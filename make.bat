@echo off

cd admin
call make.bat
cd..

cd client
call make.bat
cd..

cd operator
call make.bat
cd..

cd server
call make.bat
cd..

rem common must be last!
cd common
call make.bat
cd..


echo _
echo _
echo _
echo        лллллллл  лл   лл   лл лл лл
echo        лллллллл  лл  ллл   лл лл лл
echo        лл    лл  лл ллл    лл лл лл
echo        лл    лл  ллллл     лл лл лл
echo        лл    лл  ллллл     лл лл лл
echo        лл    лл  лл ллл    лл лл лл
echo        лллллллл  лл  ллл           
echo        лллллллл  лл   лл   лл лл лл
echo _
echo _
echo _
pause
