
#ifndef __CONFIG_H__
#define __CONFIG_H__


#include <vector>


enum {
MACHINE_TYPE_GAMECLUB = 1,
MACHINE_TYPE_INETCAFE = 2,
MACHINE_TYPE_OPERATOR = 4,
MACHINE_TYPE_ORGANIZATION = 8,
MACHINE_TYPE_TERMINAL = 16,
MACHINE_TYPE_HOME = 32,
MACHINE_TYPE_OTHER = 64,
MACHINE_TYPE_ALL = 0xFFFFFFFF,
};


typedef char TPATH[MAX_PATH];
typedef TPATH TSTRING;
typedef char TLONGSTRING[4096];


class CCfgEntry1 
{
      BOOL state;
      char* parm;

  public:
      CCfgEntry1();
      CCfgEntry1(const CCfgEntry1 &other);
      ~CCfgEntry1();
      CCfgEntry1& operator = (const CCfgEntry1 &other);

      BOOL GetState() const { return state; }
      const char* GetParm() const { return parm ? parm : ""; }
      BOOL IsActive() const { return GetState() && GetParm()[0]; }

  public:
      void Load(BOOL state,const char *parm);

  protected:
      friend class CConfig;

      BOOL IsEmpty() const { return !GetState() && !GetParm()[0]; }
};


class CCfgEntry2
{
      BOOL state;
      char* parm1;
      char* parm2;

  public:
      CCfgEntry2();
      CCfgEntry2(const CCfgEntry2 &other);
      ~CCfgEntry2();
      CCfgEntry2& operator = (const CCfgEntry2 &other);

      BOOL GetState() const { return state; }
      const char* GetParm1() const { return parm1 ? parm1 : ""; }
      const char* GetParm2() const { return parm2 ? parm2 : ""; }
      BOOL IsActive() const { return GetState() && GetParm1()[0] && GetParm2()[0]; }

  protected:
      friend class CConfig;

      void Load(BOOL state,const char *parm1,const char *parm2);
      BOOL IsEmpty() const { return !GetState() && !GetParm1()[0] && !GetParm2()[0]; }
};


typedef std::vector<CCfgEntry1> TCFGLIST1;
typedef std::vector<CCfgEntry2> TCFGLIST2;



class CShortcut
{
          char *s_name;
          char *s_exe;
          char *s_arg;
          char *s_cwd;
          char *s_icon_path;
          int i_icon_idx;
          char *s_pwd;
          BOOL b_allow_only_one;
          char *s_runas_domain;
          char *s_runas_user;
          char *s_runas_pwd;
          int i_show_cmd;
          int i_vcd_num;
          char *s_vcd;
          char *s_saver;
          char *s_sshot;
          char *s_desc;
          char *s_script1;
          char *s_group;
          char *s_floatlic;

  public:
          CShortcut( const char *s_name,
                     const char *s_exe,
                     const char *s_arg,
                     const char *s_cwd,
                     const char *s_icon_path,
                     int i_icon_idx,
                     const char *s_pwd,
                     BOOL b_allow_only_one,
                     const char *s_runas_domain,
                     const char *s_runas_user,
                     const char *s_runas_pwd,
                     int i_show_cmd,
                     int i_vcd_num,
                     const char *s_vcd,
                     const char *s_saver,
                     const char *s_sshot,
                     const char *s_desc,
                     const char *s_script1,
                     const char *s_group,
                     const char *s_floatlic );
          CShortcut(const char *full_path_to_file,BOOL allow_only_one=FALSE);
          CShortcut(const char* name,const char *full_path_to_file,const char *arg,BOOL allow_only_one=FALSE);
          ~CShortcut();

          const char* GetName() const { return GetNonNullString(s_name); }
          const char* GetExePath() const { return GetNonNullString(s_exe); }
          const char* GetArg() const { return GetNonNullString(s_arg); }
          const char* GetCWD() const { return GetNonNullString(s_cwd); }
          const char* GetIconPath() const { return GetNonNullString(s_icon_path); }
          int GetIconIdx() const { return i_icon_idx; }
          const char* GetPassword() const { return GetNonNullString(s_pwd); }
          BOOL GetAllowOnlyOne() const { return b_allow_only_one; }
          const char* GetRunAsDomain() const { return GetNonNullString(s_runas_domain); }
          const char* GetRunAsUser() const { return GetNonNullString(s_runas_user); }
          const char* GetRunAsPassword() const { return GetNonNullString(s_runas_pwd); }
          int GetShowCmd() const { return i_show_cmd; }
          int GetVCDNum() const { return i_vcd_num; }
          const char* GetVCDPath() const { return GetNonNullString(s_vcd); }
          const char* GetSaver() const { return GetNonNullString(s_saver); }
          const char* GetSShotPath() const { return GetNonNullString(s_sshot); }
          const char* GetDescription() const { return GetNonNullString(s_desc); }
          const char* GetScript1() const { return GetNonNullString(s_script1); }
          const char* GetGroup() const { return GetNonNullString(s_group); }
          const char* GetFloatLic() const { return GetNonNullString(s_floatlic); }
          
  private:
          const char* GetNonNullString( const char* s ) const { return s ? s : ""; }
          void InitVars();
          void Free();

  protected:
          friend class CConfig;

          void LoadVarsOnly( const char *s_name,
                             const char *s_exe,
                             const char *s_arg,
                             const char *s_cwd,
                             const char *s_icon_path,
                             int i_icon_idx,
                             const char *s_pwd,
                             BOOL b_allow_only_one,
                             const char *s_runas_domain,
                             const char *s_runas_user,
                             const char *s_runas_pwd,
                             int i_show_cmd,
                             int i_vcd_num,
                             const char *s_vcd,
                             const char *s_saver,
                             const char *s_sshot,
                             const char *s_desc,
                             const char *s_script1,
                             const char *s_group,
                             const char *s_floatlic );

};


class CRealShortcut
{
          const CShortcut* m_shortcut;
          
          char *s_exe;
          char *s_arg;
          char *s_cwd;
          char *s_icon_path;
          int i_icon_idx;
          char *s_vcd;
          char *s_sshot;

  public:
          CRealShortcut(const CShortcut& shortcut);
          ~CRealShortcut();

          const char* GetExePath() const { return GetNonNullString(s_exe); }
          const char* GetArg() const { return GetNonNullString(s_arg); }
          const char* GetCWD() const { return GetNonNullString(s_cwd); }
          const char* GetIconPath() const { return GetNonNullString(s_icon_path); }
          int GetIconIdx() const { return i_icon_idx; }
          const char* GetVCDPath() const { return GetNonNullString(s_vcd); }
          const char* GetSShotPath() const { return GetNonNullString(s_sshot); }

          const char* GetName() const { return m_shortcut ? m_shortcut->GetName() : ""; }
          const char* GetPassword() const { return m_shortcut ? m_shortcut->GetPassword() : ""; }
          BOOL GetAllowOnlyOne() const { return m_shortcut ? m_shortcut->GetAllowOnlyOne() : TRUE; }
          const char* GetRunAsDomain() const { return m_shortcut ? m_shortcut->GetRunAsDomain() : ""; }
          const char* GetRunAsUser() const { return m_shortcut ? m_shortcut->GetRunAsUser() : ""; }
          const char* GetRunAsPassword() const { return m_shortcut ? m_shortcut->GetRunAsPassword() : ""; }
          int GetShowCmd() const { return m_shortcut ? m_shortcut->GetShowCmd() : SW_NORMAL; }
          int GetVCDNum() const { return m_shortcut ? m_shortcut->GetVCDNum() : -1; }
          const char* GetDescription() const { return m_shortcut ? m_shortcut->GetDescription() : ""; }
          const char* GetScript1() const { return m_shortcut ? m_shortcut->GetScript1() : ""; }
          const char* GetSaver() const { return m_shortcut ? m_shortcut->GetSaver() : ""; }
          const char* GetGroup() const { return m_shortcut ? m_shortcut->GetGroup() : ""; }
          const char* GetFloatLic() const { return m_shortcut ? m_shortcut->GetFloatLic() : ""; }

          BOOL IsEmptyShortcut(BOOL use_icon_path) const;

  private:
          const char* GetNonNullString( const char* s ) const { return s ? s : ""; }
          static BOOL IsEmptyShortcutInternal(const char *target);
};


class CSheet
{
          char *s_name;
          char *s_icon_path;
          int i_color;
          int i_bg_color;
          char *s_bg_pic;
          char *s_bg_thumb_pic;
          int i_time_min;
          int i_time_max;
          char *s_vip_users;
          char *s_rules;
          BOOL is_internet_sheet;
  
          typedef std::vector<CShortcut*> TShortcuts;
          TShortcuts shortcuts;

  public:
          CSheet( const char *s_name,
                  const char *s_icon_path,
                  int i_color,
                  int i_bg_color,
                  const char *s_bg_pic,
                  const char *s_bg_thumb_pic,
                  int i_time_min,
                  int i_time_max,
                  const char *s_vip_users,
                  const char *s_rules,
                  BOOL is_internet_sheet );
          ~CSheet();

          const char* GetName() const { return GetNonNullString(s_name); }
          const char* GetIconPath() const { return GetNonNullString(s_icon_path); }
          int GetColor() const { return i_color; }
          int GetBGColor() const { return i_bg_color; }
          const char* GetBGPath() const { return GetNonNullString(s_bg_pic); }
          const char* GetBGThumbPath() const { return GetNonNullString(s_bg_thumb_pic); }
          int GetTimeMin() const { return i_time_min; }
          int GetTimeMax() const { return i_time_max; }
          const char* GetVIPUsers() const { return GetNonNullString(s_vip_users); }
          const char* GetRulesPath() const { return GetNonNullString(s_rules); }
          BOOL IsInternetSheet() const { return is_internet_sheet; }
          
          int GetCount() const { return shortcuts.size(); }
          CShortcut& operator [] (int idx) { return *shortcuts[idx]; }
          CShortcut& operator [] (unsigned idx) { return *shortcuts[idx]; }
          const CShortcut& operator [] (int idx) const { return *shortcuts[idx]; }
          const CShortcut& operator [] (unsigned idx) const { return *shortcuts[idx]; }

          BOOL IsCurrentlyEnabled(SYSTEMTIME *_st = NULL) const ;
          CShortcut *FindShortcutByName(const char *name);
          void GetRealBGThumbPicPathFast(char *s);

  private:
          const char* GetNonNullString( const char* s ) const { return s ? s : ""; }

  protected:
          friend class CConfig;
          
          void AddShortcut(CShortcut *shortcut);
          void LoadVarsOnly(const char *s_name,
                           const char *s_icon_path,
                           int i_color,
                           int i_bg_color,
                           const char *s_bg_pic,
                           const char *s_bg_thumb_pic,
                           int i_time_min,
                           int i_time_max,
                           const char *s_vip_users,
                           const char *s_rules,
                           BOOL is_internet_sheet);
          void MoveShortcut(int from,int to);
          void DelShortcut(int idx);

};


class CContent
{
          typedef std::vector<CSheet*> TSheets;
          TSheets sheets;

  public:
          CContent();
          ~CContent();

          int GetCount() const { return sheets.size(); }
          CSheet& operator [] (int idx) { return *sheets[idx]; }
          CSheet& operator [] (unsigned idx) { return *sheets[idx]; }
          const CSheet& operator [] (int idx) const { return *sheets[idx]; }
          const CSheet& operator [] (unsigned idx) const { return *sheets[idx]; }

          CSheet* FindSheetByName(const char *name) const;

  protected:
          friend class CConfig;

          void Clear();
          void AddSheet(CSheet *sh);
          void MoveSheet(int from,int to);
          void DelSheet(int idx);
};


class CSheetsGuard
{
          typedef std::vector<BOOL> TSheetsState;
          TSheetsState old_state;

  public:
          CSheetsGuard(SYSTEMTIME *_st = NULL);
          ~CSheetsGuard();

          BOOL IsStateChanged(SYSTEMTIME *_st = NULL);
};

class CSheetsGuardAutoRefresh : public CSheetsGuard
{
  public:
          CSheetsGuardAutoRefresh(SYSTEMTIME *_st = NULL);
          ~CSheetsGuardAutoRefresh();
};



BOOL IsInternetSheetPresentAndEnabled();
void AddSheetToDisableList(const char *name);
void RemoveSheetFromDisableList(const char *name);


#ifdef CFG_DLL
#define CFG_EXPORT   extern "C" __declspec(dllexport)
#define CFG_DECL __cdecl
#else
#define CFG_EXPORT 
#define CFG_DECL
#endif


CFG_EXPORT void CFG_DECL CfgReadConfig(const void *block,int block_size,int lang,int machine_type);
CFG_EXPORT void CFG_DECL CfgWriteBWCConfig();
CFG_EXPORT void* CFG_DECL CfgWriteConfig(BOOL write_vars,BOOL write_content,int *_size);
CFG_EXPORT void CFG_DECL CfgFreeBlock(void *block);


#endif

