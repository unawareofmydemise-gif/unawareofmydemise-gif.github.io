shader_type spatial;
// UOMD toon yüzey shader'ı (anime cel gölgeleme). Mobile renderer, tek geçiş, opak.
//
// - İki bantlı gölge: ışık/gölge sınırı (shade_*) + isteğe bağlı çekirdek gölge (shade2_*).
// - Ana (yönlü) ışık gölge tonunu taşır; nokta/spot ışıklar yalnız ışık ekler (gölge tabanı yok).
// - Rim ışığı yalnız ışık tarafında; sert specular (saç, metal) isteğe bağlı.
// - Kontur ayrı bir geçiştir: toon_outline.gdshader, malzemenin next_pass'ine bağlanır (ToonSkin yapar).
// Parametre değerleri game/data/toon_presets.json içindedir; uniform adı değişirse oradaki anahtar da değişmeli
// (game/tests/test_toon_skin.gd bunu denetler).

render_mode cull_back, depth_draw_opaque;

group_uniforms surface;
uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec3 emission_color : source_color = vec3(0.0);
uniform float emission_strength : hint_range(0.0, 8.0) = 0.0;

group_uniforms shading;
// Gölge tarafında ana ışığın çarpanı (1 = gölge yok). Doygun, soğuk/mor tonlar anime görünümünü verir.
uniform vec3 shade_color : source_color = vec3(0.66, 0.60, 0.78);
// N·L eşiği: 0 terminatör çizgisi, büyük değer = daha çok gölge alanı.
uniform float shade_threshold : hint_range(-1.0, 1.0) = 0.12;
uniform float shade_softness : hint_range(0.0, 0.5) = 0.03;
// Çekirdek gölge (ikinci bant). shade2_color = shade_color ise tek bant görünür.
uniform vec3 shade2_color : source_color = vec3(0.66, 0.60, 0.78);
uniform float shade2_threshold : hint_range(-1.0, 1.0) = -0.45;
uniform float shade2_softness : hint_range(0.0, 0.5) = 0.05;
// Dökülen gölgelerin (ATTENUATION) keskinliği: 0 yumuşak, 1 sert.
uniform float cast_shadow_hardness : hint_range(0.0, 1.0) = 0.7;

group_uniforms rim;
uniform vec3 rim_color : source_color = vec3(1.0, 0.95, 0.90);
uniform float rim_strength : hint_range(0.0, 2.0) = 0.0;
uniform float rim_threshold : hint_range(0.0, 1.0) = 0.62;
uniform float rim_softness : hint_range(0.0, 0.5) = 0.12;

group_uniforms specular;
uniform vec3 specular_color : source_color = vec3(1.0);
uniform float specular_strength : hint_range(0.0, 2.0) = 0.0;
// Vurgu bölgesinin büyüklüğü (0 çok küçük, 1 tüm yüzey) ve kenar yumuşaklığı.
uniform float specular_size : hint_range(0.0, 1.0) = 0.06;
uniform float specular_softness : hint_range(0.0, 0.5) = 0.01;

void fragment() {
	vec4 base = albedo * texture(albedo_texture, UV);
	ALBEDO = base.rgb;
	EMISSION = emission_color * emission_strength;
	ROUGHNESS = 1.0;
	METALLIC = 0.0;
	SPECULAR = 0.0;
}

void light() {
	float ndl = dot(NORMAL, LIGHT);

	// Ana ışık: ışık / gölge / çekirdek gölge bantları.
	float lit = smoothstep(
			shade_threshold - shade_softness - 1e-4, shade_threshold + shade_softness + 1e-4, ndl);
	float core = smoothstep(
			shade2_threshold - shade2_softness - 1e-4, shade2_threshold + shade2_softness + 1e-4, ndl);

	// Dökülen gölge (kendi gölgesi dahil): ATTENUATION'ı belirli bir eşikte bantla.
	float h = mix(0.5, 0.05, cast_shadow_hardness);
	float shadow = smoothstep(0.5 - h, 0.5 + h, ATTENUATION);

	if (LIGHT_IS_DIRECTIONAL) {
		float lit_final = lit * shadow;
		vec3 tone = mix(shade2_color, shade_color, core);
		tone = mix(tone, vec3(1.0), lit_final);
		DIFFUSE_LIGHT += LIGHT_COLOR * tone / PI;

		// Rim: yalnız ışık tarafında, silüete yakın.
		float rim_f = 1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0);
		float rim = smoothstep(rim_threshold - rim_softness - 1e-4, rim_threshold + rim_softness + 1e-4, rim_f);
		SPECULAR_LIGHT += rim_color * LIGHT_COLOR * rim * rim_strength * lit_final / PI;

		// Sert specular (saç, metal).
		vec3 half_vec = normalize(LIGHT + VIEW);
		float ndh = clamp(dot(NORMAL, half_vec), 0.0, 1.0);
		float spec = smoothstep(
				1.0 - specular_size - specular_softness - 1e-4, 1.0 - specular_size + specular_softness + 1e-4, ndh);
		SPECULAR_LIGHT += specular_color * LIGHT_COLOR * spec * specular_strength * lit_final / PI;
	} else {
		// Nokta / spot: yalnız ışık tarafına, mesafe ve gölge zaten ATTENUATION'da.
		float lit_other = lit * ATTENUATION;
		DIFFUSE_LIGHT += LIGHT_COLOR * lit_other / PI;
	}
}
