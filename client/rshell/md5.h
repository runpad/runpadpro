
#ifndef __MD5_H__
#define __MD5_H__



class CMD5
{
          typedef unsigned char *POINTER;
          typedef const unsigned char *CPOINTER;

          /* UINT2 defines a two byte word */
          typedef unsigned short UINT2;

          /* UINT4 defines a four byte word */
          typedef unsigned long UINT4;


          struct {
            UINT4 state[4];                                   /* state (ABCD) */
            UINT4 count[2];        /* number of bits, modulo 2^64 (lsb first) */
            unsigned char buffer[64];                         /* input buffer */
          } context;

  public:
          CMD5();
          ~CMD5();

          void Update(const unsigned char *buff,unsigned int len);
          void Final(unsigned char digest[16]);

          static const char* Str2MD5(const char *src,char *md5_str /*at least 33 chars*/);

  private:
          void MD5Transform (UINT4 state[4],const unsigned char block[64]);
          void Encode (unsigned char *output, const UINT4 *input, unsigned int len);
          void Decode (UINT4 *output, const unsigned char *input, unsigned int len);
          void MD5_memcpy (POINTER output, CPOINTER input, unsigned int len);
          void MD5_memset (POINTER output, int value, unsigned int len);

};


class CStr2MD5
{
         char s_out[64];  // only 33 is needed

  public:
         CStr2MD5(const char *str);
         ~CStr2MD5();

         operator const char* () const { return s_out; }
         const char* GetMD5() const { return s_out; }
};



#endif
