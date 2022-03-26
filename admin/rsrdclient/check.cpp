
#include <windows.h>
#include <shlwapi.h>
#include <tlhelp32.h>
#include "../../client/rshell/f0.h"


// the same code in RSRDCLIENT/RFMCLIENT !!!



BOOL IsFileExist(const char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


int GetParentProcessId(int pid)
{
  int rc = -1;
  
  HANDLE h = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);

  if ( h != INVALID_HANDLE_VALUE )
     {
       PROCESSENTRY32 i;
       ZeroMemory(&i,sizeof(i));
       i.dwSize = sizeof(i);

       BOOL b = Process32First(h,&i);
       while (b)
       {
         if ( i.th32ProcessID == pid )
            {
              rc = i.th32ParentProcessID;
              break;
            }

         b = Process32Next(h,&i);
       }

       CloseHandle(h);
     }

  return rc;
}


void GetFileNameInLocalDir(const char *local,char *out)
{
  if ( out )
     {
       char s[MAX_PATH] = "";
       GetModuleFileName(NULL,s,sizeof(s));
       PathRemoveFileSpec(s);
       PathAppend(s,local);
       lstrcpy(out,s);
     }
}


BOOL AreWeStartedFromOperatorProgram()
{
  BOOL rc = FALSE;

  HWND w = FindWindow("_RSOperatorClass",NULL);
  if ( w )
     {
       DWORD pid = -1;
       GetWindowThreadProcessId(w,&pid);

       if ( pid != -1 )
          {
            int parent = GetParentProcessId(GetCurrentProcessId());
            if ( parent != -1 )
               {
                 if ( parent == pid )
                    {
                      rc = TRUE;
                    }
               }
          }
     }

  return rc;
}


BOOL IsAdminProgram()
{
  char s[MAX_PATH] = "";

  GetFileNameInLocalDir("rssettings.exe",s);

  return IsFileExist(s);
}


extern "C" __declspec(dllexport) BOOL __cdecl CheckAtStartup(HWND parent,BOOL silent)
{
  if ( AreWeStartedFromOperatorProgram() )
     return TRUE;

  if ( IsAdminProgram() )
     {
       if ( IsAdminAccount() )
          {
            return TRUE;
          }
       else
          {
            if ( !silent )
               MessageBox(parent,"Необходимы права администратора для запуска\n(для Vista/7 используйте \"Правый клик\"->\"Запуск от имени администратора\")",NULL,MB_OK | MB_ICONERROR);

            return FALSE;
          }
     }
  else
     {
       if ( !silent )
          MessageBox(parent,"Возможен запуск только из программы оператора",NULL,MB_OK | MB_ICONERROR);

       return FALSE;
     }
}



