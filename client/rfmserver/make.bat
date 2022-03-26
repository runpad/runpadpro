@echo off
if exist rfmserver.exe del rfmserver.exe
set cl=
cl /Ferfmserver /nologo /MT /MP /EHsc /O2s /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" *.cpp -link /MACHINE:X86 kernel32.lib user32.lib gdi32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib comctl32.lib shlwapi.lib ws2_32.lib
if %ERRORLEVEL% NEQ 0 pause
mycodesign rfmserver.exe
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist rfmserver.exe (
 if exist ..\test\rfmserver.exe del /Q ..\test\rfmserver.exe
 if exist ..\test\rfmserver.exe (
  start /wait ..\test\rfmserver.exe -uninstall
  copy /Y rfmserver.exe ..\test\
  start /wait ..\test\rfmserver.exe -install
 ) ELSE (
  copy /Y rfmserver.exe ..\test\
 )
)
