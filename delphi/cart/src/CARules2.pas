unit CARules2;

interface

uses
 SysUtils;

const
 sMapSig = 'MAP CA1';
 MaxNeib = 64;

{Capabilities}

capIrrevStep = $01;
capRevStep   = $02;
capInvert    = $04;
capSaveMap   = $08;
capLoadMap   = $10;

var
 DumpLocRule : Boolean = false;

type

 NCell = byte;
 XCell = integer;

 DVec = record
  DX,DY : Integer;
 end;

 scdTab = array[0..1,0..4,0..4] of Shortint;

 CACells = array of array of NCell;

 CAIntMatrix =  array of array of Integer;

 TNeibs =  array of DVec;
 TLocRuls =  array of NCell;
 TLocCells =  array[0..MaxNeib-1] of NCell;

 TBndKnd = (tbkCycl,tbkZero);

 Tfxupd = (fx_plus_y,fx_minus_y,y_minus_fx,f_special,f_spec_rev);

  LocRul2CA = class
    Ns : Integer;
    Nx : Integer;
    BndKnd : TBndKnd;
    fxy : Tfxupd;
    AuxMask : NCell;
    Neib : TNeibs;
    DefCap : Integer;
   public
    function Nsr : Integer; virtual;
    function Ns2(C1 : NCell = 0) : Integer; virtual;
    function Npars(Kind : Integer; St : Integer = 0) : Integer; virtual;
    function JoinC12(C1,C2 : Integer) : Integer; virtual;
    procedure SplitC12(C12 : Integer; var C1,C2 : NCell); virtual;
    procedure CalcLocCells(var NewCell : XCell; var Cells : TLocCells); virtual;
     abstract;
    constructor Create(aNs : Integer);
    destructor Destroy; override;
    function CalcOne(var CArea : CACells; MaxX,MaxY,X,Y : Integer) : NCell;
    procedure CalcCell(var NewCell : XCell; var CArea : CACells;
     MaxX,MaxY,X,Y : Integer); virtual;
    procedure SaveMap(var FO : TextFile); virtual;
     abstract;
    procedure LoadMap(var FI : TextFile; ChkSig : Boolean = True); virtual;
     abstract;
    procedure BoundCond(var X,Y : Integer; MaxX,MaxY : Integer;
     var UseC : boolean; var C : NCell); virtual;
    function CheckCap(cap : integer) : Boolean; virtual;
    procedure UpdateCell(var C1,C2 : NCell; back : Boolean); virtual;
    procedure ApplyXCell(var C2 : NCell; C1 : NCell;
                         XC : XCell; back : Boolean); virtual;
   end;

  LocRulCAm = class(LocRul2CA)
   public
    constructor Create(aNs : Integer);
    procedure SaveMap(var FO : TextFile); override;
  end;

  LocRul2CA2 = class(LocRul2CA)
    FNs2 : Integer;
  public
    constructor Create(aNs,aNs2 : Integer);
    function Nsr : Integer; override;
    function Ns2(C1 : NCell = 0) : Integer; override;
  end;


  LocRulCAtab = class(LocRul2CA)
    LocRul : TLocRuls;
   public
    procedure CalcLocCells(var NewCell : XCell; var Cells : TLocCells);
      override;
    constructor Create(aNs : Integer);
    destructor Destroy; override;
    procedure SaveMap(var FO : TextFile); override;
    procedure LoadMap(var FI : TextFile; ChkSig : Boolean = True); override;
   end;

   LocRulLife = class(LocRulCAtab)
    constructor Create;
   end;

   LocRulDLife = class(LocRulCAtab)
    constructor Create(kd,kc,b0,b1,l0,l1 : single); overload;
    constructor Create(burn,surv : array of shortint); overload;
    constructor Create(SCDName : string; FromFile : Boolean = true); overload;
    procedure FillSCD(var tab : scdTab);
   end;


   CAField = class
    function GetSizeX : Integer;
    function GetSizeY : Integer;
    function GetCA12(I,J : Integer) : Integer; virtual;
    procedure SetCA12(I,J,Value : Integer); virtual;
   public
    CARul : LocRul2CA;
    CA1,CA2 : CACells;
    ShareRule : Boolean;
    constructor Create(ARule : LocRulCAtab);
    destructor Destroy; override;
    procedure CalcNew; virtual;
    procedure CalcNewRev(back : boolean = false); virtual;
    procedure SetArea(X,Y : Integer);
    procedure ClearArea;
    procedure SwapAreas;
    procedure UpdateAreas(back : boolean = false); virtual;
    procedure SaveMapFile(FileName : String);
    function LoadMapFile(FileName : String; New : Boolean) : Boolean;
    function NumCells(var CA : CACells) : Integer;
    function CenterCells(var CA : CACells) : DVec;
    property SizeX : integer read GetSizeX;
    property SizeY : integer read GetSizeY;
    property CA12[I,J : Integer] : Integer read GetCA12 write SetCA12;
   end;



implementation

 { LocRul2CA }

   constructor LocRul2CA.Create(aNs : Integer);
   begin
    inherited Create;
    Ns := aNs;
    Nx := 0;
    AuxMask := $FF;
    BndKnd := tbkCycl;
    fxy := fx_plus_y;
    Neib := nil;
    DefCap := capIrrevStep + capRevStep + capInvert;
   end;

  destructor LocRul2CA.Destroy;
  begin
   Neib := nil;
   inherited Destroy;
  end;

  function LocRul2CA.JoinC12(C1, C2: Integer): Integer;
  begin
    Result := C2*Ns + C1;
  end;

  procedure LocRul2CA.CalcCell(var NewCell: XCell; var CArea: CACells; MaxX, MaxY,
    X, Y: Integer);
   var
    Xc,Yc,i : Integer;
    UseC : boolean;
    C,CAr : NCell;
    Cells : TLocCells;
   begin
    for i := 0 to Nx-1 do
    begin
     Xc := X+Neib[i].DX;
     Yc := Y+Neib[i].DY;
     if (Xc >= 0) and (Xc < MaxX)
     and (Yc >= 0) and (Yc < MaxY) then
      CAr := CArea[Xc,Yc] and AuxMask
     else
     begin
      BoundCond(Xc,Yc,MaxX,MaxY,UseC,C);
      if UseC then CAr := C
      else CAr := CArea[Xc,Yc] and AuxMask
     end;
     Cells[i] := CAr;
    end;
    CalcLocCells(NewCell,Cells);
   end;

   function LocRul2CA.CalcOne(var CArea : CACells;
    MaxX,MaxY,X,Y : Integer) : NCell;
   var
    C : XCell;
   begin
     C := 0;
     CalcCell(C,CArea,MaxX,MaxY,X,Y);
     CalcOne := C;
   end;

   function LocRul2CA.CheckCap(cap: integer): Boolean;
   begin
    Result := ((cap and DefCap) = cap)  {flags}
   end;

   procedure LocRul2CA.ApplyXCell(var C2 : NCell; C1 : NCell;
     XC : XCell; back : Boolean);
   var
    k1,k2 : integer;
   begin
     k1 := 1; k2:=1;
     case fxy of
       fx_plus_y,f_special,f_spec_rev:
             if back then
                begin k1:=-1; k2:=-1 end
             else k2 := 1;
       fx_minus_y: k2 := -1;
       y_minus_fx:
             if not back then
                begin k1:=-1; k2:=-1 end
             else k2 := 1;
     end;
    C2 := (Ns + k1*(XC + k2*C2)) mod Ns
   end;

   procedure LocRul2CA.BoundCond(var X,Y : Integer; MaxX,MaxY : Integer;
     var UseC : boolean; var C : NCell);
   begin
    case BndKnd of
     tbkCycl :
      begin
       if X < 0 then X := X+MaxX
        else if X >= MaxX then X := X - MaxX;
       if Y < 0 then Y := Y+MaxY
        else if Y >= MaxY then Y := Y - MaxY;
       UseC := false
      end;
     tbkZero:
      begin
       UseC := true;
       C := 0;
      end;
     end; {case}
   end;

   function LocRul2CA.Npars(Kind : Integer; St : Integer): Integer;
   begin
     Npars := Ns2(St);
   end;

   function LocRul2CA.Ns2(C1 : NCell): Integer;
   begin
    Ns2 := Ns;
   end;

   function LocRul2CA.Nsr: Integer;
   begin
    Nsr := sqr(Ns);
   end;


   procedure LocRul2CA.SplitC12(C12: Integer; var C1, C2: NCell);
   begin
     C1 := C12 mod Ns;
     C2 := C12 div Ns;
   end;

   procedure LocRul2CA.UpdateCell(var C1, C2: NCell; back: Boolean);
   var
    Sw : NCell;
   begin
     Sw := C1; C1 := C2; C2 := Sw;
   end;

{ LocRulCAtab }

   procedure LocRulCAtab.CalcLocCells(var NewCell : XCell; var Cells : TLocCells);
   var
    i,Idx : integer;
   begin
    Idx := 0;
    for i := 0 to Nx - 1 do
     Idx := Ns*Idx+Cells[i];
    NewCell := LocRul[Idx];
   end;

   constructor LocRulCAtab.Create(aNs : Integer);
   begin
    inherited Create(aNs);
    LocRul := nil;
    DefCap := capIrrevStep + capRevStep + capInvert
     + capSaveMap + capLoadMap;
   end;

   destructor LocRulCAtab.Destroy;
   begin
    LocRul := nil;
    inherited Destroy;
   end;





   procedure LocRulCAtab.SaveMap(var FO : TextFile);
   var
    i : integer;
   begin
    writeln(FO,sMapSig);
    writeln(FO,SizeOf(NCell)*8,' ;NCELL');
    writeln(FO,AuxMask, ' ;MASK');
    writeln(FO,Ns);
    writeln(FO,Nx);
    for i := 0 to Nx - 1 do
    with Neib[i] do
    writeln(FO,DX,' ',DY);
    writeln(FO,'1 1 ',Length(LocRul));
    for i := 0 to Length(LocRul)-1 do
     writeln(FO,LocRul[i]);
   end;

   procedure LocRulCAtab.LoadMap(var FI : TextFile; ChkSig : Boolean = True);
   var
    i,b1,b2,nr : integer;
    s : string;
   begin
    if ChkSig then
    begin
     Readln(FI,S);
     if s <> sMapSig then
      Raise EInOutError.Create('Wrong MAP File format');
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
    Readln(FI,b1,b2,nr);
    if (b1 <> 1) or (b2 <> 1) then
      Raise EInOutError.Create('MAP File: Nonstandard Block');
    LocRul := nil;
    SetLength(LocRul,nr);
    for i := 0 to nr - 1 do
     readln(FI,LocRul[i]);
   end;


{ LocRulLife }

   constructor LocRulLife.Create;
   var
    i,i0,i1,i2,i3,i4,i5,i6,i7,i8,
    s,ind,v : integer;
   begin
    inherited Create(2);
    AuxMask := 1;
    Nx := 9;
    SetLength(Neib,9);
    SetLength(LocRul,512);
    for i := 0 to 8 do
    with Neib[i] do
    begin
     DX := i mod 3 - 1;
     DY := i div 3 - 1;
    end;
    for i0 := 0 to 1 do
     for i1 := 0 to 1 do
      for i2 := 0 to 1 do
       for i3 := 0 to 1 do
        for i4 := 0 to 1 do
         for i5 := 0 to 1 do
          for i6 := 0 to 1 do
           for i7 := 0 to 1 do
            for i8 := 0 to 1 do
    begin
     ind := i0+2*(i1+2*(i2+2*(i3+2*(i4+
               2*(i5+2*(i6+2*(i7+2*i8)))))));
     s := i0+i1+i2+i3+ i5+i6+i7+i8;
     if i4 = 0 then
      if s = 3 then v := 1 else v := 0
     else
      if (s=2) or (s=3) then v := 1 else v := 0;
     LocRul[ind] := v
    end;
   end;

{ LocRulDLife }

   procedure LocRulDLifeDump(FileName : string;
    kd,kc,b0,b1,l0,l1 : single);
   var
    FO : TextFile;
    si,ci,di,
    v : integer;
    s : single;
   begin
    try
    AssignFile(FO,FileName);
    Rewrite(FO);
    for si := 0 to 1 do
    for ci := 0 to 4 do
    for di := 0 to 4 do
    begin
     s := kd*di+kc*ci;
     if si = 0 then
      if (s >= b0) and (s <= b1) then v := 1 else v := 0
     else
      if (s >= l0) and (s <= l1) then v := 1 else v := 0;
     write(FO,'s:',si,' c:',ci,' d:',di,' -> ',v);
     if si <> v then writeln(FO,' *') else writeln(FO);
    end;
    finally
     CloseFile(FO);
    end;
   end;


   constructor LocRulDLife.Create(kd,kc,b0,b1,l0,l1 : single);
   var
    i,i0,i1,i2,i3,i4,i5,i6,i7,i8,
    ind,v : integer;
    s : single;
   begin
    inherited Create(2);
    AuxMask := 1;
    Nx := 9;
    SetLength(Neib,9);
    SetLength(LocRul,512);
    for i := 0 to 8 do
    with Neib[i] do
    begin
     DX := i mod 3 - 1;
     DY := i div 3 - 1;
    end;
    for i0 := 0 to 1 do
     for i1 := 0 to 1 do
      for i2 := 0 to 1 do
       for i3 := 0 to 1 do
        for i4 := 0 to 1 do
         for i5 := 0 to 1 do
          for i6 := 0 to 1 do
           for i7 := 0 to 1 do
            for i8 := 0 to 1 do
    begin
     ind := i0+2*(i1+2*(i2+2*(i3+2*(i4+
               2*(i5+2*(i6+2*(i7+2*i8)))))));
     s := kd*(i0+i2+i6+i8)+kc*(i1+i3+i5+i7);
     if i4 = 0 then
      if (s >= b0) and (s <= b1) then v := 1 else v := 0
     else
      if (s >= l0) and (s <= l1) then v := 1 else v := 0;
     LocRul[ind] := v
    end;
    if DumpLocRule then
     LocRulDLifeDump('LocRul.DMP',kd,kc,b0,b1,l0,l1);
   end;

   procedure SetSCDTab(var tab : scdTab; s,c,d : shortint);
   var
    i : integer;
   begin
    if (c >= 0) and (d >= 0) then tab[s,c,d] := 1
    else
    if c = -1 then
     for i := 0 to 4 do tab[s,i,d] := 1
    else
    if d = -1 then
     for i := 0 to 4 do tab[s,c,i] := 1
    else
    if d = -2 then
     for i := 0 to c do
     if (c-i >= 0) and (c-i <= 4) and (i <= 4)
     then tab[s,i,c-i] := 1
   end;

   constructor LocRulDLife.Create(burn,surv : array of shortint);
   var
    si,ci,di,
    i : integer;
    tab : scdTab;
   begin
    inherited Create(2);
    AuxMask := 1;
    Nx := 9;
    SetLength(Neib,9);
    SetLength(LocRul,512);
    for i := 0 to 8 do
    with Neib[i] do
    begin
     DX := i mod 3 - 1;
     DY := i div 3 - 1;
    end;
    for si := 0 to 1 do
    for ci := 0 to 4 do
    for di := 0 to 4 do
     tab[si,ci,di] := 0;
    for i := 0 to Length(burn) div 2 - 1 do
     SetSCDtab(tab,0,burn[2*i],burn[2*i+1]);
    for i := 0 to Length(surv) div 2 - 1 do
     SetSCDtab(tab,1,surv[2*i],surv[2*i+1]);
    FillSCD(tab);
   end;

   constructor LocRulDLife.Create(SCDName : string; FromFile : Boolean);
   var
    FI : TextFile;
    si,ci,di,
    i : integer;
    tab : scdTab;
   begin
    inherited Create(2);
    AuxMask := 1;
    Nx := 9;
    SetLength(Neib,9);
    SetLength(LocRul,512);
    for i := 0 to 8 do
    with Neib[i] do
    begin
     DX := i mod 3 - 1;
     DY := i div 3 - 1;
    end;
    for si := 0 to 1 do
    for ci := 0 to 4 do
    for di := 0 to 4 do
     tab[si,ci,di] := 0;
    if FromFile then
    try
     AssignFile(FI,SCDName);
     Reset(FI);
     while not EOF(FI) do
     begin
      readln(FI,si,ci,di);
      SetSCDtab(tab,si,ci,di);
     end;
    finally
     CloseFile(FI);
    end
    else
    begin
     si := 0;
     for i := 1 to Length(SCDName) do
     case UpCase(SCDName[i]) of
      '0'..'8' :
        SetSCDtab(tab,si,Ord(SCDName[i])-Ord('0'),-2);
      'B' : si := 0;
      'S' : si := 1;
     end;
    end;
    FillSCD(tab);
   end;

   procedure LocRulDLife.FillSCD(var tab : scdTab);
   var
    i0,i1,i2,i3,i4,i5,i6,i7,i8,
    ind,v : integer;
   begin
    for i0 := 0 to 1 do
     for i1 := 0 to 1 do
      for i2 := 0 to 1 do
       for i3 := 0 to 1 do
        for i4 := 0 to 1 do
         for i5 := 0 to 1 do
          for i6 := 0 to 1 do
           for i7 := 0 to 1 do
            for i8 := 0 to 1 do
    begin
     ind := i0+2*(i1+2*(i2+2*(i3+2*(i4+
               2*(i5+2*(i6+2*(i7+2*i8)))))));
     v := tab[i4,i1+i3+i5+i7,i0+i2+i6+i8];
     LocRul[ind] := v
    end;
   end;

{ CAField }

  constructor CAField.Create(ARule : LocRulCAtab);
  begin
   inherited Create;
   CARul := ARule;
   CA1 := nil;
   CA2 := nil;
   ShareRule := False;
  end;

  destructor CAField.Destroy;
  begin
   if not ShareRule and (CARul <> nil) then CARul.Free;
   inherited
  end;

  function CAField.GetCA12(I, J: Integer): Integer;
  begin
    GetCA12 := CARul.JoinC12(CA1[I,J],CA2[I,J]);
  end;

  function CAField.GetSizeX: Integer;
  begin
    Result := Length(CA1);
  end;

  function CAField.GetSizeY: Integer;
  begin
    if Length(CA1) = 0 then Result := 0
    else Result := Length(CA1[0]);
  end;

  procedure CAField.SetCA12(I, J, Value: Integer);
  begin
    CARul.SplitC12(Value,CA1[i,j],CA2[i,j]);
  end;


  procedure CAField.CalcNew;
  var
    I,J,Imx,Jmx : integer;
  begin
   Imx := Length(CA1);
   Jmx := Length(CA1[0]);
   for I := 0 to Imx-1 do
    for J := 0 to Jmx-1 do
   CA2[I,J] := CA1[I,J];

   for I := 0 to Imx-1 do
    for J := 0 to Jmx-1 do
     CA1[I,J] := CaRul.CalcOne(CA2,Imx,Jmx,I,J);
  end;

  procedure CAField.CalcNewRev(back : boolean);
  var
    I,J,Imx,Jmx,k1,k2,Nst : integer;
    XC : XCell;
  begin
   Imx := Length(CA1);
   Jmx := Length(CA1[0]);
   if CARul.fxy >= f_special then
   begin
     if back then UpdateAreas(back);
     for I := 0 to Imx-1 do
      for J := 0 to Jmx-1 do
      begin
       CaRul.CalcCell(XC,CA1,Imx,Jmx,I,J);
       CARul.ApplyXCell(CA2[I,J],CA1[I,J],XC,back)
      end;
     if not back then UpdateAreas(back);
   end
   else
   begin
     k1 := 1; k2:=1;
     case CARul.fxy of
       fx_plus_y:
             if back then
                begin k1:=-1; k2:=-1 end
             else k2 := 1;
       fx_minus_y: k2 := -1;
       y_minus_fx:
             if not back then
                begin k1:=-1; k2:=-1 end
             else k2 := 1;
     end;
     Nst := CaRul.Ns;
     if back then SwapAreas;
     for I := 0 to Imx-1 do
      for J := 0 to Jmx-1 do
       CA2[I,J] := (Nst + k1*(CaRul.CalcOne(CA1,Imx,Jmx,I,J)
        + k2*CA2[I,J])) mod Nst;
     if not back then SwapAreas;
   end;
  end;


  procedure CAField.SetArea(X,Y : Integer);
  begin
   SetLength(CA1,X,Y);
   SetLength(CA2,X,Y);
   ClearArea;
  end;


  procedure CAField.ClearArea;
  var
   I,J : integer;
  begin
   for I := 0 to Length(CA1)-1 do
    for J := 0 to Length(CA1[0])-1 do
    begin
     CA1[I,J] := 0; CA2[I,J] := 0;
    end;
  end;


  procedure CAField.SwapAreas;
  var
   I,J : integer;
   Sw : NCell;
  begin
   for I := 0 to Length(CA1)-1 do
    for J := 0 to Length(CA1[0])-1 do
    begin
     Sw := CA2[I,J];
     CA2[I,J] := CA1[I,J];
     CA1[I,J] := Sw;
    end;
  end;


  procedure CAField.UpdateAreas(back: boolean);
  var
   I,J : integer;
  begin
   if CARul <> nil then
   with CARul do
   for I := 0 to Length(CA1)-1 do
    for J := 0 to Length(CA1[0])-1 do
     UpdateCell(CA1[I,J],CA2[I,J],back)
   else
    SwapAreas;
  end;

  procedure CAField.SaveMapFile(FileName : String);
  var
   FO : TextFile;
  begin
   if (CARul <> nil) and CARul.CheckCap(capSaveMap) then
   try
    AssignFile(FO,FileName);
    Rewrite(FO);
    CARul.SaveMap(FO);
   finally
    Close(FO);
   end
   else
     Raise EInOutError.Create('MAP file may not be saved');
  end;

  function CAField.LoadMapFile(FileName : String; New : Boolean) : Boolean;
  var
   FI : TextFile;
  begin
   Result := false;
   if New then CARul.Free;
   if New or (CARul = nil) then
    CARul := LocRulCAtab.Create(0);
   if CARul.CheckCap(capLoadMap) then
   try
    AssignFile(FI,FileName);
    Reset(FI);
    CARul.LoadMap(FI);
    result := true;
   finally
    Close(FI);
   end
   else
     Raise EInOutError.Create('MAP file may not be loaded');
  end;

  function CAField.NumCells(var CA : CACells) : Integer;
  var
   i,j : integer;
  begin
   Result := 0;
   for I := 0 to Length(CA)-1 do
    for J := 0 to Length(CA[0])-1 do
     if CA[i,j] <> 0 then Inc(Result);
  end;

  function CAField.CenterCells(var CA : CACells) : DVec;
  var
   i,j,n : integer;
   sx,sy : single;
  begin
   n := 0;
   sx := 0;
   sy := 0;
   for I := 0 to Length(CA)-1 do
    for J := 0 to Length(CA[0])-1 do
    if CA[i,j] <> 0 then
    begin
     Inc(n);
     sx := sx+i;
     sy := sy+j;
    end;
   if n > 0 then
   begin
    sx := sx / n;
    sy := sy / n;
   end;
   with Result do
   begin
    DX := Round(sx);
    DY := Round(sy);
   end;
  end;



{ LocRulCAm }

   constructor LocRulCAm.Create(aNs: Integer);
   begin
    inherited Create(aNs);
    DefCap := capIrrevStep + capRevStep + capInvert
     + capSaveMap;
   end;

   procedure LocRulCAm.SaveMap(var FO: TextFile);
   var
    i,j,k,n : integer;
    XC : XCell;
    Cells : TLocCells;
   begin
    writeln(FO,sMapSig);
    writeln(FO,SizeOf(NCell)*8);
    writeln(FO,AuxMask);
    writeln(FO,Ns);
    writeln(FO,Nx);
    for i := 0 to Nx - 1 do
    with Neib[i] do
    writeln(FO,DX,' ',DY);
    n := 1;
    for i := 0 to Nx - 1 do n:=n*Ns;
    writeln(FO,'1 1 ',n);
    for j := 0 to n-1 do
    begin
     k := j;
     for i := 0 to Nx - 1 do
     begin
      Cells[i] := k mod Ns;
      k := k div Ns;
     end;
     CalcLocCells(XC,Cells);
     writeln(FO,XC);
    end;
   end;

{ LocRul2CA2 }

constructor LocRul2CA2.Create(aNs,aNs2: Integer);
begin
 inherited Create(aNs);
 FNs2 := aNs2;
end;

function LocRul2CA2.Ns2(C1 : NCell): Integer;
begin
 Ns2 := FNs2;
end;

function LocRul2CA2.Nsr: Integer;
begin
 Nsr := Ns*FNs2;
end;

end.
