#!/usr/bin/env bash
# UOMD bulut ortamı kurulumu. Tekrar çalıştırılabilir (idempotent): kurulu olanı atlar.
# Kullanım: bash tools/bootstrap.sh        (kök yetkisi gerekir; bulut ortamında öyledir)
set -euo pipefail

GODOT_VERSION="4.7.2"
GODOT_SHA256="cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4"
BLENDER_VERSION="5.2.4"
BLENDER_SHA256="2fd14c50987426897ba60237ee996edf2b4151f4b1a72a460ca20be58c1d2d86"
MPFB_TAG="v2010-submitted-to-blender"   # makehumancommunity/mpfb2 (MPFB 2.0.10)
PY_PACKAGES=("graphifyy[mcp]==0.9.118" "mcp==2.3.0" "gdtoolkit==4.5.0" "fake-bpy-module-5.2==20260730")
GODOT_MCP_VERSION="4.0.1"   # npm: godot-mcp-runtime
GODOT_AI_VERSION="4.4.2"    # PyPI: godot-ai (sunucu). Eklenti game/addons/godot_ai/plugin.cfg ile AYNI sürüm olmalı
TOOLS_DIR="${UOMD_TOOLS_DIR:-/opt/uomd-tools}"

log() { printf '[bootstrap] %s\n' "$*"; }
mkdir -p "$TOOLS_DIR"

# 1) Sistem kütüphaneleri: EGL/Vulkan (yazılımsal GPU ile render), X sanal ekranı.
need_pkgs=()
for p in x11-utils libegl1 libegl-mesa0 libvulkan1 libxkbcommon0 libsm6 libxi6 libxxf86vm1 libxfixes3 libxrender1 xvfb unzip zip xz-utils git python3-venv; do
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

# 4) Python araçları (ayrı sanal ortam): Graphify, gdtoolkit (gdlint/gdformat), Blender API tip tanımları
VENV="$TOOLS_DIR/venv"
[ -x "$VENV/bin/python" ] || python3 -m venv "$VENV"
if ! "$VENV/bin/pip" freeze 2>/dev/null | grep -q "^graphifyy==0.9.118"; then
  log "pip: ${PY_PACKAGES[*]}"
  "$VENV/bin/pip" install -q --upgrade pip
  "$VENV/bin/pip" install -q "${PY_PACKAGES[@]}"
fi
for b in graphify gdlint gdformat; do ln -sf "$VENV/bin/$b" "/usr/local/bin/$b"; done
# Graphify'ın Claude yeteneği (~/.claude/skills/graphify) — her yeni konteynerde
[ -f "$HOME/.claude/skills/graphify/SKILL.md" ] || "$VENV/bin/graphify" install --platform claude >/dev/null

# 5) MPFB2 (MakeHuman Blender eklentisi): parametrik insan gövdesi + oyun iskeleti. Kod GPL-3, varlıklar CC0.
MPFB_EXT_DIR="$HOME/.config/blender/${BLENDER_VERSION%.*}/extensions/user_default/mpfb"
if [ ! -f "$MPFB_EXT_DIR/blender_manifest.toml" ]; then
  log "MPFB2 $MPFB_TAG kuruluyor"
  rm -rf "$TOOLS_DIR/src/mpfb2"; mkdir -p "$TOOLS_DIR/src"
  git -c advice.detachedHead=false clone -q --depth 1 --branch "$MPFB_TAG" https://github.com/makehumancommunity/mpfb2 "$TOOLS_DIR/src/mpfb2"
  (cd "$TOOLS_DIR/src/mpfb2/src" && rm -f "$TOOLS_DIR/mpfb.zip" && zip -qr "$TOOLS_DIR/mpfb.zip" mpfb -x '*/__pycache__/*')
  blender -b --factory-startup --command extension install-file -r user_default -e "$TOOLS_DIR/mpfb.zip" >/dev/null 2>&1
  rm -rf "$TOOLS_DIR/src/mpfb2" "$TOOLS_DIR/mpfb.zip"
  [ -f "$MPFB_EXT_DIR/blender_manifest.toml" ] || { log "MPFB2 kurulamadı"; exit 1; }
fi

# 6) MCP sunucuları: Godot (godot-mcp-runtime, npm) + UOMD Blender köprüsü (repo içinde)
REPO_DIR="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"
if [ ! -f "$TOOLS_DIR/mcp/node_modules/godot-mcp-runtime/package.json" ] || \
   ! grep -q "\"version\": \"$GODOT_MCP_VERSION\"" "$TOOLS_DIR/mcp/node_modules/godot-mcp-runtime/package.json"; then
  log "npm: godot-mcp-runtime@$GODOT_MCP_VERSION"
  mkdir -p "$TOOLS_DIR/mcp"
  npm install --prefix "$TOOLS_DIR/mcp" --silent --no-audit --no-fund "godot-mcp-runtime@$GODOT_MCP_VERSION"
fi
ln -sf "$REPO_DIR/tools/godot-display.sh" /usr/local/bin/uomd-godot-display
ln -sf "$REPO_DIR/tools/mcp/uomd-blender-mcp" /usr/local/bin/uomd-blender-mcp

# 6b) Godot AI (hi-godot/godot-ai, MIT): Godot editörünü MCP ile yönetir. Eklenti game/addons/godot_ai'de (repoda, sabit);
#     sunucu paketi ayrı sanal ortamda (kendi sabit bağımlılıkları var). Eklenti sunucuyu uvx ile başlatır.
GAI_VENV="$TOOLS_DIR/godot-ai-venv"
[ -x "$GAI_VENV/bin/python" ] || python3 -m venv "$GAI_VENV"
if ! "$GAI_VENV/bin/pip" freeze 2>/dev/null | grep -q "^godot-ai==$GODOT_AI_VERSION$"; then
  log "pip: godot-ai==$GODOT_AI_VERSION"
  "$GAI_VENV/bin/pip" install -q --upgrade pip
  "$GAI_VENV/bin/pip" install -q "godot-ai==$GODOT_AI_VERSION"
fi
if ! command -v uvx >/dev/null; then # taban imajda uv var (0.11); yoksa venv'e kurup PATH'e koy
  log "pip: uv (yedek)"
  "$GAI_VENV/bin/pip" install -q uv
  ln -sf "$GAI_VENV/bin/uv" /usr/local/bin/uv; ln -sf "$GAI_VENV/bin/uvx" /usr/local/bin/uvx
fi
grep -q "^version=\"$GODOT_AI_VERSION\"" "$REPO_DIR/game/addons/godot_ai/plugin.cfg" 2>/dev/null || \
  log "UYARI: game/addons/godot_ai eklenti sürümü $GODOT_AI_VERSION değil; sunucu ve eklenti aynı sürümde olmalı"
# Sunucuda ses kartı yok: ALSA'yı boş cihaza yönlendir (editörden çalışan oyun "ERR_CANT_OPEN" yazmasın)
[ -f /etc/asound.conf ] || printf 'pcm.!default { type null }\nctl.!default { type null }\n' >/etc/asound.conf

# 7) Arşivleri sil (disk kotası)
rm -f "$TOOLS_DIR/godot.zip" "$TOOLS_DIR/blender.tar.xz"

log "godot $(godot --version 2>/dev/null | head -1)"
log "blender $(blender -b --factory-startup --version 2>/dev/null | head -1)"
log "graphify $("$VENV/bin/pip" show graphifyy 2>/dev/null | awk '/^Version/{print $2}') · gdtoolkit $("$VENV/bin/pip" show gdtoolkit 2>/dev/null | awk '/^Version/{print $2}') · MPFB $(grep -m1 '^version' "$MPFB_EXT_DIR/blender_manifest.toml" | cut -d'"' -f2)"
log "godot-ai $("$GAI_VENV/bin/godot-ai" --version 2>/dev/null | head -1) · uv $(uv --version 2>/dev/null | awk '{print $2}')"
log "tamam"
