@echo off
if exist *.dll del *.dll
dcc32 -Q -B -$I- -$D- -$L- -$Y- -DOFFICE2000 -LUrtl;vcl bodyoffice.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.ddp del *.ddp
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodyoffice.dll rename bodyoffice.dll bodyoffice2000.dll
if exist bodyoffice2000.dll copy /Y bodyoffice2000.dll ..\test\

