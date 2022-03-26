@echo off
if exist setup_selector.exe del setup_selector.exe
rc /nologo resource.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- setup_selector.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*

