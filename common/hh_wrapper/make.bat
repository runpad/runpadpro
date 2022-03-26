@echo off
if exist hh_wrapper.dll del hh_wrapper.dll
if exist hh_wrapper.lib del hh_wrapper.lib
set cl=
cl -Fehh_wrapper -LD -O2s -nologo main.c kernel32.lib user32.lib advapi32.lib hh_api\htmlhelp.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist hh_wrapper.dll copy /Y hh_wrapper.dll ..\..\admin\test\

