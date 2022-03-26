
#ifndef __CACHE_LAYER_H__
#define __CACHE_LAYER_H__



class CTempLayersCache
{
          class CWrapper;

          class CTempLayer
          {
                    CLayer *layer;
                    BOOL locked;

            protected:
                    friend class CTempLayersCache;

                    CTempLayer(CLayer *_layer) : layer(_layer), locked(FALSE) {}
                    ~CTempLayer() { ASSERT(!locked); SAFEDELETE(layer); }

            public:        
                    BOOL IsLocked() const { return locked; }
                    CLayer* GetLayer() const { return layer; }

            protected:
                    friend class CTempLayersCache::CWrapper;
                    
                    void SetLocked(BOOL _locked) { locked = _locked; }
                    void Lock() { SetLocked(TRUE); }
                    void Unlock() { SetLocked(FALSE); }
          };

  public:
          class CWrapper
          {
                    CTempLayer *temp;

            public:
                    CWrapper(CTempLayer *_temp) : temp(_temp)
                    {
                      ASSERT(temp);
                      ASSERT(!temp->IsLocked());
                      temp->Lock();
                    }
                    ~CWrapper()
                    {
                      ASSERT(temp->IsLocked());
                      temp->Unlock();
                      temp = NULL;
                    }
                    CLayer* GetLayer() const { return temp->GetLayer(); }
          };


  private:
          static const int g_max_layers = 30;
          static const int g_max_bytes = 3000000;

          typedef std::vector<CTempLayer*> TLayers;
          TLayers m_layers;

          static CTempLayersCache m_obj;

  public:
          CTempLayersCache();
          ~CTempLayersCache();

          static CWrapper* GetLayer(int width,int height,int bpp);

  private:
          void ClearAll();
          void ClearSomeUnused();
          unsigned GetTotalCacheSize();
          CWrapper* GetLayerInternal(int width,int height,int bpp);

};



#endif
