
#include <windows.h>
#include <shlwapi.h>
#include <commdlg.h>
#include <shlobj.h>
#include <objbase.h>
#include <oleauto.h>
#include <wia.h>
#include <sti.h>
#include "utils.h"
#include "gdip.h"
#include "main.h"
#include "lang.h"
#include "../rp_shared/rp_shared.h"


static void GetSpecialFolder(int folder,char *s)
{
  LPMALLOC pMalloc;
  LPITEMIDLIST pidl;

  s[0] = 0;

  if ( SHGetMalloc(&pMalloc) == NOERROR ) 
     {
       if ( SHGetSpecialFolderLocation(NULL,folder,&pidl) == NOERROR )
          {
            SHGetPathFromIDList(pidl,s);
            pMalloc->lpVtbl->Free(pMalloc,pidl);
          }

       pMalloc->lpVtbl->Release(pMalloc);
     }
}


static char *GetSaveFile(HWND parent,char *filter,char *name,char *defext)
{
  static char out[MAX_PATH];
  char dir[MAX_PATH];
  OPENFILENAME p;

  dir[0] = 0;
  GetSpecialFolder(CSIDL_DESKTOP,dir);
  
  lstrcpy(out,name);
  ZeroMemory(&p,sizeof(p));
  p.lStructSize = sizeof(p);
  p.hwndOwner = parent;
  p.lpstrFilter = filter;
  p.nFilterIndex = 1;
  p.lpstrDefExt = defext;
  p.lpstrInitialDir = dir[0]?dir:NULL;
  p.lpstrFile = out;
  p.nMaxFile = MAX_PATH;
  p.Flags = OFN_HIDEREADONLY | OFN_LONGNAMES | OFN_OVERWRITEPROMPT | OFN_PATHMUSTEXIST;
  
  return GetSaveFileName(&p) ? out : NULL;
}


static BOOL SaveConvertFile(HWND hwnd,char *temp_path,char *out_path)
{
  BOOL rc;
  char *selected_file;
  
  out_path[0] = 0;
  
  if ( !FileExist(temp_path) )
     {
       MessageBox(hwnd,S_SCAN_ERROR_FILENOTFOUND,LS(LS_ERROR),MB_OK | MB_ICONERROR);
       return FALSE;
     }

  selected_file = GetSaveFile(hwnd,"BMP (*.bmp)\0*.bmp\0JPEG (*.jpg)\0*.jpg\0PNG (*.png)\0*.png\0TIFF (*.tif)\0*.tif\0\0","scan_000",".bmp");

  if ( !selected_file )   
     {
       DeleteFile(temp_path);
       return FALSE;
     }
 
  if ( lstrcmpi(PathFindExtension(selected_file),".bmp") )
     {
       int w,h;
       void *buff = NULL;
       
       if ( !LoadPicFile(temp_path,&w,&h,&buff) )
          {
            DeleteFile(temp_path);
            MessageBox(hwnd,S_SCAN_ERROR_FILELOAD,LS(LS_ERROR),MB_OK | MB_ICONERROR);
            return FALSE;
          }

       DeleteFile(temp_path);

       PathRemoveFileSpec(temp_path);
       PathAppend(temp_path,PathFindFileName(selected_file));

       if ( !SavePicFile(temp_path,w,h,buff) )
          {
            DeleteFile(temp_path);
            FreePicFile(buff);
            MessageBox(hwnd,S_SCAN_ERROR_FILESAVE,LS(LS_ERROR),MB_OK | MB_ICONERROR);
            return FALSE;
          }

       FreePicFile(buff);
     }

  rc = CopyFile(temp_path,selected_file,FALSE);
  DeleteFile(temp_path);

  if ( rc )
     {
       lstrcpy(out_path,selected_file);
       return TRUE;
     }
  else
     {
       MessageBox(hwnd,S_SCAN_ERROR_FILECOPY,LS(LS_ERROR),MB_OK | MB_ICONERROR);
       return FALSE;
     }

  return FALSE;
}



BOOL DoScanImage(HWND hwnd,char *out_path)
{
  BOOL exit_code = FALSE;
  IWiaDevMgr *wia = NULL;

  out_path[0] = 0;

  CoCreateInstance(&CLSID_WiaDevMgr,NULL,CLSCTX_LOCAL_SERVER,&IID_IWiaDevMgr,(void **)&wia);
  if ( wia )
     {
       HRESULT hrc = S_FALSE;
       char temp_path[MAX_PATH];
       WCHAR wsz[MAX_PATH];
       BSTR bfilename = NULL;

       temp_path[0] = 0;
       GetTempPath(sizeof(temp_path),temp_path);
       PathAddBackslash(temp_path);
       CreateDirectory(temp_path,NULL);
       PathAppend(temp_path,"scan_tmp_000.bmp");
       DeleteFile(temp_path);

       wsz[0] = 0;
       MultiByteToWideChar(CP_ACP,0,temp_path,-1,wsz,MAX_PATH);

       bfilename = SysAllocString(wsz);
       if ( bfilename )
          {
            GUID format;
            
            CopyMemory(&format,&WiaImgFmt_BMP,sizeof(format));
            
            hrc = wia->lpVtbl->GetImageDlg(wia,hwnd,StiDeviceTypeDefault,WIA_DEVICE_DIALOG_SINGLE_IMAGE|WIA_DEVICE_DIALOG_USE_COMMON_UI,
                                     WIA_INTENT_NONE,NULL,bfilename,&format);

            SysFreeString(bfilename);
          }

       wia->lpVtbl->Release(wia);

       switch (hrc)
       {
         case S_OK:
                      if ( SaveConvertFile(hwnd,temp_path,out_path) )
                         exit_code = TRUE;
                      break;
         case S_FALSE:
                      break;
         case WIA_S_NO_DEVICE_AVAILABLE:
                      MessageBox(hwnd,S_SCAN_PLUG,LS(LS_ERROR),MB_OK | MB_ICONERROR);
                      break;
         default:
                      MessageBox(hwnd,S_SCAN_ERROR,LS(LS_ERROR),MB_OK | MB_ICONERROR);
                      break;
       };
     }
  else
     {
       MessageBox(hwnd,S_SCAN_INSTALL,LS(LS_ERROR),MB_OK | MB_ICONERROR);
     }

  return exit_code;
}


void ExecuteSelfScan(void)
{
  STARTUPINFO si;
  PROCESS_INFORMATION pi;
  char cmd[MAX_PATH];
  char self[MAX_PATH];

  self[0] = 0;
  GetModuleFileName(instance,self,MAX_PATH);

  wsprintf(cmd,"\"%s\" -scan",self);
  
  ZeroMemory(&si,sizeof(si));
  si.cb = sizeof(si);
  CreateProcess(NULL,cmd,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi);
}
