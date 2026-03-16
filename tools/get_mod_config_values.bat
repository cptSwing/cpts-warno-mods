@echo off
set "CONFIG_FILE=%~1"
if not exist "%CONFIG_FILE%" (
  echo --- Error: Config file at %CONFIG_FILE% does not exist!
  exit /b 1
)

setlocal EnableDelayedExpansion
set "EXPORTS="

for /f "usebackq tokens=1,2 eol=; delims==;" %%I in ("%CONFIG_FILE%") do (
  call :trim KEY "%%~I"
  call :trim VALUE "%%~J"
  set "EXPORTS=!EXPORTS! & set "!KEY!=!VALUE!""
)

endlocal %EXPORTS%
exit /b

:trim
set "%~1=%~2"
for /f "tokens=* delims= " %%I in ("!%~1!") do set "%~1=%%I"
:trim_tail
if "!%~1:~-1!"==" " set "%~1=!%~1:~0,-1!" & goto trim_tail
exit /b
