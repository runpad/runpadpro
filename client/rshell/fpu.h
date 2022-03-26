
#ifndef ___FPU_H___
#define ___FPU_H___


#define f2i(x)   CFPU::ftoi(x)


class CFPU
{
  public:
          static const int FPU_RC_NEAR = 0x0;
          static const int FPU_RC_DOWN = 0x4;
          static const int FPU_RC_UP   = 0x8;
          static const int FPU_RC_CHOP = 0xC;
          static const int FPU_PC_24   = 0x0;
          static const int FPU_PC_53   = 0x2;
          static const int FPU_PC_64   = 0x3;
          static const int FPU_MASK    = 0xF;

  private:
          unsigned short oldcw;

  public:
          inline CFPU(int flags);
          inline ~CFPU();

          static int __inline ftoi(float x);
          static int __inline ftoi(double x);
};


class CFPU_RC_Near : public CFPU
{
  public:
          CFPU_RC_Near() : CFPU(FPU_RC_NEAR | FPU_PC_64) {}
};


class CFPU_RC_Down : public CFPU
{
  public:
          CFPU_RC_Down() : CFPU(FPU_RC_DOWN | FPU_PC_64) {}
};


class CFPU_RC_Up : public CFPU
{
  public:
          CFPU_RC_Up() : CFPU(FPU_RC_UP | FPU_PC_64) {}
};


class CFPU_RC_Chop : public CFPU
{
  public:
          CFPU_RC_Chop() : CFPU(FPU_RC_CHOP | FPU_PC_64) {}
};



CFPU::CFPU(int flags)
{
  unsigned short _newcw,_oldcw;

  flags &= FPU_MASK;
  
  __asm {
	push	eax
	fnstcw	_oldcw
	mov	ax,_oldcw
	and	ah,0F0h
	or	ah,byte ptr flags
	mov	_newcw,ax
	fldcw	_newcw
	pop	eax
  };

  oldcw = _oldcw;
}


CFPU::~CFPU()
{
  unsigned short _oldcw = oldcw;

  __asm {
	fldcw	_oldcw
  };
}


int CFPU::ftoi(float x)
{
  int i;

  __asm {
	fld	x
	fistp	i
  };

  return i;
}


int CFPU::ftoi(double x)
{
  int i;

  __asm {
	fld	x
	fistp	i
  };

  return i;
}



#endif

