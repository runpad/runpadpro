
#ifndef __CORE_H__
#define __CORE_H__



class CCore
{
         class CSheet
         {
                  char *filename;
                  char *text;
                  CLayer *layer;

           public:
                  CSheet(const char *_filename,const char *_text,CLayer *_layer)
                  {
                    filename = sys_copystring(_filename);
                    text = sys_copystring(_text);
                    layer = _layer;
                  }
                  ~CSheet()
                  {
                    FREEANDNULL(filename);
                    FREEANDNULL(text);
                    SAFEDELETE(layer);
                  }
                  void ReplaceLayer(CLayer *_new)
                  {
                    if ( layer != _new )
                       {
                         SAFEDELETE(layer);
                         layer = _new;
                       }
                  }
                  BOOL IsSame(const char *_filename,const char *_text) const
                  {
                    return lstrcmpi(filename,NNS(_filename)) == 0 && 
                           lstrcmp(text,NNS(_text)) == 0;
                  }
                  BOOL IsSameStrict(const char *_filename,const char *_text) const
                  {
                    return lstrcmp(filename,NNS(_filename)) == 0 && 
                           lstrcmp(text,NNS(_text)) == 0;
                  }
                  const char* GetFileName() const { return filename; }
                  const char* GetFilename() const { return filename; }
                  const char* GetText() const { return text; }
                  const CLayer* GetLayer() const { return layer; }
         };
         

         TDeskExternalConnection *conn;

         HWND m_wnd;
         int user_message;
         
         CShadowsCache *m_shadows;
         CThumbsCache *m_thumbs;

         typedef std::vector<CSheet*> TSheets;
         TSheets m_sheets;

         CLayer24 *m_screen;   // offscreen
         CLayer24 *m_status_buff;
         CLayer32 *m_infotext_buff;

         unsigned m_infotext_animation;
         
         int m_sheet_width;
         int m_sheet_height;
         int m_fsize_min;
         int m_active_sheet;     // -1,0,1,2,...
         int m_page_shaded_int;  // -1,0,1

         char m_organization[256];
         char m_info_text[8192];
         char m_status_string[256];

         HBITMAP m_default_bg;

         BOOL b_need_postponded_refresh;

  public:
         CCore(TDeskExternalConnection *_conn,HWND _hwnd,int _user_message);
         ~CCore();

         void Refresh();
         BOOL Paint(HDC _hdc);
         void OnMouseMove(int x,int y);
         void OnMouseClick(int x,int y);
         void OnStatusStringChanged();
         void OnUserMessage(UINT message,WPARAM wParam,LPARAM lParam);
         void UpdateInfoTextAnimation();
         static int GetNullColor();

  private:       
         void RefreshInternal(BOOL b_total_repaint=FALSE);
         void ClearSheetsAr();
         void GetHostDim(int &w,int &h);
         void GetSheetsArea(RECT &_r);
         void CalculateSheetDim(int &w,int &h,int count);
         CLayer* CreateSheetLayer(int total_width,int total_height,const char *_filename,const char *_text,int *_fsize=NULL,int actual_fsize=0);
         void GetSheetRect(int idx,RECT &_r);
         BOOL SheetHitTest(int x,int y,int &_idx);
         void GetStatusStringArea(RECT &_r);
         void GetInfoTextArea(RECT &_r);
         HRGN CreatePaintRgnInternal(const RECT &r_init,int combine_mode);
         HRGN CreateExclPaintRgn();
         HRGN CreateInclPaintRgn();
         void FillStatusStringBuff();
         void PaintInfoTextInternalNoCheck(HDC hdc_dest,HDC hdc_src,const RECT &r);
         int GetInfoTextFullTextHeight(const char *text,int width);
};




#endif

