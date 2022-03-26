
#include "include.h"



static const int g_leftpad = 5;
static const int g_rightpad = g_leftpad;
static const int g_toppad = 5;
static const int g_bottompad = 5;
static const int g_top_area_height = 42;
static const int g_taskbar_area_height = 30;
static const int g_bottom_area_height = 90+g_taskbar_area_height;
static const int g_areas_border = 3; // do not change!!!

static const int g_shade_color = RGB(0,0,0);
static const int g_shade_alpha = 100;

static const char* g_infotext_font = "Arial";
static const int g_infotext_weight = FW_BOLD;
static const int g_infotext_size = -14;
static const int g_infotext_format = DT_LEFT|DT_TOP|DT_EXPANDTABS|DT_WORDBREAK;

enum {
MSG_UPDATETHUMB = 0xAB0213,
};



CCore::CCore(TDeskExternalConnection *_conn,HWND _hwnd,int _user_message)
{
  conn = _conn;
  
  m_wnd = _hwnd;
  user_message = _user_message;

  m_shadows = new CShadowsCache();
  m_thumbs = new CThumbsCache(our_instance,IDT_NULLIMAGE,_hwnd,_user_message,MSG_UPDATETHUMB);

  m_screen = NULL;
  m_status_buff = NULL;
  m_infotext_buff = NULL;

  m_infotext_animation = 0;

  m_sheet_width = 0;
  m_sheet_height = 0;
  m_fsize_min = 1;
  m_active_sheet = -1;
  m_page_shaded_int = -1;

  lstrcpy(m_organization,"");
  lstrcpy(m_info_text,"");
  lstrcpy(m_status_string,"");

  m_default_bg = LoadPicFromResource(our_instance,IDT_BGIMAGE);

  b_need_postponded_refresh = FALSE;

  RefreshInternal(TRUE);
}


CCore::~CCore()
{
  conn = NULL;

  if ( m_default_bg )
     ::DeleteObject(m_default_bg);
  m_default_bg = NULL;
  
  SAFEDELETE(m_screen);
  SAFEDELETE(m_status_buff);
  SAFEDELETE(m_infotext_buff);

  SAFEDELETE(m_thumbs);
  SAFEDELETE(m_shadows);

  m_wnd = NULL;
  
  ClearSheetsAr();
}


int CCore::GetNullColor()
{
  return RGB(168,166,174);  // RGB(255,255,255)
}



struct TSHEETID {
 char *filename;
 char *text;
};


void CCore::Refresh()
{
  RefreshInternal(FALSE);
}


void CCore::RefreshInternal(BOOL b_total_repaint)
{
  int host_w = 0, host_h = 0;
  GetHostDim(host_w,host_h);

  if ( host_w == 0 || host_h == 0 )
     return;  //fatal error?

  // check screen and display mode
  if ( !m_screen || !m_screen->IsSizeMatch(host_w,host_h) )
     {
       SAFEDELETE(m_screen);
       m_screen = new CLayer24(host_w,host_h,FALSE);
       b_total_repaint = TRUE;
     }

  ASSERT(m_screen);
  if ( !m_screen->IsValid() )
     return;  //fatal error?

  // check sheet_dims
  const int new_sheets_count = (conn && conn->GetNumSheets ? conn->GetNumSheets() : 0);
  int new_sheet_width = 0, new_sheet_height = 0;
  CalculateSheetDim(new_sheet_width,new_sheet_height,new_sheets_count);

  if ( m_sheet_width != new_sheet_width || m_sheet_height != new_sheet_height )
     {
       m_shadows->Clear();
       ClearSheetsAr();

       m_sheet_width = new_sheet_width;
       m_sheet_height = new_sheet_height;

       b_total_repaint = TRUE;
     }

  // checks sheets for add/delete and build new sheets array if needed
  {
    std::vector<TSHEETID> ids;

    // fill ids and calculate new min font size
    m_fsize_min = 1000;
    for ( int n = 0; n < new_sheets_count; n++ )
        {
          const char *text = (conn && conn->GetSheetName ? conn->GetSheetName(n) : "");
          const char *filename = (conn && conn->GetSheetBGPic ? conn->GetSheetBGPic(n) : "");
          
          TSHEETID id;
          id.filename = sys_copystring(filename);
          id.text = sys_copystring(text);
          ids.push_back(id);

          int size = 0;
          if ( CreateSheetLayer(m_sheet_width,m_sheet_height,id.filename,id.text,&size) )
             {
               ASSERT(FALSE);
             }

          if ( ABS(size) < ABS(m_fsize_min) )
             m_fsize_min = size;
        }

    if ( m_fsize_min == 0 || m_fsize_min == 1000 )
       m_fsize_min = 1;

    // fill temp array of sheets
    TSheets temp;

    for ( int n = 0; n < ids.size(); n++ )
        {
          const char *filename = ids[n].filename;
          const char *text = ids[n].text;

          CSheet *find = NULL;
          for ( int m = 0; m < m_sheets.size(); m++ )
              {
                if ( m_sheets[m] && m_sheets[m]->IsSame(filename,text) )
                   {
                     find = m_sheets[m];
                     m_sheets[m] = NULL;
                     break;
                   }
              }

          if ( !find )
             {
               CLayer *layer = CreateSheetLayer(m_sheet_width,m_sheet_height,filename,text,NULL,m_fsize_min);
               ASSERT(layer);
               find = new CSheet(filename,text,layer);
        
               m_active_sheet = -1;  //needed?
               b_total_repaint = TRUE;
             }

          temp.push_back(find);
        }

    // clear rest of our old sheets
    for ( int n = 0; n < m_sheets.size(); n++ )
        {
          if ( m_sheets[n] )
             {
               SAFEDELETE(m_sheets[n]);

               m_active_sheet = -1;  //needed?
               b_total_repaint = TRUE;
             }
        }
    m_sheets.clear();

    // copy temp to m_sheets and clear temp
    temp.swap(m_sheets);

    // clear ids array
    for ( int n = 0; n < ids.size(); n++ )
        {
          FREEANDNULL(ids[n].filename);
          FREEANDNULL(ids[n].text);
        }
    ids.clear();
  }

  // check active sheet
  {
    int new_active_sheet = -1;
    for ( int n = 0; n < new_sheets_count; n++ )
        {
          const BOOL active = (conn && conn->IsSheetActive ? conn->IsSheetActive(n) : FALSE);

          if ( active )
             {
               new_active_sheet = n;
               break;  // use only first active
             }
        }
    
    if ( m_active_sheet != new_active_sheet )
       {
         m_active_sheet = new_active_sheet;
         b_total_repaint = TRUE;
       }
  }

  // check shaded
  {
    int curr_shade = (conn && conn->IsPageShaded ? (conn->IsPageShaded()?1:0) : 0);
    if ( m_page_shaded_int != curr_shade )
       {
         m_page_shaded_int = curr_shade;
         b_total_repaint = TRUE;
       }
  }

  // other strings
  {
    const char *new_org = (conn && conn->GetMachineLoc ? conn->GetMachineLoc() : "");
    const char *new_desc = (conn && conn->GetMachineDesc ? conn->GetMachineDesc() : "");

    char s1[120];
    char s2[120];
    char s[256];

    lstrcpyn(s1,NNS(new_org),sizeof(s1));
    lstrcpyn(s2,NNS(new_desc),sizeof(s2));

    if ( !IsStrEmpty(s1) && !IsStrEmpty(s2) )
       wsprintf(s,"%s (%s)",s1,s2);
    else
    if ( IsStrEmpty(s1) && IsStrEmpty(s2) )
       lstrcpy(s,"");
    else
    if ( !IsStrEmpty(s1) )
       lstrcpy(s,s1);
    else
       lstrcpy(s,s2);
    
    if ( lstrcmp(m_organization,s) )
       {
         lstrcpyn(m_organization,s,sizeof(m_organization));
         b_total_repaint = TRUE;
       }
  }

  {
    const char *new_status_string = (conn && conn->GetStatusString ? conn->GetStatusString() : "");
    if ( b_total_repaint || !m_status_buff || lstrcmp(m_status_string,NNS(new_status_string)) )
       {
         lstrcpyn(m_status_string,NNS(new_status_string),sizeof(m_status_string));

         SAFEDELETE(m_status_buff);

         RECT r = {0,0,0,0};
         GetStatusStringArea(r);
         
         m_status_buff = new CLayer24(r.right-r.left,r.bottom-r.top,FALSE);

         // painting will be done later after m_screen will filled out...
       }
  }

  {
    const char *html_info_text = (conn && conn->GetInfoText ? conn->GetInfoText():"");

    RECT r = {0,0,0,0};
    GetInfoTextArea(r);
    BOOL width_changed = (m_infotext_buff && m_infotext_buff->GetWidth() != r.right-r.left);
    
    if ( !m_infotext_buff || width_changed || StrCmpN(NNS(html_info_text),m_info_text,sizeof(m_info_text)-1) )
       {
         lstrcpyn(m_info_text,NNS(html_info_text),sizeof(m_info_text));

         SAFEDELETE(m_infotext_buff);

         int width = r.right-r.left;
         if ( width > 0 )
            {
              char *raw_info_text = (char*)malloc(sizeof(m_info_text));
              raw_info_text[0] = 0;
              RemoveHTMLTags(m_info_text, raw_info_text, sizeof(m_info_text));
              
              int h = GetInfoTextFullTextHeight(raw_info_text,width);
              h += 3; //paranoja
              
              m_infotext_buff = new CLayer32(width,h,FALSE);
              m_infotext_buff->Fill(RGB(0,0,0),0);

              RECT r = {0,0,width,h};
              
              DrawSmoothText(*m_infotext_buff,r,raw_info_text,
                             g_infotext_format,g_infotext_font,g_infotext_size,g_infotext_weight,
                             RGB(0,0,80),230,1);

              free(raw_info_text);
            }
       }
  }

  // draw offscreen if needed
  if ( b_total_repaint )
     {
       // bg bitmap
       {
         HBITMAP bg = NULL;
         
         if ( m_active_sheet >= 0 && m_active_sheet < m_sheets.size() )
            {
              BOOL def = FALSE;
              bg = m_thumbs->GetThumb(m_sheets[m_active_sheet]->GetFileName(),def);
              if ( def )
                 bg = NULL;
            }

         m_screen->Fill(RGB(170,170,170)); //paranoja

         int over_color, over_alpha;
         
         if ( bg )
            {
              over_color = RGB(170,170,170);
              over_alpha = 220;
            }
         else
            {
              over_color = RGB(170,170,170);
              over_alpha = 100;
              bg = m_default_bg;
            }
       
         if ( bg )
            {
              ::ApplyBitmapProportional(*m_screen,bg,InterpolationModeBilinear);
              m_screen->AlphaFill(over_color,over_alpha);
            }
       }

       // top area
       {
         CTempLayersCache::CWrapper *wrp = CTempLayersCache::GetLayer(m_screen->GetWidth(),g_top_area_height,24);
         if ( wrp )
            {
              CLayer24 *t = static_cast<CLayer24*>(wrp->GetLayer());
              if ( t )
                 {
                   t->Fill(RGB(255,255,255));
                   t->PaintTo(*m_screen,0,0,80);
                 }

              delete wrp;
            }
       }

       // bottom area
       {
         CTempLayersCache::CWrapper *wrp = CTempLayersCache::GetLayer(m_screen->GetWidth(),g_bottom_area_height,24);
         if ( wrp )
            {
              CLayer24 *t = static_cast<CLayer24*>(wrp->GetLayer());
              if ( t )
                 {
                   t->Fill(RGB(255,255,255));
                   t->PaintTo(*m_screen,0,m_screen->GetHeight()-t->GetHeight(),80);
                 }

              delete wrp;
            }
       }

       // area borders
       {
         CTempLayersCache::CWrapper *wrp = CTempLayersCache::GetLayer(m_screen->GetWidth(),g_areas_border,32);
         if ( wrp )
            {
              CLayer32 *t = static_cast<CLayer32*>(wrp->GetLayer());
              if ( t && t->IsValid() )
                 {
                   ASSERT(g_areas_border==3);
                   ASSERT(t->GetHeight()==g_areas_border);
                   const int alphas[3] = {130,180,130};
                   for ( int m = 0; m < 3; m++ )
                       {
                         int alpha = alphas[m];
                         BYTE *row = t->GetPointer(0,m);
                         BYTE c = 255 * alpha / 255;
                         for ( int n = 0; n < t->GetWidth(); n++ )
                             {
                               *row++ = c; 
                               *row++ = c; 
                               *row++ = c; 
                               *row++ = alpha;
                             }
                       }

                   t->PaintTo(*m_screen,0,g_top_area_height-1/*!!!*/);
                   t->PaintTo(*m_screen,0,m_screen->GetHeight()-g_bottom_area_height-t->GetHeight()+1/*!!!*/);
                 }

              delete wrp;
            }
       }

       // sheets with lighter
       for ( int n = 0; n < m_sheets.size(); n++ )
           {
             const CLayer* layer = m_sheets[n]->GetLayer();
             if ( layer && layer->IsValid() )
                {
                  RECT r = {0,0,0,0};
                  GetSheetRect(n,r);

                  if ( !IsRectEmpty(&r) )
                     {
                       if ( n == m_active_sheet )
                          {
                            CLayer32* t = CreateLighterLayer(layer->GetWidth(),layer->GetHeight(),RGB(255,240,20),0.65);
                            if ( t )
                               {
                                 t->PaintTo(*m_screen,r.left,r.top);
                                 delete t;
                               }
                          }
                       
                       layer->PaintTo(*m_screen,r.left,r.top);
                     }
                }
           }

       // organization name
       {
         RECT r2;
         GetInfoTextArea(r2);
         
         RECT r;
         r.left = (r2.right ? r2.right+50 : 10);
         r.right = m_screen->GetWidth() - 10;
         r.top = m_screen->GetHeight()-g_bottom_area_height;
         r.bottom = m_screen->GetHeight()-g_taskbar_area_height;
         if ( r.right > r.left && r.bottom > r.top )
            {
              const int format = DT_RIGHT|DT_VCENTER|DT_SINGLELINE;
              int fsize = GetFontSizeToFitIn(-64,r,m_organization,format,"Arial",FW_BOLD);
              DrawSmoothText(*m_screen,r,m_organization,format,"Arial",fsize,FW_BOLD,
                             RGB(255,255,255),40,1);
            }
       }

       // shade page
       if ( m_page_shaded_int == 1 )
          {
            HRGN rgn = CreateExclPaintRgn();
            
            m_screen->AlphaFill(g_shade_color,g_shade_alpha,rgn);

            if ( rgn )
               ::DeleteObject(rgn);
          }
     }

  // paint into the status string buffer
  FillStatusStringBuff();


  // update cursor if needed
  if ( b_total_repaint )
     {
       POINT p = {-1,-1};
       if ( GetCursorPos(&p) )
          {
            if ( m_wnd )
               {
                 RECT r = {0,0,0,0};
                 GetWindowRect(m_wnd,&r);

                 if ( PtInRect(&r,p) && WindowFromPoint(p) == m_wnd )
                    {
                      ScreenToClient(m_wnd,&p);
                      
                      //OnMouseMove(p.x,p.y);
                      PostMessage(m_wnd,WM_MOUSEMOVE,0,MAKELONG(p.x,p.y));
                    }
               }
          }
     }


  // invalidate always!
  InvalidateRect(m_wnd,NULL,FALSE);
}


void CCore::OnStatusStringChanged()
{
  const char *new_status_string = (conn && conn->GetStatusString ? conn->GetStatusString() : "");

  if ( lstrcmp(m_status_string,NNS(new_status_string)) )
     {
       lstrcpyn(m_status_string,NNS(new_status_string),sizeof(m_status_string));

       FillStatusStringBuff();
       
       if ( m_wnd )
          {
            RECT r = {0,0,0,0};
            GetStatusStringArea(r);
            if ( !IsRectEmpty(&r) )
               {
                 InvalidateRect(m_wnd,&r,FALSE);
               }
          }
     }
}


void CCore::FillStatusStringBuff()
{
  if ( m_status_buff && m_status_buff->IsValid() && m_screen && m_screen->IsValid() )
     {
       RECT r = {0,0,0,0};
       GetStatusStringArea(r);

       if ( !IsRectEmpty(&r) )
          {
            const int w = r.right - r.left;
            const int h = r.bottom - r.top;

            ASSERT( w == m_status_buff->GetWidth() && h == m_status_buff->GetHeight() );

            BitBlt(m_status_buff->GetHDC(),0,0,w,h,m_screen->GetHDC(),r.left,r.top,SRCCOPY);

            RECT dr = {0,0,w,h};
            DrawSmoothTextFitIn(*m_status_buff,dr,m_status_string,DT_RIGHT|DT_VCENTER|DT_SINGLELINE,
                            "Arial",-24,FW_BOLD,RGB(250,250,255),230,1);

            if ( m_page_shaded_int == 1 )
               {
                 m_status_buff->AlphaFill(g_shade_color,g_shade_alpha);
               }
          }
     }
}


void CCore::PaintInfoTextInternalNoCheck(HDC hdc_dest,HDC hdc_src,const RECT &r)
{
  const int w = r.right - r.left;
  const int h = r.bottom - r.top;
  
  CTempLayersCache::CWrapper *wrp = CTempLayersCache::GetLayer(w,h,24);
  if ( wrp )
     {
       CLayer24 *t = static_cast<CLayer24*>(wrp->GetLayer());
       if ( t && t->IsValid() )
          {
            BitBlt(t->GetHDC(),0,0,w,h,hdc_src,r.left,r.top,SRCCOPY);

            if ( !IsStrEmpty(m_info_text) ) // optimization
               {
                 if ( m_infotext_buff && m_infotext_buff->IsValid() )
                    {
                      int y = h - (m_infotext_animation % (m_infotext_buff->GetHeight() + h));
                      m_infotext_buff->PaintTo(*t,0,y);
                    }
               }

            if ( m_page_shaded_int == 1 )
               {
                 t->AlphaFill(g_shade_color,g_shade_alpha);
               }

            t->PaintTo(hdc_dest,r.left,r.top);
          }

       delete wrp;
     }
}


BOOL CCore::Paint(HDC _hdc)
{
  BOOL rc = FALSE;
  
  if ( _hdc )
     {
       if ( !IsIconic(m_wnd) )
          {
            int host_w=0,host_h=0;
            GetHostDim(host_w,host_h);

            if ( host_w > 0 && host_h > 0 )
               {
                 if ( m_screen && m_screen->IsValid() )
                    {
                      ASSERT(m_screen->IsSizeMatch(host_w,host_h));

                      // paint status string and exclude its clip rect
                      {
                        RECT r = {0,0,0,0};
                        GetStatusStringArea(r);
                        if ( !IsRectEmpty(&r) )
                           {
                             if ( m_status_buff )
                                m_status_buff->PaintTo(_hdc,r.left,r.top);

                             ExcludeClipRect(_hdc,r.left,r.top,r.right,r.bottom);
                           }
                      }
                      
                      // paint info text and exclude its clip rect
                      {
                        RECT r = {0,0,0,0};
                        GetInfoTextArea(r);
                        if ( !IsRectEmpty(&r) )
                           {
                             PaintInfoTextInternalNoCheck(_hdc,m_screen->GetHDC(),r);
                             ExcludeClipRect(_hdc,r.left,r.top,r.right,r.bottom);
                           }
                      }
                      
                      // paint the rest
                      m_screen->PaintTo(_hdc,0,0);

                      rc = TRUE;
                    }
               }
          }
     }

  return rc;
}


void CCore::UpdateInfoTextAnimation()
{
  if ( !IsStrEmpty(m_info_text) && m_infotext_buff && m_infotext_buff->IsValid() ) // optimization
     {
       BOOL is_busy = (conn && conn->IsWaitCursor && conn->IsWaitCursor());

       if ( !is_busy && m_page_shaded_int != 1 )
          {
            RECT r = {0,0,0,0};
            GetInfoTextArea(r);
            if ( !IsRectEmpty(&r) )
               {
                 if ( m_wnd )
                    {
                      POINT center = {(r.left+r.right)/2,(r.top+r.bottom)/2};
                      if ( ClientToScreen(m_wnd,&center) )
                         {
                           if ( WindowFromPoint(center) == m_wnd )
                              {
                                POINT cp;
                                if ( GetCursorPos(&cp) )  // desktop test
                                   {
                                     if ( !conn || !conn->CanUseGFX || conn->CanUseGFX() )
                                        {
                                          m_infotext_animation++;

                                          InvalidateRect(m_wnd,&r,FALSE);
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}


void CCore::ClearSheetsAr()
{
  for ( int n = 0; n < m_sheets.size(); n++ )
      {
        SAFEDELETE(m_sheets[n]);
      }

  m_sheets.clear();
}


void CCore::GetHostDim(int &_w,int &_h)
{
  RECT r = {0,0,0,0};
  GetClientRect(m_wnd,&r);

  _w = r.right - r.left;
  _h = r.bottom - r.top;
}


void CCore::GetSheetsArea(RECT &_r)
{
  SetRectEmpty(&_r);
  
  int vw=0,vh=0;
  GetHostDim(vw,vh);

  if ( vw > 0 && vh > 0 )
     {
       _r.left = g_leftpad;
       _r.right = vw - g_rightpad;
       _r.top = g_toppad + g_top_area_height + g_areas_border - 1/*!!!*/;
       _r.bottom = vh - g_bottompad - g_bottom_area_height - g_areas_border + 1/*!!!*/;

       if ( _r.right - _r.left <= 0 || _r.bottom - _r.top <= 0 )
          {
            SetRectEmpty(&_r);
          }
     }
}


void CCore::GetStatusStringArea(RECT &_r)
{
  SetRectEmpty(&_r);
  
  int vw=0,vh=0;
  GetHostDim(vw,vh);

  if ( vw > 0 && vh > 0 )
     {
       _r.left = 10;
       _r.right = vw - 10;
       _r.top = 0;
       _r.bottom = g_top_area_height;

       if ( _r.right - _r.left <= 0 || _r.bottom - _r.top <= 0 )
          {
            SetRectEmpty(&_r);
          }
     }
}


void CCore::GetInfoTextArea(RECT &_r)
{
  SetRectEmpty(&_r);
  
  int vw=0,vh=0;
  GetHostDim(vw,vh);

  if ( vw > 0 && vh > 0 )
     {
       _r.left = 10;
       _r.right = MIN(vw/2-50,450);
       _r.top = vh - g_bottom_area_height + 5;
       _r.bottom = vh - g_taskbar_area_height - 5;

       if ( _r.right - _r.left <= 0 || _r.bottom - _r.top <= 0 )
          {
            SetRectEmpty(&_r);
          }
     }
}


int CCore::GetInfoTextFullTextHeight(const char *text,int width)
{
  int rc = 0;
  
  HDC hdc = CreateCompatibleDC(NULL);

  {
    CFont f(hdc,g_infotext_font,g_infotext_size,g_infotext_weight,CLEARTYPE_QUALITY);
    RECT r = {0,0,width,1};
    rc = IsStrEmpty(text) ? 0 : f.DrawText(text,r,g_infotext_format|DT_CALCRECT);
  }

  DeleteDC(hdc);

  return rc;
}


HRGN CCore::CreatePaintRgnInternal(const RECT &r_init,int combine_mode)
{
  HRGN rgn = CreateRectRgnIndirect(&r_init);

  if ( rgn )
     {
       for ( int n = 0; n < 2; n++ )
           {
             RECT r = {0,0,0,0};

             if ( n == 0 )
                GetStatusStringArea(r);
             else
                GetInfoTextArea(r);

             HRGN t = CreateRectRgnIndirect(&r);
             if ( t )
                {
                  CombineRgn(rgn,rgn,t,combine_mode);
                  DeleteObject(t);
                }
           }
     }

  return rgn;
}


HRGN CCore::CreateExclPaintRgn()
{
  RECT r = {0,0,0,0};
  return CreatePaintRgnInternal(r,RGN_OR);
}


HRGN CCore::CreateInclPaintRgn()
{
  int w=0,h=0;
  GetHostDim(w,h);
  RECT r = {0,0,w,h};
  return CreatePaintRgnInternal(r,RGN_XOR);
}


void CCore::CalculateSheetDim(int &_w,int &_h,int numsheets)
{
  _w = 0;
  _h = 0;
  
  RECT shr = {0,0,0,0};
  GetSheetsArea(shr);

  int vw = shr.right - shr.left;
  int vh = shr.bottom - shr.top;

  if ( vw > 0 && vh > 0 )
     {
       const int max_sheet_w = 310;

       int curr_w = max_sheet_w;
       int curr_h;

       do {
        curr_h = curr_w * 94 / 100;

        if ( curr_h == 0 )
           break;

        int fit_horiz = vw / curr_w;
        int fit_vert = vh / curr_h;

        if ( fit_horiz * fit_vert >= numsheets )
           break;

        curr_w--;

       } while ( curr_w > 0 );

       if ( curr_w == 0 || curr_h == 0 )
          {
            curr_w = 0;
            curr_h = 0;
          }

       _w = curr_w;
       _h = curr_h;
     }
}


void CCore::GetSheetRect(int idx,RECT &_r)
{
  SetRectEmpty(&_r);

  if ( idx >= 0 && idx < m_sheets.size() )
     {
       if ( m_sheet_width > 0 && m_sheet_height > 0 )
          {
            RECT shr = {0,0,0,0};
            GetSheetsArea(shr);

            const int vw = shr.right - shr.left;
            const int vh = shr.bottom - shr.top;

            if ( vw > 0 && vh > 0 )
               {
                 const int numsheets = m_sheets.size();

                 const int fit_horiz = vw / m_sheet_width;
                 const int fit_vert = vh / m_sheet_height;

                 if ( fit_horiz > 0 && fit_vert > 0 )
                    {
                      int num_rows = (numsheets + fit_horiz - 1) / fit_horiz;
                      int row = idx / fit_horiz;
                      int offs_y = (vh - (num_rows * m_sheet_height)) / 2;
                      int abs_y = shr.top + offs_y + row * m_sheet_height;
                      int num_cols = (row == num_rows-1) ? ((numsheets-1) % fit_horiz)+1 : fit_horiz;
                      int col = (idx % fit_horiz);
                      int offs_x = (vw - (num_cols * m_sheet_width)) / 2;
                      int abs_x = shr.left + offs_x + col * m_sheet_width;

                      _r.left = abs_x;
                      _r.right = _r.left + m_sheet_width;
                      _r.top = abs_y;
                      _r.bottom = _r.top + m_sheet_height;
                    }
               }
          }
     }
}


CLayer* CCore::CreateSheetLayer(int total_width,int total_height,const char *_filename,const char *_text,
                                int *_fsize,int actual_fsize)
{
  if ( _fsize )
     *_fsize = 0;
  
  CLayer32 *out = _fsize ? NULL : new CLayer32(total_width,total_height,FALSE);

  if ( !out || out->IsValid() )
     {
       if ( out )
          {
            out->Fill(RGB(0,0,0),0);
          }

       int sheet_xoffs = 20;
       int sheet_yoffs = 13;
       const int text_hpad = 12;
       const int text_vpad = 8;
       const int shadow_smooth = 5;
       
       int sheet_bound_width = total_width - 2 * sheet_xoffs;
       int sheet_bound_height = sheet_bound_width * 3 / 4;  // we use 4x3 dims

       if ( sheet_bound_width > 0 && sheet_bound_height > 0 )
          {
            int sheet_width = 0;
            int sheet_height = 0;

            BOOL b_default_image = FALSE;

            HBITMAP bmp = m_thumbs->GetThumb(_filename,b_default_image);
            if ( bmp )
               {
                 int bw=0,bh=0;
                 GetBitmapDim(bmp,bw,bh);

                 if ( bw > 0 && bh > 0 )
                    {
                      if ( bw * sheet_bound_height / bh < sheet_bound_width )
                         {
                           sheet_height = sheet_bound_height;
                           sheet_width = bw * sheet_bound_height / bh;
                         }
                      else
                         {
                           sheet_width = sheet_bound_width;
                           sheet_height = bh * sheet_bound_width / bw;
                         }
                    }
               }
            
            if ( sheet_width > 0 && sheet_height > 0 )
               {
                 sheet_xoffs = (total_width - sheet_width) / 2;

                 int image_alpha = b_default_image ? 80 : 255;
                 
                 if ( out )
                    {
                      const CLayer *shadow = m_shadows->GetLayer(sheet_width,sheet_height,shadow_smooth,130);
                      if ( shadow )
                         {
                           if ( image_alpha == 255 )
                              shadow->PaintTo(*out,sheet_xoffs,sheet_yoffs); // optimization
                           else
                              shadow->PaintTo(*out,sheet_xoffs,sheet_yoffs,image_alpha);
                         }
                    }

                 if ( out && bmp )
                    {
                      CTempLayersCache::CWrapper *wrp = CTempLayersCache::GetLayer(sheet_width,sheet_height,32);
                      if ( wrp )
                         {
                           CLayer32 *t = static_cast<CLayer32*>(wrp->GetLayer());
                           if ( t && t->IsValid() )
                              {
                                t->ApplyBitmap(bmp,InterpolationModeBilinear);
                                ::ApplyCornerEffect(*t);
                                if ( image_alpha == 255 )
                                   t->PaintTo(*out,sheet_xoffs,sheet_yoffs); //optimization
                                else
                                   t->PaintTo(*out,sheet_xoffs,sheet_yoffs,image_alpha);
                              }

                           delete wrp;
                         }
                    }

                 if ( 1 /*!IsStrEmpty(_text)*/ )
                    {
                      const int text_height = total_height - text_vpad - sheet_yoffs - sheet_bound_height - text_vpad;

                      if ( text_height > 0 )
                         {
                           RECT r;
                           r.left = text_hpad;
                           r.top = sheet_yoffs + sheet_height + text_vpad;
                           r.right = total_width - text_hpad;
                           r.bottom = r.top + text_height;

                           if ( r.right - r.left > 0 )
                              {
                                RECT r2 = r;
                                OffsetRect(&r2,3,3);

                                const int format = DT_TOP | DT_CENTER | DT_WORDBREAK;

                                int fsize = actual_fsize;
                                
                                if ( _fsize || actual_fsize == 0 )
                                   {
                                     fsize = GetFontSizeToFitIn(-24,r,_text,format,"Arial",FW_BOLD);
                                     if ( _fsize )
                                        *_fsize = fsize;
                                   }

                                if ( out && !IsStrEmpty(_text) )
                                   {
                                     DrawSmoothTextWithShadow(*out,r,r2,_text,format,"Arial",
                                                             fsize,FW_BOLD,RGB(255,255,255),130,3);
                                   }
                              }
                         }
                    }
               }
          }
     }

  return out;
}


BOOL CCore::SheetHitTest(int x,int y,int &_idx)
{
  BOOL find = FALSE;

  _idx = -1;
  
  for ( int n = 0; n < m_sheets.size(); n++ )
      {
        RECT r = {0,0,0,0};
        GetSheetRect(n,r);

        POINT p = {x,y};

        if ( PtInRect(&r,p) )
           {
             _idx = n;
             
             const CLayer* t = m_sheets[n]->GetLayer();
             if ( t && t->IsValid() )
                {
                  ASSERT(t->IsSizeMatch(r.right-r.left,r.bottom-r.top));
                  ASSERT(t->IsAlpha());
                  
                  const BYTE *pixel = t->GetPointer(x-r.left,y-r.top);
                  ASSERT(pixel);

                  if ( pixel )
                     {
                       if ( pixel[3] > 0 )
                          {
                            find = TRUE;
                          }
                     }
                }

             break;
           }
      }

  return find;
}


void CCore::OnMouseMove(int x,int y)
{
  const char *cursor = NULL;
  
  if ( conn && conn->IsWaitCursor && conn->IsWaitCursor() )
     {
       cursor = IDC_WAIT;
     }
  else
     {
       int idx = -1;
       cursor = SheetHitTest(x,y,idx) ? IDC_HAND : IDC_ARROW;
     }
  
  SetCursor(LoadCursor(NULL,cursor));
}


void CCore::OnMouseClick(int x,int y)
{
  int idx = -1;
  if ( SheetHitTest(x,y,idx) )
     {
       ASSERT(idx!=-1);

       if ( conn && conn->SetSheetActive ) 
          {
            conn->SetSheetActive(idx,TRUE);
          }
     }
}


void CCore::OnUserMessage(UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == user_message )
     {
       if ( wParam == MSG_UPDATETHUMB )
          {
            char *filename = (char*)lParam;
            if ( filename )
               {
                 BOOL find = FALSE;
                 for ( int n = 0; n < m_sheets.size(); n++ )
                     {
                       CSheet *sheet = m_sheets[n];
                       
                       if ( !lstrcmpi(sheet->GetFileName(),filename) )
                          {
                            CLayer *layer = CreateSheetLayer(m_sheet_width,m_sheet_height,sheet->GetFileName(),sheet->GetText(),NULL,m_fsize_min);
                            sheet->ReplaceLayer(layer);
                            find = TRUE;
                          }
                     }

                 if ( find )
                    {
                      b_need_postponded_refresh = TRUE;
                    }

                 if ( b_need_postponded_refresh )
                    {
                      ASSERT(m_wnd);
                      MSG msg;
                      BOOL msg_in_queue = PeekMessage(&msg,m_wnd,user_message,user_message,PM_NOREMOVE);
                      if ( !msg_in_queue )
                         {
                           b_need_postponded_refresh = FALSE;
                           RefreshInternal(TRUE);
                         }
                    }

                 FREEANDNULL(filename);
               }
          }
     }
}


