unit BuildTree;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

 uses SysUtils, Classes,
  SortList, CARules2;

type
 PTreeRec = ^TreeRec;
 TreeRec = Record
   IDX : Integer;
   aIDX : Array of Integer;
 end;

 TSortTreeRecList = class(TSortList)
    constructor Create;
    function CompareItems(const I1, I2: Pointer): Integer; override;
    destructor Destroy; override;
    function FindOrIns(var Rec : TreeRec) : Integer;
 end;

 TreeBuilder = class
   NS,NNeib : Integer;
   Recs : array of PTreeRec;
   Lists : array of TSortTreeRecList;
   constructor Create(N,Nn : Integer);
   destructor Destroy; override;
   function CalcCells(var Cells : TLocCells) : XCell; virtual;
   procedure BuildLists;
   function CalcNode(lev : integer; var Cells : TLocCells) : Integer;
   procedure ConvListsToTree(var Tr : CAIntMatrix);
   procedure DumpLists(var FO : TextFile);
 end;

implementation

{ TSortTreeRecList }

function TSortTreeRecList.CompareItems(const I1, I2: Pointer): Integer;
var
 i,k,n : integer;
begin
 k := 0; i := 0;
 n := Length(PTreeRec(I1)^.aIDX);
 while (k=0) and (i < n) do
 begin
   k :=  PTreeRec(I1)^.aIDX[i] - PTreeRec(I2)^.aIDX[i];
   if k > 0 then k:=1
   else if k < 0 then k:=-1;
   i := i+1;
 end;
 CompareItems := k;
end;

constructor TSortTreeRecList.Create;
begin
 inherited Create;
 FSorted := true;
end;

destructor TSortTreeRecList.Destroy;
var
 i : integer;
begin
  for i := 0 to Count - 1 do
  begin
    PTreeRec(Items[i])^.aIDX := nil;
    Dispose(PTreeRec(Items[i]));
  end;
  inherited Destroy;
end;

function TSortTreeRecList.FindOrIns(var Rec: TreeRec): Integer;
var
 Index,I : Integer;
 PT : PTreeRec;
begin
 if Find(@Rec,Index) then
  Result := PTreeRec(Items[Index])^.IDX
 else
 begin
  New(PT);
  PT^.IDX := Count;
  Result := Count;
  SetLength(PT^.aIDX,Length(Rec.aIDX));
  for I := 0 to Length(Rec.aIDX) - 1 do
   PT^.aIDX[I] := Rec.aIDX[I];
  Insert(Index,PT);
  PT := nil;
 end;
end;

{ TreeBuilder }

procedure TreeBuilder.BuildLists;
var
 Cells : TLocCells;
begin
 CalcNode(0,Cells);
end;

function TreeBuilder.CalcCells(var Cells: TLocCells): XCell;
begin
 Result := 0;
end;

function TreeBuilder.CalcNode(lev: integer;
  var Cells: TLocCells): Integer;
var
 i,n : integer;
begin
  Recs[lev]^.aIDX[0] := lev;
  for i := 0 to Ns-1 do
  begin
    Cells[lev] := i;
    if lev = Nneib-1 then
     n := CalcCells(Cells)
    else
     n := CalcNode(lev+1,Cells);
    Recs[lev]^.aIDX[i+1] := n;
  end;
  Result := Lists[lev].FindOrIns(Recs[lev]^)
end;

procedure TreeBuilder.ConvListsToTree(var Tr: CAIntMatrix);
var
 Nt,DN,DNn,I,J,IdJ,K : Integer;
begin
 Nt := 0;
 for I := 0 to NNeib - 1 do
  Nt := Nt + Lists[I].Count;
 SetLength(Tr,Nt,NS+1);
 DN := 0; DNn := 0;
 for I := NNeib - 1 downto 0 do
 with Lists[I] do
 begin
   for J := 0 to Count - 1 do
   begin
     IdJ := PTreeRec(Items[J])^.IDX;
     Tr[IdJ+DN,0] := NNeib - I;
     for K := 1 to NS do
       Tr[IdJ+DN,K] := DNn+PTreeRec(Items[J])^.aIdx[K]
   end;
   DNn := DN;
   DN := DN + Count;
 end;
end;

constructor TreeBuilder.Create(N,Nn: Integer);
var
 i : Integer;
 PT : PTreeRec;
begin
 NS := N;
 Nneib := Nn;
 SetLength(Recs,Nneib);
 SetLength(Lists,Nneib);
 for i := 0 to Nneib - 1 do
 begin
  New(PT);
  PT^.IDX := -1;
  SetLength(PT^.aIDX,NS + 1);
  PT^.aIDX[0] := i;
  Recs[i] := PT;
  Lists[i] := TSortTreeRecList.Create
 end;  

end;

destructor TreeBuilder.Destroy;
var
 i : Integer;
begin
  for i := 0 to Nneib - 1 do
  begin
    PTreeRec(Recs[i])^.aIDX := nil;
    Dispose(Recs[i]);
    Lists[i].Free;
  end;
  Recs := nil;
  Lists := nil;
  inherited Destroy;
end;

procedure TreeBuilder.DumpLists(var FO: TextFile);
var
 I,J,K : integer;
begin
 for I := 0 to Nneib - 1 do
 with Lists[I] do
 begin
   writeln(FO,'I:',I);
   for J := 0 to Count - 1 do
   with PTreeRec(Items[J])^ do
   begin
    for k := 0 to Length(aIdx) - 1 do
      write(FO,aIdx[k],' ');
     writeln(FO,'J:',J,',IDX:',Idx);
   end;

     
 end;

end;

end.
