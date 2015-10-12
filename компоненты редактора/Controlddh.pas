unit Controlddh;

interface

uses
  Classes, Windows, Messages, Controls, StdCtrls;

const
  sc_DragMove: Longint = $F012;

type
 TControlddh = class (TCustomControl)
  private
    FRectList: array [1..8] of TRect;
    FPosList: array [1..8] of Integer;
    hdc1:     HDC;
    hbrush1:  HBRUSH;
    hPen1:    HPEN;
    HObj1: HGDIOBJ;
    HObj2: HGDIOBJ;
    PostRect: TRect;
  public
    FControl: TControl;
    ForimageCont: TControl;
    constructor Create (AControl: TControl);
    procedure CreateParams (var Params: TCreateParams);
      override;
    procedure CreateHandle; override;
    procedure WmNcHitTest (var Msg: TWmNcHitTest);
      message wm_NcHitTest;
    procedure WmSize (var Msg: TWmSize);
      message wm_Size;

    procedure WmMove (var Msg: TWmMove);
      message wm_Move;
    procedure Paint; override;
   destructor Destroy; override;
  end;

type
 TControlImage = class (TCustomControl)
  private
   // FRectList: array [1..8] of TRect;
    //FPosList: array [1..8] of Integer;
    hdc1:     HDC;
    hbrush1:  HBRUSH;
    hPen1:    HPEN;
    HObj1: HGDIOBJ;
    HObj2: HGDIOBJ;
    PostRect: TRect;
  public
    FControl: TControl;
    constructor Create (AControl: TControl);
    procedure CreateParams (var Params: TCreateParams);
      override;
    procedure CreateHandle; override;
  //  procedure WmNcHitTest (var Msg: TWmNcHitTest);
  //    message wm_NcHitTest;
  //  procedure WmSize (var Msg: TWmSize);
  //    message wm_Size;

  //  procedure WmMove (var Msg: TWmMove);
  //    message wm_Move;
    procedure Paint; override;
   destructor Destroy; override;
  end;

procedure Register;

implementation

uses
 Graphics;

// TDdhSizeButton methods



// TDdhSizerControl methods

constructor TControlddh.Create (AControl: TControl);
var
  R: TRect;
begin
  ForimageCont:=nil;
  if AControl is TControlImage then
  begin
    ForimageCont:=AControl;
    AControl:=(AControl as TControlImage).FControl;
  end;
  inherited Create(AControl);
  FControl := AControl;
  R := FControl.BoundsRect;
  BoundsRect := R;


  Parent := FControl.Parent;
  FPosList [1] := htTopLeft;
  FPosList [2] := htTop;
  FPosList [3] := htTopRight;
  FPosList [4] := htRight;
  FPosList [5] := htBottomRight;
  FPosList [6] := htBottom;
  FPosList [7] := htBottomLeft;
  FPosList [8] := htLeft;
  hdc1:=GetDC((self as TCustomControl).Handle);
  PostRect:=self.BoundsRect;
  hbrush1:=CreateSolidBrush(RGB(255,0,0));
  Hpen1:=CreatePen(0,1,RGB(100,100,100));
  HObj1:=Selectobject(hdc1,hbrush1);
  HObj2:=Selectobject(hdc1,Hpen1);
 // SetROP2(hdc1,R2_NOTXORPEN);
end;

procedure TControlddh.CreateHandle;
begin
  inherited CreateHandle;
  //if ((fcontrol.Owner as TForm).Visible and (fcontrol.Owner as TForm).e) then SetFocus;
end;

procedure TControlddh.CreateParams (var Params: TCreateParams);
begin
  inherited CreateParams(Params);
 Params.ExStyle := Params.ExStyle +
  ws_ex_Transparent;
end;

procedure TControlddh.Paint;
var
  I: Integer;
  ppx,ppy: TPoint;
  hdc2: HDC;
  dc: Hrgn;
  df1,df2: TPoint;
begin
   if assigned(ForimageCont) then
   begin

   ForimageCont.Invalidate;
   FControl.Invalidate;
   end;
  for I := 1 to  8 do
      begin
      ppx:=FRectList[i].TopLeft;ppy:=FRectList[i].BottomRight;
      Rectangle(hdc1,ppx.X,ppx.Y,ppy.X,ppy.Y);
      end;

      ppx:=Frectlist[1].TopLeft;
      ppy:=Frectlist[5].BottomRight;
      MoveToEx(hdc1,ppx.X,ppx.Y,nil);
      LineTo(hdc1,ppy.X-1,ppx.Y);
      LineTo(hdc1,ppy.X-1,ppy.Y-1);
      LineTo(hdc1,ppx.X,ppy.Y-1);
      LineTo(hdc1,ppx.X,ppx.Y);

       PostRect:=self.BoundsRect;

  end;

procedure TControlddh.WmNcHitTest(var Msg: TWmNcHitTest);
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

procedure TControlddh.WmSize (var Msg: TWmSize);
var
  R: TRect;
begin
R := BoundsRect;
InflateRect (R, 0, 0);
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
  if assigned(ForimageCont) then ForimageCont.BoundsRect:=R;
end;

procedure TControlDDH.WmMove(var Msg: TWmMove);
begin
   if assigned(ForimageCont) then ForimageCont.BoundsRect:=self.BoundsRect;
end;

destructor TControlddh.Destroy;
begin

if assigned(Fcontrol) then
   Fcontrol.Invalidate;
  DeleteObject(HObj1);
  DeleteObject(HObj2);
  DeleteDC(hdc1);
if assigned(ForimageCont) then ForimageCont.Invalidate;
inherited destroy;
end;


constructor TControlImage.Create (AControl: TControl);
var
  R: TRect;
begin
  inherited Create(AControl.Owner);
  FControl := AControl;
  R := FControl.BoundsRect;
  BoundsRect := R;


  Parent := FControl.Parent;

  {hdc1:=GetDC((self as TCustomControl).Handle);
  PostRect:=self.BoundsRect;
  hbrush1:=CreateSolidBrush(RGB(255,0,0));
  Hpen1:=CreatePen(0,1,RGB(100,100,100));
  HObj1:=Selectobject(hdc1,hbrush1);
  HObj2:=Selectobject(hdc1,Hpen1);
 // SetROP2(hdc1,R2_NOTXORPEN); }
end;

procedure TControlImage.CreateHandle;
begin
  inherited CreateHandle;
  //SetFocus;
end;

procedure TControlImage.CreateParams (var Params: TCreateParams);
begin
  inherited CreateParams(Params);
 Params.ExStyle := Params.ExStyle +
  ws_ex_Transparent;
end;

procedure TControlImage.Paint;
var
  I: Integer;
  ppx,ppy: TPoint;
  hdc2: HDC;
  dc: Hrgn;
  df1,df2: TPoint;
begin


   //  inherited;
       PostRect:=self.BoundsRect;

  end;



destructor TControlImage.Destroy;
begin
if assigned(Fcontrol) then
   Fcontrol.Invalidate;
  DeleteObject(HObj1);
  DeleteObject(HObj2);
  DeleteDC(hdc1);
inherited destroy;
end;


procedure Register;
begin
  RegisterNoIcon ([TControlddh]);
end;

end.


