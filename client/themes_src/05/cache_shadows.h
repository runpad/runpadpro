
#ifndef __CACHE_SHADOWS_H__
#define __CACHE_SHADOWS_H__



class CShadowsCache
{
         class CCached
         {
                  int sheet_width;
                  int sheet_height;
                  int smooth;
                  BYTE alpha;
                  CLayer *layer;

           public:
                  CCached(int _w,int _h,int _smooth,BYTE _alpha) :
                    sheet_width(_w), sheet_height(_h), smooth(_smooth), alpha(_alpha) 
                  {
                    layer = ::CreateSheetShadowLayer(_w,_h,_smooth,_alpha);
                  }
                  ~CCached()
                  {
                    SAFEDELETE(layer);
                  }
                  BOOL IsSame(int _w,int _h,int _smooth,BYTE _alpha) const
                  {
                    return sheet_width == _w &&
                           sheet_height == _h &&
                           smooth == _smooth &&
                           alpha == _alpha;
                  }
                  const CLayer* GetLayer() const { return layer; }
         };

         std::vector<CCached*> m_cache;

  public:
         CShadowsCache();
         ~CShadowsCache();

         void Clear();
         const CLayer* GetLayer(int sheet_width,int sheet_height,int smooth,BYTE alpha);
};




#endif

