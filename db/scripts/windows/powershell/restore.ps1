# DESTRUCTIVO: restaura la BD desde un volcado .sql. Uso: .\restore.ps1 <archivo.sql>
param([string]$InFile)
. (Join-Path $PSScriptRoot "_common.ps1")

if (-not $InFile -or -not (Test-Path $InFile)) {
  Write-Host "Uso: .\restore.ps1 <archivo.sql>"
  Write-Host "Backups disponibles:"
  Get-ChildItem (Join-Path $Script:DbDir "backups\*.sql") -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "  $($_.Name)" }
  return
}

Write-Host "ATENCION: esto sobrescribe los datos de '$Script:PgDb' con: $InFile" -ForegroundColor Yellow
$ans = Read-Host "Escribe 'si' para confirmar"
if ($ans -ne "si") { Write-Host "Cancelado."; return }

Get-Content $InFile | Invoke-DC exec -T postgres psql -U $Script:PgUser -d $Script:PgDb
Write-Host "Restauración completada."
