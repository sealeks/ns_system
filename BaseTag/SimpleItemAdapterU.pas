unit SimpleItemAdapterU;

interface

uses
  Classes, ItemAdapterU, MemStructsU, SysUtils,ValEdit,Grids,ConstDef;

type
  TRTItemWraper = class  (TItemWraper)
    protected
     rtIt: TanalogMems;
     function GetTyp(Index: Integer): String;
     procedure SetTyp(Index: Integer; value: String);
     function GetTyp_(): String;
     procedure SetTyp_(value: String);
     function GetAlarmType(Index: Integer): String;
     procedure SetAlarmType(Index: Integer; value: String);
     function GetAlarmType_(): String;
     procedure SetAlarmType_(value: String);
     function GetName(Index: Integer): String;
     procedure SetName(Index: Integer; value: String);
     function GetName_(): String;
     procedure SetName_(value: String);
     function GetComment(Index: Integer): String;
     procedure SetComment(Index: Integer; value: String);
     function GetComment_(): String;
     procedure SetComment_(value: String);
     function GetSource(Index: Integer): String;
     procedure SetSource(Index: Integer; value: String);
     function GetSource_(): String;
     procedure SetSource_(value: String);
     function GetEU(Index: Integer): String;
     procedure SetEU(Index: Integer; value: String);
     function GetEU_(): String;
     procedure SetEU_(value: String);
     function GetOnMsgStr(Index: Integer): String;
     procedure SetOnMsgStr(Index: Integer; value: String);
     function GetOnMsgStr_(): String;
     procedure SetOnMsgStr_(value: String);
     function GetOffMsgStr(Index: Integer): String;
     procedure SetOffMsgStr(Index: Integer; value: String);
     function GetOffMsgStr_(): String;
     procedure SetOffMsgStr_(value: String);
     function GetAlarmMsgStr(Index: Integer): String;
     procedure SetAlarmMsgStr(Index: Integer; value: String);
     function GetAlarmMsgStr_(): String;
     procedure SetAlarmMsgStr_(value: String);
     function GetMinRaw(Index: Integer): Single;
     procedure SetMinRaw(Index: Integer; value: single);
     function GetMinRaw_(): String;
     procedure SetMinRaw_(value: String);

     function  GetVal(Index: Integer): real;
     procedure SetVal(Index: Integer; value: real);
     function  GetVal_(): String;
     procedure SetVal_(value: String);




     function GetMaxRaw(Index: Integer): Single;
     procedure SetMaxRaw(Index: Integer; value: single);
     function GetMaxRaw_(): String;
     procedure SetMaxRaw_(value: String);
     function GetMinEU(Index: Integer): Single;
     procedure SetMinEU(Index: Integer; value: single);
     function GetMinEU_(): String;
     procedure SetMinEU_(value: String);
     function GetMaxEU(Index: Integer): Single;
     procedure SetMaxEU(Index: Integer; value: single);
     function GetMaxEU_(): String;
     procedure SetMaxEU_(value: String);
     function GetAlarmConst(Index: Integer): Single;
     procedure SetAlarmConst(Index: Integer; value: single);
     function GetAlarmConst_(): String;
     procedure SetAlarmConst_(value: String);
     function GetDeadBaund(Index: Integer): real;
     procedure SetDeadBaund(Index: Integer; value: real);
     function GetDeadBaund_(): String;
     procedure SetDeadBaund_(value: String);
     function GetLogDB(Index: Integer): real;
     procedure SetLogDB(Index: Integer; value: real);
     function GetLogDB_(): String;
     procedure SetLogDB_(value: String);
     function GetLogTime(Index: Integer): integer;
     procedure SetLogTime(Index: Integer; value: integer);
     function GetLogTime_(): String;
     procedure SetLogTime_(value: String);
     function GetPreTime(Index: Integer): integer;
     procedure SetPreTime(Index: Integer; value: integer);
     function GetPreTime_(): String;
     procedure SetPreTime_(value: String);
     function GetOnMsg(Index: Integer): boolean;
     procedure SetOnMsg(Index: Integer; value: boolean);
     function GetOnMsg_(): String;
     procedure SetOnMsg_(value: String);
     function GetOffMsg(Index: Integer): boolean;
     procedure SetOffMsg(Index: Integer; value: boolean);
     function GetOffMsg_(): String;
     procedure SetOffMsg_(value: String);
     function GetAlarmLocalMsg(Index: Integer): boolean;
     procedure SetAlarmLocalMsg(Index: Integer; value: boolean);
     function GetAlarmLocalMsg_(): String;
     procedure SetAlarmLocalMsg_(value: String);
     function GetAlarmMsg(Index: Integer): boolean;
     procedure SetAlarmMsg(Index: Integer; value: boolean);
     function GetAlarmMsg_(): String;
     procedure SetAlarmMsg_(value: String);
     function GetLogged(Index: Integer): boolean;
     procedure SetLogged(Index: Integer; value: boolean);
     function GetLogged_(): String;
     procedure SetLogged_(value: String);
     function GetAlarmCond(Index: Integer): TAlarmCase;
     procedure SetAlarmCond(Index: Integer; value: TAlarmCase);
     function GetAlarmCond_(): String;
     procedure SetAlarmCond_(value: String);
     function checkCorrectname(val: string): string;
    public
    constructor create(rt: TanalogMems;le: TValueListEditor);
    destructor destroy;
    procedure writetofile();  override;
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;


    procedure setList(value: TList); override;
    property Name[Index: Integer]: String read GetName write SetName;
    property Name_: String read GetName_ write SetName_;
    property Comment[Index: Integer]: String read GetComment write SetComment;
    property Comment_: String read GetComment_ write SetComment_;
    property Source[Index: Integer]: String read GetSource write SetSource;
    property Source_: String read GetSource_ write SetSource_;
    property EU[Index: Integer]: String read GetEU write SetEU;
    property EU_: String read GetEU_ write SetEU_;
    property OnMsgStr[Index: Integer]: String read GetOnMsgStr write SetOnMsgStr;
    property OnMsgStr_: String read GetOnMsgStr_ write SetOnMsgStr_;
    property OffMsgStr[Index: Integer]: String read GetOffMsgStr write SetOffMsgStr;
    property OffMsgStr_: String read GetOffMsgStr_ write SetOffMsgStr_;
    property AlarmMsgStr[Index: Integer]: String read GetAlarmMsgStr write SetAlarmMsgStr;
    property AlarmMsgStr_: String read GetAlarmMsgStr_ write SetAlarmMsgStr_;
    property MinRaw[Index: Integer]: single read GetMinRaw write SetMinRaw;
    property MinRaw_: String read GetMinRaw_ write SetMinRaw_;
    property Val[Index: Integer]: real read GetVal write SetVal;
    property Val_: String read GetVal_ write SetVal_;
    property MaxRaw[Index: Integer]: single read GetMaxRaw write SetMaxRaw;
    property MaxRaw_: String read GetMaxRaw_ write SetMaxRaw_;
    property MinEU[Index: Integer]: single read GetMinEU write SetMinEU;
    property MinEU_: String read GetMinEU_ write SetMinEU_;
    property MaxEU[Index: Integer]: single read GetMaxEU write SetMaxEU;
    property MaxEU_: String read GetMaxEU_ write SetMaxEU_;
    property AlarmConst[Index: Integer]: single read GetAlarmConst write SetAlarmConst;
    property AlarmConst_: String read GetAlarmConst_ write SetAlarmConst_;
    property DeadBaund[Index: Integer]: real read GetDeadBaund write SetDeadBaund;
    property DeadBaund_: String read GetDeadBaund_ write SetDeadBaund_;
    property LogDB[Index: Integer]: real read GetLogDB write SetLogDB;
    property LogDB_: String read GetLogDB_ write SetLogDB_;
    property LogTime[Index: Integer]: integer read GetLogTime write SetLogTime;
    property LogTime_: String read GetLogTime_ write SetLogTime_;
    property PreTime[Index: Integer]: integer read GetPreTime write SetPreTime;
    property PreTime_: String read GetPreTime_ write SetPreTime_;
    property OnMsg[Index: Integer]: boolean read GetOnMsg write SetOnMsg;
    property OnMsg_: String read GetOnMsg_ write SetOnMsg_;
    property OffMsg[Index: Integer]: boolean read GetOffMsg write SetOffMsg;
    property OffMsg_: String read GetOffMsg_ write SetOffMsg_;
    property AlarmLocalMsg[Index: Integer]: boolean read GetAlarmLocalMsg write SetAlarmLocalMsg;
    property AlarmLocalMsg_: String read GetAlarmLocalMsg_ write SetAlarmLocalMsg_;
    property AlarmMsg[Index: Integer]: boolean read GetAlarmMsg write SetAlarmMsg;
    property AlarmMsg_: String read GetAlarmMsg_ write SetAlarmMsg_;
    property Logged[Index: Integer]: boolean read GetLogged write SetLogged;
    property Logged_: String read GetLogged_ write SetLogged_;
    property AlarmCond[Index: Integer]: TAlarmCase read GetAlarmCond write SetAlarmCond;
    property AlarmCond_: String read GetAlarmCond_ write SetAlarmCond_;
     property Typ[Index: Integer]: String read GetTyp write SetTyp;
    property Typ_: String read GetTyp_ write SetTyp_;
    property AlarmType[Index: Integer]: String read GetAlarmType write SetAlarmType;
    property AlarmType_: String read GetAlarmType_ write SetAlarmType_;
   // property Different[Index: Integer]: boolean read GetDiffer;
end;



function getTypIt(): TStringList;
function TypIttoInt(val: string): integer;
function InttoTypIt(val: integer): string;



implementation


function getTypIt(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('nodef');
 result.Add('часовой архив');
 result.Add('discret');
 result.Add('integer');
 result.Add('real');
 result.Add('smallint');
 result.Add('shortint');
 result.Add('word');
 result.Add('byte');
 result.Add('single');
 result.Add('real48');

end;

function getAlarmTypIt(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('нет');
 result.Add('тревога');
 result.Add('авария');

end;

function TypIttoInt(val: string): integer;
begin
 val:=trim(ansiuppercase(val));
 if (val='DISCRET') then result:=TYPE_DISCRET else
   if (val='INTEGER')then result:=TYPE_INTEGER else
     if (val='REAL')then result:=TYPE_DOUBLE else
        if (val='SMALLINT')then result:=TYPE_SMALLINT else
            if (val='SHORTINT')then result:=TYPE_SHORTINT else
               if (val='WORD')then result:=TYPE_WORD else
                   if (val='BYTE')then result:=TYPE_BYTE else
                        if (val='SINGLE')then result:=TYPE_SINGLE else
                          if (val='REAL48')then result:=TYPE_REAL48 else
                            if (val='ЧАСОВОЙ АРХИВ')then result:=REPORTTYPE_HOUR else
        result:=TYPE_NODEF;
end;

function AlarmTypIttoInt(val: string): integer;
begin
 val:=trim(AnsiLowerCase(val));
 if (val='нет') then result:=ALARMTYPE_NONE else
   if (val='тревога')then result:=ALARMTYPE_ALARM else
     if (val='авария')then result:=ALARMTYPE_AVAR else
        result:=-1;
end;

function InttoTypIt(val: integer): string;
begin
 case val of
 TYPE_DISCRET : result:='discret';
 TYPE_INTEGER: result:='integer';
 TYPE_DOUBLE: result:='real';
 TYPE_SMALLINT: result:='smallint';
 TYPE_SHORTINT: result:='shortint';
 TYPE_WORD: result:='word';
 TYPE_BYTE: result:='bite';
 TYPE_SINGLE: result:='single';
 TYPE_REAL48: result:='real48';
 REPORTTYPE_HOUR:  result:='часовой архив';
 else result:='nodef';

 end;
end;

function InttoAlarmTypIt(lev: integer; almsg: boolean ): string;
begin
 if (not almsg) then result:='нет'
 else
  begin
    if (lev>500) then result:='авария'
    else result:='тревога';
 end;
end;



procedure TRTItemWraper.setMap();
begin
         editor.Strings.Clear;
         if (getCount<2) then
         setPropertys('Тег',Name_);
         setPropertys('Комментарий',Comment_);
         setPropertys('Источник',Source_);
         setPropertys('Единицы контроллера min',MinRaw_);
         setPropertys('Единицы контроллера max',MaxRaw_);
         setPropertys('Единицы контроллера (мертвая зона)',DeadBaund_);
         setPropertys('Инженерные единицы min',MinEU_);
         setPropertys('Инженерные единицы max',MaxEU_);
         setPropertys('Инженерные единицы ',EU_);
         setPropertys('Сообщение о включении',OnMsg_,getBooleanList());
         setPropertys('Текст сообщения о включении',OnMsgStr_);
         setPropertys('Сообщение о выключении',OffMsg_,getBooleanList());
         setPropertys('Текст сообщения о выключении',OffMsgStr_);
         //setPropertys('Тревожное сообщение',AlarmLocalMsg_,getBooleanList());
        // setPropertys('Аварийное сообщение',AlarmMsg_,getBooleanList());
         setPropertys('Тип аварийности',AlarmType_,getAlarmTypIt);
         setPropertys('Текст тревожного сообщения',AlarmMsgStr_);
         setPropertys('Граничное значение тревоги',AlarmConst_);
         setPropertys('Условие граничного значения тревоги',AlarmCond_,getCondList());
         setPropertys('Архивирование',Logged_,getBooleanList());
         setPropertys('Мертвая зона архивирования',LogDB_);
         setPropertys('Тип',Typ_,getTypIt);
         setNew();

end;

function TRTItemWraper.checkCorrectname(val: string): string;
begin
  if ((trim(val)='')) then
     raise  Exception.Create('Тег не может быть пустым!');
   if not (TagIsCorrect_(trim(val))) then
     raise  Exception.Create('Некорректное имя: '+val+' !');
   if ((((ids[0]<>rtit.GetSimpleID(trim(val))) and not (rtit.GetSimpleID(trim(val))=-1)))) then
     raise  Exception.Create('Дублирование имен: '+val+' !');

end;


function TRTItemWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   {if ((trim(val)='') and (key=0)) then
     raise  Exception.Create('Тег не может быть пустым!');
   if ((key=0) and not TagIsCorrect_(trim(val))) then
     raise  Exception.Create('Некорректное имя: '+val+' !');
   if ((key=0) and ((ids[0]<>rtit.GetSimpleID(trim(val))) and not (rtit.GetSimpleID(trim(val))=-1))) then
     raise  Exception.Create('Дублирование имен: '+val+' !'); }
   //if ((key=0) and (getCount=1)) then checkCorrectname(val);
   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Comment_:=val;
   2: Source_:=val;
   3: MinRaw_:=val;
   4: MaxRaw_:=val;
   5: DeadBaund_:=val;
   6: MinEU_:=val;
   7: MaxEU_:=val;
   8: EU_:=val;
   9: OnMsg_:=val;
   10: OnMsgStr_:=val;
   11: OffMsg_:=val;
   12: OffMsgStr_:=val;
  // 13: AlarmLocalMsg_:=val;
   //14: AlarmMsg_:=val;
   13: AlarmType_:=val;
   14: AlarmMsgStr_:=val;
   15: AlarmConst_:=val;
   16: AlarmCond_:=val;
   17: Logged_:=val;
   18: LogDB_:=val;
   19: Typ_:=val;
   end;


end;




procedure TRTItemWraper.writetofile();
var i: integer;
begin
   for i:=0 to idscount-1 do
      rtIt.WriteToFile(ids[i]);
end;

constructor TRTItemWraper.create(rt: TanalogMems;le: TValueListEditor);
begin
  inherited create(le);
  rtIt:=rt;
end;

destructor TRTItemWraper.destroy;
begin

end;

procedure TRTItemWraper.setList(value: TList);
var i: integer;
    str: String;
begin
   SetLength(ids,value.Count);
   for i:=0 to value.Count-1 do
     begin
        str:=string(value.Items[i]^);
        ids[i]:=rtit.GetSimpleID(str);
     end;
   idscount:=value.Count;
end;


function TRTItemWraper.GetName(Index: Integer): String;
begin
    result:=rtit.GetName(ids[Index]);
end;

procedure TRTItemWraper.SetName(Index: Integer; value: String);
begin
   rtit.SetName(ids[Index],value);
end;


function TRTItemWraper.GetName_(): String;
var i: integer;
begin
     result:=Name[0];
        for i:=1 to idscount-1 do
         if (Name[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TRTItemWraper.SetName_( value: String);
var i: integer;
begin
   if ((getCount=1)) then checkCorrectname(value);
   for i:=0 to idscount-1 do
     Name[i]:=value;
end;

function TRTItemWraper.GetComment(Index: Integer): String;

begin
    result:=rtit.GetComment(ids[Index]);




end;

procedure TRTItemWraper.SetComment(Index: Integer; value: String);
begin
   rtit.SetComment(ids[Index],value);
end;


function TRTItemWraper.GetComment_(): String;
var i: integer;
    str: String;
begin
     result:=Comment[0];
     differ[0]:=false;
        for i:=1 to idscount-1 do
        begin
         str:=Comment[i];
         if (Comment[i]<>result) then
           begin
              result:='';
              differ[0]:=true;
           end;
           end;
end;

procedure TRTItemWraper.SetComment_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Comment[i]:=value;
end;

function TRTItemWraper.GetSource(Index: Integer): String;
begin
    result:=rtit.GetDDEItem(ids[Index]);
end;

procedure TRTItemWraper.SetSource(Index: Integer; value: String);
begin
   rtit.SetDDEItem(ids[Index],value);
end;


function TRTItemWraper.GetSource_(): String;
var i: integer;
begin
     result:=Source[0];
     differ[1]:=false;
        for i:=1 to idscount-1 do
         if (Source[i]<>result) then
           begin
              result:='';
              differ[1]:=true;
           end;
end;

procedure TRTItemWraper.SetSource_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Source[i]:=value;
end;

function TRTItemWraper.GetEU(Index: Integer): String;
begin
    result:=rtit.GetEU(ids[Index]);
end;

procedure TRTItemWraper.SetEU(Index: Integer; value: String);
begin
   rtit.SetEU(ids[Index],value);
end;


function TRTItemWraper.GetEU_(): String;
var i: integer;
begin
     result:=EU[0];
     differ[2]:=false;
        for i:=1 to idscount-1 do
         if (EU[i]<>result) then
           begin
              result:='';
              differ[2]:=true;
           end;
end;

procedure TRTItemWraper.SetEU_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     EU[i]:=value;
end;

function TRTItemWraper.GetOnMsgStr(Index: Integer): String;
begin
    result:=rtit.GetOnMsg(ids[Index]);
end;

procedure TRTItemWraper.SetOnMsgStr(Index: Integer; value: String);
begin
   rtit.SetOnMsg(ids[Index],value);
end;


function TRTItemWraper.GetOnMsgStr_(): String;
var i: integer;
begin
     result:=OnMsgStr[0];
     differ[3]:=false;
        for i:=1 to idscount-1 do
         if (OnMsgStr[i]<>result) then
           begin
              result:='';
              differ[3]:=true;
           end;
end;

procedure TRTItemWraper.SetOnMsgStr_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     OnMsgStr[i]:=value;
end;

function TRTItemWraper.GetOffMsgStr(Index: Integer): String;
begin
    result:=rtit.GetOffMsg(ids[Index]);
end;

procedure TRTItemWraper.SetOffMsgStr(Index: Integer; value: String);
begin
   rtit.SetOffMsg(ids[Index],value);
end;


function TRTItemWraper.GetOffMsgStr_(): String;
var i: integer;
begin
     result:=OffMsgStr[0];
     differ[4]:=false;
        for i:=1 to idscount-1 do
         if (OffMsgStr[i]<>result) then
           begin
              result:='';
              differ[4]:=true;
           end;
end;

procedure TRTItemWraper.SetOffMsgStr_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     OffMsgStr[i]:=value;
end;

function TRTItemWraper.GetAlarmMsgStr(Index: Integer): String;
begin
    result:=rtit.GetAlarmMsg(ids[Index]);

end;

procedure TRTItemWraper.SetAlarmMsgStr(Index: Integer; value: String);
begin
   rtit.SetAlarmMsg(ids[Index],value);
end;


function TRTItemWraper.GetAlarmMsgStr_(): String;
var i: integer;
begin
     result:=AlarmMsgStr[0];
     differ[5]:=false;
        for i:=1 to idscount-1 do
         if (AlarmMsgStr[i]<>result) then
           begin
              result:='';
              differ[5]:=true;
           end;
end;

procedure TRTItemWraper.SetAlarmMsgStr_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     AlarmMsgStr[i]:=value;
end;


function TRTItemWraper.GetMinRaw(Index: Integer): single;
begin
    result:=rtit[ids[Index]].MinRaw;

end;

procedure TRTItemWraper.SetMinRaw(Index: Integer; value: single);
begin
   rtit[ids[Index]].MinRaw:=value;
end;


function TRTItemWraper.GetMinRaw_(): String;
var i: integer;
begin
     result:=floattostr(MinRaw[0]);
     differ[6]:=false;
        for i:=1 to idscount-1 do
         if (floattostr(MinRaw[i])<>result) then
           begin
              result:='';
              differ[6]:=true;
           end;
end;

procedure TRTItemWraper.SetMinRaw_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     MinRaw[i]:=StrToFloat(value);
    except

    end;
end;

function TRTItemWraper.GetMaxRaw(Index: Integer): single;
begin
    result:=rtit[ids[Index]].MaxRaw;

end;

procedure TRTItemWraper.SetMaxRaw(Index: Integer; value: single);
begin
   rtit[ids[Index]].MaxRaw:=value;
end;


function TRTItemWraper.GetMaxRaw_(): String;
var i: integer;
begin
     result:=floattostr(MaxRaw[0]);
     differ[7]:=false;
        for i:=1 to idscount-1 do
         if (floattostr(MaxRaw[i])<>result) then
           begin
              result:='';
              differ[7]:=true;
           end;
end;

procedure TRTItemWraper.SetMaxRaw_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     MaxRaw[i]:=StrToFloat(value);
    except

    end;
end;

function TRTItemWraper.GetVal(Index: Integer): real;
begin
    result:=rtit[ids[Index]].ValReal;

end;

procedure TRTItemWraper.SetVal(Index: Integer; value: real);
begin
   rtit[ids[Index]].ValReal:=value;
end;


function TRTItemWraper.GetVal_(): String;
var i: integer;
begin
     result:=floattostr(Val[0]);
     differ[19]:=false;
        for i:=1 to idscount-1 do
         if (floattostr(Val[i])<>result) then
           begin
              result:='';
              differ[19]:=true;
           end;
end;

procedure TRTItemWraper.SetVal_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     Val[i]:=StrToFloat(value);
    except

    end;
end;

function TRTItemWraper.GetMinEU(Index: Integer): single;
begin
    result:=rtit[ids[Index]].MinEU;

end;

procedure TRTItemWraper.SetMinEU(Index: Integer; value: single);
begin
   rtit[ids[Index]].MinEU:=value;
end;


function TRTItemWraper.GetMinEU_(): String;
var i: integer;
begin
     result:=floattostr(MinEU[0]);
     differ[8]:=false;
        for i:=1 to idscount-1 do
         if (floattostr(MinEU[i])<>result) then
           begin
              result:='';
              differ[8]:=true;
           end;
end;

procedure TRTItemWraper.SetMinEU_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     MinEU[i]:=StrToFloat(value);
    except

    end;
end;

function TRTItemWraper.GetMaxEU(Index: Integer): single;
begin
    result:=rtit[ids[Index]].MaxEU;

end;

procedure TRTItemWraper.SetMaxEU(Index: Integer; value: single);
begin
   rtit[ids[Index]].MaxEU:=value;
end;


function TRTItemWraper.GetMaxEU_(): String;
var i: integer;
begin
     result:=floattostr(MaxEU[0]);
     differ[9]:=false;
        for i:=1 to idscount-1 do
         if (floattostr(MaxEU[i])<>result) then
           begin
              result:='';
              differ[9]:=true;
           end;
end;

procedure TRTItemWraper.SetMaxEU_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     MaxEU[i]:=StrToFloat(value);
    except

    end;
end;

function TRTItemWraper.GetAlarmConst(Index: Integer): single;
begin
    result:=rtit[ids[Index]].AlarmConst;

end;

procedure TRTItemWraper.SetAlarmConst(Index: Integer; value: single);
begin
   rtit[ids[Index]].AlarmConst:=value;

end;


function TRTItemWraper.GetAlarmConst_(): String;
var i: integer;
begin
     result:=floattostr(AlarmConst[0]);
     differ[10]:=false;
        for i:=1 to idscount-1 do
         if (floattostr(AlarmConst[i])<>result) then
           begin
              result:='';
              differ[10]:=true;
           end;
end;

procedure TRTItemWraper.SetAlarmConst_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     AlarmConst[i]:=StrToFloat(value);
    except

    end;
end;

 function TRTItemWraper.GetDeadBaund(Index: Integer): real;
begin
  //  result:=rtit[ids[Index]].DeadBaund;
    result:=0;
end;

procedure TRTItemWraper.SetDeadBaund(Index: Integer; value: real);
begin
  // rtit[ids[Index]].DeadBaund:=value;

end;


function TRTItemWraper.GetDeadBaund_(): String;
var i: integer;
begin
     result:=floattostr(DeadBaund[0]);
     differ[11]:=false;
        for i:=1 to idscount-1 do
         if (floattostr(DeadBaund[i])<>result) then
           begin
              result:='';
              differ[11]:=true;
           end;
end;

procedure TRTItemWraper.SetDeadBaund_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     DeadBaund[i]:=StrToFloat(value);
    except

    end;
end;

function TRTItemWraper.GetLogDB(Index: Integer): real;
begin
    result:=rtit[ids[Index]].LogDB;

end;

procedure TRTItemWraper.SetLogDB(Index: Integer; value: real);
begin
   rtit[ids[Index]].LogDB:=value;

end;


function TRTItemWraper.GetLogDB_(): String;
var i: integer;
begin
     result:=floattostr(LogDB[0]);
     differ[12]:=false;
        for i:=1 to idscount-1 do
         if (floattostr(LogDB[i])<>result) then
           begin
              result:='';
              differ[12]:=true;
           end;
end;

procedure TRTItemWraper.SetLogDB_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     LogDB[i]:=StrToFloat(value);
    except

    end;
end;

function TRTItemWraper.GetLogTime(Index: Integer): integer;
begin
    result:=rtit[ids[Index]].LogTime;

end;

procedure TRTItemWraper.SetLogTime(Index: Integer; value: integer);
begin
   rtit[ids[Index]].LogTime:=value;

end;


function TRTItemWraper.GetLogTime_(): String;
var i: integer;
begin
     result:=inttostr(LogTime[0]);
     differ[13]:=false;
        for i:=1 to idscount-1 do
         if (inttostr(LogTime[i])<>result) then
           begin
              result:='';
              differ[13]:=false;
           end;
end;

procedure TRTItemWraper.SetLogTime_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     LogTime[i]:=StrToInt(value);
    except

    end;
end;

function TRTItemWraper.GetPreTime(Index: Integer): integer;
begin
    result:=rtit[ids[Index]].PreTime;

end;

procedure TRTItemWraper.SetPreTime(Index: Integer; value: integer);
begin
   rtit[ids[Index]].PreTime:=value;

end;


function TRTItemWraper.GetPreTime_(): String;
var i: integer;
begin
     result:=inttostr(PreTime[0]);
     differ[13]:=false;
        for i:=1 to idscount-1 do
         if (inttostr(PreTime[i])<>result) then
           begin
              result:='';
              differ[13]:=false;
           end;
end;

procedure TRTItemWraper.SetPreTime_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     PreTime[i]:=StrToInt(value);
    except

    end;
end;

function TRTItemWraper.GetOnMsg(Index: Integer): boolean;
begin
    result:=rtit[ids[Index]].OnMsged;

end;

procedure TRTItemWraper.SetOnMsg(Index: Integer; value: boolean);
begin
   rtit[ids[Index]].OnMsged:=value;

end;


function TRTItemWraper.GetOnMsg_(): String;
var i: integer;
begin
     result:=getbooleanstr(OnMsg[0]);
     differ[14]:=false;
        for i:=1 to idscount-1 do
         if (getbooleanstr(OnMsg[i])<>result) then
           begin
              result:='';
              differ[14]:=true;
           end;
end;

procedure TRTItemWraper.SetOnMsg_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     OnMsg[i]:=getStrBoolean(value);
    except

    end;
end;

function TRTItemWraper.GetOffMsg(Index: Integer): boolean;
begin
    result:=rtit[ids[Index]].OffMsged;

end;

procedure TRTItemWraper.SetOffMsg(Index: Integer; value: boolean);
begin
   rtit[ids[Index]].OffMsged:=value;

end;


function TRTItemWraper.GetOffMsg_(): String;
var i: integer;
begin
     result:=getbooleanstr(OffMsg[0]);
      differ[15]:=false;
        for i:=1 to idscount-1 do
         if (getbooleanstr(OffMsg[i])<>result) then
           begin
              result:='';
              differ[15]:=true;
           end;
end;

procedure TRTItemWraper.SetOffMsg_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     OffMsg[i]:=getStrBoolean(value);
    except

    end;
end;

 function TRTItemWraper.GetAlarmMsg(Index: Integer): boolean;
begin
    result:=rtit[ids[Index]].AlarmLevel>500;

end;

procedure TRTItemWraper.SetAlarmMsg(Index: Integer; value: boolean);
begin
  if  (value) then rtit[ids[Index]].AlarmLevel:=999
  else  rtit[ids[Index]].AlarmLevel:=500;

end;


function TRTItemWraper.GetAlarmMsg_(): String;
var i: integer;
begin
     result:=getbooleanstr(AlarmMsg[0]);
     differ[16]:=false;
        for i:=1 to idscount-1 do
         if (getbooleanstr(AlarmMsg[i])<>result) then
           begin
              result:='';
              differ[16]:=true;
           end;
end;

procedure TRTItemWraper.SetAlarmMsg_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     AlarmMsg[i]:=getStrBoolean(value);
    except

    end;
end;


function TRTItemWraper.GetAlarmLocalMsg(Index: Integer): boolean;
begin
    result:=rtit[ids[Index]].AlarmedLocal;

end;

procedure TRTItemWraper.SetAlarmLocalMsg(Index: Integer; value: boolean);
begin
   rtit[ids[Index]].AlarmedLocal:=value;

end;


function TRTItemWraper.GetAlarmLocalMsg_(): String;
var i: integer;
begin

     result:=getbooleanstr(AlarmLocalMsg[0]);
     differ[17]:=false;
        for i:=1 to idscount-1 do
         if (getbooleanstr(AlarmLocalMsg[i])<>result) then
           begin
              result:='';
              differ[17]:=true;
           end;
end;

procedure TRTItemWraper.SetAlarmLocalMsg_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     AlarmLocalMsg[i]:=getStrBoolean(value);
    except

    end;
end;

function TRTItemWraper.GetLogged(Index: Integer): boolean;
begin
    result:=rtit[ids[Index]].Logged;

end;

procedure TRTItemWraper.SetLogged(Index: Integer; value: boolean);
begin
   rtit[ids[Index]].Logged:=value;

end;


function TRTItemWraper.GetLogged_(): String;
var i: integer;
begin
     result:=getbooleanstr(Logged[0]);
     differ[18]:=false;
        for i:=1 to idscount-1 do
         if (getbooleanstr(Logged[i])<>result) then
           begin
              result:='';
              differ[18]:=true;
           end;
end;

procedure TRTItemWraper.SetLogged_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     Logged[i]:=getStrBoolean(value);
    except

    end;
end;


function TRTItemWraper.GetAlarmCond(Index: Integer): TAlarmCase;
begin
    result:=rtit[ids[Index]].alarmCase;

end;

procedure TRTItemWraper.SetAlarmCond(Index: Integer; value: TAlarmCase);
begin
   rtit[ids[Index]].alarmCase:=value;

end;


function TRTItemWraper.GetAlarmCond_(): String;
var i: integer;
begin
     result:=getACstr(AlarmCond[0]);
     differ[19]:=false;
        for i:=1 to idscount-1 do
         if (getACstr(AlarmCond[i])<>result) then
           begin
              result:='';
              differ[19]:=true;
           end;
end;

procedure TRTItemWraper.SetAlarmCond_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     AlarmCond[i]:=getStrAC(value);
    except

    end;
end;

function TRTItemWraper.GetTyp(Index: Integer): String;
begin
    result:=InttoTypIt(LogTime[Index]);
end;

procedure TRTItemWraper.SetTyp(Index: Integer; value: String);
begin
   LogTime[Index]:=TypIttoInt(value);
end;


function TRTItemWraper.GetTyp_(): String;
var i: integer;
begin
     result:=Typ[0];
        for i:=1 to idscount-1 do
         if (Typ[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TRTItemWraper.SetTyp_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Typ[i]:=value;
end;


function TRTItemWraper.GetAlarmType(Index: Integer): String;
begin
    result:=InttoAlarmTypIt(rtit[ids[Index]].AlarmLevel,rtit[ids[Index]].AlarmedLocal);
end;


procedure TRTItemWraper.SetAlarmType(Index: Integer; value: String);
begin
   case AlarmTypIttoInt(value) of
     ALARMTYPE_NONE:
       begin
         rtit[ids[Index]].AlarmedLocal:=false;
         rtit[ids[Index]].AlarmLevel:=0;
       end;
     ALARMTYPE_ALARM:
       begin
         rtit[ids[Index]].AlarmedLocal:=true;
         rtit[ids[Index]].AlarmLevel:=500;
       end;
     ALARMTYPE_AVAR:
       begin
         rtit[ids[Index]].AlarmedLocal:=true;
         rtit[ids[Index]].AlarmLevel:=999;
       end;
    end;
end;

function TRTItemWraper.GetAlarmType_(): String;
var i: integer;
begin
     result:=AlarmType[0];
        for i:=1 to idscount-1 do
         if (AlarmType[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TRTItemWraper.SetAlarmType_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     AlarmType[i]:=value;
end;

end.
