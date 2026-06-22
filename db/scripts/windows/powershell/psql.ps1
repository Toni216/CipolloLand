# Abre una shell psql interactiva dentro del contenedor.
# Argumentos extra se pasan a psql, p.ej.: .\psql.ps1 -c "SELECT version();"
. (Join-Path $PSScriptRoot "_common.ps1")

Invoke-DC exec postgres psql -U $Script:PgUser -d $Script:PgDb @args
