unit CalcU1;

interface
Uses
    classes, sysUtils;
{
Порядок вычисления операторов слева направо
в соответствии со следующим приоритетом.
· Математические функции, такие как (SQR(X), и т.д.)
· Отрицание !, знаковый минус ~
· Умножение (*), деление (/), MOD
· Сложение (+), вычитание (-)
· Сдвиг влево (<<), сдвиг вправо (>>)
· Операции сравнения (=, <, <=, >, >=, <>)
· Логическое и &
· Логическое или |
}

type

TConvertFunction = procedure (Sender: TObject; var rez: real) of object;

TOperandCount = (otBi, otUni);//оператор с одним или двумя операторами



TElemType = (etNone, etIdent, etNumber,
              etSqr,etSin, etCos,
              etNot, etSignMinus,
              etMul, etDiv,
              etPlus, etMinus,
              etEq, etUnEq, etLessEq, etLess, etMoreEq, etMore,
              etAnd,
              etOr,
              etRightBrench, etLeftBrench
);

TSepType = etSqr .. etLeftBrench;

const
SeparSet: set of etSqr .. etRightBrench = [etSqr .. etRightBrench];

type
TOper = record
      name: string;
      Level: integer;
      operCount: TOperandCount;
end;

TSepArray = array[TSepType] of toper;
const
//елси операция содержит в начале синтаксис другой,
// то сначала должна стоять более длинная (например: <=, <)
SepArray: TSepArray =(

           (name: 'SQR'; Level: 90; operCount: otUni), //etSqr
           (name: 'SIN'; Level: 90; operCount: otUni), //etCos
           (name: 'COS'; Level: 90; operCount: otUni), //etSin
           (name: '!'; Level: 80; operCount: otUni), //etNot
           (name: '~'; Level: 80; operCount: otUni), //etSignMinus
           (name: '*'; Level: 70; operCount: otBi), //etMul
           (name: '/'; Level: 70; operCount: otBi), //etDiv
           (name: '+'; Level: 60; operCount: otBi), //etPlus
           (name: '-'; Level: 60; operCount: otBi), //etMinus
           (name: '='; Level: 50; operCount: otBi), //etEg
           (name: '<>'; Level: 50; operCount: otBi), //etUnEq
           (name: '<='; Level: 50; operCount: otBi), //etLessEq
           (name: '<'; Level: 50; operCount: otBi), //etLess
           (name: '>='; Level: 50; operCount: otBi), //etMoreEq
           (name: '>'; Level: 50; operCount: otBi), //etMore
           (name: '&'; Level: 40; operCount: otBi), //etAND
           (name: '|'; Level: 30; operCount: otBi), //or
           (name: ')'; Level: 20; operCount: otBi), //etRightBrench
           (name: '('; Level: 10; operCount: otBi) //etLeftBrench
);


type
TCalcItem = Class
   private
      fValueReal: real;

      fIdent: String;
      fElemType : TElemType;
      procedure setIdent(iIdent: string);
      function GetValue: real;
   public
      obj: TObject;
      ConvertFunction: TConvertFunction;
      validLevel: integer;
      constructor Create(iIdent: string; Septype: TSepType);
      destructor Destroy; override;
      property Ident: string read fIdent write setIdent;
      property ElemType : TElemType read fElemType;
      property ValueReal : real read GetValue;
      function isSeparator: boolean;
end;

TCalcItemList = class (TList)
private
       function GetCalcItem(i: integer): TCalcItem;
       procedure SetCalcitem(i: integer; Item : TCalcItem);
public
      property Items [i: integer] : TCalcItem read GetCalcItem
                                                   write SetCalcItem; default;
      procedure FreeObj;
      destructor Destroy; override;
end;

TRealArray = array [0..100000] of real;
PTRealArray = ^TRealArray;

TMathStack = class
private
       stack: PTRealArray;
       maxCount, count: integer;
public
      constructor Create(imaxCount: integer);
      destructor Destroy; override;
      procedure push(val: real);
      function  pop: real;
      procedure Add;
      procedure Minus;
      procedure Mul;
      procedure Divide;
      procedure LogicOr;
      procedure LogicAnd;
      procedure Eq;
      procedure Less;
      procedure LessEq;
      procedure More;
      procedure MoreEq;
      procedure UnEq;
      procedure SignMin;
      procedure LogicNot;
      procedure fSQR;
      procedure fSIN;
      procedure fCOS;
end;

TCalculator = class(TObject)
private
   SepList: TList;
   fExpresion: string;
//   fpolExpresion: string;
   procedure TestError;
   function GetSeparatorLevel(tp: TSepType): integer;
   procedure FreeSeparators;
   procedure AddSeparator(Sep: string; Septype : TSepType);
//   procedure FillPolStr;
   procedure WriteExpretion(Exp: string);
   procedure SetConvertFunction(Func: TConvertFunction);
public
   ExprList: TCalcItemList;
   value : real;
   validLevel: integer; //minimum from validLevel of Items
   constructor Create;
   destructor Destroy; override;
   property ConvertFunction: TConvertFunction write SetConvertFunction;
   property Expresion: string read fExpresion write WriteExpretion;
//   property polExpresion: string read fPolExpresion write fPolExpresion;
//   procedure Convert;
   procedure FillList;
   function Calc: boolean;
end;

var
   MathStack : TMathStack;

//Функця выбирает из выражения первый элемент и определяет его тип
function GetFirstElement(var Expr, Elem: string): TElemType;
//Находит позицию разделителя в строке
function GetSeparatorPos(Expr: string): integer;
//определяет, является ли строка вещественным числом
function isFloat(Expr: string): boolean;

implementation

//tMathStack Definition
constructor TMathStack.Create(imaxCount: integer);
begin
     maxCount := imaxCount;
     count := 0;
     GetMem(stack, sizeof(real) * maxCount);
end;
destructor TMathStack.Destroy;
begin
     freemem(stack);
end;
procedure TMathStack.push(val: real);
begin
     if count < maxCount then begin
        stack[count] := val;
        inc(count);
     end else raise Exception.Create('Переполнение математического стека');
end;
function TMathStack.Pop: real;
begin
     if count > 0 then begin
        result := Stack[Count-1];
        dec(count);
     end else raise Exception.Create('MathStack.Pop: Действие на пустом стеке');
end;
procedure TMathStack.Add;
begin
     if count > 1 then begin
        stack[count-2] := stack[count-2] + stack[count-1];
        dec(count);
     end else raise Exception.Create('MathStack.Add: Действие на пустом стеке');
end;
procedure TMathStack.Minus;
begin
     if count > 1 then begin
        stack[count-2] := stack[count-2] - stack[count-1];
        dec(count);
     end else raise Exception.Create('MathStack.Sub: Действие на пустом стеке');
end;
procedure TMathStack.Mul;
begin
     if count > 1 then begin
        stack[count-2] := stack[count-2] * stack[count-1];
        dec(count);
     end else raise Exception.Create('MathStack.Mul: Действие на пустом стеке');
end;
procedure TMathStack.Divide;
begin
     if count > 1 then begin
        stack[count-2] := stack[count-2] / stack[count-1];
        dec(count);
     end else raise Exception.Create('MathStack.Div: Действие на пустом стеке');
end;
procedure TMathStack.LogicAnd;
begin
     if count > 1 then begin
       if (stack[count-2] <> 0) and (stack[count-1] <> 0) then
        stack[count-2] := 1
       else stack[count-2] := 0;
        dec(count);
     end else raise Exception.Create('MathStack.And: Действие на пустом стеке');
end;
procedure TMathStack.LogicOr;
begin
     if count > 1 then begin
       if (stack[count-2] <> 0) or (stack[count-1] <> 0) then
        stack[count-2] := 1
       else stack[count-2] := 0;
        dec(count);
     end else raise Exception.Create('MathStack.Or: Действие на пустом стеке');
end;
procedure TMathStack.Eq;
begin
     if count > 1 then begin
       if (stack[count-2] = stack[count-1]) then
        stack[count-2] := 1
       else stack[count-2] := 0;
        dec(count);
     end else raise Exception.Create('MathStack.Eq: Действие на пустом стеке');
end;
procedure TMathStack.Less;
begin
     if count > 1 then begin
       if (stack[count-2] < stack[count-1]) then
        stack[count-2] := 1
       else stack[count-2] := 0;
        dec(count);
     end else raise Exception.Create('MathStack.Less: Действие на пустом стеке');
end;
procedure TMathStack.LessEq;
begin
     if count > 1 then begin
       if (stack[count-2] <= stack[count-1]) then
        stack[count-2] := 1
       else stack[count-2] := 0;
        dec(count);
     end else raise Exception.Create('MathStack.LessEq: Действие на пустом стеке');
end;
procedure TMathStack.More;
begin
     if count > 1 then begin
       if (stack[count-2] > stack[count-1]) then
        stack[count-2] := 1
       else stack[count-2] := 0;
        dec(count);
     end else raise Exception.Create('MathStack.More: Действие на пустом стеке');
end;
procedure TMathStack.MoreEq;
begin
     if count > 1 then begin
       if (stack[count-2] >= stack[count-1]) then
        stack[count-2] := 1
       else stack[count-2] := 0;
        dec(count);
     end else raise Exception.Create('MathStack.MoreEq: Действие на пустом стеке');
end;
procedure TMathStack.UnEq;
begin
     if count > 1 then begin
       if (stack[count-2] <> stack[count-1]) then
        stack[count-2] := 1
       else stack[count-2] := 0;
        dec(count);
     end else raise Exception.Create('MathStack.UnEq: Действие на пустом стеке');
end;
procedure TMathStack.Signmin;
begin
     if count > 0 then begin
        stack[count-1] := stack[count-1] * -1;
     end else raise Exception.Create('MathStack.SignMin: Действие на пустом стеке');
end;
procedure TMathStack.LogicNot;
begin
     if count > 0 then begin
        if stack[count-1] <> 0 then
          stack[count-1] := 0
        else
          stack[count-1] := 1;
     end else
           raise Exception.Create('MathStack.Not: Действие на пустом стеке');
end;
procedure TMathStack.fSQR;
begin
     if count > 0 then begin
        stack[count-1] := SQR(stack[count-1]);
     end else raise Exception.Create('MathStack.SignMin: Действие на пустом стеке');
end;

procedure TMathStack.fCOS;
begin
     if count > 0 then begin
        stack[count-1] := COS(stack[count-1]*pi/180);
     end else raise Exception.Create('MathStack.SignMin: Действие на пустом стеке');
end;

procedure TMathStack.fSIN;
begin
     if count > 0 then begin
        stack[count-1] := SIN(stack[count-1]*pi/180);
     end else raise Exception.Create('MathStack.SignMin: Действие на пустом стеке');
end;

//TCalcItem definition
function TCalcItem.isSeparator: boolean;
begin
     result := (ElemType in SeparSet);

end;

function TCalcItem.GetValue: real;
begin
     case ElemType of
       etNumber: result := fValueReal;
       etident: if Assigned(ConvertFunction) then ConvertFunction(Self, result)
                else raise Exception.Create ('TCalcItem.GetValue:Значение для '+
                        'параметра '+Self.Ident + ' не определено');
     else
         raise Exception.Create ('TCalcItem.GetValue:Значение для параметра не определено');
     end;
end;

procedure TCalcItem.setIdent(iIdent: string);
begin
     fIdent := UpperCase(trim (iIdent));
end;

constructor TCalcItem.Create(iIdent: string; septype: tSeptype);
begin
     setIdent(iIdent);
     fElemtype := sepType;
     if SepType = etNumber then
          fValueReal := strtofloat (iIdent);
end;

//Tcalculator type definition
constructor TCalculator.Create;
begin
  inherited;
     ExprList := TCalcItemList.Create;
     SepList := TList.Create;
     Expresion := '';
     convertFunction := nil;
//     polExpresion := '';
end;

destructor TCalculator.Destroy;
begin
     ExprList.Free;
     SepList.Free;
     inherited Destroy;
end;

procedure TCalculator.WriteExpretion(Exp: string);
begin
     if fExpresion <> Exp then begin
       fExpresion := Exp;
       FillList;
     end;
end;

procedure TCalculator.TestError;
var
   itemsCount: integer;
   SepCount: integer;
   i: integer;
begin
   itemsCount := 0;
   SepCount := 0;
   for i := 0 to ExprList.Count - 1 do
       if (TCalcItem(ExprList[i])).IsSeparator then begin
         if (SepArray[TCalcItem(ExprList[i]).ElemType].operCount = otBi) then
           inc (SepCount);
       end else inc (itemsCount);
   inc (SepCount);
   if SepCount > ItemsCount then
      raise Exception.Create('Лишний знак');
   if SepCount < ItemsCount then
      raise Exception.Create('Нехватает знака');
end;

function TCalculator.Calc: boolean;
Var
   i: integer;
begin
     result:=false;
     if not Assigned(MathStack) then Mathstack := TMathStack.Create(100);

     ValidLevel := 100;
     for i := 0 to ExprList.Count - 1 do
       case TCalcItem(ExprList[i]).ElemType of
          etIdent     :
            begin
              MathStack.Push(TCalcItem(ExprList[i]).ValueReal);
              if TCalcItem(ExprList[i]).ValidLevel < validLevel then
                validLevel := TCalcItem(ExprList[i]).ValidLevel;
            end;
          etNumber    : MathStack.Push(TCalcItem(ExprList[i]).ValueReal);
          etPlus      : MathStack.Add;
          etMinus     : MathStack.Minus;
          etMul       : MathStack.Mul;
          etDiv       : MathStack.Divide;
          etAnd       : MathStack.LogicAnd;
          etOr        : MathStack.LogicOr;
          etEq        : MathStack.Eq;
          etLess      : MathStack.Less;
          etLessEq    : MathStack.LessEq;
          etMore      : MathStack.More;
          etMoreEq    : MathStack.MoreEq;
          etUnEq      : MathStack.UnEq;
          etSignMinus : MathStack.SignMin;
          etNot       : MathStack.LogicNot;
          etSqr       : MathStack.fSQR;
          etSin       : MathStack.fSin;
          etCos       : MathStack.fcos;
       else
        {   raise Exception.Create ('Действие математической операции: ' +
                                     SepArray[TCalcItem(ExprList[i]).ElemType].Name +
                                     ' неопределено!');    }
         result:=true;
       end;
       try
       value := MathStack.Pop;
       except
       result:=true;
       end;
end;

function TCalculator.GetSeparatorLevel(tp: TSepType): integer;
begin
     result := sepArray[tp].Level;
end;

function GetSeparatorPos(Expr: string): integer;
var
   i: integer;
   j: TSepType;
begin
     result := 0;
     for i := 1 to Length(Expr) do
       for j := etSqr to etLeftBrench do
         if  upperCase(copy(Expr, i, Length(SepArray[j].Name))) = SepArray[j].Name then
         begin
           result := i;
           exit;
         end;
end;

procedure TCalculator.FreeSeparators;
var
   i: integer;
begin
     for i := SepList.Count - 1 downTo 0 do
          if TCalcItem(SepList[i]).ElemType <> etLeftBrench then
             ExprList.Add(SepList[i])
          else
              raise Exception.Create('Лишняя открывающаяся скобочка');
     sepList.Clear;
end;

procedure TCalculator.AddSeparator(Sep: String; Septype: tSepType);
var
   newLevel: integer;
   calcitem: TCalcItem;
begin
   CalcItem := TCalcItem.Create(Sep, SepType);
   newLevel := GetSeparatorLevel(CalcItem.ElemType);
     if sep <> '(' then
        while (SepList.Count > 0) and
           (GetSeparatorLevel(TCalcItem(SepList[SepList.Count-1]).ElemType) >= NewLevel) do begin
           ExprList.Add(SepList[SepList.Count-1]);
           SepList.Delete(SepList.Count-1);
        end;

     if CalcItem.ElemType <> etRightBrench then SepList.Add(CalcItem);

     // левая скобка просто помещается в стек,
     // а правая удаляет все элементы до левой
     if (CalcItem.ElemType = etRightBrench) and
        ((SepList.Count=0) or (TCalcItem(SepList[SepList.Count-1]).ElemType <> etLeftBrench)) then
        raise Exception.Create('Лишняя закрывающаяся скобочка');
     if (CalcItem.ElemType = etRightBrench ) and
                           (TCalcItem(SepList[SepList.Count-1]).ElemType = etLeftBrench) then
                                   SepList.Delete(SepList.Count-1);
end;

procedure TCalculator.SetConvertFunction(Func: TConvertFunction);
var
   i: integer;
begin
     for i := 0 to ExprList.Count - 1 do
         TCalcItem(ExprList[i]).ConvertFunction := Func;
end;

function GetFirstElement(var Expr, Elem: string): TElemType;
var
   j: TSepType;
   SepPos: integer;
begin
  expr := TrimLeft(Expr);
     for j := etSqr to etLeftBrench do
         if  upperCase(copy(Expr, 1, Length(SepArray[j].Name))) = SepArray[j].Name then
         begin
           //первый элемент - разделитель
           result := j;
           Elem := SepArray[j].Name;
           Expr := trimLeft( copy (expr, length (SepArray[j].Name) + 1,
                                      length(expr) - length (SepArray[j].Name)));
           exit;
         end;
     //если мы здесь, то первый элемент или выражение или число
     SepPos := GetSeparatorPos(Expr);
     if SepPos = 0 then
     begin
        elem := expr;
        expr := '';
     end else begin
       elem := Trim(copy(expr, 1, Seppos - 1));
       expr := TrimRight(copy (expr, SepPos, Length(expr)- Seppos + 1));
     end;
     try
       if isFloat (elem) then
       begin
         strtofloat (elem);
         result := etNumber;
       end else result := etIdent;
     except
        result := etIdent;
     end;
end;

procedure TCalculator.FillList;
var
   Expr : string;
   Elem: string;
   elemtype: TElemtype;
begin
     ExprList.FreeObj;
     ExprList.Clear;
     SepList.Clear;
     Expr := Expresion;
   try
     while Expr <> '' do begin
       elemtype := GetFirstElement (Expr, Elem);
       if  (elemtype = etIdent) or (elemtype = etNumber) then
         ExprList.Add(TCalcItem.Create(Elem, elemType))
       else
        addSeparator(Elem, elemType);
     end;
     FreeSeparators;
     if Expr <> '' then
       TestError;
   except
        SepList.Clear;
        ExprList.Clear;
        raise;
   end;
end;


{Function determize is entered string the float value
this function doesnt trunk and doesnt undestend blanks}
function isFloat(expr: string): boolean;
var
  i, numPoints: integer;
  startPoint: integer;
begin
  result := false;
  numpoints := 0;
  expr := trim(expr);
  if expr='' then exit;
  if (Expr[1] = '+') or (Expr[1] = '-') then startPoint := 2 else startPoint := 1;
  for i := startPoint to length (expr) do
    if (ord('0') > ord(expr[i])) or (ord(expr[i]) > ord('9')) then //it is not number
      if (expr[i] = ',') then inc (numPoints)
      else abort;
  if numpoints <= 1 then result := true;
end;

//TCalcItemList definition
destructor TCalcItemList.Destroy;
begin
  freeObj;
  inherited;
end;

procedure TCalcItemList.FreeObj;
var
  i: integer;
begin
  for i := 0 to count - 1 do
    Items[i].obj.free;
end;

function TCalcItemList.GetCalcItem(i: integer): TCalcItem;
begin
     result := inherited Items[i];
end;

procedure TCalcItemList.SetCalcitem(i: integer; Item : TCalcItem);
begin
     inherited Items[i] := Item;
end;

destructor TCalcItem.Destroy;
begin
  obj.free;
  inherited;
end;

end.
