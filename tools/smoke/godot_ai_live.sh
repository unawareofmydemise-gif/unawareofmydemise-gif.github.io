#!/usr/bin/env bash
# Godot AI canlı duman testi (YAVAŞ: ilk editör açılışı dakikalar sürebilir; bu yüzden doctor'a girmez).
# Editörü açar, bağlanır, sahneyi çalıştırıp oyun karesini yakalar, her şeyi kapatır.
# Kullanım: tools/smoke/godot_ai_live.sh [çıktı klasörü = out/godot_ai_smoke]
# Ne zaman: Godot AI sürümü ya da proje ayarı değiştiğinde ve yeni bir bulut ortamında bir kez.
set -euo pipefail
ROOT="$(cd "$(dirname "$(readlink -f "$0")")/../.." && pwd)"
OUT="${1:-$ROOT/out/godot_ai_smoke}"
trap '"$ROOT/tools/godot-editor.sh" stop' EXIT
"$ROOT/tools/godot-editor.sh" start
"$ROOT/tools/godot-editor.sh" wait 1500
/opt/uomd-tools/venv/bin/python "$ROOT/tools/smoke/godot_ai_smoke.py" "$OUT"
