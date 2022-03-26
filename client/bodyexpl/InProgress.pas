unit InProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFormInProgress = class(TForm)
    Label1: TLabel;
    Bevel: TBevel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormInProgress: TFormInProgress;

implementation

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}

procedure TFormInProgress.FormShow(Sender: TObject);
begin
 Label1.Caption:=LS(1312);
end;

end.
