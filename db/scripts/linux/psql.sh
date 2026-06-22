#!/usr/bin/env bash
# Abre una shell psql interactiva dentro del contenedor.
# Pasa argumentos extra a psql, p.ej.: ./psql.sh -c "SELECT version();"
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

$DC exec postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" "$@"
