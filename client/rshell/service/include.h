
#ifndef __INCLUDE_H__
#define __INCLUDE_H__

#define _WIN32_IE     0x0501   //WinXP
#define _WIN32_WINNT  0x0501   //WinXP
#define _WIN32_DCOM

#include <winsock2.h>
#include <windows.h>
#include <commctrl.h>
#include <shlwapi.h>
#include <shlobj.h>
#include <objbase.h>
#include <wia.h>
#include <sti.h>
#include <stierr.h>
#include <nb30.h>
#include <lm.h>
#include <Iphlpapi.h>
#include <userenv.h>
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <assert.h>
#include <string>
#include <vector>

#include "def.h"
#include "lang.h"
#include "resource.h"
#include "serviceman.h"
#include "../../common/version.h"
#include "../types.h"
#include "../cfg.h"
#include "../cfg_vars.h"
#include "../cfg_common.h"
#include "../f0.h"
#include "../f1.h"
#include "tools.h"
#include "../ourtime.h"
#include "../netclient.h"
#include "../netcmd.h"
#include "../install.h"
#include "configurator.h"
#include "pipe.h"
#include "net.h"
#include "myservice.h"
#include "cputemp.h"
#include "wiacb.h"
#include "someinfo.h"
#include "update.h"
#include "../../z/z_lib.h"
#include "../../rp_shared/rp_shared.h"
#include "rollback.h"



#endif
