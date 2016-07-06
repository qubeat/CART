// Simplc3s: MCell User DLL
//

library Simplc3s;  // Your DLL name, change by "Save Project as..." option of the File menu

uses
  SysUtils,
  Classes;

//
// Calculate the new state of the 'Me' cell.
function CARule(Generation,col,row,
                NW,N, NE,
                W, Me,E,
                SW,S, SE: Integer): Integer; stdcall;
var
  sum,sumd: Integer;
  newState: Integer;
const
  M : array[0..2] of integer = (0,1,1);

begin

  sumd := NW+NE+SW+SE;
  sum := M[N]+M[W]+M[S]+M[E];
  if (sumd = 0) and ((sum=1) or (sum=2)) then
   newState := (Me + 1) mod 3
  else newState := Me;
  CARule := newState;
end;
//
// Setup the rule.
// The function is called immediatelly after this rule is selected in MCell.
procedure CASetup(var RuleType, CountOfColors: Integer; ColorPalette, Misc: PChar); stdcall;
begin
  RuleType := 2;       // 1 - 1D, 2 - 2D
  CountOfColors := 3;  // count of states, 0..n-1
  StrCopy(ColorPalette, 'MCell standard');  // optional color palette specification
  StrCopy(Misc, '');   // optional extra parameters; none supported at the moment
end;

exports
  CARule  index 1,
  CASetup index 2;

begin
  // optional internal initialization.
end.
