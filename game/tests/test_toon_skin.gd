extends GutTest
## ToonSkin testleri: preset dosyası, malzeme dönüşümü, shader/preset tutarlılığı.
## Not: shader'ın derlenmesi ekransız çalışmada sınanamaz (boş render sürücüsü); onu tools/qa/toon_stage.sh sınar.

const SURFACE_SHADER_PATH := "res://shaders/toon.gdshader"
const OUTLINE_SHADER_PATH := "res://shaders/toon_outline.gdshader"
const REQUIRED_PRESETS := ["default", "skin", "cloth", "hair", "metal"]


func _declared_uniforms(path: String) -> Array[String]:
	var regex := RegEx.create_from_string("(?m)^\\s*uniform\\s+\\w+\\s+(\\w+)")
	var names: Array[String] = []
	for found in regex.search_all(FileAccess.get_file_as_string(path)):
		names.append(found.get_string(1))
	return names


func _sphere_with_material(material: Material) -> MeshInstance3D:
	var mesh := SphereMesh.new()
	mesh.material = material
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	return instance


func test_required_presets_exist() -> void:
	for preset_name in REQUIRED_PRESETS:
		assert_true(ToonSkin.presets().has(preset_name), "preset yok: %s" % preset_name)


func test_preset_keys_are_declared_uniforms() -> void:
	var surface := _declared_uniforms(SURFACE_SHADER_PATH)
	var outline := _declared_uniforms(OUTLINE_SHADER_PATH)
	assert_gt(surface.size(), 5, "yüzey shader'ında uniform bulunamadı")
	assert_gt(outline.size(), 3, "kontur shader'ında uniform bulunamadı")
	for preset_name in ToonSkin.presets():
		for key: String in ToonSkin.presets()[preset_name]:
			var declared := outline if key.begins_with("outline_") else surface
			assert_true(key in declared, "%s.%s shader'da tanımlı değil" % [preset_name, key])


func test_surface_and_outline_share_albedo_uniforms() -> void:
	for shared in ToonSkin.SHARED_PARAMS:
		assert_true(shared in _declared_uniforms(SURFACE_SHADER_PATH), "yüzeyde yok: %s" % shared)
		assert_true(shared in _declared_uniforms(OUTLINE_SHADER_PATH), "konturda yok: %s" % shared)


func test_preset_name_from_material_name() -> void:
	assert_eq(ToonSkin.preset_name_for("skin"), "skin")
	assert_eq(ToonSkin.preset_name_for("Skin.001"), "skin")
	assert_eq(ToonSkin.preset_name_for("HAIR_ash"), "hair")
	assert_eq(ToonSkin.preset_name_for("metal-silver"), "metal")
	assert_eq(ToonSkin.preset_name_for("bell_silver"), "default")
	assert_eq(ToonSkin.preset_name_for(""), "default")


func test_make_material_keeps_albedo_and_texture() -> void:
	var source := StandardMaterial3D.new()
	source.resource_name = "skin_face"
	source.albedo_color = Color(0.2, 0.4, 0.6)
	var texture := ImageTexture.create_from_image(Image.create(4, 4, false, Image.FORMAT_RGBA8))
	source.albedo_texture = texture
	var toon := ToonSkin.make_material(source)
	assert_eq(toon.shader.resource_path, SURFACE_SHADER_PATH)
	assert_eq(toon.resource_name, "toon_skin")
	assert_eq(toon.get_shader_parameter("albedo"), source.albedo_color)
	assert_eq(toon.get_shader_parameter("albedo_texture"), texture)
	var outline := toon.next_pass as ShaderMaterial
	assert_not_null(outline, "kontur geçişi (next_pass) yok")
	assert_eq(outline.shader.resource_path, OUTLINE_SHADER_PATH)
	assert_eq(outline.get_shader_parameter("albedo"), source.albedo_color)
	assert_eq(outline.get_shader_parameter("albedo_texture"), texture)


func test_make_material_without_source_uses_default() -> void:
	var toon := ToonSkin.make_material(null)
	assert_eq(toon.resource_name, "toon_default")
	assert_not_null(toon.next_pass)


func test_outline_params_go_only_to_outline_pass() -> void:
	var toon := ToonSkin.make_material(null, "skin")
	var outline := toon.next_pass as ShaderMaterial
	assert_null(toon.get_shader_parameter("outline_width"), "kontur parametresi yüzeye gitmiş")
	assert_not_null(outline.get_shader_parameter("outline_width"))
	assert_not_null(toon.get_shader_parameter("shade_color"))
	assert_null(outline.get_shader_parameter("shade_color"), "yüzey parametresi konturda")


func test_params_override_source_and_preset() -> void:
	var source := StandardMaterial3D.new()
	source.albedo_color = Color.RED
	var toon := ToonSkin.make_material(source, "skin", {"albedo": Color.BLUE, "rim_strength": 0.9})
	assert_eq(toon.get_shader_parameter("albedo"), Color.BLUE)
	assert_eq(toon.get_shader_parameter("rim_strength"), 0.9)


func test_unknown_preset_falls_back_to_default() -> void:
	var toon := ToonSkin.make_material(null, "yok_boyle_bir_preset")
	assert_eq(toon.resource_name, "toon_default")
	assert_push_warning_count(1)


func test_emission_is_carried_over() -> void:
	var source := StandardMaterial3D.new()
	source.emission_enabled = true
	source.emission = Color(1.0, 0.5, 0.1)
	source.emission_energy_multiplier = 2.0
	var toon := ToonSkin.make_material(source)
	assert_eq(toon.get_shader_parameter("emission_color"), Color(1.0, 0.5, 0.1))
	assert_eq(toon.get_shader_parameter("emission_strength"), 2.0)


func test_apply_converts_child_surfaces() -> void:
	var root := Node3D.new()
	var child := _sphere_with_material(StandardMaterial3D.new())
	root.add_child(child)
	add_child_autofree(root)
	assert_eq(ToonSkin.apply(root), 1)
	assert_eq(child.get_surface_override_material(0).shader.resource_path, SURFACE_SHADER_PATH)


func test_apply_converts_root_mesh_instance() -> void:
	# Tek parçalı prop'ta glTF kökü MeshInstance3D'dir; find_children kökü atlar (gerçek bir hataydı).
	var instance := _sphere_with_material(StandardMaterial3D.new())
	add_child_autofree(instance)
	assert_eq(ToonSkin.apply(instance), 1)
	assert_true(instance.get_surface_override_material(0) is ShaderMaterial)


func test_apply_is_idempotent_and_keeps_source_albedo() -> void:
	var source := StandardMaterial3D.new()
	source.albedo_color = Color(0.1, 0.7, 0.3)
	var instance := _sphere_with_material(source)
	add_child_autofree(instance)
	ToonSkin.apply(instance)
	ToonSkin.apply(instance)
	var toon := instance.get_surface_override_material(0) as ShaderMaterial
	assert_eq(
		toon.get_shader_parameter("albedo"), source.albedo_color, "ikinci apply rengi kaybetti"
	)


func test_apply_forced_preset_and_params() -> void:
	var instance := _sphere_with_material(null)
	add_child_autofree(instance)
	ToonSkin.apply(instance, "hair", {"albedo": Color(0.9, 0.8, 0.5)})
	var toon := instance.get_surface_override_material(0) as ShaderMaterial
	assert_eq(toon.resource_name, "toon_hair")
	assert_eq(toon.get_shader_parameter("albedo"), Color(0.9, 0.8, 0.5))
