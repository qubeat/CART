// Life: MCell User DLL
//

library Life;  // Your DLL name, change by "Save Project as..." option of the File menu

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
  sum: Integer;
  newState: Integer;
begin

  sum := 0;
  If NW > 0 then Inc(sum);
  If N  > 0 then Inc(sum);
  If NE > 0 then Inc(sum);
  If W  > 0 then Inc(sum);
  If E  > 0 then Inc(sum);
  If SW > 0 then Inc(sum);
  If S  > 0 then Inc(sum);
  If SE > 0 then Inc(sum);

  newState := 0;
  if Me = 0 then // dead
  begin
    if sum = 3 then newState := 1;
  end
  else // alive
  begin
    if (sum = 2) or (sum = 3) then newState := Me + 1;
  end;
  CARule := newState;
end;
//
// Setup the rule.
// The function is called immediatelly after this rule is selected in MCell.
procedure CASetup(var RuleType, CountOfColors: Integer; ColorPalette, Misc: PChar); stdcall;
begin
  RuleType := 2;       // 1 - 1D, 2 - 2D
  CountOfColors := 5;  // count of states, 0..n-1
  StrCopy(ColorPalette, 'MCell standard');  // optional color palette specification
  StrCopy(Misc, '');   // optional extra parameters; none supported at the moment
end;

exports
  CARule  index 1,
  CASetup index 2;

begin
  // optional internal initialization.
end.
