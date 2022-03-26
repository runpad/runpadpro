@echo off
if exist bodymobile.exe del bodymobile.exe
rc /nologo resource.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodymobile.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist bodymobile.exe copy /Y bodymobile.exe ..\test\

