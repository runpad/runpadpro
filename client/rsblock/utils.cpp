
#include "stdafx.h"
#include <shlwapi.h>
#include "utils.h"


BOOL FileExist(char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


void *sys_alloc(int size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}


int TrueRandom(void)
{
  unsigned seed = GetTickCount();
  seed = seed * 0x41C64E6D + 0x3039;
  return (seed >> 16) & 0xFFFF;
}


unsigned seed = 0;

int PseudoRandom(void)
{
  seed = seed * 0x41C64E6D + 0x3039;
  return (seed >> 16) & 0xFFFF;
}

