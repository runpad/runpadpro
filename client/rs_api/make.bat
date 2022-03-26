@echo off
if exist *.dll del *.dll
if exist examples\include\*.* del /Q examples\include\*.*
set cl=
nmake -NOLOGO -S -f makefile all
if %ERRORLEVEL% NEQ 0 pause

cd examples
rar a -r examples >nul
if %ERRORLEVEL% NEQ 0 pause
if exist ..\..\..\common\help\ext\examples.rar del ..\..\..\common\help\ext\examples.rar
move /Y examples.rar ..\..\..\common\help\ext\
cd..
