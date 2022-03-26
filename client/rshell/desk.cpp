
#include "include.h"



static void __cdecl D_OnError(const char *err_text)
{
  if ( !err_text )
     err_text = "";
  
  char filename[MAX_PATH] = "";
  GetErrLogFileName(filename);
  WriteFullFile(filename,err_text,lstrlen(err_text));

  if ( !dont_show_theme_errors )
     {
       char s[MAX_PATH*2];
       wsprintf(s,STR_010,filename);
       
       BalloonNotify(NIIF_WARNING,LS(LS_WARNING),s,15);
     }
}

static void __cdecl D_OnRClick()
{
  SheetsSelectPopup();
}

static void __cdecl D_OnMouseDown()
{
  WorkSpaceOnDeskMouseDown();
}

static const char* __cdecl D_GetMachineLoc()
{
  return machine_loc;
}

static const char* __cdecl D_GetMachineDesc()
{
  return machine_desc;
}

static const char* __cdecl D_GetVipSessionName()
{
  return vip_session;
}

static const char* __cdecl D_GetStatusString()
{
  return ExpandStatusText(html_status_text1);
}

static const char* __cdecl D_GetInfoText()
{
  static char s[8192];
  static BOOL first = TRUE;

  if ( first )  // optimization, but must be reloaded when config changed or theme re-navigated
     {
       first = FALSE;
       
       s[0] = 0;
       LoadTextFromDescriptionToken(html_status_text2,s,sizeof(s));
     }

  return s;
}

static int __cdecl D_GetNumSheets()
{
  int count = 0;

  SYSTEMTIME st;
  GetLocalTime(&st);

  for ( int n = 0; n < g_content.GetCount(); n++ )
      if ( g_content[n].IsCurrentlyEnabled(&st) )
         count++;

  return count;
}

static const char* __cdecl D_GetSheetName(int idx)
{
  int real_idx = 0;

  SYSTEMTIME st;
  GetLocalTime(&st);

  for ( int n = 0; n < g_content.GetCount(); n++ )
      if ( g_content[n].IsCurrentlyEnabled(&st) )
         {
           if ( real_idx == idx )
              {
                return g_content[n].GetName();
              }
           
           real_idx++;
         }

  return "";
}

static BOOL __cdecl D_IsSheetActive(int idx)
{
  int real_idx = 0;

  SYSTEMTIME st;
  GetLocalTime(&st);

  for ( int n = 0; n < g_content.GetCount(); n++ )
      if ( g_content[n].IsCurrentlyEnabled(&st) )
         {
           if ( real_idx == idx )
              {
                return GetActiveSheet() == &g_content[n];
              }
           
           real_idx++;
         }

  return FALSE;
}

static void __cdecl D_SetSheetActive(int idx, BOOL active)
{
  PostMessage(GetMainWnd(),RS_SETSHEETACTIVEBYIDX,idx,active);
}

static const char* __cdecl D_GetSheetBGPic(int idx)
{
  int real_idx = 0;

  SYSTEMTIME st;
  GetLocalTime(&st);

  for ( int n = 0; n < g_content.GetCount(); n++ )
      if ( g_content[n].IsCurrentlyEnabled(&st) )
         {
           if ( real_idx == idx )
              {
                static char filename[MAX_PATH];
                
                filename[0] = 0;
                g_content[n].GetRealBGThumbPicPathFast(filename);

                return filename;
              }
           
           real_idx++;
         }

  return "";
}


static BOOL __cdecl D_IsPageShaded()
{
  if ( !use_desk_shader || !CanUseGFX() )
     return FALSE;

  HWND w = GetActiveSheetWindowHandle();

  if ( w && IsWindow(w) && IsWindowVisible(w) && !IsIconic(w) )
     return TRUE;

  return FALSE;
}


static BOOL __cdecl D_IsWaitCursor()
{
  return CWaitCursor::IsWaitCursor();
}


static BOOL __cdecl D_CanUseGFX()
{
  return CanUseGFX();
}


static void __cdecl D_DoShellExec(const char *_exe,const char *args)
{
  if ( !IsStrEmpty(_exe) )
     {
       if ( PathIsURL(_exe) )
          {
            ShellExecute(NULL,NULL,_exe,NULL,NULL,SW_SHOWNORMAL);
          }
       else
          {
            char exe[MAX_PATH] = "";
            lstrcpyn(exe,_exe,MAX_PATH);
            StrReplaceI(exe,"/","\\");
            DoEnvironmentSubst(exe,MAX_PATH);

            char cwd[MAX_PATH] = "";
            lstrcpy(cwd,exe);
            PathRemoveFileSpec(cwd);

            ShellExecute(NULL,NULL,exe,IsStrEmpty(args)?NULL:args,cwd,SW_SHOWNORMAL);
          }
     }
}


static const char* __cdecl D_GetInputText(const char *title,const char *text)
{
  return GetString(title,text,0,1000,"");
}


static void __cdecl D_Alert(const char *text)
{
  WarnBox(text);
}


static const char* __cdecl D_GetInputTextPos(char pwdchar,int x,int y,int w,int h,int maxlen,const char *text)
{
  static char out[1001];

  maxlen = MIN(maxlen,sizeof(out)-1);
  maxlen = MAX(maxlen,1);

  out[0] = 0;

  if ( !GetInputTextPos(GetMainWnd(),pwdchar,x,y,w,h,maxlen,text,out) )
     {
       lstrcpyn(out,NNS(text),sizeof(out));
     }
  
  return out;
}



// !!!!!!!!!!!!
// must be changed in rshell.dll, ALL PLUGINS and plugin's test program too!!!!!
static const struct {
   void (__cdecl *OnError)(const char *err_text);
   void (__cdecl *OnRClick)();
   void (__cdecl *OnMouseDown)();
   const char* (__cdecl *GetMachineLoc)();
   const char* (__cdecl *GetMachineDesc)();
   const char* (__cdecl *GetVipSessionName)();
   const char* (__cdecl *GetStatusString)();
   const char* (__cdecl *GetInfoText)();
   int (__cdecl *GetNumSheets)();
   const char* (__cdecl *GetSheetName)(int idx);
   BOOL (__cdecl *IsSheetActive)(int idx);
   void (__cdecl *SetSheetActive)(int idx, BOOL active);
   const char* (__cdecl *GetSheetBGPic)(int idx);
   BOOL (__cdecl *IsPageShaded)();
   BOOL (__cdecl *IsWaitCursor)();
   BOOL (__cdecl *CanUseGFX)();
   void (__cdecl *DoShellExec)(const char *exe,const char *args);
   const char* (__cdecl *GetInputText)(const char *title,const char *text);
   void (__cdecl *Alert)(const char *text);
   const char* (__cdecl *GetInputTextPos)(char pwdchar,int x,int y,int w,int h,int maxlen,const char *text);
} g_desk_conn_table =
{
   D_OnError,
   D_OnRClick,
   D_OnMouseDown,
   D_GetMachineLoc,
   D_GetMachineDesc,
   D_GetVipSessionName,
   D_GetStatusString,
   D_GetInfoText,
   D_GetNumSheets,
   D_GetSheetName,
   D_IsSheetActive,
   D_SetSheetActive,
   D_GetSheetBGPic,
   D_IsPageShaded,
   D_IsWaitCursor,
   D_CanUseGFX,
   D_DoShellExec,
   D_GetInputText,
   D_Alert,
   D_GetInputTextPos,
};


CDesk::CDesk(HWND main_window)
{
  w_main = main_window;
  w_desk = Desk_Create((void*)&g_desk_conn_table,CPathExpander(curr_desktop_theme));
}


CDesk::~CDesk()
{
  Desk_Destroy();
}


HWND CDesk::GetWindow()
{
  return w_desk;
}


BOOL CDesk::IsVisible(void)
{
  return Desk_IsVisible();
}


void CDesk::Hide(void)
{
  Desk_Hide();
}


void CDesk::Show(void)
{
  Desk_Show();
}


void CDesk::Repaint(void)
{
  Desk_Repaint();
}


void CDesk::Refresh(void)
{
  Desk_Refresh();
}


void CDesk::BringToBottom(void)
{
  Desk_BringToBottom();
}


void CDesk::OnConfigChange(void)
{
  Desk_Navigate(CPathExpander(curr_desktop_theme));
}


void CDesk::OnDisplayChange(int sw,int sh)
{
  Desk_OnDisplayChange();
}


void CDesk::OnTimer(void)
{
}


void CDesk::OnEndSession()
{
  Desk_OnEndSession();
}


void CDesk::OnStatusStringChanged()
{
  Desk_OnStatusStringChanged();
}


void CDesk::OnActiveSheetChanged()
{
  Desk_OnActiveSheetChanged();
}


void CDesk::OnPageShaded()
{
  Desk_OnPageShaded();
}

