"""Kalite kontrol render'ları: bir modeli standart açılardan EEVEE ile render eder.

Kullanım (Blender betiği içinden):
    import sys; sys.path.insert(0, "art_src/lib")
    from uomd_render import render_views
    render_views("out/fadyme", height=1.6)

Kameralar ortografiktir: oranları referans çizimle karşılaştırmak için perspektif bozulması olmaz.
"""
import math
import os
import bpy

VIEWS = {  # ad: (kameranın modele göre yatay açısı, derece)
    "front": 0,
    "three_quarter": 35,
    "side": 90,
    "back": 180,
}


def _setup_scene(resolution, bg, engine="BLENDER_EEVEE"):
    sc = bpy.context.scene
    sc.render.engine = engine
    if engine == "BLENDER_WORKBENCH":  # hızlı önizleme: düz gölge + kavite + kontur
        sh = sc.display.shading
        sh.light = "STUDIO"; sh.color_type = "MATERIAL"; sh.show_cavity = True; sh.show_object_outline = True
        sc.display.render_aa = "8"
    sc.render.resolution_x, sc.render.resolution_y = resolution
    sc.render.film_transparent = False
    if sc.world is None:
        sc.world = bpy.data.worlds.new("qa_world")
    sc.world.color = bg
    sc.view_settings.view_transform = "Standard"  # toon renkleri kaydırmasın
    return sc


def _ensure_light():
    """Sahnede ışık yoksa ana ışık + arkadan dolgu ışığı ekler (her açı okunur olsun)."""
    if any(o.type == "LIGHT" for o in bpy.context.scene.objects):
        return
    for name, energy, rot_z in (("qa_key", 3.0, 30), ("qa_fill", 1.5, 210)):
        data = bpy.data.lights.new(name, "SUN"); data.energy = energy
        sun = bpy.data.objects.new(name, data)
        sun.rotation_euler = (math.radians(50), 0, math.radians(rot_z))
        bpy.context.scene.collection.objects.link(sun)


def render_views(out_dir, height=1.7, center_z=None, views=None,
                 resolution=(768, 1152), bg=(0.82, 0.80, 0.77), margin=1.1, engine="BLENDER_EEVEE"):
    """Sahnedeki modeli verilen açılardan render eder; PNG yollarını döndürür.

    height:   modelin yaklaşık boyu (metre). Kadraj buna göre ayarlanır.
    center_z: kadraj merkezinin yüksekliği (varsayılan height/2).
    engine:   "BLENDER_EEVEE" (toon/son görünüm) veya "BLENDER_WORKBENCH" (hızlı önizleme).
    """
    os.makedirs(out_dir, exist_ok=True)
    sc = _setup_scene(resolution, bg, engine)
    _ensure_light()
    center_z = height / 2 if center_z is None else center_z
    cam_data = bpy.data.cameras.new("qa_cam"); cam_data.type = "ORTHO"
    aspect = resolution[0] / resolution[1]
    cam_data.ortho_scale = height * margin * max(1.0, 1 / aspect)
    cam = bpy.data.objects.new("qa_cam", cam_data)
    sc.collection.objects.link(cam); sc.camera = cam
    paths = []
    for name, angle in (views or VIEWS).items():
        a = math.radians(angle); dist = 10.0
        cam.location = (dist * math.sin(a), -dist * math.cos(a), center_z)
        cam.rotation_euler = (math.radians(90), 0, a)
        sc.render.filepath = os.path.join(out_dir, f"{name}.png")
        bpy.ops.render.render(write_still=True)
        paths.append(sc.render.filepath)
    bpy.data.objects.remove(cam)
    return paths
