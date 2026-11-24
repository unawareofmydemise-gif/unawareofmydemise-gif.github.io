#!/usr/bin/env bash
# Altyapı sağlık kontrolü: araç sürümleri + Blender render + glTF + Godot içe aktarma + Godot render.
# Kullanım: tools/doctor.sh [çıktı klasörü]   (varsayılan: /tmp/uomd-doctor)
set -euo pipefail
source "$(dirname "$0")/env.sh"
OUT="${1:-/tmp/uomd-doctor}"; rm -rf "$OUT"; mkdir -p "$OUT"
ok=0; fail() { echo "❌ $*"; ok=1; }
command -v godot >/dev/null && echo "✅ godot $(godot --version | head -1)" || fail "godot yok (tools/bootstrap.sh)"
command -v blender >/dev/null && echo "✅ $(blender -b --factory-startup --version 2>/dev/null | head -1)" || fail "blender yok (tools/bootstrap.sh)"
log="$OUT/blender.log"
"$UOMD_ROOT/tools/blender.sh" "$UOMD_ROOT/tools/smoke/blender_smoke.py" -- "$OUT" >"$log" 2>&1 || true
grep -q SMOKE_BLENDER_RENDER_OK "$log" && echo "✅ Blender EEVEE render ($(grep -o 'OK [0-9.]*s' "$log"))" || fail "Blender render (bkz. $log)"
grep -q SMOKE_BLENDER_GLTF_OK "$log" && echo "✅ Blender glTF dışa aktarma" || fail "glTF dışa aktarma (bkz. $log)"
"$UOMD_ROOT/tools/blender.sh" "$UOMD_ROOT/tools/smoke/mpfb_smoke.py" -- "$OUT" >"$OUT/mpfb.log" 2>&1 || true
grep -q SMOKE_MPFB_GLTF_OK "$OUT/mpfb.log" && echo "✅ MPFB2 gövde + iskelet ($(grep -o 'verts=.*' "$OUT/mpfb.log"))" || fail "MPFB2 (bkz. $OUT/mpfb.log)"
proj="$OUT/godot"; cp -r "$UOMD_ROOT/tools/smoke/godot" "$proj"; cp "$OUT/smoke.glb" "$proj/" 2>/dev/null || true
godot --headless --import --path "$proj" >"$OUT/godot_import.log" 2>&1 || true
[ -f "$proj/.godot/imported/smoke.glb-"*.scn ] 2>/dev/null && echo "✅ Godot glTF içe aktarma" || { ls "$proj/.godot/imported" 2>/dev/null | grep -q smoke.glb && echo "✅ Godot glTF içe aktarma" || fail "Godot içe aktarma (bkz. $OUT/godot_import.log)"; }
SMOKE_OUT="$OUT" "$UOMD_ROOT/tools/godot.sh" --path "$proj" --resolution 960x540 >"$OUT/godot_run.log" 2>&1 || true
grep -q "SMOKE_GODOT_RENDER_OK.*method=mobile" "$OUT/godot_run.log" && echo "✅ Godot render, Mobile yöntemi ($(grep -o 'llvmpipe[^)]*)' "$OUT/godot_run.log" | head -1))" || fail "Godot render ya da Mobile yöntemi (bkz. $OUT/godot_run.log)"
live="$OUT/godot_live"; cp -r "$UOMD_ROOT/tools/smoke/godot_live" "$live"; godot --headless --import --path "$live" >/dev/null 2>&1 || true
/opt/uomd-tools/venv/bin/python "$UOMD_ROOT/tools/smoke/mcp_smoke.py" "$live" "$OUT" >"$OUT/mcp.log" 2>&1 || true
n_ok=$(grep -c SMOKE_MCP_OK "$OUT/mcp.log" || true); n_fail=$(grep -c SMOKE_MCP_FAIL "$OUT/mcp.log" || true)
[ "$n_fail" = 0 ] && [ "$n_ok" -ge 8 ] && echo "✅ MCP izleme: Godot (çalıştır/ekran/arayüz/GDScript) + Blender (kod/bilgi/ekran) · $n_ok kontrol" || fail "MCP ($n_fail hata; bkz. $OUT/mcp.log)"
for b in graphify gdlint gdformat; do command -v $b >/dev/null && echo "✅ $b" || fail "$b yok (tools/bootstrap.sh)"; done
(cd "$UOMD_ROOT" && tools/test.sh >"$OUT/gut.log" 2>&1) && echo "✅ Godot birim testleri ($(grep -o 'Passing Tests *[0-9]*' "$OUT/gut.log" | tr -s ' '))" || fail "Godot testleri (bkz. $OUT/gut.log)"
echo "Çıktılar: $OUT/blender_eevee.png  $OUT/godot_render.png"
exit $ok
