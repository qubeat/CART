unit PixSer;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TSerBmpDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    PageControlPix: TPageControl;
    TabSheetSing: TTabSheet;
    Bevel1: TBevel;
    CellsGrBox: TGroupBox;
    LabXmin: TLabel;
    LabYmin: TLabel;
    LabXmax: TLabel;
    LabYmax: TLabel;
    EdXmin: TEdit;
    EdYmin: TEdit;
    EdXmax: TEdit;
    EdYmax: TEdit;
    OutParBox: TGroupBox;
    LabW: TLabel;
    LabH: TLabel;
    Label1: TLabel;
    EdW: TEdit;
    EdH: TEdit;
    EdStep: TEdit;
    TabSheet1: TTabSheet;
    GroupBoxCells: TGroupBox;
    LabSz: TLabel;
    LabGap: TLabel;
    EdSz: TEdit;
    EdGap: TEdit;
    Bevel2: TBevel;
    OutParBox2: TGroupBox;
    LabFmt: TLabel;
    LabOffs: TLabel;
    LabCnt: TLabel;
    EdFmt: TEdit;
    EdOffs: TEdit;
    EdCnt: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SinglePix : Boolean;
    Xmin,Xmax,Ymin,Ymax,Wp,Hp,Stp : Integer;
    Sz,Gp,Offs,Cnt : Integer;
    Fmt : String;
    procedure SetPars;
    function GetPars : boolean;
    function Execute : boolean;
  end;

var
  SerBmpDlg: TSerBmpDlg;

implementation

{$R *.dfm}
   procedure TSerBmpDlg.SetPars;
   begin
    EdXmin.Text:= IntToStr(Xmin);
    EdYmin.Text:= IntToStr(Ymin);
    EdXmax.Text:= IntToStr(Xmax);
    EdYmax.Text:= IntToStr(Ymax);
    EdW.Text:= IntToStr(Wp);
    EdH.Text:= IntToStr(Hp);
    EdStep.Text:= IntToStr(Stp);

    EdSz.Text := IntToStr(Sz);
    EdGap.Text := IntToStr(Gp);
    EdOffs.Text := IntToStr(Offs);
    EdCnt.Text:= IntToStr(Cnt);
    EdFmt.Text:= Fmt;

    with PageControlPix do
    if SinglePix then
     ActivePageIndex := 0
    else
     ActivePageIndex := 1
   end;

   procedure TSerBmpDlg.FormCreate(Sender: TObject);
   begin
    GetPars
   end;

   function TSerBmpDlg.GetPars : boolean;
   begin
    result := false;
    try
     Xmin := StrToInt(EdXmin.Text);
     Ymin := StrToInt(EdYmin.Text);
     Xmax := StrToInt(EdXmax.Text);
     Ymax := StrToInt(EdYmax.Text);
     Wp := StrToInt(EdW.Text);
     Hp := StrToInt(EdH.Text);
     Stp := StrToInt(EdStep.Text);

     Sz := StrToInt(EdSz.Text);
     Gp := StrToInt(EdGap.Text);
     Offs := StrToInt(EdOffs.Text);
     Cnt := StrToInt(EdCnt.Text);
     Fmt := EdFmt.Text;
     SinglePix := (PageControlPix.ActivePageIndex = 0);
     result := true;
    finally
    end;
   end;

   function TSerBmpDlg.Execute : boolean;
   begin
    result := false;
    if ShowModal = mrOK then
     if GetPars then result := true;
   end;


end.
