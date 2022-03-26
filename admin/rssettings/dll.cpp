
#include <windows.h>
#include <objbase.h>
#include <shlobj.h>
#include <shlwapi.h>
#include <setupapi.h>



#define MAX_ADD_LNK_BLOCK_SIZE   2560   //additional data for the .LNK file


typedef struct {
 IShellLink *psl;
 IPersistFile *ppf;
 IShellLinkDataList *psld;
} LNKINFO;


BOOL IsStrEmpty(const char *s)
{
  return !s || !s[0];
}


BOOL IsURLFile(const char *filename)
{
  if ( !filename || !filename[0] )
     return FALSE;

  return (lstrcmpi(PathFindExtension(filename),".url") == 0);
}


void LnkPrepare(LNKINFO *li)
{
  li->psl = NULL;
  li->ppf = NULL;
  li->psld = NULL;

  CoCreateInstance(CLSID_ShellLink,NULL,CLSCTX_INPROC_SERVER,IID_IShellLink,(void **)&li->psl);
  if ( li->psl )
     {
       li->psl->QueryInterface(IID_IPersistFile,(void **)&li->ppf); 
       li->psl->QueryInterface(IID_IShellLinkDataList,(void **)&li->psld);
     }
}


void LnkFinish(LNKINFO *li)
{
  if ( li->psld )
     li->psld->Release(); 
  if ( li->ppf )
     li->ppf->Release(); 
  if ( li->psl )
     li->psl->Release(); 

  li->psl = NULL;
  li->ppf = NULL;
  li->psld = NULL;
}


static const char ror_table[] = {1,1,7,3,2,4,1,6,7,5,0,2,3};


void RORDecode(char *dest,const char *src)
{
  int n;
  char c,rol_value;

  n = 0;
  do {
   c = *src++;
   rol_value = ror_table[(n++)%(sizeof(ror_table)/sizeof(ror_table[0]))] & 7;

   switch ( rol_value )
   {
     case 0: 
             __asm   rol c,0
             break;
     case 1: 
             __asm   rol c,1
             break;
     case 2: 
             __asm   rol c,2
             break;
     case 3: 
             __asm   rol c,3
             break;
     case 4: 
             __asm   rol c,4
             break;
     case 5: 
             __asm   rol c,5
             break;
     case 6: 
             __asm   rol c,6
             break;
     case 7: 
             __asm   rol c,7
             break;
   };

   *dest++ = c;
  } while (c);
}



#define LNK_DESC_ID   33037
#define LNK_DESC_ID2  33129


void GetLnkDescription(const LNKINFO *li,char *desc,BOOL force_old)
{
  if ( !desc )
     return;

  desc[0] = 0;

  if ( force_old )
     return;
   
  if ( li->psl )
     {
       int get_std = 1;
       
       if ( li->psld )
          {
            void *buff = NULL;
            
            if ( li->psld->CopyDataBlock(LNK_DESC_ID2,&buff) == S_OK )
               {
                 if ( buff )
                    {
                      if ( *((DWORD*)buff+0) > sizeof(DWORD) + sizeof(DWORD) )
                         {
                           if ( *((DWORD*)buff+1) == LNK_DESC_ID2 )
                              {
                                const char *s = (char*)((DWORD*)buff+2);

                                if ( lstrlen(s)+1 <= MAX_ADD_LNK_BLOCK_SIZE )
                                   {
                                     RORDecode(desc,s);
                                     get_std = 0;
                                   }
                              }
                         }

                      LocalFree(buff);
                    }
               }
            else
            if ( li->psld->CopyDataBlock(LNK_DESC_ID,&buff) == S_OK )
               {
                 if ( buff )
                    {
                      if ( *((DWORD*)buff+0) > sizeof(DWORD) + sizeof(DWORD) )
                         {
                           if ( *((DWORD*)buff+1) == LNK_DESC_ID )
                              {
                                const char *s = (char*)((DWORD*)buff+2);

                                if ( lstrlen(s)+1 <= MAX_ADD_LNK_BLOCK_SIZE )
                                   {
                                     lstrcpy(desc,s);
                                     get_std = 0;
                                   }
                              }
                         }

                      LocalFree(buff);
                    }
               }
          }

       if ( get_std )
          {
            li->psl->GetDescription(desc,MAX_ADD_LNK_BLOCK_SIZE);
          }
     }
}


void GetURLDescription(const char *filename,char *desc)
{
  if ( !desc )
     return;

  GetPrivateProfileString("RShell","Desc","",desc,MAX_ADD_LNK_BLOCK_SIZE,filename);
}


void UnExpandPathInternal(char *inout)
{
  if ( !IsStrEmpty(inout) )
     {
       char s[MAX_PATH] = "";

       if ( PathUnExpandEnvStrings(inout,s,sizeof(s)) )
          {
            lstrcpy(inout,s);
          }
     }
}


void GetLnkInfoNotInit(const LNKINFO *li,const char *filename,char *path,char *desc,char *arg,char *cwd,int *showcmd,char *icon,int *icon_idx)
{
  WCHAR wsz[MAX_PATH]; 
  WIN32_FIND_DATA wfd; 
  char tpath[MAX_PATH];
  char tdesc[MAX_ADD_LNK_BLOCK_SIZE];
  char targ[MAX_PATH];
  char tcwd[MAX_PATH];
  int tshowcmd;
  char ticon[MAX_PATH];
  int ticon_idx;
  BOOL force_old;

  tpath[0] = 0;
  tdesc[0] = 0;
  targ[0] = 0;
  tcwd[0] = 0;
  tshowcmd = SW_SHOWNORMAL;
  ticon[0] = 0;
  ticon_idx = 0;

  force_old = !lstrcmpi(PathFindExtension(filename),".pif");

  if ( li->psl && li->ppf )
     {
       wsz[0] = 0;
       MultiByteToWideChar(CP_ACP,0,filename,-1,wsz,MAX_PATH);
       if ( li->ppf->Load(wsz,STGM_READ) == S_OK ) 
          {
            li->psl->GetPath(tpath,sizeof(tpath),&wfd,SLGP_RAWPATH);
            li->psl->GetArguments(targ,sizeof(targ));
            li->psl->GetWorkingDirectory(tcwd,sizeof(tcwd));
            li->psl->GetShowCmd(&tshowcmd);
            li->psl->GetIconLocation(ticon,sizeof(ticon),&ticon_idx);
            GetLnkDescription(li,tdesc,force_old);
          }
     }

  if ( IsURLFile(filename) )
     {
       GetURLDescription(filename,tdesc);
       GetPrivateProfileString("InternetShortcut","URL","",tpath,sizeof(tpath),filename);
     }

  if ( !tpath[0] )
     lstrcpy(tpath,filename);

  if ( tshowcmd != SW_SHOWNORMAL && tshowcmd != SW_SHOWMAXIMIZED && tshowcmd != SW_SHOWMINIMIZED && tshowcmd != SW_SHOWMINNOACTIVE && tshowcmd != SW_MINIMIZE && tshowcmd != SW_FORCEMINIMIZE )
     tshowcmd = SW_SHOWNORMAL;

  UnExpandPathInternal(tpath);
  UnExpandPathInternal(tcwd);
  UnExpandPathInternal(ticon);

  if ( path )
     lstrcpy(path,tpath);

  if ( desc )
     lstrcpy(desc,tdesc);

  if ( arg )
     lstrcpy(arg,targ);

  if ( cwd )
     lstrcpy(cwd,tcwd);

  if ( showcmd )
     *showcmd = tshowcmd;

  if ( icon )
     lstrcpy(icon,ticon);

  if ( icon_idx )
     *icon_idx = ticon_idx;
}


void GetLnkInfo(const char *filename,char *path,char *desc,char *arg,char *cwd,int *showcmd,char *icon,int *icon_idx)
{
  LNKINFO li;
  
  LnkPrepare(&li);
  GetLnkInfoNotInit(&li,filename,path,desc,arg,cwd,showcmd,icon,icon_idx);
  LnkFinish(&li);
}



#define TOKEN_PWD	"PWD:"
#define TOKEN_VCD	"VCD:"
#define TOKEN_DESC	"DESC:"
#define TOKEN_SSHOT	"SSHOT:"
#define TOKEN_ONE	"ONE:"
#define TOKEN_RUNAS	"RUNAS:"
#define TOKEN_HIDDEN    "HIDDEN:"
#define TOKEN_VCDNUM    "VCDN:"
#define TOKEN_SAVER     "SAVER:"
#define TOKEN_SCRIPT1   "SCRIPT1:"
#define TOKEN_SCRIPT2   "SCRIPT2:"


static struct {
const char *name;
char value[MAX_PATH];
int need_quotes;
} tokens[] = 
{
  {TOKEN_PWD,"",0},
  {TOKEN_ONE,"",0},
  {TOKEN_RUNAS,"",1},
  {TOKEN_HIDDEN,"",0},
  {TOKEN_VCDNUM,"",0},
  {TOKEN_VCD,"",1},
  {TOKEN_SAVER,"",1},
  {TOKEN_SSHOT,"",1},
  {TOKEN_DESC,"",1},
  {TOKEN_SCRIPT1,"",1},
  {TOKEN_SCRIPT2,"",1},
};



void EmptyTokens(void)
{
  for ( int n = 0; n < sizeof(tokens)/sizeof(tokens[0]); n++ )
      {
        ZeroMemory(tokens[n].value,sizeof(tokens[n].value));
      }
}


void ReadTokens(const char *s)
{
  for ( int n = 0; n < sizeof(tokens)/sizeof(tokens[0]); n++ )
      {
        char find;
        BOOL replaceq;
        
        ZeroMemory(tokens[n].value,sizeof(tokens[n].value));
       
        const char *ss = StrStr(s,tokens[n].name);
        if ( !ss )
           continue;

        ss += lstrlen(tokens[n].name);
        if ( *ss == '\"' )
           {
             ss++;
             find = '\"';
             replaceq = TRUE;
           }
        else
           {
             find = ' ';
             replaceq = FALSE;
           }

        char *out = tokens[n].value;

        while ( *ss && *ss != find && out-tokens[n].value < sizeof(tokens[n].value)-1 )
              *out++ = *ss++;

        if ( replaceq )
           {
             for ( int m = 0; m < lstrlen(tokens[n].value); m++ )
                 if ( tokens[n].value[m] == -73 /*183*/ )
                    tokens[n].value[m] = '\"';
           }
      }
}


const char* GetToken(const char *id)
{
  for ( int n = 0; n < sizeof(tokens)/sizeof(tokens[0]); n++ )
      {
        if ( !lstrcmp(tokens[n].name,id) )
           return tokens[n].value;
      }

  return NULL;
}



typedef struct {
char name[MAX_PATH];
char exe[MAX_PATH];
char arg[MAX_PATH];
char cwd[MAX_PATH];
int showcmd;
char icon[MAX_PATH];
int icon_idx;
char vcd[MAX_PATH];
char desc[MAX_PATH];
char sshot[MAX_PATH];
BOOL allow_one;
char runas_domain[MAX_PATH];
char runas_user[MAX_PATH];
char runas_pwd[MAX_PATH];
int vcd_num;
char saver[MAX_PATH];
char run_script[MAX_PATH];
} OLDFILEINFO;


// str,name,value must be not exceeded MAX_PATH!
void StrReplaceI(char *str,const char *name,const char *value)
{
  if ( IsStrEmpty(str) || IsStrEmpty(name) || !value )
     return;

  if ( lstrlen(str) >= MAX_PATH || lstrlen(name) >= MAX_PATH || lstrlen(value) >= MAX_PATH )
     return;

  if ( !lstrcmpi(name,value) )
     return;
     
  if ( !IsStrEmpty(value) && StrStrI(value,name) )
     return;

  do {

   char *p = StrStrI(str,name);
   if ( p )
      {
        char s[MAX_PATH*2+10] = "";

        lstrcpyn(s,str,p-str+1);
        lstrcat(s,value);
        lstrcat(s,p+lstrlen(name));
        lstrcpyn(str,s,MAX_PATH-1);
      }
   else
      break;

  } while (1);
}


void ReplaceHashByNL(char *s)
{
  StrReplaceI(s,"#","\r\n");
}


void GetOldFileInfoInternalNoCheck(const char *filename,BOOL is_dir,OLDFILEINFO *i)
{
  ZeroMemory(i,sizeof(*i));

  lstrcpy(i->name,PathFindFileName(filename));
  if ( !is_dir )
     PathRemoveExtension(i->name);

  i->showcmd = SW_SHOWNORMAL;
  i->icon_idx = 0;
  i->allow_one = TRUE;
  i->vcd_num = -1;

  char desc[MAX_ADD_LNK_BLOCK_SIZE] = "";
  
  if ( !is_dir )
     {
       GetLnkInfo(filename,i->exe,desc,i->arg,i->cwd,&i->showcmd,i->icon,&i->icon_idx);
     }
  else
     {
       lstrcpy(i->exe,filename);
       UnExpandPathInternal(i->exe);
     }

  EmptyTokens();
  ReadTokens(desc);

  lstrcpy(i->vcd,GetToken(TOKEN_VCD));

  lstrcpy(i->desc,GetToken(TOKEN_DESC));
  ReplaceHashByNL(i->desc);

  lstrcpy(i->sshot,GetToken(TOKEN_SSHOT));

  {
    const char *s = GetToken(TOKEN_ONE);
    if ( !IsStrEmpty(s) )
       {
         i->allow_one = StrToInt(s)?TRUE:FALSE;
       }
  }
  
  {
    char s[MAX_PATH];
    ZeroMemory(s,sizeof(s));
    lstrcpy(s,GetToken(TOKEN_RUNAS));

    for ( int n = lstrlen(s)-1; n >= 0; n-- )
        if ( s[n] == '#' )
           s[n] = 0;

    const char *p = s;
    const char *domain = p; p += lstrlen(p)+1;
    const char *user = p; p += lstrlen(p)+1;
    const char *pwd = p; p += lstrlen(p)+1;

    if ( !IsStrEmpty(domain) && !IsStrEmpty(user) && !IsStrEmpty(pwd) )
       {
         lstrcpy(i->runas_domain,domain);
         lstrcpy(i->runas_user,user);
         lstrcpy(i->runas_pwd,pwd);
       }
  }

  {
    const char *s = GetToken(TOKEN_VCDNUM);
    if ( !IsStrEmpty(s) )
       {
         i->vcd_num = StrToInt(s);
       }
  }

  lstrcpy(i->saver,GetToken(TOKEN_SAVER));
  ReplaceHashByNL(i->saver);
  
  lstrcpy(i->run_script,GetToken(TOKEN_SCRIPT1));
  ReplaceHashByNL(i->run_script);

  {
    const char *s = GetToken(TOKEN_HIDDEN);
    if ( !IsStrEmpty(s) && StrToInt(s) != 0 )
       {
         i->showcmd = SW_HIDE;
       }
  }
}


typedef BOOL (__cdecl *OLDFILEPROC)(const OLDFILEINFO *i,void *parm);


extern "C" 
__declspec(dllexport) void __cdecl OldLnkFile_Iterate(const char *path,OLDFILEPROC proc,void *parm)
{
  CoInitialize(0);
  
  if ( !IsStrEmpty(path) )
     {
       char s[MAX_PATH];
       lstrcpy(s,path);
       PathAppend(s,"*.*");

       WIN32_FIND_DATA wfd;

       HANDLE h = FindFirstFile(s,&wfd);
       if ( h != INVALID_HANDLE_VALUE )
          {
            do {

             DWORD attr = wfd.dwFileAttributes;

             if ( !(attr&FILE_ATTRIBUTE_HIDDEN) && !(attr&FILE_ATTRIBUTE_SYSTEM) )
                {
                  if ( lstrcmp(wfd.cFileName,".") && lstrcmp(wfd.cFileName,"..") )
                     {
                       //const char *ext = PathFindExtension(wfd.cFileName);

                       //if ( !lstrcmpi(ext,".lnk") || !lstrcmpi(ext,".pif") || !lstrcmpi(ext,".url") )
                          {
                            char filename[MAX_PATH];
                            lstrcpy(filename,path);
                            PathAppend(filename,wfd.cFileName);

                            OLDFILEINFO i;
                            GetOldFileInfoInternalNoCheck(filename,(attr&FILE_ATTRIBUTE_DIRECTORY)?TRUE:FALSE,&i);

                            if ( proc )
                               {
                                 if ( !proc(&i,parm) )
                                    break;
                               }
                          }
                     }
                }

            } while ( FindNextFile(h,&wfd) );

            FindClose(h);
          }
     }

  CoUninitialize();
}


extern "C"
__declspec(dllexport) HDEVINFO __cdecl DLL_CreateFlashDrivesEnumerator()
{
  //{4D36E967-E325-11CE-BFC1-08002BE10318} - diskdrives guid
  static const GUID classname = {0x4D36E967,0xE325,0x11CE,{ 0xBF, 0xC1, 0x08, 0x00, 0x2B, 0xE1, 0x03, 0x18}};

  return SetupDiGetClassDevs(&classname,0,0,DIGCF_PRESENT);
}


extern "C"
__declspec(dllexport) void __cdecl DLL_DestroyFlashDrivesEnumerator(HDEVINFO h)
{
  if ( h != INVALID_HANDLE_VALUE )
     {
       SetupDiDestroyDeviceInfoList(h);
     }
}


extern "C"
__declspec(dllexport) BOOL __cdecl DLL_GetNextFlashDrive(HDEVINFO h,int &idx,char *s_inst,int max)
{
  BOOL rc = FALSE;
  
  if ( h != INVALID_HANDLE_VALUE )
     {
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
                   lstrcpyn(s_inst,s,max);
                   rc = TRUE;
                   break;
                 }
            }
       }
     }

  return rc;
}
