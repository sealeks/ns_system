program NS_DesignTime;

uses
  Forms,
  GlobalValue,
  mainFormRedactorU in '..\Редактор\mainFormRedactorU.pas' {mainFormRedactor},
  Expr in '..\VCL\Expr.pas',
  IMMIImage in '..\VCL\IMMIImage.pas',
  ConstDef in '..\Units\constDef.pas',
  frmShowTegsU in '..\Units\frmShowTegsU.pas' {frmShowTegs},
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  UnitObject in 'UnitObject.pas' {Form2},
  FormPackage in 'FormPackage.pas' {FormPackage},
  FormFindExprU in 'FormFindExprU.pas' {FormFindExpr},
  DialogExprU in '..\компоненты редактора\DialogExprU.pas' {DialogExpr},
  fTopMenuU in '..\Immi\fTopMenuU.pas' {fTopMenu},
  SelectFormPU in 'SelectFormPU.pas' {SelectFormP},
  FormComponentU in 'FormComponentU.pas' {FormComponent},
  FormExprQueekU in 'FormExprQueekU.pas' {FormExprQueek},
  AppImmi in '..\Units\AppImmi.pas',
  MyObjAuto in 'MyObjAuto.pas',
  ifps_maincompile in '..\VCL\ifps3\ifps_maincompile.pas',
  MainRunTimeRegistration in '..\Units\MainRunTimeRegistration.pas';

//{ Opendirectory in 'Opendirectory.pas' {Form12},
  //UnitExpr in 'UnitExpr.pas'} ;

{$R *.res}

begin

  Application.Initialize;
  InitialSys;
  application.ShowMainForm:=true;
  Application.CreateForm(TfTopMenu, fTopMenu);
  mainFormRedactor:= TmainFormRedactor.Create(Application);
  Application.CreateForm(TfrmShowTegs, frmShowTegs);
  fTopMenu.height:=0;
  mainFormRedactor.SelectLast(nil);
  Application.Run;


  end.
