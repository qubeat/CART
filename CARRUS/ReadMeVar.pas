unit ReadMeVar;

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
  Dialogs, ComCtrls, StdCtrls, FileUtil;

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
     if FileExistsUTF8(ReadMeName) { *Converted from FileExists*  } then
     begin
      Memo1.Lines.LoadFromFile(ReadMeName);
      Show;
     end;
   end;


end.
