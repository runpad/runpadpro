
#ifndef __MAINMENU_H__
#define __MAINMENU_H__


#include "popupmenu.h"
#include <vector>

class CODItem;
class CQuickLaunch;
class CContent;
class CSheet;

class CMainMenu : public CPopupMenu
{
           class CScreenPart
           {
                      RECT rect;
                      RBUFF buff;
             public:
                      CScreenPart(const RECT *r);
                      ~CScreenPart();
                      BOOL IsOurRect(const RECT *r) const;
                      HDC GetHDC() const;
           };
           
           
           static const int IDM_BASE = 1000;
           
           BOOL do_transparent_menu;

           typedef std::vector<CODItem*> TItems;
           TItems items;

           std::vector<CScreenPart*> screen_parts;

  public:
           CMainMenu(const CContent *content,const CSheet *curr_sheet,const CQuickLaunch *ql);
           ~CMainMenu();

           void Show();
           static void ExecMainMenuItem(int idx);
  
  protected:
           virtual BOOL MeasureMenuItem(MEASUREITEMSTRUCT *i);
           virtual BOOL DrawMenuItem(DRAWITEMSTRUCT *i);

  private:
           void AddODNormalItem(CODItem *item,HMENU menu=NULL);
           void AddODSeparator(CODItem *item,HMENU menu=NULL);
           void AddODPopup(HMENU popup,CODItem *item,HMENU menu=NULL);

           int FindMMItem(int id);

           HMENU CreateUserToolsMenu(const CQuickLaunch *ql);
           HMENU CreateShortcutsMenu(const CSheet *sheet,const CSheet *curr_sheet);
           HMENU CreateContentMenu(const CContent *content,const CSheet *curr_sheet);

           void AddMMSeparator(HMENU menu=NULL);
           void AddMMItem(int id,HMENU menu=NULL);
           void AddMMPopup(int id,HMENU popup,HMENU menu=NULL);

           HDC GetScreenPartHDC(const RECT *r);
};



void ExecMainMenuItem(int idx);


#endif

