unit SysCommansGroupU;

interface

uses
  Classes, memStructsU, Expr, SysUtils, ConstDef, StrUtils;

type

 TTagExpressioncase = class
    TagID: integer;
    Expr: TExpretion;
    Error: integer;
    constructor Create(id: integer; expr_: string);
    destructor Destroy;
    procedure Execute();
    end;


  TSysCommandsItem = class
  ID: longInt; //Номер тега в базе данных
  Expr: TExpretion; // условное выражение
  Error: integer;
  comandList: TList;
  //function getItems(i: integer): TTagExpressioncase;
//  property Items[]
  constructor Create(num: integer);
  destructor Destroy;
  procedure TextItemToCommand(SL: TStringList);
  function CommandItemfromtext(val: string): TTagExpressioncase;
  procedure Execute;
  end;



TSysCommandsGroupItems = class (TList)
public

   procedure update;
   constructor create; 
   function Add(IDS: integer): TSysCommandsItem;

   function  findBS(IDS: integer): TSysCommandsItem;
   destructor Destroy; override;
end;


implementation


function GetCaseExpr(val: string): TExpretion;
var str: string;
    i: integer;
begin
   result:=nil;
   i:=pos('?', val);
   if i>1 then
     begin
       str:=leftstr(val,i-1);
       result:=TExpretion.Create;
       result.Expr:=str;
       try
         result.ImmiInit
       except
         freeandNil(result);
       end;
     end;
end;

procedure GetCommandListSTr(val: string; SL: TStringList);
var str: string;
    i: integer;
begin
   i:=pos(',', val);
   if i>0 then
     begin
       str:=rightstr(val,length(val)-i);
       val:=leftstr(val,i-1);
       GetCommandListSTr(str, SL);
     end;
    str:=uppercase(val);
    i:=pos('SET', str);
    if i<1 then exit;
    SL.Insert(0,val);
end;






procedure GetCaseCommand(val: string; var SL:  TStringList);
var str: string;
    i: integer;
begin
   i:=pos('?', val);
   if i>1 then
     begin
       str:=rightstr(val,length(val)-i);
       GetCommandListSTr( str, SL);
       //TextItemToCommand( SL, commandL);
     end;
end;




constructor TSysCommandsItem.Create(num: Integer);
var str: string;
    SL: TStringList;
begin
    SL:=TStringList.Create;
    ID := num;
    if rtitems[ID].ID<-1 then
      begin
       Error:=1;
       SL.Free;
       exit;

      end;
    Expr:=GetCaseExpr(rtitems.GetDDEItem(ID));
    if not assigned(Expr) then
      begin
       Error:=1;
       SL.Free;
       rtitems.LogError('Тег группы $COMMANDSCASE не добавлен bind='+rtitems.GetDDEItem(ID));
       exit;
      end;
    comandList:=TList.Create;
    GetCaseCommand(rtitems.GetDDEItem(ID),SL);
    TextItemToCommand (SL);
    if comandList.Count<1 then   Error:=1;
    SL.Free;

end;

destructor TSysCommandsItem.Destroy;
begin
    if assigned(Expr) then
      begin
        Expr.ImmiUnInit;
        Expr.Free;
      end;
    comandList.Free;
end;

procedure TSysCommandsItem.TextItemToCommand(SL: TStringList);
var i: integer;
    str: string;
    command_: TTagExpressioncase;
begin
   for i:=0 to SL.Count-1 do
     begin
       str:=SL.Strings[i];
       command_:=CommandItemfromtext(str);
       if assigned(command_) then
            comandList.Add(command_);
     end;
end;

function TSysCommandsItem.CommandItemfromtext(val: string): TTagExpressioncase;
var i, j: integer;
    lstr, rstr: string;

begin
   result:=nil;
   val:=uppercase(val);
   i:=pos('SET', val);
   if i>0 then
     begin
       lstr:=leftstr(val,i-1);
       rstr:=rightstr(val,length(val)-i-2);
       j:=rtitems.GetSimpleID(trim(lstr));
       if j<0 then
        begin
         Error:=1;
         exit;
        end;
       result:=TTagExpressioncase.Create(j,rstr);
       if result.Error>0 then FreeAndNil(result);
     end;
end;

procedure TSysCommandsItem.Execute;
var i: integer;
begin
   if Error>0 then exit;
   if not assigned(Expr) then exit;
   try
    Expr.ImmiUpdate;
   except
     exit;
   end;
   if ((comandList.Count>0)
    and (Expr.validLevel>VALID_LEVEL)
      and (Expr.isTrue))then
    begin
       for i:=0 to comandList.Count-1 do
         TTagExpressioncase(comandList.Items[i]).Execute;
    end;
end;


//***************TVariableItems ******************************

constructor TSysCommandsGroupItems.create;
begin

    inherited create;
    clear;
    count:=0;
end;

function TSysCommandsGroupItems.findBS(IDS: integer): TSysCommandsItem;
var x1,x2,xs: integer;
begin
    result:=nil;
    x1:=0;
    x2:=self.count-1;
    if x2<0 then exit;
    while (TSysCommandsItem(items[x1]).ID<>TSysCommandsItem(items[x2]).ID) do
      begin
        if TSysCommandsItem(items[x1]).ID>IDS then exit;
        if TSysCommandsItem(items[x2]).ID<IDS then exit;
        if TSysCommandsItem(items[x1]).ID=IDS then
          begin
           result:=TSysCommandsItem(items[x1]);
           exit;
          end;
        if TSysCommandsItem(items[x2]).ID=IDS then
          begin
           result:=TSysCommandsItem(items[x2]);
           exit;
          end;
       xs:=round((x1+x2)/2);
       if TSysCommandsItem(items[xs]).ID>IDS then x2:=xs
         else x1:=xs;
     end;
      if TSysCommandsItem(items[x1]).ID=IDS then
          begin
           result:=TSysCommandsItem(items[x1]);
           exit;
          end;
end;

procedure TSysCommandsGroupItems.Update;
var
  i: integer;
begin
   for i:=0 to self.Count-1 do
    if (TSysCommandsItem(Items[i]).Error=0) then
    TSysCommandsItem(Items[i]).Execute;
end;

function TSysCommandsGroupItems.Add(IDS: Integer): TSysCommandsItem;
var
  SV: TSysCommandsItem;
  i: integer;
begin
  if rtitems.Items[IDS].ID<0 then exit;
  if findBS(IDS)<>nil then exit;
  SV := TSysCommandsItem.Create(IDS);
  for i:=0 to count-1 do
   begin
     if TSysCommandsItem(items[i]).ID>IDS then
      begin
       inherited Insert(i,SV);
       result:=SV;
       exit
      end;
   end;
  inherited Add(SV);
  result := SV;
end;



destructor TSysCommandsGroupItems.Destroy;
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
    TSysCommandsItem(Items[i]).Free;
  end;  
  inherited;
end;



constructor TTagExpressioncase.Create(id: integer; expr_: string);
begin
    Error:=0;
    TagID:=id;
    Expr := TExpretion.Create;
    Expr.Expr := expr_;
    try
      Expr.ImmiInit;
    except
      rtitems.LogError('Тег группы $COMMANDSCASE не добавлен expr='+expr_);
      FreeAndNil(Expr);
      Error:=1;
    end;
    ///Expr:=extr_;
end;

destructor TTagExpressioncase.Destroy;
begin
    if assigned(Expr) then
    begin
      Expr.ImmiUnInit;
      Expr.Free;
    end;
end;

procedure TTagExpressioncase.Execute();
var val: real;
begin
   if ((not assigned(Expr)) or (TagID<0) or (Error>0)) then exit;
   try
   Expr.ImmiUpdate;
   if (Expr.validLevel>VALID_LEVEL) then
     begin
        rtitems.AddCommand(TagID,Expr.value,true);
      //  rtitems[TagID].ValReal:=Expr.value;
     end;
   except
   end;
end;

end.
