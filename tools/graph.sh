#!/usr/bin/env bash
# Kod bilgi grafiğini kurar: Graphify (Python, Markdown…) + bizim GDScript/.tscn çıkarıcımız, tek graph.json'da.
# Çıktı: graphify-out/graph.json (+ GRAPH_REPORT.md, graph.html). Sorgu: graphify query "<soru>"
# Kullanım: tools/graph.sh
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$UOMD_ROOT"
VENV=/opt/uomd-tools/venv/bin
"$VENV/graphify" update . --force >/dev/null
"$VENV/python" tools/graph/gdscript_extract.py game graphify-out/gdscript.json --exclude addons --res-root game
"$VENV/graphify" merge-graphs graphify-out/graph.json graphify-out/gdscript.json --out graphify-out/graph.json >/dev/null
"$VENV/graphify" cluster-only . --no-label >/dev/null 2>&1 || true
python3 -c "import json;d=json.load(open('graphify-out/graph.json'));print(f'[graph] {len(d[\"nodes\"])} düğüm, {len(d[\"links\"])} kenar -> graphify-out/graph.json')"
