
#include "include.h"


// drivers list:
#include "drv_xp_x86.inline"



/////////////////////////////////

CRollback::CDevice::CDevice(const char *devicepath)
{
  m_handle = CreateFile(devicepath,GENERIC_READ|GENERIC_WRITE,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_EXISTING,0,NULL);
}


CRollback::CDevice::~CDevice()
{
  if ( m_handle != INVALID_HANDLE_VALUE )
     {
       CloseHandle(m_handle);
     }
}


BOOL CRollback::CDevice::Call(DWORD code,LPVOID inbuff,DWORD inbuffsize,LPVOID outbuff,DWORD outbuffsize,LPDWORD _rcbytes)
{
  BOOL rc = FALSE;
  
  if ( _rcbytes )
     *_rcbytes = 0;

  if ( m_handle != INVALID_HANDLE_VALUE )
     {
       DWORD bytes = 0;
       if ( DeviceIoControl(m_handle,code,inbuff,inbuffsize,outbuff,outbuffsize,&bytes,NULL) )
          {
            if ( _rcbytes )
               *_rcbytes = bytes;

            rc = TRUE;
          }
     }

  return rc;
}



/////////////////////////////////


CRollback::COurPrivileges::COurPrivileges()
{
  SetProcessPrivilege(SE_BACKUP_NAME);  // needed for driver
}



/////////////////////////////////

CRollback::CRollback()
{
  unsigned drv_size = 0;
  b_os_supported = (_GetDriver4CurrentOs(drv_size) != NULL);
  b_is_admin = IsAdminAccount();
  m_lasterror = ERR_NONE;
}


CRollback::~CRollback()
{
}


// checks for all driver-based functions
BOOL CRollback::CommonChecks()
{
  if ( !IsOsSupported() )
     {
       SetLastError(ERR_OS);
       return FALSE;
     }

  if ( !IsAdmin() )
     {
       SetLastError(ERR_ACCESS);
       return FALSE;
     }

  SetLastError(ERR_NONE);
  return TRUE;
}


const void* CRollback::_GetDriver4CurrentOs(unsigned &_size)
{
  _size = 0;
  
  BOOL b_os64;
  #ifdef _WIN64
  b_os64 = TRUE;
  #else
  b_os64 = IsWOW64();
  #endif
  
  if ( b_os64 )
     return NULL;   // now is unsupported

  OSVERSIONINFO i;
  ZeroMemory(&i,sizeof(i));
  i.dwOSVersionInfoSize = sizeof(i);
  if ( !GetVersionEx(&i) )
     return NULL;

  WORD ver = (i.dwMajorVersion << 8) | i.dwMinorVersion;
  
  if ( ver != 0x500 && ver != 0x501 /*&& ver != 0x502*/ )  // not tested on Server2003 x86
     return NULL;  // now is unsupported

  _size = sizeof(drv_xp_x86_bin);
  return drv_xp_x86_bin;
}


char* CRollback::_GetDriverFullPathName(char *s)
{
  if ( s )
     {
       s[0] = 0;
       GetSystemWindowsDirectory(s,MAX_PATH);
       if ( IsStrEmpty(s) )
          GetWindowsDirectory(s,MAX_PATH);
       PathAppend(s,"System32"); // for both x86 and x64
       PathAppend(s,"drivers");
       PathAppend(s,"RollBack.sys");
     }

  return s;
}


BOOL CRollback::_WriteDriverFile()
{
  unsigned fsize = 0;
  const void* fbuff = _GetDriver4CurrentOs(fsize);
  assert(fbuff && fsize);

  BOOL rc;
  
  {
    CDisableWOW64FSRedirection fsg;

    char s[MAX_PATH] = "";
    rc = WriteFullFile(_GetDriverFullPathName(s),fbuff,fsize);
  }

  return rc;
}


void CRollback::_DeleteDriverFile()
{
  CDisableWOW64FSRedirection fsg;

  char s[MAX_PATH] = "";
  ::DeleteFile(_GetDriverFullPathName(s));
}


void CRollback::_DeleteRegAndDriverFile()
{
  DeleteRegKey(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack");

  {
    CRegEmptySD rsdg(HKLM,"SYSTEM\\CurrentControlSet\\Enum\\Root");
    DeleteRegKey(HKLM,"SYSTEM\\CurrentControlSet\\Enum\\Root\\LEGACY_ROLLBACK");
  }

  DeleteRegKey(HKLM,"SYSTEM\\CurrentControlSet\\Control\\Class\\{69567CCF-2EC8-7245-8CCA-9B67250F5140}");

  _DeleteDriverFile();
}


BOOL CRollback::_CallDriver(DWORD code,LPVOID inbuff,DWORD inbuffsize,
                            LPVOID outbuff,DWORD outbuffsize,LPDWORD _rcbytes)
{
  if ( _rcbytes )
     *_rcbytes = 0;

  return COurDevice().Call(code,inbuff,inbuffsize,outbuff,outbuffsize,_rcbytes);
}


int CRollback::_GetRlbStateByReturnCode(BYTE rc)
{
  return (rc >= 0 && rc <= 5) ? rc+1 : -1;
}


BOOL CRollback::_IncludeOrExcludeDisk(int drivenum,BOOL b_include,int &_newstate)
{
  BOOL rc = FALSE;

  _newstate = -1;
  
  char s_drive[MAX_PATH];
  sprintf(s_drive,"%c:\\",'A'+drivenum);

  char s_volume[MAX_PATH] = "";
  if ( GetVolumeNameForVolumeMountPoint(s_drive,s_volume,sizeof(s_volume)) )
     {
       PathRemoveBackslash(s_volume);
       HANDLE h_vol = CreateFile(s_volume,GENERIC_READ|GENERIC_WRITE,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_EXISTING,0,NULL);
       if ( h_vol != INVALID_HANDLE_VALUE )
          {
            {
              COurDevice drv;

              // todo: code maybe need to change for x64 driver!
              drv.Call(0x88000008,&h_vol,sizeof(h_vol));

              BYTE i = b_include ? 0x01 : 0x00;
              BYTE o = 0xFF;
              if ( drv.Call(0x80380,&i,sizeof(i),&o,sizeof(o)) )
                 {
                   rc = TRUE;
                   _newstate = _GetRlbStateByReturnCode(o); // here must be RLB_OFF_ON for include and RLB_OFF_OFF for exclude
                 }
            }

            CloseHandle(h_vol);
          }
     }

  return rc;
}



BOOL CRollback::GetDriverStatus(int &_out)
{
  if ( !CommonChecks() )
     return FALSE;

  int rlb;
  if ( !GetRollbackStatus(rlb) )
     return FALSE;

  BOOL drv_now = (rlb != ST_RLB_NODRIVER);
  BOOL drv_after;

  {
    CDisableWOW64FSRedirection fsg;

    char s[MAX_PATH] = "";
    drv_after = (ReadRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack","Type",-1) == 2 
                 && IsFileExist(_GetDriverFullPathName(s)));
  }

  if ( !drv_now && !drv_after )
     _out = ST_DRV_OFF_OFF;
  else
  if ( !drv_now && drv_after )
     _out = ST_DRV_OFF_ON;
  else
  if ( drv_now && drv_after )
     _out = ST_DRV_ON_ON;
  else
     _out = ST_DRV_ON_OFF;

  SetLastError(ERR_NONE);
  return TRUE;
}


BOOL CRollback::GetRollbackStatus(int &_out)
{
  if ( !CommonChecks() )
     return FALSE;

  {
    COurDevice dev;

    if ( !dev.IsValid() )
       {
         _out = ST_RLB_NODRIVER;
         SetLastError(ERR_NONE);
         return TRUE;
       }

    BYTE o = 0xFF;
    if ( !dev.Call(0x80380,NULL,0,&o,sizeof(o)) )
       {
         SetLastError(ERR_FAILED);
         return FALSE;
       }

    int out = _GetRlbStateByReturnCode(o);
    
    if ( out >= ST_RLB_FIRST && out <= ST_RLB_LAST )
       {
         _out = out;
         SetLastError(ERR_NONE);
         return TRUE;
       }
    else
       {
         SetLastError(ERR_FAILED);
         return FALSE;
       }
  }
}


BOOL CRollback::InstallDriver()
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv == ST_DRV_OFF_ON || drv == ST_DRV_ON_ON )
     {
       SetLastError(ERR_NONE);
       return TRUE;
     }

  // write driver file
  if ( !_WriteDriverFile() )
     {
       SetLastError(ERR_ACCESS);
       return FALSE;
     }

  // update registry
  {
    const char *key = "SYSTEM\\CurrentControlSet\\Services\\RollBack";
    WriteRegStr(HKLM,key,"Group","filter");
    WriteRegDword(HKLM,key,"ErrorControl",0);
    WriteRegDword(HKLM,key,"Start",0);
    WriteRegDword(HKLM,key,"Type",2);
  }

  {
    const char *key = "SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters";
    DeleteRegKey(HKLM,key); // cleanup, paranoja
    WriteRegDword(HKLM,key,"DisableExcludeList",1);
    WriteRegDword(HKLM,key,"EnableLogging",1);
  }

  {
    const char *key = "SYSTEM\\CurrentControlSet\\Services\\RollBack\\Enum";
    WriteRegStr(HKLM,key,"0","Root\\LEGACY_ROLLBACK\\0000");
    WriteRegDword(HKLM,key,"Count",1);
    WriteRegDword(HKLM,key,"NextInstance",1);
  }

  {
    CRegEmptySD rsdg(HKLM,"SYSTEM\\CurrentControlSet\\Enum\\Root");

    {
      const char *key = "SYSTEM\\CurrentControlSet\\Enum\\Root\\LEGACY_ROLLBACK";
      WriteRegDword(HKLM,key,"NextInstance",1);
    }

    {
      const char *key = "SYSTEM\\CurrentControlSet\\Enum\\Root\\LEGACY_ROLLBACK\\0000";
      WriteRegStr(HKLM,key,"Service","RollBack");
      WriteRegDword(HKLM,key,"Legacy",1);
      WriteRegDword(HKLM,key,"ConfigFlags",0);
      WriteRegStr(HKLM,key,"Class","LegacyDriver");
      WriteRegStr(HKLM,key,"ClassGUID","{8ECC055D-047F-11D1-A537-0000F8753ED1}");
      WriteRegStr(HKLM,key,"DeviceDesc","RollBack");
    }

    {
      const char *key = "SYSTEM\\CurrentControlSet\\Enum\\Root\\LEGACY_ROLLBACK\\0000\\Control";
      WriteRegStr(HKLM,key,"ActiveService","RollBack");
    }
  }

  {
    static const BYTE data[] = 
    {
      0xE8, 0xC8, 0xE3, 0xF2, 0xF3, 0xF2, 0xE5, 0x85,
      0xD6, 0xC8, 0xAA, 0xE4, 0xE0, 0x8A, 0xC8, 0xDF,
      0xC3, 0xC6, 0xCE, 0xAA, 0x92, 0xE8, 0x9F, 0x9D,
      0x87, 0x99, 0x9D, 0xE9, 0xEB, 0x87, 0x92, 0x98,
      0x9E, 0x92, 0x87, 0xEF, 0x9A, 0x92, 0x9A, 0x87,
      0xE9, 0x99, 0x93, 0xEB, 0xAA
    };

    const char *key = "SYSTEM\\CurrentControlSet\\Control\\Class\\{69567CCF-2EC8-7245-8CCA-9B67250F5140}";
    WriteRegBin(HKLM,key,"{CB596977-87BC-FC4F-8B9C-62032C29128D}",(char*)data,sizeof(data));
  }

  // check
  BOOL rc = ReadRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack","Type",-1) == 2 &&
            ReadRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Enum\\Root\\LEGACY_ROLLBACK\\0000","Legacy",-1) == 1;

  if ( !rc )
     {
       // cleanup
       _DeleteRegAndDriverFile();
     }

  SetLastError(rc?ERR_NONE:ERR_ACCESS);
  return rc;
}


BOOL CRollback::UninstallDriver()
{
  if ( !CommonChecks() )
     return FALSE;

  int rlb;
  if ( !GetRollbackStatus(rlb) )
     return FALSE;

  if ( rlb != ST_RLB_NODRIVER && rlb != ST_RLB_OFF_OFF )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv == ST_DRV_OFF_OFF || drv == ST_DRV_ON_OFF )
     {
       SetLastError(ERR_NONE);
       return TRUE;
     }

  _DeleteRegAndDriverFile();

  if ( !GetDriverStatus(drv) )
     return FALSE;

  BOOL rc = (drv == ST_DRV_OFF_OFF || drv == ST_DRV_ON_OFF);

  SetLastError(rc?ERR_NONE:ERR_ACCESS);
  return rc;
}


BOOL CRollback::UpdateDriverFile()
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv == ST_DRV_OFF_OFF || drv == ST_DRV_ON_OFF )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }
  
  BOOL rc = _WriteDriverFile();

  SetLastError(rc?ERR_NONE:ERR_ACCESS);
  return rc;
}


BOOL CRollback::SetDisks(unsigned mask)
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv == ST_DRV_OFF_OFF || drv == ST_DRV_ON_OFF )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

//  int rlb;
//  if ( !GetRollbackStatus(rlb) )
//     return FALSE;
//
//  if ( rlb != ST_RLB_NODRIVER && rlb != ST_RLB_OFF_OFF )
//     {
//       SetLastError(ERR_FAILED);
//       return FALSE;
//     }

  if ( WriteRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","DriveList",mask) )
     {
       SetLastError(ERR_NONE);
       return TRUE;
     }
  else
     {
       SetLastError(ERR_ACCESS);
       return FALSE;
     }
}


BOOL CRollback::GetDisks(unsigned& _mask)
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv == ST_DRV_OFF_OFF || drv == ST_DRV_ON_OFF )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  _mask = ReadRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","DriveList",0);

  SetLastError(ERR_NONE);
  return TRUE;
}


BOOL CRollback::SetExcludePaths(const TStringList& list,BOOL b_fail_if_any_invalid)
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv == ST_DRV_OFF_OFF || drv == ST_DRV_ON_OFF )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

//  int rlb;
//  if ( !GetRollbackStatus(rlb) )
//     return FALSE;
//
//  if ( rlb != ST_RLB_NODRIVER && rlb != ST_RLB_OFF_OFF )
//     {
//       SetLastError(ERR_FAILED);
//       return FALSE;
//     }

  TStringList real;
  for ( int n = 0; n < list.size(); n++ )
      {
        const std::string& path = list[n];

        if ( path.size() >= 4 && path[1] == ':' && path[2] == '\\' )
           {
             CDisableWOW64FSRedirection fsg;

             if ( IsFileExist(path.c_str()) )
                {
                  std::string dest(path);
                  if ( dest[dest.size()-1] != '\\' )
                     dest += "\\";
                  
                  char sys_drv = GetSysDrivePathWithBackslash()[0];
                  sys_drv = (char)(unsigned char)CharUpper((LPSTR)((unsigned char)sys_drv));
                  char req_drv = (char)(unsigned char)CharUpper((LPSTR)((unsigned char)path[0]));

                  if ( req_drv == sys_drv )
                     {
                       dest.replace(0,2,"@");
                     }
                  else
                     {
                       dest.erase(0,2);
                     }

                  real.push_back(dest);
                }
           }
      }

  BOOL b_any_invalid = (real.size() != list.size());
  if ( b_fail_if_any_invalid && b_any_invalid )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  if ( real.size() == 0 )
     {
       WriteRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","DisableExcludeList",1);
       DeleteRegValue(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","RollBackExcludeList");
     }
  else
     {
       WriteRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","DisableExcludeList",0);

       std::string t;
       for ( int n = 0; n < real.size(); n++ )
           {
             t += real[n];
             t += '\0';
           }
       t += '\0';
       
       WriteRegMultiStr(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","RollBackExcludeList",t.data(),t.size());
     }

  SetLastError(ERR_NONE);
  return TRUE;
}


BOOL CRollback::GetExcludePaths(TStringList& _list)
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv == ST_DRV_OFF_OFF || drv == ST_DRV_ON_OFF )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  int stat = ReadRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","DisableExcludeList",-1);
  if ( stat == -1 )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  BOOL rc = FALSE;
  
  if ( stat )
     {
       _list.clear();
       rc = TRUE;
     }
  else
     {
       int max_size = 65536;
       char *t = (char*)sys_zalloc(max_size); //zero clears
       int size = 0;
       ReadRegMultiStr(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","RollBackExcludeList",t,max_size,&size);

       if ( size < 3 )
          {
            _list.clear();
            rc = TRUE;
          }
       else
          {
            if ( t[size-1] == 0 && t[size-2] == 0 )
               {
                 _list.clear();

                 const char *p = t;
                 while ( *p )
                 {
                   std::string path(p);

                   if ( path[0] == '@' )
                      {
                        path.replace(0,1,GetSysDrivePathWithBackslash(),2);
                      }
                   else
                   if ( path[0] == '\\' )
                      {
                        path.insert(0,"%Disk%");
                      }

                   _list.push_back(path);

                   p += lstrlen(p)+1;
                 };

                 rc = TRUE;
               }
          }

       sys_free(t);
     }

  SetLastError(rc?ERR_NONE:ERR_FAILED);
  return rc;
}


BOOL CRollback::RollbackActivate()
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv != ST_DRV_ON_ON )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  int rlb;
  if ( !GetRollbackStatus(rlb) )
     return FALSE;

  if ( rlb == ST_RLB_ON_ON || rlb == ST_RLB_OFF_ON || rlb == ST_RLB_ON_ON_SAVE )
     {
       SetLastError(ERR_NONE);
       return TRUE;
     }

  if ( rlb == ST_RLB_ON_OFF || rlb == ST_RLB_ON_OFF_SAVE )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  // here only ST_RLB_OFF_OFF
  BYTE i = 0x01;
  BYTE o = 0xFF;
  if ( !_CallDriver(0x80380,&i,sizeof(i),&o,sizeof(o)) || _GetRlbStateByReturnCode(o) != ST_RLB_OFF_ON )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  // setup disks to rollback
  // here we in ST_RLB_OFF_ON state

  // get real fixed disks in system
  unsigned d_sys = GetLogicalDrives();
  d_sys &= 0xFFFFFFFC; // ignore floppy A,B
  for ( int n = 0; n <= 25; n++ )
      {
        if ( (d_sys >> n) & 1 )
           {
             char t[8];
             t[0] = n + 'A';
             t[1] = ':';
             t[2] = '\\';
             t[3] = 0;

             if ( GetDriveType(t) != DRIVE_FIXED || IsDriveTrueRemovableI(n) )
                {
                  d_sys &= ~((unsigned)1<<n);  // ignore this drive
                }
           }
      }

  // get drives from config
  unsigned d_cfg = ReadRegDword(HKLM,"SYSTEM\\CurrentControlSet\\Services\\RollBack\\Parameters","DriveList",0);

  unsigned d_rlb = (d_sys & d_cfg);
  for ( int n = 0; n <= 25; n++ )
      {
        if ( (d_sys >> n) & 1 )
           {
             BOOL inc = ((d_rlb >> n) & 1) != 0;
             int newstate = -1;
             _IncludeOrExcludeDisk(n,inc,newstate); // maybe check return codes here?
           }
      }

  SetLastError(ERR_NONE);
  return TRUE;
}


BOOL CRollback::RollbackDeactivate(BOOL b_saveall)
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv != ST_DRV_ON_ON )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  int rlb;
  if ( !GetRollbackStatus(rlb) )
     return FALSE;

  if ( rlb == ST_RLB_OFF_OFF || rlb == ST_RLB_ON_OFF || rlb == ST_RLB_ON_OFF_SAVE )
     {
       SetLastError(ERR_NONE);
       return TRUE;
     }

  if ( rlb == ST_RLB_OFF_ON )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  // here only ST_RLB_ON_ON, ST_RLB_ON_ON_SAVE
  int needed_state = b_saveall ? ST_RLB_ON_OFF_SAVE : ST_RLB_ON_OFF;
  BYTE i = b_saveall ? 0xFF : 0x00;
  BYTE o = 0xFF;
  if ( !_CallDriver(0x80380,&i,sizeof(i),&o,sizeof(o)) || _GetRlbStateByReturnCode(o) != needed_state )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  SetLastError(ERR_NONE);
  return TRUE;
}


BOOL CRollback::RollbackSaveAll()
{
  if ( !CommonChecks() )
     return FALSE;

  int drv;
  if ( !GetDriverStatus(drv) )
     return FALSE;

  if ( drv != ST_DRV_ON_ON )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  int rlb;
  if ( !GetRollbackStatus(rlb) )
     return FALSE;

  if ( rlb == ST_RLB_ON_ON_SAVE )
     {
       SetLastError(ERR_NONE);
       return TRUE;
     }

  if ( rlb != ST_RLB_ON_ON )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  // here only ST_RLB_ON_ON
  BYTE i = 0xFE;
  BYTE o = 0xFF;
  if ( !_CallDriver(0x80380,&i,sizeof(i),&o,sizeof(o)) || _GetRlbStateByReturnCode(o) != ST_RLB_ON_ON_SAVE )
     {
       SetLastError(ERR_FAILED);
       return FALSE;
     }

  SetLastError(ERR_NONE);
  return TRUE;
}






