#!/usr/bin/env bash
set -euo pipefail

for f in firmware/icegeiger_v2/secrets.h integrations/bridge/.env; do
  [[ ! -e "$f" ]] || {
    echo "ERROR: secret-bearing file exists: $f" >&2
    exit 1
  }
done

# `--` is required because the private-key pattern begins with dashes and would
# otherwise be parsed by grep as an option. Binary CAD/render artifacts are
# excluded so random binary bytes cannot create false positives.
PATTERN='-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|(appkey|nwkkey|password|passwd|token|secret)[[:space:]]*[:=][[:space:]]*[A-Za-z0-9+/=_-]{20,}'

if grep -RIE \
  --exclude-dir=.git \
  --exclude='*.stl' \
  --exclude='*.3mf' \
  --exclude='*.png' \
  --exclude='*.jpg' \
  --exclude='*.jpeg' \
  --exclude='*.svg' \
  --exclude='*.zip' \
  -- "$PATTERN" .; then
  echo 'ERROR: possible secret' >&2
  exit 1
fi

echo 'Security scan: no obvious embedded secrets found; manual review still required.'
