# Vuelca la BD a backups/ con marca de tiempo. Opcional: ruta de archivo como argumento.
param([string]$OutFile)
. (Join-Path $PSScriptRoot "_common.ps1")

if (-not $OutFile) {
  $ts = Get-Date -Format "yyyyMMdd-HHmmss"
  $OutFile = Join-Path $Script:DbDir "backups\$($Script:PgDb)-$ts.sql"
}

Write-Host "Volcando '$Script:PgDb' a: $OutFile"
Invoke-DC exec -T postgres pg_dump -U $Script:PgUser -d $Script:PgDb --clean --if-exists |
  Out-File -FilePath $OutFile -Encoding utf8
Write-Host "Backup completado ($((Get-Item $OutFile).Length) bytes)."
