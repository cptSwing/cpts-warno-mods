@echo off

rem change working directory to directory where script resides
cd /d "%~dp0"

set DEBUG_MODE=ON
call :get_config_env_variables
set MOD_NAMES="%NDF_PARSE_SOURCE_MOD_NAME%","DoubleSupply","TripleSupply","YIMBY"
call :validate_mods_folders
call :validate_mods_config_folders

:main
call :menu
setlocal EnableDelayedExpansion
set LOOP_INDEX=0
for %%I in (%MOD_NAMES:,= %) do (
  set /a LOOP_INDEX=!LOOP_INDEX!+1
  if %MENU_CHOICE% equ !LOOP_INDEX! (
    if "%%~I"=="%NDF_PARSE_SOURCE_MOD_NAME%" (
      call create_new_mod.bat "%NDF_PARSE_SOURCE_MOD_NAME%"
      call generate_mod.bat "%NDF_PARSE_SOURCE_MOD_NAME%"
    ) else (
      call process_mod_info.bat "%%~I"
    )
    goto main
  )
)
if %MENU_CHOICE% equ 5 call :toggledebug & goto main
if %MENU_CHOICE% equ 6 goto end
endlocal
goto end


:menu
setlocal EnableDelayedExpansion
call :get_mods_versions
echo.
echo *** MAIN MENU ***
echo =================
echo Select an option:
echo.
set LOOP_INDEX=0
for %%I in (%MOD_NAMES:,= %) do (
  set /a LOOP_INDEX=!LOOP_INDEX!+1
  call set "THIS_MOD_GEN_VERSION=%%%%~I_MOD_GEN_VERSION%%"
  call set "THIS_MOD_VERSION=%%%%~I_MOD_VERSION%%"

  if "!THIS_MOD_GEN_VERSION!"=="" (
    echo !LOOP_INDEX!: Generate %%~I ^(also adds Config file^)
  ) else (
    if !THIS_MOD_VERSION!==0 (
      set "VERSION_STRING=New"
    ) else (
      set "VERSION_STRING=Version !THIS_MOD_VERSION!"
    )
    echo !LOOP_INDEX!: Re-Generate %%~I ^(!VERSION_STRING!, ModGenVersion !THIS_MOD_GEN_VERSION!^)
  )

  if "%%~I"=="%NDF_PARSE_SOURCE_MOD_NAME%" (
    echo    ALWAYS do this before any of the following updates^^!
    echo -----------------
  )
)
echo -----------------
echo D: Toggle Debug Mode (currently %DEBUG_MODE%)
echo -----------------
echo X: Exit
echo.
endlocal
choice /C 1234DX /M "Select an option "
set MENU_CHOICE=%ERRORLEVEL%
echo.
exit /b



:get_config_env_variables
call get_mod_config_values.bat "%~dp0..\config.env"
if "%WARNO_MODS_FOLDER%"=="" echo --- Error: WARNO_MODS_FOLDER is not defined in config.env^^! & goto end
if "%NDF_PARSE_SOURCE_MOD_NAME%"=="" echo --- Error: NDF_PARSE_SOURCE_MOD_NAME is not defined in config.env^^! & goto end
if "%USER_MOD_CONFIG_FOLDER%"=="" echo --- Error: USER_MOD_CONFIG_FOLDER is not defined in config.env^^! & goto end
if "%DEBUG_MODE%"=="ON" (
  echo.
  echo +++ Debugging output of :get_config_env_variables
  echo + WARNO Mods folder: [%WARNO_MODS_FOLDER%]
  echo + Source mod name:   [%NDF_PARSE_SOURCE_MOD_NAME%]
  echo + Mod Config folder: [%USER_MOD_CONFIG_FOLDER%]
  echo.
)
exit /b



:validate_mods_folders
for %%I in (%MOD_NAMES:,= %) do (
  if not exist "%WARNO_MODS_FOLDER%\%%~I\" (
    echo --- Error: %%~I does not exist at %WARNO_MODS_FOLDER%\ - CREATING mod ...
    call create_new_mod.bat "%%~I"
  )
)
exit /b



:validate_mods_config_folders
setlocal EnableDelayedExpansion
set "EXPORTS="
for %%I in (%MOD_NAMES:,= %) do (
  if not exist "%USER_MOD_CONFIG_FOLDER%\%%~I\" (
    choice /C yN  /T 5 /D N /M "*** WARNING: Config file location for %%~I does not exist - Would you like to GENERATE your mod? (Defaults to N after 5 seconds) "
    set GENERATE_MOD_CHOICE=!ERRORLEVEL!
    if !GENERATE_MOD_CHOICE! equ 1 (
      call generate_mod.bat "%%~I"
    ) else (
      rem set variable to undefined
      set "EXPORTS=!EXPORTS! & set "%%~I_MOD_GEN_VERSION=""
    )
  )
)
endlocal %EXPORTS%
exit /b



:get_mods_versions
setlocal EnableDelayedExpansion
set "EXPORTS="
for %%I in (%MOD_NAMES:,= %) do (
  set "MOD_CONFIG_FILE=%USER_MOD_CONFIG_FOLDER%\%%~I\Config.ini"
  call get_mod_config_values.bat "!MOD_CONFIG_FILE!"
  set GET_MOD_CONFIG_ERROR_LEVEL=!ERRORLEVEL!
  if !GET_MOD_CONFIG_ERROR_LEVEL! equ 0 (
    set "EXPORTS=!EXPORTS! & set "%%~I_MOD_VERSION=!Version!" & set "%%~I_MOD_GEN_VERSION=!ModGenVersion!""
  )
)
endlocal %EXPORTS%
exit /b



:toggledebug
if "%DEBUG_MODE%"=="ON" (
  set "DEBUG_MODE=OFF"
  ) else (
  set "DEBUG_MODE=ON"
)
echo +++ Debug set to %DEBUG_MODE%
echo.
exit /b



:end
echo +++ Exiting
endlocal
exit /b
