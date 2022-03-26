
#include "include.h"



CSheetWindow::CIcon::CIcon(CSheetWindow *_shwindow,CSystemIcon* _small,CSystemIcon* _big,const CShortcut *shortcut_ptr,BOOL is_net_icon)
{
  shwindow = _shwindow;
  icon_small = _small;
  icon_big = _big;
  shortcut = shortcut_ptr;
  b_neticon = is_net_icon;
  h_thread = NULL;
  ZeroMemory(&shadow,sizeof(shadow));
  i_group_idx = -1;
  i_local_idx = -1;
}


CSheetWindow::CIcon::~CIcon()
{
  if ( h_thread )
     {
       //if ( WaitForSingleObject(h_thread,0) == WAIT_TIMEOUT )
       //   TerminateThread(h_thread,0);  // too dangerous! maybe hung
       CloseHandle(h_thread);
       h_thread = NULL;
     }

  RB_Destroy(&shadow);
     
  SAFEDELETE(icon_small);
  SAFEDELETE(icon_big);
}


void CSheetWindow::CIcon::SetGroupAndLocalIndexes(int group,int local)
{
  i_group_idx = group;
  i_local_idx = local;
}


void CSheetWindow::CIcon::GetGroupAndLocalIndexes(int &_group,int &_local) const
{
  _group = i_group_idx;
  _local = i_local_idx;
}


void CSheetWindow::CIcon::UpdateIcons(CSystemIcon* _small,CSystemIcon* _big)
{
  if ( _small && _big )
     {
       SAFEDELETE(icon_small);
       SAFEDELETE(icon_big);

       icon_small = _small;
       icon_big = _big;
     }
  else
     {
       SAFEDELETE(_small);
       SAFEDELETE(_big);
     }
}


typedef struct {
HWND w_sheet;
int self_idx;
int session;
char s_iconpath[MAX_PATH];
char s_exepath[MAX_PATH];
int i_iconidx;
int w1,h1,w2,h2;
} LAZYICONLOADTHREADINFO;



DWORD WINAPI CSheetWindow::CIcon::LazyIconLoad(void *parm)
{
  LAZYICONLOADTHREADINFO *info = (LAZYICONLOADTHREADINFO*)parm;

  if ( IsWindow(info->w_sheet) && info->session == CSheetWindow::GetCurrentSession() )
     { 
       CSystemIcon* i_big = NULL;
       CSystemIcon* i_small = NULL;

       if ( IsPictureFile(info->s_iconpath) )
          {
            i_small = new CSystemIcon(info->s_iconpath,info->w1,info->h1);
            i_big = new CSystemIcon(info->s_iconpath,info->w2,info->h2);
          }
       else
          {
            HICON h_big = NULL;
            HICON h_small = NULL;

            if ( !IsStrEmpty(info->s_iconpath) )
               {
                 ExtractIconEx(info->s_iconpath,info->i_iconidx,&h_big,&h_small,1);
               }
            else
               {
                 if ( !IsStrEmpty(info->s_exepath) )
                    {
                      h_small = ExtractSingleIconInOldMethod(info->s_exepath,32);
                      h_big = NULL;
                    }
               }

            if ( !h_big )
               h_big = h_small ? CopyIcon(h_small) : NULL;

            if ( h_big && h_small )
               {
                 i_big = new CSystemIcon(h_big,TRUE);
                 i_small = new CSystemIcon(h_small,TRUE);
               }
            else
               {
                 if ( h_big )
                    DestroyIcon(h_big);
                 if ( h_small )
                    DestroyIcon(h_small);
               }
          }

       if ( i_big && i_small && IsWindow(info->w_sheet) )
          {
            LAZYICONLOADUPDATEINFO *p = (LAZYICONLOADUPDATEINFO *)sys_alloc(sizeof(*p));
            p->icon_idx = info->self_idx;
            p->_big = i_big;
            p->_small = i_small;
            p->session = info->session;
            PostMessage(info->w_sheet,RegisterWindowMessage("_SheetsWindowUpdateIcon"),(WPARAM)p,0);
          }
       else
          {
            SAFEDELETE(i_big);
            SAFEDELETE(i_small);
          }
     }

  sys_free(info);
  return 1;
}


void CSheetWindow::CIcon::StartLazyLoadThread(HWND w_sheet,int self_idx,int session)
{
  if ( b_neticon )
     {
       LAZYICONLOADTHREADINFO *p = (LAZYICONLOADTHREADINFO*)sys_zalloc(sizeof(*p)); // zero clears

       p->w_sheet = w_sheet;
       p->self_idx = self_idx;
       p->session = session;

       {
         const CShortcut *sh = GetShortcut();
         CRealShortcut rsh(*sh);

         lstrcpyn(p->s_iconpath,rsh.GetIconPath(),MAX_PATH);
         lstrcpyn(p->s_exepath,rsh.GetExePath(),MAX_PATH);
         p->i_iconidx = rsh.GetIconIdx();

         shwindow->GetPicIconSize1(p->w1,p->h1);
         shwindow->GetPicIconSize2(p->w2,p->h2);
       }

       DWORD id;
       h_thread = MyCreateThreadSelectedCPU(LazyIconLoad,(void*)p,&id,THREAD_PRIORITY_IDLE);
     }
  else
     {
       h_thread = NULL;
     }

  b_neticon = FALSE;
}


void CSheetWindow::PrepareForLazyIconsLoading(HWND w)
{
  for ( int n = 0; n < icons.size(); n++ )
      {
        icons[n]->StartLazyLoadThread(w,n,icons_session);
      }
}


CSheetWindow::CIcon* CSheetWindow::LoadShortcut(const CShortcut *sh)
{
  CIcon *icon = NULL;

  if ( sh )
     {
       CRealShortcut rsh(*sh);
       
       if ( !IsStrEmpty(rsh.GetName()) )
          {
            if ( !PathIsURL(rsh.GetExePath()) && dont_show_empty_icons && rsh.IsEmptyShortcut(det_empty_icons_by_icon_path) )
               {
                 return NULL;
               }
            
            if ( IsPictureFile(rsh.GetIconPath()) )
               {
                 if ( IsNetPathFast(rsh.GetIconPath()) )
                    {
                      HICON i1=NULL,i2=NULL;

                      CIconsCache::Get(rsh.GetExePath(),"",0,icon_size1,icon_size2,i1,i2);

                      icon = new CIcon(this,new CSystemIcon(i1,TRUE),new CSystemIcon(i2,TRUE),sh,TRUE);
                    }
                 else
                    {
                      int w,h;
                      GetPicIconSize1(w,h);
                      CSystemIcon *i_small = new CSystemIcon(rsh.GetIconPath(),w,h);
                      GetPicIconSize2(w,h);
                      CSystemIcon *i_big = new CSystemIcon(rsh.GetIconPath(),w,h);

                      icon = new CIcon(this,i_small,i_big,sh,/*is_net*/FALSE);
                    }
               }
            else
               {
                 if ( !PathIsURL(rsh.GetExePath()) )
                    {
                      HICON i1=NULL,i2=NULL;
                      BOOL is_net = FALSE;
                      CIconsCache::Get(rsh.GetExePath(),rsh.GetIconPath(),rsh.GetIconIdx(),icon_size1,icon_size2,i1,i2,&is_net);

                      icon = new CIcon(this,new CSystemIcon(i1,TRUE),new CSystemIcon(i2,TRUE),sh,is_net);
                    }
                 else
                    {
                      HICON i1=NULL,i2=NULL;
                      BOOL is_net = FALSE;

                      if ( !IsStrEmpty(rsh.GetIconPath()) )
                         {
                           CIconsCache::Get(rsh.GetIconPath(),rsh.GetIconPath(),rsh.GetIconIdx(),icon_size1,icon_size2,i1,i2,&is_net);
                         }
                      else
                         {
                           LoadUrlIconsGuarant(icon_size1,icon_size2,&i1,&i2);
                         }

                      icon = new CIcon(this,new CSystemIcon(i1,TRUE),new CSystemIcon(i2,TRUE),sh,is_net);
                    }
               }

            CreateShadowInternal(icon->GetShadow(),rsh.GetName(),0);
          }
     }

  return icon;
}


void CSheetWindow::LoadIcons()
{
  FreeIcons();
  
  if ( m_sheet )
     {
       // create shortcuts/icons array
       unsigned starttime = GetTickCount();
       for ( int n = 0; n < m_sheet->GetCount(); n++ )
           {
             CIcon *icon = LoadShortcut(&(*m_sheet)[n]);
             if ( icon )
                {
                  icons.push_back(icon);
                }

             if ( GetTickCount() - starttime > 4000 )
                {
                  // todo: better way, because sent messages are processed here...
                  MSG msg;
                  PeekMessage(&msg,w_sheet,0,0,PM_NOREMOVE);

                  starttime = GetTickCount();
                }
           }

       // build grouped icons
       for ( int n = 0; n < icons.size(); n++ )
           {
             const char *s = icons[n]->GetShortcut()->GetGroup();

             BOOL find = FALSE;
             for ( int m = 0; m < icon_groups.size(); m++ )
                 if ( !lstrcmpi(icon_groups[m].name,s) )
                    {
                      find = TRUE;
                      break;
                    }

             if ( !find )
                {
                  ICONGROUP i;
                  i.count = 0;
                  i.name = s;
                  icon_groups.push_back(i);
                }
           }

       for ( int n = 0; n < icon_groups.size(); n++ )
           {
             const char *des_group = icon_groups[n].name;

             for ( int m = 0; m < icons.size(); m++ )
                 if ( !lstrcmpi(icons[m]->GetShortcut()->GetGroup(),des_group) )
                    {
                      icons[m]->SetGroupAndLocalIndexes(n,icon_groups[n].count++);
                    }
           }
     }
}


void CSheetWindow::FreeIcons()
{
  icons_session++;  // interlocked increment... :)

  while ( icons.size() )
  {
    TIcons::iterator it = icons.begin();
    CIcon *i = *it;
    delete i;
    icons.erase(it);
  };

  icon_groups.clear();
}


void CSheetWindow::LoadBG()
{
  FreeBG();
  
  if ( m_sheet )
     {
       p_background = new CBackground4Sheet(w_sheet,m_sheet);
     }
}


void CSheetWindow::FreeBG()
{
  SAFEDELETE(p_background);
}


BOOL CSheetWindow::IsBGMotion() const
{
  return p_background ? p_background->IsMotion() : FALSE;
}


