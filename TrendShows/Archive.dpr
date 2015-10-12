program Archive;

{%ToDo 'Archive.todo'}

uses
  Forms,
  StrUtils,
  System,
  SysUtils,
  fTrendU in 'fTrendU.pas' {fTrend},
  fPropFilterU in 'fPropFilterU.pas' {fPropSave},
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  fAlfavitU in 'fAlfavitU.pas' {fAlfavit},
  SaveArcPU in 'SaveArcPU.pas' {SaveArcP};

{$R *.res}
var i: integer;
begin
  //InitialSys;
  Application.Initialize;

  Application.CreateForm(TfTrend, fTrend);
  //Application.CreateForm(TqueryFormTr, queryFormTr);

  Application.CreateForm(TfPropSave, fPropSave);
  Application.CreateForm(TfAlfavit, fAlfavit);

  Application.CreateForm(TSaveArcP, SaveArcP);
 
  Application.Run;
end.
