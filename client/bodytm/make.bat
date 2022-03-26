@echo off
if exist bodytm.exe del bodytm.exe
set cl=
rc /nologo resource.rc
cl -Febodytm -O2s -MT -nologo *.cpp -link /MACHINE:X86 /MANIFEST:NO resource.res kernel32.lib user32.lib shlwapi.lib shell32.lib ole32.lib advapi32.lib comctl32.lib wtsapi32.lib ..\rp_shared\rp_shared.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist bodytm.exe copy /Y bodytm.exe ..\test\


