unit Dm2U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, ADODB;

type
  TDm2 = class(TDataModule)
    tbTrendDef: TADOTable;
    dbFillQuery: TADOQuery;
    Trend: TADOConnection;
  private
    { Private declarations }
  public
    procedure FillPeriod(Send,sbegin: TDateTime);
    { Public declarations }
  end;

var
  Dm2: TDm2;

implementation

{$R *.DFM}

procedure TDm2.FillPeriod(Send,sbegin: TDateTime);
var ststst: string;
    
 begin
   ststst:='select * from "StStDef" where (((stoptime >= "' +  DateTimeTostr(send) +  '" and stoptime <"' +
   DateTimeTostr(sbegin) + '") or ( starttime < "' +  DateTimeTostr(sbegin) + '" and starttime>="'+
   DateTimeTostr( send) +'") or  (  starttime>="'+ DateTimeTostr( send) +'" and stoptime<="' + DateTimeTostr( sbegin)+'")))';
   dbFillQuery.SQL.Clear;
   dbFillQuery.SQL.Add('select * from "StStDef" where (((stoptime >= "' +  DateTimeTostr(send) +  '" and stoptime <"' +
   DateTimeTostr(sbegin) + '") or ( starttime < "' +  DateTimeTostr(sbegin) + '" and starttime>="'+
   DateTimeTostr( send) +'") or  (  starttime>="'+ DateTimeTostr( send) +'" and stoptime<="' + DateTimeTostr( sbegin)+'")))');
   
 end;


end.
