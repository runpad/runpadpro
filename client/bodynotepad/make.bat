@echo off
if exist bodynotepad.exe del bodynotepad.exe
rc /nologo bodynotepad.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodynotepad.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.ddp del *.ddp
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodynotepad.exe copy /Y bodynotepad.exe ..\test\

