#!/usr/bin/env bash
# UOMD bulut ortamı kurulumu. Tekrar çalıştırılabilir (idempotent): kurulu olanı atlar.
# Kullanım: bash tools/bootstrap.sh        (kök yetkisi gerekir; bulut ortamında öyledir)
set -euo pipefail

GODOT_VERSION="4.7.2"
GODOT_SHA256="cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4"
BLENDER_VERSION="5.2.4"
BLENDER_SHA256="2fd14c50987426897ba60237ee996edf2b4151f4b1a72a460ca20be58c1d2d86"
TOOLS_DIR="${UOMD_TOOLS_DIR:-/opt/uomd-tools}"

log() { printf '[bootstrap] %s\n' "$*"; }
mkdir -p "$TOOLS_DIR"

# 1) Sistem kütüphaneleri: EGL/Vulkan (yazılımsal GPU ile render), X sanal ekranı.
need_pkgs=()
for p in libegl1 libegl-mesa0 libvulkan1 libxkbcommon0 libsm6 libxi6 libxxf86vm1 libxfixes3 libxrender1 xvfb unzip xz-utils; do
  dpkg -s "$p" >/dev/null 2>&1 || need_pkgs+=("$p")
done
if [ ${#need_pkgs[@]} -gt 0 ]; then
  log "apt: ${need_pkgs[*]}"
  apt-get update -q >/dev/null
  DEBIAN_FRONTEND=noninteractive apt-get install -y -q "${need_pkgs[@]}" >/dev/null
fi

fetch() { # url hedef sha256
  local url="$1" out="$2" sum="$3"
  if [ -f "$out" ] && echo "$sum  $out" | sha256sum -c --status; then return 0; fi
  log "indiriliyor: $url"
  curl -fsSL --retry 4 --retry-delay 3 -o "$out.part" "$url"
  echo "$sum  $out.part" | sha256sum -c --status || { log "SHA256 uyuşmadı: $out"; rm -f "$out.part"; exit 1; }
  mv "$out.part" "$out"
}

# 2) Godot
GODOT_BIN="$TOOLS_DIR/Godot_v${GODOT_VERSION}-stable_linux.x86_64"
if [ ! -x "$GODOT_BIN" ]; then
  fetch "https://downloads.godotengine.org/?version=${GODOT_VERSION}&flavor=stable&slug=linux.x86_64.zip&platform=linux.64" \
        "$TOOLS_DIR/godot.zip" "$GODOT_SHA256"
  unzip -oq "$TOOLS_DIR/godot.zip" -d "$TOOLS_DIR"
fi
ln -sf "$GODOT_BIN" /usr/local/bin/godot

# 3) Blender
BLENDER_DIR="$TOOLS_DIR/blender-${BLENDER_VERSION}-linux-x64"
if [ ! -x "$BLENDER_DIR/blender" ]; then
  fetch "https://download.blender.org/release/Blender${BLENDER_VERSION%.*}/blender-${BLENDER_VERSION}-linux-x64.tar.xz" \
        "$TOOLS_DIR/blender.tar.xz" "$BLENDER_SHA256"
  tar xf "$TOOLS_DIR/blender.tar.xz" -C "$TOOLS_DIR"
fi
ln -sf "$BLENDER_DIR/blender" /usr/local/bin/blender

# 4) Arşivleri sil (disk kotası)
rm -f "$TOOLS_DIR/godot.zip" "$TOOLS_DIR/blender.tar.xz"

log "godot $(godot --version 2>/dev/null | head -1)"
log "blender $(blender -b --factory-startup --version 2>/dev/null | head -1)"
log "tamam"
