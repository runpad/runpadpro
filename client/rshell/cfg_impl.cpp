
#include "include.h"



CCfgEntry1::CCfgEntry1()
{
  state = FALSE;
  parm = NULL;
}


CCfgEntry1::CCfgEntry1(const CCfgEntry1 &other)
{
  state = other.state;
  parm = sys_copystring_replace_empty_by_null(other.parm,sizeof(TSTRING));
}


CCfgEntry1::~CCfgEntry1()
{
  FREEANDNULL(parm);
}


CCfgEntry1& CCfgEntry1::operator = (const CCfgEntry1 &other)
{
  Load(other.state,other.parm);
  return *this;
}


void CCfgEntry1::Load(BOOL _state,const char *_parm)
{
  FREEANDNULL(parm);

  state = _state;
  parm = sys_copystring_replace_empty_by_null(_parm,sizeof(TSTRING));
}


CCfgEntry2::CCfgEntry2()
{
  state = FALSE;
  parm1 = NULL;
  parm2 = NULL;
}


CCfgEntry2::~CCfgEntry2()
{
  FREEANDNULL(parm1);
  FREEANDNULL(parm2);
}


CCfgEntry2::CCfgEntry2(const CCfgEntry2 &other)
{
  state = other.state;
  parm1 = sys_copystring_replace_empty_by_null(other.parm1,sizeof(TSTRING));
  parm2 = sys_copystring_replace_empty_by_null(other.parm2,sizeof(TSTRING));
}


CCfgEntry2& CCfgEntry2::operator = (const CCfgEntry2 &other)
{
  Load(other.state,other.parm1,other.parm2);
  return *this;
}


void CCfgEntry2::Load(BOOL _state,const char *_parm1,const char *_parm2)
{
  FREEANDNULL(parm1);
  FREEANDNULL(parm2);

  state = _state;
  parm1 = sys_copystring_replace_empty_by_null(_parm1,sizeof(TSTRING));
  parm2 = sys_copystring_replace_empty_by_null(_parm2,sizeof(TSTRING));
}



void CShortcut::InitVars()
{
  s_name = NULL;
  s_exe = NULL;
  s_arg = NULL;
  s_cwd = NULL;
  s_icon_path = NULL;
  i_icon_idx = 0;
  s_pwd = NULL;
  b_allow_only_one = TRUE;
  s_runas_domain = NULL;
  s_runas_user = NULL;
  s_runas_pwd = NULL;
  i_show_cmd = SW_SHOWNORMAL;
  i_vcd_num = -1;
  s_vcd = NULL;
  s_saver = NULL;
  s_sshot = NULL;
  s_desc = NULL;
  s_script1 = NULL;
  s_group = NULL;
  s_floatlic = NULL;
}


CShortcut::CShortcut(const char *full_path_to_file,BOOL allow_only_one)
{
  InitVars();

  b_allow_only_one = allow_only_one;
  
  if ( full_path_to_file && full_path_to_file[0] )
     {
       char s[MAX_PATH];

       lstrcpyn(s,PathFindFileName(full_path_to_file),sizeof(s));
       PathRemoveExtension(s);
       s_name = sys_copystring(s,sizeof(TSTRING));
       s_exe = sys_copystring(full_path_to_file,sizeof(TPATH));
     }
}


CShortcut::CShortcut(const char* name,const char *full_path_to_file,const char *arg,BOOL allow_only_one)
{
  InitVars();

  b_allow_only_one = allow_only_one;
  s_name = sys_copystring(name,sizeof(TSTRING));
  s_exe = sys_copystring(full_path_to_file,sizeof(TPATH));
  s_arg = sys_copystring(arg,sizeof(TSTRING));
}


CShortcut::CShortcut( const char *_name,
                     const char *_exe,
                     const char *_arg,
                     const char *_cwd,
                     const char *_icon_path,
                     int _icon_idx,
                     const char *_pwd,
                     BOOL _allow_only_one,
                     const char *_runas_domain,
                     const char *_runas_user,
                     const char *_runas_pwd,
                     int _show_cmd,
                     int _vcd_num,
                     const char *_vcd,
                     const char *_saver,
                     const char *_sshot,
                     const char *_desc,
                     const char *_script1,
                     const char *_group,
                     const char *_floatlic )
{
  s_name = sys_copystring_replace_empty_by_null(_name,sizeof(TSTRING));
  s_exe = sys_copystring_replace_empty_by_null(_exe,sizeof(TPATH));
  s_arg = sys_copystring_replace_empty_by_null(_arg,sizeof(TSTRING));
  s_cwd = sys_copystring_replace_empty_by_null(_cwd,sizeof(TPATH));
  s_icon_path = sys_copystring_replace_empty_by_null(_icon_path,sizeof(TPATH));
  i_icon_idx = _icon_idx;
  s_pwd = sys_copystring_replace_empty_by_null(_pwd,sizeof(TSTRING));
  b_allow_only_one = _allow_only_one;
  s_runas_domain = sys_copystring_replace_empty_by_null(_runas_domain,sizeof(TSTRING));
  s_runas_user = sys_copystring_replace_empty_by_null(_runas_user,sizeof(TSTRING));
  s_runas_pwd = sys_copystring_replace_empty_by_null(_runas_pwd,sizeof(TSTRING));
  i_show_cmd = _show_cmd;
  i_vcd_num = _vcd_num;
  s_vcd = sys_copystring_replace_empty_by_null(_vcd,sizeof(TPATH));
  s_saver = sys_copystring_replace_empty_by_null(_saver,sizeof(TLONGSTRING));
  s_sshot = sys_copystring_replace_empty_by_null(_sshot,sizeof(TPATH));
  s_desc = sys_copystring_replace_empty_by_null(_desc,sizeof(TLONGSTRING));
  s_script1 = sys_copystring_replace_empty_by_null(_script1,sizeof(TLONGSTRING));
  s_group = sys_copystring_replace_empty_by_null(_group,sizeof(TSTRING));
  s_floatlic = sys_copystring_replace_empty_by_null(_floatlic,sizeof(TSTRING));
}


CShortcut::~CShortcut()
{
  Free();
}


void CShortcut::LoadVarsOnly( const char *_name,
                              const char *_exe,
                              const char *_arg,
                              const char *_cwd,
                              const char *_icon_path,
                              int _icon_idx,
                              const char *_pwd,
                              BOOL _allow_only_one,
                              const char *_runas_domain,
                              const char *_runas_user,
                              const char *_runas_pwd,
                              int _show_cmd,
                              int _vcd_num,
                              const char *_vcd,
                              const char *_saver,
                              const char *_sshot,
                              const char *_desc,
                              const char *_script1,
                              const char *_group,
                              const char *_floatlic )
{
  Free();

  s_name = sys_copystring_replace_empty_by_null(_name,sizeof(TSTRING));
  s_exe = sys_copystring_replace_empty_by_null(_exe,sizeof(TPATH));
  s_arg = sys_copystring_replace_empty_by_null(_arg,sizeof(TSTRING));
  s_cwd = sys_copystring_replace_empty_by_null(_cwd,sizeof(TPATH));
  s_icon_path = sys_copystring_replace_empty_by_null(_icon_path,sizeof(TPATH));
  i_icon_idx = _icon_idx;
  s_pwd = sys_copystring_replace_empty_by_null(_pwd,sizeof(TSTRING));
  b_allow_only_one = _allow_only_one;
  s_runas_domain = sys_copystring_replace_empty_by_null(_runas_domain,sizeof(TSTRING));
  s_runas_user = sys_copystring_replace_empty_by_null(_runas_user,sizeof(TSTRING));
  s_runas_pwd = sys_copystring_replace_empty_by_null(_runas_pwd,sizeof(TSTRING));
  i_show_cmd = _show_cmd;
  i_vcd_num = _vcd_num;
  s_vcd = sys_copystring_replace_empty_by_null(_vcd,sizeof(TPATH));
  s_saver = sys_copystring_replace_empty_by_null(_saver,sizeof(TLONGSTRING));
  s_sshot = sys_copystring_replace_empty_by_null(_sshot,sizeof(TPATH));
  s_desc = sys_copystring_replace_empty_by_null(_desc,sizeof(TLONGSTRING));
  s_script1 = sys_copystring_replace_empty_by_null(_script1,sizeof(TLONGSTRING));
  s_group = sys_copystring_replace_empty_by_null(_group,sizeof(TSTRING));
  s_floatlic = sys_copystring_replace_empty_by_null(_floatlic,sizeof(TSTRING));
}


void CShortcut::Free()
{
  FREEANDNULL(s_name);
  FREEANDNULL(s_exe);
  FREEANDNULL(s_arg);
  FREEANDNULL(s_cwd);
  FREEANDNULL(s_icon_path);
  FREEANDNULL(s_pwd);
  FREEANDNULL(s_runas_domain);
  FREEANDNULL(s_runas_user);
  FREEANDNULL(s_runas_pwd);
  FREEANDNULL(s_vcd);
  FREEANDNULL(s_saver);
  FREEANDNULL(s_sshot);
  FREEANDNULL(s_desc);
  FREEANDNULL(s_script1);
  FREEANDNULL(s_group);
  FREEANDNULL(s_floatlic);

  InitVars();
}


CSheet::CSheet( const char *_name,
                const char *_icon_path,
                int _color,
                int _bg_color,
                const char *_bg_pic,
                const char *_bg_thumb_pic,
                int _time_min,
                int _time_max,
                const char *_vip_users,
                const char *_rules,
                BOOL _internet_sheet )
{
  s_name = sys_copystring_replace_empty_by_null(_name,sizeof(TSTRING));
  s_icon_path = sys_copystring_replace_empty_by_null(_icon_path,sizeof(TPATH));
  i_color = _color;
  i_bg_color = _bg_color;
  s_bg_pic = sys_copystring_replace_empty_by_null(_bg_pic,sizeof(TPATH));
  s_bg_thumb_pic = sys_copystring_replace_empty_by_null(_bg_thumb_pic,sizeof(TPATH));
  i_time_min = _time_min;
  i_time_max = _time_max;
  s_vip_users = sys_copystring_replace_empty_by_null(_vip_users,sizeof(TSTRING));
  s_rules = sys_copystring_replace_empty_by_null(_rules,sizeof(TPATH));
  is_internet_sheet = _internet_sheet;
}


CSheet::~CSheet()
{
  FREEANDNULL(s_name);
  FREEANDNULL(s_icon_path);
  FREEANDNULL(s_bg_pic);
  FREEANDNULL(s_bg_thumb_pic);
  FREEANDNULL(s_vip_users);
  FREEANDNULL(s_rules);

  for ( int n = 0; n < shortcuts.size(); n++ )
      {
        if ( shortcuts[n] )
           {
             delete shortcuts[n];
             shortcuts[n] = NULL;
           }
      }

  shortcuts.clear();
}


void CSheet::LoadVarsOnly(const char *_name,
                         const char *_icon_path,
                         int _color,
                         int _bg_color,
                         const char *_bg_pic,
                         const char *_bg_thumb_pic,
                         int _time_min,
                         int _time_max,
                         const char *_vip_users,
                         const char *_rules,
                         BOOL _internet_sheet)
{
  FREEANDNULL(s_name);
  FREEANDNULL(s_icon_path);
  FREEANDNULL(s_bg_pic);
  FREEANDNULL(s_bg_thumb_pic);
  FREEANDNULL(s_vip_users);
  FREEANDNULL(s_rules);

  s_name = sys_copystring_replace_empty_by_null(_name,sizeof(TSTRING));
  s_icon_path = sys_copystring_replace_empty_by_null(_icon_path,sizeof(TPATH));
  i_color = _color;
  i_bg_color = _bg_color;
  s_bg_pic = sys_copystring_replace_empty_by_null(_bg_pic,sizeof(TPATH));
  s_bg_thumb_pic = sys_copystring_replace_empty_by_null(_bg_thumb_pic,sizeof(TPATH));
  i_time_min = _time_min;
  i_time_max = _time_max;
  s_vip_users = sys_copystring_replace_empty_by_null(_vip_users,sizeof(TSTRING));
  s_rules = sys_copystring_replace_empty_by_null(_rules,sizeof(TPATH));
  is_internet_sheet = _internet_sheet;
}


CShortcut* CSheet::FindShortcutByName(const char *name)
{
  CShortcut *out = NULL;
  
  if ( name && name[0] )
     {
       for ( int n = 0; n < GetCount(); n++ )
           {
             if ( !lstrcmpi(shortcuts[n]->GetName(),name) )
                {
                  out = shortcuts[n];
                  break;
                }
           }
     }

  return out;
}


void CSheet::AddShortcut(CShortcut *shortcut)
{
  if ( shortcut )
     {
       shortcuts.push_back(shortcut);
     }
}


void CSheet::MoveShortcut(int from,int to)
{
  if ( from != to )
     {
       if ( (from >= 0 && from < GetCount()) && (to >= 0 && to < GetCount()) )
          {
            CShortcut *s_from = shortcuts[from];
            CShortcut *s_to = shortcuts[to];
            shortcuts[from] = s_to;
            shortcuts[to] = s_from;
          }
     }
}


void CSheet::DelShortcut(int idx)
{
  if ( idx >= 0 && idx < GetCount() )
     {
       TShortcuts::iterator it = shortcuts.begin();
       
       for ( int n = 0; n < idx; n++, ++it )
           {
           }

       delete *it;
       shortcuts.erase(it);
     }
}


CContent::CContent()
{
}


CContent::~CContent()
{
  Clear();
}


CSheet* CContent::FindSheetByName(const char *name) const
{
  CSheet *out = NULL;
  
  if ( name && name[0] )
     {
       for ( int n = 0; n < GetCount(); n++ )
           {
             if ( !lstrcmpi(sheets[n]->GetName(),name) )
                {
                  out = sheets[n];
                  break;
                }
           }
     }

  return out;
}


void CContent::Clear()
{
  for ( int n = 0; n < GetCount(); n++ )
      {
        if ( sheets[n] )
           {
             delete sheets[n];
             sheets[n] = NULL;
           }
      }

  sheets.clear();
}


void CContent::AddSheet(CSheet *sh)
{
  if ( sh )
     {
       sheets.push_back(sh);
     }
}


void CContent::MoveSheet(int from,int to)
{
  if ( from != to )
     {
       if ( (from >= 0 && from < GetCount()) && (to >= 0 && to < GetCount()) )
          {
            CSheet *s_from = sheets[from];
            CSheet *s_to = sheets[to];
            sheets[from] = s_to;
            sheets[to] = s_from;
          }
     }
}


void CContent::DelSheet(int idx)
{
  if ( idx >= 0 && idx < GetCount() )
     {
       TSheets::iterator it = sheets.begin();
       
       for ( int n = 0; n < idx; n++, ++it )
           {
           }

       delete *it;
       sheets.erase(it);
     }
}

