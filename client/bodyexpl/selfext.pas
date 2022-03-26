unit selfext;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSEForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetExeName(s:string);
  end;

var
  SEForm: TSEForm;

implementation

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}


procedure TSEForm.SetExeName(s:string);
begin
 Label2.Caption:=s;
end;

procedure TSEForm.FormShow(Sender: TObject);
begin
   Caption:=LS(1321);
   Label1.Caption:=LS(1322);
   Label3.Caption:=LS(1323);
   Label4.Caption:=LS(1324);
   Button1.Caption:=LS(1325);
   Button2.Caption:=LS(1326);
   Button3.Caption:=LS(LS_CANCEL);
end;

end.
