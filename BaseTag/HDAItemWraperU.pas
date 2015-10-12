unit HDAItemWraperU;

interface

uses
  Classes,SimpleItemAdapterU, SysUtils,MemStructsU,ItemAdapterU;



type
  THDAItemWraper = class(TRTItemWraper)
  private
    { Private declarations }
    function GetTyp(Index: Integer): String;
    procedure SetTyp(Index: Integer; value: String);
    function GetTyp_(): String;
    procedure SetTyp_(value: String);
    function GetDelt(Index: Integer): string;
    procedure SetDelt(Index: Integer; value: string);
    function GetDelt_(): String;
    procedure SetDelt_(value: String);
  protected
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;
    property Typ[Index: Integer]: String read GetTyp write SetTyp;
    property Typ_: String read GetTyp_ write SetTyp_;
    property Delt[Index: Integer]: string read GetDelt write SetDelt;
    property Delt_: String read GetDelt_ write SetDelt_;
  end;

implementation



procedure THDAItemWraper.setMap();
begin
         editor.Strings.Clear;
         if (getCount<2) then
         setPropertys('Тег',Name_);
         setPropertys('Комментарий',Comment_);
         setPropertys('Источник',Source_);
         setPropertys('Период ',Typ_,getTypRSL);
         setPropertys('Глубина опроса в периодах(инициализация)',LogDB_);
         setPropertys('Cмещение подведения итога(подпериод)',Delt_);
         setPropertys('Инженерные единицы min',MinEU_);
         setPropertys('Инженерные единицы max',MaxEU_);
         setPropertys('Инженерные единицы ',EU_);


         setNew();

end;


function THDAItemWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   if ((trim(val)='') and (key=0)) then exit;
   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Comment_:=val;
   2: Source_:=val;
   3: Typ_:=val;

   4: LogDB_:=val;
   5: Delt_:=val;
   6: MinEU_:=val;
   7: MaxEU_:=val;
   8: EU_:=val;



   end;


end;

function THDAItemWraper.GetTyp(Index: Integer): String;
begin
    result:=InttoTypR(LogTime[Index]);
end;

procedure THDAItemWraper.SetTyp(Index: Integer; value: String);
begin
   LogTime[Index]:=TypRtoInt(value);
end;


function THDAItemWraper.GetTyp_(): String;
var i: integer;
begin
     result:=Typ[0];
        for i:=1 to idscount-1 do
         if (Typ[i]<>result) then
           begin
              result:='';
           end;
end;

procedure THDAItemWraper.SetTyp_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
          begin
     Typ[i]:=value;
     SetAlarmLocalMsg(i,false);
     SetAlarmMsg(i,false);
     end;
end;

function THDAItemWraper.GetDelt(Index: Integer): String;
begin
    result:=inttostr(round(AlarmConst[Index]));
end;

procedure THDAItemWraper.SetDelt(Index: Integer; value: String);
begin
   AlarmConst[Index]:=strtointdef(value,round(AlarmConst[Index]));
end;


function THDAItemWraper.GetDelt_(): String;
var i: integer;
begin
     result:=Delt[0];
        for i:=1 to idscount-1 do
         if (Delt[i]<>result) then
           begin
              result:='';
           end;
end;

procedure THDAItemWraper.SetDelt_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Delt[i]:=value;
end;

end.
