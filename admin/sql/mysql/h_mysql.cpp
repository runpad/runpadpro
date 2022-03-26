
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "api/include/mysql.h"
#include "api/include/errmsg.h"
#include "g_conn.h"
#include "../h_sql_inc.h"


#define EXPORT extern "C" __declspec(dllexport)

static void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def);

static int g_numobjects = 0;  //number of allocated objects

// global constants (runpad-specific)
#define RUNPAD_BASE  "RunpadPro"
#define RUNPAD_USER  "rsp_service"
#define RUNPAD_BACKUP_USER  "rsp_backupoperator"
#define RUNPAD_PWD   "cthdbc"
#define REG_COMMON_KEY "Software\\RunpadProCommon"


////////////////////////////////////////
// low-level SQL functions
////////////////////////////////////////

EXPORT void __cdecl SQL_FinishLibrary() // usually called before FreeLibrary(this_lib)
{
  if ( g_numobjects == 0 )
     {
       mysql_library_end();
     }
}


static BOOL __cdecl CBVarsI(TEXECSQLCBSTRUCT *i)
{
  if ( i->idx == 0 )
     {
       void *f = i->GetFieldByName(i->obj,"Value");
       if ( !f )
          f = i->GetFieldByName(i->obj,"VARIABLE_VALUE");
       
       if ( f )
          {
            *(int*)i->user_parm = i->GetFieldValueAsInt(i->obj,f);
          }

       return FALSE; //only first row is accepted
     }
  else
     {
       return TRUE;
     }
}


EXPORT void* __cdecl SQL_Connect(const char *s_server,const char *s_login,const char *s_pwd,const char *s_base)
{
  char s_port[MAX_PATH];
  ReadRegStr(HKEY_LOCAL_MACHINE,REG_COMMON_KEY,"def_mysql_port",s_port,"");
  int i_port = s_port[0] ? atoi(s_port) : 0;
  
  CServerConn *c = new CServerConn(s_server,s_login,s_pwd,s_base,i_port);

  if ( c->IsConnected() )
     {
       if ( c->GetServerVersion() < 50027 )
          {
            c->Disconnect();
            c->SetLastError("Версии MySQL-сервера ниже 5.0.27 не поддерживаются");
          }
       else
          {
            if ( !c->ExecSQL("SET NAMES \'cp1251\'") )
               {
                 c->Disconnect();
                 c->SetLastError("Кодировка cp1251 не поддерживается сервером");
               }
            else
               {
                 BOOL b_continue = TRUE;
                 
                 int v = -1;
                 if ( c->ExecSQL("SHOW VARIABLES LIKE \'max_allowed_packet\'",SQL_DEF_TIMEOUT,NULL,CBVarsI,&v) )
                    {
                      if ( v != -1 )
                         {
                           if ( v < 30000000 )
                              {
                                c->Disconnect();
                                c->SetLastError("Необходимо установить переменную MySQL-сервера \'max_allowed_packet\' как минимум на 32МБ (см. справку по установке RunpadPro)");
                                b_continue = FALSE;
                              }
                         }
                    }
                 
                 if ( b_continue )
                    {
                      c->ExecSQL("SET max_allowed_packet=32000000");
                      c->ExecSQL("SET wait_timeout=604800"); //1 week
                    }
               }
          }
     }

  ++g_numobjects;

  return c;
}


EXPORT void __cdecl SQL_Disconnect(void *obj)
{
  if ( obj )
     {
       CServerConn *c = (CServerConn*)obj;

       delete c;

       --g_numobjects;
     }
}


EXPORT BOOL __cdecl SQL_IsConnected(void *obj)
{
  if ( obj )
     {
       CServerConn *c = (CServerConn*)obj;

       return c->IsConnected();
     }
  else
     {
       return FALSE;
     }
}


EXPORT BOOL __cdecl SQL_PollServer(void *obj)
{
  BOOL rc = FALSE;
  
  if ( obj )
     {
       CServerConn *c = (CServerConn*)obj;

       if ( c->IsConnected() )
          {
            c->ExecSQL("SELECT 1");

            rc = c->IsConnected();
          }
     }

  return rc;
}


EXPORT const char* __cdecl SQL_GetLastError(void *obj)
{
  if ( obj )
     {
       CServerConn *c = (CServerConn*)obj;

       const char *s = c->GetLastError();
       return s ? s : "";
     }
  else
     {
       return "NULL object passed";
     }
}


// must be allocated at least [strlen(from)*2+1] for "to"
EXPORT void __cdecl SQL_EscapeString(void *obj,const char *from,char *to)
{
  to[0] = 0;

  if ( from && from[0] )
     {
       if ( obj )
          {
            CServerConn *c = (CServerConn*)obj;

            c->EscapeString(from,to);
          }
       else
          {
            char *dest = to;
            
            for ( int n = 0; n <= strlen(from)/*!!!*/; n++ )
                {
                  char c = from[n];

                  if ( c == '\r' )
                     {
                       *dest++ = '\\';
                       *dest++ = 'r';
                     }
                  else
                  if ( c == '\n' )
                     {
                       *dest++ = '\\';
                       *dest++ = 'n';
                     }
                  else
                  if ( c == '\\' )
                     {
                       *dest++ = '\\';
                       *dest++ = '\\';
                     }
                  else
                  if ( c == '\'' )
                     {
                       *dest++ = '\\';
                       *dest++ = '\'';
                     }
                  else
                  if ( c == '\"' )
                     {
                       *dest++ = '\\';
                       *dest++ = '\"';
                     }
                  else
                     {
                       *dest++ = c;
                     }
                }
          }
     }
}


EXPORT BOOL __cdecl SQL_Exec(void *obj,const char *query,int timeout,int *_record_count,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin)
{
  if ( _record_count )
     *_record_count = 0;
  
  if ( obj )
     {
       CServerConn *c = (CServerConn*)obj;

       return c->ExecSQL(query,timeout,_record_count,cb,cb_parm,call_cb_at_begin);
     }
  else
     {
       return FALSE;
     }
}


EXPORT BOOL __cdecl SQL_CallStoredProc(void *obj,const char *s_proc,int timeout,TSTOREDPROCPARAM *argv,int argc)
{
  if ( obj )
     {
       CServerConn *c = (CServerConn*)obj;

       return c->CallStoredProc(s_proc,timeout,argv,argc);
     }
  else
     {
       return FALSE;
     }
}



////////////////////////////////////////
// our internal functions
////////////////////////////////////////

class CEscape
{
          char *s_esc;

  public:
          CEscape(void *obj,const char *s)
          {
            if ( s && s[0] )
               {
                 s_esc = (char*)malloc(strlen(s)*2+1);
                 SQL_EscapeString(obj,s,s_esc);
               }
            else
               {
                 s_esc = NULL;
               }
          }
          ~CEscape()
          {
            if ( s_esc )
               free(s_esc);
          }

          const char* Text() const { return s_esc ? s_esc : ""; }
          operator const char* () const { return Text(); }
};


static BOOL IsEmpty(const char *p)
{
  return !p || !p[0];
}


static BOOL IsNotEmpty(const char *p)
{
  return !IsEmpty(p);
}


static void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def)
{
  HKEY h;
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
          data[len] = 0;
       RegCloseKey(h);
     }
}


static BOOL Query(void *obj,const char *query,int timeout=SQL_DEF_TIMEOUT,int *_record_count=NULL,TEXECSQLCBPROC cb=NULL,void *cb_parm=NULL,BOOL call_cb_at_begin=FALSE)
{
  return SQL_Exec(obj,query,timeout,_record_count,cb,cb_parm,call_cb_at_begin);
}


static BOOL GrantInternal(void *obj,const char *privileges,const char *object,const char *user)
{
  BOOL rc = FALSE;

  char s[MAX_PATH];
  sprintf(s,"GRANT %s ON %s TO \'%s\'@\'%%\'",privileges,object,CEscape(obj,user).Text());
  rc = Query(obj,s);

  if ( rc )
     {
       sprintf(s,"GRANT %s ON %s TO \'%s\'@\'localhost\'",privileges,object,CEscape(obj,user).Text());
       Query(obj,s); // we do not check results here
     }

  return rc;
}


static BOOL RevokeInternal(void *obj,const char *privileges,const char *object,const char *user)
{
  BOOL rc = FALSE;

  char s[MAX_PATH];
  sprintf(s,"REVOKE %s ON %s FROM \'%s\'@\'%%\'",privileges,object,CEscape(obj,user).Text());
  rc = Query(obj,s);

  if ( rc )
     {
       sprintf(s,"REVOKE %s ON %s FROM \'%s\'@\'localhost\'",privileges,object,CEscape(obj,user).Text());
       Query(obj,s); // we do not check results here
     }

  return rc;
}


static BOOL IsProcExists(void *obj,const char *s_proc,const char *s_base)
{
  BOOL rc = FALSE;

  char s[MAX_PATH];
  sprintf(s,"SELECT * FROM mysql.proc WHERE name=\'%s\' AND db=\'%s\'",s_proc,s_base);
  int cnt = 0;
  if ( Query(obj,s,SQL_DEF_TIMEOUT,&cnt) )
     {
       if ( cnt > 0 )
          {
            rc = TRUE;
          }
       else
          {
            // try with lowercase db
            char l_base[MAX_PATH];
            strcpy(l_base,s_base);
            strlwr(l_base);
            
            sprintf(s,"SELECT * FROM mysql.proc WHERE name=\'%s\' AND db=\'%s\'",s_proc,l_base);
            int cnt = 0;
            if ( Query(obj,s,SQL_DEF_TIMEOUT,&cnt) )
               {
                 if ( cnt > 0 )
                    {
                      rc = TRUE;
                    }
               }
          }
     }

  return rc;
}



////////////////////////////////////////
// high-level SQL functions
////////////////////////////////////////

EXPORT BOOL __cdecl SQL_InplaceCallStoredProc(void *obj,const char *s_proc,const char *params,int timeout,int *_record_count,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin)
{
  BOOL rc = FALSE;

  if ( IsNotEmpty(s_proc) )
     {
       char *s = NULL;

       if ( IsEmpty(params) )
          {
            s = (char*)malloc(32+strlen(s_proc));
            sprintf(s,"CALL %s()",s_proc);
          }
       else
          {
            s = (char*)malloc(32+strlen(s_proc)+strlen(params));
            sprintf(s,"CALL %s(%s)",s_proc,params);
          }

       rc = Query(obj,s,timeout,_record_count,cb,cb_parm,call_cb_at_begin);

       free(s);
     }

  return rc;
}


EXPORT BOOL __cdecl SQL_CreateUser(void *obj,const char *name,const char *pwd)
{
  BOOL rc = FALSE;
  
  if ( IsNotEmpty(name) )
     {
       char s[MAX_PATH];
       sprintf(s,"SELECT * FROM mysql.user WHERE user=\'%s\' AND host=\'%%\'",CEscape(obj,name).Text());
       int cnt = 0;
       if ( Query(obj,s,SQL_DEF_TIMEOUT,&cnt) )
          {
            if ( cnt > 0 )
               {
                 sprintf(s,"GRANT USAGE ON * TO \'%s\'@\'%%\'",CEscape(obj,name).Text());
               }
            else
               {
                 sprintf(s,"GRANT USAGE ON * TO \'%s\'@\'%%\' IDENTIFIED BY \'%s\'",CEscape(obj,name).Text(),CEscape(obj,pwd).Text());
               }

            rc = Query(obj,s);

            if ( rc )
               {
                 sprintf(s,"GRANT USAGE ON * TO \'%s\'@\'localhost\'",CEscape(obj,name).Text());
                 Query(obj,s); //we do not check result here
               }
          }
     }

  return rc;
}


EXPORT BOOL __cdecl SQL_ChangeCurrentPwd(void *obj,const char *old_pwd,const char *new_pwd)
{
  char s[MAX_PATH];
  sprintf(s,"SET PASSWORD=PASSWORD(\'%s\')",CEscape(obj,new_pwd).Text());
  return Query(obj,s);
}


EXPORT BOOL __cdecl SQL_ChangeOtherPwd(void *obj,const char *login,const char *pwd)
{
  BOOL rc = FALSE;
  
  if ( IsNotEmpty(login) )
     {
       char s[MAX_PATH];
       sprintf(s,"SET PASSWORD FOR \'%s\'@\'%%\' = PASSWORD(\'%s\')",CEscape(obj,login).Text(),CEscape(obj,pwd).Text());
       rc = Query(obj,s);
       if ( rc )
          {
            sprintf(s,"SET PASSWORD FOR \'%s\'@\'localhost\' = PASSWORD(\'%s\')",CEscape(obj,login).Text(),CEscape(obj,pwd).Text());
            Query(obj,s); //we do not check result here
          }
     }

  return rc;
}


// todo: remove this
static void RevokeAllInternalHack(void *obj,const char *user)
{
  // this is a stupid MySQL hack:
  // server only can revoke privileges that was granted before!
  // REVOKE ALL ON * isn't works fine!
  RevokeInternal(obj,"SELECT,INSERT,UPDATE","TPrices",user);
  RevokeInternal(obj,"SELECT,DELETE","TServices",user);
  RevokeInternal(obj,"SELECT,DELETE","TEvents",user);
  RevokeInternal(obj,"SELECT,DELETE","TUserResponses",user);
  RevokeInternal(obj,"SELECT","TDBUsers",user);
  RevokeInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TCompProfiles",user);
  RevokeInternal(obj,"EXECUTE","PROCEDURE PCompProfilesAddModify",user);
  RevokeInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TVarsProfiles",user);
  RevokeInternal(obj,"EXECUTE","PROCEDURE PVarsProfilesAddModify",user);
  RevokeInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TContentProfiles",user);
  RevokeInternal(obj,"EXECUTE","PROCEDURE PContentProfilesAddModify",user);
  RevokeInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TCompSettingsRules",user);
  RevokeInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TSettingsRules",user);
  RevokeInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TVipUsers",user);
  RevokeInternal(obj,"EXECUTE","PROCEDURE PVipLogin",user);
  RevokeInternal(obj,"EXECUTE","PROCEDURE PVipRegister",user);
  RevokeInternal(obj,"EXECUTE","PROCEDURE PVipDelete",user);
  RevokeInternal(obj,"EXECUTE","PROCEDURE PVipClearPass",user);
}


EXPORT BOOL __cdecl SQL_RemoveUserFromCurrentBase(void *obj,const char *login)
{
  BOOL rc = FALSE;
  
  if ( IsNotEmpty(login) )
     {
       RevokeAllInternalHack(obj,login);
       rc = RevokeInternal(obj,"ALL","*",login);  //not worked at all, because we never GRANT ALL
     }

  return rc;
}


EXPORT BOOL __cdecl SQL_BeginTransaction(void *obj,int timeout)
{
  return Query(obj,"BEGIN;",timeout);
}


EXPORT BOOL __cdecl SQL_CommitTransaction(void *obj,int timeout)
{
  return Query(obj,"COMMIT;",timeout);
}


EXPORT BOOL __cdecl SQL_RollbackTransaction(void *obj,int timeout)
{
  return Query(obj,"ROLLBACK;",timeout);
}


EXPORT BOOL __cdecl SQL_IsMSSQLSyntax()
{
  return FALSE;
}


EXPORT BOOL __cdecl SQL_IsMySQLSyntax()
{
  return TRUE;
}


////////////////////////////////////////
// Runpad-specific functions
////////////////////////////////////////

static BOOL __cdecl CBIntSelect(TEXECSQLCBSTRUCT *i)
{
  if ( i->idx == 0 )
     {
       void *f = i->GetFieldByIdx(i->obj,0);
       if ( f )
          {
            *(int*)i->user_parm = i->GetFieldValueAsInt(i->obj,f);
          }

       return FALSE; //only first row is accepted
     }
  else
     {
       return TRUE;
     }
}


EXPORT BOOL __cdecl SQL_RuleCheck(void *obj,const char *s_rule,const char *s_computerloc,const char *s_computerdesc,const char *s_computername,const char *s_ip,const char *s_userdomain,const char *s_username,int s_langid)
{
  if ( IsEmpty(s_rule) )
     {
       return TRUE; //empty rule is equals to TRUE
     }

  const char *fmt = 
    "SET @computerloc=\'%s\';\n"
    "SET @computerdesc=\'%s\';\n"
    "SET @computername=\'%s\';\n"
    "SET @ip=\'%s\';\n"
    "SET @userdomain=\'%s\';\n"
    "SET @username=\'%s\';\n"
    "SET @langid=%d;\n"
    "SELECT IF(%s,1,0);";

  char *query = (char*)malloc(strlen(fmt)+strlen(s_rule)+6*MAX_PATH);

  sprintf(query,fmt,
                    CEscape(obj,s_computerloc).Text(),
                    CEscape(obj,s_computerdesc).Text(),
                    CEscape(obj,s_computername).Text(),
                    CEscape(obj,s_ip).Text(),
                    CEscape(obj,s_userdomain).Text(),
                    CEscape(obj,s_username).Text(),
                    s_langid,
                    s_rule);

  BOOL rc = FALSE;

  int v = -1;
  if ( Query(obj,query,SQL_DEF_TIMEOUT,NULL,CBIntSelect,&v,FALSE) )
     {
      if ( v != -1 )
         {
           rc = (v == 1);
         }
     }

  free(query);

  return rc;
}


EXPORT BOOL __cdecl SQL_PrepareDB(void *obj)
{
  BOOL rc = FALSE;

  if ( obj )
     {
       if ( !Query(obj,"CREATE DATABASE IF NOT EXISTS " RUNPAD_BASE " DEFAULT CHARACTER SET cp1251 COLLATE cp1251_general_ci") )
          return rc;

       if ( !Query(obj,"USE " RUNPAD_BASE) )
          return rc;

       //create prices table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TPrices(\n"
        " id          INT,\n"
        " name        VARCHAR(256),\n"
        " price_count FLOAT,\n"
        " price_size  FLOAT,\n"
        " price_time  FLOAT,\n"
        " price_fixed FLOAT)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create services table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TServices(\n"
        " comp_loc    VARCHAR(256),\n"
        " comp_desc   VARCHAR(256),\n"
        " comp_name   VARCHAR(256),\n"
        " comp_ip     VARCHAR(256),\n"
        " user_domain VARCHAR(256),\n"
        " user_name   VARCHAR(256),\n"
        " vip_name    VARCHAR(256),\n"
        " id          INT,\n"
        " data_count  INT,\n"
        " data_size   INT,\n"
        " data_time   INT,\n"
        " comments    VARCHAR(512),\n"
        " time        DATETIME,\n"
        " cost        FLOAT)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create services-insertion stored proc
       if ( !IsProcExists(obj,"PAddServiceString",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PAddServiceString(\n"
        "_comp_loc    VARCHAR(256),\n"
        "_comp_desc   VARCHAR(256),\n"
        "_comp_name   VARCHAR(256),\n"
        "_comp_ip     VARCHAR(256),\n"
        "_user_domain VARCHAR(256),\n"
        "_user_name   VARCHAR(256),\n"
        "_vip_name    VARCHAR(256),\n"
        "_id          INT,\n"
        "_data_count  INT,\n"
        "_data_size   INT,\n"
        "_data_time   INT,\n"
        "_comments    VARCHAR(512))\n"
        "BEGIN\n"
        "DECLARE __cnt INT;\n"
        "DECLARE __res FLOAT;\n"
        "SELECT Count(TPrices.id) FROM TPrices WHERE TPrices.id=_id INTO __cnt;\n"
        "IF __cnt=0 THEN\n"
        " SET __res=0;\n"
        "ELSE\n"
        " SELECT Avg(TPrices.price_count*_data_count+TPrices.price_size*_data_size+TPrices.price_time*_data_time+TPrices.price_fixed) FROM TPrices WHERE TPrices.id=_id INTO __res;\n"
        "END IF;\n"
        "INSERT INTO TServices VALUES(_comp_loc,_comp_desc,_comp_name,_comp_ip,_user_domain,_user_name,_vip_name,_id,_data_count,_data_size,_data_time,_comments,NOW(),__res);\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create events table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TEvents(\n"
        " comp_loc    VARCHAR(256),\n"
        " comp_desc   VARCHAR(256),\n"
        " comp_name   VARCHAR(256),\n"
        " comp_ip     VARCHAR(256),\n"
        " user_domain VARCHAR(256),\n"
        " user_name   VARCHAR(256),\n"
        " vip_name    VARCHAR(256),\n"
        " level       INT,\n"
        " comments    VARCHAR(512),\n"
        " time        DATETIME)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create events-insertion stored proc
       if ( !IsProcExists(obj,"PAddEventString",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PAddEventString(\n"
        "_comp_loc    VARCHAR(256),\n"
        "_comp_desc   VARCHAR(256),\n"
        "_comp_name   VARCHAR(256),\n"
        "_comp_ip     VARCHAR(256),\n"
        "_user_domain VARCHAR(256),\n"
        "_user_name   VARCHAR(256),\n"
        "_vip_name    VARCHAR(256),\n"
        "_level       INT,\n"
        "_comments    VARCHAR(512))\n"
        "BEGIN\n"
        "INSERT INTO TEvents VALUES(_comp_loc,_comp_desc,_comp_name,_comp_ip,_user_domain,_user_name,_vip_name,_level,_comments,NOW());\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create user-responses table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TUserResponses(\n"
        " msg_kind    VARCHAR(256),\n"
        " msg_title   VARCHAR(256),\n"
        " user_name   VARCHAR(256),\n"
        " user_age    VARCHAR(256),\n"
        " msg_text    TEXT,\n"
        " time        DATETIME)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create user-responses-insertion stored proc
       if ( !IsProcExists(obj,"PAddUserResponse",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PAddUserResponse(\n"
        "_msg_kind    VARCHAR(256),\n"
        "_msg_title   VARCHAR(256),\n"
        "_user_name   VARCHAR(256),\n"
        "_user_age    VARCHAR(256),\n"
        "_msg_text    TEXT)\n"
        "BEGIN\n"
        "INSERT INTO TUserResponses VALUES(_msg_kind,_msg_title,_user_name,_user_age,_msg_text,NOW());\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create VIP-users table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TVipUsers(\n"
        " user_name   VARCHAR(256),\n"
        " user_pwd    VARCHAR(256))\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create VIP-users stored proc for Login
       if ( !IsProcExists(obj,"PVipLogin",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PVipLogin(\n"
        "_user_name   VARCHAR(256),\n"
        "_user_pwd    VARCHAR(256))\n"
        "BEGIN\n"
        "SELECT * FROM TVipUsers WHERE user_name=_user_name AND user_pwd=_user_pwd;\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create VIP-users stored proc for Login by password only
       if ( !IsProcExists(obj,"PVipLoginByPwd",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PVipLoginByPwd(\n"
        "_user_pwd    VARCHAR(256))\n"
        "BEGIN\n"
        "SELECT * FROM TVipUsers WHERE user_pwd=_user_pwd;\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create VIP-users stored proc for Register
       if ( !IsProcExists(obj,"PVipRegister",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PVipRegister(\n"
        "_user_name  VARCHAR(256),\n"
        "_user_pwd   VARCHAR(256))\n"
        "BEGIN\n"
        "IF _user_pwd=\'\' THEN\n"
        " IF NOT EXISTS (SELECT * FROM TVipUsers WHERE user_name=_user_name) THEN\n"
        "  INSERT INTO TVipUsers VALUES(_user_name,_user_pwd);\n"
        "  SELECT 1;\n"
        " END IF;\n"
        "ELSE\n"
        " UPDATE TVipUsers SET user_pwd=_user_pwd WHERE user_name=_user_name AND user_pwd=\'\';\n"
        " SELECT * FROM TVipUsers WHERE user_name=_user_name AND user_pwd=_user_pwd;\n"
        "END IF;\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create VIP-users stored proc for Delete
       if ( !IsProcExists(obj,"PVipDelete",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PVipDelete(\n"
        "_user_name  VARCHAR(256))\n"
        "BEGIN\n"
        "DELETE FROM TVipUsers WHERE user_name=_user_name;\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create VIP-users stored proc for ClearPass
       if ( !IsProcExists(obj,"PVipClearPass",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PVipClearPass(\n"
        "_user_name  VARCHAR(256))\n"
        "BEGIN\n"
        "UPDATE TVipUsers SET user_pwd=\'\' WHERE user_name=_user_name;\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create DB-users table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TDBUsers(\n"
        " user_name   VARCHAR(256),\n"
        " user_rights TEXT)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create CompProfiles table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TCompProfiles(\n"
        " name   VARCHAR(256),\n"
        " data   LONGBLOB)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create CompProfiles stored proc for Add/Modify
       if ( !IsProcExists(obj,"PCompProfilesAddModify",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PCompProfilesAddModify(\n"
        "_name  VARCHAR(256),\n"
        "_data  LONGBLOB)\n"
        "BEGIN\n"
        "IF EXISTS (SELECT name FROM TCompProfiles WHERE name=_name) THEN\n"
        " UPDATE TCompProfiles SET data=_data WHERE name=_name;\n"
        "ELSE\n"
        " INSERT INTO TCompProfiles VALUES(_name,_data);\n"
        "END IF;\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create VarsProfiles table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TVarsProfiles(\n"
        " name   VARCHAR(256),\n"
        " data   LONGBLOB)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create VarsProfiles stored proc for Add/Modify
       if ( !IsProcExists(obj,"PVarsProfilesAddModify",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PVarsProfilesAddModify(\n"
        "_name  VARCHAR(256),\n"
        "_data  LONGBLOB)\n"
        "BEGIN\n"
        "IF EXISTS (SELECT name FROM TVarsProfiles WHERE name=_name) THEN\n"
        " UPDATE TVarsProfiles SET data=_data WHERE name=_name;\n"
        "ELSE\n"
        " INSERT INTO TVarsProfiles VALUES(_name,_data);\n"
        "END IF;\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create ContentProfiles table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TContentProfiles(\n"
        " name   VARCHAR(256),\n"
        " data   LONGBLOB)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create ContentProfiles stored proc for Add/Modify
       if ( !IsProcExists(obj,"PContentProfilesAddModify",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PContentProfilesAddModify(\n"
        "_name  VARCHAR(256),\n"
        "_data  LONGBLOB)\n"
        "BEGIN\n"
        "IF EXISTS (SELECT name FROM TContentProfiles WHERE name=_name) THEN\n"
        " UPDATE TContentProfiles SET data=_data WHERE name=_name;\n"
        "ELSE\n"
        " INSERT INTO TContentProfiles VALUES(_name,_data);\n"
        "END IF;\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create rules table (for computer)
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TCompSettingsRules(\n"
        " number           INT,\n"
        " rule_string      TEXT,\n"
        " comp_profile     VARCHAR(256))\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create rules table (for user)
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TSettingsRules(\n"
        " number           INT,\n"
        " rule_string      TEXT,\n"
        " vars_profile     VARCHAR(256),\n"
        " content_profile  VARCHAR(256))\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create client-update table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TClientUpdate(\n"
        " path           VARCHAR(256),\n"
        " crc32          VARCHAR(256),\n"
        " data           LONGBLOB)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create client-update stored proc for Add
       if ( !IsProcExists(obj,"PClientUpdateAdd",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PClientUpdateAdd(\n"
        "_path   VARCHAR(256),\n"
        "_crc32  VARCHAR(256),\n"
        "_data   LONGBLOB)\n"
        "BEGIN\n"
        "INSERT INTO TClientUpdate VALUES(_path,_crc32,_data);\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create client-update table
       {
        const char *q = 
        "CREATE TABLE IF NOT EXISTS TClientUpdateNoShell(\n"
        " path           VARCHAR(256),\n"
        " crc32          VARCHAR(256),\n"
        " data           LONGBLOB)\n";
        if ( !Query(obj,q) )
           return rc;
       }

       //create client-update stored proc for Add
       if ( !IsProcExists(obj,"PClientUpdateNoShellAdd",RUNPAD_BASE) )
       {
        const char *q = 
        "CREATE PROCEDURE PClientUpdateNoShellAdd(\n"
        "_path   VARCHAR(256),\n"
        "_crc32  VARCHAR(256),\n"
        "_data   LONGBLOB)\n"
        "BEGIN\n"
        "INSERT INTO TClientUpdateNoShell VALUES(_path,_crc32,_data);\n"
        "END;\n";
        if ( !Query(obj,q) )
           return rc;
       }

       // process internal runpad user
       if ( !SQL_CreateUser(obj,RUNPAD_USER,RUNPAD_PWD) )
          return rc;

       rc = TRUE;
       rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PAddServiceString",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PAddEventString",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PAddUserResponse",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipLogin",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipLoginByPwd",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipRegister",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipDelete",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipClearPass",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"SELECT","TCompProfiles",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"SELECT","TVarsProfiles",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"SELECT","TContentProfiles",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"SELECT","TCompSettingsRules",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"SELECT","TSettingsRules",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"SELECT","TClientUpdate",RUNPAD_USER);
       rc = rc && GrantInternal(obj,"SELECT","TClientUpdateNoShell",RUNPAD_USER);
     }

  return rc;
}


EXPORT BOOL __cdecl SQL_ApplyUserRights(void *obj,const char *user,BOOL ur_editcosts,BOOL ur_deloldrecords,BOOL ur_editcompvars,BOOL ur_editvars,BOOL ur_editcontent,BOOL ur_editcomprules,BOOL ur_editrules,BOOL ur_vipwork)
{
  BOOL rc = FALSE;

  if ( obj && IsNotEmpty(user) )
     {
       RevokeAllInternalHack(obj,user); //hack
       RevokeInternal(obj,"ALL","*",user); //we do not check result here!

       rc = TRUE;

       if ( ur_editcosts )
       {
         rc = rc && GrantInternal(obj,"SELECT,INSERT,UPDATE","TPrices",user);
       }
       else
       {
         rc = rc && GrantInternal(obj,"SELECT,INSERT","TPrices",user);
       }

       if ( ur_deloldrecords )
       {
         rc = rc && GrantInternal(obj,"SELECT,DELETE","TServices",user);
         rc = rc && GrantInternal(obj,"SELECT,DELETE","TEvents",user);
         rc = rc && GrantInternal(obj,"SELECT,DELETE","TUserResponses",user);
       }
       else
       {
         rc = rc && GrantInternal(obj,"SELECT","TServices",user);
         rc = rc && GrantInternal(obj,"SELECT","TEvents",user);
         rc = rc && GrantInternal(obj,"SELECT","TUserResponses",user);
       }

       rc = rc && GrantInternal(obj,"SELECT","TDBUsers",user);

       if ( ur_editcompvars )
       {
         rc = rc && GrantInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TCompProfiles",user);
         rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PCompProfilesAddModify",user);
       }
       else
       {
         rc = rc && GrantInternal(obj,"SELECT","TCompProfiles",user);
       }

       if ( ur_editvars )
       {
         rc = rc && GrantInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TVarsProfiles",user);
         rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVarsProfilesAddModify",user);
       }
       else
       {
         rc = rc && GrantInternal(obj,"SELECT","TVarsProfiles",user);
       }

       if ( ur_editcontent )
       {
         rc = rc && GrantInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TContentProfiles",user);
         rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PContentProfilesAddModify",user);
       }
       else
       {
         rc = rc && GrantInternal(obj,"SELECT","TContentProfiles",user);
       }

       if ( ur_editcomprules )
       {
         rc = rc && GrantInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TCompSettingsRules",user);
       }
       else
       {
         rc = rc && GrantInternal(obj,"SELECT","TCompSettingsRules",user);
       }

       if ( ur_editrules )
       {
         rc = rc && GrantInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TSettingsRules",user);
       }
       else
       {
         rc = rc && GrantInternal(obj,"SELECT","TSettingsRules",user);
       }

       if ( ur_vipwork )
       {
         rc = rc && GrantInternal(obj,"SELECT,DELETE,UPDATE,INSERT","TVipUsers",user);
         rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipLogin",user);
         rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipRegister",user);
         rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipDelete",user);
         rc = rc && GrantInternal(obj,"EXECUTE","PROCEDURE PVipClearPass",user);
       }
       else
       {
         rc = rc && GrantInternal(obj,"SELECT","TVipUsers",user);
       }
     }

  return rc;
}


EXPORT void* __cdecl SQL_ConnectAsInternalUser(const char *s_server)
{
  return SQL_Connect(s_server,RUNPAD_USER,RUNPAD_PWD,RUNPAD_BASE);
}


EXPORT void* __cdecl SQL_ConnectAsBackupOperator(const char *s_server)
{
  return NULL;  //unsupported
}


EXPORT void* __cdecl SQL_ConnectAsNormalUser(const char *s_server,const char *s_login,const char *s_pwd)
{
  return SQL_Connect(s_server,s_login,s_pwd,RUNPAD_BASE);
}

