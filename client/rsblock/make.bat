@echo off
if exist rsblock.exe del rsblock.exe
set cl=
rc /nologo resource.rc
cl /Fersblock /MT /MP /EHsc /nologo /O2s /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_ATL_DLL" *.cpp -link /MANIFEST:NO /MACHINE:X86 kernel32.lib user32.lib gdi32.lib advapi32.lib shell32.lib shlwapi.lib ole32.lib oleaut32.lib comctl32.lib gdiplus.lib ..\rp_shared\rp_shared.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.res del *.res
if exist *.obj del *.obj
if exist rsblock.exe copy /Y rsblock.exe ..\test\

