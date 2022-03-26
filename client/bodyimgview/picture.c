#include "picture.h"

void InitPicture(PICTURE* p)
{
  p->buf = 0;
  p->own = 0;
  p->rotate = 0;
  p->w = 0;
  p->h = 0;
}

void FreePicture(PICTURE* p)
{
  if ( p->buf && p->own )
     {
       sys_free(p->buf);
     }
  p->own = 0;
  p->buf = 0;
  p->rotate = 0;
  p->w = 0;
  p->h = 0;

}