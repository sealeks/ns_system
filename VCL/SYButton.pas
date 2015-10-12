unit SYButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TMode = (Down,Up);
  TTextStyle = (tsLowered,tsRaised);
  TSYButton = class(TCustomControl)
  private
    { Private declarations }
    FColor       :TColor;
    FTextStyle   :TTextStyle;
    FModalResult :TModalResult;
    FOnClick     :TNotifyEvent;
    Function  DeltaColor (Color:TColor;Delta:Integer):TColor;
    Procedure Line (x1,y1,x2,y2:Integer;LineColor:TColor);
    Procedure DotLine (x1,y1:Integer;Dir:Boolean;Len:Integer;LineColor:TColor);
    Procedure Paint; override;
    procedure SetColor(const Value: TColor);
    procedure SetTextStyle(const Value: TTextStyle);
  protected
    { Protected declarations }
    Procedure CMMouseLeave (Var Message:TMessage); message CM_MOUSELEAVE;
    Procedure CMMouseEnter (Var Message:TMessage); message CM_MOUSEENTER;
    Procedure CMFontChanged (Var Message:TMessage); message CM_FONTCHANGED;
    Procedure WMLButtonDown (Var Message:TMessage); message WM_LBUTTONDOWN;
    Procedure WMLButtonUp (Var Message:TMessage); message WM_LBUTTONUP;
    Procedure CMTextChanged (var Message:TMessage); message CM_TEXTCHANGED;
    Procedure WMSetFocus (var Message:TMessage); message WM_SETFOCUS;
    Procedure WMKillFocus (var Message:TMessage); message WM_KILLFOCUS;
    Procedure WMChar (var Message:TWMChar); message WM_CHAR;
    Procedure WMEnable (var Message:TMessage); message WM_ENABLE;
  public
    { Public declarations }
    Mode,ButtonMode :TMode;
    SYFocused :Boolean;
    Constructor Create (AOwner:TComponent); override;
    Procedure SYClick;
  published
    { Published declarations }
    Property Color :TColor read FColor write SetColor;
    Property Caption;
    Property Enabled;
    Property Font;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    Property TextStyle :TTextStyle read FTextStyle write SetTextStyle;
    Property TabStop;
    Property TabOrder;
    Property OnClick :TNotifyEvent read FOnClick write FOnClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  // RegisterComponents('Additional', [TSyButton]);
end;

Constructor TSYButton.Create (AOwner:TComponent);
Begin
  Inherited Create (AOwner);
  Mode:=Up;
  ButtonMode:=Up;
  Width:=80; Height:=25;
  FColor:=$A0A0A0;
  Enabled:=True;
  FTextStyle:=tsLowered;
  TabStop:=True;
  ControlStyle:=[csSetCaption,csCaptureMouse];
End;

procedure TSYButton.SetColor(const Value: TColor);
begin
  FColor:=Value;
  Paint;
end;

procedure TSYButton.SetTextStyle(const Value: TTextStyle);
begin
  FTextStyle:=Value;
  Paint;
end;

Procedure TSYButton.CMFontChanged (Var Message:TMessage);
Begin
  Inherited;
  Canvas.Font.Assign (Font);
  Paint;
End;

Procedure TSYButton.CMMouseLeave (Var Message:TMessage);
Begin
  Inherited;
  If Mode=Down then
  Begin
    Mode:=Up;
    Paint;
  End;
End;

Procedure TSYButton.CMMouseEnter (Var Message:TMessage);
Begin
  Inherited;
  If (Mode=Up) and (ButtonMode=Down) then
  Begin
    Mode:=Down;
    Paint;
  End;
End;

Procedure TSYButton.WMLButtonDown (Var Message:TMessage);
Begin
  Inherited;
  If Enabled then
  Begin
    Mode:=Down;
    ButtonMode:=Down;
    if parent.Visible then SetFocus;
    Paint;
  End;
End;

Procedure TSYButton.WMLButtonUp (Var Message:TMessage);
Begin
  Inherited;
  ButtonMode:=Up;
  If Mode=Down then
  Begin
    Mode:=Up;
    Paint;
    SYClick;
  End;
End;

Procedure TSYButton.CMTextChanged (var Message:TMessage);
Begin
  Inherited;
  Paint;
End;

Procedure TSYButton.WMSetFocus (var Message:TMessage);
Begin
  Inherited;
  SYFocused:=True;
  Paint;
End;

Procedure TSYButton.WMKillFocus (var Message:TMessage);
Begin
  Inherited;
  SYFocused:=False;
  Paint;
End;

Procedure TSYButton.WMChar (var Message: TWMChar);
Begin
  If Chr (Message.CharCode)=#13 then
  Begin
    If (Mode=Up) and (ButtonMode=Up) then SYClick;
  End else inherited;
End;

Procedure TSYButton.WMEnable (var Message:TMessage);
Begin
  Inherited;
  Paint;
End;

Procedure TSYButton.SYClick;
Var       Form :TCustomForm;
Begin
  If Enabled then
  Begin
    //Сначала вызываем обработчик пользователя
    If Assigned (FOnClick) then FOnClick (Self);
    //Затем проверяем ModalResult
    Form:=GetParentForm (Self);
    If (Form<>nil) and (ModalResult<>mrNone) then Form.ModalResult:=ModalResult;
  End;
End;

Function TSYButton.DeltaColor (Color:TColor;Delta:Integer):TColor;
Var      Max,R,G,B :SmallInt;
Begin
  R:=Color and $FF; Max:=R;
  G:=(Color shr 8) and $FF; If G>Max then Max:=G;
  B:=(Color shr 16) and $FF; If B>Max then Max:=B;
  R:=R+Round (R/Max*Delta); If R>255 then R:=255 else If R<0 then R:=0;
  G:=G+Round (G/Max*Delta); If G>255 then G:=255 else If G<0 then G:=0;
  B:=B+Round (B/Max*Delta); If B>255 then B:=255 else If B<0 then B:=0;
  Result:=R+G*256+B*65536;
End;

Procedure TSYButton.Line (x1,y1,x2,y2:Integer;LineColor:TColor);
Begin
  With Canvas do
  Begin
    Pen.Color:=LineColor;
    MoveTo (x1,y1); LineTo (x2,y2);
  End;
End;

Procedure TSYButton.DotLine (x1,y1:Integer;Dir:Boolean;Len:Integer;LineColor:TColor);
Var       i :Integer;
Begin
  If Dir then Begin For i:=1 to Len do If Odd (i) then Canvas.Pixels [x1+i-1,y1]:=LineColor; End
         else Begin For i:=1 to Len do If Odd (i) then Canvas.Pixels [x1,y1+i-1]:=LineColor; End;
End;

{Function TSYButton.Gradation (Color:Tcolor):Byte;
Var      R,G,B :SmallInt;
Begin
  R:=Color and $FF;
  G:=(Color shr 8) and $FF;
  B:=(Color shr 16) and $FF;
  Result:=Round (R*0.297+G*0.584+B*0.119);
End;}

Procedure TSYButton.Paint;
Var       Max,MaxTop,MaxBottom,R,G,B :SmallInt;
          x1,y1                      :Integer;
          TextColor                  :TColor;
          Form                       :TCustomForm;
begin
  Form:=GetParentForm (Self);
  If Form<>nil then
  Begin
    If Mode=Up then
    Begin
      TextColor:=Font.Color;
      R:=Color and $FF; Max:=R;
      G:=(Color shr 8) and $FF; If G>Max then Max:=G;
      B:=(Color shr 16) and $FF; If B>Max then Max:=B;
      If Max+70>255 then MaxTop:=255-Max else MaxTop:=70;
      If Max-70<0 then MaxBottom:=-Max else MaxBottom:=-70;
      With Canvas do
      Begin
        Brush.Color:=Color; Pen.Color:=$3C3C3C;
        Rectangle (0,0,Width,Height);
        Line (0,0,Width,0,DeltaColor (Color,MaxBottom div 2));
        Line (0,0,0,Height,DeltaColor (Color,MaxBottom div 2));
        Line (1,1,Width-2,1,DeltaColor (Color,MaxTop));
        Line (1,1,1,Height-2,DeltaColor (Color,MaxTop));
        Line (2,2,Width-3,2,DeltaColor (Color,MaxTop div 2));
        Line (2,2,2,Height-3,DeltaColor (Color,MaxTop div 2));
        Line (3,Height-3,Width-3,Height-3,DeltaColor (Color,MaxBottom div 2));
        Line (Width-3,3,Width-3,Height-2,DeltaColor (Color,MaxBottom div 2));
        Line (2,Height-2,Width-2,Height-2,DeltaColor (Color,MaxBottom));
        Line (Width-2,2,Width-2,Height-1,DeltaColor (Color,MaxBottom));
        x1:=(Width-TextWidth (Caption)) div 2; y1:=(Height-TextHeight (Caption)) div 2;
        If SYFocused then
        Begin
          DotLine (4,4,True,Width-8,TextColor);
          DotLine (4,4,False,Height-8,TextColor);
          DotLine (Width-5,4,False,Height-8,TextColor);
          DotLine (4,Height-5,True,Width-8,TextColor);
        End;
        Brush.Style:=bsClear;
        If Enabled then
        Begin
          If TextStyle=tsLowered
           then Begin If Max+40>255 then MaxTop:=255-Max else MaxTop:=40; End
           else Begin If Max-100<0 then MaxTop:=-Max else MaxTop:=-100; End;
          Font.Color:=DeltaColor (Color,MaxTop); TextOut (x1+1,y1+1,Caption);
          Font.Color:=TextColor; TextOut (x1,y1,Caption);
        End
        else Begin
               If Max+40>255 then MaxTop:=255-Max else MaxTop:=40;
               Font.Color:=DeltaColor (Color,MaxTop); TextOut (x1+1,y1+1,Caption);
               If Max-50<0 then MaxBottom:=-Max else MaxBottom:=-50;
               Font.Color:=DeltaColor (Color,MaxBottom); TextOut (x1,y1,Caption);
             End;
      End;
    End else Begin
               TextColor:=Font.Color;
               R:=Color and $FF; Max:=R;
               G:=(Color shr 8) and $FF; If G>Max then Max:=G;
               B:=(Color shr 16) and $FF; If B>Max then Max:=B;
               If Max-40<0 then MaxBottom:=-Max else MaxBottom:=-40;
               With Canvas do
               Begin
                 Brush.Color:=Color; Pen.Color:=$3C3C3C;
                 Rectangle (0,0,Width,Height);
                 Line (1,1,Width-1,1,DeltaColor (Color,MaxBottom));
                 Line (1,1,1,Height-1,DeltaColor (Color,MaxBottom));
                 Line (2,2,Width-2,2,DeltaColor (Color,MaxBottom div 2));
                 Line (2,2,2,Height-2,DeltaColor (Color,MaxBottom div 2));
                 Line (2,Height-2,Width-2,Height-2,DeltaColor (Color,MaxBottom div 2));
                 Line (Width-2,2,Width-2,Height-1,DeltaColor (Color,MaxBottom div 2));
                 x1:=(Width-TextWidth (Caption)) div 2+1; y1:=(Height-TextHeight (Caption)) div 2+1;
                 If SYFocused then
                 Begin
                   DotLine (5,5,True,Width-8,TextColor);
                   DotLine (5,5,False,Height-8,TextColor);
                   DotLine (Width-4,5,False,Height-8,TextColor);
                   DotLine (5,Height-4,True,Width-8,TextColor);
                 End;
                 Brush.Style:=bsClear;
                 If TextStyle=tsLowered
                  then Begin If Max+40>255 then MaxTop:=255-Max else MaxTop:=40; End
                  else Begin If Max-100<0 then MaxTop:=-Max else MaxTop:=-100; End;
                 Font.Color:=DeltaColor (Color,MaxTop); TextOut (x1+1,y1+1,Caption);
                 Font.Color:=TextColor; TextOut (x1,y1,Caption);
               End;
             End;
  End;
End;

end.
