
#include <windows.h>
#include <shlwapi.h>
#include "hack.h"
#include "twain.h"



CRITICAL_SECTION g_section;
HACK *g_hack = NULL;
void *g_orig = NULL;


void HackFunction(void);
void* UnhackFunction(void);



BOOL OnSuccessScan(void)
{
  BOOL rc = FALSE;

  HWND w = FindWindow("_RunpadClass",NULL);
  if ( w )
     {
       rc = SendMessage(w,WM_USER+187/*198*/,0,0);
       if ( rc )
          PostMessage(w,WM_USER+175,0,0);
     }

  return rc;
}


TW_UINT16 FAR PASCAL MyDSMEntry(pTW_IDENTITY pOrigin,pTW_IDENTITY pDest,TW_UINT32 DG,TW_UINT16 DAT,TW_UINT16 MSG,TW_MEMREF pData)
{
  DSMENTRYPROC p_orig = UnhackFunction();

  TW_UINT16 rc = p_orig ? p_orig(pOrigin,pDest,DG,DAT,MSG,pData) : TWRC_FAILURE;

  if ( DG == DG_IMAGE && MSG == MSG_GET &&
       (DAT == DAT_IMAGENATIVEXFER || DAT == DAT_IMAGEMEMXFER || DAT == DAT_IMAGEFILEXFER) &&
       rc == TWRC_XFERDONE )
     {
       if ( !OnSuccessScan() )
          {
            rc = TWRC_FAILURE;
          }
     }

  HackFunction();

  return rc;
}


void HackFunction(void)
{
  EnterCriticalSection(&g_section);

  if ( !g_hack )
     {
       char s[MAX_PATH];

       s[0] = 0;
       GetWindowsDirectory(s,sizeof(s));
       PathAppend(s,"twain_32.dll");
       
       g_hack = HackAPIFunction(s,MAKEINTRESOURCE(1),MyDSMEntry);
       if ( !g_hack )
          g_hack = HackAPIFunction(s,"DSM_Entry",MyDSMEntry);

       if ( !g_hack )
          {
            lstrcpy(s,"twain_32.dll");

            g_hack = HackAPIFunction(s,MAKEINTRESOURCE(1),MyDSMEntry);
            if ( !g_hack )
               g_hack = HackAPIFunction(s,"DSM_Entry",MyDSMEntry);
          }

       if ( !g_orig )
          g_orig = g_hack ? g_hack->base_addr : NULL;
     }

  LeaveCriticalSection(&g_section);
}


void* UnhackFunction(void)
{
  void *p_orig;
  
  EnterCriticalSection(&g_section);

  p_orig = g_orig;

  if ( g_hack )
     {
       UnhackAPIFunction(g_hack);
       g_hack = NULL;
     }

  LeaveCriticalSection(&g_section);

  return p_orig;
}


DWORD WINAPI InitThreadProc(LPVOID lpParameter)
{
  HackFunction();
  return 1;
}


BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
  if ( dwReason == DLL_PROCESS_ATTACH )
     {
       DWORD id;
       HANDLE h_thread;

       InitializeCriticalSection(&g_section);
       
       h_thread = CreateThread(NULL,0,InitThreadProc,NULL,0,&id);
       if ( h_thread )
          CloseHandle(h_thread);
     }
  else
  if ( dwReason == DLL_PROCESS_DETACH )
     {
       UnhackFunction();
       DeleteCriticalSection(&g_section);
     }

  return 1;
}
