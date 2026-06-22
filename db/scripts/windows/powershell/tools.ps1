# Levanta la GUI Adminer (perfil "tools"). Acceso: http://localhost:8080
. (Join-Path $PSScriptRoot "_common.ps1")

$port = if ($env:ADMINER_PORT) { $env:ADMINER_PORT } else { "8080" }
Invoke-DC --profile tools up -d
Write-Host "Adminer en http://localhost:$port  (servidor: postgres, usuario: $Script:PgUser)"
