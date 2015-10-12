unit ArhiveTblOPCs;



// 4 - часовые 6 - дневные 7-месячные
interface

uses classes,SvcMgr, DateUtils,SysUtils,MemStructsU, DBTables, db, Forms, dialogs, ConstDef, dm2Us, Variants, UMyTime,GlobalValue,SqlTimSt, TimeSincronize;

function GetLogCode (iName: string): longInt;
procedure WriteLog (iLogCode:longInt; iData: real);
procedure WriteLogP (iLogCode:longInt; iData: real;tim: TDatetime);
procedure WriteStartTime(numb: integer);
procedure WriteTime(numb: integer);
procedure clearerror(numb: integer);
procedure clearArcOff(numb: integer;month: integer);
procedure clearOscOff(month: integer);
procedure WriteOsc (itm: TdateTime; itid: integer; idelt: integer);
procedure WriteUchet(Code:longInt; Data: real; tm: TDateTime);


implementation

//uses dm1us;

var
  CanLog: Boolean = true;
   null_1: double;


function GetLogCode (iName: string): longInt;
var
 ts: boolean;
begin

  GetLogCode := -2;
  //if not CanLog then exit;
   try
  // dm1.Status:=csStartPending;
   //dm2.Trend.Open;
   if TableExist('Trenddef', dm2.Trend) then

     { ShowMessage('Файл Treddef не найден, что может быть связано с тем, что: '+char(13)+
      '1. Система запускается впервые.'+char(13)+
      '2. Изменен каталог доступа к базе Trend в драйвере BDE Administrator.'+char(13)+
      'Таблица Trenddef будет создана заново.
      В случае если система работала и  '+char(13)+
      'до этого, необходимо проверить путь к БД Trend(2) или переисать в текущий'+char(13)+
      'каталог доступа к БД Trend резервную копию  таблицы Trenddef ');
       dm2.tbTrendDef.Sql.Add ('CREATE TABLE Trenddef' +
                                      ' (cod AUTOINC, Name ALPHA, Enabled LOGICAL, MinEU NUMBER, MaxEU NUMBER,Comment ALPHA'+
                                      ' Edizmer ALPHA)');
       dm2.tbTrendDef.sq  }
      {  ShowMessage('Работа с архивом невозможна, файл Treddef не найден');
       CanLog:=false;
       exit;

     end;      }
             begin
              dm2.tbTrendDef.SQL.Clear;
             // dm2.tbTrendDef.Parameters.Clear;
              dm2.tbTrendDef.SQL.Add('select * from trenddef where iName=:Name');

              dm2.tbTrendDef.Parameters.ParamByName('Name').Value:=iName;
              dm2.tbTrendDef.ExecSQL;
              dm2.tbTrendDef.Open;

              if dm2.tbTrendDef.RecordCount=1 then


  {dm2.tbTrendDef.TableName:='TrendDef';
   ts:=dm2.tbTrendDef.Active;
  try
     try
        dm2.tbTrendDef.Active := true;
     except
       CanLog := False;
       ShowMessage('Работа с архивом невозможна, файл Treddef поврежден');
       exit;
     end;
     if dm2.tbTrendDef.Locate('Name', iName, [loCaseInsensitive]) then  }
                result := dm2.tbTrendDef.fieldbyName('Cod').asInteger;
        end;
  except
  // ShowMessage(inttostr(2));
  //  ShowMessage('tttt');

     //dm2.tbTrendDef.Close := ;
 end;
end;

procedure WriteLog (iLogCode:longInt; iData: real);
var
   fn, s : string;

begin

end;


procedure WriteUchet(Code:longInt; Data: real; tm: TDateTime);
var
   fn, s : string;
   per: integer;
begin
   try
  //if not CanLog then exit; //global variable, determize existing of dataBase
  //f (rtitems[Code].logDB<=3600*24)
  per:=round(rtitems[Code].logTime);

  fn := datetoFileNameU(Date,per);
  if not TableExist(fn, dm2.Trend) then
  begin
    //create new trend table
     Sincronize;
   { dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE TABLE ' + fn +
                                      ' (cod INTEGER, nm TEXT, period INTEGER, tm DATETIME, val FLOAT,' +
                                      'PRIMARY KEY(cod, tm))');
    try
      dm2.qTrend.ExecSQL;
    except
   //   raise Exception.Create('Невозможно создать файл архива с именем ' + fn);
    end;
    dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD)');
    try
      dm2.qTrend.ExecSQL;
    except
   //   raise Exception.Create('Невозможно создать индекс для архива ' + fn);
    end;
    dm2.qTrend.Sql.Clear;     }

    CreateUchTable(fn,fn,dm2.Trend,dm2.qTrend);
  end;

  with dm2.qTrend do
  begin
     s := 'insert into %s (cod, nm, period, tm, val)' +
          ' values (:cod,  :nm, :period, :tm, :val)';
     s := format (s, [fn]);
     DecimalSeparator := '.';
     SQL.Clear;
    SQL.Add('insert into ' + fn+
        ' values (:cod, :nm, :period,:tm, :Val)');
     Parameters.parambyname('cod').value := rtitems[Code].ID;
     Parameters.parambyname('nm').DataType:=ftString;
     Parameters.parambyname('nm').value := rtitems.GetName(Code);
     Parameters.parambyname('period').value := per;
     Parameters.parambyname('tm').DataType:=ftString;
     Parameters.parambyname('tm').value:=selfFormatDateTime(tm);
     Parameters.parambyname('Val').value := data;

    try
     ExecSQL;
    except
      //если приходят данные в то же время меняем - последние данные самые главные.
     // SQL.Clear;
    //  SQL.Add(format('UPDATE %s SET Val = :Val ' +
                   //     'WHERE (cod = :Cod) and  (tm = :tm)', [fn]));

     // Parameters.parambyname('Cod').value := iLogCode;


     // Parameters.parambyname('tm').DataType:=ftDateTime;
     // Parameters.parambyname('tm').value := now;
     // Parameters.parambyname('Val').value := idata;
    end;
  end;
  except
  end;
    dm2.qTrend.Sql.Clear;
end;


procedure WriteOsc (itm: TdateTime; itid: integer; idelt: integer);


begin

end;

procedure WriteLogP (iLogCode:longInt; iData: real;tim: TDatetime);
var
   fn, s : string;

begin

end;

procedure WriteStartTime(numb: integer);
var
    s : string;
   null: double;
   tstart,tstop: TDateTime;
   tIsR: boolean;
   tcod: integer;
   tn: string;
begin




end;

procedure WriteTime(numb: integer);
var
   tn, start : string;

begin

 end;


procedure clearerror(numb: integer);
var
   tn, start : string;

begin

end;


procedure clearArcOff(numb: integer;month: integer);
var
    tn, start : string;

begin

 end;

procedure clearOscOff(month: integer);
var
   fn, tn, start : string;

begin

 end;


end.
