unit carrusform;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  CARules2, CARulTree, GollyFiles, UMCell, SaveGTree, USpecl, CASpecTree,
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, ImgList, ToolWin, ActnList, StdCtrls, FileUtil,
  Math;

const
 sPalSig = 'CAR PAL';

type

  MapType = (mtMap,mtTree,mtOther);

  TCellColBufr = array of array of TColor;

  { TFormCA }

  TFormCA = class(TForm)
    ScrollPan: TPanel;
    StatusLine: TStatusBar;
    ToolPan: TPanel;
    MainPan: TPanel;
    ScrollMain: TScrollBox;
    CAPaintBox: TPaintBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    SaveAs1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Run1: TMenuItem;
    Run2: TMenuItem;
    Pause1: TMenuItem;
    Step1: TMenuItem;
    Clear1: TMenuItem;
    Invert1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ToolBarRun: TToolBar;
    ToolSep1: TToolButton;
    RunBtn: TToolButton;
    StepBtn: TToolButton;
    PauseBtn: TToolButton;
    ImageBtnsList: TImageList;
    ClearBtn: TToolButton;
    PixBtn: TToolButton;
    RunList: TActionList;
    RunAct: TAction;
    StepAct: TAction;
    PauseAct: TAction;
    ClearAct: TAction;
    PixAct: TAction;
    InvBtn: TToolButton;
    InvAct: TAction;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MenuMap: TMenuItem;
    Reversible1: TMenuItem;
    N3: TMenuItem;
    Life1: TMenuItem;
    OpenMap1: TMenuItem;
    SaveMapAs1: TMenuItem;
    Drive1: TMenuItem;
    Cyclic1: TMenuItem;
    ReadMe1: TMenuItem;
    FileNew1: TAction;
    ToolSep2: TToolButton;
    NewBtn: TToolButton;
    OpenBtn: TToolButton;
    SaveBtn: TToolButton;
    ToolSep3: TToolButton;
    ExitBtn: TToolButton;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    ToolBarEdit: TToolBar;
    ToolSep4: TToolButton;
    SetCellBtn: TToolButton;
    GetCellBtn: TToolButton;
    EditCA: TEdit;
    ExportMap: TMenuItem;
    IrrevTab1: TMenuItem;
    RevTab1: TMenuItem;
    Invtab1: TMenuItem;
    ExportPattern: TMenuItem;
    RunBackAct: TAction;
    BackStepAct: TAction;
    RewBtn: TToolButton;
    BackBtn: TToolButton;
    Rewind1: TMenuItem;
    Back1: TMenuItem;
    Tables1: TMenuItem;
    Tree1: TMenuItem;
    Load1: TMenuItem;
    MCell1: TMenuItem;
    InputBS: TMenuItem;
    RenewMenu1: TMenuItem;
    OldPlusNew: TMenuItem;
    NewMinusOld: TMenuItem;
    OldMinusNew: TMenuItem;
    MenuColors1: TMenuItem;
    MenuReadColors: TMenuItem;
    MenuSaveColors: TMenuItem;
    SpecialRule1: TMenuItem;
    N2: TMenuItem;
    Buffer1: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure CAPaintBoxPaint(Sender: TObject);
    procedure CAPaintBoxClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Step1Click(Sender: TObject);
    procedure CAPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Invert1Click(Sender: TObject);
    procedure ToolPixClick(Sender: TObject);
    procedure MainPanMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Run2Click(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Reversible1Click(Sender: TObject);
    procedure Life1Click(Sender: TObject);
    procedure SaveMapAs1Click(Sender: TObject);
    procedure OpenMap1Click(Sender: TObject);
    procedure Drive1Click(Sender: TObject);
    procedure Cyclic1Click(Sender: TObject);
    procedure MenuMapClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure ReadMe1Click(Sender: TObject);
    procedure IrrevTab1Click(Sender: TObject);
    procedure RevTab1Click(Sender: TObject);
    procedure Invtab1Click(Sender: TObject);
    procedure ExportPatternClick(Sender: TObject);
    procedure BackStepActExecute(Sender: TObject);
    procedure RunBackActExecute(Sender: TObject);
    procedure Tree1Click(Sender: TObject);
    procedure MCell1Click(Sender: TObject);
    procedure InputBSClick(Sender: TObject);
    procedure RenewMenu1Click(Sender: TObject);
    procedure RenewOptClick(Sender: TObject);
    procedure MenuSaveColorsClick(Sender: TObject);
    procedure MenuReadColorsClick(Sender: TObject);
    procedure SpecialRule1Click(Sender: TObject);
    procedure CAPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CAPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Buffer1Click(Sender: TObject);
  private
    { Private declarations }
    FRev,FBufr : Boolean;
    //MsState : TShiftState;
  public
    { Public declarations }
    CellA : CAField;
    mp : MapType;
    Sc,Gc,
    Xc,Yc,
    MsX,MsY,
    NStep,NStat : Integer;
    Running : boolean;
    DblPal : boolean;
    BkCol : TColor;
    StCols : TCellColors;
    RuleName : String;
    CBufr : TCellColBufr;

    procedure FullPaint;
    procedure PaintCanvas(Canvas : TCanvas;
      Sc,Gc,X0,X1,Y0,Y1 : Integer);
    procedure PaintChanges;
    procedure PaintChkChanges;
    procedure NextState(i,j : integer);
    function GetCellColor(i,j : integer) : TColor;
    function GetColorPal(C : Integer; Inv : Boolean) : TColor;
    procedure BMPSeries(x1,y1,x2,y2,nx,ny,stp : integer); overload;
    procedure BMPSeries(FName : String; Offs,Sz,Gp,Stp : integer); overload;
    procedure OpenRevFile(FileName : String);
    procedure OpenGollyRleFile(FileName : String);
    procedure SaveRevFile(FileName : String);
    procedure SetRev(Value : Boolean);
    function GetRev : Boolean;
    procedure SetBufr(Value : Boolean);
    procedure SaveGTabl(tron : tRevOrNot);
    procedure SaveConvertTree;
    property IsRev : boolean Read GetRev write SetRev;
    property IsBufr : boolean Read FBufr write SetBufr;
    procedure CheckCapCA;
    procedure ReadColorPal(PalFileName : String);
    procedure WriteColorPal(PalFileName : String; UseHex : Boolean);
    function CheckColorPal(PalName : String) : Boolean;
    procedure ChangeState(Draw : Boolean);
    procedure FillColBufr;
    procedure GetVisibleCells(var X0,X1,Y0,Y1 : Integer);
  end;

var
  FormCA: TFormCA;

implementation

{$R *.dfm}

uses CAPix,PixSer,DlgCells,AboutCART,ReadMeVar,DlgXY;

 type
  RevSig = packed record
   Sig : word;
   Xm,Ym : SmallInt;
  end;

  BytesArray = Array [0..MaxInt-1] of byte;
  PBytesArray = ^BytesArray;

function InterColor(C1, C2 : Integer; k : single) : Integer;
var
 r1,g1,b1,r2,g2,b2 : integer;
begin
 r1 := C1 mod 256; C1 := C1 div 256;
 g1 := C1 mod 256; C1 := C1 div 256;
 b1 := C1 mod 256;
 r2 := C2 mod 256; C2 := C2 div 256;
 g2 := C2 mod 256; C2 := C2 div 256;
 b2 := C2 mod 256;
 r1 := Trunc((1-k) * r1 + k * r2);
 g1 := Trunc((1-k) * g1 + k * g2);
 b1 := Trunc((1-k) * b1 + k * b2);
 Result := r1 + 256*(g1+256*b1);
end;


procedure TFormCA.FormCreate(Sender: TObject);
begin
 Sc := 4;
 Gc := 1;
 Xc := 50;
 Yc := 50;
 NStep := 0;
 NStat := 2;
 SetLength(StCols,4);
 DblPal := false;
 BkCol := Color;

 StCols[0] := clWhite;
 StCols[1] := clRed;
 StCols[2] := clLime;
 StCols[3] := clBlue;
 FRev := True;
 FBufr := False;
 Running := False;
 CBufr := nil;
 CellA := CAField.Create(LocRulLife.Create);
 mp := mtMAP;
 RuleName := 'Life';
 CellA.SetArea(Xc,Yc);
 {$IFNDEF FPC}
 ForceCurrentDirectory := true;
 {$ENDIF}
 ReadMeName := 'CARRUS-readme.txt';
 CheckCapCA;
end;

procedure TFormCA.CAPaintBoxPaint(Sender: TObject);
begin
 FullPaint
end;

procedure TFormCA.CheckCapCA;
begin
 with CellA.CARul do
 begin
   InvAct.Enabled := IsRev and CheckCap(capInvert);
   if CheckCap(capIrrevStep + capRevStep) then
    Reversible1.Enabled := true
   else
   begin
    if (IsRev and not CheckCap(capRevStep))
    or (not IsRev and CheckCap(capIrrevStep)) then
      IsRev := not FRev;
    Reversible1.Enabled := false;
   end;
   SaveMapAs1.Enabled := CheckCap(capSaveMap);
   RenewMenu1.Enabled := IsRev and (fxy < f_special);
 end;
  StatusLine.Panels[2].Text := RuleName;
end;

function TFormCA.CheckColorPal(PalName: String) : Boolean;
begin
  Result := False;
  if FileExistsUTF8(ChangeFileExt(PalName,'.ccl')) { *Converted from FileExists*  } then
   if MessageDlg('Read palette?',
    mtConfirmation,[mbYes,mbNo],0) = mrYes then
   try
    ReadColorPal(ChangeFileExt(PalName,'.ccl'));
    FullPaint;
    Result := True;
   except
    on E : Exception do
     ShowMessage('Error reading palette');
   end;
end;

procedure TFormCA.CAPaintBoxClick(Sender: TObject);
begin
 // ChangeState(False)
end;

procedure TFormCA.ChangeState(Draw : Boolean);
var
 X,Y,St,St0 : Integer;
begin
 X := MsX;
 Y := MsY;
 if (X >= 0) and (X < Xc)
  and (Y >= 0) and (Y < Yc) then
  with CellA,CAPaintBox do
  begin
    with CellA do
     if IsRev then
      St0 := CA12[X,Y]
     else
      St0 := CA1[X,Y];
   if GetCellBtn.Down then
   begin
     EditCA.Text := IntToStr(St0);
   end
   else
   begin
    if SetCellBtn.Down then
    if EditCA.Text = '+' then
     NextState(X,Y)
    else
    begin
     St := StrToIntDef(EditCA.Text,0);
     if (not Draw) and (St0 = St) then St := 0; 
     with CellA do
     if IsRev then
      CA12[X,Y] := St mod CellA.CARul.Nsr
     else
      CA1[X,Y] := St mod NStat;
    end;
    Canvas.Brush.Color := GetCellColor(X,Y);
    Canvas.Clipping:=false;  {!!!}
    Canvas.FillRect(Rect(X*(Sc+Gc)+1,Y*(Sc+Gc)+1,
                 X*(Sc+Gc)+Sc+1,Y*(Sc+Gc)+Sc+1));
   end;
  end;
end;

procedure TFormCA.NextState(i,j : integer);
begin
 with CellA do
 if IsRev then
  CA12[i,j] := (CA12[i,j]+1) mod CellA.CARul.Nsr
 else
  CA1[i,j] := (CA1[i,j]+1) mod Nstat;
end;

procedure TFormCA.FillColBufr;
var
 i,j : integer;
begin
 if (Length(CBufr) <> Xc)
  or (Length(CBufr[0]) <> Yc)
 then SetLength(CBufr,Xc,Yc);
 for i := 0 to Xc-1 do
   for j := 0 to Yc-1 do
     CBufr[i,j] := GetCellColor(i,j)
end;

function TFormCA.GetCellColor(i,j : integer) : TColor;
begin
 with CellA do
 if IsRev then
  Result := GetColorPal(CA12[i,j],True)
 else
  Result := GetColorPal(CA1[i,j],False)
end;


function TFormCA.GetColorPal(C: Integer; Inv : boolean): TColor;
var
 C1,C2 : NCell;
 l : integer;
 k : single;
begin
  if Inv then
  with CellA.CARul do
  begin
   if Nsr <= Length(StCols) then
    Result := StCols[C]
   else
   begin
    SplitC12(C,C1,C2);
    if DblPal then
    begin
      l := Length(StCols) div 2;
      if C1 >= l then
       C1 := C1 mod (l-1) + 1;
      k := C2/Ns2(C1);
      Result := InterColor(ColorToRGB(StCols[C1]),
        ColorToRGB(StCols[C1+l]),k)
    end
    else
    begin
      l := Length(StCols);
      if C1 >= l then
       C1 := C1 mod (l-1) + 1;
      k := C2/Ns2(C1);
      Result := InterColor(ColorToRGB(StCols[C1]),
        ColorToRGB(StCols[0]) xor $FFFFFF,k)
    end;
   end
  end
  else
  begin
   if C >= Length(StCols) then
     C := C mod (Length(StCols)-1)+1;
   Result := StCols[C]
  end;
end;

function TFormCA.GetRev: Boolean;
begin
 Result := FRev;
end;

procedure TFormCA.FullPaint;
var
 X0,X1,Y0,Y1 : integer;
begin
 with CAPaintBox do
 begin
  Width := Xc*(Sc+Gc)+1;
  Height := Yc*(Sc+Gc)+1;
  GetVisibleCells(X0,X1,Y0,Y1);
  PaintCanvas(Canvas,Sc,Gc,X0,X1,Y0,Y1)
 end;
end;

procedure TFormCA.GetVisibleCells(var X0,X1,Y0,Y1 : Integer);
var
 R : TRect;
begin
  with ScrollMain do
  begin
   R.Left := HorzScrollBar.Position;
   R.Right := R.Left+MainPan.Width;
   R.Top := VertScrollBar.Position;
   R.Bottom := R.Top+MainPan.Height;
  end;
  X0 := R.Left div (Sc+Gc);
  X1 := Min(Xc,R.Right div (Sc+Gc)+1);
  Y0 := R.Top div (Sc+Gc);
  Y1 := Min(Yc,R.Bottom div (Sc+Gc)+1);
end;

procedure TFormCA.PaintCanvas(Canvas: TCanvas;
  Sc,Gc,X0,X1,Y0,Y1 : Integer);
var
 i,j : integer;
begin
 with Canvas do
 begin
  Brush.Color := BkCol;
  Canvas.Clipping:=false;  {!!!}
  FillRect(Rect(X0,Y0,X1*(Sc+Gc)+1,Y1*(Sc+Gc)+1));
  for i := X0 to X1-1 do
   for j := Y0 to Y1-1 do
   begin
    Brush.Color := GetCellColor(i,j);
    FillRect(Rect(i*(Sc+Gc)+1,j*(Sc+Gc)+1,
                i*(Sc+Gc)+Sc+1,j*(Sc+Gc)+Sc+1));
   end;
 end
end;

procedure TFormCA.PaintChanges;
var
 i,j,
 X0,X1,Y0,Y1 : integer;
begin
 GetVisibleCells(X0,X1,Y0,Y1);
 with CAPaintBox do
 begin
  for i := X0 to X1-1 do
   for j := Y0 to Y1-1 do
   if CellA.CA1[i,j] <> CellA.CA2[i,j] then
   begin
    Canvas.Brush.Color := GetCellColor(i,j);
    Canvas.FillRect(Rect(i*(Sc+Gc)+1,j*(Sc+Gc)+1,
                i*(Sc+Gc)+Sc+1,j*(Sc+Gc)+Sc+1));
   end;
 end
end;

procedure TFormCA.PaintChkChanges;
var
 i,j,
 X0,X1,Y0,Y1 : integer;
 PrevCol : TColor;
begin
 GetVisibleCells(X0,X1,Y0,Y1);
 with CAPaintBox do
 begin
  for i := X0 to X1-1 do
   for j := Y0 to Y1-1 do
   begin
    Canvas.Brush.Color := GetCellColor(i,j);
    if FBufr then PrevCol := CBufr[i,j]
    else PrevCol := Canvas.Pixels[i*(Sc+Gc)+1,j*(Sc+Gc)+1];
    if Canvas.Brush.Color <> PrevCol
    then  Canvas.FillRect(Rect(i*(Sc+Gc)+1,j*(Sc+Gc)+1,
                i*(Sc+Gc)+Sc+1,j*(Sc+Gc)+Sc+1));
   end;
 end
end;

procedure TFormCA.Clear1Click(Sender: TObject);
begin
  CellA.ClearArea;
  FullPaint;
  NStep:=0;
  StatusLine.Panels[1].Text := Format('%d',[NStep]);

end;

procedure TFormCA.Step1Click(Sender: TObject);
begin
  if IsRev then
  begin
   if FBufr then FillColBufr;
   CellA.CalcNewRev;
   PaintChkChanges;
  end
  else
  begin
   CellA.CalcNew;
   PaintChanges;
  end;
  Inc(NStep);
  StatusLine.Panels[1].Text := Format('%d',[NStep]);
end;

procedure TFormCA.CAPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 MsX := (X-1) div (Sc+Gc);
 MsY := (Y-1) div (Sc+Gc);
 //MsState := Shift;
 if [ssLeft] = Shift then ChangeState(false);
 StatusLine.Panels[0].Text := Format('X = %d, Y = %d',[MsX,MsY])

end;

procedure TFormCA.CAPaintBoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 if (MsX <> (X-1) div (Sc+Gc))
  or (MsY <> (Y-1) div (Sc+Gc)) then
 begin
  MsX := (X-1) div (Sc+Gc);
  MsY := (Y-1) div (Sc+Gc);
  if [ssLeft] = Shift then
   ChangeState(true);
 end;
 StatusLine.Panels[0].Text := Format('X = %d, Y = %d',[MsX,MsY])

end;

procedure TFormCA.CAPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 MsX := (X-1) div (Sc+Gc);
 MsY := (Y-1) div (Sc+Gc);
 //MsState := Shift;
 StatusLine.Panels[0].Text := Format('X = %d, Y = %d',[MsX,MsY])
end;

procedure TFormCA.InputBSClick(Sender: TObject);
var
 S : String;
begin
  S := 'B3/S23';
  if InputQuery('Input of Born/Survive rule',
   'Enter the rule B.../S...',S)
  then
  begin
    CellA.CARul.Free;
    CellA.CARul :=  LocRulDLife.Create(S,False);
    NStat := CellA.CARul.Ns;
    mp := mtMap;
    RuleName := S;
    CheckCapCA;
  end;

end;

procedure TFormCA.Invert1Click(Sender: TObject);
begin
 if IsRev then
 begin
  CellA.SwapAreas;
  FullPaint;
 end;
 NStep := -NStep;
 StatusLine.Panels[1].Text := Format('%d',[NStep]);
end;

procedure TFormCA.Invtab1Click(Sender: TObject);
begin
 SaveGTabl(trRevInv);
end;

procedure TFormCA.IrrevTab1Click(Sender: TObject);
begin
 SaveGTabl(trIrRev);
end;

procedure TFormCA.BackStepActExecute(Sender: TObject);
begin
  if IsRev then
  begin
   if FBufr then FillColBufr;
   CellA.CalcNewRev(true);
   PaintChkChanges;
   Dec(NStep);
  end;
  StatusLine.Panels[1].Text := Format('%d',[NStep]);
end;

procedure TFormCA.BMPSeries(FName: String; Offs, Sz, Gp, Stp: integer);
var
 i : integer;
begin
 with FormPix do
 begin
  InitPix(Xc*(Sz+Gp)+1,Yc*(Sz+Gp)+1);
  for i := 0 to Stp-1 do
  begin
    if i <> 0 then Step1Click(Self);
    PaintCanvas(FormPix.Pix.Canvas,Sz,Gp,0,Xc,0,Yc);
    FormPix.Pix.Picture.SaveToFile(
     Format(FName,[Offs+i]));
    Application.ProcessMessages;
  end;
 end;
end;

procedure TFormCA.BMPSeries(x1,y1,x2,y2,nx,ny,stp  : integer);
var
 i,ix,iy,jx,jy,x,y,st,W,H : integer;
begin
 st := nx*ny;
 x := x2-x1+1;
 y := y2-y1+1;
 W := (x+1)*nx+1;
 H := (y+1)*ny+1;
 with FormPix do
 begin
  InitPix(W,H);
  for iy := 0 to ny-1 do
  for ix := 0 to nx-1 do
  begin
   if (ix > 0) or (iy > 0) then
   for i := 1 to Stp do
    Step1Click(Self);
   for jx := x1 to x2 do
    for jy := y1 to y2 do
     Pix.Canvas.Pixels[ix*(x+1)+jx-x1+1,iy*(y+1)+jy-y1+1] :=
      GetCellColor(jx,jy);
   Application.ProcessMessages;
  end;
 end;
end;


procedure TFormCA.Buffer1Click(Sender: TObject);
begin
  IsBufr := Buffer1.Checked;
end;

procedure TFormCA.ToolPixClick(Sender: TObject);
begin
 with SerBmpDlg do
 begin
 Sz := Sc;
 Gp := Gc;
 SetPars;
 if Execute then
 begin
  with SaveDialog1 do
  begin
    if DefaultExt <> 'BMP' then FileName := '';
    DefaultExt := 'BMP';
    Filter := 'Bitmap Files (*.bmp)|*.bmp|All files (*.*)|*.*';
    if Execute then
     if SinglePix then
     begin
      BMPSeries(Xmin,Ymin,Xmax,Ymax,Wp,Hp,Stp);
      FormPix.Pix.Picture.SaveToFile(FileName);
     end
     else
      BMPSeries(ChangeFileExt(FileName,'')+Fmt+'.bmp',Offs,Sz,Gp,Cnt);
   end;
 end;
 end;
end;

procedure TFormCA.Tree1Click(Sender: TObject);
begin
 SaveConvertTree
end;


procedure TFormCA.MainPanMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 MsX := -1;
 MsY := -1;
 StatusLine.Panels[0].Text := '';
end;

procedure TFormCA.MCell1Click(Sender: TObject);
var
 MCAdat : TMCAdat;
 PalName : String;
 AskPal : Boolean;
begin
 AskPal := True;
 with OpenDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> 'DLL' then FileName := '';
  DefaultExt := 'DLL';
  Filter := 'MCell Rule (*.dll)|*.DLL|Any file (*.*)|*.*';
  if Execute then
  begin
   if LoadMCellDll(MCADat,PalName,FileName) then
   with CellA do
   begin
    CARul.Free;
    CARul := LocRulMCellDll.Create(MCAdat);
    mp := mtOther;
    if IsRev then
     if MessageDlg('Set irreversible mode',
      mtConfirmation,[mbYes,mbNo],0) = mrYes
      then SetRev(False)
      else
       with CellA.CARul do
       if (Ns > 2) and (fxy = fx_plus_y) then
       fxy := fx_minus_y;
    NStat := CellA.CARul.Ns;
    RuleName := ChangeFileExt(ExtractFileName(FileName),'');
    if FileExistsUTF8(PalName+'.mcp') { *Converted from FileExists*  } then
     if MessageDlg('Read MCell color table?',
      mtConfirmation,[mbYes,mbNo],0) = mrYes then
     try
      SetLength(StCols,NStat);
      DblPal := False;
      ReadMCellColors(StCols,PalName+'.mcp');
      FullPaint;
      AskPal := False;
     except
      on E : Exception do
       ShowMessage('Error reading color table');
     end;
    if AskPal then CheckColorPal(FileName);
    CheckCapCA
   end
   else ShowMessage('Wrong DLL type')

  end;
 end;
end;

procedure TFormCA.Run2Click(Sender: TObject);
begin
 if Running then Exit;
 MenuMap.Enabled := False;
 NStep := 0;
 RunAct.Enabled := False;
 RunBackAct.Enabled := False;
 PauseAct.Enabled := True;
 Running := True;
 repeat
  Step1Click(Sender);
  Application.ProcessMessages;
 Until not Running;
end;

procedure TFormCA.RunBackActExecute(Sender: TObject);
begin
 if Running or not IsRev then Exit;
 MenuMap.Enabled := False;
 NStep := 0;
 RunAct.Enabled := False;
 RunBackAct.Enabled := False;
 PauseAct.Enabled := True;
 Running := True;
 repeat
  BackStepActExecute(Sender);
  Application.ProcessMessages;
 Until not Running;
end;

procedure TFormCA.Pause1Click(Sender: TObject);
begin
 Running := False;
 MenuMap.Enabled := True;
 RunAct.Enabled := True;
 RunBackAct.Enabled := IsRev;
 PauseAct.Enabled := False;
end;

procedure TFormCA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Running then Pause1Click(Sender)
 else Action := caFree;
end;

procedure TFormCA.Exit1Click(Sender: TObject);
begin
 Close;
end;

procedure TFormCA.ExportPatternClick(Sender: TObject);
begin
 with SaveDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> 'rle' then FileName := '';
  DefaultExt := 'rle';
  Filter := 'Golly pattern files (*.rle)|*.rle'
   + '|All files (*.*)|*.*';
  if Execute then
   WriteGPattern(0,0,CellA.SizeX-1,CellA.SizeY-1,CellA,
    IsRev,True,RuleName,FileName)
 end;
end;

procedure TFormCA.New1Click(Sender: TObject);
begin
 if Running then Exit;
 with CellsDlg do
 if Execute then
 begin
  Sc := NSc;
  Gc := NGc;
  Xc := NXc;
  Yc := NYc;
  CellA.SetArea(Xc,Yc);
  FullPaint;
 end;
end;

procedure TFormCA.Open1Click(Sender: TObject);
var
 Ext : string;
begin
 with OpenDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> 'REV' then FileName := '';
  DefaultExt := 'REV';
  Filter := 'R.Evol files (*.rv,*.rev)|*.RV;*.REV'
   + '|Golly pattern files (*.rle)|*.RLE'
   + '|All files (*.*)|*.*';
  if Execute then
  begin
   Ext := UpperCase(ExtractFileExt(FileName));
   if (Ext = '.REV') or (Ext = '.RV')
   then OpenRevFile(FileName)
    else
    if (Ext = '.RLE') then
    OpenGollyRleFile(FileName)

  end;
 end;
end;

procedure TFormCA.OpenGollyRleFile(FileName: String);
begin
 with FormDlgXY do
 if Execute then
 begin
  CellA.ClearArea;
  ReadGPattern(X,Y,CellA,FileName,IsRev);
  FullPaint;
 end;
end;

procedure TFormCA.SaveAs1Click(Sender: TObject);
begin
 with SaveDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> 'REV' then FileName := '';
  DefaultExt := 'REV';
  Filter := 'R.Evol files (*.rv)|*.RV|All files (*.*)|*.*';
  if Execute then
   SaveRevFile(FileName)
 end;
end;

procedure TFormCA.SaveConvertTree;
var
 FO : TextFile;
 CA : LocRulTree;
 Ext : String;
 OK,rv,bk : Boolean;
begin
 with SaveDialog1 do
 begin
  FilterIndex := 1;
  if Pos('/',RuleName)=0 then FileName := RuleName
  else if DefaultExt <> 'MPT' then FileName := '';
  DefaultExt := 'MPT';
  Filter := 'CART tree files (*.MPT)|*.MPT|Golly rule trees (*.tree)|*.tree';
  if Execute then
  begin
    OK := False;
    Ext := UpperCase(ExtractFileExt(FileName));
    if Ext = '.MPT' then
    try
      Screen.Cursor := crHourGlass;
      if CellA.CARul.fxy >= f_special
      then
       CA := LocRulSpecTree.Create(CellA.CARul)
      else
       CA := LocRulTree.Create(CellA.CARul);
      AssignFile(FO,FileName);
      Rewrite(FO);
      CA.SaveMap(FO);
      OK := True;
    finally
      CloseFile(FO);
      CA.Free;
      Screen.Cursor := crDefault;
    end
    else
     if Ext = '.TREE'
     then
     begin
       Rv := IsRev;
       if Rv then
        Rv := MessageDlg('Save as reversible?',
         mtConfirmation,[mbYes,mbNo],0) = mrYes;
       if Rv then
         Bk := not (MessageDlg('Run-forward definition?',
          mtConfirmation,[mbYes,mbNo],0) = mrYes);

       try
         Screen.Cursor := crHourGlass;
         if Rv then
          if Bk then
            OK := SaveGlyTrees(CellA.CARul,'','',FileName)
          else
            OK := SaveGlyTrees(CellA.CARul,'',FileName,'')
         else
          OK := SaveGlyTree(CellA.CARul,FileName);
       finally
         Screen.Cursor := crDefault;
       end;
     end;
    if not OK then
      ShowMessage('Error saving '+FileName);
   end;
 end;
end;

procedure TFormCA.SaveGTabl(tron: tRevOrNot);
var
 FO : TextFile;
begin
 with SaveDialog1 do
 begin
  FilterIndex := 1;
  if Pos('/',RuleName)=0 then
  case tron of
   trIrRev : FileName := RuleName;
   trRev : FileName := 'Rev'+RuleName;
   trRevInv : FileName := 'Rev'+RuleName+'-Inv';
  end
  else if DefaultExt <> 'table' then FileName := '';
  DefaultExt := 'table';
  Filter := 'Golly table files (*.table)|*.table|All files (*.*)|*.*';
  if Execute then
  try
    AssignFile(FO,FileName);
    Rewrite(FO);
    Screen.Cursor := crHourGlass;
    WriteGlyTab(CellA.CARul,tron,FO);
  finally
    CloseFile(FO);
    Screen.Cursor := crDefault;
  end;
 end;
end;

procedure TFormCA.OpenRevFile(FileName : String);
var
  RS : RevSig;
  Dat : Pointer;
  i,j,b : integer;
  F : File;
 begin
  try
   AssignFile(F,FileName);
   Reset(F,1);
   BlockRead(F,RS,SizeOf(RS));
   if RS.Sig <> 4011 then Exit;
   try
    GetMem(Dat,RS.Xm*RS.Ym);
    BlockRead(F,Dat^,RS.Xm*RS.Ym);
    Xc := RS.Xm;
    Yc := RS.Ym;
    CellA.SetArea(Xc,Yc);
    for i := 0 to Xc-1 do
     for j := 0 to Yc-1 do
     begin
      b := PByteArray(Dat)^[i*Yc+j];
      CellA.CA12[i,j] := b;
     end;
    FullPaint;
   finally
    FreeMem(Dat);
   end;
  finally
   CloseFile(F)
  end;
 end;

 procedure TFormCA.SaveRevFile(FileName : String);
 var
  RS : RevSig;
  Dat : Pointer;
  i,j,NSkey : integer;
  F : File;
 begin
  if IsRev then NSkey := NStat else NSkey := 0;
  try
   AssignFile(F,FileName);
   Rewrite(F,1);
   RS.Sig := 4011;
   Rs.Xm := Xc;
   Rs.Ym := Yc;
   BlockWrite(F,RS,SizeOf(RS));
   try
    GetMem(Dat,RS.Xm*RS.Ym);
    for i := 0 to Xc-1 do
     for j := 0 to Yc-1 do
      PByteArray(Dat)^[i*Yc+j] :=
       (CellA.CA1[i,j] + NSkey*CellA.CA2[i,j]) mod 256;
    BlockWrite(F,Dat^,RS.Xm*RS.Ym);
   finally
    FreeMem(Dat);
   end;
  finally
   CloseFile(F)
  end;
 end;

 procedure TFormCA.SetBufr(Value : Boolean);
 begin
  FBufr := Value;
 end;


procedure TFormCA.SetRev(Value: Boolean);
begin
 FRev := Value;
 InvAct.Enabled := FRev;
 BackStepAct.Enabled := FRev;
 RunBackAct.Enabled := FRev;
 RenewMenu1.Enabled := FRev
  and (CellA.CARul.fxy < f_special);
 with
  Reversible1 do
  if Checked <> Value then Checked := Value;
 Buffer1.Enabled := FRev;
end;

procedure TFormCA.SpecialRule1Click(Sender: TObject);
var
 SpDat : TLSpecDat;
begin
with OpenDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> 'CLL' then FileName := '';
  DefaultExt := 'CLL';
  Filter := 'Special Rule (*.cll)|*.CLL|Any file (*.*)|*.*';
  if Execute then
  begin
   if LoadSpecLL(SpDat,FileName) then
   with CellA do
   begin
    CARul.Free;
    CARul := LocRulSpecLL.Create(SpDat);
    mp := mtOther;
    Nstat := CARul.Ns;
    RuleName := ChangeFileExt(ExtractFileName(FileName),'');
    CheckColorPal(FileName);
    CheckCapCA;
   end
   else ShowMessage('Wrong file type');
  end;
 end;

end;

procedure TFormCA.Reversible1Click(Sender: TObject);
begin
 SetRev(Reversible1.Checked);
end;

procedure TFormCA.RevTab1Click(Sender: TObject);
begin
 SaveGTabl(trRev);
end;

procedure TFormCA.Life1Click(Sender: TObject);
begin
 CellA.CARul.Free;
 CellA.CARul := LocRulLife.Create;
 NStat := CellA.CARul.Ns;
 mp := mtMap;
 RuleName := 'Life';
 CheckCapCA;
end;

procedure TFormCA.SaveMapAs1Click(Sender: TObject);
var
 DefExt : string;
begin
 case mp of
  mtMap : DefExt := 'MAP';
  mtTree :  DefExt :='MPT';
  mtOther :
     if CellA.CARul.CheckCap(capSaveMap)
      then DefExt := 'MAP'
      else Exit
 end;
 with SaveDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> DefExt then FileName := '';
  DefaultExt := DefExt;
  Filter := 'CART rule file (*.'+LowerCase(DefExt)+')|*.'+DefExt+
  '|All files (*.*)|*.*';
  if (FileName = '') and (Pos('/',RuleName)=0)
   then FileName := RuleName;
  if Execute then
  try
   Screen.Cursor := crHourGlass;
   CellA.SaveMAPFile(FileName);
  finally
   Screen.Cursor := crDefault;
  end;
 end;
end;

procedure TFormCA.OpenMap1Click(Sender: TObject);
var
 Ext : string;
 AskPal : Boolean;
begin
 AskPal := True;
 with OpenDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> 'MAP' then FileName := '';
  DefaultExt := 'MAP';
  Filter := 'All CART rules files (*.map,*.mpt,*.tb3)|*.MAP;*.MPT;*.tb3'
   +'|MAP rules files (*.map)|*.MAP;'
   +'|Map "tb3" rules files (*.tb3)|*.tb3;'
   +'|MPT tree rules files (*.mpt)|*.MPT;'
   +'|Golly tree files (*.tree)|*.tree';
  if Execute then
  begin
   Ext := UpperCase(ExtractFileExt(FileName));
   with CellA do
   if Ext = '.MAP' then
   begin
    if mp <> mtMap then
    begin
      CARul.Free;
      CARul := nil;
    end;
    try
     Screen.Cursor := crHourGlass;
     LoadMAPFile(FileName,False);
    finally
     Screen.Cursor := crDefault;
    end;
    RuleName := ChangeFileExt(ExtractFileName(FileName),'');
    mp := mtMap;
   end
   else
    if Ext = '.TB3' then
    with CellA do
    begin
     CellA.CARul.Free;
     CellA.CARul := LocRulDLife.Create(FileName);
     mp := mtMap;
     RuleName := ChangeFileExt(ExtractFileName(FileName),'');
    end
    else
     if (Ext = '.TREE') or (Ext = '.MPT') then
     begin
      mp := mtTree;
      if Ext = '.TREE' then SetRev(False);
      CARul.Free;
      try
       Screen.Cursor := crHourGlass;
       CARul := LocRulSpecTree.Create(FileName);
      finally
       Screen.Cursor := crDefault;
      end;
      RuleName := ChangeFileExt(ExtractFileName(FileName),'');
      if FileExistsUTF8(ChangeFileExt(FileName,'.colors')) { *Converted from FileExists*  } then
       if MessageDlg('Read Golly color table?',
        mtConfirmation,[mbYes,mbNo],0) = mrYes then
       try
        NStat := CellA.CARul.Ns;
        SetLength(StCols,NStat);
        DblPal := False;
        ReadGCellColors(StCols,
         ChangeFileExt(FileName,'.colors'));
        AskPal := False;
        FullPaint;
       except
        on E : Exception do
         ShowMessage('Error reading color table');
       end;
     end;
   NStat := CellA.CARul.Ns;
   if AskPal then CheckColorPal(FileName);
   CheckCapCA;
  end;
 end;
end;

procedure TFormCA.Drive1Click(Sender: TObject);
begin
 CellA.CARul.Free;
 CellA.CARul :=  LocRulDLife.Create(
 [1,2, 2,1], [1,1, 1,2, 2,0, 2,1]);
 {0.75,1.25,2.7,3.5,1.8,3.7);}
 NStat := CellA.CARul.Ns;
 mp := mtMap;
 RuleName := 'Drive';
 CheckCapCA;
end;

procedure TFormCA.Cyclic1Click(Sender: TObject);
begin
 with CellA.CARul do
 if Cyclic1.Checked then
  BndKnd := tbkCycl
 else
  BndKnd := tbkZero
end;

procedure TFormCA.MenuMapClick(Sender: TObject);
begin
 Cyclic1.Checked := (CellA.CARul.BndKnd = tbkCycl)
end;

procedure TFormCA.MenuReadColorsClick(Sender: TObject);
begin
 with OpenDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> 'CCL' then FileName := '';
  DefaultExt := 'CCL';
  Filter := 'CAR palette file (*.ccl)|*.ccl';
  if Execute then
  try
   Screen.Cursor := crHourGlass;
   ReadColorPal(FileName);
   FullPaint;
  finally
   Screen.Cursor := crDefault;
  end;
 end;
end;

procedure TFormCA.MenuSaveColorsClick(Sender: TObject);
begin
 with SaveDialog1 do
 begin
  FilterIndex := 1;
  if DefaultExt <> 'CCL' then FileName := '';
  DefaultExt := 'CCL';
  Filter := 'CAR palette file (*.ccl)|*.ccl';
  if Pos('/',RuleName)=0 then FileName := RuleName;
  if Execute then
  try
   Screen.Cursor := crHourGlass;
   WriteColorPal(FileName,true);
  finally
   Screen.Cursor := crDefault;
  end;
 end;
end;

procedure TFormCA.About1Click(Sender: TObject);
begin
 DlgAboutCar.ShowModal
end;

procedure TFormCA.ReadColorPal(PalFileName: String);
var
 FI : TextFile;
 s : string;
 l,n,i,c1,c2,c3,d1,d2,d3 : integer;
begin
 try
   AssignFile(FI,PalFileName);
   Reset(FI);
   Readln(FI,s);
   if s <> sPalSig then
      Raise EInOutError.Create('Wrong palette format');
   Readln(FI,l,n);
   case n of
    1 :
     begin
      DblPal := false;
      SetLength(StCols,l);
      for i := 0 to l - 1 do
      begin
        Readln(FI,c1);
        StCols[i] := TColor(c1);
      end;
     end;
    2 :
     begin
      DblPal := true;
      SetLength(StCols,2*l);
      for i := 0 to l - 1 do
      begin
        Readln(FI,c1,d1);
        StCols[i] := TColor(c1);
        StCols[i+l] := TColor(d1);
      end;
     end;
    3 :
     begin
      DblPal := false;
      SetLength(StCols,l);
      for i := 0 to l - 1 do
      begin
        Readln(FI,c1,c2,c3);
        StCols[i] := TColor(c1+256*(c2+256*c3));
      end;
     end;
    6 :
     begin
      DblPal := true;
      SetLength(StCols,2*l);
      for i := 0 to l - 1 do
      begin
        Readln(FI,c1,c2,c3,d1,d2,d3);
        StCols[i] := TColor(c1+256*(c2+256*c3));
        StCols[i+l] := TColor(d1+256*(d2+256*d3));
      end;
     end;
   else
    Raise EInOutError.Create('Wrong palette items number');
   end;
 finally
   CloseFile(FI);
 end;
end;

procedure TFormCA.WriteColorPal(PalFileName: String; UseHex : Boolean);
var
 FO : TextFile;
 i,l : integer;
 FmtNum : String;
begin
 try
   AssignFile(FO,PalFileName);
   Rewrite(FO);
   Writeln(FO,sPalSig);
   if UseHex then FmtNum :=  '$%x'
   else FmtNum := '%d';
   if DblPal then
   begin
     l := Length(StCols) div 2;
     Writeln(FO,l,' 2');
     for i := 0 to l - 1 do
      Writeln(FO,Format(FmtNum+' '+FmtNum,
       [ColorToRGB(StCols[i]),ColorToRGB(StCols[i+l])]))
   end
   else
   begin
     l := Length(StCols);
     Writeln(FO,l,' 1');
     for i := 0 to l - 1 do
      Writeln(FO,Format(FmtNum,[ColorToRGB(StCols[i])]))
   end;

 finally
   CloseFile(FO);
 end;

end;

procedure TFormCA.ReadMe1Click(Sender: TObject);
begin
 ReadMeForm.Perform
end;

procedure TFormCA.RenewMenu1Click(Sender: TObject);
begin
 case CellA.CARul.fxy of
   fx_plus_y :  OldPlusNew.Checked := True;
   fx_minus_y : NewMinusOld.Checked := True;
   y_minus_fx : OldMinusNew.Checked := True;
   f_special,f_spec_rev  : RenewMenu1.Enabled := False;
 end;
end;

procedure TFormCA.RenewOptClick(Sender: TObject);
begin
  with CellA.CARul do
  if fxy < f_special then
   if OldPlusNew.Checked then fxy := fx_plus_y
   else
    if NewMinusOld.Checked then fxy := fx_minus_y
    else
     if OldMinusNew.Checked then fxy := y_minus_fx;
end;

end.
