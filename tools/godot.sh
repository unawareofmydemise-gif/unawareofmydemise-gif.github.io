#!/usr/bin/env bash
# Godot'u sanal ekran (Xvfb) + yazılımsal Vulkan ile çalıştırır; ekran görüntüsü alınabilir.
# Kullanım: tools/godot.sh [godot argümanları]
#   örn:    tools/godot.sh --path game --resolution 1920x1080
# Yalnız içe aktarma / betik için render gerekmiyorsa: godot --headless ...
set -euo pipefail
source "$(dirname "$0")/env.sh"
exec xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-driver vulkan "$@"
