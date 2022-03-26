@echo off
if exist bodycam.exe del bodycam.exe
rc /nologo resource.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodycam.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
if exist *.ddp del *.ddp
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodycam.exe copy /Y bodycam.exe ..\test\

