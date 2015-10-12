unit DdhSizer;

interface

uses
  Classes, Windows, Messages, Controls, StdCtrls, Menus, constDef;

const
  sc_DragMove: Longint = $F012;

type
  TDdhSizeButton = class (TButton)
  public
    procedure WmNcHitTest (var Msg: TWmNcHitTest);
      message wm_NcHitTest;
  end;

  TDdhSizerControl = class (TCustomControl)
  private
    FControl: TControl;
    FRectList: array [1..8] of TRect;
    FPosList: array [1..8] of Integer;
    fMenu: TPopupMenu;
  public
    constructor Create (AOwner: TComponent;
      AControl: TControl);
    procedure CreateParams (var Params: TCreateParams);
      override;
    procedure CreateHandle; override;
    procedure WmNcHitTest (var Msg: TWmNcHitTest);
      message wm_NcHitTest;
    procedure WmSize (var Msg: TWmSize);
      message wm_Size;
    procedure WmLButtonDown (var Msg: TWmLButtonDown);
      message wm_LButtonDown;
    procedure WmRButtonDown (var Msg: TWmLButtonDown);
      message wm_RButtonDown;
    procedure WmMove (var Msg: TWmMove);
      message wm_Move;
    procedure Paint; override;
    procedure SizerControlExit (Sender: TObject);
    procedure PopMenuShowProp(Sender: TObject);
    procedure PopMenuBringToFront(Sender: TObject);
    procedure PopMenuSendToBack(Sender: TObject);
  end;

procedure Register;

implementation

uses
  Graphics;

// TDdhSizeButton methods

procedure TDdhSizeButton.WmNcHitTest(var Msg: TWmNcHitTest);
var
  Pt: TPoint;
begin
  Pt := Point (Msg.XPos, Msg.YPos);
  Pt := ScreenToClient (Pt);
  if (Pt.x < 5) and (pt.y < 5) then
    Msg.Result := htTopLeft
  else if (Pt.x > Width - 5) and (pt.y < 5) then
    Msg.Result := htTopRight
  else if (Pt.x > Width - 5) and (pt.y > Height - 5) then
    Msg.Result := htBottomRight
  else if (Pt.x < 5) and (pt.y > Height - 5) then
    Msg.Result := htBottomLeft
  else if (Pt.x < 5) then
    Msg.Result := htLeft
  else if (pt.y < 5) then
    Msg.Result := htTop
  else if (Pt.x > Width - 5) then
    Msg.Result := htRight
  else if (pt.y > Height - 5) then
    Msg.Result := htBottom
  else
    inherited;
end;

// TDdhSizerControl methods

constructor TDdhSizerControl.Create (
  AOwner: TComponent; AControl: TControl);
var
  R: TRect;
begin
  inherited Create (AOwner);
  FControl := AControl;
  // install the new handler
  OnExit := SizerControlExit;
  // set the size and position
  R := FControl.BoundsRect;
  InflateRect (R, 2, 2);
  BoundsRect := R;
  // set the parent
  Parent := FControl.Parent;
  // create the list of positions
  FPosList [1] := htTopLeft;
  FPosList [2] := htTop;
  FPosList [3] := htTopRight;
  FPosList [4] := htRight;
  FPosList [5] := htBottomRight;
  FPosList [6] := htBottom;
  FPosList [7] := htBottomLeft;
  FPosList [8] := htLeft;
  fMenu := NewPopupMenu(Self, 'MyMenu', paLeft, false,
                    [NewItem('На передний план', 0,
                      False, True, self.PopMenuBringToFront, 0, 'Item1'),
                      NewItem('На задний план', 0,
                      False, True, self.PopMenuSendToBack, 0, 'Item1'),
                      NewItem('Свойства', 0,
                      False, True, self.PopMenuShowProp, 0, 'Item1')]);
end;

procedure TDdhSizerControl.CreateHandle;
begin
  inherited CreateHandle;
  SetFocus;
end;

procedure TDdhSizerControl.CreateParams (var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle +
    ws_ex_Transparent;
end;

procedure TDdhSizerControl.Paint;
var
  I: Integer;
begin
  Canvas.Brush.Color := clBlack;
  for I := 1 to  8 do
    Canvas.Rectangle (FRectList [I].Left, FRectList [I].Top,
      FRectList [I].Right, FRectList [I].Bottom);
end;

procedure TDdhSizerControl.WmNcHitTest(var Msg: TWmNcHitTest);
var
  Pt: TPoint;
  I: Integer;
begin
  Pt := Point (Msg.XPos, Msg.YPos);
  Pt := ScreenToClient (Pt);
  Msg.Result := 0;
  for I := 1 to  8 do
    if PtInRect (FRectList [I], Pt) then
      Msg.Result := FPosList [I];
  // if the return value was not set
  if Msg.Result = 0 then
    inherited;
end;

procedure TDdhSizerControl.WmSize (var Msg: TWmSize);
var
  R: TRect;
begin
  R := BoundsRect;
  InflateRect (R, -2, -2);
  FControl.BoundsRect := R;
  // setup data structures
  FRectList [1] := Rect (0, 0, 5, 5);
  FRectList [2] := Rect (Width div 2 - 3, 0,
    Width div 2 + 2, 5);
  FRectList [3] := Rect (Width - 5, 0, Width, 5);
  FRectList [4] := Rect (Width - 5, Height div 2 - 3,
   Width, Height div 2 + 2);
  FRectList [5] := Rect (Width - 5, Height - 5,
   Width, Height);
  FRectList [6] := Rect (Width div 2 - 3, Height - 5,
    Width div 2 + 2, Height);
  FRectList [7] := Rect (0, Height - 5, 5, Height);
  FRectList [8] := Rect (0, Height div 2 - 3,
   5, Height div 2 + 2);
end;

procedure TDdhSizerControl.SizerControlExit (Sender: TObject);
begin
  Free;
end;

procedure TDdhSizerControl.WmLButtonDown (var Msg: TWmLButtonDown);
begin
  Perform (wm_SysCommand, sc_DragMove, 0);
end;

procedure TDdhSizerControl.WmMove (var Msg: TWmMove);
var
  R: TRect;
begin
  refresh;
  R := BoundsRect;
  InflateRect (R, -2, -2);
  FControl.Invalidate; // repaint entire surface
  FControl.BoundsRect := R;
  refresh;
end;

// components registration

procedure Register;
begin
  //RegisterComponents ('DDHB', [TDdhSizeButton]);
 // RegisterNoIcon ([TDdhSizerControl]);
end;

procedure TDdhSizerControl.WmRButtonDown(var Msg: TWmLButtonDown);
var
  pt : TPoint;
begin
  with TWMMouse(Msg) do
    pt := clienttoscreen(Point(xPos, yPos));
  fmenu.Popup(pt.x, pt.Y);
end;

procedure TDdhSizerControl.PopMenuBringToFront(Sender: TObject);
begin
  fControl.BringToFront;
end;

procedure TDdhSizerControl.PopMenuSendToBack(Sender: TObject);
begin
  fControl.SendToBack;
end;

procedure TDdhSizerControl.PopMenuShowProp(Sender: TObject);
begin
  fControl.Perform(WM_IMMSHOWPROPFORM, 0, 0);
end;

end.
