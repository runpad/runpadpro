unit Archive;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFormArchive = class(TForm)
    CheckBox144: TCheckBox;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    LabelName: TLabel;
    ImageBook: TImage;
    EditName: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormArchive: TFormArchive;

implementation

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}

procedure TFormArchive.FormShow(Sender: TObject);
begin
 Caption:=LS(1300);
 LabelName.Caption:=LS(1301);
 CheckBox144.Caption:=LS(1302);
 ButtonOK.Caption:=LS(LS_OK);
 ButtonCancel.Caption:=LS(LS_CANCEL);
end;

end.
