
#ifndef __RLE7_H__
#define __RLE7_H__


class CRLE7
{
  public:
         static int Compress(const unsigned char *src1,const unsigned char *src2,unsigned char *dest,int size);
         static BOOL Decode(const unsigned char *buff,unsigned char *screen,int size,int dest_size);
};


#endif
