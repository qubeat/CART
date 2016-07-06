program CART;

uses
  Forms,
  CARTForm in 'CARTForm.pas' {FormCA},
  CARules2 in 'CARules2.pas',
  CAPix in 'CAPix.pas' {FormPix},
  PixSer in 'PixSer.pas' {SerBmpDlg},
  DlgCells in 'DlgCells.pas' {CellsDlg},
  AboutCART in 'AboutCART.pas' {DlgAboutCAR},
  ReadMeVar in 'ReadMeVar.pas' {ReadMeForm},
  CARulTree in 'CARulTree.pas',
  GollyFiles in 'GollyFiles.pas',
  BuildTree in 'BuildTree.pas',
  SortList in 'SortList.pas',
  CA2Tree in 'CA2Tree.pas',
  UMCell in 'UMCell.pas',
  SaveGTree in 'SaveGTree.pas',
  USpecl in 'USpecl.pas',
  DlgXY in 'DlgXY.pas' {FormDlgXY},
  CASpecTree in 'CASpecTree.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormCA, FormCA);
  Application.CreateForm(TFormPix, FormPix);
  Application.CreateForm(TSerBmpDlg, SerBmpDlg);
  Application.CreateForm(TCellsDlg, CellsDlg);
  Application.CreateForm(TDlgAboutCAR, DlgAboutCAR);
  Application.CreateForm(TReadMeForm, ReadMeForm);
  Application.CreateForm(TFormDlgXY, FormDlgXY);
  Application.Run;
end.
