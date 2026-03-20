@echo off
setlocal EnableDelayedExpansion
set MOD_NAMES="DoubleSupply","TripleSupply","YIMBY","Entrench"

rem change working directory to directory where script resides
cd /d "%~dp0"

call :get_config_env_variables
set WARNO_VERSION=0
pushd %WARNO_MODS_FOLDER%\..\Data\PC
for /D %%I in (*) do (
  if %%I gtr !WARNO_VERSION! set "WARNO_VERSION=%%I"
)
popd
call :validate_mods_folders
call :validate_mods_config_folders



:main
call :menu
set LOOP_MOD_INDEX=0
for %%I in (%MOD_NAMES:,= %) do (
  set /a LOOP_MOD_INDEX+=1
  if %MENU_CHOICE% equ !LOOP_MOD_INDEX! (
    pushd command
    call process.bat "%%~I"
    popd
    goto main
  )
)
set /a SOURCE_CHOICE=%LOOP_MOD_INDEX%+1
if %MENU_CHOICE% equ %SOURCE_CHOICE% (
  pushd command
  rem deletes, recreates, regenerates the source mod
  call create.bat "%NDF_PARSE_SOURCE_MOD_NAME%"
  rem call generate.bat "%NDF_PARSE_SOURCE_MOD_NAME%"
  popd
  goto main
)
set /a DEBUG_CHOICE=%LOOP_MOD_INDEX%+2
if %MENU_CHOICE% equ %DEBUG_CHOICE% goto toggledebug
set /a END_CHOICE=%LOOP_MOD_INDEX%+3
if %MENU_CHOICE% equ %END_CHOICE% goto end



:menu
setlocal EnableDelayedExpansion
call :get_mods_versions
echo.
echo *** MAIN MENU (Game Version: %WARNO_VERSION%) ***
echo ========================================
echo Select an option:
echo.
echo S: Re-Create %NDF_PARSE_SOURCE_MOD_NAME%
echo ALWAYS do this before any of the following updates^^!
echo ----------------------------------------
set LOOP_MOD_INDEX=0
for %%I in (%MOD_NAMES:,= %) do (
  set /a LOOP_MOD_INDEX+=1
  set MENU_VAR_!LOOP_MOD_INDEX!=!LOOP_MOD_INDEX!
  call set "THIS_MOD_GEN_VERSION=%%%%~I_MOD_GEN_VERSION%%"
  call set "THIS_MOD_VERSION=%%%%~I_MOD_VERSION%%"

  if "!THIS_MOD_GEN_VERSION!"=="" (
    echo !LOOP_MOD_INDEX!: Generate %%~I ^(also adds Config file^)
  ) else (
    if !THIS_MOD_VERSION!==0 (
      set "VERSION_STRING=New"
    ) else (
      set "VERSION_STRING=Version !THIS_MOD_VERSION!"
    )
    echo !LOOP_MOD_INDEX!: Re-Generate %%~I ^(!VERSION_STRING!, ModGenVersion !THIS_MOD_GEN_VERSION!^)
  )
)
echo ----------------------------------------
echo D: Toggle Debug Mode (currently %DEBUG_MODE%)
echo ----------------------------------------
echo X: Exit
echo.
endlocal & set DYNAMIC_CHOICE_PARAM=%MENU_VAR_1%%MENU_VAR_2%%MENU_VAR_3%%MENU_VAR_4%%MENU_VAR_5%%MENU_VAR_6%%MENU_VAR_7%%MENU_VAR_8%%MENU_VAR_9%SDX
choice /C %DYNAMIC_CHOICE_PARAM% /M "Select an option "
set MENU_CHOICE=%ERRORLEVEL%
exit /b



:get_config_env_variables
pushd command
call get_config.bat "%~dp0..\config.env"
popd
if "%WARNO_MODS_FOLDER%"=="" echo --- Error: WARNO_MODS_FOLDER is not defined in config.env^^! & goto end
if "%NDF_PARSE_SOURCE_MOD_NAME%"=="" echo --- Error: NDF_PARSE_SOURCE_MOD_NAME is not defined in config.env^^! & goto end
if "%USER_MOD_CONFIG_FOLDER%"=="" echo --- Error: USER_MOD_CONFIG_FOLDER is not defined in config.env^^! & goto end
if "%DEBUG_MODE%"=="ON" (
  echo.
  echo +++ Debugging output of :get_config_env_variables
  echo + WARNO Mods folder:  [%WARNO_MODS_FOLDER%]
  echo + Name of Source Mod: [%NDF_PARSE_SOURCE_MOD_NAME%]
  echo + Mod Config folder:  [%USER_MOD_CONFIG_FOLDER%]
  echo.
)
exit /b



:validate_mods_folders
set ALL_MOD_NAMES="%NDF_PARSE_SOURCE_MOD_NAME%","DoubleSupply","TripleSupply","YIMBY","Entrench"
for %%I in (%ALL_MOD_NAMES:,= %) do (
  if not exist "%WARNO_MODS_FOLDER%\%%~I\" (
    echo --- Error: %%~I does not exist at %WARNO_MODS_FOLDER%\ - CREATING mod ...
    pushd command
    call create.bat "%%~I"
    popd
  )
)
exit /b



:validate_mods_config_folders
setlocal EnableDelayedExpansion
set "EXPORTS="
for %%I in (%MOD_NAMES:,= %) do (
  if not exist "%USER_MOD_CONFIG_FOLDER%\%%~I\" (
    choice /C yN  /T 5 /D N /M "*** WARNING: Config file location for %%~I does not exist - GENERATE your mod (Without modifying files) ? "
    set GENERATE_MOD_CHOICE=!ERRORLEVEL!
    if !GENERATE_MOD_CHOICE! equ 1 (
      pushd command
      call generate.bat "%%~I"
      popd
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
  pushd command
  call get_config.bat "!MOD_CONFIG_FILE!" "OFF"
  popd
  set GET_MOD_CONFIG_ERROR_LEVEL=!ERRORLEVEL!
  if !GET_MOD_CONFIG_ERROR_LEVEL! equ 0 (
    set "EXPORTS=!EXPORTS! & set "%%~I_MOD_VERSION=!Version!" & set "%%~I_MOD_GEN_VERSION=!ModGenVersion!""
  )
)
endlocal %EXPORTS%
exit /b



:toggledebug
if "%DEBUG_MODE%"=="ON" (
  set DEBUG_MODE=OFF
) else (
  set DEBUG_MODE=ON
)
echo.
echo +++ Debug mode set to %DEBUG_MODE%
goto main



:end
echo.
echo +++ Exiting
endlocal
exit /b
