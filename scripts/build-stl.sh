#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; SCAD="$ROOT/hardware/v2/openscad/icegeiger_v2_enclosure.scad"; OUT="$ROOT/hardware/v2/stl"; mkdir -p "$OUT"
command -v openscad >/dev/null || { echo 'openscad not installed' >&2; exit 1; }
for p in base lid service_cover fit_jig; do openscad -q -D "part=\"$p\"" -o "$OUT/icegeiger_v2_${p}_PRELIMINARY.stl" "$SCAD"; done
