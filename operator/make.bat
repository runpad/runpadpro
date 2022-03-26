@echo off

cd rsoperator
 cd dll
 call make.bat
 cd..
 call make.bat
cd..

cd rsstat
 cd dll
 call make.bat
 cd..
 cd help
 call make.bat
 cd..
 call make.bat
cd..

