#!/usr/bin/env bash
# Levanta PostgreSQL en segundo plano y espera a que esté sano.
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

echo "Levantando PostgreSQL..."
$DC up -d postgres
echo "Esperando a que la BD esté lista..."
$DC exec -T postgres sh -c 'until pg_isready -U "'"$POSTGRES_USER"'" -d "'"$POSTGRES_DB"'"; do sleep 1; done'
echo "PostgreSQL listo en localhost:${POSTGRES_PORT:-5432} (db: $POSTGRES_DB)."
