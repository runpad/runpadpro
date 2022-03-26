
unit tools;

interface

uses Windows, Classes, ComCtrls, Controls;


function TrueGetFolder(showfiles:boolean):string;
function TrueGetOpenFile(filter,name:pchar):string;
function EmulGetFolder(showfiles:boolean):string;
function EmulGetOpenFile(filter,name:pchar):string;
function GetLocalPath(local:string):string;
function GetFileNameIcon(s:string):integer;
procedure WaitCursor(state:boolean;process_messages:boolean);
function ExecLocalFile(s:string):boolean;
procedure WriteConfigStr(local_key,value,data:string);
procedure WriteConfigInt(local_key,value:string;data:integer);
function ReadConfigStr(local_key,value,def:string):string;
function ReadConfigInt(local_key,value:string;def:integer):integer;
procedure FillStringListWithHistory(list:TStrings;name:string);
procedure StoreHistoryFromStringList(list:TStrings;name:string);
procedure UpdateHistoryFromComboBox(ComboBoxEx:TComboBoxEx;list_id:string);
function ReplaceInvalidFileNameChars(const src:string):string;


implementation

uses global, filefolder, SysUtils, StrUtils, shellapi, Forms, Registry;


function FileFolderInternal(emul:boolean;filter,name:pchar;show_files_in_folders:boolean):string;
var form : TFileFolderForm;
begin
  Result:='';
  form:=TFileFolderForm.Create(nil);
  form.SetInfo(emul,filter,name,show_files_in_folders);
  if form.ShowModal=idOk then
    Result:=form.Edit1.Text;
  form.Free;
end;


function TrueGetFolder(showfiles:boolean):string;
begin
 Result:=FileFolderInternal(FALSE,nil,nil,showfiles);
end;

function TrueGetOpenFile(filter,name:pchar):string;
begin
 if filter=nil then
  filter:='';
 if name=nil then
  name:='';
 Result:=FileFolderInternal(FALSE,filter,name,FALSE);
end;

function EmulGetFolder(showfiles:boolean):string;
begin
 Result:=FileFolderInternal(TRUE,nil,nil,showfiles);
end;

function EmulGetOpenFile(filter,name:pchar):string;
begin
 if filter=nil then
  filter:='';
 if name=nil then
  name:='';
 Result:=FileFolderInternal(TRUE,filter,name,FALSE);
end;

function GetLocalPath(local:string):string;
var s:array[0..MAX_PATH] of char;
begin
 s[0]:=#0;
 GetModuleFileName(hInstance,s,sizeof(s));
 Result:=IncludeTrailingPathDelimiter(ExtractFilePath(s))+local;
end;

function GetFileNameIcon(s:string):integer;
var info:SHFILEINFO;
begin
 Result:=0;
 if SHGetFileInfo(pchar(s),0,info,sizeof(info),SHGFI_ICON or SHGFI_SMALLICON)<>0 then
  Result:=info.hIcon;
 if Result=0 then
  Result:=CopyIcon(LoadIcon(0,IDI_APPLICATION));
end;

procedure WaitCursor(state:boolean;process_messages:boolean);
begin
 if state then
  begin
   Screen.Cursor:=crHourGlass;
   if process_messages then
     Application.ProcessMessages;
  end
 else
  begin
   Screen.Cursor:=crDefault;
  end;
end;

function ExecLocalFile(s:string):boolean;
var cwd:string;
    p:array[0..MAX_PATH] of char;
    si:_STARTUPINFOA;
    pi:_PROCESS_INFORMATION;
begin
 cwd:=IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));
 StrCopy(p,pchar(cwd+s));
 FillChar(si,sizeof(si),0);
 si.cb:=sizeof(si);
 Result:=CreateProcess(nil,p,nil,nil,false,0,nil,pchar(cwd),si,pi);
end;

procedure WriteConfigStr(local_key,value,data:string);
var reg:TRegistry;
begin
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if reg.OpenKey(REGPATH+local_key,true) then
   begin
     try
       reg.WriteString(value,data);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
end;

procedure WriteConfigInt(local_key,value:string;data:integer);
var reg:TRegistry;
begin
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if reg.OpenKey(REGPATH+local_key,true) then
   begin
     try
       reg.WriteInteger(value,data);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
end;

function ReadConfigStr(local_key,value,def:string):string;
var reg:TRegistry;
    s:string;
begin
 s:=def;
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly(REGPATH+local_key) then
   begin
     try
      s:=reg.ReadString(value);
      if s='' then
        s:=def;
     except end;
     reg.CloseKey;
   end;
 reg.Free;
 Result:=s;
end;

function ReadConfigInt(local_key,value:string;def:integer):integer;
var reg:TRegistry;
    rc:integer;
begin
 rc:=def;
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly(REGPATH+local_key) then
   begin
     try
      rc:=reg.ReadInteger(value);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
 Result:=rc;
end;


const MAXHISTORYLIST = 20;

procedure FillStringListWithHistory(list:TStrings;name:string);
var n:integer;
    s:string;
begin
 list.Clear;

 if name<>'' then
  begin
   for n:=0 to MAXHISTORYLIST-1 do
    begin
     s:=ReadConfigStr(OURAPPNAME+'\InputHistory\'+name,'item'+inttostr(n),'');
     if s='' then
      break;
     list.Add(s);
    end;
  end;
end;


procedure StoreHistoryFromStringList(list:TStrings;name:string);
var n:integer;
    s:string;
begin
 if name<>'' then
  begin
   for n:=0 to MAXHISTORYLIST-1 do
    begin
     if n>list.Count-1 then
      s:=''
     else
      s:=list[n];
     WriteConfigStr(OURAPPNAME+'\InputHistory\'+name,'item'+inttostr(n),s);
    end;
  end;
end;


procedure UpdateHistoryFromComboBox(ComboBoxEx:TComboBoxEx;list_id:string);
var s:string;
    find:boolean;
    n:integer;
begin
 if list_id<>'' then
  begin
   if trim(ComboBoxEx.Text)<>'' then
    begin
     s:=ComboBoxEx.Text;
     find:=false;
     for n:=0 to ComboBoxEx.Items.Count-1 do
      if AnsiCompareText(ComboBoxEx.Items[n],s)=0 then
       begin
        find:=true;
        break;
       end;
     if not find then
      begin
       ComboBoxEx.Items.Insert(0,s);
       StoreHistoryFromStringList(ComboBoxEx.Items,list_id);
      end;
    end;
  end;
end;


function ReplaceInvalidFileNameChars(const src:string):string;
const inv:string = '"*/:<>?\~`{}[]|^';
var s:string;
    n:integer;
begin
 s:=src;

 for n:=1 to length(s) do
  if (ord(s[n])<32) or AnsiContainsText(inv,s[n]) then
   s[n]:='_';

 Result:=s;
end;


end.
