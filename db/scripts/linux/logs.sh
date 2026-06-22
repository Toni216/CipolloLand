#!/usr/bin/env bash
# Sigue los logs de PostgreSQL (Ctrl+C para salir).
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

$DC logs -f postgres
