@echo off
if exist bodymp.exe del bodymp.exe
set cl=
rc /nologo resource.rc
cl /Febodymp /nologo /EHsc /MT /O2s /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_ATL_DLL" *.cpp -link /MANIFEST:NO /MACHINE:X86 kernel32.lib user32.lib gdi32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib comctl32.lib shlwapi.lib ..\rp_shared\rp_shared.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.res del *.res
if exist *.obj del *.obj
if exist bodymp.exe copy /Y bodymp.exe ..\test\

