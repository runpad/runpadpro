@echo off
if exist rsrules.exe del rsrules.exe
if exist rsrules.dll del rsrules.dll
set cl=
rc /nologo rsrules_exe.rc
cl -Fersrules -O2s -MT -nologo rsrules.cpp -link /MACHINE:X86 /MANIFEST:NO kernel32.lib user32.lib shlwapi.lib shell32.lib advapi32.lib ole32.lib comctl32.lib rsrules_exe.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
dcc32 -Q -B -$I- -$D- -$L- -$Y- -LUrtl;vcl rsrules.dpr
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.dcu del *.dcu
if exist *.ddp del *.ddp
if exist *.bak del *.bak
if exist *.~* del *.~*
if exist rsrules.exe copy /Y rsrules.exe ..\test\
if exist rsrules.dll copy /Y rsrules.dll ..\test\
