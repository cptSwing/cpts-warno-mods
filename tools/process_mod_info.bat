@echo off
setlocal EnableDelayedExpansion
set MOD_NAME=%~1
 
if "%DEBUG_MODE%"=="True" (
  echo.
  echo +++ Debugging output of process_mod_info.bat:
  echo + MOD_NAME: %MOD_NAME%
  echo + WARNO_MODS_FOLDER: %WARNO_MODS_FOLDER%
  echo + NDF_PARSE_SOURCE_MOD_NAME: %NDF_PARSE_SOURCE_MOD_NAME%
  echo + USER_MOD_CONFIG_FOLDER: %USER_MOD_CONFIG_FOLDER%
  echo.
)

set "CONFIG_FILE=%USER_MOD_CONFIG_FOLDER%\%MOD_NAME%\Config.ini"
call get_mod_config_values.bat "%CONFIG_FILE%"

echo +++ Mod version: %Version%
echo +++ Gameversion this mod was generated for: %ModGenVersion%
echo.

echo +++ executing ndf_parse
set "PYTHON_SCRIPT_LOCATION=%~dp0..\mods\%MOD_NAME%"
poetry run python %PYTHON_SCRIPT_LOCATION%\modify_values.py "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" %DEBUG_MODE%
set RETURN=%ERRORLEVEL%

if %RETURN% equ 0 (
  if "%DEBUG_MODE%"=="True" (
    echo.
    echo ndf_parse executed successfully, exiting since DEBUG_MODE == True
    echo.
  ) else (
    echo.
    echo +++ ^(Re-^)Generating Mod

    set "MY_MOD_FOLDER=%WARNO_MODS_FOLDER%\%MOD_NAME%"
    pushd !MY_MOD_FOLDER!
    call GenerateMod.bat
    call :update_version
    
    choice /C YN /M "+++ Successfully edited mod files - would you like to upload your mod? "
    echo.
    set CHOICE=!ERRORLEVEL!

    if !CHOICE! equ 1 (
      echo +++ Uploading !MY_MOD_FOLDER!
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
set "TEMP_CONFIG=%CONFIG_FILE%.tmp"
set /a Version+=1
echo +++ New Mod Version: %Version%

(
  for /f "usebackq delims=" %%I in ("%CONFIG_FILE%") do (
      set "LINE=%%I"
      
      if /i "!LINE:~0,7!"=="Version" (
          echo Version = !Version!
      ) else (
          echo !LINE!
      )
  )
) > "%TEMP_CONFIG%"

move /y "%TEMP_CONFIG%" "%CONFIG_FILE%" >nul
exit /b
