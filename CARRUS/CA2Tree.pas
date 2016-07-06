unit CA2Tree;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses SysUtils, Classes,
  CARules2, BuildTree;

type

 TDecNeib = array of integer;

 CA3Build = class(TreeBuilder)
   FCARul : LocRul2CA;
   constructor Create(CA : LocRul2CA);
   function CalcCells(var Cells : TLocCells) : XCell; override;
  end;

  CA3BuildDec = class(TreeBuilder)
   FCARul : LocRul2CA;
   Decod : TDecNeib;
   constructor Create(CA : LocRul2CA; var ADec : TDecNeib);
   function CalcCells(var Cells : TLocCells) : XCell; override;
  end;

 TNeibDecoder = class
   function DecodeCells(CA : LocRul2CA; var Cells : TLocCells) : XCell;
    virtual; abstract;
 end;

 CA3BuildDecoder = class(TreeBuilder)
   FCARul : LocRul2CA;
   Decoder : TNeibDecoder;
   constructor Create(CA : LocRul2CA; NSt : integer; var ADecod : TNeibDecoder);
   destructor Destroy; override;
   function CalcCells(var Cells : TLocCells) : XCell; override;
  end;

 procedure CreateTree(var Tr: CAIntMatrix; CA : LocRul2CA);

 procedure CreateDecTree(var Tr: CAIntMatrix; CA : LocRul2CA;
  var ADec : TDecNeib); overload;

 procedure CreateDecTree(var Tr: CAIntMatrix; CA : LocRul2CA; NSt : integer;
  ADecoder : TNeibDecoder); overload;

implementation

{ CA3Build }

function CA3Build.CalcCells(var Cells: TLocCells): XCell;
begin
  FCARul.CalcLocCells(Result,Cells)
end;

constructor CA3Build.Create(CA: LocRul2CA);
begin
 inherited Create(CA.Ns,Ca.Nx);
 FCARul := CA;
end;

 procedure CreateTree(var Tr: CAIntMatrix; CA : LocRul2CA);
 var
  CA3B :  CA3Build;
 begin
  try
   CA3B := CA3Build.Create(CA);
   CA3B.BuildLists;
   CA3B.ConvListsToTree(Tr);
  finally
   CA3B.Free
  end;
 end;

{ CA3BuildDec }

function CA3BuildDec.CalcCells(var Cells: TLocCells): XCell;
var
 LCells : TLocCells;
 i : integer;
begin
 for i := 0 to Length(Decod) - 1 do
  LCells[Decod[i]] := Cells[i];
 FCARul.CalcLocCells(Result,LCells)
end;

constructor CA3BuildDec.Create(CA: LocRul2CA; var ADec: TDecNeib);
begin
 inherited Create(CA.Ns,Ca.Nx);
 FCARul := CA;
 Decod := ADec;
end;

procedure CreateDecTree(var Tr: CAIntMatrix; CA : LocRul2CA;
  var ADec : TDecNeib);
var
  CA3B :  CA3BuildDec;
 begin
  try
   CA3B := CA3BuildDec.Create(CA,ADec);
   CA3B.BuildLists;
   CA3B.ConvListsToTree(Tr);
  finally
   CA3B.Free
  end;
 end;

{ CA3BuildDecoder }

function CA3BuildDecoder.CalcCells(var Cells: TLocCells): XCell;
begin
 Result := Decoder.DecodeCells(FCARul,Cells);
end;

constructor CA3BuildDecoder.Create(CA: LocRul2CA; NSt : integer; var ADecod: TNeibDecoder);
begin
 inherited Create(Nst,Ca.Nx);
 FCARul := CA;
 Decoder := ADecod;
end;

destructor CA3BuildDecoder.Destroy;
begin
  Decoder.Free;
  inherited Destroy;
end;

 procedure CreateDecTree(var Tr: CAIntMatrix; CA : LocRul2CA; NSt : integer;
  ADecoder : TNeibDecoder);
 var
  CA3B :  CA3BuildDecoder;
 begin
  try
   CA3B := CA3BuildDecoder.Create(CA,NSt,ADecoder);
   CA3B.BuildLists;
   CA3B.ConvListsToTree(Tr);
  finally
   CA3B.Free
  end;
 end;

end.
