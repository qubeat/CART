unit ReadMeVar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TReadMeForm = class(TForm)
    Memo1: TMemo;
    StatusBar1: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Perform;
  end;

var
  ReadMeForm: TReadMeForm;
  ReadMeName : string = 'readme.txt';

implementation

{$R *.dfm}



   procedure TReadMeForm.Perform;
   begin
     Memo1.Clear;
     if FileExists(ReadMeName) then
     begin
      Memo1.Lines.LoadFromFile(ReadMeName);
      Show;
     end;
   end;


end.
