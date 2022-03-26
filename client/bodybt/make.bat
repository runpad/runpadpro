@echo off
if exist bodybt.exe del bodybt.exe
rc /nologo images.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodybt.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
if exist *.ddp del *.ddp
if exist *.dcu del *.dcu
if exist btf\*.dcu del btf\*.dcu
if exist *.ddp del *.ddp
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodybt.exe copy /Y bodybt.exe ..\test\
copy /Y bftowdthunk.dll ..\test\

