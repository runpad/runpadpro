
#ifndef ___INCLUDE_H___
#define ___INCLUDE_H___

#define _WIN32_IE     0x0501   //WinXP
#define _WIN32_WINNT  0x0501   //WinXP
#define _WIN32_DCOM

// это дополнение делалось для болгарина, раскомментить если нужны доп. языки:
//#define ADDLANGS


#include <winsock2.h>
#include <windows.h>
#include <userenv.h>
#include <dbt.h>
#include <sensapi.h>
#include <commctrl.h>
#include <commdlg.h>
#include <objbase.h>
#include <shlobj.h>
#include <ole2.h>
#include <oleauto.h>
#include <shlwapi.h>
#include <tlhelp32.h>
#include <WtsApi32.h>
#include <Aclapi.h>
#include <sddl.h>
#include <psapi.h>
#include <vfw.h>
#include <excpt.h>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <assert.h>
#include <gdiplus.h>
#include <dshow.h>
#include <setupapi.h>
#include "qedit.h"   // not supported in VC9 or later


using namespace Gdiplus;


#include "osdef.h"
#include "../common/version.h"
#include "types.h"
#include "cfg.h"
#include "g_vars.h"
#include "cfg_vars.h"
#include "lang.h"
#include "resource.h"
#include "messages.h"
#include "../rp_shared/rp_shared.h"
#include "hook.h"
#include "webcam.h"
#include "hwident.h"
#include "ibutton.h"
#include "fpu.h"
#include "f0.h"
#include "f1.h"
#include "f2.h"
#include "f3.h"
#include "f4.h"
#include "netcmd.h"
#include "netclient.h"
#include "popupmenu.h"
#include "tray.h"
#include "ql.h"
#include "taskpane.h"
#include "desk.h"
#include "workspace.h"
#include "shwindow.h"
#include "mainmenu.h"
#include "draw.h"
#include "api.h"
#include "dialogs.h"
#include "indicators.h"
#include "about.h"
#include "stat.h"
#include "vip.h"
#include "restricts.h"
#include "saver.h"
#include "ppreview.h"
#include "main.h"
#include "cfg_common.h"
#include "body.h"
#include "install.h"
#include "servicemgr.h"
#include "background.h"
#include "md5.h"
#include "gpu.h"
#include "ourtime.h"
#include "iconscache.h"
#include "floatlic.h"


#ifdef LS
#undef LS
#endif

#define LS(id) GetLangStrByLangId(curr_lang,id)


#endif
