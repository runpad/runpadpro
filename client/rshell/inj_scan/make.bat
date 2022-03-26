@echo off
if exist inj_scan.dll del inj_scan.dll
set cl=
cl -Feinj_scan -LD -O2s -nologo *.c kernel32.lib user32.lib shlwapi.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist inj_scan.dll copy /Y inj_scan.dll ..\..\test\

