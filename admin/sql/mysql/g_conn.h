
#ifndef __G_CONN_H__
#define __G_CONN_H__

#include "api/include/mysql.h"
#include "../h_sql_inc.h"



class CServerConn
{
          MYSQL *p_conn;
          char m_lasterror[1024];

          typedef struct {
           MYSQL_RES *res;
           MYSQL_ROW row;
          } TROWINFO;

  public:
          CServerConn(const char *s_server,const char *s_user,const char *s_password,const char *s_db,int s_port=0);
          ~CServerConn();

          const char *GetLastError() const;
          int GetServerVersion();
          BOOL IsConnected() const;

          BOOL ExecSQL(const char *s_query,int timeout=SQL_DEF_TIMEOUT,int *_result=NULL,TEXECSQLCBPROC cb=NULL,void *cb_parm=NULL,BOOL call_cb_at_begin=FALSE);
          BOOL CallStoredProc(const char *s_proc,int timeout=SQL_DEF_TIMEOUT,TSTOREDPROCPARAM *argv=NULL,int argc=0);

          void EscapeString(const char *from,char *to);


          void Disconnect();  //for internal use only
          void SetLastError(const char *s); //for internal use only

  private:
          void ProcessResultInternal(MYSQL_RES *res,int *_result,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin);
          unsigned ProcessStoredProcParams(const TSTOREDPROCPARAM *argv,int argc,char *buff);

          static int __cdecl D_GetNumFields(void *obj);
          static void* __cdecl D_GetFieldByName(void *obj,const char *name);
          static void* __cdecl D_GetFieldByIdx(void *obj,int idx);
          static void __cdecl D_GetFieldDisplayName(void *obj,void *field,char *_out);
          static int __cdecl D_GetFieldDataType(void *obj,void *field);
          static int __cdecl D_GetFieldValueAsInt(void *obj,void *field);
          static double __cdecl D_GetFieldValueAsDouble(void *obj,void *field);
          static double __cdecl D_GetFieldValueAsDateTime(void *obj,void *field);
          static char* __cdecl D_GetFieldValueAsString(void *obj,void *field);
          static void* __cdecl D_GetFieldValueAsBlob(void *obj,void *field,int *_size);
          static void __cdecl D_FreePointer(void *p);

          static const void* GetFieldRawData(void *obj,void *field,int *_size);
          static double ConvertDateTimeStringToDouble(const char *datetime);
          static char* ConvertDoubleToDateTimeString(double d,char *datetime);

};



#endif
