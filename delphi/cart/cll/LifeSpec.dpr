library LifeSpec;

uses
  {SysUtils, Classes,} CARules2Int;

{$R *.res}
{$E cll}

function LibVerCAR(var ANs : Integer;
 var fxu :  Tfxupd) : Integer; stdcall;
begin
  ANs := 2;
  fxu := f_special;
  LibVerCAR := 1
end;

procedure InitCAR(var ANs,ANx,ANsr : Integer); stdcall;
begin
  ANs := 2;
  ANx := 9;
  ANsr := 4;
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
 i,n : integer;
begin
  n := 0;
  for i := 0 to 8 do
    n := n + Cells[i];
  if Cells[4] = 0 then
   if n = 3 then NewCell := 1 else NewCell := 0
  else
   if (n = 3) or (n=4) then NewCell := 1 else NewCell := 0
end;

procedure UpdCell(var C1,C2 : NCell; back : Boolean); stdcall;
var
 C : NCell;
begin
 C := C1; C1 := C2; C2 := C;
end;

procedure ApplXC(var C2 : NCell; C1 : NCell;
                         XC : XCell; back : Boolean); stdcall;

begin
 C2 := (C2 + XC) mod 2
end;

exports LibVerCAR, InitCAR, SetNeib, GetNs2, CalcCells, UpdCell, ApplXC;
begin
end.
