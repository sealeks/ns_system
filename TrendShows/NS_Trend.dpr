program NS_Trend;

{%ToDo 'NS_Trend.todo'}

uses
  Forms,
  StrUtils,
  System,
  SysUtils,
  fTrendU in 'fTrendU.pas' {fTrend},
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  SelectFormVCLU in '..\VCL\SelectFormVCLU.pas' {SelectFormVCL};

{$R *.res}
var i: integer;
begin
  //InitialSys;
  Application.Initialize;

  Application.CreateForm(TfTrend, fTrend);
 
  //Application.CreateForm(TqueryFormTr, queryFormTr);




 
  Application.Run;
end.