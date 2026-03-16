setlocal
set MOD_NAME=%~1
set "MY_MOD_FOLDER=%WARNO_MODS_FOLDER%\%MOD_NAME%"

echo +++ ^(Re-^)Generating Mod %MOD_NAME%
echo.

pushd %MY_MOD_FOLDER%
call GenerateMod.bat
popd

endlocal
exit /b
