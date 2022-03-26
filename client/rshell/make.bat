@echo off
if exist rshell.exe del rshell.exe
set cl=
rc /nologo resource.rc
cl -Fershell -nologo -DNDEBUG /O2t /EHsc /MT /MP *.cpp -link /MACHINE:X86 /BASE:0x01000000 /TSAWARE kernel32.lib user32.lib gdi32.lib winmm.lib shlwapi.lib shell32.lib comdlg32.lib advapi32.lib ole32.lib oleaut32.lib ws2_32.lib comctl32.lib imm32.lib wininet.lib opengl32.lib glu32.lib vfw32.lib msimg32.lib userenv.lib winspool.lib gdiplus.lib strmiids.lib wtsapi32.lib psapi.lib setupapi.lib .\hook\rshelper.lib ..\rp_shared\rp_shared.lib nvidia\nvapi.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
mycodesign rshell.exe
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.pch del *.pch
if exist *.res del *.res
if exist rshell.exe copy /Y rshell.exe ..\test\

if exist rscfg.dll del rscfg.dll
set cl=
cl -Ferscfg -nologo -DCFG_DLL -DNDEBUG /O2t /EHsc /MT /LD cfg_def.cpp cfg_impl.cpp cfg_vars.cpp f0.cpp md5.cpp kernel32.lib user32.lib advapi32.lib shlwapi.lib ws2_32.lib ..\rp_shared\rp_shared.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.exp del *.exp
if exist *.lib del *.lib
if exist *.obj del *.obj
if exist *.pch del *.pch
if exist rscfg.dll copy /Y rscfg.dll ..\..\admin\test\

