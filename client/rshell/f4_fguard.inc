

CForegroundWindowGuard::CForegroundWindowGuard()
{
  old_fg = GetForegroundWindow();
}


CForegroundWindowGuard::~CForegroundWindowGuard()
{
  if ( old_fg && IsWindow(old_fg) )
     {
       SetForegroundWindow(old_fg);
     }
}

