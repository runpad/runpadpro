
static BOOL __cdecl CB_WaitDTools(void *parm)
{
  unsigned start = (unsigned)parm;

  if ( GetTickCount() - start > 10000 )
     {
       ErrBoxW(WSTR_011);
       return FALSE;
     }
  
  return TRUE;
}


static int VCD1(const char *file)
{
  // FarStone VDrive code
  char s[MAX_PATH];
  s[0] = 0;
  GetWindowsDirectory(s,sizeof(s));
  PathAddBackslash(s);
  lstrcat(s,"vdrive.exe");
  if ( IsFileExist(s) )
     {
       char cmd[MAX_PATH*2];
       int rc;

       lstrcpy(cmd,"vdrive.exe /drives");
       rc = 0;
       if ( !RunHiddenProcessAndWait(cmd,&rc) || rc == 0 )
          return -1;
     
       wsprintf(cmd,"vdrive.exe 1: \"%s\" /i",file);
       rc = 1;
       if ( !RunHiddenProcessAndWait(cmd,&rc) || rc == 1 )
          return -1;
       
       return 0;
     }

  return -1;
}


static int VCD2(const char *file)
{
  DWORD (WINAPI *VCDApiEject)(LPCSTR szDriveOrFileName);
  DWORD (WINAPI *VCDApiGetVCDDriveLetters)(LPSTR lpResult, size_t nResultLen);
  DWORD (WINAPI *VCDApiInsert)(char cDrive, LPCSTR szFileName, LPCSTR szPassword);
  void (WINAPI *VCDApiUnLockVCDDrive)(char cDrive);
  BOOL (WINAPI *VCDApiIsVCDDriveLocked)(char cDrive);
  DWORD (WINAPI *VCDApiIsProperlyInstalled)(void);

  char s[MAX_PATH],drive;
  HINSTANCE lib;

  // Virtual CD 5,6,7 code
  lib = LoadLibrary("vc5api.dll");
  if ( !lib )
     lib = LoadLibrary("vc6api.dll");
  if ( !lib )
     lib = LoadLibrary("vc7api.dll");

  if ( lib )
     {
       *(void**)&VCDApiEject = (void *)GetProcAddress(lib,"VCDApiEject");
       *(void**)&VCDApiGetVCDDriveLetters = (void *)GetProcAddress(lib,"VCDApiGetVCDDriveLetters");
       *(void**)&VCDApiInsert = (void *)GetProcAddress(lib,"VCDApiInsert");
       *(void**)&VCDApiUnLockVCDDrive = (void *)GetProcAddress(lib,"VCDApiUnLockVCDDrive");
       *(void**)&VCDApiIsVCDDriveLocked = (void *)GetProcAddress(lib,"VCDApiIsVCDDriveLocked");
       *(void**)&VCDApiIsProperlyInstalled = (void *)GetProcAddress(lib,"VCDApiIsProperlyInstalled");

       if ( VCDApiEject &&
            VCDApiGetVCDDriveLetters &&
            VCDApiInsert &&
            VCDApiUnLockVCDDrive &&
            VCDApiIsVCDDriveLocked &&
            VCDApiIsProperlyInstalled )
          {
            if ( !VCDApiIsProperlyInstalled() )
               {
                 s[0] = 0;
                 VCDApiGetVCDDriveLetters(s,sizeof(s));

                 if ( !s[0] )
                    {
                      FreeLibrary(lib);
                      return -1;
                    }

                 drive = s[0];
                 s[1] = 0;

                 if ( VCDApiIsVCDDriveLocked(drive) )
                    VCDApiUnLockVCDDrive(drive);

                 if ( VCDApiInsert(drive,file,"") )
                    {
                      FreeLibrary(lib);
                      return -1;
                    }

                 FreeLibrary(lib);
                 return 0;
               }
          }

       FreeLibrary(lib);
       return -1;
     }

  return -1;
}


static int VCD3(const char *file)
{
  char s[MAX_PATH];
  ExpandPath(alcohol_path,s);

  // Alcohol CD Emulator code
  if ( s[0] && IsFileExist(s) )
     {
       char cmd[MAX_PATH*2];
       int rc;

       wsprintf(cmd,"\"%s\" /L",s);
       rc = 0;
       if ( !RunHiddenProcessAndWait(cmd,&rc) || rc == 0 )
          return -1;
     
       wsprintf(cmd,"\"%s\" 1: /M:\"%s\"",s,file);
       rc = 1;
       if ( !RunHiddenProcessAndWait(cmd,&rc) || rc == 1 )
          return -1;
       
       return 0;
     }

  return -1;
}


static int VCD4(const char *file)
{
  char s[MAX_PATH];
  ExpandPath(daemon_path,s);

  // Daemon-Tools Lite (DT)
  if ( s[0] && IsFileExist(s) )
     {
       char cmd[MAX_PATH*2];
       wsprintf(cmd,"\"%s\" -mount dt, 0,\"%s\"",s,file);

       if ( RunHiddenProcessAndWaitIdle(cmd,NULL,CB_WaitDTools,(void*)GetTickCount()) )
          return 0;
     }

  return -1;
}


static int VCD5(const char *file)
{
  char s[MAX_PATH];
  ExpandPath(daemon_pro_path,s);

  // Daemon-Tools Pro (SCSI)
  if ( s[0] && IsFileExist(s) )
     {
       char cmd[MAX_PATH*2];
       wsprintf(cmd,"\"%s\" -mount scsi, 0,\"%s\"",s,file);

       if ( RunHiddenProcessAndWaitIdle(cmd,NULL,CB_WaitDTools,(void*)GetTickCount()) )
          return 0;
     }

  return -1;
}


static int VCD6(const char *file)
{
  char s[MAX_PATH];
  ExpandPath(daemon_pro_path,s);

  // Daemon-Tools Pro (DT)
  if ( s[0] && IsFileExist(s) )
     {
       char cmd[MAX_PATH*2];
       wsprintf(cmd,"\"%s\" -mount dt, 0,\"%s\"",s,file);

       if ( RunHiddenProcessAndWaitIdle(cmd,NULL,CB_WaitDTools,(void*)GetTickCount()) )
          return 0;
     }

  return -1;
}


static int VCD7(const char *file)
{
  char s[MAX_PATH];
  ExpandPath(daemon_path,s);

  // Daemon-Tools Lite (SCSI)
  if ( s[0] && IsFileExist(s) )
     {
       char cmd[MAX_PATH*2];
       wsprintf(cmd,"\"%s\" -mount scsi, 0,\"%s\"",s,file);

       if ( RunHiddenProcessAndWaitIdle(cmd,NULL,CB_WaitDTools,(void*)GetTickCount()) )
          return 0;
     }

  return -1;
}




typedef struct {
const char *name;
int (*func)(const char*);
} VCDMAN;

static VCDMAN vcd_managers[] = 
{
  {"Virtual Drive",VCD1},
  {"Virtual CD",VCD2},
  {"Alcohol",VCD3},
  {"Daemon-Tools Lite (DT)",VCD4},
  {"Daemon-Tools Pro Standard/Advanced (SCSI)",VCD5},
  {"Daemon-Tools Pro Standard/Advanced (DT)",VCD6},
  {"Daemon-Tools Lite (SCSI)",VCD7},
};
static const int vcd_managers_count = sizeof(vcd_managers)/sizeof(vcd_managers[0]);



void InsertVCD(const char *file,int num)
{
  int n;
  
  if ( num >= 0 && num < vcd_managers_count )
     {
       if ( !vcd_managers[num].func(file) )
          return;
     }

  for ( n = 0; n < vcd_managers_count; n++ )   
      {
        if ( !vcd_managers[n].func(file) )
           return;
      }
  
  ErrBox(LS(3046));
}
