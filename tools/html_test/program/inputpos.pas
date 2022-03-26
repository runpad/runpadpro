unit inputpos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TInputPosForm = class(TForm)
    Edit1: TEdit;
    Timer1: TTimer;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    inactive_sec : cardinal;
    procedure WMActivate(var M: TWMActivate); message WM_ACTIVATE;
    procedure WMActivateApp(var M: TWMActivateApp); message WM_ACTIVATEAPP;
  public
    { Public declarations }
    constructor CreateForm(pwdchar:char;x,y,w,h,maxlen:integer;const intext:string);
  end;

function ShowInputPosFormModal(pwdchar:char;x,y,w,h,maxlen:integer;var inout:string):boolean;

implementation

{$R *.dfm}

function ShowInputPosFormModal(pwdchar:char;x,y,w,h,maxlen:integer;var inout:string):boolean;
var f:TInputPosForm;
begin
 Result:=false;
 f:=TInputPosForm.CreateForm(pwdchar,x,y,w,h,maxlen,inout);
 if f.ShowModal=mrOk then
  begin
   inout:=f.Edit1.Text;
   Result:=true;
  end;
 ReleaseCapture();
 f.Free;
end;

constructor TInputPosForm.CreateForm(pwdchar:char;x,y,w,h,maxlen:integer;const intext:string);
begin
 inherited Create(nil);

 inactive_sec:=0;

 if maxlen<1 then
  maxlen:=1;
 if maxlen>1000 then
  maxlen:=1000;

 Edit1.MaxLength:=maxlen;
 Edit1.PasswordChar:=pwdchar;
 Edit1.Width:=w;
 Edit1.Height:=h;
 Edit1.Top:=0;
 Edit1.Left:=0;

 ClientWidth:=w;
 ClientHeight:=h;
 Left:=x;
 Top:=y;

 Edit1.Text:=Copy(intext,1,maxlen);
end;

procedure TInputPosForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_ESCAPE then
  ModalResult:=mrCancel
 else
 if (key=VK_RETURN) or (key=VK_TAB) then
  ModalResult:=mrOK;
 inactive_sec:=0;
end;

procedure TInputPosForm.WMActivate(var M: TWMActivate);
begin
 if M.Active = WA_INACTIVE then
  ModalResult:=mrOk;
 inherited;
end;

procedure TInputPosForm.WMActivateApp(var M: TWMActivateApp);
begin
 if not M.Active then
  ModalResult:=mrOk;
 inherited;
end;

procedure TInputPosForm.Timer1Timer(Sender: TObject);
begin
 inc(inactive_sec);
 if inactive_sec >= 60 then
  ModalResult:=mrOk;
end;

procedure TInputPosForm.FormShow(Sender: TObject);
begin
 SetCapture(Handle);
end;

procedure TInputPosForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (x<0) or (y<0) or (x>=width) or (y>=height) then
  ModalResult:=mrOk;
end;

end.
