

extern HINSTANCE our_instance;
extern char our_currpath[MAX_PATH];
extern char our_apppath[MAX_PATH];
extern const char *our_appname;


void G_OnEndSession();
void G_OnTimer();
void G_OnTimerVista();
void G_OnTaskbarCreated();
void G_OnTrayMessage(int wParam,int lParam);
void G_OnForceUpdate();

