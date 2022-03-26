CRCCheck off

Name "Runpad Pro"
Caption "Runpad Pro"

OutFile "setup.exe"
InstallDir "$TEMP\RunpadProInst"
ShowInstDetails nevershow
AutoCloseWindow true
InstallColors /windows
DirShow hide


Function .onInit

  IfNewOS OSOk
    MessageBox MB_OK|MB_ICONEXCLAMATION "Win95/98/ME/NT4 не поддерживаются"
    Abort
  OSOk:
  
  IfAdmin RightsOK
    MessageBox MB_OK|MB_ICONEXCLAMATION "Установку необходимо производить из-под учетной записи администратора"
    Abort
  RightsOK:

FunctionEnd



Section ""

  SetOutPath $INSTDIR

  File /oname=inst_1.exe "..\..\!out\runpad_pro_admin.exe"
  File /oname=inst_2.exe "..\..\!out\runpad_pro_server.exe"
  File /oname=inst_3.exe "..\..\!out\runpad_pro_client_shell.exe"
  File /oname=inst_4.exe "..\..\!out\runpad_pro_client_rollback.exe"
  File /oname=inst_5.exe "..\..\!out\runpad_pro_operator.exe"

  File "..\setup_selector\setup_selector.exe"
  File "..\help\help_setup.chm"

  ExecWait "$INSTDIR\setup_selector.exe"

  RMDir /r "$INSTDIR"

SectionEnd

