unit SaveGTree;

interface

uses SysUtils, CARules2, GollyFiles, CA2Tree;

type

TRev2TreeDec = class(TNeibDecoder)
  Decod : TDecNeib;
  back : boolean;
  constructor Create(var ADec : TDecNeib; bk : boolean);
  function DecodeCells(CA : LocRul2CA; var Cells : TLocCells) : XCell;
    override;
end;


function SaveGlyTree(LCA : LocRul2CA; FName : String) : Boolean;

function SaveGlyTreeRev(LCA : LocRul2CA; FName : String;
 back : Boolean) : Boolean;

function SaveGlyTrees(LCA : LocRul2CA;
 IrFName,RevFName,RevInvFName : String) : Boolean;

procedure ConvTrToRev(LCA : LocRul2CA; var TrTree,TrTree2 : CAIntMatrix);

procedure ConvTrToRevInv(LCA : LocRul2CA; var TrTree,TrTree2 : CAIntMatrix);


implementation

procedure CheckDecod(LCA : LocRul2CA; var Decod : TDecNeib;
   var Need,Err : boolean);
var
 i,j,k : integer;
 Neib,TreeNeib : array [0..8] of Integer;
begin
  Err := True;
  case LCA.Nx of
  5 :  for i := 0 to LCA.Nx - 1 do
        TreeNeib[i] := Ord(TreeNeibNeum[i]);
  9 :  for i := 0 to LCA.Nx - 1 do
        TreeNeib[i] := Ord(TreeNeibMoore[i]);
  else
   Exit
 end;
 for i := 0 to LCA.Nx - 1 do
 with LCA.Neib[i] do
   Neib[i] := 3*DY+DX+4;
 k := 0;
 for i := 0 to LCA.Nx - 1 do
 if Neib[i] <> TreeNeib[i] then k := -1;
 if k=0 then
 begin
   if Need then
   begin
     SetLength(Decod,LCA.Nx);
     for i := 0 to LCA.Nx - 1 do
      Decod[i] := i;
   end;
   Need := False;
 end
 else
  begin
    Need := True;
    SetLength(Decod,LCA.Nx);
    for i := 0 to LCA.Nx - 1 do
    begin
     k := -1;
     for j := 0 to LCA.Nx - 1 do
      if Neib[j] = TreeNeib[i] then k := j;
     Decod[i] := k;
     if k=-1 then Exit;
    end;
  end;
  Err := False;
end;

procedure WriteTrTree(Ns,Nx : Integer; var TrTree : CAIntMatrix;
   FName : String);
var
  i,j : integer;
  FO : TextFile;
begin
 try
    AssignFile(FO,FName);
    Rewrite(FO);
    Writeln(FO,sPrefNSt,Ns);
    Writeln(FO,sPrefNNei,Nx-1);
    Writeln(FO,sPrefNNod,Length(TrTree));
    for i := 0 to Length(TrTree) - 1 do
    begin
      for j := 0 to Length(TrTree[i]) - 1 do
      begin
       if j <> 0 then Write(FO,' ');
       Write(FO,TrTree[i,j]);
      end;
      Writeln(FO);
    end;
 finally
    CloseFile(FO);
 end;
end;


function SaveGlyTree(LCA : LocRul2CA; FName : String) : Boolean;
var
 TrTree : CAIntMatrix;
 Decod : TDecNeib;
 NeedDecod,Err : Boolean;
begin
 Result := False;
 NeedDecod := False;
 CheckDecod(LCA,Decod,NeedDecod,Err);
 if Err then Exit;

 if NeedDecod then
   CreateDecTree(TrTree,LCA,Decod)
 else
   CreateTree(TrTree,LCA);

 WriteTrTree(LCA.Ns,LCA.Nx,TrTree,FName);
 Finalize(TrTree);
 Result := True;
end;

procedure ConvTrToRev(LCA : LocRul2CA; var TrTree,TrTree2 : CAIntMatrix);
var
  i,j,k,n2 : integer;
  C1,C2 : NCell;
begin
  n2 := LCA.Nsr;
  if TrTree2 = nil then
    SetLength(TrTree2,Length(TrTree),n2+1);
  for i := 0 to Length(TrTree) - 1 do
  begin
    k := TrTree[i,0];
    TrTree2[i,0] := k;
    with LCA do
    if k=1 then
     for j := 0 to n2 - 1 do
     begin
       SplitC12(j,C1,C2);
       ApplyXCell(C2,C1,TrTree[i,C1+1],false);
       UpdateCell(C1,C2,false);
       TrTree2[i,j+1] := JoinC12(C1,C2)
     end
    else
      for j := 0 to n2 - 1 do
      begin
       SplitC12(j,C1,C2);
       TrTree2[i,j+1] := TrTree[i,C1+1]
      end;
  end;
end;

procedure ConvTrToRevInv(LCA : LocRul2CA; var TrTree,TrTree2 : CAIntMatrix);
var
  i,j,k,n2 : integer;
  C1,C2 : NCell;
begin
  n2 := LCA.Nsr;
  if TrTree2 = nil then
    SetLength(TrTree2,Length(TrTree),n2+1);
  for i := 0 to Length(TrTree) - 1 do
  begin
    k := TrTree[i,0];
    TrTree2[i,0] := k;
    with LCA do
    if k=1 then
     for j := 0 to n2 - 1 do
     begin
       SplitC12(j,C1,C2);
       UpdateCell(C1,C2,true);
       ApplyXCell(C2,C1,TrTree[i,C1+1],true);
       TrTree2[i,j+1] := JoinC12(C1,C2)
     end
    else
      for j := 0 to n2 - 1 do
      begin
       SplitC12(j,C1,C2);
       UpdateCell(C1,C2,true);
       TrTree2[i,j+1] := TrTree[i,C1+1]
      end;
  end;
end;

function SaveGlyTrees(LCA : LocRul2CA; IrFName,RevFName,RevInvFName : String) : Boolean;
var
 TrTree,TrTree2 : CAIntMatrix;
 Decod : TDecNeib;
 NeedDecod,Err : Boolean;
begin
 Result := False;
 NeedDecod := False;
 CheckDecod(LCA,Decod,NeedDecod,Err);
 if Err then Exit;

 if NeedDecod then
   CreateDecTree(TrTree,LCA,Decod)
 else
   CreateTree(TrTree,LCA);

 if IrFName <> '' then
  WriteTrTree(LCA.Ns,LCA.Nx,TrTree,IrFName);

 TrTree2 := nil;
 if RevFName <> '' then
 begin
  ConvTrToRev(LCA,TrTree,TrTree2);
  WriteTrTree(LCA.Nsr,LCA.Nx,TrTree2,RevFName);
 end;
 if RevInvFName <> '' then
 begin
  ConvTrToRevInv(LCA,TrTree,TrTree2);
  WriteTrTree(LCA.Nsr,LCA.Nx,TrTree2,RevInvFName);
 end;
 Finalize(TrTree);
 Finalize(TrTree2);
 Result := True;
end;

function SaveGlyTreeRev(LCA : LocRul2CA; FName : String; back : Boolean) : Boolean;
var
 TrTree : CAIntMatrix;
 Decod : TDecNeib;
 NeedDecod,Err : Boolean;
 Decoder : TRev2TreeDec;
begin
 Result := False;
 NeedDecod := True;
 CheckDecod(LCA,Decod,NeedDecod,Err);
 if Err then Exit;

 Decoder := TRev2TreeDec.Create(Decod,back);
 CreateDecTree(TrTree,LCA,LCA.NSr,Decoder);

 WriteTrTree(LCA.Nsr,LCA.Nx,TrTree,FName);

 Finalize(TrTree);
 Result := True;
end;


{ TRev2TreeDec }

constructor TRev2TreeDec.Create(var ADec: TDecNeib; bk: boolean);
begin
  inherited Create;
  Decod := ADec;
  back := bk;
end;

function TRev2TreeDec.DecodeCells(CA : LocRul2CA; var Cells : TLocCells) : XCell;
var
 LCells1,LCells2 : TLocCells;
 i,me : integer;
 XC : XCell;
begin
 with CA do
 begin
  for i := 0 to Length(Decod) - 1 do
   SplitC12(Cells[i],LCells1[Decod[i]],LCells2[Decod[i]]);
  if back then
   for i := 0 to Length(Decod) - 1 do
    UpdateCell(LCells1[i],LCells2[i],back);
  CalcLocCells(XC,LCells1);
  me := Decod[Nx-1];
  ApplyXCell(LCells2[me],LCells1[me],XC,back);
  if not back then
   UpdateCell(LCells1[me],LCells2[me],back);
  Result := JoinC12(LCells1[me],LCells2[me]);
 end;

end;

end.
