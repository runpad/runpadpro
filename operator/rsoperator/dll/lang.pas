unit lang;

interface

const S_WARNING    = 'Предупреждение';
const S_QUESTION   = 'Вопрос';
const S_ERR        = 'Ошибка';
const S_INFO       = 'Сообщение';
const S_SELECTFOLDER = 'Выбор папки';
const S_SELECTFILEFOLDER = 'Выбор папки/файла';
const S_SELECTFILE = 'Выбор файла';
const S_SELECTFOLDERREMOTE = 'Впишите полный путь к папке:';
const S_SELECTFILEFOLDERREMOTE = 'Впишите полный путь к папке/файлу:';
const S_SELECTFILEREMOTE = 'Впишите полный путь к файлу';
const S_SELECTFOLDERLOCAL = 'Выберите папку:';
const S_SELECTFILEFOLDERLOCAL = 'Выберите папку/файл:';
const S_SELECTFILELOCAL = 'Выберите файл';
const S_NOSERVERSPECIFIED = 'В настройках не установлен SQL-сервер'#13#10'Вход не будет возможен пока администратор не сделает этих установок';
const S_SQLCONNECTING = 'Подключение к SQL-серверу...';
const S_ERRSQLCONNECT = 'Ошибка входа в SQL-базу';
const S_ERRCONNECTINGTOSQL = 'Ошибка подключения/входа'#13#10'Убедитесь, что администратор добавил этот логин к базе';
const S_NOTSQLCONNECTED = 'Вход в базу не выполнен';
const S_NOTSQLCONNECTEDTITLE = 'ВХОД НЕ ВЫПОЛНЕН';
const S_SQLCONNECTED = 'Подключено к базе';
const S_DIFFPWDS = 'Вы ввели разные пароли';
const S_PWDCHANGED = 'Пароль изменен!';
const S_PWDNOTCHANGED = 'Ошибка смены пароля';
const S_EMPTYSTRING = 'Вы ничего не ввели';
const S_VIPADD = 'Добавление VIP-пользователя';
const S_VIPDEL = 'Удаление VIP-пользователя';
const S_VIPCLEARPWD = 'Очистка пароля VIP-пользователя';
const S_ENTERVIPNAME = 'Введите имя пользователя:';
const S_VIPADDED = 'Пользователь добавлен в базу!'#13#10'Теперь VIP-клиент должен выбрать "Регистрация нового пользователя" на клиентской машине';
const S_ERRVIPADD = 'Ошибка добавления в базу!'#13#10'Возможно у вас нет прав или пользователь уже существует в базе';
const S_VIPDELETED = 'Пользователь удален из базы!';
const S_ERRVIPDELETE = 'Ошибка удаления из базы!'#13#10'Возможно у вас нет прав';
const S_VIPCLEARED = 'Пароль пользователя очищен!'#13#10'Теперь VIP-клиент должен выбрать "Регистрация нового пользователя" на клиентской машине';
const S_ERRVIPCLEAR = 'Ошибка очистки пароля!'#13#10'Возможно у вас нет прав';
const S_USERNOTADDED2DB = 'Администратор не добавил данного пользователя к базе данных'#13#10'Работа с функциями будет невозможна';
const S_SERVERCONNECTED = 'Подключено к серверу';
const S_SERVERCONNECTING = 'Подключение к серверу';
const S_COMPUSERREPORT = '%d компьютеров / %d пользователей';
const S_DEFZAL = 'Организация';
const S_INFO_VIP = 'VIP';
const S_INFO_MONITOR = 'Монитор';
const S_INFO_OFF = 'Выкл';
const S_INFO_BLOCKED = 'Заблокирован';
const S_INFO_TASK = 'Задача';
const S_INFO_ROLLBACK = 'ROLLBACK';
const S_INFOFMT_GUID         = 'GUID: %d';
const S_INFOFMT_CLASS        = 'Класс: %s';
const S_INFOFMT_IP           = 'IP: %s';
const S_INFOFMT_MAC          = 'MAC: %s';
const S_INFOFMT_RPVER        = 'Версия: %s';
const S_INFOFMT_MACHINELOC   = 'Положение: %s';
const S_INFOFMT_MACHINEDESC  = 'Описание: %s';
const S_INFOFMT_COMPNAME     = 'Машина: %s';
const S_INFOFMT_DOMAIN       = 'Домен: %s';
const S_INFOFMT_USERNAME     = 'Пользователь: %s';
const S_INFOFMT_VIPSESSION   = 'VIP-сессия: %s';
const S_INFOFMT_ACTIVETASK   = 'Активная задача: "%s"';
const S_INFOFMT_MONITORON    = 'Монитор включен';
const S_INFOFMT_MONITOROFF   = 'Монитор выключен';
const S_INFOFMT_BLOCKON      = 'Блокировка включена';
const S_INFOFMT_BLOCKOFF     = 'Блокировка выключена';
const S_INFOFMT_RFMON        = 'Сервис RemoteFileManager: Вкл';
const S_INFOFMT_RFMOFF       = 'Сервис RemoteFileManager: Откл';
const S_INFOFMT_RDON         = 'Сервис RemoteDesktop: Вкл';
const S_INFOFMT_RDOFF        = 'Сервис RemoteDesktop: Откл';
const S_INFOFMT_RLBON        = 'Rollback (откат): Вкл';
const S_INFOFMT_RLBOFF       = 'Rollback (откат): Откл или Вкл с сохранением';
const S_EMPTYLOGIN = 'Логин не может быть пустым';
const S_EMPTYLOGINPWD = 'Логин и пароль не могут быть пустыми';
const S_TURNSHELLON = 'Включение клиентского шелла';
const S_TURNSHELLOFF = 'Отключение клиентского шелла';
const S_TURNSHELLON_BTN = 'Включить шелл';
const S_TURNSHELLOFF_BTN = 'Отключить шелл';
const S_CLEARWOLCACHE = 'Очистить кэш списка MAC-адресов?';


implementation

end.
