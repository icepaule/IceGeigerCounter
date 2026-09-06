#!/usr/bin/env bash
set -euo pipefail
for f in firmware/icegeiger_v2/secrets.h integrations/bridge/.env; do [[ ! -e "$f" ]] || { echo "ERROR: secret-bearing file exists: $f" >&2; exit 1; }; done
if grep -RIE --exclude-dir=.git --exclude='*.stl' --exclude='*.jpg' --exclude='*.svg' '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|(appkey|nwkkey|password|passwd|token|secret)[[:space:]]*[:=][[:space:]]*[A-Za-z0-9+/=_-]{20,}' .; then echo 'ERROR: possible secret' >&2; exit 1; fi
echo 'Security scan: no obvious embedded secrets found; manual review still required.'
