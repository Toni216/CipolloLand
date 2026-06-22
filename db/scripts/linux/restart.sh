#!/usr/bin/env bash
# Reinicia el contenedor de PostgreSQL sin borrar datos.
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

echo "Reiniciando PostgreSQL..."
$DC restart postgres
echo "Hecho."
