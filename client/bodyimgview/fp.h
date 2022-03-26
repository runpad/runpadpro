

#define RC_NEAR		0x0
#define RC_DOWN		0x4
#define RC_UP		0x8
#define RC_CHOP		0xC
#define PC_24		0x0
#define PC_53		0x2
#define PC_64		0x3



static short oldcw,newcw;



static int __inline f2i(float x)
{
  int i;

  __asm {
		fld	x
		fistp	i
  }

  return i;
}



static int __inline d2i(double x)
{
  int i;

  __asm {
		fld	x
		fistp	i
  }

  return i;
}



static void __inline FP_Set(int flags)
{
  __asm {
                push	eax
   		fnstcw	oldcw
                mov	ax,oldcw
		and	ah,0F0h
		or	ah,byte ptr flags
                mov	newcw,ax
		fldcw	newcw
		pop	eax
  }
}



static void __inline FP_Restore(void)
{
  __asm {
		fldcw	oldcw
  }
}




