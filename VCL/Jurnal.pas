unit Jurnal;

interface

uses
  SysUtils, Classes, Controls, Grids,  constdef, dialogs, math,
  MemStructsU, GroupsU, Messages, Forms, expr,{ debugClasses,} Printers, JurnalTree, StrUtils,
  JurnalEditor, GlobalValue, ColorStringGrid, Graphics, windows;

type

  TColumn = class(TCollectionItem)
  private
    fcaption: string;
    fvisible: boolean;
    fWidth: integer;
  public
   constructor Create(Collection: TCollection); override;
  published
    property caption: string read fCaption write fCaption;
    property visible: boolean read fVisible write fVisible;
    property width : integer read fWidth write fWidth;
  end;


//  TColumns = class(TList)
  TColumns = class(TCollection)
  private
    function GetItem(i: integer): TColumn;
    procedure SetItem(i: integer; const Value: TColumn);
  public
   property Items[i: integer]: TColumn read GetItem write SetItem; default;
  end;

  TSelectCondition = class
  private
    fLevelFrom, fLevelTo: integer;
    //fTimeFrom,
    fTimeTo: TDateTime;
    fTegList: TstringList;
    fMsgState: TMsgState;
    fAlarmGroupID: integer;
    procedure SetTegList(const Value: TStringList);
  public
    constructor Create;
    destructor destroy; override;
    function CheckAlarms(num: integer; act: boolean): boolean;

  published
    property AlarmGroupID: integer read fAlarmGroupID write fAlarmGroupID;
    property LevelFrom: integer read flevelFrom write fLevelFrom;
    property LevelTo: integer read flevelTo write fLevelTo;
    property MsgState: TMsgState read fMsgState write fMsgState;
    //property TimeFrom: TDateTime read fTimeFrom write fTimeFrom;
    property TimeTo: TDateTime read fTimeTo write fTimeTo;
    property TegList: TStringList read fTegList write SetTegList;
  end;

  {***************** TJurnal *******************************************}
  TJurnal = class(TColorStringGrid)
  private
    fColumns: TColumns;
    QueryText: string;
    fExprGroupID: integer; //ID тега, группа алармов которого используется
   // dsMain: TDataSource;
    fPrevAlarmGroup: integer; //предыдущая активная группа. Если группа меняется, то перезапрашиваем, если autoShow;
     fauto: boolean;
    //Управляющие выражения
    fExprCmdShow: tExpretion;
    fExprCmdShowAuto: tExpretion;
    fExprCmdPrint: tExpretion;
    fExprmsNew: tExpretion;
    fExprmsKvit: tExpretion;
    fExprmsOut: tExpretion;
    fExprmsOn: tExpretion;
    fExprmsOff: tExpretion;
    fExprmsCmd: tExpretion;
    fExprLevelFrom, fExprLevelTo: tExpretion;
    //fExprDate: tExpretion;
    //fExprTimeFrom,
    fExprTimeTo: tExpretion;

    fExprGroupStr: TExprStr;//показывать теги с идентичной группой алармов
    fExprCmdShowStr: TExprStr; //команда отобразить/обновить
    fExprCmdShowAutoStr: TExprStr; //команда отобразить/обновить
    fExprCmdPrintStr: TExprStr; //команда отобразить/обновить
    fExprmsNewStr: TExprStr;
    fExprmsKvitStr: TExprStr;
    fExprmsOutStr: TExprStr;
    fExprmsOnStr: TExprStr;
    fExprmsOffStr: tExprStr;
    fExprmsCmdStr: tExprStr;
    fExprLevelFromStr, fExprLevelToStr: TExprStr;
    //fExprDateStr: TexprStr;
    fExprTimeFromStr, fexprTimeToStr: TExprStr;

    fJurnalTree: TJurnalTree;
    fShowActive: boolean; //Журнал активных тревог
    fActiveLastNumber: integer;
    fAlarm_Cursor: integer;
    //настройки цветов сообщений
    fcolorEvent, fColorAl, fColorAlKvit, fColorAv, fColorAvKvit, fColorAlOut, fColorAvOut, fColorCMD: TColor;
    fgrRowCount: integer;
    AlarmCurLinePrev: integer;
    fAlarm_CursorDelt: integer;
    fAlarm_CursorCount: integer;
    procedure SetExprGroup(const Value: TExprStr);
    procedure SetGrRowCount(const Value: integer);
    procedure CheckTegOption; //проверяет, определены ни теги опций и присваивает из значения
    procedure FillCaptions;
    procedure FillCells;
    procedure FillActiveAlarms; //перерисовать видимую область
    procedure FillAlarms;//перерисовать видимую область
    procedure fillRowActive(grRow, alRow: integer);//Отобразить заданную строку в алармах на заданную строку в гриде
    procedure fillRowAlarm(grRow, alRow: integer);//Отобразить заданную строку в алармах на заданную строку в гриде
    procedure ClearRow(row: integer);
    function FillRowLess: boolean; //Заполнять невидимую строку, и если удачно, то крутить
    //function FillRowMore(DateTime: TDateTime): boolean;
    procedure moveRows(Source, Destination, Count: integer);
    procedure JurnalOnNewAlarm(AlarmNum: Integer);
    procedure Setalarm_Cursor(val: integer);

  protected
    { Protected declarations }
  public
    { Public declarations }
    sc: TSelectCondition;
    ///: TQuery;
    filterStr: string;
    grTimeFrom, GrTimeTo: TDateTime;
    function Inc_alarm_Cursor(val: integer): integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PrepareTegList;
    procedure Print;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    //procedure ImmiBlinkOn (var Msg: TMessage); message WM_IMMIBLINKON;
    //procedure ImmiBlinkOff (var Msg: TMessage); message WM_IMMIBLINKOFF;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function ShowPropForm: boolean; virtual;
    procedure ShowPropFormMsg (var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMKEYUP(var Msg: TWMVScroll); message WM_KEYUP;
    procedure WMCREATE(var Msg: TWMVScroll); message WM_CREATE;
    property  Alarm_Cursor: integer read fAlarm_Cursor write setAlarm_Cursor;
    property  Alarm_CursorDelt:integer read fAlarm_CursorDelt;
    property  Alarm_CursorCount:integer read fAlarm_CursorCount;
  published
    { Published declarations }
    property columns: TColumns read fColumns write fColumns;
    property ExprGroup: TExprStr read fExprGroupStr write SetExprGroup;
    property ExprCmdShow: TExprStr read fExprCmdShowStr write fExprCmdShowStr;
    property ExprCmdShowAuto: TExprStr read fExprCmdShowAutoStr write fExprCmdShowAutoStr;
    property ExprCmdPrint: TExprStr read fExprCmdPrintStr write fExprCmdPrintStr;
    property ExprmsNew: TExprStr read fExprmsNewStr write fExprmsNewStr;
    property ExprmsKvit: TExprStr read fExprmsKvitStr write fExprmsKvitStr;
    property ExprmsOut: TExprStr read fExprmsOutStr write fExprmsOutStr;
    property ExprmsOn: TExprStr read fExprmsOnStr write fExprmsOnStr;
    property ExprmsOff: TExprStr read fExprmsOffStr write fExprmsOffStr;
    property ExprmsCmd: TExprStr read fExprmsCmdStr write fExprmsCmdStr;
    property ExprLevelFrom: TExprStr read fExprLevelFromStr write fExprLevelFromStr;
    property ExprLevelTo: TExprStr read fExprLevelToStr write fExprLevelToStr;
    property exprTimeTo: TExprStr read fexprTimeToStr write fexprTimeToStr;

    property JurnalTree: TJurnalTree read fJurnalTree write fJurnalTree;
    property ShowActive: boolean read fShowActive write fShowActive;


    //настройки цветов сообщений
    property colorEvent: TColor read fColorEvent write fColorEvent;
    property colorCmd: TColor read fColorCmd write fColorCmd;
    property ColorAl: TColor read fColorAl write fColorAl;
    property ColorAv: TColor read fColorAv write fColorAv;
    property ColorAlKvit: TColor read fColorAlKvit write fColorAlKvit;
    property ColorAvKvit: TColor read fColorAvKvit write fColorAvKvit;
    property ColorAlOut: TColor read fColorAlOut write fColorAlOut;
    property ColorAvOut: TColor read fColorAvOut write fColorAvOut;

    property grRowCount: integer read fgrRowCount write SetGrRowCount;
  end;


implementation


{ TJurnal }

procedure TJurnal.CheckTegOption;
begin
  if assigned(fExprmsNew) then
  begin
    fExprmsNew.ImmiUpdate;

    if fExprmsNew.Istrue  then sc.fMsgState := sc.fMsgState + [msNew] else sc.fMsgState := sc.fMsgState - [msNew];
  end;
  if assigned(fExprmsKvit) then
  begin
    fExprmsKvit.ImmiUpdate;
    if fExprmsKvit.Istrue  then sc.fMsgState := sc.fMsgState + [msKvit] else sc.fMsgState := sc.fMsgState - [msKvit];
  end;
  if assigned(fExprmsOut) then
  begin
    fExprmsOut.ImmiUpdate;
    if fExprmsOut.Istrue  then sc.fMsgState := sc.fMsgState + [msOut] else sc.fMsgState := sc.fMsgState - [msOut];
  end;
  if assigned(fExprmsOn) then
  begin
    fExprmsOn.ImmiUpdate;
    if fExprmsOn.Istrue  then sc.fMsgState := sc.fMsgState + [msOn] else sc.fMsgState := sc.fMsgState - [msOn];
  end;
  if assigned(fExprmsOff) then
  begin
    fExprmsOff.ImmiUpdate;
    if fExprmsOff.Istrue  then sc.fMsgState := sc.fMsgState + [msOff] else sc.fMsgState := sc.fMsgState - [msOff];
  end;
  if assigned(fExprmsCmd) then
  begin
    fExprmsCmd.ImmiUpdate;
    if fExprmsCmd.Istrue  then sc.fMsgState := sc.fMsgState + [msCmd] else sc.fMsgState := sc.fMsgState - [msCmd];
  end;
  if assigned(fExprLevelFrom) then
  begin
    fExprLevelFrom.ImmiUpdate;
    sc.Levelfrom := trunc(fExprLevelFrom.Value);
  end;
  if assigned(fExprLevelTo) then
  begin
    fExprLevelTo.ImmiUpdate;
    sc.LevelTo := trunc(fExprLevelTo.Value);
  end;
  {if assigned(fExprTimeFrom) then
  begin
    fExprTimeFrom.ImmiUpdate;
    sc.TimeFrom := TDateTime(fExprTimeFrom.Value);
  end;}
  if assigned(fExprTimeTo) then
  begin
    fExprTimeTo.ImmiUpdate;
    sc.TimeTo := TDateTime(fExprTimeTo.Value);
    //ShowMessage(DateTimetostr(sc.TimeTo));
  end;
end;



constructor TJurnal.Create(AOwner: TComponent);
var
  newColumn: TColumn;
begin
  inherited;
  rowCount := 100; //для определения количества видимых строк
  fgrRowCount := 0; //Здесь количество строк (rowCount) модифицируется
  JurnalTree := nil;
  grTimeTo := 0;
  filterStr := '';
  fExprGroupID := -1;
  fPrevAlarmGroup := -1;
  options := options + [goColSizing] - [goEditing, goRangeSelect];
  sc := TSelectCondition.Create;
  fauto:=false;
  fColumns := TColumns.Create(TColumn);
  fAlarm_Cursor:=0;
  //newColumn := TColumn.Create;
  newColumn := TColumn(Columns.Add);
  newColumn.caption := 'Дата';
  newColumn.Width := 60;
  //Columns.Add(newColumn);
  //newColumn := TColumn.Create;
  newColumn := TColumn(Columns.Add);
  newColumn.caption := 'Время';
  newColumn.Width := 60;
  //Columns.Add(newColumn);
  //newColumn := TColumn.Create;
  newColumn := TColumn(Columns.Add);
  newColumn.caption := 'Комментарий';
  newColumn.Width := 500;
  //Columns.Add(newColumn);
  //newColumn := TColumn.Create;
  newColumn := TColumn(Columns.Add);
  newColumn.caption := 'Оператор';
  newColumn.Width := 160;
  //Columns.Add(newColumn);
  //newColumn := TColumn.Create;
  newColumn := TColumn(Columns.Add);
  newColumn.caption := 'Параметр';
  newColumn.Width := 120;
  //Columns.Add(newColumn);
  //newColumn := TColumn.Create;
  newColumn := TColumn(Columns.Add);
  newColumn.caption := 'Состояние';
  newColumn.Width := 120;
  //Columns.Add(newColumn);
  //newColumn := TColumn.Create;
  newColumn := TColumn(Columns.Add);
  newColumn.caption := 'Уровень';
  newColumn.Width := 60;
  //Columns.Add(newColumn);


  //qryMain := TQuery.Create(self);
 // qryMain.DataBaseName := 'alarms';
 // dsMain := TDataSource.Create(self);
  //dsMain.dataSet := qryMain;
end;

destructor TJurnal.Destroy;
begin
  fColumns.Free;
  fExprCmdShow.free;
  fExprCmdPrint.free;
  fExprmsNew.free;
  fExprmsKvit.free;
  fExprmsOut.free;
  fExprmsOn.free;
  fExprmsOff.free;
  fExprmsCmd.free;
  fExprLevelFrom.Free;
  fExprLevelTo.free;
  //fExprDate.free;
  //fExprTimeFrom.free;
  fexprTimeTo.free;

  //dsMain.free;
 // qryMain.free;
  sc.Free;
  inherited;
end;





procedure TJurnal.Setalarm_Cursor(val: integer);
begin
  if val<0 then val:=0;
  if val>rtitems.alarms.Count-1 then val:=rtitems.alarms.Count-1;
  falarm_Cursor:=val;
end;

function TJurnal.Inc_alarm_Cursor(val: integer): integer;
var i,j,res: integer;
begin
   j:=0;
   for i:=0 to rtitems.alarms.Count-1 do
       if sc.CheckAlarms(i,fauto) then inc(j);
   falarm_Cursorcount:=j-1;
   i:=0;
   j:=alarm_Cursor;
   res:=alarm_Cursor;
   if val=0 then exit;
    if alarm_Cursor>=rtitems.alarms.Count-1 then falarm_Cursordelt:=0;
   if (alarm_Cursor>=rtitems.alarms.Count-1) and (val>0) then exit;
   if (alarm_Cursor<=0) and (val<0) then exit;
   if val>0 then
    begin
      while (i<val) and (res<rtitems.alarms.Count) do
        begin
          inc(res);
          if  (res<rtitems.alarms.Count) and (sc.CheckAlarms(res,fauto)) then inc(i);
        end;
    end
   else
    begin
      while (i<abs(val)) and (res>-1) do
        begin
          dec(res);
          if (res>-1) and (sc.CheckAlarms(res,fauto))  then inc(i);
        end;
    end;
     alarm_Cursor:=res;
    if alarm_Cursor>=rtitems.alarms.Count-1 then falarm_Cursordelt:=0 else
    falarm_Cursordelt:=1;


  result:=0;
end;

procedure TJurnal.FillCaptions;
var
 i: integer;
begin
  fixedCols := 0;
  ColCount := 1;
  for i := 0 to Columns.Count - 1 do
    if Columns[i].visible  then
    begin
      cells[ColCount-1, 0] := Columns[i].caption;
      ColWidths[ColCount-1] := Columns[i].Width;
      ColCount := ColCount + 1;
    end;
    ColCount := ColCount - 1;
end;

procedure TJurnal.ImmiInit(var Msg: TMessage);
begin
  FillCaptions;
  fExprGroupID := rtItems.GetSimpleID(fExprGroupStr);

  CreateAndInitExpretion(fExprCmdShow, fExprCmdShowStr);
  CreateAndInitExpretion(fExprCmdShowAuto, fExprCmdShowAutoStr);
  CreateAndInitExpretion(fExprCmdPrint, fExprCmdPrintStr);
  CreateAndInitExpretion(fExprmsNew, fExprmsNewStr);
  CreateAndInitExpretion(fExprmsKvit, fExprmsKvitStr);
  CreateAndInitExpretion(fExprmsOut, fExprmsOutStr);
  CreateAndInitExpretion(fExprmsOn, fExprmsOnStr);
  CreateAndInitExpretion(fExprmsOff, fExprmsOffStr);
  CreateAndInitExpretion(fExprmsCmd, fExprmsCmdStr);
  CreateAndInitExpretion(fExprLevelFrom, fExprLevelFromStr);
  CreateAndInitExpretion(fExprLevelTo, fExprLevelToStr);
  //CreateAndInitExpretion(fExprDate, fExprDateStr);
  //CreateAndInitExpretion(fExprTimeFrom, fExprTimeFromStr);
  CreateAndInitExpretion(fExprTimeTo, fExprTimeToStr);
  //FillCells;
end;

procedure TJurnal.ImmiUnInit(var Msg: TMessage);
begin
  if assigned(fExprCmdShow) then fExprCmdShow.IMMIUnInit;
  if assigned(fExprCmdPrint) then fExprCmdPrint.IMMIUnInit;
  if assigned(fExprmsNew) then fExprmsNew.IMMIUnInit;
  if assigned(fExprmsKvit) then fExprmsKvit.IMMIUnInit;
  if assigned(fExprmsOut) then fExprmsOut.IMMIUnInit;
  if assigned(fExprmsOff) then fExprmsOff.IMMIUnInit;
  if assigned(fExprmsCmd) then fExprmsCmd.IMMIUnInit;
  if assigned(fExprLevelFrom) then fExprLevelFrom.IMMIUnInit;
  if assigned(fExprLevelTo) then fExprLevelTo.IMMIUnInit;
  //if assigned(fExprDate) then fExprdate.IMMIUnInit;
  //if assigned(fExprTimeFrom) then fExprTimeFrom.IMMIUnInit;
  if assigned(fExprTimeTo) then fExprTimeTo.IMMIUnInit;
end;

procedure TJurnal.ImmiUpdate(var Msg: TMessage);
var
  id: integer;
begin
  if fShowActive and (fActiveLastNumber <> rtItems.activeAlarms.LastNumber) then
  begin
    fillCells;
    fActiveLastNumber := rtItems.activeAlarms.LastNumber;
    TopRow := RowCount - VisibleRowCount;
    fillCells;
  end;

  //Нет ли команды "Показать"?
  if assigned(fExprCmdShow) then
  begin
    fExprCmdShow.ImmiUpdate;
    if (fExprCmdShow.Value = 1)  then
    begin
      id := rtItems.GetSimpleID(fExprCmdShowStr);
      if ID <>  -1 then
      begin
        rtitems[ID].ValReal := 0;
        FillCells;
      end;
    end;
  end;
  //Нет ли команды "Напечатать"?
  if assigned(fExprCmdPrint) then
  begin
    fExprCmdPrint.ImmiUpdate;
    if (fExprCmdPrint.Value = 1)  then
    begin
      id := rtItems.GetSimpleID(fExprCmdPrintStr);
      if ID <>  -1 then
      begin
        rtitems[ID].ValReal := 0;
        Print;
      end;
    end;
  end;
  //Тег принадлежит ссылочной группе, и ссылка обновилась - надо обновить журнал
  if fExprGroupID <> -1 then
  begin
  if fPrevAlarmGroup <> rtItems[fExprGroupID].alarmGroup then
  begin
    fPrevAlarmGroup := rtItems[fExprGroupID].alarmGroup;
    if fPrevAlarmGroup <> -1 then fillCells;
  end;
  end;
  if (rtItems.Alarms.CurLine <> AlarmCurLinePrev) and (assigned(fExprCmdShowAuto)) then
  begin
    fExprCmdShowAuto.ImmiUpdate;
    fauto:=fExprCmdShowAuto.isTrue;
    AlarmCurLinePrev := rtItems.Alarms.CurLine;
    JurnalOnNewAlarm(rtItems.Alarms.CurLine);
  end;
end;

procedure TJurnal.Print;
var
  fPrn: System.text;
begin


end;

procedure TJurnal.SetExprGroup(const Value: TExprStr);
begin
  fExprGroupStr := Value;
end;

procedure TJurnal.SetGrRowCount(const Value: integer);
begin
  fGrRowCount := Value;
  if not fShowActive then
  begin
  if rtitems<>nil then
  begin
  self.Inc_alarm_Cursor(0);
   end;
  if assigned(rtItems) and not fShowActive then
  RowCount := min(max(2,VisibleRowCount+20), max(2,self.Alarm_CursorCount)) ;

  end;
end;

procedure TJurnal.PrepareTegList;
begin
  filterStr := '';

  //показывается одна из четырех выборок в следующем порядке:
  // 1 - выделенные строки
  //2 - выбранная группа
  //2 - заданные теги
  //4 - показать все

  //1 - если есть выделения, то обрабатываем их



  if fExprGroupStr <> '' then
  begin
  //2 - если ничего не выбрано, обрабатываем группу
    if fExprGroupID <> -1 then
    begin
      sc.AlarmGroupID := rtItems[fExprGroupID].AlarmGroup;
      //GroupStr := rtItems.AlarmGroups.ItemNameByNum[GroupNum];
    end else
    begin
      //GroupStr := fExprGroupStr;
      sc.AlarmGroupID := rtItems.AlarmGroups.ItemNum[fExprGroupStr];
    end;
    //sc.tegList.Clear;
    //for i := 0 to rtItems.Count - 1 do
      //if rtItems[i].AlarmGroup = GroupNum then sc.tegList.Add(rtItems.GetName(i));
  end;

  //3 - пытаемся запросить JurnalTree
  if assigned(jurnalTree) then
  try
    jurnalTree.GetSelection(sc.tegList);
  except
  end;
end;



function TJurnal.ShowPropForm: boolean;
var
  i, j: integer;
  curjurnalName: string;
begin
  result := false;
  with TfrmJurnalEditor.Create(nil) do
  try
// ************** поля таблицы ****************************
      cbDate.Checked := Columns[0].Visible;
      cbTime.Checked := Columns[1].Visible;
      cbComment.Checked := Columns[2].Visible;
      cbOper.Checked := Columns[3].Visible;
      cbParam.Checked := Columns[4].Visible;
      cbState.Checked := Columns[5].Visible;
      cbLevel.Checked := Columns[6].Visible;

      seWidth0.Value :=   columns[0].width;
      seWidth1.Value :=   columns[1].width;
      seWidth2.Value :=   columns[2].width;
      seWidth3.Value :=   columns[3].width;
      seWidth4.Value :=   columns[4].width;
      seWidth5.Value :=   columns[5].width;
      seWidth6.Value :=   columns[6].width;
// ************** основные настройки ****************************
      ebmsNew.text := fExprmsNewStr;
      ebmsKvit.text := fExprmsKvitStr;
      ebmsOut.text := fExprmsOutStr;
      ebmsOn.text := fExprmsOnStr;
      ebmsOff.text := fExprmsOffStr;
      ebmsCmd.text := fExprmsCmdStr;

      cbMsnew.Checked := msNew in sc.MsgState;
      cbMsout.Checked := msOut in sc.MsgState;
      cbMsKvit.Checked := msKvit in sc.MsgState;
      cbMsOn.Checked := msOn in sc.MsgState;
      cbMsOff.Checked := msOff in sc.MsgState;
      cbMsCmd.Checked := msCmd in sc.MsgState;

      cbMsnew.Enabled := fExprmsNewStr = '';
      cbMsout.Enabled := fExprmsOutStr = '';
      cbMsKvit.Enabled := fExprmsKvitStr = '';
      cbMsOn.Enabled := fExprmsOnStr = '';
      cbMsOff.Enabled := fExprmsOffStr = '';
      cbMsCmd.Enabled := fExprmsCmdStr = '';

      seLevelfrom.Value := sc.levelFrom;
      seLevelTo.Value := sc.levelTo;

      checkExprOverride;
// ************** управление ****************************
      cbJType.ItemIndex := ifthen(showActive, 1, 0);
      ebCmdShow.Text := fExprCmdShowStr;
      ebCmdPrint.Text := fExprCmdPrintStr;

      ebTimeTo.Text := fExprTimeToStr;

      ebGroup.text := fExprGroupStr;

      if assigned(Jurnaltree) then curJurnalName :=  Jurnaltree.Name else curJurnalName := '';
      cbJurnalTree.clear;
      j := 0;
      with self do
      for i := 0 to Owner.ComponentCount - 1 do
        if Owner.components[i] is TJurnaltree then
        begin
          cbJurnalTree.AddItem(Owner.components[i].Name, Owner.components[i]);
          if AnsiUpperCase(Owner.components[i].Name) = AnsiUpperCase(curJurnalName) then cbJurnalTree.itemIndex := j;
          inc(j);
        end;
      ebCMDShowAuto.Text := fExprCmdShowAutoStr;
// ************** настройки цветов ****************************
      panel2.color := self.color;
      panel3.color := fixedColor;
      panel4.color := ColorAl;
      panel5.color := ColorAv;
      panel6.color := ColorAlKvit;
      panel7.color := ColorAvKvit;
      panel8.color := ColorEvent;
      panel9.color := ColorAlOut;
      panel10.color := ColorAvOut;
      panel11.color := ColorCmd;

      if ShowModal = mrOk then
      begin
// ************** поля таблицы ****************************
      Columns[0].Visible := cbDate.Checked;
      Columns[1].Visible := cbTime.Checked;
      Columns[2].Visible := cbComment.Checked;
      Columns[3].Visible := cbOper.Checked;
      Columns[4].Visible := cbParam.Checked;
      Columns[5].Visible := cbState.Checked;
      Columns[6].Visible := cbLevel.Checked;

      columns[0].width := seWidth0.Value;
      columns[1].width := seWidth1.Value;
      columns[2].width := seWidth2.Value;
      columns[3].width := seWidth3.Value;
      columns[4].width := seWidth4.Value;
      columns[5].width := seWidth5.Value;
      columns[6].width := seWidth6.Value;
// ************** основные настройки ****************************
      showActive := (cbJType.ItemIndex = 1);
      fExprmsNewStr := ebmsNew.text;
      fExprmsOutStr := ebmsOut.text;
      fExprmsKvitStr := ebmsKvit.text;
      fExprmsOnStr := ebmsOn.text;
      fExprmsOffStr := ebmsOff.text;
      fExprmsCmdStr := ebmsCmd.text;

      if cbMsnew.Checked then sc.MsgState := sc.MsgState + [msNew] else sc.MsgState := sc.MsgState - [msNew];
      if cbMsOut.Checked then sc.MsgState := sc.MsgState + [msOut] else sc.MsgState := sc.MsgState - [msOut];
      if cbMsKvit.Checked then sc.MsgState := sc.MsgState + [msKvit] else sc.MsgState := sc.MsgState - [msKvit];
      if cbMsOn.Checked then sc.MsgState := sc.MsgState + [msOn] else sc.MsgState := sc.MsgState - [msOn];
      if cbMsOff.Checked then sc.MsgState := sc.MsgState + [msOff] else sc.MsgState := sc.MsgState - [msOff];
      if cbMsCmd.Checked then sc.MsgState := sc.MsgState + [msCmd] else sc.MsgState := sc.MsgState - [msCmd];

      sc.levelFrom := seLevelfrom.Value;
      sc.levelTo := seLevelTo.Value;

// ************** управление ****************************
      fExprCmdShowStr := ebCmdShow.Text;
      fExprCmdPrintStr := ebCmdPrint.Text;

      fExprTimeToStr := ebTimeTo.Text;

      fExprGroupStr := ebGroup.Text;

      
      if cbJurnalTree.ItemIndex = -1 then jurnalTree := nil
      else JurnalTree := TJurnalTree(cbJurnalTree.Items.objects[cbJurnalTree.ItemIndex]);
      fExprCmdShowAutoStr := ebCMDShowAuto.Text;

      // ************** настройки цветов ****************************
      self.color := panel2.color;
      fixedColor := panel3.color;
      ColorAl := panel4.color;
      ColorAv := panel5.color;
      ColorAlKvit := panel6.color;
      ColorAvKvit := panel7.color;
      ColorEvent := panel8.color;
      ColorAlOut := panel9.color;
      ColorAvOut := panel10.color;
      ColorCmd := panel11.color;
    end;//mrOK

  finally
    free;
  end;
  FillCaptions;
end;

procedure TJurnal.ShowPropFormMsg(var Msg: TMessage);
begin

end;


{ TCollumn }

{ TColumnList }


{ TColumnList }

function TColumns.GetItem(i: integer): TColumn;
begin
  Result:=TColumn(inherited Items[i]);
end;

procedure TColumns.SetItem(i: integer; const Value: TColumn);
begin
  inherited Items[i] := value;
end;

procedure TJurnal.WMVScroll(var Msg: TWMVScroll);
begin
  if FShowActive then
    inherited
  else
   begin
   case Msg.ScrollCode of
     SB_LINEDOWN:
     self.Inc_alarm_Cursor(-1);
      { if (grRowCount >= topRow + VisibleRowCount) then inherited
       else if FillRowLess then inherited;}
     SB_PAGEDOWN:
        self.Inc_alarm_Cursor(-visiblerowcount);
     {  if (grRowCount > topRow + VisibleRowCount) then inherited
       else
       if FillRowLess then
       begin
         inherited;
         while (grRowCount < topRow + VisibleRowCount) and (fillRowLess) do ;
       end;}
     SB_LINEUP: {inherited;}   self.Inc_alarm_Cursor(1);
     SB_PAGEUP:{inherited; }     self.Inc_alarm_Cursor(visiblerowcount);
    
   end;
   FillRowLess;
   end;
end;


function TJurnal.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  if  not fShowActive then
   begin
     self.Inc_alarm_Cursor(-1);

    FillRowLess;
    end else result:=inherited DoMouseWheelDown(Shift, MousePos);
     
end;

function TJurnal.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
 if  not fShowActive then
   begin
     self.Inc_alarm_Cursor(1);

    FillRowLess;
    end else result:=inherited DoMouseWheelup(Shift, MousePos);

end;


procedure  TJurnal.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if  not fShowActive then
   begin
    case Key of
      VK_UP:  self.Inc_alarm_Cursor(1);
      VK_DOWN:  self.Inc_alarm_Cursor(-1);
      VK_PRIOR:;
      VK_NEXT: ;
      VK_HOME: ;
      VK_END:  ;
    end;
    FillRowLess;
    end else inherited;
end;

function TSelectCondition.CheckAlarms(num: integer;act: boolean): boolean;
var
  i, tegID: integer;
begin
  result := false;
  tegID := rtItems.Alarms[num].TegID;
    if (fLevelFrom <= rtItems[tegid].AlarmLevel) and
       (fLevelto >= rtItems[TegID].AlarmLevel) and
       (time <= fTimeTo) and
       (rtItems.Alarms[num].Typ in MsgState) and
        ((AlarmGroupID = -1) or (AlarmGroupID = rtItems[tegid].AlarmGroup))then
       if fTegList.Count = 0 then result := true
       else
         for i := 0 to fTegList.Count - 1 do
           if fTegList[i] = rtItems.GetName(TegID) then
           begin
             if ((self.TimeTo>=rtItems.Alarms[num].time)  and not act) or act then
             result := true;
             exit;
           end;
end;

constructor TSelectCondition.Create;
begin
  inherited;
  fAlarmGroupID := -1;
  LevelFrom := 0;
  levelTo := 1000;
  //TimeFrom := strtotime('0:0');
  TimeTo := strtotime('23:59:59');
  MsgState := [msNew, msKvit, msOut, msOn, msOff, msCmd];
  ftegList := TStringList.Create;
end;

destructor TSelectCondition.destroy;
begin
  fTegList.free;
  inherited;
end;

procedure TSelectCondition.SetTegList(const Value: TStringList);
begin
  fTegList.assign(Value);
end;



procedure TJurnal.FillCells;
begin
  CheckTegOption;
  prepareTegList;

  GrRowCount := 0;
  if assigned(rtItems) and fShowActive then FillActiveAlarms else FillAlarms;
end;

procedure TJurnal.FillActiveAlarms;
var
  i: integer;

begin
  RowCount := max(rtItems.activeAlarms.Count + 1,2);
  //RowCount := min(20+visibleRowcount, rtItems.activeAlarms.Count + 2);
  grRowCount := 0;
  try
  for i := rtItems.activeAlarms.Count - 1 downto 0 do
  begin

    grRowCount := grRowCount + 1;
    fillRowActive(grRowCount, i);
  end;
  for i := grRowCount + 1 to RowCount do clearRow(i);
  topRow := 1;
  except
  end;
end;



procedure TJurnal.FillAlarms;
var
  i: integer;
begin
  grRowCount := 0;
  topRow := 1;
  for i := 1 to rowCount - 1 do ClearRow(i);
  self.Alarm_Cursor:=rtitems.alarms.Count-1;
  self.Inc_alarm_Cursor(0);
 { if }fillRowLess; {then }
  //  while (grRowCount < VisibleRowCount) and FillRowLess do;
end;

procedure TJurnal.fillRowActive(grRow, alRow: integer);
var
  i: integer;
begin

  for i := 0 to ColCount - 1 do
    begin
      if (rtItems[rtItems.activeAlarms[alRow].tegID].AlarmLevel <= 500) and (not rtItems.activeAlarms[alRow].isKvit) then Rows[grRow].Font.Color := fcolorAl;
      if (rtItems[rtItems.activeAlarms[alRow].tegID].AlarmLevel <= 500) and (rtItems.activeAlarms[alRow].isKvit) then Rows[grRow].Font.Color := fcolorAlKvit;
      if (rtItems[rtItems.activeAlarms[alRow].tegID].AlarmLevel > 500) and (not rtItems.activeAlarms[alRow].isKvit) then Rows[grRow].Font.Color := fcolorAv;
      if (rtItems[rtItems.activeAlarms[alRow].tegID].AlarmLevel > 500) and (rtItems.activeAlarms[alRow].isKvit) then Rows[grRow].Font.Color := fcolorAvKvit;

      if cells[i, 0] = 'Дата' then cells[i, grRow] := datetostr(rtItems.activeAlarms[alRow].time) else
      if cells[i, 0] = 'Время' then cells[i, grRow] := timetostr(rtItems.activeAlarms[alRow].time) else
      if cells[i, 0] = 'Комментарий' then cells[i, grRow] := rtItems.GetAlarmMsg(rtItems.activeAlarms[alRow].tegID) else
      if cells[i, 0] = 'Оператор' then cells[i, grRow] := rtItems.activeAlarms[alRow].oper else
      if cells[i, 0] = 'Параметр' then cells[i, grRow] := rtItems.GetName(rtItems.activeAlarms[alRow].tegID) else
      if cells[i, 0] = 'Состояние' then cells[i, grRow] := ifthen(rtItems.activeAlarms[alRow].isKvit, 'КВИТ', 'АКТИВ') else
      if cells[i, 0] = 'Уровень' then cells[i, grRow] := inttostr(rtItems[rtItems.activeAlarms[alRow].tegID].AlarmLevel);
      Rows[grRow].DateTime := rtItems.activeAlarms[alRow].time;
    end;
end;


procedure TJurnal.WMCREATE(var Msg: TWMVScroll);
begin
end;

procedure TJurnal.WMKEYUP(var Msg: TWMVScroll);
begin
inherited;
  if FShowActive then fillCells;
end;

procedure TJurnal.fillRowAlarm(grRow, alRow: integer);
function getnametyp(val: TMsgType; allev: integer): string;
begin
      if val =msOff then result:='Выкл';
      if val =msOn then result:='Вкл';
      if val = msCmd then result:= 'Команда';
      if (allev <= 500) and ( val = msnew) then result:= 'Авария';
      if (allev > 500) and ( val = msnew) then result:= 'Тревога';
      if (allev <= 500) and ( val = msKvit) then result:= 'Авария квитированная';
      if (allev > 500) and ( val = msKvit) then result:= 'Тревога квитированная';
      if (allev <= 500) and ( val = msOut) then result:= 'Авария ушедшая';
      if (allev > 500) and ( val = msOut) then result:= 'Тревога ушедшая';
end;

function getmsgcontent(val: TMsgType; ids: integer): string;
begin
      result:='';
      if rtitems.Count<ids+1  then exit;
      if val =msOff then result:=rtitems.GetOffMsg(ids);
      if val =msOn then result:=rtitems.GetOnMsg(ids);
      if val = msCmd then result:=rtitems.GetComment(ids);;
      if ( val = msnew) or ( val = msKvit) or
       ( val = msOut) then result:=rtitems.GetAlarmMsg(ids);
end;

var
  i, tegID: integer;
begin

  if alRow <> -1 then tegID := rtItems.Alarms[alRow].TegID;

  for i := 0 to ColCount - 1 do
    begin
      
      if rtItems.Alarms[alRow].typ=msOff then Rows[grRow].Font.Color := not(fcolorEvent);
      if rtItems.Alarms[alRow].typ=msOn then Rows[grRow].Font.Color := fcolorEvent;
      if rtItems.Alarms[alRow].typ = msCmd then Rows[grRow].Font.Color := fcolorCmd;
      if (rtItems[tegID].AlarmLevel <= 500) and (rtItems.Alarms[alRow].typ = msnew) then Rows[grRow].Font.Color := fcolorAl;
      if (rtItems[tegID].AlarmLevel > 500) and (rtItems.Alarms[alRow].typ = msnew) then Rows[grRow].Font.Color := fcolorAV;
      if (rtItems[tegID].AlarmLevel <= 500) and (rtItems.Alarms[alRow].typ = msKvit) then Rows[grRow].Font.Color := fcolorAlKvit;
      if (rtItems[tegID].AlarmLevel > 500) and (rtItems.Alarms[alRow].typ = msKvit) then Rows[grRow].Font.Color := fcolorAVKvit;
      if (rtItems[tegID].AlarmLevel <= 500) and (rtItems.Alarms[alRow].typ = msOut) then Rows[grRow].Font.Color := fcolorAlOut;
      if (rtItems[tegID].AlarmLevel > 500) and (rtItems.Alarms[alRow].typ = msOut) then Rows[grRow].Font.Color := fcolorAVOut;
      if cells[i, 0] = 'Дата' then cells[i, grRow] := datetostr(rtItems.Alarms[alRow].time) else
      if cells[i, 0] = 'Время' then
      begin
       { if rtItems.Alarms[alRow].typ in [msOff, msOn] then
          cells[i, grRow] := formatdatetime('hh:mm:ss.zzz', rtItems.Alarms[alRow].time)
        else} cells[i, grRow] := timetostr(rtItems.Alarms[alRow].time);
      end else
      if cells[i, 0] = 'Комментарий' then cells[i, grRow] := getmsgcontent(rtItems.Alarms[alRow].typ, rtItems.Alarms[alRow].tegID) else
      if cells[i, 0] = 'Оператор' then cells[i, grRow] := rtItems.Alarms[alRow].oper else
      if cells[i, 0] = 'Параметр' then cells[i, grRow] := rtItems.GetName(rtItems.Alarms[alRow].tegID) else
      if cells[i, 0] = 'Состояние' then cells[i, grRow] := getnametyp(rtItems.Alarms[alRow].typ,rtItems[tegID].AlarmLevel) else
      if cells[i, 0] = 'Уровень' then cells[i, grRow] := inttostr(rtItems[rtItems.Alarms[alRow].tegID].AlarmLevel);
      Rows[grRow].DateTime := rtItems.Alarms[alRow].time;
    end;

end;

procedure TJurnal.moveRows(Source, Destination, Count: integer);
var
  col, row: integer;
begin
   //ShowMessage('Move From '+ inttostr(Source) + ' to ' + inttostr(Destination) + ' count ' + inttostr(Count));
  for row := 0 to Count - 1 do
    for col := 0 to ColCount - 1 do
      if source > destination then
      begin
        Cells[col, Destination + row] := Cells[col, source + row];
        Rows[Destination + row].Font.Color := Rows[source + row].Font.Color;
        Rows[Destination + row].DateTime := Rows[source + row].DateTime;
      end
      else
      begin
        Cells[col, Destination + Count - row - 1] := Cells[col, source + count - row - 1];
        Rows[Destination + Count - row - 1].Font.Color := Rows[source + count - row - 1].Font.Color;
        Rows[Destination + Count - row - 1].DateTime := Rows[source + count - row - 1].DateTime;
      end;
end;

function TJurnal.FillRowLess: boolean;
var
 i, j: integer;
 DateTime: TDateTime;
 kn: integer;
begin
  kn:=0;
  //if grRowCount = 0 then dateTime := sc.fTimeTo else dateTime := Rows[grRowCount].DateTime;
  //ShowMessage(DateTimeToStr(DateTime));
  result := false;
   for i := {rtItems.Alarms.Count - 1}self.Alarm_Cursor downto 0 do
   begin
    {if (rtItems.Alarms[i].Time < DateTime) then}
    begin
      //ShowMessage('!');
      if sc.CheckAlarms(i,fauto) then
      begin
        grRowCount := grRowCount + 1;;
        inc(kn);
        fillRowAlarm (kn, i);
        if kn>self.VisibleRowCount then
          begin
          toprow:=self.Alarm_CursorDelt+1;
          self.RowCount:=kn+4;
            exit;
          end;
        result := true;

        //добавляем все алармы с таким же временем
        j := 1;
        if not fauto then
        begin
        while (i-j >= 0) and (rtItems.Alarms[i].Time = rtItems.Alarms[i - j].Time) do
        begin
          if sc.CheckAlarms(i - j,fauto) then
          begin
            grRowCount := grRowCount + 1;;
             inc(kn);
            fillRowAlarm (kn, i - j);
             if kn>self.VisibleRowCount then
          begin
         toprow:=self.Alarm_CursorDelt+1;
            self.RowCount:=kn+4;
            exit;
          end;
          end;
          inc(j);
        end;
        end;
  //      break;
      end;
    end;
   end;
  //if not result then ShowMessage('Сообщений по данному запросу больше нет!');
end;

procedure TJurnal.ClearRow(row: integer);
var
  i: integer;
begin
  for i := 0 to ColCount - 1 do cells[i, Row] := ''
end;

procedure TJurnal.JurnalOnNewAlarm(AlarmNum: Integer);
var
  id: integer;
begin
  if (fExprCmdShowAuto.Value <> 0) then
  begin
    id := rtItems.GetSimpleID(fExprTimeToStr);
    if id <> - 1 then rtItems[id].ValReal := Now;
    sc.timeTo := Now;
    if not fShowActive then self.Inc_alarm_Cursor(1);
    fillCells;
  end;
end;

{ TColumn }

constructor TColumn.Create;
begin
  inherited;
  visible := true;
end;

end.
