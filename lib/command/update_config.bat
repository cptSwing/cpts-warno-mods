setlocal EnableDelayedExpansion
set "MOD_NAME=%~1"
set "CONFIG_FILE=%USER_MOD_CONFIG_FOLDER%\%MOD_NAME%\Config.ini"

call get_config.bat "%CONFIG_FILE%"
set GET_MOD_CONFIG_ERROR_LEVEL=%ERRORLEVEL%

if %GET_MOD_CONFIG_ERROR_LEVEL% equ 0 (
  set /a THIS_MOD_VERSION=%Version%+1
  
  set "PREVIEW_IMAGE=%~dp0..\..\mods\%MOD_NAME%\preview.png"
  for %%I in ("!PREVIEW_IMAGE!") do (
    if exist "!PREVIEW_IMAGE!" (
      rem resolve path via for loop:
      set "PREVIEW_IMAGE=%%~fI"
    ) else (
      echo --- Error: Preview Image at %%I does not exist^!
    )
  )

  echo.
  echo +++ %MOD_NAME% updated to version !THIS_MOD_VERSION!
  echo +++ PreviewImagePath set to !PREVIEW_IMAGE!

  set "TEMP_CONFIG=%CONFIG_FILE%.tmp"
  (
    for /f "usebackq delims=" %%I in ("%CONFIG_FILE%") do (
      set "LINE=%%I"
      if /i "!LINE:~0,7!"=="Version" (
        echo Version = !THIS_MOD_VERSION!
      ) else (
        if /i "!LINE:~0,16!"=="PreviewImagePath" (
          echo PreviewImagePath = !PREVIEW_IMAGE!
        ) else (
          echo !LINE!
        )
      )
    )
  ) > "!TEMP_CONFIG!"

  move /y "!TEMP_CONFIG!" "%CONFIG_FILE%" >nul
)

endlocal
exit /b
