unit CARulTree;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

 uses SysUtils, CARules2, GollyFiles, CA2Tree, USpecl;

const
 sMapTreeSig = 'MAP CAT';


type

 LocRulTree = class(LocRulSpec)
    TranTree : CAIntMatrix;
   public
    constructor Create(FileName : String); overload;
    constructor Create(CloneCA : LocRul2CA); overload;
    destructor Destroy; override;
    procedure CalcLocCells(var NewCell : XCell; var Cells : TLocCells);
  override;
    procedure SaveMap(var FO : TextFile); override;
    procedure LoadMap(var FI : TextFile; ChkSig : Boolean = True); override;
   end;



implementation

{ LocRulTree }


procedure LocRulTree.CalcLocCells(var NewCell : XCell; var Cells : TLocCells);
var
  n,i : Integer;
begin
  n := Length(TranTree)-1;
  for i := 0 to Nx - 1 do
   n := TranTree[n,Cells[i]+1];
  NewCell := n;
end;

constructor LocRulTree.Create(FileName: String);
var
 FI : TextFile;
 Ext : string;
begin
 inherited Create(0);
 DefCap := capIrrevStep + capRevStep + capInvert
     + capSaveMap + capLoadMap;
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
 end;
end;

constructor LocRulTree.Create(CloneCA : LocRul2CA);
var
 i : integer;
begin
 inherited Create(CloneCA.Ns);
 DefCap := capIrrevStep + capRevStep + capInvert
     + capSaveMap + capLoadMap;
 Nx := CloneCA.Nx;
 SetLength(Neib,Nx);
 for i := 0 to Nx - 1 do
 begin
   Neib[i].DX := CloneCA.Neib[i].DX;
   Neib[i].DY := CloneCA.Neib[i].DY
 end;
 CreateTree(TranTree,CloneCA)
end;

destructor LocRulTree.Destroy;
begin
  TranTree := nil;
  inherited;
end;

procedure LocRulTree.LoadMap(var FI: TextFile; ChkSig : Boolean = True);
var
  i,j,aux,NNodes : integer;
  s : string;
begin
  if ChkSig then
  begin
   readln(FI,s);
   if s <> sMapTreeSig+'1' then
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
end;

procedure LocRulTree.SaveMap(var FO: TextFile);
var
  i,j,aux : integer;
begin
  writeln(FO,sMapTreeSig+'1');
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
end;

end.
