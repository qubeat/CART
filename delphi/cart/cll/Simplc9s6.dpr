library Simplc9s6;

uses
  {SysUtils, Classes,} CARules2Int;

{$R *.res}
{$E cll}

function LibVerCAR(var ANs : Integer;
 var fxu :  Tfxupd) : Integer; stdcall;
begin
  ANs := 3;
  fxu := f_special;
  LibVerCAR := 1
end;

procedure InitCAR(var ANs,ANx,ANsr : Integer); stdcall;
begin
  ANs := 3;
  ANx := 9;
  ANsr := 6;
end;

procedure SetNeib(N : integer; var DX,DY : Integer); stdcall;
begin
   DX := N mod 3 - 1;
   DY := N div 3 - 1;
 end;

function GetNs2(C1 : NCell) : Integer; stdcall;
begin
  GetNs2 := 2;
end;

procedure CalcCells(var NewCell : XCell; var Cells : TLocCells); stdcall;
var
  sum,sumd: Integer;
const
 NW= 0; N = 1; NE= 2;
 W = 3; Me= 4; E = 5;
 SW= 6; S = 7; SE= 8;
begin
  sumd := Cells[NW]+Cells[NE]+Cells[SW]+Cells[SE];
  sum := Cells[W] div 2 +Cells[N] div 2 + Cells[S] div 2 + Cells[E] div 2;
  if (sumd = 0) and ((sum = 1) or (sum=2)) then
    NewCell := 1
  else NewCell := 0
end;


procedure UpdCell(var C1,C2 : NCell; back : Boolean); stdcall;
begin
 if C2 = 0 then
  if C1 > 0 then
  begin
   C1 := C1 - 1; C2 := 1 - C2
  end else {nothing}
 else
  if C1 < 2 then
  begin
   C1 := C1 + 1; C2 := 1 - C2
  end
end;

procedure ApplXC(var C2 : NCell; C1 : NCell;
                         XC : XCell; back : Boolean); stdcall;

begin
  C2 := (XC + C2) mod 2
end;

exports LibVerCAR, InitCAR, SetNeib, GetNs2, CalcCells, UpdCell, ApplXC;
begin
end.
