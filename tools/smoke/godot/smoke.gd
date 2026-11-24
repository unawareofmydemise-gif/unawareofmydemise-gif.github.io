extends Node3D


# Duman testi: Blender'dan gelen smoke.glb'yi yükler, render alır, PNG kaydeder, çıkar.
func _ready() -> void:
	var out_dir := OS.get_environment("SMOKE_OUT")
	var model := load("res://smoke.glb") as PackedScene
	add_child(model.instantiate())
	var cam := Camera3D.new()
	cam.position = Vector3(0, 0, 3.4)
	add_child(cam)
	cam.current = true
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-35, 35, 0)
	add_child(sun)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.85, 0.82, 0.78)
	add_child(env)
	for i in 6:
		await get_tree().process_frame
	var img := get_viewport().get_texture().get_image()
	img.save_png(out_dir.path_join("godot_render.png"))
	print("SMOKE_GODOT_RENDER_OK ", img.get_size(), " ", RenderingServer.get_video_adapter_name())
	get_tree().quit()
