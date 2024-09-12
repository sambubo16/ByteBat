@echo off
setlocal

if "%~5"=="" (
    echo Usage: Browser.bat x y width height "URL"
    exit /b 1
)

set X=%~1
set Y=%~2
set WIDTH=%~3
set HEIGHT=%~4
set URL=%~5
ping -n 1 www.google.com >nul 2>&1
if %errorlevel% neq 0 (
    echo Internet not connected.
) else (
    powershell -ExecutionPolicy Bypass -File ByteBat.ps1 -x %X% -y %Y% -width %WIDTH% -height %HEIGHT% -url "%URL%" >nul

)

endlocal
