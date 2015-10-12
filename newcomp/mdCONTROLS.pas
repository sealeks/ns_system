{
 -----------------------------------------------------------------------------

 MODUL          mdCONTROLS.pas

 COPYRIGHT      micro dynamics GmbH
 AUTHOR(S)      Michael Frank
 UPDATE         30.06.2002

 COMPILER       Delphi 5/6
 PLATFORM       Windows 95/98/Me/NT4/2000/XP

 DESCRIPTION    These components support Windows XP Visual Styles, if
		available.
		They are usable as direct replacements of the original
		Borland Delphi aequivalents.

 -----------------------------------------------------------------------------
 Revision History:   Original Version  01.02

 30.06.2002     Version 2.20
                Registration and design-editor separated into mdCONTROLSREG.pas
                TStatusBar and TToolBar added
 18.06.2002     Version 2.10
 08.06.2002     Version 2.00
 11.01.2002     Version 1.10
 29.12.2001     Version 1.00
 -----------------------------------------------------------------------------
}
unit mdCONTROLS;

//============================================================================

interface

//============================================================================

uses
  Windows, Classes, Controls, CommCtrl, CheckLst, Forms, Graphics, Messages,
  ComCtrls, StdCtrls, SysUtils, ToolWin,
  mdTHEMES;

const
  tagDISABLED = $01000000;

type
{ TXPThemeAPI }

  TXPThemeAPI = class(TComponent)
  public
    constructor Create (AOwner : TComponent); override;
  end;

{ TXPPageControl }

  TXPPageControl = class(TPageControl)
  end;

{ TXPTabSheet }

  TXPTabSheet = class(TTabSheet)
  private
    fBodyTexture : boolean;
    procedure SetBodyTexture (Value : boolean);
    procedure WMEraseBkgnd (var Message : TWMEraseBkgnD); message WM_ERASEBKGND;
  protected
    procedure CreateParams (var Params : TCreateParams); override;
  public
    constructor Create (AOwner : TComponent); override;
    procedure Dispatch (var Message); override;
  published
    property BodyTexture : boolean read fBodyTexture write SetBodyTexture default true;
  end;

{ TXPGroupBox }

  TXPGroupBox = class(TGroupBox)
  private
    procedure CMEnabledChanged (var Message : TMessage); message CM_ENABLEDCHANGED;
    procedure WMEraseBkgnd (var Message : TWMEraseBkgnD); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
  public
    procedure Dispatch (var Message); override;
  end;

{ TXPCheckListBox }

  TXPCheckListBox = class(TCheckListBox)
  private
    function GetItemEnabled (Index : integer) : boolean;
    function GetState (Index : integer) : TCheckBoxState;
    procedure CMEnabledChanged (var Message : TMessage); message CM_ENABLEDCHANGED;
    procedure CMExit (var Message : TCMExit); message CM_EXIT;
    procedure CNDrawItem (var Message : TWMDrawItem); message CN_DRAWITEM;
    procedure DrawItemCheck (Rect : TRect; State : TCheckBoxState; Enabled : boolean);
    procedure DrawItemText (Index : integer; Rect : TRect; State : TOwnerDrawState);
  protected
    procedure DrawItem (Index : integer; Rect : TRect; State : TOwnerDrawState); override;
    procedure KeyPress (var Key : Char); override;
    procedure MouseDown (Button : TMouseButton; Shift : TShiftState; X, Y : integer); override;
    procedure ToggleClickCheck (Index : integer);
  end;

{ TXPListView }

  TXPListView = class(TListView)
  public
    procedure Dispatch (var Message); override;
  end;

{ TXPAnimate }

  TXPAnimate = class(TAnimate)
  private
    procedure WMEraseBkgnd (var Message : TWMEraseBkgnD); message WM_ERASEBKGND;
  end;

{ TXPCheckBox }

  TXPCheckBox = class(TCheckBox)
  private
    procedure WMEraseBkgnd (var Message : TWMEraseBkgnD); message WM_ERASEBKGND;
  end;

{ TXPRadioButton }

  TXPRadioButton = class(TRadioButton)
  private
    procedure WMEraseBkgnd (var Message : TWMEraseBkgnD); message WM_ERASEBKGND;
  end;

{ TXPStatusBar }

  TXPStatusBar = class(TStatusBar)
  private
    procedure WMEraseBkgnd (var Message : TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSize (var Message : TWMSize); message WM_SIZE;
  end;

{ TXPToolBar }

  TXPToolBar = class(TToolBar)
  private
    fActiveButton : TToolButton;
    procedure WMEraseBkgnd (var Message : TWMEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure WndProc (var Message : TMessage); override;
  public
    constructor Create (AOwner : TComponent); override;
  end;

{ TXPTrackBar }

  TXPTrackBar = class(TTrackBar)
  private
    fShowSelRange : boolean;
    procedure SetShowSelRange (Value : boolean);
    procedure WMEraseBkgnd (var Message : TWMEraseBkgnD); message WM_ERASEBKGND;
  public
    constructor Create (AOwner : TComponent); override;
    procedure Dispatch (var Message); override;
  protected
    procedure CreateParams (var Params : TCreateParams); override;
  published
    property ShowSelRange : boolean read fShowSelRange write SetShowSelRange default false;
  end;

//============================================================================

procedure Register;

implementation




//============================================================================

//============================================================================
// class TXPThemeAPI
//============================================================================

//----------------------------------------------------------------------------
constructor TXPThemeAPI.Create (AOwner : TComponent);
//----------------------------------------------------------------------------

var
  i, Instances : integer;

begin
  inherited;

  if not (AOwner is TForm) then
  begin
    MessageBeep(0);
    Abort;
  end;

  i:= 0;
  Instances:= 0;
  while (i < AOwner.ComponentCount) and (Instances < 2) do
  begin
    if (AOwner.Components[i] is TXPThemeAPI) then
      inc(Instances,1);
    inc(i,1);
  end;

  if (Instances > 1) then
  begin
    MessageBeep(0);
    Abort;
  end;
end;

//============================================================================
// class TXPTabSheet
//============================================================================

//----------------------------------------------------------------------------
constructor TXPTabSheet.Create (AOwner : TComponent);
//----------------------------------------------------------------------------

begin
  inherited;
  fBodyTexture:= true;
end;

//----------------------------------------------------------------------------
procedure TXPTabSheet.CreateParams (var Params : TCreateParams);
//----------------------------------------------------------------------------

begin
  inherited;
  Params.Style:= Params.Style and not WS_CLIPCHILDREN;
end;

//----------------------------------------------------------------------------
procedure TXPTabSheet.Dispatch (var Message);
//----------------------------------------------------------------------------

var
  i : integer;
  found, IsAnimate : boolean;

begin
  if UseThemes and
     BodyTexture and
     HandleAllocated and
     not (csDesigning in ComponentState) then
  begin
    with TMessage(Message) do
    begin
      case Msg of
	WM_CTLCOLORBTN,
	WM_CTLCOLOREDIT,
	WM_CTLCOLORSTATIC :
	  begin
            i:= 0;
            found:= false;
            IsAnimate:= false;

            while (i < ControlCount) and not found do
            begin
              if ((Controls[i] is TAnimate) and
                 (TAnimate(Controls[i]).Handle = THandle(LParam))) then
              begin
		IsAnimate:= true;
		found:= true;
              end else

	      if ((Controls[i] is TButtonControl) and
		 (TButtonControl(Controls[i]).Handle = THandle(LParam)))
              or
		 ((Controls[i] is TTrackBar) and
		 (TTrackBar(Controls[i]).Handle = THandle(LParam)))
              then
		found:= true
              else
		inc(i,1);
            end;

            if found and not IsAnimate then
            begin
              DrawThemeParentBackground(LParam, WParam, nil);
              Result:= GetStockObject(NULL_BRUSH);
            end else
              inherited;
	  end;

	WM_PAINT :
	  begin
            i:= 0;
            while (i < ControlCount) do
            begin
              if (Controls[i] is TTrackBar) then
                SendMessage(TTrackBar(Controls[i]).Handle, WM_ENABLE,
		            integer(TTrackBar(Controls[i]).Enabled), 0);
              inc(i,1);
            end;
            inherited;
	  end;
	else
	  inherited;
      end;
    end;
  end else
    inherited;
end;

//----------------------------------------------------------------------------
procedure TXPTabSheet.WMEraseBkgnd (var Message : TWMEraseBkgnd);
//----------------------------------------------------------------------------

const
  MARGIN = 4;

var
  hhTheme : HTHEME;
  DrawRect : TRect;

begin
  hhTheme:= 0;

  if UseThemes and
     BodyTexture and
     not (csDesigning in ComponentState) then
    hhTheme:= OpenThemeData(0,'Tab');

  if (hhTheme <> 0) then
  try
    DrawRect:= ClientRect;
    InflateRect(DrawRect, MARGIN, MARGIN);
    DrawThemeBackground(hhTheme, Message.DC, TABP_PANE, 0, @DrawRect, nil);
  finally
    CloseThemeData(hhTheme);
    Message.Result:= 1;
  end else
    inherited;
end;

//----------------------------------------------------------------------------
procedure TXPTabSheet.SetBodyTexture (Value : boolean);
//----------------------------------------------------------------------------

begin
  if (Value <> fBodyTexture) then
  begin
    fBodyTexture:= Value;

    if (Parent is TPageControl)	then
    begin
      if (TPageControl(Parent).ActivePage = Self) then
      begin
	Hide;
	Show;
      end;
    end else
      RecreateWnd;
  end;
end;

//============================================================================
// class TXPGroupBox
//============================================================================

//----------------------------------------------------------------------------
procedure TXPGroupBox.CMEnabledChanged (var Message : TMessage);
//----------------------------------------------------------------------------

var
  i : integer;

begin
  inherited;
  Invalidate;

  i:= 0;
  while (i < ControlCount) do
  begin
    if (Controls[i] is TWinControl) then
    begin
      if not Enabled then
      begin
	if TWinControl(Controls[i]).Enabled then
	  TWinControl(Controls[i]).Tag:= TWinControl(Controls[i]).Tag or tagDISABLED;

	TWinControl(Controls[i]).Enabled:= false;
      end else
      begin
	if (TWinControl(Controls[i]).Tag and tagDISABLED = tagDISABLED) then
	  TWinControl(Controls[i]).Enabled:= true;
	TWinControl(Controls[i]).Tag:= TWinControl(Controls[i]).Tag and not tagDISABLED;
      end;
    end;
    inc(i,1);
  end;
end;

//----------------------------------------------------------------------------
procedure TXPGroupBox.Dispatch (var Message);
//----------------------------------------------------------------------------

var
  i : integer;
  found, IsAnimate : boolean;

begin
  if UseThemes and
     HandleAllocated and
     not (csDesigning in ComponentState) then
  begin
    with TMessage(Message) do
    begin
      case Msg of
	WM_CTLCOLORBTN,
	WM_CTLCOLOREDIT,
	WM_CTLCOLORSTATIC :
	  begin
	    i:= 0;
	    found:= false;
	    IsAnimate:= false;

	    while (i < ControlCount) and not found do
	    begin
	      if ((Controls[i] is TAnimate) and
		 (TAnimate(Controls[i]).Handle = THandle(LParam))) then
	      begin
		IsAnimate:= true;
		found:= true;
	      end else

              if ((Controls[i] is TButtonControl) and
		 (TButtonControl(Controls[i]).Handle = THandle(LParam)))
	      or
		 ((Controls[i] is TTrackBar) and
		 (TTrackBar(Controls[i]).Handle = THandle(LParam)))
	      then
		found:= true
		  else
		inc(i,1);
	    end;

	    if found and not IsAnimate then
	    begin
	      DrawThemeParentBackground(LParam, WParam, nil);
	      Result:= GetStockObject(NULL_BRUSH);
	    end else
	      inherited;
	  end;

	WM_PAINT :
	  begin
	    i:= 0;
	    while (i < ControlCount) do
	    begin
	      if (Controls[i] is TTrackBar) then
		SendMessage(TTrackBar(Controls[i]).Handle, WM_ENABLE,
		            integer(TTrackBar(Controls[i]).Enabled), 0);
	      inc(i,1);
	    end;
	    inherited;
	  end;
	else
	  inherited;
      end;
    end;
  end else
    inherited;
end;

//----------------------------------------------------------------------------
procedure TXPGroupBox.WMEraseBkgnd (var Message : TWMEraseBkgnd);
//----------------------------------------------------------------------------

begin
  if UseThemes and not (csDesigning in ComponentState) then
  begin
    DrawThemeParentBackground(Handle, Message.DC, nil);
    Message.Result:= 1;
  end else
    inherited;
end;

//----------------------------------------------------------------------------
procedure TXPGroupBox.Paint;
//----------------------------------------------------------------------------

const
  CAPTIONOFFSET = 7;
  CAPTIONMARGIN = 1;

var
  hhTheme : HTHEME;
  i : integer;
  iDrawState, iMargin : integer;
  DrawRect, CaptionRect : TRect;
  DummyRect : TRect;
  Flags : Dword;
  s : WideString;

begin
  hhTheme:= 0;

  with Canvas do
  begin
    Font:= Self.Font;
    i:= TextHeight('0');
    DrawRect:= Rect(0, i div 2, Width, Height);
    Flags:= DrawTextBiDiModeFlags(DT_SINGLELINE);
    if (Text = '') then
      iMargin:= 0
    else
      iMargin:= CAPTIONMARGIN;

    if UseRightToLeftAlignment then
      CaptionRect:= Rect(DrawRect.Right - TextWidth(Text) - CAPTIONOFFSET, 0,
			 DrawRect.Right - CAPTIONOFFSET - 2*iMargin, i)
    else
      CaptionRect:= Rect(DrawRect.Left + CAPTIONOFFSET, 0,
			 DrawRect.Left + TextWidth(Text) + CAPTIONOFFSET + 2*iMargin, i);

    if UseThemes and not (csDesigning in ComponentState) then
      hhTheme:= OpenThemeData(0,'Button');

    if (hhTheme <> 0) then
    try
      if Enabled then
        iDrawState:= GBS_NORMAL
      else
        iDrawState:= GBS_DISABLED;

      s:= WideString(Text);
      GetThemeTextExtent(hhTheme, Handle, BP_GROUPBOX, iDrawState,
                         PWideChar(s), -1, Flags, nil, DummyRect);

      with CaptionRect do
        ExcludeClipRect(Handle, Left, Top, Right, Bottom);

      DrawThemeBackground(hhTheme, Handle, BP_GROUPBOX, iDrawState, @DrawRect, nil);
      SelectClipRgn(Handle, 0);

      DrawThemeText(hhTheme, Handle, BP_GROUPBOX, iDrawState,
		    PWideChar(s), -1, Flags, 0, @CaptionRect);
    finally
      CloseThemeData(hhTheme);
    end else

    begin
      with CaptionRect do
	ExcludeClipRect(Handle, Left, Top, Right, Bottom);
      if Ctl3D then
      begin
        inc(DrawRect.Left, 1);
	inc(DrawRect.Top, 1);
	Brush.Color:= clBtnHighlight;
	FrameRect(DrawRect);
	OffsetRect(DrawRect, -1, -1);
	Brush.Color:= clBtnShadow;
      end else
        Brush.Color:= clWindowFrame;
      FrameRect(DrawRect);
      SelectClipRgn(Handle, 0);

      if (Text <> '') then
      begin
        inc(CaptionRect.Left, iMargin);
	DrawText(Handle, PChar(Text), Length(Text), CaptionRect, Flags or DT_CALCRECT);
	SetBKMode(Handle, Windows.TRANSPARENT);

	if not Enabled then
	begin
	  OffsetRect(CaptionRect, 1, 1);
	  Font.Color:= clBtnHighlight;
	  DrawText(Handle, PChar(Text), Length(Text), CaptionRect, Flags);
	  OffsetRect(CaptionRect, -1, -1);
	  Font.Color:= clBtnShadow;
	end;
	DrawText(Handle, PChar(Text), Length(Text), CaptionRect, Flags);
      end;
    end;
  end;
end;

//============================================================================
// class TXPCheckListBox
//============================================================================

//----------------------------------------------------------------------------
function TXPCheckListBox.GetState (Index : integer) : TCheckBoxState;
//----------------------------------------------------------------------------

begin
  Result:= State[Index];
end;

//----------------------------------------------------------------------------
function TXPCheckListBox.GetItemEnabled (Index : integer) : boolean;
//----------------------------------------------------------------------------

begin
  Result:= ItemEnabled[Index];
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.CMEnabledChanged (var Message : TMessage);
//----------------------------------------------------------------------------

begin
  if not Enabled then
    ItemIndex:= -1;
  inherited;
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.CMExit (var Message : TCMExit);
//----------------------------------------------------------------------------

begin
  inherited;
  ItemIndex:= -1;
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.CNDrawItem (var Message : TWMDrawItem);
//----------------------------------------------------------------------------

begin
  with Message.DrawItemStruct^ do
  begin
    if UseRightToLeftAlignment then
      dec(rcItem.Right, 1)
    else
      inc(rcItem.Left, 1);
  end;
  inherited;
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.DrawItem (Index : integer; Rect : TRect;
                                    State : TOwnerDrawState);
//----------------------------------------------------------------------------

var
  fEnable : boolean;

begin
  if (Index < Items.Count) then
  begin
    { Force lbStandard list to ignore OnDrawItem event. }
    if (Style <> lbStandard) and Assigned(OnDrawItem) then
    begin
      OnDrawItem(Self, Index, Rect, State);
    end else
    begin
      fEnable:= Self.Enabled and GetItemEnabled(Index);
      DrawItemCheck(Rect, GetState(Index), fEnable);
      if not fEnable then
	Canvas.Font.Color:= clGrayText;
      DrawItemText(Index, Rect, State);
    end;
  end;
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.DrawItemText (Index : integer; Rect : TRect;
                                        State : TOwnerDrawState);
//----------------------------------------------------------------------------

const
  MARGIN = 2;

var
  Flags : Dword;

begin
  Canvas.FillRect(Rect);
  Flags:= DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
  if not UseRightToLeftAlignment then
    inc(Rect.Left, MARGIN)
  else
    dec(Rect.Right, MARGIN);
  DrawText(Canvas.Handle, PChar(Items[Index]), Length(Items[Index]), Rect, Flags);
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.DrawItemCheck (Rect : TRect; State : TCheckBoxState;
                                         Enabled : boolean);
//----------------------------------------------------------------------------

var
  hhTheme : HTHEME;
  iCheckWidth : integer;
  iDrawState : integer;

begin
  hhTheme:= 0;

  iCheckWidth:= GetCheckWidth;

  if UseRightToLeftAlignment then
  begin
    Rect.Left:= Rect.Right;
    Rect.Right:= Rect.Left + iCheckWidth;
  end else
  begin
    Rect.Right:= Rect.Left;
    Rect.Left:= Rect.Right - iCheckWidth;
  end;

  dec(iCheckWidth, 2);
  Rect.Left := Rect.Left + (Rect.Right - Rect.Left - iCheckWidth) div 2;
  Rect.Top := Rect.Top + (Rect.Bottom - Rect.Top - iCheckWidth) div 2;
  Rect.Right:= Rect.Left + iCheckWidth;
  Rect.Bottom:= Rect.Top + iCheckWidth;

  if UseThemes and not (csDesigning in ComponentState) then
    hhTheme:= OpenThemeData(0,'Button');

  if (hhTheme <> 0) then
  begin
    case State of
      cbChecked :
	if Enabled then
	  iDrawState:= CBS_CHECKEDNORMAL
        else
	  iDrawState:= CBS_CHECKEDDISABLED;

      cbUnchecked :
        if Enabled then
          iDrawState:= CBS_UNCHECKEDNORMAL
	else
	  iDrawState:= CBS_UNCHECKEDDISABLED;

      else // cbGrayed
        if Enabled then
	  iDrawState:= CBS_MIXEDNORMAL
	else
	  iDrawState:= CBS_MIXEDDISABLED;
    end;

    try
      DrawThemeBackground(hhTheme, Canvas.Handle, BP_CHECKBOX, iDrawState, @Rect, nil);
    finally
      CloseThemeData(hhTheme);
    end;
  end else

  begin
    case State of
      cbChecked :
	iDrawState:= DFCS_BUTTONCHECK or DFCS_CHECKED;

      cbUnchecked :
	iDrawState:= DFCS_BUTTONCHECK;

      else // cbGrayed
        iDrawState:= DFCS_BUTTON3STATE or DFCS_CHECKED;
    end;

    if not Enabled then
      iDrawState:= iDrawState or DFCS_INACTIVE;

    if Flat then
       iDrawState:= iDrawState or DFCS_FLAT;

    DrawFrameControl(Canvas.Handle, Rect, DFC_BUTTON, iDrawState);
  end;
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.KeyPress (var Key : Char);
//----------------------------------------------------------------------------

begin
  if (Key = ' ') then
    ToggleClickCheck(ItemIndex)
  else
    inherited;
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.MouseDown (Button : TMouseButton; Shift : TShiftState;
                                     X, Y : integer);
//----------------------------------------------------------------------------

var
  Index : integer;

begin
  inherited;
  if (Button = mbLeft) then
  begin
    Index:= ItemAtPos(Point(X,Y), true);
    if (Index <> -1) and GetItemEnabled(Index) then
    begin
      if UseRightToLeftAlignment then
      begin
	Dec(X, ItemRect(Index).Right - GetCheckWidth);
	if not ((X > 0) and (X < GetCheckWidth)) then
	  ToggleClickCheck(Index);
      end else
      begin
	if not (X - ItemRect(Index).Left < GetCheckWidth) then
	  ToggleClickCheck(Index);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------
procedure TXPCheckListBox.ToggleClickCheck;
//----------------------------------------------------------------------------

var
  State : TCheckBoxState;

begin
  if (Index >= 0) and (Index < Items.Count) and GetItemEnabled(Index) then
  begin
    State:= Self.State[Index];
    case State of
      cbUnchecked :
	if AllowGrayed then
	  State:= cbGrayed
        else
	  State:= cbChecked;

      cbChecked :
	State:= cbUnchecked;

      cbGrayed :
	State:= cbChecked;
    end;
    Self.State[Index]:= State;
    ClickCheck;
  end;
end;

//============================================================================
// class TXPListView
//============================================================================

//----------------------------------------------------------------------------
procedure TXPListView.Dispatch (var Message);
//----------------------------------------------------------------------------

begin
  if HandleAllocated then
  begin
    with TMessage(Message) do
    begin
      case Msg of
	LVM_SETCOLUMN,
	LVM_INSERTCOLUMN :
          with PLVColumn(LParam)^ do
          begin
	    if (iImage = -1) then
              mask:= mask and not LVCF_IMAGE;
	  end;
	WM_THEMECHANGED :
	  begin
	    RecreateWnd;
	  end;
      end;
    end;
  end;
  inherited;
end;

//============================================================================
// class TXPAnimate
//============================================================================

//----------------------------------------------------------------------------
procedure TXPAnimate.WMEraseBkgnd (var Message : TWMEraseBkgnd);
//----------------------------------------------------------------------------

begin
  if UseThemes and not (csDesigning in ComponentState) then
  begin
    Message.Result:= 1;
  end else
    inherited;
end;

//============================================================================
// class TXPCheckBox
//============================================================================

//----------------------------------------------------------------------------
procedure TXPCheckBox.WMEraseBkgnd (var Message : TWMEraseBkgnd);
//----------------------------------------------------------------------------

begin
  if UseThemes and not (csDesigning in ComponentState) then
  begin
    Message.Result:= 1;
  end else
    inherited;
end;

//============================================================================
// class TXPRadioButton
//============================================================================

//----------------------------------------------------------------------------
procedure TXPRadioButton.WMEraseBkgnd (var Message : TWMEraseBkgnd);
//----------------------------------------------------------------------------

begin
  if UseThemes and not (csDesigning in ComponentState) then
  begin
    Message.Result:= 1;
  end else
    inherited;
end;

//============================================================================
// class TXPStatusBar
//============================================================================

//----------------------------------------------------------------------------
procedure TXPStatusBar.WMEraseBkgnd (var Message : TWMEraseBkgnd);
//----------------------------------------------------------------------------

var
  hhTheme : HTHEME;
  DrawRect : TRect;

begin
  hhTheme:= 0;

  if UseThemes and not (csDesigning in ComponentState) then
    hhTheme:= OpenThemeData(0,'Status');

  if (hhTheme <> 0) then
  try
    DrawRect:= ClientRect;
    DrawThemeBackground(hhTheme, Message.DC, 0, 0, @DrawRect, nil);
  finally
    CloseThemeData(hhTheme);
    Message.Result:= 1;
  end else
    inherited;
end;

//----------------------------------------------------------------------------
procedure TXPStatusBar.WMSize (var Message : TWMSize);
//----------------------------------------------------------------------------

begin
  inherited;
  Invalidate;
end;

//============================================================================
// class TXPToolBar
//============================================================================

//----------------------------------------------------------------------------
constructor TXPToolBar.Create (AOwner : TComponent);
//----------------------------------------------------------------------------

begin
  inherited;
  fActiveButton:= nil;

  Flat:= true;
  Transparent:= true;
end;

//----------------------------------------------------------------------------
procedure TXPToolBar.WMEraseBkgnd (var Message : TWMEraseBkgnd);
//----------------------------------------------------------------------------

const
  BORDERMARGIN = 2;

var
  i, iButtonHeight : integer;
  found : boolean;

begin
  if AutoSize and
     (Parent <> nil) then
  begin
    if (Parent is TCoolBar) then
    begin
      iButtonHeight:= ButtonHeight + 2*BorderWidth;
      if (ebTop in EdgeBorders) then
        inc(iButtonHeight,BORDERMARGIN);
      if (ebBottom in EdgeBorders) then
        inc(iButtonHeight,BORDERMARGIN);
      if not Flat then
        inc(iButtonHeight,2*BORDERMARGIN);

      i:= 0;
      found:= false;
      with TCoolBar(Parent) do
      begin
        while (i < Bands.Count) and not found do
        begin
          if (Bands[i].Control = Self) then
          begin
            if (Bands[i].MinHeight <> iButtonHeight) then
              Bands[i].MinHeight:= iButtonHeight;
            found:= true;
          end;
          inc(i,1);
        end;
      end;
    end;
  end;

  inherited;
end;

//----------------------------------------------------------------------------
procedure TXPToolBar.WndProc (var Message : TMessage);
//----------------------------------------------------------------------------

var
  AControl : TControl;
  MaxXPos : integer;

//----------------------------------------------------------------------------
  function IsToolButtonMessage : boolean;
  begin
    AControl:= ControlAtPos(SmallPointToPoint(TWMMouse(Message).Pos), false);
    Result:= (AControl <> nil) and (AControl is TToolButton) and not AControl.Dragging;
  end;
//----------------------------------------------------------------------------

begin
  if not (csDesigning in ComponentState) then
  begin
    case TMessage(Message).Msg of

      WM_LBUTTONUP :
        if IsToolButtonMessage then
        begin
          DefaultHandler(Message);
          if (TToolButton(AControl) = fActiveButton) then
          with TToolButton(AControl) do
          begin
            if (Style = tbsCheck) and Grouped and AllowAllUp then
              Down:= not Down;
            Click;
          end;
        end else
          inherited;

      WM_LBUTTONDOWN,
      WM_LBUTTONDBLCLK :
        if IsToolButtonMessage then
        begin
          DefaultHandler(Message);
          with TToolButton(AControl) do
          begin
            MaxXPos:= Left + ButtonWidth;
            if (Style <> tbsDropDown) or
               ((GetComCtlVersion >= ComCtlVersionIE4) and
               (TWMMouse(Message).XPos < MaxXPos)) then
              fActiveButton:= TToolButton(AControl)
            else
              fActiveButton:= nil;
          end;
        end else
          inherited;

      else
        inherited;

    end;
  end else
    inherited;
end;

//============================================================================
// class TXPTrackBar
//============================================================================

//----------------------------------------------------------------------------
constructor TXPTrackBar.Create (AOwner : TComponent);
//----------------------------------------------------------------------------

begin
  inherited;
  fShowSelRange:= false;
end;

//----------------------------------------------------------------------------
procedure TXPTrackBar.CreateParams (var Params : TCreateParams);
//----------------------------------------------------------------------------

begin
  inherited;
  if not fShowSelRange then
    Params.Style:= Params.Style and not TBS_ENABLESELRANGE;
end;

//----------------------------------------------------------------------------
procedure TXPTrackBar.Dispatch (var Message);
//----------------------------------------------------------------------------

begin
  if HandleAllocated then
  begin
    with TMessage(Message) do
    begin
      case Msg of
	WM_THEMECHANGED :
	  begin
	    Sleep(1000);
	    RecreateWnd;
	  end;
      end;
    end;
  end;
  inherited;
end;

//----------------------------------------------------------------------------
procedure TXPTrackBar.WMEraseBkgnd (var Message : TWMEraseBkgnd);
//----------------------------------------------------------------------------

begin
  if UseThemes and not (csDesigning in ComponentState) then
  begin
    Message.Result:= 1;
  end else
    inherited;
end;

//----------------------------------------------------------------------------
procedure TXPTrackBar.SetShowSelRange (Value : boolean);
//----------------------------------------------------------------------------

begin
  if (Value <> fShowSelRange) then
  begin
    fShowSelRange:= Value;
    RecreateWnd;
  end;
end;

//============================================================================
procedure Register;
begin
  RegisterComponents('XPControls', [TXPThemeAPI, TXPPageControl, TXPGroupBox,
    TXPCheckListBox, TXPListView, TXPCheckBox, TXPRadioButton, TXPTrackBar,
    TXPAnimate, TXPStatusBar, TXPToolBar]);

  RegisterNoIcon([TXPTabSheet]);
  RegisterClasses([TXPTabSheet]);

end;


end.


