
#include "common.h"



CTempLayersCache CTempLayersCache::m_obj; //singletone


CTempLayersCache::CTempLayersCache()
{
}


CTempLayersCache::~CTempLayersCache()
{
  ClearAll();
}


void CTempLayersCache::ClearAll()
{
  for ( int n = 0; n < m_layers.size(); n++ )
      {
        ASSERT(!m_layers[n]->IsLocked());
        SAFEDELETE(m_layers[n]);
      }

  m_layers.clear();
}


unsigned CTempLayersCache::GetTotalCacheSize()
{
  unsigned res = 0;
  
  for ( int n = 0; n < m_layers.size(); n++ )
      {
        CLayer* t = m_layers[n]->GetLayer();
        if ( t && t->IsValid() )
           {
             res += t->GetDataSize();
           }
      }

  return res;
}


void CTempLayersCache::ClearSomeUnused()
{
  do {

    if ( m_layers.size() <= g_max_layers && GetTotalCacheSize() <= g_max_bytes )
       break;

    BOOL b_deleted = FALSE;
    for ( TLayers::iterator it = m_layers.begin(); it != m_layers.end(); ++it )
        {
          CTempLayer* t = *it;
          ASSERT(t);

          if ( !t->IsLocked() )
             {
               SAFEDELETE(t);
               m_layers.erase(it);
               b_deleted = TRUE;
               break;
             }
        }

    if ( !b_deleted )
       break;

  } while ( 1 );
}


CTempLayersCache::CWrapper* CTempLayersCache::GetLayer(int width,int height,int bpp)
{
  return m_obj.GetLayerInternal(width,height,bpp);
}


CTempLayersCache::CWrapper* CTempLayersCache::GetLayerInternal(int width,int height,int bpp)
{
  CWrapper *out = NULL;

  for ( int n = 0; n < m_layers.size(); n++ )
      {
        if ( !m_layers[n]->IsLocked() )
           {
             const CLayer* t = m_layers[n]->GetLayer();
             if ( t && t->IsValid() && t->IsStrictMatch(width,height,bpp) )
                {
                  out = new CWrapper(m_layers[n]);
                  ASSERT(m_layers[n]->IsLocked());
                  break;
                }
           }
      }

  if ( !out )
     {
       ClearSomeUnused();

       CLayer *layer = new CLayer(width,height,bpp,FALSE);
       CTempLayer *temp = new CTempLayer(layer);
       ASSERT(!temp->IsLocked());

       m_layers.push_back(temp);

       out = new CWrapper(temp);
       ASSERT(temp->IsLocked());
     }

  return out;
}




