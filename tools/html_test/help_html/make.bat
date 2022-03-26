@echo off
if exist *.chm del *.chm
hhc script.hhp
if %ERRORLEVEL% EQU 0 pause
if exist help.chm move /Y help.chm .\help_html.chm

