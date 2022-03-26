#include <windows.h>
#include <shlwapi.h>
#include <shlobj.h>



int Path2Drive(const char *path)
{
  const unsigned char *s = (const unsigned char *)path;
  int drive;

  if ( !s || lstrlen(s) < 2 || s[1] != ':' )
     return -1;

  drive = s[0];
  drive = (int)CharUpper((LPSTR)drive);
  
  if ( drive >= 'A' && drive <= 'Z' )
     drive -= 'A';
  else
     drive = -1;

  return drive;
}


int EjectNT(const char *path)
{
	HANDLE hDisk;
	DWORD dwRc;
	TCHAR tsz[8];
	SECURITY_ATTRIBUTES sa;
	int result;

	wsprintf(tsz, TEXT("\\\\.\\%c:"), TEXT('@') + Path2Drive(path) + 1);
	sa.nLength = sizeof(sa);
	sa.lpSecurityDescriptor = NULL;
	sa.bInheritHandle = TRUE;
	hDisk =  CreateFile(tsz, GENERIC_READ | GENERIC_WRITE,
		FILE_SHARE_READ | FILE_SHARE_WRITE,&sa,
		OPEN_EXISTING, FILE_FLAG_WRITE_THROUGH, NULL);

	if (hDisk != INVALID_HANDLE_VALUE)
	{
		FlushFileBuffers(hDisk);
		result = DeviceIoControl(hDisk, IOCTL_STORAGE_EJECT_MEDIA, NULL, 0, NULL, 0,&dwRc, NULL);
		CloseHandle(hDisk);
	}
	else
		result = 0;

	return result;
}



__declspec(dllexport) int __cdecl EjectDrive(const char *path)
{
	OSVERSIONINFO osver;
	osver.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
	if ( !GetVersionEx(&osver) )
		return -1;
	else
		if ( osver.dwMajorVersion < 5 )
			return -1;
		else
			return EjectNT(path);
}


__declspec(dllexport) int __cdecl FormatDrive(HWND Handle, const char *path)
{
	OSVERSIONINFO osver;
	osver.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
	if ( !GetVersionEx(&osver) )
		return -1;
	else
		if ( osver.dwMajorVersion < 5 )
			return -1;
		else
			return SHFormatDrive(Handle, Path2Drive(path), SHFMT_ID_DEFAULT, 0);
}
