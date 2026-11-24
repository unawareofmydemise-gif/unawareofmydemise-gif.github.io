---
name: uomd-model-kalite-dongusu
description: Bir 3D modeli (Blender betiği) standart açılardan render edip referans çizimle karşılaştırma sayfasına bakarak doğrulama döngüsü. Model ya da malzeme değiştirdikten sonra kullan.
---
# Model kalite döngüsü

1. Betiği çalıştır: `tools/blender.sh art_src/<tür>/<id>/build.py -- --render` (çıktı: `out/<id>/{front,three_quarter,side,back}.png`).
2. Sayfa üret: `python3 tools/qa/sheet.py out/<id>/sheet.png art/portraits/<id>/composed.webp out/<id>/*.png`.
3. **Sayfaya bak** (görüntüyü aç). Oranlar, siluet, kıyafet, aksesuar referansla uyuşuyor mu? `design/art_bible/character_locks.md` kilitleriyle karşılaştır.
4. Fark varsa `build.py`'yi düzelt (modeli elle düzenleme) ve 1'e dön.
5. Godot'ta toon ile doğrula: `--export` ile `.glb`, sonra `tools/qa/toon_stage.sh` ya da `tools/godot.sh`; ekran görüntüsüne bak. İskelet varsa `POSE=x:70 FOCUS=body tools/qa/toon_stage.sh` ile poz altında konturu kontrol et.
6. Sayfa yolunu commit mesajına yaz. "Anime görünüyor mu" yargısı gerektiğinde sahibe sor.

Not: render bu kapsülde ~16 sn/açı (GPU yok). Hızlı önizleme için `engine="BLENDER_WORKBENCH"` (`art_src/lib/uomd_render.py`).
