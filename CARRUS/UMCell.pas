unit UMCell;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  dynlibs,
  //LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Graphics, GollyFiles, CARules2;

type

TMCARul = function (Generation,col,row,
                NW,N, NE,
                W, Me,E,
                SW,S, SE: Integer): Integer; stdcall;

TMCASetup = procedure (var RuleType, CountOfColors: Integer;
              ColorPalette, Misc: PChar); stdcall;

TMCAdat = record
  HLibr : THandle;
  MCARul : TMCARul;
  MCASetup : TMCASetup;
  NCol : Integer;
 end;

LocRulMCellDll = class(LocRulCAm)
  MCAdat : TMCAdat;
 public
  constructor Create(var Dat : TMCAdat); overload;
  destructor Destroy; override;
  procedure CalcLocCells(var NewCell : XCell; var Cells : TLocCells);
   override;
end;

function LoadMCellDll(var MCAdat : TMCAdat; var PalName : String;
 DLLName : String) : Boolean;

procedure ReadMCellColors(var Cols : TCellColors; FileName : String);


implementation

function LoadMCellDll(var MCAdat : TMCAdat; var PalName : String;
 DLLName : String) : Boolean;
var
  CPal,CMisc : array[0..255] of Char;
  RT : integer;
begin
  Result := False;
  with MCAdat do
  begin
   HLibr := LoadLibrary(PChar(DLLName));
   if HLibr > 0 then
   begin
     @MCASetup := GetProcAddress(HLibr,'CASetup');
     if @MCASetup <> nil then
     begin
       @MCARul := GetProcAddress(HLibr,'CARule');
       if @MCARul <> nil then
       begin
        CMisc[0] := #0;
        MCASetup(RT,NCol,@CPal,@CMisc);
        if RT = 2 then
        begin
         PalName := PChar(@CPal);
         Result := True;
        end;
       end;
     end;
     if not Result then FreeLibrary(HLibr);
   end;
  end;
end;


{ LocRulMCellDll }

procedure LocRulMCellDll.CalcLocCells(var NewCell: XCell; var Cells: TLocCells);
begin
  NewCell := MCADat.MCARul(1,1,1,Cells[0],Cells[1],Cells[2],
   Cells[3],Cells[4],Cells[5],Cells[6],Cells[7],Cells[8])
end;

constructor LocRulMCellDll.Create(var Dat: TMCAdat);
var
 i : integer;
begin
  inherited Create(Dat.NCol);
  MCAdat := Dat;
  Nx := 9;
  SetLength(Neib,Nx);
  for i := 0 to 8 do
   Neib[i] := DirsToVecs(CellRel(i))

end;

destructor LocRulMCellDll.Destroy;
begin
  FreeLibrary(MCAdat.HLibr);
  inherited Destroy;
end;

procedure ReadMCellColors(var Cols : TCellColors; FileName : String);
var
 FI : TextFile;
 n,col : integer;
 S : string;
begin
try
   Assign(FI,FileName);
   Reset(FI);
   Cols[0] := clBlack;
   while not Eof(FI) do
   begin
     readln(FI,S);
     if (S <> '') and (Pos('#STATE',S) = 1) then
     begin
       S := Copy(S,7,MaxInt);
       GetNextNum(S,n);
       GetNextNum(S,col);
       if n<Length(Cols) then
        Cols[n] := TColor(col)
     end;
   end;
 finally
   Close(FI);
 end;
end;

end.
