
#define MAXFLASHDRIVES 26

typedef struct {
BOOL active;
unsigned free_space;
unsigned uploaded;
} FLASHDRIVE;

static FLASHDRIVE flash_drives[MAXFLASHDRIVES] = {{FALSE,0,0},};


void CollectFlashDrivesInfo4Stat(void)
{
  int n,drives;
  
  ZeroMemory(flash_drives,sizeof(flash_drives));

  drives = GetLogicalDrives();
       
  for ( n = 2; n < MAXFLASHDRIVES; n++ )
      if ( (drives >> n) & 1 )
         {
           char s[8];

           s[0] = 'A'+n;
           s[1] = ':';
           s[2] = '\\';
           s[3] = 0;

           if ( GetDriveType(s) == DRIVE_REMOVABLE || IsDriveTrueRemovableI(n) )
              {
                OnFlashDriveInserted4Stat(n);
              }
         }
}


void FinishFlashDrives4Stat(void)
{
  int n;

  for ( n = 0; n < MAXFLASHDRIVES; n++ )
      {
        FLASHDRIVE *f = &flash_drives[n];

        if ( f->active )
           OnFlashDriveRemoved4Stat(n);
      }
}


void OnFlashDriveInserted4Stat(int _drive)
{
  char drive[MAX_PATH];
  DWORD sn,err;
  BOOL rc;
  FLASHDRIVE *f = &flash_drives[_drive];

  wsprintf(drive,"%c:\\",_drive+'A');

  err = SetErrorMode(SEM_FAILCRITICALERRORS);
  rc = GetVolumeInformation(drive,NULL,0,&sn,NULL,NULL,NULL,0);
  SetErrorMode(err);

  if ( f->active )
     OnFlashDriveRemoved4Stat(_drive);
  
  if ( rc )
     {
       f->active = TRUE;
       f->uploaded = 0;
       f->free_space = GetDriveFreeSpace(drive);
     }
}


void OnFlashDriveRemoved4Stat(int _drive)
{
  FLASHDRIVE *f = &flash_drives[_drive];

  if ( f->active )
     {
       if ( allow_use_flash && !net_flash[0] && allow_flash_stat )
          {
            AddServiceString2SQLBase(GCID_FLASHDISK,1,f->uploaded,0,NULL);
          }
       
       f->active = FALSE;
       f->uploaded = 0;
       f->free_space = 0;
     }
}


void OnFlashDriveFormatted4Stat(int _drive)
{
  FLASHDRIVE *f = &flash_drives[_drive];

  if ( f->active )
     {
       char drive[MAX_PATH];
       
       wsprintf(drive,"%c:\\",_drive+'A');

       f->uploaded = 0;
       f->free_space = GetDriveFreeSpace(drive);
     }
}


void OnFlashDriveFilesDeleted4Stat(int _drive)
{
  FLASHDRIVE *f = &flash_drives[_drive];

  if ( f->active )
     {
       char drive[MAX_PATH];
       
       wsprintf(drive,"%c:\\",_drive+'A');

       f->free_space = GetDriveFreeSpace(drive);
     }
}


void OnFlashDriveFilesAdded4Stat(int _drive)
{
  FLASHDRIVE *f = &flash_drives[_drive];

  if ( f->active )
     {
       char drive[MAX_PATH];
       unsigned new_space;
       
       wsprintf(drive,"%c:\\",_drive+'A');

       new_space = GetDriveFreeSpace(drive);

       if ( new_space < f->free_space )
          {
            f->uploaded += f->free_space - new_space;
          }
       
       f->free_space = new_space;
     }
}


BOOL IsAnyOfInsertedFlashesHardwareIdFoundInList(const char *list)
{
  BOOL rc = FALSE;
  
  //{4D36E967-E325-11CE-BFC1-08002BE10318} - diskdrives guid
  static const GUID classname = {0x4D36E967,0xE325,0x11CE,{ 0xBF, 0xC1, 0x08, 0x00, 0x2B, 0xE1, 0x03, 0x18}};

  HDEVINFO h = SetupDiGetClassDevs(&classname,0,0,DIGCF_PRESENT);
  if ( h != INVALID_HANDLE_VALUE )
     {
       int idx = 0;
       while (1)
       {
         SP_DEVINFO_DATA DeviceInfoData;
         DeviceInfoData.cbSize = sizeof(SP_DEVINFO_DATA);
         if ( !SetupDiEnumDeviceInfo(h,idx,&DeviceInfoData) )
          break;

         idx++;

         char s[MAX_PATH] = "";
         if ( SetupDiGetDeviceInstanceId(h,&DeviceInfoData,s,sizeof(s),NULL) )
            {
              if ( !StrCmpNI(s,"USB",3) )
                 {
                   if ( StrStrI(NNS(list),s) )
                      {
                        rc = TRUE;
                        break;
                      }
                 }
            }
       }
       
       SetupDiDestroyDeviceInfoList(h);
     }

  return rc;
}


