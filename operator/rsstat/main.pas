unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls, CommCtrl, ImgList, XPMan, Menus,
  ActnList, WinSock, ShellApi;

type
  TFormStat = class(TForm)
    ToolBar: TToolBar;
    PanelLeft: TPanel;
    TreeView: TTreeView;
    ImageListTb: TImageList;
    XPManifest: TXPManifest;
    btnAlphabetical: TToolButton;
    ImageListState: TImageList;
    SplitterH: TSplitter;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miFileOpen: TMenuItem;
    miFileClose: TMenuItem;
    N1: TMenuItem;
    miFileExit: TMenuItem;
    N2: TMenuItem;
    MenuItemHelpAbout: TMenuItem;
    MenuItemHelpIndex: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    miFilePrint: TMenuItem;
    miFileExport: TMenuItem;
    miFileExportHTML: TMenuItem;
    MenuItemFileExportExcel: TMenuItem;
    miFileExportXML: TMenuItem;
    OpenDialog: TOpenDialog;
    MeniItemView: TMenuItem;
    miViewOptions: TMenuItem;
    btnRating: TToolButton;
    btnTree: TToolButton;
    ToolButton4: TToolButton;
    btnAll: TToolButton;
    btnSheet: TToolButton;
    SplitterV: TSplitter;
    ListView: TListView;
    N5: TMenuItem;
    miAlphabetical: TMenuItem;
    miRating: TMenuItem;
    ActionList: TActionList;
    actAlphabetical: TAction;
    actRating: TAction;
    miSort: TMenuItem;
    N6: TMenuItem;
    actTree: TAction;
    actAll: TAction;
    actSheet: TAction;
    miTree: TMenuItem;
    miAll: TMenuItem;
    miSheet: TMenuItem;
    PanelRight: TPanel;
    ScrollBox: TScrollBox;
    Image1: TImage;
    Image2: TImage;
    PanelTitle: TPanel;
    TitleImage1: TImage;
    TitleImage2: TImage;
    miFileSave: TMenuItem;
    SaveDialog: TSaveDialog;
    ImageListTV: TImageList;
    StatusBar: TStatusBar;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeViewKeyPress(Sender: TObject; var Key: Char);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure ScrollBoxResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miFileExitClick(Sender: TObject);
    procedure miFileCloseClick(Sender: TObject);
    procedure miFileOpenClick(Sender: TObject);
    procedure miViewOptionsClick(Sender: TObject);
    procedure MenuItemHelpAboutClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure actViewExecute(Sender: TObject);
    procedure miFileSaveClick(Sender: TObject);
    procedure MenuItemHelpIndexClick(Sender: TObject);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure miFileExportHTMLClick(Sender: TObject);
    procedure miFileExportXMLClick(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure SplitterHMoved(Sender: TObject);
  private
    TVNodeSelectedSheet: TTreeNode;
    TVCheckedCount: integer;
    Image: ^TImage;
    TitleImage: ^TImage;

    VisibleImage: ^TImage; // This is used to resize image and scroll area.


    IsLoading: boolean;

    // Utility functions for DrawImage_Histograms
    procedure DrawImage_Histograms_VerticalLines(CaptionWidth, y1,y2: integer; max: real);
    procedure DrawImage_Histograms_VerticalLinesValues(CaptionWidth, y1,y2: integer; max: real);
    procedure DrawImage_Histograms_Bar(CaptionWidth, y,r_width: integer; c: TColor);


    function DrawImage_TimeDependence: boolean;
    function DrawImage_Histograms: boolean;

    procedure SwapImage; // this will display buffer and set new buffer for drawing
    function DrawImage: boolean; // this will draw to buffer
    procedure ResizeImage;
    procedure WhiteImage;    

    procedure LoadData(FilePath: string);

    procedure OnTVItemStateChanging(node : TTreeNode);
    procedure UpdateActiveTreeItems;

    procedure ShowProgress(Position, Maximum: integer);
    procedure HideProgress();
  public
    procedure DefaultHandler(var Message); override;
  end;

var
  FormStat: TFormStat;
  user_message: THandle;

implementation

uses Options, Types;
{$INCLUDE dll\stat.inc}

const SHEET_LEVEL = 0;
const SHORTCUT_LEVEL = 1;

const STATEINDEX_OFF = 1;
const STATEINDEX_ON = 2;
{$R *.dfm}

procedure TFormStat.DefaultHandler(var Message);
var
  s: string;
  res: integer;
  buf: array[0..256] of char;
begin
  with TMessage(Message) do
    if msg=user_message then
      begin
        res := GlobalGetAtomName(wParam, buf, 255);
        
        if (res = 0) then
        begin
          MessageBox(0, PChar('Ошибка при получении пути'#10#13'Обратитесь к разработчику'), 'Ошибка', MB_OK);
          Exit;
        end;

        s := buf;
        LoadData(s);
        if DrawImage then
          SwapImage;
      end
    else
      inherited;
end;

procedure TFormStat.SwapImage;
begin
  if Image = @Image2 then
    begin
      Image := @Image1;
      Image2.Visible := true;
      Image1.Visible := false;
      TitleImage := @TitleImage1;
      TitleImage2.Visible := true;
      TitleImage1.Visible := false;
      VisibleImage := @Image2;
    end
  else
    begin
      Image := @Image2;
      Image1.Visible := true;
      Image2.Visible := false;
      TitleImage := @TitleImage2;
      TitleImage1.Visible := true;
      TitleImage2.Visible := false;
      VisibleImage := @Image1;
    end
end;

procedure TFormStat.ResizeImage;
begin
  Image^.Picture.Bitmap.Width := Image^.Width;
  Image^.Picture.Bitmap.Height := Image^.Height;
  Image^.Width := Image^.Width;
  Image^.Height := Image^.Height;
  Image^.Picture.Bitmap.HandleType := bmDIB;
  Image^.Picture.Bitmap.PixelFormat := pf32bit;

  TitleImage^.Picture.Bitmap.Width := TitleImage^.Width;
  TitleImage^.Picture.Bitmap.Height := TitleImage^.Height;
  TitleImage^.Width := TitleImage^.Width;
  TitleImage^.Height := TitleImage^.Height;
  TitleImage^.Picture.Bitmap.HandleType := bmDIB;
  TitleImage^.Picture.Bitmap.PixelFormat := pf32bit;
end;


function LighterColor(color: TColor): TColor;
var
  r,g,b : integer;
begin
  r := (color and $FF);
  g := ((color shr 8) and $FF);
  b := ((color shr 16) and $FF);

  r := round(r*1.1);
  g := round(g*1.1);
  b := round(b*1.1);
  if (r>$FF) then
    r := $FF;
  if (g>$FF) then
    g := $FF;
  if (b>$FF) then
    b := $FF;

  Result := (r) or (g shl 8) or (b shl 16);
end;


function DarkerColor(color: TColor): TColor;
var
  r,g,b : integer;
begin
  r := (color and $FF);
  g := ((color shr 8) and $FF);
  b := ((color shr 16) and $FF);

  if (r+g+b < $F) then
    begin
      r := $80;
      g := $80;
      b := $80;
    end
  else
    begin
      r := round(r*0.7);
      g := round(g*0.7);
      b := round(b*0.7);
    end;

  Result := (r) or (g shl 8) or (b shl 16);
end;


function DarkerDarkerColor(color: TColor): TColor;
var
  r,g,b : integer;
begin
  r := (color and $FF);
  g := ((color shr 8) and $FF);
  b := ((color shr 16) and $FF);

  if (r+g+b < $2F) then
    begin
      r := $A0;
      g := $A0;
      b := $A0;
    end
  else
    begin
      r := round(r*0.5);
      g := round(g*0.5);
      b := round(b*0.5);
    end;

  Result := (r) or (g shl 8) or (b shl 16);
end;


function OppositeColor(color: TColor): TColor;
var
  r,g,b : integer;
begin
  r := (color and $FF);
  g := ((color shr 8) and $FF);
  b := ((color shr 16) and $FF);

  if (abs($7F-r)<$F) and (abs($7F-g)<$F) and (abs($7F-b)<$F) then
    begin
      r := $B0;
      g := $B0;
      b := $B0;
    end
  else
    begin
      r := round($FF-r);
      g := round($FF-g);
      b := round($FF-b);
    end;  

  Result := (r) or (g shl 8) or (b shl 16);
end;


function MiddleColor(color1, color2: TColor; level: real): TColor;
var
  r1,g1,b1 : integer;
  r2,g2,b2 : integer;
  r,g,b : integer;
begin
  r1 := (color1 and $FF);
  g1 := ((color1 shr 8) and $FF);
  b1 := ((color1 shr 16) and $FF);
  r2 := (color2 and $FF);
  g2 := ((color2 shr 8) and $FF);
  b2 := ((color2 shr 16) and $FF);

  r := round(r1*level + r2*(1-level));
  g := round(g1*level + g2*(1-level));
  b := round(b1*level + b2*(1-level));

  Result := (r) or (g shl 8) or (b shl 16);
end;


procedure TFormStat.DrawImage_Histograms_VerticalLines(CaptionWidth, y1,y2: integer; max: real);
var
  f: real;
  x: integer;
begin
  with Image^.Picture.Bitmap.Canvas do
    begin
      f := 0;
      while f < max do
        begin
          x := CaptionWidth + round(f*(Image.Width - CaptionWidth)/(max));
          MoveTo(x, y1);
          LineTo(x, y2);
          if max>780 then
              f := f + 120
          else
            if max>120 then
                f := f + 60
            else
              if max>30 then
                  f := f + 15
              else
                  f := f + 1;
        end;
    end;
end;

procedure TFormStat.DrawImage_Histograms_VerticalLinesValues(CaptionWidth, y1,y2: integer; max: real);
var
  f: real;
  x: integer;
begin
  with TitleImage^.Picture.Bitmap.Canvas do
    begin
      f := 0;
      while f < max do
        begin
          x := CaptionWidth + round(f*(Image.Width - CaptionWidth)/(max));
          if max>780 then
            begin
              TextOut(x, 2, IntToStr(trunc(f/60))+'ч.');
              f := f + 120;
            end
          else
            if max>120 then
              begin
                TextOut(x, 2, IntToStr(trunc(f/60))+'ч.');
                f := f + 60;
              end
            else
              if max>30 then
                begin
                  TextOut(x, 2, IntToStr(trunc(f))+'мин.');
                  f := f + 15;
                end
              else
                begin
                  TextOut(x, 2, IntToStr(trunc(f))+'мин.');
                  f := f + 1;
                end
        end;
    end;
end;


procedure TFormStat.DrawImage_Histograms_Bar(CaptionWidth, y,r_width: integer; c: TColor);
var
  i: integer;
  c1, c2: TColor;
begin
  with Image^.Picture.Bitmap.Canvas do
    begin
      c1 := OppositeColor(c);
      c2 := c;
      for i:=0 to 8 do
        begin
          Pen.Color := MiddleColor(c2, c1, i/8);
          MoveTo(CaptionWidth, y+i);
          LineTo(CaptionWidth + r_width, y+i);
          MoveTo(CaptionWidth, y+16-i);
          LineTo(CaptionWidth + r_width, y+16-i);
        end
    end;
end;


function TFormStat.DrawImage_Histograms: boolean;
var
  y: integer;
  f, max: real;
  r: TRect;
  CaptionWidth: integer;
  r_width: integer;
  Color: TColor;
  it: pointer;
  enumsize, enumpos: integer;
  ScrollBoxClientHeight: Integer;
  ScrollBoxClientWidth: Integer;

begin
  Result := false;

  with Image^.Picture.Bitmap.Canvas do
    begin
      if actTree.Checked then
        st_SetEnumMode(ST_EMODE_TREE);
      if actAll.Checked then
        st_SetEnumMode(ST_EMODE_SHORTCUTS);
      if actSheet.Checked then
        st_SetEnumMode(ST_EMODE_SHEETS);

      if actAlphabetical.Checked then
        st_SetEnumSort(ST_ESORT_ALPHA);
      if actRating.Checked then
        st_SetEnumSort(ST_ESORT_RATING);

      CaptionWidth := 0;
      max := 0;

      // Determine the total height and maximum width of caption
      y := 0;
      it := st_EnumStart(nil);

      enumsize := st_GetEnumSize();
      enumpos := 0;

      while it<>nil do
        begin
          if st_GetItActive(it)<>0 then
            begin
              if st_GetItType(it) = ST_TYPE_SHEET then
                begin
                  DrawText(Handle, st_GetItName(it), Length(st_GetItName(it)), r, DT_CALCRECT);
                  if CaptionWidth < r.Right - r.Left + 10 then
                    CaptionWidth := r.Right - r.Left + 10;
                  f := st_GetItMidlevel(it);
                  if f > max then
                    max := f;
                  y := y+25;
                end;

              if st_GetItType(it) = ST_TYPE_SHORTCUT then
                begin
                  DrawText(Handle, st_GetItName(it), Length(st_GetItName(it)), r, DT_CALCRECT);
                  if CaptionWidth < r.Right - r.Left then
                    CaptionWidth := r.Right - r.Left;
                  f := st_GetItMidlevel(it);
                  if f > max then
                    max := f;
                  y := y+20;
                end;
            end;
          it := st_EnumNext();
          end;

      // Select scale horisontal
      if not FormOptions.ScaleRatingAuto(false) then
        max := FormOptions.ScaleRating(false)*60;
      CaptionWidth := CaptionWidth + 4;

      // Set image height. If too small - fill with white
      if (ScrollBox.ClientHeight < y+2) then
        Image.Height := y+2
      else
        Image.Height := ScrollBox.ClientHeight;

      Image.Width := ScrollBox.ClientWidth;
      TitleImage.Width := ScrollBox.Width;

      // Avoid double-drawing due to changing of area.
      ScrollBoxClientHeight := ScrollBox.ClientHeight;
      ScrollBoxClientWidth := ScrollBox.ClientWidth;
      VisibleImage.Height := Image.Height;
      VisibleImage.Width := Image.Width;
      Application.ProcessMessages;
      if (ScrollBoxClientHeight <> ScrollBox.ClientHeight) or
         (ScrollBoxClientWidth <> ScrollBox.ClientWidth) then
        exit; // Draw procedure was processed in OnResize event handler.

      ResizeImage;
      WhiteImage;

      // Draw items
      y := 0;
      it := st_EnumStart(nil);

      if max > 0 then
        while it<>nil do
          begin
            if st_GetItActive(it)<>0 then
              begin
                Color := st_GetItColor(it);

                if st_GetItType(it) = ST_TYPE_SHEET then
                  begin
                    // Fill background
                    Brush.Color := Color;
                    FillRect(Rect(0, y, CaptionWidth, y+25));
                    Brush.Color := LighterColor(Color);
                    FillRect(Rect(CaptionWidth, y, Image.Width, y+25));

                    // Draw vertical lines
                    Pen.Color := DarkerColor(Color);
                    DrawImage_Histograms_VerticalLines(CaptionWidth, y, y+25, max);

                    // Draw caption
                    Font.Color := OppositeColor(Color);
                    Brush.Color := Color;
                    TextOut(10, y+2, st_GetItName(it));
                    
                    // Draw rating bar
                    if actSheet.Checked then
                      begin
                        r_width := round( st_GetItMidlevel(it)*(Image^.Width-CaptionWidth) / max );
                        DrawImage_Histograms_Bar(CaptionWidth, y+2, r_width, Color);
                      end;

                    // Draw horisontal line
                    Pen.Color := DarkerColor(Color);
                    MoveTo(1, y+20);
                    LineTo(Image.Width-1, y+20);
                    
                    y := y+25;
                  end;

                if st_GetItType(it) = ST_TYPE_SHORTCUT then
                  begin
                    // Fill background
                    Brush.Color := Color;
                    FillRect(Rect(0, y, CaptionWidth, y+20));
                    Brush.Color := LighterColor(Color);
                    FillRect(Rect(CaptionWidth, y, Image.Width, y+20));

                    // Draw vertical lines
                    Pen.Color := DarkerColor(Color);
                    DrawImage_Histograms_VerticalLines(CaptionWidth, y, y+20, max);

                    // Draw caption
                    Font.Color := DarkerDarkerColor(Color);
                    Brush.Color := Color;
                    TextOut(1, y+2, st_GetItName(it));

                    // Draw rating bar
                    r_width := round( st_GetItMidlevel(it)*(Image^.Width-CaptionWidth) / max );
                    DrawImage_Histograms_Bar(CaptionWidth, y+2, r_width, Color);
                    y := y+20;
                  end;
              end;
          
          ShowProgress(enumpos, enumsize);
          inc(enumpos);

          it := st_EnumNext();
          end;
    end;

  with TitleImage^.Picture.Bitmap.Canvas do
    begin
      Brush.Color := clWhite;
      FillRect(Rect(0, 0, TitleImage.Width, TitleImage.Height));

      // Write horisontal top line values
      Font.Color := clBlack;
      DrawImage_Histograms_VerticalLinesValues(CaptionWidth, 0,0, max);
    end;

  HideProgress();

  Result := true;
end;


function TFormStat.DrawImage_TimeDependence: boolean;
var
  i, x, y: integer;
  i_begin, i_end: integer;
  ri_begin, ri_end: integer; // real values
  max, f: real;
  CaptionWidth, CaptionHeight, GraphHeight: integer;
  begin_date: TDateTime;
  Color: TColor;
  s: string;
  ScrollBoxClientHeight: Integer;
  ScrollBoxClientWidth: Integer;
begin
  Result := false;

  with Image^.Picture.Bitmap.Canvas do
    begin
      if (FormOptions.ScaleDateManual(false) = 0) then
        begin
          i_begin := 0;
          i_end := st_GetItRawLen(TreeView.Selected.Data)-1;
          ri_begin := i_begin;
          ri_end := i_end;
          begin_date := st_GetItDate(TreeView.Selected.Data);
        end
      else
        begin
          i_begin := trunc(FormOptions.ScaleDateManualFrom()) - st_GetItDate(TreeView.Selected.Data);
          i_end := i_begin + trunc(FormOptions.ScaleDateManualTill()) - trunc(FormOptions.ScaleDateManualFrom());
          ri_begin := i_begin;
          ri_end := i_end;
          if i_begin < 0 then
            i_begin := 0;
          if i_end > st_GetItRawLen(TreeView.Selected.Data)-1 then
            i_end := st_GetItRawLen(TreeView.Selected.Data)-1;
          begin_date := st_GetItDate(TreeView.Selected.Data) + ri_begin;
        end;

      // Determine the maximum value (vertical scale)
      max := 0;
      if not FormOptions.ScaleRatingAuto(false) then
        max := FormOptions.ScaleRating(false)*60
      else
        for i := i_begin to i_end do
          begin
            f := st_GetItRawItem(TreeView.Selected.Data, i);
            if f>max then
              max := f;
          end;
      max := max + max/10;

      Image.Height := ScrollBox.ClientHeight;

      // Avoid double-drawing due to changing of area.
      ScrollBoxClientHeight := ScrollBox.ClientHeight;
      ScrollBoxClientWidth := ScrollBox.ClientWidth;
      VisibleImage.Height := Image.Height;
      VisibleImage.Width := Image.Width;
      Application.ProcessMessages;
      if (ScrollBoxClientHeight <> ScrollBox.ClientHeight) or
         (ScrollBoxClientWidth <> ScrollBox.ClientWidth) then
        exit; // Draw procedure was processed in OnResize event handler.

      ResizeImage;
      WhiteImage;

      if max>120 then
        CaptionWidth := 30
      else
        CaptionWidth := 40;
      CaptionHeight := 20;
      GraphHeight := Image.Height-CaptionHeight;

      // Fill background
      Color := st_GetItColor(TreeView.Selected.Data);
      Brush.Color := Color;
      FillRect(Rect(CaptionWidth, 0, Image.Width, Image.Height-CaptionHeight));

      if max > 0 then
        begin

          // Draw axises
          Pen.Color := DarkerColor(Color);
          MoveTo(CaptionWidth, 0);
          LineTo(CaptionWidth, Image.Height-1);
          MoveTo(0, Image.Height-CaptionHeight);
          LineTo(Image.Width, Image.Height-CaptionHeight);

          // Draw horisontal lines & write vertical axis values
          Pen.Color := DarkerColor(Color);
          Brush.Color := clWhite;
          Font.Color := clBlack;
          f := 0;
          while f <= max do
            begin
              y := GraphHeight - trunc(f * GraphHeight / max);
              MoveTo(CaptionWidth, y);
              LineTo(Image.Width, y);

              if max>780 then
                begin
                  TextOut(2, y+1, IntToStr(trunc(f/60))+'ч.');
                  f := f + 120;
                end
              else
                if max>120 then
                  begin
                    TextOut(2, y+1, IntToStr(trunc(f/60))+'ч.');
                    f := f + 60;
                  end
                else
                  if max>30 then
                    begin
                      TextOut(2, y+1, IntToStr(trunc(f))+'мин.');
                      f := f + 15;
                    end
                  else
                    begin
                      TextOut(2, y+1, IntToStr(trunc(f))+'мин.');
                      f := f + 1;
                    end
            end;

          // Write horisontal axis values
          TextOut(CaptionWidth + 2, GraphHeight + 2, DateToStr(begin_date));
          s := DateToStr(begin_date + ri_end - ri_begin);
          TextOut(Image.Width - TextWidth(s) - 2, GraphHeight + 2, s);

          Pen.Color := OppositeColor(Color);

          // Draw the graphic
          Pen.Width := 3;
          i := ri_begin;
          if ri_begin>=i_begin then
            y := round((Image.Height-CaptionHeight) * (1 - st_GetItRawItem(TreeView.Selected.Data, i) / max))
          else
            y := round(Image.Height-CaptionHeight);
          x := CaptionWidth;
          MoveTo(x, y);
          if ri_begin = ri_end then
            LineTo(Image.Width, y)
          else
            begin
              if i_begin>ri_begin then 
                begin
                  x := CaptionWidth + (i_begin - ri_begin) * (Image.Width-CaptionWidth) div (ri_end - ri_begin);
                  LineTo(x, y);
                end;
              for i := i_begin to i_end do
                begin
                  x := CaptionWidth + (i - ri_begin) * (Image.Width-CaptionWidth) div (ri_end - ri_begin);
                  y := round((Image.Height-CaptionHeight) * (1 - st_GetItRawItem(TreeView.Selected.Data, i) / max));
                  LineTo(x, y);
                  ShowProgress(x, Image.Width);
                end;
              if i_end<ri_end then 
                begin
                  y := round(Image.Height-CaptionHeight);
                  LineTo(x, y);
                  x := CaptionWidth + (ri_end - ri_begin) * (Image.Width-CaptionWidth) div (ri_end - ri_begin);
                  LineTo(x, y);
                end
            end;
          Pen.Width := 1;
        end;
    end;

  with TitleImage^.Picture.Bitmap.Canvas do
    begin
      Brush.Color := clWhite;
      FillRect(Rect(0, 0, TitleImage.Width, TitleImage.Height));

      // Fill background
      Brush.Color := LighterColor(Color);//clWhite;
      FillRect(Rect(CaptionWidth, 0, TitleImage.Width, TitleImage.Height));
      // Write caption
      Font.Color := DarkerColor(Color);//clBlack;
      TextOut(CaptionWidth+2, 2, st_GetItName(TreeView.Selected.Data));
    end;

  HideProgress;
  Result := true;
end;


procedure TFormStat.WhiteImage;
var
  r: TRect;
begin
  with Image^.Picture.Bitmap.Canvas do
    begin
      r := Rect(0,0, Image^.Width, Image^.Height);
      Brush.Color := clWhite;
      FillRect(r);
    end;
  with TitleImage^.Picture.Bitmap.Canvas do
    begin
      r := Rect(0,0, TitleImage^.Width, TitleImage^.Height);
      Brush.Color := clWhite;
      FillRect(r);
    end;
end;


function TFormStat.DrawImage: boolean;
var
  i: integer;
begin
  Result := false;
  if IsLoading then
    exit;

  UpdateActiveTreeItems();

  TVCheckedCount := 0;
  for i:=0 to TreeView.Items.Count-1 do
    if ((TreeView.Items[i].Level = SHORTCUT_LEVEL) and not actSheet.Checked)
      or ((TreeView.Items[i].Level = SHEET_LEVEL) and actSheet.Checked)
      then
      if TreeView.Items[i].StateIndex = STATEINDEX_ON then
        inc(TVCheckedCount);

  if TreeView.Selected <> nil then
    if (((TreeView.Selected.Level = SHORTCUT_LEVEL) or actSheet.Checked)
      and (((TreeView.Selected.StateIndex = STATEINDEX_ON) and (TVCheckedCount = 1))
      or (TVCheckedCount = 0)))
    then
      Result := DrawImage_TimeDependence
    else
      Result := DrawImage_Histograms;
end;


function getListItemMachine(MachineName: string): TListItem;
var
  MachineItem: TListItem;
  i: integer;
begin
  MachineItem := nil;
  with FormStat.ListView.Items do
    begin
      for i:=0 to Count-1 do
        if Item[i].Caption = MachineName then
          begin
            MachineItem := Item[i];
            break;
          end;

      if MachineItem = nil then
        begin
          MachineItem := Add;
          MachineItem.Caption := MachineName;
          //SheetNode.StateIndex := 1;
        end;
    end;

  Result := MachineItem;
end;

function getTreeNodeShortcut(SheetName, ShortcutName: string): TTreeNode;
var
  SheetNode: TTreeNode;
  ShortcutNode: TTreeNode;
begin
  with FormStat.TreeView.Items do
    begin
      SheetNode := GetFirstNode;
      while SheetNode <> nil do
        if SheetNode.Text <> SheetName then
          SheetNode := SheetNode.getNextSibling
        else
          break;
      if SheetNode = nil then
        begin
          SheetNode := Add(nil, SheetName);
          SheetNode.StateIndex := 1;
        end;

      ShortcutNode := SheetNode.getFirstChild;
      while ShortcutNode <> nil do
        if ShortcutNode.Text <> ShortcutName then
          ShortcutNode := ShortcutNode.GetNextSibling
        else
          break;
      if ShortcutNode = nil then
        begin
          ShortcutNode := AddChild(SheetNode, ShortcutName);
          ShortcutNode.StateIndex := 1;
        end;

      Result := ShortcutNode;
    end;
end;

procedure TFormStat.UpdateActiveTreeItems;
var
  i: integer;
  active: integer;
begin
  for i:=0 to TreeView.Items.Count-1 do
    if TreeView.Items[i].Data<>nil then
      begin
        if (TreeView.Items[i].StateIndex <> STATEINDEX_OFF) or (TreeView.Items[i].Selected) or (TreeView.Items[i] = TVNodeSelectedSheet) or (TreeView.Items[i].Parent = TreeView.Selected) then
          active := 1
        else
          active := 0;

        st_SetItActive(TreeView.Items[i].Data, active);
        if TreeView.Items[i].Level = SHEET_LEVEL then
          st_SetItChildrenActive(TreeView.Items[i].Data, active);
      end;
end;

procedure TFormStat.LoadData(FilePath: string);
var
  hsheet, hmachine: pointer;
  SheetName: string;
  MachineName: string;
  ShortcutNode: TTreeNode;
  SheetNode: TTreeNode;
  MachineItem: TListItem;
  ip: integer;
  h_icon: HICON;
  d_icon: TIcon;
  i: integer;
  OpenCode: integer;
  enumsize, enumpos : integer;
begin
  IsLoading := true;

  OpenCode := st_LoadFile(PChar(FilePath));

  if OpenCode <> 0 then
    begin
      if OpenCode = -1 then
        MessageBox(Handle, PChar('Ошибка при открытии файла'#10#13+FilePath), 'Ошибка', MB_OK);
      if OpenCode = -2 then
        MessageBox(Handle, PChar('Данные получены от незвестной машины'#10#13+FilePath), 'Ошибка', MB_OK);
      miFileClose.Click;
    end;

  with FormStat.TreeView.Items do
    begin
      BeginUpdate();
      Clear();

      st_SetEnumMode(ST_EMODE_SHEETS);
      hsheet := st_EnumStart(nil);
      enumsize := st_GetEnumSize();
      enumpos := 0;
      while hsheet<>nil do
        begin
          i := 0;
          h_icon := st_GetItIcon(hsheet);
          if (h_icon<>0) then
            begin
              d_Icon := TIcon.Create;
              d_Icon.Handle := DuplicateIcon(0, h_icon);
              i := ImageListTV.AddIcon(d_Icon);
              d_Icon.Destroy;
            end;

          SheetName := st_GetItName(hsheet);
          SheetNode := Add(nil, SheetName);
          SheetNode.Data := hsheet;
          SheetNode.ImageIndex := i;
          SheetNode.SelectedIndex := i;
          SheetNode.StateIndex := STATEINDEX_OFF;

          ShortcutNode := AddChild(SheetNode, '');
          ShortcutNode.Data := nil;

//          if (st_GetItActive(hsheet)<>0) then
//            SheetNode.StateIndex := STATEINDEX_ON
//          else
//           SheetNode.StateIndex := STATEINDEX_OFF;
//          OnTVItemStateChanging(SheetNode);

          ShowProgress(enumpos, enumsize);
          inc(enumpos);

          hsheet := st_EnumNext();
        end;
      HideProgress();
      EndUpdate();
    end;  

  hmachine := st_EnumMachinesStart();
  while hmachine<>nil do
    begin
      ip := st_GetItIp(hmachine);
      MachineName := st_GetItName(hmachine);
      MachineItem := getListItemMachine(MachineName);
      MachineItem.Data := hmachine;
      MachineItem.Checked := st_GetItActive(hmachine)<>0;
      MachineItem.SubItems.Clear;
      MachineItem.SubItems.Add(inet_ntoa(in_addr(ip)));

      hmachine := st_EnumMachinesNext();
    end;

  if TreeView.Selected = nil then
    if TreeView.Items.Count > 0 then
      TreeView.Selected := TreeView.Items[0];

  IsLoading := false;
end;

procedure TFormStat.FormCreate(Sender: TObject);
var
  style : Integer;
  hImages: THandle;
begin
  TreeView.HandleNeeded;

  hImages := ImageListTV.Handle;
  ImageListTV.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 5, 1);
  ImageListTV.AddIcon(Application.Icon);
  if hImages<>0 then
    ImageList_Destroy(hImages);
  TreeView.Images := ImageListTV;

  style := GetWindowLong(TreeView.Handle, GWL_STYLE);
  style := style or TVS_CHECKBOXES;
  SetWindowLong(TreeView.Handle, GWL_STYLE, style);
  hImages := SendMessage(TreeView.Handle, TVM_GETIMAGELIST, TVSIL_STATE, 0);
  if hImages<>0 then
    ImageList_Destroy(hImages);
  TreeView.StateImages := ImageListState;

  SwapImage;
end;

procedure TFormStat.OnTVItemStateChanging(node : TTreeNode);
var
  i, selCount : integer;
  tvIt : TTVITEM;
  state: integer;
  parentNode : TTreeNode;
begin
  if node <> nil then
    begin
      Repaint;

      tvIt.mask := TVIF_HANDLE or TVIF_STATE;
      tvIt.hItem := node.ItemId;
      tvIt.stateMask := TVIS_STATEIMAGEMASK;

      TreeView_GetItem(TreeView.Handle, tvIt);
      state := tvIt.state shr 12;

      if state = 3 then
        begin
          state := 1;
          tvIt.state := INDEXTOSTATEIMAGEMASK(state);
          TreeView_SetItem(TreeView.Handle, tvIt);
        end;
      node.StateIndex := state;

      // set subnodes if present
      for i:=0 to node.Count-1 do
        node.Item[i].StateIndex := state;

      // update parent node
      parentNode := node.Parent;
      if parentNode <> nil then
        begin
          selCount := 0;
          for i:=0 to parentNode.Count-1 do
            if parentNode.Item[i].StateIndex = 1 then
              inc(selCount);

          if selCount = parentNode.Count then
            parentNode.StateIndex := 1
          else if selCount = 0 then
            parentNode.StateIndex := 2
          else
            parentNode.StateIndex := 3;
        end;

      if not IsLoading then
        begin
          if DrawImage then
            SwapImage;
        end
    end;
end;

procedure TFormStat.TreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  node : TTreeNode;
  tvIt : TTVITEM;
  state: integer;
begin
  node := TreeView.GetNodeAt(X,Y);

  if node<>nil then
    begin
      tvIt.mask := TVIF_HANDLE or TVIF_STATE;
      tvIt.hItem := node.ItemId;
      tvIt.stateMask := TVIS_STATEIMAGEMASK;

      TreeView_GetItem(TreeView.Handle, tvIt);
      state := tvIt.state shr 12;

      if node.StateIndex <> state then
        OnTVItemStateChanging(node);
    end;
end;

procedure TFormStat.TreeViewKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ' ' then
    OnTVItemStateChanging(TreeView.Selected);
end;

procedure TFormStat.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  TVNodeSelectedSheet := Node.Parent;
  Repaint;
  if DrawImage then
    SwapImage;
end;

procedure TFormStat.ScrollBoxResize(Sender: TObject);
begin
  if (TitleImage1.Width <> ScrollBox.Width) or (TitleImage2.Width <> ScrollBox.Width) or
     (Image1.Width <> ScrollBox.ClientWidth) or (Image2.Width <> ScrollBox.ClientWidth) or
     (Image1.Height < ScrollBox.ClientHeight) or (Image2.Height < ScrollBox.ClientHeight) then
    begin
      Image1.Width := ScrollBox.ClientWidth;
      Image2.Width := ScrollBox.ClientWidth;
      TitleImage1.Width := ScrollBox.Width;
      TitleImage2.Width := ScrollBox.Width;
      if DrawImage then
        SwapImage;
    end;
end;

procedure TFormStat.FormShow(Sender: TObject);
var
  i : integer;
begin
  ProgressBar.Parent := StatusBar;

  for i:=1 to ParamCount do
    LoadData(ParamStr(i));
  if DrawImage then
    SwapImage;
end;

procedure TFormStat.miFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormStat.miFileCloseClick(Sender: TObject);
begin
  IsLoading := true;
  TreeView.Items.Clear;
  ListView.Items.Clear;
  st_Clean();
  if DrawImage then
    SwapImage;
  IsLoading := false;
end;

procedure TFormStat.miFileOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    begin
      Repaint;
      LoadData(OpenDialog.FileName);
      if DrawImage then
        SwapImage;
    end;
end;

procedure TFormStat.miViewOptionsClick(Sender: TObject);
begin
  FormOptions.HandleNeeded;
  FormOptions.TreeView.HandleNeeded;
  if FormOptions.TreeView.Selected=nil then
    FormOptions.TreeView.Select(FormOptions.TreeView.Items[1]);
  if FormOptions.TreeView.Selected.Index<1 then
    FormOptions.TreeView.Select(FormOptions.TreeView.Items[1]);

  if FormOptions.ShowModal = mrOk then
    begin
      if (FormOptions.ScaleDateManual(false) = 0) then
        begin
          st_SetBeginDate(0);
          st_SetEndDate(0);
        end
      else
        begin
          st_SetBeginDate(trunc(FormOptions.ScaleDateManualFrom()));
          st_SetEndDate(trunc(FormOptions.ScaleDateManualTill()));
        end;

      st_Update;
  
      Repaint;
      if DrawImage then
        SwapImage;
    end;
end;

procedure TFormStat.MenuItemHelpAboutClick(Sender: TObject);
begin
  FormOptions.HandleNeeded;
  FormOptions.TreeView.Select(FormOptions.TreeView.Items[0]);
  FormOptions.ShowModal;
end;

procedure TFormStat.FormDestroy(Sender: TObject);
begin
  IsLoading := true;
  st_Clean();
end;

procedure TFormStat.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if IsLoading then
    exit;
    
  if Item.Checked then
    st_SetItActive(Item.Data, 1)
  else
    st_SetItActive(Item.Data, 0);

  st_Update();

  Repaint;
  if DrawImage then
    SwapImage;
end;

procedure TFormStat.actViewExecute(Sender: TObject);
begin
  Repaint;
  if DrawImage then
    SwapImage;
end;

procedure TFormStat.MenuItemHelpIndexClick(Sender: TObject);
var
  fpath_st: array[0..MAX_PATH]of Char;
  fpath, cut_pos: PChar;
begin
  fpath := @fpath_st;
  GetModuleFileName(0, fpath, MAX_PATH);
  if GetFullPathName(fpath, MAX_PATH, fpath, cut_pos)<>0 then
    begin
      cut_pos^ := #0;
      lstrcat(fpath, 'help.chm');
      ShellExecute(0, nil, fpath, nil, nil, SW_SHOWMAXIMIZED);
    end;
end;

procedure TFormStat.ShowProgress(Position, Maximum: integer);
begin
  if not ProgressBar.Visible then
  begin
    ProgressBar.Max := Maximum;
    ProgressBar.Visible := true;
  end;
  ProgressBar.Position := Position;
  ProgressBar.Update;
end;

procedure TFormStat.HideProgress;
begin
  ProgressBar.Visible := false;
end;

procedure TFormStat.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  hshortcut{, hsheet}: pointer;
//  SheetName: string;
  ShortcutName: string;
  ShortcutNode: TTreeNode;
//  SheetNode: TTreeNode;
  h_icon: HICON;
  d_icon: TIcon;
  i: integer;
  enumsize, enumpos : integer;
begin
  AllowExpansion := true;

  if (Node.Item[0].Data <> nil) then
    exit;

  IsLoading := true;

  with FormStat.TreeView.Items do
    begin
      BeginUpdate();
      Delete(Node.Item[0]);

      st_SetEnumMode(ST_EMODE_SHEETSHORTCUTS);
      hshortcut := st_EnumStart(Node.Data);
      enumsize := st_GetEnumSize();
      enumpos := 0;
      while hshortcut<>nil do
        begin
          i := 0;
          h_icon := st_GetItIcon(hshortcut);
          if (h_icon<>0) then
            begin
              d_Icon := TIcon.Create;
              d_Icon.Handle := DuplicateIcon(0, h_icon);
              i := ImageListTV.AddIcon(d_Icon);
              d_Icon.Destroy;
            end;

          ShortcutName := st_GetItName(hshortcut);
          ShortcutNode := AddChild(Node, ShortcutName);
          ShortcutNode.Data := hshortcut;
          ShortcutNode.ImageIndex := i;
          ShortcutNode.SelectedIndex := i;
          ShortcutNode.StateIndex := Node.StateIndex;

//          if (st_GetItActive(hshortcut)<>0) then
//            ShortcutNode.StateIndex := STATEINDEX_ON
//          else
//            ShortcutNode.StateIndex := STATEINDEX_OFF;
//          OnTVItemStateChanging(ShortcutNode);

          ShowProgress(enumpos, enumsize);
          inc(enumpos);

          hshortcut := st_EnumNext();
        end;
      HideProgress();
      EndUpdate();
    end;

  IsLoading := false;
end;

procedure TFormStat.miFileSaveClick(Sender: TObject);
begin
  SaveDialog.DefaultExt := 'stat';
  SaveDialog.Filter := 'Файл статистики (*.stat)|*.stat';
  if SaveDialog.Execute then
    begin
      st_SaveFile(PChar(SaveDialog.FileName));
    end;
end;

procedure TFormStat.miFileExportHTMLClick(Sender: TObject);
begin
  SaveDialog.DefaultExt := 'html';
  SaveDialog.Filter := 'Веб-страница (*.html)|*.html';
  if SaveDialog.Execute then
    begin
      st_Export2Html(PChar(SaveDialog.FileName));
    end;
end;

procedure TFormStat.miFileExportXMLClick(Sender: TObject);
begin
  SaveDialog.DefaultExt := 'xml';
  SaveDialog.Filter := 'Документ Xml (*.xml)|*.html';
  if SaveDialog.Execute then
    begin
      st_Export2Xml(PChar(SaveDialog.FileName));
    end;
end;

procedure TFormStat.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  ProgressBar.Left := Rect.Left;
  ProgressBar.Top := Rect.Top;
  ProgressBar.Width := Rect.Right - Rect.Left;
  ProgressBar.Height := Rect.Bottom - Rect.Top;
end;

procedure TFormStat.SplitterHMoved(Sender: TObject);
begin
  TreeView.Invalidate;
  ListView.Invalidate;
  ScrollBox.Invalidate;
end;

end.
