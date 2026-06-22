@echo off
REM Levanta la GUI Adminer (perfil "tools"). Acceso: http://localhost:8080
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

echo.
echo Levantando Adminer (GUI web de la BD, perfil "tools")...
echo [run] %DC% --profile tools up -d
%DC% --profile tools up -d
if errorlevel 1 (
  echo [ERROR] No se pudo levantar Adminer. Revisa el mensaje arriba.
  exit /b 1
)
echo [OK] Adminer en http://localhost:%ADMINER_PORT%
echo      Conexion: sistema=PostgreSQL, servidor=postgres, usuario=%POSTGRES_USER%, base=%POSTGRES_DB%
