@echo off
if exist rshell.dll del rshell.dll
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl rshell.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist rshell.dll copy /Y rshell.dll ..\..\test\
