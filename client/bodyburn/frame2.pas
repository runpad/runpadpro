unit frame2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TPage2 = class(TFrame)
    Label1: TLabel;
    RadioButtonCD: TRadioButton;
    RadioButtonDVD: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OnShow(Sender:TObject);
    procedure OnCreate(Sender:TObject);
    function IsDVDSelected:boolean;
  end;

implementation

uses global;

{$R *.dfm}

procedure TPage2.OnCreate(Sender:TObject);
begin
 RadioButtonCD.Checked:=true;

 if IsNetBurn() then
  begin
   Label2.Visible:=false;
   Label3.Visible:=false;
  end;
end;

procedure TPage2.OnShow(Sender:TObject);
begin
//
end;

function TPage2.IsDVDSelected:boolean;
begin
 Result:=RadioButtonDVD.Checked;
end;

end.
