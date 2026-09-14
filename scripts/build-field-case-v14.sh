#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/hardware/v2/field_case_v14/icegeiger_field_case_v14.scad"
OUT="$ROOT/hardware/v2/field_case_v14/stl"
mkdir -p "$OUT"

python3 "$ROOT/hardware/v2/field_case_v14/check_fit.py"

openscad -D 'part="base"' -o "$OUT/icegeiger_field_case_v14_base.stl" "$SCAD"
openscad -D 'part="lid"' -o "$OUT/icegeiger_field_case_v14_lid.stl" "$SCAD"
openscad -D 'part="service_bridge"' -o "$OUT/icegeiger_field_case_v14_service_bridge.stl" "$SCAD"
openscad -D 'part="beta_cap"' -o "$OUT/icegeiger_field_case_v14_beta_cap.stl" "$SCAD"
openscad -D 'part="gasket_jig"' -o "$OUT/icegeiger_field_case_v14_gasket_jig.stl" "$SCAD"

echo "Field Case v1.4 STL build: OK"
