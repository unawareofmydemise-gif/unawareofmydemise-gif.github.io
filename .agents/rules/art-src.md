---
trigger: glob
globs: art_src/**,design/art_bible/**
description: Blender üretim betikleri ve art bible kuralları
---
# 3D üretim (Blender) kuralları

- Model **Blender Python betiğiyle** üretilir (`art_src/<tür>/<id>/build.py`; kalıp: `art_src/README.md`). `.glb`'yi elle düzenleme; betiği düzelt, yeniden üret.
- Ölçek: 1 birim = 1 metre, ayak tabanı z=0. Karakterler Blender'da **-Y yönüne bakar**; glTF'te +Z olur.
- Malzeme adı preset seçer: `skin_*`, `hair_*`, `cloth_*`, `metal_*` (başka ad = default). Taban renk ve doku glTF'e gider; toon görünüm Godot'tadır.
- Her model değişikliğinden sonra: `tools/blender.sh <betik> -- --render` → `python3 tools/qa/sheet.py out/<id>/sheet.png <referans> <render>...` → **sayfaya bak**. Bakmadan "oldu" deme; sayfa yolunu commit mesajına yaz.
- Ortak kod `art_src/lib/`. Karakterler ortak anime gövde tabanını ve iskeleti paylaşır (animasyonlar bir kez yazılır).
- Blender API'sinden emin değilsen tahmin etme: `bpy-stubs` tip tanımlarını oku. İnsan gövdesi tabanı MPFB2 (`tools/smoke/mpfb_smoke.py`).
- Karakter görünüşünün tek kaynağı: `design/art_bible/` (`character_locks.md` kilitli özellikler) ve `art/portraits/` (salt okunur).
