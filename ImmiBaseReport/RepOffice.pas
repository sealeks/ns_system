unit RepOffice;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls, Spin,Globalvar, GlobalValue,
  ColorDBGrid, ConstDef, Buttons, IMMIBitBtn, Printers, Menus, Math, ADODB, AdoInt, MemStructsU,
  ImgList, RpDefine, RpRender, RpRenderText, RpRenderCanvas,
  RpRenderPrinter, dateutils, RpCon, RpConDS, RpRave, RpBase, RpSystem,
  RpRenderPDF, RpRenderRTF, RpRenderHTML, ToolWin;

type TMyColorDBGrid = class(TcustomDBGrid);

type
  TfJournal = class(TForm)
    DataS: TDataSource;
    PrintDialog1: TPrintDialog;

    Alarm: TADOConnection;
    ImageList1: TImageList;
    Timer1: TTimer;
    DBGrid1: TDBGrid;
    ToolBar1: TToolBar;
    OpenTbl: TSpeedButton;
    PrintTbl: TSpeedButton;
    PropertyTbl: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ToolButton1: TToolButton;
    ChangeName: TSpeedButton;
    ColumnAdd: TSpeedButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ReportMenu: TPopupMenu;
    ToolButton4: TToolButton;
    PopupMenuEditMode: TPopupMenu;
    N1: TMenuItem;

    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure AlarmBeforeConnect(Sender: TObject);
    procedure AlarmConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure DataSStateChange(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure AlarmExecuteComplete(Connection: TADOConnection;
      RecordsAffected: Integer; const Error: Error;
      var EventStatus: TEventStatus; const Command: _Command;
      const Recordset: _Recordset);
    procedure ADOQuery1EditError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure ADOQuery1DeleteError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure ADOQuery1AfterOpen(DataSet: TDataSet);
    procedure ADOQuery1FetchComplete(DataSet: TCustomADODataSet;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ADOQuery1FetchProgress(DataSet: TCustomADODataSet; Progress,
      MaxProgress: Integer; var EventStatus: TEventStatus);
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure RvSystem1Print(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PopupMenuEditModePopup(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    querymy: TadoQuery;
    isQact: boolean;
    BaseNode, lastFilteredNode: TTreeNode;
    feditMode: boolean;
    function HasChildGG(GroupName: string): boolean;
    procedure FillNodeListByParent(parent: string; List: TStringList);
    procedure DefineQueryText;
    procedure DefineQueryParameters;
    procedure raveEx(pr: string);
    procedure  SetEm(val: boolean);
    function GetEm: boolean;
    function ReadPeportMenu: boolean;
    function WritePeportMenu: boolean;
    procedure AddPunkt(Sender: TObject);
    procedure DelPunkt(Sender: TObject);
    procedure AddReport(Sender: TObject);
    procedure DelReport(Sender: TObject);
    procedure AddSub(Name: string);
    procedure AddReportInM(MIP: TMenuItem; Name: string);
    procedure ExecReport(Sender: TObject);
    procedure CreteSQL;

  public
    QueryDate: tDate;
    filterStr: string;
    repSL: TStringList;
    SQLQ: string;
    property EditMode: boolean read getEM write setEM;
  end;

var

  fJournal: TfJournal;
  lastformat: string;

implementation

uses AddPFU,RerEditU;

{$R *.DFM}

procedure TfJournal.Button1Click(Sender: TObject);
begin
     Hide;
end;


procedure TfJournal.FormActivate(Sender: TObject);
begin
   //  timer1.Enabled:=false;
  //   lastformat:=LongTimeFormat;
    // LongTimeFormat := 'hh:nn:ss.zzz';
  //   dateTimePicker1.Date := Date;
    // DateTimePicker1Change(nil);
     //TreeView1.select(baseNode);
   //  isQact:=false;
     // showmessage('hhhhh');
     self.Caption:='Отчеты';
end;

procedure TfJournal.Button2Click(Sender: TObject);
begin
     print;
end;

procedure TfJournal.raveEx(pr: string);
var
  i: integer;
  fPrn: System.text;
  KG: STRING;
  fStr: TstringList;
  tprint: tprinter;
  repper: string;
  grN: string;
  staterep: string;
  strM: TMemorystream;

begin
  strM:=TMemorystream.Create;
//application.ProcessMessages;
//try
//self.ColorDBGrid1.DataSource:=nil;
 //self.RvDataSetConnection1.DataSet:=self.querymy;
 //self.RvDataSetConnection1.ExecOpen;
 //self.RvProject1.ProjectFile:=PathMem+'jRep.rav';
// if (trunc(now)=trunc(self.DateTimePicker1.DateTime)) and ((now)<(self.dtTimeTo.Time)) then
//  repper:='C '+FormatDateTime('hh:nn:ss',dtTimeFrom.DateTime)+' до '+FormatDateTime('hh:nn:ss',now)+' '+
//  FormatDateTime('dd.mm.yyyy',self.DateTimePicker1.Date)
// else
//  repper:='C '+FormatDateTime('hh:nn:ss',dtTimeFrom.DateTime)+' до '+FormatDateTime('hh:nn:ss',dtTimeto.DateTime)+' '+
 // FormatDateTime('dd.mm.yyyy',self.DateTimePicker1.Date);
 //  self.RvProject1.SetParam('stationname',trim(ProjectName));
  //if (self.TreeView1.Selected=nil) or (self.TreeView1.Selected.Text='Все события') then grN:=''
//  else grn:=' по группе "'+self.TreeView1.Selected.Text+'"';
 // self.RvProject1.SetParam('Periodrep',repper+grn);
//  staterep:='';
 // if (self.CheckBox1.Checked) or (self.CheckBox2.Checked) or (self.CheckBox3.Checked) then
  //  begin
 //    staterep:='Тревоги(';
  //   if (self.CheckBox1.Checked) then
  //    begin
  //     staterep:=staterep+'новые';
  //      if (self.CheckBox2.Checked) then staterep:=staterep+', квит.';
  //      if (self.CheckBox3.Checked) then staterep:=staterep+', ушедшие';
  //    end else
  //    begin
   //   if (self.CheckBox2.Checked) then
  //    begin
  //    staterep:=staterep+'квит.';
  //      if (self.CheckBox3.Checked) then staterep:=staterep+', ушедшие'
  //    end  else
  //    staterep:=staterep+'ушедшие'
  //    end;
 //     staterep:=staterep+'),'
  //  end;
   // if (self.CheckBox6.Checked) then  staterep:=staterep+' Включение,';
   // if (self.CheckBox7.Checked) then  staterep:=staterep+' Выключение,';
   // if (self.CheckBox8.Checked) then  staterep:=staterep+' Команды,';
   // if (self.CheckBox9.Checked) then  staterep:=staterep+' События';
  //  self.RvProject1.SetParam('staterep',staterep);


 // self.querymy.
  {try
  if pr='' then
  begin
  self.RvSystem1.DefaultDest:=rdPrinter;;
  self.RvSystem1.OutputFileName:='';
  self.RvProject1.Execute;
  end
  else
  begin
  self.RvSystem1.DefaultDest:=rdFile;;
  self.RvSystem1.DoNativeOutput:=false;
  self.RvSystem1.OutputFileName:=PathMem+'rvrep1';
  self.RvProject1.Execute;
   strM.LoadFromFile(PathMem+'rvrep1');
  self.RvRenderPDF1.NDRStream:=strm;
  self.RvRenderPDF1.PrintRender(strm,pr);

  {self.RvRenderHTML1.NDRStream:=strm;
  self.RvRenderHTML1.PrintRender(strm,pr+'.html');
    self.RvRenderTeXT1.NDRStream:=strm;
  self.RvRenderTeXT1.PrintRender(strm,pr+'.txt'); }
 { end;
  except
     try
   if pr='' then
  begin
  self.RvSystem1.DefaultDest:=rdPrinter;
  self.RvSystem1.OutputFileName:='';
  self.RvSystem1.SystemOptions:=self.RvSystem1.SystemOptions-[sousefiler];
  self.RvProject1.Execute
  end
  else
  begin
  self.RvSystem1.DefaultDest:=rdFile;;
  self.RvSystem1.DoNativeOutput:=false;
  self.RvSystem1.OutputFileName:=PathMem+'rvrep1';
  self.RvProject1.Execute;
   strM.LoadFromFile(PathMem+'rvrep1');
  self.RvRenderPDF1.NDRStream:=strm;
  self.RvRenderPDF1.PrintRender(strm,pr);
  end;
  except
  end;
  end;
  strm.Free;
 // finally
 // self.ColorDBGrid1.DataSource:=self.DataSource1;;
//  end;     }
end;

procedure TfJournal.BitBtn1Click(Sender: TObject);
  function fillStr (str: string; len: integer): string;
  begin
    result := str;
    while length (result) < len do result := result + ' ';
    setLength (result, len);
  end;

var
  i: integer;
  fPrn: System.text;
  KG: STRING;
  fStr: TstringList;
  tprint: tprinter;
  repper: string;
  grN: string;
  staterep: string;
begin

if querymy=nil then
  exit;

  if fileexists(PathMem+'jRep.rav') then
  begin
    try
  self.DBGrid1.DataSource:=nil;;
    raveEx('');
   finally
  self.DBGrid1.DataSource:=self.DataS;;
  end;
  end else
  begin
  try
  self.DBGrid1.DataSource:=nil;;
//if not PrintDialog1.Execute then exit;
i:=0;
  try
  fStr:=TstringList.Create;
  fstr.Clear;
    // AssignPrn(fPrn);
    // Rewrite (fPrn);
 // with printer.Canvas do
    // begin
      // Font.Name := 'Times New Roman';
     //  Font.Size := 8;
     //end;
    {   fStr.Add(DateToStr(DateTimePicker1.Date)+
       '  c  '+ timetostr(dtTimeFrom.Time)+ '  до  '+ timetostr(dtTimeTo.Time));
      // fStr.Add(fillStr('Время', 15)+fillStr('Группа', 18)+fillStr('Состояние', 12)+fillStr('Сообщение', 80){+fillStr('Параметер', 15)//}//;

      { querymy.First;
       while (not (querymy.EOF) and (i<700)) do
       begin
         if pos(uppercase('Событи'),uppercase(trim(querymy.FieldByName ('istate').asstring)))<>0 then
         kg:=FormatDateTime('hh:nn:ss.zzz',querymy.FieldByName ('tm').Value) else
         kg:=FormatDateTime('hh:nn:ss',querymy.FieldByName ('tm').Value);
         fstr.Add(fillStr(trim(KG), 15)+fillStr(trim(querymy.FieldByName ('iparam').asString), 12)+fillStr(trim(querymy.FieldByName ('iState').asString),10)+fillStr(trim(querymy.FieldByName ('icomment').asString), 80){+fillStr(querymy.FieldByName ('iParam').asString,15
           querymy.next;
           inc(i);       }

    //   end;

      //printer.
     //  if i>699 then Showmessage('Количество записей превысело 500 ипри выводена печать было обрезано');
       //if not fileexists('c:\wwww.txt') then
       // fileclose(filecreate('c:\wwww.txt'));
       //fstr.SaveToFile('c:\wwww.txt');
      // self.RichEdit1.Lines.Clear;
      // self.RichEdit1.Lines.AddStrings(fstr);
      // self.RichEdit1.Print('cc');
      // for i:=0 to fStr.Count-1 do
     // self.RvRenderText1.OutputFileName:='c:\wwww.txt';
     // self.RvRenderText1.DocBegin;
    //  self.RvRenderText1.Render('c:\wwww.txt');
     // self.RvRenderPrinter1.InitFileStream('c:\wwww.txt');
     // self.Print;
      // begin
      //  fstr.LoadFromStream();
         //:=FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz',querymy.FieldByName ('tm').Value);

        // writeln(fPrn, fstr.strings[i]);



finally
     fStr.Free;
end;
finally
  self.DBGrid1.DataSource:=self.DataS;;
  end;
end;

end;

procedure TfJournal.BitBtn2Click(Sender: TObject);
begin
    if  querymy<>nil then
    begin
     try
     querymy.Close;
     querymy.Free;
     except
     end;
    end;
   isQact:=false;
  //  bitBtn3.Enabled:=true;
     Hide;
     self.Close;
end;

procedure TfJournal.FormCreate(Sender: TObject);
var
  i: integer;
  T: TDateTimeField;
begin
  rtitems:=TAnalogMems.create(pathmem);
  feditMode:=false;
  filterStr := '';
  left := 0;
  case resolution of
  r640:
    begin
     height := 392;
     width := 640;
     dbGrid1.width := 460;
     dbGrid1.Height := 370;
     for i := 0 to ControlCount - 1 do
       if not (controls[i] is tColorDBGrid) then
         controls[i].Left := controls[i].left - 160;
    end;
  r800:
    begin
     height := 455;
     width := 800;
    end;
  r1024:
    begin
     height := 623;
     width := 1024;
    end;
  r1280:
    begin
     top := 0;
     left := 0;
     height := 880;
     width := 1280;
    end;
  end;
  //заполняем дерево сортировки
 //   with query2 do
   // begin
   {   SQL.Clear;
      SQL.add('select * from groups where parent="Все события"');
      try
      execSQL;
      open;
      except
      end;  }
  //  BaseNode := TreeView1.Items.AddChild(nil,'Все события');
      try

  //    for i := 0 to rtitems.AlarmGroups.Count - 1 do
   //     with TreeView1.Items.AddChild(nil,rtitems.AlarmGroups.Items[i].Name) do
        begin
         // hasChildren := HasChildGG(fieldbyname('Name').asString);
         // next;
        end;
    //  close;
      except
      end;
  //  end;
  //lastFilteredNode := baseNode;

 { querymy.Close;
  T := TDateTimeField.Create(querymy);
   T.FieldName := 'Time';
   T.Name := querymy.Name + 'Time';
   T.Index := 1;
   T.DataSet := querymy;
   T.DisplayFormat := 'hh:nn:ss.zzz'; }
  // querymy.FieldByName('time').SetFieldType(ftDateTime);
  //self.ColorDBGrid1.Columns.Items[1].Field:=T;
   
 //  querymy.FieldDefs.UpDate;
  // ClientDataSet1.Open;
  querymy:=nil;
  repSL:=TStringList.Create;
  self.ReadPeportMenu;


end;


procedure TfJournal.BitBtn3Click(Sender: TObject);
var
 i, j: integer;
 tegList: TStringList;
 str: string;
 grN: string;
begin
   Timer1.Enabled:=false;
   if  querymy<>nil then
    begin
     try
     self.DBGrid1.DataSource.DataSet:=nil;
     self.DBGrid1.Update;
     querymy.Close;
     querymy.Free;
     except
     end;
    end;
   querymy:=TadoQuery.Create(self);
   querymy.OnFetchComplete:=ADOQuery1FetchComplete;
    querymy.OnFetchProgress:=ADOQuery1FetchProgress;
   querymy.OnEditError:=ADOQuery1EditError;
   querymy.OnEditError:=ADOQuery1DeleteError;
   querymy.AfterOpen:=ADOQuery1AfterOpen;
 querymy.CacheSize:=1;
   querymy.Connection:=self.Alarm;
   querymy.LockType:=ltReadOnly;
   querymy.CursorLocation:=clUseClient;
   querymy.Cursortype:=ctStatic;
   querymy.ExecuteOptions:=[eoAsyncExecute, eoAsyncFetch, eoAsyncFetchNonBlocking];

  //if (self.TreeView1.Selected=nil) or (self.TreeView1.Selected.Text='Все события') then grN:=''
 // else grn:=self.TreeView1.Selected.Text;

  querymy.SQL.clear;
 { if GrN='' then  }


 { DefineQueryParameters;  }
 // querymy.SQL.Add('SELECT     f.tm, f.val AS Expr0, s.val AS Expr1, a.val as Expr2 FROM _arch f, _arch s, _arch a '+
  //           'WHERE     ((f.cod = 118) AND (s.cod = 119) and (a.cod=120) and (f.tm=s.tm) and(s.tm=a.tm))');
  querymy.SQL.Add( SQLQ);
  try
 //self.ColorDBGrid1.DataSource:=nil;
 self.DataS.DataSet:=nil;
   querymy.Open;
  // querymy.RecordCount;
 // Label8.Caption:='Запрос серверу';
  Timer1.Enabled:=true;
  self.DataS.DataSet:=querymy;
 self.DBGrid1.DataSource:=self.DataS;
// querymy.Last;
  except
 // Alarm.Errors.Clear;
   // ShowMessage('Нет данных');
  end;
 
end;

function TfJournal.HasChildGG(GroupName: string): boolean;
begin
  {  with query3 do
    begin
      SQL.Clear;
      SQL.add('select * from groups where (parent = "' + GroupName + '") and (isTag = :isTag)');
      Parameters.ParambyName('isTag').Value:=integer(false);
    //  execSQL;
      open;
      result := RecordCount > 0;
      close;
    end;   }
end;

procedure TfJournal.TreeView1Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  i: integer;
begin
  {if node.HasChildren and (node.Count = 0) then
    with query2 do
    begin
      SQL.Clear;
      SQL.add('select * from groups where parent ="' + Node.Text + '"');
      execSQL;
      open;
      //сначала добавляем группы
      for i := 0 to RecordCount - 1 do
      begin
       if not fieldByName('isTag').AsBoolean then
         with TreeView1.Items.AddChild(Node,fieldbyname('Name').asString) do
         begin
          hasChildren := hasChildGG(text);
         end;
         next;
       end;
      //затем добавляем теги
      {first;
      for i := 0 to RecordCount - 1 do
      begin
       if fieldByName('isTag').AsBoolean then
        with TreeView1.Items.AddChild(Node,fieldbyname('Name').asString) do
        begin
          hasChildren := false;
        end;
        next;
       end;}
     { close;
    end;   }

end;

procedure TfJournal.FillNodeListByParent(parent: string; List: TStringList);
var
  i: integer;
  query: TQuery;
begin
 { query := TQuery.Create(self);
  query.databasename := 'trend';
  try
    with query do
    begin
      SQL.Clear;
      SQL.add('select * from groups where parent ="' + parent + '"');
      execSQL;
      open;
      //сначала добавляем группы
      for i := 0 to RecordCount - 1 do
      begin
       if fieldByName('isTag').AsBoolean then
         begin
         list.Add(fieldByName('Name').AsString)

         end
       else
         FillNodeListByParent(fieldByName('Name').AsString, list);
       next;
       end;
      //затем добавляем теги
      {first;
      for i := 0 to RecordCount - 1 do
      begin
       if fieldByName('isTag').AsBoolean then
        with TreeView1.Items.AddChild(Node,fieldbyname('Name').asString) do
        begin
          hasChildren := false;
        end;
        next;
       end;}
     { close;
    end;
  finally
    Query.free;
  end;   }
end;

procedure TfJournal.DefineQueryParameters;
begin
    if querymy=nil then exit;

end;

procedure TfJournal.DefineQueryText;
begin
 { querymy.Close;
 //if QueryDate = dateTimePicker1.Date then exit;
  QueryDate := dateTimePicker1.Date;

{  Params := tParams.create;
  Params.assign(querymy.Params);}
 { querymy.SQL.Clear;
  querymy.SQL.Add(
  'UPDATE "'+datetoFileName(dateTimePicker1.Date)+'" table1 SET SELECTED = true '+
//'SELECT "' + datetostr(dateTimePicker1.Date) + '" as Дата, table1."Time" ,  table1."Comment" , table1."Param",  table1."Operator",' +
//'table1."Level" ,  table1."State" ' +
//'FROM "' + DateString + '"  table1 ' +
'WHERE (' + filterStr +
'        ( table1."Time"  >= :TimeFrom) AND'+
'        ( table1."Time"  <= :TimeTo) AND' +
'        (  (  ( table1."State" = :StateKvit)  or' +
'              ( table1."State" = :StateOn)  or' +
'              ( table1."State" = :StateOff)' +
'              AND' +
'              ( table1."Level"  >= :LevelFrom) AND'+
'              ( table1."Level"  <= :LevelTo)' +
           ') or ' +
'           ( table1."State" = :StateMsgOn)  or' +
'           ( table1."State" = :StateMsgOff)  or' +
'           ( table1."State" = :StateCommand)' +
'        )'+
'      )');
end;

procedure TfJournal.ColorDBGrid1DblClick(Sender: TObject);
begin
  BitBtn3Click(self);  }
end;

procedure TfJournal.AlarmBeforeConnect(Sender: TObject);
begin
if not asyncBase then alarm.ConnectOptions:=coConnectUnspecified;
alarm.ConnectionString:=CSTrend;
end;

procedure TfJournal.AlarmConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
var GRn: string;
begin

 if not alarm.connected then
 begin
 //label8.Caption:='';
   //label7.Caption:='';
   timer1.Enabled:=false;
showmessage('Не удалось связатся с сервером');
end;
end;

procedure TfJournal.DataSStateChange(Sender: TObject);
begin
  TMyColorDBGrid(self.DBGrid1).ColWidthsChanged;
    TMyColorDBGrid(self.DBGrid1).EndUpdate;
end;

procedure TfJournal.query1BeforeOpen(DataSet: TDataSet);
begin
if querymy=nil then exit;
if not asyncBase then
begin
  querymy.ExecuteOptions:=[];
end;
end;

procedure TfJournal.AlarmExecuteComplete(Connection: TADOConnection;
  RecordsAffected: Integer; const Error: Error;
  var EventStatus: TEventStatus; const Command: _Command;
  const Recordset: _Recordset);
begin
  //label8.Caption:='';
  // label7.Caption:='';
   timer1.Enabled:=false;
  if error=nil then
  begin

  exit;
  end;
  if error.number=-2147217865 then
  Showmessage('На текущую дату нет данных');

end;

procedure TfJournal.ADOQuery1EditError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  DBGrid1.DataSource;
 // label8.Caption:='';
  // label7.Caption:='';
end;

procedure TfJournal.ADOQuery1DeleteError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
   DBGrid1.DataSource;
  // label8.Caption:='';
 //  label7.Caption:='';
end;

procedure TfJournal.ADOQuery1AfterOpen(DataSet: TDataSet);
begin
  querymy.First;
 // label8.Caption:='';
  //timer1.Enabled:=false;
end;

procedure TfJournal.ADOQuery1FetchComplete(DataSet: TCustomADODataSet;
  const Error: Error; var EventStatus: TEventStatus);
begin
  // label7.Caption:='';
end;

procedure TfJournal.ADOQuery1FetchProgress(DataSet: TCustomADODataSet;
  Progress, MaxProgress: Integer; var EventStatus: TEventStatus);
begin
//  if (label7.Caption='') or (label7.Caption='Чтение данных -') then
   // label7.Caption:='Чтение данных /' else label7.Caption:='Чтение данных -'

end;

procedure TfJournal.Timer1Timer(Sender: TObject);
var i,j: integer;
begin
//label8.Caption:='Ожидание ответа';
 i:=SecondOfTheMinute(now);
 i:= i mod 10;
// for j:=0 to i do label8.Caption:=label8.Caption+'.';
 //label8.Font.Color:=  not label8.Font.Color;
end;

procedure TfJournal.BitBtn4Click(Sender: TObject);
function fillStr (str: string; len: integer): string;
  begin
    result := str;
    while length (result) < len do result := result + ' ';
    setLength (result, len);
   // result:=result+'|';
  end;

var
  i: integer;
  fPrn: System.text;
  KG: STRING;
  fStr: TstringList;
  tprint: tprinter;
begin



end;

procedure TfJournal.RvSystem1Print(Sender: TObject);
begin
exit;
end;

procedure TfJournal.N1Click(Sender: TObject);
begin
 editMode:=not  editMode;
 //  editMode:=self.PopupMenuEditMode.Items[0].Checked;
end;

procedure TfJournal.PopupMenuEditModePopup(Sender: TObject);
begin
 n1.Checked:=feditMode;
end;

procedure  TfJournal.SetEm(val: boolean);
var i: integer;
    MI,MIO: TMenuItem;
begin
  feditMode:=val;
  n1.Checked:=feditMode;
  for i:=0 to self.ReportMenu.ComponentCount-1  do
    begin
    if (self.ReportMenu.Components[i] is TMenuItem) then
       begin
       MIO:=self.ReportMenu.Components[i] as TMenuItem;
        if (MIO.Tag>5) then
          begin
           MIO.Visible:=feditMode;
          end;
        end;
     end;   
end;

function TfJournal.GetEm: boolean;
begin
   result:=feditMode;
end;

function TfJournal.ReadPeportMenu: boolean;
var filestr: TFilestream;
    MI,MIO: TMenuItem;
    i:integer;
begin

  if FileExists(pathmem+'ReportLogika.men') then
    begin
      try
      filestr:=TFilestream.Create(pathmem+'ReportLogika.men',fmOpenRead);
      filestr.ReadComponent(self.ReportMenu);


       for i:=0 to self.ReportMenu.ComponentCount-1  do
       begin
       if (self.ReportMenu.Components[i] is TMenuItem) then
       begin
       MIO:=self.ReportMenu.Components[i] as TMenuItem;
       if (MIO.Tag=9) then
         begin
         MIO.OnClick:=AddPunkt;
         end;
       if (MIO.Tag=10) then
         begin
         MIO.OnClick:=DelPunkt;
         end;
       if (MIO.Tag=7) then
         begin
         MIO.OnClick:=AddReport;
         end;
       if (MIO.Tag=8) then
         begin
         MIO.OnClick:=DelReport;
         end;
        end;
       if (MIO.Tag=3) then
         begin
         MIO.OnClick:=ExecReport;
         end;
        
        end;


      except
      if filestr<>nil then filestr.Free;
        self.ReportMenu.Items.Clear;
      MI:=TMenuItem.Create(self.ReportMenu);
      self.ReportMenu.Items.Add(MI);
      MI.Caption:='Добавить пункт';
      MI.OnClick:=AddPunkt;
      MI.Tag:=9;
      MI:=TMenuItem.Create(self.ReportMenu);
      self.ReportMenu.Items.Add(MI);
      MI.Caption:='Удалить пункт';
      MI.OnClick:=DelPunkt;
      MI.Tag:=10;
      WritePeportMenu;
      end;
      if filestr<>nil then filestr.Free;
    end
  else
    begin
      self.ReportMenu.Items.Clear;
      MI:=TMenuItem.Create(self.ReportMenu);
      self.ReportMenu.Items.Add(MI);
      MI.Caption:='Добавить пункт';
      MI.OnClick:=AddPunkt;
      MI.Tag:=9;
      MI:=TMenuItem.Create(self.ReportMenu);
      self.ReportMenu.Items.Add(MI);
      MI.Caption:='Удалить пункт';
      MI.OnClick:=DelPunkt;
      MI.Tag:=10;
      WritePeportMenu;

    end;
end;

function TfJournal.WritePeportMenu: boolean;
var filestr: TFilestream;
    MI, MIO: TMenuItem;
    i: integer;
begin
   for i:=0 to self.ReportMenu.ComponentCount-1  do
     begin
       if (self.ReportMenu.Components[i] is TMenuItem) then
       begin
          MIO:=self.ReportMenu.Components[i] as TMenuItem;
           if (MIO.Tag>5) then
            begin
             MIO.Visible:=false;
            end;
       end;
     end;
  if FileExists(pathmem+'ReportLogika.men') then
    begin
      try
      filestr:=TFilestream.Create(pathmem+'ReportLogika.men',fmOpenWrite);
      filestr.WriteComponent(self.ReportMenu);
      except
      end;
      if filestr<>nil then filestr.Free;
    end
  else
    begin
      try
      filestr:=TFilestream.Create(pathmem+'ReportLogika.men',fmCreate	);
      filestr.WriteComponent(self.ReportMenu);
      except
      end;
      if filestr<>nil then filestr.Free;
    end;
    for i:=0 to self.ReportMenu.ComponentCount-1  do
     begin
       if (self.ReportMenu.Components[i] is TMenuItem) then
       begin
          MIO:=self.ReportMenu.Components[i] as TMenuItem;
           if (MIO.Tag>5) then
            begin
             MIO.Visible:=feditMode;
            end;
       end;
     end;
end;

procedure TfJournal.AddPunkt(Sender: TObject);
var
  AddPF: TAddPForm;
  MI: TMenuItem;
begin
   try

   AddPF:=TAddPForm.Create(self);
   AddPF.Caption:='Добавление пункта меню';
   if (AddPF.GetNm=MrOk) then
    begin
      if AddPF.Nm<>'' then
        begin
           AddSub(AddPF.Nm);
        end;
    end;
   finally
   AddPF.Free;
   end;
end;

procedure TfJournal.DelPunkt(Sender: TObject);
begin
    //
end;

procedure TfJournal.AddReport(Sender: TObject);
var
  AddPF: TAddPForm;
  MI: TMenuItem;
begin
    try

   AddPF:=TAddPForm.Create(self);
   AddPF.Caption:='Добавление пункта отчета';
   if (AddPF.GetNm=MrOk) then
    begin
      if AddPF.Nm<>'' then
        begin
          AddReportInM(TMenuItem(Sender).Parent, AddPF.Nm);
        end;
    end;
   finally
   AddPF.Free;
   end;
end;

procedure TfJournal.DelReport(Sender: TObject);
begin
    //
end;

procedure TfJournal.AddSub(Name: string);
var
    MI,MI1: TMenuItem;
    i:integer;
begin
   if (self.ReportMenu.Items.Find(Name)=nil) then
     begin
      MI:=TMenuItem.Create(self.ReportMenu);
      self.ReportMenu.Items.Add(MI);
      MI.Caption:=Name;
      MI.Tag:=0;
      MI1:=TMenuItem.Create(self.ReportMenu);
      MI.Add(MI1);
      MI1.Caption:='Добавить отчет';
      MI1.OnClick:=AddReport;
      MI1.Tag:=7;
      MI1:=TMenuItem.Create(self.ReportMenu);
      MI.Add(MI1);
      MI1.Caption:='Удалить отчет';
      MI1.OnClick:=DelReport;
      MI1.Tag:=8;
      WritePeportMenu;

     end
    else
      begin
        MessageBox(0,PChar('Пункт :  ' +Name +' уже сужествует '),
           'Ошибка',
                  MB_OK+MB_TOPMOST+MB_ICONERROR);
      end;
end;

procedure TfJournal.AddReportInM(MIP: TMenuItem; Name: string);
var
    MI,MI1: TMenuItem;
    i:integer;
begin
   if (MIP.Find(Name)=nil) then
     begin
      MI:=TMenuItem.Create(self.ReportMenu);
      MIP.Add(MI);
      MI.Caption:=Name;
      MI.Tag:=3;
      WritePeportMenu;

     end
    else
     begin
       MessageBox(0,PChar('Отчет :  ' +Name +' уже сужествует ')
           ,'Ошибка',
                  MB_OK+MB_TOPMOST+MB_ICONERROR);
     end;
end;


procedure TfJournal.ExecReport(Sender: TObject);
var RE: TRepEdit;
    nm: string;
begin
    if ( (Sender is TMenuitem) and
      ((Sender as TMenuitem).Parent<>nil )) then
    nm:=(Sender as TMenuitem).Parent.Caption+'_'+(Sender as TMenuitem).Caption+'.lgrep'
    else exit;
    if (EditMode=true) then
      begin
         try
         RE:=TRepEdit.Create(self);
         if RE.EditRep((Sender as TMenuitem).Caption, nm)=MrOK then
           RE.RichEdit1.Lines.SaveToFile(nm);
         finally
            RE.Free;
         end;
      end
    else
      begin
        try
        self.Caption:=nm;
        repSL.LoadFromFile(nm);
        CreteSQL;
        BitBtn3Click(nil);
        except
        end;
      end;
end;

procedure TfJournal.FormDestroy(Sender: TObject);
begin
repSL.Free;
end;

procedure TfJournal.CreteSQL;
var i: integer;
    sq:string;
begin
sq:='SELECT  distinct aaaaa0.tm, ';
for i:=0 to repSL.Count-1 do
 begin
    if (i<>(repSL.Count-1)) then sq:=sq+'aaaaa'+inttostr(i+1)+'.val as '+ repSL.Strings[i]+', ' else
    sq:=sq+'aaaaa'+inttostr(i+1)+'.val as '+ repSL.Strings[i]+' ';

     // if (i<>(repSL.Count-1)) then sq:=sq+'aaaaa'+inttostr(i+1)+'.val , ' else
   // sq:=sq+'aaaaa'+inttostr(i+1)+'.val ';
 end;
sq:=sq+' FROM _arch aaaaa0';
for i:=0 to repSL.Count-1 do
 begin
    if (i<>(repSL.Count-1)) then sq:=sq+' FULL OUTER JOIN _arch '+ 'aaaaa'+inttostr(i+1)+ ' ON '+
    'aaaaa'+inttostr(i+1)+'.nm like '''+repSL.Strings[i]+''' and aaaaa'+inttostr(i+1)+'.tm=aaaaa0.tm'
     else
    sq:=sq+' FULL OUTER JOIN _arch '+ 'aaaaa'+inttostr(i+1)+ ' ON '+
    'aaaaa'+inttostr(i+1)+'.nm like '''+repSL.Strings[i]+''' and aaaaa'+inttostr(i+1)+'.tm=aaaaa0.tm'
 end;
sq:=sq+' WHERE not (aaaaa0.tm is null) and not (';

for i:=0 to repSL.Count-1 do
 begin
     if (i<>(repSL.Count-1)) then
    sq:=sq+'aaaaa'+inttostr(i+1)+ '.val is null and ' else
     sq:=sq+'aaaaa'+inttostr(i+1)+ '.val is null) ';
 end;
sq:=sq+' order by aaaaa0.tm desc';
{for i:=0 to repSL.Count-1 do
 begin
    if (i<>(repSL.Count-1)) then sq:=sq+'(aaaaa'+inttostr(i+1)+'.nm like '''+repSL.Strings[i]+''' or aaaaa'+inttostr(i+1)+'.nm like NULL) and' else

     sq:=sq+'(aaaaa'+inttostr(i+1)+'.nm like '''+repSL.Strings[i]+''' or aaaaa'+inttostr(i+1)+'.nm like NULL)';
 end;
 if repSL.Count>1 then sq:=sq+' and ' else sq:=sq+')';
 for i:=0 to repSL.Count-2 do
 begin
    if (i<>(repSL.Count-2)) then sq:=sq+' (aaaaa'+inttostr(i+1)+'.tm='+'aaaaa'+inttostr(i+2)+'.tm or aaaaa'+inttostr(i+1)+'.tm=NULL or aaaaa'+inttostr(i+2)+'.tm=NULL) and ' else
     sq:=sq+' (aaaaa'+inttostr(i+1)+'.tm='+'aaaaa'+inttostr(i+2)+'.tm or aaaaa'+inttostr(i+1)+'.tm=NULL or aaaaa'+inttostr(i+2)+'.tm=NULL))';
 end;  }

 SQLQ:=sq;
end;



end.
