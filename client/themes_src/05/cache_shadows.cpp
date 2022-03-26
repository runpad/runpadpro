
#include "include.h"




CShadowsCache::CShadowsCache()
{
}


CShadowsCache::~CShadowsCache()
{
  Clear();
}


void CShadowsCache::Clear()
{
  for ( int n = 0; n < m_cache.size(); n++ )
      {
        SAFEDELETE(m_cache[n]);
      }

  m_cache.clear();
}


const CLayer* CShadowsCache::GetLayer(int sheet_width,int sheet_height,int smooth,BYTE alpha)
{
  CCached *c = NULL;
  
  for ( int n = 0; n < m_cache.size(); n++ )
      {
        if ( m_cache[n]->IsSame(sheet_width,sheet_height,smooth,alpha) )
           {
             c = m_cache[n];
             break;
           }
      }

  if ( !c )
     {
       c = new CCached(sheet_width,sheet_height,smooth,alpha);
       m_cache.push_back(c);
     }

  return c->GetLayer();
}


