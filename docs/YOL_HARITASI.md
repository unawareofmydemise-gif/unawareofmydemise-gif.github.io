# Yol haritası ve görev kuyruğu

Tek kuyruk burasıdır; durumu `docs/ILERLEME.md` tutar. Altyapı adımları (`docs/ALTYAPI.md` §7 A1–A10) ve oyun aşamaları (`design/OYUN_TASARIM_PLANI.md` §8)
burada **doğrulanabilir görevlere** çevrildi. Durum: ✅ tamam · ⏳ sırada · ❓ sahip kararı bekliyor · ⛔ bloklu.

**Bitti tanımı (her görev için):** `tools/test.sh` ve `tools/lint.sh` yeşil · görevin Doğrulama komutları geçti · görsel iş için ekran görüntüsü / karşılaştırma sayfası üretildi ve **bakıldı**
(yolu commit mesajında) · ilgili belge güncel · `docs/ILERLEME.md` güncel · gizli bilgi yok · yapılmayan şey açıkça yazıldı.

**Kuzey yıldızı** ("en iyi Android oyunu" ölçülemez; bu ölçütler ölçülebilir): (1) APK Android'de açılır ve 60 sn kesintisiz oynanır; (2) öğretici + Bölüm 1 baştan sona oynanabilir;
(3) 4 karakterle sıra tabanlı savaş (temel/yetenek/ultimate, element + kırılma, Çan Sayacı); (4) toon görünüm kalitesi sahip onaylı; (5) testler yeşil; (6) FPS hedefi tutuyor (hedef cihaz sınıfını sahip belirler).

## M0 — Altyapı

| ID | Görev | Kabul | Doğrulama | Durum |
|---|---|---|---|---|
| A1–A5, A4d | Kurulum hattı, repo, QA, eklentiler, MCP, toon shader, Godot AI | `docs/ALTYAPI.md` §3–4.1 | `tools/doctor.sh` 13/13 | ✅ |
| T0.1 | Taşınabilir ortam: Dockerfile / devcontainer (`tools/bootstrap.sh` çalıştırır) | Konteynerde `tools/doctor.sh` 13/13; Windows/macOS'ta aynı araç zinciri | `docker build` + `doctor` | ⏳ (Docker bu kapsülde yoktu: denenmedi) |
| T0.2 | A5 görsel onayı: "toon anime görünüyor mu" | Onay (ya da düzeltme listesi) karar günlüğünde | `tools/qa/toon_stage.sh` sayfaları | ❓ |

## M1 — Karakter hattı

| ID | Görev | Kabul | Doğrulama | Durum |
|---|---|---|---|---|
| T1.1 (A6) | Anime gövde tabanı v1 + standart iskelet | (1) `art_src/lib/body_base.py` kadın ve erkek taban üretir. (2) İskelet Godot `SkeletonProfileHumanoid` BoneMap'ine eşlenir; GUT: kemik sayısı + eşleme. (3) Oran parametreleri (boy, baş oranı, omuz, bel, bacak) çalışır; 4 açı QA sayfası bakıldı. (4) Poz testi (omuz, dirsek, diz, boyun) Godot render sayfasında temiz. (5) A5 toon ile render. (6) Poligon/kemik bütçesi tahmini `docs/PERFORMANS.md`'de | `tools/blender.sh art_src/lib/body_base.py -- --render --export` · `tools/test.sh` · `tools/lint.sh` · `tools/qa/toon_stage.sh` · `POSE=x:70 FOCUS=body tools/qa/toon_stage.sh` | ⏳ |
| T1.2 | Baş oranı karar kapısı | ~7 baş (tam boy anime) ve ~5 baş (hafif stilize) yan yana sayfa; karar `design/OYUN_TASARIM_PLANI.md` §9.1 | QA sayfası | ❓ |
| T1.3 (A7) | Referans paketi: Fadyme ve Mahmut için ön / yan / arka (Gemini API) | `design/refs/<id>/{front,side,back}.png` + istem ve model adı kaydı; `design/art_bible/character_locks.md` ile karşılaştırma sayfası; kilitler bozulmaz | Karşılaştırma sayfası | ⏳ (Gemini API anahtarı: sahip) |
| T1.4 | Dikey kesit: Fadyme + Mahmut (yüz dokusu, saç eğrileri, kıyafet katmanları, aksesuarlar) | Godot'ta 3 ışıkta yan yana render sayfası; 5 ifade (nötr, gülümseme, üzgün, kızgın, şaşkın); `heroes/fadyme.md` ve `character_locks.md` ile madde madde karşılaştırma notu; sahip onayı | `tools/qa/toon_stage.sh` + kendi sayfa betiği | ⏳ |
| T1.5 | Ortak animasyonlar (bekleme, yürüme, koşu, temel saldırı) | İki karakterde aynı animasyon kütüphanesi oynar; poz altında kontur temiz; testler yeşil | `tools/test.sh` + ekran görüntüsü | ⏳ |

T1.1 notu: başlangıç noktası MPFB2 gövdesi (53 kemikli `game_engine` iskeleti, `tools/smoke/mpfb_smoke.py`, 19.158 köşe, malzemesiz; lisans CC0 varlıklar). Seçenekler:
(a) MPFB gövdesini kodla "anime"ye dönüştürmek (büyük baş, ince uzuv, sade el ve ayak; şekil anahtarlarıyla), (b) sıfırdan parametrik gövde.
İki küçük denemeyle karar ver; ölçüt: temiz topoloji, hazır iskelet ve ağırlık, anime silueti, Android poligon bütçesi. Gerekçeyi karar günlüğüne yaz.

## M2 — Android yürüyen iskelet (erken risk azaltma)

| ID | Görev | Kabul | Doğrulama | Durum |
|---|---|---|---|---|
| T2.1 (A8/A9) | Godot Android dışa aktarma | Export şablonları + Android SDK + JDK kurulu; `game/export_presets.cfg` (anahtar ve şifre **commit edilmez**); toon test sahnesi APK olur ve emülatörde açılır; ekran görüntüsü; yayın paketinde `_mcp_game_helper` **yok** | Dışa aktarma komutu + ekran görüntüsü + paket içeriği kontrolü | ⏳ (denenmedi) |
| T2.2 | Performans bütçesi | Hedef cihaz sınıfı (sahip); emülatör/cihazda FPS ölçümü; kontur geçişi maliyeti; karakter başına poligon / kemik / draw call bütçesi → `docs/PERFORMANS.md` | Ölçüm çıktısı | ⏳ |
| T2.3 | Dokunmatik UI iskeleti | 16:9 ve 20:9; güvenli alan; hedefler ≥ 48 px; iki çözünürlükte ekran görüntüsü | `tools/godot.sh` + sayfa | ⏳ |
| T2.4 | Web dışa aktarma (isteğe bağlı hızlı önizleme) | Tarayıcıda açılır | Dışa aktarma + ekran görüntüsü | ⏳ |

## M3 — Keşif prototipi

| ID | Görev | Kabul | Durum |
|---|---|---|---|
| T3.1 | Kül Ormanı greybox: yürüme, Phantom Camera kamerası, etkileşim | Klavye, oyun kolu ve dokunmatikle yürünür; GUT + ekran görüntüleri | ⏳ |
| T3.2 | Diyalog: Dialogue Manager + 2D portre (198 hazır) + 3D sahne | Bölüm 1 açılış mektubu sahnesi oynanır | ⏳ |
| T3.3 | Haritada düşman, ilk vuruş avantajı, savaşa geçiş (State Charts) | Geçiş testleri yeşil | ⏳ |

## M4 — Savaş prototipi

| ID | Görev | Kabul | Durum |
|---|---|---|---|
| T4.1 | Hıza göre sıra çizelgesi, 4 kişilik parti, temel / yetenek / ultimate, Yemin Puanı (veri odaklı, `game/data/`) | Hasar ve sıra hesapları GUT testli | ⏳ |
| T4.2 | 6 element + kırılma, durum etkileri, **Çan Sayacı** (boss'larda merkezî) | Kırılma ve sayaç testleri | ⏳ |
| T4.3 | Denge test aracı: otomatik savaş simülasyonu (komut satırı) + 25 kahramanın `data/` verisinin yeni şemaya taşınması | Simülasyon raporu; aşırı güçlü/zayıf birim listesi | ⏳ |
| T4.4 | Savaş UI ve VFX (shader + parçacık, kodla) | 16:9 ve 20:9 ekran görüntüleri | ⏳ |

## M5+ (özet; M3–M4 bitince ayrıntılandır)

- **M5 Dikey dilim:** öğretici + Bölüm 1 eksiksiz (hikâye, 4–5 karakter, kamp, yemin defteri = çağırma ekranı, gacha oranı/garanti şeffaflığı: `design/gacha_ui_principles.md` §8).
- **M6 Part I:** 7 bölüm, 25 kahraman, tüm boss'lar. **M7 Canlı oyun mimarisi:** sunucu kararı, `.pck` yamaları, analitik. **M8 Yayın:** Play Console (hesap sahibin).
- Sahibe ait kararlar: hedef cihaz sınıfı, minimum Android sürümü, para kazanma ayrıntıları, yayın hesabı.
