
#include "include.h"


CNetCmd::CNetCmd() : CDynBuff()
{
}

CNetCmd::CNetCmd(int cmd_id) : CDynBuff()
{
  AddInt(cmd_id);
}

CNetCmd::~CNetCmd()
{
}

BOOL CNetCmd::IsValid() const
{
  return GetBuffPtr() && GetBuffSize() >= sizeof(int);
}

int CNetCmd::GetCmdId() const
{
  return IsValid() ? *(const int*)GetBuffPtr() : NETCMD_INVALID;
}

const char* CNetCmd::GetCmdBuffPtr() const
{
  if ( IsValid() && GetBuffSize() > sizeof(int) )
     {
       return (const char*)GetBuffPtr() + sizeof(int);
     }

  return NULL;
}

unsigned CNetCmd::GetCmdBuffSize() const
{
  if ( IsValid() && GetBuffSize() > sizeof(int) )
     {
       return GetBuffSize() - sizeof(int);
     }

  return 0;
}

CNetCmd::operator const char* () const
{
  return (const char*)GetCmdBuffPtr();
}

CNetCmd::operator const unsigned char* () const
{
  return (const unsigned char*)GetCmdBuffPtr();
}

CNetCmd::operator const void* () const
{
  return (const void*)GetCmdBuffPtr();
}

const char* CNetCmd::FindValueByName(const char *name) const
{
  if ( !name || !name[0] )
     return NULL;

  const char *p = GetCmdBuffPtr();
  unsigned len = GetCmdBuffSize();

  if ( !p || !len )
     return NULL;

  if ( p[len-1] != 0 ) //terminator check
     return NULL;

  while ( len > 0 )
  {
    if ( !p[0] || !StrStr(p,"=") )
       break;
    
    if ( !StrCmpNI(p,name,lstrlen(name)) && p[lstrlen(name)] == '=' )
       return p + lstrlen(name) + 1;

    unsigned delta = lstrlen(p) + 1;
    p += delta;
    len -= delta;
  };

  return NULL;
}

BOOL CNetCmd::GetParmAsBool(const char *name,BOOL def) const
{
  const char *s = FindValueByName(name);
  
  if ( !s || !s[0] )
     return def;

  return (!lstrcmpi(s,"1") || !lstrcmpi(s,"Yes") || !lstrcmpi(s,"True") || !lstrcmpi(s,"On"));
}


int CNetCmd::GetParmAsInt(const char *name,int def) const
{
  const char *s = FindValueByName(name);
  
  if ( !s || !s[0] )
     return def;

  return StrToInt(s);
}


const char* CNetCmd::GetParmAsString(const char *name,const char *def) const
{
  const char *s = FindValueByName(name);
  return s ? s : def;
}


void CNetCmd::AddStringParm(const char *name,const char *value)
{
  AddStringPair(name,value);
}


void CNetCmd::AddIntParm(const char *name,int value)
{
  char s[MAX_PATH];
  wsprintf(s,"%d",value);
  AddStringPair(name,s);
}


void CNetCmd::AddBoolParm(const char *name,BOOL value)
{
  AddStringPair(name,value?"1":"0");
}


