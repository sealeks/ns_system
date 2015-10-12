unit Expr;

interface

uses
  classes,  dialogs, sysUtils,
  memStructsU, constDef, calcU1{, alarmU, globalVar};

type TCorrExrStatus = (cesCorr, cesErr, cesNo);

Type

TExpretion = class (tPersistent)
private
  fExpr: string;
  calc: tCalculator;
  isInit:boolean;
  function GetValue: real;
  procedure SetValue (val : real);
  function GetValidLevel: Integer;
  procedure SetValidLevel (val : Integer);
  function GetIsTrue: boolean;
  procedure SetExpr(const Value: String);
public
  isErr: boolean;
  property value: real read GetValue write SetValue;
  property isTrue: boolean read GetisTrue;
  property validLevel: integer read GetValidLevel write SetValidLevel;
  property Expr: String read fExpr write SetExpr;
  constructor Create;
  destructor destroy; override;
  procedure Assign(Source: TPersistent); override;
  Function ImmiInit: boolean;
  procedure ImmiUnInit;
  function ImmiUpdate: boolean;
  procedure ConvertIdentifier(Sender : TObject; var rez: real);
  //добавл€ет к списку идентификаторов все идентификаторы в выражении
  procedure AddIdentList(IdentList: TStringList);
  procedure ReplaceIdent(Source, Destination: string);
end;

procedure CreateAndInitExpretion(var Expr: TExpretion; ExprStr: String);
function  CheckExpr(texts: String): TCorrExrStatus;

implementation

uses ParamU;

procedure CreateAndInitExpretion(var Expr: TExpretion; ExprStr: String);
begin
   
  if (ExprStr <> '') and not Assigned (Expr) then
    Expr := tExpretion.Create;

  if assigned(Expr) then
  begin
    Expr.Expr := ExprStr;
    try
      Expr.ImmiInit;
    except
      freeandNil(Expr);
      raise;
    end;
  end;
end;

{************************TExpretion****************************}

constructor TExpretion.Create;
begin
  inherited;
   isErr:=false;
  calc := nil;
end;

destructor TExpretion.Destroy;
begin
  calc.free;
  inherited;
end;

function TExpretion.GetIsTrue: boolean;
begin
 // if calc=nil then exit;
  result := calc.Value <> 0;
end;

function TExpretion.GetValue: real;
begin
  result := calc.Value;
end;

procedure TExpretion.SetValue (val : real);
begin
  calc.Value := val;
end;

function TExpretion.GetValidLevel: Integer;
begin
  result := calc.ValidLevel;
end;

procedure TExpretion.SetValidLevel (val : Integer);
begin
  calc.ValidLevel := val;
end;

procedure TExpretion.Assign(Source: TPersistent);
begin
     fExpr := TExpretion(Source).Expr;
     inherited;
end;

procedure TExpretion.ConvertIdentifier(Sender : TObject; var rez: real);
var
  ident: string;
  field: string;
  CalcItem: TCalcItem;
  param: TParam;
begin

//if itenID not defined then define itemID
  CalcItem := (Sender as TCalcItem);
  if Calcitem.ElemType <> etIdent then
    raise Exception.Create('TExpretion.ConvertIdentifier конвертаци€ не идентификатора');

  param := CalcItem.obj as TParam;
  if not assigned(param) then
    raise Exception.Create('TExpretion.ConvertIdentifier параметр не определен');
  ident := CalcItem.ident;

  if pos ('.', ident) <> 0 then
  begin
    field := copy (ident, pos ('.', ident) + 1, length(ident) - pos ('.', ident));
  end;


//if itenID defined then calc
//  if IdentID < alarmShift then begin
    if field = '' then begin
      rez := param.Value;
      CalcItem.validLevel :=
          param.validLevel;
    end
    else if field = 'ACK' then
         begin
            if param.isAlarmKvit then rez := 1 else rez := 0
         end else
         if strtointdef(field, -1) <> -1 then
         begin
            if (round(param.value) and (1 shl strtointdef(field, -1)))<>0 then rez := 1 else rez := 0
         end else
         raise Exception.Create ('Field ' + field + ' not defined'+inttostr(round(param.Value)));
//  end else

{  if IdentID > alarmShift then
  begin
   if field = '' then
   begin
      if alarms[identID].isOn then rez := 1 else rez := 0;
      TCalcItem(sender).validLevel := alarms[IdentID].validLevel;
   end
    else if field = 'ACK' then
         begin
           if alarms[IdentID].isKvit then rez := 1 else rez := 0
         end else raise Exception.Create ('Field ' + field + ' not defined');
  end;}
end;

Procedure TExpretion.AddIdentList(IdentList: TStringList);
var
  i: integer;
  Ident: string;
  TestCalc: TCalculator;
begin
   TestCalc := TCalculator.Create;
  try
    TestCalc.Expresion := Expr;

    for i := 0 to Testcalc.ExprList.Count - 1 do
      if TCalcItem(Testcalc.ExprList[i]).ElemType = etIdent then
      begin
        if pos ('.', Testcalc.ExprList[i].ident) <> 0 then
          ident := copy ((Testcalc.ExprList[i]).Ident, 1, pos ('.', Testcalc.ExprList[i].Ident) - 1)
        else ident := Testcalc.ExprList[i].ident;
        IdentList.Add(ident);
      end;
  finally
    TestCalc.free;
  end;
end;

function TExpretion.ImmiInit: boolean;
var
  i: integer;
  param: TParam;
begin
  result:=false;
  if not Assigned(Calc) then Calc := TCalculator.Create;
  //если выражение изменилось, заново все перестраиваем
  if Calc.Expresion <> Expr then
  begin
    Calc.Expresion := Expr;
    for i := 0 to calc.ExprList.Count - 1 do
      if TCalcItem(calc.ExprList[i]).ElemType = etIdent then
      begin
        param := TParam.Create;
        if pos ('.', calc.ExprList[i].ident) <> 0 then
          param.rtName := copy ((calc.ExprList[i]).Ident, 1, pos ('.', calc.ExprList[i].Ident) - 1)
        else param.rtName := calc.ExprList[i].ident;
          calc.ExprList[i].obj := param;
      end;
    end;
    //инициализируем переменные
    for i := 0 to calc.ExprList.Count - 1 do
      if TCalcItem(calc.ExprList[i]).ElemType = etIdent then
            if (calc.ExprList[i].obj as TParam).Init('–ассчет выражени€: ') then result:=true;;

    calc.ConvertFunction := ConvertIdentifier;
    isInit := true;
end;

procedure TExpretion.ImmiUnInit;
var
  i: integer;
begin
 if isInit then
 begin
  for i := 0 to Calc.ExprList.Count - 1 do
    if TCalcItem(Calc.ExprList[i]).ElemType = etIdent then
      (TCalcItem(Calc.ExprList[i]).obj as TParam).UnInit;
  isInit := false;
 end;
  isErr:=false;
end;

function TExpretion.ImmiUpdate: boolean;
begin
  if calc=nil then exit;
  if calc.Expresion <> '' then
   result:= calc.calc;
end;

procedure TExpretion.ReplaceIdent(Source, Destination: string);
var
  Ex, El, tmp: string;
  newExpr: string;
begin

  Ex := TrimRight(UpperCase(Expr));
  Source := UpperCase(Source);
  if ex='' then exit;
  while (Ex<>'') do
  begin
    tmp := Ex;
    if (GetFirstElement(Ex, El) = etIdent) and (El = Source) then
        NewExpr := NewExpr + copy(tmp, 1, pos(El, tmp)-1) + Destination
    else
      //если в выделенный элемент закралось поле, то эелемент заменить а поле сохранить
      if pos('.', el) <> 0 then
        NewExpr := NewExpr + copy(tmp, 1, pos(El, tmp)-1) + Destination +
                                copy(el, pos('.', el), Length(el)-pos('.', el) + 1)
        else
          NewExpr := NewExpr + copy(tmp, 1, pos(El, tmp)-1) + El;
    // опируем заново, что бы не тер€ть пробелы
    Ex := copy (tmp, Pos(El, tmp) + Length(el), length(tmp) - pos(el, tmp));
  end;
  Expr := NewExpr;
end;

procedure TExpretion.SetExpr(const Value: String);
begin
  if isInit then
  begin
    IMMIUnInit;
    fExpr := Value;
    IMMIInit;
  end else fExpr := Value;
end;

function  CheckExpr(texts: String): TCorrExrStatus;
var Expr: TExpretion;
    val: real;
begin
  result:=cesNo;
  try
  Expr := TExpretion.Create;
  Expr.Expr:=Texts;
        try
          if Expr.ImmiInit then  result:=cesErr;
          if expr.ImmiUpdate then result:=cesErr;
           Expr.ImmiUninit;
          if not (result=cesErr) then result:=cesCorr;
        except
          result:=cesErr;
        end;
  except
   try
   if expr<>nil then
     begin
       expr.ImmiUnInit;
       expr.Free;
     end;
   except
   end;
  end;
end;



end.

