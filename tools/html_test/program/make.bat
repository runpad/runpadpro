@echo off
if exist html_test.exe del html_test.exe
dcc32 -Q -B -$I- -$D- -$L- -$Y- html_test.dpr
if %ERRORLEVEL% NEQ 0 pause
mycodesign html_test.exe
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*
rem if exist html_test.exe copy /Y html_test.exe ..\test\

