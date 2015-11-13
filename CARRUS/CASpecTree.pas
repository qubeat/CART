unit CASpecTree;


{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

 uses SysUtils, CARules2, GollyFiles, CA2Tree, CARulTree, USpecl;

type
 SwapCells =  array of array [boolean] of NCell;
 SpecTab = array of array of SwapCells;


 LocRulSpecTree = class(LocRulTree)
    FNs2 : array of integer;
    FunUpd : SpecTab;
    FunSwap : SwapStates;
   public
    constructor Create(FileName : String); overload;
    constructor Create(CloneCA : LocRul2CA); overload;
    destructor Destroy; override;
    function Ns2(C1 : NCell = 0) : Integer; override;
    procedure CalcLocCells(var NewCell : XCell; var Cells : TLocCells);
  override;
    procedure SaveMap(var FO : TextFile); override;
    procedure LoadMap(var FI : TextFile; ChkSig : Boolean = True); override;
    procedure UpdateCell(var C1,C2 : NCell; back : Boolean); override;
    procedure ApplyXCell(var C2 : NCell; C1 : NCell;
                         XC : XCell; back : Boolean); override;
   end;

 function TrTreeMaxElt(var TranTree : CAIntMatrix) : Integer;

implementation

function TrTreeMaxElt(var TranTree : CAIntMatrix) : Integer;
var
 i,j,M : Integer;
begin
 M := 0;
 for i := 0 to Length(TranTree) - 1 do
 if TranTree[i,0] = 1 then {}
  for j := 1 to Length(TranTree[i]) - 1 do
   if TranTree[i,j] > M then M := TranTree[i,j];
 Result := M;
end;

{ LocRulSpecTree }

procedure LocRulSpecTree.CalcLocCells(var NewCell : XCell; var Cells : TLocCells);
var
  n,i : Integer;
begin
  n := Length(TranTree)-1;
  for i := 0 to Nx - 1 do
   n := TranTree[n,Cells[i]+1];
  NewCell := n;
end;

constructor LocRulSpecTree.Create(FileName: String);
var
 FI : TextFile;
 Ext : string;
begin
 inherited Create(0);
 DefCap := capRevStep + capSaveMap + capLoadMap;
 try
   Assign(FI,FileName);
   Reset(FI);
   Ext := UpperCase(ExtractFileExt(FileName));
   if Ext = '.TREE' then
     ReadGlyTree(Self,TranTree,FI)
   else
    LoadMap(FI);
 finally
   Close(FI);
   if fxy <> f_spec_rev then
    DefCap := DefCap or capIrrevStep;
   if (Ns = 2) and (fxy < f_special) then
    DefCap := DefCap or capInvert;

 end;
end;

constructor LocRulSpecTree.Create(CloneCA : LocRul2CA);
var
 i,j,k,n : integer;
 C1,C2 : NCell;
 SameOrd : boolean;
 StOrd : array of integer;
begin
 inherited Create(CloneCA.Ns);
 DefCap := CloneCA.DefCap or (capSaveMap + capLoadMap);
 Nx := CloneCA.Nx;
 SetLength(Neib,Nx);
 for i := 0 to Nx - 1 do
 begin
   Neib[i].DX := CloneCA.Neib[i].DX;
   Neib[i].DY := CloneCA.Neib[i].DY
 end;
 CreateTree(TranTree,CloneCA);
 fxy := CloneCA.fxy;
 if fxy >= f_special then
 begin
  DefCap := capRevStep  + capSaveMap + capLoadMap;
  if fxy <> f_spec_rev then
   DefCap := DefCap or capIrrevStep;
  SetLength(FNs2,Ns);
  for i := 0 to Ns - 1 do
   FNs2[i] := CloneCA.Ns2(i);
  FNsr := CloneCA.Nsr;
  SetLength(FunSwap,FNsr);
  for i := 0 to NSr - 1 do
  begin
   CloneCA.SplitC12(i,C1,C2);
   CloneCA.UpdateCell(C1,C2,false);
   FunSwap[i,false] := CloneCA.JoinC12(C1,C2);
  end;
  for i := 0 to Nsr - 1 do
    FunSwap[FunSwap[i,false],true] := i;
  FillJoinSplitArrays;
  n := TrTreeMaxElt(TranTree) + 1;
  SetLength(FunUpd,Ns);
  for i := 0 to Length(FunUpd) - 1 do
  begin { Ns }
    SetLength(FunUpd[i],n);
    for j := 0 to n-1 do
    begin { Nxc }
      SetLength(FunUpd[i,j],CloneCA.Ns2(i));
      for k := 0 to Length(FunUpd[i,j]) - 1 do
      begin
        C2 := k;
        CloneCA.ApplyXCell(C2,i,j,false);
        FunUpd[i,j,k,false] := C2;
      end;
      for k := 0 to Length(FunUpd[i,j]) - 1 do
       FunUpd[i,j,FunUpd[i,j,k,false],true] := k
    end;
  end;
 end;
 SetLength(StOrd,Nsr);
 SameOrd := True;
 {Find order}
 for i := 0 to Nsr - 1 do
 begin
  CloneCA.SplitC12(i,C1,C2);
  StOrd[i] := JoinC12(C1,C2);
  if StOrd[i] <> i then SameOrd := false;
 end;
 if not SameOrd then
 begin
  SetLength(Reorder,Nsr);
  for i := 0 to Nsr - 1 do
  begin
   Reorder[i,false] := StOrd[i];
   Reorder[StOrd[i],true] := i
  end;
  {Correct swap}
  for i := 0 to Nsr - 1 do
   StOrd[i] := Reorder[FunSwap[Reorder[i,true],false],false];
  for i := 0 to Nsr - 1 do
   FunSwap[i,false] := StOrd[i];
  for i := 0 to Nsr - 1 do
   FunSwap[FunSwap[i,false],true] := i;
 end;
 StOrd := nil;
end;

destructor LocRulSpecTree.Destroy;
begin
  Finalize(FNs2);
  Finalize(FunUpd);
  Finalize(FunSwap);
  inherited;
end;

function LocRulSpecTree.Ns2(C1 : NCell): Integer;
begin
 if fxy >= f_special then
  Ns2 := FNs2[C1]
 else
  Result := inherited Ns2(C1);
end;

procedure LocRulSpecTree.LoadMap(var FI: TextFile; ChkSig : Boolean = True);
var
  i,j,k,n,v,aux,upd,NNodes : integer;
  s : string;
begin
  v := 0;
  if ChkSig then
  begin
   readln(FI,s);
   if s = sMapTreeSig+'1' then v := 1
   else
    if s = sMapTreeSig+'2' then v := 2
    else
     if s = sMapTreeSig+'3' then v := 3
     else
      Raise EInOutError.Create('Wrong MAP-Tree File format');
  end;
  Readln(FI,S); {NCell}
  Readln(FI,AuxMask);
  Readln(FI,Ns);
  Readln(FI,Nx);

  Neib := nil;
  SetLength(Neib,Nx);
  for i := 0 to Nx - 1 do
  with Neib[i] do
    readln(FI,DX,DY);

  Readln(FI,aux,NNodes);
  if (aux <> 1) then
    Raise EInOutError.Create('MAP-Tree File: Nonstandard nodes');
  SetLength(TranTree,NNodes,Ns+1);
  for i := 0 to NNodes - 1 do
  begin
    for j := 0 to Ns do
     Read(FI,TranTree[i,j]);
    Readln(FI)
  end;
  {* ------- Special ---------- *}
  if v >= 2 then
  begin
   readln(FI,upd);
   fxy := Tfxupd(upd);
   DefCap := DefCap or capIrrevStep;
   if fxy = f_spec_rev then
     DefCap := DefCap - capIrrevStep;
   DefCap := DefCap or capInvert;
   if (Ns <> 2) or (fxy >= f_special) then
    DefCap := DefCap - capInvert;
   SetLength(FNs2,Ns);
   for i := 0 to Ns - 1 do
    read(FI,FNs2[i]);
   readln(FI);
   readln(FI,FNsr);
   FillJoinSplitArrays;
   SetLength(FunSwap,FNsr);
   for i := 0 to Nsr - 1 do
    read(FI,FunSwap[i,false]);
   readln(FI);
   for i := 0 to Nsr - 1 do
    FunSwap[FunSwap[i,false],true] := i;
   readln(FI,n);
   if n <> Ns then
    Raise EInOutError.Create('MAP-Tree File: Nonstandard update');
   SetLength(FunUpd,Ns);
   for i := 0 to Length(FunUpd) - 1 do
   begin { Ns }
    readln(FI,n);
    SetLength(FunUpd[i],n);
    for j := 0 to n-1 do
    begin { Nxc }
      SetLength(FunUpd[i,j],Ns2(i));
      for k := 0 to Length(FunUpd[i,j]) - 1 do
        read(FI,FunUpd[i,j,k,false]);
      readln(FI);
      for k := 0 to Length(FunUpd[i,j]) - 1 do
       FunUpd[i,j,FunUpd[i,j,k,false],true] := k
    end;
   end;
   if v = 3 then
   begin
    readln(FI,n);
    if (n = FNsr) then
    begin
     SetLength(Reorder,FNsr);
     for i := 0 to Nsr - 1 do
     read(FI,Reorder[i,true]);
     readln(FI);
     for i := 0 to Nsr - 1 do
      Reorder[Reorder[i,true],false] := i;
    end
   end;
  end;
end;

procedure LocRulSpecTree.SaveMap(var FO: TextFile);
var
  i,j,k,n,aux : integer;
begin
 if fxy >= f_special then
 begin
  if Reorder = nil then
   writeln(FO,sMapTreeSig+'2')
  else
   writeln(FO,sMapTreeSig+'3');
  writeln(FO,SizeOf(NCell)*8,' ;NCELL');
  writeln(FO,AuxMask, ' ;MASK');
  writeln(FO,Ns);
  writeln(FO,Nx);
  aux:=1;
  for i := 0 to Nx - 1 do
  with Neib[i] do
   writeln(FO,DX,' ',DY);
  writeln(FO,aux,' ',Length(TranTree));
  for i := 0 to Length(TranTree) - 1 do
   begin
     for j := 0 to Ns+aux-1 do
      Write(FO,' ',TranTree[i,j]);
     Writeln(FO)
   end;
  {* ------- Special ---------- *}
  writeln(FO,ord(fxy), ' ;Fxy');
  for i := 0 to Ns - 1 do
   write(FO,' ',Ns2(i));
  writeln(FO);
  writeln(FO,Nsr,' ;Nsr');
  for i := 0 to Nsr - 1 do
   write(FO,' ',FunSwap[i,false]);
  writeln(FO);
  writeln(FO,Length(FunUpd),' ',Ns);
  for i := 0 to Length(FunUpd) - 1 do
  begin { Ns }
    n := Length(FunUpd[i]);
    writeln(FO,n);
    for j := 0 to n-1 do
    begin { Nxc }
      for k := 0 to Length(FunUpd[i,j]) - 1 do
        write(FO,' ',FunUpd[i,j,k,false]);
      writeln(FO)
    end;
  end;
  if Reorder <> nil then
  begin
   writeln(FO,Nsr);
   for i := 0 to Nsr - 1 do
    write(FO,' ',Reorder[i,true]);
   writeln(FO);
  end
 end
 else
  inherited SaveMap(FO)
end;

procedure LocRulSpecTree.ApplyXCell(var C2 : NCell; C1 : NCell;
                             XC : XCell; back : Boolean);
begin
 if fxy >= f_special then
  C2 := FunUpd[C1,XC,C2,back]
 else
  inherited ApplyXCell(C2,C1,XC,back);
end;

procedure LocRulSpecTree.UpdateCell(var C1, C2: NCell; back: Boolean);
var
  St : XCell;
begin
  if fxy >= f_special then
  begin
   St := JoinC12(C1,C2);
   if Reorder <> nil then St := Reorder[St,false];
   St := FunSwap[St,back];
   if Reorder <> nil then St := Reorder[St,true];
   SplitC12(St,C1,C2);
  end
  else
   inherited UpdateCell(C1,C2,back);
end;

end.

