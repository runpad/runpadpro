@echo off

set cl=

rem 64-bit dll
if exist rshelper64.dll del rshelper64.dll
call pushvcvars.bat
call setvcvars64.bat
cl -Fershelper64 -LD -MT -O2s -nologo hook.c kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
mycodesign rshelper64.dll
if %ERRORLEVEL% NEQ 0 pause
call popvcvars.bat
if exist rshelper64.dll copy /Y rshelper64.dll ..\..\test\

rem 32-bit dll
if exist rshelper.dll del rshelper.dll
if exist rshelper.lib del rshelper.lib
cl -Fershelper -LD -MT -O2s -nologo hook.c kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
mycodesign rshelper.dll
if %ERRORLEVEL% NEQ 0 pause
if exist rshelper.dll copy /Y rshelper.dll ..\..\test\


