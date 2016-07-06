library Q2R2vN;

uses
  {SysUtils, Classes,} CARules2Int;

{$R *.res}
{$E cll}


function LibVerCAR(var ANs : Integer;
 var fxu :  Tfxupd) : Integer; stdcall;
begin
  ANs := 2;
  fxu := fx_plus_y;
  LibVerCAR := 1
end;

procedure InitCAR(var ANs,ANx,ANsr : Integer); stdcall;
begin
  ANs := 2;
  ANx := 5;
  ANsr := 4;
end;

procedure SetNeib(N : integer; var DX,DY : Integer); stdcall;
const
 vnNeib : array[0..4,0..1] of integer
 = ((0,-1),(-1,0),(0,0),(1,0),(0,1));
begin
  DX := vnNeib[N,0];
  DY := vnNeib[N,1];
end;


procedure CalcCells(var NewCell : XCell; var Cells : TLocCells); stdcall;
var
 i,n : integer;
begin
  n := 0;
  for i := 0 to 4 do
  if i <> 2 then
    n := n + Cells[i];
  if n = 2 then NewCell := 1 else NewCell := 0
end;

{****************************************

function GetNs2(C1 : NCell) : Integer; stdcall;
begin
  GetNs2 := 2;
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

********************************************}

exports LibVerCAR, InitCAR, SetNeib, {GetNs2, UpdCell, ApplXC,} CalcCells;
begin
end.
