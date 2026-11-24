# İlerleme defteri

Canlı durum burada tutulur; her ajan (Gemini, Claude…) çalışmadan önce okur, işi bitince günceller. Görevler ve kabul ölçütleri: `docs/YOL_HARITASI.md`.
Çatışmada satırları **birleştir**, başkasının satırını silme. Son güncelleme: 2026-11-24 (Claude, devir anı).

## Şu an aktif

| Ajan | Görev | Başlangıç | Not |
|---|---|---|---|
| — | (kimse çalışmıyor; devir bekliyor) | | İlk görev: ortam keşfi (`docs/DEVIR_GEMINI.md` §8), sonra T1.1 |

## Ortam (her ajan kendi ortamını yazar)

| Ajan / ortam | OS · GPU | Godot | Blender | `doctor` / `test` / `lint` | Godot AI | Not |
|---|---|---|---|---|---|---|
| Claude, bulut kapsülü (2026-11-24) | Ubuntu 24.04 · GPU yok (lavapipe) | 4.7.2 ✅ | 5.2.4 ✅ | 13/13 · 17/17 · temiz ✅ | canlı test 9/9 ✅ | Referans ortam |
| Gemini Orchestrator | ? | ? | ? | ? | ? | **İlk iş: doldur** |

## Durum özeti

| Aşama | Durum | Kanıt |
|---|---|---|
| A1–A4c Altyapı (kurulum, QA, eklentiler, MCP) | ✅ | `docs/ALTYAPI.md` §3 |
| A4d Godot AI | ✅ | `docs/KAYNAKLAR.md`, `tools/smoke/godot_ai_live.sh` |
| A5 Toon shader + kontur | ✅ teknik; "anime görünüyor mu" onayı ❓ | `docs/ALTYAPI.md` §4.1, `out/toon/` (yerel) |
| A6 Anime gövde tabanı (T1.1) | ⏳ | — |
| A7 Referans paketi (T1.3) | ⏳ (Gemini API anahtarı gerek) | — |
| A8/A9 Android dışa aktarma (T2.1) | ⏳ | — |
| A10 Otomatik testler | kısmen: GUT çatısı ve 17 test var (altyapı + toon) | `tools/test.sh` |
| Oyun (karakter, harita, savaş, UI, APK) | ⏳ hiçbiri yok | — |

## Karar günlüğü

| Tarih | Karar | Gerekçe | Kim |
|---|---|---|---|
| 2026-11-24 | Render yöntemi Mobile'a sabit (`tools/godot.sh --rendering-method mobile`) | Godot `--rendering-driver` ile proje ayarını yok sayıp Forward+'a düşüyordu; Mobile ile Forward+ çıktısı toon sahnesinde 518.400 pikselin 1'inde farklıydı | Claude |
| 2026-11-24 | Kontur: ters gövde (`next_pass`), post-process değil | Android'de tam ekran geçiş pahalı; ters gövde iskeletli mesh'lerde çalışır (poz altında denendi) | Claude |
| 2026-11-24 | Godot AI eklendi; telemetri kapalı; sunucuyu `tools/godot-editor.sh` başlatır | Sahibin isteği; eklentinin kendi uvx başlatması bir denemede engellendi (`identity_mismatch`) | Claude |
| 2026-11-24 | Proje Gemini 4 Carbon Orchestrator'a devredildi; `AGENTS.md` kanonik, `GEMINI.md` ince | Sahibin isteği; Antigravity ikisini de okur | Claude |
| 2026-11-24 | Hedef: Android'de olabilecek en iyi oyun (sahibin son yönergesi) | Önceki karar "önce PC, sonra Android" idi: ilişkisi **açık soru 2** | Sahip |

## Açık sorular (sahibe)

| # | Soru | Neden önemli | Durum |
|---|---|---|---|
| 1 | Orchestrator nerede çalışacak (masaüstü / CLI / Remote Agents; hangi işletim sistemi)? | Araç zinciri ve betikler (bash) buna göre uyarlanır | ❓ |
| 2 | Android öncelikli mi, yoksa önceki karar (önce PC) mi geçerli? Hedef cihaz sınıfı ve minimum Android sürümü? | Performans bütçesi, dışa aktarma, UI | ❓ |
| 3 | Gemini API anahtarı ve Google TTS erişimi var mı? | T1.3 referans görseller, seslendirme | ❓ |
| 4 | Play Console hesabı ve imza anahtarı politikası (kim, nerede saklar)? | T2.1, yayın | ❓ |
| 5 | Baş oranı: tam boy anime mi, hafif stilize mi? | T1.2, tüm karakter hattı | ❓ |
| 6 | A5 toon görünümü "anime" yargısını geçiyor mu? | T0.2 | ❓ |
| 7 | Bulut ortamının kurulum betiği "başarısız olursa oturum başlamasın" riski: yumuşatılsın mı? | Claude bulut oturumlarının güvenilirliği | ❓ (bekliyor) |
| 8 | `design/OYUN_TASARIM_PLANI.md` §5'teki Meshy/Tripo adımlarına "geçersiz" notu düşüldü: onaylıyor musun? | Orkestratör eski planı izlemesin | ❓ |

## Sorunlar / bloklar

(şimdilik yok; ilk ajan yazar)

## Notlar (ajanlar arası)

- Claude'un tüm çalışmaları `main` dalındadır; küçük commit'ler, mesajlarda neyin yapılmadığı yazılı.
- Claude bulut kapsülünde editör ilk açılışı ~8–10 dk sürdü; önbellekle ~35 sn.
