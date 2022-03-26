
#ifndef __LOG_H__
#define __LOG_H__



class CLog
{
          CRITICAL_SECTION o_cs;
          
          char *m_filepath;
          void *m_handle;
          BOOL m_err;

          unsigned max_size;

  public:
          CLog(const char *_filename,const char *_appname="Server",unsigned _max_size=500000);
          ~CLog();

          void Add(const char *format,...);

};


extern CLog g_log;

#define ADD2LOG(arglist)   { g_log.Add arglist; }



#endif

