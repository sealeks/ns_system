unit Dm2UOPC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, FrmSelectDirU, ADODB, globalvalue;

type
  TDm2OPC = class(TDataModule)
    qTrend: TADOQuery;
    Query1: TADOQuery;
    Trend: TADOConnection;
    //проверяем сконфигурированность BDE и конфигурируем при необхости
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dm2s: TDm2OPC;

implementation

{$R *.DFM}


procedure TDm2OPC.DataModuleCreate(Sender: TObject);
var
  alias1Enable, alias2Enable: boolean;
  MyStringList: TStringList;
  i: integer;
begin
   
end;

end.
