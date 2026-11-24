"""Blender içinde çalışır (blender -b). blender_mcp.py her araç çağrısında bunu başlatır.

Argüman: -- <istek.json>. İstek: {"action", "session", "result", ...}. Sonuç JSON'u "result" yoluna yazılır.
Oturum dosyası (session .blend) kalıcıdır: değiştiren eylemlerden sonra kaydedilir, bir sonraki çağrıda açılır.
"""
import contextlib
import io
import json
import os
import runpy
import sys
import traceback

import bpy
from mathutils import Vector

req = json.load(open(sys.argv[sys.argv.index("--") + 1]))
session = req["session"]
repo = req["repo"]
sys.path.insert(0, os.path.join(repo, "art_src", "lib"))
out = {"ok": True}


def load_session():
    if os.path.exists(session) and not req.get("reset"):
        bpy.ops.wm.open_mainfile(filepath=session)
    else:
        bpy.ops.wm.read_factory_settings(use_empty=True)


def save_session():
    os.makedirs(os.path.dirname(session), exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=session, compress=True)


def scene_info():
    objs = []
    for o in bpy.context.scene.objects:
        d = {"name": o.name, "type": o.type, "location": [round(v, 3) for v in o.location],
             "dimensions": [round(v, 3) for v in o.dimensions], "parent": o.parent.name if o.parent else None}
        if o.type == "MESH":
            d.update(verts=len(o.data.vertices), faces=len(o.data.polygons),
                     materials=[m.name for m in o.data.materials if m],
                     modifiers=[m.type for m in o.modifiers],
                     shape_keys=[k.name for k in o.data.shape_keys.key_blocks] if o.data.shape_keys else [])
        elif o.type == "ARMATURE":
            d.update(bones=len(o.data.bones), root_bones=[b.name for b in o.data.bones if not b.parent][:5])
        objs.append(d)
    meshes = [o for o in bpy.context.scene.objects if o.type == "MESH" and o.visible_get()]
    bounds = None
    if meshes:
        pts = [o.matrix_world @ Vector(c) for o in meshes for c in o.bound_box]
        lo = [min(p[i] for p in pts) for i in range(3)]; hi = [max(p[i] for p in pts) for i in range(3)]
        bounds = {"min": [round(v, 3) for v in lo], "max": [round(v, 3) for v in hi]}
    return {"objects": objs, "object_count": len(objs), "bounds": bounds,
            "total_verts": sum(o.get("verts", 0) for o in objs)}


def run_captured(fn):
    buf = io.StringIO()
    try:
        with contextlib.redirect_stdout(buf), contextlib.redirect_stderr(buf):
            fn()
        out["stdout"] = buf.getvalue()[-20000:]
    except Exception:
        out.update(ok=False, stdout=buf.getvalue()[-20000:], error=traceback.format_exc()[-8000:])


action = req["action"]
if action == "reset":
    bpy.ops.wm.read_factory_settings(use_empty=True); save_session(); out["info"] = scene_info()
elif action == "execute":
    load_session()
    run_captured(lambda: exec(compile(req["code"], "<mcp-code>", "exec"), {"bpy": bpy, "__name__": "__mcp__"}))
    if out["ok"] and req.get("save", True):
        save_session()
    out["info"] = scene_info()
elif action == "script":
    load_session()
    sys.argv = [req["path"]] + ["--"] + req.get("args", [])
    run_captured(lambda: runpy.run_path(req["path"], run_name="__main__"))
    if out["ok"]:
        save_session()
    out["info"] = scene_info()
elif action == "info":
    load_session(); out["info"] = scene_info()
elif action == "render":
    from uomd_render import render_views, VIEWS
    load_session()
    info = scene_info(); b = info["bounds"]
    if not b:
        out.update(ok=False, error="Sahnede görünür mesh yok.")
    else:
        height = max(b["max"][2] - b["min"][2], 0.2); center = (b["max"][2] + b["min"][2]) / 2
        width = max(b["max"][0] - b["min"][0], b["max"][1] - b["min"][1])
        views = {k: VIEWS[k] for k in req.get("views", list(VIEWS))}
        res = tuple(req.get("resolution", (640, 960)))
        run_captured(lambda: out.__setitem__("paths", render_views(
            req["out_dir"], height=max(height, width * res[1] / res[0]), center_z=center, views=views, resolution=res,
            engine=req.get("engine", "BLENDER_WORKBENCH"))))
        out["info"] = info
elif action == "export":
    load_session()
    os.makedirs(os.path.dirname(req["path"]) or ".", exist_ok=True)
    run_captured(lambda: bpy.ops.export_scene.gltf(filepath=req["path"], export_apply=req.get("apply_modifiers", True)))
    out["path"] = req["path"]; out["info"] = scene_info()
else:
    out.update(ok=False, error=f"bilinmeyen eylem: {action}")

json.dump(out, open(req["result"], "w"))
