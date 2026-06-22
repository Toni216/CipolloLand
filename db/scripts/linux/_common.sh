#!/usr/bin/env bash
# Helpers compartidos por los scripts de Linux/macOS.
# Se ubica el directorio `db/` (dos niveles por encima de este archivo) y se opera
# siempre desde ahí, para que docker compose use el .env y el yml correctos.
set -euo pipefail

DB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$DB_DIR"

# Carga variables de .env si existe (sin pisar las ya exportadas en el entorno).
if [ -f "$DB_DIR/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  . "$DB_DIR/.env"
  set +a
fi

POSTGRES_USER="${POSTGRES_USER:-cipolloland}"
POSTGRES_DB="${POSTGRES_DB:-cipolloland}"

# Elige `docker compose` (v2) o `docker-compose` (v1).
if docker compose version >/dev/null 2>&1; then
  DC="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
else
  echo "ERROR: no se encontró 'docker compose' ni 'docker-compose'." >&2
  exit 1
fi
