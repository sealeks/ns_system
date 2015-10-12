unit PDJRotoLabel;

// TPDJRotoLabel version 1.10
// Freeware Component for D3,D4,D5,D6
// Copyright © 2000-2001 by Peric
// Birthday of Component 23.05.2001.
// E-mail: pericddn@ptt.yu
// If I' find any errors or rubbish in TPDJRotoLabel please send me Your suggest or Reclamation.


{$IFDEF VER100}
  {$DEFINE PDJ_D3}
{$ELSE}
  {$IFDEF VER120}
    {$DEFINE PDJ_D4}
  {$ELSE}
    {$DEFINE PDJ_D5Up}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER140}
  {$DEFINE PDJ_D6}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MMSystem,ExtCtrls,Buttons,StdCtrls;

{$R PDJRotoLabel.res}

type
  TOnMouseOverEvent = procedure(Sender: TObject) of object;
  TOnMouseOutEvent = procedure(Sender: TObject) of object;
  TUgao = (ag0,ag45,ag90,ag135,ag180,ag225,ag270,ag315);
  TPDJRotoLabel = class(TGraphicControl)
  private

    FUgao:TUgao;
    FZaokretanje:integer;
    FOnMouseOver: TOnMouseOverEvent;
    FOnMouseOut: TOnMouseOutEvent;
    FText3D:boolean;

    procedure DrawCaption;
    procedure DrawCaptionEnabled;
    procedure DrawCaption3D;
    procedure Krecenje;
    procedure SetUgao(value:TUgao);
    function GetTransparent: Boolean;
    procedure SetTransparent(Value: Boolean);
    procedure SetText3D(AText3D: Boolean);

    procedure CMMouseEnter(var AMsg: TMessage);
              message CM_MOUSEENTER;
    procedure CMMouseLeave(var AMsg: TMessage);
              message CM_MOUSELEAVE;
    procedure CmTextChanged(var Message: TWmNoParams);
              message CM_TEXTCHANGED;
    procedure CMSysColorChange(var Message: TMessage);
              message CM_SYSCOLORCHANGE;
    procedure CMColorChanged(var Message: TMessage);
              message CM_COLORCHANGED;
    procedure CmEnabledChanged(var Message: TWmNoParams);
              message CM_ENABLEDCHANGED;
    procedure CmParentColorChanged(var Message: TWMNoParams);
              message CM_PARENTCOLORCHANGED;
    procedure CmVisibleChanged(var Message: TWmNoParams);
              message CM_VISIBLECHANGED;
    procedure CmFontChanged(var Message: TWMNoParams);
              message CM_FONTCHANGED;

  protected
    procedure Paint;override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure IntToAngle(const value:integer);
    
  published
    property Text3D:Boolean read FText3D write SetText3D default False;
    property Transparent: Boolean read GetTransparent write SetTransparent default False;
    property Angle:TUgao read FUgao write SetUgao default ag45;
    property Caption;
    property Font;
    property Color;
    property ParentColor;
    property Enabled;
    property Visible;
    property Align;
    property ShowHint;
    property DragCursor;
    property DragMode;

    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnStartDrag;
    property OnMouseEnter: TOnMouseOverEvent read FOnMouseOver write FOnMouseOver;
    property OnMouseExit: TOnMouseOutEvent read FOnMouseOut write FOnMouseOut;
    property PopupMenu;
    

       {$IFDEF PDJ_D3}
  {$ELSE}
    property Anchors;
    property Constraints;
    property DragKind;
  {$ENDIF}

  end;

//procedure Register;

implementation
var   tf : TFont;
Krec:TColor;

//procedure Register;
{begin
  RegisterComponents('PDJ', [TPDJRotoLabel]);
end;      }

constructor TPDJRotoLabel.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
SetBounds(0, 0, 90, 90);
ControlStyle := ControlStyle + [csOpaque];
FUgao:=ag45;
FZaokretanje:=450;
FText3D:=False;
with Font do
begin
Name:='Arial';
Size:=10;
Style:=Font.Style + [fsBold];
Color:=clRed;
end;
end;

destructor TPDJRotoLabel.Destroy;
begin
inherited Destroy;
end;

procedure TPDJRotoLabel.SetText3D(AText3D: Boolean);
begin
FText3D:=AText3D;
Invalidate;
end;


function TPDJRotoLabel.GetTransparent: Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

procedure TPDJRotoLabel.SetTransparent(Value: Boolean);
begin
  if Transparent <> Value then
  begin
    if Value then
      ControlStyle := ControlStyle - [csOpaque] else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

procedure TPDJRotoLabel.IntToAngle( const value:integer);
begin
Case value of
0: SetUgao(ag0);
45: SetUgao(ag45);
90: SetUgao(ag90);
135: SetUgao(ag135);
180: SetUgao(ag180);
225: SetUgao(ag225);
270: SetUgao(ag270);
315: SetUgao(ag315);
end;
end;

procedure TPDJRotoLabel.SetUgao(value:TUgao);
begin
if value<>FUgao then
begin
FUgao:=value;
Case FUgao of
  ag0: FZaokretanje:=0;
 ag45: FZaokretanje:=450;
 ag90: FZaokretanje:=900;
ag135: FZaokretanje:=1350;
ag180: FZaokretanje:=1800;
ag225: FZaokretanje:=2250;
ag270: FZaokretanje:=2700;
ag315: FZaokretanje:=3150;
end;
Invalidate;
end;
end;

procedure TPDJRotoLabel.Paint;
begin
Krecenje;
DrawCaption;
end;


procedure TPDJRotoLabel.Krecenje;
begin
if transparent then exit;
with canvas do
begin
brush.color:=color;
fillrect(clientrect);
end;
end;


procedure TPDJRotoLabel.DrawCaption;
var
  lf : TLogFont;
begin
  with Canvas do begin
    Font.Assign(Self.Font);
    Krec:=Font.Color;
    tf := TFont.Create;
    brush.style:=bsclear;
    try
      tf.Assign(Font);
      GetObject(tf.Handle, sizeof(lf), @lf);
      lf.lfEscapement := FZaokretanje;
      lf.lfOrientation := FZaokretanje;
      tf.Handle := CreateFontIndirect(lf);
      Font.Assign(tf);
    finally
    
    end;
    if (Enabled) and (FText3D) then DrawCaption3D;
    if not Enabled then DrawCaptionEnabled;
    Case FZaokretanje of
    0:   TextOut((Width-TextWidth(Caption))div 2,(Height-TextHeight(Caption))div 2, caption);
    450: TextOut(TextHeight(Caption) div 3,Height-TextHeight(Caption), caption);
    900: TextOut((Width-TextHeight(Caption)) div 2,Height-(Height-TextWidth(Caption))div 2, caption);
    1350:TextOut(Width-TextHeight(Caption),Height-TextHeight(Caption) div 3, caption);
    1800:TextOut(Width-((Width-TextWidth(Caption))div 2),((Height-TextHeight(Caption))div 2)+TextHeight(Caption), caption);
    2250:TextOut(Width-TextHeight(Caption) div 3,TextHeight(Caption), caption);
    2700:TextOut(((Width-TextHeight(Caption))div 2)+TextHeight(Caption),(Height-Textwidth(Caption))div 2, caption);
    3150:TextOut(TextHeight(Caption),TextHeight(Caption) div 3, caption);
    end;

    //vazi za okretanje od 0-360 stepeni
   {    if (FZaokretanje >=0) and (FZaokretanje <=899) then
    TextOut(0,Height-TextHeight(Caption), caption);
    if (FZaokretanje >=901) and (FZaokretanje <=1799) then
    TextOut(Width-TextHeight(Caption),Height-TextHeight(Caption) div 3, caption);
    if (FZaokretanje >=1800) and (FZaokretanje <=2699) then
    TextOut(Width,TextHeight(Caption), caption);
    if (FZaokretanje >=2700) and (FZaokretanje <=3600) then
    TextOut(TextHeight(Caption),0, caption);  }
  end;
   tf.Free;
end;

procedure TPDJRotoLabel.DrawCaptionEnabled;
begin
with canvas do
  begin
  Font.Assign(tf);
  brush.style:=bsclear;
   font.Color :=clBtnHighlight;
    Case FZaokretanje of
    0:   TextOut(1+(Width-TextWidth(Caption))div 2,1+(Height-TextHeight(Caption))div 2, caption);
    450: TextOut(1+TextHeight(Caption) div 3,1+Height-TextHeight(Caption), caption);
    900: TextOut(1+(Width-TextHeight(Caption)) div 2,1+Height-(Height-TextWidth(Caption))div 2, caption);
    1350:TextOut(1+Width-TextHeight(Caption),1+Height-TextHeight(Caption) div 3, caption);
    1800:TextOut(1+Width-((Width-TextWidth(Caption))div 2),1+((Height-TextHeight(Caption))div 2)+TextHeight(Caption), caption);
    2250:TextOut(1+Width-TextHeight(Caption) div 3,1+TextHeight(Caption), caption);
    2700:TextOut(1+((Width-TextHeight(Caption))div 2)+TextHeight(Caption),1+(Height-Textwidth(Caption))div 2, caption);
    3150:TextOut(1+TextHeight(Caption),1+TextHeight(Caption) div 3, caption);
    end;

  font.color :=clBtnShadow;
  end;
end;

procedure TPDJRotoLabel.DrawCaption3D;
begin
with canvas do
  begin
  Font.Assign(tf);
  brush.style:=bsclear;
   font.Color :=clBtnHighlight;
    Case FZaokretanje of
    0:   TextOut(((Width-TextWidth(Caption))div 2)-1,((Height-TextHeight(Caption))div 2)-1, caption);
    450: TextOut((TextHeight(Caption) div 3)-1,(Height-TextHeight(Caption))-1, caption);
    900: TextOut(((Width-TextHeight(Caption)) div 2)-1,(Height-(Height-TextWidth(Caption))div 2)-1, caption);
    1350:TextOut((Width-TextHeight(Caption))-1,(Height-TextHeight(Caption) div 3)-1, caption);
    1800:TextOut((Width-((Width-TextWidth(Caption))div 2))-1,(((Height-TextHeight(Caption))div 2)+TextHeight(Caption))-1, caption);
    2250:TextOut((Width-TextHeight(Caption) div 3)-1,(TextHeight(Caption))-1, caption);
    2700:TextOut((((Width-TextHeight(Caption))div 2)+TextHeight(Caption))-1,((Height-Textwidth(Caption))div 2)-1, caption);
    3150:TextOut((TextHeight(Caption))-1,(TextHeight(Caption) div 3)-1, caption);
    end;

  font.color :=Krec;
  end;
end;

procedure TPDJRotoLabel.CMMouseEnter(var AMsg: TMessage);
begin
if Assigned(FOnMouseOver) then FOnMouseOver(Self);
end;

procedure TPDJRotoLabel.CMMouseLeave(var AMsg: TMessage);
begin
if Assigned(FOnMouseOut) then FOnMouseOut(Self);
end;

procedure TPDJRotoLabel.CmTextChanged(var Message: TWmNoParams);
begin
  inherited;
  Invalidate;
end;

procedure TPDJRotoLabel.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TPDJRotoLabel.CMColorChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TPDJRotoLabel.CmEnabledChanged(var Message: TWmNoParams);
begin
  inherited;
  Invalidate;
end;

procedure TPDJRotoLabel.CmParentColorChanged(var Message: TWMNoParams);
begin
  inherited;
 Invalidate;
end;

procedure TPDJRotoLabel.CmVisibleChanged(var Message: TWmNoParams);
begin
  inherited;
end;

procedure TPDJRotoLabel.CmFontChanged(var Message: TWMNoParams);
begin
  inherited;
  Invalidate;
end;


end.
