#!/usr/bin/env bash
# Para los contenedores conservando los datos (volumen intacto).
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

echo "Parando contenedores (los datos se conservan)..."
$DC down
echo "Hecho."
