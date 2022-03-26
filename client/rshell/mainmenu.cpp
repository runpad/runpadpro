
#include "include.h"



CMainMenu::CScreenPart::CScreenPart(const RECT *r)
{
  CopyRect(&rect,r);
  ZeroMemory(&buff,sizeof(buff));

  if ( !IsRectEmpty(&rect) )
     {
       int w = rect.right - rect.left;
       int h = rect.bottom - rect.top;

       if ( w > 0 && h > 0 )
          {
            RB_CreateNormal(&buff,w,h);

            HDC screen_hdc = GetDC(NULL);
            BitBlt(buff.hdc,0,0,w,h,screen_hdc,rect.left,rect.top,SRCCOPY);
            ReleaseDC(NULL,screen_hdc);
          }
     }
}

CMainMenu::CScreenPart::~CScreenPart()
{
  RB_Destroy(&buff);
}

BOOL CMainMenu::CScreenPart::IsOurRect(const RECT *r) const
{
  return EqualRect(&rect,r);
}

HDC CMainMenu::CScreenPart::GetHDC() const
{
  return buff.hdc;
}


static const float menu_hgrad_gamma = 1.80;
static const float menu_sel_gamma = 0.88;


class CODItem
{
  public:
           virtual ~CODItem() {}
           
           virtual void Measure(int *_w,int *_h) = 0;
           virtual void Draw(int item_state,RBUFF *buff,HDC screen_hdc,int screen_x,int screen_y) = 0;
           virtual void Execute() = 0;
};

class CODItemSmall : public CODItem
{
  public:
           virtual void Measure(int *_w,int *_h);
           virtual void Draw(int item_state,RBUFF *buff,HDC screen_hdc,int screen_x,int screen_y);

  private:
           virtual HICON GetIcon() = 0;
           virtual const char* GetText() = 0;
};

class CODItemBig : public CODItem
{
  public:
           virtual void Measure(int *_w,int *_h);
           virtual void Draw(int item_state,RBUFF *buff,HDC screen_hdc,int screen_x,int screen_y);

  private:
           virtual HICON GetIcon() = 0;
           virtual const char* GetText() = 0;
};

class CODItemBigSeparator : public CODItem
{
  public:
           CODItemBigSeparator() {}
           virtual ~CODItemBigSeparator() {}
           
           virtual void Measure(int *_w,int *_h);
           virtual void Draw(int item_state,RBUFF *buff,HDC screen_hdc,int screen_x,int screen_y);
           virtual void Execute();
};

class CODItemMain : public CODItemBig
{
           HICON icon;
           int m_idx;
  
  public:
           CODItemMain(int idx);
           virtual ~CODItemMain();
           
           virtual void Execute();

  private:
           virtual HICON GetIcon();
           virtual const char* GetText();
};

class CODItemShortcut : public CODItemSmall
{
           HICON icon;
           BOOL b_allow_execute;
           const CShortcut *m_shortcut;
           const CSheet *m_sheet;
  
  public:
           CODItemShortcut(const CSheet *sheet,const CShortcut *shortcut,BOOL allow_execute);
           virtual ~CODItemShortcut();
           
           virtual void Execute();

  private:
           virtual HICON GetIcon();
           virtual const char* GetText();
};

class CODItemSheet : public CODItemSmall
{
           HICON icon;
           const CSheet *m_sheet;
  
  public:
           CODItemSheet(const CSheet *sheet);
           virtual ~CODItemSheet();
           
           virtual void Execute();

  private:
           virtual HICON GetIcon();
           virtual const char* GetText();
};

class CODItemUserTool : public CODItemBig
{
           const CQLItem *m_item;
  
  public:
           CODItemUserTool(const CQLItem *item);
           virtual ~CODItemUserTool();
           
           virtual void Execute();

  private:
           virtual HICON GetIcon();
           virtual const char* GetText();
};

void CODItemSmall::Measure(int *_w,int *_h)
{
  SIZE size;
  size.cx = size.cy = 0;

  const char *text = GetText();
  if ( text && text[0] )
     {
       HDC hdc = CreateCompatibleDC(NULL);
       HFONT font = CreateFont(-11,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Tahoma");
       HFONT oldfont = (HFONT)SelectObject(hdc,font);
       GetTextExtentPoint32(hdc,text,lstrlen(text),&size);
       SelectObject(hdc,oldfont);
       DeleteObject(font);
       DeleteDC(hdc);
     }

  size.cx += 4+16+10+15;
  size.cy = 16+2;

  *_w = size.cx;
  *_h = size.cy;
}

void CODItemSmall::Draw(int item_state,RBUFF *buff,HDC screen_hdc,int screen_x,int screen_y)
{
  BOOL is_selected = item_state & ODS_SELECTED;
  int menu_color = theme.menu;
  int bg_color = is_selected ? Gamma(menu_color,menu_sel_gamma) : menu_color;
  int text_color = GetFGColor(bg_color);

  int w = buff->w;
  int h = buff->h;

  RB_HGradient32(buff,bg_color,Gamma(bg_color,menu_hgrad_gamma));
  
  if ( is_selected )
     {
       RECT r;
       SetRect(&r,0,0,w,h);
       DrawIconHLInternal(buff->hdc,&r,100);
     }
  
  HICON icon = GetIcon();
  if ( icon )
     DrawIconEx(buff->hdc,4,(h-16)/2,icon,16,16,0,NULL,DI_NORMAL);

  const char *text = GetText();
  if ( text && text[0] )
     {
       HFONT font = CreateFont(-11,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Tahoma");
       HFONT oldfont = (HFONT)SelectObject(buff->hdc,font);
       SetBkMode(buff->hdc,TRANSPARENT);
       SetTextColor(buff->hdc,text_color);
       RECT lr;
       SetRect(&lr,4+16+10,0,w,h);
       //if ( is_selected )
       //   DrawTextWithShadow(buff->hdc,text,&lr,DT_LEFT | DT_VCENTER | DT_SINGLELINE,0,2);
       //else
          DrawText(buff->hdc,text,-1,&lr,DT_LEFT | DT_VCENTER | DT_SINGLELINE);
       SelectObject(buff->hdc,oldfont);
       DeleteObject(font);
     }
}

void CODItemBig::Measure(int *_w,int *_h)
{
  SIZE size;
  size.cx = size.cy = 0;

  const char *text = GetText();
  if ( text && text[0] )
     {
       HDC hdc = CreateCompatibleDC(NULL);
       HFONT font = CreateFont(-11,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Tahoma");
       HFONT oldfont = (HFONT)SelectObject(hdc,font);
       GetTextExtentPoint32(hdc,text,lstrlen(text),&size);
       SelectObject(hdc,oldfont);
       DeleteObject(font);
       DeleteDC(hdc);
     }

  size.cx += 4+32+10+15;
  size.cy = 32+8;

  *_w = size.cx;
  *_h = size.cy;
}

void CODItemBig::Draw(int item_state,RBUFF *buff,HDC screen_hdc,int screen_x,int screen_y)
{
  BOOL is_selected = item_state & ODS_SELECTED;
  int menu_color = theme.menu;
  int bg_color = is_selected ? Gamma(menu_color,menu_sel_gamma) : menu_color;
  int text_color = GetFGColor(bg_color);

  int w = buff->w;
  int h = buff->h;

  RB_HGradient32(buff,bg_color,Gamma(bg_color,menu_hgrad_gamma));

  if ( screen_hdc )
     MakeTransparent(buff->hdc,screen_hdc,0,0,screen_x,screen_y,w,h,200);

  if ( is_selected )
     {
       RECT r;
       SetRect(&r,0,0,w,h);
       DrawIconHLInternal(buff->hdc,&r,100);
     }
  
  HICON icon = GetIcon();
  if ( icon )
     DrawIconEx(buff->hdc,4,(h-32)/2,icon,32,32,0,NULL,DI_NORMAL);

  const char *text = GetText();
  if ( text && text[0] )
     {
       HFONT font = CreateFont(-11,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Tahoma");
       HFONT oldfont = (HFONT)SelectObject(buff->hdc,font);
       SetBkMode(buff->hdc,TRANSPARENT);
       SetTextColor(buff->hdc,text_color);
       RECT lr;
       SetRect(&lr,4+32+10,0,w,h);
       //if ( is_selected )
       //   DrawTextWithShadow(buff->hdc,text,&lr,DT_LEFT | DT_VCENTER | DT_SINGLELINE,0,2);
       //else
          DrawText(buff->hdc,text,-1,&lr,DT_LEFT | DT_VCENTER | DT_SINGLELINE);
       SelectObject(buff->hdc,oldfont);
       DeleteObject(font);
     }
}

void CODItemBigSeparator::Measure(int *_w,int *_h)
{
  *_w = 1;
  *_h = 7;
}

void CODItemBigSeparator::Draw(int item_state,RBUFF *buff,HDC screen_hdc,int screen_x,int screen_y)
{
  int menu_color = theme.menu;
  int bg_color = menu_color;
  int fg_color = GetFGColor(bg_color);

  int w = buff->w;
  int h = buff->h;

  RB_HGradient32(buff,bg_color,Gamma(bg_color,menu_hgrad_gamma));

  if ( screen_hdc )
     MakeTransparent(buff->hdc,screen_hdc,0,0,screen_x,screen_y,w,h,200/*ALPHA*/);
  
  RECT lr;
  lr.left = 0;
  lr.right = w;
  lr.top = h/2;
  lr.bottom = lr.top+1;
  
  HBRUSH brush = CreateSolidBrush(fg_color);
  FillRect(buff->hdc,&lr,brush);
  DeleteObject(brush);
}

void CODItemBigSeparator::Execute()
{
}


enum {
IDM_VIPBEGIN  ,
IDM_VIPEND    ,
IDM_SHOWGCINFO,
IDM_CALLADMIN ,
IDM_OFFERSBOOK,
IDM_MONITOROFF,
IDM_RESTORE   ,
IDM_MYCOMPUTER,
IDM_CONTENT   ,
IDM_USERTOOLS ,
IDM_LOGOFF    ,
IDM_REBOOT    ,
IDM_SHUTDOWN  ,
IDM_ENDWORK   ,
};

typedef struct {
int icon_idx;
int lang_id;
void(*func)();
int id;
} MAINMENUITEM;

static const MAINMENUITEM mmitems[] =
{
  {10, 3053, M_Vipsession, IDM_VIPBEGIN     },
  {9,  3054, M_Vipsession, IDM_VIPEND       },
  {0,  3055, M_Showgcinfo, IDM_SHOWGCINFO   },
  {1,  3056, M_Calladmin,  IDM_CALLADMIN    },
  {11, 3057, M_Offersbook, IDM_OFFERSBOOK   },
  {8,  3058, M_Monitoroff, IDM_MONITOROFF   },
  {2,  3059, M_Restore,    IDM_RESTORE      },
  {3,  3060, M_Mycomp,     IDM_MYCOMPUTER   },
  {4,  3061, NULL,         IDM_CONTENT      }, //popup
  {4,  3062, NULL,         IDM_USERTOOLS    }, //popup
  {5,  3063, M_Logoff,     IDM_LOGOFF       },
  {6,  3064, M_Reboot,     IDM_REBOOT       },
  {7,  3065, M_Shutdown,   IDM_SHUTDOWN     },
  {7,  3066, NULL,         IDM_ENDWORK      }, //popup
};


void ExecMainMenuItem(int idx)
{
  CMainMenu::ExecMainMenuItem(idx);
}


void CMainMenu::ExecMainMenuItem(int idx)
{
  if ( idx >= 0 && idx < sizeof(mmitems)/sizeof(mmitems[0]) )
     {
       if ( mmitems[idx].func )
          {
            mmitems[idx].func();
          }
     }
}


CODItemMain::CODItemMain(int idx)
{
  if ( idx < 0 || idx >= sizeof(mmitems)/sizeof(mmitems[0]) )
     idx = 0;
  
  m_idx = idx;

  int res_idx = IDI_ODBASE + Get2DTheme()->icons_pack * 100 + mmitems[idx].icon_idx;
  icon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(res_idx),IMAGE_ICON,32,32,LR_SHARED);
}

CODItemMain::~CODItemMain()
{
}

HICON CODItemMain::GetIcon()
{
  return icon;
}

const char* CODItemMain::GetText()
{
  return LS(mmitems[m_idx].lang_id);
}

void CODItemMain::Execute()
{
  PostMessage(GetMainWnd(),RS_EXECMAINMENUITEM,m_idx,0);
}


CODItemShortcut::CODItemShortcut(const CSheet *sheet,const CShortcut *shortcut,BOOL allow_execute)
{
  m_sheet = sheet;
  m_shortcut = shortcut;
  b_allow_execute = allow_execute;
  icon = NULL;
}

CODItemShortcut::~CODItemShortcut()
{
  if ( icon )
     DestroyIcon(icon);
}

void CODItemShortcut::Execute()
{
  if ( b_allow_execute )
     {
       PostMessage(GetMainWnd(),RS_RUNPROGRAMINTERNAL,(WPARAM)m_shortcut,(LPARAM)m_sheet);
     }
  else
     {
       PostMessage(GetMainWnd(),RS_MESSAGE,(WPARAM)(LS(3052)),0);
     }
}

HICON CODItemShortcut::GetIcon()
{
  if ( !icon )
     {
       CRealShortcut rsh(*m_shortcut);
       
       if ( !PathIsURL(rsh.GetExePath()) )
          {
            if ( !IsStrEmpty(rsh.GetIconPath()) && !IsPictureFile(rsh.GetIconPath()) )
               ExtractIconEx(rsh.GetIconPath(),rsh.GetIconIdx(),NULL,&icon,1);
            if ( !icon && rsh.GetExePath()[0] )
               icon = ExtractSingleIconInOldMethod(rsh.GetExePath(),16);
          }
       else
          {
            if ( !IsStrEmpty(rsh.GetIconPath()) && !IsPictureFile(rsh.GetIconPath()) )
               ExtractIconEx(rsh.GetIconPath(),rsh.GetIconIdx(),NULL,&icon,1);
            if ( !icon )   
               LoadUrlIconsGuarant(16,16,&icon,NULL);
          }

       if ( !icon )
          icon = CopyIcon((HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_DEFFILE),IMAGE_ICON,16,16,LR_SHARED));
     }

  return icon;
}

const char* CODItemShortcut::GetText()
{
  return m_shortcut->GetName();
}


CODItemSheet::CODItemSheet(const CSheet *sheet)
{
  m_sheet = sheet;
  icon = NULL;
}

CODItemSheet::~CODItemSheet()
{
  if ( icon )
     DestroyIcon(icon);
}

void CODItemSheet::Execute()
{
}

HICON CODItemSheet::GetIcon()
{
  if ( !icon )
     {
       if ( m_sheet->GetIconPath()[0] )
          icon = ExtractSingleIconInOldMethod(CPathExpander(m_sheet->GetIconPath()),16);
       if ( !icon )
          icon = CopyIcon((HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_DEFFOLDER),IMAGE_ICON,16,16,LR_SHARED));
     }

  return icon;
}

const char* CODItemSheet::GetText()
{
  return m_sheet->GetName();
}


CODItemUserTool::CODItemUserTool(const CQLItem *item)
{
  m_item = item;
}

CODItemUserTool::~CODItemUserTool()
{
}

void CODItemUserTool::Execute()
{
  PostMessage(GetMainWnd(),RS_EXECQLITEM,(WPARAM)m_item,0);
}

HICON CODItemUserTool::GetIcon()
{
  return m_item->icon_big;
}

const char* CODItemUserTool::GetText()
{
  return m_item->name;
}



void CMainMenu::AddODNormalItem(CODItem *item,HMENU menu)
{
  int idx = items.size();
  items.push_back(item);
  
  if ( menu )
     {
       AppendMenu(menu,MF_OWNERDRAW,IDM_BASE+idx,(LPCTSTR)item);
     }
  else
     {
       Add(MF_OWNERDRAW,IDM_BASE+idx,(char*)item);
     }
}


void CMainMenu::AddODSeparator(CODItem *item,HMENU menu)
{
  items.push_back(item);
  
  if ( menu )
     {
       AppendMenu(menu,MF_OWNERDRAW | MF_SEPARATOR,0,(LPCTSTR)item);
     }
  else
     {
       Add(MF_OWNERDRAW | MF_SEPARATOR,0,(char*)item);
     }
}


void CMainMenu::AddODPopup(HMENU popup,CODItem *item,HMENU menu)
{
  items.push_back(item);
  
  if ( menu )
     {
       AppendMenu(menu,MF_OWNERDRAW | MF_POPUP,(int)popup,(LPCTSTR)item);
     }
  else
     {
       Add(MF_OWNERDRAW | MF_POPUP,(int)popup,(char*)item);
     }
}


int CMainMenu::FindMMItem(int id)
{
  int idx = -1;
  
  for ( int n = 0; n < sizeof(mmitems)/sizeof(mmitems[0]); n++ )
      {
        if ( mmitems[n].id == id )
           {
             idx = n;
             break;
           }
      }

  return idx;
}


void CMainMenu::AddMMSeparator(HMENU menu)
{
  CODItemBigSeparator *od = new CODItemBigSeparator();
  AddODSeparator(od,menu);
}


void CMainMenu::AddMMItem(int id,HMENU menu)
{
  int idx = FindMMItem(id);
  if ( idx != -1 )
     {
       CODItemMain *od = new CODItemMain(idx);
       AddODNormalItem(od,menu);
     }
}


void CMainMenu::AddMMPopup(int id,HMENU popup,HMENU menu)
{
  int idx = FindMMItem(id);
  if ( idx != -1 )
     {
       CODItemMain *od = new CODItemMain(idx);
       AddODPopup(popup,od,menu);
     }
}


BOOL CMainMenu::MeasureMenuItem(MEASUREITEMSTRUCT *i)
{
  BOOL rc = FALSE;

  CODItem *item = (CODItem*)i->itemData;
  if ( item )
     {
       int w = 0, h = 0;
       item->Measure(&w,&h);

       i->itemWidth = w;
       i->itemHeight = h;

       rc = TRUE;
     }

  return rc;
}


BOOL CMainMenu::DrawMenuItem(DRAWITEMSTRUCT *i)
{
  BOOL rc = FALSE;

  CODItem *item = (CODItem*)i->itemData;
  if ( item )
     {
       HDC hdc = i->hDC;
       RECT r = i->rcItem;

       int w = r.right - r.left;
       int h = r.bottom - r.top;

       if ( w > 0 && h > 0 )
          {
            RBUFF buff;

            RB_CreateNormal(&buff,w,h);
            
            if ( do_transparent_menu )
               {
                 POINT p = {0,0};
                 GetDCOrgEx(hdc,&p);
                 int screen_x = p.x + r.left;
                 int screen_y = p.y + r.top;

                 RECT sr;
                 SetRect(&sr,screen_x,screen_y,screen_x+w,screen_y+h);
                 HDC back_hdc = GetScreenPartHDC(&sr);
                 item->Draw(i->itemState,&buff,back_hdc,0,0);
               }
            else
               {
                 item->Draw(i->itemState,&buff,NULL,0,0);
               }

            BitBlt(hdc,r.left,r.top,w,h,buff.hdc,0,0,SRCCOPY);
            RB_Destroy(&buff);

            rc = TRUE;
          }
     }

  return rc;
}


HMENU CMainMenu::CreateUserToolsMenu(const CQuickLaunch *ql)
{
  HMENU menu = CreatePopupMenu();

  for ( int n = 0; n < ql->GetCount(); n++ )
      {
        const CQLItem *ql_item = ql->GetItemAt(n);
        CODItemUserTool *od = new CODItemUserTool(ql_item);
        AddODNormalItem(od,menu);
      }

  return menu;
}


HMENU CMainMenu::CreateShortcutsMenu(const CSheet *sheet,const CSheet *curr_sheet)
{
  HMENU menu = CreatePopupMenu();

  BOOL allow_exec = TRUE;
  if ( sheet->GetRulesPath()[0] )
     {
       if ( sheet != curr_sheet )
          {
            allow_exec = FALSE;
          }
     }

  for ( int n = 0; n < sheet->GetCount(); n++ )
      {
        const CShortcut *sh = &(*sheet)[n];

        if ( !dont_show_empty_icons || !CRealShortcut(*sh).IsEmptyShortcut(det_empty_icons_by_icon_path) ) //time cost!
           {
             CODItemShortcut *od = new CODItemShortcut(sheet,sh,allow_exec);
             AddODNormalItem(od,menu);
           }
      }

  return menu;
}


HMENU CMainMenu::CreateContentMenu(const CContent *content,const CSheet *curr_sheet)
{
  HMENU menu = CreatePopupMenu();

  for ( int n = 0; n < content->GetCount(); n++ )
      {
        const CSheet *sh = &(*content)[n];
        if ( sh->IsCurrentlyEnabled() )
           {
             HMENU popup = CreateShortcutsMenu(sh,curr_sheet);
             CODItemSheet *od = new CODItemSheet(sh);
             AddODPopup(popup,od,menu);
           }
      }

  return menu;
}


CMainMenu::CMainMenu(const CContent *content,const CSheet *curr_sheet,const CQuickLaunch *ql) 
  : CPopupMenu(NULL) //allocates popup menu
{
  do_transparent_menu = FALSE;//!IsDesktopCompositionEnabled();


  if ( vip_in_menu )
     AddMMItem(vip_session[0]?IDM_VIPEND:IDM_VIPBEGIN);
  if ( gc_info_in_menu )
     AddMMItem(IDM_SHOWGCINFO);
  if ( calladmin_in_menu )
     AddMMItem(IDM_CALLADMIN);
  if ( show_book_in_menu )
     AddMMItem(IDM_OFFERSBOOK);
  if ( monitor_off_in_menu )
     AddMMItem(IDM_MONITOROFF);
  AddMMItem(IDM_RESTORE);

  AddMMSeparator();
  if ( mycomp_in_menu )
     AddMMItem(IDM_MYCOMPUTER);
  AddMMPopup(IDM_CONTENT,CreateContentMenu(content,curr_sheet));
  AddMMPopup(IDM_USERTOOLS,CreateUserToolsMenu(ql)); //todo: check for empty

  if ( logoff_in_menu || reboot_in_menu || shutdown_in_menu || (vip_in_menu && vip_session[0]) )
     {
       HMENU m2 = CreatePopupMenu();
#ifndef DEBUG
       if ( logoff_in_menu )
#endif
          AddMMItem(IDM_LOGOFF,m2);
       if ( reboot_in_menu )
          AddMMItem(IDM_REBOOT,m2);
       if ( shutdown_in_menu )
          AddMMItem(IDM_SHUTDOWN,m2);

       if ( vip_in_menu && vip_session[0] )
          {
            if ( logoff_in_menu || reboot_in_menu || shutdown_in_menu )
               AddMMSeparator(m2);
            AddMMItem(IDM_VIPEND,m2);
          }

       AddMMSeparator();
       AddMMPopup(IDM_ENDWORK,m2);
     }
}


CMainMenu::~CMainMenu()
{
  for ( int n = 0; n < items.size(); n++ )
      {
        if ( items[n] )
           {
             delete items[n];
             items[n] = NULL;
           }
      }

  items.clear();

  for ( int n = 0; n < screen_parts.size(); n++ )
      {
        if ( screen_parts[n] )
           {
             delete screen_parts[n];
             screen_parts[n] = NULL;
           }
      }

  screen_parts.clear();
}


void CMainMenu::Show()
{
  int rc = Popup(TRUE,0,GetSystemMetrics(SM_CYSCREEN)-Get2DTheme()->panel_height);

  if ( rc )
     {
       rc -= IDM_BASE;

       if ( rc >= 0 && rc < items.size() )
          {
            CODItem *od = items[rc];
            if ( od ) //paranoja
               {
                 od->Execute();
               }
          }
     }
}


HDC CMainMenu::GetScreenPartHDC(const RECT *r)
{
  for ( int n = 0; n < screen_parts.size(); n++ )
      {
        if ( screen_parts[n]->IsOurRect(r) )
           {
             return screen_parts[n]->GetHDC();
           }
      }

  CScreenPart *part = new CScreenPart(r);
  screen_parts.push_back(part);

  return part->GetHDC();
}

