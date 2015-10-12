unit ImmiScopeStatic;

interface

uses controls,  dxButton, oscillogramU,classes,PointerTegsU,fStartDateTimeGrU, ComCtrls, SelectFormVCLU,
TrackBarDouble, groupsU, ConfigurationSys, stdctrls,DB, Dialogs,globalvalue, StrUtils, messages, sysUtils,
DateUtils, constDef, Expr, Scope,windows,graphics, DataGraphcModul,
forms, {GlobalVar,}   DBManagerFactoryU,MainDataModuleU;

type parrboolean = ^boolean;


type
  TExprNameLabel = class(TLabel)

   public
    { Private declarations }
    SC: TComponent;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    

  end;

TTimeGrLabel = class(TLabel)
   private
    flabelFormat: string;
   public
    { Private declarations }
    SC: TComponent;
    function getlabelformat: string;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
     published
     property labelFormat: string read flabelFormat write flabelFormat;
  end;

type
  TCtrlGraphButton = class(TdxButton)
   public
    { Private declarations }
    GgrList: TList;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
  end;


type
  TCtrlGrArchButton = class(TCtrlGraphButton)
  public
    { Private declarations }

    procedure Click; override;
   end;

type
  TCtrlGrOschButton = class(TCtrlGraphButton)
  protected
    fNamePar: string;
  public
    { Private declarations }

    procedure Click; override;
  published
    property NamePar: string read fNamePar write fNamePar;
   end;

type
  TImmiGraphButton = class(TdxButton)
  public
    { Private declarations }
    GgrList: TList;
    procedure Click; override;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
  end;

type
  TImmiGraphTrBr = class(TTrackBarDouble)
  private
   fbuttonWidth: integer;
    fbuttonHeight: integer;
    flbdate: TTimeGrLabel;
    flbtime: TTimeGrLabel;
   procedure setint(li,ri: TDatetime);
   procedure setbuttonWidth(val : integer);
   procedure setbuttonHeight(val : integer);
  public
    { Private declarations }


    GgrList: TList;
    procedure SliderMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   procedure SliderMouseMove(Sender: TObject{; Shift: TShiftState; X, Y: Integer});
   // procedure Click; override;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    published
    property buttonWidth: integer read fbuttonWidth write setbuttonWidth;
    property buttonHeight: integer read fbuttonHeight write setbuttonHeight;
    property lbdate: TTimeGrLabel read flbdate write flbdate;
    property lbtime: TTimeGrLabel read flbtime write flbtime;

  end;

type
  TExprGraphButton = class(TdxButton)
  public
    { Private declarations }
    GgrList: TList;
    function getTrdef: TTrenddefList;
    procedure Click; override;
    procedure Loaded; override;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
  end;

type
  TImmiScopeStatic = class(TScope)
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
    fbbButtonExpr: TExprGraphButton;
    DataMod: TDataModule1;
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

    fMyLock: boolean;
    idExpr: integer;
    isArcNul: array [0..1] of boolean;
    delta: real;
    fFormat: string;
    res:  tTDPointData;
    fExprString: TExprStr ;
    fCap: string;
    fmaxValEu: real;
    fminValEu: real;
    ftimeLabel: boolean;
    flbExprName: TExprNameLabel;
    fAutoSizeEU: boolean;
    curEUMax: double;
    curEUMin: double;
    statEUMax: double;
    statEUMin: double;
    valLeft: double;
    valRight: double;
    fcheckauto: TCheckbox;

    procedure SetForm (str: string);
    procedure SetCaption (str: TCaption);
    procedure SetMylock(val: boolean);
    procedure SetDateTM;
    function getvaluebytm(tm: TDatetime): double;
    procedure FillAbsence(value: tTDPoint);
  protected
   procedure SetIn;
   procedure SetOut;
   procedure SetLeft100;
   procedure SetRight100;
   procedure SetLeft50;
   procedure SetRight50;
   procedure Setexpr(value: TExprStr);
   procedure setHorizTrBar(val: TImmiGraphTrBr);
   procedure setvertTrBar(val: TImmiGraphTrBr);
   procedure setbbLeft100(val: TImmiGraphButton);
   procedure setbbLeft50(val: TImmiGraphButton);
   procedure setbbRight50(val: TImmiGraphButton);
   procedure setbbRight100(val: TImmiGraphButton);
   procedure setbbToNow(val: TImmiGraphButton);
   procedure setbbIn(val: TImmiGraphButton);
   procedure setbbOut(val: TImmiGraphButton);
   procedure setbbButtonExpr(val: TExprGraphButton);
   procedure setbbSettimeArc(val: TCtrlGraphButton);
   procedure setlbExprName(val: TExprNameLabel);
   function  getTrdef: TTrenddefList;
    { Protected declarations }
   procedure QueryFetchComplete(data: tTDPointData;
   Error: integer);
  // procedure Query1FetchProgress(DataSet: TCustomADODataSet;
  //  Progress, MaxProgress: Integer; var EventStatus: TEventStatus);
    procedure setStartTm(val:TdateTime);
    procedure setTimePeriod(val:TTime);
    procedure SetTimeToNow;
    procedure SetInput;
    procedure SetInVert(newMin:  double; newMax:  double);
    procedure SetmaxValEu(val: real);
    procedure SetminValEu(val: real);
    procedure setlbMidle(val: TTimeGrLabel);
    procedure setlbStart(val: TTimeGrLabel);
    procedure setlbStop(val: TTimeGrLabel);
    procedure setlbDate(val: TTimeGrLabel);
    procedure setAutoSizeEU(val: boolean);
    function getTrdefInfoByName(nm: string): PTrenddefRec;
    function getTRDFComment(nm: string): string;
    function getTRDFMax(nm: string): double;
    function getTRDFMin(nm: string): double;
    function getTRDFId(nm: string): integer;
  public
    { Public declarations }
    LimitedTime: boolean;
    fLimitedStart: TDateTime;
    fLimitedPeriod: TDateTime;
    fInputStart: TDateTime;
    fInputPeriod: TDateTime;
    property  Trdef: TTrenddefList read getTrdef;
    property maxValEu: real read fmaxValEu write SetmaxValEu;
    property minValEu: real read fminValEu write SetminValEu;
    property MyLock: boolean read fMyLock write SetMyLock;
    procedure Loaded; override;
    procedure FillPerfect;
    procedure ExprNil;
    procedure removeCompFromScope(val: TComponent);
    constructor Create(AOwner: TComponent); override;
    procedure QueryExpr(timstart: TDateTime; timstop: TDateTime;  aTagid: integer; var val: tTDPointData);
    destructor Destroy; override;
    procedure ImmiQueryGraph;
    procedure SetCurUE;

    function SetNewRange(min, max: integer): boolean;
    function SetNewRangeW(setstart: TdateTime; setPeriod: TTime): boolean;
    procedure ButtonControlAction(val: TImmiGraphButton);
    procedure ButtonControlActionST(val:  TCtrlGraphButton);
    procedure SetByTrackBarH(min,max: integer);
    procedure SetByTrackBarV(min,max: integer);
    procedure SetHtr;
  published
    { Published declarations }
    property form: string read fFormat write SetForm;
    property Expr: TExprStr  read fExprString write setExpr;
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
    property bbButtonExpr: TExprGraphButton read fbbButtonExpr write setbbButtonExpr;
    property bbSettimeArc: TCtrlGraphButton read fbbSettimeArc write setbbSettimeArc;
    property lbExprName: TExprNameLabel read flbExprName write setlbExprName;
    property lbMidle: TTimeGrLabel read flbMidle write setlbMidle;
    property lbStart: TTimeGrLabel read flbStart write setlbStart;
    property lbStop: TTimeGrLabel read flbStop write setlbStop;
    property lbDate: TTimeGrLabel read flbDate write setlbDate;
    property timeLabel: boolean read ftimeLabel write ftimeLabel;
    property OschNumb: integer read fOschNumb write fOschNumb;
    property AutoSizeEU: boolean read fAutoSizeEU write setAutoSizeEU;
    property  checkauto: TCheckbox read fcheckauto write fcheckauto;
  end;



procedure Register;
function GetMidY(x1,y1,x2,y2,xx: double): double;

var
  TRENDLIST_GLOBAL_ISC: TTrenddefList;

implementation

Uses IMMIAnalogPropU;



procedure TImmiGraphButton.Click;
 var i: integer;
begin

 for i:=0 to GgrList.count-1 do
   if (GgrList.Items[i]<>nil) and  (TObject(GgrList.Items[i]) is TImmiScopeStatic) then
     begin
 //    TImmiScopeStatic(GgrList.Items[i]).AutoSizeEU:=true;
     TImmiScopeStatic(GgrList.Items[i]).ButtonControlAction(self);
     end;
 for i:=0 to GgrList.count-1 do
   if (GgrList.Items[i]<>nil) and  (TObject(GgrList.Items[i]) is TImmiScopeStatic) then
     TImmiScopeStatic(GgrList.Items[i]).SetHtr;
     inherited;
end;

constructor TImmiGraphButton.Create(Aowner: TComponent);
begin
inherited;
GgrList:=TList.Create;

end;

destructor TImmiGraphButton.Destroy;
var i: integer;
begin
 {for i:=0 to GgrList.count-1 do
   if (GgrList.Items[0]<>nil) and
     (TObject(GgrList.Items[0]) is TImmiScopeStatic) then
     TImmiScopeStatic(GgrList.Items[0]).removeCompFromScope(self);  }
GgrList.free;
inherited;
end;



constructor TExprNameLabel.Create(Aowner: TComponent);
begin
inherited;


end;

destructor TExprNameLabel.Destroy;
begin
//if (SC<>nil) and (TObject(SC) is TImmiScopeStatic) then  TImmiScopeStatic(SC).removeCompFromScope(self);
inherited;
end;



procedure TExprNameLabel.Loaded;
begin
 inherited;
 caption:='Пусто';

end;

constructor TTimeGrLabel.Create(Aowner: TComponent);
begin
inherited;
end;

destructor TTimeGrLabel.Destroy;
begin
//if (SC<>nil) and (TObject(SC) is TImmiScopeStatic) then  TImmiScopeStatic(SC).removeCompFromScope(self);
inherited;
end;

function TTimeGrLabel.getlabelformat: string;
begin
   result:='%3.3f';
 //  if  flabelformat<>nil then
   if trim(flabelformat)<>'' then result:=flabelformat;
end;

procedure TTimeGrLabel.Loaded;
begin
 inherited;
 caption:='0';
 //alignment:=taLeft;
 autosize:=true;
 WordWrap:=false;
end;

procedure TImmiGraphTrBr.SliderMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      var i: integer;
       posPoint: tpoint;
       pos: Integer;
begin
 // application.MessageBox(pansichar(''),pansichar(''),0);
      if orientation = trhorizontal then  exit;
   ActiveSlider:= nil;
   for i:=0 to GgrList.count-1 do
   if (GgrList.Items[i]<>nil) and  (TObject(GgrList.Items[i]) is TImmiScopeStatic) then
     begin
     if self.Position1=self.Position then
        begin
          if self.Position1<>0 then
          self.Position1:=self.Position1-1;
        end;
     if self.Position1=self.Position then
        begin
          if self.Position<>100 then
          self.Position:=self.Position+1;
        end;
     if orientation = trVertical then
     begin
     TImmiScopeStatic(GgrList.Items[i]).SetByTrackBarV(self.Position1,self.Position);
     if TImmiScopeStatic(GgrList.Items[i]).checkauto<>nil then TImmiScopeStatic(GgrList.Items[i]).checkauto.Checked:=TImmiScopeStatic(GgrList.Items[i]).AutoSizeEU;
     end;
      {else
     TImmiScopeStatic(GgrList.Items[i]).SetByTrackBarH(self.Position1,self.Position)};
     end;
end;

procedure TImmiGraphTrBr.SliderMouseMove(Sender: TObject{; Shift: TShiftState; X, Y: Integer});
      var i: integer;
       posPoint: tpoint;
       pos: Integer;
       stateS: boolean;
begin
 // application.MessageBox(pansichar(''),pansichar(''),0);
   stateS:=false;
   //ActiveSlider:= nil;
   for i:=0 to GgrList.count-1 do
   if (GgrList.Items[i]<>nil) and  (TObject(GgrList.Items[i]) is TImmiScopeStatic) then
     begin
     if not states then
       begin
          setint(TImmiScopeStatic(GgrList.Items[i]).Indicator.lineL,TImmiScopeStatic(GgrList.Items[i]).Indicator.lineR);
       end;
   {  if self.Position1=self.Position then
        begin
          if self.Position1<>0 then
          self.Position1:=self.Position1-1;
        end;
     if self.Position1=self.Position then
        begin
          if self.Position<>100 then
          self.Position:=self.Position+1;
        end;     }
     if orientation = trhorizontal then
    TImmiScopeStatic(GgrList.Items[i]).SetByTrackBarh(self.Position1,self.Position){ else
   //  TImmiScopeStatic(GgrList.Items[i]).SetByTrackBarH(self.Position1,self.Position)};
     end;
end;




procedure TImmiGraphTrBr.setint(li,ri: TDatetime);
begin
 if self.flbdate<>nil then
           begin
             self.flbdate.Caption:=timetostr(ri)+ ' '+datetostr(ri);
             if dayofthemonth(li)<>dayofthemonth(ri) then
              self.flbdate.Caption:=timetostr(li)+ ' '+datetostr(li)+' - '+self.flbdate.Caption else
               self.flbdate.Caption:=timetostr(li)+' - '+self.flbdate.Caption
           end;
   if self.flbtime<>nil then
           begin
             self.flbtime.Caption:=timetostr(ri-li);
           end;
end;

constructor TImmiGraphTrBr.Create(Aowner: TComponent);
begin
inherited;
GgrList:=TList.Create;
fbuttonWidth:=8;
fbuttonHeight:=25;
fSlider.OnMouseUp := SliderMouseUp;
fSlider1.OnMouseUp := SliderMouseUp;
self.OnChange := SliderMouseMove;
end;

destructor TImmiGraphTrBr.Destroy;
var i: integer;
begin
{ for i:=0 to GgrList.count-1 do
   if (GgrList.Items[0]<>nil) and
     (TObject(GgrList.Items[0]) is TImmiScopeStatic) then
     TImmiScopeStatic(GgrList.Items[0]).removeCompFromScope(self);  }
GgrList.free;
inherited;
end;

procedure TImmiGraphTrBr.setbuttonWidth(val : integer);
begin
  if (val<>fbuttonWidth) and (val>0) and (val<40) then
  begin
   if fSlider<>nil then fSlider.width:=val;
   if fSlider1<>nil then fSlider1.width:=val;
   fbuttonWidth:=val;
  end;
end;

procedure TImmiGraphTrBr.setbuttonHeight(val : integer);
begin
  if (val<>fbuttonHeight) and (val>0) and (val<40) then
  begin
   if fSlider<>nil then fSlider.Height:=val;
   if fSlider1<>nil then fSlider1.Height:=val;
   fbuttonHeight:=val;
  end;
end;

procedure TExprGraphButton.Click;
 var i: integer;
     strV: string;
     tmp_trdf: TTrenddefList;
begin
 tmp_trdf:=getTrdef;
 if  tmp_trdf=nil then exit;
 strV:='';
 if SelectFormVCL=nil then  SelectFormVCL:=TSelectFormVCL.create(application, tmp_trdf);

 SelectFormVCL.SelectTextFieldEx(strV);
 if strv<>'' then
 begin
  self.caption:=strv;
  if strv='Пусто' then strv:='';
  for i:=0 to GgrList.count-1 do
   if (GgrList.Items[i]<>nil) and  (TObject(GgrList.Items[i]) is TImmiScopeStatic) then
     TImmiScopeStatic(GgrList.Items[i]).Expr:=strv;
 end;
 inherited;
end;



constructor TExprGraphButton.Create(Aowner: TComponent);
begin
inherited;
GgrList:=TList.Create;
end;

procedure TExprGraphButton.Loaded;
begin
 inherited;
 caption:='Пусто';

end;

destructor TExprGraphButton.Destroy;
var i: integer;
begin
GgrList.free;
inherited;
end;

function TExprGraphButton.getTrdef: TTrenddefList;
var fDM: TMainDataModule;
begin
try
fDM:=nil;
if TRENDLIST_GLOBAL_ISC=nil then
   begin
     try
     fDM:=TDBManagerFactory.buildManager(dbmanager,connectionstr, dbaReadOnly);
      if fDM<>nil then
      begin
         try
         fDM.Connect;
         try
         TRENDLIST_GLOBAL_ISC:=fDM.regTrdef();
         if TRENDLIST_GLOBAL_ISC.Count=0 then raise Exception.Create('Trenddef пуст или не существует');
         except
           if TRENDLIST_GLOBAL_ISC<>nil then
           freeAndNil(TRENDLIST_GLOBAL_ISC);
           NSDBErrorMessage(NSDB_TRENDDEF_ERR);
          
         end
         except
           TRENDLIST_GLOBAL_ISC:=nil;
           NSDBErrorMessage(NSDB_CONNECT_ERR);
         end;
      end else NSDBErrorMessage(NSDB_CONNECT_ERR);
     finally
       if fDM<>nil then
         try
          fdM.Free;
         except
         end;
     end;
    // result:=TRENDLIST_GLOBAL_ISC;
   end;

except
TRENDLIST_GLOBAL_ISC:=nil;
end;
result:=TRENDLIST_GLOBAL_ISC;
end;


procedure  TCtrlGrArchButton.Click;
 var i: integer;
     strV: string;
     ISS: TImmiScopeStatic;
     temp, hour, min, sec: word;
begin

 strV:='';
 if fDateTimeGr=nil then  fDateTimeGr:=TfDateTimeGr.create(application);
 if (GgrList.Items[0]<>nil) and  (TObject(GgrList.Items[0]) is TImmiScopeStatic) then
      ISS:=TImmiScopeStatic(GgrList.Items[0]);
 if ISS=nil then exit;
 with fDateTimeGr do
  begin
    //spinedit4.Value := trunc(ISS.ftimeperiod);
    decodeDateTime(ISS.timeperiod, temp, temp, temp, hour, min, sec, temp);
    spinedit3.Value := hour;
    spinedit2.Value := min;
    spinedit1.Value := sec;
    dtpDateStart.Date := ISS.starttm;
    dtpTimeStart.Time := ISS.starttm;

    if ShowModal = mrOK then
      with fDateTimeGr do
        for i:=0 to GgrList.count-1 do
          if (GgrList.Items[i]<>nil) and  (TObject(GgrList.Items[i]) is TImmiScopeStatic) then
            begin
              TImmiScopeStatic(GgrList.Items[i]).fInputPeriod:=
                                spinedit3.Value / 24 +
                                        spinedit2.Value / 1440 +
                                                spinedit1.Value / 86400;

              TImmiScopeStatic(GgrList.Items[i]).FInputstart:=trunc(dtpDateStart.Date) + dtpTimeStart.Time;
              TImmiScopeStatic(GgrList.Items[i]).ButtonControlActionST(self);
            end;
 end;
 inherited;
end;

procedure  TCtrlGrOschButton.Click;
 var i,j: integer;
     strV: string;
     ISS: TImmiScopeStatic;
     temp, hour, min, sec: word;
    // tagGs: TOschTegGrope;
     SelectOsc: TFormSelectOsc;
     ids: integer;
     startsss: TDateTime;
     periodSSS: TTime;
begin
inherited;
     { try
        SelectOsc:=TFormSelectOsc.create(self);
       if SelectOsc.Shows(fNamePar) then
         begin
         if  SelectOsc.isCansel then exit;
         startsss:=SelectOsc.TimeSt;
         periodSSS:=incMilliSecond(0,SelectOsc.MilliSec);
         if rtitems.getsimpleid(trim(SelectOsc.iName))<0 then
         begin
            for j:=0 to  GgrList.Count-1 do
                     TImmiScopeStatic(GgrList.Items[j]).expr:='';
          exit;
         end;
         rtitems.getOschTeg(rtitems.getsimpleid(trim(SelectOsc.iName)),tagGs);
          for i:=0 to tagGs.n-1 do
            for j:=0 to  GgrList.Count-1 do
             if TImmiScopeStatic(GgrList.Items[j]).OschNumb=i then
               begin


               TImmiScopeStatic(GgrList.Items[j]).LimitedTime:=true;
               TImmiScopeStatic(GgrList.Items[j]).fLimitedStart:=startsss;

               TImmiScopeStatic(GgrList.Items[j]).fLimitedPeriod:=periodSSS;

               TImmiScopeStatic(GgrList.Items[j]).TimePeriod:=periodSSS;
               TImmiScopeStatic(GgrList.Items[j]).Starttm:=startsss;
               TImmiScopeStatic(GgrList.Items[j]).Expr:=rtitems.GetName(tagGs.num[i]);

              end;
          end else
            begin
             if  SelectOsc.isCansel then exit;
             if trim(SelectOsc.Label4.Caption)='Пусто' then
                for j:=0 to  GgrList.Count-1 do
                     TImmiScopeStatic(GgrList.Items[j]).expr:='';
            end;
       finally
         SelectOsc.Free;
       end;  }

 end;





constructor TCtrlGraphButton.Create(Aowner: TComponent);
begin
inherited;
GgrList:=TList.Create;
end;

destructor TCtrlGraphButton.Destroy;
var i: integer;
begin
 {for i:=0 to GgrList.count-1 do
   if (GgrList.Items[0]<>nil) and
     (TObject(GgrList.Items[0]) is TImmiScopeStatic) then
     TImmiScopeStatic(GgrList.Items[0]).removeCompFromScope(self);}
GgrList.free;
inherited;
end;

constructor TImmiScopeStatic.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    idexpr:=-1;

    Furrsttime:=false;
    fMyLock:=false;
    setlength(indicator.resabs.point,0);
    indicator.resabs.n:=0;
    setlength(res.point,0);
    res.npoint:=0;
    setlength(res.time,0);
    res.ntime:=0;
    fQueryStartTm:=0;
    fQueryTimePeriod:=0;
    indicator.FDST:=true;
    indicator.Slide:=true;
    fOschNumb:=-1;
    //LimitedTime:=true;
    //self.fLimitedStart:=inchour(now,-1);
    ///self.fLimitedPeriod:=1/24;
end;



procedure TImmiScopeStatic.removeCompFromScope(val: TComponent);
begin
  if val=nil then exit;
  if fHorizTrBar=val then HorizTrBar:=nil;
  if val=fvertTrBar then vertTrBar:=nil;
  if val=fbbSettimeArc then bbSettimeArc:=nil;
  if val=fbbIn then bbIn:=nil;
  if val=fbbOut then bbOut:=nil;
  if val=fbbLeft100 then bbLeft100:=nil;
  if val=fbbRight100 then bbRight100:=nil;
  if val=fbbLeft50 then bbLeft50:=nil;
  if val=fbbRight50 then bbRight50:=nil;
  if val=fbbToNow then bbToNow:=nil;
  if val=fbbButtonExpr then bbButtonExpr:=nil;
  if val=flbMidle then lbMidle:=nil;
  if val=flbStart then lbStart:=nil;
  if val=flbStop then lbStop:=nil;
  if val=flbDate then lbDate:=nil;
end;


procedure TImmiScopeStatic.SetmaxValEu(val: real);

begin
  if idExpr<0 then exit;
  if val<>fmaxValEu then
   begin
     SELF.fAutoSizeEU:=FALSE;
     fmaxValEu:=val;
    // application.MessageBox(pansichar(floattostr(fminValEu)+'hhh'+floattostr(fmaxValEu)),pansichar(floattostr(fminvaleu)+'hhh'+floattostr(k)),0);
     SetInvert(fminValEu,fmaxValEu);

   end;
end;

procedure TImmiScopeStatic.SetminValEu(val: real);

begin
 if idExpr<0 then exit;
 if val<>fminValEu then
   begin
     SELF.fAutoSizeEU:=FALSE;
     fminValEu:=val;
    //  application.MessageBox(pansichar(floattostr(fminValEu)+'hhh'+floattostr(fmaxValEu)),pansichar(floattostr(k)+'hhh'+floattostr(fmaxValEu)),0);
     SetInvert(fminValEu,fmaxValEu);

   end;
end;

function TImmiScopeStatic.SetNewRange(min, max: integer): boolean;
var i: integer;
 //   min,max: integer;
begin
result:=true;
     begin
       result:=false;
       fstartTm:=fQuerystartTm+fQueryTimePeriod*min/100;
       ftimePeriod:=fQueryTimePeriod*(max-min)/100;
       indicator.FFirstPoint[0]:=true;
      if Indicator.WorldRight<>fstartTm then
       begin
       Indicator.WorldLeft:= fstartTm;
       Indicator.WorldRight:= fstartTm+ftimePeriod;
       end else
       begin
       Indicator.WorldRight:= fstartTm+ftimePeriod;
       Indicator.WorldLeft:= fstartTm;
       end;
       FillPerfect;
     end;

end;

function TImmiScopeStatic.SetNewRangeW(setstart: TdateTime; setPeriod: TTime): boolean;
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
       indicator.FFirstPoint[0]:=true;
       if Indicator.WorldRight<>setstart then
       begin
       Indicator.WorldLeft:= setstart;
       Indicator.WorldRight:= setstart+setPeriod;
       end else
       begin
       Indicator.WorldRight:= setstart+setPeriod;
       Indicator.WorldLeft:= setstart;
       end;
      { if  fHorizTrBar<>nil then
         begin
          fHorizTrBar.Position1:=round(min);
          fHorizTrBar.Position:=round(max);
         end;  }


        self.FillPerfect;

      // fstartTm:=setStart;
     // fTimePeriod:=SetPeriod;
     // application.MessageBox(pansichar(floattostr(Indicator.WorldLeft)+'iiii'+floattostr(Indicator.WorldRight)),pansichar(''),0);
     end;

end;

procedure TImmiScopeStatic.SetIn;
var ltp,tp,stt: TDateTime;
begin
 {  if (self.Indicator.lineL=self.StartTm) and (self.Indicator.lineR=(self.StartTm+self.TimePeriod))  then
   begin
   timeperiod:=0.5*ftimeperiod;
   starttm:=starttm+0.5*ftimePeriod;
   end else }
   begin
      tp:=timeperiod*(self.HorizTrBar.Position-self.HorizTrBar.Position1)/100;
      stt:=self.StartTm+timeperiod*self.HorizTrBar.Position1/100;
     timeperiod:=tp;
     SetNewRangeW(StartTm,tp);
     if self.StartTm=stt then
     begin
     stt:=incmillisecond(stt,1);
     end;
      self.StartTm:=stt;
   end;
end;

procedure TImmiScopeStatic.SetHtr;
var ltp,tp,stt: TDateTime;
begin

   if self.HorizTrBar<>nil then
     begin
        self.HorizTrBar.Position:=100;
          self.HorizTrBar.Position1:=0;
     end;
end;

procedure TImmiScopeStatic.SetInput;
var ltp: TDateTime;
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
   indicator.StartTime:=fStartTm;
   indicator.TimePer:=fTimePeriod;
   ImmiQueryGraph;
   SetDateTM;
   end;
end;

procedure TImmiScopeStatic.SetLeft100;
begin
  
   starttm:=starttm-1*ftimePeriod;
    if self.HorizTrBar<>nil then
     begin
        self.HorizTrBar.Position:=100;
          self.HorizTrBar.Position1:=0;
     end;
end;

procedure TImmiScopeStatic.SetTimeToNow;
begin
  // ftimeperiod:=0.5*ftimeperiod;
   starttm:=now-1*ftimePeriod;
   if self.HorizTrBar<>nil then
     begin
        self.HorizTrBar.Position:=100;
          self.HorizTrBar.Position1:=0;
     end;
end;

procedure TImmiScopeStatic.SetLeft50;
begin
  // ftimeperiod:=0.5*ftimeperiod;
   starttm:=starttm-0.5*ftimePeriod;
   if self.HorizTrBar<>nil then
     begin
        self.HorizTrBar.Position:=100;
          self.HorizTrBar.Position1:=0;
     end;
end;

procedure TImmiScopeStatic.SetRight100;
begin
  // ftimeperiod:=0.5*ftimeperiod;
   starttm:=starttm+1*ftimePeriod;
    if self.HorizTrBar<>nil then
     begin
        self.HorizTrBar.Position:=100;
          self.HorizTrBar.Position1:=0;
     end;
end;

procedure TImmiScopeStatic.SetRight50;
begin
  // ftimeperiod:=0.5*ftimeperiod;
   starttm:=starttm+0.5*ftimePeriod;
    if self.HorizTrBar<>nil then
     begin
        self.HorizTrBar.Position:=100;
          self.HorizTrBar.Position1:=0;
     end;
end;


procedure TImmiScopeStatic.SetOut;
begin
   if timeperiod>0.999999 then exit;
   timeperiod:=2*timeperiod;
   starttm:=starttm-0.25*ftimePeriod;
     if self.HorizTrBar<>nil then
     begin
        self.HorizTrBar.Position:=100;
          self.HorizTrBar.Position1:=0;
     end;
end;



procedure TImmiScopeStatic.setStartTm(val:TdateTime);
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

      indicator.lineL:= val;
     indicator.lineR:= val+fTimePeriod;
  if (ftimeperiod+val)>now then val:=now-ftimeperiod;
  if (fStartTm<>val) or (LimitedTime) then
   begin
     fStartTm:=val;
       indicator.StartTime:=fStartTm;
     indicator.TimePer:=fTimePeriod;
        indicator.initline:=false;
      indicator.lineL:= val;
      indicator.lineR:= val+fTimePeriod;
     if SetNewRangeW(fStartTm,ftimeperiod) then
     ImmiQueryGraph;

     SetDateTM;

    if idexpr<0 then
       begin
         Draw;
         ExprNil;
         //indicator.draw;
       end;
   end;
end;

function TImmiScopeStatic.getvaluebytm(tm: TDatetime): double;
var m1,m2,mm: integer;
begin
result:=0;
if res.npoint<1 then exit;
if tm<=self.fStartTm then
  result:= res.point[0][1];
if tm>=self.fStartTm+self.fTimePeriod then
  result:= res.point[indicator.resabs.n-1][1];
  m1:=0;
  m2:= res.npoint-1;
  mm:=m2;
while abs(m2-m1)>1 do
  begin
   mm:=trunc((m2+m1)/2);
   if tm<= res.point[mm][2] then
     m2:=mm else
      m1:=mm;
  end;
  if ((tm<res.point[mm][2]) or (mm=(res.npoint-1))) then
      result:= res.point[mm][1]
  else
      result:= res.point[mm+1][1];
end;

procedure TImmiScopeStatic.setbbSettimeArc(val: TCtrlGraphButton);
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

procedure TImmiScopeStatic.setbbLeft100(val: TImmiGraphButton);
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

procedure TImmiScopeStatic.setbbLeft50(val: TImmiGraphButton);
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

procedure TImmiScopeStatic.setbbRight50(val: TImmiGraphButton);
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

procedure TImmiScopeStatic.setbbRight100(val: TImmiGraphButton);
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


procedure TImmiScopeStatic.setAutoSizeEU(val: boolean);
begin
  if val<>fAutoSizeEU then
    begin
      fAutoSizeEU:=val;
      if not val then
        begin
           CUREumAX:= getTRDFMax(fexprstring);//rtitems.items[idExpr].MaxEu;
           cureumin:= getTRDFMin(fexprstring);//rtitems.items[idExpr].MinEu;
        end;
      self.FillPerfect;
       if (self.vertTrBar<>nil) and (self.idExpr>-1) then
         begin
          vertTrBar.Position1:=0;
          vertTrBar.Position:=100;
          if fautosizeeu then begin
          vertTrBar.Position:=100-round((self.curEUMin-getTRDFMin(fexprstring))*100/
          (getTRDFMax(fexprstring)-getTRDFMin(fexprstring)));
          vertTrBar.Position1:=100-round((self.curEUMax-getTRDFMin(fexprstring))*100/
          (getTRDFMax(fexprstring)-getTRDFMin(fexprstring)));
          end;
   end;
    end;
    if fcheckauto<>nil then fcheckauto.Checked:=fAutoSizeEU;
end;

procedure TImmiScopeStatic.setbbToNow(val: TImmiGraphButton);
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

procedure TImmiScopeStatic.setlbExprName(val: TExprNameLabel);
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

procedure TImmiScopeStatic.setlbMidle(val: TTimeGrLabel);
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

procedure TImmiScopeStatic.setlbStart(val: TTimeGrLabel);
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

procedure TImmiScopeStatic.setlbDate(val: TTimeGrLabel);
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

procedure TImmiScopeStatic.setlbStop(val: TTimeGrLabel);
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

procedure TImmiScopeStatic.setbbIn(val: TImmiGraphButton);
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

procedure TImmiScopeStatic.setbbOut(val: TImmiGraphButton);
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

procedure TImmiScopeStatic.setbbButtonExpr(val: TExprGraphButton);
begin
if val<>fbbButtonExpr then
 begin
   if fbbButtonExpr<>nil then
       fbbButtonExpr.GgrList.Remove(self);
   if val<>nil then
       val.GgrList.Add(self);
    if val<>nil then
    begin
    val.tag:=0;
     
     end;
   fbbButtonExpr:=val;
   if Val <> nil then Val.FreeNotification(Self);
 end;
end;

procedure TImmiScopeStatic.setHorizTrBar(val: TImmiGraphTrBr);
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

procedure TImmiScopeStatic.setvertTrBar(val: TImmiGraphTrBr);
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

procedure TImmiScopeStatic.ButtonControlActionST(val:  TCtrlGraphButton);
begin
 if val=nil then exit;
if val=fbbSettimeArc then
 begin
       if self.HorizTrBar<>nil then

   //application.MessageBox(pansichar(Datetimetostr(starttm)),pansichar(Datetimetostr(starttm+timeperiod)),0);
   SetInPUt;
     self.HorizTrBar.setint(fStartTm,fStartTm+ftimeperiod);
   exit;
 end;
end;

procedure TImmiScopeStatic.ButtonControlAction(val: TImmiGraphButton);
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

procedure TImmiScopeStatic.setTimePeriod(val:TTime);
begin
   if  self.LimitedTime then
    begin
       if ftimeperiod>self.fLimitedPeriod then val:=self.fLimitedPeriod;
    end;
   if val>0.9999999 then val:=0.9999999;
   if val<=incMillisecond(0,5) then exit;
     indicator.TimePer:=fTimePeriod;
    if (fTimePeriod<>val) and (val<>0) then
   begin
     fTimePeriod:=val;
   //  if trim(fExprstring)<>'' then ImmiQueryGraph;
   end;
end;

procedure TImmiScopeStatic.Loaded;
 var Msg: TMessage;
begin
 inherited;
//expr:='k34_4d44_I1';
// if nodb then self.ImmiInit(Msg);
  if fTimePeriod<=0 then fTimePeriod:=1/24;
  fStartTm:=now-fTimePeriod;
//  fTimePeriod:=fTimePeriod;
  Indicator.WorldTop:= 0;
  Indicator.WorldBottom:= 100;
   if Indicator.WorldRight<>fstartTm then
       begin
       Indicator.WorldLeft:= fstartTm;
       Indicator.WorldRight:= fstartTm+ftimePeriod;
       end else
       begin
       Indicator.WorldRight:= fstartTm+ftimePeriod;
       Indicator.WorldLeft:= fstartTm;
       end;
  indicator.horlable:=self.ftimeLabel;
  expr:='';
  //indicator.MARGIN_TOP:=indicator.MARGIN_TOP-1;
end;

procedure TImmiScopeStatic.SetForm (str: string);
begin
  fformat := str;
  caption := str;
end;

procedure TImmiScopeStatic.SetCaption (str: TCaption);
begin
  fCap := string(str);
  inherited caption := str;
end;

procedure TImmiScopeStatic.SetMylock(val: boolean);
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
      if fbbButtonExpr<>nil then fbbButtonExpr.Enabled:=false;
      if (fhorizTrbar<>nil) then  fhorizTrbar.Enabled:=false;
      if (fbbSetTimeArc<>nil) then  fbbSetTimeArc.Enabled:=false;
      if fbbIn<>nil then fbbIn.tag:=fbbIn.tag+1;
      if fbbOUT<>nil then fbbOut.tag:=fbbOut.tag+1;
      if fbbLeft100<>nil then fbbLeft100.tag:=fbbLeft100.tag+1;
      if fbbLeft50<>nil then fbbLeft50.tag:=fbbLeft50.tag+1;
      if fbbRight100<>nil then fbbRight100.tag:=fbbRight100.tag+1;
      if fbbRight50<>nil then fbbRight50.tag:=fbbRight50.Tag+1;
      if fbbToNow<>nil then fbbToNow.tag:=fbbToNow.tag+1;
      if fbbButtonExpr<>nil then fbbButtonExpr.tag:=fbbButtonExpr.tag+1;
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
      if fbbButtonExpr<>nil then fbbButtonExpr.tag:=fbbButtonExpr.tag-1;
      if (fbbSetTimeArc<>nil) then fbbSetTimeArc.tag:=fbbSetTimeArc.tag-1;
      if (fbbIn<>nil) and (fbbIn.Tag<1) then fbbIn.Enabled:=true;
      if (fbbOUT<>nil) and (fbbOUT.Tag<1) then fbbOut.Enabled:=true;
      if (fbbLeft100<>nil) and (fbbLeft100.Tag<1) then fbbLeft100.Enabled:=true;
      if (fbbLeft50<>nil) and (fbbLeft50.Tag<1) then fbbLeft50.Enabled:=true;
      if (fbbRight100<>nil) and (fbbRight100.Tag<1) then fbbRight100.Enabled:=true;
      if (fbbRight50<>nil) and (fbbRight50.Tag<1) then fbbRight50.Enabled:=true;
      if (fbbToNow<>nil) and (fbbToNow.Tag<1) then fbbToNow.Enabled:=true;
      if (fbbButtonExpr<>nil) and (fbbButtonExpr.Tag<1) then fbbButtonExpr.Enabled:=true;
       if (fbbSetTimeArc<>nil) and (fbbSetTimeArc.Tag<1) then fbbSetTimeArc.Enabled:=true;
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
   if not fMylock then self.Repaint;
 end;

end;

procedure TImmiScopeStatic.SetInVert(newMin:  double; newMax:  double);
var i: integer;
    delts: double;

begin

     if Indicator.WorldBottom<>newmax then
     begin
     SELF.curEUMax:= newmax;
     SELF.curEUMIN:= newmin;
     end else
     begin
      SELF.curEUMIN:= newmin;
      SELF.curEUMAX:= newmax;
     end;
    self.FillPerfect;
   {   if (self.vertTrBar<>nil) then
   begin
   vertTrBar.Position:=100;
   vertTrBar.Position1:=0;
   vertTrBar.Position:=round((self.curEUMax-self.minvaleu)*100/(self.maxValEu-self.minValEu));
   vertTrBar.Position1:=round((self.curEUMin-self.minValEu)*100/(self.maxValEu-self.minValEu));

   end;      }
end;

destructor TImmiScopeStatic.Destroy;
begin
    try
       setlength(indicator.resabs.point,0);
       indicator.resabs.n:=0;
        setlength(res.point,0);
        res.npoint:=0;
    except
    end;
    try
    // queryforanalog.Active:=false;
    //queryforanalog.free;
   //  queryforanalogabs.Active:=false;
    //queryforanalog1.free;
   // queryforanalogabs.free;
    Furrsttime:=false;
  //  DataMod.Free;
    except
    end;
    inherited;
end;


procedure TImmiScopeStatic.ImmiQueryGraph;
var
   val,val1: real;
   str: string;
   newCap: string;
   last,last1: double;
   datpoint: TDPoint;
   datpoint1: TDPoint;
   isf: boolean;
   strfind,i: integer;
   lbval: tTDPointData;
begin
         if idexpr<0 then exit;
          setlength(res.point,0);
          res.npoint:=0;
         fminValEu:=getTRDFMin(fexprstring);
         fmaxValEu:=getTRDFMax(fexprstring);
         if (fvertTrbar<>nil) and (idexpr>-1) then
         begin
          fminValEu:=getTRDFMin(fexprstring)+(100-fvertTrbar.position)/
          100*abs(getTRDFMax(fexprstring)-getTRDFMin(fexprstring));
          fmaxValEu:=getTRDFMin(fexprstring)+(100-fvertTrbar.position1)/
          100*abs(getTRDFMax(fexprstring)-getTRDFMin(fexprstring));
         end;
         if Indicator.WorldBottom<>fmaxValEu then
         begin
         Indicator.WorldTop:= fmaxValEu;
         Indicator.WorldBottom:= fminValEu;
         end else
         begin
         Indicator.WorldBottom:= fminValEu;
         Indicator.WorldTop:= fmaxValEu;

         end;
        // application.MessageBox(pansichar(floattostr(fminValEu)+'  oooo'+floattostr(fmaxValEu)),pansichar(''),0);
        if Indicator.WorldRight<>fstartTm then
       begin
       Indicator.WorldLeft:= fstartTm;
       Indicator.WorldRight:= fstartTm+ftimePeriod;
       end else
       begin
       Indicator.WorldRight:= fstartTm+ftimePeriod;
       Indicator.WorldLeft:= fstartTm;
       end;
       //  idExpr:=rtitems.getsimpleId(fExprString);

        // idExpr1:=rtitems.getsimpleId(fExprString1);
         if (idexpr>-1)  then
           begin
           setlength(indicator.resabs.point,0);
           indicator.resabs.n:=0;
           MyLock:=true;
           QueryExpr(fstartTm,fstartTm+ftimePeriod,idexpr,lbval);
           end
         else
           try
            // MyLock:=true;
            // QueryExpr;
           except
           end;
end;

procedure TImmiScopeStatic.QueryExpr(timstart: TDateTime; timstop: TDateTime;  aTagid: integer; var val: tTDPointData);
 var TTread_T: TTrendThread;
begin
  try
   try
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,fexprstring,timstart, timstop,
   QueryFetchComplete,self.getTrdef);
   except
   end;
  finally

  end;

end;


procedure TImmiScopeStatic.SetByTrackBarH(min,max: integer);
begin

   begin
   indicator.lineL:=self.StartTm+min*self.TimePeriod/100;
    indicator.lineR:=self.StartTm+max*self.TimePeriod/100;
    if (self.flbMidle<>nil) then  flbMidle.Caption:=format(flbStop.getlabelformat,[getvaluebytm(indicator.lineR)]);
   indicator.Drawlines;
   refresh;
   end;
end;

procedure TImmiScopeStatic.SetByTrackBarV(min,max: integer);
begin
 if idExpr<0 then exit;
  //application.MessageBox(pansichar(floattostr(min)),pansichar(floattostr(max)),0);
  minValEu:=getTRDFMin(fexprstring)+(100-max)/100*abs(getTRDFMax(fexprstring)-getTRDFMin(fexprstring));
  maxValEu:=getTRDFMin(fexprstring)+(100-min)/100*abs(getTRDFMax(fexprstring)-getTRDFMin(fexprstring));
    //application.MessageBox(pansichar(floattostr(minValEu)),pansichar(floattostr(maxValEu)),0);
  end;

procedure TImmiScopeStatic.Setexpr(value: TExprStr);
var ms: TMessage;
begin
   if self.HorizTrBar<>nil then
  self.HorizTrBar.setint(fStartTm,fStartTm+ftimeperiod);
  if self.LimitedTime then
   begin
     fStartTm:=self.fLimitedStart;
     fTimePeriod:=self.fLimitedPeriod;
   end;
  indicator.StartTime:=fStartTm;
  indicator.TimePer:=fTimePeriod;
   if Indicator.WorldRight<>fstartTm then
       begin
       Indicator.WorldLeft:= fstartTm;
       Indicator.WorldRight:= fstartTm+ftimePeriod;
       end else
       begin
       Indicator.WorldRight:= fstartTm+ftimePeriod;
       Indicator.WorldLeft:= fstartTm;
       end;
  if fExprstring<>value then
   begin
   fExprstring:=value;
   idExpr:=getTRDFId(fexprstring);
   if idexpr<-1 then
     begin
        setlength(indicator.resabs.point,0);
        indicator.resabs.n:=0;
        setlength(res.point,0);
        res.npoint:=0;
     end;
   if flbexprname<>nil then
   begin
   if idexpr>-1 then
   flbexprname.Caption:=getTRDFComment(fexprstring) else
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
   if idexpr>-1 then
   begin
      if (fvertTrbar<>nil) then
         begin
             fVertTrbar.max:=100{round(rtitems.items[idexpr].MaxEU)};
             fVertTrbar.min:=0{round(rtitems.items[idexpr].MinEU)};
             fVertTrbar.position1:=0{round(rtitems.items[idexpr].MinEU)};
             fVertTrbar.position:=100{round(rtitems.items[idexpr].MaxEU)};
         end;
     if trim(fExprstring)<>'' then  ImmiQueryGraph;
   end;
   end;
   if (trim(value)='') or  (idexpr<0) then
   begin
  // application.MessageBox(pansichar('Start'),pansichar('Start'),0);
   exprNil;
   end;
end;


procedure  TImmiScopeStatic.SetDateTM;
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
  // flbMidle.caption:=FormatDateTime(str,Starttm+TimePeriod/2);
end;
if flbStop<>nil then
begin
//   flbStop.caption:=FormatDateTime(str,Starttm+TimePeriod);
end;
end;

procedure TImmiScopeStatic.FillPerfect;
var i,j: integer;
    datpoint: TDPoint;
    strfind: integer;
    flab: boolean;
    firststatus,instatus, laststatus,outstatus: boolean;

begin
  if res.npoint=0 then
    begin
    isarcNul[0]:=true;
    exit;
    end;
  firststatus:=false;
  laststatus:=false;
  instatus:=false;
  outstatus:=false;

  indicator.FFirstPoint[0]:=true;

   SetCurUe;
  begin
  for i:=0 to res.npoint-1 do
    begin

        if (res.point[i][2]<self.indicator.WorldLeft) and (i< res.npoint-1) and
              (res.point[i+1][2]>self.indicator.WorldRight) then  outstatus:=true;

        if (not outstatus) and (res.point[i][2]<self.indicator.WorldLeft) and
                 (i< res.npoint-1) and
                      (res.point[i+2][1]>self.indicator.WorldLeft) then
                        firststatus:=true;
        if (not outstatus) and (res.point[i][2]<self.indicator.WorldRight) and
                 (i< res.npoint-1) and
                      (res.point[i+1][2]>self.indicator.WorldRight) then
                        laststatus:=true;
        if (res.point[i][2]>=self.indicator.WorldLeft) and
              (res.point[i][2]<=self.indicator.WorldRight) then  instatus:=true;






        datpoint[1]:=res.point[i][2];
        datpoint[2]:=res.point[i][1];


        if outstatus then laststatus:=false;
        if outstatus then firststatus:=false;
        if  instatus then
             begin
               Indicator.AddPointP(datpoint,0);
              // if (i+1)=(res.npoint-1) then  Indicator.AddPointP(res.point[i+1],0,1,0);
             end;

        if  (firststatus) then
             begin
               datpoint[1]:=self.indicator.WorldLeft+0.00000000001;
               datpoint[2]:=GetMidY(res.point[i][1],res.point[i][2],res.point[i+1][1],res.point[i+1][2],self.indicator.WorldLeft);
               Indicator.AddPointP(datpoint,0);
               Indicator.AddPointP(datpoint,0);
             end;

         if  (laststatus) then
             begin
               datpoint[1]:=self.indicator.WorldRight+0.00000000001;
               datpoint[2]:=GetMidY(res.point[i][1],res.point[i][2],res.point[i+1][1],res.point[i+1][2],self.indicator.WorldRight);
               Indicator.AddPointP(datpoint,0);
               Indicator.AddPointP(datpoint,0);
             end;

         if  (outstatus) then
             begin
               datpoint[1]:=self.indicator.WorldLeft+0.00000000001;
               datpoint[2]:=GetMidY(res.point[i][1],res.point[i][2],res.point[i+1][1],res.point[i+1][2],self.indicator.WorldLeft);
               Indicator.AddPointP(datpoint,0);
               Indicator.AddPointP(datpoint,0);
               datpoint[1]:=self.indicator.WorldRight+0.00000000001;
               datpoint[2]:=GetMidY(res.point[i][1],res.point[i][2],res.point[i+1][1],res.point[i+1][2],self.indicator.WorldRight);
               Indicator.AddPointP(datpoint,0);

             end;
       firststatus:=false;
       laststatus:=false;
       instatus:=false;
       outstatus:=false;
 //  Application.ProcessMessages;
    end;
     refresh;
  if (flbStop<>nil) then  flbStop.Caption:=format(flbStop.getlabelformat,[stateumax]);
  if (flbStart<>nil) then  flbStart.Caption:=format(flbStop.getlabelformat,[stateumin]);
    if (self.flbMidle<>nil) then  flbMidle.Caption:=format(flbStop.getlabelformat,[getvaluebytm(self.StartTm+self.TimePeriod)]);

  end;
  FillAbsence(self.Indicator.resabs);
  self.Indicator.lineR:=self.StartTm+self.TimePeriod;
  self.Indicator.lineL:=self.StartTm;
end;


procedure TImmiScopeStatic.QueryFetchComplete(data: tTDPointData;
   Error: integer);
var
    i: integer;

begin
    res:=data;
     if data.ntime>0 then
        begin
           setlength(Indicator.resabs.point,data.ntime);
           Indicator.resabs.n:=data.ntime;
           for i:=0 to data.ntime-1 do
             begin
                Indicator.resabs.point[i][1]:=data.time[i][1];
                Indicator.resabs.point[i][2]:=data.time[i][2];
             end;
         end;
    fillperfect;
    SetMylock(false);
end;


procedure TImmiScopeStatic.FillAbsence(value: tTDPoint);
 var j: integer;
     tr: Trect;
      ststpoint1,ststpoint2: TDPoint;

begin
  try

    for j:=0 to value.n-1 do
      begin
      ststpoint2[1]:=value.point[j][2];
      ststpoint1[1]:=value.point[j][1];
      ststpoint2[2]:=0;
      ststpoint1[2]:=0;
      Indicator.DrawGridStStop(ststpoint1,ststpoint2);
      end;
    except

    end;
end;






procedure TImmiScopeStatic.ExprNil;
var
  Pn : TDPoint;
  Pc : TDPoint;
begin
   if ftimeperiod<=incMillisecond(0,5) then ftimeperiod:=incMillisecond(0,5);
  if Indicator.WorldRight<>fstarttm then
  begin
  Indicator.Worldleft:= fstarttm;
  Indicator.WorldRight:= fstarttm+ftimeperiod;
  end else
  begin
  Indicator.WorldRight:= fstarttm+ftimeperiod;
  Indicator.Worldleft:= fstarttm;
  end;
   indicator.WorldTop:= 0;
   Indicator.WorldBottom:= 100;
  pc[1]:=fstarttm;
  Pn[1]:=fstarttm+ftimeperiod;
  //application.MessageBox(pansichar('Start'),pansichar('Start'),0);
  indicator.DrawGridStStop(pn,pc);
  refresh;
end;

procedure TimmiscopeStatic.SetCurUE;
var minEus, maxEus: double;
    i: integer;
    firststatus,instatus, laststatus,outstatus: boolean;

begin
  firststatus:=false;
  laststatus:=false;
  instatus:=false;
  outstatus:=false;
  if (idexpr>-1) then
   begin
    minEus:=getTRDFmin(fexprstring);
    maxEus:=getTRDFmax(fexprstring);
    if fautosizeEU then
    begin
    minEus:=getTRDFmax(fexprstring);
    maxEus:=getTRDFmin(fexprstring);
    for i:=0 to res.npoint-1 do
      begin
        if (res.point[i][2]<self.indicator.WorldLeft) and (i< res.npoint-1) and
              (res.point[i+1][1]>self.indicator.WorldRight) then  outstatus:=true;

        if (not outstatus) and (res.point[i][1]<self.indicator.WorldLeft) and
                 (i< res.npoint-1) and
                      (res.point[i+1][1]>self.indicator.WorldLeft) then
                        firststatus:=true;
        if (not outstatus) and (res.point[i][1]<self.indicator.WorldRight) and
                 (i< res.npoint-1) and
                      (res.point[i+1][1]>self.indicator.WorldRight) then
                        laststatus:=true;
        if (res.point[i][2]>=self.indicator.WorldLeft) and
              (res.point[i][1]<=self.indicator.WorldRight) then  instatus:=true;



        if  instatus then
             begin
               if {fautosizeEU}true then begin
               if res.point[i][1]<minEus then minEus:=res.point[i][1];
               if res.point[i][1]>maxEus then maxEus:=res.point[i][1]; end;
               if i=0 then valLeft:=res.point[i][2];
               if (i+1)=(res.npoint-1) then
                  begin
                   if {fautosizeEU}true then begin
                   if res.point[i+1][1]<minEus then minEus:=res.point[i][1];
                   if res.point[i+1][1]>maxEus then maxEus:=res.point[i][1]; end;
                   valRight:=res.point[i+1][2];
                  end;
             end;

        if  (firststatus) then
             begin
              if {fautosizeEU}true then begin
              if GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft)<mineuS then minEus:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft);
               if GetMidY(res.point[i][2 ],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft)>maxEus then maxEus:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft); end;
               valLeft:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft);
             end;

         if  (laststatus) then
             begin
               if {fautosizeEU}true then begin
               if GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight)<mineuS then minEus:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight);
               if GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight)>maxEus then maxEus:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight); end;
               valRight:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight);
             end;

         if  (outstatus) then
             begin
               if {fautosizeEU}true then begin
               if GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft)<mineuS then minEus:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft);
               if GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft)>maxEus then maxEus:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft);
               if GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight)<mineuS then minEus:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight);
               if GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight)>maxEus then maxEus:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight); end;
               valLeft:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldLeft);
               valRight:=GetMidY(res.point[i][2],res.point[i][1],res.point[i+1][2],res.point[i+1][1],self.indicator.WorldRight);
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
           minEus:=minEus-(getTRDFmax(fexprstring)-getTRDFmin(fexprstring))*0.005;
           maxEus:=maxEus+(getTRDFmax(fexprstring)-getTRDFmin(fexprstring))*0.005;
         end;
       if minEUs=maxEUs then
         begin
           minEus:=minEus-0.005;
           maxEus:=maxEus+0.005;
         end;
         self.curEUMin:=minEus;
         self.curEUMax:=maxeus;
        if Indicator.WorldBottom<>maxEus then
          begin
           Indicator.WorldTop:= maxEus;
           Indicator.WorldBottom:= minEus;
          end else
          begin
            Indicator.WorldBottom:= minEUs;
            Indicator.WorldTop:= maxEus;
          end;  end;

    stateumin:=minEUs;
    stateumax:=maxEUs;
    end;
    end;
   if not fautosizeEU then begin
     curEUMax:=maxEus;
     curEUMin:=minEus;
    //minEus:=rtitems.items[idexpr].minEu;
    //maxEus:=rtitems.items[idexpr].maxEu;
     if Indicator.WorldBottom<>maxEus then
          begin
           Indicator.WorldTop:= curEUMax;
           Indicator.WorldBottom:= curEUMIN;
          end else
          begin
            Indicator.WorldBottom:= curEUMIN;
            Indicator.WorldTop:= curEUMAX;
          end;
         // self.curEUMax:=maxEus;
       //  self.curEUMin:=minEus;
  //  exit;
   end; 
end;



function TimmiscopeStatic.getTrdefInfoByName(nm: string): PTrenddefRec;
var tmpTrdef: TTrenddefList;
    tmpId: integer;
begin
   result:=nil;
   tmpTrdef:=getTrdef;
   if tmpTrdef<>nil then
    begin
       if tmpTrdef.Find(trim(nm),tmpid) then
         begin
           result:= PTrenddefRec(tmpTrdef.Objects[tmpid]);
         end;
    end;
end;

function TimmiscopeStatic.getTRDFId(nm: string): integer;
var tmp: PTrenddefRec;
begin
   result:=-1;
   tmp:=getTrdefInfoByName(nm);
   if tmp<>nil then
     result:=tmp^.cod;
end;

function TimmiscopeStatic.getTRDFMin(nm: string): double;
var tmp: PTrenddefRec;
begin
   result:=0;
   tmp:=getTrdefInfoByName(nm);
   if tmp<>nil then
     result:=tmp^.MinEU;
end;

function TimmiscopeStatic.getTRDFMax(nm: string): double;
var tmp: PTrenddefRec;
begin
   result:=100;
   tmp:=getTrdefInfoByName(nm);
   if tmp<>nil then
     result:=tmp^.MaxEU;
end;

function TimmiscopeStatic.getTRDFComment(nm: string): string;
var tmp: PTrenddefRec;
begin
   result:='';
   tmp:=getTrdefInfoByName(nm);
   if tmp<>nil then
     result:=tmp^.Comment;
end;




function TimmiscopeStatic.getTrdef: TTrenddefList;
var fDM: TMainDataModule;
begin
 if (csDesigning  in ComponentState) then
  begin
      result:=nil;
      exit;
  end;
try
if TRENDLIST_GLOBAL_ISC=nil then
   begin
     try
      fDM:=TDBManagerFactory.buildManager(dbmanager,connectionstr, dbaReadOnly);
      if fDM<>nil then
      begin
         try
         fDM.Connect;
         try
         TRENDLIST_GLOBAL_ISC:=fDM.regTrdef();
         if TRENDLIST_GLOBAL_ISC.Count=0 then raise Exception.Create('Trenddef пуст или не существует');
         except
           if TRENDLIST_GLOBAL_ISC<>nil then
           freeAndNil(TRENDLIST_GLOBAL_ISC);
           NSDBErrorMessage(NSDB_TRENDDEF_ERR);
           if fDM<>nil then fdM.Free;
           exit;
         end
         except
           TRENDLIST_GLOBAL_ISC:=nil;
           NSDBErrorMessage(NSDB_CONNECT_ERR);
         end;
      end else NSDBErrorMessage(NSDB_CONNECT_ERR);
     finally
       if fDM<>nil then fdM.Free;
     end;
    // result:=TRENDLIST_GLOBAL_ISC;
   end;

except
TRENDLIST_GLOBAL_ISC:=nil;
end;
result:=TRENDLIST_GLOBAL_ISC;
end;


function GetMidY(x1,y1,x2,y2,xx: double): double;
begin
result:=y1;
if x1=x2 then exit;
result:=(y2-y1)/(x2-x1)*(xx-x1)+y1;


end;

procedure Register;
begin
  RegisterComponents('IMMIGraph', [TImmiScopeStatic,TImmiGraphButton,TExprGraphButton,TCtrlGrArchButton, TImmiGraphTrBr,TExprNameLabel,TTimeGrLabel,TCtrlGrOschButton]);
end;

initialization
 TRENDLIST_GLOBAL_ISC:=nil;
finalization
 try
 if TRENDLIST_GLOBAL_ISC<>nil then TRENDLIST_GLOBAL_ISC.Free;
 except
 end;
end.
