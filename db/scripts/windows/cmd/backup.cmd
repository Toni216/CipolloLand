@echo off
REM Vuelca la BD a backups\ con marca de tiempo. Opcional: ruta de archivo como %1.
call "%~dp0_common.cmd"
if not "%DOCKER_OK%"=="1" exit /b 1

if not "%~1"=="" (
  set "OUTFILE=%~1"
) else (
  for /f "tokens=1-4 delims=/-: " %%a in ("%date% %time%") do set "STAMP=%%a%%b%%c-%%d"
  set "OUTFILE=%DBDIR%\backups\%POSTGRES_DB%-%STAMP%.sql"
)

echo.
echo Volcando la BD '%POSTGRES_DB%' a:
echo   %OUTFILE%
echo [run] %DC% exec -T postgres pg_dump -U %POSTGRES_USER% -d %POSTGRES_DB% --clean --if-exists
%DC% exec -T postgres pg_dump -U %POSTGRES_USER% -d %POSTGRES_DB% --clean --if-exists > "%OUTFILE%"
if errorlevel 1 (
  echo [ERROR] pg_dump fallo. El archivo de salida puede estar incompleto.
  exit /b 1
)
echo [OK] Backup completado: %OUTFILE%
