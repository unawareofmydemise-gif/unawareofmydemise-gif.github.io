# Dış kaynaklar: araçlar, eklentiler, referans repolar

> Kural: Bir kaynak ancak **bu bulut ortamında denenip çalıştığı görüldükten sonra** projeye eklenir. Her satırdaki "test"
> sütunu, 2026-11-24'te gerçekten yapılan denemeyi yazar.

## 1. Projeye eklenenler

### Godot eklentileri (`game/addons/`, sürüm sabit, repoya dahil)

| Eklenti | Sürüm | Lisans | Ne için | Test |
|---|---|---|---|---|
| [GUT](https://github.com/bitwes/Gut) | 9.7.1 | MIT | Birim testleri (`tools/test.sh`) | Ekransız çalıştı; başarısız testte çıkış kodu 1 ✅ |
| [Phantom Camera](https://github.com/ramokz/phantom-camera) | 0.12 | MIT | Keşif / diyalog / savaş kameraları | Kamera hedef konuma geçti ✅ (editördeki güncelleme kontrolü kapatıldı) |
| [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) | 4.2.0 | MIT | Dallanan diyaloglar (`.dialogue` metin dosyaları) | Koşullu satırlar dahil derlendi ve okundu ✅ |
| [Godot State Charts](https://github.com/derkork/godot-statecharts) | 0.22.5 | MIT | Savaş akışı, keşif/diyalog/savaş modları | Olayla durum değişti ✅ |
| [Godot AI](https://github.com/hi-godot/godot-ai) | 4.4.2 (commit `06e6731`) | MIT | Godot **editörünü** MCP ile yönetme: sahne/düğüm/betik/malzeme/animasyon yazma, oyunu çalıştırma, **oyun ve editör ekran görüntüsü**, günlükler, test çalıştırma (46 araç). Editör eklentisi + Python sunucusu (`godot-ai==4.4.2`, `/opt/uomd-tools/godot-ai-venv`) | Editör sanal ekranda açıldı, eklenti sunucuyu `uvx` ile başlattı, sahne açıldı, oyun çalıştırıldı, oyun karesi yakalandı, günlük okundu, temiz kapandı ✅ (`tools/smoke/godot_ai_live.sh`) |

**Godot AI notları** (sahibin isteğiyle eklendi; kodu bu ortamda incelendi):
- **Telemetri varsayılan olarak AÇIK** (yerleşik bir Cloud Run uç noktasına gider; kurulum kimliği, olay, süre, platform, sürüm; kod/sahne/dosya adı yok denir).
  Biz kapalı tutuyoruz: `GODOT_AI_DISABLE_TELEMETRY=true`, editör ayarı `godot_ai/telemetry_enabled=false`, `--disable-telemetry`
  (`tools/godot-editor.sh` ve `.mcp.json` bunları verir). Ağ ilkemiz o adresi zaten kapalı tutar (savunma katmanı).
- Güncelleyici `api.github.com`'a gider (izinli adres değil; zararsız biçimde engellenir). Eklentiyi editördeki "Update" ile
  **güncelleme**: sürüm `tools/bootstrap.sh` (`GODOT_AI_VERSION`) ve `game/addons/godot_ai` birlikte, bilinçli yükseltilir; `doctor` tutarsızlığı yakalar.
- `client_manage` aracı AI istemcilerinin yapılandırma dosyalarını yazar; **kullanma** (`.mcp.json`'u biz yönetiriz).
- `project_run` varsayılan olarak bellekteki değişiklikleri sahne dosyasına kaydeder: `autosave=false` ver.
- Eklenti ekransız (`--headless`) modda MCP'yi kapatır (`GODOT_AI_ALLOW_HEADLESS` yoksa); bu yüzden editör sanal ekranda normal açılır.
  Dışa aktarma eklentisi ekransız modda da çalışır ve yardımcı otomatik yüklemesini yayın paketinden ayıklar (kodda doğrulandı; **A8'de gerçek dışa aktarmada sınanacak**).
- **Eklentinin kendi sunucu başlatması kırılgan:** 4.4.2'de `uvx` ile başlatma bir denemede `server start blocked ... identity_mismatch`
  ile engellendi (eklenti sunucuya hiç bağlanmadı; başka bir denemede sorunsuzdu). Eklentinin kendi belgesi de eşzamanlı başlatma
  yarışlarının tamamen giderilmediğini söyler. Bu yüzden `tools/godot-editor.sh` MCP sunucusunu **kendisi** başlatır (sabit sürüm,
  ağ gerekmez), editör eklentisi onu belgeli "harici sunucu" yoluyla devralır.
- Süre: taze projede ilk editör açılışı ~8–10 dk ("Updating scripts documentation", yazılımsal render + tek iş parçacığı);
  önbellek varken uçtan uca canlı test **35 sn** (editör hazır: 3 sn).
- Antigravity, Claude Code, Codex, Gemini CLI dahil 26 istemciyi destekler (kodda `clients/` altında doğrulandı); Antigravity için
  yapılandırma `~/.gemini/config/mcp_config.json` (`mcpServers`, düz `command/args/env`).

### Python araçları (`/opt/uomd-tools/venv`, `tools/bootstrap.sh` kurar)

| Araç | Sürüm | Ne için | Test |
|---|---|---|---|
| [Graphify](https://github.com/Graphify-Labs/graphify) (`graphifyy[mcp]`) | 0.9.118 | Kod bilgi grafiği, sorgu; Claude yeteneği `/graphify` | Repo 2 sn'de tarandı; sorgu çalıştı ✅ |
| GDScript çıkarıcımız (`tools/graph/gdscript_extract.py`) | — | Graphify GDScript desteklemiyor; `.gd`/`.tscn` grafiği | GDQuest RPG: 82 dosya, 438 düğüm; sorgu doğru dosyayı buldu ✅ |
| [gdtoolkit](https://github.com/Scony/godot-gdscript-toolkit) | 4.5.0 | `gdlint`, `gdformat` (kod kalitesi) | Kendi kodumuzda gerçek sorunlar yakaladı ✅ |
| [fake-bpy-module](https://github.com/nutti/fake-bpy-module) (5.2) | 20260730 | Blender API tip tanımları (doğru `bpy` kodu yazmak için okunur) | Kuruldu (yalnız `.pyi` dosyaları) ✅ |

### Blender eklentisi

| Eklenti | Sürüm | Lisans | Ne için | Test |
|---|---|---|---|---|
| [MPFB2](https://github.com/makehumancommunity/mpfb2) (MakeHuman) | 2.0.10 | Kod GPL-3, varlıklar **CC0** | Anime gövde tabanının başlangıç noktası: temiz topoloji + 53 kemikli oyun iskeleti | 0,5 sn'de gövde + iskelet; glTF → Godot'a 53 kemik, deri bağlarıyla geçti ✅ |

GPL notu: MPFB kodu yalnız Blender'da üretim sırasında çalışır; oyuna giden şey ürettiği model (CC0 varlıklardan türetilmiş)
dir. Oyun kodu MPFB'ye bağlanmaz.

## 2. Salt okunur referans repolar (git alt modülleri: `vendor/`, `tools/fetch_refs.sh` indirir)

Repoya yalnız sürüm işaretçisi girer (`.gitmodules`); içerik gerektiğinde indirilir. Kod oyuna kopyalanmaz.

| Repo | Sürüm | Lisans | Neden |
|---|---|---|---|
| [GDQuest Open RPG](https://github.com/gdquest-demos/godot-open-rpg) | 0.4.0 | MIT | Godot 4'te sıra tabanlı savaş: aktif sıra kuyruğu, savaşçı animasyonları, sıra çubuğu arayüzü |
| [godot-demo-projects](https://github.com/godotengine/godot-demo-projects) | 4.7 | MIT | Resmi örnekler: 3D, arayüz, mobil, shader |
| [MPFB2](https://github.com/makehumancommunity/mpfb2) | 2.0.10 | GPL-3/CC0 | MPFB'yi betikle kullanmak için kaynak kod ve örnekler |
| [godot-mcp-runtime](https://github.com/Erodenn/godot-mcp-runtime) | 4.0.1 | MIT | Godot MCP sunucusunun kaynağı (araçların tam davranışı `docs/tools.md`'de) |

### MCP sunucuları: Claude'un Godot ve Blender'ı yönetmesi ve **izlemesi** (`.mcp.json`)

| Sunucu | Sürüm | Ne verir | Test |
|---|---|---|---|
| [godot-mcp-runtime](https://github.com/Erodenn/godot-mcp-runtime) (npm, `/opt/uomd-tools/mcp`) | 4.0.1 · MIT | Oyunu sanal ekranda (:99) çalıştırma, **ekran görüntüsü** (boş kare tespitiyle), arayüz öğelerini okuma, girdi simülasyonu (tıklama, tuş), **çalışan oyunda canlı GDScript**, hata/çıktı kayıtları, profil (FPS, en pahalı fonksiyonlar), sahne/düğüm düzenleme (43 araç). Projeye eklenti kurmaz. | Düğmeye tıklandı, etiket değişti, ekran görüntüsünde göründü ✅ |
| **uomd-blender** (bizim, `tools/mcp/blender_mcp.py`) | — | Oturum sahnesinde `bpy` kodu çalıştırma, betik çalıştırma, sahne bilgisi (nesne, nokta, malzeme, şekil anahtarı, kemik), **çok açılı ekran görüntüsü + referansla karşılaştırma sayfası** (hızlı önizleme 4–7 sn; toon ~45 sn/açı), glTF dışa aktarma, **adım günlüğü** (`out/blender/journal/`). Arka planda süreç ya da açık port yok. | MPFB gövdesi oluşturuldu, 4 açı + referans sayfası alındı, bilerek yapılan hata yakalandı ✅ |
| [godot-ai](https://github.com/hi-godot/godot-ai) (PyPI, `/opt/uomd-tools/godot-ai-venv`) | 4.4.2 · MIT | `godot-ai attach` (stdio) → yerel sunucu (HTTP 8000) → editör eklentisi (WebSocket 9500); iki bağlantı da dönen yetki kayıtlarıyla korunur. **Editörü** yönetir (46 araç, 120+ işlem): sahne ağacı, düğüm, betik, sinyal, malzeme, kamera, animasyon, UI, test, **oyun/editör ekran görüntüsü**, günlükler. Editör açık olmalı: `tools/godot-editor.sh start`. | `tools/smoke/godot_ai_live.sh` ✅ |

## 3. Değerlendirilip eklenmeyenler

| Aday | Karar | Neden |
|---|---|---|
| [Dialogic](https://github.com/dialogic-godot/dialogic) | ❌ | GDQuest RPG içindeki sürümü Godot 4.7'de derlenmedi (ayrıştırma hataları). Dialogue Manager aynı işi görüyor ve 4.7'de çalıştı. |
| [gdUnit4](https://github.com/MikeSchulze/gdUnit4) | ⏸ | GUT ile aynı işi görüyor; iki test çatısı gereksiz. |
| [godot-vrm / MToon](https://github.com/V-Sekai/godot-vrm) | ⏸ | VRM biçimini kullanmıyoruz; toon shader'ı kendimiz yazacağız. Gerekirse shader referansı olarak okunur. |
| [Coding-Solo/godot-mcp](https://github.com/Coding-Solo/godot-mcp) | ❌ | Çalışan oyunu göremiyor (yalnız başlatma + hata çıktısı). |
| [Beckett](https://github.com/beckettlab/beckett-godot-mcp) | ⏸ | Aynı sınıf (açık editör ister); godot-ai seçildi. godot-mcp-runtime editörsüz izleme için duruyor. |
| [blender-mcp](https://github.com/ahujasid/blender-mcp) | ❌ | Arayüzlü Blender + sürekli açık port gerektiriyor; bu ortamın otomatik izin denetimi arka planda port açan dış eklentiyi reddetti. Ayrıca telemetri, ücretli servis ve çok sayıda dış entegrasyon içeriyor. Yerine kendi küçük köprümüzü yazdık. |
| MB-Lab | ⏸ | MPFB2 daha güncel, CC0 varlıklı ve betikle kullanımı doğrulandı. |
| Görselden 3D servisleri (Meshy, Tripo) | ❌ | Sahip kararı: modeller Claude tarafından elle (kodla) yapılacak. |

## 4. Sonra değerlendirilecekler

| Aday | Ne zaman |
|---|---|
| Terrain3D (GDExtension arazi) | Keşif haritaları aşamasında; mobil performansı denenmeli |
| Beehave / LimboAI (davranış ağaçları) | Düşman yapay zekâsı basit kalmazsa |
| GodotSteam | PC yayın aşamasında |
| CMU hareket yakalama verisi (BVH) | Animasyon aşamasında; lisans ve iskelete aktarma denenmeli |
