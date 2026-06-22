#!/usr/bin/env bash
# Muestra el estado de los contenedores del stack de BD.
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

$DC ps
