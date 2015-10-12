unit Cvtype;

{в данном модуле содержатся классы данных
 для точек типа TPoint,
 для меток-значков,
 для кривых, выводимых на экран,
 и ряд глобальных функций преобразования для Extended           }

interface

 uses WinTypes,Classes,Graphics;

{стандартные константы для установки стиля обозначения
 меток данных }
const PtEndStyle=15;      { максимальное число типов значков     }
        mpNone=0;               { нет значков в точках           }
        mpCircle=1;             {кружок вокруг точки             }
        mpUpTreangle=2;         {перевернутый треугольник..      }
        mpTreangle=3;           {треугольник с центром в точке   }
        mpRect=4;               {квадрат с центром в точке       }
        mpRomb=5;               {-/- ромб                        }
        mpCross=6;              {крест                           }
        mpDiag=7;               { крест в виде "х"               }
        mpArrow=8;              {шестиконечный крест - звёздочка }
        mpPoint=9;              {точка                           }
      mpNN=10;                  {не определен  нет значков       }
        mpFillCircle=11;        { то же, что и выше,             }
        mpUpFillTreangle=12;    {   но с заполнением             }
        mpFillTreangle=13;
        mpFillRect=14;
        mpFillRomb=15;

type
    TMarkStyle=0..ptEndStyle; {тип меток-значков в точках(от int)}

    TDataPoint=class {описывает одну точку преобразованных данных
                      - необходим для работы со списком точек
                      для кривых и упрощения действий по
                      преобразованию отдельных полей в тип TPoint}
      private
       function GetPoint:TPoint;
       procedure SetPoint(Value:TPoint);
      public
        X,Y:integer;
       property Point:TPoint read GetPoint write SetPoint;
    end;

    TMark=class {отражает вид и параметры значка и надписи при
                 работе с кривыми - один экземпляр на одну кривую -
                 методы организуют рисование меток и надписей в
                 соответствии с установленным стилем                }
     public
      Font:TFont;        {шрифт только при рисовании надписей }
      Color:TColor;      {цвет только значков                 }
      Style:TMarkStyle;  {стиль значков                       }
      Radius:byte;       {размер значков -по умолч- в Create  }
      constructor Create;           {нач. установка полей     }
      destructor Destroy; override; {для Font.Free            }
      procedure Draw(const Cv:TCanvas;Pt:Tpoint);
       {рисование значка с центром в точке Pt на полотне Cv   }
      procedure DrawTitle(const S:string; const Cv:TCanvas;Pt:Tpoint);
       {рисование надписи S для точки Pt на полотне Cv
          - выравнивание текста выполняется в данном методе   }
    end;

    TCurve=class  {содержит внутренний список значений точек
                   и строк для надписей и организует вывод кривой
                   на какое-либо полотно в виде ломаной линии и
                   используя для каждой точки вызов метода Draw для
                   рисования значков и надписей
                   (последние выводятся только в случае Titled=true }
     private
      DataList:TStringList;  {список строк с надписями для точек
                              и самими точками в виде объектов
                              класса TdataPoint                     }
      FMaxCount:integer;     {максимально допустимое число
                              элементов-точек данных в списке точек
                              - устанавливается в каких-то разумных
                              пределах - в случае добавления точек,
                              когда общее число точек кривой будет
                              превышать предел -первый элемент списка
                              будет удален
                              (для повыш. скорости вывода кривой     }
      function GetData(Index:integer):Tpoint;
       {для свойства-массива - доступ к полям выбр. элемента списка  }
      function GetCount:integer; {просто оформление DataList.Count   }
      function GetColor:TColor;
      procedure SetColor(Value:TColor);
     public
      Titled : boolean;  {true - происходит вызов DrawTitle -
                          для рисования надписей (например значений
                          в точке, иначе рисования надписей
                          из списка строк не происходит              }
      Pen:TPen;          {перо, к-м рисуется кривая                  }
      Mark:TMark;        {объект - отвечает за вывод и свойства меток
                          для ВСЕХ точек из списка                   }
      Name:string;       {при создании кривой ей задаем название     }
{      procedure Assign(const Source:TCurve); virtual;
        для возможностей по копированию полей и списков кривых
  }
      procedure SetMaxCount(Value:integer);
       {перенесли из private для возм. альтернативного вызова        }

      constructor Create;
      destructor Destroy; override;
      procedure ClearPoints; { удаляет все точки из списка           }
      procedure AddPoint(const S:string; Pt:Tpoint);
           { добавляет в список точку и надпись - если после
            добавления DataList.Count>FMaxCount,то удаляется
            нулевой элемент списка и список корректируется           }
      procedure AddDataPoint(X,Y:extended;Pt:Tpoint);
           { аналогично пред., но надписи для точек выводятся в виде
             (X;Y) наппример (10.2;234) - формат - 3 цифры           }
      procedure GoStepX(St:integer);
           { сдвиг точек списка влево на St пикселов
             без перерисовки кривой                                  }
      procedure GoStepY(St:integer);
           { то же, но сдвиг по Y-оси вниз на St единиц              }
      procedure Draw(const Cv:TCanvas);
           { собственно рисование кривой на каком-либо полотне Cv    }
      procedure DrawExample(const Cv:TCanvas;Left,Top,Width:integer);
           {рисование кусочка кривой с одной меткой-значком -
              данный метод следует использовать
              при оформлении списка кривых например в виде таблицы
               Width-длина отрезка  }

      property DataPoint[index:integer]:tPoint read GetData;
           {свойство-массив для доступа к полям списка точек кривой
            в случае выхода за диапазон 0,0                          }
      property Count:integer read GetCount; {для упрощения доступа   }
      property MaxCount:integer read FMaxCount write SetMaxCount;
           {см. комментарий для поля данных                          }
      property Color:tColor read GetColor write SetColor;
           {Color введен для упрощения доступа к полю Pen.Color      }
     end;

{ ___________________________________________________________________}
{                                                                    }
{ Некоторые глобальные функции, используемые при работе с кривыми в
 модуле, содержащем компоненты вывода кривых с данными типа Extended }
{ -------------------------------------------------------------------}
function ExtInt(Value,Diver:extended):extended; {деление нацело      }
function ExtMod(Value,Diver:extended):extended;
                                          {остаток деления нацело    }
function StepPrecision(ScrDim:integer;ExtDim:extended;
  Prec:integer):extended;
           {округление с нужной точностью (Prec-точность в знаках)
            при переходе между экранным и реальным размером          }
function ExtPtInRect(X1,Y1,X2,Y2,XPt,YPt:extended):boolean;
           {true - если точка с координатами XPt,YPt
                                лежит внутри или на границе области  }

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
implementation

{$IFDEF WIN32}
  uses Sysutils;
{$ELSE}
  uses Winprocs,Sysutils;
{$ENDIF}


{ ___________________________________________________________________}
{  Вначале опишем глобальные функции                                 }

function ExtInt(Value,Diver:extended):extended;
 begin
  if Diver=0 then Result:=0
  else Result:=Diver*(Int(Value/Diver));
 end;

 function ExtMod(Value,Diver:extended):extended;
 begin
  if Diver=0 then Result:=0
  else Result:=Diver*(Frac(Value/Diver));
 end;

function StepPrecision(ScrDim:integer;ExtDim:extended;
  Prec:integer):extended;
 var LocSt,LocV:extended;
 begin
  Result:=-1;
  if (ScrDim=0) or (Prec=0) then exit;
  if ExtDim=0 then begin Result:=0; exit; end;
  LocSt:=1;
  LocV:=ExtDim/ScrDim;
  while Int(10*LocV)=0 do
   begin
    LocSt:=LocSt*10;
    LocV:=LocV*LocSt;
   end;
  if Frac(LocV)>=0.5 then LocV:=LocV+1;
  LocV:=Int(10*Abs(Prec)*LocV)/(10*Abs(Prec));
  Result:=(LocV/LocSt);
 end;

function ExtPtInRect(X1,Y1,X2,Y2,XPt,YPt:extended):boolean;
  begin
   if (XPt>=X1) and (XPt<=X2) and (YPt>=Y1) and (YPt<=Y2) then
    Result:=True
   else Result:=false;
  end;

{ ----------------------------------------------------------------  }
{ *********************    TDataPoint      ************************ }
 function TDataPoint.GetPoint:TPoint;
  begin
   Result.X:=X;
   Result.Y:=Y;
  end;
 procedure TDataPoint.SetPoint(Value:TPoint);
  begin
   X:=Value.X;
   Y:=Value.Y;
  end;
{ _________________________________________________________________ }
{ *********************    TMark           ************************ }
{ ----------------------------------------------------------------  }
constructor TMark.Create;
 begin
  inherited Create;
   Radius:=4; { для разрешения 800х600 лучше Radius=3               }
   Font:=TFont.Create;
   Font.Color:=clYellow;
   Font.Size:=8;
   Style:=mpNone;
   Color:=clRed;
 end;

destructor TMark.Destroy;
 begin
  Font.Free;
  inherited Destroy;
 end;

procedure TMark.Draw(const Cv:TCanvas;Pt:Tpoint);
var LocB:byte;
 begin
  with Cv,Pt do
   begin
    { при рисовании старые средства не сохраняются }
    Pen.Style:=psSolid;
    Pen.Width:=1;
    Pen.Color:=Color;     { я делаю установку цвета вида:
                            Cv.Pen.Color:=Self.Color !              }
    Brush.Color:=Color;   { Внимание! для простоты я задаю
                            цвет заполнения ткким же как и цвет пера}
    if Style<=10 then Brush.Style:=bsClear else Brush.Style:=bsSolid;
                     { если Style>10 то это заполненная метка-значок}
    LocB:=Style;     { см. ниже }
    if LocB>10 then LocB:=LocB mod 10;
       { для объединения меток одного вида, но с разл. заполнением  }
    case LocB of
    mpCircle: Ellipse(X-Radius,Y-Radius,X+Radius,Y+Radius);
    mpUpTreangle: Polygon([Point(X,Y-Radius),
                           Point(X-Radius,Y+Radius),
                           Point(X+Radius,Y+Radius)]);
    mpTreangle: Polygon([Point(X-Radius,Y-Radius),
                         Point(X,Y+Radius),
                         Point(X+Radius,Y-Radius)]);
    mpRect:   Rectangle(X-Radius,Y-Radius,X+Radius,Y+Radius);
    mpRomb:   Polygon([Point(X-Radius,Y-Radius),
                        Point(X+Radius,Y-Radius),
                        Point(X+Radius,Y+Radius),
                        Point(X-Radius,Y+Radius)]);
    mpCross: begin
              Pen.Width:=2;
              MoveTo(X-Radius,Y);
              LineTo(X+Radius,Y);
              MoveTo(X,Y-Radius);
              LineTo(X,Y+Radius);
             end;
    mpDiag: begin
              MoveTo(X-Radius,Y-Radius);
              LineTo(X+Radius,Y+Radius);
              MoveTo(X+Radius,Y-Radius);
              LineTo(X-Radius,Y+Radius);
            end;
    mpArrow: begin
              MoveTo(X-Radius,Y);
              LineTo(X+Radius,Y);
              MoveTo(X,Y-Radius);
              LineTo(X,Y+Radius);
              MoveTo(X-Radius,Y-Radius);
              LineTo(X+Radius,Y+Radius);
              MoveTo(X+Radius,Y-Radius);
              LineTo(X-Radius,Y+Radius);
             end;
    mpPoint:  Pixels[X,Y]:=Pen.Color;
    end; { case }
   end; { with Cv,Pt }
 end;

 procedure TMark.DrawTitle(const S:string; const Cv:TCanvas;Pt:Tpoint);
  begin
   if S='' then exit; { пустую надпись рисовать не надо            }
   with Cv do
    begin
      Font.Assign(Self.Font);
             { установки шрифта Cv.Font заменяются без сохранения  }
       { Font.Color:=Self.Color; }
      SetTextAlign(Handle,ta_left+ta_bottom);
             {надпись снизу и справа от точки                      }
      Brush.Style:=bsClear; { старый стиль кисти не сохраняется
                              bsClear обесп. прозрачный фон надписи}
      TextOut(Pt.X+1,Pt.Y-1,S);
    end;
  end;

{ _________________________________________________________________ }
{ *********************    TCurve          ************************ }
{ ----------------------------------------------------------------  }

{ ------------------private  - методы доступа --------------------  }
function TCurve.GetData(Index:integer):Tpoint;
  begin
   Result.X:=0;  { что-то возвращаем всегда }
   Result.Y:=0;
   if (DataList.Count=0)or (index<0) or (index>=DataList.Count) then exit;
   Result:=((DataList.Objects[Index])as TDataPoint).Point;
  end;

function TCurve.GetCount:integer;
 begin
  Result:=DataList.Count;
 end;

procedure TCurve.SetMaxCount(Value:integer);
 begin
  if Value<=1 then exit; { cтранный случай списка точек }
  FMaxCount:=Value;
  while FMaxCount<DataList.Count do
    DataList.Delete(0); { корректируем список точек в соотв. с новым
                          ограничением длины этого списка            }
 end;

function TCurve.GetColor:TColor;
 begin
   Result:=Pen.Color;
 end;
procedure TCurve.SetColor(Value:TColor);
 begin
   Pen.Color:=Value;
 end;
{------------ public методы ----------------------------------------}

 procedure TCurve.ClearPoints;
  begin
   DataList.Clear;
  end;

 procedure TCurve.AddPoint(const S:string; Pt:Tpoint);
 var TMP_Data : TDataPoint;
  begin
   with DataList do
    if Count>0 then
      if ((Objects[Count-1] as TDataPoint).X=Pt.X)
       and ((Objects[Count-1] as TDataPoint).Y=Pt.Y) then
          begin  { добавляемая точка совпадает с последней в списке }
           Strings[Count-1]:=S;{ изменяем надпись точки             }
           exit;
          end;
   TMP_Data:= TDataPoint.Create;
   TMP_Data.Point:=Pt;            {созд. новая точка с зад. коорд.  }
   DataList.AddObject(S,TMP_Data);{добав. вместе со сторкой-надписью}
   if DataList.Count>FMaxCount then DataList.Delete(0);
         {при превышении числа эл.-тов в списке первый удаляем      }
  end;

procedure TCurve.AddDataPoint(X,Y:extended;Pt:Tpoint);
 var TMP_Data : TDataPoint;
     LocS:String;
  begin
   LocS:=Concat('(',FloatToStrF(X,ffgeneral,3,3),', ',
                    FloatToStrF(Y,ffgeneral,3,3),')');
                 {формат надписи рядом с точкой по умолчанию        }
    {комментарии - см. выше для AddPoint }
   with DataList do
    if Count>0 then
      if ((Objects[Count-1] as TDataPoint).X=Pt.X)
       and ((Objects[Count-1] as TDataPoint).Y=Pt.Y) then
          begin
           Strings[Count-1]:=LocS;
           exit;
          end;
   TMP_Data:= TDataPoint.Create;
   TMP_Data.Point:=Pt;
   DataList.AddObject(LocS,TMP_Data);
   if DataList.Count>FMaxCount then DataList.Delete(0);
  end;

procedure TCurve.GoStepX(St:integer);
var il:integer;
 begin
  il:=0;
  while il<DataList.Count do  { проходим весь список точек }
   begin
    (DataList.Objects[il] as TDataPoint).X:=
       (DataList.Objects[il] as TDataPoint).X-St;
    Inc(il);
   end;
 end;

procedure TCurve.GoStepY(St:integer);
var il:integer;
 begin
  il:=0;
  while il<DataList.Count do  { проходим весь список точек }
   begin
    (DataList.Objects[il] as TDataPoint).Y:=
       (DataList.Objects[il] as TDataPoint).Y+St;
    Inc(il);
   end;
 end;

procedure TCurve.Draw(const Cv:TCanvas);
var il:integer;
    LocPt1,LocPt2:TPoint;
    {эти переменные нужны для организации правильной логики
     работы. Порядок такой:
      1. рисуем линию из точки 1 в точку 2
      2. рисуем метку (если стиль меток требует) в точке 1
      3. рисуем надпись (если надо) в точке 1               }
 begin
  Cv.Pen.Assign(Pen); {старые уст. пера теряются }
  with Cv,DataList do
   begin
    if Count<=0 then exit; { пустой список точек }
    LocPt1:=(Objects[0] as TDataPoint).Point;
    LocPt2:=LocPt1;
    MoveTo(LocPt1.X,LocPt1.Y);
     il:=1;
     while il<Count do { рисуем весь список точек начиная с 1}
       begin
         LocPt1:=(Objects[il] as TDataPoint).Point;
         LineTo(LocPt1.X,LocPt1.Y);
         if Mark.Style<>mpNone then   {метки нужно рисовать  }
                Mark.Draw(Cv,LocPt2); {- что и делаем        }
         if Titled then               {видимые надписи       }
            Mark.DrawTitle(Strings[il-1],Cv,LocPt2);
         LocPt2:=LocPt1;
         Pen.Assign(Self.Pen);     {при рисов. меток нарушили
                                     установки пера          }
         MoveTo(LocPt1.X,LocPt1.Y);{при рисов. меток
                                     указатель сместился     }
         Inc(il);
       end; { while }
     { в конце вывода требуется нарисовать метку и надпись
       для последней точки списка                            }
     if Mark.Style<>mpNone then
        begin
         Mark.Draw(Cv,LocPt1);
         Pen.Assign(Self.Pen);
        end;
       if Titled then
        begin
         Mark.DrawTitle(Strings[il-1],Cv,LocPt1);
        end;
   end; {with Cv,DataList.... }
 end;

 procedure TCurve.DrawExample(const Cv:TCanvas;Left,Top,Width:integer);
  begin
   Cv.Pen.Assign(Self.Pen);
    with Cv do
     begin
      MoveTo(Left,Top);
      LineTo(Left+Width,Top);
      Mark.Draw(Cv,Classes.Point(Left+Width div 2,Top));
     end; 
  end;

 constructor TCurve.Create;
  begin
   Inherited Create;
   Titled:=false;
   Name:='';
   DataList:=TStringList.Create;
   Mark:=TMark.Create;
   Pen:=TPen.Create;
   FMaxCount:=100;{от балды - по моему это наиболее корректное число}
  end;

 destructor TCurve.Destroy;
  begin
   DataList.Free;
   Mark.free;
   Pen.free;
   Inherited Destroy;
  end;

end.
