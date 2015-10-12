unit ItemAdapterU;

interface

uses
  Classes,ValEdit,Grids,MemStructsU,SysUtils,Controls, ConstDef;


type
  TItemWraper = class
    protected
     editor:  TValueListEditor;
     differ: array[0..1000] of boolean;
     control: TControl;
    public
    
    changes: array[0..1000] of boolean;
    oldstr: array[0..1000] of string;
    newstr: array[0..1000] of string;
    rowcount: integer;
    ids: array of integer;
    idscount: integer;

    procedure    ValueListEditorEdit(Sender: TObject; ACol,
    ARow: Integer; const Value: String);
    procedure    setMap(); virtual;
    function     getCount(): integer;
    function     getVal(key: String; var dif: boolean): String;  virtual;
    procedure    setVal(key: String; value: String); virtual;
    procedure    setList(value: TList); virtual;
    procedure    setType();  virtual;
    function     save(): string;   virtual;
    procedure    setNew();
    constructor  create(le: TValueListEditor);
    procedure    setPropertys( name: string; value: string;   list: TStringList); overload;
    procedure    setPropertys( name: string; value: string); overload;
    function     setchange(key: integer; val: string): string; virtual;
    procedure    setControl(observer: TControl);
    procedure    setEnabled(value: boolean);
    procedure    writetofile(); virtual;
    procedure    setPropertys(name: string; value: string; readOnly: boolean);  overload;
    procedure    setPropertys(name: string; value: string;  NI: TNotifyEvent); overload;
   end;





   function getbooleanstr(val: boolean): String;
   function getstrboolean(val: string): boolean;
   function getACstr(val: TAlarmCase): String;
   function getstrAC(val: string): TAlarmCase;
   function getCondList: TStringList;
   function getNASL(): TStringList;
   function getBooleanList(): TStringList;
   function getNAtoStr(val: boolean): string;
   function getstrToNA(val: string): boolean;
   function tagisCorrect_(val: string): boolean;
   function TypRtoInt(val: string): integer;
   function InttoTypR(val: integer): string;
   function getTypAGRSL(): TStringList;
   function TypAGRtoInt(val: string): integer;
   function InttoTypAGR(val: integer): string;
   function getTypRSL(): TStringList;

implementation


function getTypRSL(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('не определено');
 result.Add('минутные');
 result.Add('10минутные');
 result.Add('30минутные');
 result.Add('часовые');
 result.Add('суточные');
 result.Add('декадные');
 result.Add('месячные');
 result.Add('квартальные');
 result.Add('годовые');
end;

function TypRtoInt(val: string): integer;
begin
 val:=trim(ansiuppercase(val));
 if (val='МИНУТНЫЕ') then result:=REPORTTYPE_MIN else
 if (val='10МИНУТНЫЕ') then result:=REPORTTYPE_10MIN else
 if (val='30МИНУТНЫЕ') then result:=REPORTTYPE_30MIN else
 if (val='ЧАСОВЫЕ') then result:=REPORTTYPE_HOUR else
   if (val='СУТОЧНЫЕ')then result:=REPORTTYPE_DAY else
     if (val='ДЕКАДНЫЕ')then result:=REPORTTYPE_DEC else
       if (val='МЕСЯЧНЫЕ')then result:=REPORTTYPE_MONTH else
        if (val='КВАРТАЛЬНЫЕ')then result:=REPORTTYPE_QVART else
         if (val='ГОДОВЫЕ')then result:=REPORTTYPE_YEAR else
        result:=-1;
end;

function InttoTypR(val: integer): string;
begin
 case val of
 REPORTTYPE_MIN : result:='минутные';
 REPORTTYPE_10MIN : result:='10минутные';
 REPORTTYPE_30MIN : result:='30минутные';
 REPORTTYPE_HOUR : result:='часовые';
 REPORTTYPE_DAY   : result:='суточные';
 REPORTTYPE_DEC   : result:='декадные';
 REPORTTYPE_MONTH : result:='месячные';
 REPORTTYPE_QVART   : result:='квартальные';
 REPORTTYPE_YEAR : result:='годовые';
 else result:='не определено';

 end;
end;

function getTypAGRSL(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('не определено');
 result.Add('интеграл');
 result.Add('среднее');
 result.Add('минимум');
 result.Add('максимум');
 result.Add('СКО');
end;


function TypAGRtoInt(val: string): integer;
begin
 val:=trim(ansiuppercase(val));
 if (val='ИНТЕГРАЛ') then result:=REPORTAGR_INTEG else
   if (val='СРЕДНЕЕ')then result:=REPORTAGR_MID else
     if (val='МИНИМУМ')then result:=REPORTAGR_MIN else
        if (val='МАКСИМУМ')then result:=REPORTTYPE_MAX else
          if (val='СКО')then result:=REPORTTYPE_SCO else
        result:=-1;
end;

function InttoTypAGR(val: integer): string;
begin
 case val of
 REPORTAGR_INTEG : result:='интеграл';
 REPORTAGR_MID   : result:='среднее';
 REPORTAGR_MIN : result:='минимум';
 REPORTTYPE_MAX : result:='максимум';
 REPORTTYPE_SCO : result:='СКО';
 else result:='не определено';

 end;
end;



function tagisCorrect_(val: string): boolean;
var  first: char;
     i: integer;
begin
result:=false;
val:=trim(val);
val:=ansiuppercase(val);
if length(val)=0 then exit;
first:=val[1];
if not (first in  ['A'..'Z','@','%','$','&','_', char('А')..char('Я')]) then exit;
for i:=2 to length(val) do
  if not (val[i]  in  ['A'..'Z','@','%','$','&','_','0'..'9',char('А')..char('Я')]) then exit;
  result:=true;
end;

function getbooleanstr(val: boolean): String;
begin
  result:='да';
  if (not val) then result:='нет';
end;

function getstrboolean(val: string): boolean;
begin
  if (trim(AnsiUpperCase(val))='ДА') then result:=true
  else
    begin
    if (trim(AnsiUpperCase(val))='HET') then result:=false
    else result:=false;
    end;
end;

function getACstr(val: TAlarmCase): String;
begin
  result:='<';
  if (val=alarmMore) then result:='>';
  if (val=alarmEqual) then result:='=';
end;

function getstrAC(val: string): TAlarmCase;
begin
  if (trim(UpperCase(val))='>') then result:=alarmMore
  else

    if (trim(UpperCase(val))='<') then result:=alarmLess
    else result:=alarmEqual;

end;

function getCondList: TStringList;
begin
   result:=TStringList.Create;
   result.Add('>');
   result.Add('<');
   result.Add('=');

end;

function getNASL(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('синхронный');
 result.Add('aсинхронный');
end;

function getBooleanList(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('да');
 result.Add('нет');
end;

function getNAtoStr(val: boolean): string;
begin
 result:='асинхронный';
 if val then result:='синхронный'
end;

function getstrToNA(val: string): boolean;
begin
 result:=false;
 if (trim(uppercase(val))=uppercase('синхронный')) then result:=true;
end;


constructor TItemWraper.create(le: TValueListEditor);
begin

    editor:=le;
end;





procedure   TItemWraper.setMap();
begin
end;

function TItemWraper.setchange(key: integer; val: string): string;
begin
end;

procedure TItemWraper.setPropertys(name: string; value: string;   list: TStringList);
begin
   setPropertys(name,value);
   editor.ItemProps[editor.Strings.Count-1].EditStyle:=esPickList;
   editor.ItemProps[editor.Strings.Count-1].PickList:=list;
   editor.ItemProps[editor.Strings.Count-1].ReadOnly:=false;
end;

procedure TItemWraper.setPropertys(name: string; value: string;  NI: TNotifyEvent);
begin
   setPropertys(name,value);
   editor.ItemProps[editor.Strings.Count-1].EditStyle:=esEllipsis;
   editor.ItemProps[editor.Strings.Count-1].ReadOnly:=false;
   editor.OnEditButtonClick:=NI;
end;

procedure TItemWraper.setPropertys(name: string; value: string);
begin

 editor.InsertRow(name,value,true);
 editor.ItemProps[editor.Strings.Count-1].EditStyle:=esSimple;
 editor.ItemProps[editor.Strings.Count-1].ReadOnly:=false;
end;

procedure TItemWraper.setPropertys(name: string; value: string; readOnly: boolean);
begin

 editor.InsertRow(name,value,true);
  editor.ItemProps[editor.Strings.Count-1].EditStyle:=esSimple;
 editor.ItemProps[editor.Strings.Count-1].ReadOnly:=readOnly;
end;

procedure TItemWraper.setList(value: TList);
begin

end;

function TItemWraper.getVal(key: String; var dif: boolean): String;
begin

end;

procedure TItemWraper.setVal(key: String; value: String);
begin

end;

function TItemWraper.getCount(): integer;
begin
   result:=idscount;
end;

procedure   TItemWraper.setType();
begin
end;


procedure   TItemWraper.setNew();
var i: integer;
begin
    editor.Refresh;
    editor.OnSetEditText:=self.ValueListEditorEdit;
    for i:=0 to 999 do changes[i]:=false;
    for i:=0 to editor.RowCount-1 do
     begin
       oldstr[i]:=editor.Cells[1,i];
       newstr[i]:=oldstr[i];
     end;
    rowcount:=editor.RowCount;
    setEnabled(false);

end;

procedure TItemWraper.ValueListEditorEdit(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
  var i: integer;
begin
     if (ACol=1) then
        begin
            if (Value<>newstr[ARow]) then
              begin
                newstr[ARow]:=Value;
                if (newstr[ARow]<>oldstr[ARow]) then
                changes[ARow]:=true
                else
                changes[ARow]:=false;
              end;
     end;
     // проверяем были ли изменения
    // setEnabled(false);
     for i:=0 to rowcount-1 do
     begin
        if (changes[ARow]) then
          begin
            setEnabled(true);
            exit;
          end;
     end;
end;

function  TItemWraper.save(): string;
var i: integer;
    tempstr: string;
begin
   try
   result:='';
   for i:=0 to rowcount-1 do
     begin
       if changes[i] then
         begin
         tempstr:=setchange(i,newstr[i]);
         if (tempstr<>'')  then result:=tempstr;
         end;
     end;
   writetofile();
   finally
   SetMap;
   end;
end;

procedure TItemWraper.setControl(observer: TControl);
begin
   control:=observer;
end;

procedure TItemWraper.setEnabled(value: boolean);
begin
   if (control<>nil) then
    control.Enabled:=value;
end;

procedure TItemWraper.writetofile();
begin

end;

end.
 