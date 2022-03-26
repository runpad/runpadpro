

void GetLnkFileInfo(const char *filename,char *path,char *desc,char *arg,char *cwd,int *showcmd,char *iconpath,int *iconidx,BOOL invoke_msi)
{
  IShellLink *psl = NULL; 
  IPersistFile *ppf = NULL; 
  IShellLinkDataList *psld = NULL;

  CoCreateInstance(CLSID_ShellLink,NULL,CLSCTX_INPROC_SERVER,IID_IShellLink,(void **)&psl);
  if ( psl )
     {
       psl->QueryInterface(IID_IPersistFile,(void **)&ppf); 
       psl->QueryInterface(IID_IShellLinkDataList,(void **)&psld);
     }

  {
    WCHAR wsz[MAX_PATH]; 
    WIN32_FIND_DATA wfd; 
    char tpath[MAX_PATH];
    char ticonpath[MAX_PATH];
    char tdesc[MAX_PATH];
    char targ[MAX_PATH];
    char tcwd[MAX_PATH];
    int tshowcmd, ticonidx;

    tpath[0] = 0;
    ticonpath[0] = 0;
    tdesc[0] = 0;
    targ[0] = 0;
    tcwd[0] = 0;
    tshowcmd = SW_SHOWNORMAL;
    ticonidx = 0;

    if ( psl && ppf )
       {
         MultiByteToWideChar(CP_ACP,0,filename,-1,wsz,MAX_PATH);
         if ( ppf->Load(wsz,STGM_READ) == S_OK ) 
            {
              psl->GetPath(tpath,sizeof(tpath),&wfd,0);
              psl->GetArguments(targ,sizeof(targ));
              psl->GetIconLocation(ticonpath,sizeof(ticonpath),&ticonidx);
              psl->GetWorkingDirectory(tcwd,sizeof(tcwd));
              psl->GetShowCmd(&tshowcmd);
              psl->GetDescription(tdesc,sizeof(tdesc));

              if ( psld && path && invoke_msi )
                 {
                   DWORD dwFlags = 0;
                   psld->GetFlags(&dwFlags);
                   if ( dwFlags & SLDF_HAS_DARWINID )
                      {
                        LPITEMIDLIST pidl = NULL;
                        
                        // this call can create sometimes (0.01% cases:-) windows and message loops, which is unsupported in shell !!!!!!!
                        // maybe move this into another thread? see win2k shelllnk.cpp for darwin implementation
                        psl->Resolve(NULL,SLR_INVOKE_MSI | SLR_NO_UI | SLR_NOSEARCH /*| SLR_UPDATE*/);
                        psl->GetIDList(&pidl);

                        if ( pidl )
                           {
                             char s[MAX_PATH];

                             s[0] = 0;
                             SHGetPathFromIDList(pidl,s);

                             if ( s[0] )
                                lstrcpy(tpath,s);
                           }
                      }
                 }
            }
       }

    if ( !tpath[0] )
       lstrcpy(tpath,filename);

    //if ( !tcwd[0] )
    //   GetDirFromPath(tpath,tcwd);

    //if ( !ticonpath[0] )
    //   {
    //     lstrcpy(ticonpath,tpath);
    //     ticonidx = 0;
    //   }

    DoEnvironmentSubst(tcwd,sizeof(tcwd));
    DoEnvironmentSubst(tpath,sizeof(tpath));
    DoEnvironmentSubst(ticonpath,sizeof(ticonpath));

    if ( tshowcmd != SW_SHOWNORMAL && tshowcmd != SW_SHOWMAXIMIZED && tshowcmd != SW_SHOWMINIMIZED && tshowcmd != SW_SHOWMINNOACTIVE && tshowcmd != SW_MINIMIZE && tshowcmd != SW_FORCEMINIMIZE )
       tshowcmd = SW_SHOWNORMAL;

    if ( path )
       lstrcpy(path,tpath);

    if ( iconpath )
       lstrcpy(iconpath,ticonpath);

    if ( desc )
       lstrcpy(desc,tdesc);

    if ( arg )
       lstrcpy(arg,targ);

    if ( cwd )
       lstrcpy(cwd,tcwd);

    if ( showcmd )
       *showcmd = tshowcmd;

    if ( iconidx )
       *iconidx = ticonidx;
  }

  if ( psld )
     psld->Release(); 
  if ( ppf )
     ppf->Release(); 
  if ( psl )
     psl->Release(); 
}

