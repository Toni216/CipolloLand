# Levanta PostgreSQL en segundo plano y espera a que esté sano.
. (Join-Path $PSScriptRoot "_common.ps1")

Write-Host "Levantando PostgreSQL..."
Invoke-DC up -d postgres
Write-Host "Esperando a que la BD esté lista..."
Invoke-DC exec -T postgres sh -c "until pg_isready -U $Script:PgUser -d $Script:PgDb; do sleep 1; done"
Write-Host "PostgreSQL listo en localhost:$Script:PgPort (db: $Script:PgDb)."
