

CBuff::CBuff(char *_buff)
{
  start_buff = _buff;
  buff = start_buff;
}

CBuff::~CBuff()
{
}

unsigned CBuff::AddBool(BOOL obj)
{
  if ( !Simulate() )
     {
       *(BOOL*)buff = obj;
     }

  buff += sizeof(BOOL);

  return GetSize();
}

unsigned CBuff::AddInt(int obj)
{
  if ( !Simulate() )
     {
       *(int*)buff = obj;
     }

  buff += sizeof(int);

  return GetSize();
}

unsigned CBuff::AddByte(unsigned char obj)
{
  if ( !Simulate() )
     {
       *(unsigned char*)buff = obj;
     }

  buff += sizeof(unsigned char);

  return GetSize();
}

unsigned CBuff::AddString(const char *obj)
{
  unsigned size = obj ? lstrlen(obj)+1 : 1;
  
  if ( !Simulate() )
     {
       lstrcpy(buff,obj?obj:"");
     }

  buff += size;

  return GetSize();
}

void CBuff::Push()
{
  if ( !Simulate() )
     {
       stack.push_back(buff);
     }

  buff += sizeof(unsigned);
}

void CBuff::Pop()
{
  if ( !Simulate() )
     {
       char *offset = stack.back();
       stack.pop_back();
       unsigned delta = buff - offset - sizeof(unsigned);
       *(unsigned*)offset = delta;
     }
}
