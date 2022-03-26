@echo off
if exist rsdbbackup.exe del rsdbbackup.exe
rc /nologo resource.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- rsdbbackup.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
if exist rsdbbackup.exe copy /Y rsdbbackup.exe ..\test\
