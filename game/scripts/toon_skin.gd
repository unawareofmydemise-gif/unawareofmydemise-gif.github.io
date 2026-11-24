class_name ToonSkin
extends RefCounted
## glTF'den gelen malzemeleri UOMD toon malzemesine çevirir; taban renk ve doku korunur.
##
## Kullanım: [code]ToonSkin.apply(karakter_sahnesi)[/code]
## Malzeme adının ilk parçası preset adıdır: "skin_face" -> skin, "Hair.001" -> hair, bilinmeyen -> default.
## Presetler game/data/toon_presets.json içindedir ("default" her presetin altına yayılır).
## "outline_" ile başlayan anahtarlar kontur geçişine, diğerleri yüzey geçişine gider.
##
## Sınırlar (A5 kapsamı): yalnız opak ve tek yüzlü malzeme; şeffaf/çift yüzlü olanlar uyarıyla opak çizilir.

const PRESETS_PATH := "res://data/toon_presets.json"
const SURFACE_SHADER: Shader = preload("res://shaders/toon.gdshader")
const OUTLINE_SHADER: Shader = preload("res://shaders/toon_outline.gdshader")
const DEFAULT_PRESET := "default"
const OUTLINE_PREFIX := "outline_"
## Yüzey ve kontur geçişinin birlikte kullandığı parametreler.
const SHARED_PARAMS: Array[String] = ["albedo", "albedo_texture"]

static var _presets: Dictionary = {}


## Preset sözlüğünü döndürür (ilk çağrıda dosyadan okunur).
static func presets() -> Dictionary:
	if _presets.is_empty():
		_presets = _load_presets(PRESETS_PATH)
	return _presets


## Malzeme adından preset adını bulur; bulunamazsa "default".
static func preset_name_for(material_name: String) -> String:
	var lower := material_name.to_lower()
	if presets().has(lower):
		return lower
	var head := lower
	for separator in ["_", ".", "-", " "]:
		head = head.split(separator)[0]
	return head if presets().has(head) else DEFAULT_PRESET


## Kaynak malzemeden (genelde glTF'ten gelen StandardMaterial3D) toon malzemesi üretir; kontur geçişi next_pass'tir.
## [param preset_name] boşsa malzeme adından seçilir. [param params] preset ve kaynağın üstüne yazılır
## (örn. {"albedo": Color(...)}). Kaynak yoksa (null) taban beyaz kalır.
static func make_material(
	source: Material, preset_name: String = "", params: Dictionary = {}
) -> ShaderMaterial:
	var chosen := preset_name
	if chosen.is_empty():
		chosen = preset_name_for(source.resource_name if source != null else "")
	elif not presets().has(chosen):
		push_warning("ToonSkin: bilinmeyen preset '%s', default kullanılıyor" % chosen)
		chosen = DEFAULT_PRESET

	var surface := ShaderMaterial.new()
	surface.shader = SURFACE_SHADER
	surface.resource_name = "toon_%s" % chosen
	var outline := ShaderMaterial.new()
	outline.shader = OUTLINE_SHADER
	outline.resource_name = "toon_outline_%s" % chosen
	surface.next_pass = outline

	var values := _merged_preset(chosen)
	values.merge(_source_values(source), true)
	values.merge(params, true)
	for key: String in values:
		var value: Variant = _to_shader_value(values[key])
		if key.begins_with(OUTLINE_PREFIX):
			outline.set_shader_parameter(key, value)
			continue
		surface.set_shader_parameter(key, value)
		if key in SHARED_PARAMS:
			outline.set_shader_parameter(key, value)
	return surface


## [param root] altındaki her MeshInstance3D yüzeyini toon malzemeye çevirir; çevrilen yüzey sayısını döndürür.
## Kaynak olarak mesh'in kendi malzemesi okunur (önceki bir override değil), bu yüzden tekrar çağırmak güvenlidir.
static func apply(root: Node, preset_name: String = "", params: Dictionary = {}) -> int:
	var count := 0
	# find_children yalnız alt düğümlere bakar; kök de bir MeshInstance3D olabilir (tek parçalı prop).
	var nodes: Array[Node] = root.find_children("*", "MeshInstance3D", true, false)
	if root is MeshInstance3D:
		nodes.push_front(root)
	for node in nodes:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh == null:
			continue
		for surface_index in mesh_instance.mesh.get_surface_count():
			var source := mesh_instance.mesh.surface_get_material(surface_index)
			_warn_if_unsupported(source)
			var toon := make_material(source, preset_name, params)
			mesh_instance.set_surface_override_material(surface_index, toon)
			count += 1
	return count


static func _load_presets(path: String) -> Dictionary:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("ToonSkin: preset dosyası okunamadı: %s" % path)
		return {DEFAULT_PRESET: {}}
	return parsed


static func _merged_preset(preset_name: String) -> Dictionary:
	var merged: Dictionary = presets().get(DEFAULT_PRESET, {}).duplicate()
	if preset_name != DEFAULT_PRESET:
		merged.merge(presets().get(preset_name, {}), true)
	return merged


static func _source_values(source: Material) -> Dictionary:
	var values := {}
	var base := source as BaseMaterial3D
	if base == null:
		return values
	values["albedo"] = base.albedo_color
	if base.albedo_texture != null:
		values["albedo_texture"] = base.albedo_texture
	if base.emission_enabled:
		values["emission_color"] = base.emission
		values["emission_strength"] = base.emission_energy_multiplier
	return values


static func _to_shader_value(value: Variant) -> Variant:
	if value is Array:
		var numbers: Array = value
		if numbers.size() == 3:
			return Color(numbers[0], numbers[1], numbers[2])
		if numbers.size() == 4:
			return Color(numbers[0], numbers[1], numbers[2], numbers[3])
	return value


static func _warn_if_unsupported(source: Material) -> void:
	var base := source as BaseMaterial3D
	if base == null:
		return
	if base.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
		push_warning(
			"ToonSkin: '%s' şeffaf; toon opak çizer (şeffaf desteği henüz yok)" % base.resource_name
		)
	if base.cull_mode == BaseMaterial3D.CULL_DISABLED:
		push_warning(
			"ToonSkin: '%s' çift yüzlü; toon tek yüzlü çizer (henüz yok)" % base.resource_name
		)
