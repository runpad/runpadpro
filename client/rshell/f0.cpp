
// functions used by both shell, cfg_dll, service

#include "include.h"


#include "f0_buff.inc"
#include "f0_dynbuff.inc"
#include "f0_windowproc.inc"
#include "f0_path.inc"



int RangeI(int v,int min,int max)
{
  if ( v < min )
     v = min;
  if ( v > max )
     v = max;

  return v;
}



static unsigned r_seed = 0;  // not thread safe!!!

void SetRandSeed(unsigned s)
{
  r_seed = s;
}


int RandomSeed()
{
  r_seed = r_seed * 0x41C64E6D + 0x3039;
  return (r_seed >> 16) & 0xFFFF;
}


int RandomWord(void)
{
  unsigned seed = GetTickCount();
  seed = seed * 0x41C64E6D + 0x3039;
  return (seed >> 16) & 0xFFFF;
}


int RandomRange(int min,int max)
{
  if ( max-min+1 == 0 )
     {
       int t = min;
       min = max;
       max = t;
     }
  
  return min + RandomWord() % (max-min+1);
}


BOOL IsBoolEqu(BOOL b1,BOOL b2)
{
  return (b1 && b2) || (!b1 && !b2);
}


BOOL IsStrEmpty(const char *s)
{
  return !s || !s[0];
}


BOOL IsStrEmpty(const WCHAR *s)
{
  return !s || !s[0];
}


BOOL IsStringEmpty(const char *s)
{
  return IsStrEmpty(s);
}


void *sys_alloc(int size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void *sys_realloc(void *buff,int newsize)
{
  return HeapReAlloc(GetProcessHeap(),0,buff,newsize);
}


char *sys_copystring(const char *_src,int max)
{
  const char *src = _src ? _src : "";

  char *s = (char*)sys_alloc(lstrlen(src)+1);

  if ( !max )
     lstrcpy(s,src);
  else
     lstrcpyn(s,src,max);

  return s;
}


WCHAR *sys_copystringW(const WCHAR *_src,int max)
{
  const WCHAR *src = _src ? _src : L"";

  WCHAR *s = (WCHAR*)sys_alloc((lstrlenW(src)+1)*sizeof(WCHAR));

  if ( !max )
     lstrcpyW(s,src);
  else
     lstrcpynW(s,src,max);

  return s;
}


char *sys_copystring_replace_empty_by_null(const char *_src,int max)
{
  const char *src = _src;

  if ( src && !src[0] )
     src = NULL;

  if ( src == NULL )
     return NULL;

  char *s = (char*)sys_alloc(lstrlen(src)+1);

  if ( !max )
     lstrcpy(s,src);
  else
     lstrcpyn(s,src,max);

  return s;
}


void *sys_zalloc(int size)
{
  return HeapAlloc(GetProcessHeap(),HEAP_ZERO_MEMORY,size);
}


void sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}


BOOL WriteRegStr(HKEY root,const char *key,const char *value,const char *data)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_SZ,(const BYTE*)data,lstrlen(data)+1) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


BOOL WriteRegStr64(HKEY root,const char *key,const char *value,const char *data)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE|GetWow64RegFlag64(),NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_SZ,(const BYTE*)data,lstrlen(data)+1) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


BOOL WriteRegMultiStr(HKEY root,const char *key,const char *value,const char *data,int len)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_MULTI_SZ,(const BYTE*)data,len) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


BOOL WriteRegMultiStr64(HKEY root,const char *key,const char *value,const char *data,int len)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE|GetWow64RegFlag64(),NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_MULTI_SZ,(const BYTE*)data,len) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


BOOL WriteRegStrP(HKEY h,const char *value,const char *data)
{
  BOOL rc = FALSE;

  if ( RegSetValueEx(h,value,0,REG_SZ,(const BYTE*)data,lstrlen(data)+1) == ERROR_SUCCESS )
     rc = TRUE;

  return rc;
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


BOOL WriteRegDword64(HKEY root,const char *key,const char *value,DWORD data)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE|GetWow64RegFlag64(),NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_DWORD,(const BYTE *)&data,4) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


BOOL WriteRegDwordP(HKEY h,const char *value,DWORD data)
{
  BOOL rc = FALSE;

  if ( RegSetValueEx(h,value,0,REG_DWORD,(const BYTE *)&data,4) == ERROR_SUCCESS )
     rc = TRUE;

  return rc;
}


void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def)
{
  HKEY h;
  DWORD len = MAX_PATH-1;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
          data[len] = 0;
       RegCloseKey(h);
     }
}


void ReadRegStr64(HKEY root,const char *key,const char *value,char *data,const char *def)
{
  HKEY h;
  DWORD len = MAX_PATH-1;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ|GetWow64RegFlag64(),&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
          data[len] = 0;
       RegCloseKey(h);
     }
}


DWORD ReadRegDword(HKEY root,const char *key,const char *value,int def)
{
  HKEY h;
  DWORD data = def;
  DWORD len = 4;

  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)&data,&len);
       RegCloseKey(h);
     }

  return data;
}


DWORD ReadRegDword64(HKEY root,const char *key,const char *value,int def)
{
  HKEY h;
  DWORD data = def;
  DWORD len = 4;

  if ( RegOpenKeyEx(root,key,0,KEY_READ|GetWow64RegFlag64(),&h) == ERROR_SUCCESS )
     {
       RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)&data,&len);
       RegCloseKey(h);
     }

  return data;
}


void ReadRegBin(HKEY root,const char *key,const char *value,char *data,int max,int *out_len)
{
  HKEY h;
  DWORD len = max;

  *out_len = 0;
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
          *out_len = len;
       RegCloseKey(h);
     }
}


BOOL WriteRegBin(HKEY root,const char *key,const char *value,const char *data,int len)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_BINARY,(const BYTE *)data,len) == ERROR_SUCCESS )
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


BOOL DeleteRegValue64(HKEY root,const char *key,const char *value)
{
  BOOL rc = FALSE;

  HKEY h = NULL;
  DWORD err = RegOpenKeyEx(root,key,0,KEY_WRITE|GetWow64RegFlag64(),&h);

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


BOOL DeleteRegKey(HKEY root,const char *key)
{
  DWORD rc = SHDeleteKey(root,key);
  return (rc == ERROR_SUCCESS || rc == ERROR_FILE_NOT_FOUND);
}


BOOL DeleteRegKeyNoRec(HKEY root,const char *key)
{
  DWORD rc = RegDeleteKey(root,key);
  return (rc == ERROR_SUCCESS || rc == ERROR_FILE_NOT_FOUND);
}


BOOL DeleteRegKeyNoRec64(HKEY root,const char *key)
{
  LONG (WINAPI *pRegDeleteKeyExA)(HKEY hKey,LPCSTR lpSubKey,REGSAM samDesired,DWORD Reserved);
  *(void**)&pRegDeleteKeyExA = (void*)GetProcAddress(GetModuleHandle("advapi32.dll"),"RegDeleteKeyExA");
  if ( pRegDeleteKeyExA && GetWow64RegFlag64() != 0 )
     {
       DWORD rc = pRegDeleteKeyExA(root,key,GetWow64RegFlag64(),0);
       return (rc == ERROR_SUCCESS || rc == ERROR_FILE_NOT_FOUND);
     }
  else
     {
       return DeleteRegKeyNoRec(root,key);
     }
}


unsigned CalculateHashBobJankins( const unsigned char *k, unsigned length, unsigned initval )
{
  unsigned a,b,c,len;

  len = length;
  a = b = 0x9e3779b9;
  c = initval;

  while( len >= 12 )
  {
    a += (k[0] + ((unsigned)k[1]<<8) + ((unsigned)k[2]<<16)  + ((unsigned)k[3]<<24));
    b += (k[4] + ((unsigned)k[5]<<8) + ((unsigned)k[6]<<16)  + ((unsigned)k[7]<<24));
    c += (k[8] + ((unsigned)k[9]<<8) + ((unsigned)k[10]<<16) + ((unsigned)k[11]<<24));

    a -= b; a -= c; a ^= (c>>13);
    b -= c; b -= a; b ^= (a<<8);
    c -= a; c -= b; c ^= (b>>13);
    a -= b; a -= c; a ^= (c>>12);
    b -= c; b -= a; b ^= (a<<16);
    c -= a; c -= b; c ^= (b>>5);
    a -= b; a -= c; a ^= (c>>3);
    b -= c; b -= a; b ^= (a<<10);
    c -= a; c -= b; c ^= (b>>15);

    k += 12;
    len -= 12;
  }

  c += length;

  switch( len )
  {
    case 11: c += ((unsigned)k[10]<<24);
    case 10: c += ((unsigned)k[9]<<16);
    case 9 : c += ((unsigned)k[8]<<8);
    case 8 : b += ((unsigned)k[7]<<24);
    case 7 : b += ((unsigned)k[6]<<16);
    case 6 : b += ((unsigned)k[5]<<8);
    case 5 : b += k[4];
    case 4 : a += ((unsigned)k[3]<<24);
    case 3 : a += ((unsigned)k[2]<<16);
    case 2 : a += ((unsigned)k[1]<<8);
    case 1 : a += k[0];
  }

  a -= b; a -= c; a ^= (c>>13);
  b -= c; b -= a; b ^= (a<<8);
  c -= a; c -= b; c ^= (b>>13);
  a -= b; a -= c; a ^= (c>>12);
  b -= c; b -= a; b ^= (a<<16);
  c -= a; c -= b; c ^= (b>>5);
  a -= b; a -= c; a ^= (c>>3);
  b -= c; b -= a; b ^= (a<<10);
  c -= a; c -= b; c ^= (b>>15);

  return c;
}


// do not pass 255.255.255.255 here!
int GetFirstHostAddrByName(const char *name)
{
  int ip = inet_addr(name);

  if ( ip == 0 || ip == -1 )
     {
       struct hostent *h = gethostbyname(name);
       if ( h )
          {
            int *pip = (int*)h->h_addr_list[0];
            if ( pip )
               ip = *pip;
          }
     }

  return ip;
}


BOOL IsMyIP(int ip)
{
  if ( ip == 0x0100007F )
     return TRUE;

  char host[MAX_PATH];
  struct hostent *h;
  int n,*pip;
  
  host[0] = 0;
  gethostname(host,sizeof(host));
  h = gethostbyname(host);
  if ( !h )
     return FALSE;

  n = 0;
  while ( (pip = (int*)h->h_addr_list[n]) )
  {
    if ( *pip == ip )
       return TRUE;
    n++;
  }

  return FALSE;
}


BOOL IsMyIP(const char *s_ip)
{
  int ip = (s_ip ? inet_addr(s_ip) : 0);
  if ( ip == 0 || ip == -1 )
     return FALSE;

  return IsMyIP(ip);
}


char* GetDomainName(char *s)
{
  s[0] = 0;

  HINSTANCE lib = LoadLibrary("secur32.dll");
  if ( lib )
     {
       typedef BOOLEAN (WINAPI *TGetUserNameEx)(int,LPSTR,PULONG);
       TGetUserNameEx pGetUserNameEx = (TGetUserNameEx)GetProcAddress(lib,"GetUserNameExA");
       if ( pGetUserNameEx )
          {
            DWORD len = MAX_PATH;

            if ( pGetUserNameEx(2,s,&len) )
               {
                 for ( int i = 0; i < lstrlen(s); i++ )
                     if ( s[i] == '\\' )
                        {
                          s[i] = 0;
                          break;
                        }
               }
          }

       FreeLibrary(lib);
     }

  if ( !s[0] )
     {
       DWORD len = MAX_PATH;
       GetComputerName(s,&len);
     }

  return s;
}


char* MyGetUserName(char *out)
{
  char s[MAX_PATH];
  DWORD len = sizeof(s);

  s[0] = 0;
  GetUserName(s,&len);

  if ( !s[0] )
     lstrcpy(s,"default_user");

  lstrcpy(out,s);
  return out;
}


char* MyGetComputerName(char *out)
{
  char s[MAX_PATH];
  DWORD len = sizeof(s);

  s[0] = 0;
  GetComputerName(s,&len);

  if ( !s[0] )
     lstrcpy(s,"default");

  lstrcpy(out,s);
  return out;
}


BOOL IsCurrentUserIsInDomain()
{
  char s1[MAX_PATH] = "";
  char s2[MAX_PATH] = "";

  MyGetComputerName(s1);
  GetDomainName(s2);

  return !IsStrEmpty(s1) && !IsStrEmpty(s2) && lstrcmpi(s1,s2);
}


int GetMyIPAsInt(void)
{
  char s_computername[MAX_PATH] = "";
  char host[MAX_PATH] = "";

  MyGetComputerName(s_computername);

  gethostname(host,sizeof(host));
  if ( !host[0] )
     lstrcpy(host,s_computername);

  return GetFirstHostAddrByName(host);
}


char* GetMyIPAsString(char *s)
{
  unsigned char ip[4];

  *(int*)ip = GetMyIPAsInt();

  wsprintf(s,"%d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
  return s;
}


static BOOL IsUserAnAdminMy()
{
  //todo: get sources from MSDN or W2KSRC
  BOOL rc = FALSE;

  if ( WriteRegDword64(HKEY_LOCAL_MACHINE,"Software","rs_test_val_2347654765",0) )
     {
       DeleteRegValue64(HKEY_LOCAL_MACHINE,"Software","rs_test_val_2347654765");
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


const char* GetSysDrivePathWithBackslash(void)
{
  static char s[MAX_PATH];
  char drive;

  s[0] = 0;
  GetEnvironmentVariable("SystemDrive",s,sizeof(s));
  if ( !s[0] )
     GetWindowsDirectory(s,sizeof(s));
  CharUpper(s);

  if ( lstrlen(s) >= 2 && s[1] == ':' )
     drive = s[0];
  else
     drive = 'C';

  if ( drive < 'C' || drive > 'Z' )
     drive = 'C';

  s[0] = drive;
  s[1] = ':';
  s[2] = '\\';
  s[3] = 0;

  return s;
}


void SetProcessPrivilege(const char *name)
{   
  HANDLE token;
  
  if ( OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,&token) )
     {
       TOKEN_PRIVILEGES tkp; 
       LookupPrivilegeValue(NULL,name,&tkp.Privileges[0].Luid); 
       tkp.PrivilegeCount = 1;
       tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED; 
       AdjustTokenPrivileges(token,FALSE,&tkp,0,(PTOKEN_PRIVILEGES)NULL,0);
       CloseHandle(token);
     }
}


CUnicode::CUnicode(const char *s,int locale)
{
  if ( s )
     {
       s_out = (WCHAR*)sys_alloc((lstrlen(s)+1)*sizeof(WCHAR));
       s_out[0] = 0;

       MultiByteToWideChar(locale,0,s,-1,s_out,lstrlen(s)+1);
     }
  else
     {
       s_out = NULL;
     }
}


CUnicode::~CUnicode()
{
  if ( s_out )
     {
       sys_free(s_out);
     }
}


CANSI::CANSI(const WCHAR *s,int codepage)
{
  if ( s )
     {
       s_out = (char*)sys_alloc((lstrlenW(s)+1)*sizeof(char));
       s_out[0] = 0;

       WideCharToMultiByte(codepage,0,s,-1,s_out,lstrlenW(s)+1,NULL,NULL);
     }
  else
     {
       s_out = NULL;
     }
}


CANSI::~CANSI()
{
  if ( s_out )
     {
       sys_free(s_out);
     }
}


const GUID& GetEmptyGUID()
{
  static const GUID empty = { 0, 0, 0, { 0, 0, 0, 0, 0, 0, 0, 0 } };
  return empty;
}


BOOL IsGUIDEmpty(const GUID& guid)
{
  return IsEqualGUID(guid,GetEmptyGUID());
}


BOOL IsWOW64()
{
  BOOL rc = FALSE;

  BOOL (WINAPI *pIsWow64Process)(HANDLE hProcess,PBOOL Wow64Process);
  *(void**)&pIsWow64Process = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"IsWow64Process");

  if ( pIsWow64Process )
     {
       BOOL is_wow = FALSE;

       if ( pIsWow64Process(GetCurrentProcess(),&is_wow) )
          {
            rc = is_wow;
          }
     }

  return rc;
}


int GetWow64RegFlag64()
{
  return IsWOW64() ? KEY_WOW64_64KEY : 0;
}


PSECURITY_DESCRIPTOR AllocateSDWithNoDACL()
{
  PSECURITY_DESCRIPTOR sd = (PSECURITY_DESCRIPTOR)LocalAlloc(LPTR,SECURITY_DESCRIPTOR_MIN_LENGTH);

  InitializeSecurityDescriptor(sd,SECURITY_DESCRIPTOR_REVISION);
  SetSecurityDescriptorDacl(sd,TRUE,NULL,FALSE);

  return sd;
}


void FreeSD(PSECURITY_DESCRIPTOR sd)
{
  LocalFree((HLOCAL)sd);
}
