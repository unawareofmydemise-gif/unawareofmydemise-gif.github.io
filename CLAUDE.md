# Unaware of My Demise — Claude çalışma kuralları

Bu repo, *Unaware of My Demise* oyununun Godot 4 ile sıfırdan 3D yeniden yapımıdır. Tüm işler bulut ortamında Claude
tarafından yapılır (yürütücü: Sonnet 5.5; danışman: Opus 5.5 / Fable 5.2). Sahip Türkçe konuşur: **sahibe her zaman
Türkçe yaz.** Kod, dosya ve değişken adları İngilizce; yorumlar ve belgeler Türkçe olabilir.

## Önce oku
| Belge | Ne zaman |
|---|---|
| `design/OYUN_BILGI_DOKUMANI.md` | Hikâye, karakter, dünya ile ilgili her işte. **Kanon budur**; çelişen bir şey uydurma. Part II sırlarını çözme. |
| `design/OYUN_TASARIM_PLANI.md` | Oynanış, savaş, UI/UX kararları. |
| `docs/ALTYAPI.md` | Araçlar, üretim hattı, kalite kontrol döngüsü. |
| `docs/KAYNAKLAR.md` | Hangi eklenti/araç neden var, neden yok. Yeni bir şey eklemeden önce oku. |
| `design/art_bible/` | Karakter ve mekân görsel tarifleri. |

## Çalışma düzeni
- **Doğrudan `main` dalında çalış** (sahibin talimatı). Küçük, anlamlı commit'ler; her adım bitince `git push origin main`.
- Adım adım ilerle: bir seferde tek iş. Oyunu "bitirmeye" koşma; her adımı doğrula, belgeye işle.
- Bitmiş bir adımı `docs/ALTYAPI.md` veya ilgili belgede güncelle. Yaptığını ve **yapmadığını** açıkça raporla.

## Repo haritası
| Klasör | İçerik | Kural |
|---|---|---|
| `art/`, `audio/`, `story/`, `data/`, `fonts/`, `localization/` | Eski oyundan gelen **kaynak** içerik | **Salt okunur.** Değiştirme, silme. |
| `design/` | Tasarım belgeleri ve art bible | Kararlar buraya yazılır |
| `art_src/` | 3D modellerin **kaynağı**: Blender Python betikleri | Modelin tek gerçek kaynağı betiktir |
| `game/` | Godot 4.7 projesi | `res://` = `game/` |
| `tools/` | Kurulum, sarmalayıcılar, kalite kontrol araçları | |
| `docs/` | Altyapı ve süreç belgeleri | |
| `out/` | Yerel render / QA çıktıları | git'e girmez |

## Komutlar
```bash
bash tools/bootstrap.sh          # Blender 5.2.4 LTS + Godot 4.7.2 + sistem kütüphaneleri (idempotent)
tools/doctor.sh                  # altyapı sağlık kontrolü; oturum başında bir kez çalıştır
tools/blender.sh <betik.py> -- <argümanlar>   # Blender ekransız, EEVEE çalışır
tools/godot.sh --path game ...   # Godot sanal ekranla; ekran görüntüsü alınabilir
godot --headless --path game --import         # yalnız içe aktarma / betik (render yok)
python3 tools/qa/sheet.py out/sheet.png <referans> <render>...   # karşılaştırma sayfası
tools/test.sh                    # Godot birim testleri (GUT), ekransız; başarısızsa çıkış kodu 1
gdlint game && gdformat --check game   # GDScript kalite kontrolü (ayarlar: gdlintrc)
tools/graph.sh                   # kod bilgi grafiği (Graphify + GDScript çıkarıcı) → graphify-out/graph.json
graphify query "<soru>"          # grafikte soru sor (kodu tanımadan önce bunu dene)
tools/fetch_refs.sh [ad]         # referans alt modüllerini vendor/ altına indir (godot-open-rpg, mpfb2, godot-demo-projects, godot-mcp-runtime)
```

## 3D üretim kuralları
1. Model **Blender Python betiğiyle** üretilir (`art_src/...`). `.glb` çıktısını elle düzenleme; betiği düzelt, yeniden üret.
2. Her model değişikliğinden sonra **kalite kontrol döngüsü** (bkz. `docs/ALTYAPI.md` §4): standart açılardan render →
   referans çizimle karşılaştırma sayfası → sayfaya **bakarak** değerlendir. Bakmadan "oldu" deme.
3. Oyundaki son görüntü **Godot toon shader**'ından gelir. Blender malzemeleri yalnız önizleme içindir; glTF'e taban renk,
   doku, UV, iskelet, şekil anahtarları (shape key) ve animasyon gider.
4. Ölçek: 1 birim = 1 metre, ayak tabanı z=0'da. Karakterler Blender'da **-Y yönüne bakar** (ön görünüm); glTF'te bu
   +Z olur. Godot'ta model önü +Z'dir (`look_at(..., true)` ile `use_model_front`).
5. Ortak kod `art_src/lib/` altında. Karakterler ortak bir anime gövde tabanını paylaşır (aynı iskelet = paylaşılan
   animasyonlar).

## İzleme (MCP) — yaptığını gör
- Godot: `godot` MCP sunucusu (`run_project` → `take_screenshot` / `get_ui_elements` / `get_debug_output` → `stop_project`).
- Blender: `uomd-blender` MCP sunucusu (`blender_execute` / `blender_run_script` → `blender_screenshot` → `blender_journal`).
- **Her görsel değişiklikten sonra ekran görüntüsü al ve bak.** Hızlı önizleme varsayılan; son görünüm için `toon=True`.
- MCP yoksa (örn. sunucu onaylanmadıysa) aynı işi `tools/blender.sh`, `tools/godot.sh` ve `tools/qa/sheet.py` ile yap.
- Bitince oyunu `stop_project` ile kapat; arkada çalışan süreç bırakma.

## Eklentiler ve araçlar
- Godot eklentileri `game/addons/` altında, sürüm sabit: GUT, Phantom Camera, Dialogue Manager, Godot State Charts.
  **Diyalog için Dialogue Manager** kullanılır (Dialogic 4.7'de derlenmiyor). Eklenti dosyalarını değiştirme.
- Yeni eklenti/araç: önce bu ortamda dene, çalıştığını gör, sonra `docs/KAYNAKLAR.md`'ye gerekçesiyle yaz.
- Blender API'sinden emin değilsen tahmin etme: `/opt/uomd-tools/venv/lib/python3.13/site-packages/bpy-stubs/` içindeki
  tip tanımlarını oku.
- İnsan gövdesi tabanı MPFB2 ile üretilir (`bl_ext.user_default.mpfb`); örnek kullanım `tools/smoke/mpfb_smoke.py`.

## Godot kuralları
- Sürüm 4.7.2, **Mobile** render yöntemi (PC ve Android aynı görünür).
- İçerik **veri odaklı**: karakter, yetenek, banner, diyalog `game/data/` altında; yeni içerik mümkün olduğunca kod
  değişikliği gerektirmesin (canlı oyun).
- UI hem 16:9 (PC) hem 20:9 (telefon) çözünürlükte, fare + klavye + oyun kolu + dokunmatikle çalışmalı; ikisinde de ekran
  görüntüsüyle doğrula.
- Kaynak içerik (`art/`, `audio/`) oyuna doğrudan bağlanmaz; gerekenler işlenip `game/assets/` altına kopyalanır.
- Yeni oyun sistemi = yeni testler (`game/tests/`). Commit'ten önce `tools/test.sh` ve `gdlint` geçmeli.

## Danışmana (advisor) ne zaman sor
- Mimari kararlar (yeni sistem, veri şeması, klasör yapısı) ve birden çok dosyayı etkileyen yeniden düzenlemelerden önce.
- Görsel yön ve kalite yargısı gereken anlarda (bir model "anime" görünüyor mu, oranlar doğru mu).
- Aynı sorunu iki denemede çözemediğinde.
- Basit, mekanik işler için danışma.

## Yapma
- Gizli bilgi (API anahtarı, şifre) commit etme; anahtarlar ortamın ağ gizli bilgilerinden gelir.
- 50 MB'tan büyük dosya commit etme. Üretilebilen çıktıları (render, ara dosya) commit etme.
- Godot editörünü veya Blender arayüzünü açmaya çalışma; her şey komut satırından.
- Eski oyunun kodunu (UOMD reposu) bu repoya taşıma.
