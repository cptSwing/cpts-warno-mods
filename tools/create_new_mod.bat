setlocal
set MOD_NAME=%~1
set "MY_MOD_FOLDER=%WARNO_MODS_FOLDER%\%MOD_NAME%"

if exist "%MY_MOD_FOLDER%\" (
  echo +++ "%MOD_NAME%" mod folder exists in %WARNO_MODS_FOLDER%, removing ...
  rd /s /q %MY_MOD_FOLDER%\
)

pushd %WARNO_MODS_FOLDER%
call CreateNewMod.bat "%MOD_NAME%"
popd

endlocal
exit /b
