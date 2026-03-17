setlocal
set MOD_NAME=%~1
set "MY_MOD_FOLDER=%WARNO_MODS_FOLDER%\%MOD_NAME%"

echo.
echo +++ Uploading Mod %MOD_NAME% to Steam Workshop

pushd %MY_MOD_FOLDER%
call UploadMod.bat
popd

endlocal
exit /b
