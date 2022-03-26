
#ifndef ___QL_H___
#define ___QL_H___


#include <vector>


class CQLItem
{
  public:
          char name[MAX_PATH];
          char exe[MAX_PATH];
          char arg[MAX_PATH];
          HICON icon_big;
          HICON icon_small;

  public:
          CQLItem();
          CQLItem(const CQLItem &other);
          ~CQLItem();
          CQLItem& operator = (const CQLItem &other);

          void Load(const char *s_exe,const char *s_arg,const char *s_name);
          void Execute();

  private:        
          void Free();
};


class CQuickLaunch
{
  typedef std::vector<CQLItem> TQLItems;
  TQLItems qlitems;

  HWND w_main, w_panel;
  HWND tooltip;

  public:
          CQuickLaunch(HWND main_window,HWND panel_window);
          ~CQuickLaunch();

          int GetCount() const;
          CQLItem *GetItemAt(int idx);
          const CQLItem *GetItemAt(int idx) const;
          void GetItemRect(int num,RECT *r);
          int GetControlWidth(void);
          void OnClick(int message,int wParam,int lParam);
          void OnConfigChange();
          void OnDisplayChange(int sw,int sh);
          void OnPaint(HDC hdc,int hl,BOOL down);
          void OnNotifyMessage(NMHDR *i);

  private:
          void GetItemDim(int *_w,int *_h);
          void SetTooltips(void);
          void DisplayTip(NMTTDISPINFO *i);
          void LoadItems(void);
          void ExecItem(int num);

};



void ExecQLItem(void *obj);


#endif

