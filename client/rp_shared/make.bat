@echo off
if exist rp_shared.dll del rp_shared.dll
if exist rp_shared.lib del rp_shared.lib
set cl=
rc /nologo rp_shared.rc
cl -MT -Ferp_shared -LD -O2s -nologo -DRP_SHARED_EXPORTS *.c -link /MACHINE:X86 rp_shared.res kernel32.lib user32.lib shlwapi.lib shell32.lib comctl32.lib gdi32.lib advapi32.lib comdlg32.lib version.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist *.exp del *.exp
if exist rp_shared.dll copy /Y rp_shared.dll ..\test\
if exist rp_shared.dll copy /Y rp_shared.dll ..\..\admin\test\

