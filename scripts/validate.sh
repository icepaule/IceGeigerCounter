#!/usr/bin/env bash
set -euo pipefail
python3 -m py_compile integrations/bridge/bridge.py
node tests/test_codec.js
python3 tests/test_bridge_normalization.py
./scripts/security-scan.sh
if command -v openscad >/dev/null; then ./scripts/build-stl.sh >/dev/null; fi
echo 'Validation: OK'
