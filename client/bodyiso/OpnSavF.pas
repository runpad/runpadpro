unit OpnSavF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ImgList;

type
  TOpenSaveForm = class(TForm)
    Label1: TLabel;
    FolderComboBox: TComboBox;
    CreateFolder: TSpeedButton;
    FilesListView: TListView;
    Label2: TLabel;
    ExtComboBox: TComboBox;
    Label3: TLabel;
    FileNameEdit: TEdit;
    OpenButton: TButton;
    CancelButton: TButton;
    FolderImages: TImageList;
    FilesImages: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FolderComboBoxChange(Sender: TObject);
    procedure ExtComboBoxChange(Sender: TObject);
    procedure FolderComboBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FilesListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FilesListViewDblClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure CreateFolderClick(Sender: TObject);
  private
    Folders     : TStringList;
    CurrFolder  : string;
    AddFolder   : string;
    CurrExtFull : string;
    CurrExtMin  : string;
    SelectedFile: string;
    fSaving     : boolean;
    function FillFolders:boolean;
    procedure FillFiles;
    function FileExistanceCheck: boolean;
    function ChangeFolderCheck: boolean;
    procedure OpenFile;
  public
    function ExecuteOpenFile( const Ext: string; var FileName: string ): boolean;
    function ExecuteSaveFile( const Ext: string; const fNewFolder: boolean; var FileName: string ): boolean;
  end;

function GetItemFromStructLine( Index, ICount: integer; St: string; Divider: char ): string;

var
  OpenSaveForm: TOpenSaveForm;

implementation

{$R *.dfm}

uses
  ShellAPI, Registry;


{$INCLUDE ..\rp_shared\RP_Shared.inc}


function GetFileNameIcon(s:string):integer;
var info:SHFILEINFO;
begin
 Result:=0;
 if SHGetFileInfo(pchar(s),0,info,sizeof(info),SHGFI_ICON or SHGFI_SMALLICON)<>0 then
  Result:=info.hIcon;
end;



function GetItemFromStructLine( Index, ICount: integer; St: string; Divider: char ): string;
var
  CurrSt   : string;
  CurrIndex: integer;
  i        : integer;
begin
  Result := '';
  try
    CurrSt := '';
    CurrIndex := 1;
    for i := 1 to length( St ) do
      if St[i] = Divider then
        CurrIndex := CurrIndex + 1
      else
        if CurrIndex = Index then
          CurrSt := CurrSt + St[i];

    if CurrIndex = ICount then Result := CurrSt;
  except
    Result := '';
  end;
end;

function CorrectPath( Path: string ): string;
begin
  if ( length( Path ) > 0 ) and ( Path[length( Path )] <> '\' ) then
    Result := Path + '\'
  else
    Result := Path;
end;

function TOpenSaveForm.ExecuteOpenFile(const Ext: string; var FileName: string): boolean;
var
  s: string;
begin
  fSaving := false;
  Caption := ' - Открытие файла - ';
  OpenButton.Caption := 'Открыть';
  CurrFolder := '';
  AddFolder := '';
  CurrExtFull := '';
  CurrExtMin := '';
  SelectedFile := '';
  ExtComboBox.Items.Clear;
  s := Ext;
  repeat
    if pos( ';', s ) > 0 then
      begin
        ExtComboBox.Items.Add( GetItemFromStructLine( 2, 2, copy( s, 1, pos( ';', s ) - 1 ), '|' ) );
        Delete( s, 1, pos( ';', s ) );
      end
    else
      begin
        ExtComboBox.Items.Add( GetItemFromStructLine( 2, 2, s, '|' ) );
        s := '';
      end;
  until s = '';
  ExtComboBox.ItemIndex := 0;
  ExtComboBoxChange( nil );
  CreateFolder.Enabled := false;
  if not FillFolders then
   begin
    Result:=false;
    exit;
   end;
  FileNameEdit.ReadOnly := true;
  FileNameEdit.Text := '';

  ActiveControl := FilesListView;
  ShowModal;
  Result := SelectedFile <> '';
  if Result then
   FileName := SelectedFile;
end;

function TOpenSaveForm.ExecuteSaveFile(const Ext: string; const fNewFolder: boolean; var FileName: string): boolean;
var
  s: string;
begin
  fSaving := true;
  Caption := ' - Сохранение файла - ';
  OpenButton.Caption := 'Сохранить';
  CurrFolder := '';
  AddFolder := '';
  CurrExtFull := '';
  CurrExtMin := '';
  SelectedFile := '';
  ExtComboBox.Items.Clear;
//  ExtComboBox.Items.Add( GetItemFromStructLine( 2, 2, Ext, '|' ) );
  s := Ext;
  repeat
    if pos( ';', s ) > 0 then
      begin
        ExtComboBox.Items.Add( GetItemFromStructLine( 2, 2, copy( s, 1, pos( ';', s ) - 1 ), '|' ) );
        Delete( s, 1, pos( ';', s ) );
      end
    else
      begin
        ExtComboBox.Items.Add( GetItemFromStructLine( 2, 2, s, '|' ) );
        s := '';
      end;
  until s = '';
  ExtComboBox.ItemIndex := 0;
  ExtComboBoxChange( nil );
  CreateFolder.Enabled := fNewFolder;
  if not FillFolders then
   begin
    Result:=false;
    exit;
   end;
  FileNameEdit.ReadOnly := false;
  FileNameEdit.Text := '';

  ActiveControl := FilesListView;
  ShowModal;
  Result := SelectedFile <> '';
  if Result then
   FileName := SelectedFile;
end;

function TOpenSaveForm.FillFolders:boolean;
var
  reg: TRegistry;
  i : integer;
  sname: string;
  spath: string;
  path: array[0..MAX_PATH] of char;
  name: array[0..MAX_PATH] of char;
  AllowSaveToAddonFolders: boolean;
begin
  FolderComboBox.ItemHeight := 16;
  FolderComboBox.Items.Clear;
  Folders.Clear;

  GetUserFolderName(pchar(@name),0);
  GetUserFolderPath(pchar(@path),0);
  sname:=string(pchar(@name));
  spath:=string(pchar(@path));
  if spath<>'' then
    begin
      Folders.Add( sname+'='+spath );
      FolderComboBox.Items.Add( sname );
    end;

  GetFlashName(pchar(@name));
  GetFlashPath(pchar(@path),0);
  sname:=string(pchar(@name));
  spath:=string(pchar(@path));
  if spath<>'' then
    begin
      Folders.Add( sname+'='+spath );
      FolderComboBox.Items.Add( sname );
    end;

  GetDisketteName(pchar(@name));
  GetDiskettePath(pchar(@path));
  spath:=string(pchar(@path));
  sname:=string(pchar(@name));
  if spath<>'' then
    begin
      Folders.Add( sname+'='+spath );
      FolderComboBox.Items.Add( sname );
    end;

  GetVIPFolderName(pchar(@name));
  GetVIPFolderPath(pchar(@path));
  spath:=string(pchar(@path));
  sname:=string(pchar(@name));
  if spath<>'' then
    begin
      Folders.Add( sname+'='+spath );
      FolderComboBox.Items.Add( sname );
    end;

  AllowSaveToAddonFolders := false;
  reg := TRegistry.Create;
  if reg.OpenKeyReadOnly( 'Software\RunpadProShell' ) then 
   begin
    try
     AllowSaveToAddonFolders := reg.ReadBool('allow_save_to_addon_folders');
    except end;
    reg.CloseKey;
   end;
  reg.Free;

  if AllowSaveToAddonFolders then
    for i:=0 to GetAdditionalFoldersCount-1 do
      begin
        GetAdditionalFolderName(pchar(@name),i);
        GetAdditionalFolderPath(pchar(@path),i);
        spath:=string(pchar(@path));
        sname:=string(pchar(@name));
        if spath<>'' then
          begin
            Folders.Add( sname+'='+spath );
            FolderComboBox.Items.Add( sname );
          end;
      end;

  if Folders.count=0 then
   begin
    MessageBox(0,'Ни папка пользователя, ни Flash-диск, ни дискета, ни дополнительные папки не найдены!','Ошибка',MB_OK or MB_ICONERROR or MB_TOPMOST);
    Result:=false;
    exit;
   end;

  CurrFolder := '';
  AddFolder := '';
  FolderComboBox.ItemIndex := 0;
  FolderComboBoxChange( nil );
  Result:=true;
end;

procedure TOpenSaveForm.FormCreate(Sender: TObject);
begin
  Folders := nil;
  Folders := TStringList.Create;
end;

procedure TOpenSaveForm.FormDestroy(Sender: TObject);
begin
  if Folders <> nil then Folders.Free;
end;

procedure TOpenSaveForm.FolderComboBoxChange(Sender: TObject);
begin
  CurrFolder := CorrectPath( GetItemFromStructLine( 2, 2, Folders[FolderComboBox.ItemIndex], '=' ) );
  AddFolder := '';
  FillFiles;
end;

procedure TOpenSaveForm.ExtComboBoxChange(Sender: TObject);
var
  s: string;
  i: integer;
begin
  s := ExtComboBox.Items[ExtComboBox.ItemIndex];
  if pos( ' (*.', s ) > 0 then
    begin
      CurrExtFull := s;
      Delete( CurrExtFull, 1, pos( ' (*.', s ) + 1 );
      CurrExtFull := copy( CurrExtFull, 1, pos( ')', CurrExtFull ) - 1 );
    end
  else
    CurrExtFull := '*.*';

  s := CurrExtFull;
  CurrExtMin := '';
  for i := 1 to length( s ) do
    if s[i] <> '*' then
      CurrExtMin := CurrExtMin + s[i];

  FillFiles;
end;

procedure TOpenSaveForm.FillFiles;
var
  SR   : TSearchRec;
  DList: TStringList;
  FList: TStringList;
  i    : integer;
  ico  : TIcon;
begin
  FilesListView.Items.Clear;
  if ( CurrFolder = '' ) or ( not DirectoryExists( CurrFolder ) ) or ( not DirectoryExists( CurrFolder + AddFolder ) ) then exit;

  DList := nil;
  FList := nil;
  try
    DList := TStringList.Create;
    FList := TStringList.Create;

    if FindFirst( CurrFolder + AddFolder + '*.*', faDirectory, SR ) = 0 then
      begin
        repeat
          if ( SR.Attr and faDirectory = faDirectory ) and ( SR.Name <> '.' ) and
             ( ( AddFolder <> '' ) or ( SR.Name <> '..' ) ) then
            DList.Add( SR.Name );
        until FindNext( SR ) <> 0;
        FindClose( SR );
      end;

    if FindFirst( CurrFolder + AddFolder + CurrExtFull, faAnyFile, SR ) = 0 then
      begin
        repeat
          if ( SR.Attr and 8{faVolumeID} <> 8{faVolumeID} ) and
             ( SR.Attr and faDirectory <> faDirectory ) then
            FList.Add( SR.Name );
        until FindNext( SR ) <> 0;
        FindClose( SR );
      end;

    DList.Sorted := true; DList.Sort;
    FList.Sorted := true; FList.Sort;

    for i := 1 to DList.Count do
      with FilesListView.Items.Add do
        begin
          Caption := DList[i-1];
          ImageIndex := 0;
        end;
    for i := 1 to FList.Count do
      begin
        ico := nil;
        try
          ico := TIcon.Create;
          ico.Handle := GetFileNameIcon( CurrFolder + AddFolder + FList[i-1] );
          FilesImages.AddIcon( ico );
          ico.Free;
        except
          if ico <> nil then ico.Free;
        end;

        with FilesListView.Items.Add do
          begin
            Caption := FList[i-1];
            ImageIndex := FilesImages.Count - 1;
          end;
      end;

  finally
    if DList <> nil then DList.Free;
    if FList <> nil then FList.Free;
  end;
end;

procedure TOpenSaveForm.FolderComboBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  FBmp: TBitmap;
  DS  : TDrawingStyle;
begin
  DS := FolderImages.DrawingStyle;
  if ( odSelected in State ) or ( odGrayed in State ) or ( odDisabled in State ) or
     ( odChecked in State ) or ( odFocused in State ) then
    FolderImages.DrawingStyle := dsFocus;

  FBmp := nil;
  try
    FBmp := TBitmap.Create;
    FolderImages.GetBitmap( 0, FBmp );
    with FolderComboBox.Canvas do
      begin
        FillRect( Rect );
        Draw( Rect.Left + 2, Rect.Top + 0, FBmp );
        TextOut( Rect.Left + 5 + FBmp.Width, Rect.Top + 2, FolderComboBox.Items.Strings[Index] );
      end;
  finally
    if FBmp <> nil then FBmp.Free;
  end;
  FolderImages.DrawingStyle := DS;
end;

procedure TOpenSaveForm.FilesListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Item.ImageIndex > 0 then FileNameEdit.Text := Item.Caption else FileNameEdit.Text := '';
end;


function TOpenSaveForm.FileExistanceCheck: boolean;
begin
  Result := true;
  if FileNameEdit.Text <> '' then
    if fSaving and ( FileExists( CurrFolder + AddFolder + FileNameEdit.Text ) or FileExists( CurrFolder + AddFolder + FileNameEdit.Text + CurrExtMin ) ) then
      if MessageBox( Handle, 'Файл с таким именем уже существует! Перезаписать?', 'Подтвердите', mb_YesNo + mb_DefButton2 + mb_IconQuestion + mb_TaskModal ) <> IDYes then
        Result := false
      else
        if FileExists( CurrFolder + AddFolder + FileNameEdit.Text ) then
          DeleteFile( CurrFolder + AddFolder + FileNameEdit.Text )
        else
          DeleteFile( CurrFolder + AddFolder + FileNameEdit.Text + CurrExtMin )
    else
      if ( not fSaving ) and ( not FileExists( CurrFolder + AddFolder + FileNameEdit.Text ) ) and ( not FileExists( CurrFolder + AddFolder + FileNameEdit.Text ) ) then
        begin
          MessageBox( Handle, 'Файла с таким именем не существует!', 'Ошибка', mb_Ok + mb_IconError + mb_TaskModal );
          Result := false
        end;
end;

function TOpenSaveForm.ChangeFolderCheck: boolean;
var
  i: integer;
begin
  if ( FilesListView.ItemIndex >= 0 ) and ( FilesListView.ItemFocused.ImageIndex = 0 ) then
    begin 
      if FilesListView.ItemFocused.Caption = '..' then
        if AddFolder <> '' then
          begin
            Delete( AddFolder, length( AddFolder ), 1 );
            for i := 1 to length( AddFolder ) do
              if AddFolder[length( AddFolder )] = '\' then
                break
              else
                Delete( AddFolder, length( AddFolder ), 1 );
          end
        else
      else
        AddFolder := AddFolder + FilesListView.ItemFocused.Caption + '\';
      FillFiles;
      Result := true;
    end
  else
    Result := false;
end;


procedure TOpenSaveForm.OpenFile;
begin
  SelectedFile := CurrFolder + AddFolder + FileNameEdit.Text;
  if pos( AnsiLowerCase( CurrExtMin ), AnsiLowerCase( FileNameEdit.Text ) ) < 1 then
    begin
      SelectedFile := SelectedFile + CurrExtMin;
    end;
  ModalResult := mrOk;
end;


procedure TOpenSaveForm.FilesListViewDblClick(Sender: TObject);
begin
  if not FileExistanceCheck then
    exit;

  if not ChangeFolderCheck then
    begin
      if ( FilesListView.ItemIndex >= 0 ) and ( FilesListView.ItemFocused.ImageIndex <> 0 ) then
        FileNameEdit.Text := FilesListView.ItemFocused.Caption;
      if FileNameEdit.Text = '' then exit;

      OpenFile;
    end;
end;

procedure TOpenSaveForm.OpenButtonClick(Sender: TObject);
begin
  ModalResult := mrNone;
  if FileNameEdit.Text <> '' then
    begin
      if FileExistanceCheck then
        OpenFile;
    end
  else
    ChangeFolderCheck;
end;

procedure TOpenSaveForm.CreateFolderClick(Sender: TObject);
var
  FolName: string;
  i      : integer;
begin
  FolName := InputBox( 'Новая папка', 'Укажите имя новой папки', '' );
  if FolName = '' then exit;
  if DirectoryExists( CurrFolder + AddFolder + FolName ) then
    begin
      MessageBox( Handle, 'Папка с таким именем уже существует!', 'Ошибка', mb_Ok + mb_IconError + mb_TaskModal );
      exit;
    end;
  try
    if not CreateDir( CurrFolder + AddFolder + FolName ) then
      MessageBox( Handle, pchar( Format( 'Ошибка при создании папки %s!', [FolName] ) ), 'Ошибка', mb_Ok + mb_IconError + mb_TaskModal )
    else
      begin
        FillFiles;
        for i := 1 to FilesListView.Items.Count do
          if ( FilesListView.Items[i-1].Caption = FolName ) and ( FilesListView.Items[i-1].ImageIndex = 0 ) then
            begin
              FilesListView.ItemIndex := i - 1;
              FilesListView.Items[i-1].Focused := true;
              break;
            end;
      end;
  except
  end;
end;

end.
