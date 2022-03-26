@echo off

cd classv
call make.bat
cd..

cd rfmclient
call make.bat
cd..

cd rsdbbackup
call make.bat
cd..

cd needed
call make.bat
cd..

cd rsdbconf
call make.bat
cd..

cd rsdbview
call make.bat
cd..

cd rsrdclient
call make.bat
cd..

cd rssettings
call make.bat
cd..

cd sql
call make.bat
cd..
