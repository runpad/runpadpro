unit erase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TEraseDiscForm = class(TForm)
    Panel1: TPanel;
    Timer: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    dev_num:integer;
  end;


implementation

{$R *.dfm}
{$INCLUDE bodyburn.inc}


procedure TEraseDiscForm.FormCreate(Sender: TObject);
begin
 dev_num:=-1;
end;

procedure TEraseDiscForm.FormShow(Sender: TObject);
begin
 Timer.Enabled:=true;
 Screen.Cursor:=crHourGlass;
end;

procedure TEraseDiscForm.FormHide(Sender: TObject);
begin
 Timer.Enabled:=false;
 Screen.Cursor:=crDefault;
end;

procedure TEraseDiscForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose:=(dev_num=-1);
end;

procedure TEraseDiscForm.TimerTimer(Sender: TObject);
begin
 Timer.Enabled:=false;
 if BurnEraseDisc(dev_num) then
  MessageBox(Handle,'Диск успешно очищен!','Сообщение',MB_OK or MB_ICONINFORMATION)
 else
  MessageBox(Handle,'Ошибка при очистке диска','Ошибка',MB_OK or MB_ICONERROR);
 dev_num:=-1;
 Close;
end;

end.
