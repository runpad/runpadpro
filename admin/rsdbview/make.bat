@echo off
if exist rsdbview.exe del rsdbview.exe
rc /nologo resource.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- rsdbview.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist rsdbview.exe copy /Y rsdbview.exe ..\test\

