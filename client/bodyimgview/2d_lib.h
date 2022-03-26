
#ifndef _2D_LIB_H
#define _2D_LIB_H


void SmoothImage24(void *img,int w,int h);
void SmoothImage8(void *img,int w,int h);
void ResizeImage24(void *src,int w,int h,void *dest,int neww,int newh,int filter);
void ResizeImage8(void *src,int w,int h,void *dest,int neww,int newh,int filter,int rowstride);

#endif
