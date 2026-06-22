@echo off
REM Reinicia el contenedor de PostgreSQL sin borrar datos.
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

echo.
echo Reiniciando el contenedor de PostgreSQL (sin tocar los datos)...
echo [run] %DC% restart postgres
%DC% restart postgres
if errorlevel 1 (
  echo [ERROR] compose restart fallo. Revisa el mensaje arriba.
  exit /b 1
)
echo [OK] PostgreSQL reiniciado.
