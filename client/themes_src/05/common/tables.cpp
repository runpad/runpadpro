
#include "common.h"


static CTables g_tables;

BYTE CTables::div10byte[256*10];
BYTE CTables::div12byte[256*12];


CTables::CTables()
{
  // div10 table
  for ( int n = 0; n < sizeof(div10byte)/sizeof(div10byte[0]); n++ )
      {
        div10byte[n] = n / 10;
      }

  // div12 table
  for ( int n = 0; n < sizeof(div12byte)/sizeof(div12byte[0]); n++ )
      {
        div12byte[n] = n / 12;
      }
}


CTables::~CTables()
{
}




