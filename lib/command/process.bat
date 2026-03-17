setlocal EnableDelayedExpansion
set "MOD_NAME=%~1"

echo +++ Modifying game files for %MOD_NAME% using ndf_parse()
echo.

set "PYTHON_SCRIPT_LOCATION=%cd%\..\python"
call poetry run python %PYTHON_SCRIPT_LOCATION%\setup_parsing.py "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%MOD_NAME%" %DEBUG_MODE%
set PYTHON_RETURN=%ERRORLEVEL%

if %PYTHON_RETURN% equ 0 (
  echo.
  call generate.bat "%MOD_NAME%"
  
  if "%DEBUG_MODE%"=="ON" (
    echo.
    echo ndf_parse executed successfully, exiting since DEBUG_MODE == True
    ) else (
    call update_config.bat "%MOD_NAME%"
    
    choice /C yN /T:5 /D N /M "+++ Generated mod files & updated Config.ini version - Would you like to upload your %MOD_NAME% to Steam? "
    set UPLOAD_CHOICE=!ERRORLEVEL!
    if !UPLOAD_CHOICE! equ 1 (
      call upload.bat "%MOD_NAME%"
    )
    
    choice /C yN /T:5 /D N /M "+++ Would you like to launch the Game with %MOD_NAME% (dev mode)? "
    set LAUNCH_CHOICE=!ERRORLEVEL!
    if !LAUNCH_CHOICE! equ 1 (
      call launch.bat "%MOD_NAME%"
    )
  )
  ) else (
  echo.
  echo --- Errorlevel "%PYTHON_RETURN%"
)

endlocal
exit /b
