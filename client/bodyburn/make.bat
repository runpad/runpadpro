@echo off
if exist bodyburn.exe del bodyburn.exe
if exist bodyburn.dll del bodyburn.dll
set cl=
cl -LD -MT -nologo bodyburn.c kernel32.lib shlwapi.lib nero\NeroAPIGlue.lib
if %ERRORLEVEL% NEQ 0 pause
rc /nologo bodyburn.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodyburn.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
if exist *.dcu del *.dcu
if exist *.ddp del *.ddp
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodyburn.dll copy /Y bodyburn.dll ..\test\
if exist bodyburn.exe copy /Y bodyburn.exe ..\test\
