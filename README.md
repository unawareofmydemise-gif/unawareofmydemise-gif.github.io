# Unaware of My Demise — Asset Arşivi

Bu repo, oyunu bir oyun motoruyla sıfırdan (3D) yeniden kurmak için **yalnızca içerik** barındırır:
görseller, sesler, hikâye, tasarım dokümanları ve eski oyunun veri tabloları. Kod yoktur.

Kaynak: `unawareofmydemise-gif/UOMD` reposu (eski Python motorlu 2D gacha sürümü), 2026-11-24 itibarıyla.

## Klasörler

| Klasör | İçerik | Dosya |
|---|---|---|
| `art/portraits/<karakter>/` | Tam boy, önden karakter çizimleri; her karakter için 3–7 ifade (`warm`, `angry`, `sad`…), 768×1152 webp | 198 |
| `art/chibi/<karakter>/` | `full.png` chibi görünüm + `parts/` (kafa, gövde, kol, bacak parçaları ve `pivots.json` eklem noktaları) | 52 karakter/düşman |
| `art/backgrounds/` | 75 mekân arka planı (1920×1080), başlık ekranı, çağırma sunağı | 78 |
| `art/banners/` | Gacha banner'ları (2592×1080) | 17 |
| `art/ui/`, `art/icons/` | Arayüz kiti (butonlar, kart çerçeveleri, element ikonları, ultimate cut-in bantları, `theme.json`), ikonlar | 113 |
| `art/fx/` | Vuruş, iyileştirme, çağırma efekt görselleri | 22 |
| `art/branding/`, `art/store/` | Logo, uygulama ikonu, mağaza görselleri | 8 |
| `audio/music/` | 11 müzik (ana tema, savaş, boss temaları, bölüm müzikleri) | 11 |
| `audio/sfx/` | Ses efektleri | 11 |
| `audio/voice/` | Japonca seslendirme (Gemini TTS), ~59 dk: hikâye sahneleri, öğretici, karakter savaş repliklerinin tamamı | 666 |
| `fonts/` | 7 yazı tipi (OFL lisanslı) | 13 |
| `story/` | Ana hikâye, karakter hikâyeleri, etkinlikler, seslendirme senaryoları (`09_VN_Scripts/Voice_Lines/`), ~300 bin kelime | 436 |
| `localization/` | `tr`, `en`, `ja` arayüz metinleri | 3 |
| `data/` | Eski oyunun içerik verileri: birimler, bölümler, karşılaşmalar, denge, etkinlik takvimi, mağaza metinleri | 405 |
| `design/` | Art bible (24 kahraman, 27 düşman, mekânlar, kıyafet rehberi), tasarım sistemi, gacha UI ilkeleri, çizim istek listesi | 34 |

## Karakterler

**Oynanabilir kahramanlar (24):** brin_alder, cassian_thorne, clem_marr, corbin_locke, dorian_kesk, fadyme,
garrick_cinder, hana_birch, iona_mist, jori_flint, kera_voss, marek_vane, mirel_quill, nara_vell, nixie_vale,
odelia_pike, pippa_bell, rikka_ember, rowan_reed, sable_wren, sister_aveline, thistle_roe, tilda_fen, vespera_wisp
— ayrıca ana karakter **mahmut**.

**Boss / önemli NPC:** ashen_lord_wraith, bell_widow, eclipse_construct, marshal_oren, red_vial_matron, captain rusk,
ash_maw, lady_yseldra_vale, lord_cael_veyr, shrine_keeper, alchemist, refugee_woman.

**Düşmanlar:** ash_wolf, bellbound_dead, bridge_revenant, chain_cultist, choir_knight, corrupted_crown_guard,
corrupted_mercenary, crownless_knight, eclipse_sentinel, estate_wraith, glass_viper, hollow_cleric, hollow_pilgrim,
inkbound_dead, lost_vow_knight, noble_retainer, orchard_ghoul, red_vial_alchemist, red_vial_scout, royal_hollow.

## Bilinen eksikler (3D'ye geçiş açısından)

- **5 kahramanın büyük çizimi yok:** cassian_thorne, corbin_locke, dorian_kesk, garrick_cinder, rowan_reed —
  yalnız chibi ve art bible tarifi var.
- **Hiçbir karakterin yan/arka görünümü (turnaround) yok.** Görselden 3D model üretimi için her ana karakterin
  ön–yan–arka referansı üretilmeli.
- Arka planlar 2D boyama; 3D sahneler için doğrudan model kaynağı değil, atmosfer/mekân referansıdır.
- Seslendirme yalnız Japonca ve TTS ile üretilmiş.

## Sonraki adımlar

1. Hikâyenin ve karakterlerin tam okunması → tek bir "oyun bilgi dokümanı" (dünya, karakterler, ilişkiler, olay örgüsü).
2. Yeni oyunun türü ve çekirdek oynanışının belirlenmesi.
3. Oyun motoru seçimi (Unity / Godot / Unreal).
4. 3D üretim hattı: turnaround üretimi → görselden 3D model → rig → animasyon.
