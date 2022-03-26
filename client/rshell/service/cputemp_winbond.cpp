
#include "include.h"


#define RANGE(v,min,max,def)  (((v) < (min) || (v) > (max)) ? (def) : (v))
#define MY_MAX(a,b)  ((a) > (b) ? (a) : (b))


#define INDEX     0x295
#define DATA      0x296


static int ReadRegister(int idx)
{
  _outp(INDEX, idx);
  return _inp(DATA) & 0xFF;
}

static void WriteRegister(int idx,int data)
{
  _outp(INDEX, idx);
  _outp(DATA, data);
}

static void SetBank(int bank)
{
  WriteRegister(0x4E,0x80|bank);
}


BOOL GetCPUTemp_Winbond(int *_temp1,int *_temp2,int *_fan)
{
  BOOL rc = FALSE;
  
  *_temp1 = 0;
  *_temp2 = 0;
  *_fan = 0;

  // CPU
  SetBank(1);
  int cpu_temp = ReadRegister(0x50);
  if ( cpu_temp == 0xFF )
     cpu_temp = 0;

  // MBM
  int mbm_temp = ReadRegister(0x27); //not SetBank() needed
  if ( mbm_temp == 0xFF )
     mbm_temp = 0;

  // FanDiv
  int fan1div_lo = (ReadRegister(0x47) >> 4) & 3;
  int fan2div_lo = (ReadRegister(0x47) >> 6) & 3;
  SetBank(0);
  int fan1div_hi = (ReadRegister(0x5D) >> 5) & 1;
  SetBank(0);
  int fan2div_hi = (ReadRegister(0x5D) >> 6) & 1;
  int fan1div = (fan1div_hi << 2) | fan1div_lo; // 0..7
  int fan2div = (fan2div_hi << 2) | fan2div_lo; // 0..7
  fan1div = (1 << fan1div); // 1..128
  fan2div = (1 << fan2div); // 1..128

  // FanCounters
  int fan1 = ReadRegister(0x28);
  if ( fan1 != 0 )
     fan1 = 1350000 / (fan1 * fan1div);
  fan1 = RANGE(fan1,61,20000,0);

  int fan2 = ReadRegister(0x29);
  if ( fan2 != 0 )
     fan2 = 1350000 / (fan2 * fan2div);
  fan2 = RANGE(fan2,61,20000,0);

  int fan = MY_MAX(fan1,fan2);

  // output
  *_temp1 = cpu_temp;
  *_temp2 = mbm_temp;
  *_fan = fan;

  rc = (cpu_temp != 0 || mbm_temp != 0 || fan != 0);

  return rc;
}
