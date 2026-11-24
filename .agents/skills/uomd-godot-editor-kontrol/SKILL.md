---
name: uomd-godot-editor-kontrol
description: Godot editörünü Godot AI MCP köprüsüyle yönetir: editörü başlat, sahne aç, oyunu çalıştır, ekran görüntüsü al, günlük oku, durdur. Sahne, düğüm, betik ya da malzeme düzenlerken ve oyunu görsel doğrularken kullan.
---
# Godot editörü kontrolü (Godot AI)

- Başlat: `tools/godot-editor.sh start`, sonra `tools/godot-editor.sh wait` (taze projede ilk açılış ~8–10 dk; sonrası ~35 sn). Bitince `tools/godot-editor.sh stop`.
- Araçlar: `godot-ai` MCP sunucusu (`.agents/mcp_config.json`). Sunucu yüklü değilse `tools/mcp-call.sh godot-ai <araç> '<json>'` (`--list`, `--schema <araç>`).
- Tipik döngü: `scene_open` → `project_run(mode="current", autosave=false)` → `editor_screenshot(source="game")` → `logs_read(source="game" | "editor")` → `project_manage(op="stop")`.
- Kurallar:
  - `project_run`'da her zaman `autosave=false` (yoksa bellekteki düzenlemeler sahne dosyasına yazılır).
  - `client_manage` aracını **kullanma** (istemci yapılandırma dosyalarını yazar).
  - Telemetri kapalı kalır. Araçlar diske yazar: iş bitince `git status` bak.
- Editör `game/project.godot`'u kanonik biçime yeniden yazar. Fark yalnız varsayılan satırların silinmesiyse commit'e alınabilir.
- Ekran görüntüsü: oyun karesi `source="game"`, editörün 3D görünümü `source="viewport"`.
- Eklentinin kendi sunucu başlatması kırılgan olabilir; `tools/godot-editor.sh` sunucuyu kendisi başlatıp editöre devreder.
