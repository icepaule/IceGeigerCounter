#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/hardware/v2/field_case_v12/icegeiger_field_case_v12.scad"
OUT="$ROOT/hardware/v2/field_case_v12/stl"
mkdir -p "$OUT"
command -v openscad >/dev/null || { echo 'openscad not installed' >&2; exit 1; }
for p in base lid tracker_shelf beta_cap gasket_jig fit_jig; do
  suffix="PRELIMINARY"
  [[ "$p" == gasket_jig || "$p" == fit_jig ]] && suffix="TEST"
  openscad -q -D "part=\"$p\"" -o "$OUT/icegeiger_field_case_v12_${p}_${suffix}.stl" "$SCAD"
done
python3 "$ROOT/hardware/v2/field_case_v12/check_fit.py"
