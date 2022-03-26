

#ifndef _PICTURE_H
#define _PICTURE_H


typedef struct
{
  void *buf;  // pointer to pixel data
  int own;   // 1 if buf is owned, 0 if buf - just duplicated pointer
  int w, h;   // width & height
  int rotate; // rotation flag. See also global rotate flag.
} PICTURE;


void InitPicture(PICTURE* p);
void FreePicture(PICTURE* p);


#endif