@echo off
if exist bodyoffice.dll del bodyoffice.dll
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodyoffice.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.ddp del *.ddp
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodyoffice.dll copy /Y bodyoffice.dll ..\test\

