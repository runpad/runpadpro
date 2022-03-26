@echo off
if exist rsbrowser.exe del rsbrowser.exe 
rc /nologo rsbrowser.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- rsbrowser.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.ddp del *.ddp
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist rsbrowser.exe copy /Y rsbrowser.exe ..\test\

