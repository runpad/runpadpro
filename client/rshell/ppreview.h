
#ifndef __PPREVIEW_H__
#define __PPREVIEW_H__

#include <vector>


class CPicPreview : public CWindowProc
{
            typedef struct {
             HBITMAP hbitmap;  //do not free it!
             const WCHAR *name; //do not free it!
             BOOL current;
             RECT r_total; //absolute
             RECT r_pic;  //relative
             RECT r_name; //relative
            } PIC;

            typedef std::vector<PIC> TPics;
            TPics g_pics;

            RBUFF back_buff;

            unsigned last_move_time;
            unsigned close_time_sec;

            int max_pic_w;

  public:
            CPicPreview(int _max_pic_w);
            virtual ~CPicPreview();

            int ShowModal(HWND parent,const WCHAR *title,int maxtime);

  protected:
            virtual void SetFirst() = 0;
            virtual BOOL GetNext(HBITMAP &_bitmap,const WCHAR* &_name,BOOL &_selected) = 0;

            virtual LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

  private:
            void GetTitleRect(RECT *r);
            void GetSheetRect(int num,RECT *r_total,RECT *r_pic,RECT *r_name);
            int GetSheetNumByPos(int x,int y);
            void PrepareBuffer(const WCHAR *title);
            void FreeBuffer();

};



class CFlagsPreview : public CPicPreview
{
            typedef std::vector<HBITMAP> TBitmaps;
            typedef std::vector<const WCHAR*> TNames;

            TBitmaps g_bitmaps;
            TNames g_names;
            int g_idx;

  public:
            CFlagsPreview();
            ~CFlagsPreview();

  protected:
            virtual void SetFirst();
            virtual BOOL GetNext(HBITMAP &_bitmap,const WCHAR* &_name,BOOL &_selected);
};




#endif
