unit rule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TRuleForm = class(TForm)
    EditRule: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ComboBoxVars: TComboBox;
    Label3: TLabel;
    ComboBoxCnt: TComboBox;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    procedure ButtonOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateForm(const rule:string;const list_vars,list_cnts:array of string;vars_idx,cnts_idx:integer;show_cnt:boolean);
    destructor Destroy; override;
  end;


function ShowRuleFormModal(var rule:string;const list_vars,list_cnts:array of string;var vars_idx,cnts_idx:integer;show_cnt:boolean):boolean;


implementation

uses lang;

{$R *.dfm}

function ShowRuleFormModal(var rule:string;const list_vars,list_cnts:array of string;var vars_idx,cnts_idx:integer;show_cnt:boolean):boolean;
var f:TRuleForm;
begin
 Result:=false;
 f:=TRuleForm.CreateForm(rule,list_vars,list_cnts,vars_idx,cnts_idx,show_cnt);
 if f.ShowModal=mrOk then
  begin
   rule:=f.EditRule.Text;
   vars_idx:=f.ComboBoxVars.ItemIndex;
   cnts_idx:=f.ComboBoxCnt.ItemIndex;
   Result:=true;
  end;
 f.Free;
end;


constructor TRuleForm.CreateForm(const rule:string;const list_vars,list_cnts:array of string;vars_idx,cnts_idx:integer;show_cnt:boolean);
var n:integer;
begin
 inherited Create(nil);

 EditRule.Text:=rule;

 for n:=0 to high(list_vars) do
  ComboBoxVars.Items.Add(list_vars[n]);
 ComboBoxVars.ItemIndex:=vars_idx;
 for n:=0 to high(list_cnts) do
  ComboBoxCnt.Items.Add(list_cnts[n]);
 ComboBoxCnt.ItemIndex:=cnts_idx;

 if not show_cnt then
  begin
   Label3.Visible:=false;
   ComboBoxCnt.Visible:=false;
  end;
end;

destructor TRuleForm.Destroy;
begin

 inherited;
end;

procedure TRuleForm.ButtonOKClick(Sender: TObject);
begin
 if (ComboBoxVars.ItemIndex=-1) or (ComboBoxCnt.Visible and (ComboBoxCnt.ItemIndex=-1)) then
  MessageBox(Handle,S_PROFILESNOTSELECTED,S_ERR,MB_OK or MB_ICONERROR)
 else
  ModalResult:=mrOk;
end;

procedure TRuleForm.FormShow(Sender: TObject);
begin
 EditRule.SetFocus;
end;

end.
