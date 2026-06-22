#!/usr/bin/env bash
# Vuelca la BD a backups/ con marca de tiempo. Opcional: nombre de archivo como $1.
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

ts="$(date +%Y%m%d-%H%M%S)"
file="${1:-$DB_DIR/backups/${POSTGRES_DB}-${ts}.sql}"

echo "Volcando '$POSTGRES_DB' a: $file"
$DC exec -T postgres pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists > "$file"
echo "Backup completado ($(wc -c < "$file") bytes)."
