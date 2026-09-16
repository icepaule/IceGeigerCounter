#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/hardware/v2/field_case_v151/badge_v152"
SCAD="$DIR/IceGeiger_Badge_v1.5.2_ACE.scad"
OUT="$ROOT/docs/v2/images"
mkdir -p "$OUT"

xvfb-run -a openscad -D 'part="two_color_preview"' --render --autocenter --viewall --imgsize 1400,900 -o "$OUT/field_case_v152_badge_ace_2color.png" "$SCAD"
xvfb-run -a openscad -D 'part="base"' --render --autocenter --viewall --imgsize 1200,900 -o "$OUT/field_case_v152_badge_base.png" "$SCAD"
xvfb-run -a openscad -D 'part="logo_text"' --render --autocenter --viewall --imgsize 1200,900 -o "$OUT/field_case_v152_badge_logo_text.png" "$SCAD"

echo "ACE badge v1.5.2 previews: OK"
