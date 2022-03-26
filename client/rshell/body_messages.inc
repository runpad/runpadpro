


int ProcessRunpadInternalMessage(HWND hwnd,int message,int wParam,int lParam,BOOL *is_processed)
{
  *is_processed = TRUE;
  
  switch ( message )
  {
    case RS_GETMONITORSTATE:
                   return !monitor_off;

    case RS_GETINPUTSTATE:
                   return monitor_off ? (!disable_input_when_monitor_off) : 1;

    case RS_GETBLOCKED:
                   return protect_run_from_api ? 1 : 0;

    case RS_GETSHELLFOLDERS:
                   if ( wParam == 4 /*user_folder*/ )
                      {
                        return (int)GlobalAddAtom(user_folder);
                      }
                   if ( wParam == 5 /*vip_folder*/ )
                      {
                        return (int)GlobalAddAtom(vip_folder);
                      }
                   return 0;

    case RS_GETMACHINENUM:
                   {
                     char s[MAX_PATH];

                     s[0] = 0;
                     for ( int n = 0; n < lstrlen(machine_desc); n++ )
                         {
                           char c = machine_desc[n];

                           if ( c >= '0' && c <= '9' )
                              {
                                char ss[10];

                                wsprintf(ss,"%c",c);
                                lstrcat(s,ss);
                              }
                         }

                     if ( s[0] )
                        {
                          return StrToInt(s);
                        }
                   }
                   return 0;
                   
    case RS_GETCURRENTSHEET:
                   {
                     CSheet *sh = GetActiveSheet();
                     return sh ? (int)GlobalAddAtom(sh->GetName()) : 0;
                   }

    case RS_ENABLESHEETS:
                   {
                     char s[MAX_PATH];

                     s[0] = 0;
                     if ( wParam )
                        {
                          GlobalGetAtomName((ATOM)wParam,s,sizeof(s));
                          GlobalDeleteAtom((ATOM)wParam);
                        }

                     EnableSheetsFromAPI(s,lParam);
                   }
                   return 0;

    case RS_REGISTERCLIENT:
                   {
                     char sname[MAX_PATH];
                     char spath[MAX_PATH];

                     sname[0] = 0;
                     if ( wParam )
                        {
                          GlobalGetAtomName((ATOM)wParam,sname,MAX_PATH);
                          GlobalDeleteAtom((ATOM)wParam);
                        }
                     spath[0] = 0;
                     if ( lParam )
                        {
                          GlobalGetAtomName((ATOM)lParam,spath,MAX_PATH);
                          GlobalDeleteAtom((ATOM)lParam);
                        }

                     if ( sname[0] && spath[0] )
                        {
                          lstrcpy(client_restore,spath);

                          {
                            const char *exe = PathFindFileName(spath); //no expand needed

                            InsertIntoCfgList1(safe_tray_icons,exe);
                            InsertIntoCfgList1(hide_tm_programs,exe);
                          }

                          CfgWriteBWCConfig();
                        }
                   }
                   return 0;

    case RS_SHOWMESSAGE:
                   if ( wParam )
                      {
                        char s[MAX_PATH];
                        
                        s[0] = 0;
                        GlobalGetAtomName((ATOM)wParam,s,sizeof(s));
                        GlobalDeleteAtom((ATOM)wParam);

                        if ( s[0] )
                           {
                             int delay = HIWORD(lParam);
                             int type = LOWORD(lParam);

                             if ( delay == 0 )
                                delay = 5;
                             if ( delay < 1 )
                                delay = 1;
                             if ( delay > 300 )
                                delay = 300;

                             if ( type == 0 )
                                TextMessageBox(s,TRUE,delay);
                             else
                             if ( type == 1 )
                                BalloonNotify(NIIF_INFO,LS(LS_INFO),s,delay);
                             else
                             if ( type == 2 )
                                {
                                  if ( lstrcmp(html_status_text1,s) )
                                     {
                                       lstrcpyn(html_status_text1,s,sizeof(html_status_text1));
                                       UpdateStatusTextString();
                                     }
                                }
                           }
                      }
                   return 0;

    case RS_MINIMIZEALLWINDOWS:
                   if ( !IsAnyChildWindows() && IsWorkSpaceVisible() )
                      ToggleDesktop();
                   return 0;

    case RS_KILLALLTASKS:
                   KillAllTasks();
                   CloseActiveSheet(TRUE);
                   return 0;

    case RS_RESTORE_MODE:
                   RestoreDisplayMode();
                   return 0;

    case RS_CLOSECHILDS:
                   CloseChildWindowsAsync();
                   return 0;

    case RS_TURNMONITORON:
                   TurnOnMonitor();
                   SendDynamicInfoToServer();
                   return 0;
                   
    case RS_TURNMONITOROFF:
                   TurnOffMonitor(disable_input_when_monitor_off,0);
                   SendDynamicInfoToServer();
                   return 0;

    case RS_CLOSEVIPSESSION:
                   CloseActiveSheet(TRUE);
                   return (force_viplogin_from_api ? CloseVIPSession(TRUE) : CloseVIPSession(FALSE/*TRUE*/));

    case RS_LOGINVIPSESSION:
    case RS_LOGINVIPSESSION_NOFORCE:
    case RS_REGISTERVIPUSER:
                   {
                     char s_login[MAX_PATH] = "";
                     char s_pass[MAX_PATH] = "";
                     
                     if ( wParam )
                        {
                          GlobalGetAtomName((ATOM)wParam,s_login,MAX_PATH);
                          GlobalDeleteAtom((ATOM)wParam);
                        }

                     if ( lParam )
                        {
                          GlobalGetAtomName((ATOM)lParam,s_pass,MAX_PATH);
                          GlobalDeleteAtom((ATOM)lParam);
                        }

                     BOOL new_user = ((message == RS_REGISTERVIPUSER) ? TRUE : FALSE);

                     if ( !force_viplogin_from_api || message == RS_LOGINVIPSESSION_NOFORCE )
                        {
                          if ( s_pass[0] )
                             {
                               if ( !new_user || s_login[0] )
                                  {
                                    return LoginVIPSession(new_user,s_login,s_pass,FALSE/*TRUE*/);
                                  }
                             }
                        }
                     else
                        {
                          if ( s_login[0] )
                             {
                               return LoginVIPSessionForce(s_login,TRUE);
                             }
                        }
                   }
                   return FALSE;

    case RS_TEMPOFFSHELL:
                   {
                     char s_md5[MAX_PATH] = "";
                     
                     if ( wParam )
                        {
                          GlobalGetAtomName((ATOM)wParam,s_md5,MAX_PATH);
                          GlobalDeleteAtom((ATOM)wParam);
                        }

                     BOOL show_reminder = (BOOL)lParam;

                     if ( !IsStrEmpty(s_md5) )
                        {
                          if ( fastexit_use_fixed_pwd && !IsStrEmpty(fastexit_fixed_pwd_md5) )
                             {
                               if ( !lstrcmpi(s_md5,fastexit_fixed_pwd_md5) )
                                  {
                                    FE_DoFastExit(TRUE,show_reminder);
                                    // never got here
                                  }
                             }
                        }
                   }
                   return FALSE;

    case RS_OPENDEFAULTSHEET:
                   if ( !IsStrEmpty(startup_sheet_name) )
                      {
                        SetSheetActiveByName(startup_sheet_name);
                      }
                   return 0;
    
    case RS_RUNPROGRAMDISABLE:
                   OnBlockAction();
                   return 0;

    case RS_RUNPROGRAMENABLE:
                   OnUnblockAction();
                   return 0;

    case RS_RUNSCREENSAVER:
                   RunOurSSaver();
                   return 0;

    case RS_LOGOFF:
                   InternalLogOff(wParam);
                   return 0;
    
    case RS_CLOSERULESWINDOW:
                      CloseRulesWindow();
                      return 0;
    
    case RS_CLOSEACTIVESHEET:
                      CloseActiveSheet(TRUE);
                      return 0;
    
    case RS_SETSHEETACTIVEBYIDX:
                      SetSheetActiveByIdx(wParam,lParam);
                      return 0;
    
    case RS_EXECMAINMENUITEM:
                      ExecMainMenuItem(wParam);
                      return 0;
    
    case RS_WINKEY:
                      OnWinKeyPressed();
                      return 0;

    case RS_CANBODYTOOLEXECWITHSQLBASE:
                      return CanExecuteBodyToolWithSQLIntegrationOn(FALSE,TRUE);

    case RS_CANBODYTOOLEXECWITHSQLBASE2:
                      return CanExecuteBodyToolWithSQLIntegrationOn(FALSE,FALSE);

    case RS_USERRESPONSEADD:
                      if ( wParam )
                         {
                           char s[MAX_PATH];
                           
                           s[0] = 0;
                           GlobalGetAtomName((ATOM)wParam,s,MAX_PATH);
                           GlobalDeleteAtom((ATOM)wParam);

                           if ( s[0] && IsFileExist(s) )
                              {
                                int fsize = 0;
                                void *fbuff = ReadFullFile(s,&fsize);

                                if ( fbuff )
                                   {
                                     const char *p = (const char*)fbuff;

                                     if ( fsize && p[fsize-1] == 0 )
                                        {
                                          CNetCmd cmd(NETCMD_ADDUSERRESPONSE2BASE);

                                          cmd.AddStringParm(NETPARM_S_KIND,p);  p += lstrlen(p)+1; //kind
                                          cmd.AddStringParm(NETPARM_S_TITLE,p); p += lstrlen(p)+1; //title
                                          cmd.AddStringParm(NETPARM_S_NAME,p);  p += lstrlen(p)+1; //name
                                          cmd.AddStringParm(NETPARM_S_AGE,p);   p += lstrlen(p)+1; //age
                                          cmd.AddStringParm(NETPARM_S_TEXT,p);  p += lstrlen(p)+1; //text
                                          p += lstrlen(p)+1; //terminator

                                          if ( p-(const char*)fbuff == fsize )
                                             {
                                               NetSend(cmd);
                                             }
                                        }

                                     sys_free(fbuff);
                                   }

                                sys_deletefile(s);
                              }
                         }
                      return 0;

    case RS_STDSHELLEXECUTE:
                      {
                        char s[MAX_PATH];
                        
                        s[0] = 0;
                        if ( wParam )
                           {
                             GlobalGetAtomName((ATOM)wParam,s,MAX_PATH);
                             GlobalDeleteAtom((ATOM)wParam);
                           }

                        if ( s[0] )
                           ShellExecute(NULL,NULL,s,NULL,NULL,SW_SHOWNORMAL);
                      }
                      return 0;
    
    case RS_MESSAGEBOX:
                      {
                        char s[MAX_PATH];
                        
                        s[0] = 0;
                        if ( wParam )
                           {
                             GlobalGetAtomName((ATOM)wParam,s,MAX_PATH);
                             GlobalDeleteAtom((ATOM)wParam);
                           }

                        if ( s[0] )
                           {
                             MsgBox(s);
                           }
                      }
                   return 0;
    
    case RS_ADDURL2STAT:
                      {
                        char s[MAX_PATH];
                        
                        s[0] = 0;
                        if ( wParam )
                           {
                             GlobalGetAtomName((ATOM)wParam,s,MAX_PATH);
                             GlobalDeleteAtom((ATOM)wParam);
                           }

                        if ( stat_enable && do_web_stat && s[0] )
                           {
                             Add2Stat(NULL,s,-1,LoadIcon(our_instance,MAKEINTRESOURCE(IDI_IE)),TRUE);
                           }
                      }
                   return 0;
                   
    case RS_VERSION:
                   return RUNPAD_VERSION_DIG;
                   
    case RS_MESSAGE:
                   if ( wParam )
                      {
                        MsgBox((char*)wParam);
                      }
                   return 0;

    case RS_LANGUAGE:
                      IndicUpdate((HWND)wParam,lParam);
                      return 0;

    case RS_INDICCLICK:
                   if ( wParam == 1 && lParam == WM_LBUTTONUP )
                      {
                        IndicNextLang();
                      }
                   return 0;

    case RS_MIXERCLICK:
                   if ( wParam == 2 && lParam == WM_LBUTTONDBLCLK )
                      {
                        if ( !is_vista )
                           RunProcess("sndvol32.exe /t");
                        else
                           RunProcess("sndvol.exe -f 0");
                      }
                   return 0;

    case RS_MICROPHONECLICK:
                   if ( wParam == 4 && lParam == WM_LBUTTONDBLCLK )
                      {
                        if ( !is_vista )
                           RunProcess("sndvol32.exe /t /r");
                        else
                           RunProcess("sndvol.exe -r 0");
                      }
                   return 0;

    case RS_MINIMIZEALLCLICK:
                   if ( wParam == 3 && lParam == WM_LBUTTONUP )
                      {
                        ToggleDesktop();
                      }
                   return 0;
    
#ifdef DEBUG
    case RS_QUIT:
                   GlobalDoneWithoutApiDone(EL_OFFSHELL);
                   ApiDone();
                   ApiExit(1);
                   return 0;
#endif

    case RS_FLASHDISK:
                   if ( fastexit_use_flash && IsAnyOfInsertedFlashesHardwareIdFoundInList(fastexit_flash_list) )
                      {
                        if ( !IsAnyChildWindows() )
                           {
                             FastExitDialog();
                           }
                      }
                   else
                   if ( autoplay_flash && autoplay_flash_cmd[0] )
                      {
                        char drive[MAX_PATH];
                        DWORD sn,err;

                        wsprintf(drive,"%c:\\",wParam+'A');
                        
                        err = SetErrorMode(SEM_FAILCRITICALERRORS);

                        if ( GetVolumeInformation(drive,NULL,0,&sn,NULL,NULL,NULL,0) )
                           {
                             char s[MAX_PATH],*p;
                             lstrcpy(s,autoplay_flash_cmd);
                             p = StrStr(s,"%1");
                             if ( p )
                                {
                                  p[0] = drive[0];
                                  p[1] = drive[1];
                                }

                             if ( allow_use_flash && !net_flash[0] )
                                {
                                  ExecTool(s);
                                }
                           }

                        SetErrorMode(err);
                      }
                   return 0;

    case RS_PICTURESCANCOMPLETE:
                   if ( allow_scan_stat )
                      {
                        AddServiceString2SQLBase(GCID_PICTURESCAN,1,0,0,NULL);
                      }
                   return 0;

    case RS_EXECQLITEM:
                   if ( wParam )
                      {
                        ExecQLItem((void*)wParam);
                      }
                   return 0;
    
    case RS_RUNPROGRAMINTERNAL:
                   if ( wParam )
                      {
                        RunProgram((CShortcut*)wParam,FALSE,(CSheet*)lParam,TRUE);
                      }
                   return 0;
    
    case RS_RUNPROGRAM:
                   if ( wParam != 0 )
                      {
                        BOOL check_ext, add2stat;

                        char s[MAX_PATH];
                        s[0] = 0;
                        GlobalGetAtomName((ATOM)wParam,s,sizeof(s));
                        GlobalDeleteAtom((ATOM)wParam);

                        CSheet *sheet = NULL;
                        
                        if ( lParam )
                           {
                             char shname[MAX_PATH];

                             shname[0] = 0;
                             GlobalGetAtomName((ATOM)lParam,shname,sizeof(shname));
                             GlobalDeleteAtom((ATOM)lParam);

                             sheet = g_content.FindSheetByName(shname);
                             if ( !sheet /*|| !sheet->IsCurrentlyEnabled()*/ )
                                sheet = GetActiveSheet();

                             check_ext = (allow_run_from_folder_shortcuts ? FALSE : TRUE);
                             add2stat = TRUE;
                           }
                        else
                           {
                             sheet = NULL;
                             check_ext = TRUE;
                             add2stat = FALSE;
                           }

                        if ( s[0] )
                           {
                             CShortcut *sh = new CShortcut(s);
                             RunProgram(sh,check_ext,sheet,add2stat);
                             delete sh;
                           }
                      }
                   return 0;

    case RS_SHELLEXECUTE:
                   {
                     char s1[MAX_PATH];
                     char s2[MAX_PATH];
                     ATOM a1 = (ATOM)wParam;
                     ATOM a2 = (ATOM)lParam;
                     s1[0] = 0;
                     s2[0] = 0;

                     if ( a1 )
                        {
                          GlobalGetAtomName(a1,s1,sizeof(s1));
                          GlobalDeleteAtom(a1);
                        }
                     if ( a2 )
                        {
                          GlobalGetAtomName(a2,s2,sizeof(s2));
                          GlobalDeleteAtom(a2);
                        }

                     DoEnvironmentSubst(s1,sizeof(s1));
                     DoEnvironmentSubst(s2,sizeof(s2));
                        
                     if ( restrict_shellexechook )
                        {
                          if ( s1[0] )
                             {
                               int n;
                               char s[MAX_PATH];
                               char *ext[] = {".exe",".cmd",".bat",".com",".pif",".lnk",NULL};
                               char *file = s1;
                               char *dir = s2;
                               if ( !*dir )
                                  dir = NULL;

                               if ( PathIsDirectory(file) )
                                  {
                                    char msg[MAX_PATH*2];
                                    wsprintf(msg,LS(3021),file);
                                    ErrBoxTray(msg);
                                    return 0;
                                  }

                               s[0] = 0;
                               for ( n = 0; n < sizeof(ext)/sizeof(ext[0]); n++ )
                                   {
                                     char *p = NULL;
                                     s[0] = 0;
                                     if ( SearchPath(dir,file,ext[n],sizeof(s),s,&p) != 0 )
                                        break;
                                   }

                               if ( s[0] )
                                  {
                                    { 
                                      const char *f = PathFindFileName(s);

                                      TCFGLIST1 &list = allow_run;
                                      
                                      for ( int n = 0; n < list.size(); n++ )
                                          {
                                            if ( list[n].IsActive() )
                                               {
                                                 if ( PathMatchSpec(f,list[n].GetParm()) )
                                                    return 1;
                                               }
                                          }
                                    }
                                    
                                    if ( PathIsDirectory(s) || !IsExtensionAllowed(s) || !IsFileExist(s) )
                                       {
                                         char msg[MAX_PATH*2];
                                         wsprintf(msg,LS(3021),s);
                                         ErrBox(msg); //ErrBoxTray(msg);
                                         return 0;
                                       }

                                    return IsFileAssociationSetInRegistry(s) ? 1 : 0;
                                  }

                               if ( protected_protos[0] )
                                  {
                                    if ( IsProtoInList(protected_protos,file) )
                                       {
                                         char msg[MAX_PATH*2];
                                         wsprintf(msg,LS(3021),file);
                                         ErrBoxTray(msg);
                                         return 0;
                                       }
                                  }
                             }
                        }
                   }
                   return 1;

    case RS_COPYHOOK:
                   {
                     char s[MAX_PATH];
                     ATOM a = (ATOM)lParam;
                     s[0] = 0;
                     if ( a )
                        {
                          GlobalGetAtomName(a,s,sizeof(s));
                          GlobalDeleteAtom(a);
                        }

                     if ( restrict_copyhook && !IsTempRelativeDir(s) )
                        {
                          char msg[MAX_PATH];
                          const char *op = "";
                          switch ( (int)wParam )
                          {
                            case FO_COPY:    op = LS(3022); break;
                            case FO_DELETE:  op = LS(3023); break;
                            case FO_MOVE:    op = LS(3024); break;
                            case FO_RENAME:  op = LS(3025); break;
                          };

                          if ( wParam == FO_RENAME && allow_newfolder_opensave )
                             return 1; //todo: remove this workaround
                          
                          wsprintf(msg,LS(3026),op,s);
                          ErrBoxTray(msg);
                          return 0;
                        }
                   }
                   return 1;

    case RS_GETCADMENU:
                   return (DWORD)OnGetCADMenu();

    case RS_CADMENUACTION:
                   OnCADMenuAction(wParam);
                   return 0;

    case RS_MIXERUPDATEICON:
                   MixerUpdate();
                   return 0;

    case RS_GETVIPSESSIONNAME:
                   if ( vip_session[0] )
                      return (int)GlobalAddAtom(vip_session);
                   return 0;

    case RS_GETVIPSESSIONPATH:
                   if ( vip_folder[0] )
                      return (int)GlobalAddAtom(vip_folder);
                   return 0;

    case RS_GETFAVPATH:
                   {
                      char t[MAX_PATH];
                      char sys_fav[MAX_PATH] = "";

                      lstrcpy(t,fav_path);
                      ExpandPath(t);
                      GetSpecialFolder(CSIDL_FAVORITES,sys_fav);
                      StrReplaceI(t,"%FAVORITES%",sys_fav);

                      if ( StrStr(t,"%") )
                         t[0] = 0;

                      if ( t[0] )
                         CreateDirectory(t,NULL);

                      return (int)GlobalAddAtom(t);
                   }
                   return 0;

    case RS_OPENWITHNOTEPAD:
                   if ( wParam )
                      {
                        char s[MAX_PATH];
                        
                        s[0] = 0;
                        GlobalGetAtomName((ATOM)wParam,s,MAX_PATH);
                        GlobalDeleteAtom((ATOM)wParam);

                        if ( s[0] )
                           {
                             char cmd[MAX_PATH];
                             
                             if ( !use_bodytool_notepad )
                                {
                                  wsprintf(cmd,"notepad.exe \"%s\"",s);
                                }
                             else
                                {
                                  wsprintf(cmd,"\"%sbodynotepad.exe\" \"%s\"",our_currpath,s);
                                }

                             RunProcess(cmd);
                           }
                      }
                   return 0;

    case RS_OPENWITHMP:
                   if ( wParam )
                      {
                        char s[MAX_PATH];
                        
                        s[0] = 0;
                        GlobalGetAtomName((ATOM)wParam,s,MAX_PATH);
                        GlobalDeleteAtom((ATOM)wParam);

                        if ( s[0] )
                           {
                             char cmd[MAX_PATH];
                             
                             wsprintf(cmd,"\"%sbodymp.exe\" \"%s\"",our_currpath,s);

                             RunProcess(cmd);
                           }
                      }
                   return 0;

    case RS_DESTROYSHADER:
                   if ( wParam && IsWindow((HWND)wParam) )
                      DestroyShader((HWND)wParam);
                   return 0;

    case RS_CHECKURL:
    case RS_CHECKURLWITHOUTRESTRICT:
                   if ( wParam )
                      {
                        char s[MAX_PATH];
                        char ext[MAX_PATH];
                        
                        s[0] = 0;
                        GlobalGetAtomName((ATOM)wParam,s,MAX_PATH);
                        GlobalDeleteAtom((ATOM)wParam);
                        ext[0] = 0;
                        if ( lParam )
                           {
                             GlobalGetAtomName((ATOM)lParam,ext,MAX_PATH);
                             GlobalDeleteAtom((ATOM)lParam);
                           }

                        if ( s[0] )
                           {
                             int n;
                             char proto[MAX_PATH];

                             if ( !StrCmpNI(s,"res:",4) && !lstrcmpi(ext,"htm") )
                                return 0;  //always allow our error page

                             if ( !lstrcmpi(s,"about:blank") )
                                return 0;
                             
                             if ( (lstrlen(s)>=2 && s[1]==':') || 
                                  !StrCmpNI(s,"\\\\",2) ||
                                  !StrCmpNI(s,"file:",5) ||
                                  !StrCmpNI(s,"res:",4) )
                                {
                                  //local resource
                                  if ( !ext[0] )
                                     return 2;

                                  if ( !IsExtensionInList(ext,ie_local_res) )
                                     return 2;

                                  const char *file_part = s;
                                  if ( StrCmpNI(s,"file:///",8) == 0 )
                                     file_part = s+8;
                                  else
                                  if ( StrCmpNI(s,"file://",7) == 0 )
                                     file_part = s+7;
                                  
                                  if ( IsExtensionInList(ext,ie_open_with_mp) )
                                     {
                                       char cmd[MAX_PATH];
                                       wsprintf(cmd,"\"%sbodymp.exe\" \"%s\"",our_currpath,file_part);
                                       RunProcess(cmd);
                                       return 1;
                                     }
                                  else
                                  if ( IsExtensionInList(ext,ie_open_with_ext) )
                                     {
                                       if ( restrict_shellexechook )
                                          {
                                            if ( !IsExtensionAllowed(file_part) )
                                               return 2;
                                          }

                                       ShellExecute(NULL,NULL,file_part,NULL,NULL,SW_SHOWNORMAL);
                                       return 1;
                                     }
                                  else
                                     return 0;
                                }

                             proto[0] = 0;
                             for ( n = 0; n < lstrlen(s); n++ )
                                 if ( s[n] == ':' )
                                    {
                                      lstrcpyn(proto,s,n+1);
                                      break;
                                    }
                             if ( proto[0] )
                                {
                                  if ( IsExtensionInList(proto,ie_disallowed_protos) )
                                     return 2;
                                  else
                                     {
                                       if ( !ftp_enable && !StrCmpNI(s,"ftp:",4) )
                                          return 2;
                                       
                                       if ( !StrCmpNI(s,"ftp:",4) || !StrCmpNI(s,"http",4) )
                                          {
                                            if ( message != RS_CHECKURLWITHOUTRESTRICT )
                                               {
                                                 if ( !CheckUrlSite(s) )
                                                    return 2;
                                                 else
                                                    {
                                                      if ( IsThisURLMustBeRedirected(s) )
                                                         {
                                                           if ( !IsStrEmpty(redirection_url) )
                                                              {
                                                                return ((int)GlobalAddAtom(redirection_url))|0x80000000;
                                                              }
                                                         }
                                                    }
                                               }
                                          }
                                       
                                       if ( IsExtensionInList(ext,ie_open_with_mp) )
                                          {
                                            char cmd[MAX_PATH];
                                            wsprintf(cmd,"\"%sbodymp.exe\" \"%s\"",our_currpath,s);
                                            RunProcess(cmd);
                                            return 1;
                                          }
                                       else
                                       if ( IsExtensionInList(ext,ie_open_with_ext) )
                                          {
                                            return 3;
                                          }
                                       else
                                          return 0;
                                     }
                                }
                             else
                                return 2;
                           }
                      }
                   return 1;

    case RS_COPYISO:
                   {
                     char s[MAX_PATH] = "";
                     if ( wParam )
                        {
                          GlobalGetAtomName((ATOM)wParam,s,MAX_PATH);
                          GlobalDeleteAtom((ATOM)wParam);
                        }
                     if ( s[0] && IsFileExist(s) )
                        {
                          void *h = sys_fopenr(s);
                          if ( h )
                             {
                               ULARGE_INTEGER size;
                               unsigned size_mb;
                               size.HighPart = 0;
                               size.LowPart = GetFileSize(h,&size.HighPart);
                               size_mb = (size.QuadPart >> 20);
                               sys_fclose(h);

                               if ( allow_burn_stat )
                                  {
                                    char s_title[MAX_PATH];
                                    lstrcpyn(s_title,PathFindFileName(s),sizeof(s_title)-1);
                                    AddServiceString2SQLBase(GCID_ISO,1,size_mb*1024,0,s_title);
                                  }
                             }
                        }
                   }
                   return 0;
    
    case RS_BURNCOMPLETE:
                   {
                     char title[MAX_PATH];
                     int cd_type,size;

                     title[0] = 0;
                     if ( wParam )
                        {
                          GlobalGetAtomName((ATOM)wParam,title,MAX_PATH);
                          GlobalDeleteAtom((ATOM)wParam);
                        }
                     if ( !title[0] )
                        lstrcpy(title,"noname");

                     cd_type = (lParam & 0x80000000) ? 1 : 0;
                     size = (lParam & ~0x80000000);

                     if ( on_burn_complete[0] )
                        {
                          char s[MAX_PATH];
                          char s_type[MAX_PATH];
                          char s_size[MAX_PATH];
                          char s_title[MAX_PATH];

                          lstrcpy(s,on_burn_complete);
                          wsprintf(s_type,"%d",cd_type);
                          wsprintf(s_size,"%d",size);
                          wsprintf(s_title,"\"%s\"",title);
                          StrReplaceI(s,"%TYPE%",s_type);
                          StrReplaceI(s,"%SIZE%",s_size);
                          StrReplaceI(s,"%TITLE%",s_title);

                          if ( s[0] )
                             {
                               RunProcess(CCmdLineExpander(s));
                             }
                        }

                     if ( allow_burn_stat )
                        {
                          char s_title[MAX_PATH];
                          lstrcpyn(s_title,title,sizeof(s_title)-1);
                          
                          if ( cd_type )
                             AddServiceString2SQLBase(GCID_BURNDVD,1,size,0,s_title);
                          else
                             AddServiceString2SQLBase(GCID_BURNCD,1,size,0,s_title);
                        }
                   }
                   return 0;

    case RS_BLUETOOTHWORK:
    case RS_MOBILECONTENT:
                   if ( allow_bt_stat )
                      {
                        BOOL is_sended = ((wParam & 0x80000000) != 0);
                        int count = (wParam & 0x7FFFFFFF);
                        int size = lParam;

                        if ( message == RS_BLUETOOTHWORK )
                           {
                             if ( is_sended )
                                AddServiceString2SQLBase(GCID_BTSEND,count,size,0,NULL);
                             else
                                AddServiceString2SQLBase(GCID_BTRECV,count,size,0,NULL);
                           }
                        else
                           {
                             AddServiceString2SQLBase(GCID_MOBILECONTENT,count,size,0,NULL);
                           }
                      }
                   return 0;

    case RS_MAILSENDED:
                   {
                     char from[MAX_PATH] = "";
                     char subj[MAX_PATH] = "";

                     if ( wParam )
                        {
                          GlobalGetAtomName((ATOM)wParam,from,MAX_PATH);
                          GlobalDeleteAtom((ATOM)wParam);
                        }

                     if ( lParam )
                        {
                          GlobalGetAtomName((ATOM)lParam,subj,MAX_PATH);
                          GlobalDeleteAtom((ATOM)lParam);
                        }
                   
                     if ( allow_mail_stat )
                        {
                          char desc[MAX_PATH];
                          char s_from[20];
                          char s_subj[40];
                          
                          lstrcpyn(s_from,from,sizeof(s_from)-1);
                          lstrcpyn(s_subj,subj,sizeof(s_subj)-1);

                          wsprintf(desc,"From: \"%s\", Subj: \"%s\"",s_from,s_subj);
                          
                          AddServiceString2SQLBase(GCID_MAIL,1,0,0,desc);
                        }
                   }
                   return 0;

    case RS_PRINTERJOBADD:
                   {
                     char desc[MAX_PATH] = "";
                     
                     if ( wParam )
                        {
                          GlobalGetAtomName((ATOM)wParam,desc,MAX_PATH);
                          GlobalDeleteAtom((ATOM)wParam);
                        }
                     
                     if ( allow_printer_control )
                        {
                          int count = (lParam >> 20) & 0xFFF;
                          int size = lParam & 0xFFFFF;

                          AddServiceString2SQLBase(GCID_PRINTER,count,size,0,desc);
                        }
                   }
                   return 0;

    case RS_NETBURNCOMPLETE:
                   if ( wParam )
                      {
                        char path[MAX_PATH];

                        path[0] = 0;
                        GlobalGetAtomName((ATOM)wParam,path,MAX_PATH);
                        GlobalDeleteAtom((ATOM)wParam);

                        if ( path[0] && IsFileExist(path) )
                           {
                             char s[MAX_PATH];
                             CNetCmd cmd(NETCMD_NETBURN_REQ);
                             cmd.AddStringParm(NETPARM_S_MACHINELOC,machine_loc);
                             cmd.AddStringParm(NETPARM_S_MACHINEDESC,machine_desc);
                             cmd.AddStringParm(NETPARM_S_DOMAIN,GetDomainName(s));
                             cmd.AddStringParm(NETPARM_S_USERNAME,MyGetUserName(s));
                             cmd.AddStringParm(NETPARM_S_PATH,path);
                             NetSend(cmd,NETGUID_FIRST_OPERATOR);
                           }
                      }
                   return 0;

    case RS_NETBTCOMPLETE:
                   if ( wParam )
                      {
                        char path[MAX_PATH];

                        path[0] = 0;
                        GlobalGetAtomName((ATOM)wParam,path,MAX_PATH);
                        GlobalDeleteAtom((ATOM)wParam);

                        if ( path[0] && IsFileExist(path) )
                           {
                             char s[MAX_PATH];
                             CNetCmd cmd(NETCMD_NETBT_REQ);
                             cmd.AddStringParm(NETPARM_S_MACHINELOC,machine_loc);
                             cmd.AddStringParm(NETPARM_S_MACHINEDESC,machine_desc);
                             cmd.AddStringParm(NETPARM_S_DOMAIN,GetDomainName(s));
                             cmd.AddStringParm(NETPARM_S_USERNAME,MyGetUserName(s));
                             cmd.AddStringParm(NETPARM_S_PATH,path);
                             cmd.AddBoolParm(NETPARM_B_MOBILECONTENT,lParam?TRUE:FALSE);
                             NetSend(cmd,NETGUID_FIRST_OPERATOR);
                           }
                      }
                   return 0;

    case RS_MEDIAINSERTED:
                   if ( wParam >= 2 && wParam < 26 )
                      {
                        char drive[8];
                        DWORD err;

                        drive[0] = wParam+'A';
                        drive[1] = ':';
                        drive[2] = 0;

                        err = SetErrorMode(SEM_FAILCRITICALERRORS);
                        
                        // CD audio
                        if ( autoplay_cda && autoplay_cda_cmd[0] )
                           {
                             char s[MAX_PATH],*p;

                             wsprintf(s,"%s\\track01.cda",drive);
                             if ( IsFileExist(s) )
                                {
                                  lstrcpy(s,autoplay_cda_cmd);
                                  p = StrStr(s,"%1");
                                  if ( p )
                                     {
                                       p[0] = drive[0];
                                       p[1] = drive[1];
                                     }

                                  ExecTool(s);
                                }
                           }

                        // DVD movie
                        if ( TRUE )
                           {
                             char s1[MAX_PATH];
                             char s2[MAX_PATH];

                             wsprintf(s1,"%s\\VIDEO_TS\\VIDEO_TS.VOB",drive);
                             wsprintf(s2,"%s\\VIDEO_TS\\VIDEO_TS.IFO",drive);
                             if ( IsFileExist(s1) || IsFileExist(s2) )
                                {
                                  if ( autoplay_dvd && autoplay_dvd_cmd[0] )
                                     {
                                       char s[MAX_PATH],*p;
                                       lstrcpy(s,autoplay_dvd_cmd);
                                       p = StrStr(s,"%1");
                                       if ( p )
                                          {
                                            p[0] = drive[0];
                                            p[1] = drive[1];
                                          }

                                       ExecTool(s);
                                     }

                                  if ( allow_dvd_stat && allow_use_cdrom && !net_cdrom[0] )
                                     {
                                       AddServiceString2SQLBase(GCID_INSERTDVD,1,0,0,NULL);
                                     }
                                }
                           }

                        // empty disk CDR/RW
                        if ( autoplay_cdr && autoplay_cdr_cmd[0] )
                           {
                             char s[MAX_PATH],*p;
                             DWORD sn;

                             wsprintf(s,"%s\\",drive);
                             
                             if ( !GetVolumeInformation(s,NULL,0,&sn,NULL,NULL,NULL,0) )
                                {
                                  lstrcpy(s,autoplay_cdr_cmd);
                                  p = StrStr(s,"%1");
                                  if ( p )
                                     {
                                       p[0] = drive[0];
                                       p[1] = drive[1];
                                     }

                                  ExecTool(s);
                                }
                           }

                        SetErrorMode(err);
                      }
                   return 0;

    case RS_FLASHINSERTED4STAT:
                   if ( wParam >= 2 && wParam < 26 )
                      {
                        OnFlashDriveInserted4Stat(wParam);
                      }
                   return 0;

    case RS_FLASHREMOVED4STAT:
                   if ( wParam >= 2 && wParam < 26 )
                      {
                        OnFlashDriveRemoved4Stat(wParam);
                      }
                   return 0;

    case RS_FLASHFORMATTED4STAT:
                   if ( wParam >= 2 && wParam < 26 )
                      {
                        OnFlashDriveFormatted4Stat(wParam);
                      }
                   return 0;

    case RS_FLASHFILESADDED4STAT:
                   if ( wParam >= 2 && wParam < 26 )
                      {
                        OnFlashDriveFilesAdded4Stat(wParam);
                      }
                   return 0;

    case RS_FLASHFILESDELETED4STAT:
                   if ( wParam >= 2 && wParam < 26 )
                      {
                        OnFlashDriveFilesDeleted4Stat(wParam);
                      }
                   return 0;

    case RS_CAMERACONNECTED:
                   if ( allow_photocam )
                      {
                        MsgBox(LS(3216));
                        ExecTool("$bodyexpl");
                      }
                   return 0;

    case RS_GETPHOTOS:
                   if ( allow_photocam )
                      {
                        int count = wParam;
                        int kbsize = lParam;

                        AddServiceString2SQLBase(GCID_DIGITALCAMERA,count,kbsize,0,NULL);
                      }
                   return 0;

    case RS_SHOWLA:
                   ShowLA();
                   return 0;
                   
  };


  *is_processed = FALSE;
  return 0;
}
