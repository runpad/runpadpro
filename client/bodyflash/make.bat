@echo off
if exist bodyflash.exe del bodyflash.exe
set cl=
rc /nologo resource.rc
cl /Febodyflash /MT /nologo /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_ATL_DLL" main.cpp -link /MANIFEST:NO /MACHINE:X86 kernel32.lib user32.lib gdi32.lib advapi32.lib shell32.lib shlwapi.lib ole32.lib oleaut32.lib comctl32.lib ..\rp_shared\rp_shared.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.res del *.res
if exist *.obj del *.obj
if exist bodyflash.exe copy /Y bodyflash.exe ..\test\

