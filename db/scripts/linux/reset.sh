#!/usr/bin/env bash
# DESTRUCTIVO: borra el volumen de datos y recrea la BD desde cero.
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

echo "ATENCIÓN: esto BORRA todos los datos de la base '$POSTGRES_DB'."
printf "Escribe 'si' para confirmar: "
read -r ans
if [ "$ans" != "si" ]; then
  echo "Cancelado."
  exit 0
fi

$DC down -v
$DC up -d postgres
echo "Esperando a que la BD esté lista..."
$DC exec -T postgres sh -c 'until pg_isready -U "'"$POSTGRES_USER"'" -d "'"$POSTGRES_DB"'"; do sleep 1; done'
echo "BD recreada desde cero. Recuerda aplicar migraciones: pnpm prisma migrate dev"
