unit TrackBarDouble;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls, StdCtrls, dialogs;

type
  TTrackBarDouble = class(TTrackBar)
  private
  protected
    { Private declarations }
    fPosition1: Integer;
    fSlider, fSlider1: TButton;
    ActiveSlider: TButton;

    procedure SetPosition(const Value: Integer);
    procedure SetPosition1(const Value: Integer);
    procedure CalcSlider(Slider: TButton; Pos: integer);
    function GetPosition: Integer;
    procedure InitSlider(var ASlider: TButton; W, H: integer);
    procedure SetupSlider(var ASlider: TButton; W, H: integer);
    function GetOrientation: TTrackBarOrientation;
    procedure SetOrientation(const Value: TTrackBarOrientation);

    { Protected declarations }
  public
    { Public declarations }
    constructor Create (AOwner: TComponent); override;
    procedure SliderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SliderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SliderMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  published
    { Published declarations }
    property Position:  Integer read GetPosition write SetPosition;
    property Position1: Integer read FPosition1 write SetPosition1;
    property Orientation: TTrackBarOrientation read GetOrientation write SetOrientation;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('IMMICtrls', [TTrackBarDouble]);
end;

{ TTrackBarDouble }

procedure TTrackBarDouble.CalcSlider(Slider: TButton; Pos: integer);
begin
  if orientation = trHorizontal then
    slider.Left := 12 + round((Width - 24) * pos / (Max - min) - slider.Width / 2)
  else
    slider.Top := 12 + round((Height - 24) * pos / (Max - min) - slider.Height / 2)
end;

constructor TTrackBarDouble.Create(AOwner: TComponent);
begin
  inherited;
  sliderVisible := false;
  InitSlider(fSlider, 8, 25);
  InitSlider(fSlider1, 8, 25);
end;

procedure TTrackBarDouble.InitSlider(var ASlider: TButton; W, H: integer);
begin
  ASlider := TButton.Create(Self);
  ASlider.parent := Self;
  SetupSlider (ASlider, W, H);
  ASlider.OnMouseDown := SliderMouseDown;
  ASlider.OnMouseMove := SliderMouseMove;
  ASlider.OnMouseUp := SliderMouseUp;
end;

procedure TTrackBarDouble.SetupSlider(var ASlider: TButton; W, H: integer);
begin
  ASlider.Width := W;
  ASlider.Height := H;
end;

function TTrackBarDouble.GetPosition: Integer;
begin
  result := inherited Position;
end;

procedure TTrackBarDouble.SetPosition(const Value: Integer);
begin
  //Position always more or equel then position1
  if value > Position1 then
    inherited Position := Value
  else inherited Position := Position1+1;
  calcSlider(fSlider, position);
end;

procedure TTrackBarDouble.SetPosition1(const Value: Integer);
begin
  if Value < Min then fPosition1 := Min
  else
    if Value > Max then fPosition1 := Max
    else
      if FPosition1 <> Value then
        if value < Position then
          FPosition1 := Value
        else FPosition1 := Position;
  calcSlider(fSlider1, Position1);
  if assigned(OnChange) then OnChange(Self); 
end;

procedure TTrackBarDouble.SliderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ActiveSlider:= Sender as TButton;
end;

procedure TTrackBarDouble.SliderMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  posPoint: tpoint;
  pos: Integer;
begin
  if (ActiveSlider = sender) then
  begin
    posPoint := Self.ScreenToClient((sENDER AS tcONTROL).ClienttoScreen(Point(x, y)));
    if orientation = trHorizontal then
      pos := round(((posPoint.x - 12) * (Max - min) - (Sender as TControl).Width / 2) / (Width - 24))
    else
      pos := round(((posPoint.y - 12) * (Max - min) - (Sender as TControl).Height / 2) / (Height - 24));
    if ActiveSlider = fSlider then position := pos else Position1 := pos;
  end;
end;

procedure TTrackBarDouble.SliderMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ActiveSlider:= nil;
end;

function TTrackBarDouble.GetOrientation: TTrackBarOrientation;
begin
  result := inherited orientation;
end;

procedure TTrackBarDouble.SetOrientation(
  const Value: TTrackBarOrientation);
begin
  inherited orientation := value;
  if orientation = trHorizontal then
  begin
    SetupSlider(fSlider, 8, 25);
    SetupSlider(fSlider1, 8, 25);
  end
  else
  begin
    SetupSlider(fSlider, 25, 8);
    SetupSlider(fSlider1, 25, 8);
  end;

  calcSlider(fSlider, position);
  calcSlider(fSlider1, position1);
end;

end.
