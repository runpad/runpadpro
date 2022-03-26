@echo off
if exist bodymouse.exe del bodymouse.exe
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodymouse.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist bodymouse.exe copy /Y bodymouse.exe ..\test\
