
#ifndef ___INCLUDE_H___
#define ___INCLUDE_H___

#define _WIN32_IE     0x0501   //WinXP
#define _WIN32_WINNT  0x0501   //WinXP
#define _WIN32_DCOM


#include <winsock2.h>
#include <windows.h>
#include <commctrl.h>
#include <objbase.h>
#include <shlwapi.h>
#include <gdiplus.h>
#include <ole2.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <excpt.h>
#include <vector>

using namespace Gdiplus;

#include "../../admin/sql/h_sql.h"
#include "../../client/rshell/f0.h"
#include "../../client/rshell/f1.h"
#include "../../client/rshell/netcmd.h"
#include "../../client/rshell/netclient.h"
#include "cfg.h"
#include "resource.h"
#include "lang.h"
#include "main.h"
#include "actions.h"
#include "gui.h"
#include "processing.h"
#include "net.h"
#include "vscontrol.h"
#include "alerts.h"
#include "tools.h"
#include "collector.h"



#endif
