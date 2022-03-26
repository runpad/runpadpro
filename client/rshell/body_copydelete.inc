
static volatile LONG copy_delete_threads_count = 0;
static BOOL copy_delete_threads_sensitive = FALSE;


int GetCopyDeleteThreadsCount(void)
{
  return ( copy_delete_threads_count >= 0 ? copy_delete_threads_count : 0 );
}


BOOL IsCopyDeleteThreadsSensitive(void)
{
  return copy_delete_threads_sensitive;
}


void SetCopyDeleteThreadsCount(int count)
{
  copy_delete_threads_count = count;
}


void SetCopyDeleteThreadsSensitivity(BOOL state)
{
  copy_delete_threads_sensitive = state;
}



typedef struct {
char *from;
char *to;
} SCOPYFILES;


static DWORD WINAPI CopyFilesThread(LPVOID lpParameter)
{
  CDisableWOW64FSRedirection fs_guard;

  SCOPYFILES *info = (SCOPYFILES*)lpParameter;

  InterlockedIncrement(&copy_delete_threads_count);

  if ( info && info->from && info->to && info->from[0] && info->to[0] )
     {
       char s_from[MAX_PATH];
       char s_to[MAX_PATH];

       ZeroMemory(s_from,sizeof(s_from));
       ZeroMemory(s_to,sizeof(s_to));
       lstrcpyn(s_from,info->from,MAX_PATH-2);
       lstrcpyn(s_to,info->to,MAX_PATH-2);

       if ( s_from[0] && s_to[0] )
          {
            SHFILEOPSTRUCT p;
            ZeroMemory(&p,sizeof(p));
            p.hwnd = NULL;
            p.wFunc = FO_COPY;
            p.pFrom = s_from;
            p.pTo = s_to;
            p.fFlags = FOF_NOCONFIRMATION | FOF_NOCONFIRMMKDIR | FOF_NOERRORUI | FOF_SILENT;

            for ( int n = 0; n < 5; n++ )
                {
                  if ( !SHFileOperation(&p) )
                     break;
                  Sleep(RandomRange(700,1300));
                }
          }
     }

  if ( info )
     {
       if ( info->from )
          sys_free(info->from);
       if ( info->to )
          sys_free(info->to);
       sys_free(info);
     }

  InterlockedDecrement(&copy_delete_threads_count);
  return 1;
}


void NetCopyFiles(const CNetCmd &cmd)
{
  if ( cmd.GetParmAsBool(NETPARM_B_KILLTASKS) )
     {
       SetCopyDeleteThreadsSensitivity(TRUE);
       KillAllTasks();
       CloseActiveSheet(TRUE);
     }

  const char *s_from = cmd.GetParmAsString(NETPARM_S_FROM);
  const char *s_to = cmd.GetParmAsString(NETPARM_S_TO);
     
  if ( !s_from || !s_from[0] || !s_to || !s_to[0] )
     return;

  SCOPYFILES *info = (SCOPYFILES *)sys_alloc(sizeof(*info));
  info->from = sys_copystring(CPathExpander(s_from));
  info->to = sys_copystring(CPathExpander(s_to));

  DWORD id;
  HANDLE thread = MyCreateThreadSelectedCPU(CopyFilesThread,(void*)info,&id,THREAD_PRIORITY_IDLE);
  CloseHandle(thread);
}


static void DeleteFilesUsingMask(const char *mask)
{
  WIN32_FIND_DATA f;

  HANDLE h = FindFirstFile(mask,&f);
  BOOL rc = (h != INVALID_HANDLE_VALUE);

  while ( rc )
  {
    if ( lstrcmp(f.cFileName,".") && lstrcmp(f.cFileName,"..") )
       {
         char s[MAX_PATH]; 
         lstrcpy(s,mask);
         PathRemoveFileSpec(s);
         PathAppend(s,f.cFileName);
         
         if ( f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY )
            {
              CleanDir(s);
              sys_removedirectory(s);
            }
         else
            {
              sys_deletefile(s);
            }
       }

    rc = FindNextFile(h,&f);
  }

  FindClose(h);
}


static DWORD WINAPI DeleteFilesThread(LPVOID lpParameter)
{
  CDisableWOW64FSRedirection fs_guard;

  TCFGLIST1 *folders = (TCFGLIST1*)lpParameter;

  if ( folders )
     {
       InterlockedIncrement(&copy_delete_threads_count);

       for ( int n = 0; n < folders->size(); n++ )
           {
             CCfgEntry1 *i = &((*folders)[n]);
             if ( i->IsActive() )
                {
                  const char *folder = i->GetParm();

                  CPathExpander oExp(folder);
                  const char *expanded = oExp.GetPath();
                  
                  if ( StrStr(expanded,"*") || StrStr(expanded,"?") || !PathIsDirectory(expanded) )
                     {
                       DeleteFilesUsingMask(expanded);
                     }
                  else
                     {
                       CleanDir(expanded);
                       char s[MAX_PATH];
                       lstrcpy(s,expanded);
                       if ( lstrlen(s) > 3 )
                          {
                            PathRemoveBackslash(s);
                            sys_removedirectory(s);
                          }
                     }
                }
           }

       InterlockedDecrement(&copy_delete_threads_count);

       delete folders;
     }

  return 1;
}


void NetDeleteFolders(const CNetCmd &cmd)
{
  static HANDLE thread = NULL;

  if ( cmd.GetParmAsBool(NETPARM_B_KILLTASKS) )
     {
       SetCopyDeleteThreadsSensitivity(TRUE);
       KillAllTasks();
       CloseActiveSheet(TRUE);
     }

  if ( thread )
     {
       if ( WaitForSingleObject(thread,0) == WAIT_OBJECT_0 )
          {
            CloseHandle(thread);
            thread = NULL;
          }
       else
          return;
     }
  
  TCFGLIST1 *list = new TCFGLIST1(delete_folders);

  DWORD id;
  thread = MyCreateThreadSelectedCPU(DeleteFilesThread,(void*)list,&id,THREAD_PRIORITY_IDLE);
}
