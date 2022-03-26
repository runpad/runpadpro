@echo off
if exist rshell_ams.exe del rshell_ams.exe
set cl=
rc /nologo resource.rc
cl -Fershell_ams -O2s -MT -MP -EHsc -nologo *.cpp *.c -link /MACHINE:X86 resource.res kernel32.lib user32.lib shell32.lib shlwapi.lib advapi32.lib comctl32.lib ole32.lib winmm.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist *.pch del *.pch

if exist rshell_ams.exe mycodesign rshell_ams.exe
if %ERRORLEVEL% NEQ 0 pause
