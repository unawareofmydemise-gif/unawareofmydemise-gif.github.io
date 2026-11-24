#!/usr/bin/env python3
"""Duman testi: .mcp.json'daki MCP sunucularını Claude'un kullanacağı biçimde başlatır ve izleme araçlarını dener.

godot:        smoke projesini çalıştır → ekran görüntüsü (boş değil mi?) → arayüz → canlı GDScript → durdur
uomd-blender: geçici oturum → küp ekle → sahne bilgisi → hızlı ekran görüntüsü
Kullanım: /opt/uomd-tools/venv/bin/python tools/smoke/mcp_smoke.py <godot_projesi> <çıktı_klasörü>
"""
import asyncio
import json
import os
import sys
from pathlib import Path

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

REPO = Path(__file__).resolve().parents[2]
proj, out = sys.argv[1], Path(sys.argv[2])
cfg = json.loads((REPO / ".mcp.json").read_text())["mcpServers"]
ok = True


def server(name, extra_env=None):
    c = cfg[name]
    env = {"PATH": os.environ["PATH"], "HOME": os.environ.get("HOME", "/root"), **c.get("env", {}), **(extra_env or {})}
    return StdioServerParameters(command=c["command"], args=c.get("args", []), env=env)


def text(res):
    return "".join(c.text for c in res.content if c.type == "text")


def check(label, cond, detail=""):
    global ok
    print(("SMOKE_MCP_OK " if cond else "SMOKE_MCP_FAIL ") + label + (f" ({detail})" if detail else ""))
    ok &= bool(cond)


async def godot():
    async with stdio_client(server("godot", {"GODOT_MCP_DISABLE_ELICITATION": "true"})) as (r, w):
        async with ClientSession(r, w) as s:
            await s.initialize()
            check("godot araçları", len((await s.list_tools()).tools) >= 40)
            res = await s.call_tool("run_project", {"projectPath": proj})
            check("godot run_project", not res.is_error, text(res)[:120])
            await asyncio.sleep(2)
            raw = text(await s.call_tool("take_screenshot", {"projectPath": proj}))
            shot = json.loads(raw) if raw.startswith("{") else {"error": raw[:200]}
            check("godot ekran görüntüsü", shot.get("stats", {}).get("likelyBlank") is False, shot.get("path", shot.get("error", "")))
            ui = text(await s.call_tool("get_ui_elements", {"projectPath": proj}))
            check("godot arayüz okuma", "MCP canlı" in ui)
            script = "extends RefCounted\nfunc execute(t: SceneTree) -> Variant:\n\treturn t.current_scene.get_child_count()\n"
            res = await s.call_tool("run_script", {"projectPath": proj, "script": script})
            check("godot canlı GDScript", not res.is_error and '"result"' in text(res))
            await s.call_tool("stop_project", {"projectPath": proj})


async def blender():
    async with stdio_client(server("uomd-blender", {"UOMD_BLENDER_WORK": str(out / "blender")})) as (r, w):
        async with ClientSession(r, w) as s:
            await s.initialize()
            await s.call_tool("blender_reset", {})
            res = await s.call_tool("blender_execute", {"code": "bpy.ops.mesh.primitive_monkey_add()"})
            check("blender kod", text(res).startswith("OK"), text(res)[:80])
            info = json.loads(text(await s.call_tool("blender_scene_info", {})))
            check("blender sahne bilgisi", info and info["object_count"] == 1)
            res = await s.call_tool("blender_screenshot", {"views": ["front", "side"]})
            check("blender ekran görüntüsü", any(c.type == "image" for c in res.content))


asyncio.run(godot())
asyncio.run(blender())
sys.exit(0 if ok else 1)
