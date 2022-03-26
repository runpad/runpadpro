@echo off
if exist rsrdclient.exe del rsrdclient.exe
if exist rsrdclient.dll del rsrdclient.dll
set cl=
cl -Fersrdclient -LD -MT -MP -EHsc -O2t -nologo *.cpp ..\..\client\rsrdserver\buff7.cpp ..\..\client\rsrdserver\rle7.cpp ..\..\client\rshell\f0.cpp -link kernel32.lib user32.lib gdi32.lib advapi32.lib shlwapi.lib ws2_32.lib
if %ERRORLEVEL% NEQ 0 pause
dcc32 -Q -B -$I- -$D- -$L- -$Y- rsrdclient.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
if exist *.dcu del *.dcu
if exist *.ddp del *.ddp
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist rsrdclient.exe copy /Y rsrdclient.exe ..\test\
if exist rsrdclient.dll copy /Y rsrdclient.dll ..\test\
