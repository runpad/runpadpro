@echo off
if exist rfmclient.exe del rfmclient.exe
set cl=
rc /nologo rfmclient.rc
cl /Ferfmclient /nologo /MP /MT /EHsc /O2s /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_STLP_USE_STATIC_LIB" *.cpp -link /MACHINE:X86 /SUBSYSTEM:Windows kernel32.lib user32.lib gdi32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib comctl32.lib shlwapi.lib ws2_32.lib rfmclient.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.res del *.res
if exist *.obj del *.obj
if exist rfmclient.exe copy /Y rfmclient.exe ..\test\


