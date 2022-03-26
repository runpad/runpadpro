@echo off

if exist rssettings.dll del rssettings.dll
set cl=
cl -nologo -Ferssettings -LD -MT -EHsc -O2s dll.cpp kernel32.lib shlwapi.lib ole32.lib setupapi.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib

if exist rssettings.exe del rssettings.exe
rc /nologo resource.rc
dcc32 -Q -B -$I- -$D- -$L- -$Y- rssettings.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.bak del *.bak
if exist *.ddp del *.ddp
if exist *.~* del *.~*

if exist rssettings.exe copy /Y rssettings.exe ..\test\
if exist rssettings.dll copy /Y rssettings.dll ..\test\
