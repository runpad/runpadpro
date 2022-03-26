@echo off
if exist rsdbconf.exe del rsdbconf.exe
rc /nologo resource.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- rsdbconf.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist rsdbconf.exe copy /Y rsdbconf.exe ..\test\
