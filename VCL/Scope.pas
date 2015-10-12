//  unit Scope version 1.0
//  Copyright (c) 1999 by Andrew V. Tumashinoff

unit Scope;

interface

uses
  Windows, Classes, ConstDef, Controls, Graphics, dialogs,DateUtils, messages;



type  BorderLine = record
  bColor: TColor;
  state: boolean;
  value: double;
end;

type arrBoolean =array [0..15] of boolean;
type     arrTPoint =array [0..15] of TPoint;


  TScopeList = class;

  TDataOrientation = (doLeftToRight, doTopToBottom);

  TIndicator = class(TPersistent)
  private
    // переменные, задающие отступы для отображения доп. информации
    FMARGIN_LEFT   : Integer;
    FMARGIN_RIGHT  : Integer;
    FMARGIN_TOP    : Integer;
    FMARGIN_BOTTOM : Integer;
    //
    FFont : TFont;
    lastleft,lastright: tdatetime;
    curleft,curright: tdatetime;
    FGridFont : TFont;
    //MaxStY, MinStY: integer;
    FCaption : String;
    Fgpen : TPen;              // цвет графика
    FTag : Integer;
    FBackground : TColor;         // цвет фона индикатора
    FAxisColor : TColor;          // цвет осей
    FGridColor,FTowColor : TColor;          // цвет сетки
    FFullGrid : Boolean;          // рисовать ли полную сетку
    FSlide : Boolean;             // режим скольжения
    fIsDiscret: boolean;
    FOrientation : TDataOrientation; // тип скольжения графика
    FWorldLeft : Double;          // левая граница мирового диапазона
    FWorldRight : Double;         // правая граница мирового диапазона
    FWorldTop : Double;           // верхняя граница мирового диапазона
    FWorldBottom : Double;        // нижняя граница мирового диапазона
    // autochanging fields
    TxtRect : TRect;      // область клиппинга текста
    Width : Integer;      // ширина индикатора, предназначенная для графика
    Height : Integer;     // высота индикатора, предназначенная для графика
    FWorldWidth : Double;  // отображаемый диапазон длины в метрах
    FWorldHeight : Double; // отображаемый диапазон высоты в метрах
    Step : TDPoint;       // шаги сетки
    //-------------

    FBounds : TRect;              // окно индикатора в Scope



    OwnerScope : TCustomControl;
    Canvas : TCanvas;
    procedure DrawSelfLine(p1,p2: TDpoint;number: integer);
    function getScrect: TRect;

    procedure UpdateOwnerView;
//    procedure DrawPoint(P : TDPoint);       // нарисовать точку
    procedure FontChanged(Sender : TObject);

    procedure FSetFont(Value : TFont);
    procedure FSetGridFont(Value : TFont);
    procedure FSetBackground(Value : TColor);
    procedure FSetgpen(Value : Tpen);
    procedure FSetGridColor(Value : TColor);
    procedure FSetAxisColor(Value : TColor);
    procedure FSetCaption(Value : String);
    procedure FSetOrientation(Value : TDataOrientation);
    procedure FSetFullGrid(Value : Boolean);
    procedure FSetSlide(Value : Boolean);
    procedure FSetWorldLeft(Value : Double);
    procedure FSetWorldRight(Value : Double);
    procedure FSetWorldTop(Value : Double);
    procedure FSetWorldBottom(Value : Double);
    procedure FSetMARGIN_LEFT(Value : Integer);
    procedure FSetMARGIN_RIGHT(Value : Integer);
    procedure FSetMARGIN_TOP(Value : Integer);
    procedure FSetMARGIN_BOTTOM(Value : Integer);
    function GetActiv(Pc : TDPoint): boolean;
  public
     startTime: TDateTime;
    TimePer: TTime;
    resabs: tTDPoint;
    firstAbsence: boolean;
    AvLo: BorderLine;
    AvHi: BorderLine;
    AlLo: BorderLine;
    AlHi: BorderLine;
    horlable: boolean;
    FDST: boolean;
    Scale : TDPoint;             // масштаб по осям  scale=pixels/meters
    FFirstPoint : arrBoolean;
     FLastPoint : arrTPoint;
    initline : boolean;
     FOrigin : TDPoint;            // мировые координаты левого нижнего угла FBounds
    procedure setcurleft(val: Tdatetime);
    procedure setcurright(val: Tdatetime);
    procedure DrawlinesFirst;
   function DrawGridStStop(Pn : TDPoint;Pc : TDPoint): boolean;
   constructor Create(aBounds : TRect; aColor, aBackground, aAxisColor : TColor);
    destructor Destroy; override;
    procedure SetBounds(aBounds : TRect);
    function WorldToScreen(P : TDPoint) : TPoint;
    function ScreenToWorld(P : TPoint) : TDPoint;
    procedure SetWorldWidth(X : TDPoint);   // установка масштаба для отображения соотв. мировых координат
    procedure SetWorldHeight(Y : TDPoint);  // установка масштаба для отображения соотв. мировых координат
    procedure Draw;
    procedure DrawGrid(inBounds : TRect; WithMarginsX, WithMarginsY  : Boolean);
    procedure AddPoint(P : TDPoint;number: byte; active: boolean);
    procedure AddPointP(P : TDPoint;number: byte);
    procedure SlideWorld(delta : Double);
    procedure SlideScreen(delta : Integer);
    procedure Drawlines;
    function PtInGraphicRect(Pt : TPoint) : Boolean;
    property lineR: TDatetime read curright write setcurright;
    property lineL: TDatetime read curLeft write setcurLeft;
  published
    property ScrRect: TRect read getScrect;
    property Font : TFont read FFont write FSetFont;
    property GridFont : TFont read FGridFont write FSetGridFont;
    property Caption : String read FCaption write FSetCaption;
    property Tag : Integer read FTag write FTag;
    property Background : TColor read FBackground write FSetBackground;
    property  gPen: TPen read Fgpen write FSetgpen;
    property  TowColor: TColor read FTowColor write FTowColor default 12345;
    property AxisColor : TColor read FAxisColor write FSetAxisColor;
    property GridColor : TColor read FGridColor write FSetGridColor;
    property FullGrid : Boolean read FFullGrid write FSetFullGrid;
    property Slide : Boolean read FSlide write FSetSlide;
    property Orientation : TDataOrientation read FOrientation write FSetOrientation;

    property WorldLeft : Double read FWorldLeft write FSetWorldLeft;
    property WorldRight : Double read FWorldRight write FSetWorldRight;
    property WorldTop : Double read FWorldTop write FSetWorldTop;
    property WorldBottom : Double read FWorldBottom write FSetWorldBottom;

    property MARGIN_LEFT : Integer read FMARGIN_LEFT write FSetMARGIN_LEFT;
    property MARGIN_RIGHT : Integer read FMARGIN_RIGHT write FSetMARGIN_RIGHT;
    property MARGIN_TOP : Integer read FMARGIN_TOP write FSetMARGIN_TOP;
    property MARGIN_BOTTOM : Integer read FMARGIN_BOTTOM write FSetMARGIN_BOTTOM;
    property isDiscret: boolean read fisDiscret write fIsDiscret;
  end;


   TIndicatorMulti = class(TPersistent)
  private
    // переменные, задающие отступы для отображения доп. информации
    FMARGIN_LEFT   : Integer;
    FMARGIN_RIGHT  : Integer;
    FMARGIN_TOP    : Integer;
    FMARGIN_BOTTOM : Integer;
    FFont : TFont;
    FGridFont : TFont;
    FCaption : String;
    Fgpen : TPen;              // цвет графика
    FTag : Integer;
    FBackground : TColor;         // цвет фона индикатора
    FAxisColor : TColor;          // цвет осей
    FGridColor,FTowColor : TColor;          // цвет сетки
    FFullGrid : Boolean;          // рисовать ли полную сетку
    FSlide : Boolean;             // режим скольжения
    fIsDiscret: boolean;
    FOrientation : TDataOrientation; // тип скольжения графика
    FWorldLeft : Double;          // левая граница мирового диапазона
    FWorldRight : Double;         // правая граница мирового диапазона
         // нижняя граница мирового диапазона
    TxtRect : TRect;      // область клиппинга текста
    Width : Integer;      // ширина индикатора, предназначенная для графика
    Height : Integer;     // высота индикатора, предназначенная для графика
    FWorldWidth : Double;  // отображаемый диапазон длины в метрах
    FWorldHeight : array [0..7] of Double; // отображаемый диапазон высоты в метрах
    Step :array [0..7] of TDPoint;       // шаги сетки
    //-------------
    FOrigin : array [0..7] of TDPoint;            // мировые координаты левого нижнего угла FBounds
    FBounds : TRect;              // окно индикатора в Scope
    OwnerScope : TCustomControl;
    Canvas : TCanvas;
    procedure DrawSelfLine(p1,p2: TDpoint; index: integer);
    function getScrect: TRect;
    procedure UpdateOwnerView;
    procedure FontChanged(Sender : TObject);
    procedure FSetFont(Value : TFont);
    procedure FSetGridFont(Value : TFont);
    procedure FSetBackground(Value : TColor);
    procedure FSetgpen(Value : Tpen);
    procedure FSetGridColor(Value : TColor);
    procedure FSetAxisColor(Value : TColor);
    procedure FSetCaption(Value : String);
    procedure FSetOrientation(Value : TDataOrientation);
    procedure FSetFullGrid(Value : Boolean);
    procedure FSetSlide(Value : Boolean);
    procedure FSetWorldLeft(Value : Double);
    procedure FSetWorldRight(Value : Double);
    procedure FSetWorldTop(index: integer; Value : Double);
    procedure FSetWorldBottom(index: integer; Value : Double);
    procedure FSetMARGIN_LEFT(Value : Integer);
    procedure FSetMARGIN_RIGHT(Value : Integer);
    procedure FSetMARGIN_TOP(Value : Integer);
    procedure FSetMARGIN_BOTTOM(Value : Integer);
    function GetActiv(Pc : TDPoint; index: integer): boolean;
  public
     FWorldTop : array [0..7] of Double;           // верхняя граница мирового диапазона
    FWorldBottom : array [0..7] of  Double;
    startTime: TDateTime;
    TimePer: TTime;
    resabs: array [0..7] of tTDPoint;
    firstAbsence: boolean;
    horlable: boolean;
    FDST: boolean;
    Scale : array [0..7] of TDPoint;             // масштаб по осям  scale=pixels/meters
    FFirstPoint : array [0..7] of Boolean;
    FLastPoint : array [0..7] of TPoint;
    function DrawGridStStop(Pn : TDPoint;Pc : TDPoint): boolean;
    constructor Create(aBounds : TRect; aColor, aBackground, aAxisColor : TColor);
    destructor Destroy; override;
    procedure SetBounds(aBounds : TRect);
    function WorldToScreen(P : TDPoint; index: integer) : TPoint;
    function ScreenToWorld(P : TPoint; index: integer) : TDPoint;
    procedure SetWorldWidth(X : TDPoint);   // установка масштаба для отображения соотв. мировых координат
    procedure SetWorldHeight(Y : TDPoint;  index: integer);  // установка масштаба для отображения соотв. мировых координат
    procedure Draw;
    procedure DrawGrid(inBounds : TRect; WithMarginsX, WithMarginsY  : Boolean);
    procedure AddPoint(P : TDPoint;index: byte; active: boolean; delt: real; min : real);
    procedure AddPointP(P : TDPoint;index: byte; delt: real; min : real);
    procedure SlideWorld(delta : Double);
    procedure SlideScreen(delta : Integer);
    function PtInGraphicRect(Pt : TPoint) : Boolean;
  published
    property ScrRect: TRect read getScrect;
    property Font : TFont read FFont write FSetFont;
    property GridFont : TFont read FGridFont write FSetGridFont;
    property Caption : String read FCaption write FSetCaption;
    property Tag : Integer read FTag write FTag;
    property Background : TColor read FBackground write FSetBackground;
    property  gPen: TPen read Fgpen write FSetgpen;
    property AxisColor : TColor read FAxisColor write FSetAxisColor;
    property GridColor : TColor read FGridColor write FSetGridColor;
    property FullGrid : Boolean read FFullGrid write FSetFullGrid;
    property Slide : Boolean read FSlide write FSetSlide;
    property Orientation : TDataOrientation read FOrientation write FSetOrientation;

    property WorldLeft : Double read FWorldLeft write FSetWorldLeft;
    property WorldRight : Double read FWorldRight write FSetWorldRight;
    property WorldTop_1 : Double  index 0 read FWorldTop[0] write FSetWorldTop;
    property WorldBottom_1 : Double index 0 read FWorldBottom[0] write FSetWorldBottom;
    property WorldTop_2 : Double  index 1 read FWorldTop[1] write FSetWorldTop;
    property WorldBottom_2 : Double index 1 read FWorldBottom[1] write FSetWorldBottom;
    property WorldTop_3 : Double  index 2 read FWorldTop[2] write FSetWorldTop;
    property WorldBottom_3 : Double index 2 read FWorldBottom[2] write FSetWorldBottom;
    property WorldTop_4 : Double  index 3 read FWorldTop[3] write FSetWorldTop;
    property WorldBottom_4 : Double index 3 read FWorldBottom[3] write FSetWorldBottom;
    property WorldTop_5 : Double  index 4 read FWorldTop[4] write FSetWorldTop;
    property WorldBottom_5 : Double index 4 read FWorldBottom[4] write FSetWorldBottom;
    property WorldTop_6 : Double  index 5 read FWorldTop[5] write FSetWorldTop;
    property WorldBottom_6 : Double index 5 read FWorldBottom[5] write FSetWorldBottom;
    property WorldTop_7 : Double  index 6 read FWorldTop[6] write FSetWorldTop;
    property WorldBottom_7 : Double index 6 read FWorldBottom[6] write FSetWorldBottom;
    property WorldTop_8 : Double  index 7 read FWorldTop[7] write FSetWorldTop;
    property WorldBottom_8 : Double index 7 read FWorldBottom[7] write FSetWorldBottom;

    property MARGIN_LEFT : Integer read FMARGIN_LEFT write FSetMARGIN_LEFT;
    property MARGIN_RIGHT : Integer read FMARGIN_RIGHT write FSetMARGIN_RIGHT;
    property MARGIN_TOP : Integer read FMARGIN_TOP write FSetMARGIN_TOP;
    property MARGIN_BOTTOM : Integer read FMARGIN_BOTTOM write FSetMARGIN_BOTTOM;
    property isDiscret: boolean read fisDiscret write fIsDiscret;
  end;

  TIndicatorList = class(TList)
    OwnerScope : TCustomControl;
    Canvas : TCanvas;
    constructor Create(AOwnerScope : TCustomControl);
    procedure AddIndicator(I : TIndicator);
    procedure FreeAll;
    destructor Destroy; override;
    procedure Draw(Canvas : TCanvas);
  end;

  TBufferedControl = class(TCustomControl)
  private
    Created : Boolean;
    FBackground : TColor;
    FUpdating : Boolean;
    Buffer : TBitmap;

    procedure FSetBackground(Value : TColor);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Draw; virtual;
    procedure UpdateView;  // called to update view when property's changed

    procedure BeginUpdate;
    procedure EndUpdate;
    property Canvas;
    property Background : TColor read FBackground write FSetBackground;
  end;

  TScope = class(TBufferedControl)
  private
    FIndicator : TIndicator;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    err: boolean;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Draw; override;
    procedure Repaint; override;
   // procedure Refresh; override;
  published
    
    property Align;
    property OnMouseMove;
    property OnResize;
    property Background;
    property Indicator : TIndicator read FIndicator write FIndicator;
  end;


  TScopeArray = class(TBufferedControl)
  private
    FIndicatorMulti : TIndicatorMulti;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    err: boolean;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Draw; override;
    procedure Repaint; override;
  published
    property Align;
    property OnMouseMove;
    property OnResize;
    property Background;
    property IndicatorMulti : TIndicatorMulti read FIndicatorMulti write FIndicatorMulti;
  end;

  TScopeList = class(TBufferedControl)
  public

    Indicators : TIndicatorList;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Draw; override;

  published
    property Align;
    property OnMouseMove;
    property OnResize;
    property Background;
    property Width;
    property Height;
    property Top;
    property Left;
  end;

function DPoint(aX, aY : Double) : TDPoint;
function GetHalfColor(C : TColor) : TColor;
procedure Register;

implementation

uses
  Math, SysUtils, Forms;

function Min(A,B : Double) : Double;
begin
  if A <= B then
    Result := A
  else
    Result := B;
end;

function Max(A,B : Double) : Double;
begin
  if A >= B then
    Result := A
  else
    Result := B;
end;

function DPoint(aX, aY : Double) : TDPoint;
begin
  Result[1] := aX;
  Result[2] := aY;
end;

function GetHalfColor(C : TColor) : TColor;
var
  F, R, G, B : Byte;
begin
  F := (C shr 24);
  R := (C shl 08) shr 24;
  G := (C shl 16) shr 24;
  B := (C shl 24) shr 24;

  R := R div 2;
  G := G div 2;
  B := B div 2;

  Result := F shl 8;
  Result := (Result + R) shl 8;
  Result := (Result + G) shl 8;
  Result := Result + B;
//  beep;
end;



//******** TIndicator *********
procedure TIndicator.DrawSelfLine(p1,p2: TDpoint;number: integer);
var deltx,delty: double;
    ddeltx,ddelty: double;
    dX,I: integer;
    curP1,curP2: TDpoint;
    TR: tRECT;
    startYbb, stopYbb: integer;
    MaxStY, MinStY: integer;
    MaxStX, MinStX: integer;
begin
  MaxStY:=FBounds.Bottom-FMARGIN_BOTTOM;
  MinStY:=FBounds.Top+FMARGIN_TOP;
  MinStX:=FBounds.Left+FMARGIN_LEFT;
  MaxStX:=FBounds.right-FMARGIN_Right;

  if (FLastPoint[number].x < FBounds.Left)
  then FLastPoint[number].x:=FBounds.Left;
  if (worldtoscreen(p1).x < FBounds.Left)
  then p1[1]:=FWorldLeft;
  if (worldtoscreen(p2).x < FBounds.Left)
  then p2[1]:=FWorldLeft;
  if (worldtoscreen(p2).x >FBounds.Right)
  then p1[1]:=FBounds.Right;
  if (worldtoscreen(p1).x >FBounds.Right)
  then p1[1]:=FBounds.Right;
  if (FLastPoint[number].x >FBounds.Right)
  then FLastPoint[number].X:=FBounds.Right;
 //Canvas.MoveTo(FLastPoint[number].x, FLastPoint[number].y);
 try
 canvas.lock;
 deltx:=p2[1]-p1[1];
 delty:=p2[2]-p1[2];
 dX:=worldtoscreen(p2).X-worldtoscreen(p1).X;
 if dX=0 then
  begin
    if getactiv(p1) then
      begin
      startYbb:=worldtoscreen(p1).y;
      stopYbb:= worldtoscreen(p2).y;
      if startYbb>MaxStY then startYbb:=MaxStY;
      if startYbb<MinStY then startYbb:=MinStY;
      if stopYbb>MaxStY then stopYbb:=MaxStY;
      if stopYbb<MinStY then stopYbb:=MinStY;
      Canvas.MoveTo(worldtoscreen(p1).x, startYbb);
      if not((startYbb=StopYbb) and ((StartYbb=MaxStY) or (stopYbb=MinStY))) and ((worldtoscreen(p2).x<=MaxStX) and (worldtoscreen(p2).x>=MinStX)) then
      Canvas.LineTo(worldtoscreen(p2).x, stopYbb)
      else
       Canvas.MoveTo(worldtoscreen(p2).x, stopYbb)
      end
    else
      begin
      tr.Left:=worldtoscreen(p2).x-1;
      tr.Right:=worldtoscreen(p2).X;
      canvas.Brush.Color:=clGray;
      tr.Top:=ScrRect.Top+FMARGIN_TOP+3;
      tr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
      if ((worldtoscreen(p2).x<MaxStX) and (worldtoscreen(p2).x>MinStX)) then Canvas.FillRect(tr);
      Canvas.MoveTo(worldtoscreen(p2).x, worldtoscreen(p2).y);
      end;
  end
 else
  begin
    Canvas.MoveTo(FLastPoint[number].x, FLastPoint[number].y);
    ddeltx:=deltx/dx;
    ddelty:=delty/dx;
    for i:=0 to dx-1 do
      begin
        curp1[1]:=p1[1]+ddeltx*i;
        curp2[1]:=p1[1]+ddeltx*(i+1);
        curp1[2]:=p1[2]+ddeltY*i;
        curp2[2]:=p1[2]+ddeltY*(i+1);
         if getactiv(curp1) then
            begin
            startYbb:=worldtoscreen(curp1).y;
            stopYbb:= worldtoscreen(curp2).y;
            if startYbb>MaxStY then startYbb:=MaxStY;
            if startYbb<MinStY then startYbb:=MinStY;
            if stopYbb>MaxStY then stopYbb:=MaxStY;
            if stopYbb<MinStY then stopYbb:=MinStY;
            Canvas.MoveTo(worldtoscreen(curp1).x, startYbb);
             if not((startYbb=StopYbb) and ((StartYbb=MaxStY) or (stopYbb=MinStY))) and ((worldtoscreen(curp1).x<MaxStX) and (worldtoscreen(curp1).x>MinStX)) then
            Canvas.LineTo(worldtoscreen(curp2).x, stopYbb) else
            Canvas.MoveTo(worldtoscreen(curp2).x, stopYbb) ;
            end
         else
            begin
            tr.Left:=worldtoscreen(curp2).x-1;
            tr.Right:=worldtoscreen(curp2).X;
            canvas.Brush.Color:=clGray;
            tr.Top:=ScrRect.Top+FMARGIN_TOP+3;
            tr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
             if ((worldtoscreen(curp2).x<=MaxStX) and (worldtoscreen(curp2).x>=MinStX)) then Canvas.FillRect(tr);
            Canvas.moveto(worldtoscreen(curp2).x, worldtoscreen(curp2).y);
            end;
      end;
  end;
  finally
  canvas.unlock;
  end;
end;

constructor TIndicator.Create(aBounds : TRect; aColor, aBackground, aAxisColor : TColor);
var i: integer;
begin
  inherited Create;
  firstAbsence:=false;
   startTime:=now;
  OwnerScope := nil;
  FFirstPoint[0] := True;
  FGridFont := TFont.Create;
  With FGridFont do begin
    OnChange := FontChanged;
    Name := 'Terminal';
    Size := 5;
    Style := [];
    Color := clWhite;
  end;
  FFont := TFont.Create;
  With FFont do begin
    OnChange := FontChanged;
    Name := 'MS Sans Serif';
    Size := 8;
    Style := [fsBold];
    Color := clWhite;
  end;
   initline:=false;
  FWorldWidth := 1;
  FWorldHeight := 1;
  SetBounds(aBounds);
  FCaption := '';
  Fgpen := TPen.Create;
  Fgpen.Color:=acolor;
  FBackground := aBackground;
  FAxisColor := aAxisColor;
  FGridColor := GetHalfColor(aAxisColor);
  // margins
  FMARGIN_LEFT   := 5;
  FMARGIN_RIGHT  := 5;
  FMARGIN_TOP    := 15;
  FMARGIN_BOTTOM := 5;

  Caption := '';
  Orientation := doLeftToRight;
   AlLo.state:=false;
   AlHi.state:=false;
   AvLo.state:=false;
   AvHi.state:=false;
   fIsDiscret:=false;
   horlable:=false;
   initline:=false;
end;

destructor TIndicator.Destroy;
begin
  Fgpen.Free;
  FGridFont.Free;
  FFont.Free;

  inherited;
end;

function TIndicator.GetActiv(Pc : TDPoint): boolean;
var j: integer;
begin
result:=true;
 for j:=0 to resabs.n-1 do
   begin
      if (pc[1]>=resabs.point[j][1]) and (pc[1]<=resabs.point[j][2]) then
        begin

        result:=false;
        exit;
        end;

   end;
end;

procedure TIndicator.UpdateOwnerView;
begin
  if Assigned(OwnerScope) then
    TBufferedControl(OwnerScope).UpdateView;
end;

procedure TIndicator.FontChanged(Sender : TObject);
begin
  UpdateOwnerView;
end;

procedure TIndicator.FSetFont(Value : TFont);
begin
  FFont.Assign(Value);
end;

procedure TIndicator.FSetGridFont(Value : TFont);
begin
  FGridFont.Assign(Value);
end;

procedure TIndicator.FSetBackground(Value : TColor);
begin
  FBackground := Value;
  UpdateOwnerView;
end;

procedure TIndicator.FSetgpen(Value : TPen);
begin
if value.Width<1 then value.Width:=1;
  Fgpen := Value;
  UpdateOwnerView;
end;

procedure TIndicator.FSetGridColor(Value : TColor);
begin
  FGridColor := Value;
  UpdateOwnerView;
end;

procedure TIndicator.FSetAxisColor(Value : TColor);
begin
  FAxisColor := Value;
  UpdateOwnerView;
end;

procedure TIndicator.FSetCaption(Value : String);
begin
  if FCaption <> Value then begin
    if (Value = '') and (FCaption <> '') then
      FMARGIN_TOP := FMARGIN_TOP - 10
    else
      if (Value <> '') and (FCaption = '') then
        FMARGIN_TOP := FMARGIN_TOP + 10;
    FCaption := Value;
    SetBounds(FBounds);
    UpdateOwnerView;
  end;
end;

procedure TIndicator.FSetOrientation(Value : TDataOrientation);
begin
  FOrientation := Value;
  case Value of
    doLeftToRight : begin
      FMARGIN_LEFT := FMARGIN_LEFT + 30;
      FMARGIN_TOP := FMARGIN_TOP - 10;
    end;
    doTopToBottom : begin
      FMARGIN_LEFT := FMARGIN_LEFT - 30;
      FMARGIN_TOP := FMARGIN_TOP + 10;
    end;
  end;
  SetBounds(FBounds);
  UpdateOwnerView;
end;

procedure TIndicator.FSetFullGrid(Value : Boolean);
begin
  FFullGrid := Value;
  UpdateOwnerView;
end;

procedure TIndicator.FSetSlide(Value : Boolean);
begin
  FSlide := Value;
  UpdateOwnerView;
end;

procedure TIndicator.FSetWorldLeft(Value : Double);
begin
  FWorldLeft := Value;
  if (FWorldLeft<>FWorldRight)  then
  SetWorldWidth(DPoint(FWorldLeft, FWorldRight));
//  SetBounds(FBounds);
  UpdateOwnerView;
end;

procedure TIndicator.FSetWorldRight(Value : Double);
begin
  FWorldRight := Value;
  SetWorldWidth(DPoint(FWorldLeft, FWorldRight));
  UpdateOwnerView;
end;

procedure TIndicator.FSetWorldTop(Value : Double);
begin
  FWorldTop := Value;
  if (FWorldBottom-FWorldTop)<>0 then SetWorldHeight(DPoint(FWorldBottom, FWorldTop));   // условие добавлено 25.10.2002 UpdateOwnerView;
 // MaxStY:=FBounds.Bottom-FMARGIN_BOTTOM;
  //MinStY:=FBounds.Top+FMARGIN_TOP;
  UpdateOwnerView;
end;

procedure TIndicator.FSetWorldBottom(Value : Double);
begin
  FWorldBottom := Value;
  if (FWorldBottom-FWorldTop)<>0 then SetWorldHeight(DPoint(FWorldBottom, FWorldTop));
  //MaxStY:=FBounds.Bottom-FMARGIN_BOTTOM;
 // MinStY:=FBounds.Top+FMARGIN_TOP;
  UpdateOwnerView;
end;

procedure TIndicator.FSetMARGIN_LEFT(Value : Integer);
begin
  FMARGIN_LEFT := Value;
  SetBounds(FBounds);
  UpdateOwnerView;
end;

procedure TIndicator.FSetMARGIN_RIGHT(Value : Integer);
begin
  FMARGIN_RIGHT := Value;
  SetBounds(FBounds);
  UpdateOwnerView;
end;

procedure TIndicator.FSetMARGIN_TOP(Value : Integer);
begin
  FMARGIN_TOP := Value;
  SetBounds(FBounds);
  //MaxStY:=FBounds.Bottom-FMARGIN_BOTTOM;
  //MinStY:=FBounds.Top+FMARGIN_TOP;
  UpdateOwnerView;

end;

procedure TIndicator.FSetMARGIN_BOTTOM(Value : Integer);
begin
  FMARGIN_BOTTOM := Value;
  SetBounds(FBounds);
  //MaxStY:=FBounds.Bottom-FMARGIN_BOTTOM;
  //MinStY:=FBounds.Top+FMARGIN_TOP;
  UpdateOwnerView;

end;

procedure TIndicator.SetBounds(aBounds : TRect);
var aBoundss : TRect;
begin
  FBounds := aBounds;
  Width := Abs(FBounds.Right - FBounds.Left) - FMARGIN_LEFT - FMARGIN_RIGHT-2;
  Height := Abs(FBounds.Bottom - FBounds.Top) - FMARGIN_TOP - FMARGIN_BOTTOM-2;

  Scale[1] := Width / FWorldWidth;
  Scale[2] := Height / FWorldHeight;

//  FWorldWidth := Width/Scale[1];
//  FWorldHeight := Height/Scale[2];
  if FDST then
  begin
  Step[1] := Power(10,Int(Log10(FWorldWidth))-1);
  end else
  begin
  Step[1] := Power(10,Int(Log10(FWorldWidth))-1);

  end;
  Step[2] := Power(10,Int(Log10(FWorldHeight))-1);
  While Round(Step[1]*Scale[1]) > 100 do
    Step[1] := Step[1]/2;
  While Round(Step[1]*Scale[1]) < 60 do
    Step[1] := Step[1]*2;

  While Round(Step[2]*Scale[2]) > 50 do
    Step[2] := Step[2]/2;
  While Round(Step[2]*Scale[2]) < 15 do
    Step[2] := Step[2]*2;
  if FDST then Step[1]:=Step[1]*2;
  aBoundss:=FBounds;
  aBoundss.TopLeft.Y:=aBoundss.TopLeft.Y-FMARGIN_Top+1;
  FLastPoint[0] := Point(FBounds.Right-FMARGIN_RIGHT-1, FBounds.bottom-FMARGIN_BOTTOM-1);
  FLastPoint[1] := Point(FBounds.Right-FMARGIN_RIGHT-1, FBounds.bottom-FMARGIN_BOTTOM-1);
  // область клиппинга текста
  TxtRect := aBoundss;
  Inc(TxtRect.Left,   FMARGIN_LEFT+1);
  Dec(TxtRect.Right,  FMARGIN_RIGHT+1);
  Inc(TxtRect.Top,    FMARGIN_TOP+1);
  Dec(TxtRect.Bottom, FMARGIN_BOTTOM+1);
  FTag := 1;

end;

function TIndicator.WorldToScreen(P : TDPoint) : TPoint;
begin
  try
  Result.x := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (P[1] - FOrigin[1])) + 1;
   except
  end;
  Result.y := FBounds.Top + FMARGIN_TOP - Round(Scale[2] * (P[2] - FOrigin[2])) + 1;

end;

function TIndicator.ScreenToWorld(P : TPoint) : TDPoint;
begin
  Result[1] := FOrigin[1] + (P.x - FBounds.Left - FMARGIN_LEFT - 1)/Scale[1];
  Result[2] := FOrigin[2] - (P.y - FBounds.Top - FMARGIN_TOP - 1)/Scale[2];
end;

procedure TIndicator.SetWorldWidth(X : TDPoint);
begin
  FOrigin[1] := Min(X[1], X[2]);
  FWorldWidth := Abs(X[1] - X[2]);
  FWorldLeft := FOrigin[1];
  FWorldRight := FOrigin[1] + FWorldWidth;
  SetBounds(FBounds);
end;

procedure TIndicator.SetWorldHeight(Y : TDPoint);
begin
  FOrigin[2] := Max(Y[1], Y[2]);
  FWorldHeight := Abs(Y[1] - Y[2]);
  FWorldTop := FOrigin[2];
  FWorldBottom := FOrigin[2] - FWorldHeight;
  SetBounds(FBounds);
end;




procedure TIndicator.Draw;
begin
  try
//  Canvas.lock;
//  внешний прямоугольник
  Canvas.Pen.Color := clWhite;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
//  Rectangle(Canvas.Handle, FBounds.Left, FBounds.Top, FBounds.Right+1, FBounds.Bottom+1);
//  внутренний прямоугольник
  Canvas.Brush.Color := FBackground;
  Canvas.Brush.Style := bsSolid;
  Rectangle(Canvas.Handle, FBounds.Left+FMARGIN_LEFT, FBounds.Top+FMARGIN_TOP, FBounds.Right+1-FMARGIN_RIGHT, FBounds.Bottom+1-FMARGIN_BOTTOM);
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(FFont);
  Canvas.TextOut(FBounds.Left+FMARGIN_LEFT,FBounds.Top+2, FCaption);

  DrawGrid(FBounds, True, True);
  finally
  //  canvas.unlock;
  end;
end;

procedure TIndicator.DrawlinesFirst;
  var
  sP,cp : integer;
  lP : TDPoint;
  postColor: TColor;
  tyr: TRect;
begin
  try
 // Canvas.lock;
  cp := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (curleft - FOrigin[1])) + 1;

  sP := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (curright - FOrigin[1]));
        //FFirstpoint[0]:=true;
        begin
          //Canvas.Brush.Color:=clred;
          Canvas.Pen.Color:=clRed;
          Canvas.pen.Mode:=pmXor;
          tyr.Left:=sp;
          tyr.Right:=sp;
          tyr.Top:=ScrRect.Top+FMARGIN_TOP+3;
          tyr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;

          Canvas.FillRect(tyr);
            tyr.Left:=cp;
          tyr.Right:=cp;
          tyr.Top:=ScrRect.Top+FMARGIN_TOP+3;
          tyr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;

          Canvas.FillRect(tyr);
          lastleft:=curleft;
          lastright:=curright;
        end;
  finally
  //Canvas.Unlock;
  end;

end;

procedure TIndicator.Drawlines;

  var
  sP,cp : integer;
  lP : TDPoint;
  postColor: TColor;
  tyr: TRect;
begin
  try
 // Canvas.lock;
{ if  initline then
 begin
 initline:=false;
 DrawlinesFirst;
 end; }
  cp := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (lastleft - FOrigin[1])) + 1;

  sP := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (lastright - FOrigin[1]));
        //FFirstpoint[0]:=true;
        begin
          //Canvas.Brush.Color:=clred;
          Canvas.Pen.Color:=clyellow;
           Canvas.Pen.Width:=1;
          Canvas.pen.Mode:=pmxor		;
          tyr.Left:=cp;
          tyr.Right:=cp+1;
          tyr.Top:=ScrRect.Top+FMARGIN_TOP+3;
          tyr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
          //Canvas.Rectangle(tyr);
          canvas.MoveTo(tyr.Left,tyr.Top);
           canvas.lineTo(tyr.Left,tyr.bottom);
          tyr.Left:=sp;
          tyr.Right:=sp+1;
          tyr.Top:=ScrRect.Top+FMARGIN_TOP+3;
          tyr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
          //Canvas.Rectangle(tyr);
          canvas.MoveTo(tyr.Left,tyr.Top);
           canvas.lineTo(tyr.Left,tyr.bottom);
        end;
  finally
  //Canvas.Unlock;
  end;
  try
  cp := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (curleft - FOrigin[1])) + 1;

  sP := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (curright - FOrigin[1]));
        //FFirstpoint[0]:=true;
        begin
          //Canvas.Brush.Color:=clred;
          Canvas.Pen.Color:=clyellow;
          Canvas.pen.Mode:=pmxor	;
          tyr.Left:=cp;
          tyr.Right:=cp+1;
          tyr.Top:=ScrRect.Top+FMARGIN_TOP+3;
          tyr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
           // Canvas.Rectangle(tyr);
          canvas.MoveTo(tyr.Left,tyr.Top);
           canvas.lineTo(tyr.Left,tyr.bottom);
          tyr.Left:=sp;
          tyr.Right:=sp+1;

          tyr.Top:=ScrRect.Top+FMARGIN_TOP+3;
          tyr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
          //Canvas.Rectangle(tyr);
           canvas.MoveTo(tyr.Left,tyr.Top);
           canvas.lineTo(tyr.Left,tyr.bottom);
           lastleft:=curleft;
          lastright:=curright;
        end;
  finally
  //Canvas.Unlock;
  end;
end;



function TIndicator.DrawGridStStop(Pn : TDPoint;Pc : TDPoint): boolean;

var
  sP,cp : integer;
  lP : TDPoint;
  postColor: TColor;
  tyr: TRect;
begin
  try
 // Canvas.lock;
  cp := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (Pc[1] - FOrigin[1])) + 1;

  sP := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (Pn[1] - FOrigin[1]));
        //FFirstpoint[0]:=true;
        begin
          Canvas.Brush.Color:=$002E2E2E;
          Canvas.Pen.Color:=clRed;

          tyr.Left:=sp+1;
          tyr.Right:=cp+1;
          tyr.Top:=ScrRect.Top+FMARGIN_TOP+3;
          tyr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;

          Canvas.FillRect(tyr);
         { Canvas.Rectangle(tyr);
          if (tyr.Right-tyr.Left)>20 then
            begin
              Canvas.TextRect(tyr,10,10,'Нет данных');
            end;   }
        end;
  finally
  //Canvas.Unlock;
  end;
end;

procedure TIndicator.DrawGrid(inBounds : TRect; WithMarginsX, WithMarginsY  : Boolean);
var
  sx, sy : Double;
  O, P,all,avl,alh,avh : TPoint;
  Z1, Z2, C : TDPoint;
  tw, th : Integer;
  num : String;
  dot_horz, dot_vert : Boolean;
  DrawNum : Boolean;
  GraphRect : TRect;
  td: TDateTime;
  rc: TRect;
  lasc: TColor;
begin
  try
 // Canvas.lock;
  canvas.Pen.Width:=1;
  DrawNum := True;

  GraphRect := inBounds;  // область для графика внутри индикатора
  if WithMarginsX then begin
    // сузить ее в соответствии с MARGINS left & right
    Inc(GraphRect.Left,   FMARGIN_LEFT+1);
    Dec(GraphRect.Right,  FMARGIN_RIGHT+1);
  end;
  if WithMarginsY then begin
    // сузить ее в соответствии с MARGINS top & bottom
    Inc(GraphRect.Top,    FMARGIN_TOP+1);
    Dec(GraphRect.Bottom, FMARGIN_BOTTOM+1);
  end;

  With Canvas do begin
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Brush.Style := bsClear;
    Font.Assign(FGridFont);


    O := WorldToScreen(DPoint(0, 0));

    dot_horz := (O.y > GraphRect.Top) and (O.y < GraphRect.Bottom);
    dot_vert := (O.x > GraphRect.Left) and (O.x < GraphRect.Right);

    // рисование насечек
    Z1 := ScreenToWorld(Point(GraphRect.Left+1, GraphRect.Top+1));
    Z2 := ScreenToWorld(Point(GraphRect.Right-1, GraphRect.Bottom-1));
    C[1] := Step[1]*Int(Z1[1]/Step[1]);
    C[2] := Step[2]*Int(Z2[2]/Step[2]);

    Pen.Color := FGridColor;
{    if FullGrid then
      Pen.Style := psDot
    else
      Pen.Style := psSolid;}

    // горизонтальная ось
    sx := C[1];
    While sx < Z1[1] do
      sx := sx + Step[1];
    While sx < Z2[1] do begin
      P := WorldToScreen(DPoint(sx, 0));
      if P.X <> O.x then begin
        if FFullGrid then begin
          MoveTo(P.x, GraphRect.Top+1);
          LineTo(P.x, GraphRect.Bottom);
        end
        else
        if dot_horz then begin
          MoveTo(P.x, O.y-2);
          LineTo(P.x, O.y+3);
        end;
      end; { if P.X }
      sx := sx + Step[1];
    end;




    // вертикальная ось
    sy := C[2];
    While sy < Z2[2] do
      sy := sy + Step[2];
    While sy < Z1[2] do begin
      P := WorldToScreen(DPoint(0, sy));
      if P.y <> O.y then begin
        if FFullGrid then begin
         MoveTo(GraphRect.Right-1{-(Tag mod 6)}, P.y);
         LineTo(GraphRect.Left, P.y);
        end
        else
        if dot_vert then begin
          MoveTo(O.x-2, P.y);
          LineTo(O.x+3, P.y);
        end;
      end; { if P.y }
      sy := sy + Step[2];
    end;

    // рисование осей
    Pen.Color := FAxisColor;
    Pen.Style := psSolid;
    if dot_vert then begin
      { вертикальная ось }
      Moveto(O.x, GraphRect.Top+1);
      LineTo(O.x, GraphRect.Bottom);
    end;
    if dot_horz then begin
      { горизонтальная ось }
      Moveto(GraphRect.Left+1, O.y);
      LineTo(GraphRect.Right, O.y);
    end;

  {   if allo.state then begin
      { горизонтальная ось }
    {   pen.color:=allo.bColor;
     // brush.Color:=allo.bColor;
   //   brush.Style:=bsDiagCross;

      Moveto(GraphRect.Left+1, all.y);
      LineTo(GraphRect.Right, all.y);
    {  rc.Left:=GraphRect.Left+1;
      rc.Right:=GraphRect.Right+1;
      rc.bottom:=GraphRect.bottom;
      rc.top:=all.Y;
      Rectangle(rc);}
   { end;

      {if avlo.state then begin
      { горизонтальная ось }
      { pen.color:=avlo.bColor;
      Moveto(GraphRect.Left+1, avl.y);
      LineTo(GraphRect.Right, avl.y);
    end;

     if alhi.state then begin
      { горизонтальная ось }
     {  pen.color:=alhi.bColor;
      Moveto(GraphRect.Left+1, alh.y);
      LineTo(GraphRect.Right, alh.y);
    end;

      if avhi.state then begin
      { горизонтальная ось }
      { pen.color:=avhi.bColor;
      Moveto(GraphRect.Left+1, avh.y);
      LineTo(GraphRect.Right, avh.y);
    end;      }

 //   canvas.Font.Assign(self.FFont);
    // горизонтальная ось - надпись текста
    if horlable then
    begin
    sx := C[1];
    lasc:=canvas.Font.Color;
 //   canvas.Font.Color:=fgridcolor;
    While sx < Z1[1] do
      sx := sx + Step[1];
    While sx < Z2[1] do begin
      P := WorldToScreen(DPoint(sx, 0));
      if DrawNum then begin
        if FDST then
        begin
          if TimePer<incsecond(0,9) then
          num := FormatDateTime('hh:nn:ss.zzz',sx)
          else
          num := TimeToStr(sx);
        end else
        num := TimeToStr(sx); //FloatToStr(sx)
        tw := TextWidth(num);
        th := TextHeight(num);
        case FOrientation of
          doLeftToRight :

            if FFullGrid then begin
              if  FMARGIN_TOP<th+3 then  MARGIN_TOP:=th+2;
              if FSlide then
                TextRect(TxtRect, P.x-tw, TxtRect.Top, num)
              else
                if abs(sx) < 1E-15 then
                  TextRect(TxtRect, P.x-tw, TxtRect.Top, num)
                else
                  TextRect(TxtRect, P.x-tw div 2, TxtRect.Top, num);
            end
            else begin
              if FSlide then
                TextRect(TxtRect, P.x-tw, O.Y-th-2, num)
              else
                if abs(sx) < 1E-15 then
                  TextRect(TxtRect, P.x-tw, O.Y-th-2, num)
                else
                  TextRect(TxtRect, P.x-tw div 2, O.Y-th-2, num);
            end;

          doTopToBottom : TextRect(FBounds, P.x-tw div 2, TxtRect.Top-th-2, num)
        end;
      end;
      sx := sx + Step[1];
    end;
    canvas.Font.Color:=lasc;
    end;

    // вертикальная ось - надпись текста
    sy := C[2];
    While sy < Z2[2] do
      sy := sy + Step[2];
    While sy < Z1[2] do begin
      P := WorldToScreen(DPoint(0, sy));
      if DrawNum then begin
        if Abs(sy) > 1E-15 then
          num := FloatToStrF(sy, ffGeneral, 9, 2)
        else
          num := '0';
        tw := TextWidth(num);
        th := TextHeight(num);
        case FOrientation of
          doLeftToRight : TextRect(FBounds, TxtRect.Left-tw-2, P.y-th div 2, num);
          doTopToBottom :
            if FFullGrid then begin
              if FSlide then
                TextRect(TxtRect, TxtRect.Left+2, P.y, num)
              else
                TextRect(TxtRect, TxtRect.Left+2, P.y-th div 2, num);
            end
            else begin
              if FSlide then
                TextRect(TxtRect, O.x-tw-2, P.y, num)
              else
                TextRect(TxtRect, O.x-tw-2, P.y - th div 2, num);
            end;
        end;
      end;
      sy := sy + Step[2];
    end;
  end;  { with Canvas }
  finally
  //Canvas.unlock;
  end;
end;

{procedure TIndicator.DrawPoint(P : TDPoint);       // нарисовать точку
var
  sP : TPoint;
begin
  sP := WorldToScreen(P);
  SetPixel(Canvas.Handle, sP.X, sP.Y, FColor);
end;}

procedure TIndicator.AddPointP(P : TDPoint; number: byte);

 var
  sP : TPoint;
  lP : TDPoint;
  postColor: TColor;
  tr: TRect;
  all,avl,alh,avh : TPoint;
  Pdisc : TDPoint;
begin
 try
//Canvas.Lock;
  initline:=false;
 // P[2]:=(p[2]-min)/delt;
  if number=1 then
  begin
   postColor:=gPen.Color;
   gPen.Color:=FTowColor;
  end;
  avl:= WorldToScreen(DPoint(0, avlo.value));
  all:= WorldToScreen(DPoint(0, allo.value));
  avh:= WorldToScreen(DPoint(0, avhi.value));
  alh:= WorldToScreen(DPoint(0, alhi.value));

 { case FOrientation of
    doLeftToRight: begin
      if P[1] >= FOrigin[1] +FWorldWidth  {Abs(FBounds.Right-FBounds.Left-FMARGIN_LEFT-FMARGIN_RIGHT-2)/Scale[1]} //then begin
        ///lP[1] := ScreenToWorld(FLastPoint[number])[1];
        {if FSlide then begin
          SlideWorld(P[1]-lP[1]);
        end
        else begin
          FOrigin[1] := lP[1];
          Draw;
          FLastPoint[number].x := FBounds.Left+FMARGIN_LEFT+1;
        end;
      end;
    end; { doLeftToRight }
   { doTopToBottom : begin
      if P[2] >= FOrigin[2]-1/Scale[2] then begin
        lP[2] := ScreenToWorld(FLastPoint[number])[2];
        if FSlide then begin
          SlideWorld(P[2]-lP[2]);
        end
        else begin
          FOrigin[2] := lP[2] + FWorldHeight;
          Draw;
          FLastPoint[number].y := FBounds.Bottom-FMARGIN_BOTTOM-1;
        end;
      end;
    end;
  end; { case }

  sP := WorldToScreen(P);

  if not FFirstPoint[number] then begin
    //Application.MessageBox(pansichar(floattostr(FLastPoint[number].x)),pansichar(floattostr(FBounds.Left)+'+'+floattostr(FMARGIN_LEFT)),0);
  //  if (FLastPoint[number].x >= FBounds.Left+FMARGIN_LEFT)   and (sP.x >= FBounds.Left+FMARGIN_LEFT) {and
       {(FLastPoint[number].y >= FBounds.Top+FMARGIN_TOP)    and (sP.y >= FBounds.Top+FMARGIN_TOP) and
       (FLastPoint[number].y <= FBounds.Bottom-FMARGIN_BOTTOM) and (sP.y <= FBounds.Bottom-FMARGIN_BOTTOM)} {then }begin
      Canvas.Pen := fgpen;
     // showmessage(floattostr(Sp.y)+' - '+floattostr(avh.y)+' - '+floattostr(avl.y)+floattostr(alh.y)+' - '+floattostr(all.y));
      if (((sP.y>avl.y) or (FLastPoint[number].y>avl.y)) and (avlo.state)) then  canvas.pen.color:=clRed else
       if (((Sp.y<avh.y) or (FLastPoint[number].y<avh.y)) and (avhi.state)) then  canvas.pen.color:=clRed else
         if (((sP.y>all.y) or (FLastPoint[number].y>all.y)) and (allo.state)) then canvas.pen.color:=clred else
           if (((Sp.y<alh.y) or (FLastPoint[number].y<alh.y)) and (alhi.state))   then   canvas.pen.color:=clred;

      if fIsDiscret then
        begin
          try
          {Canvas.MoveTo(FLastPoint[number].x, FLastPoint[number].y);

          Canvas.LineTo(sP.x, FLastPoint[number].y);
          Canvas.LineTo(sP.x, sP.y); }
            if ((FLastPoint[number].x < FBounds.Left)   and (sP.x < FBounds.Left)) or
             ((FLastPoint[number].x > FBounds.Right)   and (sP.x > FBounds.Right))
          then
              Canvas.MoveTo(sp.x, sp.y)
          else
          begin
          Pdisc[1]:=screentoworld(FLastPoint[number])[1];
           Pdisc[2]:=p[2];
          DrawSelfLine(screentoworld(FLastPoint[number]),Pdisc,number);
          DrawSelfLine(Pdisc,P,number);
          end;
          except
          end;
          //FLastPoint[number] := sP;

        end
      else
        begin
          try
          if ((FLastPoint[number].x < FBounds.Left)   and (sP.x < FBounds.Left)) or
             ((FLastPoint[number].x > FBounds.Right)   and (sP.x > FBounds.Right))
          then
          else
          DrawSelfLine(screentoworld(FLastPoint[number]),P,number);
          except
          end;
          //  FLastPoint[number] := sP;
        end;
     { if  ((not active)) then
            begin
            tr.Left:=Sp.x-1;
            tr.Right:=Sp.X;
            canvas.Brush.Color:=clGray;
            tr.Top:=ScrRect.Top+FMARGIN_TOP+3;
            tr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
            Canvas.FillRect(tr);
            end;  }
       FLastPoint[number] := sP;
    end;
  end
  else
    FFirstPoint[number] := False;

  FLastPoint[number] := sP;
   if number=1 then
  begin
   gPen.Color:=postColor;
  end;
  finally
//  canvas.Unlock;
   FFirstPoint[number] := False;
  end;
end;

procedure TIndicator.setcurleft(val: Tdatetime);
begin
   if val<>curleft then
   begin
      if not initline then
        begin
           curleft:=self.startTime;
           curRight:=self.startTime+self.TimePer;
           self.DrawlinesFirst;
           initline:=true;
           exit;
        end else
        begin
         curleft:=val;
         self.Drawlines;
        end;
   end;;
end;

procedure TIndicator.setcurright(val: Tdatetime);
begin
  if val<>curright then
   begin

      if not initline then
        begin
           curleft:=self.startTime;
           curRight:=self.startTime+self.TimePer;
           self.DrawlinesFirst;
           initline:=true;
           exit;
        end else
        begin
         curright:=val;
         self.Drawlines;
        end;
   end;
end;

procedure TIndicator.AddPoint(P : TDPoint; number: byte; active: boolean);
var
  sP : TPoint;
  lP : TDPoint;
  postColor: TColor;
  tr: TRect;
  all,avl,alh,avh : TPoint;
begin
  initline:=false;
 try

 // P[2]:=(p[2]-min)/delt;
  if number=1 then
  begin
   postColor:=gPen.Color;
   gPen.Color:=FTowColor;
  end;
  avl:= WorldToScreen(DPoint(0, avlo.value));
  all:= WorldToScreen(DPoint(0, allo.value));
  avh:= WorldToScreen(DPoint(0, avhi.value));
  alh:= WorldToScreen(DPoint(0, alhi.value));

  case FOrientation of
    doLeftToRight: begin
      if P[1] >= FOrigin[1] +FWorldWidth  {Abs(FBounds.Right-FBounds.Left-FMARGIN_LEFT-FMARGIN_RIGHT-2)/Scale[1]} then begin
        lP[1] := ScreenToWorld(FLastPoint[number])[1];
        if FSlide then begin
          SlideWorld(P[1]-lP[1]);
        end
        else begin
          FOrigin[1] := lP[1];
          Draw;
          FLastPoint[number].x := FBounds.Left+FMARGIN_LEFT+1;
        end;
      end;
    end; { doLeftToRight }
    doTopToBottom : begin
      if P[2] >= FOrigin[2]-1/Scale[2] then begin
        lP[2] := ScreenToWorld(FLastPoint[number])[2];
        if FSlide then begin
          SlideWorld(P[2]-lP[2]);
        end
        else begin
          FOrigin[2] := lP[2] + FWorldHeight;
          Draw;
          FLastPoint[number].y := FBounds.Bottom-FMARGIN_BOTTOM-1;
        end;
      end;
    end;
  end; { case }

  sP := WorldToScreen(P);

  if not FFirstPoint[number] then begin
    if (FLastPoint[number].x >= FBounds.Left+FMARGIN_LEFT)   and (sP.x >= FBounds.Left+FMARGIN_LEFT) {and
       {(FLastPoint[number].y >= FBounds.Top+FMARGIN_TOP)    and (sP.y >= FBounds.Top+FMARGIN_TOP) and
       (FLastPoint[number].y <= FBounds.Bottom-FMARGIN_BOTTOM) and (sP.y <= FBounds.Bottom-FMARGIN_BOTTOM)} then begin
      Canvas.Pen := fgpen;
     // showmessage(floattostr(Sp.y)+' - '+floattostr(avh.y)+' - '+floattostr(avl.y)+floattostr(alh.y)+' - '+floattostr(all.y));
      if (((sP.y>avl.y) or (FLastPoint[number].y>avl.y)) and (avlo.state)) then  canvas.pen.color:=clRed else
       if (((Sp.y<avh.y) or (FLastPoint[number].y<avh.y)) and (avhi.state)) then  canvas.pen.color:=clRed else
         if (((sP.y>all.y) or (FLastPoint[number].y>all.y)) and (allo.state)) then canvas.pen.color:=clred else
           if (((Sp.y<alh.y) or (FLastPoint[number].y<alh.y)) and (alhi.state))   then   canvas.pen.color:=clred;

      if fIsDiscret then
        begin
          try
          Canvas.MoveTo(FLastPoint[number].x, FLastPoint[number].y);

          Canvas.LineTo(sP.x, FLastPoint[number].y);
          Canvas.LineTo(sP.x, sP.y);
          except
          end;
          //FLastPoint[number] := sP;

        end
      else
        begin
          try
          Canvas.MoveTo(FLastPoint[number].x, FLastPoint[number].y);
          Canvas.LineTo(sP.x, sP.y);
          except
          end;
          //  FLastPoint[number] := sP;
        end;
      if  ((not active)) then
            begin
            tr.Left:=Sp.x-1;
            tr.Right:=Sp.X;
            canvas.Brush.Color:=clGray;
            tr.Top:=ScrRect.Top+FMARGIN_TOP+3;
            tr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
            Canvas.FillRect(tr);
            end;
       FLastPoint[number] := sP;
    end;
  end
  else
    FFirstPoint[number] := False;

  FLastPoint[number] := sP;
   if number=1 then
  begin
   gPen.Color:=postColor;
  end;
  finally
 // canvas.Unlock;
  end;
end;


procedure TIndicator.SlideWorld(delta : Double);
var
  X : Integer;
begin
  X := Round(Scale[1+Byte(FOrientation in [doTopToBottom])] * delta);
  SlideScreen(X);
end;

procedure TIndicator.SlideScreen(delta : Integer);
begin
  try
  Canvas.lock;
  if delta > 0 then begin
    case FOrientation of
      doLeftToRight : begin
        Dec(FLastPoint[0].x, delta);
        Dec(FLastPoint[1].x, delta);
        BitBlt(Canvas.Handle, FBounds.Left+FMARGIN_LEFT+1,FBounds.Top+FMARGIN_TOP+1,
               FBounds.Right-FBounds.Left-FMARGIN_RIGHT-FMARGIN_LEFT-delta, FBounds.Bottom-FBounds.Top-FMARGIN_TOP-FMARGIN_BOTTOM-1,
               Canvas.Handle, FBounds.Left+FMARGIN_LEFT+delta+1,FBounds.Top+FMARGIN_TOP+1, SRCCOPY);
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := FBackground;
        PatBlt(Canvas.Handle, FBounds.Right-FMARGIN_RIGHT-delta, FBounds.Top+FMARGIN_TOP+1,
               delta, FBounds.Bottom-FBounds.Top-FMARGIN_TOP-FMARGIN_BOTTOM-1, PATCOPY);
        FOrigin[1] := FOrigin[1] + delta/Scale[1];
        Inc(FTag, delta mod 3);
        DrawGrid(Rect(FBounds.Right-FMARGIN_RIGHT-delta-2, FBounds.Top,
                      FBounds.Right-FMARGIN_RIGHT, FBounds.Bottom), False, True);
      end; { doLeftToRight }
      doTopToBottom : begin
        Inc(FLastPoint[0].y, delta);
        Inc(FLastPoint[1].y, delta);
        BitBlt(Canvas.Handle, FBounds.Left+FMARGIN_LEFT+1,FBounds.Top+FMARGIN_TOP+delta,
               FBounds.Right-FBounds.Left-FMARGIN_RIGHT-FMARGIN_LEFT, FBounds.Bottom-FBounds.Top-FMARGIN_TOP-FMARGIN_BOTTOM-delta,
               Canvas.Handle, FBounds.Left+FMARGIN_LEFT+1,FBounds.Top+FMARGIN_TOP, SRCCOPY);
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := FBackground;
        PatBlt(Canvas.Handle, FBounds.Left+FMARGIN_LEFT+1, FBounds.Top+FMARGIN_TOP+1,
               FBounds.Right-FBounds.Left-FMARGIN_LEFT-FMARGIN_RIGHT-1, delta, PATCOPY);
        FOrigin[2] := FOrigin[2] + delta/Scale[2];
        Inc(FTag, delta mod 3);
        DrawGrid(Rect(FBounds.Left, FBounds.Top+FMARGIN_TOP,
                      FBounds.Right, FBounds.Top+FMARGIN_TOP+delta+2), True, False);
      end; { doTopToBottom }
    end; { case }
  end;
  finally
  Canvas.unlock;
  end;
end;

function TIndicator.PtInGraphicRect(Pt : TPoint) : Boolean;
begin
  Result := PtInRect(TxtRect, Pt);
end;

//******** TIndicatorList *********
constructor TIndicatorList.Create(AOwnerScope : TCustomControl);
begin
  inherited Create;
  OwnerScope := AOwnerScope;
  Canvas := TBufferedControl(OwnerScope).Buffer.Canvas;
end;

procedure TIndicatorList.AddIndicator(I : TIndicator);
begin
  Add(I);
  I.Canvas := Canvas;
  I.OwnerScope := OwnerScope;
end;

procedure TIndicatorList.FreeAll;
var
  i : Integer;
begin
  for i := 0 to Count-1 do
    TIndicator(Items[i]).Free;
  While Count > 0 do
    Delete(0);
end;

destructor TIndicatorList.Destroy;
begin
  FreeAll;
  inherited;
end;

procedure TIndicatorList.Draw(Canvas : TCanvas);
var
  i : Integer;
begin
  for i := 0 to Count-1 do
    TIndicator(Items[i]).Draw;
end;

//******** TBufferredControl *********
procedure TBufferedControl.FSetBackground(Value : TColor);
begin
  FBackground := Value;
  if not FUpdating then
    Draw;
end;

procedure TBufferedControl.Paint;
begin
  try
  Canvas.Lock;
  inherited;
  BitBlt(Canvas.Handle,0,0,Width,Height,Buffer.Canvas.Handle,0,0,SRCCOPY);
  finally
  Canvas.Unlock;
  end;
end;

constructor TBufferedControl.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csClickEvents, csFramed, csOpaque, csDoubleClicks,
                   csCaptureMouse, csSetCaption];
  Buffer := TBitmap.Create;
  SetBounds(Left,Top,100,100);
  Created := True;
end;

destructor TBufferedControl.Destroy;
begin
  Buffer.Free;
  inherited;
end;

procedure TBufferedControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (AWidth < 100) then
    AWidth := 100;
  if (AHeight < 100) then
    AHeight := 100;

  Buffer.Height := AHeight;
  Buffer.Width := AWidth;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TBufferedControl.Draw;
begin
end;

procedure TBufferedControl.UpdateView;
begin
  if not FUpdating then
    Draw;
end;

procedure TBufferedControl.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TBufferedControl.EndUpdate;
begin
  if FUpdating then begin
    FUpdating := False;
    Draw;
  end;
end;

//******** TScope *********
constructor TScope.Create(AOwner : TComponent);
begin
  inherited;
  err:=false;
  FIndicator := TIndicator.Create(Rect(0,0, Width, Height), clBlue, clBlack, clYellow);
  FIndicator.OwnerScope := Self;
  FIndicator.Canvas := Buffer.Canvas;
  FIndicator.SetWorldWidth(DPoint(-10, 10));
  FIndicator.SetWorldHeight(DPoint(-1, 1));

end;

destructor TScope.Destroy;
begin
  FIndicator.Free;
  inherited;
end;

procedure TScope.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if FIndicator <> nil then
    FIndicator.SetBounds(Rect(0, 0, Width, Height));
  if Created and (not FUpdating) then
    Draw;
end;

procedure TScope.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
begin
    try
    Canvas.Lock;
    inherited;
    finally
    canvas.unlock;
    end;
end;

procedure TScope.Repaint;
begin
if indicator.Canvas.LockCount=0 then inherited;
end;

{procedure TScope.Refresh;
begin
if indicator.Canvas.LockCount>0 then inherited;
end;       }

procedure TScope.Draw;
begin
  if indicator.Canvas.LockCount>0 then exit;
  try
   Buffer.Canvas.Lock;
  inherited Draw;

  With Buffer.Canvas do begin
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Brush.Style := bsSolid;
    Brush.Color := FBackground;
    PatBlt(Handle,0,0,Width,Height,PATCOPY);
    Brush.Style := bsClear;
  end;

  FIndicator.Draw;

  With Buffer.Canvas do begin
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Brush.Style := bsClear;
    Brush.Color := FBackground;
  end;

  Refresh;
  finally
  Buffer.Canvas.Unlock;
  end;
end;





//******** TScopeList *********
constructor TScopeList.Create(AOwner : TComponent);
begin
  inherited;
  Indicators := TIndicatorList.Create(Self);
end;

destructor TScopeList.Destroy;
begin
  Indicators.Free;
  inherited;
end;

procedure TScopeList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if Created and (not FUpdating) then
    Draw;
end;

procedure TScopeList.Draw;
begin
  try
   Buffer.Canvas.lock;
  inherited Draw;

  With Buffer.Canvas do begin
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Brush.Style := bsSolid;
    Brush.Color := FBackground;
    PatBlt(Handle,0,0,Width,Height,PATCOPY);
    Brush.Style := bsClear;
  end;

  Indicators.Draw(Buffer.Canvas);

  With Buffer.Canvas do begin
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Brush.Style := bsClear;
    Brush.Color := FBackground;
  end;

  Refresh;
  finally
  Buffer.Canvas.unlock;
  end;
end;


function TIndicator.getScrect: TRect;
begin
  result:=Rect(FBounds.Right-FMARGIN_RIGHT-2, FBounds.Top,
                      FBounds.Right-FMARGIN_RIGHT, FBounds.Bottom);
end;

//******** TIndicatorMulti *********
procedure TIndicatorMulti.DrawSelfLine(p1,p2: TDpoint; index: integer);
var deltx,delty: double;
    ddeltx,ddelty: double;
    dX,I: integer;
    curP1,curP2: TDpoint;
    TR: tRECT;
    startYbb, stopYbb: integer;
    MaxStY, MinStY: integer;
    MaxStX, MinStX: integer;
begin
  MaxStY:=FBounds.Bottom-FMARGIN_BOTTOM;
  MinStY:=FBounds.Top+FMARGIN_TOP;
   MinStX:=FBounds.Left+FMARGIN_LEFT;
  MaxStX:=FBounds.right-FMARGIN_Right;

  if (FLastPoint[index].x < FBounds.Left)
  then FLastPoint[index].x:=FBounds.Left;
  if (worldtoscreen(p1,index).x < FBounds.Left)
  then p1[1]:=FWorldLeft;
  if (worldtoscreen(p2,index).x < FBounds.Left)
  then p2[1]:=FWorldLeft;
  if (worldtoscreen(p2,index).x >FBounds.Right)
  then p1[1]:=FBounds.Right;
  if (worldtoscreen(p1,index).x >FBounds.Right)
  then p1[1]:=FBounds.Right;
  if (FLastPoint[index].x >FBounds.Right)
  then FLastPoint[index].X:=FBounds.Right;
 //Canvas.MoveTo(FLastPoint[number].x, FLastPoint[number].y);
 try
 canvas.lock;
 deltx:=p2[1]-p1[1];
 delty:=p2[2]-p1[2];
 dX:=worldtoscreen(p2,index).X-worldtoscreen(p1,index).X;
 if dX=0 then
  begin
    if getactiv(p1,index) then
      begin
      startYbb:=worldtoscreen(p1,index).y;
      stopYbb:= worldtoscreen(p2,index).y;
      if startYbb>MaxStY then startYbb:=MaxStY;
      if startYbb<MinStY then startYbb:=MinStY;
      if stopYbb>MaxStY then stopYbb:=MaxStY;
      if stopYbb<MinStY then stopYbb:=MinStY;
      Canvas.MoveTo(worldtoscreen(p1,index).x, startYbb);
      if not((startYbb=StopYbb) and ((StartYbb=MaxStY) or (stopYbb=MinStY))) and ((worldtoscreen(p2,index).x<=MaxStX) and (worldtoscreen(p2,index).x>=MinStX)) then
      Canvas.LineTo(worldtoscreen(p2,index).x, stopYbb)
      else
       Canvas.MoveTo(worldtoscreen(p2,index).x, stopYbb)
      end
    else
      begin
      tr.Left:=worldtoscreen(p2,index).x-1;
      tr.Right:=worldtoscreen(p2,index).X;
      canvas.Brush.Color:=clGray;
      tr.Top:=ScrRect.Top+FMARGIN_TOP+3;
      tr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
      if ((worldtoscreen(p2,index).x<MaxStX) and (worldtoscreen(p2,index).x>MinStX)) then Canvas.FillRect(tr);
      Canvas.MoveTo(worldtoscreen(p2,index).x, worldtoscreen(p2,index).y);
      end;
  end
 else
  begin
    Canvas.MoveTo(FLastPoint[index].x, FLastPoint[index].y);
    ddeltx:=deltx/dx;
    ddelty:=delty/dx;
    for i:=0 to dx-1 do
      begin
        curp1[1]:=p1[1]+ddeltx*i;
        curp2[1]:=p1[1]+ddeltx*(i+1);
        curp1[2]:=p1[2]+ddeltY*i;
        curp2[2]:=p1[2]+ddeltY*(i+1);
         if getactiv(curp1,index) then
            begin
            startYbb:=worldtoscreen(curp1,index).y;
            stopYbb:= worldtoscreen(curp2,index).y;
            if startYbb>MaxStY then startYbb:=MaxStY;
            if startYbb<MinStY then startYbb:=MinStY;
            if stopYbb>MaxStY then stopYbb:=MaxStY;
            if stopYbb<MinStY then stopYbb:=MinStY;
            Canvas.MoveTo(worldtoscreen(curp1,index).x, startYbb);
             if not((startYbb=StopYbb) and ((StartYbb=MaxStY) or (stopYbb=MinStY))) and ((worldtoscreen(curp1,index).x<MaxStX) and (worldtoscreen(curp1,index).x>MinStX)) then
            Canvas.LineTo(worldtoscreen(curp2,index).x, stopYbb) else
            Canvas.MoveTo(worldtoscreen(curp2,index).x, stopYbb) ;
            end
         else
            begin
            tr.Left:=worldtoscreen(curp2,index).x-1;
            tr.Right:=worldtoscreen(curp2,index).X;
            canvas.Brush.Color:=clGray;
            tr.Top:=ScrRect.Top+FMARGIN_TOP+3;
            tr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
             if ((worldtoscreen(curp2,index).x<=MaxStX) and (worldtoscreen(curp2,index).x>=MinStX)) then Canvas.FillRect(tr);
            Canvas.moveto(worldtoscreen(curp2,index).x, worldtoscreen(curp2,index).y);
            end;
      end;
  end;
  finally
  canvas.unlock;
  end;
end;

constructor TIndicatorMulti.Create(aBounds : TRect; aColor, aBackground, aAxisColor : TColor);
var i: integer;
begin
  inherited Create;
  firstAbsence:=false;
   startTime:=now;
  OwnerScope := nil;
  for i:=0 to 15 do
  FFirstPoint[i] := True;
  FGridFont := TFont.Create;
  With FGridFont do begin
    OnChange := FontChanged;
    Name := 'Terminal';
    Size := 5;
    Style := [];
    Color := clWhite;
  end;
  FFont := TFont.Create;
  With FFont do begin
    OnChange := FontChanged;
    Name := 'MS Sans Serif';
    Size := 8;
    Style := [fsBold];
    Color := clWhite;
  end;

  FWorldWidth := 1;
  for i:=0 to 7 do
  FWorldHeight[i] := 1;
  SetBounds(aBounds);
  FCaption := '';
  Fgpen := TPen.Create;
  Fgpen.Color:=acolor;
  FBackground := aBackground;
  FAxisColor := aAxisColor;
  FGridColor := GetHalfColor(aAxisColor);
  // margins
  FMARGIN_LEFT   := 5;
  FMARGIN_RIGHT  := 5;
  FMARGIN_TOP    := 15;
  FMARGIN_BOTTOM := 5;

  Caption := '';
  Orientation := doLeftToRight;
   horlable:=false;
end;

destructor TIndicatorMulti.Destroy;
begin
  Fgpen.Free;
  FGridFont.Free;
  FFont.Free;

  inherited;
end;

function TIndicatorMulti.GetActiv(Pc : TDPoint; index: integer): boolean;
var j: integer;
begin
result:=true;
 for j:=0 to resabs[index].n-1 do
   begin
      if (pc[1]>=resabs[index].point[j][1]) and (pc[1]<=resabs[index].point[j][2]) then
        begin
        result:=false;
        exit;
        end;

   end;
end;

procedure TIndicatorMulti.UpdateOwnerView;
begin
  if Assigned(OwnerScope) then
    TBufferedControl(OwnerScope).UpdateView;
end;

procedure TIndicatorMulti.FontChanged(Sender : TObject);
begin
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetFont(Value : TFont);
begin
  FFont.Assign(Value);
end;

procedure TIndicatorMulti.FSetGridFont(Value : TFont);
begin
  FGridFont.Assign(Value);
end;

procedure TIndicatorMulti.FSetBackground(Value : TColor);
begin
  FBackground := Value;
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetgpen(Value : TPen);
begin
if value.Width<1 then value.Width:=1;
  Fgpen := Value;
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetGridColor(Value : TColor);
begin
  FGridColor := Value;
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetAxisColor(Value : TColor);
begin
  FAxisColor := Value;
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetCaption(Value : String);
begin
  if FCaption <> Value then begin
    if (Value = '') and (FCaption <> '') then
      FMARGIN_TOP := FMARGIN_TOP - 10
    else
      if (Value <> '') and (FCaption = '') then
        FMARGIN_TOP := FMARGIN_TOP + 10;
    FCaption := Value;
    SetBounds(FBounds);
    UpdateOwnerView;
  end;
end;

procedure TIndicatorMulti.FSetOrientation(Value : TDataOrientation);
begin
  FOrientation := Value;
  case Value of
    doLeftToRight : begin
      FMARGIN_LEFT := FMARGIN_LEFT + 30;
      FMARGIN_TOP := FMARGIN_TOP - 10;
    end;
    doTopToBottom : begin
      FMARGIN_LEFT := FMARGIN_LEFT - 30;
      FMARGIN_TOP := FMARGIN_TOP + 10;
    end;
  end;
  SetBounds(FBounds);
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetFullGrid(Value : Boolean);
begin
  FFullGrid := Value;
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetSlide(Value : Boolean);
begin
  FSlide := Value;
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetWorldLeft(Value : Double);
begin
  FWorldLeft := Value;
  SetWorldWidth(DPoint(FWorldLeft, FWorldRight));
//  SetBounds(FBounds);
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetWorldRight(Value : Double);
begin
  FWorldRight := Value;
  SetWorldWidth(DPoint(FWorldLeft, FWorldRight));
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetWorldTop(index: integer; Value : Double);
begin
  FWorldTop[index] := Value;
  if (FWorldBottom[index]-FWorldTop[index])<>0 then SetWorldHeight(DPoint(FWorldBottom[index], FWorldTop[index]),index);   // условие добавлено 25.10.2002 UpdateOwnerView;

  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetWorldBottom(index: integer; Value : Double);
begin
  FWorldBottom[index] := Value;
  if (FWorldBottom[index]-FWorldTop[index])<>0 then SetWorldHeight(DPoint(FWorldBottom[index], FWorldTop[index]),index);

  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetMARGIN_LEFT(Value : Integer);
begin
  FMARGIN_LEFT := Value;
  SetBounds(FBounds);
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetMARGIN_RIGHT(Value : Integer);
begin
  FMARGIN_RIGHT := Value;
  SetBounds(FBounds);
  UpdateOwnerView;
end;

procedure TIndicatorMulti.FSetMARGIN_TOP(Value : Integer);
begin
  FMARGIN_TOP := Value;
  SetBounds(FBounds);

  UpdateOwnerView;

end;

procedure TIndicatorMulti.FSetMARGIN_BOTTOM(Value : Integer);
begin
  FMARGIN_BOTTOM := Value;
  SetBounds(FBounds);

  UpdateOwnerView;

end;

procedure TIndicatorMulti.SetBounds(aBounds : TRect);
var aBoundss : TRect;
    i: integer;
begin
  FBounds := aBounds;
  Width := Abs(FBounds.Right - FBounds.Left) - FMARGIN_LEFT - FMARGIN_RIGHT-2;
  Height := Abs(FBounds.Bottom - FBounds.Top) - FMARGIN_TOP - FMARGIN_BOTTOM-2;
  for i:=0 to 7 do
  begin
  Scale [i][1] := Width / FWorldWidth;
  Scale[i][2] := Height / FWorldHeight[i];
  end;
  for i:=0 to 7 do
  begin
  if FDST then
  begin
  Step[i][1] := Power(10,Int(Log10(FWorldWidth))-1);
  end else
  begin
  Step[i][1] := Power(10,Int(Log10(FWorldWidth))-1);

  end;
  Step[i][2] := Power(10,Int(Log10(FWorldHeight[i]))-1);
  While Round(Step[i][1]*Scale[i][1]) > 100 do
    Step[i][1] := Step[i][1]/2;
  While Round(Step[i][1]*Scale[i][1]) < 60 do
    Step[i][1] := Step[i][1]*2;

  While Round(Step[i][2]*Scale[i][2]) > 50 do
    Step[i][2] := Step[i][2]/2;
  While Round(Step[i][2]*Scale[i][2]) < 15 do
    Step[i][2] := Step[i][2]*2;
  if FDST then Step[i][1]:=Step[i][1]*2;
  aBoundss:=FBounds;
  aBoundss.TopLeft.Y:=aBoundss.TopLeft.Y-FMARGIN_Top+1;
  FLastPoint[i] := Point(FBounds.Right-FMARGIN_RIGHT-1, FBounds.bottom-FMARGIN_BOTTOM-1);
  FLastPoint[i] := Point(FBounds.Right-FMARGIN_RIGHT-1, FBounds.bottom-FMARGIN_BOTTOM-1);
  // область клиппинга текста
  TxtRect := aBoundss;
  Inc(TxtRect.Left,   FMARGIN_LEFT+1);
  Dec(TxtRect.Right,  FMARGIN_RIGHT+1);
  Inc(TxtRect.Top,    FMARGIN_TOP+1);
  Dec(TxtRect.Bottom, FMARGIN_BOTTOM+1);
  FTag := 1;
  end;
end;

function TIndicatorMulti.WorldToScreen(P : TDPoint; index: integer) : TPoint;
begin
  Result.x := FBounds.Left + FMARGIN_LEFT + Round(Scale[index][1] * (P[1] - FOrigin[index][1])) + 1;
  Result.y := FBounds.Top + FMARGIN_TOP - Round(Scale[index][2] * (P[2] - FOrigin[index][2])) + 1;
end;

function TIndicatorMulti.ScreenToWorld(P : TPoint; index: integer) : TDPoint;
begin
  Result[1] := FOrigin[index][1] + (P.x - FBounds.Left - FMARGIN_LEFT - 1)/Scale[index][1];
  Result[2] := FOrigin[index][2] - (P.y - FBounds.Top - FMARGIN_TOP - 1)/Scale[index][2];
end;

procedure TIndicatorMulti.SetWorldWidth(X : TDPoint);
begin
  FOrigin[0][1] := Min(X[1], X[2]);
  FWorldWidth := Abs(X[1] - X[2]);
  FWorldLeft := FOrigin[0][1];
  FWorldRight := FOrigin[0][1] + FWorldWidth;
  SetBounds(FBounds);
end;

procedure TIndicatorMulti.SetWorldHeight(Y : TDPoint; index: integer);
begin
  FOrigin[index][2] := Max(Y[1], Y[2]);
  FWorldHeight[index] := Abs(Y[1] - Y[2]);
  FWorldTop[index] := FOrigin[index][2];
  FWorldBottom[index] := FOrigin[index][2] - FWorldHeight[index];
  SetBounds(FBounds);
end;




procedure TIndicatorMulti.Draw;
begin
  try
//  Canvas.lock;
//  внешний прямоугольник
  Canvas.Pen.Color := clWhite;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
//  Rectangle(Canvas.Handle, FBounds.Left, FBounds.Top, FBounds.Right+1, FBounds.Bottom+1);
//  внутренний прямоугольник
  Canvas.Brush.Color := FBackground;
  Canvas.Brush.Style := bsSolid;
  Rectangle(Canvas.Handle, FBounds.Left+FMARGIN_LEFT, FBounds.Top+FMARGIN_TOP, FBounds.Right+1-FMARGIN_RIGHT, FBounds.Bottom+1-FMARGIN_BOTTOM);
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(FFont);
  Canvas.TextOut(FBounds.Left+FMARGIN_LEFT,FBounds.Top+2, FCaption);

  DrawGrid(FBounds, True, True);
  finally
  //  canvas.unlock;
  end;
end;

function TIndicatorMulti.DrawGridStStop(Pn : TDPoint;Pc : TDPoint): boolean;

var
  sP,cp : integer;
  lP : TDPoint;
  postColor: TColor;
  tyr: TRect;
begin
 { try
 // Canvas.lock;
  cp := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (Pc[1] - FOrigin[1])) + 1;

  sP := FBounds.Left + FMARGIN_LEFT + Round(Scale[1] * (Pn[1] - FOrigin[1]));
        //FFirstpoint[0]:=true;
        begin
          Canvas.Brush.Color:=$002E2E2E;
          Canvas.Pen.Color:=clRed;

          tyr.Left:=sp;
          tyr.Right:=cp;
          tyr.Top:=ScrRect.Top+FMARGIN_TOP+3;
          tyr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;

          Canvas.FillRect(tyr);
         { Canvas.Rectangle(tyr);
          if (tyr.Right-tyr.Left)>20 then
            begin
              Canvas.TextRect(tyr,10,10,'Нет данных');
            end;   }
    //    end;
 // finally
  //Canvas.Unlock;
//  end;           }
end;

procedure TIndicatorMulti.DrawGrid(inBounds : TRect; WithMarginsX, WithMarginsY  : Boolean);
var
  sx, sy : Double;
  O, P,all,avl,alh,avh : TPoint;
  Z1, Z2, C : TDPoint;
  tw, th : Integer;
  num : String;
  dot_horz, dot_vert : Boolean;
  DrawNum : Boolean;
  GraphRect : TRect;
  td: TDateTime;
  rc: TRect;
  lasc: TColor;
begin
  try
 // Canvas.lock;
  DrawNum := True;

  GraphRect := inBounds;  // область для графика внутри индикатора
  if WithMarginsX then begin
    // сузить ее в соответствии с MARGINS left & right
    Inc(GraphRect.Left,   FMARGIN_LEFT+1);
    Dec(GraphRect.Right,  FMARGIN_RIGHT+1);
  end;
  if WithMarginsY then begin
    // сузить ее в соответствии с MARGINS top & bottom
    Inc(GraphRect.Top,    FMARGIN_TOP+1);
    Dec(GraphRect.Bottom, FMARGIN_BOTTOM+1);
  end;

  With Canvas do begin
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Brush.Style := bsClear;
    Font.Assign(FGridFont);


    O := WorldToScreen(DPoint(0, 0),0);

    dot_horz := (O.y > GraphRect.Top) and (O.y < GraphRect.Bottom);
    dot_vert := (O.x > GraphRect.Left) and (O.x < GraphRect.Right);

    // рисование насечек
    Z1 := ScreenToWorld(Point(GraphRect.Left+1, GraphRect.Top+1),0);
    Z2 := ScreenToWorld(Point(GraphRect.Right-1, GraphRect.Bottom-1),0);
    C[1] := Step[0][1]*Int(Z1[1]/Step[0][1]);
    C[2] := Step[0][2]*Int(Z2[2]/Step[0][2]);

    Pen.Color := FGridColor;
{    if FullGrid then
      Pen.Style := psDot
    else
      Pen.Style := psSolid;}

    // горизонтальная ось
    sx := C[1];
    While sx < Z1[1] do
      sx := sx + Step[0][1];
    While sx < Z2[1] do begin
      P := WorldToScreen(DPoint(sx, 0),0);
      if P.X <> O.x then begin
        if FFullGrid then begin
          MoveTo(P.x, GraphRect.Top+1);
          LineTo(P.x, GraphRect.Bottom);
        end
        else
        if dot_horz then begin
          MoveTo(P.x, O.y-2);
          LineTo(P.x, O.y+3);
        end;
      end; { if P.X }
      sx := sx + Step[0][1];
    end;




    // вертикальная ось
    sy := C[2];
    While sy < Z2[2] do
      sy := sy + Step[0][2];
    While sy < Z1[2] do begin
      P := WorldToScreen(DPoint(0, sy),0);
      if P.y <> O.y then begin
        if FFullGrid then begin
         MoveTo(GraphRect.Right-1{-(Tag mod 6)}, P.y);
         LineTo(GraphRect.Left, P.y);
        end
        else
        if dot_vert then begin
          MoveTo(O.x-2, P.y);
          LineTo(O.x+3, P.y);
        end;
      end; { if P.y }
      sy := sy + Step[0][2];
    end;

    // рисование осей
    Pen.Color := FAxisColor;
    Pen.Style := psSolid;
    if dot_vert then begin
      { вертикальная ось }
      Moveto(O.x, GraphRect.Top+1);
      LineTo(O.x, GraphRect.Bottom);
    end;
    if dot_horz then begin
      { горизонтальная ось }
      Moveto(GraphRect.Left+1, O.y);
      LineTo(GraphRect.Right, O.y);
    end;



    // горизонтальная ось - надпись текста
    if horlable then
    begin
    sx := C[1];
    lasc:=canvas.Font.Color;
    canvas.Font.Color:=fgridcolor;
    While sx < Z1[1] do
      sx := sx + Step[0][1];
    While sx < Z2[1] do begin
      P := WorldToScreen(DPoint(sx, 0),0);
      if DrawNum then begin
        if FDST then
        begin
          if TimePer<incsecond(0,9) then
          num := FormatDateTime('hh:nn:ss.zzz',sx)
          else
          num := TimeToStr(sx);
        end else
        num := TimeToStr(startTime+sx/24/60); //FloatToStr(sx)
        tw := TextWidth(num);
        th := TextHeight(num);
        case FOrientation of
          doLeftToRight :

            if FFullGrid then begin
              if  FMARGIN_TOP<th+3 then  MARGIN_TOP:=th+2;
              if FSlide then
                TextRect(TxtRect, P.x-tw, TxtRect.Top, num)
              else
                if abs(sx) < 1E-15 then
                  TextRect(TxtRect, P.x-tw, TxtRect.Top, num)
                else
                  TextRect(TxtRect, P.x-tw div 2, TxtRect.Top, num);
            end
            else begin
              if FSlide then
                TextRect(TxtRect, P.x-tw, O.Y-th-2, num)
              else
                if abs(sx) < 1E-15 then
                  TextRect(TxtRect, P.x-tw, O.Y-th-2, num)
                else
                  TextRect(TxtRect, P.x-tw div 2, O.Y-th-2, num);
            end;

          doTopToBottom : TextRect(FBounds, P.x-tw div 2, TxtRect.Top-th-2, num)
        end;
      end;
      sx := sx + Step[0][1];
    end;
    canvas.Font.Color:=lasc;
    end;

    // вертикальная ось - надпись текста
    sy := C[2];
    While sy < Z2[2] do
      sy := sy + Step[0][2];
    While sy < Z1[2] do begin
      P := WorldToScreen(DPoint(0, sy),0);
      if DrawNum then begin
        if Abs(sy) > 1E-15 then
          num := FloatToStrF(sy, ffGeneral, 9, 2)
        else
          num := '0';
        tw := TextWidth(num);
        th := TextHeight(num);
        case FOrientation of
          doLeftToRight : TextRect(FBounds, TxtRect.Left-tw-2, P.y-th div 2, num);
          doTopToBottom :
            if FFullGrid then begin
              if FSlide then
                TextRect(TxtRect, TxtRect.Left+2, P.y, num)
              else
                TextRect(TxtRect, TxtRect.Left+2, P.y-th div 2, num);
            end
            else begin
              if FSlide then
                TextRect(TxtRect, O.x-tw-2, P.y, num)
              else
                TextRect(TxtRect, O.x-tw-2, P.y - th div 2, num);
            end;
        end;
      end;
      sy := sy + Step[0][2];
    end;
  end;  { with Canvas }
  finally
  //Canvas.unlock;
  end;
end;



procedure TIndicatorMulti.AddPointP(P : TDPoint; index: byte;  delt: real; min : real);

 var
  sP : TPoint;
  lP : TDPoint;
  postColor: TColor;
  tr: TRect;
  all,avl,alh,avh : TPoint;
  Pdisc : TDPoint;
begin
 try
//Canvas.Lock;
  P[2]:=(p[2]-min)/delt;
  if index=1 then
  begin
   postColor:=gPen.Color;
   gPen.Color:=FTowColor;
  end;

  sP := WorldToScreen(P,index);

  if not FFirstPoint[index] then begin
     begin
      Canvas.Pen := fgpen;


      if fIsDiscret then
        begin
          try

            if ((FLastPoint[index].x < FBounds.Left)   and (sP.x < FBounds.Left)) or
             ((FLastPoint[index].x > FBounds.Right)   and (sP.x > FBounds.Right))
          then
              Canvas.MoveTo(sp.x, sp.y)
          else
          begin
          Pdisc[1]:=screentoworld(FLastPoint[index],index)[1];
           Pdisc[2]:=p[2];
          DrawSelfLine(screentoworld(FLastPoint[index],index),Pdisc,index);
          DrawSelfLine(Pdisc,P,index);
          end;
          except
          end;


        end
      else
        begin
          try
          if ((FLastPoint[index].x < FBounds.Left)   and (sP.x < FBounds.Left)) or
             ((FLastPoint[index].x > FBounds.Right)   and (sP.x > FBounds.Right))
          then
          else
          DrawSelfLine(screentoworld(FLastPoint[index],index),P,index);
          except
          end;

        end;

       FLastPoint[index] := sP;
    end;
  end
  else
    FFirstPoint[index] := False;

  FLastPoint[index] := sP;
   if index=1 then
  begin
   gPen.Color:=postColor;
  end;
  finally

   FFirstPoint[index] := False;
  end;
end;




procedure TIndicatorMulti.AddPoint(P : TDPoint; index: byte; active: boolean; delt: real; min : real);
var
  sP : TPoint;
  lP : TDPoint;
  postColor: TColor;
  tr: TRect;
  all,avl,alh,avh : TPoint;
begin
 try
//Canvas.Lock;
  P[2]:=(p[2]-min)/delt;
  if index=1 then
  begin
   postColor:=gPen.Color;
   gPen.Color:=FTowColor;
  end;

  case FOrientation of
    doLeftToRight: begin
      if P[1] >= FOrigin[0][1] +FWorldWidth  {Abs(FBounds.Right-FBounds.Left-FMARGIN_LEFT-FMARGIN_RIGHT-2)/Scale[1]} then begin
        lP[1] := ScreenToWorld(FLastPoint[index],index)[1];
        if FSlide then begin
          SlideWorld(P[1]-lP[1]);
        end
        else begin
          FOrigin[0][1] := lP[1];
          Draw;
          FLastPoint[index].x := FBounds.Left+FMARGIN_LEFT+1;
        end;
      end;
    end; { doLeftToRight }
    doTopToBottom : begin
      if P[2] >= FOrigin[0][2]-1/Scale[0][2] then begin
        lP[2] := ScreenToWorld(FLastPoint[index],index)[2];
        if FSlide then begin
          SlideWorld(P[2]-lP[2]);
        end
        else begin
          FOrigin[0][2] := lP[2] + FWorldHeight[index];
          Draw;
          FLastPoint[index].y := FBounds.Bottom-FMARGIN_BOTTOM-1;
        end;
      end;
    end;
  end; { case }

  sP := WorldToScreen(P,index);

  if not FFirstPoint[index] then begin
    if (FLastPoint[index].x >= FBounds.Left+FMARGIN_LEFT)   and (sP.x >= FBounds.Left+FMARGIN_LEFT)  then begin
      Canvas.Pen := fgpen;



      if fIsDiscret then
        begin
          try
          Canvas.MoveTo(FLastPoint[index].x, FLastPoint[index].y);

          Canvas.LineTo(sP.x, FLastPoint[index].y);
          Canvas.LineTo(sP.x, sP.y);
          except
          end;
          //FLastPoint[number] := sP;

        end
      else
        begin
          try
          Canvas.MoveTo(FLastPoint[index].x, FLastPoint[index].y);
          Canvas.LineTo(sP.x, sP.y);
          except
          end;
          //  FLastPoint[number] := sP;
        end;
      if  ((not active)) then
            begin
            tr.Left:=Sp.x-1;
            tr.Right:=Sp.X;
            canvas.Brush.Color:=clGray;
            tr.Top:=ScrRect.Top+FMARGIN_TOP+3;
            tr.Bottom:=ScrRect.bottom-FMARGIN_BOTTOM-2;
            Canvas.FillRect(tr);
            end;
       FLastPoint[index] := sP;
    end;
  end
  else
    FFirstPoint[index] := False;

  FLastPoint[index] := sP;
   if index=1 then
  begin
   gPen.Color:=postColor;
  end;
  finally
 // canvas.Unlock;
  end;
end;


procedure TIndicatorMulti.SlideWorld(delta : Double);
var
  X : Integer;
begin
  X := Round(Scale[0][1+Byte(FOrientation in [doTopToBottom])] * delta);
  SlideScreen(X);
end;

procedure TIndicatorMulti.SlideScreen(delta : Integer);
begin
  try
  Canvas.lock;
  if delta > 0 then begin
    case FOrientation of
      doLeftToRight : begin
        Dec(FLastPoint[0].x, delta);
        Dec(FLastPoint[1].x, delta);
        BitBlt(Canvas.Handle, FBounds.Left+FMARGIN_LEFT+1,FBounds.Top+FMARGIN_TOP+1,
               FBounds.Right-FBounds.Left-FMARGIN_RIGHT-FMARGIN_LEFT-delta, FBounds.Bottom-FBounds.Top-FMARGIN_TOP-FMARGIN_BOTTOM-1,
               Canvas.Handle, FBounds.Left+FMARGIN_LEFT+delta+1,FBounds.Top+FMARGIN_TOP+1, SRCCOPY);
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := FBackground;
        PatBlt(Canvas.Handle, FBounds.Right-FMARGIN_RIGHT-delta, FBounds.Top+FMARGIN_TOP+1,
               delta, FBounds.Bottom-FBounds.Top-FMARGIN_TOP-FMARGIN_BOTTOM-1, PATCOPY);
        FOrigin[0][1] := FOrigin[0][1] + delta/Scale[0][1];
        Inc(FTag, delta mod 3);
        DrawGrid(Rect(FBounds.Right-FMARGIN_RIGHT-delta-2, FBounds.Top,
                      FBounds.Right-FMARGIN_RIGHT, FBounds.Bottom), False, True);
      end; { doLeftToRight }
      doTopToBottom : begin
        Inc(FLastPoint[0].y, delta);
        Inc(FLastPoint[1].y, delta);
        BitBlt(Canvas.Handle, FBounds.Left+FMARGIN_LEFT+1,FBounds.Top+FMARGIN_TOP+delta,
               FBounds.Right-FBounds.Left-FMARGIN_RIGHT-FMARGIN_LEFT, FBounds.Bottom-FBounds.Top-FMARGIN_TOP-FMARGIN_BOTTOM-delta,
               Canvas.Handle, FBounds.Left+FMARGIN_LEFT+1,FBounds.Top+FMARGIN_TOP, SRCCOPY);
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := FBackground;
        PatBlt(Canvas.Handle, FBounds.Left+FMARGIN_LEFT+1, FBounds.Top+FMARGIN_TOP+1,
               FBounds.Right-FBounds.Left-FMARGIN_LEFT-FMARGIN_RIGHT-1, delta, PATCOPY);
        FOrigin[0][2] := FOrigin[0][2] + delta/Scale[0][2];
        Inc(FTag, delta mod 3);
        DrawGrid(Rect(FBounds.Left, FBounds.Top+FMARGIN_TOP,
                      FBounds.Right, FBounds.Top+FMARGIN_TOP+delta+2), True, False);
      end; { doTopToBottom }
    end; { case }
  end;
  finally
  Canvas.unlock;
  end;
end;

function TIndicatorMulti.PtInGraphicRect(Pt : TPoint) : Boolean;
begin
  Result := PtInRect(TxtRect, Pt);
end;



//*******TScopeArray********

constructor TScopeArray.Create(AOwner : TComponent);
begin
  inherited;
  err:=false;
  FIndicatorMulti := TIndicatorMulti.Create(Rect(0,0, Width, Height), clBlue, clBlack, clYellow);
  FIndicatorMulti.OwnerScope := Self;
  FIndicatorMulti.Canvas := Buffer.Canvas;
  FIndicatorMulti.SetWorldWidth(DPoint(-10, 10));
  FIndicatorMulti.SetWorldHeight(DPoint(-1, 1),0);

end;

destructor TScopeArray.Destroy;
begin
  FIndicatorMulti.Free;

  inherited;
end;

procedure TScopeArray.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if IndicatorMulti <> nil then
    FIndicatorMulti.SetBounds(Rect(0, 0, Width, Height));
  if Created and (not FUpdating) then
    Draw;
end;

procedure TScopeArray.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
begin
    try
    Canvas.Lock;
    inherited;
    finally
    canvas.unlock;
    end;
end;

procedure TScopeArray.Repaint;
begin
if FIndicatorMulti.Canvas.LockCount=0 then inherited;
end;



procedure TScopeArray.Draw;
begin
  if FIndicatorMulti.Canvas.LockCount>0 then exit;

  try
   Buffer.Canvas.Lock;
  inherited Draw;

  With Buffer.Canvas do begin
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Brush.Style := bsSolid;
    Brush.Color := FBackground;
    PatBlt(Handle,0,0,Width,Height,PATCOPY);
    Brush.Style := bsClear;
  end;

 FIndicatorMulti.Draw;


  With Buffer.Canvas do begin
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Brush.Style := bsClear;
    Brush.Color := FBackground;
  end;

  Refresh;
  finally
  Buffer.Canvas.Unlock;
  end;
end;

function TIndicatorMulti.getScrect: TRect;
begin
  result:=Rect(FBounds.Right-FMARGIN_RIGHT-2, FBounds.Top,
                      FBounds.Right-FMARGIN_RIGHT, FBounds.Bottom);
end;


procedure Register;
begin
  {RegisterComponents('IMMI', [TScopeList])};
end;



end.

