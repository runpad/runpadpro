unit tip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TTipForm = class(TForm)
    Image: TImage;
    Memo: TMemo;
    CheckBox: TCheckBox;
    ButtonOK: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowTip(num:integer);
  end;

var
  TipForm: TTipForm;

implementation

uses global, tools, lang;

{$R *.dfm}

const tips : array [0..3] of string =
(
  S_TIP0,
  S_TIP1,
  S_TIP2,
  S_TIP3
);


procedure TTipForm.FormShow(Sender: TObject);
begin
 ButtonOK.SetFocus;
end;

procedure TTipForm.ShowTip(num:integer);
begin
 if (num>=0) and (num<length(tips)) then
  begin
   if ReadConfigInt(OURAPPNAME+'\Tips','tip'+inttostr(num),1)<>0 then
    begin
     Memo.Text:=tips[num];
     CheckBox.Checked:=false;
     if ShowModal=mrOK then
      begin
       if CheckBox.Checked then
        WriteConfigInt(OURAPPNAME+'\Tips','tip'+inttostr(num),0);
      end;
    end;
  end;
end;

procedure TTipForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_ESCAPE then
  ModalResult:=mrCancel;
end;

end.
