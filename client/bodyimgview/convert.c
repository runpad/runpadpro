
#include <windows.h>
#include <shlwapi.h>
#include "lang.h"
#include "main.h"
#include "utils.h"
#include "gdip.h"
#include "files.h"
#include "../rp_shared/rp_shared.h"



static void GetUniqueFileName(char *file)
{
  char s[MAX_PATH];
  int probe = 1;

  lstrcpy(s,file);
  
  while ( FileExist(s) )
  {
    char temp[MAX_PATH];
    lstrcpy(s,file);
    PathRemoveExtension(s);
    wsprintf(temp,"%s (%d)%s",s,probe++,PathFindExtension(file));
    lstrcpy(s,temp);
  };

  lstrcpy(file,s);
}


void ConvertFormat(HWND hwnd,const char *file,int rotate)
{
  if ( file && file[0] && FileExist(file) )
     {
       char text[MAX_PATH];
       int rc;

       wsprintf(text,S_CONVERT_FILE,PathFindFileName(file));

       rc = RPMessageBox(hwnd,text,S_CONVERT_TITLE,"JPG\0BMP\0PNG\0GIF\0TIFF\0\0",0,RPICON_QUESTION);

       if ( rc != -1 )
          {
            static const char* exts[] = {".jpg",".bmp",".png",".gif",".tif"};
            char src_file[MAX_PATH];
            char dest_file[MAX_PATH];
            int w,h;
            void *buff = NULL;

            lstrcpy(src_file,file);
            lstrcpy(dest_file,file);
            PathRemoveExtension(dest_file);
            lstrcat(dest_file,exts[rc]);
            GetUniqueFileName(dest_file);

            SetCursor(LoadCursor(NULL, IDC_WAIT));
            
            if ( LoadPicFile(src_file,&w,&h,&buff) && buff )
               {
                 if ( SavePicFile(dest_file,w,h,buff) )
                    {
                      char s[MAX_PATH];
                      wsprintf(s,S_SUCCESS_CONVERT,PathFindFileName(dest_file));
                      MessageBox(hwnd,s,LS(LS_INFO),MB_OK | MB_ICONINFORMATION);
                    }
                 else
                    {
                      MessageBox(hwnd,S_ERR_CONVERT,LS(LS_ERROR),MB_OK | MB_ICONERROR);
                    }
                 
                 FreePicFile(buff);
               }

            SetCursor(LoadCursor(NULL, IDC_ARROW));
          }
     }
}
