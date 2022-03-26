unit fav;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFavForm = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    EditURL: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender:TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
{$INCLUDE ..\..\RP_Shared\RP_Shared.inc}



procedure TFavForm.FormShow(Sender:TObject);
begin
   Caption:=LS(1502);
   Label1.Caption:=LS(1503);
   Label2.Caption:=LS(1504);
   Button1.Caption:=LS(1505);
   Button2.Caption:=LS(LS_CANCEL);
end;


end.
