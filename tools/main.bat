@echo off

rem change working directory to directory where script resides
cd /d "%~dp0"

set DEBUG_MODE=True

call :get_config_env_variables
call :get_source_mod_gen_version
call :get_mod_versions

setlocal EnableDelayedExpansion
:main
call :menu

if %CHOICE% equ 1 (
  pushd %WARNO_MODS_FOLDER%
  if exist %WARNO_MODS_FOLDER%\%NDF_PARSE_SOURCE_MOD_NAME%\ (
    echo +++ "%NDF_PARSE_SOURCE_MOD_NAME%" mod exists, removing ...
    rd /s /q %WARNO_MODS_FOLDER%\%NDF_PARSE_SOURCE_MOD_NAME%\
  )
  
  call CreateNewMod.bat "%NDF_PARSE_SOURCE_MOD_NAME%"
  
  rem mod generation seems to be the only way to grab the current version number (from the generated "pristine" mod's Config.ini)
  pushd %NDF_PARSE_SOURCE_MOD_NAME%
  call GenerateMod.bat
  popd
  popd
  
  call :get_source_mod_gen_version

  goto main
)

if %CHOICE% equ 2 (
  set MOD_NAME=DoubleSupply
  call process_mod_info.bat "!MOD_NAME!"
  goto main
)

if %CHOICE% equ 3 (
  set MOD_NAME=TripleSupply
  call process_mod_info.bat "!MOD_NAME!"
  goto main
)

if %CHOICE% equ 4 (
  set MOD_NAME=YIMBY
  call process_mod_info.bat "!MOD_NAME!"
  goto main
)

if %CHOICE% equ 5 (
  set MOD_NAME=Debug
  call process_mod_info.bat "!MOD_NAME!"
  goto main
)

if %CHOICE% equ 6 call :toggledebug & goto main
if %CHOICE% equ 7 goto end
endlocal

:menu
echo MAIN MENU
echo =================
echo Select an option:
echo.
echo 1: Generate/Refresh "pristine" Source Mod - Do this before choosing any other option^^! (Source Mod-Gen-Version: [!SOURCE_MOD_GEN_VERSION!])
echo -----------------
echo 2: Generate/Update DoubleSupply (ModGenVersion !TripleSupply_MOD_GEN_VERSION!, Version !TripleSupply_VERSION!)
echo 3: Generate/Update TripleSupply (ModGenVersion !TripleSupply_MOD_GEN_VERSION!, Version !TripleSupply_VERSION!)
echo 4: Generate/Update YIMBY (ModGenVersion !TripleSupply_MOD_GEN_VERSION!, Version !TripleSupply_VERSION!)
echo 5: Test
echo -----------------
echo D: Toggle Debug Mode (currently %DEBUG_MODE%)
echo -----------------
echo X: Exit
echo.
choice /C 12345DX /M "Select an option "
set CHOICE=%ERRORLEVEL%
echo.
exit /b

:toggledebug
if %DEBUG_MODE%==True (
  set DEBUG_MODE=False
  ) else (
  set DEBUG_MODE=True
)
echo +++ Debug set to %DEBUG_MODE%
echo.
call :get_config_env_variables
exit /b

:get_config_env_variables
call get_mod_config_values.bat "%~dp0..\config.env"
if "%WARNO_MODS_FOLDER%"=="" echo --- Error: WARNO_MODS_FOLDER is not defined in config.env^^! & goto end
if "%NDF_PARSE_SOURCE_MOD_NAME%"=="" echo --- Error: NDF_PARSE_SOURCE_MOD_NAME is not defined in config.env^^! & goto end
if "%USER_MOD_CONFIG_FOLDER%"=="" echo --- Error: USER_MOD_CONFIG_FOLDER is not defined in config.env^^! & goto end

if "%DEBUG_MODE%"=="True" (
  echo.
  echo +++ Debugging output of :get_config_env_variables
  echo + WARNO Mods folder: [%WARNO_MODS_FOLDER%]
  echo + Source mod name: [%NDF_PARSE_SOURCE_MOD_NAME%]
  echo + Mod Config folder: [%USER_MOD_CONFIG_FOLDER%]
  echo.
)
exit /b

:get_source_mod_gen_version
set "SOURCE_MOD_CONFIG_FILE=%USER_MOD_CONFIG_FOLDER%\%NDF_PARSE_SOURCE_MOD_NAME%\Config.ini"
call get_mod_config_values.bat "%SOURCE_MOD_CONFIG_FILE%"
set SOURCE_MOD_GEN_VERSION=%ModGenVersion%
exit /b

:get_mod_versions
setlocal
set MOD_NAMES="DoubleSupply","TripleSupply","YIMBY"
set "EXPORTS="

for %%I in (%MOD_NAMES:,= %) do (
    set "MOD_CONFIG_FILE=%USER_MOD_CONFIG_FOLDER%\%%~I\Config.ini"
    call get_mod_config_values.bat "!MOD_CONFIG_FILE!"
    if !ERRORLEVEL! equ 0 (
      set "EXPORTS=!EXPORTS! & set "%%~I_VERSION=!Version!" & set "%%~I_MOD_GEN_VERSION=!ModGenVersion!""
    )
)

endlocal %EXPORTS%
exit /b

:end
echo +++ Exiting
exit /b
