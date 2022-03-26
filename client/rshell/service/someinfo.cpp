
#include "include.h"



BOOL HW_CPUInfo(CDynBuff &buff)
{
  int mhz;
  char s[MAX_PATH];
  char t[MAX_PATH];
  SYSTEM_INFO i;

  ZeroMemory(&i,sizeof(i));
  GetSystemInfo(&i);

  s[0] = 0;

  ReadRegStr(HKLM,"HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0","ProcessorNameString",t,"");
  if ( t[0] )
     {
       lstrcat(s,t);
       lstrcat(s," ");
     }

  mhz = ReadRegDword(HKLM,"HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0","~MHz",0);
  if ( mhz )
     {
       mhz = (mhz + 50) / 100 * 100;
       wsprintf(t,"(%d.%d GHz) ",mhz/1000,(mhz%1000)/100);
       lstrcat(s,t);
     }

  if ( !s[0] )
     {
       switch ( i.wProcessorArchitecture )
       {
         case PROCESSOR_ARCHITECTURE_INTEL:
                                 lstrcat(s,"Intel x86 ");
                                 break;
         case PROCESSOR_ARCHITECTURE_AMD64:
                                 lstrcat(s,"AMD x64 ");
                                 break;
         case PROCESSOR_ARCHITECTURE_IA64:
                                 lstrcat(s,"IA64 ");
                                 break;
         case PROCESSOR_ARCHITECTURE_IA32_ON_WIN64/*10*/:
                                 lstrcat(s,"WOW64 ");
                                 break;
         default:
                                 lstrcat(s,"unknown ");
                                 break;
       };

       wsprintf(t,"(%d,%d,%d) ",i.wProcessorLevel,(i.wProcessorRevision>>8)&0xFF,i.wProcessorRevision&0xFF);
       lstrcat(s,t);
     }

  if ( i.dwNumberOfProcessors != 1 )
     {
       wsprintf(t,"(%d) ",i.dwNumberOfProcessors);
       lstrcat(s,t);
     }

  if ( s[lstrlen(s)-1] == ' ' )
     s[lstrlen(s)-1] = 0;

  buff.AddStringNoTerm("CPU ");
  buff.AddStringNoTerm(s);

  return TRUE;
}


BOOL HW_MotherBoardInfo(CDynBuff &buff)
{
  char s[MAX_PATH];

  ZeroMemory(s,sizeof(s));
  ReadRegStr(HKLM,"HARDWARE\\DESCRIPTION\\System","SystemBiosVersion",s,"AT/AT Compatible");

  buff.AddStringNoTerm("MotherBoard ");
  buff.AddStringNoTerm(s);

  return TRUE;
}


BOOL HW_RAMInfo(CDynBuff &buff)
{
  unsigned total_phys_mb;

  {
    MEMORYSTATUS m;
    ZeroMemory(&m,sizeof(m));
    GlobalMemoryStatus(&m);
    total_phys_mb = m.dwTotalPhys/(1024*1024);
  }
  
  BOOL (WINAPI *pGlobalMemoryStatusEx)(LPMEMORYSTATUSEX lpBuffer);
  *(void**)&pGlobalMemoryStatusEx = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"GlobalMemoryStatusEx");
  if ( pGlobalMemoryStatusEx )
     {
       MEMORYSTATUSEX i;
       ZeroMemory(&i,sizeof(i));
       i.dwLength = sizeof(i);
       if ( pGlobalMemoryStatusEx(&i) )
          {
            total_phys_mb = i.ullTotalPhys/(1024*1024);
          }
     }

  char s[MAX_PATH];
  wsprintf(s,"%d MB",total_phys_mb);
  buff.AddStringNoTerm("RAM ");
  buff.AddStringNoTerm(s);

  return TRUE;
}


BOOL HW_VideoInfo(CDynBuff &buff)
{
  char s[MAX_PATH];
  DISPLAY_DEVICE d;

  ZeroMemory(&d,sizeof(d));
  d.cb = sizeof(d);
  if ( EnumDisplayDevices(NULL,0,&d,0) )
     lstrcpy(s,d.DeviceString);
  else
     lstrcpy(s,"VGA Compatible");

  buff.AddStringNoTerm("Video1 ");
  buff.AddStringNoTerm(s);

  return TRUE;
}


BOOL HW_SoundInfo(CDynBuff &buff)
{
  char s[MAX_PATH];
  WAVEOUTCAPS i;

  ZeroMemory(&i,sizeof(i));
  if ( waveOutGetDevCaps(0,&i,sizeof(i)) == MMSYSERR_NOERROR )
     lstrcpy(s,i.szPname);
  else
     lstrcpy(s,"WAVEOut");

  buff.AddStringNoTerm("Sound1 ");
  buff.AddStringNoTerm(s);

  return TRUE;
}


BOOL HW_HDDInfo(CDynBuff &buff)
{
  int hddfind=0;

  for ( int n = 0; n < 8; n++ )
      {
        char t[MAX_PATH];
        wsprintf(t,"\\\\.\\PhysicalDrive%d",n);
        HANDLE device = CreateFile(t,0,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_EXISTING,0,NULL);
        if ( device != INVALID_HANDLE_VALUE )
           {
             DISK_GEOMETRY g;
             DWORD rc;
             ZeroMemory(&g,sizeof(g));
             if ( DeviceIoControl(device,IOCTL_DISK_GET_DRIVE_GEOMETRY,NULL,0,&g,sizeof(g),&rc,NULL) )
                {
                  if ( g.MediaType == FixedMedia )
                     {
                       unsigned __int64 cylinders = *(unsigned __int64 *)&g.Cylinders;
                       unsigned heads = g.TracksPerCylinder;
                       unsigned secpertrack = g.SectorsPerTrack;
                       unsigned sectorsize = g.BytesPerSector;
                       unsigned __int64 sectors = cylinders * secpertrack * heads;
                       unsigned mbtotal = sectors * sectorsize / 1000 / 1000;

                       char s[MAX_PATH];
                       wsprintf(s,"HDD%d %d.%d GB",++hddfind,mbtotal/1000,(mbtotal%1000)/100);
                       if ( hddfind > 1 )
                          buff.AddStringNoTerm("\n");
                       buff.AddStringNoTerm(s);
                     }
                }

             CloseHandle(device);
           }
      }

  return hddfind > 0;
}


BOOL HW_FDDInfo(CDynBuff &buff)
{
  int fddfind = 0;
  
  unsigned drives = GetLogicalDrives();
  for ( int n = 0; n < 2; n++ )
      {
        if ( (drives >> n) & 1 )
           {
             char s[MAX_PATH];
             wsprintf(s,"FDD%d %c:",++fddfind,n+'A');
             if ( fddfind > 1 )
                buff.AddStringNoTerm("\n");
             buff.AddStringNoTerm(s);
           }
      }

  return fddfind > 0;
}


BOOL HW_LANInfo(CDynBuff &buff)
{
  int netfind = 0;

  for ( int n = 0; n < 8; n++ )
      {
        NCB ncb;
        unsigned char info[256];

        ZeroMemory(&ncb,sizeof(ncb));
        ncb.ncb_command = NCBRESET;
        ncb.ncb_lana_num = n;
        Netbios(&ncb);
        
        ZeroMemory(&ncb,sizeof(ncb));
        ncb.ncb_command = NCBASTAT;
        ncb.ncb_lana_num = n;
        ncb.ncb_buffer = info;
        ncb.ncb_length = sizeof(info);
        lstrcpy((char*)ncb.ncb_callname,"* ");
        
        ZeroMemory(info,sizeof(info));

        if ( Netbios(&ncb) == 0 )
           {
             char s[MAX_PATH];
             wsprintf(s,"NetCard%d %02X:%02X:%02X:%02X:%02X:%02X",++netfind,info[0],info[1],info[2],info[3],info[4],info[5]);
             if ( netfind > 1 )
                buff.AddStringNoTerm("\n");
             buff.AddStringNoTerm(s);
           }
     }

  return netfind > 0;
}


typedef BOOL (*HW_FUNC)(CDynBuff &buff);

static HW_FUNC hw_info[] = 
{
  HW_CPUInfo,
  HW_MotherBoardInfo,
  HW_RAMInfo,
  HW_VideoInfo,
  HW_SoundInfo,
  HW_HDDInfo,
  HW_FDDInfo,
  HW_LANInfo,
};


void S_GetHWInfo(CNetCmd &cmd)
{
  cmd.AddStringNoTerm(NETPARM_S_HWINFO);
  cmd.AddStringNoTerm("=");
  
  for ( int n = 0; n < sizeof(hw_info)/sizeof(hw_info[0]); n++ )
      {
        if ( hw_info[n](cmd) )
           {
             cmd.AddStringNoTerm("\n");
           }
      }

  cmd.AddStringSZ("");
}


void S_GetShellVersion(CNetCmd &cmd)
{
  cmd.AddStringParm(NETPARM_S_VERSION,RUNPAD_VERSION_STR);
}


void S_GetCfgInfo(CNetCmd &cmd,const CConfigurator *_cfg,const CNetClient *_net)
{
  if ( _cfg )
     {
       char s[MAX_PATH*2] = "";
       
       int st = _cfg->GetState();
       
       if ( st == CConfigurator::STATE_WAITING )
          {
            lstrcpy(s,S_SETT_WAITING);
          }
       else
       if ( st == CConfigurator::STATE_FROMCACHE || st == CConfigurator::STATE_FROMDEF )
          {
            const char *s1 = (st == CConfigurator::STATE_FROMCACHE ? S_SETT_FROMCACHE : S_SETT_FROMDEF);
            const char *s2 = "";
            char s3[MAX_PATH] = "";

            int err = _cfg->GetLastErrorI();

            if ( err == CConfigurator::ERR_NONE )
               {
                 // only when recv NULL block, must be never happened
               }
            else
            if ( err == CConfigurator::ERR_NOTCONNECTED )
               {
                 s2 = S_ERR_NOTCONNECTED;
                 int i_ip = _net ? _net->GetServerIP() : 0;
                 unsigned char s_ip[4];
                 *(int*)s_ip = i_ip;
                 sprintf(s3,"%d.%d.%d.%d",s_ip[0],s_ip[1],s_ip[2],s_ip[3]);
               }
            else
            if ( err == CConfigurator::ERR_NORESPONCE )
               {
                 s2 = S_ERR_NORESPONCE;
                 lstrcpyn(s3,_cfg->GetLastErrorS(),sizeof(s3));
               }
            else
            if ( err == CConfigurator::ERR_DBNOTREADY )
               {
                 s2 = S_ERR_DBNOTREADY;
                 lstrcpyn(s3,_cfg->GetLastErrorS(),sizeof(s3));
               }
            else
            if ( err == CConfigurator::ERR_OUTOFLICENSE )
               {
                 s2 = S_ERR_OUTOFLICENSE;
                 lstrcpyn(s3,_cfg->GetLastErrorS(),sizeof(s3));
               }
            else
            if ( err == CConfigurator::ERR_SERVER )
               {
                 s2 = S_ERR_SERVER;
                 lstrcpyn(s3,_cfg->GetLastErrorS(),sizeof(s3));
               }

            if ( !IsStrEmpty(s2) )
               sprintf(s,"%s (%s)",s1,s2);
            else
               lstrcpy(s,s1);

            if ( !IsStrEmpty(s3) )
               {
                 lstrcat(s," \"");
                 lstrcat(s,s3);
                 lstrcat(s,"\"");
               }
          }
       else
       if ( st == CConfigurator::STATE_FROMSERVER )
          {
            lstrcpy(s,S_SETT_FROMSERVER);
          }

       if ( !IsStrEmpty(s) )
          {
            cmd.AddStringParm(NETPARM_S_COMPSETTINGS,s);
          }
     }
}


void S_GetServices(CNetCmd &cmd)
{
  BOOL is_rfm = IsServiceRunning(SERVICE_NAME_RFM);
  BOOL is_rd = IsServiceRunning(SERVICE_NAME_RD);
  
  const char *s = "---";
  if ( is_rfm && is_rd )
     s = "RemoteFileManager/RemoteDesktop";
  else
  if ( is_rfm )
     s = "RemoteFileManager";
  else
  if ( is_rd )
     s = "RemoteDesktop";
  
  cmd.AddStringParm(NETPARM_S_OURSERVICES,s);
}  


void S_GetDisksInfo(CNetCmd &cmd)
{
  char query[1024] = "";
  unsigned drives = GetLogicalDrives();
  for ( int n = 2; n < 26; n++ )
      {
        if ( (drives >> n) & 1 )
           {
             char s[MAX_PATH];
             wsprintf(s,"%c:\\",'A'+n);
             if ( GetDriveType(s) == DRIVE_FIXED && !IsDriveTrueRemovableI(n) )
                {
                  unsigned __int64 fr = 0;
                  GetDiskFreeSpaceEx(s,(PULARGE_INTEGER)&fr,NULL,NULL);
                  unsigned gb = (unsigned)(fr >> 20) * 10 / 1000;
                  if ( gb >= 20 ) // 2.0GB
                     wsprintf(s,"%c: %d.%d; ",'A'+n,gb/10,gb%10);
                  else
                     wsprintf(s,"%c: <font color=red><b>%d.%d</b></font>; ",'A'+n,gb/10,gb%10);
                  lstrcat(query,s);
                }
           }
      }

  if ( !query[0] )
     lstrcpy(query,"N/A");
  
  cmd.AddStringParm(NETPARM_S_DISKSSPACE,query);
}


void S_GetCPUTemp(CNetCmd &cmd)
{
  char s[MAX_PATH];
  s[0] = 0;
  GetCPUTemperatureHTMLString(s,NULL,NULL);
  cmd.AddStringParm(NETPARM_S_CPUTEMP,s);
}


void S_GetMBMTemp(CNetCmd &cmd)
{
  char s[MAX_PATH];
  s[0] = 0;
  GetCPUTemperatureHTMLString(NULL,s,NULL);
  cmd.AddStringParm(NETPARM_S_MBMTEMP,s);
}


void S_GetCPUCooler(CNetCmd &cmd)
{
  char s[MAX_PATH];
  s[0] = 0;
  GetCPUTemperatureHTMLString(NULL,NULL,s);
  cmd.AddStringParm(NETPARM_S_CPUCOOLER,s);
}


void PrepareSomeInfo(CNetCmd &cmd,const CConfigurator *_cfg,const CNetClient *_net)
{
  S_GetShellVersion(cmd);
  S_GetCfgInfo(cmd,_cfg,_net);
  S_GetServices(cmd);
  S_GetDisksInfo(cmd);

  if ( IsShellInstalled() )
     {
       S_GetCPUTemp(cmd);
       S_GetMBMTemp(cmd);
       S_GetCPUCooler(cmd);
     }

  S_GetHWInfo(cmd);
}


void PrepareRollbackInfo(CNetCmd &cmd,CConfigurator *_cfg)
{
  CRollback rlb;
  
  cmd.AddStringParm(NETPARM_S_RLBVERSION,rlb.GetVersion());

  if ( _cfg->CanAccess() )
     {
       std::string comments;
       BOOL b_lic = IsRollbackAllowedFromLic(_cfg->GetLicFeat(),comments);
       
       char t[MAX_PATH];
       sprintf(t,"%s",b_lic?S_RLB_LICPRESENT:S_RLB_LICNOTPRESENT);

       if ( !comments.empty() )
          {
            lstrcat(t,"\n(");
            lstrcat(t,comments.c_str());
            lstrcat(t,")");
          }
       
       cmd.AddStringParm(NETPARM_S_RLBLICENSE,t);
     }
  else
     {
       cmd.AddStringParm(NETPARM_S_RLBLICENSE,S_RLB_LICNOTRECEIVEDJET);
     }


  int err = CRollback::ERR_NONE;

  int st_drv = -1;
  if ( !rlb.GetDriverStatus(st_drv) )
     {
       err = rlb.GetLastError();
     }

  int st_rlb = -1;
  if ( !rlb.GetRollbackStatus(st_rlb) )
     {
       err = rlb.GetLastError();
     }

  if ( err == CRollback::ERR_NONE )
     {
       switch ( st_drv )
       {
         case CRollback::ST_DRV_OFF_OFF:
          cmd.AddStringParm(NETPARM_S_RLBDRVNOW,S_SWITCH_OFF);
          cmd.AddStringParm(NETPARM_S_RLBDRVAFTER,S_SWITCH_OFF);
         break;
         case CRollback::ST_DRV_OFF_ON:
          cmd.AddStringParm(NETPARM_S_RLBDRVNOW,S_SWITCH_OFF);
          cmd.AddStringParm(NETPARM_S_RLBDRVAFTER,S_SWITCH_ON);
         break;
         case CRollback::ST_DRV_ON_OFF:
          cmd.AddStringParm(NETPARM_S_RLBDRVNOW,S_SWITCH_ON);
          cmd.AddStringParm(NETPARM_S_RLBDRVAFTER,S_SWITCH_OFF);
         break;
         case CRollback::ST_DRV_ON_ON:
          cmd.AddStringParm(NETPARM_S_RLBDRVNOW,S_SWITCH_ON);
          cmd.AddStringParm(NETPARM_S_RLBDRVAFTER,S_SWITCH_ON);
         break;
         default:
          cmd.AddStringParm(NETPARM_S_RLBDRVNOW,"?");
          cmd.AddStringParm(NETPARM_S_RLBDRVAFTER,"?");
         break;
       };

       switch ( st_rlb )
       {
         case CRollback::ST_RLB_NODRIVER:
          cmd.AddStringParm(NETPARM_S_RLBRLBNOW,S_NODRIVER);
          cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,S_NODRIVER);
         break;
         case CRollback::ST_RLB_OFF_OFF:
          cmd.AddStringParm(NETPARM_S_RLBRLBNOW,S_SWITCH_OFF);
          cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,S_SWITCH_OFF);
         break;
         case CRollback::ST_RLB_ON_ON:
          cmd.AddStringParm(NETPARM_S_RLBRLBNOW,S_SWITCH_ON);
          cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,S_SWITCH_ON);
         break;
         case CRollback::ST_RLB_OFF_ON:
          cmd.AddStringParm(NETPARM_S_RLBRLBNOW,S_SWITCH_OFF);
          cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,S_SWITCH_ON);
         break;
         case CRollback::ST_RLB_ON_OFF:
          cmd.AddStringParm(NETPARM_S_RLBRLBNOW,S_SWITCH_ON);
          cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,S_SWITCH_OFF);
         break;
         case CRollback::ST_RLB_ON_ON_SAVE:
          cmd.AddStringParm(NETPARM_S_RLBRLBNOW,S_SWITCH_ON_SAVE);
          cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,S_SWITCH_ON);
         break;
         case CRollback::ST_RLB_ON_OFF_SAVE:
          cmd.AddStringParm(NETPARM_S_RLBRLBNOW,S_SWITCH_ON_SAVE);
          cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,S_SWITCH_OFF);
         break;
         default:
          cmd.AddStringParm(NETPARM_S_RLBRLBNOW,"?");
          cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,"?");
         break;
       };

       {
         unsigned disks = 0;
         rlb.GetDisks(disks);

         std::string s_disks;
         for ( int n = 0; n < 26; n++ )
             {
               if ( (disks >> n) & 1 )
                  {
                    char t[8];
                    sprintf(t,"%c: ",n+'A');
                    s_disks += t;
                  }
             }
         
         cmd.AddStringParm(NETPARM_S_RLBDISKS,s_disks.c_str());
       }

       {
         CRollback::TStringList list;
         rlb.GetExcludePaths(list);

         std::string s_paths;
         
         for ( int n = 0; n < list.size(); n++ )
             {
               s_paths += list[n];
               s_paths += "\n";
             }
         
         cmd.AddStringParm(NETPARM_S_RLBPATHS,s_paths.c_str());
       }
     }
  else
     {
       const char *s;

       if ( err == CRollback::ERR_OS )
          s = S_RLB_ERR_OS;
       else
       if ( err == CRollback::ERR_ACCESS )
          s = S_RLB_ERR_ACCESS;
       else
          s = S_RLB_ERR_OTHER;

       cmd.AddStringParm(NETPARM_S_RLBDRVNOW,s);
       cmd.AddStringParm(NETPARM_S_RLBDRVAFTER,s);
       cmd.AddStringParm(NETPARM_S_RLBRLBNOW,s);
       cmd.AddStringParm(NETPARM_S_RLBRLBAFTER,s);
       cmd.AddStringParm(NETPARM_S_RLBDISKS,"");
       cmd.AddStringParm(NETPARM_S_RLBPATHS,"");
     }
}




