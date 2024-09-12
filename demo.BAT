@echo off
echo Opened site
call ByteBat.bat 150 150 700 500 "https://8biticon.com/constructor?token=276076422645791" >nul
pause >nul
echo Closed site
taskkill /IM iexplore.exe /F >nul
pause >nul
