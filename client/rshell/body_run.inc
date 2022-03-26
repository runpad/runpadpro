
BOOL IsExtensionAllowed(const char *path)
{
  return IsExtensionAllowedInternal(path,allowed_ext);
}


BOOL ExecutionMustBeProtectedBecauseClientNotLoaded(void)
{
  if ( client_restore[0] )
     {
       int pid = FindProcess(PathFindFileName(CPathExpander(client_restore)));
       if ( pid != -1 )
          {
            unsigned t_process = GetProcessCreationTimeInSec(pid);
            if ( t_process )
               {
                 __int64 ft = GetSystemTime64();
                 unsigned t_now = GetNormalTimeSec((FILETIME*)&ft);

                 if ( t_now - t_process > 3 )
                    return FALSE;
                 else
                    return TRUE;
               }
            else
               return FALSE;
          }
       else
          return TRUE;
     }
  else
     return FALSE;
}


static void RunBatScript(const char *cwd,const char *token)
{
  if ( token && token[0] )
     {
       char old_dir[MAX_PATH] = "";
       char script[8192];
       
       GetCurrentDirectory(MAX_PATH,old_dir);
       SetCurrentDirectory(cwd);

       script[0] = 0;
       LoadTextFromDescriptionToken(token,script,sizeof(script)-1);

       if ( script[0] )
          {
            char s[MAX_PATH] = "";

            GetTempPath(MAX_PATH,s);
            PathAppend(s,"rs_scrpt.bat");
            sys_deletefile(s);

            WriteFullFile(s,script,lstrlen(script));
            if ( IsFileExist(s) )
               RunHiddenProcessAndWait(s,NULL);

            sys_deletefile(s);
          }

       SetCurrentDirectory(old_dir);
     }
}


void RunProgram(const CShortcut *shortcut,BOOL checkext,const CSheet *sheet,BOOL add2stat)
{
  if ( !shortcut )
     return;
  
#ifndef DEBUG
  if ( !IsOurServiceActive() )
     {
       ErrBox(LS(3028));
       return;
     }
#endif

  if ( !IsLicenseWithShell() )
     {
       MsgBox(LS(3239));
       return;
     }
     
  if ( protect_run_from_api )
     {
       MsgBox(LS(3029));
       return;
     }
  
  if ( protect_run_when_nosql && !sql_base_ready )
     {
       MsgBox(LS(3002));
       return;
     }
  
  if ( protect_in_safe_mode && IsRunningInSafeMode() )
     {
       MsgBox(LS(3030));
       return;
     }
  
  if ( IsCopyDeleteThreadsSensitive() )
     {
       if ( GetCopyDeleteThreadsCount() > 0 )
          {
            MsgBox(LS(3031));
            return;
          }
       else
          {
            SetCopyDeleteThreadsCount(0);
            SetCopyDeleteThreadsSensitivity(FALSE);
          }
     }

  if ( IsGCInstalled() )
     {
       if ( !FindGCWindow() )
          {
            MsgBox(LS(3032));
            return;
          }
     }

  if ( ExecutionMustBeProtectedBecauseClientNotLoaded() )
     {
       MsgBox(LS(3009));
       return;
     }


  CWaitCursor oCursor;

  CRealShortcut rsh(*shortcut);
  const char *path = rsh.GetExePath();
  BOOL is_url = PathIsURL(path);
  
  if ( !IsStrEmpty(rsh.GetPassword()) )
     {
       const char *p = ShowPassword(LS(3033));
       if ( !p || !p[0] )
          {
            return;
          }
       else
          {
            if ( lstrcmpi(rsh.GetPassword(),p) )
               {
                 return;
               }
          }
     }

  // we must insert VCD first, then check file for existance, because it maybe on VCD!
  if ( !IsStrEmpty(rsh.GetVCDPath()) )
     {
       InsertVCD(rsh.GetVCDPath(),rsh.GetVCDNum());
     }

  if ( !is_url && checkext )
     {
       CDisableWOW64FSRedirection fsg;

       if ( PathIsDirectory(path) || !IsExtensionAllowed(path) /*|| !IsFileAssociationSetInRegistry(path)*/ )
          {
            ErrBox(LS(3034));
            return;
          }
     }

  
  {
    CDisableWOW64FSRedirection fsg;

    if ( !is_url && PathIsDirectory(path) )
       {
         DisplayFolder(path);
         return;
       }

    if ( !is_url && !IsFileExist(path) )
       {
         ErrBox(LS(3035));
         return;
       }
  }

  if ( allow_run_only_one && rsh.GetAllowOnlyOne() && IsProcessSpyed() )
     {
       MsgBox(LS(3036));
       return;
     }

  if ( !lstrcmpi(PathFindFileName(path),"steam.exe") && StrStrI(rsh.GetArg(),"-applaunch ") )
     {
       CFloatLic::ShutdownSteamAndSteamLicsWait();
     }

  CFloatLicSingle *fl = NULL;

  if ( !IsStrEmpty(rsh.GetFloatLic()) )
     {
       fl = CFloatLic::Execute(rsh.GetFloatLic(),"FLOATLIC");
       if ( !fl )
          return;
       else
          fl->SetEnvForThisProcess();
     }
  else
     {
       if ( !is_url && !ExecuteLicMan(path) )
          return;
     }

  
  RunBatScript(rsh.GetCWD(),rsh.GetScript1());

  if ( !GetForegroundWindow() )
     SetForegroundWindow(GetMainWnd()); //needed for some programs!
  
  int pid = -1;

  char layer[MAX_PATH];
  layer[0] = 0;
  GetEnvironmentVariable("__COMPAT_LAYER",layer,sizeof(layer));
  SetEnvironmentVariable("__COMPAT_LAYER",NULL);

//  if ( !lstrcmpi(PathFindFileName(path),"LA2.exe") || !lstrcmpi(PathFindFileName(path),"L2.exe") || !lstrcmpi(PathFindFileName(path),"LineageII.exe") || !lstrcmpi(PathFindFileName(path),"Lineage II.exe") ||
//       StrStrI(rsh.GetName(),"Lineage") || StrStrI(rsh.GetName(),"LA2") || StrStrI(rsh.GetName(),"Линейка") )
//     {
//       ExecExplorerUmulator4LA2();
//     }
  
  {
    CRealShortcut rsh(*shortcut);  // recreate because of envvars after floatlicman.Execute()

    if ( (pid = RunAsAnotherUser(&rsh)) == -1 )
       {
         pid = RunAsThisUser(&rsh);
       }
  }

  SetEnvironmentVariable("__COMPAT_LAYER",layer[0]?layer:NULL);

  if ( fl )
     {
       fl->SetPid(pid);  // can be -1
       fl->ClearEnvForThisProcess();
       CFloatLic::Add(fl);
       fl = NULL;
     }

  if ( allow_run_only_one && rsh.GetAllowOnlyOne() && pid != -1 )
     {
       SetSpyProcess(pid);
     }

  if ( add2stat && stat_enable )
     {
       if ( (is_url && do_web_stat) || (!is_url && !IsExtensionAllowedInternal(path,stat_excl)) )
          {
            char s_url[MAX_PATH]; //file path in temp dir, not URL!
            if ( is_url )
               {
                 CreateUrlFile(path,s_url);
                 path = s_url;
               }
            
            HICON icon = NULL;
            
            if ( !IsStrEmpty(rsh.GetIconPath()) && !IsPictureFile(rsh.GetIconPath()) )
               ExtractIconEx(rsh.GetIconPath(),rsh.GetIconIdx(),NULL,&icon,1);
            
            if ( !icon )
               icon = ExtractSingleIconInOldMethod(path,16);

            Add2Stat(sheet,rsh.GetName(),pid,icon,FALSE);

            if ( icon )
               DestroyIcon(icon);
          }
     }
}

