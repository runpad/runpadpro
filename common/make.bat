@echo off

cd help
call make.bat
cd..

cd hh_wrapper
call make.bat
cd..

cd setup_selector
call make.bat
cd..

cd redist
call make.bat
cd..

