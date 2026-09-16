#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/hardware/v2/field_case_v151/badge_v153"
SCAD="$DIR/IceGeiger_Badge_v1.5.3_ACE.scad"
OUT="$DIR/stl"
mkdir -p "$OUT"

openscad -D 'part="base"' -o "$OUT/IceGeiger_Badge_v1.5.3_BASE.stl" "$SCAD"
openscad -D 'part="logo_text"' -o "$OUT/IceGeiger_Badge_v1.5.3_LOGO_TEXT.stl" "$SCAD"
openscad -D 'part="one_color"' -o "$OUT/IceGeiger_Badge_v1.5.3_ONE_COLOR.stl" "$SCAD"

echo "ACE badge v1.5.3 STL build: OK"
