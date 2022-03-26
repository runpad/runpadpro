@echo off
if exist *.exe del *.exe
set cl=

rc /nologo bodyword.rc
cl -nologo bodyword.c -link /MACHINE:X86 /ENTRY:WinMain bodyword.res kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
mycodesign bodyword.exe
if %ERRORLEVEL% NEQ 0 pause

rc /nologo bodyexcel.rc
cl -nologo bodyexcel.c -link /MACHINE:X86 /ENTRY:WinMain bodyexcel.res kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
mycodesign bodyexcel.exe
if %ERRORLEVEL% NEQ 0 pause

rc /nologo bodympc.rc
cl -nologo bodympc.c -link /MACHINE:X86 /ENTRY:WinMain bodympc.res kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
mycodesign bodympc.exe
if %ERRORLEVEL% NEQ 0 pause

rc /nologo bodywinamp.rc
cl -nologo bodywinamp.c -link /MACHINE:X86 /ENTRY:WinMain bodywinamp.res kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
mycodesign bodywinamp.exe
if %ERRORLEVEL% NEQ 0 pause

rc /nologo bodypdvd.rc
cl -nologo bodypdvd.c -link /MACHINE:X86 /ENTRY:WinMain bodypdvd.res kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
mycodesign bodypdvd.exe
if %ERRORLEVEL% NEQ 0 pause

rc /nologo bodybtw.rc
cl -nologo bodybtw.c -link /MACHINE:X86 /ENTRY:WinMain bodybtw.res kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
mycodesign bodybtw.exe
if %ERRORLEVEL% NEQ 0 pause

if exist *.obj del *.obj
if exist *.res del *.res
if exist *.exe copy /Y *.exe ..\test\

