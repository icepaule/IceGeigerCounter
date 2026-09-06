#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; SCAD="$ROOT/hardware/v2/openscad/icegeiger_v2_enclosure.scad"; OUT="$ROOT/docs/v2/images"; mkdir -p "$OUT"
command -v openscad >/dev/null || exit 0
for spec in 'assembly:v2_enclosure_assembled' 'exploded:v2_enclosure_exploded' 'layout:v2_internal_layout'; do p=${spec%%:*}; n=${spec##*:}; xvfb-run -a openscad --imgsize=1200,700 --viewall --autocenter -D "part=\"$p\"" -o "$OUT/$n.png" "$SCAD"; if command -v convert >/dev/null; then convert "$OUT/$n.png" -quality 82 "$OUT/$n.jpg"; rm -f "$OUT/$n.png"; fi; done
