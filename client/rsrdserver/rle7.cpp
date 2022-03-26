
#include "include.h"



//src2 maybe NULL
int CRLE7::Compress(const unsigned char *src1,const unsigned char *src2,unsigned char *dest,int size)
{
  if ( !src1 || !dest || !size )
     return 0;

  if ( !src2 )
     {
       const unsigned char *s = src1;
       unsigned char *d = dest;

       do {
        unsigned char c = ((*s++) + 1) & 0x7F;
        size--;

        int prev_count = 1;
        while ( size && prev_count < 256 )
        {
          unsigned char c2 = ((*s) + 1) & 0x7F;

          if ( c2 != c )
             break;

          s++;
          size--;
          prev_count++;
        }

        if ( prev_count > 2 )
           {
             *d++ = c | 0x80;
             *d++ = prev_count-1;
           }
        else
           {
             *d++ = c;
             if ( --prev_count )
                *d++ = c;
           }

       } while ( size );

       return d - dest;
     }
  else
     {
       if ( !memcmp(src1,src2,size) )
          return 0;
       
       const unsigned char *s1 = src1;
       const unsigned char *s2 = src2;
       unsigned char *d = dest;

       do {
         unsigned char t1 = *s1++;
         unsigned char t2 = *s2++;
         unsigned char c = (t1 == t2) ? 0 : ((t1+1)&0x7F);
         size--;

         int prev_count = 1;
         while ( size && prev_count < 256 ) 
         {
           unsigned char t1 = *s1;
           unsigned char t2 = *s2;
           unsigned char c2 = (t1 == t2) ? 0 : (t1+1)&0x7F;

           if ( c2 != c )
              break;

           s1++;
           s2++;
           size--;
           prev_count++;
        };

        if ( prev_count > 2 )
           {
             *d++ = c | 0x80;
             *d++ = prev_count-1;
           }
        else
           {
             *d++ = c;
             if ( --prev_count )
                *d++ = c;
           }

       } while ( size );

       return d - dest;
     }
}


BOOL CRLE7::Decode(const unsigned char *buff,unsigned char *screen,int size,int dest_size)
{
  const unsigned char *s = buff;
  unsigned char *d = screen;

  if ( !size || !dest_size || !buff || !screen )
     return FALSE;

  do {
   unsigned char c = *s++;
   size--;
   if ( c & 0x80 )
      {
        int count;
        
        if ( !size )
           return FALSE; //fatal error
        
        count = (int)(*s++) + 1;
        size--;

        if ( d + count - screen > dest_size )
           return FALSE; //fatal error
        
        c &= 0x7F;
        if ( c )
           {
             c--; //real color
             do {
                   *d++ = c;
             }  while ( --count );
           }
        else
           d += count;
      }
   else
      {
        if ( d + 1 - screen > dest_size )
           return FALSE; //fatal error
        
        if ( c )
           *d = c-1; //real color
        d++;
      }

  } while ( size );

  return (d - screen == dest_size);
}


