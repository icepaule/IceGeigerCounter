#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/hardware/v2/field_case_v151/badge_v153"
SCAD="$DIR/IceGeiger_Badge_v1.5.3_ACE.scad"
OUT="$ROOT/docs/v2/images"
mkdir -p "$OUT"

render(){
  local part="$1"; local file="$2"; local size="${3:-1200,900}"
  xvfb-run -a openscad -D "part=\"$part\"" --render --autocenter --viewall --imgsize "$size" -o "$OUT/$file" "$SCAD"
}

render base field_case_v153_badge_base.png
render logo_text field_case_v153_badge_logo_text.png
render one_color field_case_v153_badge_one_color.png
render two_color_preview field_case_v153_badge_2color.png 1400,900

echo "ACE badge v1.5.3 previews: OK"
