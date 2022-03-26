
unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, StdCtrls, ImgList, Printers, ToolWin, ExtCtrls, CommCtrl;


type
  TBodyNotepadForm = class(TForm)
    ToolbarImages: TImageList;
    Memo: TMemo;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CreateDocButton: TToolButton;
    OpenDocButton: TToolButton;
    SaveDocButton: TToolButton;
    SaveAsDocButton: TToolButton;
    CloseDocButton: TToolButton;
    PrintDocButton: TToolButton;
    ExitButton: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure CreateDocButtonClick(Sender: TObject);
    procedure CloseDocButtonClick(Sender: TObject);
    procedure SaveDocButtonClick(Sender: TObject);
    procedure OpenDocButtonClick(Sender: TObject);
    procedure SaveAsDocButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure PrintDocButtonClick(Sender: TObject);
    procedure MemoChange(Sender: TObject);
  private
    DocFileName      : string;   // имя файла документа
    Saved            : boolean;  // файл сохранён
    function CreateOfficeFile: boolean;
    function OpenOfficeFile: boolean;
    function SaveOfficeFile( const fRewrite: boolean ): boolean;
    procedure WorkBeginning;
    procedure WorkDone;
    procedure AdjustToolBar( const mode: boolean); // enable/disable tool bar buttons
  end;

var
  BodyNotepadForm: TBodyNotepadForm;

implementation

{$R *.dfm}

uses
  Registry, OpnSavF;

{$INCLUDE ..\rp_shared\RP_Shared.inc}


const
  FILE_MASKS : string = '*.txt|TXT files (*.txt);*.*|*.*';

  procedure AlphaBlendRect(Canvas: TCanvas; Rect: TRect; FillColor: TColor; AlphaBlendValue: Byte);
  var
    X, Y: integer;
    PColor : TColor;
    NewR, RegionR: Byte;
    NewG, RegionG: Byte;
    NewB, RegionB: Byte;
  begin
    RegionR := GetRValue(ColorToRGB(FillColor));
    RegionG := GetGValue(ColorToRGB(FillColor));
    RegionB := GetBValue(ColorToRGB(FillColor));

    for Y := Rect.Top to Rect.Bottom - 1 do
    begin
      for X := Rect.Left to Rect.Right - 1 do
      begin
       PColor := Canvas.Pixels[X, Y];

       NewR := Round(RegionR * (AlphaBlendValue / 255) +
         GetRValue(ColorToRGB(PColor)) * (1 - (AlphaBlendValue / 255)));
       NewG := Round(RegionG * (AlphaBlendValue / 255) +
         GetGValue(ColorToRGB(PColor)) * (1 - (AlphaBlendValue / 255)));
       NewB := Round(RegionB * (AlphaBlendValue / 255) +
         GetBValue(ColorToRGB(PColor)) * (1 - (AlphaBlendValue / 255)));
       PColor := RGB(NewR, NewG, NewB);

       Windows.SetPixel(Canvas.Handle, X, Y, PColor);
      end;
    end;
  end;


procedure TBodyNotepadForm.FormCreate(Sender: TObject);
var
  n : integer;
  s : string;

  i: integer;
begin
  Caption:=Application.Title;
  CreateDocButton.Caption:=LS(501);
  OpenDocButton.Caption:=LS(502);
  SaveDocButton.Caption:=LS(503);
  SaveAsDocButton.Caption:=LS(504);
  CloseDocButton.Caption:=LS(505);
  PrintDocButton.Caption:=LS(506);
  ExitButton.Caption:=LS(507);
  CreateDocButton.Hint:='';
  OpenDocButton.Hint:='';
  SaveDocButton.Hint:='';
  SaveAsDocButton.Hint:='';
  CloseDocButton.Hint:='';
  PrintDocButton.Hint:='';
  ExitButton.Hint:='';

  ToolbarImages.Handle := ImageList_Create(24, 24, ILC_MASK or ILC_COLOR32, 7, 1);
  for i:=1000 to 1006 do
    ImageList_AddIcon(ToolbarImages.Handle,   LoadIcon(HInstance, PChar(i)));

  Constraints.MinWidth := ToolBar.ButtonCount * (ToolBar.ButtonWidth + 1) + 2;

  DocFileName := '';
  Saved := true;

  s:='';
  for n:=1 to ParamCount do
   if (ParamStr(n)[1]<>'-') and (ParamStr(n)[1]<>'/') then
    begin
     s:=ParamStr(n);
     break;
    end;

  if s<>'' then
   begin
     if FileExists(s) then
       begin
         DocFileName:=s;
       end;
   end;

  if DocFileName <> '' then
    begin
      AdjustToolBar(false);
    end
  else
    begin
      AdjustToolBar(true);
    end;
end;

procedure TBodyNotepadForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (CloseDocButton.Enabled) and (CloseDocButton.Visible) then CloseDocButtonClick( Sender );
end;

procedure TBodyNotepadForm.FormShow(Sender: TObject);
begin
  if DocFileName<>'' then
    OpenDocButtonClick(nil)
  else
    CreateDocButtonClick(nil);

  SetForegroundWindow(handle);
end;

procedure TBodyNotepadForm.WorkBeginning;
begin
  Toolbar.Enabled := false;
  Memo.Visible := false;
  Cursor:=crHourGlass;
  Update;
end;

procedure TBodyNotepadForm.WorkDone;
begin
  Toolbar.Enabled := true;
  Cursor:=crDefault;
  Update;
end;


function TBodyNotepadForm.CreateOfficeFile: boolean;
begin
  WorkBeginning;

  Memo.Lines.Clear;
  Memo.Visible := true;
  Memo.SetFocus;
  Saved := true;

  WorkDone;
  Result := true;
end;

function TBodyNotepadForm.OpenOfficeFile: boolean;
var
  Stream     : TFileStream;
  MemSize    : integer;
  S          : string;
  Buffer     : PChar;
  TempBuffer : PChar;
  TempCh     : char;
  i          : integer;
begin
  WorkBeginning;

  Memo.Lines.Clear;

  try
    Stream := TFileStream.Create(DocFileName, fmOpenRead);
    try
      MemSize := Stream.Size;
      Inc(MemSize); {Make room for the buffer's null terminator.}
      Buffer := AllocMem(MemSize);
      try
        Stream.Read(Buffer^, MemSize);

        if (MemSize>4) and Odd(MemSize) and (Buffer^ = #$FF) and ((Buffer+1)^ = #$FE) then {Plain unicode}
          begin
            S := WideCharToString(PWideChar(Buffer+2)); { +2 - to skip BOM signature on beginning of text}
            Memo.Lines.Text := S;
          end
        else
        if (MemSize>4) and Odd(MemSize) and (Buffer^ = #$FE) and ((Buffer+1)^ = #$FF) then {Plain unicode big-endian}
          begin
            TempBuffer := Buffer;
            for i:=0 to ((MemSize-2) shr 1) do
              begin                               {Reverse odd & even bytes}
                TempCh := TempBuffer^;
                TempBuffer^ := (TempBuffer+1)^;
                inc(TempBuffer);
                TempBuffer^ := TempCh;
                inc(TempBuffer);
              end;
            S := WideCharToString(PWideChar(Buffer+2)); { +2 - to skip BOM signature on beginning of text}
            Memo.Lines.Text := S;
          end
        else  {just plain text}
          begin
            for i:=0 to MemSize-2 do
              if (Buffer+i)^ = #$0 then    {Filter #0 characters}
                (Buffer+i)^ := #$20;

            Memo.Lines.Text := Buffer;
          end;

        Memo.Visible := true;
        Memo.SetFocus;
        Saved := true;
        Result := true;
      finally
        FreeMem(Buffer, MemSize);
      end;
    finally
      Stream.Free;
    end;
  except
    Result := false;
  end;

  WorkDone;
end;

function TBodyNotepadForm.SaveOfficeFile( const fRewrite: boolean ): boolean;
var
  fTemp: string;
begin
  try
    if fRewrite then
      begin
        fTemp := ExtractFilePath( DocFileName ) + IntToStr( GetTickCount ) + '.txt';
        Memo.Lines.SaveToFile( fTemp );
        DeleteFile( DocFileName );
        Memo.Lines.SaveToFile( DocFileName );
        DeleteFile( fTemp );
      end
    else
      Memo.Lines.SaveToFile( DocFileName );

    Saved := true;
    Result := true;
  except
    Result := false;
  end;
end;

procedure TBodyNotepadForm.CreateDocButtonClick(Sender: TObject);
begin
  if not CreateOfficeFile then

  DocFileName := '';

  AdjustToolBar(false);
end;

procedure TBodyNotepadForm.CloseDocButtonClick(Sender: TObject);
var s1,s2:pchar;
begin
  s1:=LSP(508);
  s2:=LSP(509);

  cursor:=crHourGlass;
  if not Saved then
    if SaveDocButton.Visible and SaveDocButton.Enabled and ( MessageBox( Handle, s1, s2, mb_YesNo + mb_IconQuestion + mb_TaskModal ) = IDYes ) then
      SaveDocButtonClick( Sender );

  DocFileName := '';

  Memo.Visible := false;
  Update;
  Refresh;

  AdjustToolBar(true);
  cursor:=crDefault;
end;

procedure TBodyNotepadForm.OpenDocButtonClick(Sender: TObject);
var s1,s2:pchar;
begin
  s1:=LSP(510);
  s2:=LSP(LS_ERR);

  if Sender<>nil then
    begin
      if not OpenSaveForm.ExecuteOpenFile( FILE_MASKS, DocFileName ) then exit;
    end;

  if DocFileName = '' then
    exit;

  if not OpenOfficeFile then
    begin
      MessageBox( Handle, s1, s2, mb_Ok + mb_IconError + mb_TaskModal );
      DocFileName := '';
    end;

  if DocFileName <> '' then
    begin
      AdjustToolBar(false);
    end
  else
    begin
      AdjustToolBar(true);
    end;
end;

procedure TBodyNotepadForm.SaveDocButtonClick(Sender: TObject);
var s_error,s_error2:pchar;
begin
  s_error:=LSP(511);
  s_error2:=LSP(LS_ERR);

  if DocFileName = '' then
    if not OpenSaveForm.ExecuteSaveFile( FILE_MASKS, true, DocFileName ) then
      begin
        DocFileName := '';
        exit;
      end;

  if not SaveOfficeFile( false ) then
    MessageBox( Handle, s_error, s_error2, mb_Ok + mb_IconError + mb_TaskModal )
end;

procedure TBodyNotepadForm.SaveAsDocButtonClick(Sender: TObject);
var
  OldName: string;
  s1,s2:pchar;
begin
  OldName := DocFileName;

  s1:=LSP(512);
  s2:=LSP(LS_ERR);

  if not OpenSaveForm.ExecuteSaveFile( FILE_MASKS, true, DocFileName ) then
    begin
      DocFileName := OldName;
      exit;
    end;

  if not SaveOfficeFile( false ) then
    MessageBox( Handle, s1, s2, mb_Ok + mb_IconError + mb_TaskModal );
end;

procedure TBodyNotepadForm.PrintDocButtonClick(Sender: TObject);
var
  fPrint : TextFile;
  i      : integer;
  s1,s2:pchar;
begin
  if (Printer.Printers.Count = 0) then // No printers installed
    exit;

  s1:=LSP(513);
  s2:=LSP(509);

  if MessageBox( Handle, s1, s2, mb_YesNo + mb_IconQuestion + mb_TaskModal ) = IDNo then
    exit;

  Printer.PrinterIndex := -1;         // Choose the default printer
  Printer.Canvas.Font := Memo.Font;

  AssignPrn(fPrint);
  System.Rewrite(fPrint);

  for i:=0 to Memo.Lines.Count - 1 do
    WriteLn(fPrint, Memo.Lines[i]);

  System.CloseFile(fPrint)
end;

procedure TBodyNotepadForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TBodyNotepadForm.AdjustToolBar( const mode : boolean);
begin
  CreateDocButton.Enabled := mode;
  OpenDocButton.Enabled := mode;
  SaveDocButton.Enabled := not mode;
  SaveAsDocButton.Enabled := not mode;
  CloseDocButton.Enabled := not mode;
  PrintDocButton.Enabled := not mode;
end;

procedure TBodyNotepadForm.MemoChange(Sender: TObject);
begin
  Saved := false;
end;

end.
