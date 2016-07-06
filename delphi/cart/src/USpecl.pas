unit USpecl;

interface

uses SysUtils, Windows, CARules2;

type

 TLibVerCAR = function(var ANs : Integer; var fxu :  Tfxupd) : Integer; stdcall;

 TLInitCAR = procedure(var ANs,ANx,ANsr : Integer); stdcall;

 TLSetNeib = procedure(N : integer; var DX,DY : Integer); stdcall;

 TLGetNs2 = function(C1 : NCell) : Integer; stdcall;

 TLCalcCells =  procedure (var NewCell : XCell; var Cells : TLocCells); stdcall;

 TLUpdCell = procedure (var C1,C2 : NCell; back : Boolean); stdcall;

 TLApplXC =  procedure (var C2 : NCell; C1 : NCell;
                         XC : XCell; back : Boolean); stdcall;

 TLSpecDat = record
   HLibr : THandle;
   LNs : Integer;
   LFx : TFxupd;
   LInitCAR : TLInitCAR;
   LSetNeib : TLSetNeib;
   LGetNs2 : TLGetNs2;
   LCalcCells : TLCalcCells;
   LUpdCell : TLUpdCell;
   LApplXC : TLApplXC;
 end;

 SwapStates = array of array [boolean] of XCell;

 LocRulSpec = class(LocRul2CA)
    FNsr : Integer;
    Reorder : SwapStates;
  private
    JoinArr : array of array of Integer;
    SplitArr : array[0..1] of array of Integer;
  public
    constructor Create(aNs : Integer);
    destructor Destroy; override;
    function Nsr : Integer; override;
    procedure FillJoinSplitArrays;
    function JoinC12(C1,C2 : Integer) : Integer; override;
    procedure SplitC12(C12 : Integer; var C1,C2 : NCell); override;
    function JoinC21(C1,C2 : Integer) : Integer;
    procedure SplitC21(C21 : Integer; var C1,C2 : NCell);
 end;

 LocRulSpecLL = class(LocRulSpec)
  private
    LSpecDat : TLSpecDat;
  public
    function Ns2(C1 : NCell = 0) : Integer; override;
    procedure CalcLocCells(var NewCell : XCell; var Cells : TLocCells); override;
    constructor Create(Dat : TLSpecDat);
    destructor Destroy; override;
    procedure UpdateCell(var C1,C2 : NCell; back : Boolean); override;
    procedure ApplyXCell(var C2 : NCell; C1 : NCell;
                          XC : XCell; back : Boolean); override;

 end;

 function LoadSpecLL(var Dat : TLSpecDat; DLLName : String) : Boolean;

implementation


function DefaultGetNs2(C1 : NCell) : Integer; stdcall;
begin
  Result := 2;
end;

procedure DefaultUpdCell(var C1,C2 : NCell; back : Boolean); stdcall;
var
 C : NCell;
begin
 C := C1; C1 := C2; C2 := C;
end;

procedure DefaultApplXC(var C2 : NCell; C1 : NCell;
                         XC : XCell; back : Boolean); stdcall;

begin
 C2 := (C2 + XC) mod 2
end;


function CheckNil(var OK : Boolean; ptr : pointer) : pointer;
begin
 Result := ptr;
 if ptr = Nil then OK := False;
end;

function LoadSpecLL(var Dat : TLSpecDat; DLLName : String) : Boolean;
var
 InitLib : TLibVerCAR;
 OK : Boolean;
begin
  Result := False;
  with Dat do
  begin
   HLibr := LoadLibrary(PChar(DLLName));
   if HLibr > 0 then
   begin
     @InitLib := GetProcAddress(HLibr,'LibVerCAR');
     if (@InitLib <> nil) and (InitLib(LNs,LFx) = 1) then
     begin
       OK := True;
       @LInitCAR := CheckNil(OK,GetProcAddress(HLibr,'InitCAR'));
       @LSetNeib := CheckNil(OK,GetProcAddress(HLibr,'SetNeib'));
       @LCalcCells := CheckNil(OK,GetProcAddress(HLibr,'CalcCells'));
       if LFx >= f_special then
       begin
        @LGetNs2 := CheckNil(OK,GetProcAddress(HLibr,'GetNs2'));
        @LUpdCell := CheckNil(OK,GetProcAddress(HLibr,'UpdCell'));
        @LApplXC := CheckNil(OK,GetProcAddress(HLibr,'ApplXC'));
       end
       else
       begin
        @LGetNs2 := @DefaultGetNs2;
        @LUpdCell := @DefaultUpdCell;
        @LApplXC := @DefaultApplXC;
       end;
       Result := OK;
     end;
     if not Result then FreeLibrary(HLibr);
   end;
  end;
end;

{ LocRulSpecLL }

procedure LocRulSpecLL.ApplyXCell(var C2: NCell; C1: NCell; XC: XCell;
  back: Boolean);
begin
 with LSpecDat do
 if LFx >= f_special then
   LApplXC(C2,C1,XC,back)
 else
  inherited ApplyXCell(C2,C1,XC,back);
end;

procedure LocRulSpecLL.CalcLocCells(var NewCell: XCell; var Cells: TLocCells);
begin
 LSpecDat.LCalcCells(NewCell,Cells);
end;

constructor LocRulSpecLL.Create(Dat: TLSpecDat);
var
 i : integer;
begin
 inherited Create(Dat.LNs);
 DefCap := capRevStep;
 LSpecDat := Dat;
 fxy := Dat.LFx;
 Dat.LInitCAR(Ns,Nx,FNsr);
 if Dat.LNs <> Ns then
  Raise EInOutError.Create('Wrong Library DLL');
 SetLength(Neib,Nx);
 for i := 0 to Nx-1 do
  with Neib[i] do
    Dat.LSetNeib(i,DX,DY);
 if fxy <> f_spec_rev then
  DefCap := DefCap or capIrrevStep;
 if (Ns = 2) and (fxy = fx_plus_y) then
  DefCap := DefCap or capInvert;
 if fxy >= f_special then
  FillJoinSplitArrays
end;

destructor LocRulSpecLL.Destroy;
begin
  FreeLibrary(LSpecDat.HLibr);
  inherited Destroy;
end;

function LocRulSpecLL.Ns2(C1: NCell): Integer;
begin
 with LSpecDat do
 if LFx >= f_special then
  Result := LGetNs2(C1)
 else
  Result := inherited Ns2(C1);
end;



procedure LocRulSpecLL.UpdateCell(var C1, C2: NCell; back: Boolean);
begin
 with LSpecDat do
 if LFx >= f_special then
  LUpdCell(C1,C2,back)
 else
  inherited UpdateCell(C1,C2,back)

end;

{ LocRulSpec }

function LocRulSpec.Nsr: Integer;
begin
  if FNsr = 0 then
   Nsr := Ns*Ns
  else
   Nsr := FNsr
end;

constructor LocRulSpec.Create(aNs: Integer);
begin
 inherited Create(aNs);
 FNsr := 0;
 Reorder := nil;
end;

destructor LocRulSpec.Destroy;
begin
  Finalize(JoinArr);
  Finalize(SplitArr);
  Finalize(Reorder);
  inherited Destroy;
end;

procedure LocRulSpec.FillJoinSplitArrays;
var
 i,j,k,m,n : integer;
begin
 SetLength(JoinArr,Ns);
 n := 0; m := 0;
 for i := 0 to Ns-1 do
 begin
   k := Ns2(i);
   SetLength(JoinArr[i],k);
   n := n + k;
   if k > m then m := k;
 end;
 SetLength(SplitArr[0],n);
 SetLength(SplitArr[1],n);
 k := 0;
 for j := 0 to m - 1 do
  for i := 0 to Ns - 1 do
   if j<Length(JoinArr[i]) then
   begin
     JoinArr[i,j] := k;
     SplitArr[0,k] := i;
     SplitArr[1,k] := j;
     k:=k+1;
   end;
   
end;

function LocRulSpec.JoinC12(C1, C2: Integer): Integer;
begin
 if JoinArr = nil then
  Result := Inherited  JoinC12(C1,C2)
 else
  if Reorder = nil then
   Result := JoinArr[C1,C2]
  else
   Result := Reorder[JoinArr[C1,C2],true]
end;

procedure LocRulSpec.SplitC12(C12: Integer; var C1, C2: NCell);
var
 B12 : XCell;
begin
  if JoinArr = nil then
   Inherited SplitC12(C12,C1,C2)
  else
  begin
    if Reorder = nil then B12 := C12
    else B12 := Reorder[C12,false];
    C1 := SplitArr[0,B12];
    C2 := SplitArr[1,B12];
  end;
end;

function LocRulSpec.JoinC21(C1, C2: Integer): Integer;
var
 i,C : integer;
begin
 C := 0;
 for i := 0 to C1-1 do C := C + Ns2(i);
 Result := C + C2;
end;

procedure LocRulSpec.SplitC21(C21: Integer; var C1, C2: NCell);
var
 i,C : integer;
begin
 i := 0;
 C := C21;
 while C >= 0 do
 begin
   C := C-Ns2(i);
   i := i+1;
 end;
 C1 := i-1;
 C2 := Ns2(C1)+C
end;


end.
