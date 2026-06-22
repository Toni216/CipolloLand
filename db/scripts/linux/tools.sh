#!/usr/bin/env bash
# Levanta la GUI Adminer (perfil "tools"). Acceso: http://localhost:${ADMINER_PORT:-8080}
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

$DC --profile tools up -d
echo "Adminer en http://localhost:${ADMINER_PORT:-8080}  (servidor: postgres, usuario: $POSTGRES_USER)"
