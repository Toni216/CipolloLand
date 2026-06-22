# DESTRUCTIVO: borra el volumen de datos y recrea la BD desde cero.
. (Join-Path $PSScriptRoot "_common.ps1")

Write-Host "ATENCION: esto BORRA todos los datos de la base '$Script:PgDb'." -ForegroundColor Yellow
$ans = Read-Host "Escribe 'si' para confirmar"
if ($ans -ne "si") { Write-Host "Cancelado."; return }

Invoke-DC down -v
Invoke-DC up -d postgres
Write-Host "Esperando a que la BD esté lista..."
Invoke-DC exec -T postgres sh -c "until pg_isready -U $Script:PgUser -d $Script:PgDb; do sleep 1; done"
Write-Host "BD recreada desde cero. Recuerda aplicar migraciones: pnpm prisma migrate dev"
