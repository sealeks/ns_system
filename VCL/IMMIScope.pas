unit IMMIScope;

interface

uses controls, classes,PointerTegsU, groupsU, ConfigurationSys, MemStructsU, stdctrls,DB, Dialogs,globalvalue, StrUtils, messages,
sysUtils, DateUtils, constDef, Expr, Scope,windows,graphics, DataGraphcModul,forms,
 {GlobalVar,}  DBManagerFactoryU,MainDataModuleU,
 Math;

type parrboolean = ^boolean;

type
  TImmiScope = class(TScope)
  private
    { Private declarations }

    finPersent: boolean;
    //min1,  delt1, min2, delt2:real;
    timC: TDateTime; MinuteC: integer;
    min_y, max_y: double;
    min1_y, max1_y: double;
    exprList: TList;
    ansenseList: TList;
    expr1List: TList;
    Furrsttime, fNoDB: boolean;
    fColMinute: integer;
    starttime: double;
    counpoint: double;
    currentvalue,currentvalue1: real;
    initPoint: tdPoint;
    initPoint1: tdPoint;
    CurPoint: tdPoint;
    curPoint1: tdPoint;
    waitexpr: tTDPoint;
    waitexpr1: tTDPoint;
    ftimeLabel: boolean;
    fMyLock: boolean;
    fMyLock1: boolean;
    idExpr, idExpr1: integer;
    fact: integer;
    isArcNul: array [0..1] of boolean;
    delta: real;
    fColAlLo, fColAvLo, fColAlHi, fColAvHi:  TColor;
    fExpr,fexpr1,fexprNag, fexprVag, fexprNpg, fexprVpg, fExprVisible: tExpretion;
    fFormat: string;
    fExprString,fExprString1: TExprStr ;
    fNagStr, fVagStr, fNpgStr, fVpgStr, fExprVisibleString: TExprStr;
    fCap: string;
    pointstr: string;
    fmaxValEu: real;
    fminValEu: real;
    fmax1ValEu: real;
    fmin1ValEu: real;
    FCompl: TNS_FetchComplete;
    autotop, autobottom: double;
    autotop1, autobottom1: double;
    fautosize: boolean;
    flasact: boolean;

    procedure SetForm (str: string);
    procedure SetCaption (str: TCaption);
    function getact: boolean;
    procedure SetMylock(val: boolean);
    procedure SetMylock1(val: boolean);
  protected
    procedure setColMinute(value: integer);
    procedure ClearList;
    procedure Setexpr(value: TExprStr);
    procedure Setexpr1(value: TExprStr);
    procedure FillAbsence;
    procedure AddtoList(number: integer; val: TDPointData);
    procedure AddtoListAbsense(val: TDateTime; endp: boolean=false);
    procedure CheckOldList(number: integer);
    procedure CheckOldAbsenseList;
    function  getAutosize(): boolean;
    function  getTrdef: TTrenddefList;
  public


    property act: boolean read getact;
    property MyLock: boolean read fMyLock write SetMyLock;
    property MyLock1: boolean read fMyLock1 write SetMyLock1;
    procedure Loaded; override;
    procedure FillPerfect(value: tTDPointData; number: byte);
    constructor Create(AOwner: TComponent); override;
    procedure exprUpdate;
    procedure  QueryExpr(timstart: TDateTime; timstop: TDateTime;  aTagid: integer; var val: tTDPointData);
    procedure  QueryExpr1(timstart: TDateTime; timstop: TDateTime;  aTagid: integer; var val: tTDPointData);
    destructor Destroy; override;
    procedure  AddPP(P : TDPoint; number: byte; active: boolean; actinfo: boolean=false);
    procedure  AddPPFirst(number: byte);
    property   autosize: boolean read getAutosize write fautosize;
    property   Trdef: TTrenddefList read getTrdef;
  published


    property form: string read fFormat write SetForm;
    property Expr: TExprStr  read fExprString write setExpr;
    property Expr1: TExprStr  read fExprString1 write setExpr1;
    property iBnNag: TExprStr  read fNagStr write fNagStr;
    property iBnVag: TExprStr  read fVagStr write fVagStr;
    property iBnNpg: TExprStr  read fNpgStr write fNpgStr;
    property iBnVpg: TExprStr  read fVpgStr write fVpgStr;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    property colMinute: integer read fColMinute write setColMinute;
    property caption write SetCaption;
    property ColAvLo: TColor read fColAvLo write fColAvLo;
    property ColAvHi: TColor read fColAvHi write fColAvHi;
    property ColAlLo: TColor read fColAlLo write fColAlLo;
    property ColAlHi: TColor read fColAlHi write fColAlHi;
    property inPersent: boolean read finPersent write finPersent;
    property ExprVisible: TExprStr  read fExprVisibleString write fExprVisibleString;
    property NoDb: boolean read fNoDB write fNoDB;
    property maxValEu: real read fmaxValEu write fmaxValEu;
    property minValEu: real read fminValEu write fminValEu;
    property timeLabel: boolean read ftimeLabel write ftimeLabel;
    procedure QueryFetchComplete(data: tTDPointData;
     Error: integer);
    procedure QueryFetchComplete1(data: tTDPointData;
     Error: integer);

  end;

procedure Register;

var
  TRENDLIST_GLOBAL_IS: TTrenddefList;

implementation

Uses IMMIAnalogPropU;

constructor TImmiScope.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    fExpr := tExpretion.Create;
    fautosize:=TRUE;
    fexprVpg:= tExpretion.Create;
    fexprVag:= tExpretion.Create;
    fexprNpg:= tExpretion.Create;
    fexprNag:= tExpretion.Create;
    form := '%8.2f';
    fNagStr := '';
    fVagStr := '';
    fNpgStr := '';
    fVpgStr := '';
    fColMinute:= 10;
    starttime:=incminute(Now,-fcolMinute);
    counpoint:=0;
    Furrsttime:=false;

    fMyLock:=false;
    fMyLock1:=false;
    setlength(waitexpr.point,0);
    waitexpr.n:=0;
    setlength(waitexpr1.point,0);
    waitexpr1.n:=0;

    indicator.FDST:=false;
    exprList:=TList.Create;
    expr1List:=TList.Create;
    ansenseList:=TList.Create;
end;

procedure TImmiScope.ClearList;
var i: integer;
begin
  for i:=0 to exprList.Count-1 do
    dispose(exprList.Items[i]);
  for i:=0 to expr1List.Count-1 do
    dispose(expr1List.Items[i]);
  for i:=0 to ansenseList.Count-1 do
    dispose(ansenseList.Items[i]);
   exprList.Clear;
   expr1List.Clear;
   ansenseList.Clear;
end;




procedure TImmiScope.AddtoList(number: integer; val: TDPointData);
var i: integer;
    tmp: pTDPointData;
begin
  CheckOldList(number);
  if number=0 then
  begin
  new(tmp);
  tmp[1]:=val[2];
  tmp[2]:=val[1];
  exprList.Insert(exprList.Count,tmp);
  if tmp[2]<min_y then
   min_y:=tmp[2];
  if tmp[2]>max_y then
   max_y:=tmp[2];

  end;

  if number=1 then
  begin
  new(tmp);
  tmp[1]:=val[2];
  tmp[2]:=val[1];
  expr1List.Insert(expr1List.Count,tmp);
  if tmp[2]<min1_y then
   min1_y:=tmp[2];
  if tmp[2]>max1_y then
   max1_y:=tmp[2];
  end;
end;

procedure TImmiScope.AddtoListAbsense(val: TDateTime; endp: boolean=false);
var tmp: pTDPointData;
begin
  if (ansenseList.Count=0) and (endp) then exit;
  CheckOldAbsenseList;
  if (ansenseList.Count=0) and (endp) then exit;
  if not endp then
  begin
  new(tmp);
  tmp[1]:=val;
  tmp[2]:=val;
  ansenseList.Insert(ansenseList.Count,tmp);
  flasact:=false;
  end else
  begin
  pTDPointData(ansenseList.items[ansenseList.count-1])^[2]:=val;
  flasact:=true;
  end;

end;


procedure TImmiScope.CheckOldAbsenseList;
var i: integer;
    fl: boolean;
begin
   i:=0;
   while (i<ansenseList.Count) do
    begin

      if ((pTDPointData(ansenseList.Items[i])[1]<indicator.FOrigin[1])
         and (pTDPointData(ansenseList.Items[i])[2]<indicator.FOrigin[1]))
        then
           begin
            /// удаляем
            dispose(ansenseList.Items[i]);
            ansenseList.delete(i);
           end else i:=i+1;
    end;

end;

procedure TImmiScope.CheckOldList(number: integer);
var i: integer;
    fl: boolean;
begin

 if number=0 then
  begin
   i:=0;
   fl:=false;
   if exprList.Count=0 then
    begin
       min_y:=fmaxValEu;
       max_y:=fminValEu;
    end;
   while (i<exprList.Count) do
    begin

      if (pTDPointData(exprList.Items[i])[1]<indicator.FOrigin[1])
        then
           begin
            /// удаляем
            if ((pTDPointData(exprList.Items[i])[2]<=min_y) or
            (pTDPointData(exprList.Items[i])[2]>=max_y)) then fl:=true;
            dispose(exprList.Items[i]);
            exprList.delete(i);
           end else i:=i+1;
    end;
    if fl then
      begin
       min_y:=fmaxValEu;
       max_y:=fminValEu;
       for i:=0 to exprList.Count-1 do
         begin
            if (pTDPointData(exprList.Items[i])[2]<min_y) then min_y:=pTDPointData(exprList.Items[i])[2];
            if (pTDPointData(exprList.Items[i])[2]>max_y) then max_y:=pTDPointData(exprList.Items[i])[2];
           end;

     end;

     // 28-08-2009

     if (max_y-min_y)>(0.03*(fmaxValEu-fminValEu)) then
     begin
     autotop:= min((max_y+(max_y-min_y)*0.1),fmaxValEu);
     autobottom:=max((min_y-(max_y-min_y)*0.1),fminValEu);
     end else
     begin
     autotop:= min(((max_y+min_y)/2+((0.03*(fmaxValEu-fminValEu)))*1.1/2.0),fmaxValEu);
     autobottom:=max(((max_y+min_y)/2-((0.03*(fmaxValEu-fminValEu)))*1.1/2.0),fminValEu);
     end;

     if autotop=autobottom then
      begin
       autotop:=autotop1+0.5;
       autobottom:=autotop1-0.5;
      end;
      end;


  if number=1 then
  begin
  i:=0;
  fl:=false;
  if expr1List.Count=0 then
    begin
       min1_y:=fmax1ValEu;
       max1_y:=fmin1ValEu;
    end;
   while (i<expr1List.Count) do
    begin

      if (pTDPointData(expr1List.Items[i])[1]<indicator.FOrigin[1])
        then
           begin
            /// удаляем
            if ((pTDPointData(expr1List.Items[i])[2]<=min1_y) or
            (pTDPointData(expr1List.Items[i])[2]>=max1_y)) then fl:=true;
            dispose(expr1List.Items[i]);
            expr1List.delete(i);
           end else i:=i+1;
    end;
    if fl then
      begin
       min1_y:=fmax1ValEu;
       max1_y:=fmin1ValEu;
       for i:=0 to expr1List.Count-1 do
         begin
            if (pTDPointData(expr1List.Items[i])[2]<min1_y) then min1_y:=pTDPointData(expr1List.Items[i])[2];
            if (pTDPointData(expr1List.Items[i])[2]>max1_y) then max1_y:=pTDPointData(expr1List.Items[i])[2];
           end;
       end;

     autotop1:= min((max1_y+(max1_y-min1_y)*0.1),fmax1ValEu);
     autobottom1:=max((min1_y-(max1_y-min1_y)*0.1),fmin1ValEu);
     if autotop1=autobottom1 then
      begin
       autotop1:=autotop1+0.1;
       autobottom1:=autotop1-0.1;
      end;


  end;

end;



procedure TImmiScope.Loaded;
 var Msg: TMessage;
begin
 inherited;
 Msg.Msg:=WM_IMMIINIT;
 Msg.Result:=-999;
 indicator.horlable:=self.ftimeLabel;;
 if nodb then self.ImmiInit(Msg);

end;



procedure TImmiScope.SetForm (str: string);
begin
  fformat := str;
  caption := str;
end;

procedure TImmiScope.SetCaption (str: TCaption);
begin
  fCap := string(str);
  inherited caption := str;
end;

procedure TImmiScope.SetMylock(val: boolean);
var i: integer;
    datpoint: TDPoint;
    datpoint1: TDPoint;
begin
if fMylock and not val then
 begin
   if isArcNul[0] then
       begin
       datpoint[1]:=0;
       datpoint[2]:=currentvalue;
       AddPP(datPoint,0,true);
       AddPP(datPoint,0,true);
       isArcNul[0]:=false;
       end;

{  if  assigned(fexpr1)  then
    begin
     if isArcNul[1] then
       begin
       datpoint[1]:=0;
       datpoint[2]:=currentvalue1;
       AddPP(datPoint,1,true);
       AddPP(datPoint,1,true);
       isArcNul[1]:=false;
       end;

     for i:=0 to waitexpr.n-1 do
    AddPP(waitexpr1.point[i],1,true);


    end;   }
 end;
fMylock:=val;
FillAbsence;
end;


procedure TImmiScope.SetMylock1(val: boolean);
var i: integer;
    datpoint: TDPoint;
    datpoint1: TDPoint;
begin
if fMylock1 and not val then
 begin

  if  assigned(fexpr1)  then
    begin
     if isArcNul[1] then
       begin
       datpoint[1]:=0;
       datpoint[2]:=currentvalue1;
       AddPP(datPoint,1,true);
       AddPP(datPoint,1,true);
       isArcNul[1]:=false;
       end;

     for i:=0 to waitexpr1.n-1 do
    AddPP(waitexpr1.point[i],1,true);


    end;
 end;
fMylock1:=val;
//FillAbsence;
end;

destructor TImmiScope.Destroy;
begin
    try
     if Nodb then
      begin
       if fExpr<>nil then fExpr.ImmiUnInit;
       if fExpr1<>nil then fexpr1.ImmiUnInit;
       if fExprVpg<>nil then fexprVpg.ImmiUnInit;
       if fExprNpg<>nil then fexprNpg.ImmiUnInit;
       if fExprNag<>nil then fexprNag.ImmiUnInit;
       if fExprVag<>nil then fexprVag.ImmiUnInit;
       if assigned(fExprVisible) then fExprVisible.immiuninit;
       setlength(waitexpr.point,0);
       waitexpr.n:=0;
       setlength(waitexpr1.point,0);
       waitexpr1.n:=0;
    
      end;
    except
    end;

    Furrsttime:=false;
    if assigned(fExprVisible) then fExprVisible.free;
    if assigned(fExpr) then fExpr.free;
    if assigned(fExpr1) then fExpr1.free;
    if assigned(fexprVpg) then fexprVpg.free;
    if assigned(fexprNpg) then fexprNpg.free;
    if assigned(fexprNag) then fexprNag.free;
    if assigned(fexprVag) then fexprVag.free;

    exprList.Free;
    expr1List.Free;
    ansenseList.Free;

    inherited;
end;

procedure TImmiScope.ImmiInit (var Msg: TMessage);
var id: integer;
     idpoint: integer;
     grNum: integer;

begin
 min_y:=100000000;
 max_y:=-100000000;
 min1_y:=100000000;
 max1_y:=-100000000;
 flasact:=true;
 if not fNoDb then
  begin
    Indicator.WorldRight:=incsecond(Now,30);
    Indicator.WorldLeft:=incminute(Now,-colMinute);

  end else
  begin
    Indicator.WorldRight:=incminute(Now,colMinute);
    Indicator.WorldLeft:=incminute(Now,0);

  end;

 fact:=-2;
 if (Nodb) and (Msg.Result<>-999) then exit;
   try

    if ((csDesigning  in ComponentState) or (Application.Tag=1000)) then  exit;
    if not NoDb then starttime:=incminute(now,-colminute)
    else starttime:=now;

    if fexprstring='' then exit;
      idExpr:=rtitems.getsimpleId(fExprString);
    if idExpr<0 then exit;
    grNum:=rtitems.Items[idExpr].GroupNum;
    fmaxValEu:=rtitems.Items[idExpr].maxEu;
    fminValEu:=rtitems.Items[idExpr].minEu;
    pointstr:='';
    if pos('$Pointer', ANSIUPPERCASE(trim(rtitems.tegGroups.ItemNameByNum[grNum])))<>0 then
      begin
        try
        pointstr:=rtitems.tegGroups.ItemNameByNum[grNum];
        idpoint:=rtitems.getsimpleId(pointstr);
        pointstr:=rtitems.getddeitem(idExpr);
        idExpr:=idpoint;
        except
         pointstr:='';
        end;
      end
   else pointstr:='';

   if fExprString1<>'' then fExpr1:= tExpretion.Create;
   isArcNul[0]:=false;
   isArcNul[1]:=false;
   fExpr.Expr := pointstr+fExprString;
   fExpr.ImmiInit;
   Indicator.MARGIN_TOP:=5;
   indicator.Font.Color:=clYellow;
   if assigned(fexpr1) then
      begin
      fexpr1.expr:=pointstr+fExprString1;
      fexpr1.immiInit;
      idExpr1:=rtitems.getsimpleId(pointstr+fExprString1);
      if idExpr1>-1 then
      begin
      fmax1ValEu:=rtitems.Items[idExpr1].maxEu;
      fmin1ValEu:=rtitems.Items[idExpr1].minEu;
      end;
      end;



   if not finPersent then
      begin
      if (fmaxValEu=fminValEu) and (fmaxValEu=0)then
        begin
        id:=idExpr;
        if id>-1 then
           begin
           Indicator.WorldTop:= rtitems.Items[id].MinEU+ (rtitems.Items[id].MaxEU-rtitems.Items[id].MinEU)*1.1;
           Indicator.WorldBottom:= rtitems.Items[id].MinEU- (rtitems.Items[id].MaxEU-rtitems.Items[id].MinEU)*0.1;
          end;
        end
      else
        begin
         Indicator.WorldTop:= fminValEu+ (fmaxValEu-fminValEu)*1.1;
         Indicator.WorldBottom:= fminValEu- (fmaxValEu-fminValEu)*0.1;
        end;
      end
   else
     begin
      id:=idExpr;
      if id>-1 then
        begin
       // min1:=rtitems.Items[id].MinEU;
      //  delt1:= rtitems.Items[id].MaxEU- rtitems.Items[id].MinEU;
        end;
     if Expr1<>'' then
        begin
         id:=idExpr1;
         if id>-1 then
           begin
         //  min2:=rtitems.Items[id].MinEU;
         //  delt2:= rtitems.Items[id].MaxEU- rtitems.Items[id].MinEU;
           end;
        end;


   //   delt1:=delt1/100;
    //  delt2:=delt2/100;
      Indicator.WorldBottom:= 0;
      Indicator.WorldTop:= 100;
     end;


   if fNagStr<>'' then
     begin
     fexprNag.Expr:=pointstr+fNagStr;
     fexprNag.ImmiInit;
     Indicator.AvLo.state:=true;
     Indicator.AvLo.bColor:=fColAvLo;
     fexprNag.ImmiUpdate;
     Indicator.AvLo.value:=fexprNag.value;
     end
   else
     Indicator.AvLo.state:=false;

   if fVagStr<>'' then
     begin
     fexprVag.Expr:=pointstr+fVagStr;
     fexprVag.ImmiInit;
     Indicator.AvHi.state:=true;
     Indicator.AvHi.bColor:=fColAvHi;
     fexprVag.ImmiUpdate;
     Indicator.avHi.value:=fexprVag.value;
     end
   else
     Indicator.AvHi.state:=false;

   if fNpgStr<>'' then
     begin
     fexprNpg.Expr:=pointstr+fNpgStr;
     fexprNpg.ImmiInit;
     Indicator.AlLo.state:=true;
     Indicator.AlLo.bColor:=fColAlLo;
     fexprNpg.ImmiUpdate;
     Indicator.AlLo.value:=fexprNpg.value;
     end
   else
     Indicator.AlLo.state:=false;

   if fVpgStr<>'' then
     begin
     fexprVpg.Expr:=pointstr+fVpgStr;
     fexprVpg.ImmiInit;
     Indicator.AlHi.state:=true;
     Indicator.AlHi.bColor:=fColAlHi;
     fexprVpg.ImmiUpdate;
     Indicator.alHi.value:=fexprVpg.value;
     end
   else
     Indicator.AlHi.state:=false;

   Draw;
   CreateAndInitExpretion(fexprVisible,fExprVisibleString);
   if rtItems.isIdent(Expr) then
     begin
     showHint := true;
     currentvalue:=fExpr.value;
     end;
   Indicator.fFirstPoint[0]:=true;
   Indicator.fFirstPoint[1]:=true;
   if not fNoDb then
     try
     fMyLock:=true;
     fMyLock1:=true;
     setlength(waitexpr.point,0);
     waitexpr.n:=0;
     setlength(waitexpr1.point,0);
     waitexpr1.n:=0;

     except
     err:=true;
     end;
   self.Paint;
  finally
  Furrsttime:=true;
  //isInition:=true;
  fact:=-2;
  end;
end;

procedure TImmiScope.ImmiUnInit (var Msg: TMessage);
begin

  if ((csDesigning in ComponentState) or (Application.Tag=1000) or  (csLoading  in ComponentState)) then  exit;
  if not Nodb then
    begin
    setlength(waitexpr.point,0);
    waitexpr.n:=0;
    setlength(waitexpr1.point,0);
    waitexpr1.n:=0;

    if fExpr<>nil then fExpr.ImmiUnInit;
    if fExpr1<>nil then fexpr1.ImmiUnInit;
    if fExprVpg<>nil then fexprVpg.ImmiUnInit;
    if fExprNpg<>nil then fexprNpg.ImmiUnInit;
    if fExprNag<>nil then fexprNag.ImmiUnInit;
    if fExprVag<>nil then fexprVag.ImmiUnInit;
    if assigned(fExprVisible) then fExprVisible.immiuninit;

    end;
    ClearList;
end;




procedure TImmiScope.ImmiUpdate;
var
   val,val1: real;
   str: string;
   newCap: string;
   last,last1: double;
   datpoint: TDPoint;
   datpoint1: TDPoint;
   lbval: tTDPointData;
   isf: boolean;
   strfind,i: integer;
   strtest: string;
   timms: Tdatetime;
   lefttimms: Tdatetime;
begin

   try
     if ((csDesigning in ComponentState) or (Application.Tag=1000) or  (csLoading  in ComponentState)) then  exit;

     // обработка видимости
     if assigned(fexprVisible) then
        begin
         fexprVisible.ImmiUpdate;
         Visible:=(fexprVisible.value>0);
        end
     else
        visible:=true;

     // обработка первой и второй точек
     if fexprstring='' then exit;
     fExpr.ImmiUpdate;

     val := fExpr.Value;
     if  assigned(fexpr1) then
       begin
       fExpr1.ImmiUpdate;
       val1:=fexpr1.value;
       currentvalue1:=val1;
       end;


     currentvalue:=val;
     datpoint[1]:=now;
     datpoint[2]:=currentvalue;


     // здесь пишуться точки пока идет запрос базе
     {-------------------------------------------------}

     if FurrstTime then InitPoint:=datpoint;
      CurPoint:=datPoint;
      if not MyLock or NoDb then
        AddPP(datPoint,0,act,true)
     else
        begin
         if waitexpr.n<300 then
          begin
           setlength(waitexpr.point,waitexpr.n+1);
           inc(waitexpr.n);
           waitexpr.point[waitexpr.n-1]:=datPoint;
         end
           else  MyLock:=false;
         begin

         end;
       end;

     if  assigned(fexpr1) then
      begin
       datpoint1[1]:=now;
       datpoint1[2]:=val1;
       CurPoint1:=datPoint1;
      if not MyLock1  or NoDb  then
        AddPP(datPoint1,1,true,true)
      else
        begin
        if waitexpr1.n<300 then
          begin
          setlength(waitexpr1.point,waitexpr1.n+1);
          inc(waitexpr1.n);
          waitexpr1.point[waitexpr1.n-1]:=datPoint1;
          end else  MyLock1:=false;
         end;
      end;
     Refresh;

     {--------------------------------------}

     if not NoDb then   // если надо  запрашивать историю
       begin
       if Furrsttime then
         begin

         isf:=false;
         strfind:=0;
         Furrsttime:=false;
         idExpr:=rtitems.getsimpleId(pointstr+fExprString);
         idexpr1:=rtitems.getsimpleId(pointstr+fExprString1);

           timms:=now;


             if (idexpr>-1)  then
           begin
            setlength(lbval.point,0);
            lbval.npoint:=0;
            if localBase then
              begin
              // обращение к памяти
              lefttimms:=rtitems.QueryLocalBaseTag(now,fcolMinute,idexpr,lbval);
              QueryFetchComplete(lbval,0);
              end
              else
              // обращение к БД
              QueryExpr(incminute(now,-colMinute), now ,idexpr,lbval);
           // exit;
            end;

           if (idexpr1>-1)  then
           begin
            setlength(lbval.point,0);
            lbval.npoint:=0;
            if localBase then
              begin
              // обращение к памяти
              lefttimms:=rtitems.QueryLocalBaseTag(now,fcolMinute,idexpr1,lbval);
              QueryFetchComplete1(lbval,0);
              end
              else
              // обращение к БД
              QueryExpr1(incminute(now,-colMinute), now ,idexpr1,lbval);
           // exit;
            end;
          end;
         end;




   except
   end;
end;






procedure TImmiScope.setColMinute(value: integer);
begin
  if value<1 then value:=1;
  if value>1800 then value:=1800;
  fColMinute:=value;
  starttime:=incminute(now,-fcolMinute);
  delta:= width/value;
end;





procedure TImmiScope.Setexpr(value: TExprStr);
var ms: TMessage;
begin
  if assigned(fExpr) then  fExpr.ImmiUnInit;
  fexprstring:=value;
end;

procedure TImmiScope.Setexpr1(value: TExprStr);
var ms: TMessage;
begin
  if assigned(fExpr1) then  fExpr.ImmiUnInit;
  fexprstring1:=value;
end;



procedure TImmiScope.exprUpdate;
begin
  starttime:=incminute(Now,-colMinute);
  counpoint:=0;
  Draw;
end;



procedure TImmiScope.FillPerfect(value: tTDPointData; number: byte);
var i,j: integer;
    datpoint: TDPointData;
    strfind: integer;
    flab: boolean;
begin
  for i:=0 to value.npoint-1 do
   begin
    AddtoList(number,value.point[i]);

   end;
   if self.exprList.Count=0 then
    begin
     if self.finPersent then
      begin
      autotop:=100;
      autobottom:=0;
      end else
      begin
       autotop:=fmaxValEu;
       autobottom:=fminValEu;
     end;
   end;

   AddPPFirst(number);
end;

procedure TImmiScope.FillAbsence;
 var j: integer;
     tr: Trect;
      ststpoint1,ststpoint2: TDPoint;
begin
  try

    for j:=0 to ansenseList.Count-1 do
      begin
      if pTDPointData(ansenseList.items[j])^[2]>indicator.FOrigin[1] then
      begin
      ststpoint2[1]:=pTDPointData(ansenseList.items[j])^[2];
      if pTDPointData(ansenseList.items[j])^[1]<indicator.FOrigin[1] then
      ststpoint1[1]:=indicator.FOrigin[1]
      else
      ststpoint1[1]:=pTDPointData(ansenseList.items[j])^[1];
      ststpoint2[2]:=0;
      ststpoint1[2]:=0;
      Indicator.DrawGridStStop(ststpoint1,ststpoint2);
      end;
      end;

    
    except

    end;
end;


procedure TImmiScope.QueryExpr(timstart: TDateTime; timstop: TDateTime;  aTagid: integer; var val: tTDPointData);
 var TTread_T: TTrendThread;
begin
  try
   try
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,rtitems.GetName(aTagid),timstart, timstop,
   QueryFetchComplete,getTrdef);
   except
   end;
  finally

  end;

end;

procedure TImmiScope.QueryExpr1(timstart: TDateTime; timstop: TDateTime;  aTagid: integer; var val: tTDPointData);
 var TTread_T: TTrendThread;
begin
  try
   try
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,rtitems.GetName(aTagid),timstart, timstop,
   QueryFetchComplete1,getTrdef);
   except
   end;
  finally
  end;
end;

procedure TImmiScope.QueryFetchComplete(data: tTDPointData;
   Error: integer);
var res: tTDPoint;
    i,j,k: integer;
begin

      if data.ntime>0 then
        begin
         
           for i:=0 to data.ntime-1 do
             begin
                AddtoListAbsense(data.time[i][1]);
                AddtoListAbsense(data.time[i][2],true);
             end;
        end;


      fillperfect(data,0);
      FillAbsence;
      Refresh;
      setlength(data.point,0);
      setlength(data.time,0);
      MyLock:=false;
end;

procedure TImmiScope.QueryFetchComplete1(data: tTDPointData;
   Error: integer);
var res: tTDPoint;
    i,j,k: integer;
begin
      if data.ntime>0 then
        begin

           for i:=0 to data.ntime-1 do
             begin
                if data.time[i][1]<indicator.FOrigin[1] then
                    data.time[i][1]:=indicator.FOrigin[1];

             end;
        end;


      fillperfect(data,1);
      setlength(data.point,0);
      setlength(data.time,0);
      MyLock1:=false;
end;


function Timmiscope.getact: boolean;
begin
  result:=true;
  if fact=-1 then exit;
  if fact=-2 then
   fact:=rtitems.GetSimpleID(fExpr.Expr);
  if fact=-1 then exit;
  result:=(rtitems.Items[fact].ValidLevel > VALID_LEVEL);
  if result<>flasact then
  begin
    AddtoListAbsense(now,(result=true));
    if (result) then FillAbsence;
  end;
 flasact:=result; 
end;


procedure Timmiscope.AddPPFirst(number: byte);
 var P1 : TDPoint;
      i: integer;
      tmpList: TList;
      tmpmin,tmpmax: double;
begin
  if autosize then
  begin
  indicator.WorldTop:=autotop;
  indicator.WorldBottom:=autobottom;
  end;
   if number=0 then
     begin
     tmpList:=exprList;
     tmpmin:=fminValEu;
     tmpmax:=fmaxValEu;
     end
     else
      begin
     tmpList:=expr1List;
     tmpmin:=fmin1ValEu;
     tmpmax:=fmax1ValEu;
     end;


   for i:=0 to tmpList.Count-1 do
    begin
       if i=(0) then
             begin

              indicator.FFirstPoint[0]:=true;
              P1[2]:=pTDPointData(tmpList.Items[i])^[2];
              P1[1]:=pTDPointData(tmpList.Items[i])^[1];
              if finPersent then
                begin
                  if (tmpmax-tmpmin)<>0 then
                  P1[2]:=(P1[2]-tmpmin)/(tmpmax-tmpmin)*100.0;
                end;
              indicator.AddPointP(P1,number);

             end else
             begin


              P1[2]:=pTDPointData(tmpList.Items[i])^[2];
              P1[1]:=pTDPointData(tmpList.Items[i])^[1];

               if finPersent then
                begin
                  if finPersent then
                    begin
                      if (tmpmax-tmpmin)<>0 then
                      P1[2]:=(P1[2]-tmpmin)/(tmpmax-tmpmin)*100.0;
                    end;
                end;

              indicator.AddPoint(P1,number,true);

             end;

    end;
    FillAbsence;
end;



procedure Timmiscope.AddPP(P : TDPoint; number: byte; active: boolean; actinfo: boolean=false);
var vl: TDPointData;
    P1 : TDPoint;
    i: integer;
    tmpT: string;
    tmpD: double;
begin

  if autosize then
   begin
   vl[1]:=P[2];
   vl[2]:=P[1];
   AddtoList(number,vl);
   if (indicator.WorldTop<>autotop) or (indicator.WorldBottom<>autobottom) then
   begin
          AddPPFirst(number);
          FillAbsence;
          exit;
   end;
   end;

   if finPersent then
     begin
       if number=0 then
         begin
          if (fmaxValEu-fminValEu)<>0 then
          P[2]:=(P[2]-fminValEu)/(fmaxValEu-fminValEu)*100.0;
         end;
       if number=1 then
         begin
          if (fmax1ValEu-fmin1ValEu)<>0 then
          P[2]:=(P[2]-fmin1ValEu)/(fmax1ValEu-fmin1ValEu)*100.0;
         end;
     end;
   if actinfo then
   indicator.AddPoint(P , number, active)
   else indicator.AddPointP(P , number);


end;


function  Timmiscope.getAutosize(): boolean;
begin
  if (trim(fExprString1)<>'') then result:=false else
    begin
      if inPersent then result:=false else
       result:=fAutosize;
    end;
end;

function Timmiscope.getTrdef: TTrenddefList;
var fDM: TMainDataModule;
begin
 if (csDesigning  in ComponentState) then
  begin
      result:=nil;
      exit;
  end;
try
fDM:=nil;
if TRENDLIST_GLOBAL_IS=nil then
   begin
     try
      fDM:=TDBManagerFactory.buildManager(dbmanager,connectionstr, dbaReadOnly);
      if fDM<>nil then
      begin
         try
         fDM.Connect;
         try
         TRENDLIST_GLOBAL_IS:=fDM.regTrdef();
         if TRENDLIST_GLOBAL_IS.Count=0 then raise Exception.Create('Trenddef пуст или не существует');
         except
           if TRENDLIST_GLOBAL_IS<>nil then
           freeAndNil(TRENDLIST_GLOBAL_IS);
           NSDBErrorMessage(NSDB_TRENDDEF_ERR);

         end
         except
           TRENDLIST_GLOBAL_IS:=nil;
           NSDBErrorMessage(NSDB_CONNECT_ERR);
         end;
      end else NSDBErrorMessage(NSDB_CONNECT_ERR);
     finally
       try
       if fDM<>nil then fdM.Free;
       except
       end;
     end;
    // result:=TRENDLIST_GLOBAL_IS;
   end;

except
TRENDLIST_GLOBAL_IS:=nil;
end;
result:=TRENDLIST_GLOBAL_IS;
end;

procedure Register;
begin
  RegisterComponents('IMMIGraph', [TImmiScope]);
end;

initialization
  {$IFDEF NSComponent}
   InitialSys;
  {$ENDIF}
   TRENDLIST_GLOBAL_IS:=nil;
finalization
 try
 if TRENDLIST_GLOBAL_IS<>nil then TRENDLIST_GLOBAL_IS.Free;
 except
 end;

end.
