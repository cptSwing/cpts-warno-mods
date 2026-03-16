@echo off
setlocal EnableDelayedExpansion
set MOD_NAME=%~1

echo +++ Modifying game files for %MOD_NAME% using ndf_parse()
echo.
set "PYTHON_SCRIPT_LOCATION=%~dp0..\mods\%MOD_NAME%"
poetry run python %PYTHON_SCRIPT_LOCATION%\modify_values.py "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" %DEBUG_MODE%
set PYTHON_RETURN=%ERRORLEVEL%

if %PYTHON_RETURN% equ 0 (
  echo.
  call generate_mod.bat "%MOD_NAME%"

  if "%DEBUG_MODE%"=="ON" (
    echo.
    echo ndf_parse executed successfully, exiting since DEBUG_MODE == True
  ) else (
    call update_mod_config.bat "%MOD_NAME%"
    choice /C yN /M "+++ Generated mod files & updated Config.ini version - Would you like to upload your mod? "
    set UPLOAD_CHOICE=!ERRORLEVEL!
    if !UPLOAD_CHOICE! equ 1 (
      call upload_mod.bat "%MOD_NAME%"
    )
  )

  exit /b
)

echo.
echo Errorlevel "%PYTHON_RETURN%"
endlocal
exit /b
