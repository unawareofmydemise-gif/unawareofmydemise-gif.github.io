#!/usr/bin/env bash
# Godot'u kalıcı sanal ekranda (Xvfb :99) + yazılımsal Vulkan ile başlatır.
# MCP sunucularının GODOT_PATH'i budur: --headless verilirse ekran kullanılmaz, verilmezse
# oyun :99 ekranında çizilir ve ekran görüntüsü alınabilir.
set -euo pipefail
source "$(dirname "$(readlink -f "$0")")/env.sh"
"$UOMD_ROOT/tools/xdisplay.sh" >/dev/null
export DISPLAY=:99
exec godot --audio-driver Dummy "$@"
