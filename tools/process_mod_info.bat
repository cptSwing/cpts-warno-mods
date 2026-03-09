@echo off

setlocal EnableDelayedExpansion

set MOD_NAME=%~1
set WARNO_MODS_FOLDER=%~2
set NDF_PARSE_SOURCE_MOD_NAME=%~3
set USER_MOD_CONFIG_FOLDER=%~4
set DEBUG_MODE=%~5

set "CONFIG_FILE=%USER_MOD_CONFIG_FOLDER%\%MOD_NAME%\Config.ini"
set "TEMP_CONFIG=%CONFIG_FILE%.tmp"

echo *** Debugging output:
echo MOD_NAME %MOD_NAME%
echo WARNO_MODS_FOLDER %WARNO_MODS_FOLDER%
echo NDF_PARSE_SOURCE_MOD_NAME %NDF_PARSE_SOURCE_MOD_NAME%
echo USER_MOD_CONFIG_FOLDER %USER_MOD_CONFIG_FOLDER%
echo DEBUG_MODE %DEBUG_MODE%
echo.

for /f "usebackq tokens=1,2 eol=; delims==" %%G in ("%CONFIG_FILE%") do (
  rem clear from previous loop iterations:
  set VALUE=
  
  for /f "tokens=1 delims= " %%I in ("%%G") do set "KEY=%%I"
  for /f "tokens=1 delims= " %%I in ("%%H") do set "VALUE=%%I"
  set "!KEY!=!VALUE!"
)

echo *** Mod version: %Version%
echo *** Gameversion this mod was generated for: %ModGenVersion%

set PYTHON_SCRIPT_LOCATION="%~dp0..\mods\%MOD_NAME%"

poetry run python %PYTHON_SCRIPT_LOCATION%\modify_values.py "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" %DEBUG_MODE%
set RETURN=%ERRORLEVEL%

if %RETURN% equ 0 (
  if "%DEBUG_MODE%"=="True" (
    echo.
    echo ndf_parse executed successfully, exiting since DEBUG_MODE == True
    echo.
  ) else (
    echo.
    echo *** ^(Re-^)Generating Mod

    set "MY_MOD_FOLDER=%WARNO_MODS_FOLDER%\%MOD_NAME%"
    pushd !MY_MOD_FOLDER!
    call GenerateMod.bat
    call :update_version
    
    choice /C YN /M "*** Successfully edited mod files - would you like to upload your mod? "
    echo.
    set CHOICE=!ERRORLEVEL!

    if !CHOICE! equ 1 (
      echo *** Uploading !MY_MOD_FOLDER!
      echo.
      call UploadMod.bat
    )

    popd
  )

  exit /b
)

echo.
echo Errorlevel "%RETURN%"
exit /b


:update_version
set /a Version+=1
echo *** New Mod Version: %Version%

(
  for /f "usebackq delims=" %%L in ("%CONFIG_FILE%") do (
      set "line=%%L"
      
      if /i "!line:~0,7!"=="Version" (
          echo Version = !Version!
      ) else (
          echo !line!
      )
  )
) > "%TEMP_CONFIG%"

move /y "%TEMP_CONFIG%" "%CONFIG_FILE%" >nul
exit /b
