

CDynBuff::CDynBuff()
{
  m_buff = NULL;
  m_size = 0;
  m_allocsize = 0;
}

CDynBuff::CDynBuff(const CDynBuff& other)
{
  CopyFrom(other);
}

CDynBuff::CDynBuff(const void *buff,unsigned len)
{
  m_buff = NULL;
  m_size = 0;
  m_allocsize = 0;
  
  AddBuff(buff,len);
}

CDynBuff::~CDynBuff()
{
  Free();
}

void CDynBuff::Clear()
{
  m_size = 0;
}

void CDynBuff::CopyFrom(const CDynBuff& other)
{
  if ( other.m_buff && other.m_size )
     {
       m_size = other.m_size;
       m_allocsize = m_size;
       m_buff = sys_alloc(m_size);
       CopyMemory(m_buff,other.m_buff,m_size);
     }
  else
     {
       m_buff = NULL;
       m_size = 0;
       m_allocsize = 0;
     }
}

const CDynBuff& CDynBuff::operator = (const CDynBuff& other)
{
  Clear();
  AddBuff(other.m_buff,other.m_size);
  return *this;
}

void CDynBuff::Free()
{
  if ( m_buff )
     sys_free(m_buff);

  m_buff = NULL;
  m_size = 0;
  m_allocsize = 0;
}

void CDynBuff::Compact(unsigned size)
{
  if ( m_buff )
     {
       if ( size < m_allocsize )
          {
            unsigned newsize = MAX(size,m_size);
            if ( newsize != m_allocsize )
               {
                 m_allocsize = newsize;

                 if ( m_allocsize )
                    {
                      m_buff = sys_realloc(m_buff,m_allocsize);
                    }
                 else
                    {
                      sys_free(m_buff);
                      m_buff = NULL;
                    }
               }
          }
     }
}

void CDynBuff::AddBuff(const void *buff,unsigned len)
{
  if ( buff && len )
     {
       if ( !m_buff )
          {
            m_buff = sys_alloc(len);
            CopyMemory(m_buff,buff,len);
            m_size = len;
            m_allocsize = len;
          }
       else
          {
            assert(m_allocsize >= m_size);
            
            if ( m_allocsize - m_size < len )
               {
                 m_allocsize *= 2;
                 if ( m_size + len > m_allocsize )
                    m_allocsize = m_size + len;

                 m_buff = sys_realloc(m_buff,m_allocsize);
               }

            CopyMemory((char*)m_buff+m_size,buff,len);
            m_size += len;
          }
     }
}

void CDynBuff::AddChar(char v)
{
  AddBuff(&v,sizeof(v));
}

void CDynBuff::AddByte(unsigned char v)
{
  AddBuff(&v,sizeof(v));
}

void CDynBuff::AddInt(int v)
{
  AddBuff(&v,sizeof(v));
}

void CDynBuff::AddInt(unsigned v)
{
  AddBuff(&v,sizeof(v));
}

void CDynBuff::AddInt64(__int64 v)
{
  AddBuff(&v,sizeof(v));
}

void CDynBuff::AddStringNoTerm(const char *v)
{
  if ( v && v[0] )
     {
       AddBuff(v,lstrlen(v));
     }
}

void CDynBuff::AddStringSZ(const char *v)
{
  if ( v )
     {
       AddBuff(v,lstrlen(v)+1);
     }
  else
     {
       AddBuff("",1);
     }
}

void CDynBuff::AddStringPair(const char *name,const char *value)
{
  if ( name && name[0] )
     {
       if ( !value )
          value = "";

       AddStringNoTerm(name);
       AddStringNoTerm("=");
       AddStringSZ(value);
     }
}

void CDynBuff::AddPointer(void *v)
{
  AddBuff(&v,sizeof(v));
}


const CDynBuff& CDynBuff::operator += (const CDynBuff &v)
{
  AddBuff(v.GetBuffPtr(),v.GetBuffSize());
  return *this;
}


const CDynBuff& CDynBuff::operator += (char v)
{
  AddChar(v);
  return *this;
}

const CDynBuff& CDynBuff::operator += (unsigned char v)
{
  AddByte(v);
  return *this;
}

const CDynBuff& CDynBuff::operator += (int v)
{
  AddInt(v);
  return *this;
}

const CDynBuff& CDynBuff::operator += (unsigned v)
{
  AddInt(v);
  return *this;
}

const CDynBuff& CDynBuff::operator += (__int64 v)
{
  AddInt64(v);
  return *this;
}

const CDynBuff& CDynBuff::operator += (const char *v)
{
  AddStringSZ(v);
  return *this;
}

CDynBuff::operator const char* () const
{
  return (const char*)GetBuffPtr();
}

CDynBuff::operator const unsigned char* () const
{
  return (const unsigned char*)GetBuffPtr();
}

CDynBuff::operator const void* () const
{
  return GetBuffPtr();
}

