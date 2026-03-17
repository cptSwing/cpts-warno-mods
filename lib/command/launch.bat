setlocal
set MOD_NAME=%~1
set "MY_MOD_FOLDER=%WARNO_MODS_FOLDER%\%MOD_NAME%"

echo.
echo +++ Launching %MOD_NAME%

pushd %MY_MOD_FOLDER%
call LaunchGameDevMode.bat
popd

endlocal
exit /b
