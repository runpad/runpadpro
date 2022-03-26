
#include <windows.h>
#include "utils.h"
#include "2d_lib.h"
#include "fp.h"


typedef struct {
unsigned char r,g,b;
} RGB;



void SmoothImage24(void *img,int w,int h)
{
  RGB *temp,*in,*out;
  int i,j,nw,nh;
  
  nw = w+2;
  nh = h+2;
  
  temp = sys_alloc(nw*nh*3);
  if ( !temp )
     return;

  // copy original
  in = (RGB *)img;
  out = &temp[nw];
  for ( j = 0; j < h; j++ )
      {
        out[0] = in[0];
        out[nw-1] = in[w-1];
        sys_memcpy(&out[1],in,w*3);
        in += w;
        out += nw;
      }
  sys_memcpy(&temp[0],&temp[nw],nw*3);
  sys_memcpy(&temp[(nh-1)*nw],&temp[(nh-2)*nw],nw*3);

  // process
  out = img;
  for ( j = 0; j < h; j++ )
      {
        in = &temp[(j+1)*nw+1];

        for ( i = 0; i < w; i++ )
            {
              RGB *p2,*p4,*p5,*p6,*p8;

              p5 = in;
              p4 = in-1;
              p6 = in+1;
              p2 = in-nw;
              p8 = in+nw;

              out->r = (((int)p2->r + p4->r + p6->r + p8->r) + ((int)p5->r << 3)) / 12;
              out->g = (((int)p2->g + p4->g + p6->g + p8->g) + ((int)p5->g << 3)) / 12;
              out->b = (((int)p2->b + p4->b + p6->b + p8->b) + ((int)p5->b << 3)) / 12;

              out++;
              in++;
            }
      }

  sys_free(temp);
}



void SmoothImage8(void *img,int w,int h)
{
  unsigned char *temp,*in,*out;
  int i,j,nw,nh;
  
  nw = w+2;
  nh = h+2;
  
  temp = sys_alloc(nw*nh*1);
  if ( !temp )
     return;

  // copy original
  in = (unsigned char *)img;
  out = &temp[nw];
  for ( j = 0; j < h; j++ )
      {
        out[0] = in[0];
        out[nw-1] = in[w-1];
        sys_memcpy(&out[1],in,w*1);
        in += w;
        out += nw;
      }
  sys_memcpy(&temp[0],&temp[nw],nw*1);
  sys_memcpy(&temp[(nh-1)*nw],&temp[(nh-2)*nw],nw*1);

  // process
  out = img;
  for ( j = 0; j < h; j++ )
      {
        in = &temp[(j+1)*nw+1];

        for ( i = 0; i < w; i++ )
            {
              unsigned char *p2,*p4,*p5,*p6,*p8;

              p5 = in;
              p4 = in-1;
              p6 = in+1;
              p2 = in-nw;
              p8 = in+nw;

              *out++ = (((int)*p2 + *p4 + *p6 + *p8) + (((int)*p5) << 3)) / 12;
              in++;
            }
      }

  sys_free(temp);
}



void ResizeImage24(void *src,int w,int h,void *dest,int neww,int newh,int filter)
{
  int i,j,ix,iy;
  float kx,ky,x,y,u,v,k1,k2,k3,k4;
  RGB *p1,*p2,*p3,*p4,*p,*row,*row0;
  
  FP_Set(PC_24 | RC_CHOP);
  
  kx = (float)w / neww;
  ky = (float)h / newh;
  
  p = (RGB *)dest;
  row0 = (RGB *)src;
  y = 0;
  
  if ( filter )
     {
       for ( j = 0; j < newh; j++ )
           {
             iy = f2i(y);
             v = y - iy;
             row = (RGB *)src + iy * w;
             x = 0;
             
             for ( i = 0; i < neww; i++  )
                 {
                   ix = f2i(x);
                   u = x - ix;
                   k4 = u * v;
                   k1 = 1 - u - v + k4;
                   k2 = u - k4;
                   k3 = v - k4;

                   p1 = &row[ix];
                   p2 = p1+1;
                   p3 = p1+w;
                   p4 = p3+1;
                   
                   if ( ix == w-1 )
                      {
                        p2 = &row[0];
                        p4 = p2+w;
                      }
                   if ( iy == h-1 )
                      {
                        p3 = &row0[ix];
                        p4 = p3+1;
                      }
                   if ( ix == w-1 && iy == h-1 )
                      p4 = &row0[0];

                   p->r = f2i(p1->r * k1 + p2->r * k2 + p3->r * k3 + p4->r * k4);
                   p->g = f2i(p1->g * k1 + p2->g * k2 + p3->g * k3 + p4->g * k4);
                   p->b = f2i(p1->b * k1 + p2->b * k2 + p3->b * k3 + p4->b * k4);

                   p++;
                   x += kx;
                 }

             y += ky;
           }
     }
  else
     {
       for ( j = 0; j < newh; j++ )
           {
             iy = f2i(y);
             row = (RGB *)src + iy * w;
             x = 0;
             
             for ( i = 0; i < neww; i++  )
                 {
                   ix = f2i(x);
                   *p++ = row[ix];
                   x += kx;
                 }

             y += ky;
           }
     }

  FP_Restore();
}



void ResizeImage8(void *src,int w,int h,void *dest,int neww,int newh,int filter,int rowstride)
{
  int i,j,ix,iy;
  float kx,ky,x,y,u,v,k1,k2,k3,k4;
  unsigned char *p1,*p2,*p3,*p4,*p,*row,*row0;
  
  FP_Set(PC_24 | RC_CHOP);

  kx = (float)w / neww;
  ky = (float)h / newh;
  
  row0 = src;
  y = 0;
  
  if ( filter )
     {
       for ( j = 0; j < newh; j++ )
           {
             iy = f2i(y);
             v = y - iy;
             row = (unsigned char *)src + iy * w;
             x = 0;
             p = (unsigned char *)dest + j * rowstride;
             
             for ( i = 0; i < neww; i++  )
                 {
                   ix = f2i(x);
                   u = x - ix;
                   k4 = u * v;
                   k1 = 1 - u - v + k4;
                   k2 = u - k4;
                   k3 = v - k4;

                   p1 = &row[ix];
                   p2 = p1+1;
                   p3 = p1+w;
                   p4 = p3+1;
                   
                   if ( ix == w-1 )
                      {
                        p2 = &row[0];
                        p4 = p2+w;
                      }
                   if ( iy == h-1 )
                      {
                        p3 = &row0[ix];
                        p4 = p3+1;
                      }
                   if ( ix == w-1 && iy == h-1 )
                      p4 = &row0[0];

                   *p++ = f2i(*p1 * k1 + *p2 * k2 + *p3 * k3 + *p4 * k4);

                   x += kx;
                 }

             y += ky;
           }
     }
  else
     {
       for ( j = 0; j < newh; j++ )
           {
             iy = f2i(y);
             row = (unsigned char *)src + iy * w;
             x = 0;
             p = (unsigned char *)dest + j * rowstride;
             
             for ( i = 0; i < neww; i++  )
                 {
                   ix = f2i(x);
                   *p++ = row[ix];
                   x += kx;
                 }

             y += ky;
           }
     }

  FP_Restore();
}



