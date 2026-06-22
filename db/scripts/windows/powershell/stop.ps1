# Para los contenedores conservando los datos (volumen intacto).
. (Join-Path $PSScriptRoot "_common.ps1")

Write-Host "Parando contenedores (los datos se conservan)..."
Invoke-DC down
Write-Host "Hecho."
