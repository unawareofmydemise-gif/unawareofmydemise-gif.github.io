---
name: uomd-ortam-kur-dogrula
description: UOMD geliştirme ortamını kurar ve sağlık kontrolünü çalıştırır (Godot 4.7.2, Blender 5.2.4, MPFB2, Godot AI). Yeni makinede ya da oturumda, bir araç bulunamadığında veya doctor hata verdiğinde kullan.
---
# Ortamı kur ve doğrula

1. Kur: `bash tools/bootstrap.sh` (Ubuntu 24.04, kök yetkisi; tekrar çalıştırılabilir; ~1,5 dk).
2. Doğrula: `tools/doctor.sh`. 13 kontrolün hepsi ✅ olmalı; ❌ satırı neyin eksik olduğunu ve log yolunu söyler.
3. Sık sorunlar:
   - Godot indirmesi 403: `downloads.godotengine.org` bir CDN'e yönlenir; ağ ilkesi o adresi izinli yapmalı. Zinciri izle:
     `curl -sIL '<indirme url>' | grep -iE '^(HTTP|location)'` (bkz. `docs/ALTYAPI.md` §1.1).
   - Godot render "Forward+" görünüyorsa `tools/godot.sh` kullan (Mobile'ı zorlar); `--rendering-driver` tek başına proje ayarını yok sayar.
   - Ekransız Godot: `godot --headless --path game --import`. Render için sanal ekran gerekir (`tools/godot.sh`).
4. Başka işletim sistemi: betikler bash'tir. WSL2/Ubuntu kullan ya da `docs/DEVIR_GEMINI.md` §5'e bak.
5. Sonucu `docs/ILERLEME.md` "Ortam" satırına yaz (ne çalışıyor, ne çalışmıyor).
