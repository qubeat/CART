unit DlgXY;

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
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormDlgXY = class(TForm)
    Bevel1: TBevel;
    LabX: TLabel;
    LabY: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    EdX: TEdit;
    EdY: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    X,Y : Integer;
    function Execute : Boolean;
  end;

var
  FormDlgXY: TFormDlgXY;

implementation

{$R *.dfm}

{ TForm1 }

function TFormDlgXY.Execute: Boolean;
begin
   result := false;
   if ShowModal = mrOK then
   begin
    try
     X := StrToInt(EdX.Text);
     Y := StrToInt(EdY.Text);
     result := true;
    finally
    end;
   end;
end;

end.
