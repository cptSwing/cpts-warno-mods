setlocal EnableDelayedExpansion
set MOD_NAME=%~1
set "CONFIG_FILE=%USER_MOD_CONFIG_FOLDER%\%MOD_NAME%\Config.ini"

call get_mod_config_values.bat "%CONFIG_FILE%"
set GET_MOD_CONFIG_ERROR_LEVEL=%ERRORLEVEL%
if %GET_MOD_CONFIG_ERROR_LEVEL% equ 0 (
  set /a THIS_MOD_VERSION=%Version%+1
)

echo +++ New Mod Version: %THIS_MOD_VERSION%

set "TEMP_CONFIG=%CONFIG_FILE%.tmp"

(
for /f "usebackq delims=" %%I in ("%CONFIG_FILE%") do (
  set "LINE=%%I"
  if /i "!LINE:~0,7!"=="Version" (
    echo Version = %THIS_MOD_VERSION%
    ) else (
    echo !LINE!
  )
)
) > "%TEMP_CONFIG%"

move /y "%TEMP_CONFIG%" "%CONFIG_FILE%" >nul

endlocal
exit /b
