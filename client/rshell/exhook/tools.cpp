
#include "include.h"




BOOL IsStrEmpty(const char *s)
{
  return !s || !s[0];
}


BOOL IsStrEmpty(const WCHAR *s)
{
  return !s || !s[0];
}


BOOL IsStrEmpty(const widestring& s)
{
  return s.empty();
}


