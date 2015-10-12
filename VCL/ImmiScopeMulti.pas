unit ImmiScopeMulti;

interface

uses controls,ImmiScopeStatic,  dxButton, oscillogramU,classes,PointerTegsU,fStartDateTimeGrU, ComCtrls, SelectFormVCLU,
TrackBarDouble, groupsU, ConfigurationSys, stdctrls,DB, Dialogs,globalvalue, StrUtils, messages, sysUtils,
DateUtils, constDef, Expr, Scope,windows,graphics, DataGraphcModul,forms, {GlobalVar,} ADODB, MemStructsU;

type parrboolean = ^boolean;





type
  TImmiScopeMulti = class(TScopeArray)
  private
    { Private declarations }
    fQueryStartTm: TDateTime;
    fQueryTimePeriod: TTime;
    fHorizTrBar: TImmiGraphTrBr;
    fvertTrBar: TImmiGraphTrBr;
    fbbSettimeArc: TCtrlGraphButton;
    fbbIn: TImmiGraphButton;
    fbbOut: TImmiGraphButton;
    fbbLeft100: TImmiGraphButton;
    fbbRight100: TImmiGraphButton;
    fbbLeft50: TImmiGraphButton;
    fOschNumb: integer;
    fbbRight50: TImmiGraphButton;
    fbbToNow: TImmiGraphButton;
    fbbButtonExpr: array [0..7] of TExprGraphButton;
    a_DataMod: array [0..7] of TDataModule1;
    flbMidle: TTimeGrLabel;
    flbStart: TTimeGrLabel;
    flbStop: TTimeGrLabel;
    flbDate: TTimeGrLabel;
    finPersent: boolean;
    min1,  delt1:real;
    Furrsttime: boolean;
    PrimariFirstTime: tTDPoint;
    postXasc:  Double;
     fStartTm: TDateTime;
    fTimePeriod: TTime;
    a_queryforanalog: array [0..7] of TADOQuery;
    a_queryforanalogAbs: array [0..7] of TADOQuery;
    fMyLock: boolean;
    a_idExpr: array [0..7] of integer;
    isArcNul: array [0..1] of boolean;
    delta: real;
    fFormat: string;
    res: array [0..7] of tTDPoint;
    a_fExprString: array [0..7] of TExprStr ;
    fCap: string;
    fmaxValEu: array [0..7] of real;
    fminValEu: array [0..7] of real;
    ftimeLabel: boolean;
    flbExprName: TExprNameLabel;
    fAutoSizeEU: boolean;
    curEUMax: double;
    curEUMin: double;
    valLeft: double;
    valRight: double;
    procedure SetForm (str: string);
    procedure SetCaption (str: TCaption);
    procedure SetMylock(val: boolean);
    procedure SetDateTM;
  protected
   procedure SetIn;
   procedure SetOut;
   procedure SetLeft100;
   procedure SetRight100;
   procedure SetLeft50;
   procedure SetRight50;
   procedure Setexpr(index: integer; value: TExprStr);
   procedure setHorizTrBar(val: TImmiGraphTrBr);
   procedure setvertTrBar(val: TImmiGraphTrBr);
   procedure setbbLeft100(val: TImmiGraphButton);
   procedure setbbLeft50(val: TImmiGraphButton);
   procedure setbbRight50(val: TImmiGraphButton);
   procedure setbbRight100(val: TImmiGraphButton);
   procedure setbbToNow(val: TImmiGraphButton);
   procedure setbbIn(val: TImmiGraphButton);
   procedure setbbOut(val: TImmiGraphButton);
   procedure setbbButtonExpr(index: integer; val: TExprGraphButton);
   procedure setbbSettimeArc(val: TCtrlGraphButton);
   procedure setlbExprName(val: TExprNameLabel);

    { Protected declarations }
   procedure Query1FetchComplete(DataSet: TCustomADODataSet;
    const Error: Error; var EventStatus: TEventStatus);
   procedure Query1FetchProgress(DataSet: TCustomADODataSet;
    Progress, MaxProgress: Integer; var EventStatus: TEventStatus);
    procedure setStartTm(val:TdateTime);
    procedure setTimePeriod(val:TTime);
    procedure SetTimeToNow;
    procedure SetInput;
    procedure SetInVert(newMin:  double; newMax:  double; num: integer);
    procedure SetmaxValEu(index: integer; val: real);
    procedure SetminValEu(index: integer; val: real);
    procedure setlbMidle(val: TTimeGrLabel);
    procedure setlbStart(val: TTimeGrLabel);
    procedure setlbStop(val: TTimeGrLabel);
    procedure setlbDate(val: TTimeGrLabel);
  public
    { Public declarations }
    LimitedTime: boolean;
    fLimitedStart: TDateTime;
    fLimitedPeriod: TDateTime;
    fInputStart: TDateTime;
    fInputPeriod: TDateTime;

    property maxValEu_1: real index 0 read fmaxValEu[0] write SetmaxValEu;
    property maxValEu_2: real index 1 read fmaxValEu[1] write SetmaxValEu;
    property maxValEu_3: real index 2 read fmaxValEu[2] write SetmaxValEu;
    property maxValEu_4: real index 3 read fmaxValEu[3] write SetmaxValEu;
    property maxValEu_5: real index 4 read fmaxValEu[4] write SetmaxValEu;
    property maxValEu_6: real index 5 read fmaxValEu[5] write SetmaxValEu;
    property maxValEu_7: real index 6 read fmaxValEu[6] write SetmaxValEu;
    property maxValEu_8: real index 7 read fmaxValEu[7] write SetmaxValEu;
    property minValEu_1: real index 0 read fminValEu[0] write SetminValEu;
    property minValEu_2: real index 1 read fminValEu[1] write SetminValEu;
    property minValEu_3: real index 2 read fminValEu[2] write SetminValEu;
    property minValEu_4: real index 3 read fminValEu[3] write SetminValEu;
    property minValEu_5: real index 4 read fminValEu[4] write SetminValEu;
    property minValEu_6: real index 5 read fminValEu[5] write SetminValEu;
    property minValEu_7: real index 6 read fminValEu[6] write SetminValEu;
    property minValEu_8: real index 7 read fminValEu[7] write SetminValEu;
    property MyLock: boolean read fMyLock write SetMyLock;
    procedure Loaded; override;
    procedure FillPerfect(index: integer);
    procedure ExprNil;
    procedure removeCompFromScope(val: TComponent);
    constructor Create(AOwner: TComponent); override;
    function QueryExpr(index: integer):tTDPoint;
    destructor Destroy; override;
    function  QueryPeriod(numg: integer; index: integer):tTDPoint;
    procedure ImmiQueryGraph(index: integer);
    procedure SetCurUE(index: integer);
    procedure reistablish(index: integer);
    function SetNewRange(min, max: integer; index: integer): boolean;
    function SetNewRangeW(setstart: TdateTime; setPeriod: TTime; index: integer): boolean;
    procedure ButtonControlAction(val: TImmiGraphButton);
    procedure ButtonControlActionST(val:  TCtrlGraphButton);
    procedure SetByTrackBarH(index: integer; min,max: integer);
    procedure SetByTrackBarV(index: integer; min,max: integer);
    procedure queryanalogBeforeOpen(DataSet: TDataSet);
    procedure queryanalogabsBeforeOpen(DataSet: TDataSet);
      procedure queryanalogConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
    procedure  queryanalogExecuteComplete(Connection: TADOConnection;
  RecordsAffected: Integer; const Error: Error;
  var EventStatus: TEventStatus; const Command: _Command;
  const Recordset: _Recordset);
  published
    { Published declarations }
    property form: string read fFormat write SetForm;
    property Expr_1: TExprStr index 0 read a_fExprString[0] write setExpr;
    property Expr_2: TExprStr index 1 read a_fExprString[1] write setExpr;
    property Expr_3: TExprStr index 2 read a_fExprString[2] write setExpr;
    property Expr_4: TExprStr index 3 read a_fExprString[3] write setExpr;
    property Expr_5: TExprStr index 4 read a_fExprString[4] write setExpr;
    property Expr_6: TExprStr index 5 read a_fExprString[5] write setExpr;
    property Expr_7: TExprStr index 6 read a_fExprString[6] write setExpr;
    property Expr_8: TExprStr index 7 read a_fExprString[7] write setExpr;
    property caption write SetCaption;
    property inPersent: boolean read finPersent write finPersent;
    property StartTm: TDateTime read fStartTm write setStartTm;
    property TimePeriod: TTime read fTimePeriod write setTimePeriod;
    property HorizTrBar: TImmiGraphTrBr read fHorizTrBar write setHorizTrBar;
    property vertTrBar: TImmiGraphTrBr read fvertTrBar write setvertTrBar;
    property bbIn: TImmiGraphButton read fbbIn write setbbIn;
    property bbOut: TImmiGraphButton read fbbOut write setbbOut;
    property bbLeft100: TImmiGraphButton read fbbLeft100 write setbbLeft100;
    property bbRight100: TImmiGraphButton read fbbRight100 write setbbRight100;
    property bbLeft50: TImmiGraphButton read fbbLeft50 write setbbLeft50;
    property bbRight50: TImmiGraphButton read fbbRight50 write setbbRight50;
    property bbToNow: TImmiGraphButton read fbbToNow write setbbToNow;
    property bbButtonExpr_1: TExprGraphButton index 0 read fbbButtonExpr[0] write setbbButtonExpr;
    property bbButtonExpr_2: TExprGraphButton index 1 read fbbButtonExpr[1] write setbbButtonExpr;
    property bbButtonExpr_3: TExprGraphButton index 2 read fbbButtonExpr[2] write setbbButtonExpr;
    property bbButtonExpr_4: TExprGraphButton index 3 read fbbButtonExpr[3] write setbbButtonExpr;
    property bbButtonExpr_5: TExprGraphButton index 4 read fbbButtonExpr[4] write setbbButtonExpr;
    property bbButtonExpr_6: TExprGraphButton index 5 read fbbButtonExpr[5] write setbbButtonExpr;
    property bbButtonExpr_7: TExprGraphButton index 6 read fbbButtonExpr[6] write setbbButtonExpr;
    property bbButtonExpr_8: TExprGraphButton index 7 read fbbButtonExpr[7] write setbbButtonExpr;
    property bbSettimeArc: TCtrlGraphButton read fbbSettimeArc write setbbSettimeArc;
    property lbExprName: TExprNameLabel read flbExprName write setlbExprName;
    property lbMidle: TTimeGrLabel read flbMidle write setlbMidle;
    property lbStart: TTimeGrLabel read flbStart write setlbStart;
    property lbStop: TTimeGrLabel read flbStop write setlbStop;
    property lbDate: TTimeGrLabel read flbDate write setlbDate;
    property timeLabel: boolean read ftimeLabel write ftimeLabel;
    property OschNumb: integer read fOschNumb write fOschNumb;
    property AutoSizeEU: boolean read fAutoSizeEU write fAutoSizeEU;
  end;

procedure Register;
function GetMidY(x1,y1,x2,y2,xx: double): double;

implementation

Uses IMMIAnalogPropU;

constructor TImmiScopeMulti.Create(AOwner: TComponent);
var i: integer;
begin
    inherited Create(AOwner);
    for i:=0 to 7 do
    begin
    indicatorMulti.resabs[i].n:=0;
    setlength(indicatorMulti.resabs[i].point,0);
    a_queryforanalog[i]:=TADOQuery.CREATE(SELF);
    a_queryforanalog[i].ExecuteOptions:=[eoAsyncExecute,eoAsyncFetch,eoAsyncFetchNOnBlocking ];
    a_queryforanalog[i].OnFetchComplete:=Query1FetchComplete;
    a_queryforanalog[i].OnFetchProgress:=Query1FetchProgress;
    a_queryforanalog[i].BeforeOpen:=queryanalogBeforeOpen;
    a_queryforanalogabs[i]:=TADOQuery.CREATE(SELF);
    a_queryforanalogabs[i].ExecuteOptions:=[eoAsyncExecute,eoAsyncFetch,eoAsyncFetchNOnBlocking ];
    a_queryforanalogabs[i].OnFetchComplete:=Query1FetchComplete;
    a_queryforanalogabs[i].OnFetchProgress:=Query1FetchProgress;
    a_queryforanalogabs[i].BeforeOpen:=queryanalogabsBeforeOpen;
    a_DataMod[i]:=TDataModule1.Create(Application);
      begin
      a_queryforanalog[i].connection:=a_DataMod[i].trend;
      a_queryforanalogabs[i].connection:=a_DataMod[i].trend;
      end;
    a_DataMod[i].Trend.OnConnectComplete:=queryanalogConnectComplete;
    a_DataMod[i].trend.OnExecuteComplete:=queryanalogExecuteComplete;
    end;
    Furrsttime:=false;
    fMyLock:=false;
    for i:=0 to 7 do
    begin
    a_idExpr[i]:=-1;
    setlength(res[i].point,0);
    res[i].n:=0;
    end;
    fQueryStartTm:=0;
    fQueryTimePeriod:=0;
    indicatorMulti.FDST:=true;
    indicatorMulti.Slide:=true;
    fOschNumb:=-1;
end;

procedure TImmiScopeMulti.reistablish(index: integer);
begin
    try
    if a_queryforanalog[index]<>nil then a_queryforanalog[index].free;

    if a_queryforanalogabs[index]<>nil then a_queryforanalogabs[index].free;
    except
    end;
    a_queryforanalog[index]:=TADOQuery.CREATE(SELF);
    a_queryforanalog[index].ExecuteOptions:=[eoAsyncExecute,eoAsyncFetch,eoAsyncFetchNOnBlocking ];
    a_queryforanalog[index].OnFetchComplete:=Query1FetchComplete;
    a_queryforanalog[index].OnFetchProgress:=Query1FetchProgress;
    a_queryforanalog[index].BeforeOpen:=queryanalogBeforeOpen;
    a_queryforanalogabs[index]:=TADOQuery.CREATE(SELF);
    a_queryforanalogabs[index].ExecuteOptions:=[eoAsyncExecute,eoAsyncFetch,eoAsyncFetchNOnBlocking ];
    a_queryforanalogabs[index].OnFetchComplete:=Query1FetchComplete;
    a_queryforanalogabs[index].OnFetchProgress:=Query1FetchProgress;
    a_queryforanalogabs[index].BeforeOpen:=queryanalogabsBeforeOpen;
end;

procedure TImmiScopeMulti.removeCompFromScope(val: TComponent);
var i: integer;
begin
  if val=nil then exit;
  if fHorizTrBar=val then fHorizTrBar:=nil;
  if val=fvertTrBar then fvertTrBar:=nil;
  if val=fbbSettimeArc then fbbSettimeArc:=nil;
  if val=fbbIn then fbbIn:=nil;
  if val=fbbOut then fbbOut:=nil;
  if val=fbbLeft100 then fbbLeft100:=nil;
  if val=fbbRight100 then fbbRight100:=nil;
  if val=fbbLeft50 then fbbLeft50:=nil;
  if val=fbbRight50 then fbbRight50:=nil;
  if val=fbbToNow then fbbToNow:=nil;
  for i:=0 to 7 do
  if val=fbbButtonExpr[i] then fbbButtonExpr[i]:=nil;
  if val=flbMidle then flbMidle:=nil;
  if val=flbStart then flbStart:=nil;
  if val=flbStop then flbStop:=nil;
  if val=flbDate then flbDate:=nil;
end;


procedure TImmiScopeMulti.SetmaxValEu(index: integer; val: real);
begin
  if (a_idExpr[index]<0) then exit;
     if  fmaxValEu[index]<>val then
     begin
     fmaxValEu[index]:=val;
     SetInvert(fminValEu[index],fmaxValEu[index],index);
     end;
end;

procedure TImmiScopeMulti.SetminValEu(index: integer; val: real);
begin
 if (a_idExpr[index]<0) then exit;
     if  fminValEu[index]<>val then
     begin
     fminValEu[index]:=val;
     SetInvert(fminValEu[index],fmaxValEu[index],index);
     end;
end;

function TImmiScopeMulti.SetNewRange(min, max: integer; index: integer): boolean;
var i: integer;
 //   min,max: integer;
begin
result:=true;
     begin
       result:=false;
       fstartTm:=fQuerystartTm+fQueryTimePeriod*min/100;
       ftimePeriod:=fQueryTimePeriod*(max-min)/100;
       indicatorMulti.FFirstPoint[index]:=true;
      if indicatorMulti.WorldRight<>fstartTm then
       begin
       indicatorMulti.WorldLeft:= fstartTm;
       indicatorMulti.WorldRight:= fstartTm+ftimePeriod;
       end else
       begin
       indicatorMulti.WorldRight:= fstartTm+ftimePeriod;
       indicatorMulti.WorldLeft:= fstartTm;
       end;
       FillPerfect(index);
     end;

end;

function TImmiScopeMulti.SetNewRangeW(setstart: TdateTime; setPeriod: TTime; index: integer): boolean;
var i: integer;
    min,max: double;
begin
result:=true;
//application.MessageBox(pansichar(DateTimeToStr(setStart)+'jjjj'+DateTimeToStr(setStart+setPeriod)+'   '+DateTimeToStr(fQueryStartTm)+'jjjj'+DateTimeToStr(fQueryStartTm+fQueryTimePeriod)),pansichar(floattostr((fTimePeriod)/(setPeriod))),0);
if ((setStart<=(fQueryStartTm+fQueryTimePeriod)) and (setStart>=(fQueryStartTm))) and
     (((setStart+setPeriod)<=(fQueryStartTm+fQueryTimePeriod)) and ((setStart+setPeriod)>=(fQueryStartTm))) then
     begin
     //  application.MessageBox(pansichar(DateTimeToStr(setStart)+'jjjj'+DateTimeToStr(setStart+setPeriod)+'   '+DateTimeToStr(fQueryStartTm)+'jjjj'+DateTimeToStr(fQueryStartTm+fQueryTimePeriod)),pansichar(floattostr((fTimePeriod)/(setPeriod))),0);
       result:=false;
       min:=100*(setStart-fQuerystartTm)/fQueryTimePeriod;
       max:=100*(setStart+setPeriod-fQuerystartTm)/fQueryTimePeriod;
       //application.MessageBox(pansichar(inttostr(min)+'jjjj'+inttostr(max)),pansichar(''),0);
       indicatorMulti.FFirstPoint[index]:=true;
       if  indicatorMulti.WorldRight<>setstart then
       begin
       indicatorMulti.WorldLeft:= setstart;
       indicatorMulti.WorldRight:= setstart+setPeriod;
       end else
       begin
       indicatorMulti.WorldRight:= setstart+setPeriod;
       indicatorMulti.WorldLeft:= setstart;
       end;
       if  fHorizTrBar<>nil then
         begin
          fHorizTrBar.Position1:=round(min);
          fHorizTrBar.Position:=round(max);
         end;


        self.FillPerfect(index);
     end;

end;

procedure TImmiScopeMulti.SetIn;
var ltp: TDateTime;
begin

   timeperiod:=0.5*ftimeperiod;
   //application.MessageBox(pansichar(SelfFormatDateTime(fStartTm)),pansichar(SelfFormatDateTime(fStartTm+fTimeperiod)),0);
   starttm:=starttm+0.5*ftimePeriod;

end;

procedure TImmiScopeMulti.SetInput;
var ltp: TDateTime;
    i:integer;
begin
  if  self.LimitedTime then
    begin
       if fInputPeriod>self.fLimitedPeriod then fInputPeriod:=self.fLimitedPeriod;
      if fInputStart<self.fLimitedStart then fInputStart:=self.fLimitedStart;
       if fInputStart>=(self.fLimitedStart+self.fLimitedPeriod) then
         fInputStart:=self.fLimitedStart+self.fLimitedPeriod-fInputPeriod;
    end;
  if  (ftimeperiod<>self.fInputPeriod) or  (fstarttm<>self.fInputStart) then begin
   timeperiod:=self.fInputPeriod;
   fstarttm:=self.fInputStart;
   for i:=0 to 7 do
   begin
   indicatorMulti.StartTime:=fStartTm;
   indicatorMulti.TimePer:=fTimePeriod;
   ImmiQueryGraph(i);
   end;
  
   SetDateTM;
   end;
end;

procedure TImmiScopeMulti.SetLeft100;
begin
  
   starttm:=starttm-1*ftimePeriod;
  // ImmiQueryGraph;
end;

procedure TImmiScopeMulti.SetTimeToNow;
begin
  // ftimeperiod:=0.5*ftimeperiod;
   starttm:=now-1*ftimePeriod;
  // ImmiQueryGraph;
end;

procedure TImmiScopeMulti.SetLeft50;
begin
  // ftimeperiod:=0.5*ftimeperiod;
   starttm:=starttm-0.5*ftimePeriod;
  // ImmiQueryGraph;
end;

procedure TImmiScopeMulti.SetRight100;
begin
  // ftimeperiod:=0.5*ftimeperiod;
   starttm:=starttm+1*ftimePeriod;
  // ImmiQueryGraph;
end;

procedure TImmiScopeMulti.SetRight50;
begin
  // ftimeperiod:=0.5*ftimeperiod;
   starttm:=starttm+0.5*ftimePeriod;
  // ImmiQueryGraph;
end;


procedure TImmiScopeMulti.SetOut;
begin
   if timeperiod>0.999999 then exit;
   timeperiod:=2*timeperiod;
   starttm:=starttm-0.25*ftimePeriod;
   //application.MessageBox(pansichar(Datetimetostr(starttm)),pansichar(Datetimetostr(starttm+timeperiod)),0);
end;



procedure TImmiScopeMulti.setStartTm(val:TdateTime);
var i: integer;
begin
  if  self.LimitedTime then
    begin
       if ftimeperiod>self.fLimitedPeriod then timeperiod:=self.fLimitedPeriod;
       if val<self.fLimitedStart then val:=self.fLimitedStart;
       if val>=(self.fLimitedStart+self.fLimitedPeriod) then
         val:=self.fLimitedStart+self.fLimitedPeriod-ftimeperiod;
       if (val+ftimeperiod)>(self.fLimitedStart+self.fLimitedPeriod) then
         val:=self.fLimitedStart+self.fLimitedPeriod-ftimeperiod;
    end;

  if (ftimeperiod+val)>now then val:=now-ftimeperiod;
  if (fStartTm<>val) or (LimitedTime) then
   begin
   fStartTm:=val;
     indicatorMulti.StartTime:=fStartTm;
     indicatorMulti.TimePer:=fTimePeriod;
     for i:=0 to 7 do
     begin

     if SetNewRangeW(fStartTm,ftimeperiod,i) then
     ImmiQueryGraph(i);
     SetDateTM;
    if (a_idexpr[i]<0) then
       begin
         Draw;
         //ExprNil;
         indicatorMulti.draw;
       end;

    end;
   end;
end;

procedure TImmiScopeMulti.setbbSettimeArc(val: TCtrlGraphButton);
begin
  if val<>fbbSettimeArc then
 begin
   if fbbSettimeArc<>nil then
       fbbSettimeArc.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   if val<>nil then val.tag:=0;
   fbbSettimeArc:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setbbLeft100(val: TImmiGraphButton);
begin
if val<>fbbLeft100 then
 begin
   if fbbLeft100<>nil then
       fbbLeft100.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   if val<>nil then val.tag:=0;
   fbbLeft100:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setbbLeft50(val: TImmiGraphButton);
begin
if val<>fbbLeft50 then
 begin
   if fbbLeft50<>nil then
       fbbLeft50.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   if val<>nil then val.tag:=0;
   fbbLeft50:=val;
  if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setbbRight50(val: TImmiGraphButton);
begin
if val<>fbbRight50 then
 begin
   if fbbRight50<>nil then
       fbbRight50.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   if val<>nil then val.tag:=0;
   fbbRight50:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setbbRight100(val: TImmiGraphButton);
begin
if (val<>fbbRight100) then
 begin
   if fbbRight100<>nil then
       fbbRight100.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   if val<>nil then val.tag:=0;
   fbbRight100:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;



procedure TImmiScopeMulti.setbbToNow(val: TImmiGraphButton);
begin
if (val<>fbbToNow) then
 begin
   if fbbToNow<>nil then
       fbbToNow.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   if val<>nil then val.tag:=0;
   fbbToNow:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setlbExprName(val: TExprNameLabel);
begin
if val<>flbExprName then
 begin
   //if flbExprName<>nil then
    //   flbExprName.GgrList.Remove(self);
   if val<>nil then
       val.SC:=self;
   if val<>nil then val.tag:=0;
   flbExprName:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setlbMidle(val: TTimeGrLabel);
begin
if val<>flbMidle then
 begin
   //if flbExprName<>nil then
    //   flbExprName.GgrList.Remove(self);
   if val<>nil then
       val.SC:=self;
   if val<>nil then val.tag:=0;
   flbMidle:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setlbStart(val: TTimeGrLabel);
begin
if val<>flbStart then
 begin
   //if flbExprName<>nil then
    //   flbExprName.GgrList.Remove(self);
   if val<>nil then
       val.SC:=self;
   if val<>nil then val.tag:=0;
   flbStart:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setlbDate(val: TTimeGrLabel);
begin
if val<>flbDate then
 begin
   //if flbExprName<>nil then
    //   flbExprName.GgrList.Remove(self);
   if val<>nil then
       val.SC:=self;
   if val<>nil then val.tag:=0;
   flbDate:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setlbStop(val: TTimeGrLabel);
begin
if val<>flbStop then
 begin
   //if flbExprName<>nil then
    //   flbExprName.GgrList.Remove(self);
   if val<>nil then
       val.SC:=self;
   if val<>nil then val.tag:=0;
   flbStop:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setbbIn(val: TImmiGraphButton);
begin
if val<>fbbIN then
 begin
   if fbbIn<>nil then
       fbbIn.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   if val<>nil then val.tag:=0;
   fbbIn:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setbbOut(val: TImmiGraphButton);
begin
if val<>fbbOut then
 begin
   if fbbOut<>nil then
       fbbOut.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   if val<>nil then val.tag:=0;
   fbbOut:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setbbButtonExpr(index: integer; val: TExprGraphButton);
var fbbButtonExprU:  TExprGraphButton;
begin
   case index of
    0: fbbButtonExprU:=bbButtonExpr_1;
    1: fbbButtonExprU:=bbButtonExpr_2;
    2: fbbButtonExprU:=bbButtonExpr_3;
    3: fbbButtonExprU:=bbButtonExpr_4;
    4: fbbButtonExprU:=bbButtonExpr_5;
    5: fbbButtonExprU:=bbButtonExpr_6;
    6: fbbButtonExprU:=bbButtonExpr_7;
    7: fbbButtonExprU:=bbButtonExpr_8;
    end;
if val<>fbbButtonExprU then
 begin
   if fbbButtonExprU<>nil then
       fbbButtonExprU.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
    if val<>nil then
    begin
    val.tag:=0;
     end;
   fbbButtonExprU:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setHorizTrBar(val: TImmiGraphTrBr);
begin
 if val<>fHorizTrBar then
 begin
   if val<>nil then
   begin
       val.max:=100;
       val.min:=0;
       val.position1:=0;
       val.position:=100;
   val.orientation:=trHorizontal;

   end;
   if val<>nil then val.tag:=0;

   if fHorizTrBar<>nil then
       fHorizTrBar.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   fHorizTrBar:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.setvertTrBar(val: TImmiGraphTrBr);
begin
   if val<>fVertTrBar then
 begin
   begin
       val.max:=100;
       val.min:=0;
       val.position1:=0;
       val.position:=100;
       val.orientation:=trVertical;
   end;
   if val<>nil then val.tag:=0;
    if fVertTrBar<>nil then
       fVertTrBar.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
   fVertTrBar:=val;
  if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeMulti.ButtonControlActionST(val:  TCtrlGraphButton);
begin
 if val=nil then exit;
if val=fbbSettimeArc then
 begin
   //application.MessageBox(pansichar(Datetimetostr(starttm)),pansichar(Datetimetostr(starttm+timeperiod)),0);
   SetInPUt;
   exit;
 end;
end;

procedure TImmiScopeMulti.ButtonControlAction(val: TImmiGraphButton);
begin
if val=nil then exit;
if val=fbbin then
 begin
   SetIn;
   exit;
 end;
if val=fbbout then
 begin

  SetOut;
  
  exit;
 end;
if val=fbbLeft100 then
 begin
   SetLeft100;
   exit;
 end;
if val=fbbLeft50 then
 begin
  SetLeft50;
  exit;
 end;
if val=fbbRight100 then
 begin
   SetRight100;
   exit;
 end;
if val=fbbRight50 then
 begin
  SetRight50;
  exit;
 end;
if val=fbbRight50 then
 begin
  SetTimetonow;
  exit;
 end;

end;

procedure TImmiScopeMulti.setTimePeriod(val:TTime);
var i: integer;
begin
   if  self.LimitedTime then
    begin
       if ftimeperiod>self.fLimitedPeriod then val:=self.fLimitedPeriod;
    end;
   if val>0.9999999 then val:=0.9999999;
   indicatorMulti.TimePer:=fTimePeriod;
   for i:=0 to 7 do
   if val<=incMillisecond(0,5) then exit;


    if (fTimePeriod<>val) and (val<>0) then
   begin
     fTimePeriod:=val;
   //  if trim(fExprstring)<>'' then ImmiQueryGraph;
   end;
end;

procedure TImmiScopeMulti.Loaded;
 var Msg: TMessage;
     i: integer;
begin
 inherited;
//expr:='k34_4d44_I1';
// if nodb then self.ImmiInit(Msg);
  if fTimePeriod<=0 then fTimePeriod:=1/24;
  fStartTm:=now-fTimePeriod;
//  fTimePeriod:=fTimePeriod;

  begin
  indicatorMulti.WorldTop_1:= 0;
  indicatorMulti.WorldTop_2:= 0;
  indicatorMulti.WorldTop_3:= 0;
  indicatorMulti.WorldTop_4:= 0;
  indicatorMulti.WorldTop_5:= 0;
  indicatorMulti.WorldTop_6:= 0;
  indicatorMulti.WorldTop_7:= 0;
  indicatorMulti.WorldTop_8:= 0;
  indicatorMulti.WorldBottom_1:= 100;
  indicatorMulti.WorldBottom_2:= 100;
  indicatorMulti.WorldBottom_3:= 100;
  indicatorMulti.WorldBottom_4:= 100;
  indicatorMulti.WorldBottom_5:= 100;
  indicatorMulti.WorldBottom_6:= 100;
  indicatorMulti.WorldBottom_7:= 100;
  indicatorMulti.WorldBottom_8:= 100;
   if indicatorMulti.WorldRight<>fstartTm then
       begin
      indicatorMulti.WorldLeft:= fstartTm;
      indicatorMulti.WorldRight:= fstartTm+ftimePeriod;
       end else
       begin
       indicatorMulti.WorldRight:= fstartTm+ftimePeriod;
       indicatorMulti.WorldLeft:= fstartTm;
       end;
  indicatorMulti.horlable:=self.ftimeLabel;
  end;

  //indicator.MARGIN_TOP:=indicator.MARGIN_TOP-1;
end;

procedure TImmiScopeMulti.SetForm (str: string);
begin
  fformat := str;
  caption := str;
end;

procedure TImmiScopeMulti.SetCaption (str: TCaption);
begin
  fCap := string(str);
  inherited caption := str;
end;

procedure TImmiScopeMulti.SetMylock(val: boolean);
var i: integer;
begin
if fMylock<>val then
 begin
    if val then
     begin
      if fbbIn<>nil then fbbIn.Enabled:=false;
      if fbbOUT<>nil then fbbOut.Enabled:=false;
      if fbbLeft100<>nil then fbbLeft100.Enabled:=false;
      if fbbLeft50<>nil then fbbLeft50.Enabled:=false;
      if fbbRight100<>nil then fbbRight100.Enabled:=false;
      if fbbRight50<>nil then fbbRight50.Enabled:=false;
      if fbbToNow<>nil then fbbToNow.Enabled:=false;
      if bbButtonExpr_1<>nil then bbButtonExpr_1.Enabled:=false;
      if bbButtonExpr_2<>nil then bbButtonExpr_2.Enabled:=false;
      if bbButtonExpr_3<>nil then bbButtonExpr_3.Enabled:=false;
      if bbButtonExpr_4<>nil then bbButtonExpr_4.Enabled:=false;
      if bbButtonExpr_5<>nil then bbButtonExpr_5.Enabled:=false;
      if bbButtonExpr_6<>nil then bbButtonExpr_6.Enabled:=false;
      if bbButtonExpr_7<>nil then bbButtonExpr_7.Enabled:=false;
      if bbButtonExpr_8<>nil then bbButtonExpr_8.Enabled:=false;
      if (fhorizTrbar<>nil) then  fhorizTrbar.Enabled:=false;
      if (fbbSetTimeArc<>nil) then  fbbSetTimeArc.Enabled:=false;
      if fbbIn<>nil then fbbIn.tag:=fbbIn.tag+1;
      if fbbOUT<>nil then fbbOut.tag:=fbbOut.tag+1;
      if fbbLeft100<>nil then fbbLeft100.tag:=fbbLeft100.tag+1;
      if fbbLeft50<>nil then fbbLeft50.tag:=fbbLeft50.tag+1;
      if fbbRight100<>nil then fbbRight100.tag:=fbbRight100.tag+1;
      if fbbRight50<>nil then fbbRight50.tag:=fbbRight50.Tag+1;
      if fbbToNow<>nil then fbbToNow.tag:=fbbToNow.tag+1;
      if bbButtonExpr_1<>nil then bbButtonExpr_1.tag:=bbButtonExpr_1.tag+1;
      if bbButtonExpr_2<>nil then bbButtonExpr_2.tag:=bbButtonExpr_2.tag+1;
      if bbButtonExpr_3<>nil then bbButtonExpr_3.tag:=bbButtonExpr_3.tag+1;
      if bbButtonExpr_4<>nil then bbButtonExpr_4.tag:=bbButtonExpr_4.tag+1;
      if bbButtonExpr_5<>nil then bbButtonExpr_5.tag:=bbButtonExpr_5.tag+1;
      if bbButtonExpr_6<>nil then bbButtonExpr_6.tag:=bbButtonExpr_6.tag+1;
      if bbButtonExpr_7<>nil then bbButtonExpr_7.tag:=bbButtonExpr_7.tag+1;
      if bbButtonExpr_8<>nil then bbButtonExpr_8.tag:=bbButtonExpr_8.tag+1;
      if (fhorizTrbar<>nil) then  fhorizTrbar.Tag:=fhorizTrbar.Tag+1;
      if (fbbSetTimeArc<>nil) then  fbbSetTimeArc.Tag:=fbbSetTimeArc.Tag+1;
     end
    else
     begin
      if fbbIn<>nil then fbbIn.tag:=fbbIn.tag-1;
      if fbbOUT<>nil then fbbOut.tag:=fbbOut.tag-1;
      if fbbLeft100<>nil then fbbLeft100.tag:=fbbLeft100.tag-1;
      if fbbLeft50<>nil then fbbLeft50.tag:=fbbLeft50.tag-1;
      if fbbRight100<>nil then fbbRight100.tag:=fbbRight100.tag-1;
      if fbbRight50<>nil then fbbRight50.tag:=fbbRight50.Tag-1;
      if fbbToNow<>nil then fbbToNow.tag:=fbbToNow.tag-1;
      if bbButtonExpr_1<>nil then bbButtonExpr_1.tag:=bbButtonExpr_1.tag-1;
      if bbButtonExpr_2<>nil then bbButtonExpr_2.tag:=bbButtonExpr_2.tag-1;
      if bbButtonExpr_3<>nil then bbButtonExpr_3.tag:=bbButtonExpr_3.tag-1;
      if bbButtonExpr_4<>nil then bbButtonExpr_4.tag:=bbButtonExpr_4.tag-1;
      if bbButtonExpr_5<>nil then bbButtonExpr_5.tag:=bbButtonExpr_5.tag-1;
      if bbButtonExpr_6<>nil then bbButtonExpr_6.tag:=bbButtonExpr_6.tag-1;
      if bbButtonExpr_7<>nil then bbButtonExpr_7.tag:=bbButtonExpr_7.tag-1;
      if bbButtonExpr_8<>nil then bbButtonExpr_8.tag:=bbButtonExpr_8.tag-1;
      if (fbbSetTimeArc<>nil) then bbSetTimeArc.tag:=bbSetTimeArc.tag-1;
      if (fbbIn<>nil) and (fbbIn.Tag<1) then fbbIn.Enabled:=true;
      if (fbbOUT<>nil) and (fbbOUT.Tag<1) then fbbOut.Enabled:=true;
      if (fbbLeft100<>nil) and (fbbLeft100.Tag<1) then fbbLeft100.Enabled:=true;
      if (fbbLeft50<>nil) and (fbbLeft50.Tag<1) then fbbLeft50.Enabled:=true;
      if (fbbRight100<>nil) and (fbbRight100.Tag<1) then fbbRight100.Enabled:=true;
      if (fbbRight50<>nil) and (fbbRight50.Tag<1) then fbbRight50.Enabled:=true;
      if (fbbToNow<>nil) and (fbbToNow.Tag<1) then fbbToNow.Enabled:=true;
      if (bbButtonExpr_1<>nil) and (bbButtonExpr_1.Tag<1) then bbButtonExpr_1.Enabled:=true;
      if (bbButtonExpr_2<>nil) and (bbButtonExpr_2.Tag<1) then bbButtonExpr_2.Enabled:=true;
      if (bbButtonExpr_3<>nil) and (bbButtonExpr_3.Tag<1) then bbButtonExpr_3.Enabled:=true;
      if (bbButtonExpr_4<>nil) and (bbButtonExpr_4.Tag<1) then bbButtonExpr_4.Enabled:=true;
      if (bbButtonExpr_5<>nil) and (bbButtonExpr_5.Tag<1) then bbButtonExpr_5.Enabled:=true;
      if (bbButtonExpr_6<>nil) and (bbButtonExpr_6.Tag<1) then bbButtonExpr_6.Enabled:=true;
      if (bbButtonExpr_7<>nil) and (bbButtonExpr_7.Tag<1) then bbButtonExpr_7.Enabled:=true;
      if (bbButtonExpr_8<>nil) and (bbButtonExpr_8.Tag<1) then bbButtonExpr_8.Enabled:=true;
       if (bbSetTimeArc<>nil) and (bbSetTimeArc.Tag<1) then bbSetTimeArc.Enabled:=true;
      if (fhorizTrbar<>nil) then
         begin
             fhorizTrbar.tag:=fhorizTrbar.tag-1;
             if fhorizTrbar.tag<1 then begin
             fhorizTrbar.enabled:=true;
             //fhorizTrbar.max:=100;
            // fhorizTrbar.min:=0;
            // fhorizTrbar.position1:=0;
             //fhorizTrbar.position:=100;
             end;
         end;
     end;
   fMylock:=val;
   
 end;

end;

procedure TImmiScopeMulti.SetInVert(newMin:  double; newMax:  double; num: integer);
var 
    delts: double;

begin
     case num of
     0:
     begin
     if indicatorMulti.WorldBottom_1<>newmax then
     begin
     indicatorMulti.WorldTop_1:= newmax;
     indicatorMulti.WorldBottom_1:= newmin;
     end else
     begin
     indicatorMulti.WorldBottom_1:= newmin;
     indicatorMulti.WorldTop_1:= newmax;
     end;
     end;

     1:
     begin
     if indicatorMulti.WorldBottom_2<>newmax then
     begin
     indicatorMulti.WorldTop_2:= newmax;
     indicatorMulti.WorldBottom_2:= newmin;
     end else
     begin
     indicatorMulti.WorldBottom_2:= newmin;
     indicatorMulti.WorldTop_2:= newmax;
     end;
     end;

     2:
     begin
     if indicatorMulti.WorldBottom_3<>newmax then
     begin
     indicatorMulti.WorldTop_3:= newmax;
     indicatorMulti.WorldBottom_3:= newmin;
     end else
     begin
     indicatorMulti.WorldBottom_3:= newmin;
     indicatorMulti.WorldTop_3:= newmax;
     end;
     end;

     3:
     begin
     if indicatorMulti.WorldBottom_4<>newmax then
     begin
     indicatorMulti.WorldTop_4:= newmax;
     indicatorMulti.WorldBottom_4:= newmin;
     end else
     begin
     indicatorMulti.WorldBottom_4:= newmin;
     indicatorMulti.WorldTop_4:= newmax;
     end;
     end;

     4:
     begin
     if indicatorMulti.WorldBottom_5<>newmax then
     begin
     indicatorMulti.WorldTop_5:= newmax;
     indicatorMulti.WorldBottom_5:= newmin;
     end else
     begin
     indicatorMulti.WorldBottom_5:= newmin;
     indicatorMulti.WorldTop_5:= newmax;
     end;
     end;

     5:
     begin
     if indicatorMulti.WorldBottom_6<>newmax then
     begin
     indicatorMulti.WorldTop_6:= newmax;
     indicatorMulti.WorldBottom_6:= newmin;
     end else
     begin
     indicatorMulti.WorldBottom_6:= newmin;
     indicatorMulti.WorldTop_6:= newmax;
     end;
     end;

      6:
     begin
     if indicatorMulti.WorldBottom_7<>newmax then
     begin
     indicatorMulti.WorldTop_7:= newmax;
     indicatorMulti.WorldBottom_7:= newmin;
     end else
     begin
     indicatorMulti.WorldBottom_7:= newmin;
     indicatorMulti.WorldTop_7:= newmax;
     end;
     end;

      7:
     begin
     if indicatorMulti.WorldBottom_8<>newmax then
     begin
     indicatorMulti.WorldTop_8:= newmax;
     indicatorMulti.WorldBottom_8:= newmin;
     end else
     begin
     indicatorMulti.WorldBottom_8:= newmin;
     indicatorMulti.WorldTop_8:= newmax;
     end;
     end;

     end;
    self.FillPerfect(num);
end;

destructor TImmiScopeMulti.Destroy;
var i: integer;
begin
  for i:=0 to 7 do
    try
       setlength(indicatorMulti.resabs[i].point,0);
       indicatorMulti.resabs[i].n:=0;
       setlength(res[i].point,0);
       res[i].n:=0;
       a_queryforanalog[i].free;
       a_queryforanalogabs[i].free;
    except
    end;

    Furrsttime:=false;

    inherited;

end;


procedure TImmiScopeMulti.ImmiQueryGraph(index: integer);
var
   val,val1: real;
   str: string;
   newCap: string;
   last,last1: double;
   datpoint: TDPoint;
   datpoint1: TDPoint;
   isf: boolean;
   strfind,i: integer;


begin
         if (a_idexpr[index]<0)  then exit;
          setlength(res[index].point,0);
          res[index].n:=0;
         begin
         fminValEu[index]:=rtitems.items[a_idexpr[index]].MinEU;
         fmaxValEu[index]:=rtitems.items[a_idexpr[index]].MaxEU;
         if (fvertTrbar<>nil) and (a_idexpr[index]>-1) then
         begin
          fminValEu[index]:=rtitems.items[a_idexpr[index]].MinEU+(100-fvertTrbar.position)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
          fmaxValEu[index]:=rtitems.items[a_idexpr[index]].MinEU+(100-fvertTrbar.position1)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
         end;


         case index of
         0:
         if indicatorMulti.WorldBottom_1<>fmaxValEu[index] then
         begin
         indicatorMulti.WorldTop_1:= fmaxValEu[index];
         indicatorMulti.WorldBottom_1:= fminValEu[index];
         end else
         begin
         indicatorMulti.WorldBottom_1:= fminValEu[index];
         indicatorMulti.WorldTop_1:= fmaxValEu[index];
         end;
          1:
         if indicatorMulti.WorldBottom_2<>fmaxValEu[index] then
         begin
         indicatorMulti.WorldTop_2:= fmaxValEu[index];
         indicatorMulti.WorldBottom_2:= fminValEu[index];
         end else
         begin
         indicatorMulti.WorldBottom_2:= fminValEu[index];
         indicatorMulti.WorldTop_2:= fmaxValEu[index];
         end;
          2:
         if indicatorMulti.WorldBottom_3<>fmaxValEu[index] then
         begin
         indicatorMulti.WorldTop_3:= fmaxValEu[index];
         indicatorMulti.WorldBottom_3:= fminValEu[index];
         end else
         begin
         indicatorMulti.WorldBottom_3:= fminValEu[index];
         indicatorMulti.WorldTop_3:= fmaxValEu[index];
         end;
          3:
         if indicatorMulti.WorldBottom_4<>fmaxValEu[index] then
         begin
         indicatorMulti.WorldTop_4:= fmaxValEu[index];
         indicatorMulti.WorldBottom_4:= fminValEu[index];
         end else
         begin
         indicatorMulti.WorldBottom_4:= fminValEu[index];
         indicatorMulti.WorldTop_4:= fmaxValEu[index];
         end;
          4:
         if indicatorMulti.WorldBottom_5<>fmaxValEu[index] then
         begin
         indicatorMulti.WorldTop_5:= fmaxValEu[index];
         indicatorMulti.WorldBottom_5:= fminValEu[index];
         end else
         begin
         indicatorMulti.WorldBottom_5:= fminValEu[index];
         indicatorMulti.WorldTop_5:= fmaxValEu[index];
         end;
           5:
         if indicatorMulti.WorldBottom_6<>fmaxValEu[index] then
         begin
         indicatorMulti.WorldTop_6:= fmaxValEu[index];
         indicatorMulti.WorldBottom_6:= fminValEu[index];
         end else
         begin
         indicatorMulti.WorldBottom_6:= fminValEu[index];
         indicatorMulti.WorldTop_6:= fmaxValEu[index];
         end;
          6:
         if indicatorMulti.WorldBottom_7<>fmaxValEu[index] then
         begin
         indicatorMulti.WorldTop_7:= fmaxValEu[index];
         indicatorMulti.WorldBottom_7:= fminValEu[index];
         end else
         begin
         indicatorMulti.WorldBottom_7:= fminValEu[index];
         indicatorMulti.WorldTop_7:= fmaxValEu[index];
         end;
          7:
         if indicatorMulti.WorldBottom_8<>fmaxValEu[index] then
         begin
         indicatorMulti.WorldTop_8:= fmaxValEu[index];
         indicatorMulti.WorldBottom_8:= fminValEu[index];
         end else
         begin
         indicatorMulti.WorldBottom_8:= fminValEu[index];
         indicatorMulti.WorldTop_8:= fmaxValEu[index];
         end;
         end;

        // application.MessageBox(pansichar(floattostr(fminValEu)+'  oooo'+floattostr(fmaxValEu)),pansichar(''),0);
        if indicatorMulti.WorldRight<>fstartTm then
       begin
       indicatorMulti.WorldLeft:= fstartTm;
       indicatorMulti.WorldRight:= fstartTm+ftimePeriod;
       end else
       begin
      indicatorMulti.WorldRight:= fstartTm+ftimePeriod;
      indicatorMulti.WorldLeft:= fstartTm;
       end;
       //  idExpr:=rtitems.getsimpleId(fExprString);

        // idExpr1:=rtitems.getsimpleId(fExprString1);
         if (a_idexpr[index]>-1) { and (conttimeoff)} then
           begin
           setlength(indicatorMulti.resabs[index].point,0);
           indicatorMulti.resabs[index].n:=0;
           MyLock:=true;
           QueryPeriod(rtitems.items[a_idexpr[index]].GroupNum,index)
           end
         else
           try
             MyLock:=true;
             QueryExpr(index);
           except
           end;

      end;

end;

procedure TImmiScopeMulti.SetByTrackBarH(index: integer;min,max: integer);
begin
    if (a_idexpr[index]<0) then exit;
    SetNewRange(min,max,index);
end;

procedure TImmiScopeMulti.SetByTrackBarV(index: integer;min,max: integer);
begin
  if (a_idexpr[index]<0) then exit;
   case index of
   0:
   begin
    minValEu_1:=rtitems.items[a_idexpr[index]].MinEU+(100-max)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
    maxValEu_1:=rtitems.items[a_idexpr[index]].MinEU+(100-min)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
   end;
    1:
   begin
    minValEu_2:=rtitems.items[a_idexpr[index]].MinEU+(100-max)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
    maxValEu_2:=rtitems.items[a_idexpr[index]].MinEU+(100-min)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
   end;
   2:
   begin
    minValEu_3:=rtitems.items[a_idexpr[index]].MinEU+(100-max)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
    maxValEu_3:=rtitems.items[a_idexpr[index]].MinEU+(100-min)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
   end;
   3:
    begin
    minValEu_3:=rtitems.items[a_idexpr[index]].MinEU+(100-max)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
    maxValEu_3:=rtitems.items[a_idexpr[index]].MinEU+(100-min)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
   end;
    4:
   begin
    minValEu_5:=rtitems.items[a_idexpr[index]].MinEU+(100-max)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
    maxValEu_5:=rtitems.items[a_idexpr[index]].MinEU+(100-min)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
   end;
    5:
   begin
    minValEu_6:=rtitems.items[a_idexpr[index]].MinEU+(100-max)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
    maxValEu_6:=rtitems.items[a_idexpr[index]].MinEU+(100-min)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
   end;
   6:
   begin
    minValEu_7:=rtitems.items[a_idexpr[index]].MinEU+(100-max)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
    maxValEu_7:=rtitems.items[a_idexpr[index]].MinEU+(100-min)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
   end;
   7:
    begin
    minValEu_8:=rtitems.items[a_idexpr[index]].MinEU+(100-max)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
    maxValEu_8:=rtitems.items[a_idexpr[index]].MinEU+(100-min)/100*abs(rtitems.items[a_idexpr[index]].MaxEU-rtitems.items[a_idexpr[index]].MinEU);
   end;
   end;
    //application.MessageBox(pansichar(floattostr(minValEu)),pansichar(floattostr(maxValEu)),0);
  end;

procedure TImmiScopeMulti.Setexpr( index: integer; value: TExprStr);
var ms: TMessage;
    num: integer;
begin

  if true then
   begin
     fStartTm:=indicatorMulti.StartTime;
     fTimePeriod:=1;
   end;
//  indicatorMulti.StartTime:=fStartTm;
//  indicatorMulti.TimePer:=fTimePeriod;
   if indicatorMulti.WorldRight<>fstartTm then
       begin
       indicatorMulti.WorldLeft:= startTm;
       indicatorMulti.WorldRight:= startTm+timePeriod;
       end else
       begin
       indicatorMulti.WorldRight:= startTm+ftimePeriod;
       indicatorMulti.WorldLeft:= startTm;
       end;
  begin
  if a_fExprstring[index]<>value then
   begin
     //case index of
   a_fExprstring[index]:='_p701';
   a_idExpr[index]:=rtitems.getsimpleId(trim(a_fExprString[index]));
   if a_idexpr[index]<-1 then
     begin
        setlength(indicatorMulti.resabs[index].point,0);
        indicatorMulti.resabs[index].n:=0;
        setlength(indicatorMulti.resabs[index].point,0);
        res[index].n:=0;
     end;
   if flbexprname<>nil then
   begin
   if a_idexpr[index]>-1 then
   flbexprname.Caption:=rtitems.GetComment(a_idexpr[index]) else
   flbexprname.Caption:='Пусто';
   end;
    fQueryStartTm:=0;
    fQueryTimePeriod:=0;
    if (fhorizTrbar<>nil) then
         begin
             fhorizTrbar.max:=100;
             fhorizTrbar.min:=0;
             fhorizTrbar.position1:=0;
             fhorizTrbar.position:=100;
         end;
   if a_idexpr[index]>-1 then
   begin
      if (fvertTrbar<>nil) then
         begin
             fVertTrbar.max:=100{round(rtitems.items[idexpr].MaxEU)};
             fVertTrbar.min:=0{round(rtitems.items[idexpr].MinEU)};
             fVertTrbar.position1:=0{round(rtitems.items[idexpr].MinEU)};
             fVertTrbar.position:=100{round(rtitems.items[idexpr].MaxEU)};
         end;
     if trim(a_fExprstring[index])<>'' then  ImmiQueryGraph(index);
   end;
   end;
   if (trim(value)='') or  (a_idexpr[index]<0) then
   begin
  // application.MessageBox(pansichar('Start'),pansichar('Start'),0);
   //exprNil;
   end;
   end;
   
end;


procedure  TImmiScopeMulti.SetDateTM;
var str: string;
begin
if flbdate<>nil then
  begin
   if dayofthemonth(Starttm)<>dayofthemonth(Starttm+TimePeriod) then
     flbdate.caption:=(FormatDateTime('dd.mm.yyyy',Starttm))+'-'+(FormatDateTime('dd.mm.yyyy',Starttm+TimePeriod)) else
     flbdate.caption:=(FormatDateTime('dd.mm.yyyy',Starttm));
  end;
  str:='';
if dayofthemonth(Starttm)<>dayofthemonth(Starttm+TimePeriod) then
begin
str:='dd.mm '
end;
str:=str+'hh';
if Minuteofthehour(Starttm)<>Minuteofthehour(Starttm+TimePeriod) then
begin
str:=str+':nn';
end;
// SecondoftheMinute(Starttm)<>SecondoftheMinute(Starttm+TimePeriod) then
//gin
str:=str+':ss';
//d;
if MilliSecondoftheSecond(Starttm)<>MilliSecondoftheSecond(Starttm+TimePeriod) then
begin
str:=str+'.zzz'
end;
if flbStart<>nil then
begin
  // flbStart.caption:=FormatDateTime(str,Starttm);
end;
if flbMidle<>nil then
begin
   flbMidle.caption:=FormatDateTime(str,Starttm+TimePeriod/2);
end;
if flbStop<>nil then
begin
//   flbStop.caption:=FormatDateTime(str,Starttm+TimePeriod);
end;
end;

procedure TImmiScopeMulti.FillPerfect(index: integer);
var i,j: integer;
    datpoint: TDPoint;
    strfind: integer;
    flab: boolean;
    firststatus,instatus, laststatus,outstatus: boolean;
    wL,wr,wt,wb: double;
begin
  if res[index].n=0 then
    begin
    isarcNul[0]:=true;
    exit;
    end;
    begin
     wl:=indicatormulti.WorldLeft;
     wr:=indicatormulti.WorldRight;
     wt:=indicatormulti.fWorldtop[index];
     wb:=indicatormulti.fWorldbottom[index];
    end;
  firststatus:=false;
  laststatus:=false;
  instatus:=false;
  outstatus:=false;
 indicatorMulti.FFirstPoint[index]:=true;
  if fAutoSizeEU or ((flbStop<>nil) or (flbStart<>nil)) then SetCurUe(index);
  begin
  for i:=0 to res[index].n-1 do
    begin
        if (res[index].point[i][1]<wl) and (i< res[index].n-1) and
              (res[index].point[i+1][1]>wr) then  outstatus:=true;

        if (not outstatus) and (res[index].point[i][1]<wl) and
                 (i< res[index].n-1) and
                      (res[index].point[i+1][1]>wl) then
                        firststatus:=true;
        if (not outstatus) and (res[index].point[i][1]<wr) and
                 (i< res[index].n-1) and
                      (res[index].point[i+1][1]>wr) then
                        laststatus:=true;
        if (res[index].point[i][1]>=wl) and
              (res[index].point[i][1]<=wr) then  instatus:=true;
        if outstatus then laststatus:=false;
        if outstatus then firststatus:=false;
        if  instatus then
             begin
               indicatormulti.AddPointP(res[index].point[i],0,1,0);
               if (i+1)=(res[index].n-1) then  indicatormulti.AddPointP(res[index].point[i+1],0,1,0);
             end;

        if  (firststatus) then
             begin
               datpoint[1]:=wl+0.00000000001;
               datpoint[2]:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2],wl);
               indicatormulti.AddPointP(datpoint,0,1,0);
               indicatormulti.AddPointP(datpoint,0,1,0);
             end;

         if  (laststatus) then
             begin
               datpoint[1]:=wr+0.00000000001;
               datpoint[2]:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2],wr);
               indicatormulti.AddPointP(res[index].point[i],0,1,0);
               indicatormulti.AddPointP(datpoint,0,1,0);
             end;

         if  (outstatus) then
             begin
               datpoint[1]:=wl+0.00000000001;
               datpoint[2]:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2],wl);
               indicatormulti.AddPointP(datpoint,0,1,0);
               indicatormulti.AddPointP(datpoint,0,1,0);
               datpoint[1]:=wr+0.00000000001;
               datpoint[2]:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2],wr);
               indicatormulti.AddPointP(datpoint,0,1,0);
             end;
       firststatus:=false;
       laststatus:=false;
       instatus:=false;
       outstatus:=false;
    end;
     refresh;
  if (flbStop<>nil) then  flbStop.Caption:=format(flbStop.getlabelformat,[valright]);
  if (flbStart<>nil) then  flbStart.Caption:=format(flbStop.getlabelformat,[valleft]);
  end;
end;




function TImmiScopeMulti.QueryExpr(index: integer) :tTDPoint;
var
   days, i,j, idLock: integer;
   curDate,Length,start: TDateTime;
   TableName,TableName1, sQuery, unionstr: string;
   curdateTS: TdateTime;
   Day1, Day2: double;
   OneTab, TwoTab: boolean;
   FirstTabEx: boolean;
   SecondTabEx: boolean;
   hes: TEventStatus;
   herr: Error;
   err: Error;
   evs: TEventstatus;
begin
  FirstTabEx:=false;
  SecondTabEx:=false;
  idLock:=a_idExpr[index];
  a_queryforanalog[index].tag:=index;



  try
    setlength(res[index].point,0);
    res[index].n:=0;
    Setlength(result.point, 0);
    result.n:=0;
    start:=fStartTm;
    length:=fTimePeriod;
    fQueryStartTm:=fStartTm;
    fQueryTimePeriod:=fTimePeriod;
    days := dayoftheMonth(Start + Length) -  dayoftheMonth(start);
    if days<>0 then days:=1;
    CurDate:= trunc(Start);
    OneTab:=false; TwoTab:=false;
  //  application.MessageBox(pansichar(inttostr(idLock)),pansichar(datetimetostr(start)+'-'+datetimetostr(start+length)),0);
    curdateTS :=  strtoDate('30.12.1899') - strtoDate('01.01.3000')+ CurDate;
   // TableName:= 'tr' + datetoFileName(start);
    Application.ProcessMessages;
    sQuery:='';
    if a_datamod[index].TableExist(TableName) then
       begin
       OneTab:=true;
       FirstTabEx:=true;
       sQuery := 'select tm,val from '+Tablename+' where (cod=:f3) and (tm=(select max(tm) from '+Tablename+' where (cod=:f2) and (tm<:start2))) UNION ';
       sQuery := sQuery+ format( ' SELECT tm , val ' +
                        'FROM  %s  ' +
                        'WHERE (cod = :f)',
                        [TableName]);
       sQuery := sQuery + ' AND (tm > :start) ';
       sQuery := sQuery + ' AND (tm < :stop)';
       end;
    if days>0 then
       begin
   //    TableName1:= 'tr' + datetoFileName(start + Length);
       if a_datamod[index].TableExist(TableName1) then
         begin
         TwoTab:=true;
         SecondTabEx:=true;
         if sQuery<>'' then sQuery:= sQuery+' UNION ';
         sQuery := squery+format( 'SELECT tm , val ' +
                        'FROM  %s  ' +
                        'WHERE (cod = :f1)',
                        [TableName1, TableName1, TableName1, TableName1
                                                ]);
         sQuery := sQuery + ' AND (tm > :start1) ';
         sQuery := sQuery + ' AND (tm < :stop1) ';
         end;
       end;
    if SecondTabEx or FirstTabEx then
    begin
    sQuery:= sQuery+ ' ORDER BY tm ASC';
    with a_queryforanalog[index] do
      begin
      Sql.Clear;
      sql.Add(sQuery);
      if OneTab then
        begin
        parameters.ParamByName('f').Value:=idLock{expr};
        parameters.ParamByName('f2').Value:=idLock{expr};
        parameters.ParamByName('f3').Value:=idLock{expr};
        parameters.ParamByName('start').DataType:=ftstring;
   //     parameters.ParamByName('start').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('start2').DataType:=ftstring;
      //  parameters.ParamByName('start2').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('stop').DataType:=ftstring;
     //   parameters.ParamByName('stop').Value:=SelfFormatDateTime(Start + Length);
        end;
      if TwoTab then
        begin
        parameters.ParamByName('f1').Value:=idLock{expr1};
        parameters.ParamByName('start1').DataType:=ftstring;
       // parameters.ParamByName('start1').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('stop1').DataType:=ftstring;
   //     parameters.ParamByName('stop1').Value:=SelfFormatDateTime(Start + Length);
        end;
    // application.MessageBox(pansichar(sQuery),pansichar(datetimetostr(start)+'-'+datetimetostr(start+length)),0) ;
      try
      Open;
      if not asyncBase then Query1FetchComplete(a_queryforanalog[index],err,evs);
      except
     Mylock:=false;
      end;
       //application.MessageBox(pansichar('Ok'),pansichar('Ok'),0)
      end;

    end
    else
    begin
      Mylock:=false;
    end;
    except
   // on e:Exception do  application.MessageBox(pansichar( sQuery),pansichar(e.message),0);
    end;
end;

procedure TImmiScopeMulti.Query1FetchComplete(DataSet: TCustomADODataSet;
  const Error: Error; var EventStatus: TEventStatus);
var 
    j,k,l,index: integer;

begin
   k:=0;
   l:=0;
   //if not myLock then exit;
   index:=DataSet.tag;
   if (DataSet=a_queryforanalog[index]) then
     begin
     //application.MessageBox(pansichar(inttostr(DataSet.RecordCount)),pansichar(inttostr(DataSet.RecordCount)),0);
     res[index].n:=0;
     try
       if not DataSet.Active then DataSet.Open;
       res[index].n:=DataSet.RecordCount;
       Setlength(res[index].point, 2);
       if DataSet.RecordCount>0 then DataSet.first;
        //DataSet.recno:=1;
       if DataSet.RecordCount>1 then
        begin
       //   inc(k);
         // res.n:=2;
          res[index].n:=res[index].n+2;;
          inc(k);
          inc(k);
          l:=1;
          res[index].point[0][1]:=fStartTm;
          res[index].point[0][2]:=double(real(DataSet['val']));
           res[index].point[1][1]:=fStartTm;
          res[index].point[1][2]:=double(real(DataSet['val']));
          DataSet.next;
        end;
         Setlength(res[index].point, DataSet.RecordCount+k);
       for j := 0+k to DataSet.RecordCount  - 1+k do
        begin
        res[index].point[j][1]:=(DataSet['tm']);
        res[index].point[j][2]:=double(real(DataSet['val']));
        if not dataset.eof  then DataSet.Next;
        end;
      if (res[index].n>1) and (res[index].point[DataSet.RecordCount+k  - 1][1]<fStartTm+fTimePeriod-0.000000000000001) then
        begin
           try
           res[index].n:=res[index].n+1;
           Setlength(res[index].point, DataSet.RecordCount+k+1);
           res[index].point[DataSet.RecordCount+k ][1]:=fStartTm+fTimePeriod-0.0000000001;
           res[index].point[DataSet.RecordCount+k ][2]:=double(real(DataSet['val']));
           except
          // on e:Exception do  application.MessageBox(pansichar(''),pansichar(e.message),0);
           end;
        end;
      if res[index].n=0 then
       begin
       res[index].n:=2;
       Setlength(res[index].point, 2);
       res[index].point[0][1]:=fStartTm;
       res[index].point[0][2]:=0;
       res[index].point[1][1]:=fStartTm+fTimePeriod-0.0000000001;
       res[index].point[1][2]:=0;
       end;
       // application.MessageBox(pansichar(inttostr(res.n)),pansichar(inttostr(DataSet.RecordCount)),0);
       if res[index].n=1 then
       begin
        res[index].n:=3;
       Setlength(res[index].point, 3);
       res[index].point[0][1]:=fStartTm;
       res[index].point[0][2]:=double(real(DataSet['val']));
       res[index].point[1][1]:=fStartTm+0.0000000001;
       res[index].point[1][2]:=double(real(DataSet['val']));
       res[index].point[2][1]:=fStartTm+fTimePeriod-0.0000000001;
       res[index].point[2][2]:=double(real(DataSet['val']));
       end
     except
        MyLock:=false;
     end;
     DataSet.close;
     //indicator.fFirstPoint[0]:=true;
     if (DataSet=a_queryforanalog[index]) then
       begin
      
       FillPerfect(index);
      // FillAbsence(resabs);
      MyLock:=false;
       end

    end;
    if (DataSet=a_queryforanalogabs[index]) then
      begin
      indicatormulti.resabs[index].n:=DataSet.RecordCount;

      Setlength(indicatormulti.resabs[index].point, DataSet.RecordCount);
      if DataSet.RecordCount>0 then DataSet.first;
      if DataSet.RecordCount>0 then DataSet.recno:=1;
      for j:=0 to DataSet.RecordCount - 1 do
        begin
        indicatormulti.resabs[index].point[j][1]:=DataSet['stoptime'];
        indicatormulti.resabs[index].point[j][2]:=DataSet['starttime'];
        if not dataset.eof then  DataSet.Next;
        end;
      if trim(a_fexprstring[index])<>'' then
        QueryExpr(index)
       else MyLock:=false;
     
      end;
end;




procedure TImmiScopeMulti.Query1FetchProgress(DataSet: TCustomADODataSet;
  Progress, MaxProgress: Integer; var EventStatus: TEventStatus);
begin

end;

function  TImmiScopeMulti.QueryPeriod(numg: integer; index: integer):tTDPoint;
var
   days, i: integer;
   curDate,Length,start,stop: TDateTime;
   TableName, sQuery: string;
   curdateTS: TdateTime;
   err: Error;
   evs: TEventstatus;
begin

      a_queryforanalogabs[index].tag:=index;

  try

    start:=fStartTm;
    stop:=fStartTm+fTimeperiod;
    sQuery := '';
    if numg=0 then TableName:= 'StStDef' else TableName:= 'StStDef'+ inttostr(numg);
    //application.MessageBox(pansichar(''),pansichar(TableName),0);

    if a_datamod[index].TableExist(TableName) then
      begin
      sQuery := 'select * from '+TableName+' where ((starttime>=:start1 and starttime<=:stop1) or (stoptime>=:start2 and stoptime<=:stop2)  or ((stoptime<=:start3) and (starttime>=:stop3)))';
     //application.MessageBox(pansichar(SelfFormatDateTime(fStartTm)),pansichar(SelfFormatDateTime(fStartTm+fTimeperiod)),0);
      with a_queryforanalogabs[index] do
        begin

        Sql.Clear;
        Sql.Add(sQuery);
        parameters.ParamByName('start1').DataType:=ftstring;
   //     parameters.ParamByName('start1').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('start2').DataType:=ftstring;
   //     parameters.ParamByName('start2').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('start3').DataType:=ftstring;
     //   parameters.ParamByName('start3').Value:=SelfFormatDateTime(start);
        parameters.ParamByName('stop1').DataType:=ftstring;
     //   parameters.ParamByName('stop1').Value:=SelfFormatDateTime(stop);
        parameters.ParamByName('stop2').DataType:=ftstring;
    //    parameters.ParamByName('stop2').Value:=SelfFormatDateTime(stop);
        parameters.ParamByName('stop3').DataType:=ftstring;
    //    parameters.ParamByName('stop3').Value:=SelfFormatDateTime(stop);
         try
           open;
           if not asyncBase then Query1FetchComplete(a_queryforanalogabs[index],err,evs);
         except
         QueryExpr(index);
          end;
        end;
      end;
  except
    // on e:Exception do  application.MessageBox(pansichar(''),pansichar(e.message),0);
  end;
end;

procedure TImmiScopeMulti.ExprNil;
var
  Pn : TDPoint;
  Pc : TDPoint;
begin
  { if ftimeperiod<=incMillisecond(0,5) then ftimeperiod:=incMillisecond(0,5);
  if tindicator(indicList.Items[index]).WorldRight<>fstarttm then
  begin
  tindicator(indicList.Items[index]).Worldleft:= fstarttm;
  tindicator(indicList.Items[index]).WorldRight:= fstarttm+ftimeperiod;
  end else
  begin
  tindicator(indicList.Items[index]).WorldRight:= fstarttm+ftimeperiod;
  tindicator(indicList.Items[index]).Worldleft:= fstarttm;
  end;
   tindicator(indicList.Items[index]).WorldTop:= 0;
   tindicator(indicList.Items[index]).WorldBottom:= 100;
  pc[1]:=fstarttm;
  Pn[1]:=fstarttm+ftimeperiod;
  //application.MessageBox(pansichar('Start'),pansichar('Start'),0);
  tindicator(indicList.Items[index]).DrawGridStStop(pn,pc);
  refresh;  }
end;

procedure TImmiScopeMulti.SetCurUE(index: integer);
var minEus, maxEus: double;
    i: integer;
    firststatus,instatus, laststatus,outstatus: boolean;
      wL,wr,wt,wb: double;
begin
  firststatus:=false;
  laststatus:=false;
  instatus:=false;
  outstatus:=false;
   begin
     wl:=indicatormulti.WorldLeft;
     wr:=indicatormulti.WorldRight;
     wt:=indicatormulti.fWorldtop[index];
     wb:=indicatormulti.fWorldbottom[index];
    end;
  //if (idexpr>-1) then
    if (a_idexpr[index]<0)  then exit;
   begin
    minEus:=rtitems.items[a_idexpr[index]].maxEu;
    maxEus:=rtitems.items[a_idexpr[index]].minEu;
    for i:=0 to res[index].n-1 do
      begin
        if (res[index].point[i][1]< wl) and (i< res[index].n-1) and
              (res[index].point[i+1][1]> wr) then  outstatus:=true;

        if (not outstatus) and (res[index].point[i][1]< wl) and
                 (i< res[index].n-1) and
                      (res[index].point[i+1][1]> wl) then
                        firststatus:=true;
        if (not outstatus) and (res[index].point[i][1]< wr) and
                 (i< res[index].n-1) and
                      (res[index].point[i+1][1]> wr) then
                        laststatus:=true;
        if (res[index].point[i][1]>= wl) and
              (res[index].point[i][1]<= wr) then  instatus:=true;



        if  instatus then
             begin
               if fautosizeEU then begin
               if res[index].point[i][2]<minEus then minEus:=res[index].point[i][2];
               if res[index].point[i][2]>maxEus then maxEus:=res[index].point[i][2]; end;
               if i=0 then valLeft:=res[index].point[i][2];
               if (i+1)=(res[index].n-1) then
                  begin
                   if fautosizeEU then begin
                   if res[index].point[i+1][2]<minEus then minEus:=res[index].point[i][2];
                   if res[index].point[i+1][2]>maxEus then maxEus:=res[index].point[i][2]; end;
                   valRight:=res[index].point[i+1][2];
                  end;
             end;

        if  (firststatus) then
             begin
              if fautosizeEU then begin
              if GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl)<mineuS then minEus:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl);
               if GetMidY(res[index].point[i][1 ],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl)>maxEus then maxEus:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl); end;
               valLeft:=GetMidY(res[index].point[i][1 ],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl);
             end;

         if  (laststatus) then
             begin
               if fautosizeEU then begin
               if GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr)<mineuS then minEus:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr);
               if GetMidY(res[index].point[i][1 ],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr)>maxEus then maxEus:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr); end;
               valRight:=GetMidY(res[index].point[i][1 ],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr);
             end;

         if  (outstatus) then
             begin
               if fautosizeEU then begin
               if GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl)<mineuS then minEus:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl);
               if GetMidY(res[index].point[i][1 ],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl)>maxEus then maxEus:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl);
               if GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr)<mineuS then minEus:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr);
               if GetMidY(res[index].point[i][1 ],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr)>maxEus then maxEus:=GetMidY(res[index].point[i][1],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr); end;
               valLeft:=GetMidY(res[index].point[i][1 ],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wl);
               valRight:=GetMidY(res[index].point[i][1 ],res[index].point[i][2],res[index].point[i+1][1],res[index].point[i+1][2], wr);
             end;
        firststatus:=false;
        laststatus:=false;
        instatus:=false;
        outstatus:=false;
       end;
    //   application.MessageBox(pansichar(floattostr(minEus)+'   ^ '+floattostr(maxEus)),pansichar(''),0);
       if fautosizeEU then begin
       if minEUs=maxEUs then
         begin
           minEus:=minEus-(rtitems.items[a_idexpr[index]].maxEu-rtitems.items[a_idexpr[index]].minEu)*0.005;
           maxEus:=maxEus+(rtitems.items[a_idexpr[index]].maxEu-rtitems.items[a_idexpr[index]].minEu)*0.005;
         end;
       if minEUs=maxEUs then
         begin
           minEus:=minEus-0.005;
           maxEus:=maxEus+0.005;
         end;
        case index of
        0:

        if  indicatorMulti.WorldBottom_1<>maxEus then
          begin
            indicatorMulti.WorldTop_1:= maxEus;
            indicatorMulti.WorldBottom_1:= minEus;
          end else
          begin
             indicatorMulti.WorldBottom_1:= minEUs;
             indicatorMulti.WorldTop_1:= maxEus;
          end;
         1:
         if  indicatorMulti.WorldBottom_2<>maxEus then
          begin
            indicatorMulti.WorldTop_2:= maxEus;
            indicatorMulti.WorldBottom_2:= minEus;
          end else
          begin
             indicatorMulti.WorldBottom_2:= minEUs;
             indicatorMulti.WorldTop_2:= maxEus;
          end;
         2:

        if  indicatorMulti.WorldBottom_3<>maxEus then
          begin
            indicatorMulti.WorldTop_3:= maxEus;
            indicatorMulti.WorldBottom_3:= minEus;
          end else
          begin
             indicatorMulti.WorldBottom_3:= minEUs;
             indicatorMulti.WorldTop_3:= maxEus;
          end;
         3:
         if  indicatorMulti.WorldBottom_4<>maxEus then
          begin
            indicatorMulti.WorldTop_4:= maxEus;
            indicatorMulti.WorldBottom_4:= minEus;
          end else
          begin
             indicatorMulti.WorldBottom_4:= minEUs;
             indicatorMulti.WorldTop_4:= maxEus;
          end;
          4:

        if  indicatorMulti.WorldBottom_5<>maxEus then
          begin
            indicatorMulti.WorldTop_5:= maxEus;
            indicatorMulti.WorldBottom_5:= minEus;
          end else
          begin
             indicatorMulti.WorldBottom_5:= minEUs;
             indicatorMulti.WorldTop_5:= maxEus;
          end;
         5:
         if  indicatorMulti.WorldBottom_6<>maxEus then
          begin
            indicatorMulti.WorldTop_6:= maxEus;
            indicatorMulti.WorldBottom_6:= minEus;
          end else
          begin
             indicatorMulti.WorldBottom_6:= minEUs;
             indicatorMulti.WorldTop_6:= maxEus;
          end;
         6:

        if  indicatorMulti.WorldBottom_7<>maxEus then
          begin
            indicatorMulti.WorldTop_7:= maxEus;
            indicatorMulti.WorldBottom_7:= minEus;
          end else
          begin
             indicatorMulti.WorldBottom_7:= minEUs;
             indicatorMulti.WorldTop_7:= maxEus;
          end;
         7:
         if  indicatorMulti.WorldBottom_8<>maxEus then
          begin
            indicatorMulti.WorldTop_8:= maxEus;
            indicatorMulti.WorldBottom_8:= minEus;
          end else
          begin
             indicatorMulti.WorldBottom_8:= minEUs;
             indicatorMulti.WorldTop_8:= maxEus;
          end;
        end;
        end;


    end;
end;

procedure TImmiScopeMulti.queryanalogBeforeOpen(DataSet: TDataSet);
var index:integer;
begin
index:=dataset.tag;
if a_queryforanalog[index]=nil then exit;
if not asyncBase then
begin
  a_queryforanalog[index].ExecuteOptions:=[];
end;
end;

procedure TImmiScopeMulti.queryanalogabsBeforeOpen(DataSet: TDataSet);
var index:integer;
begin
index:=dataset.tag;
if a_queryforanalogAbs[index]=nil then exit;
if not asyncBase then
begin
  a_queryforanalogabs[index].ExecuteOptions:=[];
end;
end;

procedure TImmiScopeMulti.queryanalogConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
  {if datamod=nil then exit;
   if not datamod.trend.connected then
 begin
 expr_1:='';
 reistablish;
 MyLock:=false;
 end;     }
end;

procedure  TImmiScopeMulti.queryanalogExecuteComplete(Connection: TADOConnection;
  RecordsAffected: Integer; const Error: Error;
  var EventStatus: TEventStatus; const Command: _Command;
  const Recordset: _Recordset);
begin
 { if error=nil then
  begin
  exit;
  end;
   expr_1:='';
  reistablish;
  MyLock:=false; }
end;

function GetMidY(x1,y1,x2,y2,xx: double): double;
begin
result:=y1;
if x1=x2 then exit;
result:=(y2-y1)/(x2-x1)*(xx-x1)+y1;


end;

procedure Register;
begin
  RegisterComponents('IMMIGraph', [TImmiScopeMulti]);
end;



end.
 