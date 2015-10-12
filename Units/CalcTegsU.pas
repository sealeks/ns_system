unit CalcTegsU;

interface

uses windows, sysutils, classes, CalcU1, memStructsU, Expr, ConstDef;

Type


TCalcItem = class
   Expr: TExpretion;
   ID: longInt; //Номер тега в базе данных
   constructor Create(num: integer);
end;

TCalcItems = class (TList)
public
   procedure update;
   function Add(ID: integer): tCalcItem;
   destructor Destroy; override;
end;



implementation



{ TCalcItem }

constructor TCalcItem.Create(num: Integer);
begin
  
  if rtItems.GetDDEItem(num) <> '' then
  begin
    Expr := TExpretion.Create;
    Expr.Expr := rtItems.GetDDEItem(num);
    ID := num;
    try
      Expr.ImmiInit;
    except
      FreeAndNil(Expr);
     // rtItems.SetComment(id, 'Ошибка в выражении "' + rtItems.GetDDEItem(num) + '"');
    end;
  end;
end;

//***************TCalcItems ******************************
procedure TCalcItems.Update;
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
    if TCalcItem(Items[i]).expr <> nil then
    begin
      TCalcItem(Items[i]).expr.ImmiUpdate;
      rtItems.SetVal(TCalcItem(Items[i]).ID, TCalcItem(Items[i]).expr.value,TCalcItem(Items[i]).expr.validLevel);
     // rtItems.SetValid(TCalcItem(Items[i]).ID, TCalcItem(Items[i]).expr.validLevel);
    end else
    if UpperCase(rtItems.GetName(TCalcItem(Items[i]).ID)) = '$ACCESSLEVEL' then
    else
    if UpperCase(rtItems.GetName(TCalcItem(Items[i]).ID)) = '$DAY' then
    else
    if UpperCase(rtItems.GetName(TCalcItem(Items[i]).ID)) = '$HOUR' then
    else
    if UpperCase(rtItems.GetName(TCalcItem(Items[i]).ID)) = '$MINUTE' then
    else
    if UpperCase(rtItems.GetName(TCalcItem(Items[i]).ID)) = '$SECOND' then
    else
    if UpperCase(rtItems.GetName(TCalcItem(Items[i]).ID)) = '$YEAR' then
    ;

  end;
end;

function TCalcItems.Add(ID: Integer): TCalcItem;
var
  CI: TCalcItem;
begin
  if rtitems.Items[id].ID<0 then exit;
  CI := TCalcItem.Create(ID);

  if rtItems.GetName(ID)[1] <> '$' then
  begin
    if CI.Expr <> nil then
      inherited Add(CI);
  end
  else inherited Add(CI);
  result := CI;
end;


destructor TCalcItems.Destroy;
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
    TCalcItem(Items[i]).Expr.ImmiUnInit;
    TCalcItem(Items[i]).Free;
  end;  
  inherited;
end;


end.
