unit UserMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TUserMessageForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ComboBoxEx: TComboBoxEx;
    Label2: TLabel;
    ComboBoxTime: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
    m_list_id : string;
  public
    { Public declarations }
    constructor CreateForm(max_length:integer);
    destructor Destroy; override;
  end;


function ShowUserMessageFormModal(var out_text:string;var out_delay:integer;max_length:integer):boolean;


implementation

uses tools,lang;

{$R *.dfm}


function ShowUserMessageFormModal(var out_text:string;var out_delay:integer;max_length:integer):boolean;
var f:TUserMessageForm;
begin
 Result:=false;
 f:=TUserMessageForm.CreateForm(max_length);
 if f.ShowModal=mrOk then
  begin
   out_text:=f.ComboBoxEx.Text;
   out_delay:=StrToIntDef(f.ComboBoxTime.Items[f.ComboBoxTime.ItemIndex],1);
   Result:=true;
  end;
 f.Free;
end;

constructor TUserMessageForm.CreateForm(max_length:integer);
var i:TIcon;
    n:integer;
begin
 inherited Create(nil);

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(hinstance,pchar(233),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 m_list_id:='SendMessage';
 FillStringListWithHistory(ComboBoxEx.Items,m_list_id);
 ComboBoxEx.Text:='';
 ComboBoxEx.MaxLength:=max_length;

 for n:=0 to 100 do
  ComboBoxTime.Items.Add(IntToStr(n+1));
 ComboBoxTime.ItemIndex:=9;
end;

destructor TUserMessageForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TUserMessageForm.FormShow(Sender: TObject);
begin
 ComboBoxEx.SetFocus;
end;

procedure TUserMessageForm.ButtonOKClick(Sender: TObject);
begin
 if (trim(ComboBoxEx.Text)='') then
  begin
   MessageBox(Handle,S_EMPTYSTRING,S_ERR,MB_OK or MB_ICONERROR);
   ComboBoxEx.SetFocus;
  end
 else
  begin
   UpdateHistoryFromComboBox(ComboBoxEx,m_list_id);
   ModalResult:=mrOk;
  end;
end;

end.
