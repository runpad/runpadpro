unit save_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TSaveForm = class(TForm)
    Label1: TLabel;
    Button3: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender:TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
{$INCLUDE ..\..\RP_Shared\RP_Shared.inc}


procedure TSaveForm.FormShow(Sender:TObject);
begin
 Caption:=LS(1507);
 Label1.Caption:=LS(1508);
 BitBtn1.Caption:=LS(1509);
 BitBtn2.Caption:=LS(1510);
 Button3.Caption:=LS(LS_CANCEL);
end;


end.
