
#include "include.h"


////////////////////////////////////////////////
// common CFG code for both shell and service
////////////////////////////////////////////////


static const char* s_settings_file = "s";
static const char* s_licfeat_file = "lf";


char* GetGlobalCommonPath(const char *local,char *out)
{
  out[0] = 0;
  GetSpecialFolder(CSIDL_COMMON_APPDATA,out);

  if ( out[0] )
     {
       PathAppend(out,"NodaSoft\\RunpadPro\\Shell");
       PathAppend(out,local);
     }
  else
     {
       GetModuleFileName(GetModuleHandle(NULL),out,MAX_PATH);
       PathRemoveFileSpec(out);
       PathAppend(out,local);
     }
  
  return out;
}


char* GetErrLogFileName(char *s)
{
  GetGlobalCommonPath("ErrLogs\\",s);
  SHCreateDirectoryEx(NULL,s,NULL);

  SYSTEMTIME st;
  GetLocalTime(&st);
  char file[MAX_PATH];
  wsprintf(file,"err_log_%04d_%02d_%02d_%02d_%02d_%02d.txt",st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond);
  PathAppend(s,file);

  return s;
}


char* GetConfigCacheDir4AllUsers(char *s)
{
  GetGlobalCommonPath("Cache",s);
  PathAddBackslash(s);
  return s;
}


char* GetConfigCacheDir4CurrentUser(char *s)
{
  s[0] = 0;
  GetConfigCacheDir4AllUsers(s);

  if ( s[0] )
     {
       char sid[MAX_PATH] = "";
       GetCurrentUserSid(sid);
       if ( sid[0] )
          {
            PathAppend(s,sid);
            PathAddBackslash(s);
          }
       else
          {
            s[0] = 0;
          }
     }

  return s;
}


void WriteSidEncryptedFileWithCRC(const char *filename,const void *buff,unsigned size)
{
  if ( filename && filename[0] )
     {
       void *h = sys_fcreate(filename);
       if ( h )
          {
            char sid[MAX_PATH] = "";
            GetCurrentUserSid(sid);
            unsigned sid_hash = CalculateHashBobJankins((const unsigned char*)sid,lstrlen(sid),0);
            SetRandSeed(sid_hash);
            unsigned crc = CalculateHashBobJankins((const unsigned char*)buff,size,0);
            
            unsigned count = size;
            const unsigned char *p = (const unsigned char*)buff;
            while ( count > 0 )
            {
              unsigned char x = RandomSeed() & 0xFF;
              unsigned char b = x ^ (*p++);

              sys_fwrite(h,&b,sizeof(b));
              count--;
            };

            sys_fwrite(h,&crc,sizeof(crc));
            sys_fclose(h);
          }
     }
}


void* ReadSidEncryptedFileWithCRC(const char *filename,unsigned *_size)
{
  if ( _size )
     *_size = 0;
  
  int size = 0;

  void *buff = ReadFullFile(filename,&size);
  if ( buff )
     {
       if ( size < 4 )
          {
            sys_free(buff);
            return NULL;
          }

       char sid[MAX_PATH] = "";
       GetCurrentUserSid(sid);
       unsigned sid_hash = CalculateHashBobJankins((const unsigned char*)sid,lstrlen(sid),0);
       SetRandSeed(sid_hash);

       unsigned count = size-4;
       unsigned char *p = (unsigned char*)buff;
       while ( count > 0 )
       {
         unsigned char x = RandomSeed() & 0xFF;
         unsigned char b = x ^ (*p);
         *p++ = b;
         count--;
       };

       unsigned crc = *(unsigned*)p;
       if ( crc != CalculateHashBobJankins((const unsigned char*)buff,size-4,0) )
          {
            sys_free(buff);
            return NULL;
          }

       if ( size == 4 )
          {
            sys_free(buff);
            return NULL;
          }
       
       if ( _size )
          *_size = size-4;
     }

  return buff;
}


void WriteLicFeatToCache(const char *s)
{
  if ( !s )
     s = "";

  char file[MAX_PATH] = "";
  GetConfigCacheDir4CurrentUser(file);

  if ( file[0] )
     {
       SHCreateDirectoryEx(NULL,file,NULL);
       PathAppend(file,s_licfeat_file);
       WriteSidEncryptedFileWithCRC(file,s,lstrlen(s));
     }
}


BOOL ReadLicFeatFromCache(char *_lic_feat,int max)
{
  BOOL rc = FALSE;

  char file[MAX_PATH] = "";
  GetConfigCacheDir4CurrentUser(file);

  if ( file[0] )
     {
       PathAppend(file,s_licfeat_file);
       unsigned size = 0;
       void *buff = ReadSidEncryptedFileWithCRC(file,&size);
       if ( buff )
          {
            char *s = (char*)sys_zalloc(size+1); //zero clears
            CopyMemory(s,buff,size);

            lstrcpyn(_lic_feat,s,max);
            rc = TRUE;

            sys_free(s);
            sys_free(buff);
          }
     }

  return rc;
}


void WriteSettingsToCache(const void *buff,unsigned size)
{
  char file[MAX_PATH] = "";
  GetConfigCacheDir4CurrentUser(file);

  if ( file[0] )
     {
       SHCreateDirectoryEx(NULL,file,NULL);
       PathAppend(file,s_settings_file);
       WriteSidEncryptedFileWithCRC(file,buff,size);
     }
}


BOOL ReadSettingsFromCache(int _curr_lang,int _machine_type)
{
  BOOL rc = FALSE;

  char file[MAX_PATH] = "";
  GetConfigCacheDir4CurrentUser(file);

  if ( file[0] )
     {
       PathAppend(file,s_settings_file);
       unsigned size = 0;
       void *buff = ReadSidEncryptedFileWithCRC(file,&size);
       if ( buff )
          {
            CfgReadConfig(buff,size,_curr_lang,_machine_type);
            rc = TRUE;

            sys_free(buff);
          }
     }

  return rc;
}



