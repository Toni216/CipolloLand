# Reinicia el contenedor de PostgreSQL sin borrar datos.
. (Join-Path $PSScriptRoot "_common.ps1")

Write-Host "Reiniciando PostgreSQL..."
Invoke-DC restart postgres
Write-Host "Hecho."
