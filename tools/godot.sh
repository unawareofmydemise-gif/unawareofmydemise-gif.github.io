#!/usr/bin/env bash
# Godot'u sanal ekran (Xvfb) + yazılımsal Vulkan ile çalıştırır; ekran görüntüsü alınabilir.
# Kullanım: tools/godot.sh [godot argümanları]
#   örn:    tools/godot.sh --path game --resolution 1920x1080
# Yalnız içe aktarma / betik için render gerekmiyorsa: godot --headless ...
# Render yöntemi Mobile'a sabitlenir (hedef: PC + Android aynı görünüm). Godot, yalnız --rendering-driver verilirse
# proje ayarını yok sayıp Forward+'a düşer (2026-11-24'te görüldü); bu yüzden --rendering-method açıkça verilir.
# Başka yöntemi denemek için sonuna kendi bayrağını ekle (sonraki bayrak kazanır): ... --rendering-method forward_plus
set -euo pipefail
source "$(dirname "$0")/env.sh"
exec xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-driver vulkan --rendering-method mobile \
  --audio-driver Dummy "$@"
