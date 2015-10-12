unit DataGraphcModul;

interface

uses
  SysUtils, Classes, Scope, DB, DBTables,constDef, Expr,DateUtils, Dialogs,
  ADODB, forms,GlobalValue;

type
  TDataModule1 = class(TDataModule)
    Trend: TADOConnection;
    procedure TrendBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
     errorData: boolean;
     function TableExist(iFileName: String): boolean;
    // function QueryExpr(Expr: TexprStr;tim: TDateTime;Minute: integer): tTDPoint;
   //  function QueryPeriod(tim: TDateTime;Minute: integer;numg: integer): tTDpoint;
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

{function TDataModule1.QueryExpr(Expr: TexprStr;tim: TDateTime; Minute: integer):tTDPoint;
var
   days, i,j: integer;
   curDate,Length,start: TDateTime;
   TableName, sQuery: string;
   curdateTS: TdateTime;
//   Day1, Day2: double;

begin
try
    Setlength(result.point, 0);
    result.n:=0;
errorData:=false;
Length:=0.9999999/24/60*Minute;
start:=tim-Length;
days := trunc(Start + Length) - trunc (start);
CurDate:= trunc(Start);
for i:= 0 to days do
  begin
    curdateTS :=  strtoDate('30.12.1899') - strtoDate('01.01.3000')+ CurDate;
    TableName:= 'tr' + datetoFileName(CurDate);
    if TableExist(TableName, Trend) then
      begin
        sQuery := '';

        sQuery := format( ' SELECT %s.tm , %s.val ' +
                        'FROM trendDef, %s  ' +
                        'WHERE ((trendDef.Cod= %s.cod) AND (trendDef.iName = :f))',
                        [TableName, TableName, TableName, TableName 
                                                ]);

        if (i = 0) then
        sQuery := sQuery + ' AND ' + TableName + '.tm > :start ';
        if i = days then
        sQuery := sQuery + ' AND ' + TableName + '.tm < :stop ';
        sQuery:= sQuery+ 'ORDER BY tm ASC';

        with queryforanalog do
          begin
            Sql.Clear;
            sql.Add(sQuery);
            parameters.ParamByName('f').Value:=expr;
            if (i = 0) then
            begin
              parameters.ParamByName('start').DataType:=ftstring;
              parameters.ParamByName('start').Value:=SelfFormatDateTime(start);
            end;
             if i = days then
             begin
               parameters.ParamByName('stop').DataType:=ftstring;
               parameters.ParamByName('stop').Value:=SelfFormatDateTime(Start + Length);
             end;
            open;
          end;
        result.n:=0;
         try
           if not queryforanalog.Active then queryforanalog.Open;
           result.n:=queryforanalog.RecordCount;
           Setlength(result.point, queryforanalog.RecordCount);
           for j := 0 to queryforanalog.RecordCount - 1 do
              begin
                 result.point[j][1]:=(Minute-double(TDateTime(tim-queryforanalog['tm']))*24*60);
                 result.point[j][2]:=double(real(queryforanalog['val']));
                 queryforanalog.Next;
              end;
           queryforanalog.close;
         except

           errorData:=true;
         end;
      end;
      curDate:= IncDay(curDate);
  end;
except
errorData:=true;
//ShowMessage('err2');
end;
end;       }

{function TDataModule1.QueryPeriod(tim: TDateTime; Minute: integer; numg: integer):tTDPoint;
var
   days, i: integer;
   curDate,Length,start,stop: TDateTime;
   TableName, sQuery: string;
   curdateTS: TdateTime;

begin
  try
 // errorData:=false;
  Setlength(result.point, 0);
  result.n:=0;
  start:=IncMinute(tim,-Minute);
  stop:=tim;
  sQuery := '';

  if numg=0 then TableName:= 'StStDef' else TableName:= 'StStDef'+ inttostr(numg);

  if TableExist(TableName, Trend) then
    begin

      sQuery := 'select * from '+TableName+' where ((starttime between :start and :stop) or (stoptime between '+
                    ':start1 and :stop1)  or ((stoptime<=:stop2) and (starttime>=:start2)))';

      with queryforanalog do
        begin

        Sql.Clear;
        Sql.Add(sQuery);
        parameters.ParamByName('start').DataType:=ftstring;
        parameters.ParamByName('stop').DataType:=ftstring;
        parameters.ParamByName('start').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('stop').Value:=SelfFormatDateTime(stop);
        parameters.ParamByName('start1').DataType:=ftstring;
        parameters.ParamByName('stop1').DataType:=ftstring;
        parameters.ParamByName('start1').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('stop1').Value:=SelfFormatDateTime(stop);
        parameters.ParamByName('start2').DataType:=ftstring;
        parameters.ParamByName('stop2').DataType:=ftstring;
        parameters.ParamByName('start2').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('stop2').Value:=SelfFormatDateTime(stop);
        open;


        end;


      if not queryforanalog.Active then queryforanalog.Open;
      result.n:=queryforanalog.RecordCount;
      Setlength(result.point, queryforanalog.RecordCount);
      for i:=0 to queryforanalog.RecordCount - 1 do
          begin
            //if TDateTime(queryforanalog['starttime'])<now then
            //  begin
              result.point[i][1]:=(Minute-double(TDateTime(tim-queryforanalog['stoptime']))*24*60);
              result.point[i][2]:=(Minute-double(TDateTime(tim-queryforanalog['starttime']))*24*60);
              if result.point[i][1]<0 then result.point[i][1]:=0 ;
              if result.point[i][2]>Minute then result.point[i][2]:=Minute ;
              if result.point[i][2]<0 then result.point[i][1]:=0 ;
              if result.point[i][1]>Minute then result.point[i][2]:=Minute ;
            //  end
          //   else dec(result.n);
            queryforanalog.Next;
          end;


  end;
  queryforanalog.close;
   except
    //showmessage(' err in query for period');
     errorData:=true;
    result.n:=1;
    Setlength(result.point, 1);
    result.point[i][1]:=0;
    result.point[i][2]:=Minute;
  end;



end;  }


function TDataModule1.TableExist(iFileName: String): boolean;
var
   TableList: TStringList;
   i : integer;
begin
    // ShowMessage('eeee');
     result := False;
     TableList := TStringlist.Create;
     try
    //  ShowMessage('eeee');
     Application.ProcessMessages;
     Trend.GetTableNames(TableList, true);
     Application.ProcessMessages;
    //  ShowMessage('tttt');
     for i := 0 to TableList.count - 1 do
         if Uppercase(TableList[i]) = uppercase(iFileName) then begin
            tableExist := true;
            break;
         end;
     finally
         TableList.Free;
     end;
end;

procedure TDataModule1.TrendBeforeConnect(Sender: TObject);
begin
 // trend.ConnectionString:=CStrend;
  if not asyncBase then trend.ConnectOptions:=coConnectUnspecified;
end;

end.
