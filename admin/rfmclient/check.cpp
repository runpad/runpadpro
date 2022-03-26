
#include <windows.h>
#include <shlwapi.h>
#include <tlhelp32.h>


// the same code in RSRDCLIENT/RFMCLIENT !!!



BOOL IsFileExist(const char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


BOOL WriteRegDword(HKEY root,const char *key,const char *value,DWORD data)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_DWORD,(const BYTE *)&data,4) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


BOOL DeleteRegValue(HKEY root,const char *key,const char *value)
{
  BOOL rc = FALSE;

  HKEY h = NULL;
  DWORD err = RegOpenKeyEx(root,key,0,KEY_WRITE,&h);

  if ( err == ERROR_SUCCESS )
     {
       DWORD err = RegDeleteValue(h,value);
       if ( err == ERROR_SUCCESS || err == ERROR_FILE_NOT_FOUND )
          rc = TRUE;
       RegCloseKey(h);
     }
  else
  if ( err == ERROR_FILE_NOT_FOUND )
     {
       rc = TRUE;
     }

  return rc;
}


static BOOL IsUserAnAdminMy()
{
  //todo: get sources from MSDN or W2KSRC
  BOOL rc = FALSE;

  if ( WriteRegDword(HKEY_LOCAL_MACHINE,"Software","rs_test_val_2347654765",0) )
     {
       DeleteRegValue(HKEY_LOCAL_MACHINE,"Software","rs_test_val_2347654765");
       rc = TRUE;
     }

  return rc;
}


BOOL IsAdminAccount()
{
  BOOL need_free = FALSE;
  HINSTANCE lib = GetModuleHandle("shell32.dll");

  if ( !lib )
     {
       lib = LoadLibrary("shell32.dll");
       need_free = TRUE;
     }

  BOOL (WINAPI *pIsUserAnAdmin)(void);
  *(void**)&pIsUserAnAdmin = (void*)GetProcAddress(lib,"IsUserAnAdmin");

  BOOL rc = pIsUserAnAdmin ? pIsUserAnAdmin() : IsUserAnAdminMy();
  
  if ( need_free )
     {
       if ( lib )
          {
            FreeLibrary(lib);
          }
     }

  return rc;
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


//extern "C" __declspec(dllexport) BOOL __cdecl CheckAtStartup(HWND parent,BOOL silent)
BOOL CheckAtStartup(HWND parent,BOOL silent)
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
               MessageBox(parent,"Необходимы права администратора для запуска\n(для Vista используйте \"Правый клик\"->\"Запуск от имени администратора\")",NULL,MB_OK | MB_ICONERROR);

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



