@echo off

setlocal EnableDelayedExpansion

set MOD_NAME=%~1
set WARNO_MODS_FOLDER=%~2
set NDF_PARSE_SOURCE_MOD_NAME=%~3
set USER_MOD_CONFIG_FOLDER=%~4
set DEBUG_MODE=%~5

echo *** Debugging output:
echo MOD_NAME %MOD_NAME%
echo WARNO_MODS_FOLDER %WARNO_MODS_FOLDER%
echo NDF_PARSE_SOURCE_MOD_NAME %NDF_PARSE_SOURCE_MOD_NAME%
echo USER_MOD_CONFIG_FOLDER %USER_MOD_CONFIG_FOLDER%
echo DEBUG_MODE %DEBUG_MODE%
echo.

for /f "usebackq tokens=1,2 eol=; delims==" %%G in ("%USER_MOD_CONFIG_FOLDER%\%MOD_NAME%\Config.ini") do (
  rem clear from previous loop iterations:
  set VALUE=
  
  for /f "tokens=1 delims= " %%I in ("%%G") do set "KEY=%%I"
  for /f "tokens=1 delims= " %%I in ("%%H") do set "VALUE=%%I"
  set "!KEY!=!VALUE!"
)

echo *** Mod version: %Version%
echo *** Gameversion mod was generated for: %ModGenVersion%

set PYTHON_SCRIPT_LOCATION="%~dp0..\parse\%MOD_NAME%"

poetry run python %PYTHON_SCRIPT_LOCATION%\modify_values.py "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" %DEBUG_MODE%
set RETURN=%ERRORLEVEL%

if %RETURN% equ 0 (
  echo.
  echo *** Successfully edited mod files - would you like to update your mod?
  
  set "MY_MOD_FOLDER=%WARNO_MODS_FOLDER%\%MOD_NAME%"
  
  rem pushd and popd set current directory to MY_MOD_FOLDER and back, respectively
  pushd !MY_MOD_FOLDER!
  call UpdateMod.bat
  popd
  
  exit /b
)

echo.
echo Errorlevel "%RETURN%"
exit /b
