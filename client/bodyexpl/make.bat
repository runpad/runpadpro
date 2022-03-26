@echo off
if exist bodyexpl.dll del bodyexpl.dll
set cl=
cl -Febodyexpl -LD -MT -nologo -O2s *.cpp kernel32.lib user32.lib shlwapi.lib gdiplus.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib

if exist bodyexpl.exe del bodyexpl.exe
rc /nologo images.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodyexpl.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*

if exist bodyexpl.exe copy /Y bodyexpl.exe ..\test\
if exist bodyexpl.dll copy /Y bodyexpl.dll ..\test\

