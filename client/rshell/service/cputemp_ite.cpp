
#include "include.h"


#define RANGE(v,min,max,def)  (((v) < (min) || (v) > (max)) ? (def) : (v))
#define MY_MAX(a,b)  ((a) > (b) ? (a) : (b))

#define INDEX    0x2E
#define DATA     0x2F


static int ReadRegister(int idx)
{
  _outp(INDEX,idx);
  return _inp(DATA) & 0xFF;
}


static void WriteRegister(int idx,int data)
{
  _outp(INDEX,idx);
  _outp(DATA,data);
}


static void SetLDN(int ldn)
{
  WriteRegister(0x07,ldn);
}


static void EnterPnPMode()
{
  _outp(INDEX, 0x87);
  _outp(INDEX, 0x01);
  _outp(INDEX, 0x55);
  _outp(INDEX, 0x55);
}


static void LeavePnPMode()
{
  WriteRegister(0x02,0x02);
}


static int ReadECRegister(int base_addr,int idx)
{
  _outp(base_addr+5,idx);
  return _inp(base_addr+6) & 0xFF;
}


static void WriteECRegister(int base_addr,int idx,int data)
{
  _outp(base_addr+5,idx);
  _outp(base_addr+6,data);
}


BOOL GetCPUTemp_ITE(int *_temp1,int *_temp2,int *_fan)
{
  BOOL rc = FALSE;
  
  *_temp1 = 0;
  *_temp2 = 0;
  *_fan = 0;

  EnterPnPMode();

  int ver_hi = ReadRegister(0x20);
  int ver_lo = ReadRegister(0x21);
  int ver = (ver_hi << 8) | ver_lo;

  if ( ver == 0xFFFF || ver == 0x0000 )
     return rc;

  if ( ver != 0x8705 && ver != 0x8712 && ver != 0x8716 && ver != 0x8718 )
     {
       LeavePnPMode();
       return rc;
     }

  SetLDN(0x04); // environment control

  int base_addr = (ReadRegister(0x60) << 8) | ReadRegister(0x61);

//  int base_addr = 0x290; //better way

  if ( base_addr == 0xFFFF || base_addr == 0x0000 )
     {
       LeavePnPMode();
       return rc;
     }

  BOOL need_sleep = FALSE;

//  BOOL b_activated = ((ReadRegister(0x30)&1) != 0);
//  if ( !b_activated )
//     {
//       WriteRegister(0x30,0x01); //enable it
//       need_sleep = TRUE;
//     }

  LeavePnPMode();   // ASAP call this


  if ( need_sleep )
     {
       Sleep(100);
       need_sleep = FALSE;
     }


//  int conf_reg = ReadECRegister(base_addr,0x00);
//  if ( (conf_reg&0x09) != 0x01 )
//     {
//       WriteECRegister(base_addr,0x00,0x01); //enable monitoring
//       need_sleep = TRUE;
//     }
//
//  int fan_enable = ReadECRegister(base_addr,0x0C);
//  if ( (fan_enable&7) != 7 )
//     {
//       WriteECRegister(base_addr,0x0C,fan_enable|7); //enable FAN's inputs
//       need_sleep = TRUE;
//     }
 
  if ( need_sleep )
     {
       Sleep(100);
       need_sleep = FALSE;
     }
     
  int temp1 = ReadECRegister(base_addr,0x29); //CPU
  if ( temp1 == 0xFF )
     temp1 = 0;
  int temp2 = ReadECRegister(base_addr,0x2A); //MBM
  if ( temp2 == 0xFF )
     temp2 = 0;

  int fan1_lo = ReadECRegister(base_addr,0x0D);
  int fan2_lo = ReadECRegister(base_addr,0x0E);
  int fan3_lo = ReadECRegister(base_addr,0x0F);
  int fan1_hi = ReadECRegister(base_addr,0x18);
  int fan2_hi = ReadECRegister(base_addr,0x19);
  int fan3_hi = ReadECRegister(base_addr,0x1A);

  int fan1 = (fan1_hi << 8) | fan1_lo;
  int fan2 = (fan2_hi << 8) | fan2_lo;
  int fan3 = (fan3_hi << 8) | fan3_lo;

  if ( fan1 == 0xFFFF )
     fan1 = 0;
  if ( fan2 == 0xFFFF )
     fan2 = 0;
  if ( fan3 == 0xFFFF )
     fan3 = 0;

  const int clk = 1350000;
  const int divisor = 2;
  
  if ( fan1 != 0 )
     fan1 = clk/(fan1*divisor);
  if ( fan2 != 0 )
     fan2 = clk/(fan2*divisor);
  if ( fan3 != 0 )
     fan3 = clk/(fan3*divisor);

  fan1 = RANGE(fan1,21,20000,0);
  fan2 = RANGE(fan2,21,20000,0);
  fan3 = RANGE(fan3,21,20000,0);

  int fan = MY_MAX(MY_MAX(fan1,fan2),fan3);

  *_temp1 = temp1;
  *_temp2 = temp2;
  *_fan = fan;

  rc = (temp1 != 0 || temp2 != 0 || fan != 0);

  return rc;
}
