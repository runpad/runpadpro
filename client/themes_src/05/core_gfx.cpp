
#include "include.h"



#include "gfx_data.inc"



void ApplyCornerEffect(CLayer &layer)
{
  if ( layer.IsValid() && layer.IsAlpha() )
     {
       const int w = layer.GetWidth();
       const int h = layer.GetHeight();

       if ( w >= 2*CORNER_RADIUS && h >= 2*CORNER_RADIUS )
          {
            for ( int m = 0; m < h; m++ )
                {
                  int y;
                  BOOL stopy=FALSE;

                  if ( m < CORNER_RADIUS )
                     y = m;
                  else
                  if ( m >= h - CORNER_RADIUS )
                     y = m - (h - CORNER_RADIUS) + CORNER_RADIUS;
                  else
                     {
                       y = CORNER_RADIUS;
                       stopy = TRUE;
                     }

                  BYTE *p = layer.GetPointer(0,m);

                  for ( int n = 0; n < w; n++ )
                      {
                        int x;
                        BOOL stopx=FALSE;
                        
                        if ( n < CORNER_RADIUS )
                           x = n;
                        else
                        if ( n >= w - CORNER_RADIUS )
                           x = n - (w - CORNER_RADIUS) + CORNER_RADIUS;
                        else
                           {
                             x = CORNER_RADIUS;
                             stopx = TRUE;
                           }

                        if ( !stopx || !stopy )
                           {
                             int effect = CORNER_EFFECT(x,y);

                             if ( effect != 0 && effect != 255 && effect != 128 )
                                {
                                  int delta = (effect - 128);
                                  float k = delta < 0 ? 0.90 : 1.1;

                                  int c;
                                  c = f2i(p[0]*k) + delta; c = MIN(c,255); c = MAX(c,0); p[0] = c;
                                  c = f2i(p[1]*k) + delta; c = MIN(c,255); c = MAX(c,0); p[1] = c;
                                  c = f2i(p[2]*k) + delta; c = MIN(c,255); c = MAX(c,0); p[2] = c;
                                }

                             int alpha = CORNER_ALPHA(x,y);
                             p[0] = p[0] * alpha / 255;
                             p[1] = p[1] * alpha / 255;
                             p[2] = p[2] * alpha / 255;
                             p[3] = alpha;
                           }
                      
                        p += 4;
                      }
                }
          }
     }
}


CLayer32* CreateSheetShadowLayer(int sheet_width,int sheet_height,int smooth,BYTE alpha)
{
  ASSERT(smooth>=0);
  
  int new_width = sheet_width + 2*smooth + 2;
  int new_height = sheet_height + 2*smooth + 2;

  CLayer32 *out = new CLayer32(new_width,new_height,FALSE);

  if ( out->IsValid() )
     {
       out->Fill(RGB(0,0,0),0);  // only black is supported here
       
       if ( sheet_width >= CORNER_DIAM && sheet_height >= CORNER_DIAM )
          {
            int w = sheet_width;
            int h = sheet_height;

            int xoffs = (new_width - sheet_width)/2;
            int yoffs = (new_height - sheet_height)/2;

            for ( int m = 0; m < h; m++ )
                {
                  BYTE *row = out->GetPointer(xoffs+0,yoffs+m);

                  int y;
                  if ( m < CORNER_RADIUS )
                     y = m;
                  else
                  if ( m >= h - CORNER_RADIUS )
                     y = m - (h - CORNER_RADIUS) + CORNER_RADIUS;
                  else
                     y = CORNER_RADIUS;
                  
                  for ( int n = 0; n < w; n++ )
                      {
                        int x;
                        if ( n < CORNER_RADIUS )
                           x = n;
                        else
                        if ( n >= w - CORNER_RADIUS )
                           x = n - (w - CORNER_RADIUS) + CORNER_RADIUS;
                        else
                           x = CORNER_RADIUS;
                      
                        if ( CORNER_ALPHA(x,y) >= 128 )
                           row[3] = alpha;
                        else
                           row[3] = 0;

                        row += 4;
                      }
                }

            out->Smooth<9>(smooth,3,3);
          }
     }

  return out;
}


CLayer32* CreateLighterLayer(int width,int height,int color,float alpha_k)
{
  CLayer32 *out = new CLayer32(width,height,FALSE);

  if ( out->IsValid() )
     {
       if ( width >= LIGHTER_DIAM && height >= LIGHTER_DIAM )
          {
            BYTE alpha_t[256];

            for ( int n = 0; n < 256; n++ )
                {
                  int t = f2i(n * alpha_k);
                  t = MIN(t,255); 
                  t = MAX(t,0);
                  alpha_t[n] = t;
                }

            out->Fill(color,alpha_t[LIGHTER_ALPHA(LIGHTER_RADIUS,LIGHTER_RADIUS)]);
                
            int w = width;
            int h = height;

            int c_r = GetRValue(color);
            int c_g = GetGValue(color);
            int c_b = GetBValue(color);

            for ( int m = 0; m < height; m++ )
                {
                  BYTE *row = out->GetPointer(0,m);

                  int y;
                  BOOL stopy=FALSE;

                  if ( m < LIGHTER_RADIUS )
                     y = m;
                  else
                  if ( m >= h - LIGHTER_RADIUS )
                     y = m - (h - LIGHTER_RADIUS) + LIGHTER_RADIUS;
                  else
                     {
                       y = LIGHTER_RADIUS;
                       stopy = TRUE;
                     }
                  
                  for ( int n = 0; n < width; n++ )
                      {
                        int x;
                        BOOL stopx=FALSE;

                        if ( n < LIGHTER_RADIUS )
                           x = n;
                        else
                        if ( n >= w - LIGHTER_RADIUS )
                           x = n - (w - LIGHTER_RADIUS) + LIGHTER_RADIUS;
                        else
                           {
                             x = LIGHTER_RADIUS;
                             stopx = TRUE;
                           }
                      
                        if ( !stopx || !stopy )
                           {
                             int alpha = alpha_t[LIGHTER_ALPHA(x,y)];

                             row[0] = c_b * alpha / 255;
                             row[1] = c_g * alpha / 255;
                             row[2] = c_r * alpha / 255;
                             row[3] = alpha;
                           }

                        row += 4;
                      }
                }
          }
       else
          {
            //out->Fill(color,255);
            out->Fill(color,0);
          }
     }

  return out;
}




