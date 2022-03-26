@echo off
if exist !out del /Q !out\*.*
if not exist !out md !out

cd admin\install
call install.bat
cd ..\..\

cd client\install
call install.bat
cd ..\..\

cd operator\install
call install.bat
cd ..\..\

cd server\install
call install.bat
cd ..\..\

rem must be last!!!
cd common\install
call install.bat
cd ..\..\

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
