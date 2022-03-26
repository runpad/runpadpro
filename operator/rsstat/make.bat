@echo off
if exist rsstat.exe del rsstat.exe
dcc32 -Q -B -$I- -$D- -$L- -$Y- rsstat.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist rsstat.exe copy /Y rsstat.exe ..\TEST\

