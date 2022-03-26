
#ifndef __INCLUDE_H__
#define __INCLUDE_H__

#define _WIN32_WINNT  0x0501   //WinXP

#include <winsock2.h>
#include <windows.h>
#include <shlwapi.h>
#include <psapi.h>
#include <tlhelp32.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <vector>

#include "../rshell/types.h"
#include "../rshell/f0.h"
#include "../rshell/service/serviceman.h"
#include "global.h"
#include "buff7.h"
#include "rle7.h"
#include "events.h"
#include "screen.h"
#include "cmds.h"
#include "myservice.h"
#include "executor.h"
#include "listener.h"
#include "session_worker.h"


#endif
