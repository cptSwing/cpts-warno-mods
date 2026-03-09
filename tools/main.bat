@echo off
setlocal EnableDelayedExpansion

rem change working directory to directory where script resides
cd /d "%~dp0"

set DEBUG_MODE=True

rem https://stackoverflow.com/a/31721353 + usebackq for quotes in path, "'s around variables to close same, %~dp0 to execute from script's working directory
for /f "usebackq tokens=1,2 delims==" %%G in ("%~dp0..\config.env") do set "%%G=%%H"

if "%WARNO_MODS_FOLDER%"=="" echo *** Error - WARNO_MODS_FOLDER is not defined in config.env! & goto end
if "%NDF_PARSE_SOURCE_MOD_NAME%"=="" echo *** Error - NDF_PARSE_SOURCE_MOD_NAME is not defined in config.env! & goto end
if "%USER_MOD_CONFIG_FOLDER%"=="" echo *** Error - USER_MOD_CONFIG_FOLDER is not defined in config.env! & goto end

echo *** Loaded config.env:
echo - WARNO Mods folder: %WARNO_MODS_FOLDER%
echo - Source mod name: %NDF_PARSE_SOURCE_MOD_NAME%
echo - Mod Config folder: %USER_MOD_CONFIG_FOLDER%
echo.

:main
call :menu

if %CHOICE% equ 1 (
  pushd %WARNO_MODS_FOLDER%
  if exist %WARNO_MODS_FOLDER%\%NDF_PARSE_SOURCE_MOD_NAME%\ (
    echo %NDF_PARSE_SOURCE_MOD_NAME% exists, removing ...
    rd /s /q %WARNO_MODS_FOLDER%\%NDF_PARSE_SOURCE_MOD_NAME%\
  )
  
  call CreateNewMod.bat "%NDF_PARSE_SOURCE_MOD_NAME%"
  popd
  
  goto main
)

if %CHOICE% equ 2 (
  set MOD_NAME=DoubleSupply
  call process_mod_info.bat "!MOD_NAME!" "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%USER_MOD_CONFIG_FOLDER%" %DEBUG_MODE%
  goto main
)

if %CHOICE% equ 3 (
  set MOD_NAME=TripleSupply
  call process_mod_info.bat "!MOD_NAME!" "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%USER_MOD_CONFIG_FOLDER%" %DEBUG_MODE%
  goto main
)

if %CHOICE% equ 4 (
  set MOD_NAME=YIMBY
  call process_mod_info.bat "!MOD_NAME!" "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%USER_MOD_CONFIG_FOLDER%" %DEBUG_MODE%
  goto main
)

if %CHOICE% equ 5 (
  set MOD_NAME=Debug
  call process_mod_info.bat "!MOD_NAME!" "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%USER_MOD_CONFIG_FOLDER%" %DEBUG_MODE%
  goto main
)

if %CHOICE% equ 6 call :toggledebug & goto main
if %CHOICE% equ 7 goto end

:menu
echo MAIN MENU
echo =================
echo Select an option:
echo.
echo 1 - Generate/Refresh "pristine" Source Mod - Do this before choosing any other option! [VERSION NUMBER HERE]
echo -----------------
echo 2 - Generate/Update DoubleSupply
echo 3 - Generate/Update TripleSupply
echo 4 - Generate/Update YIMBY
echo 5 - Test
echo -----------------
echo D - Toggle Debug Mode (currently %DEBUG_MODE%)
echo -----------------
echo X - Exit
echo.

choice /C 12345DX /M "Select an option "
set CHOICE=%ERRORLEVEL%
echo.
exit /b

:end
echo *** Exiting
echo.
exit /b

:toggledebug
if %DEBUG_MODE%==True (
  set DEBUG_MODE=False
  ) else (
  set DEBUG_MODE=True
)
echo *** Debug set to %DEBUG_MODE%
echo.

exit /b
