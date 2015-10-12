unit HDAGroupAdapterU;

interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,ItemAdapterU,FormHDAClientUE;

type
THDAGroupWraper = class (TGroupWraper)
    protected
     function getTopic_conf( TA: integer;HR: integer;MR: integer;Na: boolean): string;
     function getApplication_conf( value: string): string;
     function GetServer(Index: Integer): String;
     procedure SetServer(Index: Integer; value: String);
     function GetServer_(): String;
     procedure SetServer_(value: String);
     function GetTimeout(Index: Integer): integer;
     procedure SetTimeout(Index: Integer; value: integer);
     function GetTimeout_(): String;
     procedure SetTimeout_(value: String);
     function GetH(Index: Integer): integer;
     procedure SetH(Index: Integer; value: integer);
     function GetH_(): String;
     procedure SetH_(value: String);
     function GetM(Index: Integer): integer;
     procedure SetM(Index: Integer; value: integer);
     function GetM_(): String;
     procedure SetM_(value: String);
     function GetN(Index: Integer): boolean;
     procedure SetN(Index: Integer; value: boolean);
     function GetN_(): String;
     procedure SetN_(value: String);


    public
    function setchange(key: integer; val: string): string;  override;
    procedure setType();  override;
    procedure setMap();   override;
    property Server[Index: Integer]: String read GetServer write SetServer;
    property Server_: String read GetServer_ write SetServer_;
    property Timeout[Index: Integer]: integer read GetTimeout write SetTimeout;
    property Timeout_: String read GetTimeout_ write SetTimeout_;
    property H[Index: Integer]: integer read GetH write SetH;
    property H_: String read GetH_ write SetH_;
    property M[Index: Integer]: integer read GetM write SetM;
    property M_: String read GetM_ write SetM_;
    property N[Index: Integer]: boolean read GetN write SetN;
    property N_: String read GetN_ write SetN_;
end;




var TA: integer;
    HR: integer;
    MR: integer;
    Nadv: boolean;



implementation

//      Topic= Tnn/Hnn/Mnn/N
//       Tnn  таймаут транзакции запроса
//       Hnn  Правая граница диапазона часового цикла опроса (мин)
//       Mnn  Правая граница диапазона минутного цикла опроса (cek)
//       N -синхронный опрос ( по умолчанию асинхронный)











procedure THDAGroupWraper.setMap();
begin

         editor.Strings.Clear;
         setPropertys('Имя',GetName_);
         setPropertys('Сервер OPC',Server_);
         setPropertys('Таймаут запроса',GetTimeout_);
         setPropertys('Правая граница диапазона часового цикла опроса (мин)',GetH_);
         setPropertys('Правая граница диапазона минутного цикла опроса (cek)',GetM_);
         setPropertys('Интерфейс',GetN_,getNASL);
         setPropertys('Номер потока',Slave_);
         setPropertys('Приложение','NS_OPCHDAbridgeService.exe/NS_OPCHDAbridgeService_app.exe',true);
         setNew();


end;

function THDAGroupWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;


   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Server_:=val;
   2: Timeout_:=val;
   3: H_:=val;
   4: M_:=val;
   5: N_:=val;
   6: Slave_:=val;


   end;


end;


procedure THDAGroupWraper.SetType;
var i: integer;
begin
  Application_:='OPC_HDA[FooServer]';
end;

function THDAGroupWraper.GetServer(Index: Integer): String;
function getServname(val: string): string;
var valt: string;
begin
   result:='Ошибка в определении';
   valt:=uppercase(val);
   if  (pos('OPC_HDA[',valt)>0) then
    begin
       val:=rightstr( val,length(val)-(8+pos('OPC_HDA[',valt)-1));
       if (pos(']',val)>0)  then
         begin
           val:=leftstr( val,pos(']',val)-1);
         end;
      result:=val;
    end;
end;
var str_temp: string;
begin
    str_temp:=trim((Application[index]));
    result:= getServname(str_temp);
end;

procedure THDAGroupWraper.SetServer(Index: Integer; value: String);
begin
   Application[index]:=getApplication_conf(value);
end;


function THDAGroupWraper.GetServer_(): String;
var i: integer;
begin
     result:=Server[0];
        for i:=1 to idscount-1 do
         if (Name[i]<>result) then
           begin
              result:='';
           end;
end;

procedure THDAGroupWraper.SetServer_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Server[i]:=value;
end;

function THDAGroupWraper.GetTimeout(Index: Integer): integer;
var int_temp: integer;
begin
    GetOPCHDAConfig(Topic[Index],TA,HR,MR,Nadv);
    result:= TA;
end;

procedure THDAGroupWraper.SetTimeout(Index: Integer; value: integer);
begin
     Topic[Index]:=getTopic_conf( value, H[Index], M[Index], N[Index]);
end;


function THDAGroupWraper.GetTimeout_(): String;
var i: integer;
begin
     result:=inttostr(Timeout[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Timeout[i])<>result) then
           begin
              result:='';
           end;
end;

procedure THDAGroupWraper.SetTimeout_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Timeout[i]:=strtoint(value);
end;

function THDAGroupWraper.GetH(Index: Integer): integer;
var int_temp: integer;
begin
    GetOPCHDAConfig(Topic[Index],TA,HR,MR,Nadv);
    result:= HR;
end;

procedure THDAGroupWraper.SetH(Index: Integer; value: integer);
begin
 Topic[Index]:=getTopic_conf(timeout[Index], value, M[Index], N[Index]);
end;


function THDAGroupWraper.GetH_(): String;
var i: integer;
begin
     result:=inttostr(H[0]);
        for i:=1 to idscount-1 do
         if (inttostr(H[i])<>result) then
           begin
              result:='';
           end;
end;

procedure THDAGroupWraper.SetH_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     H[i]:=strtoint(value);
end;


function THDAGroupWraper.GetM(Index: Integer): integer;
var int_temp: integer;
begin
    GetOPCHDAConfig(Topic[Index],TA,HR,MR,Nadv);
    result:= MR;
end;

procedure THDAGroupWraper.SetM(Index: Integer; value: integer);
begin
 Topic[Index]:=getTopic_conf(timeout[Index], H [Index],value, N[Index]);
end;


function THDAGroupWraper.GetM_(): String;
var i: integer;
begin
     result:=inttostr(M[0]);
        for i:=1 to idscount-1 do
         if (inttostr(M[i])<>result) then
           begin
              result:='';
           end;
end;

procedure THDAGroupWraper.SetM_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     M[i]:=strtoint(value);
end;

function THDAGroupWraper.GetN(Index: Integer): boolean;
var int_temp: integer;
begin
    GetOPCHDAConfig(Topic[Index],TA,HR,MR,Nadv);
    result:= Nadv;
end;

procedure THDAGroupWraper.SetN(Index: Integer; value: boolean);
begin
 Topic[Index]:=getTopic_conf(timeout[Index], H [Index], M[Index], value);
end;


function THDAGroupWraper.GetN_(): String;
var i: integer;
begin
     result:=getNAtoStr(N[0]);
        for i:=1 to idscount-1 do
         if (getNAtoStr(N[i])<>result) then
           begin
              result:='';
           end;
end;

procedure THDAGroupWraper.SetN_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     N[i]:=getstrToNA(value);
end;





function THDAGroupWraper.getTopic_conf( TA: integer;HR: integer;MR: integer;Na: boolean): string;
begin
     result:='';
     if TA<0 then TA:=0;
     if HR<0 then HR:=0;
     if MR<0 then MR:=0;
     if (TA<>120) then result:='T'+inttostr(TA)+'/';
     if (HR<>60) then result:=result+'H'+inttostr(HR)+'/';
     if (MR<>30) then result:=result+'M'+inttostr(MR);
     if (Na) then
      begin
      if (result<>'') then
      result:=result+'/N' else result:=result+'N';
      if (result<>'') then result:=result+'/'
      end;
end;

function THDAGroupWraper.getApplication_conf( value: string): string;
begin
    result:='OPC_HDA['+value+']';;
end;





end.
