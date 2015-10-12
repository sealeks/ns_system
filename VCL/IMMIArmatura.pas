unit IMMIArmatura;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math,
  ParamU, memStructsU, SwitchKnobFormU, Switch2FormU, IMMIControls;

type

  TArmatType = (atValve, atValve1, atVent);
  TArmatMode = (amOn, amOFF, amMidle, amError, amErrorBlink);
  TArmatOrient = (aoHor, aoVert);

  TArmatStyle = class(tPersistent)
  private
    fParam: TParam;
    FPen: TPen;
    FBrush: TBrush;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

  published
    procedure SetParam(value: tParam);
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    property Brush: TBrush read FBrush write SetBrush;
    property Pen: TPen read FPen write SetPen;
    property Param: TParam read FParam write fParam;
  end;

  TIMMIArmat = class(TIMMIGraphicControl)
  private
    FArmatType: TArmatType;
    fArmatMode: TArmatMode;
    fOnStyle, fOFFStyle, fErrorStyle: TArmatStyle;
    fonParamControl, fOffParamControl: string;
    fArmatOrient: TArmatOrient;
    fCaption: TCaption;
    fAccess: integer;
    fUseError: boolean;
    fUseControl: boolean;
    procedure SetArmatType(Value: TArmatType);
    procedure SetArmatMode (Value: TArmatMode);
    procedure SetArmatOrient (Value: tArmatOrient);

    procedure SetOnStyle (Value: TarmatStyle);
    procedure SetOffStyle (Value: TarmatStyle);
    procedure SetErrorStyle (Value: TarmatStyle);
    procedure DrawVentHor(Left, top, Width, Height: integer);
    procedure defineSizes;

    procedure VentClick;
    procedure Valve1Click;
  protected
    procedure Paint; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UnInit; override;
    procedure UpdateValue; override;
    procedure Init(ContName: String); override;
    procedure StyleChanged (Sender: tObject);
  published
    property ArmatOrient: tArmatOrient read fArmatOrient write SetArmatOrient;
    property ArmatMode: TArmatMode read fArmatMode write SetArmatMode default amMidle;
    property ArmatType: TArmatType  read FArmatType write SetArmatType default atValve;

    property OnStyle: TArmatStyle read fOnStyle write SetOnStyle;
    property OffStyle: TArmatStyle read fOffStyle write SetOffStyle;
    property ErrorStyle: TArmatStyle read fErrorStyle write SetErrorStyle;

    property onParamControl: string read fonParamControl write fOnParamControl;
    property offParamControl: string read foffParamControl write fOffParamControl;

    property Caption read fCaption write fCaption;
    property access: integer read faccess write faccess;

    property UseError: boolean read fUseError write fUseError;
    property UseControl: boolean read fUseControl write fUseControl;

    property ShowHint;
    property ParentShowHint;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

procedure Register;

implementation

{ TArmatStyle }
constructor TArmatStyle.Create;
begin
     inherited;
     fPen := tPen.Create;
     fBrush := tBrush.Create;
     fParam := tParam.Create;
end;

procedure TArmatStyle.Assign(Source: TPersistent);
begin
     inherited;
     fPen.Assign(TArmatStyle(Source).fPen);
     fBrush.Assign(TArmatStyle(Source).fBrush);
     fParam.Assign(TArmatStyle(Source).fParam);
end;

procedure TArmatStyle.SetBrush(Value: TBrush);
begin
     fBrush.Assign(Value);
end;

procedure TArmatStyle.SetPen(value: TPen);
begin
     fPen.Assign(Value);
end;

procedure TArmatStyle.SetParam(value: tParam);
begin
     fParam.Assign(Value);
end;

destructor TArmatStyle.Destroy;
begin
     fParam.free;
     fPen.free;
     fBrush.free;
     inherited;
end;

{ TIMMIArmat }
constructor TIMMIArmat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fOnStyle := tArmatStyle.Create;
  fOffStyle := tArmatStyle.Create;
  fErrorStyle := tArmatStyle.Create;
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 34;
  Height := 20;

  fOnStyle.Brush.Color := clGreen;
  fOnStyle.Pen.Color := clBlack;
  fOffStyle.Brush.Color := clSilver;
  fOffStyle.Pen.Color := clBlack;
  fErrorStyle.Brush.Color := clRed;
  fErrorStyle.Pen.Color := clYellow;

  fOnStyle.FPen.OnChange := StyleChanged;
  fOffStyle.FPen.OnChange := StyleChanged;
  ferrorStyle.FPen.OnChange := StyleChanged;

  fOnStyle.FBrush.OnChange := StyleChanged;
  fOffStyle.FBrush.OnChange := StyleChanged;
  fErrorStyle.FBrush.OnChange := StyleChanged;

  if fUseControl then cursor := crHandPoint;
end;

procedure TIMMIArmat.SetArmatType(Value: TArmatType);
begin
  if fArmatType <> value then
  begin
     fArmatType := value;
     defineSizes;
     invalidate;
  end;
end;

procedure TIMMIArmat.SetArmatMode (Value: TArmatMode);
begin
  if fArmatMode <> value then
  begin
     fArmatMode := value;
     invalidate;
  end;
end;

procedure TIMMIArmat.SetArmatOrient (Value: tArmatOrient);
begin
     if fArmatOrient <> value then begin
        fArmatOrient := value;
        defineSizes;
        invalidate;
     end;
end;

procedure TIMMIArmat.VentClick;
begin
     if not fUseControl then exit;
     if not assigned (SwitchKnobForm) then
        Application.CreateForm (TSwitchKnobForm, SwitchKnobForm);

     SwitchKnobForm.IMMISpeedButton1.Param.rtName := fonParamControl;
     SwitchKnobForm.IMMISpeedButton1.Param.access := access;
     SwitchKnobForm.Caption := caption;
     SwitchKnobForm.Left := left + width + 5;
     SwitchKnobForm.Top := top;
     if SwitchKnobForm.Left + SwitchKnobForm.width > screen.width then
          SwitchKnobForm.Left := left - SwitchKnobForm.width - 5;
     SwitchKnobForm.Show;
end;

procedure TIMMIArmat.Valve1Click;
begin
     if not fUseControl then exit;
     if not assigned (Switch2Form) then
        Application.CreateForm (TSwitch2Form, Switch2Form);

     Switch2Form.Caption := caption;

     Switch2Form.IMMISpeedButton1.Param.access := access;
     Switch2Form.IMMISpeedButton1.Param.rtName := foffParamControl;

     Switch2Form.IMMISpeedButton2.Param.access := access;
     Switch2Form.IMMISpeedButton2.Param.rtName := fonParamControl;

     Switch2Form.IMMIImage1.Param.rtName := foffParamControl;
     Switch2Form.IMMIImage2.Param.rtName := fonParamControl;


     Switch2Form.Left := left + width + 5;
     Switch2Form.Top := top;
     if Switch2Form.Left + Switch2Form.width > screen.width then
          Switch2Form.Left := left - Switch2Form.width - 5;

     Switch2Form.Show;
end;

procedure TIMMIArmat.Click;

begin
     inherited;
     case fArmatType of
          atVent, atValve: VentClick;
          atValve1: Valve1Click;
     end;
end;

procedure TIMMIArmat.Paint;
var
  X, Y, W, H: Integer;
begin
  with Canvas do
  begin
    case ArmatMode of
    amOn:
         begin
              Pen := fOnStyle.fPen;
              brush := fOnStyle.FBrush
         end;
    amOff:
         begin
              Pen := fOffStyle.fPen;
              brush := fOffStyle.FBrush
         end;
    amError:
         begin
              Pen := fErrorStyle.fPen;
              brush := fErrorStyle.FBrush
         end;
    end;
    X := Pen.Width div 2;
    Y := X;
    W := Width - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    case fArmatType of
      atValve, atValve1:
        Case fArmatOrient of
           aoHor: Polygon([Point(x, y), Point(x+w-1, y+h-1), Point(x+w-1, y),
                          Point(x, y+h-1), Point(x, y)]);
           aoVert: Polygon([Point(x, y), Point(x+w-1, y+h-1), Point(x, y+h-1),
                          Point(x+w-1, y), Point(x, y)]);
        end;
      atVent: DrawVentHor (x, y+1, w - 1, h - 1);
    end;
  end;
end;

procedure TIMMIArmat.StyleChanged (Sender: tObject);
begin
     invalidate;
end;

procedure TIMMIArmat.SetOnStyle (Value: TarmatStyle);
begin
     fOnStyle.Assign(Value);
end;

procedure TIMMIArmat.SetOffStyle (Value: TarmatStyle);
begin
     fOffStyle.Assign(Value);
end;

procedure TIMMIArmat.SetErrorStyle (Value: TarmatStyle);
begin
     fErrorStyle.Assign(Value);
end;

Procedure TIMMIArmat.DrawVentHor(Left, top, Width, Height: integer);
var
   rad1, rad2: real;
   CenterX, CenterY: real;
   Height1, top1: integer;
begin
     rad1 := minValue([Height / 2, width / 2 * 0.7]);
     rad2 := rad1 / 2.5;

     top1 := round(top + rad2* 0.4);
     height1 := round(Height - rad2* 0.4);

     CenterX := left + width / 2;
     Centery := top1 + height1 / 2;

     with canvas do begin
          PenPos := Point(round(CenterX + 1), round(CenterY - rad1));
          LineTo (left+ Width, round(CenterY - rad1));

          PenPos := Point(round(CenterX), round(Centery - rad2));
          LineTo (left + Width, round(Centery - rad2));



          Ellipse(Round(CenterX - rad1), Round(CenterY - rad1),
                                Round(CenterX + Rad1), Round(CenterY + Rad1));
          Arc(round(CenterX - rad2), round(Centery - rad2),
                                  round(CenterX + rad2), round(Centery + rad2),
                                  round(CenterX), round(top1 + Centery),
                                  round(CenterX), round(top1));

          PenPos := Point(round(CenterX-1), round(Centery - rad2));
          LineTo (left, round(Centery - rad2));

          PenPos := Point(round(CenterX-1), round(Centery + rad2 - 1));
          LineTo (left, round(Centery + rad2 - 1));
          Fillrect(Rect(round(CenterX-1), round(Centery - rad2 + 1),
                                          left, round(Centery + rad2 - 1)));

          Fillrect(Rect(round(CenterX + 1), round(CenterY - rad1 + 1),
                                          left+ Width, round(Centery - rad2)));

           Rectangle(left, round(CenterY - rad2 * 1.4),
                     round(left + rad2 * 0.8), round(CenterY + rad2 * 1.4));

           Rectangle(round(left + width - rad2 * 0.8), round(CenterY - rad1 - rad2* 0.4),
                     round(left + width), round(CenterY - rad2  + rad2 * 0.4));
     end;
end;

procedure TIMMIArmat.defineSizes;
begin
     exit;
     Case fArmatType of
          atVent: case fArmatOrient of
                       aoHor: begin width := 53; height := 37; end;
                       aoVert: begin width := 37; height := 53; end;
                  end;
          atValve, atValve1:
                  case fArmatOrient of
                       aoHor: begin width := 34; height := 20; end;
                       aoVert: begin width := 20; height := 34; end;
                  end;
     end;
end;

procedure TIMMIArmat.Init(ContName: String);
begin
     fOnStyle.Param.Init(ContName);
     if armatType = atValve1 then fOffStyle.Param.Init(ContName);
     if fUseError then fErrorStyle.Param.Init(ContName);
     if fUseControl then cursor := crHandPoint;
end;

procedure TIMMIArmat.UnInit;
begin
     fOnStyle.Param.UnInit;
     if armatType = atValve1 then fOffStyle.Param.UnInit;
     if UseError then fErrorStyle.Param.UnInit;
end;

procedure TIMMIArmat.UpdateValue;
var
   MustMode : TArmatMode;
begin
  mustMode := amOff;
  if (fonStyle.Param.Value <> 0) then
           mustMode := amOn;
  if armatType = atValve1 then begin
    if (fonStyle.Param.Value = 0) and
       (foffStyle.Param.Value <> 0) then
           mustMode := amOff;

    if (fonStyle.Param.Value = 0) and
       (foffStyle.Param.Value = 0) then
           mustMode := amMidle;
  end;

  if (fUseError) and (fErrorStyle.Param.Value <> 0) then
     mustMode := amError;

  if fArmatMode <> mustMode then armatMode := mustMode;
end;


Destructor TIMMIArmat.Destroy;
begin
  fOnStyle.Free;
  fOffStyle.Free;
  fErrorStyle.Free;
  inherited;
end;

procedure Register;
begin
  //RegisterComponents('IMMIOld', [TIMMIArmat]);
end;

end.
