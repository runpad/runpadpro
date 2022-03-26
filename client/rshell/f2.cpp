
// some higher-level functions

#include "include.h"


#include "f2_assoc.inc"
#include "f2_desktop.inc"
#include "f2_inject.inc"
#include "f2_iterators.inc"
#include "f2_lnk.inc"
#include "f2_pic.inc"
#include "f2_process.inc"
#include "f2_shellobj.inc"
#include "f2_task.inc"
#include "f2_extracticon.inc"
#include "f2_aa.inc"
#include "f2_thread.inc"
#include "f2_res.inc"



BOOL IsApplicationHung(HWND w,int timeout)
{
  DWORD rc;
  return !SendMessageTimeout(w,RegisterWindowMessage("_TestAppHung"),0,0,SMTO_BLOCK|SMTO_ABORTIFHUNG,timeout,(PDWORD_PTR)&rc);
}


BOOL IsTempRelativeDir(const char *dir)
{
  BOOL rc = FALSE;

  if ( dir && dir[0] )
     {
       char temp[MAX_PATH];
       
       temp[0] = 0;
       GetTempPath(sizeof(temp),temp);

       if ( temp[0] )
          {
            char s[MAX_PATH];
            
            lstrcpy(s,dir);
            GetShortPathName(s,s,sizeof(s));
            GetShortPathName(temp,temp,sizeof(temp));

            if ( s[0] && temp[0] )
               {
                 PathAddBackslash(s);
                 PathAddBackslash(temp);

                 if ( lstrlen(s) > lstrlen(temp) )
                    {
                      if ( !StrCmpNI(s,temp,lstrlen(temp)) )
                         {
                           rc = TRUE;
                         }
                    }
               }
          }
     }

  return rc;
}


BOOL IsExplorerLoaded(void)
{
  return GetShellWindow() != NULL;
}


static BOOL DelProc(const char *path,WIN32_FIND_DATA *f,void *user)
{
  if ( f->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY )
     {
       CleanDir(path);
       sys_removedirectory(path);
     }
  else
     {
       sys_deletefile(path);
     }

  return TRUE;
}



void CleanDir(const char *dir)
{
  ScanDir(dir,SCAN_DIR | SCAN_FILE | SCAN_HIDDEN,DelProc,NULL);
}


void LoadTextFromDescriptionToken(const char *token,char *out,int max)
{
  if ( !out )
     return;

  out[0] = 0;

  if ( !token || !token[0] || max < 2 )
     return;

  char *s = sys_copystring(token);

  if ( (lstrlen(s) < MAX_PATH && !StrStrI(s,"\n") && StrStrI(s,"\\")) &&
       ((lstrlen(s) >= 3 && s[1] == ':' && s[2] == '\\') || 
        (lstrlen(s) >= 3 && s[0] == '\\' && s[1] == '\\') ||
        (lstrlen(s) >= 3 && s[0] == '%')) )
     {
       void *h = sys_fopenr(CPathExpander(s));
       if ( h )
          {
            int count = 0;

            while ( count < max-1 )
            {
              char c;
              
              if ( sys_fread(h,&c,sizeof(c)) != sizeof(c) )
                 break;

              if ( c != '\r' )
                 {
                   *out++ = c;
                   count++;
                 }
            }

            *out++ = 0;

            sys_fclose(h);
          }
     }
  else
     {
       int count = 0;
       const char *p = s;

       while ( count < max-1 )
       {
         char c = *p++;
         
         if ( !c )
            break;

         if ( c != '\r' )
            {
              *out++ = c;
              count++;
            }
       }

       *out++ = 0;
     }

  sys_free(s);
}


typedef struct {
int max;
char **list;
int count;
} TGALLERY;


static BOOL ScanPicFunc(const char *s,WIN32_FIND_DATA *f,void *user)
{
  TGALLERY *g = (TGALLERY*)user;
  char *ext;
  
  if ( g->count == g->max )
     return FALSE;
  
  ext = PathFindExtension(s);
  if ( !lstrcmpi(ext,".jpg") || !lstrcmpi(ext,".jpeg") || !lstrcmpi(ext,".jpe") || !lstrcmpi(ext,".bmp") || !lstrcmpi(ext,".png") || !lstrcmpi(ext,".gif") )
     {
       char *t = (char*)sys_alloc(lstrlen(s)+1);
       lstrcpy(t,s);
       g->list[g->count++] = t;
     }

  return TRUE;
}


// path must be expanded!
void GetRandomPictureFileFromGallery(const char *path,char *out)
{
  out[0] = 0;

  if ( path && path[0] && IsFileExist(path) && PathIsDirectory(path) )
     {
       TGALLERY g;
       int n;

       g.max = 300;
       g.list = (char**)sys_zalloc(g.max*sizeof(*g.list));
       g.count = 0;

       ScanDir(path,SCAN_FILE,ScanPicFunc,(void*)&g);

       if ( g.count )
          {
            lstrcpy(out,g.list[RandomRange(0,g.count-1)]);
          }

       for ( n = 0; n < g.count; n++ )
           {
             if ( g.list[n] )
                sys_free(g.list[n]);
           }

       sys_free(g.list);
     }
}


void RemoveAppCompatFlags(void)
{
  char exe[MAX_PATH];
  char s[MAX_PATH];
  
  GetModuleFileName(our_instance,exe,sizeof(exe));
  ReadRegStr(HKCU,"Software\\Microsoft\\Windows NT\\CurrentVersion\\AppCompatFlags\\Layers",exe,s,"");
  if ( s[0] )
     {
       DeleteRegValue(HKCU,"Software\\Microsoft\\Windows NT\\CurrentVersion\\AppCompatFlags\\Layers",exe);
     }
}


BOOL ImportRegistryFileGuarantee(const char *filename)
{
  int regdisable = ReadRegDword(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableRegistryTools",0);
  if ( regdisable )
     {
       AdminAccessWriteRegDword(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableRegistryTools",0);
     }

  BOOL rc = ImportRegistryFile(filename);

  if ( regdisable )
     {
       AdminAccessWriteRegDword(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableRegistryTools",1);
     }

  return rc;
}

