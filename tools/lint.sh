#!/usr/bin/env bash
# GDScript kalite kontrolü: gdlint + gdformat --check. Üçüncü taraf eklentiler (game/addons) kapsam dışıdır:
# gdlint bunu gdlintrc'den bilir, gdformat'ın dışlama seçeneği olmadığı için dosya listesini burada süzeriz.
# Kullanım: tools/lint.sh      Sorun varsa çıkış kodu 1.
set -euo pipefail
cd "$(dirname "$0")/.."
gdlint game
mapfile -d '' files < <(find game -name '*.gd' -not -path 'game/addons/*' -not -path 'game/.godot/*' -print0)
[ "${#files[@]}" -gt 0 ] || { echo "gdformat: denetlenecek dosya yok"; exit 0; }
gdformat --check "${files[@]}"
