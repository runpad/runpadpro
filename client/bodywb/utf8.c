
#include <windows.h>
#include <shlwapi.h>
#include <malloc.h>


static BOOL Base64Decode(char *in,char *out,int max)
{
#define PUSHBIT(b)  { out[numbits/8] |= (b) << (7-(numbits&7)); numbits++; }
#define PUSHBITS(count,data) { int j; for ( j = 0; j < (count); j++ ) PUSHBIT(((data) >> ((count)-1-j))&1); }

  const char *table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  int n,m,numbits;

  if ( !in[0] )
     return FALSE;
  
  //if ( lstrlen(in) & 3 )
  //   return FALSE;

  ZeroMemory(out,max); //needed
  numbits = 0;
  
  for ( n = 0; n < lstrlen(in); n++ )
      {
        char c64 = in[n];

        if ( c64 == '=' )
           break;

        for ( m = 0; m < lstrlen(table); m++ )
            if ( table[m] == c64 )
               {
                 break;
               }

        if ( m == 64 )
           return FALSE;

        PUSHBITS(6,m);
      }

  PUSHBITS(8,0);
  PUSHBITS(8,0);

  return TRUE;

#undef PUSHBIT
#undef PUSHBITS
}


static BOOL UTF8DecodeInternalW(char *in,WCHAR *out)
{
  if ( !in[0] )
     return FALSE;

  while ( 1 )
  {
    unsigned char c = *in++, c2,c3,c4;

    if ( !c )
       break;

    if ( !(c & 0x80) )
       {
         *out++ = (unsigned)c;  //normal case
       }
    else
       {
         if ( (c & 0xE0) == 0xC0 )
            { //0x00000080 - 0x000007FF: 110xxxxx 10xxxxxx
              if ( lstrlen(in) < 1 )
                 return FALSE;

              c2 = *in++;
              if ( (c2 & 0xC0) != 0x80 )
                 return FALSE;

              *out++ = ((unsigned)(c & 0x1F) << 6) | (c2 & 0x3F);
            }
         else
         if ( (c & 0xF0) == 0xE0 )
            { //0x00000800 - 0x0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
              if ( lstrlen(in) < 2 )
                 return FALSE;

              c2 = *in++;
              if ( (c2 & 0xC0) != 0x80 )
                 return FALSE;

              c3 = *in++;
              if ( (c3 & 0xC0) != 0x80 )
                 return FALSE;

              *out++ = ((unsigned)(c & 0x0F) << 12) | ((unsigned)(c2 & 0x3F) << 6) | (c3 & 0x3F);
            }
         else
         if ( (c & 0xF8) == 0xF0 )
            { //0x00010000 - 0x001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
              if ( lstrlen(in) < 3 )
                 return FALSE;

              return FALSE; //unsupported
            }
         else
            return FALSE;
       }
  }

  *out++ = 0;
  return TRUE;
}


BOOL UTF8Decode64(char *_in,char *_out,int _max)
{
  char *s = _in;

  if ( s && lstrlen(s) > 12 && !StrCmpNI(s,"=?utf-8?",8) && s[9] == '?' && s[lstrlen(s)-1] == '=' && s[lstrlen(s)-2] == '?' )
     {
       char *in = (char*)alloca(_max);
       char *out = (char*)alloca(_max);

       lstrcpy(in,s+10);
       in[lstrlen(in)-2] = 0;

       if ( Base64Decode(in,out,_max) )
          {
            lstrcpy(in,out);

            if ( in[0] )
               {
                 WCHAR *out = (WCHAR*)alloca(_max*sizeof(WCHAR));
                 if ( UTF8DecodeInternalW(in,out) )
                    {
                      in[0] = 0;
                      WideCharToMultiByte(CP_ACP,0,out,-1,in,_max,NULL,NULL);

                      if ( in[0] )
                         {
                           lstrcpy(_out,in);
                           return TRUE;
                         }
                    }
               }
          }
     }

  return FALSE;
}


BOOL UTF8DecodeStupid(char *_in,char *_out,int _max)
{
  char *s = _in;

  if ( s && lstrlen(s) > 7 && !StrCmpNI(s,"utf-8\'\'",7) )
     {
       char *in = (char*)alloca(_max);
       char *out = (char*)alloca(_max);

       lstrcpy(in,s+7);
       UrlUnescapeInPlace(in,0);

       if ( in[0] )
          {
            WCHAR *out = (WCHAR*)alloca(_max*sizeof(WCHAR));
            if ( UTF8DecodeInternalW(in,out) )
               {
                 in[0] = 0;
                 WideCharToMultiByte(CP_ACP,0,out,-1,in,_max,NULL,NULL);

                 if ( in[0] )
                    {
                      lstrcpy(_out,in);
                      return TRUE;
                    }
               }
          }
     }

  return FALSE;
}


BOOL UTF8DecodeRaw(char *_in,char *_out,int _max)
{
  char *s = _in;

  if ( s && lstrlen(s) > 0 )
     {
       char *in = (char*)alloca(_max);
       char *out = (char*)alloca(_max);

       lstrcpy(in,s);
       UrlUnescapeInPlace(in,0);

       if ( in[0] )
          {
            WCHAR *out = (WCHAR*)alloca(_max*sizeof(WCHAR));
            if ( UTF8DecodeInternalW(in,out) )
               {
                 in[0] = 0;
                 WideCharToMultiByte(CP_ACP,0,out,-1,in,_max,NULL,NULL);

                 if ( in[0] )
                    {
                      lstrcpy(_out,in);
                      return TRUE;
                    }
               }
          }
     }

  return FALSE;
}


