unit AlarmTblU;

interface

uses classes, SysUtils, DBTables, db, ConstDef, dialogs;

type

TAlarmTable = class
private
  lastTableName: string;
  //qAlarms: TQuery;
public

  constructor Create;
  procedure WriteAlarm (iName, irtItem, iComment, iState: string; iAlarmLevel: integer);
end;
var
  AlarmTable: TAlarmTable;
implementation

constructor TAlarmTable.Create;
begin
     inherited;
     //lastTableName := '';
    // qAlarms:= TQuery.Create(nil);
    // qAlarms.DatabaseName := 'alarms';
end;


procedure TAlarmTable.WriteAlarm (iName, irtItem, iComment, iState: string;iAlarmLevel: integer);
var
   s,dateString : string;
begin
     //удаление старого файла, старее 3 мес€цев
   {  s:=DatetoFilename(IncMonth(Date, -3));
     DeleteFile('..\dbdata\Alarms\'+s+'.DB');

     //получение имени сегодн€шнего файла
     dateString := datetoFileName(Date);
     if lastTableName <> dateString then
     if not TableExist(dateString, 'Alarms') then
     begin
       //create alarm trend table
       qAlarms.Sql.Clear;
       qAlarms.Sql.Add ('CREATE TABLE "' + dateString +
                                      '" ("'+dateString+'"."Time" Time, Name CHAR(50), PARAM CHAR(50),"' +
                                      dateString + '"."Level" integer, comment CHAR(255), State CHAR(10),' +
                                      'Operator CHAR(60), SELECTED BOOLEAN)');
        try
          qAlarms.ExecSQL;
        except
          raise Exception.Create('Ќевозможно создать журнал тревог ' + dateString);
        end;
       end;//создание таблицы
       lastTableName := dateString;

    with qAlarms do
    begin
     SQL.Clear;
     SQL.Add('insert into "' + dateString + '" ("'+dateString+'"."time", name, param, "'+dateString+'"."level", comment, state, operator)' +
                                  ' values (:prTime, "' +iName + '","' + irtItem + '",' +
                                  inttostr(iAlarmLevel)+ ',"' + iComment + '","' +
                                  iState + '","' +  ConstDef.OperatorName^ + '")');
     parambyname('prTime').asTime := Time;
     try
       ExecSQL;
     except
        raise;
     end;
    end; {with}
end;

end.

