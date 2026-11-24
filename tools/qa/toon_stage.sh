#!/usr/bin/env bash
# Toon shader görsel kontrolü: test gövdesini boru hattından üretir (MPFB -> glTF -> Godot), Godot'ta her ışık düzeni
# için düz ve toon render alır, shader/betik hatası varsa çıkış 1 verir.
# Çıktı: <klasör>/<ışık>_<mod>.png ve karşılaştırma sayfaları <klasör>/sheet_<ışık>.png (düz | toon).
# Kullanım: tools/qa/toon_stage.sh [çıktı klasörü = out/toon]
#   Daraltmak için:  LIGHTS="candle" MODES="toon" FOCUS=head tools/qa/toon_stage.sh
#   İskelet pozu (kontur/normal testi):  POSE=x:60 FOCUS=body tools/qa/toon_stage.sh out/toon_pose
set -euo pipefail
source "$(dirname "$0")/../env.sh"
cd "$UOMD_ROOT"
OUT="${1:-out/toon}"
LIGHTS="${LIGHTS:-candle ash neutral}"
MODES="${MODES:-toon flat}"
FOCUS="${FOCUS:-all}"
POSE="${POSE:-}"
RESOLUTION="${RESOLUTION:-1280x720}"
BODY=game/assets/dev/mpfb_body.glb   # git'e girmez (game/.gitignore)
mkdir -p "$OUT"

if [ ! -f "$BODY" ]; then
  echo "[toon_stage] test gövdesi üretiliyor (Blender + MPFB)"
  mkdir -p "$OUT/_body" "$(dirname "$BODY")"
  tools/blender.sh tools/smoke/mpfb_smoke.py -- "$OUT/_body" >"$OUT/_body/blender.log" 2>&1
  cp "$OUT/_body/mpfb_body.glb" "$BODY"
fi
godot --headless --path game --import >"$OUT/import.log" 2>&1 || true

fail=0
for light in $LIGHTS; do
  shots=()
  for mode in flat toon; do
    case " $MODES " in *" $mode "*) ;; *) continue ;; esac
    png="$OUT/${light}_${mode}.png"; log="$OUT/${light}_${mode}.log"
    start=$(date +%s)
    tools/godot.sh --path game --resolution "$RESOLUTION" res://scenes/dev/toon_stage.tscn -- \
      --light="$light" --mode="$mode" --focus="$FOCUS" ${POSE:+--pose="$POSE"} --shot="$UOMD_ROOT/$png" >"$log" 2>&1 || fail=1
    # Render Mobile yöntemiyle alınmış olmalı (hedef platform); shader/betik hatası olmamalı.
    if ! grep -q "TOON_STAGE_OK.*method=mobile" "$log" || grep -qE "SHADER ERROR|SCRIPT ERROR|Parse Error|^ERROR:" "$log"; then
      echo "❌ $light/$mode (bkz. $log)"; grep -E "SHADER ERROR|SCRIPT ERROR|Parse Error|^ERROR:" "$log" | head -8 || true; fail=1
    else
      echo "✅ $light/$mode  $(( $(date +%s) - start )) sn  -> $png"
      shots+=("$png")
    fi
  done
  if [ "${#shots[@]}" -gt 1 ]; then python3 tools/qa/sheet.py "$OUT/sheet_${light}.png" "${shots[@]}" --height 540 >/dev/null; fi
done
exit $fail
