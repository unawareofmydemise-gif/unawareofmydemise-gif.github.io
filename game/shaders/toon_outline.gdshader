shader_type spatial;
// UOMD toon kontur geçişi: ters gövde (inverted hull). Yüzey malzemesinin next_pass'ine bağlanır.
//
// Köşeler ekran uzayında normal yönünde itilir; kalınlık, mesafeden bağımsız ve çözünürlükten bağımsız
// (1080p'de piksel cinsinden). Arka yüzler çizilir, böylece yalnız silüet kenarı görünür.
// Kontur rengi sabit renk ile "taban rengin koyulaştırılmış hâli" arasında karıştırılır
// (cilt konturu sıcak kahve, saç konturu külli koyu olur; saf siyah çizgi sert durur).
// Sınır: sert (bölünmüş) normalli yüzeylerde kontur kenarlarda ayrılır; karakter gövdeleri düzgün normallidir.

render_mode cull_front, unshaded, depth_draw_opaque;

group_uniforms surface;
uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, hint_default_white, filter_linear_mipmap, repeat_enable;

group_uniforms outline;
uniform vec3 outline_color : source_color = vec3(0.10, 0.07, 0.10);
uniform float outline_width : hint_range(0.0, 8.0) = 1.6;
uniform float outline_albedo_blend : hint_range(0.0, 1.0) = 0.55;
uniform float outline_darkness : hint_range(0.0, 1.0) = 0.28;

void vertex() {
	vec4 clip = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 view_normal = normalize(MODELVIEW_NORMAL_MATRIX * NORMAL);
	vec2 dir = (PROJECTION_MATRIX * vec4(view_normal, 0.0)).xy;
	dir = dir / max(length(dir), 1e-5);
	float aspect = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
	// NDC'de 2 birim = ekran yüksekliği; kalınlık 1080p pikseline göre.
	vec2 offset = dir * vec2(1.0 / aspect, 1.0) * (outline_width * 2.0 / 1080.0) * clip.w;
	clip.xy += offset;
	POSITION = clip;
}

void fragment() {
	vec3 base = albedo.rgb * texture(albedo_texture, UV).rgb;
	ALBEDO = mix(outline_color, base * outline_darkness, outline_albedo_blend);
}
