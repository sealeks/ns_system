program PrintTest;

uses
  Forms,
  main in 'main.pas' {Form1},
  Justify in 'JUSTIFY.PAS',
  PrintConfig in 'PrintConfig.pas' {PrintConfigForm},
  PrintEngine in 'PrintEngine.pas',
  PrintMainDlg in 'PrintMainDlg.pas' {PrintMainDialog},
  PrintReport in 'PrintReport.pas';

{$R *.RES}


begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
