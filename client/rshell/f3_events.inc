
static struct {
BOOL important;
int id;
const char *name;
} events_desc[] =
{
  {FALSE,EL_STARTSHELL, STR_003 },
  {TRUE,EL_OFFSHELL,    STR_004 },
  {FALSE,EL_LOGOFF,     STR_005 },
  {FALSE,EL_REBOOT,     STR_006 },
  {FALSE,EL_SHUTDOWN,   STR_007 },
};



static const char* GetEventText(int id)
{
  int n;

  for ( n = 0; n < sizeof(events_desc)/sizeof(events_desc[0]); n++ )
      if ( events_desc[n].id == id )
         return events_desc[n].name;

  return "unknown event";
}


static BOOL IsEventImportant(int id)
{
  int n;

  for ( n = 0; n < sizeof(events_desc)/sizeof(events_desc[0]); n++ )
      if ( events_desc[n].id == id )
         return events_desc[n].important;

  return FALSE;
}


void AddEventString2SQLBase(int id)
{
  AddEventString2SQLBaseInternal(IsEventImportant(id)?1:0,GetEventText(id));
}

