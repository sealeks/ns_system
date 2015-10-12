program RepOffice;

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
  RepOfficeF in 'RepOfficeF.pas' {fJournal},
  AddPFU in 'AddPFU.pas' {AddPForm},
  RerEditU in 'RerEditU.pas' {RepEdit},
  UnitExpr in 'UnitExpr.pas' {FormExpr},
  FormDelListU in 'FormDelListU.pas' {FormDelList},
  FormDTU in 'FormDTU.pas' {FormDT},
  SetTimiUnitU in 'SetTimiUnitU.pas' {SetTimeForm};

{$R *.res}

begin
  InitialSys;
  Application.Initialize;
  Sincronize;
  Application.Title := 'RepOffice';
  Application.CreateForm(TfJournal, fJournal);
  Application.CreateForm(TFormExpr, FormExpr);
  Application.CreateForm(TFormDelList, FormDelList);
  Application.CreateForm(TFormDT, FormDT);
  Application.CreateForm(TSetTimeForm, SetTimeForm);
  {  for i := 1 to ParamCount do
  begin
    if trim(LowerCase(ParamStr(i))) = 'non' then
     fJournal.BorderStyle:=bsNone else
     fJournal.Position:=poDesktopCenter;
  end;       }
  Application.Run;
end.
