unit Imit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, ComCtrls, stdCtrls,
  dialogs, Math, Graphics,
  Expr, constDef, ParamU, ImitEditFrm,MemstructsU;

type
  TImit = class(TWinControl)
  private
    { Private declarations }
    fshpqOn, fshpqOff, fshpOn, fshpOff, fshpStop: TShape;
    fshpPos: TProgressBar;
    fSpeed: real;
    fqOnStr, fqOffStr, fOnStr, fOffStr, fPosStr: TExprStr;
    fqOnExpr, fqOffExpr: TExpretion;
    fOnParam, fOffParam, fPosParam: TParamControl;
    fqOn, fqOff, fOn, fOff: boolean;
    fcaption: string;
    flblpos, flblStop: TLabel;
    fStop, fRST: boolean;
    procedure WMSize (var Msg : TMsg); Message WM_SIZE;
    procedure CalcSizes;
    procedure SetStop(const Value: boolean);
    //procedure SetRST(const Value: boolean);
    procedure SetOff(const Value: boolean);
    procedure SetOn(const Value: boolean);
    procedure SetqOff(const Value: boolean);
    procedure SetqOn(const Value: boolean);
    procedure SetCaption(const Value: string);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure fshpqOnMouseDown(Sender: TObject; Button: TMouseButton;
                  Shift: TShiftState; X, Y: Integer);
    procedure fshpqOffMouseDown(Sender: TObject; Button: TMouseButton;
                  Shift: TShiftState; X, Y: Integer);
    procedure fshpOnMouseDown(Sender: TObject; Button: TMouseButton;
                  Shift: TShiftState; X, Y: Integer);
    procedure fshpOffMouseDown(Sender: TObject; Button: TMouseButton;
                  Shift: TShiftState; X, Y: Integer);
    procedure fshpStopMouseDown(Sender: TObject; Button: TMouseButton;
                  Shift: TShiftState; X, Y: Integer);
    property qon: boolean read fqon write SetqOn;
    property qoff: boolean read fqoff write SetqOff;
    property on_: boolean read fon write SetOn;
    property off: boolean read foff write SetOff;

    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;

    procedure ShowPropForm;
    procedure ShowPropFormMsg (var Msg: TMessage); message WM_IMMSHOWPROPFORM;
  published
    { Published declarations }
    property Caption: string read fCaption write SetCaption;
    property Stop: boolean read fStop write SetStop;
    property Speed: real read fSpeed write fSpeed;
    property qOnStr: TExprStr read fqonStr write fqOnStr;
    property qOffStr: TExprStr read fqoffStr write fqOffStr;
    property OnStr: TExprStr read fonStr write fOnStr;
    property OffStr: TExprStr read foffStr write fOffStr;
    property PosStr: TExprStr read fPosStr write fPosStr;
    property RST: boolean read fRST write fRST;
  end;

implementation


{ TImit }

constructor TImit.Create(AOwner: TComponent);
begin
  inherited;

  fSpeed := 10;

  width := 65;
  height := 97;

  fshpqOn := TShape.Create(self);
  with fshpqOn do
  begin
    parent := self;
    shape := stRectangle;
    fshpqOn.OnMouseDown := fshpqOnMouseDown;

  end;

  fshpqOff := TShape.Create(self);
  with fshpqOff do
  begin
    parent := self;
    shape := stRectangle;
    OnMouseDown := fshpqOffMouseDown;
  end;

  fshpOn := TShape.Create(self);
  with fshpOn do
  begin
    parent := self;
    shape := stRectangle;
    fshpOn.OnMouseDown := fshpOnMouseDown;
  end;

  fshpOff := TShape.Create(self);
  with fshpOff do
  begin
    parent := self;
    shape := stRectangle;
    fshpOff.OnMouseDown := fshpOffMouseDown;
  end;


  fshpPos := TProgressBar.Create(self);
  with fshpPos do
  begin
    parent := self;
  end;

  fshpStop := TShape.Create(self);
  with fshpStop do
  begin
    parent := self;
    shape := stRectangle;
    OnMouseDown := fshpStopMouseDown;
  end;

  flblPos := tLabel.Create(self);
  flblPos.parent := self;
  flblStop := tLabel.Create(self);
  flblStop.parent := self;
  flblStop.transparent := true;
  flblStop.Caption := 'ярно';

end;

destructor TImit.Destroy;
begin
  fshpqOn.free;
  fshpqOff.free;
  fshpOn.free;
  fshpOff.Free;
  fshpPos.Free;
  fshpStop.Free;
  flblPos.Free;
  flblStop.Free;
  inherited;
end;

procedure TImit.WMSize(var Msg: TMsg);
begin
  CalcSizes;
  inherited;
end;

procedure TImit.CalcSizes;
begin

  flblPos.Top := trunc(self.height * 0.13 / 2 - flblPos.Height / 2);
  flblPos.Left := 0;

  with fshpPos do
  begin
    left := 0;
    top := trunc(self.height * 0.13);
    width := self.width;
    height := trunc(self.height * 0.07);
  end;

  with fshpqOn do
  begin
    left := 0;
    top := trunc(self.height * 0.2);
    width := trunc(self.width / 2);
    height := trunc(self.height /100 * 30);
  end;

  with fshpOn do
  begin
    left := trunc(self.width / 2);
    top := trunc(self.height * 0.2);;
    width := trunc(self.width / 2);
    height := trunc(self.height /100 * 30);
  end;

  with fshpqOff do
  begin
    left := 0;
    top := trunc(self.height * 0.5);
    width := trunc(self.width / 2);
    height := trunc(self.height / 100 * 30);
  end;

  with fshpOff do
  begin
    left := trunc(self.width / 2);
    top := trunc(self.height * 0.5);
    width := trunc(self.width / 2);
    height := trunc(self.height / 100 * 30);
  end;

  with fshpStop do
  begin
    left := 0;
    top := trunc(self.height * 0.8);
    width := self.width;
    height := trunc(self.height * 0.2);
  end;
  flblStop.Top := trunc(fshpStop.Top + fshpStop.Height / 2 - flblStop.Height / 2);
  flblStop.Left := trunc(fshpStop.Width / 2 - flblStop.width / 2);
end;

procedure TImit.fshpqOnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  qon := not qon;
end;

procedure TImit.fshpStopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Stop := not Stop;
end;

procedure TImit.SetStop(const Value: boolean);
begin
  fStop := Value;
  fshpStop.Brush.Color := ifthen (fStop, clRed, clWhite);
end;

{procedure TImit.SetRST(const Value: boolean);
begin
  fRST := Value;
end;}

procedure TImit.fshpqOffMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  qoff := not qoff;
end;


procedure TImit.SetOff(const Value: boolean);
begin
  foff := Value;
  fshpOff.Brush.Color := ifthen (fOff, clGreen, clWhite);
end;

procedure TImit.SetOn(const Value: boolean);
begin
  fon := Value;
  fshpOn.Brush.Color := ifthen (Fon, clGreen, clWhite);
end;

procedure TImit.SetqOff(const Value: boolean);
begin
  fqoff := Value;
  fshpqOff.Brush.Color := ifthen (fqoff, clGreen, clWhite);
end;

procedure TImit.SetqOn(const Value: boolean);
begin
  fqon := Value;
  fshpqOn.Brush.Color := ifthen (Fqon, clGreen, clWhite);
end;

procedure TImit.ImmiInit(var Msg: TMessage);
begin
  CreateAndInitExpretion(fqOnExpr, fqOnStr);
  CreateAndInitExpretion(fqOffExpr, fqOffStr);
  CreateAndInitParamControl(fOnParam, fOnStr);
  CreateAndInitParamControl(fOffParam, fOffStr);
  CreateAndInitParamControl(fPosParam, fPosStr);
  flblPos.Caption := Caption + '=%d';
end;

procedure TImit.ImmiUnInit(var Msg: TMessage);
begin
  if assigned(fqOnExpr) then fqOnExpr.ImmiUnInit;
  if assigned(fqOffExpr) then fqOffExpr.ImmiUnInit;
  if assigned(fOnParam) then fOnParam.UnInit;
  if assigned(fOffParam) then fOffParam.UnInit;
  if assigned(fPosParam) then fPosParam.UnInit;
end;

procedure TImit.ImmiUpdate(var Msg: TMessage);
begin
  if assigned(fqOnExpr) then
  begin
     fqOnExpr.ImmiUpdate;
     qOn := (fqOnExpr.Value <> 0);
     if not assigned(fqOffExpr) then qOff := (fqOnExpr.Value = 0)
  end;
  if assigned(fqOffExpr) then
  begin
     fqOffExpr.ImmiUpdate;
     qOff := (fqOffExpr.Value <> 0);
     if not assigned(fqOnExpr) then qOn := (fqOffExpr.Value = 0)
  end;
  if assigned(fOnParam) then
  begin
     fOnParam.ImmiUpdate;
     On_ := (fOnParam.Value <> 0);
  end;
  if assigned(fOffParam) then
  begin
     fOffParam.ImmiUpdate;
     Off := (fOffParam.Value <> 0);
  end;
  if assigned(fPosParam) then
  begin
     fPosParam.ImmiUpdate;
     fshpPos.Position := trunc(fPosParam.Value);
  end;
  if fRST then
  begin
   if ((qOn = true) and On_ ) then if rtitems.GetSimpleID(fqOnExpr.expr)>-1 then rtitems.setval(rtitems.getsimpleId(fqOnExpr.expr),0,100);
   if ((qOff = true) and Off ) then if rtitems.GetSimpleID(fqOffExpr.expr)>-1 then rtitems.setval(rtitems.getsimpleId(fqOffExpr.expr),0,100);
  end;
  if not fStop then
  begin
    fshpPos.Position := min(100, max(0, round(fshpPos.Position + fSpeed *(integer(fqOn) - integer(fqOff)))));
    flblPos.Caption := format(Caption, [fshpPos.Position]);
    On_ := (fshpPos.Position = 100);
    Off := (fshpPos.Position = 0);
    if assigned (fOnParam) and (On_ and not fOnParam.IsOn) then fOnParam.TurnOn;
    if assigned (fOnParam) and (not On_ and fOnParam.IsOn) then fOnParam.TurnOff;
    if assigned (fOffParam) and (off and not fOffParam.IsOn)then fOffParam.TurnOn;
    if assigned (fOffParam) and (not Off and fOffParam.IsOn) then fOffParam.TurnOff;
    if assigned (fPosParam) and (abs(fshpPos.Position - fPosParam.Value) >= 1) then fPosParam.SetNewValue(fshpPos.Position);
  end;
end;


procedure TImit.ShowPropForm;
begin
  with TImitEditForm.Create(nil) do
    try
      Edit1.Text := fqonStr;
      edit2.Text := fqOffStr;
      edit3.Text := fOnStr;
      edit4.text := fOffStr;
      edit5.text := self.caption;
      edit6.text := fPosStr;
      spinEdit1.Value := trunc(fSpeed);
      if ShowModal = mrOk then
      begin
        fqonStr := Edit1.Text;
        fqOffStr := edit2.Text;
        fOnStr := edit3.Text;
        fOffStr := edit4.text;
        fSpeed := spinEdit1.Value;
        self.caption := edit5.Text;
        fPosStr := edit6.text;
      end;
    finally
      free;
    end;
end;

procedure TImit.ShowPropFormMsg(var Msg: TMessage);
begin
  ShowPropForm;
end;

procedure TImit.SetCaption(const Value: string);
begin
  fCaption := Value;
  flblPos.Caption := fCaption;
end;

procedure TImit.fshpOffMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if assigned (fOffParam) then
    if fOffParam.isOn then fOffParam.TurnOff
    else fOffParam.TurnOn;
end;

procedure TImit.fshpOnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if assigned (fOnParam) then
    if fOnParam.isOn then fOnParam.TurnOff
    else fOnParam.TurnOn;
end;

initialization
 registerclasses([TProgressBar]);

end.
