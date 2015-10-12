unit OPCGroupAdapterU;

interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,Windows,ItemAdapterU,FormOPCClientUE;

type
TOPCGroupWraper = class (TGroupWraper)
    protected
     function getApplication_conf(server, host, group : string): string;
     function getTopic_conf(Uval: integer; Pval: single; Na: boolean): string;
     function GetServer(Index: Integer): String;
     procedure SetServer(Index: Integer; value: String);
     function GetServer_(): String;
     procedure SetServer_(value: String);
     function GetHost(Index: Integer): String;
     procedure SetHost(Index: Integer; value: String);
     function GetHost_(): String;
     procedure SetHost_(value: String);
     function GetOPCGroup(Index: Integer): String;
     procedure SetOPCGroup(Index: Integer; value: String);
     function GetOPCGroup_(): String;
     procedure SetOPCGroup_(value: String);
     function GetU(Index: Integer): DWORD;
     procedure SetU(Index: Integer; value: DWORD);
     function GetU_(): String;
     procedure SetU_(value: String);
     function GetP(Index: Integer): single;
     procedure SetP(Index: Integer; value: single);
     function GetP_(): String;
     procedure SetP_(value: String);
     function GetN(Index: Integer): boolean;
     procedure SetN(Index: Integer; value: boolean);
     function GetN_(): String;
     procedure SetN_(value: String);
    public
      //procedure   setType();  override;
    property Server[Index: Integer]: String read GetServer write SetServer;
    property Server_: String read GetServer_ write SetServer_;
    property Host[Index: Integer]: String read GetHost write SetHost;
    property Host_: String read GetHost_ write SetHost_;
    property OPCGroup[Index: Integer]: String read GetOPCGroup write SetOPCGroup;
    property OPCGroup_: String read GetOPCGroup_ write SetOPCGroup_;
    property U[Index: Integer]: DWORD read GetU write SetU;
    property U_: String read GetU_ write SetU_;
    property P[Index: Integer]: single read GetP write SetP;
    property P_: String read GetP_ write SetP_;
    property N[Index: Integer]: boolean read GetN write SetN;
    property N_: String read GetN_ write SetN_;
    procedure setType();  override;
    procedure setMap();    override;
    function setchange(key: integer; val: string): string; override;
end;




var
  UR: DWORD;
  PD: single;
  Nadv: boolean;
  var_host: string;
  var_grn: string;

implementation





 // SERVER - имя сервера
     // HOST -хост
     // OPCGROUPNAME - имя группы OPC
     // U -период обновления данных
     // P - мертвая зона сервера в прцентах
     // N - синхронный интерфейс

{function isOPC(val: string; var host: string; var grn: string): string;
 function getinVstring(var val: string; pref: string): string;
   var valU, PrefU, preftemp: string;
       i: integer;
   begin
     val:=trim(val);
     result:='';
     PrefU:=trim(uppercase(pref));
     valU:=trim(uppercase(val));
     if ((length(valU)+3)<(length(PrefU))) then
       begin
         val:='';
         result:='';
         exit;
       end;
    // if (pref<>'') then
       begin
          preftemp:=copy(valU,1,length(prefU)+1);
          if ((pref+'[')=(preftemp)) then
            begin
              i:=length(preftemp)+1;
              while ((ValU[i]<>']') and (i<=length(ValU))) do
                begin
                  result:=result+Val[i];
                  i:=i+1;
                end;
              if (i<length(ValU)) then val:=copy(val,i+1,length(valU)-i+1) else
              val:='';
            end;
       end;
   end;

var valUp,tempval: string;
    i: integer;
begin
   result:='';
   host:='';
   grn:='';
   val:=trim(val);
   if val='' then exit;
   result:=trim(getinVstring(val,'OPC'));
   if ((result<>'') and (val<>'')) then
     begin
       tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);
       if (length(tempval)>6) and (uppercase(copy(tempval,1,6))='GROUP:')
               then grn:=copy(tempval,7,length(tempval)-6);
         tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);
       if (length(tempval)>6) and (uppercase(copy(tempval,1,6))='GROUP:')
               then grn:=copy(tempval,7,length(tempval)-6);
     end;
end;


procedure GetOPCConfig(val: string; var UR: DWORD; var PD: single; var Nadv: boolean);
var urStr, PDStr, flaStr: string;
    i: integer;
    flU, flP, FlA: boolean;
begin
   try
   UR:=0;
   urStr:='';
   PDStr:='';
   flaStr:='';
   PD:=0;
   flU:=false;flP:=false;FlA:=false;
   val:=uppercase(trim(val));
   for i:=1 to length(val) do
     begin
        if (val[i]='U') then begin flU:=true; flP:=false; end;
        if (val[i]='P') then begin flU:=false; flP:=true; end;
        if (val[i]='N') then begin flA:=false; flA:=true;FlaStr:=val[i]; end;
        if (val[i]='/') or (val[i]='\') then begin flU:=false; flP:=false; flA:=false; end;
        if (val[i]<>'U') and (val[i]<>'P') and (val[i]<>'N') then
          begin
             if (flU) then urStr:=urStr+val[i];
             if (flP) then PDStr:=PDStr+val[i];
             if (flA) then FlaStr:=flaStr+val[i];
          end;
     end;
       urStr:=trim(urStr);
       PDStr:=trim(PDStr);
       FlaStr:=trim(FlaStr);
     try
       UR:=strtoint(urStr);
     except
     end;
      try
       PD:=strtofloat(PDStr);
     except
     end;
     Nadv:=(FlaStr<>'');
     except
     end;
end;   }

procedure TOPCGroupWraper.setMap();
var
    str: String;
    id: integer;


    StrL: TStringList;
    diff: boolean;

begin
         editor.Strings.Clear;
         setPropertys('Имя',GetName_);
         setPropertys('Сервер OPC',Server_);
         setPropertys('Хост',Host_);
         setPropertys('Группа OPC',OPCGroup_);
         setPropertys('Период обновления данных',U_);
         setPropertys('Мертвая зона изменении',P_);
         setPropertys('Интерфейс',N_,getNASL);
         setPropertys('Номер потока',Slave_);
         setPropertys('Приложение','NS_OPCDDEbridgeService.exe/NS_OPCDDEbridge_app.exe',true);
         setNew();
end;

function TOPCGroupWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;


   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Server_:=val;
   2: Host_:=val;
   3: OPCGroup_:=val;
   4: U_:=val;
   5: P_:=val;
   6: N_:=val;
   7: Slave_:=val;


   end;


end;


procedure TOPCGroupWraper.SetType;
var i: integer;
begin
  Application_:='OPC[FooServer]';
end;



function TOPCGroupWraper.GetServer(Index: Integer): String;
function getServname(val: string): string;
var valt: string;
begin
   result:='Ошибка в определении';
   valt:=uppercase(val);
   if  (pos('OPC[',valt)>0) then
    begin
       val:=rightstr( val,length(val)-(4+pos('OPC[',valt)-1));
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

procedure TOPCGroupWraper.SetServer(Index: Integer; value: String);
begin
   Application[index]:=getApplication_conf(value,Host[index],OPCGroup[Index]);
end;


function TOPCGroupWraper.GetServer_(): String;
var i: integer;
begin
     result:=Server[0];
        for i:=1 to idscount-1 do
         if (Server[i]<>result) then
           begin
              result:='';
           end;

end;

procedure TOPCGroupWraper.SetServer_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Server[i]:=value;
end;

function TOPCGroupWraper.GetHost(Index: Integer): String;
begin
    isOPC(Application[index],result,var_grn);
end;

procedure TOPCGroupWraper.SetHost(Index: Integer; value: String);
begin
   Application[index]:=getApplication_conf(Server[index],value,OPCGroup[Index]);
end;


function TOPCGroupWraper.GetHost_(): String;
var i: integer;
begin
     result:=Host[0];
        for i:=1 to idscount-1 do
         if (Host[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TOPCGroupWraper.SetHost_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Host[i]:=value;
end;

function TOPCGroupWraper.GetOPCGroup(Index: Integer): String;
begin
    isOPC(Application[index],var_grn,result);
end;

procedure TOPCGroupWraper.SetOPCGroup(Index: Integer; value: String);
begin
   Application[index]:=getApplication_conf(Server[index],Host[Index],value);
end;


function TOPCGroupWraper.GetOPCGroup_(): String;
var i: integer;
begin
     result:=OPCGroup[0];
        for i:=1 to idscount-1 do
         if (OPCGroup[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TOPCGroupWraper.SetOPCGroup_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     OPCGroup[i]:=value;
end;

function TOPCGroupWraper.GetU(Index: Integer): DWORD;
begin
    GetOPCConfig(Topic[index],result,PD,Nadv);
end;

procedure TOPCGroupWraper.SetU(Index: Integer; value: DWORD);
begin
   Topic[index]:=getTopic_conf(value,P[index],N[index]);
end;


function TOPCGroupWraper.GetU_(): String;
var i: integer;
begin
     result:=inttostr(U[0]);
        for i:=1 to idscount-1 do
         if (inttostr(U[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TOPCGroupWraper.SetU_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     U[i]:=strtoint(value);
end;



function TOPCGroupWraper.GetP(Index: Integer): single;
begin
    GetOPCConfig(Topic[index],UR,result,Nadv);
end;

procedure TOPCGroupWraper.SetP(Index: Integer; value: single);
begin
   Topic[index]:=getTopic_conf(U[index],value,N[index]);
end;


function TOPCGroupWraper.GetP_(): String;
var i: integer;
begin
     result:=floattostr(P[0]);
        for i:=1 to idscount-1 do
         if (floattostr(P[i])<>result) then
           begin
              result:='';
           end;
end;



procedure TOPCGroupWraper.SetP_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     P[i]:=strtofloat(value);
end;


function TOPCGroupWraper.GetN(Index: Integer): boolean;
begin
    GetOPCConfig(Topic[index],UR,PD,result);
end;

procedure TOPCGroupWraper.SetN(Index: Integer; value: boolean);
begin
   Topic[index]:=getTopic_conf(U[index],P[index],value);
end;



function TOPCGroupWraper.GetN_(): String;
var i: integer;
begin
     result:=getNAtoStr(N[0]);
        for i:=1 to idscount-1 do
         if (getNAtoStr(N[i])<>result) then
           begin
              result:='';
           end;
end;



procedure TOPCGroupWraper.SetN_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     N[i]:=getstrToNA(value);
end;




function TOPCGroupWraper.getApplication_conf(server, host, group : string): string;
begin
    result:='OPC['+server+']';
    if (trim(host)<>'') then result:=result+'[host:'+host+']';
    if (trim(group)<>'') then result:=result+'[group:'+group+']';
end;

function TOPCGroupWraper.getTopic_conf(Uval: integer; Pval: single; Na: boolean): string;
begin
    result:='';
     if Uval<0 then Uval:=0;
     if Pval<0 then Pval:=0;

     if (Uval<>0) then result:=result+'U'+inttostr(Uval)+'/';
     if (Pval<>0) then result:=result+'P'+floattostr(Pval)+'/';
     if (Na) then
      begin
      if (result<>'') then
      result:=result+'/N' else result:=result+'N'
      end;
end;



end.
