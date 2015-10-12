program NS_Report;

uses
  Forms,
  GlobalValue,
  StrUtils,
  System,
  SysUtils,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  ConstDef in '..\Units\ConstDef.pas',
  MemStructsU in '..\Units\MemStructsU.pas',
  TimeSincronize in '..\Units\TimeSincronize.pas',
  RepOfficeF in 'RepOfficeF.pas' {FormReport},
  SetTimiUnitU in 'SetTimiUnitU.pas' {SetTimeForm};

{$R *.res}

begin

  Application.Initialize;
  Sincronize;
  Application.Title := 'RepOffice';
  Application.CreateForm(TFormReport, FormReport);
  Application.CreateForm(TSetTimeForm, SetTimeForm);
  {  for i := 1 to ParamCount do
  begin
    if trim(LowerCase(ParamStr(i))) = 'non' then
     fJournal.BorderStyle:=bsNone else
     fJournal.Position:=poDesktopCenter;
  end;       }
  Application.Run;
end.
