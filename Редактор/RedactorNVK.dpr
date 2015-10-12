program RedactorNVK;

uses
  Forms,
  GlobalValue,
  Unit1 in 'Unit1.pas' {Form1},
  Expr in '..\VCL\Expr.pas',
  IMMIImage in '..\VCL\IMMIImage.pas',
  ConstDef in '..\Units\constDef.pas',
  frmShowTegsU in '..\Units\frmShowTegsU.pas' {frmShowTegs},
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  UnitObject in 'UnitObject.pas' {Form2},
  FormPackage in 'FormPackage.pas' {FormPackage},
  FormFindExprU in 'FormFindExprU.pas' {FormFindExpr},
  DialogExprU in '..\компоненты редактора\DialogExprU.pas' {DialogExpr},
  fTopMenuU in '..\Immi\fTopMenuU.pas' {fTopMenu};

//{ Opendirectory in 'Opendirectory.pas' {Form12},
  //UnitExpr in 'UnitExpr.pas'} ;

{$R *.res}

begin

  Application.Initialize;
  InitialSys;
  PathEthSer:='\\\';
  Application.CreateForm(TfTopMenu, fTopMenu);
  Form1:= TForm1.Create(Application);
  Form1.show;
  Application.CreateForm(TfrmShowTegs, frmShowTegs);
   fTopMenu.height:=0;
  Application.Run;

  end.
