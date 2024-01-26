@echo off
setlocal

set t=600

echo active!

:LOOP
set /a "i+=1"

rem Simulate the F15 key press
echo WScript.CreateObject("WScript.Shell").SendKeys("{F15}") > temp.vbs
cscript //nologo temp.vbs
del temp.vbs

timeout /nobreak /t 600 >nul

if %i% lss %t% goto LOOP

echo Script completed.
endlocal
