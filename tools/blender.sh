#!/usr/bin/env bash
# Blender'ı ekransız, EEVEE çalışacak şekilde başlatır.
# Kullanım: tools/blender.sh <betik.py> [-- betik argümanları]
#   örn:    tools/blender.sh art_src/characters/fadyme/build.py -- --render
set -euo pipefail
source "$(dirname "$0")/env.sh"
script="$1"; shift
exec blender -b --factory-startup --gpu-backend vulkan --python-exit-code 1 -P "$script" "$@"
