@echo off
if exist bodyrecycle.exe del bodyrecycle.exe
rc /nologo images.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodyrecycle.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist bodyrecycle.exe copy /Y bodyrecycle.exe ..\test\
