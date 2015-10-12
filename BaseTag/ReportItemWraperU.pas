unit ReportItemWraperU;

interface

uses
  Classes,SimpleItemAdapterU, SysUtils,MemStructsU,FormVarSelectU,Windows,ItemAdapterU;



type
  TReportItemWraper = class(TRTItemWraper)
  private
    { Private declarations }
    function GetTyp(Index: Integer): String;
    procedure SetTyp(Index: Integer; value: String);
    function GetTyp_(): String;
    procedure SetTyp_(value: String);
    function GetAGR(Index: Integer): String;
    procedure SetAGR(Index: Integer; value: String);
    function GetAGR_(): String;
    procedure SetAGR_(value: String);
    function GetDelt(Index: Integer): string;
    procedure SetDelt(Index: Integer; value: string);
    function GetDelt_(): String;
    procedure SetDelt_(value: String);

  protected
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;
    property Typ[Index: Integer]: String read GetTyp write SetTyp;
    property Typ_: String read GetTyp_ write SetTyp_;
    property AGR[Index: Integer]: String read GetAGR write SetAGR;
    property AGR_: String read GetAGR_ write SetAGR_;
    property Delt[Index: Integer]: string read GetDelt write SetDelt;
    property Delt_: String read GetDelt_ write SetDelt_;
    procedure GetTagSours(Sender: TObject);
  end;

implementation



procedure TReportItemWraper.setMap();
begin
         editor.Strings.Clear;
         if (getCount<2) then
         setPropertys('Тег',Name_);
         setPropertys('Комментарий',Comment_);
         setPropertys('Источник',Source_,GetTagSours);
         setPropertys('Период ',Typ_,getTypRSL);
         setPropertys('Стат. характеристика ',AGR_,getTypAGRSL);

         setPropertys('Глубина опроса в периодах(инициализация)',LogDB_);
         setPropertys('Cмещение подведения итога(подпериод)',Delt_);
         //setPropertys('Единицы контроллера (мертвая зона)',DeadBaund_);
         setPropertys('Инженерные единицы min',MinEU_);
         setPropertys('Инженерные единицы max',MaxEU_);
         setPropertys('Инженерные единицы ',EU_);


         setNew();

end;

procedure TReportItemWraper.GetTagSours(Sender: TObject);
var str: string;
    row: integer;
begin
   row:=2;
   if (Typ_=InttoTypIt(0)) then
     begin
      MessageBox(0,PChar('Период должен быть определен!!!'),'Сообщение',
                 MB_OK+MB_TOPMOST+MB_ICONWARNING);
                  exit;
     end;
  if (getCount>1) then row:=1;
   with TFormVarSelect.Create(nil)  do
    try
        if Exec(str,self.rtIt,strtointdef(Logtime_,0)) then
          begin
           // Source_:=str;
            editor.Values['Источник']:=str;
            self.ValueListEditorEdit(nil,1,row,str);
            editor.Update;
          end;
    finally
      free;
    end;

end;


function TReportItemWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Comment_:=val;
   2: Source_:=val;
   3: Typ_:=val;
   4: AGR_:=val;
   5: LogDB_:=val;
   6: Delt_:=val;
   7: MinEU_:=val;
   8: MaxEU_:=val;
   9: EU_:=val;



   end;


end;

function TReportItemWraper.GetTyp(Index: Integer): String;
begin
    result:=InttoTypR(LogTime[Index]);
end;

procedure TReportItemWraper.SetTyp(Index: Integer; value: String);
begin
   LogTime[Index]:=TypRtoInt(value);
end;


function TReportItemWraper.GetTyp_(): String;
var i: integer;
begin
     result:=Typ[0];
        for i:=1 to idscount-1 do
         if (Typ[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TReportItemWraper.SetTyp_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     begin
     Typ[i]:=value;
     SetAlarmLocalMsg(i,false);
     SetAlarmMsg(i,false);
     end;
end;

function TReportItemWraper.GetAGR(Index: Integer): String;
begin
    result:=InttoTypAGR(PreTime[Index]);
end;

procedure TReportItemWraper.SetAGR(Index: Integer; value: String);
begin
   PreTime[Index]:=TypAGRtoInt(value);
end;


function TReportItemWraper.GetAGR_(): String;
var i: integer;
begin
     result:=AGR[0];
        for i:=1 to idscount-1 do
         if (AGR[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TReportItemWraper.SetAGR_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     AGR[i]:=value;
end;


function TReportItemWraper.GetDelt(Index: Integer): String;
begin
    result:=inttostr(round(AlarmConst[Index]));
end;

procedure TReportItemWraper.SetDelt(Index: Integer; value: String);
begin
   AlarmConst[Index]:=strtointdef(value,round(AlarmConst[Index]));
end;


function TReportItemWraper.GetDelt_(): String;
var i: integer;
begin
     result:=Delt[0];
        for i:=1 to idscount-1 do
         if (Delt[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TReportItemWraper.SetDelt_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Delt[i]:=value;
end;

end.
