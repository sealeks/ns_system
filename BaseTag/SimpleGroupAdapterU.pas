unit SimpleGroupAdapterU;

interface



uses
  Classes, ItemAdapterU, MemStructsU, SysUtils,Grids,GroupsU,ValEdit,globalValue;

type
  TGroupWraper = class  (TItemWraper)
    protected
     rtgr: TGroups;

     function checkcorrectname(val: string): string;

     function GetName(Index: Integer): String;
     procedure SetName(Index: Integer; value: String);
     function GetName_(): String;
     procedure SetName_(value: String);
     function GetApplication(Index: Integer): String;
     procedure SetApplication(Index: Integer; value: String);
     function GetApplication_(): String;
     procedure SetApplication_(value: String);
     function GetTopic(Index: Integer): String;
     procedure SetTopic(Index: Integer; value: String);
     function GetTopic_(): String;
     procedure SetTopic_(value: String);

     function GetSlave(Index: Integer): integer;
     procedure SetSlave(Index: Integer; value: integer);
     function GetSlave_(): String;
     procedure SetSlave_(value: String);
     function GetNum(Index: Integer): integer;
     procedure SetNum(Index: Integer; value: integer);
     function GetNum_(): String;
     procedure SetNum_(value: String);

    public
    procedure writetofile(); override;
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;
    constructor create(rt: TGroups;le: TValueListEditor);
    destructor destroy;
    procedure setType(); override;

    procedure setVal(key: String; value: String); override;
    procedure setList(value: TList); override;
    property Name[Index: Integer]: String read GetName write SetName;
    property Name_: String read GetName_ write SetName_;
    property Application[Index: Integer]: String read GetApplication write SetApplication;
    property Application_: String read GetApplication_ write SetApplication_;
    property Topic[Index: Integer]: String read GetTopic write SetTopic;
    property Topic_: String read GetTopic_ write SetTopic_;
    property Slave[Index: Integer]: integer read GetSlave write SetSlave;
    property Slave_: String read GetSlave_ write SetSlave_;
    property Num[Index: Integer]: integer read GetNum write SetNum;
    property Num_: String read GetNum_ write SetNum_;



end;









implementation


procedure TGroupWraper.setMap();
begin
         editor.Strings.Clear;
        /// setPropertys('N',Num_);
         if (getCount=1) then setPropertys('Имя',GetName_);
         setPropertys('Приложение',Application_);
         setPropertys('Тема',Topic_);
         setPropertys('Номер устройства',Slave_);
         setNew();
end;

function TGroupWraper.checkcorrectname(val: string): string;
begin
    if ((trim(val)='')) then
     raise  Exception.Create('Имя группы не может быть пустым!');
   if (((ids[0]<>rtgr.Idx[trim(val)]) and not (rtgr.Idx[trim(val)]=-1))) then
     raise  Exception.Create('Дублирование имен групп: '+val+' !');
   if (isSystemGroup(val)) then
     raise  Exception.Create('Системные группы создаются через контекстное меню: '+val+' !');

end;

function TGroupWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;


   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Application_:=val;
   2: Topic_:=val;
   3: Slave_:=val;

   end;


end;

procedure TGroupWraper.SetType;
var i: integer;
begin
  Application_:='';
  Topic_:='';
end;

procedure TGroupWraper.writetofile();
begin
 rtgr.SaveToFile(PathMem + 'groups.cfg');
end;



constructor TGroupWraper.create(rt: TGroups;le: TValueListEditor);
begin
  inherited create(le);
  rtgr:=rt;
end;

destructor TGroupWraper.destroy;
begin

end;

procedure TGroupWraper.setList(value: TList);
var i: integer;

begin
   SetLength(ids,value.Count);
   for i:=0 to value.Count-1 do
     begin
        ids[i]:=StrToInt(string(value.Items[i]^));
     end;
   idscount:=value.Count;
end;




procedure TGroupWraper.setVal(key: String; value: String);
begin

end;

function TGroupWraper.GetName(Index: Integer): String;
begin
    result:=rtgr.Items[ids[Index]].Name;

end;

procedure TGroupWraper.SetName(Index: Integer; value: String);
begin
   rtgr.Items[ids[Index]].Name:=value;
end;


function TGroupWraper.GetName_(): String;
var i: integer;
begin
     result:=Name[0];
        for i:=1 to idscount-1 do
         if (Name[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TGroupWraper.SetName_( value: String);
var i: integer;
begin
   checkcorrectname(value);
   for i:=0 to idscount-1 do
     Name[i]:=value;
end;

function TGroupWraper.GetApplication(Index: Integer): String;

begin
    result:=rtgr.Items[ids[Index]].App;




end;

procedure TGroupWraper.SetApplication(Index: Integer; value: String);
begin
   rtgr.Items[ids[Index]].App:=value;
end;


function TGroupWraper.GetApplication_(): String;
var i: integer;
    str: String;
begin
     result:=Application[0];
     differ[0]:=false;
        for i:=1 to idscount-1 do
        begin
         str:=Application[i];
         if (Application[i]<>result) then
           begin
              result:='';
              differ[0]:=true;
           end;
           end;
end;

procedure TGroupWraper.SetApplication_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Application[i]:=value;
end;

function TGroupWraper.GetTopic(Index: Integer): String;
begin
    result:=rtgr.Items[ids[Index]].Topic;
end;

procedure TGroupWraper.SetTopic(Index: Integer; value: String);
begin
   rtgr.Items[ids[Index]].Topic:=value;
end;


function TGroupWraper.GetTopic_(): String;
var i: integer;
begin
     result:=Topic[0];
     differ[1]:=false;
        for i:=1 to idscount-1 do
         if (Topic[i]<>result) then
           begin
              result:='';
              differ[1]:=true;
           end;
end;

procedure TGroupWraper.SetTopic_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Topic[i]:=value;
end;



function TGroupWraper.GetSlave(Index: Integer): integer;
begin
    result:=rtgr.Items[ids[Index]].SlaveNum;

end;

procedure TGroupWraper.SetSlave(Index: Integer; value: integer);
begin
   rtgr.Items[ids[Index]].SlaveNum:=value;

end;


function TGroupWraper.GetSlave_(): String;
var i: integer;
begin
     result:=inttostr(Slave[0]);
     differ[13]:=false;
        for i:=1 to idscount-1 do
         if (inttostr(Slave[i])<>result) then
           begin
              result:='';
              differ[13]:=false;
           end;
end;

procedure TGroupWraper.SetSlave_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     Slave[i]:=StrToInt(value);
    except

    end;
end;

function TGroupWraper.GetNum(Index: Integer): integer;
begin
    result:=rtgr.Items[ids[Index]].Num;

end;

procedure TGroupWraper.SetNum(Index: Integer; value: integer);
begin
   rtgr.Items[ids[Index]].Num:=value;

end;


function TGroupWraper.GetNum_(): String;
var i: integer;
begin
     result:=inttostr(Num[0]);
     differ[13]:=false;
        for i:=1 to idscount-1 do
         if (inttostr(Num[i])<>result) then
           begin
              result:='';
              differ[13]:=false;
           end;
end;

procedure TGroupWraper.SetNum_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
    try
     Num[i]:=StrToInt(value);
    except

    end;
end;




end.
