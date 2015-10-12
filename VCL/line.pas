unit line;

interface

uses
  Windows, Messages, Graphics, SysUtils, Classes, Controls;

type
  TLineDirection = (drLeftRight, drUpDown, drTopLeftBottomRight, drTopRightBottomLeft);

  TLine = class(TGraphicControl)
  private
    { Private declarations }
    FLineDir: TLineDirection;
    FArrow1: Boolean;
    FArrow2: Boolean;
    FArrowFactor: Integer;
    
    function GetLineWidth: Integer;
    function GetLineColor: TColor;
    function GetArrowColor: TColor;
    procedure SetLineWidth(const NewWidth: Integer);
    procedure SetLineColor(const NewColor: TColor);
    procedure SetArrowColor(const NewColor: TColor);
    procedure SetLineDir(const NewDir: TLineDirection);
    procedure SetArrow1(Value: Boolean);
    procedure SetArrow2(Value: Boolean);
    procedure SetArrowFactor(Value: integer);
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property DragCursor;
    property DragKind;
    property DragMode;
    property Align;
    property ParentShowHint;
    property Hint;
    property ShowHint;
    property Visible;
    property PopupMenu;
    property Direction: TLineDirection read FLineDir write SetLineDir default drLeftRight;
    property LineColor: TColor read GetLineColor write SetLineColor;
    property ArrowColor: TColor read GetArrowColor write SetArrowColor;
    property LineWidth: Integer read GetLineWidth write SetLineWidth;
    property Arrow1: Boolean read FArrow1 write SetArrow1 default False;
    property Arrow2: Boolean read FArrow2 write SetArrow2 default False;
    property ArrowFactor: Integer read FArrowFactor write SetArrowFactor default 3;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEndDock;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
  end;

procedure Register;

implementation

{ TLine }

constructor TLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 65;
  Height := 4;
  Canvas.Brush.Color:=clBlack;
  FArrowFactor:=3;
end;

destructor TLine.Destroy;
begin
  inherited Destroy;
end;

procedure TLine.SetArrowFactor(Value: Integer);
begin
  if Value <> FArrowFactor then begin
     FArrowFactor := Value;
     Invalidate; 
  end;
end;

procedure TLine.SetArrow1(Value: Boolean);
begin
  if Value <> FArrow1 then begin
     FArrow1 := Value;
   {  if Value then SetLineWidth(1);
     Invalidate;  }
  end;
end;

procedure TLine.SetArrow2(Value: Boolean);
begin
  if Value <> FArrow2 then begin
     FArrow2 := Value;
     {if Value then SetLineWidth(1);
     Invalidate;  }
  end;
end;


function TLine.GetLineWidth: Integer;
begin
  Result := Canvas.Pen.Width;
end;

function TLine.GetLineColor: TColor;
begin
  Result := Canvas.Pen.Color;
end;

function TLine.GetArrowColor: TColor;
begin
  Result := Canvas.Brush.Color;
end;

procedure TLine.SetLineWidth(const NewWidth: Integer);
begin
  if NewWidth <> Canvas.Pen.Width then
  begin
    if FArrow1 or FArrow2 then begin
       LineWidth:=1;
       Canvas.Pen.Width:=1;
    end else Canvas.Pen.Width := NewWidth;
    //Invalidate;
  end;
end;

procedure TLine.SetLineColor(const NewColor: TColor);
begin
  if NewColor <> Canvas.Pen.Color then
  begin
    Canvas.Pen.Color := NewColor;
   // Invalidate;
  end;
end;

procedure TLine.SetArrowColor(const NewColor: TColor);
begin
  if NewColor <> Canvas.Brush.Color then
  begin
    Canvas.Brush.Color := NewColor;
   // Invalidate;
  end;
end;

procedure TLine.SetLineDir(const NewDir: TLineDirection);
begin
  if NewDir <> FLineDir then
  begin
    FLineDir := NewDir;
    Invalidate;
  end;
end;

procedure TLine.Paint;
var
  start: Integer;
  p1,p2,p3:TPoint;
  H0,W0,H,W:Integer;
  Alfa:extended;
begin
  inherited;
  case FLineDir of
    drLeftRight:
      begin
        start := (Height - Canvas.Pen.Width) div 2;
        Canvas.MoveTo(0, start);
        Canvas.LineTo(Width, Start);
        if FArrow1 then begin
          //Flecha hacia izquierda
          p1:=Point(0,start);
          p2:=Point(FArrowFactor,Start-FArrowFactor);
          p3:=Point(FArrowFactor,Start+FArrowFactor);
          Canvas.Polygon([p1,p2,p3]);
        end;

        if FArrow2 then begin
          //Flecha hacia derecha
          p1:=Point(Width-1, Start);
          p2:=Point(Width-(FArrowFactor+1),Start-FArrowFactor);
          p3:=Point(Width-(FArrowFactor+1),Start+FArrowFactor);
          Canvas.Polygon([p1,p2,p3]);
        end;
      end;
    drUpDown:
      begin
        start := (Width - Canvas.Pen.Width) div 2;
        Canvas.MoveTo(start, 0);
        Canvas.LineTo(start, Height);
        if FArrow1 then begin
          //Flecha hacia arriba
          p1:=Point(start,0);
          p2:=Point(Start-FArrowFactor,FArrowFactor);
          p3:=Point(Start+FArrowFactor,FArrowFactor);
          Canvas.Polygon([p1,p2,p3]);
        end;

        if FArrow2 then begin
          //Flecha hacia abajo
          p1:=Point(start,Height-1);
          p2:=Point(Start-FArrowFactor,Height-(FArrowFactor+1));
          p3:=Point(Start+FArrowFactor,Height-(FArrowFactor+1));
          Canvas.Polygon([p1,p2,p3]);
        end;
      end;
    drTopLeftBottomRight:
      begin
        Canvas.MoveTo(0, 0);
        Canvas.LineTo(Width, Height);
        if FArrow1 and(Width>0)then begin
          //Flecha hacia arriba
          Alfa:=ArcTan(Height/Width);
          H0:=Round((FArrowFactor+1)*Sin(Alfa));
          W0:=Round((FArrowFactor+1)*Cos(Alfa));

          p1:=Point(0,0);
          W:=Round(W0+(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0-(FArrowFactor*Sin((Pi/2)-Alfa)));

          if H<0 then H:=0;
          if W<0 then W:=0;

          p2:=Point(W,H);

          W:=Round(W0-(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0+(FArrowFactor*Sin((Pi/2)-Alfa)));

          if H<0 then H:=0;
          if W<0 then W:=0;

          p3:=Point(W,H);

          Canvas.Polygon([p1,p2,p3]);
        end;


        if FArrow2 and(Width>0)then begin
          //Flecha hacia abajo
          Alfa:=ArcTan(Height/Width);
          H0:=Round((FArrowFactor+1)*Sin(Alfa));
          W0:=Round((FArrowFactor+1)*Cos(Alfa));

          p1:=Point(Width-1, Height-1);
          
          W:=Round(W0-(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0+(FArrowFactor*Sin((Pi/2)-Alfa)));

          W:=Width-W-1;
          H:=Height-H-1;
          
          if H>=Height then H:=Height-1;
          if W>=Width then W:=Width-1;

          p2:=Point(W,H);

          W:=Round(W0+(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0-(FArrowFactor*Sin((Pi/2)-Alfa)));

          W:=Width-W-1;
          H:=Height-H-1;
          
          if H>=Height then H:=Height-1;
          if W>=Width then W:=Width-1;

          p3:=Point(W,H);

          Canvas.Polygon([p1,p2,p3]);
        end;

      end;
    drTopRightBottomLeft:
      begin
        Canvas.MoveTo(Width, 0);
        Canvas.LineTo(0, Height);
        if FArrow1 and(Width>0)then begin
          //Flecha hacia arriba
          Alfa:=ArcTan(Height/Width);
          H0:=Round((FArrowFactor+1)*Sin(Alfa));
          W0:=Round((FArrowFactor+1)*Cos(Alfa));

          p1:=Point(Width-1,0);
          
          W:=Round(W0+(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0-(FArrowFactor*Sin((Pi/2)-Alfa)));

          W:=Width-W-1;

          if H<0 then H:=0;
          if W>=Width then W:=Width-1;

          p2:=Point(W,H);

          W:=Round(W0-(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0+(FArrowFactor*Sin((Pi/2)-Alfa)));

          W:=Width-W-1;

          if H<0 then H:=0;
          if W>=Width then W:=Width-1;

          p3:=Point(W,H);

          Canvas.Polygon([p1,p2,p3]);
        end;

        if FArrow2 and(Width>0)then begin
          //Flecha hacia abajo
          Alfa:=ArcTan(Height/Width);
          H0:=Round((FArrowFactor+1)*Sin(Alfa));
          W0:=Round((FArrowFactor+1)*Cos(Alfa));

          p1:=Point(0, Height-1);
          
          W:=Round(W0-(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0+(FArrowFactor*Sin((Pi/2)-Alfa)));

          H:=Height-H-1;
          
          if H>=Height then H:=Height-1;
          if W<0 then W:=0;

          p2:=Point(W,H);

          W:=Round(W0+(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0-(FArrowFactor*Sin((Pi/2)-Alfa)));

          H:=Height-H-1;
          
          if H>=Height then H:=Height-1;
          if W<0 then W:=0;

          p3:=Point(W,H);

          Canvas.Polygon([p1,p2,p3]);
        end;
      end;
  end;
end;

procedure Register;
begin

end;

end.
