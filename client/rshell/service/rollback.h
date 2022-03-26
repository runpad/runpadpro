
#ifndef __ROLLBACK_H__
#define __ROLLBACK_H__


#include <vector>
#include <string>


///////////////////////////////////////////////////
//
// Общие замечания по использованию модуля:
//
// [*] Используется слегка (не функционально) модифицированный драйвер от ShadowUser Pro 2.5
// [*] Все функции требуют прав администратора для своего выполнения.
// [*] Функции Install/Uninstall/Activate/Deactivate/Save требуют перезагрузки для выполнения.
// [*] Функции SetDisks/SetExcludePaths только лишь записывают данные в реестр.
// [*] Функции SetDisks/SetExcludePaths должны быть вызваны перед активацией отката.
// [*] Для функции SetDisks можно указать маску 0xFFFFFFFF, 0x00000000 или любую другую.
// [*] Если путь исключения задан на диске, отличном от системного, то будут исключаться эти пути на всех дисках!
// [*] Все пути исключений должны существовать перед вызовом SetExcludePaths.
// [*] Для вызова драйвера модуль устанавливает для процесса SE_BACKUP_NAME.
// [*] Особенность: при вызове DeactivateSave или Save в папках-исключениях данные этого сеанса не сохраняются!
// [*] Особенность: если на диске менее 1.3ГБ свободного места и включен откат, то драйвер рано или поздно (0.5 - 3 часа)
//      выдаст код ошибки 768 (в event-log) и посыпятся ошибки NTFS о невозможности отложенной записи, или сразу BSOD.
//      Это проверялось на системном диске C: (возможно на других проблемы нет), 1.3ГБ подобрано опытным путем.
// [*] Проблема совместимости с DrWeb 5x если в нем включена функция самозащиты - компьютер после перезагрузки не загрузится. Для 6х такой проблемы нет.
//
///////////////////////////////////////////////////



class CRollback
{
  public:
          // driver statuses (do not change values!)
          enum {
           ST_DRV_FIRST       = 0, // ---
           ST_DRV_OFF_OFF     = 0, // драйвер не установлен, после перезагрузки не будет включен
           ST_DRV_OFF_ON      = 1, // драйвер не включен, после перезагрузки будет включен
           ST_DRV_ON_ON       = 2, // драйвер включен, после перезагрузки будет включен
           ST_DRV_ON_OFF      = 3, // драйвер включен, после перезагрузки не будет включен
           ST_DRV_LAST        = 3, // ---
          };

          // rollback statuses (do not change values!)
          enum {
           ST_RLB_FIRST       = 0, // ---
           ST_RLB_NODRIVER    = 0, // Драйвер не установлен (ST_DRV_OFF_OFF или ST_DRV_OFF_ON)
           ST_RLB_OFF_OFF     = 1, // Режим RollBack не активен, после перезагрузки не будет активен
           ST_RLB_ON_ON       = 2, // Режим RollBack активен, после перезагрузки будет активен
           ST_RLB_OFF_ON      = 3, // Режим RollBack не активен, после перезагрузки будет активен
           ST_RLB_ON_OFF      = 4, // Режим RollBack активен, после перезагрузки будет не активен
           ST_RLB_ON_ON_SAVE  = 5, // Режим RollBack активен, при перезагрузке будет активен данные сохранятся
           ST_RLB_ON_OFF_SAVE = 6, // Режим RollBack активен, при перезагрузке будет не активен данные сохранятся
           ST_RLB_LAST        = 6, // ---
          };

          // error codes
          enum {
           ERR_SUCCESS       = 0,
           ERR_OK            = 0,
           ERR_NONE          = 0,
           ERR_FAILED        = 1,  // any other failure
           ERR_OS            = 2,  // unsupported OS
           ERR_ACCESS        = 3,  // access denied
          };

          typedef std::vector<std::string> TStringList;

  private:        

          class CDevice
          {
                    HANDLE m_handle;
            public:
                    CDevice(const char *devicepath);
                    ~CDevice();
                    BOOL IsValid() const { return m_handle != INVALID_HANDLE_VALUE; }
                    BOOL Call(DWORD code,LPVOID inbuff=NULL,DWORD inbuffsize=0,LPVOID outbuff=NULL,DWORD outbuffsize=0,LPDWORD _rcbytes=NULL);
          };
          
          class COurPrivileges
          {
            public:
                    COurPrivileges();
          };

          class COurDevice : public COurPrivileges, public CDevice  // here COurPrivileges must be first!
          {
            public:
                    COurDevice() : CDevice("\\\\.\\RollBackControl") {}
          };
          
          
          BOOL b_os_supported;
          BOOL b_is_admin;
          int m_lasterror;

  public:
          CRollback();
          ~CRollback();

          int GetLastError() const { return m_lasterror; }
          const char* GetVersion() const { return "v1.00 (W2K/XP x86)"; }

          BOOL GetDriverStatus(int &_out);
          BOOL GetRollbackStatus(int &_out);
          BOOL InstallDriver();
          BOOL UninstallDriver();
          BOOL UpdateDriverFile();
          BOOL SetDisks(unsigned mask);
          BOOL GetDisks(unsigned& _mask);
          BOOL SetExcludePaths(const TStringList& list,BOOL b_fail_if_any_invalid);
          BOOL GetExcludePaths(TStringList& _list);
          BOOL RollbackActivate();
          BOOL RollbackDeactivate(BOOL b_saveall);
          BOOL RollbackSaveAll();

  private:
          void SetLastError(int err) { m_lasterror = err; }
          BOOL IsOsSupported() const { return b_os_supported; }
          BOOL IsAdmin() const { return b_is_admin; }
          BOOL CommonChecks();

          static const void* _GetDriver4CurrentOs(unsigned &_size);
          static char* _GetDriverFullPathName(char *s);
          static BOOL _WriteDriverFile();
          static void _DeleteDriverFile();
          static void _DeleteRegAndDriverFile();
          static BOOL _CallDriver(DWORD code,LPVOID inbuff=NULL,DWORD inbuffsize=0,LPVOID outbuff=NULL,DWORD outbuffsize=0,LPDWORD _rcbytes=NULL);
          static int _GetRlbStateByReturnCode(BYTE rc);
          static BOOL _IncludeOrExcludeDisk(int drivenum,BOOL b_include,int &_newstate);
};




#endif

