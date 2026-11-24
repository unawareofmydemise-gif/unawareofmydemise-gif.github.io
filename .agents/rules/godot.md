---
trigger: glob
globs: game/**/*.gd,game/**/*.gdshader,game/**/*.tscn,game/data/**
description: Godot projesi kuralları
---
# Godot kuralları

- Godot 4.7.2, **Mobile** render yöntemi. `tools/godot.sh` yöntemi zorlar; başka yöntemle render alma.
- İçerik **veri odaklı**: karakter, yetenek, banner, diyalog `game/data/` altında; yeni içerik kod değişikliği gerektirmesin.
- Yeni oyun sistemi = yeni GUT testi (`game/tests/`). Commit'ten önce `tools/test.sh` ve `tools/lint.sh` yeşil.
- Statik tipli GDScript yaz. `game/addons/` altındaki dosyaları değiştirme.
- Toon görünüm: `ToonSkin.apply(...)` ve `game/data/toon_presets.json`. Shader ya da preset değişince `tools/qa/toon_stage.sh` çalıştır ve sayfaya bak.
- UI hem 16:9 (PC) hem 20:9 (telefon) çözünürlükte çalışmalı; fare, klavye, oyun kolu ve **dokunmatik**; dokunma hedefi ≥ 48 px, güvenli alan. İkisinde de ekran görüntüsüyle doğrula.
- Kaynak içerik (`art/`, `audio/`) doğrudan bağlanmaz; işlenip `game/assets/` altına kopyalanır.
- Godot editörünü yalnız `tools/godot-editor.sh` ile aç; `project_run`'da `autosave=false`; `client_manage` aracını kullanma; iş bitince `stop`.
