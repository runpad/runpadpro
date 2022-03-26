
{*******************************************************}
{                                                       }
{       TEAP LEAP Soft Group 2004                       }
{       Dropper - Component for Drag & Drop files       }
{                                                       }
{       Copyright (c) 2004, TEAP LEAP Soft Group 2004   }
{                                                       }
{       Компонент для копирования файлов через          }
{                   Drag & Drop средствами OLE          }
{                                                       }
{             Разработчик: Матвеев Игорь Владимирович   }
{                           E-Mail: teap_leap@mail.ru   }
{                                                       }
{*******************************************************}

{********************** Описание ***********************}
{                                                       }
{  Компонент предназначен для внедрения в Ваши проекты  }
{ технологии Drag & Drop, но не в виде приемника файлов }
{ из проводника, а как сервер - Вы можете перетаскивать }
{ файлы в проводник Windows и другие программы,         }
{ зарегестрированные с помощью DragAcceptFiles.         }
{  При необшодимости вызвать Drag & Drop (например при  }
{ OnMouseDown), вызовите метод TDropper.StartDrop.      }
{ А в событии TDropper.OnDropUp задайте файлы для       }
{ копирования. Указанные файлы будут переданы           }
{ Drag & Drop клиенту (в случае с проводником - файлы   }
{ будут скопированны).                                  }
{                                                       }
{  Не используйте Drag & Drop во время отладки          }
{  приложения из под Delphi - возникает ошибка, но она  }
{  не ловится и не влияет на работу готового приложения }
{                                                       }
{*******************************************************}

unit M_Dropper;

interface

uses
  Windows, Messages, SysUtils, Classes, ActiveX, ShlObj, Forms;

type
  { TFormatList - массив записей TFormatEtc }
  PFormatList = ^TFormatList;
  TFormatList = array[0..1] of TFormatEtc;

  TDropUp = procedure(var Files: TStringList) of object;
  TDropCheck  = procedure(var Allow: Boolean) of object;

  TEnumFormatEtc = class(TInterfacedObject, IEnumFormatEtc)
  private
    FFormatList  : PFormatList;
    FFormatCount : Integer;
    FIndex       : Integer;
  public
    constructor Create(FormatList: PFormatList; FormatCount, Index: Integer);
    { IEnumFormatEtc }
    function Next(Celt: LongInt; out Elt; PCeltFetched: PLongInt): HResult; stdcall;
    function Skip(Celt: LongInt): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out Enum: IEnumFormatEtc): HResult; stdcall;
  end;

  { TDragDropInfo Информация о перетаскиваемых файлах }
  TDragDropInfo = class(TObject)
  private
    FInClientArea : Boolean;
    FDropPoint    : TPoint;
    FFileList     : TStringList;
  public
    constructor Create(ADropPoint : TPoint; AInClient : Boolean);
    function    CreateHDrop : HGlobal;
    destructor  Destroy; override;
    procedure   Add(const s : String);

    property InClientArea : Boolean     read FInClientArea;
    property DropPoint    : TPoint      read FDropPoint;
    property Files        : TStringList read FFileList;
  end;

  TFileDropEvent = procedure(DDI : TDragDropInfo) of object;

  { THDropDataObject - объект данных с
    информацией о перетаскиваемых файлах }
  THDropDataObject = class(TInterfacedObject, IDataObject)
  private
    FDropInfo : TDragDropInfo;
  public
    constructor Create(ADropPoint: TPoint; AInClient: Boolean);
    destructor  Destroy; override;
    procedure   Add(const s : String);
    { из IDataObject }
    function GetData(const formatetcIn: TFormatEtc;
        out medium: TStgMedium): HResult; stdcall;
    function GetDataHere(const formatetc: TFormatEtc;
        out medium: TStgMedium): HResult; stdcall;
    function QueryGetData(const formatetc: TFormatEtc): HResult; stdcall;
    function GetCanonicalFormatEtc(const formatetc: TFormatEtc;
        out formatetcOut: TFormatEtc): HResult; stdcall;
    function SetData(const formatetc: TFormatEtc; var medium: TStgMedium;
        fRelease: BOOL): HResult; stdcall;
    function EnumFormatEtc(dwDirection: Longint;
        out enumFormatEtc: IEnumFormatEtc): HResult; stdcall;
    function DAdvise(const formatetc: TFormatEtc; advf: Longint;
        const advSink: IAdviseSink; out dwConnection: Longint): HResult; stdcall;
    function DUnadvise(dwConnection: Longint): HResult; stdcall;
    function EnumDAdvise(out enumAdvise: IEnumStatData): HResult; stdcall;
  end;

  { TFileDropSource - источник
    для перетаскивания файлов }
  TFileDropSource = class(TInterfacedObject, IDropSource)
    FOnDragQuery : TDropUp;
    FOnDropCheck : TDropCheck;
    constructor Create;
    function QueryContinueDrag(fEscapePressed: BOOL;
        grfKeyState: Longint): HResult; stdcall;
    function GiveFeedback(dwEffect: Longint): HResult; stdcall;
    property OnDragQuery : TDropUp read FOnDragQuery write FOnDragQuery;
    property OnDropCheck : TDropCheck read FOnDropCheck write FOnDropCheck;
  end;

  TDropper = class(TComponent)
  private
    { Private declarations }
    FEnabled     : Boolean;
    FIsDropping  : Boolean;
    FOnDropUp    : TDropUp;
    FOnDropCheck : TDropCheck;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure   StartDrag;
    property    IsDropping : Boolean read FIsDropping;
  published
    { Published declarations }
    property Enabled     : Boolean    read FEnabled     write FEnabled;
    property OnDropUp    : TDropUp    read FOnDropUp    write FOnDropUp;
    property OnDropCheck : TDropCheck read FOnDropCheck write FOnDropCheck;
  end;

var
  DropData : THDropDataObject;
  Enabld   : Boolean;

procedure Register;

implementation

// TEnumFormatEtc //////////////////////////////////////////////////////////////

constructor TEnumFormatEtc.Create(FormatList: PFormatList;
    FormatCount, Index : Integer);
begin
  inherited Create;
  FFormatList := FormatList;
  FFormatCount := FormatCount;
  FIndex := Index;
end;

{
  Next извлекает заданное количество
  структур TFormatEtc
  в передаваемый массив elt.
  Извлекается celt элементов, начиная с
  текущей позиции в списке.
}
function TEnumFormatEtc.Next(celt: Longint; out elt; pceltFetched: PLongint): HResult;
var
  i : Integer;
  eltout : TFormatList absolute elt;
begin
  i := 0;

  while (i < celt) and (FIndex < FFormatCount) do
  begin
    eltout[i] := FFormatList[FIndex];
    Inc (FIndex);
    Inc (i);
  end;

  if (pceltFetched <> nil) then
    pceltFetched^ := i;

  if (I = celt) then
    Result := S_OK
  else
    Result := S_FALSE;
end;

{
  Skip пропускает celt элементов списка, 
  устанавливая текущую позицию
  на (CurrentPointer + celt) или на конец 
  списка в случае переполнения.
}
function TEnumFormatEtc.Skip(celt: Longint): HResult;
begin
  if (celt <= FFormatCount - FIndex) then
  begin
    FIndex := FIndex + celt;
    Result := S_OK;
  end else
  begin
    FIndex := FFormatCount;
    Result := S_FALSE;
  end;
end;

{ Reset устанавливает указатель текущей
позиции на начало списка }
function TEnumFormatEtc.Reset: HResult;
begin
  FIndex := 0;
  Result := S_OK;
end;

{ Clone копирует список структур }
function TEnumFormatEtc.Clone(out enum: IEnumFormatEtc): HResult;
begin
  enum := TEnumFormatEtc.Create 
  (FFormatList, FFormatCount, FIndex);
  Result := S_OK;
end;

// TFileDropSource /////////////////////////////////////////////////////////////

constructor TFileDropSource.Create;
begin
  inherited Create;
  _AddRef;
end;


function TFileDropSource.QueryContinueDrag(fEscapePressed: BOOL;
    grfKeyState: Longint): HResult;
var
  Files     : TStringList;
  I         : Integer;
  AllowDrop : Boolean;
begin
  if not Enabld then
    begin
      Result := DRAGDROP_S_CANCEL;
      Exit;
    end;

  if (fEscapePressed) then
    Result := DRAGDROP_S_CANCEL
  else
     if (grfKeyState and MK_LBUTTON) = 0 then
       begin
         if Assigned(FOnDropCheck) then
           FOnDropCheck(AllowDrop)
         else
           AllowDrop := true;

         if AllowDrop then
           begin
             Files := TStringList.Create;
             if Assigned(FOnDragQuery) then      // спрашиваем список файлов
               FOnDragQuery(Files);
             for i := 0 to Files.Count - 1 do
               DropData.Add(Files.Strings[i]);
             Files.Free;

             Result := DRAGDROP_S_DROP;
           end
         else
           Result := DRAGDROP_S_CANCEL;

       end
     else Result := S_OK;
end;

function TFileDropSource.GiveFeedback(dwEffect: Longint): HResult;
var
  i: DWORD;
  AllowDrop: Boolean;
begin
  if Assigned(FOnDropCheck) then
    FOnDropCheck(AllowDrop)
  else
    AllowDrop := true;

  if AllowDrop then
    begin
      i:=dwEffect;
      case i of
        DROPEFFECT_NONE,
        DROPEFFECT_COPY,
        DROPEFFECT_LINK,
        DROPEFFECT_SCROLL : Result := DRAGDROP_S_USEDEFAULTCURSORS;
        else
          Result := S_OK;
      end;
    end
  else
    begin
      SetCursor(LoadCursor(0, IDC_NO));
      Result := S_OK;
    end;
end;

{ THDropDataObject }
constructor THDropDataObject.Create(ADropPoint : TPoint; AInClient : Boolean);
begin
  inherited Create;
  _AddRef;
  FDropInfo := TDragDropInfo.Create(ADropPoint, AInClient);
end;

destructor THDropDataObject.Destroy;
begin
  if (FDropInfo <> nil) then FDropInfo.Free;
  inherited Destroy;
end;

procedure THDropDataObject.Add(const s : String);
begin
  FDropInfo.Add(s);
end;

function THDropDataObject.GetData(const formatetcIn: TFormatEtc;
  out medium: TStgMedium): HResult;
begin
  Result := DV_E_FORMATETC;
  { Необходимо обнулить все поля medium  на случай ошибки}
  medium.tymed := 0;
  medium.hGlobal := 0;
  medium.unkForRelease := nil;

  { Если формат поддерживается, создаем
    и возвращаем данные }
  if (QueryGetData(formatetcIn) = S_OK) then
  begin
    if (FDropInfo <> nil) then
    begin
      medium.tymed := TYMED_HGLOBAL;
      { За освобождение отвечает вызывающая сторона! }
      medium.hGlobal := FDropInfo.CreateHDrop;
      Result := S_OK;
    end;
  end;
end;

function THDropDataObject.GetDataHere( const formatetc: TFormatEtc;
    out medium: TStgMedium): HResult;
begin
  Result := DV_E_FORMATETC;  { К сожалению, не поддерживается }
end;

function THDropDataObject.QueryGetData(const formatetc: TFormatEtc): HResult;
begin
  Result := DV_E_FORMATETC;
  with formatetc do
    if dwAspect = DVASPECT_CONTENT then
      if (cfFormat = CF_HDROP) and (tymed = TYMED_HGLOBAL) then
        Result := S_OK;
end;

function THDropDataObject.GetCanonicalFormatEtc(const formatetc: TFormatEtc;
   out formatetcOut: TFormatEtc): HResult;
begin
  formatetcOut.ptd := nil;
  Result := E_NOTIMPL;
end;

function THDropDataObject.SetData(const formatetc: TFormatEtc;
    var medium: TStgMedium; fRelease: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

// TDragDropInfo ///////////////////////////////////////////////////////////////

constructor TDragDropInfo.Create(ADropPoint : TPoint; AInClient : Boolean);
begin
  inherited Create;
  FFileList     := TStringList.Create;
  FDropPoint    := ADropPoint;
  FInClientArea := AInClient;
end;

destructor TDragDropInfo.Destroy;
begin
  FFileList.Free;
  inherited Destroy;
end;

function TDragDropInfo.CreateHDrop : HGlobal;
var
  RequiredSize : Integer;
  i : Integer;
  hGlobalDropInfo : HGlobal;
  DropFiles : PDropFiles;
  c : PChar;
begin
  {
    Построим структуру TDropFiles в памяти, 
    выделенной через
    GlobalAlloc. Область памяти сделаем глобальной 
    и совместной,
    поскольку она, вероятно, будет передаваться 
    другому процессу.
  }

  { Определяем необходимый размер структуры }
  RequiredSize := SizeOf (TDropFiles);
  for i := 0 to Self.Files.Count-1 do
  begin
    { Длина каждой строки, плюс 1 байт для терминатора }
    RequiredSize := RequiredSize + Length(Self.Files[i]) + 1;
  end;
  { 1 байт для завершающего терминатора }
  Inc(RequiredSize);

  hGlobalDropInfo := GlobalAlloc((GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT),
                       RequiredSize);
  if (hGlobalDropInfo <> 0) then
  begin
    { Заблокируем область памяти, чтобы к ней
      можно было обратиться }
    DropFiles := GlobalLock(hGlobalDropInfo);

    { Заполним поля структуры DropFiles }
    { pFiles -- смещение от начала
      структуры до первого байта массива
      с именами файлов. }
    DropFiles.pFiles := SizeOf(TDropFiles);
    DropFiles.pt     := Self.FDropPoint;
    DropFiles.fNC    := Self.InClientArea;
    DropFiles.fWide  := False;

    { Копируем каждое имя файла в буфер.
      Буфер начинается со смещения
      DropFiles + DropFiles.pFiles,
      то есть после последнего поля структуры. }
    c := PChar(DropFiles);
    c := c + DropFiles.pFiles;
    for i := 0 to Self.Files.Count-1 do
    begin
      StrCopy(c, PChar(Self.Files[i]+#0));
      c := c + Length(Self.Files[i]) + 1;
    end;

    { Снимаем блокировку }
    GlobalUnlock (hGlobalDropInfo);
  end;

  Result := hGlobalDropInfo;
end;

procedure TDragDropInfo.Add(const s : String);
begin
  Files.Add(S);
end;

// EnumFormatEtc ///////////////////////////////////////////////////////////////

{ EnumFormatEtc возвращает список
поддерживаемых форматов }
function THDropDataObject.EnumFormatEtc(dwDirection: Longint;
    out enumFormatEtc: IEnumFormatEtc): HResult;
const
  DataFormats: array[0..0] of TFormatEtc =
  ((
      cfFormat : CF_HDROP;
      ptd      : nil;
      dwAspect : DVASPECT_CONTENT;
      lindex   : -1;
      tymed    : TYMED_HGLOBAL;
   ));
  DataFormatCount = 1;
begin
  { Поддерживается только Get. Задать
  содержимое данных нельзя }
  if dwDirection = DATADIR_GET then
  begin
    enumFormatEtc := TEnumFormatEtc.Create(@DataFormats, DataFormatCount, 0);
    Result := S_OK;
  end else
  begin
    enumFormatEtc := nil;
    Result := E_NOTIMPL;
  end;
end;

{ Функции Advise не поддерживаются }
function THDropDataObject.DAdvise(const formatetc: TFormatEtc; advf: Longint;
    const advSink: IAdviseSink; out dwConnection: Longint): HResult;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

function THDropDataObject.DUnadvise(dwConnection: Longint): HResult;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

function THDropDataObject.EnumDAdvise(out enumAdvise: IEnumStatData): HResult;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

// TDropper ////////////////////////////////////////////////////////////////////

constructor TDropper.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
end;

procedure TDropper.StartDrag;
var
  DropSource : TFileDropSource;
  Rslt       : HRESULT;
  dwEffect   : Integer;
  DropPoint  : TPoint;
begin
 try
   { Создаем объект-источник... }
   DropSource := TFileDropSource.Create;

   { ...и объект данных }
   DropPoint.x := 100;
   DropPoint.y := 100;
   DropData := THDropDataObject.Create(DropPoint, True);

   DropSource.OnDragQuery := OnDropUp;
   DropSource.OnDropCheck := OnDropCheck;

   Enabld  := FEnabled;
   FIsDropping := True;

   Rslt := DoDragDrop(DropData, DropSource, DROPEFFECT_COPY, dwEffect);

  // DropData.Free;

   if ((Rslt <> DRAGDROP_S_DROP) and (Rslt <> DRAGDROP_S_CANCEL)) then
     case rslt of
       E_OUTOFMEMORY : raise Exception.Create('Недостаточно памяти для Drag & Drop');
         else raise Exception.Create('При Drag & Drop произошла ошибка');
     end;

   { Освобождаем использованные ресурсы после завершения работы }
   DropSource.Free;
   DropData.Free;

   FIsDropping := False;
 except
 end;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TDropper]);
end;

//initialization
//  OleInitialize(nil);

//finalization
//  OleUninitialize;

end.
