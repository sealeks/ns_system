unit Dm2Us;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, FrmSelectDirU, ADODB, globalvalue;

type
  TDm2s = class(TDataModule)
    AlarmBase: TADOTable;
    TrendBase: TADOTable;
    qTrend: TADOQuery;
    qDateTime: TADOQuery;
    Query1: TADOQuery;
    Trend: TADOConnection;
    Alarms: TADOConnection;
    Registration: TADOConnection;
    Regist: TADOQuery;
    tbTrenddef: TADOQuery;
    qAlarms: TADOQuery;
    //проверяем сконфигурированность BDE и конфигурируем при необхости
    procedure DataModuleCreate(Sender: TObject);
    procedure RegistrationBeforeConnect(Sender: TObject);
    procedure TrendBeforeConnect(Sender: TObject);
    procedure AlarmsBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dm2: TDm2s;

implementation

{$R *.DFM}


procedure TDm2s.DataModuleCreate(Sender: TObject);
var
  alias1Enable, alias2Enable: boolean;
  MyStringList: TStringList;
  i: integer;
begin
{  alias1Enable := false;
  alias2Enable := false;
  MyStringList := TStringList.Create;
  try
    Session.GetAliasNames(MyStringList);
    { fill a list box with alias names for the user to select from }
   { for I := 0 to MyStringList.Count - 1 do
      if UpperCase(MyStringList[I]) = 'ALARMS' then Alias1Enable := true
      else
      if UpperCase(MyStringList[I]) = 'TREND' then Alias2Enable := true;
  finally
    MyStringList.Free;
  end;
  if not Alias1Enable or not Alias2Enable then
  with TFrmSelectDir.Create(self) do
  try
    if not Alias1Enable then
    begin
      caption := 'Выберите каталог хранения сообщений';
      if ShowModal = mrOK then
      begin
       Session.AddStandardAlias('Alarms',shellTreeView.path,'PARADOX');
       Session.SaveConfigFile;
      end;
    end;
     if not Alias2Enable then
    begin
      caption := 'Выберите каталог хранения архива';
      if ShowModal = mrOK then
      begin
       Session.AddStandardAlias('Trend',shellTreeView.path,'PARADOX');
       Session.SaveConfigFile;
      end;
    end;
    Session.Close; // иначе он у меня не был сpазу виден
    Session.Open; // ---------//
  finally
    free;
  end; }
end;

procedure TDm2s.RegistrationBeforeConnect(Sender: TObject);
begin
if trim(csRegistration)='' then exit;
registration.ConnectionString:=CSRegistration;
end;

procedure TDm2s.TrendBeforeConnect(Sender: TObject);
begin
 trend.ConnectionString:=CSTrend;
end;

procedure TDm2s.AlarmsBeforeConnect(Sender: TObject);
begin
  Alarms.ConnectionString:=CSAlarms;
end;

end.
