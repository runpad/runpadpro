

template< class _T >
void CCollector::Start(const TENVENTRY *list,unsigned listcount)
{
  if ( !g_collector )
     {
       g_collector = new _T(list,listcount);
       g_collector->ShowDialog();
       g_collector->Finish();
       delete g_collector;
       g_collector = NULL;
     }
}


void CCollector::AppendData(const CNetCmd &cmd,unsigned src_guid)
{
  if ( g_collector )
     {
       g_collector->Append(cmd,src_guid);
     }
}

