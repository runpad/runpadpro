@echo off
if exist bodyiso.exe del bodyiso.exe
rc /nologo images.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodyiso.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
if exist *.dcu del *.dcu
if exist *.ddp del *.ddp
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodyiso.exe copy /Y bodyiso.exe ..\test\
