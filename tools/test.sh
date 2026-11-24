#!/usr/bin/env bash
# Godot birim testlerini (GUT) ekransız çalıştırır. Başarısız test varsa çıkış kodu 1.
# Kullanım: tools/test.sh [ek GUT argümanları, örn. -gselect=test_battle]
set -euo pipefail
cd "$(dirname "$0")/../game"
godot --headless --path . --import >/dev/null 2>&1 || true
exec godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit "$@"
