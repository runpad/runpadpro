
#include "include.h"


CLog g_log("log.txt");



CLog::CLog(const char *_filename,const char *_appname,unsigned _max_size)
{
  InitializeCriticalSection(&o_cs);

  m_filepath = NULL;
  m_handle = NULL;
  m_err = FALSE;
  max_size = _max_size;

  char s[MAX_PATH] = "";
  GetSpecialFolder(CSIDL_COMMON_APPDATA,s);
  if ( s[0] )
     {
       PathAppend(s,"NodaSoft\\RunpadPro");
       PathAppend(s,_appname);
       PathAppend(s,!IsStrEmpty(_filename)?_filename:"log");
       m_filepath = sys_copystring(s);
     }
}


CLog::~CLog()
{
  if ( m_handle )
     sys_fclose(m_handle);
  m_handle = NULL;

  if ( m_filepath )
     sys_free(m_filepath);
  m_filepath = NULL;

  DeleteCriticalSection(&o_cs);
}


void CLog::Add(const char *format,...)
{
  CCSGuard oGuard(o_cs);

  if ( !m_err )
     {
       if ( !m_handle )
          {
            if ( !IsStrEmpty(m_filepath) )
               {
                 m_handle = sys_fopena(m_filepath);

                 if ( !m_handle )
                    {
                      char s[MAX_PATH];
                      lstrcpy(s,m_filepath);

                      PathRemoveFileSpec(s);
                      SHCreateDirectoryEx(NULL,s,NULL);

                      m_handle = sys_fcreate(m_filepath);
                    }
               }
          }

       if ( !m_handle )
          {
            m_err = TRUE;
          }

       if ( m_handle )
          {
            if ( sys_fsize(m_handle) > max_size )
               {
                 sys_fclose(m_handle);
                 m_handle = sys_fcreate(m_filepath);
               }
          }

       if ( m_handle )
          {
            char buffer[1024];
            va_list args;
            va_start(args,format);
            vsprintf(buffer,format,args);
            va_end(args);

            SYSTEMTIME st;
            GetLocalTime(&st);
            char t[100];
            wsprintf(t,"%02d.%02d.%04d %02d:%02d:%02d - ",st.wDay,st.wMonth,st.wYear,st.wHour,st.wMinute,st.wSecond);

            sys_fwrite_txt(m_handle,t);
            sys_fwrite_txt(m_handle,buffer);
            sys_fwrite_txt(m_handle,"\n");
          }
     }
}





