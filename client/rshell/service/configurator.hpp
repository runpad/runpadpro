


template<class _T>
const _T& CConfigurator::GetCfgVar(const _T& v)
{
  assert(CanAccess());

  return v;
}


