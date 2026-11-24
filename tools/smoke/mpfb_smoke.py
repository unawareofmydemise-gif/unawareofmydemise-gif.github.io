"""Duman testi: MPFB2 ile insan gövdesi + oyun motoru iskeleti üretir ve glTF'e aktarır."""
import os
import sys
import bpy

out_dir = sys.argv[sys.argv.index("--") + 1]
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.preferences.addon_enable(module="bl_ext.user_default.mpfb")
from bl_ext.user_default.mpfb.services.humanservice import HumanService  # noqa: E402
from bl_ext.user_default.mpfb.services.targetservice import TargetService  # noqa: E402

macro = TargetService.get_default_macro_info_dict()
macro.update({"gender": 0.0, "age": 0.45, "proportions": 0.9})
body = HumanService.create_human(macro_detail_dict=macro, scale=0.1)
rig = HumanService.add_builtin_rig(body, "game_engine")
print(f"SMOKE_MPFB_OK verts={len(body.data.vertices)} bones={len(rig.data.bones)} height={body.dimensions.z:.2f}m")
bpy.ops.export_scene.gltf(filepath=os.path.join(out_dir, "mpfb_body.glb"), export_apply=True)
print("SMOKE_MPFB_GLTF_OK")
