#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/hardware/v2/field_case_v151"
SCAD="$DIR/IceGeiger_FieldCase_v1.5.1_COMPLETE.scad"
OUT="$ROOT/docs/v2/images"
mkdir -p "$OUT"

render(){
  local part="$1"; local file="$2"; local size="${3:-1200,900}"
  xvfb-run -a openscad -D "part=\"$part\"" --render --autocenter --viewall --imgsize "$size" -o "$OUT/$file" "$SCAD"
}

render base field_case_v151_base.png
render lid field_case_v151_lid.png
render service_bridge field_case_v151_service_bridge.png
render beta_cap field_case_v151_beta_cap.png
render rear_badge field_case_v151_rear_badge.png
render gasket_jig field_case_v151_gasket_jig.png
render assembly field_case_v151_assembled.png 1400,1000
render layout field_case_v151_internal_layout.png 1400,1000
render exploded field_case_v151_exploded_raw.png 1400,1000
python3 "$ROOT/scripts/label-field-case-v151.py" "$OUT/field_case_v151_exploded_raw.png" "$OUT/field_case_v151_exploded_labeled.png"

echo "Field Case v1.5.1 previews: OK"
