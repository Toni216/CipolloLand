@echo off
REM Para los contenedores conservando los datos (volumen intacto).
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

echo.
echo Parando contenedores (los datos del volumen se CONSERVAN)...
echo [run] %DC% down
%DC% down
if errorlevel 1 (
  echo [ERROR] compose down fallo. Revisa el mensaje arriba.
  exit /b 1
)
echo [OK] Contenedores parados. El volumen de datos sigue intacto.
