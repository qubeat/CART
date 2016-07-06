unit GollyFiles;

interface

uses SysUtils, Graphics, CARules2;

const
 sPrefNSt = 'num_states=';
 sPrefNNei = 'num_neighbors=';
 sPrefNNod = 'num_nodes=';


type
 
 CellRel = (cNorthWest,cNorth,cNorthEast,
            cWest,cCenter,cEast,
            cSouthWest,cSouth,cSouthEast);

 TCellColors = array of TColor;

 tRevOrNot = (trIrRev,trRev,trRevInv);

const
 TreeNeibNeum : array[0..4] of CellRel
  = (cNorth,cWest,cEast,cSouth,cCenter);
 TreeNeibMoore : array[0..8] of CellRel
  = (cNorthWest,cNorthEast,cSouthWest,cSouthEast,
    cNorth,cWest,cEast,cSouth,cCenter);

 TabNeibNeum  : array[0..4] of CellRel
   = (cCenter,cNorth,cEast,cSouth,cWest);
 TabNeibMoore : array[0..8] of CellRel
  = (cCenter,cNorth,cNorthEast,cEast,cSouthEast,
     cSouth,cSouthWest,cWest,cNorthWest);

function DirsToVecs(Dir : CellRel) : DVec;

procedure ReadGlyTree(LCA : LocRul2CA;
 var TranTree : CAIntMatrix;
 var FI : TextFile);

procedure ReadGCellColors(var Cols : TCellColors; FileName : String);

procedure ReadGPattern(x0,y0 : integer; CAF : CAField; FileName : String;
 IsRev : Boolean = False);

function GetNextNum(var S : string; var n : integer) : boolean;

procedure WriteGPattern(x1,y1,x2,y2 : integer; CAF : CAField;
 IsRev,IsBnd : Boolean; RuleName, FileName : String);

procedure WriteGlyTab(LCA : LocRul2CA; tron : tRevOrNot;
 var FO : TextFile; WriteAll : Boolean = false);

implementation

function GetNextNum(var S : string; var n : integer) : boolean;
var
 er,er0 : integer;
begin
  Result := true;
  val(S,n,er);
  if er = 0 then S := ''
  else
   if er=1 then Result := False
   else
    begin
      val(Copy(S,1,er-1),n,er0);
      S := Copy(S,er,MaxInt);
    end;


end;

function DirsToVecs(Dir : CellRel) : DVec;
begin
  with Result do
  begin
    DX := Ord(Dir) mod 3 - 1;
    DY := Ord(Dir) div 3 - 1;
  end;
end;

procedure ReadGlyTree(LCA : LocRul2CA;
 var TranTree : CAIntMatrix;
 var FI : TextFile);
var
 s : string;
 NNei,NNodes,i,j : integer;
begin
 with LCA do
 begin
   Readln(FI,s);
   if Pos(sPrefNSt,s) = 1 then
    Ns := StrToInt(Copy(s,Length(sPrefNSt)+1,MaxInt))
   else
    Raise EInOutError.Create('Format error: not '+sPrefNSt);
   Readln(FI,s);
   if Pos(sPrefNNei,s) = 1 then
    NNei := StrToInt(Copy(s,Length(sPrefNNei)+1,MaxInt))
   else
    Raise EInOutError.Create('Format error: not '+sPrefNNei);
   case NNei of
    4 :
     begin
      Nx := NNei+1;
      SetLength(Neib,Nx);
      for i := 0 to Nx-1 do
        Neib[i] := DirsToVecs(TreeNeibNeum[i])
     end;
    8 :
     begin
      Nx := NNei+1;
      SetLength(Neib,Nx);
         for i := 0 to Nx-1 do
      Neib[i] := DirsToVecs(TreeNeibMoore[i])
     end
    else
      Raise EInOutError.Create(
       'Format error: unsupported '+s);
   end;
   Readln(FI,s);
   if Pos(sPrefNNod,s) = 1 then
    NNodes := StrToInt(Copy(s,Length(sPrefNNod)+1,MaxInt))
   else
    Raise EInOutError.Create('Format error: not '+sPrefNNod);
   SetLength(TranTree,NNodes,Ns+1);
   for i := 0 to NNodes - 1 do
   begin
     for j := 0 to Ns do
      Read(FI,TranTree[i,j]);
     Readln(FI)
   end;
 end
end;


procedure ReadGCellColors(var Cols : TCellColors; FileName : String);
 {Array Cols should be set to necessary length}
 {Colors with bigges index would not assigned}
var
 FI : TextFile;
 n,cr,cg,cb : integer;
 S : string;
begin
try
   Assign(FI,FileName);
   Reset(FI);
   Cols[0] := clBlack;
   while not Eof(FI) do
   begin
     readln(FI,S);
     if (S <> '') and (S[1] <> '#') then
     begin
       n := Pos('=',S);
       S := Copy(S,n+1,MaxInt);
       GetNextNum(S,n);
       GetNextNum(S,cr);
       GetNextNum(S,cg);
       GetNextNum(S,cb);
       if n<Length(Cols) then
        Cols[n] := TColor(cr+256*(cg+256*cb))
     end;
   end;
 finally
   Close(FI);
 end;
end;




procedure ReadGPattern(x0,y0 : integer; CAF : CAField; FileName : String;
 IsRev : Boolean);
var
 FI : TextFile;
 S : string;
 i,n,c,x,y : integer;
 wr,eow : boolean;
begin
 x := x0; y := y0;
 try
  Assign(FI,FileName);
  Reset(FI);
  eow := false;
  while not (Eof(FI) or eow) do
  begin
   readln(FI,S);
   if (S <> '') and (S[1] <> '#') then
    if S[1] <> 'x' then
    begin
     n := 1; c := 0; wr := false;
     repeat
        case S[1] of
           '0'..'9' :
            begin
             GetNextNum(S,n);
             wr := false;
            end;
           '!' :
            begin
              S := '';
              wr := false;
              eow := true;
            end;
           '$' :
            begin
              y := y+n;
              x := x0;
              n := 1;
              S:=Copy(S,2,MaxInt);
              wr := false;
            end;
           '.','b' :
            begin
             c := 0; S:=Copy(S,2,MaxInt);
             wr := true;
            end;
           'o' :
            begin
             c := 1; S:=Copy(S,2,MaxInt);
             wr := true;
            end;
           'A' .. 'X' :
            begin
             c := ord(S[1])-ord('A')+1;
             S:=Copy(S,2,MaxInt);
             wr := true;
            end;
           'p' .. 'y' :
            begin
             c := 24*(ord(S[1])-ord('p')+1)
                     + ord(S[2])-ord('A')+1;
             S:=Copy(S,3,MaxInt);
             wr := true;
            end;

          end;
      if wr then
      begin
       for i := 0 to n-1 do
       with CAF do
       if IsRev then
        CA12[(x+i+SizeX) mod SizeX,(y+SizeY) mod SizeY] := c
       else
        CA1[(x+i+SizeX) mod SizeX,(y+SizeY) mod SizeY] := c;
       x := x+n;
       n := 1;
       wr := false;
      end;
     until (S = '');
    end;
  end;

 finally
  Close(FI);
 end;
end;

function C2S(C : byte) : string;
begin
  case C of
   0 : C2S := '.';
   1 .. 24 : C2S := chr(ord('A')+ C - 1);
   25 .. 255 : C2S := chr((C-25) div 24 + ord('p'))
                    + chr((C-25) mod 24 + ord('A'));
  end;

end;



procedure WriteGPattern(x1,y1,x2,y2 : integer; CAF : CAField;
  IsRev,IsBnd : Boolean; RuleName,FileName : String);
var
 FO : TextFile;
 S : string;
 i,j : integer;
begin
  try
    Assign(FO,FileName);
    Rewrite(FO);
    Writeln(FO,'# CART output without compression');
    Writeln(FO);
    Write(FO,'x = ',x2-x1+1,', y = ',y2-y1+1,
     ', rule = ');
    if IsRev then Write(FO,'Rev',RuleName)
    else Write(FO,RuleName);
    if IsBnd then
    case CAF.CARul.BndKnd of
      tbkCycl: Write(FO,':T',CAF.GetSizeX,',',CAF.GetSizeY);
      tbkZero: Write(FO,':P',CAF.GetSizeX,',',CAF.GetSizeY);
    end;
    Writeln(FO);
    Writeln(FO);
    for i := y1 to y2 do
    begin
      S := '';
      for j := x1 to x2 do
      if IsRev then
       S := S+C2S(CAF.CA12[j,i])
      else
       S := S+C2S(CAF.CA1[j,i]);
      if i = y2 then S := S+'!'
      else S := S+'$';
      writeln(FO,S);
    end;
  finally
    Close(FO);
  end;
end;


function CalcTabAny(TabNeib : array of CellRel;
         ni : array of integer;
         CAtst : CAField; tron : tRevOrNot) : integer;
var
 i,n : integer;
begin
 CATst.ClearArea;
 for i := 0 to Length(TabNeib)-1 do
 begin
   n := ni[i];
   with DirsToVecs(TabNeib[i]) do
   case tron of
     trIrRev: CATst.CA1[DX+1,DY+1] := n;
     trRev, trRevInv:
        CATst.CA12[DX+1,DY+1] := n
    end;
 end;
 case tron of
   trIrRev:
   begin
    CATst.CalcNew;
    Result := CATst.CA1[1,1]
   end;
   trRev, trRevInv:
   begin
    CATst.CalcNewRev(tron=trRevInv);
    Result := CATst.CA12[1,1]
   end;
 end;
end;


procedure WriteGlyTab(LCA : LocRul2CA; tron : tRevOrNot;
 var FO : TextFile; WriteAll : Boolean);
var
 i,i0,i1,i2,i3,i4,i5,i6,i7,i8,
 Nst,NNei : integer;
 CAtst : CAField;
 sep : string;
begin
  NNei := Length(LCA.Neib);
  if (NNei = 5) or (NNei = 9) then
  begin
    if tron = trIrRev then NSt := LCA.Ns
     else NSt := LCA.Nsr;
    if ((NNei = 9) and (NSt > 9))
      or ((NNei = 5) and (NSt > 64)) then
      Raise EInOutError.Create( 'Table size is too big');
    try
     CAtst := CAField.Create(nil);
     CAtst.ShareRule := True;
     CAtst.CARul := LCA;
     CAtst.SetArea(3,3);
     writeln(FO,'n_states:',NSt);
     if NSt > 10 then sep :=','
     else sep := '';
     case NNei of
     5 :
      begin
        writeln(FO,'neighborhood:vonNeumann');
        writeln(FO,'symmetries:none');
        for i0 := 0 to Nst-1 do
         for i1 := 0 to Nst-1 do
          for i2 := 0 to Nst-1 do
           for i3 := 0 to Nst-1 do
            for i4 := 0 to Nst-1 do
            begin
             i := CalcTabAny([cCenter,cNorth,cEast,cSouth,cWest],
               [i0,i1,i2,i3,i4],CAtst,tron);
             if WriteAll or (i <> i0) then
               writeln(FO,i0,sep,i1,sep,i2,sep,i3,sep,i4,sep,i)
            end;
      end;
     9 :
      begin
        writeln(FO,'neighborhood:Moore');
        writeln(FO,'symmetries:none');
        for i0 := 0 to Nst-1 do
         for i1 := 0 to Nst-1 do
          for i2 := 0 to Nst-1 do
           for i3 := 0 to Nst-1 do
            for i4 := 0 to Nst-1 do
             for i5 := 0 to Nst-1 do
              for i6 := 0 to Nst-1 do
               for i7 := 0 to Nst-1 do
                for i8 := 0 to Nst-1 do
                begin
                 i := CalcTabAny([cCenter,cNorth,cNorthEast,cEast,
                 cSouthEast,cSouth,cSouthWest,cWest,cNorthWest],
                 [i0,i1,i2,i3,i4,i5,i6,i7,i8],
                 CAtst,tron);
                 if WriteAll or (i <> i0) then
                  writeln(FO,i0,i1,i2,i3,i4,i5,i6,i7,i8,i)
                end;

      end;
     end
    finally
      CAtst.CARul := nil;
      CATst.Free;
    end
  end
  else
      Raise EInOutError.CreateFmt(
          'Unsupported neighborhood size %d',[NNei]);
end;


end.
