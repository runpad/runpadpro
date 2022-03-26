@echo off
if exist bodywb.dll del bodywb.dll
rc /nologo resource.rc
rem here is bug with loading animation AVI if specify -LUvcl !!!!!!!!!
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl bodywb.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist *.dcu del *.dcu
if exist *.ddp del *.ddp
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodywb.dll copy /Y bodywb.dll ..\..\test\
