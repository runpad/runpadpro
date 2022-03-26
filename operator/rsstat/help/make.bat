@echo off
if exist rsstat.hlp del rsstat.hlp
start /WAIT /MIN hcw /c /e rsstat.hpj
if %ERRORLEVEL% NEQ 0 pause
copy /Y rsstat.hlp ..\..\TEST\

