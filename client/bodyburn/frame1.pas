unit frame1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ImgList, Menus;

type
  TPage1 = class(TFrame)
    Panel3: TPanel;
    Label1: TLabel;
    LabelSize: TLabel;
    ButtonAdd: TBitBtn;
    ButtonRemove: TBitBtn;
    ListView: TListView;
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    MenuAdd: TMenuItem;
    MenuDel: TMenuItem;
    RadioButtonData: TRadioButton;
    RadioButtonImage: TRadioButton;
    RadioButtonAudio: TRadioButton;
    Bevel1: TBevel;
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonRemoveClick(Sender: TObject);
    procedure MenuAddClick(Sender: TObject);
    procedure MenuDelClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure RadioButtonImageClick(Sender: TObject);
  private
    { Private declarations }
    total_size : integer;
    function GetFileNameIcon(s:string):integer;
    procedure UpdateCDType();
    function CanBeImageCD:boolean;
  public
    { Public declarations }
    procedure OnShow(Sender:TObject);
    procedure OnCreate(Sender:TObject);
    procedure UpdateLabelSize;
    function CreateFList:pchar;
    procedure FreeFList(f:pchar);
    function GetTotalSize:integer;
    procedure AddFileToWrite(s:string);
    function GetCDType:integer;
  end;

implementation

uses commctrl, shellapi;

{$R *.dfm}
{$INCLUDE ..\rp_shared\rp_shared.inc}


function TPage1.CanBeImageCD:boolean;
var ext:string;
begin
 Result:=false;
 if ListView.Items.Count=1 then
  begin
   ext:=AnsiLowerCase(ExtractFileExt(ListView.Items[0].SubItems[0]));
   if (ext='.iso') or (ext='.nrg') or (ext='.cue') then
    Result:=true;
  end;
end;

procedure TPage1.UpdateCDType();
begin
 if RadioButtonImage.Checked and (not CanBeImageCD) then
  begin
   try
    Panel3.SetFocus;
   except end;
   RadioButtonData.Checked:=true;
  end
 else
 if (not RadioButtonImage.Checked) and CanBeImageCD then
  begin
   try
    Panel3.SetFocus;
   except end;
   RadioButtonImage.Checked:=true;
  end;
end;

function TPage1.GetCDType:integer;
begin
 if RadioButtonData.Checked then
  Result:=0
 else
 if RadioButtonImage.Checked then
  Result:=1
 else
 if RadioButtonAudio.Checked then
  Result:=2
 else
  Result:=0;
end;

procedure TPage1.OnCreate(Sender:TObject);
begin
 total_size:=0;
 UpdateLabelSize;

 ImageList.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 1, 1);

 ButtonRemove.Enabled:=false;
end;

procedure TPage1.OnShow(Sender:TObject);
begin
 try
  ListView.Selected:=nil;
 except end;
end;

function TPage1.GetTotalSize:integer;
begin
 Result:=total_size;
end;

procedure TPage1.ButtonAddClick(Sender: TObject);
begin
 MessageBox(Handle,'Для добавления файлов перенесите их из проводника на поле просмотра','Информация',MB_OK or MB_ICONINFORMATION);
end;

procedure TPage1.ButtonRemoveClick(Sender: TObject);
var n:integer;
    delsize:integer;
begin
 if ListView.SelCount<>0 then
  begin
   delsize:=0;
   for n:=0 to ListView.Items.Count-1 do
    if ListView.Items[n].Selected then
     Inc(delsize,integer(ListView.Items[n].Data));
   Dec(total_size,delsize);
   if total_size<0 then
    total_size:=0;
   ListView.DeleteSelected;
   UpdateLabelSize();
   UpdateCDType();
  end;
end;

procedure TPage1.UpdateLabelSize;
var mb : real;
    s:string;
begin
 mb:=total_size/1024;

 if total_size<1024 then
  s:=Format('%d',[total_size])+' KB'
 else
 if mb<100 then
  s:=Format('%0.1f',[mb])+' MB'
 else
 if mb<1000 then
  s:=Format('%d',[integer(trunc(mb))])+' MB'
 else
 if mb<10000 then
  s:=Format('%0.2f',[mb/1000])+' GB'
 else
  s:=Format('%0.1f',[mb/1000])+' GB';

 LabelSize.Caption:=s;
end;

procedure TPage1.MenuAddClick(Sender: TObject);
begin
 ButtonAddClick(Sender);
end;

procedure TPage1.MenuDelClick(Sender: TObject);
begin
 ButtonRemoveClick(Sender);
end;

procedure TPage1.PopupMenuPopup(Sender: TObject);
begin
 MenuDel.Enabled:=ListView.SelCount<>0;
end;

procedure TPage1.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
 ButtonRemove.Enabled:=ListView.SelCount<>0;
end;

function TPage1.CreateFList():pchar;
var n,len,count:integer;
    p,flist:pchar;
begin
 count:=ListView.Items.Count;

 if count=0 then
  begin
   Result:=nil;
   Exit;
  end;

 len:=1; //zero terminator
 for n:=0 to count-1 do
  Inc(len,length(ListView.Items[n].SubItems[0])+1);
 GetMem(flist,len);
 p:=flist;
 for n:=0 to count-1 do
  begin
   StrCopy(p,pchar(ListView.Items[n].SubItems[0]));
   p:=p+length(p)+1;
  end;
 p^:=#0;

 Result:=flist;
end;

procedure TPage1.FreeFList(f:pchar);
begin
 if f<>nil then
  FreeMem(f);
end;

function TPage1.GetFileNameIcon(s:string):integer;
var info:SHFILEINFO;
begin
 Result:=0;
 if SHGetFileInfo(pchar(s),0,info,sizeof(info),SHGFI_ICON or SHGFI_SMALLICON)<>0 then
  Result:=info.hIcon;
end;

procedure TPage1.AddFileToWrite(s:string);
var item:TListItem;
    local:string;
    hicon,kbsize:integer;
begin
 if length(s)<=3 then
  exit;

 if ((s[1]<>':') and (s[2]=':')) or ((s[1]='\') and (s[2]='\')) then
  begin
   if s[length(s)]='\' then
    setlength(s,length(s)-1);
   local:=ExtractFileName(s);
   if local<>'' then
    begin
     if (ListView.Items.Count=0) or (ListView.FindCaption(0,local,false,true,false)=nil) then
      begin
       Screen.Cursor:=crHourGlass;
       Application.ProcessMessages;
       if not ScanForLawProtected(pchar(s)) then
        begin
         kbsize:=GetDirectorySize(pchar(s));
         hicon:=GetFileNameIcon(s);
         item:=ListView.Items.Add;
         item.Caption:=local;
         item.ImageIndex:=ImageList_AddIcon(ImageList.Handle,hicon);
         item.SubItems.Add(s);
         item.Data:=pointer(kbsize);
         inc(total_size,kbsize);
         try
          ListView.Scroll(0,32);
         except end;
         UpdateLabelSize();
         UpdateCDType();
        end
       else
        begin
         MessageBox(Handle,'Запись одного или нескольких выбранных Вами файлов запрещена законом об авторских правах','Запрет',MB_OK or MB_ICONWARNING);
        end;
       Screen.Cursor:=crDefault;
      end;
    end;
  end;
end;

procedure TPage1.RadioButtonImageClick(Sender: TObject);
begin
 if Visible and RadioButtonImage.Checked then
  begin
   if not CanBeImageCD then
    begin
     MessageBox(Handle,'Для записи образа диска необходимо добавить только один файл формата ISO, NRG или CUE','Информация',MB_OK or MB_ICONINFORMATION);
     RadioButtonData.Checked:=true;
     try
      RadioButtonData.SetFocus;
     except end;
    end;
  end;
end;

end.
