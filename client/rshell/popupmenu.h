
#ifndef __POPUPMENU_H__
#define __POPUPMENU_H__


class CPopupMenu : public CWindowProc
{
           static unsigned last_popdown_time;
           HMENU menu;
           BOOL need_destroy_menu;

  public:
           CPopupMenu(HMENU src_menu=NULL);
           ~CPopupMenu();
            
           virtual void Add(int flags,int id,const char *value);
           virtual void AddSeparator();
           virtual int Popup(BOOL is_down_top=FALSE,int x=-1,int y=-1);

           static unsigned GetLastPopdownTime();

  protected:
           virtual BOOL MeasureMenuItem(MEASUREITEMSTRUCT *i);
           virtual BOOL DrawMenuItem(DRAWITEMSTRUCT *i);

  private:
           HBRUSH GetMenuBrush(HMENU menu);
           void SetMenuBrush(HMENU menu,HBRUSH brush);
           LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
};


class CPopupMenuWithODSeparator : public CPopupMenu
{
  public:
           inline CPopupMenuWithODSeparator() : CPopupMenu(NULL) {}
           inline ~CPopupMenuWithODSeparator() {}

           virtual void AddSeparator();

  protected:
           virtual BOOL MeasureMenuItem(MEASUREITEMSTRUCT *i);
           virtual BOOL DrawMenuItem(DRAWITEMSTRUCT *i);

};


int PopupMenuAndDestroy(HMENU menu,BOOL is_down_top,int x,int y);
unsigned GetMenuLastPopdownTime();


#endif
