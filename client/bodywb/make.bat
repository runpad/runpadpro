@echo off
if exist bodywb.exe del bodywb.exe
rc /nologo resource.rc
set cl=
cl -Febodywb -O2s -nologo -MT *.c -link /MACHINE:X86 /MANIFEST:NO kernel32.lib user32.lib shlwapi.lib shell32.lib advapi32.lib ole32.lib comctl32.lib wininet.lib ..\rp_shared\rp_shared.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist bodywb.exe copy /Y bodywb.exe ..\test\
