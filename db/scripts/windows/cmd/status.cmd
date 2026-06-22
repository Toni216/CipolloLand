@echo off
REM Muestra el estado de los contenedores del stack de BD.
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

echo.
echo Estado de los contenedores del stack 'cipolloland-db':
echo [run] %DC% ps
%DC% ps
