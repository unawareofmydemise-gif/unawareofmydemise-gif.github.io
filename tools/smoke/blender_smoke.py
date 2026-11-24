"""Altyapı duman testi: toon malzemeli küre + kontur, EEVEE ile render, glTF dışa aktarma."""
import bpy, sys, os, time
out_dir = sys.argv[sys.argv.index("--") + 1]
os.makedirs(out_dir, exist_ok=True)
bpy.ops.wm.read_factory_settings(use_empty=True)
sc = bpy.context.scene
bpy.ops.mesh.primitive_monkey_add(); ob = bpy.context.object
bpy.ops.object.shade_smooth()
sub = ob.modifiers.new("sub", 'SUBSURF'); sub.levels = 2; sub.render_levels = 2
m = bpy.data.materials.new("toon")
nt = m.node_tree; n = nt.nodes; n.clear()
diff = n.new('ShaderNodeBsdfDiffuse'); s2r = n.new('ShaderNodeShaderToRGB'); ramp = n.new('ShaderNodeValToRGB')
ramp.color_ramp.interpolation = 'CONSTANT'; ramp.color_ramp.elements[1].position = 0.3
ramp.color_ramp.elements[0].color = (0.16, 0.08, 0.2, 1); ramp.color_ramp.elements[1].color = (0.72, 0.52, 0.78, 1)
emit = n.new('ShaderNodeEmission'); o = n.new('ShaderNodeOutputMaterial')
for a, b in ((diff, s2r), (s2r, ramp), (ramp, emit), (emit, o)):
    nt.links.new(a.outputs[0], b.inputs[0])
ob.data.materials.append(m)
ol = bpy.data.materials.new("outline"); ol.use_backface_culling = True
on = ol.node_tree.nodes; on.clear(); e = on.new('ShaderNodeEmission'); e.inputs[0].default_value = (0.05, 0.03, 0.05, 1)
oo = on.new('ShaderNodeOutputMaterial'); ol.node_tree.links.new(e.outputs[0], oo.inputs[0])
ob.data.materials.append(ol)
mod = ob.modifiers.new("outline", 'SOLIDIFY'); mod.thickness = 0.025; mod.use_flip_normals = True; mod.material_offset = 1; mod.offset = 1
bpy.ops.object.light_add(type='SUN', rotation=(0.9, 0.0, 1.9))
bpy.ops.object.camera_add(location=(0, -4.2, 0.3), rotation=(1.52, 0, 0)); sc.camera = bpy.context.object
sc.render.engine = 'BLENDER_EEVEE'; sc.render.resolution_x = sc.render.resolution_y = 512
sc.render.filepath = os.path.join(out_dir, "blender_eevee.png")
t = time.time(); bpy.ops.render.render(write_still=True)
print(f"SMOKE_BLENDER_RENDER_OK {time.time()-t:.1f}s")
ob.modifiers.remove(mod)
bpy.ops.export_scene.gltf(filepath=os.path.join(out_dir, "smoke.glb"))
print("SMOKE_BLENDER_GLTF_OK")
