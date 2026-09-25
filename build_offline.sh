#!/usr/bin/env bash
# Genera la versió sense connexió de la web: docencia-offline.zip
set -euo pipefail
cd "$(dirname "$0")"
OFFLINE=true mkdocs build --strict --site-dir site-offline
rm -f docencia-offline.zip
(cd site-offline && zip -qr ../docencia-offline.zip .)
rm -rf site-offline
echo "Creat: docencia-offline.zip (obre index.html)"
