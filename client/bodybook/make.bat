@echo off
if exist bodybook.exe del bodybook.exe
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl bodybook.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist bodybook.exe copy /Y bodybook.exe ..\test\
