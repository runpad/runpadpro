

static void ScheduleSingleDisk(int disk)
{
  char buff[4096+MAX_PATH],*p;
  char s[MAX_PATH];
  int len = 0;

  ZeroMemory(buff,sizeof(buff));
  ReadRegMultiStr(HKLM,"SYSTEM\\CurrentControlSet\\Control\\Session Manager","BootExecute",buff,sizeof(buff)-MAX_PATH,&len);

  wsprintf(s,"autocheck autochk /p \\??\\%c:",disk+'A');

  p = buff;
  while ( *p )
  {
    if ( !lstrcmpi(p,s) )
       return;

    p += lstrlen(p) + 1;
  };

  MoveMemory(buff+lstrlen(s)+1,buff,len);
  lstrcpy(buff,s);

  p = buff;
  do {
    p += lstrlen(p)+1;
  } while ( *p );
  p++;
  len = p-buff;

  AdminAccessWriteRegMultiStr(HKLM,"SYSTEM\\CurrentControlSet\\Control\\Session Manager","BootExecute",buff,len);
}


void ScheduleScanDisk(void)
{
  if ( do_scandisk )
     {
       unsigned last_time;
       int interval = scandisk_hours;
       if ( interval < 1 )
          interval = 1;
       interval *= 60;

       last_time = ReadRegDword(HKLM,REGPATH,"LastScanDiskScheduleTime",0);

       if ( last_time + (unsigned)interval <= GetLocalTimeMin() )
          {
            if ( scandisk_disks )
               {
                 int n;

                 for ( n = 0; n < 26; n++ )
                     if ( (scandisk_disks >> n) & 1 )
                        ScheduleSingleDisk(n);
               }

            AdminAccessWriteRegDword(HKLM,REGPATH,"LastScanDiskScheduleTime",GetLocalTimeMin());
          }
     }
}

