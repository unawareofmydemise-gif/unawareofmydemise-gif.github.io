# Altyapı: bulut ortamı, araçlar ve üretim hattı

> Son güncelleme: 2026-11-24. Bu belge altyapının **gerçekte** ne durumda olduğunu anlatır; denenmemiş bir şey "çalışıyor"
> diye yazılmaz.

## 1. Bulut ortamı

| | |
|---|---|
| Ortam adı | **Unaware of My Demise** (kişisel). Repolar: `unawareofmydemise-gif.github.io`, `UOMD` |
| Makine | Ubuntu 24.04, 4 çekirdek, 15 GB RAM, **GPU yok** |
| Render | Yazılımsal GPU: Vulkan → lavapipe (`/opt/lavapipe`), OpenGL → llvmpipe |
| Kurulum | `tools/bootstrap.sh` (ortamın kurulum betiği bunu çalıştırır) |
| Gerekli ağ adresleri | `download.blender.org`, `downloads.godotengine.org`, `godot-releases.nbg1.your-objectstorage.com` (Godot indirmesi buraya yönleniyor), `github.com`, `release-assets.githubusercontent.com`, `generativelanguage.googleapis.com` (Gemini) + paket depoları |

### 1.1 Ortam ayarları (Settings → Environments → "Unaware of My Demise")

**İzinli adresler** (mevcut `generativelanguage.googleapis.com`'a ek olarak):

```
download.blender.org
downloads.godotengine.org
godot-releases.nbg1.your-objectstorage.com
github.com
release-assets.githubusercontent.com
```

**Kurulum betiği** (her yeni oturum başında çalışır; repo yoksa hiçbir şey yapmaz):

```bash
if [ -d unawareofmydemise-gif.github.io ]; then bash unawareofmydemise-gif.github.io/tools/bootstrap.sh; fi
```

**Durum (2026-11-24): uygulandı.** Sahip iki `update_environment` kartını onayladı; ortamda yukarıdaki 5 adres + Gemini adresi
ve kurulum betiği kayıtlı. Betik satırı bu oturumda `/home/user` dizininden aynen çalıştırıldı (75 sn, çıkış 0) ve
`tools/doctor.sh` 12/12 ✅ verdi. **Taze bir kapsülde (yeni oturum açılırken, Claude başlamadan) çalışması henüz denenmedi:**
ilk yeni oturumda `tools/doctor.sh` ile doğrulanır. Betik düşerse oturum hiç başlamayabilir; betiği değiştirmeden önce
`tools/bootstrap.sh`'ı elle çalıştırıp sına. Betik `$HOME`'a bağlıdır (MPFB `~/.config/blender`, Graphify yeteneği `~/.claude`):
kurulum betiği başka bir HOME ile çalışırsa MPFB/Graphify yeni oturumda görünmeyebilir. `tools/doctor.sh` yalnız MPFB'yi sınar;
Graphify yeteneğinin (`~/.claude/skills/graphify/SKILL.md`) varlığına bakmaz, onu ilk yeni oturumda elle kontrol et.
Gemini anahtarı o ortamda ilk ihtiyaçta (A7) istenir (`request_credential`, host: `generativelanguage.googleapis.com`).

**Godot indirme adresi değişebilir.** `downloads.godotengine.org` bir yönlendirme (302) verir. Eski notta hedef
`release-assets.githubusercontent.com` idi; 2026-11-24'te `godot-releases.nbg1.your-objectstorage.com` oldu ve ağ ilkesi
403 verdi (`agent proxy: no rule or network setting allows this host`): bootstrap Godot indirmesinde düştü. Aynı belirti
tekrarlarsa önce zinciri izle, sonra yeni adresi `update_environment` ile ekle:

```bash
curl -sIL 'https://downloads.godotengine.org/?version=4.7.2&flavor=stable&slug=linux.x86_64.zip&platform=linux.64' | grep -iE '^(HTTP|location)'
```

`github.com` (git okuması) ve `release-assets.githubusercontent.com` izin listesine eklenmeden önce de erişilebiliyordu
(platform varsayılanı olabilir); belgelenmiş gereksinim olduğu için yine de listede tutuluyor.

## 2. Araçlar (sabitlenmiş sürümler)

| Araç | Sürüm | Doğrulama |
|---|---|---|
| Blender | **5.2.4 LTS** | SHA-256 `tools/bootstrap.sh` içinde |
| Godot | **4.7.2 stable** (standart, .NET'siz) | SHA-256 `tools/bootstrap.sh` içinde |
| Python + Pillow | sistem | QA sayfaları |
| Graphify · gdtoolkit · fake-bpy-module | 0.9.118 · 4.5.0 · 5.2 | `/opt/uomd-tools/venv` |
| MPFB2 (Blender eklentisi) | 2.0.10 | `~/.config/blender/5.2/extensions/user_default/mpfb` |
| Godot eklentileri | bkz. `docs/KAYNAKLAR.md` | `game/addons/` (repoda) |

Sürüm yükseltmek bilinçli bir karardır: `bootstrap.sh` içindeki sürüm ve SHA-256 birlikte değişir, `tools/doctor.sh` geçmeli.

## 3. Doğrulanmış yetenekler (2026-11-24, `tools/doctor.sh`)

| Yetenek | Durum | Not |
|---|---|---|
| Blender ekransız EEVEE render (toon + kontur) | ✅ | 512² ~16 sn, başlangıç dahil ~17 sn (2026-11-24, yeni ortam; ilk soğuk koşu 28 sn). Önceki ortamda ~7 sn ölçülmüştü: bu ortam ~2× yavaş, QA döngüsü bütçesinde hesaba kat. `--gpu-backend vulkan` + lavapipe |
| Blender Cycles (CPU) | ✅ | Gerektiğinde; toon için EEVEE kullanılır |
| Blender → glTF (.glb) | ✅ | |
| Godot ekransız içe aktarma | ✅ | `godot --headless --import` |
| Godot render + ekran görüntüsü | ✅ | Xvfb + Vulkan (llvmpipe), **Mobile** yöntemi. `tools/godot.sh` `--rendering-method mobile` verir: yalnız `--rendering-driver vulkan` verilirse Godot proje ayarını yok sayıp **Forward+'a düşer** (2026-11-24'te görüldü; eski doctor bunu fark etmiyordu, artık `method=mobile` şart). MCP'nin kullandığı `godot-display.sh` zaten Mobile'a düşüyor |
| Standart açı render'ları + karşılaştırma sayfası | ✅ | `art_src/lib/uomd_render.py`, `tools/qa/sheet.py` |
| Godot dışa aktarma (Windows/Linux/Web/Android) | ⏳ | Export template'leri ve Android SDK henüz kurulmadı (bkz. §7) |
| Blender toon malzemesinin Godot'a taşınması | ❌ (beklenen) | Toon görünüm Godot shader'ında yapılacak |
| MPFB2 insan gövdesi + 53 kemikli oyun iskeleti → Godot | ✅ | 0,5 sn; deri bağları korunuyor |
| Godot birim testleri (GUT) ekransız | ✅ | `tools/test.sh` |
| Kod bilgi grafiği (Graphify + GDScript) | ✅ | `tools/graph.sh`, `graphify query` |
| GDScript lint/format | ✅ | `tools/lint.sh` = gdlint + `gdformat --check`; `game/addons/` hariç (gdformat'ın dışlama seçeneği yok; `gdformat --check game` eklentilerde 204 dosyada düşer) |
| Toon shader + kontur (Mobile), düz / toon karşılaştırma sayfası | ✅ | `tools/qa/toon_stage.sh`; bkz. §4.1. Mum / kül / nötr ışık, doku ve emisyon yolları dahil |
| Godot AI: editörü MCP ile yönetme (sahne, düğüm, betik, oyun karesi, günlük) | ✅ | `tools/godot-editor.sh`, `tools/mcp-call.sh`, `tools/smoke/godot_ai_live.sh`; bkz. §3.1 ve `docs/KAYNAKLAR.md` |
| Sıfırdan kurulum süresi | ✅ | ~82 sn (`tools/bootstrap.sh`; 2026-11-24 yeni kapsül: apt ~7 sn + indirme/pip/npm ~75 sn). `tools/doctor.sh` ~80 sn |

Yeni bulut ortamındaki doğrulama (2026-11-24): `tools/doctor.sh` **13/13 ✅** (12 + Godot AI sürüm denetimi); `tools/test.sh` 17/17 (A5 sonrası); `tools/graph.sh` 470 düğüm /
501 kenar (4 sn), `graphify query` yanıt verdi; `tools/lint.sh` temiz.

## 3.1 İzleme: Claude Godot ve Blender'da ne olduğunu nasıl görür

| | Godot (`godot` MCP) | Blender (`uomd-blender` MCP) |
|---|---|---|
| Görüntü | `take_screenshot` (çalışan oyun), `render_movie` (kare dizisi, hareket var mı) | `blender_screenshot` (4 açı + referans sayfası; `toon=True` ile EEVEE) |
| Durum | `get_ui_elements`, `get_scene_tree`, `get_node_properties`, `run_script` (canlı GDScript) | `blender_scene_info` |
| Kayıt | `get_debug_output` (print + hatalar, çöküşten sonra da) | `blender_journal` + `out/blender/journal/journal.md` (her adım, kodu ve görüntüsüyle) |
| Etkileşim | `simulate_input` (tıklama, tuş, eylem) | `blender_execute`, `blender_run_script` |
| Performans | `profile_project` (FPS, pahalı fonksiyonlar, çizim çağrıları) | — |

Sanal ekran: `:99` (Xvfb, 1920×1080), gerektiğinde `tools/xdisplay.sh` başlatır. MCP sunucuları oturum başında
`.mcp.json`'dan yüklenir; Claude Code ilk seferde sunucular için onay ister. Godot sunucusu oyunu her başlatmadan önce
onay isteyebilir (elicitation); `.mcp.json`'da `GODOT_MCP_DISABLE_ELICITATION` **bilerek açık bırakılmadı**.

MCP sunucuları yalnız **oturum başında** yüklenir. İkili dosyalar oturum açıldıktan sonra kurulduysa (yeni kapsülün ilk
oturumu) sunucular o oturumda yüklenmez ve yeni oturum gerekir; Claude'un araç listesinde `godot` / `uomd-blender` araçları
yoksa nedeni budur. 2026-11-24'te sunucular elle sınandı: `godot` 43 araç, `uomd-blender` 7 araç (MCP el sıkışması +
`tools/doctor.sh` içindeki 8 kontrol); yani yeni oturumda yüklenmemeleri için bir engel yok.

**Godot AI** (`godot-ai`, üçüncü Godot köprüsü): **editörü** yönetir. `tools/godot-editor.sh start` editörü sanal ekranda açar
(eklenti MCP sunucusunu kendisi başlatır), `wait` hazır olana kadar bekler, `stop` kapatır. Araçlar `.mcp.json`'daki `godot-ai`
girdisiyle ya da (sunucu oturuma yüklü değilse) `tools/mcp-call.sh godot-ai <araç> '<json>'` ile çağrılır; `--list` araçları,
`--schema <araç>` parametreleri gösterir. Tipik döngü: `scene_open` → `project_run(mode="current", autosave=false)` →
`editor_screenshot(source="game")` → `logs_read(source="game"|"editor")` → `project_manage(op="stop")`. Karşılaştırma: godot-mcp-runtime
oyunu editörsüz çalıştırır ve izler; Godot AI editörün kendisini (sahne ağacı, düğüm özellikleri, betik, malzeme, test) yönetir.
Kurallar ve riskler: `CLAUDE.md` (İzleme) ve `docs/KAYNAKLAR.md` (Godot AI notları).

## 4. Üretim hattı ve kalite kontrol döngüsü

```
 Referans (art/portraits, art bible, gerekirse Gemini ile üretilen yan/arka görünüm)
        │
        ▼
 art_src/<tür>/<id>/build.py  ──(tools/blender.sh)──▶  Blender sahnesi
        │                                              │
        │                     ┌────────────────────────┤
        ▼                     ▼                        ▼
  render_views() → out/<id>/{front,three_quarter,side,back}.png      export → game/assets/<tür>/<id>.glb
        │                                                                 │
        ▼                                                                 ▼
  tools/qa/sheet.py  referans + render'lar  ──▶  Claude sayfaya bakar   tools/godot.sh ile oyunda render
        │                                         │
        └──── fark var ──▶ build.py düzeltilir ◀──┘
```

Kurallar:
- Her model betiği `--render` ile QA görüntülerini, `--export` ile `.glb`'yi üretir (betik kalıbı `art_src/README.md`).
- QA sayfasına bakılmadan model "tamam" sayılmaz. Bakılan sayfanın yolu commit mesajına veya ilgili nota yazılır.
- Render'lar `out/` altında kalır (git'e girmez); onaylanan son görüntüler gerekirse `docs/` veya ilgili klasöre küçük
  boyutta eklenir.

### 4.1 Toon malzeme (A5, 2026-11-24)

Oyundaki son görüntü Godot'ta bu malzemeden gelir (Blender malzemeleri yalnız önizleme).

| Dosya | Ne |
|---|---|
| `game/shaders/toon.gdshader` | Yüzey: 2 bantlı cel gölge (+ isteğe bağlı çekirdek gölge), ışık tarafında rim, sert specular, emisyon. Ana yönlü ışık gölge tonunu taşır; nokta/spot ışıklar yalnız ışık ekler. |
| `game/shaders/toon_outline.gdshader` | Kontur: ters gövde (`next_pass`). Kalınlık 1080p pikselinde sabittir (mesafeden ve çözünürlükten bağımsız); renk = sabit renk ile koyulaştırılmış taban rengin karışımı. |
| `game/data/toon_presets.json` | Presetler: `default`, `skin`, `cloth`, `hair`, `metal`. `default` hepsinin altına yayılır; anahtarlar shader uniform adlarıdır (`outline_` ile başlayanlar kontura gider). Yeni görünüm = yeni preset, kod değişmez. |
| `game/scripts/toon_skin.gd` (`ToonSkin`) | `ToonSkin.apply(kök, preset?, parametreler?)` glTF'ten gelen malzemeleri toon'a çevirir; taban renk, doku ve emisyon korunur. Preset malzeme adının ilk parçasından seçilir (`skin_face` → skin, bilinmeyen → default). |
| `game/scenes/dev/toon_stage.tscn`, `tools/qa/toon_stage.sh` | Test sahnesi: 5 preset küresi + doku + emisyon + MPFB test gövdesi; mum / kül / nötr ışık. Düz ve toon yan yana sayfa üretir; Mobile yöntemini ve shader/betik hatalarını denetler. Gövde git'e girmez (`game/assets/dev/`), betik her seferinde boru hattından üretir. |

- **Blender → Godot sözleşmesi:** Blender'da malzemeleri `skin_*`, `hair_*`, `cloth_*`, `metal_*` diye adlandır (bkz. `art_src/README.md`). Taban renk ve doku glTF'e gider, geri kalanı presetten gelir.
- **Doğrulama:** ekransız GUT testleri `game/tests/test_toon_skin.gd` (14 test). Shader derlemesi ekransız sürücüde sınanamaz; onu `tools/qa/toon_stage.sh` sınar. Mobile ile Forward+ çıktısı karşılaştırıldı: 518.400 pikselin yalnız 1'i farklı.
- **Görsel kontrol:** mum, kül ve nötr ışıkta tam sahne; 1080p baş ve el yakın çekimi (kontur çatlağı yok); iskelet pozu altında (üst kollar x:70 ve z:70, `POSE=x:70 FOCUS=body tools/qa/toon_stage.sh`) kontur deforme silüeti doğru izliyor, hayalet kontur yok.
- **Bilinen sınırlar:** yalnız opak ve tek yüzlü malzeme (şeffaf / çift yüzlü uyarıyla opak çizilir); kontur bölünmüş (sert) normalli yüzeylerde kenarlardan ayrılır; yüz ve saç için özel gölge yok (dikey kesit işi); normal map yok; yalnız statik üst kol pozu denendi, hareketli animasyonda kontur titremesi **denenmedi**; **performans ölçülmedi** (GPU yok; kontur her mesh için çizim çağrısını ikiye katlar).
- **Onay durumu:** teknik olarak tamam. "Anime görünüyor mu" yargısı henüz danışmana ya da sahibe sorulmadı.

## 5. Karakterleri "elle" (kodla) modelleme yaklaşımı

Hazır yapay zekâ 3D servisleri kullanılmıyor; her model Claude tarafından Blender Python ile adım adım kurulur. Bunun için
kendi "VRoid benzeri" sistemimizi kodla kuruyoruz:

1. **Anime gövde tabanı** (kadın / erkek): temiz topoloji, standart insansı iskelet, oran parametreleri (boy, baş oranı,
   omuz, bel, bacak), yüz ifadesi şekil anahtarları. **Bir kez, çok dikkatle** yapılır; her karakter bunu kullanır.
2. **Yüz:** anime stilinde basit yüz geometrisi + göz/kaş/ağız **dokuları** (SVG ile çizilip PNG'ye çevrilir). İfadeler doku
   değişimi ve şekil anahtarlarıyla yapılır.
3. **Saç:** eğri (Bezier) tabanlı saç tutamları; kalınlık ve uç incelmesi parametrik.
4. **Kıyafet:** gövdeden türetilen katmanlar (kabuk) + ayrı parçalar (pelerin, başlık, kemer, zırh plakaları).
5. **Aksesuar ve silah:** ayrı prop betikleri (Fadyme'nin çanı, Mahmut'un kalkanı…).
6. **Animasyon:** iskelet ortak olduğu için animasyonlar (bekleme, yürüme, saldırı…) **bir kez** yazılır, tüm karakterlerde
   çalışır.

Risk: yüz ve saç estetiği en zor kısım. Bu yüzden gövde tabanından sonraki ilk iş tek karakterle (Fadyme) dikey kesit testi.

## 6. Git stratejisi

- Kaynaklar metin: modeller Python betiği, sahneler `.tscn`, veriler JSON. Diff'lenebilir ve küçük.
- `.glb` gibi ikili dışa aktarmalar yalnız **onaylanmış** sürümlerde `game/assets/` altına commit edilir.
- Git LFS şimdilik kullanılmıyor (ücretsiz kota düşük). Repo boyutu 2 GB'ı geçerse yeniden değerlendirilecek.
- Çalışma doğrudan `main` dalında.

## 7. Altyapı yol haritası

| # | İş | Durum |
|---|---|---|
| A1 | Bulut ortamı, Blender + Godot kurulumu, sağlık kontrolü | ✅ |
| A2 | Repo yapısı, `CLAUDE.md`, Godot proje iskeleti | ✅ |
| A3 | QA render modülü ve karşılaştırma sayfası | ✅ |
| A4 | Ortamın kurulum betiği ve ağ adresleri (yeni oturumlar otomatik kurulsun) | ✅ uygulandı 2026-11-24; taze kapsülde ilk yeni oturumla doğrulanacak (§1.1) |
| A4b | Eklentiler, Graphify, lint, test çatısı, MPFB2, referans repolar (`docs/KAYNAKLAR.md`) | ✅ |
| A4c | MCP izleme: Godot (godot-mcp-runtime) + Blender (kendi köprümüz), referanslar git alt modülü | ✅ |
| A4d | Godot AI: Godot editörünü MCP ile yönetme (sahibin isteği; kod incelendi, telemetri kapalı, canlı test) | ✅ |
| A5 | Godot toon shader + kontur (karakterler için temel malzeme) | ✅ teknik olarak (§4.1); "anime görünüyor mu" onayı bekliyor |
| A6 | Anime gövde tabanı v1 + standart iskelet | ⏳ |
| A7 | Referans paketi: her ana karakter için ön/yan/arka referans (Gemini) | ⏳ |
| A8 | Godot export template'leri; tarayıcıda oynanabilir önizleme (Web) | ⏳ |
| A9 | Android SDK + imzalama ile Android derlemesi | ⏳ (PC sürümünden sonra) |
| A10 | Otomatik testler (GDScript birim testleri, savaş hesapları) | ⏳ (GUT çatısı ve 17 test var; savaş hesapları yok) |

Görev kuyruğu ve doğrulanabilir kabul ölçütleri: [`YOL_HARITASI.md`](YOL_HARITASI.md) (A5–A10 oradaki T-numaralarına çevrildi). Canlı durum: [`ILERLEME.md`](ILERLEME.md).
