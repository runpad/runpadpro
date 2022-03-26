@echo off
if exist bodymail.exe del bodymail.exe
rc /nologo images.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodymail.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist bodymail.exe copy /Y bodymail.exe ..\test\
