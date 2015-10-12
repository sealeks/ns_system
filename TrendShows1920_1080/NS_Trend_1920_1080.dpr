program NS_Trend_1920_1080;

{%ToDo 'NS_Trend_1024_768.todo'}
{%ToDo 'NS_Trend_1920_1080.todo'}

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
