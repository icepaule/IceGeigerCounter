#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/hardware/v2/field_case_v151"
SCAD="$DIR/IceGeiger_FieldCase_v1.5.1_COMPLETE.scad"
OUT="$DIR/stl"
mkdir -p "$OUT"

python3 "$DIR/check_fit.py"

for part in base lid service_bridge beta_cap rear_badge gasket_jig; do
  openscad -D "part=\"$part\"" -o "$OUT/IceGeiger_FieldCase_v1.5.1_${part^^}.stl" "$SCAD"
done

echo "Field Case v1.5.1 STL build: OK"
