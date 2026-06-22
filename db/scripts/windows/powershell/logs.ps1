# Sigue los logs de PostgreSQL (Ctrl+C para salir).
. (Join-Path $PSScriptRoot "_common.ps1")

Invoke-DC logs -f postgres
