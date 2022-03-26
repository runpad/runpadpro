@echo off
if exist h_mssql.dll del h_mssql.dll

dcc32 -Q -B -$I- -$D- -$L- -$Y- h_mssql.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*

if exist h_mssql.dll move /Y h_mssql.dll ..\
