extends Node3D
## Toon shader test sahnesi (geliştirme aracı; oyunda kullanılmaz). tools/qa/toon_stage.sh çalıştırır.
## Argümanlar `godot ... -- --anahtar=değer` biçiminde verilir:
##   --light=candle|ash|neutral          ışık düzeni (sıcak mum + yan ışık / soğuk kül ve sis / nötr stüdyo)
##   --mode=toon|flat                    toon malzeme ya da kaynak (düz) malzeme
##   --focus=all|spheres|body|head|hand  kadraj
##   --pose=x:60                         üst kolları yerel eksende döndürür (iskelet altında kontur/normal testi)
##   --shot=<png yolu>                   ekran görüntüsünü kaydedip çıkar

const BODY_PATH := "res://assets/dev/mpfb_body.glb"
const BODY_X := 2.5
const SKIN_ALBEDO := Color(0.96, 0.80, 0.70)
const SPHERE_RADIUS := 0.25
const LIGHT_SETUPS := {
	"candle":
	{
		"sun_color": Color(1.0, 0.72, 0.44),
		"sun_energy": 1.3,
		"ambient_color": Color(0.30, 0.36, 0.55),
		"ambient_energy": 0.8,
		"background": Color(0.09, 0.08, 0.11),
		"fog": false,
		"omni_color": Color(0.55, 0.70, 1.0),
		"omni_energy": 1.5,
	},
	"ash":
	{
		"sun_color": Color(0.80, 0.86, 1.0),
		"sun_energy": 1.0,
		"ambient_color": Color(0.58, 0.60, 0.66),
		"ambient_energy": 0.7,
		"background": Color(0.36, 0.38, 0.42),
		"fog": true,
		"omni_energy": 0.0,
	},
	"neutral":
	{
		"sun_color": Color(1.0, 1.0, 1.0),
		"sun_energy": 1.0,
		"ambient_color": Color(0.55, 0.55, 0.60),
		"ambient_energy": 0.6,
		"background": Color(0.82, 0.80, 0.77),
		"fog": false,
		"omni_energy": 0.0,
	},
}
const FOCUS_SETUPS := {
	"all": {"pos": Vector3(0.0, 1.15, 6.8), "target": Vector3(0.0, 0.8, 0.0)},
	"spheres": {"pos": Vector3(-0.74, 0.7, 4.6), "target": Vector3(-0.74, 0.3, 0.0)},
	"body": {"pos": Vector3(BODY_X, 1.0, 4.4), "target": Vector3(BODY_X, 0.78, 0.0)},
	"head": {"pos": Vector3(BODY_X, 1.45, 1.5), "target": Vector3(BODY_X, 1.43, 0.0)},
	"hand": {"pos": Vector3(BODY_X + 0.55, 0.86, 1.0), "target": Vector3(BODY_X + 0.55, 0.86, 0.0)},
}
## Sıra: hazır presetler, sonra doku yolu ("checker") ve emisyon yolu ("glow").
const SPHERE_SPECS := [
	{"preset": "default", "albedo": Color(0.85, 0.84, 0.86)},
	{"preset": "skin", "albedo": SKIN_ALBEDO},
	{"preset": "cloth", "albedo": Color(0.42, 0.20, 0.50)},
	{"preset": "hair", "albedo": Color(0.86, 0.80, 0.62)},
	{"preset": "metal", "albedo": Color(0.78, 0.80, 0.86)},
	{"preset": "", "kind": "checker"},
	{"preset": "", "kind": "glow"},
]

var _toon := true


func _ready() -> void:
	var args := _parse_args()
	var setup: Dictionary = LIGHT_SETUPS.get(args.get("light", "neutral"), LIGHT_SETUPS["neutral"])
	_toon = args.get("mode", "toon") == "toon"
	_build_environment(setup)
	_build_lights(setup)
	_build_floor()
	_build_spheres()
	_build_body(args.get("pose", ""))
	_build_camera(FOCUS_SETUPS.get(args.get("focus", "all"), FOCUS_SETUPS["all"]))
	if args.has("shot"):
		await _capture(args["shot"])


func _parse_args() -> Dictionary:
	var parsed := {}
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--") and "=" in arg:
			var parts := arg.substr(2).split("=", true, 1)
			parsed[parts[0]] = parts[1]
	return parsed


func _build_environment(setup: Dictionary) -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = setup["background"]
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = setup["ambient_color"]
	env.ambient_light_energy = setup["ambient_energy"]
	env.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	if setup["fog"]:
		env.fog_enabled = true
		env.fog_light_color = setup["background"]
		env.fog_density = 0.035
	var world := WorldEnvironment.new()
	world.environment = env
	add_child(world)


func _build_lights(setup: Dictionary) -> void:
	var sun := DirectionalLight3D.new()
	sun.light_color = setup["sun_color"]
	sun.light_energy = setup["sun_energy"]
	sun.shadow_enabled = true
	sun.shadow_bias = 0.03
	sun.shadow_normal_bias = 1.0
	sun.directional_shadow_max_distance = 20.0
	add_child(sun)
	# Ön-sol-yukarıdan, sahnenin ortasına doğru.
	sun.look_at_from_position(Vector3(-2.5, 3.2, 3.5), Vector3(0.0, 0.6, 0.0))
	if setup["omni_energy"] > 0.0:
		var omni := OmniLight3D.new()
		omni.light_color = setup["omni_color"]
		omni.light_energy = setup["omni_energy"]
		omni.omni_range = 9.0
		omni.shadow_enabled = true
		omni.position = Vector3(3.6, 1.6, 2.4)
		add_child(omni)


func _build_floor() -> void:
	var floor_mesh := PlaneMesh.new()
	floor_mesh.size = Vector2(80.0, 60.0)
	var floor_instance := MeshInstance3D.new()
	floor_instance.mesh = floor_mesh
	add_child(floor_instance)
	if _toon:
		var material := ToonSkin.make_material(null, "cloth", {"albedo": Color(0.62, 0.58, 0.64)})
		material.next_pass = null  # zeminin konturu yok
		floor_instance.material_override = material
	else:
		floor_instance.material_override = _flat_material(Color(0.62, 0.58, 0.64))


func _build_spheres() -> void:
	for i in SPHERE_SPECS.size():
		var spec: Dictionary = SPHERE_SPECS[i]
		var sphere_mesh := SphereMesh.new()
		sphere_mesh.radius = SPHERE_RADIUS
		sphere_mesh.height = SPHERE_RADIUS * 2.0
		var instance := MeshInstance3D.new()
		instance.mesh = sphere_mesh
		instance.position = Vector3(-2.6 + 0.62 * i, SPHERE_RADIUS, 0.0)
		add_child(instance)
		var kind: String = spec.get("kind", "")
		if kind.is_empty():
			if _toon:
				instance.material_override = ToonSkin.make_material(
					null, spec["preset"], {"albedo": spec["albedo"]}
				)
			else:
				instance.material_override = _flat_material(spec["albedo"])
			continue
		# Doku / emisyon: glTF'in izlediği yol. Kaynak StandardMaterial3D mesh'te durur, ToonSkin.apply çevirir.
		sphere_mesh.material = _source_material(kind)
		if _toon:
			ToonSkin.apply(instance)


func _source_material(kind: String) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	if kind == "checker":
		material.resource_name = "cloth_checker"
		material.albedo_texture = _checker_texture()
	else:
		material.resource_name = "glow"
		material.albedo_color = Color(1.0, 0.55, 0.2)
		material.emission_enabled = true
		material.emission = Color(1.0, 0.45, 0.1)
		material.emission_energy_multiplier = 1.4
	return material


func _checker_texture() -> ImageTexture:
	var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	for y in 64:
		for x in 64:
			var on := ((x >> 3) + (y >> 3)) % 2 == 0
			image.set_pixel(x, y, Color(0.86, 0.25, 0.45) if on else Color(0.98, 0.9, 0.78))
	return ImageTexture.create_from_image(image)


func _flat_material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	return material


func _build_body(pose: String) -> void:
	if not ResourceLoader.exists(BODY_PATH):
		push_warning("Test gövdesi yok: %s (tools/qa/toon_stage.sh üretir)" % BODY_PATH)
		return
	var body := (load(BODY_PATH) as PackedScene).instantiate() as Node3D
	body.position = Vector3(BODY_X, 0.0, 0.0)
	add_child(body)
	if not pose.is_empty():
		_apply_pose(body, pose)
	if _toon:
		ToonSkin.apply(body, "skin", {"albedo": SKIN_ALBEDO})
	else:
		for node in body.find_children("*", "MeshInstance3D", true, false):
			(node as MeshInstance3D).material_override = _flat_material(SKIN_ALBEDO)


## "x:60" -> iki üst kolu yerel X ekseninde 60° döndürür (sağ kol ters yönde).
func _apply_pose(body: Node, spec: String) -> void:
	var parts := spec.split(":")
	var axes := {"x": Vector3.RIGHT, "y": Vector3.UP, "z": Vector3.BACK}
	var axis: Vector3 = axes.get(parts[0], Vector3.RIGHT)
	var degrees := float(parts[1]) if parts.size() > 1 else 45.0
	for node in body.find_children("*", "Skeleton3D", true, false):
		var skeleton := node as Skeleton3D
		for bone_name in ["upperarm_l", "upperarm_r"]:
			var index := skeleton.find_bone(bone_name)
			if index < 0:
				continue
			var side := -1.0 if bone_name.ends_with("_r") else 1.0
			var rest_rotation := skeleton.get_bone_rest(index).basis.get_rotation_quaternion()
			var delta := Quaternion(axis, deg_to_rad(degrees * side))
			skeleton.set_bone_pose_rotation(index, rest_rotation * delta)


func _build_camera(focus: Dictionary) -> void:
	var camera := Camera3D.new()
	camera.fov = 30.0
	add_child(camera)
	camera.look_at_from_position(focus["pos"], focus["target"])
	camera.current = true


func _capture(path: String) -> void:
	for i in 10:
		await get_tree().process_frame
	var image := get_viewport().get_texture().get_image()
	image.save_png(path)
	print(
		"TOON_STAGE_OK ",
		image.get_size(),
		" method=",
		RenderingServer.get_current_rendering_method(),
		" ",
		RenderingServer.get_video_adapter_name(),
		" ",
		path
	)
	get_tree().quit()
