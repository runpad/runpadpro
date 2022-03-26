unit filefolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFileFolderForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    s_filter, s_name : pchar;
    b_showfiles : boolean;
    b_emul : boolean;
  public
    { Public declarations }
    procedure SetInfo(emul:boolean;filter,name:pchar;show_files_in_folders:boolean);
  end;

implementation

uses shlobj, activex, commdlg, lang;

{$R *.dfm}


function PathUnExpandEnvStrings(pszPath,pszBuf:pchar;cchBuf:cardinal):longbool; stdcall; external 'shlwapi.dll' name 'PathUnExpandEnvStringsA';

function UnExpandPath(s:string):string;
var buff : array [0..MAX_PATH-1] of char;
begin
 buff[0]:=#0;
 if PathUnExpandEnvStrings(pchar(s),buff,sizeof(buff)) then
  Result:=buff
 else
  Result:=s;
end;

function SysGetFolder(parent:HWND;show_files:boolean):string;
var pMalloc:IMalloc;
    bi:_browseinfoA;
    pidl:PITEMIDLIST;
    s:array[0..MAX_PATH] of char;
begin
 Result:='';
 if SUCCEEDED( SHGetMalloc(pMalloc) ) then
  begin
   FillChar(bi,sizeof(bi),0);
   bi.hwndOwner:=parent;
   bi.ulFlags:=BIF_RETURNONLYFSDIRS;
   if show_files then
    bi.ulFlags:=bi.ulFlags or BIF_BROWSEINCLUDEFILES;
   pidl:=SHBrowseForFolder(bi);
   if pidl<>nil then
    begin
     if SHGetPathFromIDList(pidl,s) then
      Result:=s;
     pMalloc.Free(pidl);
     pidl:=nil;
    end;
   //pMalloc._Release;
   pMalloc:=nil;
  end;
end;


type
  MyOFN = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PAnsiChar;
    lpstrCustomFilter: PAnsiChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PAnsiChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PAnsiChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PAnsiChar;
    lpstrTitle: PAnsiChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PAnsiChar;
    lCustData: LPARAM;
    lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpTemplateName: PAnsiChar;
  end;


function MyGetOpenFileName(var OpenFile: MyOFN): Bool; stdcall; external 'comdlg32.dll'  name 'GetOpenFileNameA';


function SysGetOpenFile(parent:HWND;filter,name:pchar):string;
var p:MyOFN;
    s:array[0..MAX_PATH] of char;
begin
 StrCopy(s,name);

 FillChar(p,sizeof(p),0);
 p.lStructSize:=sizeof(p);
 p.hWndOwner:=parent;
 p.lpstrFilter:=filter;
 p.nFilterIndex:=1;
 p.lpstrFile:=s;
 p.nMaxFile:=MAX_PATH;
 p.Flags:=OFN_FILEMUSTEXIST or OFN_HIDEREADONLY or OFN_LONGNAMES or OFN_PATHMUSTEXIST;

 if MyGetOpenFileName(p) then
  Result:=s
 else
  Result:='';
end;


procedure TFileFolderForm.FormCreate(Sender: TObject);
begin
 s_filter:=nil;
 s_name:=nil;
 b_showfiles:=false;
 b_emul:=false;
end;

procedure TFileFolderForm.SetInfo(emul:boolean;filter,name:pchar;show_files_in_folders:boolean);
var is_file : boolean;
begin
 b_emul:=emul;
 s_filter:=filter;
 s_name:=name;
 b_showfiles:=show_files_in_folders;
 is_file:=(s_filter<>nil) and (s_name<>nil);

 if is_file then
  Caption:=S_SELECTFILE
 else
  begin
   if not b_showfiles then
    Caption:=S_SELECTFOLDER
   else
    Caption:=S_SELECTFILEFOLDER;
  end;

 if emul then
  begin
   if is_file then
    begin
     Label1.Caption:=S_SELECTFILEREMOTE+' ('+string(filter)+'):';
     Edit1.Text:=name;
    end
   else
    begin
     if not b_showfiles then
      Label1.Caption:=S_SELECTFOLDERREMOTE
     else
      Label1.Caption:=S_SELECTFILEFOLDERREMOTE;
    end;
  end
 else
  begin
   if is_file then
    begin
     Label1.Caption:=S_SELECTFILELOCAL+' ('+string(filter)+'):';
     Edit1.Text:=name;
    end
   else
    begin
     if not b_showfiles then
      Label1.Caption:=S_SELECTFOLDERLOCAL
     else
      Label1.Caption:=S_SELECTFILEFOLDERLOCAL;
    end;
  end;
end;

procedure TFileFolderForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 if key=#27 then
  ModalResult:=mrCancel;
 if key=#13 then
  ModalResult:=mrOk;
end;


procedure TFileFolderForm.Button2Click(Sender: TObject);
var s:string;
begin
 if (s_filter<>nil) and (s_name<>nil) then
  s:=SysGetOpenFile(Handle,s_filter,s_name)
 else
  s:=SysGetFolder(Handle,b_showfiles);

 if s<>'' then
  begin
   if b_emul then
    s:=UnExpandPath(s);
   Edit1.Text:=s;
  end;
end;

end.
