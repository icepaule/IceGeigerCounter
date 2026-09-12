#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/hardware/v2/field_case_v12/icegeiger_field_case_v12.scad"
OUT="$ROOT/docs/v2/images"
mkdir -p "$OUT"
command -v openscad >/dev/null || { echo 'openscad not installed' >&2; exit 1; }
for spec in \
 'assembly:field_case_v12_assembled' \
 'exploded:field_case_v12_exploded' \
 'layout:field_case_v12_internal_layout' \
 'beta_detail:field_case_v12_beta_window'; do
  p=${spec%%:*}; n=${spec##*:}
  xvfb-run -a openscad --imgsize=1400,900 --viewall --autocenter \
    -D "part=\"$p\"" -o "$OUT/$n.png" "$SCAD"
done
