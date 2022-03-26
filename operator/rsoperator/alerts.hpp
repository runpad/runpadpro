
template< class _T >
void CAlerts::Add(const CNetCmd &cmd,unsigned src_guid)
{
  if ( alerts.size() < MAXALERTS )
     {
       _T *a = new _T(m_hwnd,m_current_id++,m_message,m_vis,cmd,src_guid);
       alerts.push_back(a);
     }
}
