@echo off
if exist bodyimgview.exe del bodyimgview.exe
set cl=
rc /nologo resource.rc
cl -Febodyimgview -nologo -O2t -MT -MP -EHsc *.c *.cpp -link /MACHINE:X86 /MANIFEST:NO kernel32.lib user32.lib gdi32.lib shlwapi.lib shell32.lib comdlg32.lib comctl32.lib Winspool.lib wiaguid.lib ole32.lib oleaut32.lib gdiplus.lib ..\rp_shared\rp_shared.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist bodyimgview.exe copy /Y bodyimgview.exe ..\test\

