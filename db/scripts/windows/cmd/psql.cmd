@echo off
REM Abre una shell psql interactiva dentro del contenedor.
REM Argumentos extra se pasan a psql, p.ej.: psql.cmd -c "SELECT version();"
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

echo.
echo Abriendo psql en el contenedor (db: %POSTGRES_DB%, usuario: %POSTGRES_USER%)...
echo [run] %DC% exec postgres psql -U %POSTGRES_USER% -d %POSTGRES_DB% %*
%DC% exec postgres psql -U %POSTGRES_USER% -d %POSTGRES_DB% %*
