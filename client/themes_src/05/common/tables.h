
#ifndef __TABLES_H__
#define __TABLES_H__



class CTables
{
          static BYTE div10byte[256*10];
          static BYTE div12byte[256*12];

  public:
          CTables();
          ~CTables();

          static BYTE FastDiv10NotSafe(int v) { return div10byte[v]; }
          static BYTE FastDiv12NotSafe(int v) { return div12byte[v]; }
};




#endif

