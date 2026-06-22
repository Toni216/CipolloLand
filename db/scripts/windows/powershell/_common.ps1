# Helpers compartidos por los scripts de PowerShell.
# Ubica la carpeta `db/` y carga el .env, para que docker compose use el yml correcto.
$ErrorActionPreference = "Stop"

$Script:DbDir = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
Set-Location $Script:DbDir

# Carga .env (KEY=VALUE) en variables de entorno del proceso.
$envFile = Join-Path $Script:DbDir ".env"
if (Test-Path $envFile) {
  Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
      $k, $v = $line.Split("=", 2)
      [Environment]::SetEnvironmentVariable($k.Trim(), $v.Trim())
    }
  }
}

$Script:PgUser = if ($env:POSTGRES_USER) { $env:POSTGRES_USER } else { "cipolloland" }
$Script:PgDb   = if ($env:POSTGRES_DB)   { $env:POSTGRES_DB }   else { "cipolloland" }
$Script:PgPort = if ($env:POSTGRES_PORT) { $env:POSTGRES_PORT } else { "5432" }

# docker compose v2 ('docker compose') con fallback a v1 ('docker-compose').
docker compose version *> $null
if ($LASTEXITCODE -eq 0) {
  function Invoke-DC { docker compose @args }
} elseif (Get-Command docker-compose -ErrorAction SilentlyContinue) {
  function Invoke-DC { docker-compose @args }
} else {
  Write-Error "No se encontró 'docker compose' ni 'docker-compose'."
}
