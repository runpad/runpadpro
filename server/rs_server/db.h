
#ifndef ___DB_H___
#define ___DB_H___

#include <vector>


class CSQLLib;
class CDynBuff;

class CDBLibGCRP
{
          CSQLLib *gc;
          CSQLLib *rp;
          
          int m_dbtype_gc;
          int m_dbtype_rp;

  public:
          CDBLibGCRP();
          ~CDBLibGCRP();

          void SetLib(int type_gc,int type_rp);
          void Free();
          void ClearWithoutFree();

          BOOL Connect(const char *server);
          BOOL IsConnected();
          BOOL PollServer();
          void Disconnect();

          const char* GetLastError();

          CSQLLib* GetGCObj() { return gc; }
          CSQLLib* GetRPObj() { return rp; }
};


class CDBObj
{
          enum {
          CMD_GETLASTERROR,
          CMD_VIPLOGIN,
          CMD_VIPLOGINBYPWD,
          CMD_VIPREGISTER,
          CMD_VIPDELETE,
          CMD_VIPCLEARPASS,
          CMD_ADDSERVICESTRING,
          CMD_ADDEVENTSTRING,
          CMD_ADDUSERRESPONSE,
          CMD_SETTINGSREQ,
          CMD_COMPSETTINGSREQ,
          CMD_CLIENTUPDATELISTREQ,
          CMD_CLIENTUPDATEFILEREQ,
          CMD_CLIENTUPDATENOSHELLLISTREQ,
          CMD_CLIENTUPDATENOSHELLFILEREQ,
          };

          typedef struct {
           const char *name;
           const char *pwd;
           BOOL find;
          } GCVIPLOGIN;
          
          typedef struct {
           CDynBuff rules;
           int count;
          } RULESCOLLECT;

          typedef struct {
           void *buff;
           unsigned size;
          } UPDFILE;

          HKEY reg_root;
          char *reg_key;
          char *reg_value_server;
          char *reg_value_dbtype_rp;
          char *reg_value_dbtype_gc;
          unsigned last_reg_read_time;

          char server_name[MAX_PATH];
          int dbtype_rp;
          int dbtype_gc;

          HANDLE h_thread;
          DWORD id_thread;

          unsigned last_poll_time;

          volatile BOOL b_connected;
          volatile HWND hwnd; //message-only window

          CDBLibGCRP gcrp; //used only in thread

  public:
          typedef std::pair<char*,char*> TStringPair;
          typedef std::vector<TStringPair> TStringPairVector;


  public:
          CDBObj(HKEY root,const char *key,const char *value_server,const char *value_dbtype_rp,const char *value_dbtype_gc);
          ~CDBObj();

          BOOL IsConnected();

          void GetLastErrorSlow(char *_err,int max);
          BOOL VipLogin(const char *s_login, const char *s_pwd);
          BOOL VipLoginByPwd(const char *s_pwd,char *_login);
          BOOL VipRegister(const char *s_login, const char *s_pwd);
          BOOL VipDelete(const char *s_login);
          BOOL VipClearPass(const char *s_login);
          BOOL AddServiceString(
                         const char* s_computerloc,
                         const char* s_computerdesc,
                         const char* s_computername,
                         const char* s_ip,
                         const char* s_userdomain,
                         const char* s_username,
                         const char* s_vipname,
                         int s_id,
                         int s_count,
                         int s_kbsize,
                         int s_time,
                         const char* s_comment
                        );
          BOOL AddEventString(
                         const char* s_computerloc,
                         const char* s_computerdesc,
                         const char* s_computername,
                         const char* s_ip,
                         const char* s_userdomain,
                         const char* s_username,
                         const char* s_vipname,
                         int s_level,
                         const char* s_comment
                        );
          BOOL AddUserResponse( 
                         const char *s_kind,
                         const char *s_title,
                         const char *s_name,
                         const char *s_age,
                         const char *s_text
                         );
          BOOL SettingsReq(
                         const char *s_computerloc,
                         const char *s_computerdesc,
                         const char *s_computername,
                         const char *s_ip,
                         const char *s_userdomain,
                         const char *s_username,
                         int s_langid,
                         CNetCmd &out);
          BOOL CompSettingsReq(
                         const char *s_computerloc,
                         const char *s_computerdesc,
                         const char *s_computername,
                         const char *s_ip,
                         CNetCmd &out);
          BOOL GetClientUpdateOrderedList(BOOL is_no_shell,TStringPairVector &out);
          void* GetClientUpdateFile(BOOL is_no_shell,const char *path,const char *crc32,unsigned *_size);

  private:
          static DWORD WINAPI ThreadProcWrapper(LPVOID lpParameter);
          static LRESULT CALLBACK WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
          DWORD ThreadProc();
          LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
          BOOL SendThreadMessage(int cmd,DWORD_PTR data,int *_exit_code=NULL);
          void RetrieveServerName(BOOL *_changed=NULL);
          void Disconnect();
          void Connect();
          void UpdateActualConnectionStatus();
          void OnIdle();
          BOOL OnCmdProcess(int cmd,DWORD_PTR data);
          static BOOL __cdecl GCVipLoginProc(TEXECSQLCBSTRUCT *parm);
          static BOOL __cdecl RPVipLoginByPwdProc(TEXECSQLCBSTRUCT *parm);
          static BOOL __cdecl RulesCollectionProc(TEXECSQLCBSTRUCT *i);
          BOOL LoadSettingsProfileInternal(CSQLLib *sql,const char *s_table,const char *s_profile,CDynBuff *out);
          static BOOL __cdecl LoadSettingsProfileCB(TEXECSQLCBSTRUCT *i);
          BOOL IsRuleAppliedInternal(CSQLLib *sql,
                                     const char *s_rule,
                                     const char *s_computerloc,
                                     const char *s_computerdesc,
                                     const char *s_computername,
                                     const char *s_ip,
                                     const char *s_userdomain,
                                     const char *s_username,
                                     int s_langid);
          static BOOL __cdecl ClientUpdateListCollectionProc(TEXECSQLCBSTRUCT *i);
          static BOOL __cdecl ClientUpdateFileCollectionProc(TEXECSQLCBSTRUCT *i);

};



#endif
