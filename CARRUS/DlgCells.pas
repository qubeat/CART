unit DlgCells;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TCellsDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    LabNx: TLabel;
    EdNx: TEdit;
    LabNy: TLabel;
    EdNy: TEdit;
    LabSz: TLabel;
    EdSz: TEdit;
    LabGap: TLabel;
    EdGap: TEdit;
    Bevel2: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
    NXc,NYc,NSc,NGc : Integer;
    function Execute : Boolean;
  end;

var
  CellsDlg: TCellsDlg;

implementation

{$R *.dfm}

 function TCellsDlg.Execute : Boolean;
 begin
   result := false;
   if ShowModal = mrOK then
   begin
    try
     NXc := StrToInt(EdNx.Text);
     NYc := StrToInt(EdNy.Text);
     NSc := StrToInt(EdSz.Text);
     NGc := StrToInt(EdGap.Text);
     result := true;
    finally
    end;
   end;
 end;

end.
