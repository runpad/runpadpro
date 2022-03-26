unit saver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, M_Dropper, tools;

type
  TSaverForm = class(TMinModalWrapper)
    ListView: TListView;
    Label1: TLabel;
    ImageList: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    Dropper: TDropper;
    MouseDownX, MouseDownY: integer;
    inout_file : pchar;
  public
    { Public declarations }
    procedure Init(const title:pchar;direction:integer;filename:pchar);
    procedure DropperDropUp(var Files: TStringList);
    procedure DropperCheckTargetWindow(var Allow: Boolean);
    procedure WMDropFiles(var M: TWMDropFiles);message WM_DROPFILES;
    procedure AcceptFiles(hDrop: THandle);
  end;


function ShowSaverWindow(parent:HWND;direction:integer;const title:pchar;filename:pchar):longbool; cdecl;


implementation

uses ShellApi;

{$R *.dfm}

{$I ..\..\rp_shared\rp_shared.inc}


procedure TSaverForm.FormCreate(Sender: TObject);
begin
 inout_file:=nil;

 Dropper:=TDropper.Create(Self);
 Dropper.Enabled := False;
 Dropper.OnDropUp := DropperDropUp;
 Dropper.OnDropCheck := DropperCheckTargetWindow;
end;

procedure TSaverForm.FormDestroy(Sender: TObject);
begin
 Dropper.Free;
end;

procedure TSaverForm.Init(const title:pchar;direction:integer;filename:pchar);
var item:TListItem;
    s:string;
begin
 Caption:=title;
 inout_file:=filename;

 if direction=2 then
  begin //out
   if (filename<>nil) and (length(string(filename))>0) then
    begin
     s:=ExcludeTrailingPathDelimiter(string(filename));
     s:=ExtractFileName(s);
     if s<>'' then
      begin
       item:=ListView.Items.Add;
       item.Caption:=s;
       item.ImageIndex:=0;
       Label1.Caption:=LS(1100);
       Dropper.Enabled:=true;
       DragAcceptFiles(Handle, False);
      end;
    end;
  end
 else
  begin //in
   Label1.Caption:=LS(1101);
   Dropper.Enabled:=false;
   DragAcceptFiles(Handle, True);
  end;
end;

procedure TSaverForm.DropperDropUp(var Files: TStringList);
begin
 if inout_file<>nil then
  Files.Add(string(inout_file));
end;

procedure TSaverForm.DropperCheckTargetWindow(var Allow: Boolean);
begin
 Allow:=true;
end;

procedure TSaverForm.ListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDownX := X;
  MouseDownY := Y;
end;

procedure TSaverForm.ListViewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (ssLeft in Shift) and (abs(MouseDownX-X)+abs(MouseDownY-Y)>10) then
    if ListView.SelCount>0 then
      Dropper.StartDrag;
end;

procedure TSaverForm.WMDropFiles(var M: TWMDropFiles);
begin
  AcceptFiles(M.Drop);
  DragFinish(M.Drop);
  M.Result := 0;
end;

procedure TSaverForm.AcceptFiles(hDrop: THandle);
var
  buf: array[0..MAX_PATH]of char;
  numfiles: integer;
begin
  numfiles := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);
  if numfiles<>1 then
  begin
   MessageBox(handle,LSP(1102),LSP(LS_ERR),MB_OK or MB_ICONERROR);
   exit;
  end;

  buf[0]:=#0;
  DragQueryFile(hDrop, 0, buf, sizeof(buf));
  if (buf[0]<>#0) and (inout_file<>nil) then
   begin
    lstrcpy(inout_file,buf);
    ModalResult:=mrOk;
   end;
end;


function ShowSaverWindow(parent:HWND;direction:integer;const title:pchar;filename:pchar):longbool; cdecl;
var Form : TSaverForm;
    style : integer;
begin
  Form:=TSaverForm.CreateParented(parent);
  style:=GetWindowLong(Form.Handle,GWL_STYLE);
  style:=(style and (not WS_CHILD)) or integer(WS_POPUP);
  SetWindowLong(Form.Handle,GWL_STYLE,style);
  Form.Init(title,direction,filename);
  Result:=(Form.ShowModal=idOk);
  Form.Free;
end;


end.
