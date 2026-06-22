@echo off
REM DESTRUCTIVO: restaura la BD desde un volcado .sql. Uso: restore.cmd <archivo.sql>
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

if "%~1"=="" goto :usage
if not exist "%~1" goto :usage

echo.
echo ATENCION: esto SOBRESCRIBE los datos de '%POSTGRES_DB%' con el contenido de:
echo   %~1
set /p ans="Escribe 'si' para confirmar: "
if /i not "%ans%"=="si" (
  echo Cancelado.
  exit /b 0
)

echo.
echo Restaurando...
echo [run] %DC% exec -T postgres psql -U %POSTGRES_USER% -d %POSTGRES_DB% ^< "%~1"
%DC% exec -T postgres psql -U %POSTGRES_USER% -d %POSTGRES_DB% < "%~1"
if errorlevel 1 (
  echo [ERROR] La restauracion fallo. Revisa el mensaje de psql arriba.
  exit /b 1
)
echo [OK] Restauracion completada desde: %~1
exit /b 0

:usage
echo Uso: restore.cmd ^<archivo.sql^>
echo Backups disponibles en %DBDIR%\backups:
dir /b "%DBDIR%\backups\*.sql" 2>nul || echo   (ninguno)
exit /b 1
