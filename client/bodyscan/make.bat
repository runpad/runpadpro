@echo off
if exist bodyscan.exe del bodyscan.exe
set cl=
rc /nologo resource.rc
cl -Febodyscan -O2s -MT -nologo main.cpp -link /MACHINE:X86 /MANIFEST:NO resource.res kernel32.lib user32.lib shell32.lib shlwapi.lib advapi32.lib comctl32.lib comdlg32.lib ole32.lib ..\rp_shared\rp_shared.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist bodyscan.exe copy /Y bodyscan.exe ..\test\
copy /Y VSTwain.dll ..\test\


