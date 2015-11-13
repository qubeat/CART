unit CAPix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls;

type
  TFormPix = class(TForm)
    StatusLine: TStatusBar;
    ScrollPix: TScrollBox;
    Pix: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitPix(W,H : Integer);
  end;

var
  FormPix: TFormPix;

implementation

{$R *.dfm}
 procedure TFormPix.InitPix(W,H : Integer);
 var
  Bitmap: TBitmap;
 begin
  Show;
  Pix.Width := W;
  Pix.Height := H;
  Bitmap := nil;
  try
    Bitmap := TBitmap.Create;
    Bitmap.Width := W;
    Bitmap.Height := H;
    Pix.Picture.Graphic := Bitmap;
  finally
    Bitmap.Free;
  end;
  Pix.Canvas.Brush.Color := Color;
  Pix.Canvas.FillRect(Rect(0,0,W,H));
 end;


end.
