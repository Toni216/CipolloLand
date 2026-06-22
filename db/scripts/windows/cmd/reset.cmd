@echo off
REM DESTRUCTIVO: borra el volumen de datos y recrea la BD desde cero.
REM Al recrearse con el volumen vacio, Postgres ejecuta init\*.sql en orden (00, 01, ...).
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

echo.
echo ATENCION: esto BORRA todos los datos de la base '%POSTGRES_DB%'.
set /p ans="Escribe 'si' para confirmar: "
if /i not "%ans%"=="si" (
  echo Cancelado.
  exit /b 0
)

echo.
echo [paso 1/4] Bajando contenedores y BORRANDO el volumen de datos...
echo [run] %DC% down -v
%DC% down -v
if errorlevel 1 (
  echo [ERROR] compose down -v fallo. Revisa el mensaje arriba.
  exit /b 1
)

echo.
echo [paso 2/4] Levantando PostgreSQL (volumen vacio = se ejecutan init\*.sql)...
echo [run] %DC% up -d postgres
%DC% up -d postgres
if errorlevel 1 (
  echo [ERROR] No se pudo levantar el contenedor. Revisa el mensaje arriba.
  exit /b 1
)

echo.
echo [paso 3/4] Esperando a que la BD acepte conexiones (pg_isready)...
%DC% exec -T postgres sh -c "until pg_isready -U %POSTGRES_USER% -d %POSTGRES_DB%; do echo '  ...aun no lista'; sleep 1; done"

echo.
echo [paso 4/4] Logs de inicializacion (debe verse la ejecucion de init/00-init.sql y 01-schema.sql):
%DC% logs --tail 50 postgres

echo.
echo [OK] BD recreada desde cero. El esquema se aplico desde init\*.sql.
echo      (Verifica las tablas con: psql.cmd -c "\dt")
