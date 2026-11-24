#!/usr/bin/env bash
# Salt okunur referans repoları (git alt modülleri, sürüm sabit) vendor/ altına indirir.
# Kod oyuna kopyalanmaz; yalnız okunur. Liste ve lisanslar: docs/KAYNAKLAR.md, sürümler: .gitmodules + git submodule status
# Kullanım: tools/fetch_refs.sh [ad...]   (örn. tools/fetch_refs.sh godot-open-rpg; ad verilmezse hepsi)
set -euo pipefail
cd "$(dirname "$0")/.."
paths=(); for n in "$@"; do paths+=("vendor/$n"); done
git -c advice.detachedHead=false submodule update --init --depth 1 "${paths[@]}"
git submodule status "${paths[@]}"
