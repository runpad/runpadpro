
#include "include.h"
#include <vector>


// disabled from API sheets
class CDisabledSheets
{
          typedef std::vector<const char*> TSheets;
          TSheets sheets;

  public:
          CDisabledSheets();
          ~CDisabledSheets();

          void DisableSheet(const char *name); //pass NULL to disable all
          void EnableSheet(const char *name); //pass NULL to enable all
          BOOL IsDisabled(const char *name);

  private:
          void ClearList();
};

CDisabledSheets::CDisabledSheets()
{

}

CDisabledSheets::~CDisabledSheets()
{
  ClearList();
}

void CDisabledSheets::ClearList()
{
  for ( int n = 0; n < sheets.size(); n++ )
      {
        char *s = (char*)sheets[n];
        sys_free(s);
        sheets[n] = NULL;
      }

  sheets.clear();
}

void CDisabledSheets::DisableSheet(const char *name)
{
  if ( name && name[0] )
     {
       BOOL find = FALSE;
       
       for ( int n = 0; n < sheets.size(); n++ )
           {
             if ( !lstrcmpi(sheets[n],name) )
                {
                  find = TRUE;
                  break;
                }
           }

       if ( !find )
          {
            char *s = (char*)sys_alloc(lstrlen(name)+1);
            lstrcpy(s,name);
            sheets.push_back(s);
          }
     }
  else
     {
       for ( int n = 0; n < g_content.GetCount(); n++ )
           {
             const char *name = g_content[n].GetName();

             if ( name && name[0] )
                {
                  DisableSheet(name);
                }
           }
     }
}

void CDisabledSheets::EnableSheet(const char *name)
{
  if ( name && name[0] )
     {
       for ( TSheets::iterator it = sheets.begin(); it != sheets.end(); ++it )
           {
             if ( !lstrcmpi(*it,name) )
                {
                  char *s = (char*)*it;
                  sys_free(s);
                  sheets.erase(it);
                  break;
                }
           }
     }
  else
     {
       ClearList();
     }
}

BOOL CDisabledSheets::IsDisabled(const char *name)
{
  BOOL rc = FALSE;

  if ( name && name[0] )
     {
       for ( int n = 0; n < sheets.size(); n++ )
           {
             if ( !lstrcmpi(sheets[n],name) )
                {
                  rc = TRUE;
                  break;
                }
           }
     }

  return rc;
}


static CDisabledSheets g_disabled_sheets; //global object


void AddSheetToDisableList(const char *name)
{
  g_disabled_sheets.DisableSheet(name);
}


void RemoveSheetFromDisableList(const char *name)
{
  g_disabled_sheets.EnableSheet(name);
}


BOOL CSheet::IsCurrentlyEnabled(SYSTEMTIME *_st) const
{
  // check in API-disabled list
  if ( g_disabled_sheets.IsDisabled(GetName()) )
     return FALSE;

  // check VIP-session
  const char *vip = GetVIPUsers();
  if ( vip[0] )
     {
       if ( !vip_session[0] )
          {
            return FALSE;
          }
       else
          {
            if ( vip[0] != '*' )
               {
                 if ( !IsExtensionInList(vip_session,vip) )
                    {
                      return FALSE;
                    }
               }
          }
     }

  // check time-sheet
  int t1 = GetTimeMin();
  int t2 = GetTimeMax();
  if ( t1 >= 0 && t1 <= 24 && t2 >= 0 && t2 <= 24 )
     {
       SYSTEMTIME st;
       if ( _st )
          {
            st = *_st;
          }
       else
          {
            GetLocalTime(&st);
          }
       int t = st.wHour;

       if ( t1 < t2 )
          {
            if ( t < t1 || t >= t2 )
               {
                 return FALSE;
               }
          }
       else
       if ( t1 > t2 )
          {
            if ( t < t1 && t >= t2 )
               {
                 return FALSE;
               }
          }
       else
          {
            return FALSE;
          }
     }

  return TRUE;
}



CSheetsGuard::CSheetsGuard(SYSTEMTIME *_st)
{
  SYSTEMTIME st;
  if ( _st )
     {
       st = *_st;
     }
  else
     {
       GetLocalTime(&st);
     }
  
  for ( int n = 0; n < g_content.GetCount(); n++ )
      {
        old_state.push_back(g_content[n].IsCurrentlyEnabled(&st));
      }
}

CSheetsGuard::~CSheetsGuard()
{
}

BOOL CSheetsGuard::IsStateChanged(SYSTEMTIME *_st)
{
  BOOL rc = FALSE;
  
  if ( old_state.size() == g_content.GetCount() )
     {
       SYSTEMTIME st;
       if ( _st )
          {
            st = *_st;
          }
       else
          {
            GetLocalTime(&st);
          }
       
       for ( int n = 0; n < g_content.GetCount(); n++ )
           {
             const BOOL b1 = g_content[n].IsCurrentlyEnabled(&st) ? TRUE : FALSE;
             const BOOL b2 = old_state[n] ? TRUE : FALSE;
             
             if ( b1 != b2 )
                {
                  rc = TRUE;
                  break;
                }
           }
     }
  else
     {
       rc = TRUE;  //must be never happens!
     }

  return rc;
}

CSheetsGuardAutoRefresh::CSheetsGuardAutoRefresh(SYSTEMTIME *_st) : CSheetsGuard(_st)
{
}

CSheetsGuardAutoRefresh::~CSheetsGuardAutoRefresh()
{
  if ( IsStateChanged() )
     {
       ::GlobalOnSheetsStateChanged();
     }
}


BOOL IsInternetSheetPresentAndEnabled()
{
  BOOL rc = FALSE;

  for ( int n = 0; n < g_content.GetCount(); n++ )
      {
        if ( g_content[n].IsInternetSheet() && g_content[n].IsCurrentlyEnabled() )
           {
             rc = TRUE;
             break;
           }
      }

  return rc;
}


CRealShortcut::CRealShortcut(const CShortcut& shortcut)
{
  m_shortcut = &shortcut;

  s_exe = NULL;
  s_arg = NULL;
  s_cwd = NULL;
  s_icon_path = NULL;
  i_icon_idx = 0;
  s_vcd = NULL;
  s_sshot = NULL;

  if ( m_shortcut )
     {
       char l_exe[MAX_PATH] = "";
       char l_arg[MAX_PATH] = "";
       char l_cwd[MAX_PATH] = "";
       char l_icon_path[MAX_PATH] = "";
       int l_icon_idx = 0;

       BOOL is_url = PathIsURL(m_shortcut->GetExePath());

       if ( !is_url )
          {
            char s[MAX_PATH];
            ExpandPath(m_shortcut->GetExePath(),s);
            const char *src_ext = PathFindExtension(s);
            if ( !lstrcmpi(src_ext,".lnk") || !lstrcmpi(src_ext,".pif") )
               {
                 GetLnkFileInfo(s,l_exe,NULL,l_arg,l_cwd,NULL,l_icon_path,&l_icon_idx,FALSE/*!!!*/);
               }
          }

       if ( !l_exe[0] )
          lstrcpy(l_exe,m_shortcut->GetExePath());
       if ( !l_arg[0] )
          lstrcpy(l_arg,m_shortcut->GetArg());
       if ( !l_cwd[0] )
          lstrcpy(l_cwd,m_shortcut->GetCWD());
       if ( !l_icon_path[0] )
          {
            lstrcpy(l_icon_path,m_shortcut->GetIconPath());
            l_icon_idx = m_shortcut->GetIconIdx();
          }

       ExpandPath(l_exe);
       ExpandPath(l_cwd);
       ExpandPath(l_icon_path);

       DoEnvironmentSubst(l_arg,sizeof(l_arg));  // needed

       if ( !l_cwd[0] && !is_url )
          GetDirFromPath(l_exe,l_cwd);

       s_exe = sys_copystring(l_exe);
       s_arg = sys_copystring(l_arg);
       s_cwd = sys_copystring(l_cwd);
       s_icon_path = sys_copystring(l_icon_path);
       i_icon_idx = l_icon_idx;

       s_vcd = sys_copystring(CPathExpander(m_shortcut->GetVCDPath()));
       s_sshot = sys_copystring(CPathExpander(m_shortcut->GetSShotPath()));
     }
}


CRealShortcut::~CRealShortcut()
{
  if ( s_exe )
     sys_free(s_exe);
  if ( s_arg )
     sys_free(s_arg);
  if ( s_cwd )
     sys_free(s_cwd);
  if ( s_icon_path )
     sys_free(s_icon_path);
  if ( s_vcd )
     sys_free(s_vcd);
  if ( s_sshot )
     sys_free(s_sshot);
}


BOOL CRealShortcut::IsEmptyShortcut(BOOL use_icon_path) const
{
  const char *target = GetExePath();

  if ( IsStrEmpty(target) )
     return TRUE;

  if ( PathIsURL(target) )
     return FALSE;

  if ( IsEmptyShortcutInternal(target) )
     {
       return TRUE;
     }
  else
     {
       const char *ic = GetIconPath();
       
       if ( !use_icon_path || IsStrEmpty(ic) )
          {
            return FALSE;
          }
       else
          {
            return IsEmptyShortcutInternal(ic);
          }
     }
}


BOOL CRealShortcut::IsEmptyShortcutInternal(const char *target)
{
  if ( lstrlen(target) < 2 )
     return TRUE;

  if ( ((target[0] >= 'a' && target[0] <= 'z') || (target[0] >= 'A' && target[0] <= 'Z')) && target[1] == ':' )
     {
       char drive[8];

       drive[0] = target[0];
       drive[1] = ':';
       drive[2] = '\\';
       drive[3] = 0;

       UINT dtype = GetDriveType(drive);
       
       if ( dtype != DRIVE_CDROM && //for VCD needed
            dtype != DRIVE_REMOTE ) 
          {
            CDisableWOW64FSRedirection g;
            
            if ( !IsFileExist(target) )
               {
                 return TRUE;
               }
          }
     }
  else
  if ( target[0] == '\\' && target[1] == '\\' )
     {
       //assume that net-shortcuts are not empty!
     }
  else
     {
       return TRUE;
     }

  return FALSE;
}


void CSheet::GetRealBGThumbPicPathFast(char *out)
{
  out[0] = 0;
  
  const char *in = GetBGThumbPath();

  //if ( IsStrEmpty(in) )
  //   {
  //     in = GetBGPath();
  //   }

  if ( !IsStrEmpty(in) )
     {
       char s[MAX_PATH] = "";
       
       ExpandPath(in,s);
       
       if ( PathIsURL(s) )
          {
            lstrcpy(out,s);   // supported only in HTML-schemes!
          }
       else
          {
            char filename[MAX_PATH] = "";
            
            const char *ext = PathFindExtension(s);
            if ( !lstrcmpi(ext,".bmp") || 
                 !lstrcmpi(ext,".jpg") || 
                 !lstrcmpi(ext,".jpe") || 
                 !lstrcmpi(ext,".jpeg") || 
                 !lstrcmpi(ext,".png") || 
                 !lstrcmpi(ext,".gif") )
               {
                 lstrcpy(filename,s);
               }

            lstrcpy(out,filename);
          }
     }
}


