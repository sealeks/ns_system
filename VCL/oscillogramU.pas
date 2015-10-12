unit oscillogramU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, SYButton, StdCtrls, ExtCtrls, Grids, DBGrids,
  ComCtrls, GlobalValue,MemStructsU, constdef, dateUtils, dxCore, dxButton,
  ImmibuttonXp;

type
  TFormSelectOsc = class(TForm)
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DBGrid1: TDBGrid;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TrendOs: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    Label4: TLabel;
    Button1: TImmiButtonXp;
    Button2: TImmiButtonXp;
    procedure TrendOsBeforeConnect(Sender: TObject);
    // procedure AlarmBeforeConnect(Sender: TObject);
    procedure AlarmConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure DataSource1StateChange(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure AlarmExecuteComplete(Connection: TADOConnection;
      RecordsAffected: Integer; const Error: Error;
      var EventStatus: TEventStatus; const Command: _Command;
      const Recordset: _Recordset);
  //  procedure ADOQuery1EditError(DataSet: TDataSet; E: EDatabaseError;
    //  var Action: TDataAction);
  //  procedure ADOQuery1DeleteError(DataSet: TDataSet; E: EDatabaseError;
  //    var Action: TDataAction);
    procedure ADOQuery1AfterOpen(DataSet: TDataSet);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure DateTimePicker2Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button2Click(Sender: TObject);
  //  procedure ADOQuery1FetchComplete(DataSet: TCustomADODataSet;
  //    const Error: Error; var EventStatus: TEventStatus);
  //  procedure ADOQuery1FetchProgress(DataSet: TCustomADODataSet; Progress,
  //    MaxProgress: Integer; var EventStatus: TEventStatus);
  private

     querymy: TADOQuery;
     fstartTmO: TDateTime;
     fstopTmO: TDateTime;
     fMilliSec: integer;
     procedure setMilliSec(val: integer);
     procedure setstartTmO(val: TDateTime);
     procedure setstopTmO(val: TDateTime);
    { Private declarations }
  public
     nemQ: string;
     TimeSt: TDateTime;
     isCansel: boolean;
     iComment: string;
     iName: string;
     property MilliSec: integer read fMilliSec write setMilliSec;
     property startTmO: TDateTime read fstartTmO write setstartTmO;
     property stopTmO: TDateTime read fstopTmO write setstopTmO;
     procedure QueryForm;
     function Shows(val: string): boolean;
    { Public declarations }
  end;

var
  FormSelectOsc: TFormSelectOsc;

implementation

{$R *.dfm}



procedure TFormSelectOsc.setstartTmO(val: TDateTime);
begin
  if val<>fstartTmO then
    begin
       if fstopTmO<val then fstopTmO:=val+1;
       fstartTmO:=val;
    end;
end;

procedure TFormSelectOsc.QueryForm;
var SQuery: string;
    boName: boolean;
begin
//self.Button1.Enabled:=false;
MilliSec:=-1;
if rtitems.GetSimpleID(nemQ)>-1 then
begin
 boName:=true;
 SQuery:='select * from OscLLConf where (tm between  :start and :stop ) and (iName=:iName)';
end else
begin
   boName:=false;
   SQuery:='select * from OscLLConf where (tm between  :start and :stop )';
end;
if  querymy<>nil then
    begin
     try
     DBGrid1.DataSource.DataSet:=nil;
     DBGrid1.Update;
     querymy.Close;
     querymy.Free;
     except
     end;
    end;
   querymy:=TadoQuery.Create(self);
 //  querymy.OnFetchComplete:=ADOQuery1FetchComplete;
  // querymy.OnFetchProgress:=ADOQuery1FetchProgress;
  // querymy.OnEditError:=ADOQuery1EditError;
 //  querymy.OnEditError:=ADOQuery1DeleteError;
   querymy.AfterOpen:=ADOQuery1AfterOpen;
   querymy.BeforeOpen:=query1BeforeOpen;
   querymy.CacheSize:=1;
   querymy.Connection:=self.TrendOs;
   querymy.LockType:=ltReadOnly;
   querymy.CursorLocation:=clUseClient;
   querymy.Cursortype:=ctStatic;
   querymy.ExecuteOptions:=[eoAsyncExecute, eoAsyncFetch, eoAsyncFetchNonBlocking];
   querymy.SQL.Add(SQuery);
   querymy.Parameters.ParambyName('start').DataType:=ftstring;
   querymy.Parameters.ParambyName('stop').DataType:=ftstring;
  // querymy.Parameters.ParambyName('start').value := SelfFormatDateTime(startTmO);
  // querymy.Parameters.ParambyName('stop').value := SelfFormatDateTime(stopTmO);
   try
   if boName then
     begin
        querymy.Parameters.ParambyName('iName').value := ftstring;
        querymy.Parameters.ParambyName('iName').value := nemQ;
     end;
   self.DataSource1.DataSet:=nil;
   querymy.Open;
   self.DataSource1.DataSet:=querymy;
   except
   //on e:Exception do  application.MessageBox(pansichar( sQuery),pansichar(e.message),0);
   end;
end;

procedure TFormSelectOsc.setMilliSec(val: integer);
begin
    if val<>fMilliSec then
      begin
        if val<5 then
         begin
           Label4.caption:='Пусто';
         //  Button1.enabled:=false;
         end
        else
         begin
           Label4.caption:=trim(IComment)+ '  на '+ trim((FormatDateTime('dd.mm.yyyy hh:nn:ss', TimeSt)));
            Button1.enabled:=true;
         end;
        fMilliSec:=val;
      end;
end;

procedure TFormSelectOsc.setstopTmO(val: TDateTime);
begin
    if val<>fstopTmO then
    begin
      if fstartTmO>val then fstartTmO:=val-1;
       fstopTmO:=val;
    end;
end;

procedure TFormSelectOsc.AlarmConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
var GRn: string;
begin

 if not TrendOs.connected then
 begin
  showmessage('Не удалось связатся с сервером');
 end;
end;

procedure TFormSelectOsc.DataSource1StateChange(Sender: TObject);
begin
    //TMyColorDBGrid(self.ColorDBGrid1).ColWidthsChanged;
   // TMyColorDBGrid(self.ColorDBGrid1).EndUpdate;
end;

procedure TFormSelectOsc.query1BeforeOpen(DataSet: TDataSet);
begin
if querymy=nil then exit;
if not asyncBase then
begin
  querymy.ExecuteOptions:=[];
end;
end;

procedure TFormSelectOsc.AlarmExecuteComplete(Connection: TADOConnection;
  RecordsAffected: Integer; const Error: Error;
  var EventStatus: TEventStatus; const Command: _Command;
  const Recordset: _Recordset);
begin

  if error=nil then
  begin

  exit;
  end;
  if error.number=-2147217865 then
  Showmessage('На текущую дату нет данных');

end;

procedure TFormSelectOsc.ADOQuery1AfterOpen(DataSet: TDataSet);
begin
  querymy.Last;

end;




procedure TFormSelectOsc.TrendOsBeforeConnect(Sender: TObject);
begin

if not asyncBase then trendOs.ConnectOptions:=coConnectUnspecified;
end;

procedure TFormSelectOsc.DateTimePicker1Change(Sender: TObject);

begin
  if DateTimePicker1.Date<>self.startTmO then
   begin
      self.startTmO:=DateTimePicker1.Date;
      QueryForm;
   end;
end;

procedure TFormSelectOsc.DateTimePicker2Change(Sender: TObject);
begin
  if DateTimePicker2.Date<>self.stopTmO then
   begin
      self.stopTmO:=DateTimePicker2.Date;
      QueryForm;
   end;
end;

function TFormSelectOsc.Shows(val: string): boolean;
begin
  isCansel:=false;
  startTmO:=startoftheDay(now)-10;
  stopTmO:=startTmO+10;
  DateTimePicker1.Date:=startTmO;
  DateTimePicker2.Date:=stopTmO;
  nemQ:=val;
  fMilliSec:=-1;
  self.QueryForm;
  self.ShowModal;
  if (MilliSec>5) then result:=true else
  begin
  result:=false;
  //ShoWMessage(inttostr(MilliSec));
  end;
end;

procedure TFormSelectOsc.FormDestroy(Sender: TObject);
begin
try
if querymy<>nil then  querymy.free;
except
end;
end;

procedure TFormSelectOsc.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var i: integer;
begin
  ModalResult:=MrCancel;
end;

procedure TFormSelectOsc.DBGrid1CellClick(Column: TColumn);
var i: integer;
begin
try
if DBGrid1.DataSource.DataSet<>nil then
     if DBGrid1.DataSource.DataSet.RecordCount>0 then
       begin
           with DBGrid1.DataSource.DataSet do
              for i := 0 to DBGrid1.SelectedRows.Count - 1 do
               begin

                 GotoBookmark(pointer(DBGrid1.SelectedRows.Items[i]));
                 TimeSt:=fieldByName('tm').AsDateTime;

                 iComment:=fieldByName('iComment').AsString;
                 iName:=fieldByName('iName').AsString;
                 MilliSec:=fieldByName('idelt').AsInteger;
               //  ShowMessage('yes');
               end;
            //  if DBGrid1.SelectedRows.Count=0 then  ShowMessage('kkk');

       end;
 except
 end;
end;

procedure TFormSelectOsc.Button2Click(Sender: TObject);
begin
    isCansel:=true;
end;

end.
