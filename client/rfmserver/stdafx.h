// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#define __SERVER_SIDE__ // сторона сервера

#pragma comment(lib, "Ws2_32.lib")

#ifndef WINVER
#define WINVER 0x0501
#endif

#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0501
#endif						

#ifndef _WIN32_WINDOWS
#define _WIN32_WINDOWS 0x0410
#endif


#define WIN32_LEAN_AND_MEAN
#include <stdio.h>
#include <tchar.h>
#include <conio.h>

// Основные файлы

#include <windows.h>
#include <winbase.h>

// Библиотеки сокетов

#include <winsock2.h>
#include <Mswsock.h>


