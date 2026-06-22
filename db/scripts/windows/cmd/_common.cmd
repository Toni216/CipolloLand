@echo off
REM ============================================================================
REM Helpers compartidos por los scripts CMD. Llamar con: call "%~dp0_common.cmd"
REM Hace: ubicar db/, cargar .env, elegir el binario de compose (DC) y comprobar
REM que Docker responde (preflight). Deja DOCKER_OK=1 si todo va bien.
REM Cada script debe, tras el call, hacer:  if not "%DOCKER_OK%"=="1" exit /b 1
REM ============================================================================

REM db/ = tres niveles por encima de scripts\windows\cmd\
for %%I in ("%~dp0..\..\..") do set "DBDIR=%%~fI"
cd /d "%DBDIR%"

REM Defaults (se sobrescriben con .env si existe).
set "POSTGRES_USER=cipolloland"
set "POSTGRES_DB=cipolloland"
set "POSTGRES_PORT=5432"
set "ADMINER_PORT=8080"

if exist "%DBDIR%\.env" (
  echo [diag] Cargando variables de "%DBDIR%\.env"
  for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%DBDIR%\.env") do (
    if not "%%A"=="" set "%%A=%%B"
  )
) else (
  echo [diag] No hay .env; usando valores por defecto. ^(copia .env.example a .env^)
)

REM docker compose v2 con fallback a docker-compose v1.
docker compose version >nul 2>&1
if %errorlevel%==0 (
  set "DC=docker compose"
) else (
  set "DC=docker-compose"
)

echo [diag] Carpeta db : %DBDIR%
echo [diag] Compose     : %DC%
echo [diag] BD / usuario: %POSTGRES_DB% / %POSTGRES_USER%   ^(puerto %POSTGRES_PORT%^)

REM ── Preflight: comprobar que el daemon de Docker responde ──────────────────
echo [diag] Comprobando que Docker responde...
docker version >nul 2>&1
if errorlevel 1 (
  echo.
  echo [ERROR] Docker no responde. El engine de Docker Desktop no esta accesible.
  echo         Causas habituales:
  echo           - Docker Desktop no esta arrancado o aun esta iniciando.
  echo             Espera a que el icono de la ballena este ESTABLE.
  echo           - Modo de contenedores en "Windows" en vez de "Linux".
  echo           - Desfase de version CLI/engine ^(error 500 / API v1.5x^):
  echo             actualiza Docker Desktop a la ultima version.
  echo         Workaround temporal antes de reintentar:
  echo             set DOCKER_API_VERSION=1.44
  echo.
  set "DOCKER_OK=0"
) else (
  echo [diag] Docker OK.
  set "DOCKER_OK=1"
)
