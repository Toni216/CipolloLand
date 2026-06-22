@echo off
REM Levanta PostgreSQL en segundo plano y espera a que este sano.
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

echo.
echo [paso 1/3] Levantando el contenedor de PostgreSQL...
echo [run] %DC% up -d postgres
%DC% up -d postgres
if errorlevel 1 (
  echo [ERROR] No se pudo levantar el contenedor. Revisa el mensaje de compose arriba.
  exit /b 1
)

echo.
echo [paso 2/3] Esperando a que la BD acepte conexiones (pg_isready)...
%DC% exec -T postgres sh -c "until pg_isready -U %POSTGRES_USER% -d %POSTGRES_DB%; do echo '  ...aun no lista'; sleep 1; done"

echo.
echo [paso 3/3] Estado y ultimos logs del contenedor:
echo [run] %DC% ps
%DC% ps
echo --- ultimas lineas de log (incluye la ejecucion de init/*.sql si fue primer arranque) ---
%DC% logs --tail 30 postgres

echo.
echo [OK] PostgreSQL listo en localhost:%POSTGRES_PORT%  (db: %POSTGRES_DB%, usuario: %POSTGRES_USER%).
