unit SysVariablesU;

interface

uses
  Classes, memStructsU;

type
  TSysVariable = class
  ID: longInt; //Ќомер тега в базе данных
  constructor Create(num: integer);
  end;

TVariableItems = class (TList)
public
   predLastCommand: integer;
   procedure update;
   constructor create; 
   function Add(IDS: integer): TSysVariable;
   procedure WriteCommand(id: integer; newComValue: single);
   function findBS(IDS: integer): TSysVariable;
   destructor Destroy; override;
end;


implementation



constructor TSysVariable.Create(num: Integer);
begin
    ID := num;
end;


//***************TVariableItems ******************************

constructor TVariableItems.create;
begin
    predLastCommand:=0;
    inherited create;
    clear;
    count:=0;
end;

function TVariableItems.findBS(IDS: integer): TSysVariable;
var x1,x2,xs: integer;
begin
    result:=nil;
    x1:=0;
    x2:=self.count-1;
    if x2<0 then exit;
    while (TSysVariable(items[x1]).ID<>TSysVariable(items[x2]).ID) do
      begin
        if TSysVariable(items[x1]).ID>IDS then exit;
        if TSysVariable(items[x2]).ID<IDS then exit;
        if TSysVariable(items[x1]).ID=IDS then
          begin
           result:=TSysVariable(items[x1]);
           exit;
          end;
        if TSysVariable(items[x2]).ID=IDS then
          begin
           result:=TSysVariable(items[x2]);
           exit;
          end;
       xs:=round((x1+x2)/2);
       if TSysVariable(items[xs]).ID>IDS then x2:=xs
         else x1:=xs;
     end;
      if TSysVariable(items[x1]).ID=IDS then
          begin
           result:=TSysVariable(items[x1]);
           exit;
          end;
end;

procedure TVariableItems.Update;
var
  i,k,ids: longInt;
  newValue: longInt;
  cN: longInt;
  prevVal: word;
  newComValue: single;
  str: string;
  j : longInt;
  Last: longInt;
  val: real;
  res: integer;
  itli: TSysVariable;
procedure ExecuteCommand;
 var numit: integer;
begin

      if rtItems.Command[j].Executed then exit
      else
      if (rtItems.Command[j].ID <> -1)then
      begin
        ids:=rtItems.Command[j].ID;
        itli := findBS(rtItems.Command[j].ID);
        if itli<>nil then
        begin
         newComValue := rtItems.Command[j].ValReal;
         WriteCommand(ids,newComValue);
         rtItems.SetCommandExecuted(j);
         //rtitems.SetValue(ids, newComValue);
         //rtitems.SetValid(ids, 100);

        
        end;
      end;
end;


begin

{***********************************************************************}
{ Writing pareameters                                                   }
{***********************************************************************}
  setlength (str, 2);
    try
      Last := PredLastCommand;

      if Last < rtItems.Command.CurLine then
        for j:=Last to rtItems.Command.CurLine - 1 do
        begin
          ExecuteCommand;
          inc(predLastCommand); //увеличивать, если команда выполнилась
        end;

      if Last > rtItems.Command.CurLine then begin
        for j := Last to  rtItems.Command.Count - 1 do
        begin
          ExecuteCommand;
          inc(predLastCommand)
        end;
        predLastCommand := 0;
        for j := 0 To rtItems.Command.CurLine - 1 do
        begin
          ExecuteCommand;
          inc(predLastCommand)
        end;
      end;


   except
    {  // if   WriteErrorCount < 3 then begin
     //   inc (WriteErrorCount);
     //   fThfThrtItems.ClearCommandExecuted(j);
    //  end else WriteErrorCount := 0; //—брасываем команду при трех неудачных попытках записи  }
    end;


end;

function TVariableItems.Add(IDS: Integer): TSysVariable;
var
  SV: TSysVariable;
  i: integer;
begin
  if rtitems.Items[IDS].ID<0 then exit;
  if findBS(IDS)<>nil then exit;
  SV := TSysVariable.Create(IDS);
  for i:=0 to count-1 do
   begin
     if TSysVariable(items[i]).ID>IDS then
      begin
       inherited Insert(i,SV);
       result:=SV;
       exit
      end;
   end;
  inherited Add(SV);
  result := SV;
end;

procedure  TVariableItems.WriteCommand(id: integer; newComValue: single);
var RC: integer;
    val: single;
begin
   if id<0 then exit;
   if rtitems[id].ID<0 then exit;
   RC:=rtitems[id].refCount;
   if rtitems[id].MinEu>newComValue then newComValue:=rtitems[id].MinEu;
   if rtitems[id].MaxEu<newComValue then newComValue:=rtitems[id].MaxEu;
   rtitems.SetVal(id,newComValue,100);
 //  rtitems.SetValid(id,100);
   rtitems[id].refCount:=0;
   rtitems.WriteToFile(id);
   rtitems[id].refCount:=RC;
end;

destructor TVariableItems.Destroy;
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
    TSysVariable(Items[i]).Free;
  end;  
  inherited;
end;



end.
