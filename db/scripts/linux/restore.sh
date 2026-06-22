#!/usr/bin/env bash
# DESTRUCTIVO: restaura la BD desde un volcado .sql. Uso: ./restore.sh <archivo.sql>
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

file="${1:-}"
if [ -z "$file" ] || [ ! -f "$file" ]; then
  echo "Uso: ./restore.sh <archivo.sql>" >&2
  echo "Backups disponibles:" >&2
  ls -1 "$DB_DIR/backups"/*.sql 2>/dev/null || echo "  (ninguno)" >&2
  exit 1
fi

echo "ATENCIÓN: esto sobrescribe los datos de '$POSTGRES_DB' con: $file"
printf "Escribe 'si' para confirmar: "
read -r ans
[ "$ans" = "si" ] || { echo "Cancelado."; exit 0; }

$DC exec -T postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" < "$file"
echo "Restauración completada."
