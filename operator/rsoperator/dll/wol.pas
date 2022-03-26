unit wol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ComCtrls, ExtCtrls, global;

type
  TWOLForm = class(TForm)
    ListView: TListView;
    Label1: TLabel;
    ImageList1: TImageList;
    Image1: TImage;
    ButtonTurnOn: TButton;
    ButtonClearCache: TButton;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ButtonTurnOnClick(Sender: TObject);
    procedure ButtonClearCacheClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    host : PHostConnection;
  public
    { Public declarations }
    constructor CreateForm(p:PHostConnection);
    destructor Destroy; override;
  end;

procedure ShowWOLFormModal(p:PHostConnection);

implementation

uses Registry, tools, lang;

{$R *.dfm}


procedure ShowWOLFormModal(p:PHostConnection);
var f:TWOLForm;
begin
 f:=TWOLForm.CreateForm(p);
 f.ShowModal;
 f.Free;
end;


constructor TWOLForm.CreateForm(p:PHostConnection);
var i:TIcon;
    reg:TRegistry;
    sl,names,values:TStringList;
    n:integer;
    s,s_loc,s_desc,s_name,s_ip,s_mac:string;
    item:TListItem;
begin
 inherited Create(nil);

 host:=p;

 FillImageList(ImageList1,16,240,1);

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(hinstance,pchar(241),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 names:=TStringList.Create;
 values:=TStringList.Create;

 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly(REGPATH+'\MACs') then
  begin
   try
    reg.GetValueNames(names);
   except
    names.Clear;
   end;
   for n:=0 to names.Count-1 do
    begin
     try
      s:=reg.ReadString(names[n]);
     except
      s:='';
     end;
     values.Add(s);
    end;
   reg.CloseKey;
  end;
 reg.Free;

 ListView.Items.BeginUpdate;
 for n:=0 to names.Count-1 do
  begin
   s:=names[n]+'\'+values[n];
   s:=StringReplace(s,'\',#13#10,[rfReplaceAll]);
   sl:=TStringList.Create;
   sl.Text:=s;
   if sl.Count=5 then
    begin
     s_loc:=sl[0];
     s_desc:=sl[1];
     s_name:=sl[2];
     s_ip:=sl[3];
     s_mac:=sl[4];
     if (s_ip<>'') and (s_mac<>'') then
      begin
       item:=ListView.Items.Add;
       item.ImageIndex:=0;
       item.Caption:='';
       item.SubItems.Add(s_loc);
       item.SubItems.Add(s_desc);
       item.SubItems.Add(s_name);
       item.SubItems.Add(s_ip);
       item.SubItems.Add(s_mac);
      end;
    end;
   sl.Free;
  end;
 ListView.AlphaSort;
 ListView.Items.EndUpdate;

 values.Free;
 names.Free;
end;

destructor TWOLForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TWOLForm.FormShow(Sender: TObject);
begin
 ButtonTurnOn.SetFocus;
end;

procedure TWOLForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
  ModalResult:=mrCancel;
end;

procedure TWOLForm.ListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var rc:integer;
begin
 rc:=AnsiCompareText(item1.SubItems[0],item2.SubItems[0]);
 if rc=0 then
  rc:=AnsiCompareText(item1.SubItems[1],item2.SubItems[1]);
 if rc=0 then
  rc:=AnsiCompareText(item1.SubItems[2],item2.SubItems[2]);
 Compare:=rc;
end;

procedure TWOLForm.ListViewEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TWOLForm.ButtonTurnOnClick(Sender: TObject);
var n:integer;
    s_ip,s_mac:string;
begin
 ButtonTurnOn.Enabled:=false;
 Update;
 WaitCursor(true,true);
 for n:=0 to ListView.Items.Count-1 do
  with ListView.Items[n] do
   if Selected then
    begin
     s_ip:=SubItems[3];
     s_mac:=SubItems[4];
     host.WakeupOnLAN(pchar(s_ip),pchar(s_mac));
    end;
 WaitCursor(false,false);
 ButtonTurnOn.Enabled:=true;
end;

procedure TWOLForm.ButtonClearCacheClick(Sender: TObject);
begin
 if ListView.Items.Count>0 then
  begin
   if MessageBox(Handle,S_CLEARWOLCACHE,S_QUESTION,MB_OKCANCEL or MB_ICONQUESTION)=IDOK then
    begin
     Windows.RegDeleteKey(HKEY_CURRENT_USER,REGPATH+'\MACs');
     ListView.Clear;
     ListView.Selected:=nil;
     ListView.ItemFocused:=nil;
    end;
  end;
end;

procedure TWOLForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=ord('A')) and (ssCtrl in Shift) then
  begin
   ListView.SelectAll;
  end;
end;

end.
