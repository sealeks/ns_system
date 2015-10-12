
{*******************************************************************}
{                                                                   }
{   dxButton (Design eXperience)                                    }
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
{   Version 1.0.2g (2002/06/25)                                     }
{     + Added support for "TdxStyleManager" (beta)                  }
{                                                                   }
{   Version 1.0.2f (2002/05/08)                                     }
{     * Minor Changes                                               }
{                                                                   }
{   Version 1.0.2e (2002/04/29)                                     }
{     + Added missed "TdxColor" Properties                          }
{                                                                   }
{   Version 1.0.2d (2002/04/29)                                     }
{     + Added "WordWrap" Property                                   }
{     + Added "HotTrack" Property                                   }
{     + Added "TdxColor" Properties                                 }
{                                                                   }
{   Version 1.0.2b+c (2002/04/12)                                   }
{     + Added AutoGray Glyphs                                       }
{       (sorry, icons as Glyphs are not longer supported -          }
{         use actions instead!)                                     }
{     + Added Glyph Layout property                                 }
{     * Fixed ActionLink (Added Destructor)                         }
{                                                                   }
{   Version 1.0.2 (2002/04/09)                                      }
{     * Minor Bugfixes                                              }
{     * Fixed Action behaviour                                      }
{       (Thanks to Rajko Bogdanovic)                                }
{     * Fixed Key-Up/Down methods                                   }
{     + Added "ReadMe.txt" and "WhatsNew.txt"                       }
{     + Added multiple-line support                                 }
{     + Reordered upload structure                                  }
{                                                                   }
{   Version 1.0.1                                                   }
{     + Replaced OwnerDrawState with internal Structure             }
{                                                                   }
{   Version 1.0.0                                                   }
{     + First Release                                               }
{                                                                   }
{*******************************************************************}

unit dxButton;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, ImgList,
  ActnList, SysUtils, dxCore;

resourcestring
  SVersion = '1.0.2g'; // always increase version number on new releases!

type
{ TdxQuality }

  //
  // The quality in which the gradient will be drawn. 'bgHigh' enables
  // the slower color dithering and have to been used only on larger component
  // dimensions.
  //
  TdxQuality = (bqLow, bqMiddle, bqHigh);

{ TdxLayout }

  //
  // The layout property is used to set the glyph position.
  //
  TdxLayout = (blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom);

{ TdxColors }

  TdxColors = class(TPersistent)
  private
    { Private declarations }
    FBackgroundFrom: TColor;
    FBackgroundTo: TColor;
    FBorderEdges: TColor;
    FBorderLine: TColor;
    FClickedFrom: TColor;
    FClickedTo: TColor;
    FFocusedFrom: TColor;
    FFocusedTo: TColor;
    FHighlightFrom: TColor;
    FHighlightTo: TColor;
    FHotTrack: TColor;
  protected
    { Protected declarations }
    FOwner: TObject;
    procedure SetBackgroundFrom(Value: TColor); virtual;
    procedure SetBackgroundTo(Value: TColor); virtual;
    procedure SetBorderEdges(Value: TColor); virtual;
    procedure SetBorderLine(Value: TColor); virtual;
    procedure SetClickedFrom(Value: TColor); virtual;
    procedure SetClickedTo(Value: TColor); virtual;
    procedure SetFocusedFrom(Value: TColor); virtual;
    procedure SetFocusedTo(Value: TColor); virtual;
    procedure SetHighlightFrom(Value: TColor); virtual;
    procedure SetHighlightTo(Value: TColor); virtual;
    procedure SetHotTrack(Value: TColor); virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);
  published
    { Published declarations }
    property BackgroundFrom: TColor read FBackgroundFrom write SetBackgroundFrom default dxColor_BgFrom;
    property BackgroundTo: TColor read FBackgroundTo write SetBackgroundTo default dxColor_BgTo;
    property BorderEdges: TColor read FBorderEdges write SetBorderEdges default dxColor_BorderEdges;
    property BorderLine: TColor read FBorderLine write SetBorderLine default dxColor_BorderLine;
    property ClickedFrom: TColor read FClickedFrom write SetClickedFrom default dxColor_CkFrom;
    property ClickedTo: TColor read FClickedTo write SetClickedTo default dxColor_CkTo;
    property FocusedFrom: TColor read FFocusedFrom write SetFocusedFrom default dxColor_FcFrom;
    property FocusedTo: TColor read FFocusedTo write SetFocusedTo default dxColor_FcTo;
    property HighlightFrom: TColor read FHighlightFrom write SetHighlightFrom default dxColor_HlFrom;
    property HighlightTo: TColor read FHighlightTo write SetHighlightTo default dxColor_HlTo;
    property HotTrack: TColor read FHotTrack write SetHotTrack default dxColor_HotTrack;
  end;

{ TdxButtonActionLink }

  TdxButtonActionLink = class(TWinControlActionLink)
  protected
    { Protected declarations }
    function IsImageIndexLinked: Boolean; override;
    procedure AssignClient(AClient: TObject); override;
    procedure SetImageIndex(Value: Integer); override;
  public
    { Public declarations }
    destructor Destroy; override;
  end;

{ TdxButton }

  TdxButton = class(TdxCustomControl)
  private
    { Private declarations }
    FAutoGray: Boolean;
    FBgGradient: TBitmap;
    FCancel: Boolean;
    FCkGradient: TBitmap;
    FDefault: Boolean;
    FFcGradient: TBitmap;
    FGlyph: TBitmap;
    FHlGradient: TBitmap;
    FHotTrack: Boolean;
    FImageChangeLink: TChangeLink;
    FImageIndex: Integer;
    FLayout: TdxLayout;
    FColors: TdxColors;
    FQuality: TdxQuality;
    FShowAccelChar: Boolean;
    FShowFocusRect: Boolean;
    FSpacing: Byte;
    FWordWrap: Boolean;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure ImageListChange(Sender: TObject);
  protected
    { Protected declarations }
    function GetVersion: string; override;
    function GetActionLinkClass: TControlActionLinkClass; override;
    function IsSpecialDrawState(IgnoreDefault: Boolean = False): Boolean;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure SetAutoGray(Value: Boolean); virtual;
    procedure SetDefault(Value: Boolean); virtual;
    procedure SetGlyph(Value: TBitmap); virtual;
    procedure SetHotTrack(Value: Boolean); virtual;
    procedure SetLayout(Value: TdxLayout); virtual;
    procedure SetQuality(Value: TdxQuality); virtual;
    procedure SetShowAccelChar(Value: Boolean); virtual;
    procedure SetShowFocusRect(Value: Boolean); virtual;
    procedure SetSpacing(Value: Byte); virtual;
    procedure SetWordWrap(Value: Boolean); virtual;
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure HookResized; override;
  published
    { Published declarations }

    // common properties.
    property Action;
    property Caption;
    property Height default 25;
    property TabOrder;
    property TabStop default True;
    property Width default 73;

    // advanced properties.
    property AutoGray: Boolean read FAutoGray write SetAutoGray default True;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Default: Boolean read FDefault write SetDefault default False;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property HotTrack: Boolean read FHotTrack write SetHotTrack default False;
    property Layout: TdxLayout read FLayout write SetLayout default blGlyphLeft;
    property ModalResult;
    property Colors: TdxColors read FColors write FColors;
    property Quality: TdxQuality read FQuality write SetQuality default bqMiddle;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar default True;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default True;
    property Spacing: Byte read FSpacing write SetSpacing default 3;
    property StyleManager;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default True;
  end;

procedure Register;

implementation

{-----------------------------------------------------------------------------
  Procedure: Register
  Author:    mh
  Date:      04-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure Register;
begin
 
end;

{ TdxColors }

{-----------------------------------------------------------------------------
  Procedure: TdxColors.Create
  Author:    mh
  Date:      29-Apr-2002
  Arguments: AOwner: TComponent
  Result:    None
-----------------------------------------------------------------------------}

constructor TdxColors.Create(AOwner: TComponent);
begin
  inherited Create;
  FBackgroundFrom := dxColor_BgFrom;
  FBackgroundTo := dxColor_BgTo;
  FBorderEdges := dxColor_BorderEdges;
  FBorderLine := dxColor_BorderLine;
  FClickedFrom := dxColor_CkFrom;
  FClickedTo := dxColor_CkTo;
  FFocusedFrom := dxColor_FcFrom;
  FFocusedTo := dxColor_FcTo;
  FHighlightFrom := dxColor_HlFrom;
  FHighlightTo := dxColor_HlTo;
  FHotTrack := dxColor_HotTrack;
  FOwner := AOwner;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetBackgroundFrom
  Author:    mh
  Date:      29-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetBackgroundFrom(Value: TColor);
begin
  if Value <> FBackgroundFrom then
  begin
    FBackgroundFrom := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetBackgroundTo
  Author:    mh
  Date:      29-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetBackgroundTo(Value: TColor);
begin
  if Value <> FBackgroundTo then
  begin
    FBackgroundTo := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetBorderEdges
  Author:    mh
  Date:      30-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetBorderEdges(Value: TColor);
begin
  if Value <> FBorderEdges then
  begin
    FBorderEdges := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetBorderLine
  Author:    mh
  Date:      30-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetBorderLine(Value: TColor);
begin
  if Value <> FBorderLine then
  begin
    FBorderLine := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetClickedFrom
  Author:    mh
  Date:      30-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetClickedFrom(Value: TColor);
begin
  if Value <> FClickedFrom then
  begin
    FClickedFrom := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetClickedTo
  Author:    mh
  Date:      30-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetClickedTo(Value: TColor);
begin
  if Value <> FClickedTo then
  begin
    FClickedTo := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetFocusedFrom
  Author:    mh
  Date:      30-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetFocusedFrom(Value: TColor);
begin
  if Value <> FFocusedFrom then
  begin
    FFocusedFrom := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetFocusedTo
  Author:    mh
  Date:      30-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetFocusedTo(Value: TColor);
begin
  if Value <> FFocusedTo then
  begin
    FFocusedTo := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetHighlightFrom
  Author:    mh
  Date:      30-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetHighlightFrom(Value: TColor);
begin
  if Value <> FHighlightFrom then
  begin
    FHighlightFrom := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetHighlightTo
  Author:    mh
  Date:      30-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetHighlightTo(Value: TColor);
begin
  if Value <> FHighlightTo then
  begin
    FHighlightTo := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxColors.SetHotTrack
  Author:    mh
  Date:      29-Apr-2002
  Arguments: Value: TColor
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxColors.SetHotTrack(Value: TColor);
begin
  if Value <> FHotTrack then
  begin
    FHotTrack := Value;
    TdxButton(FOwner).HookResized;
  end;
end;

{ TdxButtonActionLink }

{-----------------------------------------------------------------------------
  Procedure: TdxButtonActionLink.AssignClient
  Author:    mh
  Date:      09-Apr-2002
  Arguments: AClient: TObject
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButtonActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TdxButton;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButtonActionLink.Destroy
  Author:    mh
  Date:      12-Apr-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TdxButtonActionLink.Destroy;
begin
  TdxButton(FClient).Invalidate;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButtonActionLink.IsImageIndexLinked
  Author:    mh
  Date:      09-Apr-2002
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}

function TdxButtonActionLink.IsImageIndexLinked: Boolean;
begin
  Result := True;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButtonActionLink.SetImageIndex
  Author:    mh
  Date:      09-Apr-2002
  Arguments: Value: Integer
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButtonActionLink.SetImageIndex(Value: Integer);
begin
  inherited;
  (FClient as TdxButton).FImageIndex := Value;
  (FClient as TdxButton).Invalidate;
end;

{ TdxButton }

{-----------------------------------------------------------------------------
  Procedure: TdxButton.Create
  Author:    mh
  Date:      21-Feb-2002
  Arguments: AOwner: TComponent
  Result:    None
-----------------------------------------------------------------------------}

constructor TdxButton.Create(AOwner: TComponent);
begin
  inherited;

  // set default properties.
  Height := 25;
  Width := 73;

  // set custom properties.
  FAutoGray := True;
  FCancel := False;
  FDefault := False;
  FImageIndex := -1;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FGlyph := TBitmap.Create;
  FHotTrack := False;
  FLayout := blGlyphLeft;
  FColors := TdxColors.Create(Self);
  FQuality := bqMiddle;
  FShowAccelChar := True;
  FShowFocusRect := True;
  FSpacing := 3;
  FWordWrap := True;

  // create ...
  FBgGradient := TBitmap.Create; // background gradient
  FCkGradient := TBitmap.Create; // clicked gradient
  FFcGradient := TBitmap.Create; // focused gradient
  FHlGradient := TBitmap.Create; // Highlight gradient
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.Destroy
  Author:    mh
  Date:      21-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TdxButton.Destroy;
begin
  FBgGradient.Free;
  FCkGradient.Free;
  FFcGradient.Free;
  FHlGradient.Free;
  FGlyph.Free;
  FColors.Free;
  FImageChangeLink.OnChange := nil;
  FImageChangeLink := nil;
  FImageChangeLink.Free;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.GetVersion
  Author:    mh
  Date:      09-Apr-2002
  Arguments: None
  Result:    string
-----------------------------------------------------------------------------}

function TdxButton.GetVersion: string;
begin
  Result := SVersion;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.GetActionLinkClass
  Author:    mh
  Date:      09-Apr-2002
  Arguments: None
  Result:    TControlActionLinkClass
-----------------------------------------------------------------------------}

function TdxButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TdxButtonActionLink;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.CMDialogKey
  Author:    mh
  Date:      22-Feb-2002
  Arguments: var Message: TCMDialogKey
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.CMDialogKey(var Message: TCMDialogKey);
begin
  inherited;
  with Message do
    if (((CharCode = VK_RETURN) and (Focused or (FDefault and not (IsSibling))))
      or ((CharCode = VK_ESCAPE) and FCancel) and (KeyDataToShiftState(KeyData) = []))
      and CanFocus then
    begin
      Click;
      Result := 1;
    end
    else
      inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetAutoGray
  Author:    mh
  Date:      12-Apr-2002
  Arguments: Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetAutoGray(Value: Boolean);
begin
  if Value <> FAutoGray then
  begin
    FAutoGray := Value;
    Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetDefault
  Author:    mh
  Date:      22-Feb-2002
  Arguments: Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetDefault(Value: Boolean);
begin
  if Value <> FDefault then
  begin
    FDefault := Value;
    with GetParentForm(Self) do
      Perform(CM_FOCUSCHANGED, 0, LongInt(ActiveControl));
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetGlyph
  Author:    mh
  Date:      22-Feb-2002
  Arguments: Value: TPicture
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetGlyph(Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetHotTrack
  Author:    mh
  Date:      29-Apr-2002
  Arguments: Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetHotTrack(Value: Boolean);
begin
  if Value <> FHotTrack then
  begin
    FHotTrack := Value;
    Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetLayout
  Author:    mh
  Date:      12-Apr-2002
  Arguments: Value: TdxLayout
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetLayout(Value: TdxLayout);
begin
  if Value <> FLayout then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetQuality
  Author:    mh
  Date:      22-Feb-2002
  Arguments: Value: TdxQuality
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetQuality(Value: TdxQuality);
begin
  if Value <> FQuality then
  begin
    FQuality := Value;
    HookResized;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetShowAccelChar
  Author:    mh
  Date:      22-Feb-2002
  Arguments: Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetShowAccelChar(Value: Boolean);
begin
  if Value <> FShowAccelChar then
  begin
    FShowAccelChar := Value;
    Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetShowFocusRect
  Author:    mh
  Date:      22-Feb-2002
  Arguments: Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetShowFocusRect(Value: Boolean);
begin
  if Value <> FShowFocusRect then
  begin
    FShowFocusRect := Value;
    Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetSpacing
  Author:    mh
  Date:      11-Apr-2002
  Arguments: Value: Integer
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetSpacing(Value: Byte);
begin
  if Value <> FSpacing then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.SetWordWrap
  Author:    mh
  Date:      29-Apr-2002
  Arguments: Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.SetWordWrap(Value: Boolean);
begin
  if Value <> FWordWrap then
  begin
    FWordWrap := Value;
    Invalidate;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.ImageListChange
  Author:    mh
  Date:      09-Apr-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.ImageListChange(Sender: TObject);
begin
  if Assigned(Action) and (Sender is TCustomImageList)
    and Assigned(TAction(Action).ActionList.Images)
    and ((TAction(Action).ImageIndex < (TAction(Action).ActionList.Images.Count))) then
    FImageIndex := TAction(Action).ImageIndex
  else
    FImageIndex := -1;
  Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.KeyDown
  Author:    mh
  Date:      22-Feb-2002
  Arguments: var Key: Word; Shift: TShiftState
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_SPACE) then
  begin
    DrawState := DrawState + [dsHighlight];
    HookMouseDown;
  end;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.KeyUp
  Author:    mh
  Date:      22-Feb-2002
  Arguments: var Key: Word; Shift: TShiftState
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.KeyUp(var Key: Word; Shift: TShiftState);
var
  cPos: TPoint;
begin
  //
  // It's not possible to call the 'HookMouseUp' or 'HookMouseLeave' methods,
  // because we don't want to call there event handlers.
  //
  if dsClicked in DrawState then
  begin
    GetCursorPos(cPos);
    cPos := ScreenToClient(cPos);
    if not PtInRect(Bounds(0, 0, Width, Height), cPos) then
      DrawState := DrawState - [dsHighlight];
    DrawState := DrawState - [dsClicked];
    Invalidate;
    Click;
  end;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.IsSpecialDrawState
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}

function TdxButton.IsSpecialDrawState(IgnoreDefault: Boolean = False): Boolean;
begin
  if dsClicked in DrawState then
    Result := not (dsHighlight in DrawState)
  else
    Result := (dsHighlight in DrawState) or (dsFocused in DrawState);
  if not IgnoreDefault then
    Result := Result or FDefault and not IsSibling;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.ActionChange
  Author:    mh
  Date:      09-Apr-2002
  Arguments: Sender: TObject; CheckDefaults: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if Assigned(TCustomAction(Sender).ActionList.Images) and
        (FImageChangeLink.Sender <> TCustomAction(Sender).ActionList.Images) then
        TCustomAction(Sender).ActionList.Images.RegisterChanges(FImageChangeLink);
      if (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
        FImageIndex := ImageIndex;
      Invalidate;
    end;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.HookResized
  Author:    mh
  Date:      22-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.HookResized;
var
  Offset, ColSteps: Integer;
  Dithering: Boolean;
begin
  inherited;

  // calculate quality.
  Dithering := FQuality = bqHigh;
  ColSteps := 16;
  if FQuality = bqLow then
    ColSteps := 8;
  if FQuality = bqHigh then
    ColSteps := 64;

  // calculate offset.
  Offset := 4 * (Integer(IsSpecialDrawState(True)));

  //
  // create gradient rectangles for...
  //

  // background.
  dxCreateGradientRect(Width - (2 + Offset), Height - (2 + Offset),
    FColors.BackgroundFrom,  FColors.BackgroundTo, ColSteps, gsTop, Dithering,
    FBgGradient);

  // clicked.
  dxCreateGradientRect(Width - 2, Height - 2, FColors.ClickedFrom,
    FColors.ClickedTo, ColSteps, gsTop, Dithering, FCkGradient);

  // focused.
  dxCreateGradientRect(Width - 2, Height - 2, FColors.FocusedFrom,
    FColors.FocusedTo, ColSteps, gsTop, Dithering, FFcGradient);

  // highlight.
  dxCreateGradientRect(Width - 2, Height - 2, FColors.HighlightFrom,
    FColors.HighlightTo, ColSteps, gsTop, Dithering, FHlGradient);

  // redraw.
  Invalidate;
end;

{-----------------------------------------------------------------------------
  Procedure: TdxButton.Paint
  Author:    mh
  Date:      21-Feb-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TdxButton.Paint;
var
  R: TRect;
  c, x, y: Integer;
  PxlColor: TColor;
  Offset, Flags: Integer;
  DrawPressed: Boolean;
  Image: TBitmap;
  Bitmap: TBitmap;
begin
  with Canvas do
  begin
    // clear background.
    R := GetClientRect;
    Brush.Color := Self.Color;
    FillRect(R);

    // draw gradient borders.
    if IsSpecialDrawState then
    begin
      Bitmap := TBitmap.Create;
      try
        if dsHighlight in DrawState then
          Bitmap.Assign(FHlGradient)
        else
          Bitmap.Assign(FFcGradient);
        BitBlt(Handle, 1, 1, Width, Height, Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
      finally
        Bitmap.Free;
      end;
    end;

    // draw background gradient...
    if not ((dsHighlight in DrawState) and (dsClicked in DrawState)) then
    begin
      Offset := 2 * Integer(IsSpecialDrawState);
      BitBlt(Handle, 1 + Offset, 1 + Offset, Width - 3 * Offset, Height - 3 * Offset,
        FBgGradient.Canvas.Handle, 0, 0, SRCCOPY);
    end
    // ...or click gradient.
    else
      BitBlt(Handle, 1, 1, Width, Height, FCkGradient.Canvas.Handle, 0, 0, SRCCOPY);

    // draw border lines.
    Pen.Color := FColors.BorderLine;
    Brush.Style := bsClear;
    RoundRect(0, 0, Width, Height, 5, 5);

    // draw border edges.
    Pen.Color := dxColor_BorderEdges;
    dxDrawLine(Canvas, 0, 1, 2, 0);
    dxDrawLine(Canvas, Width - 2, 0, Width, 2);
    dxDrawLine(Canvas, 0, Height - 2, 2, Height);
    dxDrawLine(Canvas, Width - 3, Height, Width, Height - 3);

    // set drawing flags.
    Flags := {DT_VCENTER or }DT_END_ELLIPSIS;
    if FWordWrap then
      Flags := Flags or DT_WORDBREAK;

    // draw image & caption.
    Image := TBitmap.Create;
    try
      // get image from action or glyph property.
      if Assigned(Action) and Assigned(TAction(Action).ActionList.Images) and
        (FImageIndex > -1) and (FImageIndex < TAction(Action).ActionList.Images.Count) then
        TAction(Action).ActionList.Images.GetBitmap(FImageIndex, Image)
      else
        Image.Assign(FGlyph);

      // autogray image (if allowed).
      if FAutoGray and not Enabled then
      for x := 0 to Image.Width - 1 do
        for y := 0 to Image.Height - 1 do
        begin
          PxlColor := ColorToRGB(Image.Canvas.Pixels[x, y]);
          c := Round((((PxlColor shr 16) + ((PxlColor shr 8) and $00FF) + (PxlColor and $0000FF)) div 3)) div 2 + 96;
          Image.Canvas.Pixels[x, y] := RGB(c, c, c);
        end;

      // assign canvas font (change HotTrack-Color, if necessary).
      Font.Assign(Self.Font);
      if (FHotTrack) and (dsHighlight in DrawState) then
        Font.Color := FColors.HotTrack;

      // calculate textrect.
      if not Image.Empty then
        case FLayout of
          blGlyphLeft:
            Inc(R.Left, Image.Width + FSpacing);
          blGlyphRight:
            begin
              Dec(R.Left, Image.Width + FSpacing);
              Dec(R.Right, (Image.Width + FSpacing) * 2);
              Flags := Flags or DT_RIGHT;
            end;
          blGlyphTop:
            Inc(R.Top, Image.Height + FSpacing);
          blGlyphBottom:
            Dec(R.Top, Image.Height + FSpacing);
        end;
      dxRenderText(Self, Canvas, Caption, Font, Enabled, FShowAccelChar, R, Flags or DT_CALCRECT);
      OffsetRect(R, (Width - R.Right) div 2, (Height - R.Bottom) div 2);

      // should we draw the pressed state?
      DrawPressed := (dsHighlight in DrawState) and (dsClicked in DrawState);
      if DrawPressed then
        OffsetRect(R, 1, 1);

      // draw image - if available.
      if not Image.Empty then
      begin
        Image.Transparent := True;
        case FLayout of
          blGlyphLeft:
            Draw(R.Left - (Image.Width + FSpacing), (Height - Image.Height) div 2 +
              Integer(DrawPressed), Image);
          blGlyphRight:
            Draw(R.Right + FSpacing, (Height - Image.Height) div 2 +
              Integer(DrawPressed), Image);
          blGlyphTop:
            Draw((Width - Image.Width) div 2 + Integer(DrawPressed),
              R.Top - (Image.Height + FSpacing), Image);
          blGlyphBottom:
            Draw((Width - Image.Width) div 2 + Integer(DrawPressed),
              R.Bottom + FSpacing, Image);
        end;
      end;

      // draw focusrect (if enabled).
      if (dsFocused in DrawState) and (FShowFocusRect) then
      begin
        Brush.Style := bsSolid;
        DrawFocusRect(Bounds(3, 3, Width - 6, Height - 6));
      end;

      // draw caption.
      SetBkMode(Handle, Transparent);
      dxRenderText(Self, Canvas, Caption, Font, Enabled, FShowAccelChar, R, Flags);
    finally
      Image.Free;
    end;
  end;
end;

end.

