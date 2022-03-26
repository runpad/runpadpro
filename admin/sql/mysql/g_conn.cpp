
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "api/include/mysql.h"
#include "api/include/errmsg.h"
#include "g_conn.h"
#include "../h_sql_inc.h"




CServerConn::CServerConn(const char *s_server,const char *s_user,const char *s_password,const char *s_db,int s_port)
{
  SetLastError("");
  
  p_conn = NULL;

  if ( s_server && s_server[0] && s_user && s_user[0] )
     {
       p_conn = mysql_init(NULL);

       if ( p_conn )
          {
            int timeout = 10;
            mysql_options(p_conn,MYSQL_OPT_CONNECT_TIMEOUT,(const char*)&timeout);
            my_bool b_reconnect = FALSE;
            mysql_options(p_conn,MYSQL_OPT_RECONNECT,(const char*)&b_reconnect); //this option is new in 5.0.13 

            if ( s_password && !s_password[0] )
               s_password = NULL;
            
            if ( s_db && !s_db[0] )
               s_db = NULL;
            
            if ( !mysql_real_connect(p_conn,s_server,s_user,s_password,s_db,s_port,NULL,CLIENT_MULTI_STATEMENTS) )
               {
                 SetLastError(mysql_error(p_conn));
                 mysql_close(p_conn);
                 p_conn = NULL;
               }
          }
       else
          {
            SetLastError("Memory allocation error");
          }
     }
}


CServerConn::~CServerConn()
{
  if ( p_conn )
     {
       mysql_close(p_conn);
       p_conn = NULL;
     }
}


void CServerConn::Disconnect()
{
  SetLastError("");

  if ( p_conn )
     {
       mysql_close(p_conn);
       p_conn = NULL;
     }
}


const char* CServerConn::GetLastError() const
{
  return m_lasterror;
}


void CServerConn::SetLastError(const char *s)
{
  strncpy(m_lasterror,s?s:"",sizeof(m_lasterror)-1);
}


int CServerConn::GetServerVersion()
{
  SetLastError("");
  return p_conn ? mysql_get_server_version(p_conn) : 0;
}


BOOL CServerConn::IsConnected() const
{
  return p_conn != NULL;  //must be fast
}


void CServerConn::EscapeString(const char *from,char *to)
{
  SetLastError("");

  to[0] = 0;

  if ( from && from[0] )
     {
       if ( p_conn )
          {
            mysql_real_escape_string(p_conn,to,from,strlen(from));
          }
       else
          {
            mysql_escape_string(to,from,strlen(from));
          }
     }
}


BOOL CServerConn::ExecSQL(const char *s_query,int timeout,int *_result,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin)
{
  BOOL rc = FALSE;

  SetLastError("");

  if ( _result )
     *_result = 0;

  if ( !p_conn )
     {
       SetLastError("Not connected to server");
       return rc;
     }

  if ( !s_query || !s_query[0] )
     {
       SetLastError("Empty query");
       return rc;
     }

  if ( !mysql_query(p_conn,s_query) )
     {
       BOOL got_res = FALSE;
       
       rc = TRUE;
       
       do {

         MYSQL_RES *res = mysql_store_result(p_conn);
         if ( res )
            {
              if ( !got_res )
                 {
                   ProcessResultInternal(res,_result,cb,cb_parm,call_cb_at_begin);
                   got_res = TRUE;
                 }

              mysql_free_result(res);
            }
         else
            {
              if ( mysql_errno(p_conn) )
                 {
                   rc = got_res;
                   break;
                 }
            }

         // fetch other results, 
         // because we don't want to get "out of sync error"
         int ec = mysql_next_result(p_conn);
         if ( ec == -1 )
            break;  //success and no more results
         else
         if ( ec > 0 )
            {         //error
              rc = got_res;
              break;
            }

       } while ( 1 );
     }

  if ( !rc )
     {
       SetLastError(mysql_error(p_conn));

       int err = mysql_errno(p_conn);
       if ( err == CR_SERVER_GONE_ERROR || err == CR_SERVER_LOST )
          {
            mysql_close(p_conn);
            p_conn = NULL;
          }
     }

  return rc;
}


void CServerConn::ProcessResultInternal(MYSQL_RES *res,int *_result,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin)
{
  if ( _result || cb )
     {
       if ( _result )
          *_result = (int)mysql_num_rows(res);

       if ( cb )
          {
            TEXECSQLCBSTRUCT i;
            TROWINFO r;

            r.res = res;
            r.row = NULL;

            i.user_parm = cb_parm;
            i.obj = &r;
            i.numrecords = (int)mysql_num_rows(res);
            i.GetNumFields            = D_GetNumFields;
            i.GetFieldByName          = D_GetFieldByName;
            i.GetFieldByIdx           = D_GetFieldByIdx;
            i.GetFieldDisplayName     = D_GetFieldDisplayName;
            i.GetFieldDataType        = D_GetFieldDataType;
            i.GetFieldValueAsInt      = D_GetFieldValueAsInt;
            i.GetFieldValueAsDouble   = D_GetFieldValueAsDouble;
            i.GetFieldValueAsDateTime = D_GetFieldValueAsDateTime;
            i.GetFieldValueAsString   = D_GetFieldValueAsString;
            i.GetFieldValueAsBlob     = D_GetFieldValueAsBlob;
            i.FreePointer             = D_FreePointer;

            BOOL b_continue = TRUE;

            if ( call_cb_at_begin )
               {
                 i.idx = -1;
                 b_continue = cb(&i);
               }

            if ( b_continue )
               {
                 MYSQL_ROW row;

                 i.idx = 0;

                 while ( (row = mysql_fetch_row(res)) )
                 {
                   r.row = row;

                   if ( !cb(&i) )
                      break;

                   i.idx++;
                 }
               }
          }
     }
}


int __cdecl CServerConn::D_GetNumFields(void *obj)
{
  TROWINFO *i = (TROWINFO*)obj;
  return i ? mysql_num_fields(i->res) : 0;
}


void* __cdecl CServerConn::D_GetFieldByName(void *obj,const char *name)
{
  void *rc = NULL;
  TROWINFO *i = (TROWINFO*)obj;

  if ( i )
     {
       int count = mysql_num_fields(i->res);
       for ( int n = 0; n < count; n++ )
           {
             MYSQL_FIELD *f = mysql_fetch_field_direct(i->res,n);
             if ( f )
                {
                  if ( !strcmpi(f->org_name,name) )
                     {
                       rc = f;
                       break;
                     }
                }
           }
     }

  return rc;
}


void* __cdecl CServerConn::D_GetFieldByIdx(void *obj,int idx)
{
  void *rc = NULL;

  TROWINFO *i = (TROWINFO*)obj;
  if ( i )
     {
       int count = mysql_num_fields(i->res);

       if ( idx >= 0 && idx < count )
          {
            rc = mysql_fetch_field_direct(i->res,idx);
          }
     }

  return rc;
}


void __cdecl CServerConn::D_GetFieldDisplayName(void *obj,void *field,char *_out)
{
  _out[0] = 0;

  MYSQL_FIELD *f = (MYSQL_FIELD*)field;
  if ( f )
     {
       strncpy(_out,f->name,MAX_PATH-1);
     }
}


int __cdecl CServerConn::D_GetFieldDataType(void *obj,void *field)
{
  int rc = SQL_DT_UNKNOWN;

  MYSQL_FIELD *f = (MYSQL_FIELD*)field;
  if ( f )
     {
       switch ( f->type )
       {
         case MYSQL_TYPE_LONG:         
         case MYSQL_TYPE_LONGLONG:         //todo: better to add new type
         case MYSQL_TYPE_TINY:
         case MYSQL_TYPE_SHORT:
         case MYSQL_TYPE_INT24:
         case MYSQL_TYPE_DECIMAL:
         case MYSQL_TYPE_NEWDECIMAL:
                                rc = SQL_DT_INTEGER;
                                break;

         case MYSQL_TYPE_FLOAT:
         case MYSQL_TYPE_DOUBLE:
                                rc = SQL_DT_REAL;
                                break;

         case MYSQL_TYPE_DATETIME:
                                rc = SQL_DT_DATETIME;
                                break;

         case MYSQL_TYPE_STRING:
         case MYSQL_TYPE_VAR_STRING:
         case MYSQL_TYPE_VARCHAR:
                                rc = SQL_DT_STRING;
                                break;

         case MYSQL_TYPE_BLOB:
         case MYSQL_TYPE_TINY_BLOB:
         case MYSQL_TYPE_MEDIUM_BLOB:
         case MYSQL_TYPE_LONG_BLOB:
                                rc = SQL_DT_BLOB;
                                break;
       };
     }

  return rc;
}


int __cdecl CServerConn::D_GetFieldValueAsInt(void *obj,void *field)
{
  int rc = 0;

  int size = 0;
  const void *buff = GetFieldRawData(obj,field,&size);
  
  if ( buff && size )
     {
       switch ( D_GetFieldDataType(obj,field) )
       {
         case SQL_DT_INTEGER:
         case SQL_DT_STRING:
                               sscanf((const char*)buff,"%d",&rc);
                               break;

         case SQL_DT_REAL:
                               {
                                 float f = 0.0;
                                 sscanf((const char*)buff,"%f",&f);
                                 rc = (int)f;
                               }
                               break;
       };
     }

  return rc;
}


double __cdecl CServerConn::D_GetFieldValueAsDouble(void *obj,void *field)
{
  double rc = 0.0;

  int size = 0;
  const void *buff = GetFieldRawData(obj,field,&size);
  
  if ( buff && size )
     {
       switch ( D_GetFieldDataType(obj,field) )
       {
         case SQL_DT_INTEGER:
         case SQL_DT_STRING:
         case SQL_DT_REAL:
                               {
                                 double f = 0.0;
                                 sscanf((const char*)buff,"%lf",&f);
                                 rc = f;
                               }
                               break;
       };
     }

  return rc;
}


double __cdecl CServerConn::D_GetFieldValueAsDateTime(void *obj,void *field)
{
  double rc = 0.0;

  int size = 0;
  const void *buff = GetFieldRawData(obj,field,&size);
  
  if ( buff && size )
     {
       switch ( D_GetFieldDataType(obj,field) )
       {
         case SQL_DT_DATETIME:
         case SQL_DT_STRING:
                               rc = ConvertDateTimeStringToDouble((const char*)buff);
                               break;
       };
     }

  return rc;
}


char* __cdecl CServerConn::D_GetFieldValueAsString(void *obj,void *field)
{
  char *rc = NULL;

  int size = 0;
  const void *buff = GetFieldRawData(obj,field,&size);
  
  if ( buff && size )
     {
       switch ( D_GetFieldDataType(obj,field) )
       {
         case SQL_DT_STRING:
         case SQL_DT_INTEGER:
         case SQL_DT_REAL:
         case SQL_DT_DATETIME:
         case SQL_DT_BLOB:
                               rc = (char*)calloc(size+1,1);
                               if ( rc )
                                  {
                                    memcpy(rc,buff,size);
                                  }
                               break;

       };
     }

  return rc ? rc : (char*)calloc(1,1);
}


void* __cdecl CServerConn::D_GetFieldValueAsBlob(void *obj,void *field,int *_size)
{
  void *rc = NULL;

  if ( _size )
     *_size = 0;

  int size = 0;
  const void *buff = GetFieldRawData(obj,field,&size);
  
  if ( buff && size )
     {
       switch ( D_GetFieldDataType(obj,field) )
       {
         case SQL_DT_BLOB:
                               rc = malloc(size);
                               if ( rc )
                                  {
                                    memcpy(rc,buff,size);
                                    if ( _size )
                                       *_size = size;
                                  }
                               break;

       };
     }

  return rc;
}


void __cdecl CServerConn::D_FreePointer(void *p)
{
  if ( p )
     {
       free(p);
     }
}


const void* CServerConn::GetFieldRawData(void *obj,void *field,int *_size)
{
  void *rc = NULL;

  if ( _size )
     *_size = 0;

  if ( obj && field )
     {
       TROWINFO *i = (TROWINFO*)obj;
       MYSQL_FIELD *f = (MYSQL_FIELD*)field;

       if ( i->res && i->row )
          {
            int count = mysql_num_fields(i->res);
            for ( int n = 0; n < count; n++ )
                {
                  if ( mysql_fetch_field_direct(i->res,n) == f )
                     {
                       unsigned long *lens = mysql_fetch_lengths(i->res);
                       if ( lens )
                          {
                            if ( _size )
                               *_size = lens[n];

                            rc = i->row[n];
                          }

                       break;
                     }
                }
          }
     }

  return rc;
}


double CServerConn::ConvertDateTimeStringToDouble(const char *datetime)
{
  double rc = 0.0;

  if ( datetime && strlen(datetime) >= 19 )
     {
       char s[100];

       strncpy(s,datetime,sizeof(s)-1);

       for ( int n = 0; n < strlen(s); n++ )
           {
             unsigned char c = ((unsigned char*)s)[n];
             if ( c < '0' || c > '9' )
                {
                  s[n] = ' ';
                }
           }

       int i_year = 0;
       int i_month = 0;
       int i_day = 0;
       int i_hour = 0;
       int i_min = 0;
       int i_sec = 0;
       
       sscanf(s,"%d %d %d %d %d %d",&i_year,&i_month,&i_day,&i_hour,&i_min,&i_sec);

       const int n_year = 1899;
       const int n_month = 12;
       const int n_day = 30;
       const int n_hour = 0;
       const int n_min = 0;
       const int n_sec = 0;

       const SYSTEMTIME i_st = {i_year,i_month,0,i_day,i_hour,i_min,i_sec,0};
       const SYSTEMTIME n_st = {n_year,n_month,0,n_day,n_hour,n_min,n_sec,0};

       __int64 i_ft = 0, n_ft = 0;
       
       SystemTimeToFileTime(&i_st,(FILETIME*)&i_ft);
       SystemTimeToFileTime(&n_st,(FILETIME*)&n_ft);

       __int64 delta = i_ft - n_ft;

       rc = (double)delta/864000000000.0;
     }

  return rc;
}


char* CServerConn::ConvertDoubleToDateTimeString(double d,char *datetime)
{
  __int64 delta = (__int64)(d*864000000000.0);

  const int n_year = 1899;
  const int n_month = 12;
  const int n_day = 30;
  const int n_hour = 0;
  const int n_min = 0;
  const int n_sec = 0;

  const SYSTEMTIME n_st = {n_year,n_month,0,n_day,n_hour,n_min,n_sec,0};

  __int64 n_ft = 0;
  
  SystemTimeToFileTime(&n_st,(FILETIME*)&n_ft);

  __int64 i_ft = n_ft + delta;

  SYSTEMTIME i_st;
  FileTimeToSystemTime((const FILETIME*)&i_ft,&i_st);

  sprintf(datetime,"%04d-%02d-%02d %02d:%02d:%02d",i_st.wYear,i_st.wMonth,i_st.wDay,i_st.wHour,i_st.wMinute,i_st.wSecond);

  return datetime;
}


BOOL CServerConn::CallStoredProc(const char *s_proc,int timeout,TSTOREDPROCPARAM *argv,int argc)
{
  BOOL rc = FALSE;

  SetLastError("");

  if ( !p_conn )
     {
       SetLastError("Not connected to server");
       return rc;
     }

  if ( !s_proc || !s_proc[0] )
     {
       SetLastError("Empty proc name");
       return rc;
     }

  unsigned alloc_size = ProcessStoredProcParams(argv,argc,NULL);

  char s[MAX_PATH];
  sprintf(s,"CALL %s()",s_proc);

  alloc_size += strlen(s)+1;

  char *buff = (char*)malloc(alloc_size);

  if ( buff )
     {
       char *p = buff;
       sprintf(p,"CALL %s(",s_proc);
       p += strlen(p);
       p += ProcessStoredProcParams(argv,argc,p);
       *p++ = ')';
       
       if ( !mysql_real_query(p_conn,buff,p-buff) )
          {
            rc = TRUE;

            // to avoid "out of sync error"
            do {
              MYSQL_RES *res = mysql_store_result(p_conn);
              if ( res )
                 {
                   mysql_free_result(res);
                 }
              else
                 {
                   if ( mysql_errno(p_conn) )
                      break;
                 }
            } while ( !mysql_next_result(p_conn) );
          }
       else
          {
            SetLastError(mysql_error(p_conn));

            int err = mysql_errno(p_conn);
            if ( err == CR_SERVER_GONE_ERROR || err == CR_SERVER_LOST )
               {
                 mysql_close(p_conn);
                 p_conn = NULL;
               }
          }

       free(buff);
     }
  else
     {
       SetLastError("Memory allocation error");
     }

  return rc;
}


// if buff == NULL returns needed allocation space incl. null-terminator (can be larger than needed)
// if buff != NULL fills it and returns number of bytes filled (not including NULL-terminator)
unsigned CServerConn::ProcessStoredProcParams(const TSTOREDPROCPARAM *_argv,int argc,char *buff)
{
  char *orig_buff = buff;
  unsigned alloc_size = 0;

  for ( int n = 0; n < argc; n++ )
      {
        if ( n != 0 )
           {
             // insert comma ','
             alloc_size++;
             if ( buff )
                *buff++ = ',';
           }
        
        BOOL is_ok = FALSE;

        const TSTOREDPROCPARAM *arg = &_argv[n];

        if ( arg->direction == SQL_PD_INPUT )
           {
             if ( arg->data_type == SQL_DT_INTEGER )
                {
                  if ( arg->value )
                     {
                       int t = *(int*)(arg->value);
                       char s[32];
                       sprintf(s,"%d",t);
                       alloc_size += strlen(s);
                       if ( buff )
                          {
                            strcpy(buff,s);
                            buff += strlen(buff);
                          }
                       is_ok = TRUE;
                     }
                }
             else
             if ( arg->data_type == SQL_DT_STRING )
                {
                  if ( arg->value )
                     {
                       const char *s = (char*)arg->value;
                       alloc_size += 1+strlen(s)*2+1; // \'escaped(%s)\'
                       if ( buff )
                          {
                            *buff++ = '\'';
                            buff += mysql_real_escape_string(p_conn,buff,s,strlen(s));
                            *buff++ = '\'';
                          }
                       is_ok = TRUE;
                     }
                }
             else
             if ( arg->data_type == SQL_DT_REAL )
                {
                  if ( arg->value )
                     {
                       double t = *(double*)(arg->value);
                       char s[200];
                       sprintf(s,"%0.20f",t);
                       alloc_size += strlen(s);
                       if ( buff )
                          {
                            strcpy(buff,s);
                            buff += strlen(buff);
                          }
                       is_ok = TRUE;
                     }
                }
             else
             if ( arg->data_type == SQL_DT_DATETIME )
                {
                  if ( arg->value )
                     {
                       double t = *(double*)(arg->value);
                       char s[100] = "";
                       ConvertDoubleToDateTimeString(t,s);
                       alloc_size += 1+strlen(s)+1; // \'YYYY-MM-DD HH:MM:SS\'
                       if ( buff )
                          {
                            *buff++ = '\'';
                            strcpy(buff,s);
                            buff += strlen(buff);
                            *buff++ = '\'';
                          }
                       is_ok = TRUE;
                     }
                }
             else
             if ( arg->data_type == SQL_DT_BLOB )
                {
                  if ( arg->value && arg->blob_size )
                     {
                       const char *s = (char*)arg->value;
                       alloc_size += 1+arg->blob_size*2+1; // \'escaped(blob)\'
                       if ( buff )
                          {
                            *buff++ = '\'';
                            buff += mysql_real_escape_string(p_conn,buff,s,arg->blob_size);
                            *buff++ = '\'';
                          }
                       is_ok = TRUE;
                     }
                }
           }

        if ( !is_ok )
           {
             //add NULL parameter
             alloc_size += strlen("NULL");
             if ( buff )
                {
                  strcpy(buff,"NULL");
                  buff += strlen(buff);
                }
           }
      }

  //final NULL terminator
  alloc_size++;
  if ( buff )
     *buff++ = 0;

  return buff ? buff-orig_buff-1 : alloc_size;
}


