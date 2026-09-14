#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/hardware/v2/field_case_v14/icegeiger_field_case_v14.scad"
OUT="$ROOT/docs/v2/images"
mkdir -p "$OUT"

render() {
  local part="$1"
  local file="$2"
  xvfb-run -a openscad -D "part=\"$part\"" --render --autocenter --viewall --imgsize 1200,900 -o "$OUT/$file" "$SCAD"
}

render assembly field_case_v14_assembled.png
render exploded field_case_v14_exploded.png
render layout field_case_v14_internal_layout.png

echo "Field Case v1.4 previews: OK"
