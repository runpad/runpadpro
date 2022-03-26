@echo off
if exist rsoperator.dll del rsoperator.dll
rc /nologo resource.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- rsoperator.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist rsoperator.dll copy /Y rsoperator.dll ..\..\test\



