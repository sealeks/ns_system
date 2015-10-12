
{*******************************************************************}
{                                                                   }
{   dxCore (Design eXperience)                                      }
{                                                                   }
{   Copyright (c) 2002 APRIORI business solutions AG                }
{   (W)ritten by M. Hoffmann - ALL RIGHTS RESERVED.                 }
{                                                                   }
{   DEVELOPER NOTES:                                                }
{   ==========================================================      }
{   This file is part of a component suite called Design            }
{   eXperience and may be used in freeware- or commercial           }
{   applications. The package itself is distributed as              }
{   freeware with full sourcecodes.                                 }
{                                                                   }
{   Feel free to fix bugs or include new features if you are        }
{   familiar with component programming. If so, please email        }
{   me your modifications, so it will be possible for me to         }
{   include nice improvements in further releases:                  }
{                                                                   }
{   Contact: mhoffmann@apriori.de                                   }
{                                                                   }
{   History:                                                        }
{   =============================================================== }
{   2002/06/22                                                      }
{     + Added "TdxStyleManager" (beta)                              }
{                                                                   }
{   2002/06/21                                                      }
{     + Moved Hook Methods to the Public Section                    }
{       (They are now accessable from the main app.)                }
{                                                                   }
{   2002/05/10                                                      }
{     * Fixed hook behaviours                                       }
{     + Added more source comments                                  }
{     + Replaced windows messages and redesigned drawstate          }
{                                                                   }
{   2002/05/02                                                      }
{     + Added some core methods (should be optimized in the future. }
{     + Replaced calling params with const attribute                }
{     * Minor Changes                                               }
{                                                                   }
{   2002/04/30                                                      }
{     * Minor Changes                                               }
{                                                                   }
{   2002/04/29                                                      }
{     * Fixed CMDialogChar                                          }
{       (Thanks to Saeed Dudhia                                     }
{                                                                   }
{   Release                                                         }
{     * Minor Bugfixes                                              }
{     * Fixed OnClick method                                        }
{     + Added Version property                                      }
{     + Added support for earlier Delphi Versions                   }
{       (Thanks to Flavio Peinado)                                  }
{     + Replaced OwnerDrawState with internal Structure             }
{     + First Release                                               }
{                                                                   }
{*******************************************************************}

unit dxCore;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, ActnList, Dialogs;

const
  //
  // color constants.
  //
  // These constants are used as default colors for descendant controls
  // and may be replaced with other (common) values. Some colors are used
  // for gradient fades and are postfixed with xxFrom and xxTo.
  //
  dxColor_BgFrom      = $00FFFFFF; // background from
  dxColor_BgTo        = $00E7EBEF; // background to
  dxColor_BorderEdges = clSilver;  // border edges
  dxColor_BorderLine  = clGray;    // border line
  dxColor_CkFrom      = $00C6CFD6; // clicked from
  dxColor_CkTo        = $00EBF3F7; // clicked to
  dxColor_FcFrom      = $00FFE7CE; // focused from
  dxColor_FcTo        = $00EF846D; // focused to
  dxColor_HlFrom      = $00CEF3FF; // highlight from
  dxColor_HlTo        = $000096E7; // highlight to
  dxColor_HotTrack    = $000000FF; // hot-track
  //dxColor_DotNetFrame = $00E7EBEF; // .NET border frame

type
{ Common Structures }

  // TdxBoundLines
  TdxBoundLines = set of (blLeft, blTop, blRight, blBottom);

  // TdxColorSteps
  TdxColorSteps = 2..255;

  // TdxTheme
  TdxTheme = (WindowsXP, OfficeXP);

  // TdxCustomControl (forward declaration)
  TdxCustomControl = class;

  // TdxDrawState
  //     dsDefault    = used for initialize state
  //     dsHighlight  = control is hovered
  //     dsFocused    = control is focused
  //     dsClicked    = control is clicked
  TdxDrawState = set of (dsDefault, dsHighlight, dsFocused, dsClicked);

  // TdxGradientStyle
  TdxGradientStyle = (gsLeft, gsTop, gsRight, gsBottom);

{ TdxWinControl }

  TdxWinControl = class(TWinControl)
  published
    { Published declarations }
    property Color;
  end;

{ TdxCustomComponent

  baseclass for non-focusable component descendants. }

  TdxCustomComponent = class(TComponent)
  private
    { Private desclarations }
    FAbout: string;
    procedure SetAbout(Value: string);
    procedure SetVersion(Value: string);
  protected
    { Protected desclarations }
    function GetVersion: string; virtual;
  public
    { Public desclarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published desclarations }
    property About: string read FAbout write SetAbout;
    property Version: string read GetVersion write SetVersion;
  end;

{ TdxStyleManager }

  TdxStyleManager = class(TdxCustomComponent)
  private
    { Private desclarations }
    FControls: TList;
    FTheme: TdxTheme;
    procedure InvalidateControls;
  protected
    { Protected desclarations }
    function GetVersion: string; override;
    procedure SetTheme(Value: TdxTheme); virtual;
  public
    { Public desclarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterControl(const AControl: TdxCustomControl);
    procedure UnregisterControl(const AControl: TdxCustomControl);
  published
    { Published desclarations }
    property Theme: TdxTheme read FTheme write SetTheme default WindowsXP;
  end;

{ TdxCustomControl

  baseclass for focusable control descendants. }

  TdxCustomControl = class(TCustomControl)
  private
    { Private desclarations }
    FAbout: string;
    FClicking: Boolean;
    FDrawState: TdxDrawState;
    FIsLocked: Boolean;
    FIsSibling: Boolean;
    FModalResult: TModalResult;
    FStyleManager: TdxStyleManager;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure SetAbout(Value: string);
    procedure SetVersion(Value: string);

    //
    // The following Messages are catched and deligated to Hook-Methods,
    // which are easier to overwrite in descendant classes.
    //

    // HookEnabledChanged
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;

    // HookFocusedChanged
    procedure CMFocusChanged(var Message: TMessage); message CM_FOCUSCHANGED;

    // HookMouseEnter
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;

    // HookMouseLeave
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    // HookParentColorChanged
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;

    // HookTextChanged
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;

    // HookMouseMove
    procedure WMMouseMove(var Message: TWMMouse); message WM_MOUSEMOVE;

    // HookResized
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    { Protected desclarations }
    function GetVersion: string; virtual;
    function GetStyleTheme: TdxTheme; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure MouseDown(Button:TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button:TMouseButton; Shift:TShiftState; X, Y: Integer); override;
    procedure SetStyleManager(Value: TdxStyleManager);

    // hidden properties.
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property StyleManager: TdxStyleManager read FStyleManager write SetStyleManager;
  public
    procedure Click; override;
    // Hook Methods.
    //
    procedure HookEnabledChanged; dynamic;
    procedure HookFocusedChanged; dynamic;
    procedure HookMouseDown; dynamic;
    procedure HookMouseEnter; dynamic;
    procedure HookMouseLeave; dynamic;
    procedure HookMouseMove; dynamic;
    procedure HookMouseUp; dynamic;
    procedure HookParentColorChanged; dynamic;
    procedure HookResized; dynamic;
    procedure HookTextChanged; dynamic;

    { Public desclarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // Call LockUpdate to prevent multiple paint events.
    procedure LockUpdate;

    // Call UnlockUpdate to enable paint event.
    procedure UnlockUpdate;

    property DrawState: TdxDrawState read FDrawState write FDrawState;
    property IsLocked: Boolean read FIsLocked write FIsLocked;
    property IsSibling: Boolean read FIsSibling write FIsSibling;
  published
    { Published declarations }

    // common properties.
    property Anchors;
    property Align;
    property BiDiMode;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    // advanced properties.
    property About: string read FAbout write SetAbout;
    property Version: string read GetVersion write SetVersion;

    // common events.
    property OnClick;

  {$IFDEF VER140} // Borland Delphi 6.0
    property OnContextPopup;
  {$ENDIF}

    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

    // advanced events.
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

{ TdxGradient }

  TdxGradient = class(TPersistent)
  private
    { Private-Deklarationen }
    FColorSteps: TdxColorSteps;
    FDithered: Boolean;
    FEnabled: Boolean;
    FEndColor: TColor;
    FStartColor: TColor;
    FGradientStyle: TdxGradientStyle;
  protected
    { Protected declarations }
    Parent: TdxCustomControl;
    procedure SetDithered(Value: Boolean); virtual;
    procedure SetColorSteps(Value: TdxColorSteps); virtual;
    procedure SetEnabled(Value: Boolean); virtual;
    procedure SetEndColor(Value: TColor); virtual;
    procedure SetGradientStyle(Value: TdxGradientStyle); virtual;
    procedure SetStartColor(Value: TColor); virtual;
  public
    { Public declarations }
    Bitmap: TBitmap;
    constructor Create(AOwner: TControl);
    destructor Destroy; override;
    procedure RecreateBands; virtual;
  published
    { Published-Deklarationen }
    property Dithered: Boolean read FDithered write SetDithered default True;
    property ColorSteps: TdxColorSteps read FColorSteps write SetColorSteps default 16;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property EndColor: TColor read FEndColor write SetEndColor default clSilver;
    property StartColor: TColor read FStartColor write SetStartColor default clGray;
    property Style: TdxGradientStyle read FGradientStyle write SetGradientStyle default gsLeft;
  end;

//
// Global Helper Methods.
//

// dxDrawLine
procedure dxDrawLine(const ACanvas: TCanvas; const x1, y1, x2, y2: Integer;
  const AutoCorrect: Boolean = False);

// dxDrawBoundLines
procedure dxDrawBoundLines(const ACanvas: TCanvas; const ABoundLines: TdxBoundLines;
  const AColor: TColor; const R: TRect);

// dxCreateGradientRect
procedure dxCreateGradientRect(const Width, Height: Integer; const StartColor,
  EndColor: TColor; const ColorSteps: TdxColorSteps; const Style: TdxGradientStyle;
  const Dithered: Boolean; var Bitmap: TBitmap);

// dxRenderText
procedure dxRenderText(const Parent: TControl; const Canvas: TCanvas;
  AText: string; const AFont: TFont; const Enabled, ShowAccelChar: Boolean;
  var Rect: TRect; Flags: Integer);

// dxSetDrawFlags
procedure dxSetDrawFlags(const Alignment: TAlignment; const WordWrap: Boolean;
  var Flags: Integer);

// dxPlaceText (beta)
procedure dxPlaceText(const Parent: TControl; const Canvas: TCanvas;
  const AText: string; const AFont: TFont; const Enabled, ShowAccelChar: Boolean;
  const Alignment: TAlignment; const WordWrap: Boolean; var Rect: TRect);

{$R dxCore.res}
  
procedure Register;

implementation

{-----------------------------------------------------------------------------
  Procedure: Register
  Author:    mh
  Date:      24-Jun-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
procedure Register;
begin
 
end;

{ TdxCustomComponent }

{-----------------------------------------------------------------------------
  Procedure: TdxCustomComponent.Create
  Author:    mh
  Date:      24-Jun-2002
  Arguments: AOwner: TComponent
  Result:    None
-----------------------------------------------------------------------------}

constructor TdxCustomComponent.Create(AOwner: TComponent);
begin
  inherited;

  // initialize property values.
  FAbout := 'Design eXperience. © 2002 M. Hoffmann';
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomComponent.GetVersion
  Author:    mh
  Date:      24-Jun-2002
  Arguments: None
  Result:    string
-----------------------------------------------------------------------------}

function TdxCustomComponent.GetVersion: string;
begin
  //
  // Each descendant class may override the version information, so
  // it's possible to give each class it's own version number.
  //
  Result := '';
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomComponent.SetAbout
  Author:    mh
  Date:      24-Jun-2002
  Arguments: Value: string
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomComponent.SetAbout(Value: string);
begin
  ; // don't enable overwriting this constant.
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomComponent.SetVersion
  Author:    mh
  Date:      24-Jun-2002
  Arguments: Value: string
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomComponent.SetVersion(Value: string);
begin
  ; // don't enable overwriting this constant.
end;

{ TdxStyleManager }

{-----------------------------------------------------------------------------
  Procedure: TdxStyleManager.Create
  Author:    mh
  Date:      25-Jun-2002
  Arguments: AOwner: TComponent
  Result:    None
-----------------------------------------------------------------------------}

constructor TdxStyleManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MessageBox(
    Application.Handle,
    'The "TdxStyleManager" component is currently in beta state and has no functionality yet!',
    PChar(Application.Title),
    MB_ICONINFORMATION);
  FControls := TList.Create;
  FTheme := WindowsXP;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxStyleManager.Destroy
  Author:    mh
  Date:      25-Jun-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TdxStyleManager.Destroy;
begin
  InvalidateControls;
  FControls.Free;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxStyleManager.InvalidateControls
  Author:    mh
  Date:      25-Jun-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxStyleManager.InvalidateControls;
var
  i: Integer;
begin
  for i := 0 to FControls.Count - 1 do
  with TdxCustomControl(FControls[i]) do
  if not FIsLocked then
    Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxStyleManager.GetVersion
  Author:    mh
  Date:      25-Jun-2002
  Arguments: None
  Result:    string
-----------------------------------------------------------------------------}

function TdxStyleManager.GetVersion: string;
begin
  Result := '1.0.0';
end;

{-----------------------------------------------------------------------------
  Procedure: TdxStyleManager.SetTheme
  Author:    mh
  Date:      25-Jun-2002
  Arguments: Value: TdxTheme
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxStyleManager.SetTheme(Value: TdxTheme);
begin
  if Value <> FTheme then
  begin
    FTheme := Value;
    InvalidateControls;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxStyleManager.RegisterControl
  Author:    mh
  Date:      25-Jun-2002
  Arguments: const AControl: TdxCustomControl
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxStyleManager.RegisterControl(const AControl: TdxCustomControl);
begin
  if FControls.IndexOf(AControl) = -1 then
    FControls.Add(AControl);
end;

{-----------------------------------------------------------------------------
  Procedure: TdxStyleManager.UnregisterControl
  Author:    mh
  Date:      25-Jun-2002
  Arguments: const AControl: TdxCustomControl
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxStyleManager.UnregisterControl(const AControl: TdxCustomControl);
begin
  if FControls.IndexOf(AControl) <> -1 then
    FControls.Delete(FControls.IndexOf(AControl));
end;

{ TdxCustomControl }

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.Create
  Author:    mh
  Date:      22-Feb-2002
  Arguments: AOwner: TComponent
  Result:    None
-----------------------------------------------------------------------------}

constructor TdxCustomControl.Create(AOwner: TComponent);
begin
  inherited;

  // initialize default control values.
  ControlStyle := ControlStyle - [csDoubleClicks];
  DoubleBuffered := True;
  TabStop := True;

  // initialize property values.
  FAbout := 'Design eXperience. © 2002 M. Hoffmann';
  FClicking := False;
  FDrawState := [dsDefault];
  FIsLocked := False;
  FIsSibling := False;
  FModalResult := 0;
  FStyleManager := nil;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.Destroy
  Author:    mh
  Date:      25-Jun-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TdxCustomControl.Destroy;
begin
  if FStyleManager <> nil then
    FStyleManager.UnregisterControl(Self);
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.Notification
  Author:    mh
  Date:      25-Jun-2002
  Arguments: AComponent: TComponent; Operation: TOperation
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (AComponent is TdxStyleManager) and (Operation = opRemove) then
    FStyleManager := nil;
  inherited Notification(AComponent, Operation);
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.SetAbout
  Author:    mh
  Date:      22-Feb-2002
  Arguments: Value: string
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.SetAbout(Value: string);
begin
  ; // don't enable overwriting this constant.
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.SetStyleManager
  Author:    mh
  Date:      25-Jun-2002
  Arguments: Value: TdxStyleManager
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.SetStyleManager(Value: TdxStyleManager);
begin
  if Value <> FStyleManager then
  begin
    if Value <> nil then
      Value.RegisterControl(Self)
    else
      FStyleManager.UnregisterControl(Self);
    FStyleManager := Value;
    if not FIsLocked then
      Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.GetVersion
  Author:    mh
  Date:      09-Apr-2002
  Arguments: None
  Result:    string
-----------------------------------------------------------------------------}

function TdxCustomControl.GetVersion: string;
begin
  //
  // Each descendant class may override the version information, so
  // it's possible to give each class it's own version number.
  //
  Result := '';
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.GetStyleTheme
  Author:    mh
  Date:      25-Jun-2002
  Arguments: None
  Result:    TdxTheme
-----------------------------------------------------------------------------}

function TdxCustomControl.GetStyleTheme: TdxTheme;
begin
  Result := WindowsXP;
  if FStyleManager <> nil then
    Result := FStyleManager.Theme;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.SetVersion
  Author:    mh
  Date:      07-Mrz-2002
  Arguments: Value: string
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.SetVersion(Value: string);
begin
  ; // don't enable overwriting this constant.
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.LockUpdate
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.LockUpdate;
begin
  FIsLocked := True;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.UnlockUpdate
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.UnlockUpdate;
begin
  FIsLocked := False;
  Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.CMDialogChar
  Author:    mh
  Date:      22-Feb-2002
  Arguments: var Message: TCMDialogChar
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
  if IsAccel(CharCode, Caption) and CanFocus and (Focused or (
    (GetKeyState(VK_MENU) and $8000) <> 0)) then
  begin
    Click;
    Result := 1;
  end
  else
    inherited;
end;

//
// method deligations.
//

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.CMEnabledChanged
  Author:    mh
  Date:      21-Feb-2002
  Arguments: var Message: TMessage
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.CMEnabledChanged(var Message: TMessage);
begin
  // deligate message "EnabledChanged" to hook.
  HookEnabledChanged;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.CMFocusChanged
  Author:    mh
  Date:      22-Feb-2002
  Arguments: var Message: TMessage
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.CMFocusChanged(var Message: TMessage);
begin
  // deligate message "FocusChanged" to hook.
  HookFocusedChanged;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.CMMouseEnter
  Author:    mh
  Date:      21-Feb-2002
  Arguments: var Message: TMessage
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.CMMouseEnter(var Message: TMessage);
begin
  // deligate message "MouseEnter" to hook.
  HookMouseEnter;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.CMMouseLeave
  Author:    mh
  Date:      21-Feb-2002
  Arguments: var Message: TMessage
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.CMMouseLeave(var Message: TMessage);
begin
  // deligate message "MouseLeave" to hook.
  HookMouseLeave;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.CMParentColorChanged
  Author:    mh
  Date:      22-Feb-2002
  Arguments: var Message: TMessage
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.CMParentColorChanged(var Message: TMessage);
begin
  // deligate message "ParentColorChanged" to hook.
  HookParentColorChanged;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.CMTextChanged
  Author:    mh
  Date:      22-Feb-2002
  Arguments: var Msg: TMessage
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.CMTextChanged(var Message: TMessage);
begin
  // deligate message "TextChanged" to hook.
  HookTextChanged;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.WMMouseMove
  Author:    mh
  Date:      10-Mai-2002
  Arguments: var Message: TWMMouse
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.WMMouseMove(var Message: TWMMouse);
begin
  // deligate message "MouseMove" to hook.
  HookMouseMove;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.WMSize
  Author:    mh
  Date:      22-Feb-2002
  Arguments: var Message: TWMSize
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.WMSize(var Message: TWMSize);
begin
  // deligate message "Size" to hook.
  HookResized;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.MouseDown
  Author:    mh
  Date:      10-Mai-2002
  Arguments: Button: TMouseButton; Shift: TShiftState; X, Y: Integer
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FClicking := True;
    HookMouseDown;
  end;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.MouseUp
  Author:    mh
  Date:      10-Mai-2002
  Arguments: Button: TMouseButton; Shift: TShiftState; X, Y: Integer
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FClicking then
  begin
    FClicking := False;
    HookMouseUp;
  end;
  inherited;
end;

//
// Hooks are used to interrupt default windows messages in an easier
// way - it's possible to override them in descedant classes.
// Beware of multiple redraw calls - if you know that the calling
// hooks always redraws the component, use the Lock i.e. Unlock methods.
//

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.Click
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.Click;
var
  Form: TCustomForm;
begin
  Form := GetParentForm(Self);
  if Form <> nil then
    Form.ModalResult := ModalResult;
  inherited Click;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookEnabledChanged
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookEnabledChanged;
begin
  // This hook is called if the enabled property was switched. In that case
  // we normaly have to redraw the control.
  if not FIsLocked then
    Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookFocusedChanged
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookFocusedChanged;
begin
  // This hook is called if the currently focused control was changed to- or
  // from this control.
  if Focused then
    Include(FDrawState, dsFocused)
  else
  begin
    Exclude(FDrawState, dsFocused);
    Exclude(FDrawState, dsClicked);
  end;
  FIsSibling := GetParentForm(Self).ActiveControl is TdxCustomControl;
  if not FIsLocked then
    Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookMouseEnter
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookMouseEnter;
begin
  // This hook is called if the user moves the mouse over the control (hover).
  Include(FDrawState, dsHighlight);
  if not FIsLocked then
    Invalidate;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookMouseLeave
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookMouseLeave;
begin
  // This hook is called if the user moves the mouse away from the control.
  Exclude(FDrawState, dsHighlight);
  if not FIsLocked then
    Invalidate;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookMouseMove
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookMouseMove;
begin
  // This hook is called if the user moves the mouse inside the control.
  ;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookMouseDown
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookMouseDown;
begin
  // This hook is called if the user presses the left mouse button over the
  // controls. In that case we have to focus to redraw it in clicked state.
  if not Focused then
    SetFocus;
  Include(FDrawState, dsClicked);
  if not FIsLocked then
    Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookMouseUp
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookMouseUp;
var
  cPos: TPoint;
  NewControl: TWinControl;
begin
  // This hook is called if the user releases the left mouse button.
  begin
    Exclude(FDrawState, dsClicked);
    if not FIsLocked then
      Invalidate;
    GetCursorPos(cPos);

    // Does the cursor is over another supported control?
    NewControl := FindVCLWindow(cPos);
    if (NewControl <> nil) and (NewControl <> Self)
      and (NewControl.InheritsFrom(TdxCustomControl)) then
      TdxCustomControl(NewControl).HookMouseEnter;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookParentColorChanged
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookParentColorChanged;
begin
  // This hook is called if the parent color was changed.
  if not FIsLocked then
    Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookResized
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookResized;
begin
  // This hook is called if the control dimensions (width/height) were changed.
  ;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxCustomControl.HookTextChanged
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxCustomControl.HookTextChanged;
begin
  // This hook is called if the caption (text) was changed.
  if not FIsLocked then
    Invalidate;
end;

{ TdxGradient }

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.Create
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: AOwner: TControl
  Result:    None
-----------------------------------------------------------------------------}

constructor TdxGradient.Create(AOwner: TControl);
begin
  inherited Create;
  Parent := TdxCustomControl(AOwner);
  Bitmap := TBitmap.Create;
  FDithered := True;
  FColorSteps := 16;
  FEnabled := True;
  FEndColor := clSilver;
  FStartColor := clGray;
  FGradientStyle := gsLeft;
end; // Create

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.Destroy
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TdxGradient.Destroy;
begin
  Bitmap.Free;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.RecreateBands
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxGradient.RecreateBands;
begin
  if Assigned(Bitmap) then
    dxCreateGradientRect(Parent.Width, Parent.Height, FStartColor, FEndColor,
      FColorSteps, FGradientStyle, FDithered, Bitmap);
end;

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.SetDithered
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxGradient.SetDithered(Value: Boolean);
begin
  if FDithered <> Value then
  begin
    FDithered := Value;
    RecreateBands;
    if not Parent.FIsLocked then
      Parent.Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.SetColorSteps
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: Value: TdxColorSteps
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxGradient.SetColorSteps(Value: TdxColorSteps);
begin
  if FColorSteps <> Value then
  begin
    FColorSteps := Value;
    RecreateBands;
    if not Parent.FIsLocked then
      Parent.Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.SetEnabled
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxGradient.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Parent.Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.SetEndColor
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxGradient.SetEndColor(Value: TColor);
begin
  if FEndColor <> Value then
  begin
    FEndColor := Value;
    RecreateBands;
    if not Parent.FIsLocked then
      Parent.Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.SetGradientStyle
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: Value: TdxGradientStyle
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxGradient.SetGradientStyle(Value: TdxGradientStyle);
begin
  if FGradientStyle <> Value then
  begin
    FGradientStyle := Value;
    RecreateBands;
    if not Parent.FIsLocked then
      Parent.Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxGradient.SetStartColor
  Author:    Kaju.74
  Date:      07-Nov-2001
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxGradient.SetStartColor(Value: TColor);
begin
  if FStartColor <> Value then
  begin
    FStartColor := Value;
    RecreateBands;
    if not Parent.FIsLocked then
      Parent.Invalidate;
  end;
end;

//
// Global Helper Methods.
//

{-----------------------------------------------------------------------------
  Procedure: dxDrawLine
  Author:    mh
  Date:      10-Mai-2002
  Arguments: const ACanvas: TCanvas; const x1, y1, x2, y2: Integer; const AutoCorrect: Boolean = False
  Result:    None
-----------------------------------------------------------------------------}

procedure dxDrawLine(const ACanvas: TCanvas; const x1, y1, x2, y2: Integer;
  const AutoCorrect: Boolean = False);
var
  xn, yn: Integer;
begin
  xn := x2;
  yn := y2;
  if AutoCorrect then
  begin
    if x2 >= x1 then
      xn := x2 + 1
    else
      xn := x2 - 1;
    if y2 >= y1 then
      yn := y2 + 1
    else
      yn := y2 - 1;
  end;
  ACanvas.MoveTo(x1, y1);
  ACanvas.LineTo(xn, yn);
end;

{-----------------------------------------------------------------------------
  Procedure: dxDrawBoundLines
  Author:    mh
  Date:      02-Mai-2002
  Arguments: const ACanvas: TCanvas; const ABoundLines: TdxBoundLines;
    const AColor: TColor; const R: TRect
  Result:    None
-----------------------------------------------------------------------------}

procedure dxDrawBoundLines(const ACanvas: TCanvas; const ABoundLines: TdxBoundLines;
  const AColor: TColor; const R: TRect);
begin
  with ACanvas do
  begin
    Pen.Color := AColor;
    if blLeft in ABoundLines then
      dxDrawLine(ACanvas, R.Left, R.Top, R.Left, R.Bottom - 1);
    if blTop in ABoundLines then
      dxDrawLine(ACanvas, R.Left, R.Top, R.Right - 1, R.Top);
    if blRight in ABoundLines then
      dxDrawLine(ACanvas, R.Right - 1, R.Top, R.Right - 1, R.Bottom - 1);
    if blBottom in ABoundLines then
      dxDrawLine(ACanvas, R.Top, R.Bottom - 1, R.Right, R.Bottom - 1);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: dxCreateGradientRect
  Author:    mh
  Date:      02-Mai-2002
  Arguments: const Width, Height: Integer; const StartColor, EndColor: TColor;
    const ColorSteps: TdxColorSteps; const Style: TdxGradientStyle;
    const Dithered: Boolean; var Bitmap: TBitmap
  Result:    None
-----------------------------------------------------------------------------}

procedure dxCreateGradientRect(const Width, Height: Integer; const StartColor,
  EndColor: TColor; const ColorSteps: TdxColorSteps; const Style: TdxGradientStyle;
  const Dithered: Boolean; var Bitmap: TBitmap);
type
  TGradientBand = array[0..255] of TColor;
  TRGBMap = packed record
    case boolean of
      True: (RGBVal: DWord);
      False: (R, G, B, D: Byte);
  end;
const
  DitherDepth = 16;
var
  iLoop, xLoop, yLoop: Integer;
  iBndS, iBndE: Integer;
  GBand: TGradientBand;
  procedure CalculateGradientBand;
  var
    rR, rG, rB: Real;
    lCol, hCol: TRGBMap;
    iStp: Integer;
  begin
    if Style in [gsLeft, gsTop] then
    begin
      lCol.RGBVal := ColorToRGB(StartColor);
      hCol.RGBVal := ColorToRGB(EndColor);
    end
    else
    begin
      lCol.RGBVal := ColorToRGB(EndColor);
      hCol.RGBVal := ColorToRGB(StartColor);
    end;
    rR := (hCol.R - lCol.R) / (ColorSteps - 1);
    rG := (hCol.G - lCol.G) / (ColorSteps - 1);
    rB := (hCol.B - lCol.B) / (ColorSteps - 1);
    for iStp := 0 to (ColorSteps - 1) do
      GBand[iStp] := RGB(
        lCol.R + Round(rR * iStp),
        lCol.G + Round(rG * iStp),
        lCol.B + Round(rB * iStp)
        );
  end;
begin
  Bitmap.Height := Height;
  Bitmap.Width := Width;
  CalculateGradientBand;
  with Bitmap.Canvas do
  begin
    Brush.Color := StartColor;
    FillRect(Bounds(0, 0, Width, Height));
    if Style in [gsLeft, gsRight] then
    begin
      for iLoop := 0 to ColorSteps - 1 do
      begin
        iBndS := MulDiv(iLoop, Width, ColorSteps);
        iBndE := MulDiv(iLoop + 1, Width, ColorSteps);
        Brush.Color := GBand[iLoop];
        PatBlt(Handle, iBndS, 0, iBndE, Height, PATCOPY);
        if (iLoop > 0) and (Dithered) then
          for yLoop := 0 to DitherDepth - 1 do
            for xLoop := 0 to Width div (ColorSteps - 1) do
              Pixels[iBndS + Random(xLoop), yLoop] := GBand[iLoop - 1];
      end;
      for yLoop := 1 to Height div DitherDepth do
        CopyRect(Bounds(0, yLoop * DitherDepth, Width, DitherDepth),
          Bitmap.Canvas, Bounds(0, 0, Width, DitherDepth));
    end
    else
    begin
      for iLoop := 0 to ColorSteps - 1 do
      begin
        iBndS := MulDiv(iLoop, Height, ColorSteps);
        iBndE := MulDiv(iLoop + 1, Height, ColorSteps);
        Brush.Color := GBand[iLoop];
        PatBlt(Handle, 0, iBndS, Width, iBndE, PATCOPY);
        if (iLoop > 0) and (Dithered) then
          for xLoop := 0 to DitherDepth - 1 do
            for yLoop := 0 to Height div (ColorSteps - 1) do
              Pixels[xLoop, iBndS + Random(yLoop)] := GBand[iLoop - 1];
      end;
      for xLoop := 0 to Width div DitherDepth do
        CopyRect(Bounds(xLoop * DitherDepth, 0, DitherDepth, Height),
          Bitmap.Canvas, Bounds(0, 0, DitherDepth, Height));
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: dxRenderText
  Author:    mh
  Date:      02-Mai-2002
  Arguments: const Parent: TControl; const Canvas: TCanvas; AText: string;
    const AFont: TFont; const Enabled, ShowAccelChar: Boolean;
    var Rect: TRect; Flags: Integer
  Result:    None
-----------------------------------------------------------------------------}

procedure dxRenderText(const Parent: TControl; const Canvas: TCanvas;
  AText: string; const AFont: TFont; const Enabled, ShowAccelChar: Boolean;
  var Rect: TRect; Flags: Integer); overload;

  {-----------------------------------------------------------------------------
    Procedure: DoDrawText
    Author:    mh
    Date:      02-Mai-2002
    Arguments: None
    Result:    None
  -----------------------------------------------------------------------------}

  procedure DoDrawText;
  begin
    DrawText(Canvas.Handle, PChar(AText), -1, Rect, Flags);
  end;

begin
  if (Flags and DT_CALCRECT <> 0) and ((AText = '') or ShowAccelChar
    and (AText[1] = '&') and (AText[2] = #0)) then
    AText := AText + ' ';
  if not ShowAccelChar then
    Flags := Flags or DT_NOPREFIX;
  Flags := Parent.DrawTextBiDiModeFlags(Flags);
  with Canvas do
  begin
    Font.Assign(AFont);
    if not Enabled then
    begin
      OffsetRect(Rect, 1, 1);
      Font.Color := clBtnHighlight;
      DoDrawText;
      OffsetRect(Rect, -1, -1);
      Font.Color := clBtnShadow;
      DoDrawText;
    end
    else
      DoDrawText;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: dxSetDrawFlags
  Author:    mh
  Date:      02-Mai-2002
  Arguments: const Alignment: TAlignment; const WordWrap: Boolean;
    var Flags: Integer
  Result:    None
-----------------------------------------------------------------------------}

procedure dxSetDrawFlags(const Alignment: TAlignment; const WordWrap: Boolean;
  var Flags: Integer);
begin
  Flags := DT_END_ELLIPSIS;
  case Alignment of
    taLeftJustify:
      Flags := Flags or DT_LEFT;
    taCenter:
      Flags := Flags or DT_CENTER;
    taRightJustify:
      Flags := Flags or DT_RIGHT;
  end;
  if not WordWrap then
    Flags := Flags or DT_SINGLELINE
  else
    Flags := Flags or DT_WORDBREAK;
end;

{-----------------------------------------------------------------------------
  Procedure: dxPlaceText
  Author:    mh
  Date:      02-Mai-2002
  Arguments: const Parent: TControl; const Canvas: TCanvas; const AText: string;
    const AFont: TFont; const Enabled, ShowAccelChar: Boolean;
    const Alignment: TAlignment; const WordWrap: Boolean; var Rect: TRect
  Result:    None
-----------------------------------------------------------------------------}

procedure dxPlaceText(const Parent: TControl; const Canvas: TCanvas; const AText: string;
  const AFont: TFont; const Enabled, ShowAccelChar: Boolean; const Alignment: TAlignment;
  const WordWrap: Boolean; var Rect: TRect);
var
  Flags, dx, OH, OW: Integer;
begin
  OH := Rect.Bottom - Rect.Top;
  OW := Rect.Right - Rect.Left;
  dxSetDrawFlags(Alignment, WordWrap, Flags);
  dxRenderText(Parent, Canvas, AText, AFont, Enabled, ShowAccelChar, Rect,
    Flags or DT_CALCRECT);
  if Alignment = taRightJustify then
    dx := OW - (Rect.Right + Rect.Left)
  else if Alignment = taCenter then
    dx := (OW - Rect.Right) div 2
  else
    dx := 0;
  OffsetRect(Rect, dx, (OH - Rect.Bottom) div 2);
  dxRenderText(Parent, Canvas, AText, AFont, Enabled, ShowAccelChar, Rect, Flags);
end;

end.

