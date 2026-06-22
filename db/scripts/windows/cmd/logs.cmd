@echo off
REM Sigue los logs de PostgreSQL en vivo (Ctrl+C para salir).
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

echo.
echo Siguiendo logs de PostgreSQL en vivo. Pulsa Ctrl+C para salir.
echo [run] %DC% logs -f postgres
%DC% logs -f postgres
