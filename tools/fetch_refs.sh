#!/usr/bin/env bash
# Salt okunur referans repoları vendor/ altına indirir (git'e girmez). Sürümler sabittir.
# Kod kopyalanmaz; yalnız okunur, fikir alınır. Lisanslar docs/KAYNAKLAR.md'de.
# Kullanım: tools/fetch_refs.sh [ad...]   (ad verilmezse hepsi)
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p vendor
declare -A REFS=(
  [godot-open-rpg]="https://github.com/gdquest-demos/godot-open-rpg 0.4.0"
  [godot-demo-projects]="https://github.com/godotengine/godot-demo-projects 4.7-6ad6167"
  [mpfb2]="https://github.com/makehumancommunity/mpfb2 v2010-submitted-to-blender"
)
names=("$@"); [ ${#names[@]} -eq 0 ] && names=("${!REFS[@]}")
for n in "${names[@]}"; do
  read -r url tag <<<"${REFS[$n]}"
  if [ -d "vendor/$n" ]; then echo "[refs] $n zaten var"; continue; fi
  echo "[refs] $n @ $tag"
  git -c advice.detachedHead=false clone -q --depth 1 --branch "$tag" "$url" "vendor/$n"
done
