@echo off
setlocal EnableDelayedExpansion

rem change working directory to directory where script resides
cd /d "%~dp0"

set DEBUG_MODE=False

rem https://stackoverflow.com/a/31721353 + usebackq for quotes in path, "'s around variables to close same, %~dp0 to execute from script's working directory
for /f "usebackq tokens=1,2 delims==" %%G in ("%~dp0..\config.env") do set "%%G=%%H"

if "%WARNO_MODS_FOLDER%"=="" echo *** Error - WARNO_MODS_FOLDER is not defined in config.env! & goto end
if "%NDF_PARSE_SOURCE_MOD_NAME%"=="" echo *** Error - NDF_PARSE_SOURCE_MOD_NAME is not defined in config.env! & goto end
if "%USER_MOD_CONFIG_FOLDER%"=="" echo *** Error - USER_MOD_CONFIG_FOLDER is not defined in config.env! & goto end

echo *** Loaded config.env:
echo WARNO Mods folder is at %WARNO_MODS_FOLDER%
echo Source Mod name is %NDF_PARSE_SOURCE_MOD_NAME%
echo Mod Config folder is %USER_MOD_CONFIG_FOLDER%

:main
call :menu

if %CHOICE% equ 1 (
  set MOD_NAME=DoubleSupply
  call process_mod_info.bat "!MOD_NAME!" "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%USER_MOD_CONFIG_FOLDER%" %DEBUG_MODE%
  goto main
)

if %CHOICE% equ 2 (
  set MOD_NAME=TripleSupply
  call process_mod_info.bat "!MOD_NAME!" "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%USER_MOD_CONFIG_FOLDER%" %DEBUG_MODE%
  goto main
)

if %CHOICE% equ 3 (
  set MOD_NAME=YIMBY
  call process_mod_info.bat "!MOD_NAME!" "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%USER_MOD_CONFIG_FOLDER%" %DEBUG_MODE%
  goto main
)

if %CHOICE% equ 4 (
  set MOD_NAME=Debug
  call process_mod_info.bat "!MOD_NAME!" "%WARNO_MODS_FOLDER%" "%NDF_PARSE_SOURCE_MOD_NAME%" "%USER_MOD_CONFIG_FOLDER%" %DEBUG_MODE%
  goto main
)

if %CHOICE% equ 5 call :toggledebug & goto main
if %CHOICE% equ 6 goto end

:menu
echo.
echo Select an option:
echo =================
echo 1 - Update DoubleSupply
echo 2 - Update TripleSupply
echo 3 - Update YIMBY
echo 4 - Test
echo -----------------
echo D - Toggle Debug Mode (currently %DEBUG_MODE%)
echo -----------------
echo X - Exit
echo.

choice /C 1234DX /M "Select an option "
set CHOICE=%ERRORLEVEL%
echo.
exit /b %CHOICE%

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
exit /b
