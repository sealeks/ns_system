{*******************************************************}
{                                                       }
{       ���������� ��������� ���������� ��������        }
{                                                       }
{                    ������ 1.19                        }
{                                                       }
{          Copyright (C) 2007. ������ �����             }
{                                                       }
{ ������ �������������:                                 }
{   ���� ����� (ikirov@bars-it.ru)                      }
{   ������ ���������� (sega-zero@yandex.ru)             }
{   ������ ������� (max@papillon.ru)                    }
{                                                       }
{*******************************************************}

unit GsvObjectInspectorGrid;

interface

uses
  Messages, Windows, Classes, SysUtils, Controls, StdCtrls, Forms,
  Graphics, ExtCtrls, Mask,
  GsvObjectInspectorTypes;

const
  WM_GSV_OBJECT_INSPECTOR_SHOW_DIALOG = WM_USER;

type
  // ����������� ����������� �������
  TGsvCustomObjectInspectorGrid    = class;
  TGsvObjectInspectorInplaceEditor = class;

  // ������, �������� ������� ����������� ������� ������� ���������� ������
  TGsvObjectInspectorHistory = class
  private
    FExpanded: array of Integer; // ������� �������, � ������� Expanded = True
    FCount:    Integer; // ������� ����� ������� � �������

  public
    Selected: Integer;
    TopRow:   Integer;

    constructor Create;
    destructor  Destroy; override;
    procedure   Clear;
    procedure   Add(Index: Integer);
    function    Expanded(Index: Integer): Boolean;
    function    ToString(const aName: string): string;
    function    FromString(const aData: string): string;
  end;

  // ������ ������������ ���� ������� �������
  TGsvObjectInspectorProperties = class
  private
    FInspector: TGsvCustomObjectInspectorGrid;
    FItems:     array of TGsvObjectInspectorPropertyInfo;
    FCount:     Integer;
    FHistory:   TStringList; // ������� ������ ����� ����� �������������� ��������
                             // � ��������� �� �� �������
    FCurrentHistory: TGsvObjectInspectorHistory; // ��������� �� ������� ������ �������

    function GetItem(AIndex: Integer): PGsvObjectInspectorPropertyInfo;
    function HistoryName: String;

  public
    constructor Create(AInspector: TGsvCustomObjectInspectorGrid);
    destructor  Destroy; override;
    procedure   FillHistory(aHistory: TGsvObjectInspectorHistory);
    procedure   Clear;
    procedure   Add(Info: PGsvObjectInspectorPropertyInfo);
    function    TopRow: Integer;
    function    Selected: Integer;
    procedure   ExpandAll(Value: Boolean);
    function    SetLayout(const aData: string;
                out aTopRow, aSelected: Integer): Boolean;
    function    SetSelected(const aName: string): Integer;
    property    Count: Integer read FCount;
    property    Items[AIndex: Integer]: PGsvObjectInspectorPropertyInfo
                read GetItem; default;
  end;

  // ���� ��� ����������� ��������� ��� ������� �����
  TGsvObjectInspectorHintWindow = class(TCustomControl)
  public
    constructor Create(AOwner: TComponent); override;

  private
    FInspector:   TGsvCustomObjectInspectorGrid;
    FMinShowTime: Cardinal; // ����������� ����� ������ ����� (��� 0)
    FMinHideTime: Cardinal; // ����������� ����� ������� �����
    FHideTime:    Cardinal; // ����� ������� �����
    FTextOffset:  Integer;  // �������� ������ ����� �� ������ ����
    FTimer:       TTimer;   // ������ ��� ���������� ������

    procedure ActivateHint(const Rect: TRect; const AText: String;
              IsEditHint: Boolean);
    procedure HideLongHint(HardHide: Boolean = False);
    procedure OnTimer(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
              X, Y: Integer); override;
  public
    function  CanFocus: Boolean; override;
  end;

  // ��������� ����������� ������ �����
  TGsvObjectInspectorListBox = class(TCustomListBox)
  public
    constructor Create(AOwner: TComponent); override;

  private
    FEditor: TGsvObjectInspectorInplaceEditor;

    procedure HideList(Accept: Boolean);

    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMRButtonUp(var Message: TWMRButtonDown); message WM_RBUTTONUP;
    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMMButtonUp(var Message: TWMMButtonDown); message WM_MBUTTONUP;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
              X, Y: Integer); override;
  end;

  // ������������� �������� �������� ��������. ����� ���� �������������� �
  // ��������� �������������� ������ � ����������� ������� ������ ��� �������
  TGsvObjectInspectorInplaceEditor = class(Mask.TCustomMaskEdit)
  public
    constructor Create(AOwner: TComponent); override;

  private
    // ����������� ����������
    FInspector:     TGsvCustomObjectInspectorGrid;
    FPropertyInfo:  PGsvObjectInspectorPropertyInfo; // ���������� �������������� ��������
    FListBox:       TGsvObjectInspectorListBox;      // ���� ����������� ������ �����
    FButtonWidth:   Integer; // ������ ������
    FPressed:       Boolean; // ��� �������������� ������ - ������ ��� ��������
    FWasPressed:    Boolean; // ������ ���� ������, �� ��� �� ��������
    FLockModify:    Boolean; // ���������� ����������� ������
    FDropDownCount: Integer; // ����������������� ������ ����������� ������

    procedure SetNewEditText(const Value: String);
    procedure ShowEditor(ALeft, ATop, ARight, ABottom: Integer;
              Info: PGsvObjectInspectorPropertyInfo;
              const Value: String);
    procedure HideEditor;
    procedure ShowEditHint;
    procedure ShowValueHint;
    procedure DropDown;
    procedure CloseUp(Accept: Boolean);
    procedure ListItemChanged;
    procedure SetListItem(Index: Integer);
    procedure ShowDialog;
    procedure ValidateStringValue(const Value: String);


    // ������� Windows
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;

  protected
    // ���������������� ������ �������� ������
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure PaintWindow(DC: HDC); override;
    procedure DoExit; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function  DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint):
              Boolean; override;
    function  DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint):
              Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Change; override;
    procedure ValidateError; override;

  public
    procedure ValidateEdit; override;
  end;

  // ���� ������������ ������� ��� ���������� ��������

  { ��� ����������� ��� ������������ ���� ������� ��������������� �������.
    ���������� ������� ����� ���� ������� ��������� ����������� ����������
    ��������, ������ �������� ���������� � ��������� Index. ������������
    ���������� � ������� 0, ������ ��� ������ ����������� ������ ������
    ����������������. ���� ��� �������� ����������� � ������ ����������
    �������� ��������� �� �������� �� ���������, �� ���������� �������
    ���������� nil. ������� ��������� ����������� ����� �������� Info }
  TGsvObjectInspectorEnumPropertiesEvent = procedure(Sender: TObject;
    Index: Integer; out Info: PGsvObjectInspectorPropertyInfo) of object;

  { ��� ����������� ��� ��������� ���������� ������������� �������� ��������.
    ���������� ����� ���� ������ �������� �������������� �������� ��������
    ��������������� �������, ������������� � ��������� ������������� �
    ��������� ��� ��������� Value }
  TGsvObjectInspectorGetStringValueEvent = procedure(Sender: TObject;
    Info: PGsvObjectInspectorPropertyInfo; out Value: String) of object;

  { ��� ����������� ��� ��������� �������� �������� �� ��� ����������
    �������������. ���������� ����� ���� ������ ������������� ���������
    ������������� �������� � ��������������� ���� �������� � ����������
    ��� � �������������� �������. ���� � �������� �������������� ��������
    ������, �� ���������� ������ �������������� ��������� �����-���� ��������,
    ��������, ������������ ������, �������� �������� ������, �������� ���������
    � ���� �������, ���������� � ������ ������� � �.�. }
  TGsvObjectInspectorSetStringValueEvent = procedure(Sender: TObject;
    Info: PGsvObjectInspectorPropertyInfo; const Value: String) of object;

  { ��� ���� ���� ������� ����������, �� ������������ ���
    ������ � ������������� �������������� �������� �������� }
  TGsvObjectInspectorGetIntegerValueEvent = procedure(Sender: TObject;
    Info: PGsvObjectInspectorPropertyInfo; out Value: LongInt) of object;
  TGsvObjectInspectorSetIntegerValueEvent = procedure(Sender: TObject;
    Info: PGsvObjectInspectorPropertyInfo; const Value: LongInt) of object;

  { ��� ����������� ��� ��������� ������ ��������� �������� ��������.
    ���������� ����� ���� ������ ��������� ������ List }
  TGsvObjectInspectorFillListEvent = procedure(Sender: TObject;
    Info: PGsvObjectInspectorPropertyInfo; List: TStrings) of object;

  { ��� ����������� ��� ������ �������-�������, ������� ����� ���������
    ��������� ���������� ���������� ��� �������������� �������� }
  TGsvObjectInspectorShowDialogEvent = procedure(Inspector: TComponent;
    Info: PGsvObjectInspectorPropertyInfo; const EditRect: TRect) of object;

  { ��� ����������� ��� ����������� ���������� �� �������� }
  TGsvObjectInspectorInfoEvent = procedure(Sender: TObject;
    Info: PGsvObjectInspectorPropertyInfo) of object;

  { ��� ����������� ��� �������������� �������� �������� }
  TGsvObjectInspectorGetCaptionEvent = procedure(Sender: TObject;
    Info: PGsvObjectInspectorPropertyInfo; var aCaption: string) of object;

  TGsvObjectInspectorTreeChangeType = (tctNone, tctChange, tctCollapse,
                                       tctExpand);

  // ���������� ������� ��������� ���������� ��������
  TGsvCustomObjectInspectorGrid = class(TCustomControl)
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

  private
    // ����������� ����������
    FProperties:       TGsvObjectInspectorProperties;    // ������ ������������ ������� ��������������� �������
    FEditor:           TGsvObjectInspectorInplaceEditor; // �������� ��������
    FHintWindow:       TGsvObjectInspectorHintWindow;    // ���� ����� ������� �����
    FRows:             array of PGsvObjectInspectorPropertyInfo; // ������ ����������
    FGlyphs:           TBitmap; // ����������� ������
    FRowsCount:        Integer; // ����� ������������ �������
    FTopRow:           Integer; // ������ �������� ������������� ��������
    FSelected:         Integer; // ������ ����������� ��������
    FMouseDivPos:      Integer; // ������� ����� ��� ����������� ����� �����������
    FFontHeight:       Integer; // ������ ������ � ��������
    FLevelIndent:      Integer; // ������ ������ � ��������
    FInvalidateLock:   Boolean; // ���������� ������� SmartInvalidate
                                // � ��� ������, ���� ������� ����������
                                // �������, ��� ����� ���� ����������

    // ��������
    FBorderStyle:      TBorderStyle; // ����� �����
    FRowHeight:        Integer;      // ������ ������ ����������, ��������
                                     // ���������� �� �������� ������
    FDividerPosition:  Integer;      // ������� ����� ����������� �������
    FFolderFontColor:  TColor;       // ���� ������ �����
    FFolderFontStyle:  TFontStyles;  // ����� ������ �����
    FLongTextHintTime: Cardinal;     // ����� ����������� ����� ������� �����.
                                     // ���� 0, �� �� ���������� �����
    FLongEditHintTime: Cardinal;     // ����� ����������� ����� ��� ��������������.
                                     // ���� 0, �� �� ���������� �����
    FAutoSelect:       Boolean;      // �������� �� ���� ����� � ��������� ��������
                                     // ��� �������� � ����?
    FMaxTextLength:    Integer;      // ������������ ����� ������ ��������
    FDropDownCount:    Integer;      // ����� ����� ����������� ������
    FHideReadOnly:     Boolean;      // ���������� ��� ��������. ���� ����
                                     // ���� ����� True, �� �������� ����
                                     // pkReadOnlyText �� ������������

    // ������ ��������� �������
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetRowHeight(const Value: Integer);
    procedure SetDividerPosition(const Value: Integer);
    procedure SetFolderFontColor(const Value: TColor);
    procedure SetFolderFontStyle(const Value: TFontStyles);
    procedure SetLongTextHintTime(const Value: Cardinal);
    procedure SetLongEditHintTime(const Value: Cardinal);
    procedure SetMaxTextLength(const Value: Integer);
    procedure SetHideReadOnly(const Value: Boolean);
    function  GetLayout: string;
    procedure SetLayout(const Value: string);

    // ������� Windows
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMShowDialog(var Message: TMessage);
              message WM_GSV_OBJECT_INSPECTOR_SHOW_DIALOG;
    procedure WMHelp(var aMessage: TMessage); message WM_HELP;

    // ��������������� ������
    function  DividerHitTest(X: Integer): Boolean;
    procedure EnumProperties;
    procedure CreateRows;
    procedure UpdateScrollBar;
    procedure ShowLongHint(const Rect: TRect; const AText: String;
              IsEditHint: Boolean = False);
    procedure HideLongHint(HardHide: Boolean = False);
    procedure ShowEditor;
    procedure HideEditor;
    procedure UpdateEditor;
    procedure UpdateFocus;
    procedure SetTopRow(ATopRow: Integer);
    procedure SetSelectedRow(ARow: Integer);
    procedure SetSelectedRowByMouse(X, Y: Integer);
    procedure ChangeBoolean(Info: PGsvObjectInspectorPropertyInfo);
    procedure ExpandingOrChangeBoolean(ExpandingOnly: Boolean;
              ChangeType: TGsvObjectInspectorTreeChangeType);

    // �������������� ��������������� ������ ��� ���� ��������������
    procedure SetSelectedRowByKey(Key: Word);
    procedure ValueChanged(Info: PGsvObjectInspectorPropertyInfo;
              const Value: String);

  protected
    // ��������� �������
    FOnEnumProperties:  TGsvObjectInspectorEnumPropertiesEvent;
    FOnGetStringValue:  TGsvObjectInspectorGetStringValueEvent;
    FOnSetStringValue:  TGsvObjectInspectorSetStringValueEvent;
    FOnGetIntegerValue: TGsvObjectInspectorGetIntegerValueEvent;
    FOnSetIntegerValue: TGsvObjectInspectorSetIntegerValueEvent;
    FOnFillList:        TGsvObjectInspectorFillListEvent;
    FOnShowDialog:      TGsvObjectInspectorShowDialogEvent;
    FOnHelp:            TGsvObjectInspectorInfoEvent;
    FOnHint:            TGsvObjectInspectorInfoEvent;
    FOnGetCaption:      TGsvObjectInspectorGetCaptionEvent;

    // ���������������� ������ �������� ������
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Resize; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
              X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
              X, Y: Integer); override;
    function  DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint):
              Boolean; override;
    function  DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint):
              Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    // ���������� �������
    function  DoGetStringValue(Info: PGsvObjectInspectorPropertyInfo):
              String; virtual;
    procedure DoSetStringValue(Info: PGsvObjectInspectorPropertyInfo;
              const Value: String); virtual;
    function  DoGetIntegerValue(Info: PGsvObjectInspectorPropertyInfo):
              LongInt; virtual;
    procedure DoSetIntegerValue(Info: PGsvObjectInspectorPropertyInfo;
              const Value: LongInt); virtual;
    procedure DoShowDialog; virtual;
    procedure DoFillList(Info: PGsvObjectInspectorPropertyInfo;
              List: TStrings); virtual;
    procedure DoHelp; virtual;
    procedure DoHint(Info: PGsvObjectInspectorPropertyInfo); virtual;
    function  DoGetCaption(Info: PGsvObjectInspectorPropertyInfo): string; virtual;

    // �������� ��� ��������������� � �������-��������
    property  BorderStyle: TBorderStyle read FBorderStyle
              write SetBorderStyle default bsSingle;
    property  RowHeight: Integer read FRowHeight
              write SetRowHeight;
    property  DividerPosition: Integer read FDividerPosition
              write SetDividerPosition;
    property  FolderFontColor: TColor read FFolderFontColor
              write SetFolderFontColor default clBtnText;
    property  FolderFontStyle: TFontStyles read FFolderFontStyle
              write SetFolderFontStyle default [fsBold];
    property  LongTextHintTime: Cardinal read FLongTextHintTime
              write SetLongTextHintTime default 3000;
    property  LongEditHintTime: Cardinal read FLongEditHintTime
              write SetLongEditHintTime default 3000;
    property  AutoSelect: Boolean read FAutoSelect
              write FAutoSelect default True;
    property  MaxTextLength: Integer read FMaxTextLength
              write SetMaxTextLength default 256;
    property  DropDownCount: Integer read FDropDownCount
              write FDropDownCount default 8;
    property  HideReadOnly: Boolean read FHideReadOnly
              write SetHideReadOnly default False;

    // ������� ��� ��������������� � �������-��������
    property  OnEnumProperties: TGsvObjectInspectorEnumPropertiesEvent
              read FOnEnumProperties write FOnEnumProperties;
    property  OnGetStringValue: TGsvObjectInspectorGetStringValueEvent
              read FOnGetStringValue write FOnGetStringValue;
    property  OnSetStringValue: TGsvObjectInspectorSetStringValueEvent
              read FOnSetStringValue write FOnSetStringValue;
    property  OnGetIntegerValue: TGsvObjectInspectorGetIntegerValueEvent
              read FOnGetIntegerValue write FOnGetIntegerValue;
    property  OnSetIntegerValue: TGsvObjectInspectorSetIntegerValueEvent
              read FOnSetIntegerValue write FOnSetIntegerValue;
    property  OnFillList: TGsvObjectInspectorFillListEvent
              read FOnFillList write FOnFillList;
    property  OnShowDialog: TGsvObjectInspectorShowDialogEvent
              read FOnShowDialog write FOnShowDialog;
    property  OnHelp: TGsvObjectInspectorInfoEvent
              read FOnHelp write FOnHelp;
    property  OnHint: TGsvObjectInspectorInfoEvent
              read FOnHint write FOnHint;
    property  OnGetCaption: TGsvObjectInspectorGetCaptionEvent
              read FOnGetCaption write FOnGetCaption;

  public
    procedure NewObject;
    procedure Clear;
    procedure AcceptChanges;
    procedure SmartInvalidate;
    procedure ExpandAll;
    procedure CollapseAll;
    function  InplaceEditor: TCustomEdit;
    function  SelectedLeftBottom: TPoint;
    function  SelectedCenter: TPoint;
    function  SelectedInfo: PGsvObjectInspectorPropertyInfo;
    function  SelectedText: string;
    procedure SetSelected(const aName: string);
    procedure ValidateStringValue(const Value: String);
    property  Layout: string read GetLayout write SetLayout;
  end;

  TGsvObjectInspectorGrid = class(TGsvCustomObjectInspectorGrid)
  published
    // ����������� �������� �� TCustomControl � ��� ���������
    property Align;
    property Anchors;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BevelKind;
    property Constraints;
    property Ctl3D;
    property ParentCtl3D;
    property Enabled;
    property ParentFont;
    property Font;
    property TabStop;
    property TabOrder;
    property Visible;

    // ����������� �������� �� TGsvCustomObjectInspectorGrid
    property BorderStyle;
    property RowHeight;
    property DividerPosition;
    property FolderFontColor;
    property FolderFontStyle;
    property LongTextHintTime;
    property LongEditHintTime;
    property AutoSelect;
    property MaxTextLength;
    property DropDownCount;
    property HideReadOnly;

    // ����������� ������� �� TCustomControl � ��� ���������
    property OnContextPopup;
    property OnEnter;
    property OnExit;
    property OnResize;

    // ����������� ������� �� TGsvCustomObjectInspectorGrid
    property OnEnumProperties;
    property OnGetStringValue;
    property OnSetStringValue;
    property OnGetIntegerValue;
    property OnSetIntegerValue;
    property OnFillList;
    property OnShowDialog;
    property OnHelp;
    property OnHint;
    property OnGetCaption;
  end;

procedure Register;

implementation

{$R GsvObjectInspectorButtons.res}

uses
  Math, RTLConsts;

procedure Register;
begin
  RegisterComponents('Immi', [TGsvObjectInspectorGrid]);
end;

const
  DIVIDER_LIMIT     = 30;  // ����������� �������� ������ ������� ����������
  BUTTON_POINT_SIZE = 2;   // ������ ����� ��� ������������ ������ pkDialog
  VALUE_LEFT_MARGIN = 1;   // ������ �� ������ ���� ��� ������ ������ ��������
  GLYPH_MAGRIN      = 1;   // ������ �� ����� ������������ ������ ������������ ������
  GLYPH_TREE_SIZE   = 9;   // ������ ������� + � - ������
  GLYPH_CHECK_SIZE  = 11;  // ������ ������� CheckBox'a
  HINT_TEXT_OFFSET  = 16;  // �������� ������ ����� � ������ ��������������
  PROP_LIST_DELTA   = 32;  // ������, �� ������� ����� ������������� ������ ��������
  HISTORY_DELTA     = 8;   // ������, �� ������� ����� ������������� ������ �������
  COLOR_RECT_WIDTH  = 20;  // ������ �������� ��������������
  COLOR_RECT_HEIGHT = 9;   // ������ �������� ��������������
  TEXT_LIMIT        = 200; // ����� ������ ������. ��� ���������� ��� ��������� � ...
  VK_OEM_MINUS      = $BD;
  VK_OEM_PLUS       = $BB;


// ������������ ��������� ��������� �������
type
  TGsvKindSelector = (
    _EDITOR,         // �������� ����� ��������
    _BUTTON,         // �������� ����� �������� � �������
    _READONLY,       // �������� ������ ��� ������
    _INPUT_TEXT,     // �������� � ���������� �������� �� ���������� �������������
    _LIST,           // �������� ����� ������
    _DIALOG,         // �������� ����� ������ �������-�������
    _INTEGER         // �������� ����� ������������� �������������
  );

function HAS(That: TGsvKindSelector; Info: PGsvObjectInspectorPropertyInfo):
  Boolean;
const
  DSK: array[TGsvObjectInspectorPropertyKind, TGsvKindSelector] of Boolean = (
    {                 EDITOR BUTTON READON INPUT  LIST   DIALOG INTEG}
    {None}           (False, False, False, False, False, False, False ),
    {Text}           (True,  False, False, True,  False, False, False ),
    {DropDownList}   (True,  True,  True,  True,  True,  False, True  ),
    {Dialog}         (True,  True,  True,  False, False, True,  False ),
    {Folder}         (False, False, True,  False, False, False, False ),
    {ReadOnlyText}   (False, False, True,  False, False, False, False ),
    {Boolean}        (False, False, False, False, False, False, True  ),
    {ImmediateText}  (True,  False, False, True,  False, False, False ),
    {TextList}       (True,  True,  False, True,  True,  False, False ),
    {Set}            (True,  False, True,  False, False, False, True  ),
    {Color}          (True,  True,  True,  True,  True,  False, True  ),
    {ColorRGB}       (True,  True,  False, True,  False, True,  True  ),
    {Float}          (True,  False, False, True,  False, False, False ),
    {TextDialog}     (True,  True,  False, True,  False, True,  False )
  );
begin
  if Assigned(Info) then Result := DSK[Info^.Kind, That]
  else                   Result := False;
end;

function TextWithLimit(const s: String): String;
begin
  Result := s;
  if Length(Result) > TEXT_LIMIT then begin
    SetLength(Result, TEXT_LIMIT);
    Result := Result + '...';
  end;
end;

{ TGsvObjectInspectorHistory }

constructor TGsvObjectInspectorHistory.Create;
begin
  SetLength(FExpanded, HISTORY_DELTA);
  Clear;
end;

destructor TGsvObjectInspectorHistory.Destroy;
begin
  FExpanded := nil;
  inherited;
end;

procedure TGsvObjectInspectorHistory.Clear;
begin
  Selected := -1;
  FCount   := 0;
end;

// ���������� ������� ��������, � �������� Expanded = True.
// ������� ����������� � ������� �����������
procedure TGsvObjectInspectorHistory.Add(Index: Integer);
begin
  // ���� ����������, �� ���������� ������� �������
  if FCount > High(FExpanded) then
    SetLength(FExpanded, Length(FExpanded) + HISTORY_DELTA);
  FExpanded[FCount] := Index;
  Inc(FCount);
end;

// �������� ����� � ������������� ������� ��������
function TGsvObjectInspectorHistory.Expanded(Index: Integer): Boolean;
var
  L, H, I: Integer;
begin
  Result := False;
  L      := 0;
  H      := FCount - 1;
  while L <= H do begin
    I := (L + H) shr 1;
    if FExpanded[I] < Index then
      L := I + 1
    else begin
      H := I - 1;
      if FExpanded[I] = Index then begin
        Result := True;
        Break;
      end;
    end;
  end;
end;


function TGsvObjectInspectorHistory.ToString(const aName: string): string;
var
  lst: TStringList;
  i:   Integer;
begin
  Result := '';
  lst    := TStringList.Create;
  try
    lst.Add(aName);
    lst.Add(IntToStr(TopRow));
    lst.Add(IntToStr(Selected));
    for i := 0 to Pred(FCount) do
      lst.Add(IntToStr(FExpanded[i]));
    Result := lst.CommaText;
  finally
    lst.Free;
  end;
end;

function TGsvObjectInspectorHistory.FromString(const aData: string): string;
var
  lst: TStringList;
  i:   Integer;
begin
  Result := '';
  lst    := TStringList.Create;
  try
    lst.CommaText := aData;
    if lst.Count >= 3 then begin
      FCount := lst.Count - 3;
      SetLength(FExpanded, FCount);
      TopRow   := StrToIntDef(lst.Strings[1], 0);
      Selected := StrToIntDef(lst.Strings[2], -1);
      for i := 3 to Pred(lst.Count) do
        FExpanded[i - 3] := StrToIntDef(lst.Strings[i], -1);
      Result := lst.Strings[0];
    end;
  finally
    lst.Free;
  end;
end;

{ TGsvObjectInspectorProperties }

function TGsvObjectInspectorProperties.GetItem(
  AIndex: Integer): PGsvObjectInspectorPropertyInfo;
begin
  Assert((AIndex >= 0) and (AIndex < FCount));
  Result := @FItems[AIndex];
end;

function TGsvObjectInspectorProperties.HistoryName: String;
var
  obj: TObject;
begin
  Result := '';
  if Length(FItems) = 0 then
    Exit;
  obj := FItems[0].TheObject;
  if not Assigned(obj) then
    Exit;
  Result := obj.ClassName;
  if FInspector.FHideReadOnly then
    Result := Result + '_HRO';
end;

constructor TGsvObjectInspectorProperties.Create(
  AInspector: TGsvCustomObjectInspectorGrid);
begin
  inherited Create;
  FInspector := AInspector;
  SetLength(FItems, PROP_LIST_DELTA);
  FHistory            := TStringList.Create;
  FHistory.Sorted     := True;
  FHistory.Duplicates := dupIgnore;
end;

destructor TGsvObjectInspectorProperties.Destroy;
var
  i: Integer;
begin
  for i := 0 to Pred(FHistory.Count) do
    FHistory.Objects[i].Free;
  FHistory.Free;
  FItems := nil;
  inherited;
end;

procedure TGsvObjectInspectorProperties.FillHistory(aHistory:
  TGsvObjectInspectorHistory);
var
  i: Integer;
begin
  // ��������� � ������ ������� ���� ������� � Expanded = True
  for i := 0 to Pred(FCount) do
    if FItems[i].HasChildren and FItems[i].Expanded then
      aHistory.Add(i);
  aHistory.TopRow   := FInspector.FTopRow;
  aHistory.Selected := FInspector.FSelected;
end;

procedure TGsvObjectInspectorProperties.Clear;
var
  nm:  String;
  ind: Integer;
  lst: TGsvObjectInspectorHistory;
begin
  FCurrentHistory := nil;
  if FCount = 0 then
    Exit;
  // ����� �������� ��������� ������� �������, � ������� Expanded = True
  nm := HistoryName;
  if nm <> '' then begin
    ind := -1;
    // ���� � ������� ����� � ������� ������, ���� ��� ���, �� ������� �����
    if not FHistory.Find(nm, ind) then begin
      // ��������� � ������� ����� ����� � ������� ��� ���� ������
      FHistory.AddObject(nm, TGsvObjectInspectorHistory.Create);
      FHistory.Find(nm, ind);
    end;
    Assert((ind >= 0) and (ind < FHistory.Count));
    lst := FHistory.Objects[ind] as TGsvObjectInspectorHistory;
    lst.Clear;
    FillHistory(lst);
  end;
  FCount := 0;
end;

// ���������� ������ �������� � ������ ������� �������
procedure TGsvObjectInspectorProperties.Add(
  Info: PGsvObjectInspectorPropertyInfo);
var
  i: Integer;
begin
  if not Assigned(Info) then
    Exit;
  if not Assigned(Info^.TheObject) then
    Exit;
  if Info^.Level < 0 then
    Exit;
  if FCount = 0 then
    FCurrentHistory := nil
  else if Info^.Level > (FItems[FCount - 1].Level + 1) then
    Exit;
  if FCount > High(FItems) then
    SetLength(FItems, Length(FItems) + PROP_LIST_DELTA);
  FItems[FCount]             := Info^;
  FItems[FCount].HasChildren := False;
  FItems[FCount].Expanded    := False;
  if FCount <> 0 then begin
    if Info^.Level > FItems[FCount - 1].Level then begin
      // �������� ����� ��������, ����� �� ������� ��� ����������
      FItems[FCount - 1].HasChildren := True;
      if Assigned(FCurrentHistory) then
        FItems[FCount - 1].Expanded := FCurrentHistory.Expanded(FCount - 1);
    end;
  end
  else begin
    // ���� � ������� ����� � ��� �� ������ � �������� ������ ��� ����������� �������
    if FHistory.Find(HistoryName, i) then
      FCurrentHistory := FHistory.Objects[i] as TGsvObjectInspectorHistory
  end;
  Inc(FCount);
end;

function TGsvObjectInspectorProperties.TopRow: Integer;
begin
  if Assigned(FCurrentHistory) then
    Result := FCurrentHistory.TopRow
  else
    Result := -1;
end;

function TGsvObjectInspectorProperties.Selected: Integer;
begin
  if Assigned(FCurrentHistory) then
    Result := FCurrentHistory.Selected
  else
    Result := 0;
end;


procedure TGsvObjectInspectorProperties.ExpandAll(Value: Boolean);
var
  i: Integer;
begin
  for i := 0 to Pred(FCount) do
    if FItems[i].HasChildren then
      FItems[i].Expanded := Value;
end;

function TGsvObjectInspectorProperties.SetLayout(const aData: string;
  out aTopRow, aSelected: Integer): Boolean;
var
  h: TGsvObjectInspectorHistory;
  i: Integer;
begin
  Result    := False;
  aTopRow   := -1;
  aSelected := -1;
  h := TGsvObjectInspectorHistory.Create;
  try
    if h.FromString(aData) = HistoryName then begin
      aTopRow   := h.TopRow;
      aSelected := h.Selected;
      Result    := (aTopRow >= 0) and (aSelected >= 0);
      if Result then begin
        for i := 0 to Pred(FCount) do begin
          if FItems[i].HasChildren then
            FItems[i].Expanded := h.Expanded(i);
        end;
      end;
    end;
  finally
    h.Free;
  end;
end;

function TGsvObjectInspectorProperties.SetSelected(
  const aName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Pred(FCount) do begin
    if FItems[i].HasChildren then
      FItems[i].Expanded := True;
    if FItems[i].Name = aName then begin
      Result := i;
      Break;
    end;
  end;
end;

{ TGsvObjectInspectorHintWindow }

constructor TGsvObjectInspectorHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle       := ControlStyle + [csOpaque];
  FInspector         := AOwner as TGsvCustomObjectInspectorGrid;
  Parent             := FInspector;
  ParentColor        := True;
  ParentCtl3D        := True;
  Color              := FInspector.Color;
  Canvas.Brush.Color := clInfoBk;
  Canvas.Font        := FInspector.Font;
  Canvas.Font.Color  := clInfoText;
  ShowHint           := False;
  TabStop            := False;
  Visible            := False;
  DoubleBuffered     := True;  // ���������� �������� ��� ��������� ������
  FTimer             := TTimer.Create(Self);
  FTimer.Enabled     := False;
  FTimer.Interval    := 100;
  FTimer.OnTimer     := OnTimer;
end;

// ����������� �����. �������� IsEditHint ����� True ��� ������
// ������������� ����� ��� �������������� ������� ������
procedure TGsvObjectInspectorHintWindow.ActivateHint(const Rect: TRect;
  const AText: String; IsEditHint: Boolean);
var
  r:  TRect;
  p0: TPoint;
  dx: Integer;
const
  MIN_TIME = 300;
begin
  // ������ ������ ��� ����������� ����������� ������ ���������
  if Assigned(FInspector.FEditor) then begin
    if Assigned(FInspector.FEditor.FListBox) then
      if FInspector.FEditor.FListBox.Visible then
        Exit;
  end;
  // ��������� ����������� ����������� �����
  if FMinShowTime <> 0 then begin
    if GetTickCount < FMinShowTime then
      Exit;
  end;
  FMinShowTime := 0;
  if IsRectEmpty(Rect) or (AText = '') then
    HideLongHint
  else begin
    // ���� ����� ����������� ����� ������ MIN_TIME, �� ���� ������ �� ����������
    if IsEditHint then begin
      if FInspector.FLongEditHintTime < MIN_TIME then
        Exit;
      FTextOffset := HINT_TEXT_OFFSET;
      FHideTime   := GetTickCount + FInspector.FLongEditHintTime;
    end
    else begin
      if FInspector.FLongEditHintTime < MIN_TIME then
        Exit;
      FTextOffset := 0;
      FHideTime   := GetTickCount + FInspector.FLongTextHintTime;
    end;
    // ������ ��������� ���� �����
    p0 := FInspector.ClientToScreen(Point(0, 0));
    SetRect(r, p0.X + Rect.Left, p0.Y + Rect.Top,
      p0.X + Rect.Right, p0.Y + Rect.Bottom);
    // ������������� �� �������� ������
    dx := r.Right - Screen.Width;
    if dx > 0 then begin
      Dec(r.Left, dx);
      Dec(r.Right, dx);
    end;
    Dec(r.Left, FTextOffset);
    if r.Left < 0 then
      r.Left := 0;
    SetBounds(r.Left, r.Top, r.Right - r.Left, r.Bottom - r.Top);
    Hint := AText;
    // ���� ���� ������������ ��� ����������� ������������� ������,
    // �� ���������� ���� �����, � ����� � ��������� ���
    // �������������� ��������� ������� ������. �������� �����������
    // �� ���� ��� �������
    if IsEditHint then begin
      if not Visible then
        Show;
      Invalidate;
      // ���������� ��������� ���� �� ������ �����, ����� �� ��
      // ����� ��������������
      Mouse.CursorPos := ClientToScreen(Point(FTextOffset div 2, 6));
      Cursor          := crUpArrow;
    end;
    // ��������� ������
    FTimer.Tag     := 1;
    FTimer.Enabled := True;
    FMinHideTime   := GetTickCount + 200;
  end;
end;

// ������� �����. ���� �������� �������� ������ ����� HardHide ����� True,
// �� ���������� ���� ��� �������� ������������ �������
procedure TGsvObjectInspectorHintWindow.HideLongHint(HardHide: Boolean);
begin
  // ������������ ����������� �������
  if not HardHide and (GetTickCount < FMinHideTime) then
    Exit;
  FTimer.Enabled := False;
  FTimer.Tag     := 0;
  if Visible then begin
    Hide;
    Hint        := '';
    FTextOffset := 0;
    Cursor      := crDefault;
  end;
  // ���� ������� �����, �� ��������� ��������� ���������� ����� �� 2 ���
  if HardHide then
    FMinShowTime := GetTickCount + 2000;
end;

// ���������� ������� �����. ������ �������� � ���������� 0.1 ���
procedure TGsvObjectInspectorHintWindow.OnTimer(Sender: TObject);
begin
  if PtInRect(GetClientRect, ScreenToClient(Mouse.CursorPos)) then begin
    // ���������� ����
    if FTimer.Tag = 1 then begin
      FTimer.Tag := 2;
      if not Visible then
        Show;
      Invalidate;
      Exit;
    end;
    // ��������� ��������� ������� ������ �����
    if FTimer.Tag = 2 then begin
      if GetTickCount < FHideTime then
        Exit;
      // ����� ������� ����� ����������� �����, ��������� ��� ���������
      // �����, ��� ����� 300 ��
      FMinShowTime := GetTickCount + 300;
    end;
  end
  else
    // ���� ���� ���� � ������� �����, �� ��������� ������� �������
    FMinHideTime := GetTickCount;
  FTimer.Enabled := False;
  FTimer.Tag     := 0;
  HideLongHint;
end;

procedure TGsvObjectInspectorHintWindow.CreateParams(
  var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    // ����������� ����, ������� ����� �������� �� ������� �������������
    // ����, � ������� �����
    Style := WS_POPUP or WS_BORDER;
    // ��������� ������� ��� ����� ��� ����������� ���� � ���������������
    // �� ��� ������� ��� ������� ����������� � ����������� ����������� ����
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

procedure TGsvObjectInspectorHintWindow.Paint;
var
  r:  TRect;
  dy: Integer;
begin
  r  := ClientRect;
  dy := (ClientHeight - FInspector.FFontHeight) div 2;
  // ��������� ������������ ������ ����������
  if Canvas.Font.Name <> FInspector.Font.Name then
    Canvas.Font.Name := FInspector.Font.Name;
  if Canvas.Font.Size <> FInspector.Font.Size then
    Canvas.Font.Size := FInspector.Font.Size;
  // ����������� ���������� ������� �����
  Canvas.FillRect(r);
  // ���������� �����
  Canvas.TextOut(1 + FTextOffset, dy, Hint);
end;

// �������������� �������� �����
procedure TGsvObjectInspectorHintWindow.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  inherited;
  HideLongHint(True);
  FInspector.SetFocus;
  FInspector.UpdateFocus;
  if Button = mbLeft then begin
    // ��������� ��������� ���� � ���������� ����������
    p := FInspector.ScreenToClient(ClientToScreen(Point(X, y)));
    // ������ ������� ��������� �������� ��� ������
    FInspector.SetSelectedRowByMouse(p.X, p.Y);
  end;
end;

function TGsvObjectInspectorHintWindow.CanFocus: Boolean;
begin
  Result := False;
end;


{ TGsvObjectInspectorListBox }

constructor TGsvObjectInspectorListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditor        := AOwner as TGsvObjectInspectorInplaceEditor;
  TabStop        := False;
  Visible        := False;
  Ctl3D          := False;
  ParentCtl3D    := False;
  ParentFont     := True;
  Color          := clWindow;
  ParentColor    := False;
  ShowHint       := False;
  ParentShowHint := False;
  IntegralHeight := True;
  TabStop        := False;
end;

// �������� ������
procedure TGsvObjectInspectorListBox.HideList(Accept: Boolean);
begin
  FEditor.CloseUp(Accept);
end;

// ��������� ������� ������� � ������ ������ �����
procedure TGsvObjectInspectorListBox.WMRButtonDown(var Message: TWMRButtonDown);
begin
end;
procedure TGsvObjectInspectorListBox.WMRButtonUp(var Message: TWMRButtonDown);
begin
end;
procedure TGsvObjectInspectorListBox.WMMButtonDown(var Message: TWMMButtonDown);
begin
end;
procedure TGsvObjectInspectorListBox.WMMButtonUp(var Message: TWMMButtonDown);
begin
end;

procedure TGsvObjectInspectorListBox.CreateParams(
  var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  // ������������� ��������� ��������� ����, �������� ����� � ������������
  // ���������
  Params.Style := WS_BORDER or WS_CHILD or WS_VSCROLL;
  // ��������� ����������� ������������� ���� (��� �� ������ ����� �������� ����)
  // � ��������� ����� WS_EX_TOOLWINDOW, ����� ���� ������ �� ����������
  // � ������� ��������
  Params.ExStyle := WS_EX_NOPARENTNOTIFY or WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
  // ��������� ���������� ��� �������, ����� �������� �����������
  // ���������� �������
  Params.WindowClass.Style := CS_SAVEBITS;
end;

procedure TGsvObjectInspectorListBox.CreateWnd;
begin
  inherited CreateWnd;
  // ����������� ������������ ����, ��� ��� ������ ����� �������� �� ��� �������.
  // ��� ��� ����������� � ����� ���������� ������ ��� ����, ����� ����
  // ������ ����� ���� �� ������� ������� ����� ��� ������� ������.
  // ��� ������ ��������, ������� ��������� ������ � �����������.
  // ����������� ��� � ������� ������������ ��������� CM_CANCELMODE, �������
  // ���������� ��� ����� ������� �� ������ ����� � ����� ���� ����������
  // � ���� ���������, ����� ������ ���� ������
  Windows.SetParent(Handle, 0);
  // ���������� ������������ ������� ��������� ��� ��������� ������ �� ����
  // ������. ��� ��� �� ����������� ������������ ����, �� ���� ������ ����� ��
  // ������ �������� ����� �����. ����� ����� ���, ����� ������ ����������� ���
  // ���������� ������, ����� ����� ������������ ����� ��� ���� �� ���������
  // ���� ��� ����������� �� ����� ������. �������� ����� ���� ���������� �
  // ���, ��� �������� ���������� ������������ ����������� ������� �� ���� ������
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TGsvObjectInspectorListBox.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then begin
    if PtInRect(GetClientRect, Point(X, Y)) then
      HideList(True)
    else
      // ���� ����� ���� �� ��������� ���� ��-�� ������� (Capture) ��� �������
      // �� ����� ������ � �������� ����, � ���������� �� ��� ���������, ��������,
      // ��� ����������. � ���� ������ ��������� �����
      HideList(False);
  end;
end;


{ TGsvObjectInspectorInplaceEditor }

constructor TGsvObjectInspectorInplaceEditor.Create(AOwner: TComponent);
var
  w: Integer;
begin
  inherited Create(AOwner);
  FInspector := AOwner as TGsvCustomObjectInspectorGrid;
  // ������ ������ ������������� ������ ������ ���������� � ����������, ���
  // � ��� ������ ��������� ����������� ���� ����� (��� ����� pkDialog).
  // ����� Dialog �� ��������� ��-�� ����, ��� ����������� ������������
  // (��� ������ ����������� ������) ����� ������� ������
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  w := BUTTON_POINT_SIZE * 7; // 7 = 3 ����� + 2 ���������� + 2 ������� �� �����
  if FButtonWidth < w then
    FButtonWidth := w;
  ParentColor      := False;
  ParentFont       := True;
  Ctl3D            := False;
  ParentCtl3D      := False;
  TabStop          := False;
  BorderStyle      := bsNone;
  DoubleBuffered   := False;
  AutoSelect       := False;
  AutoSize         := False;
  ShowHint         := False;
  FListBox         := TGsvObjectInspectorListBox.Create(Self);
  FListBox.Parent  := Self;
end;

// ��������� ������ � ����������� ��������� � ��� ���������
procedure TGsvObjectInspectorInplaceEditor.SetNewEditText(const Value: String);
begin
  if Value = Text then begin
    Modified := False;
    Exit;
  end;
  FLockModify := True;
  try
    Text := Value;
  finally
    FLockModify := False;
  end;
  Modified := False;
end;

// ����������� ���� ���������, ����� ���������� �����������
procedure TGsvObjectInspectorInplaceEditor.ShowEditor(
  ALeft, ATop, ARight, ABottom: Integer;
  Info: PGsvObjectInspectorPropertyInfo; const Value: String);
var
  r:  TRect;
  dy: Integer;
begin
  Assert(Assigned(Info));
  // ���������� �������� ����������� ����������� ��������
  if Modified and Assigned(FPropertyInfo) then
    FInspector.ValueChanged(FPropertyInfo, EditText);
  FLockModify := true;
  if Info.EditMask <> '' then begin
    if EditMask <> Info.EditMask then
      EditMask := Info.EditMask;
  end
  else
    EditMask := '';
  FLockModify := false;
  // ��������� ������ �������� ��������
  FPropertyInfo := Info;
  SetNewEditText(Value);
  // �������� ��������� � �������� ����
  SetBounds(ALeft, ATop + 2, ARight - ALeft, ABottom - ATop - 3);
  dy := (((ABottom - ATop) - FInspector.FFontHeight) div 2) - 1;
  if dy < 0 then
    dy := 0;
  SetRect(r, VALUE_LEFT_MARGIN, dy, Width, Height);
  // ���� ��������� ������, �� ��������� ������ ������� ��������������
  // � ���������� ������� � ������� �������
  if HAS(_BUTTON, FPropertyInfo) then
    Dec(r.Right, FButtonWidth);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@r));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
  // �������� ���� ��������� � ����������� �� ����, �������� �� ��������
  // ��� �������������� ��� ������ ��� ������
  if HAS(_READONLY, FPropertyInfo) then begin
    Color    := clBtnFace;
    ReadOnly := True;
  end
  else begin
    Color    := clWindow;
    ReadOnly := False;
    if FInspector.AutoSelect then
      SelectAll;
  end;
  if not FInspector.Visible then
    Exit;
  if not Visible then
    Visible := true;
  if Visible and Enabled and (not Focused) and FInspector.Focused then
    SetFocus;
  Invalidate;
end;

procedure TGsvObjectInspectorInplaceEditor.HideEditor;
begin
  if Focused and FInspector.Visible and FInspector.Enabled then
    FInspector.SetFocus;
  if Visible then
    Hide;
end;

// ����������� ����� ������������� ������ ��� ����� ��������� � ��������
// ��������������, ���� ����� ������ ������� �� ������� ���������
procedure TGsvObjectInspectorInplaceEditor.ShowEditHint;
var
  r:  TRect;
  s:  String;
  w:  Integer;
  cw: Integer;
const
  TG = 2;
begin
  if not HAS(_READONLY, FPropertyInfo) then begin
    s := TextWithLimit(Text);
    w := FInspector.Canvas.TextWidth(s);
    cw := ClientWidth - 1;
    if HAS(_BUTTON, FPropertyInfo) then
      Dec(cw, FButtonWidth);
    if w > cw then begin
      r.Left   := Left - 1;
      r.Top    := Top - FInspector.FRowHeight - TG;
      r.Right  := Left + w + 4;
      r.Bottom := Top - TG;
      FInspector.ShowLongHint(r, s, True);
    end
    else
      FInspector.HideLongHint;
  end
  else
    FInspector.HideLongHint;
end;

// ����������� ����� �������� �������� ���������������� ������ ���� ������
// ���������, ���� ����� �� ������, ���� ��� ����
procedure TGsvObjectInspectorInplaceEditor.ShowValueHint;
var
  r:  TRect;
  s:  String;
  w:  Integer;
  cw: Integer;
  dw: Integer;
  bt: Boolean;
begin
  s  := TextWithLimit(Text);
  w  := FInspector.Canvas.TextWidth(s);
  cw := ClientWidth - 2;
  bt := HAS(_BUTTON, FPropertyInfo);
  if bt then
    Dec(cw, FButtonWidth);
  if w > cw then begin
    r.Left   := Left - 1;
    r.Top    := Top - 2;
    r.Right  := Left + w + 4;
    r.Bottom := r.Top + FInspector.FRowHeight;
    if bt then begin
      dw := FButtonWidth + (r.Right - r.Left) - Width - 1;
      Dec(r.Left, dw);
      Dec(r.Right, dw);
    end;
    FInspector.ShowLongHint(r, s);
  end
  else
    FInspector.HideLongHint;
end;

// �������� ����������� ������
procedure TGsvObjectInspectorInplaceEditor.DropDown;

  function WorkAreaRect: TRect;
  begin
    SystemParametersInfo(SPI_GETWORKAREA, 0, @Result, 0);
  end;

var
  Org:   TPoint;   // �������� ���������� ���� ���������
  XList: Integer;  // ����� ���������� ������
  YList: Integer;  // ������� ���������� ������
  WList: Integer;  // ������ ������
  HList: Integer;  // ������ ������
  RDesk: TRect;    // �������� ������� ��������
  WDesk: Integer;  // ������ ��������� ������� ��������
  HDesk: Integer;  // ������ ��������� ������� ��������
  i:     Integer;
  mw:    Integer;  // ������������ ������ ����� ������
const
  HG = 2;
  YG = 2;
  XG = 2;
begin
  if FListBox.Visible then
    Exit;
  // ������� ������ � ��������� ���
  FListBox.Clear;
  FInspector.DoFillList(FPropertyInfo, FListBox.Items);
  if FListBox.Items.Count = 0 then
    Exit;
  // ������������� ������� ������� ������
  FListBox.ItemIndex := FListBox.Items.IndexOf(Text);
  Org := ClientOrigin;
  FListBox.ItemHeight := FInspector.FFontHeight;
  // ������������ ����� �������� ����
  FDropDownCount := FInspector.FDropDownCount;
  if FDropDownCount < 4 then
    FDropDownCount := 4;
  if FListBox.Items.Count < FDropDownCount then
    FDropDownCount := FListBox.Items.Count;
  // ������������ ������� ������
  RDesk := WorkAreaRect;
  HList := FListBox.ItemHeight * FDropDownCount + HG;
  YList := Org.Y + Height;
  if (YList + HList) > RDesk.Bottom then begin
    // ������������ ����� ��� ������ ��� ����������
    YList := Org.Y - HList - YG;
    if YList < RDesk.Top then begin
      HDesk := RDesk.Bottom - RDesk.Top;
      // ������������ ����� ��� ������ ��� ���������
      if Org.Y > (HDesk div 2) then begin
        // �������� ���������� � ������ �������� ������� ������� ��������,
        // ��������� ������ ������ � ��������� ��� ������
        FDropDownCount := ((Org.Y - RDesk.Top) div FListBox.ItemHeight) - 1;
        HList := FListBox.ItemHeight * FDropDownCount + HG;
        YList := Org.Y - HList - YG;
      end
      else begin
        // �������� ���������� � ������� �������� ��������,
        // ��������� ������ ����� � ��������� ��� ������
        YList := Org.Y + Height;
        FDropDownCount := ((RDesk.Bottom - YList) div FListBox.ItemHeight) - 1;
        HList := FListBox.ItemHeight * FDropDownCount + HG;
      end;
    end;
  end;
  // ��������� ������ ����� ������
  mw := Width;
  for i := 0 to Pred(FListBox.Items.Count) do
    mw := Max(mw, FInspector.Canvas.TextWidth(FListBox.Items[i]));
  if mw > Width then begin
    // ������ ����, ��� ���� ��������������, ������������ ��� ������ � ����������
    WList := mw + 4;
    if FListBox.Items.Count > FDropDownCount then
      WList := WList + GetSystemMetrics(SM_CXVSCROLL);
    XList := Org.X + Width - WList;
    if XList < RDesk.Left then
      XList := RDesk.Left;
    WDesk := RDesk.Right - RDesk.Left;
    if (XList + WList) > WDesk then
      WList := WDesk - XList;
  end
  else begin
    XList := Org.X - XG;
    WList := Width + XG;
  end;
  // ������������� ������� � ������� ���� ������ � �������������� ��� �
  // ����������� ��� �������� ��� ����������
  SetWindowPos(FListBox.Handle, 0, XList, YList, WList, HList, SWP_NOACTIVATE);
  FListBox.Visible := True;
  // ������������� ����� ���� ���������, ��� ��� ������ ��� �����
  // ������ ��� ����������� �� �������
  Windows.SetFocus(Handle);
end;

// �������� ���� ������ � ����� �������� (��� ����� �� ������, ����
// �������� Accept ����� ������)
procedure TGsvObjectInspectorInplaceEditor.CloseUp(Accept: Boolean);
var
  i: Integer;
begin
  Assert(Assigned(FListBox));
  if FListBox.Visible then begin
    // ���� �������� ����� ��������, �� �������� ������ ����������
    // �������� ������ ��� �������� �� �������� � �������������� �������
    i := FListBox.ItemIndex;
    if Accept and (i >= 0) then
      FInspector.ValueChanged(FPropertyInfo, FListBox.Items[i]);
    // �������� �������� �������� �������������� ��������
    SetNewEditText(FInspector.DoGetStringValue(FPropertyInfo));
    // ��������� ��������� ����� �� ���� ������ ����� �������� ������
    FInspector.HideLongHint(True);
    // �������� � ������� ������
    FListBox.Hide;
    FListBox.Clear;
  end;
end;

// ����������� �������� �������� �������� ������ �����
procedure TGsvObjectInspectorInplaceEditor.ListItemChanged;
begin
  Assert(Assigned(FListBox));
  Text := FListBox.Items[FListBox.ItemIndex];
end;

// ������ ��������� �� ������ �����
procedure TGsvObjectInspectorInplaceEditor.SetListItem(Index: Integer);
var
  d: Integer;
begin
  Assert(Assigned(FListBox));
  if Index >= FListBox.Items.Count then
    Index := FListBox.Items.Count - 1;
  if Index < 0 then
    Index := 0;
  if Index >= FListBox.Items.Count then
    Exit;
  d := FListBox.TopIndex;
  if Index < d then
    d := Index
  else if (d + FDropDownCount - 1) >= Index then
    d := Index - FDropDownCount + 1;
  if FListBox.TopIndex <> d then
    FListBox.TopIndex := d;
  if FListBox.ItemIndex <> Index then
    FListBox.ItemIndex := Index;
  ListItemChanged;
end;

// ����� �������-�������
procedure TGsvObjectInspectorInplaceEditor.ShowDialog;
begin
  if FListBox.Visible then
    Exit;
  if Modified and Assigned(FPropertyInfo) then begin
    FInspector.ValueChanged(FPropertyInfo, Text);
    SetNewEditText(FInspector.DoGetStringValue(FPropertyInfo));
  end;
  FInspector.DoShowDialog;
end;

procedure TGsvObjectInspectorInplaceEditor.ValidateStringValue(
  const Value: String);
var
  s: string;
  p: Integer;
begin
  if IsMasked then begin
    s := EditText;
    if not Validate(s, p) then
      raise EDBEditError.CreateRes(@SMaskErr);
  end;
end;

// �������� ������ ��� ������� ������ ����� �� ��������� ������
procedure TGsvObjectInspectorInplaceEditor.CMCancelMode(
  var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FListBox) then
    CloseUp(False);
end;

// ���������� ����������� ������� ������������ ���� ��������������
procedure TGsvObjectInspectorInplaceEditor.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

// ��������� ������� ���� � ����������� �� ����, ��� �� ��������� -
// � ���� �������������� ��� �� ������
procedure TGsvObjectInspectorInplaceEditor.WMSetCursor(
  var Message: TWMSetCursor);
var
  p:   TPoint;
  r:   TRect;
  inh: Boolean;
begin
  inh := True;
  if HAS(_BUTTON, FPropertyInfo) then begin
    GetCursorPos(p);
    SetRect(r, Width - FButtonWidth, 0, Width, Height);
    if PtInRect(r, ScreenToClient(p)) then begin
      Windows.SetCursor(LoadCursor(0, IDC_ARROW));
      inh := False;
    end;
  end;
  if inh then
    inherited;
end;

// ������������ ����������� ������� Windows (������ ����������� �������)
// ��-�� ����, ��� ��������� ��������� ��������� � ����������� �� �����, ���
// ������ ������� ����� - �� ���� �������������� ��� �� ������
procedure TGsvObjectInspectorInplaceEditor.WMLButtonDown(
  var Message: TWMLButtonDown);
var
  r:   TRect;
  inh: Boolean;
  inv: Boolean;
  sl:  Boolean;
begin
  SendCancelMode(Self);
  MouseCapture := True;
  ControlState := ControlState + [csClicked];
  inh := True;
  inv := False;
  sl  := False;
  if HAS(_BUTTON, FPropertyInfo) then begin
    SetRect(r, Width - FButtonWidth, 0, Width, Height);
    if PtInRect(r, Point(Message.XPos, Message.YPos)) then begin
      FPressed    := True;
      FWasPressed := True;
      inh         := False;
      inv         := True;
      sl          := HAS(_LIST, FPropertyInfo);
    end;
  end;
  if inh then
    inherited;
  if inv then
    Invalidate;
  if FListBox.Visible then
    CloseUp(False)
  else if sl then
    DropDown;
end;

procedure TGsvObjectInspectorInplaceEditor.WMLButtonUp(
  var Message: TWMLButtonUp);
var
  inv: Boolean;
  sw:  Boolean;
begin
  MouseCapture := False;
  ControlState := ControlState - [csClicked];
  inv := False;
  sw  := False;
  if FWasPressed then begin
    FWasPressed := False;
    FPressed    := False;
    inv         := True;
    sw          := HAS(_DIALOG, FPropertyInfo);
  end
  else
    inherited;
  if inv then
    Invalidate;
  if sw then
    ShowDialog;
end;

// �������� � ������������� �������� �������, ���� ��� ������� �� ������
procedure TGsvObjectInspectorInplaceEditor.WMLButtonDblClk(
  var Message: TWMLButtonDblClk);
var
  r:        TRect;
  InButton: Boolean;
begin
  SendCancelMode(Self);
  InButton := False;
  if HAS(_BUTTON, FPropertyInfo) then begin
    SetRect(r, Width - FButtonWidth, 0, Width, Height);
    InButton := PtInRect(r, Point(Message.XPos, Message.YPos));
  end;
  if not InButton then begin
    if not ReadOnly then
      // ��������� ����� ������ ������ ����������� ������� ��������� �����.
      // ��������� ����� - ��� ����������� ������� ������ �������������� ���������
      SelectAll
    else if HAS(_LIST, FPropertyInfo) then
      DropDown
    else if HAS(_DIALOG, FPropertyInfo) then
      ShowDialog;
  end;
end;

procedure TGsvObjectInspectorInplaceEditor.WMKillFocus(
  var Message: TMessage);
begin
  inherited;
  CloseUp(False);
end;

procedure TGsvObjectInspectorInplaceEditor.CreateParams(
  var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  // ������������� � ������� ������ ��������� ����� �������������� ���������
  // ��� ����, ����� ����� ���� ���������� ������� ��������������
  // � ���������� ������ � ������ ����� ������� �������� ��������������
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TGsvObjectInspectorInplaceEditor.CreateWnd;
begin
  inherited CreateWnd;
  // �� ��������� Parent ��� ���� ������ � ������������, �����
  // ���� ��� �� ���� ��������� ������� � �� ��� ������� Windows-���������.
  // ������, ����� �������������� �������� ���� ��������� ����� ���������
  // �������� ���� ������
  if Assigned(FListBox) then
    FListBox.HandleNeeded;
end;

// ��������� ������, ���� ��� ����
procedure TGsvObjectInspectorInplaceEditor.PaintWindow(DC: HDC);
var
  r:     TRect;
  Flags: Integer;
  x, y:  Integer;
  w:     Integer;
  ew:    Integer;
begin
  ew := Width;
  if HAS(_BUTTON, FPropertyInfo) then begin
    ew := ew - FButtonWidth;
    SetRect(r, ew, 0, Width, Height);
    // ��������� ������� ������. ���� ��� ������, �� ������������ ������� �����
    if FPressed then
      Flags := BF_FLAT or DFCS_PUSHED
    else
      Flags := 0;
    DrawFrameControl(DC, r, DFC_BUTTON, Flags or DFCS_BUTTONPUSH);
    if HAS(_DIALOG, FPropertyInfo) then begin
      // ��������� ���� ����� - ������������ ������ �������
      x := r.Left + FButtonWidth div 2 - BUTTON_POINT_SIZE div 2;
      y := r.Top  + Height div 2 - BUTTON_POINT_SIZE div 2;
      // ��� ������� ������ �������� ����� ������ � ����
      if FPressed then begin
        Inc(x);
        Inc(y);
      end;
      PatBlt(DC, x, y, BUTTON_POINT_SIZE, BUTTON_POINT_SIZE, BLACKNESS);
      PatBlt(DC, x - BUTTON_POINT_SIZE * 2, y, BUTTON_POINT_SIZE,
        BUTTON_POINT_SIZE, BLACKNESS);
      PatBlt(DC, x + BUTTON_POINT_SIZE * 2, y, BUTTON_POINT_SIZE,
        BUTTON_POINT_SIZE, BLACKNESS);
    end
    else begin
      // ��������� ������������ - ������������ ������ ����������� ������
      w := BUTTON_POINT_SIZE * 3 + 1;
      x := r.Left + (FButtonWidth - w) div 2;
      y := r.Top + (Height - w div 2) div 2;
      if FPressed then begin
        Inc(x);
        Inc(y);
      end;
      // ������ ����������� ������� ��������� ������, ������� � ������� �����,
      // ������ ��� �������� ������ �����
      while w > 0 do begin
        PatBlt(DC, x, y, w, 1, BLACKNESS);
        Inc(x);
        Inc(y);
        Dec(w, 2);
      end;
    end;
  end;
  inherited PaintWindow(DC);
end;

// ��������� �������� �������� ��� ������ ������
procedure TGsvObjectInspectorInplaceEditor.DoExit;
begin
  inherited;
  FInspector.HideLongHint;
  if Modified then begin
    try
      FInspector.ValueChanged(FPropertyInfo, EditText);
    except
    end;
    Modified := False;
  end;
end;

// ������� �� ����������� �����, ����� �������� ��� ������� ��� ������� ������
// � �������� ����������� ����� ��� ������� ������ ��������
procedure TGsvObjectInspectorInplaceEditor.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  r: TRect;
  p: Boolean;
begin
  inherited;
  if FWasPressed then begin
    SetRect(r, Width - FButtonWidth, 0, Width, Height);
    p := PtInRect(r, Point(x, y));
    if p <> FPressed then begin
      FPressed := p;
      Invalidate;
    end;
  end
  else
    ShowValueHint;
end;

// ��������� ��������� ������� ������ ��� ��������� �� �������������� ���������
// ��� �� ������� ����������� ������ � ����������� �� ����, ����� ������ ��� ���

// ��������� � ������� �������� ������
function TGsvObjectInspectorInplaceEditor.DoMouseWheelDown(
  Shift: TShiftState; MousePos: TPoint): Boolean;
var
  h: Integer;
  c: Integer;
  t: Integer;
  i: Integer;
begin
  if FListBox.Visible then begin
    c := FListBox.Items.Count;
    h := FInspector.FDropDownCount;
    if c > h then begin
      t := FListBox.TopIndex;
      // �������� ���������� ������ ������ �� ������� ����� ��������� ����� 1
      Inc(t, h - 1);
      if (t + h) >= c then begin
        t := c - h + 1;
        i := c - 1;
      end
      else
        i := t;
      if t <> FListBox.TopIndex then
        FListBox.TopIndex := t;
      if i <> FListBox.ItemIndex then
        FListBox.ItemIndex := i;
      ListItemChanged;
    end;
    Result := True;
  end
  else begin
    // ����� ��������� ��������� �������������� � ���������� ������������� ����,
    // �� ����, ����������
    Result := False;
    // ����� ����, ��� ��������� �������� ���� ������� ������
    FInspector.HideLongHint(True);
  end;
end;

function TGsvObjectInspectorInplaceEditor.DoMouseWheelUp(
  Shift: TShiftState; MousePos: TPoint): Boolean;
var
  h: Integer;
  t: Integer;
  i: Integer;
begin
  if FListBox.Visible then begin
    t := FListBox.TopIndex;
    i := FListBox.ItemIndex;
    if (t <> 0) or (i <> 0) then begin
      h := FInspector.FDropDownCount;
      if t <> 0 then begin
        Dec(t, h - 1);
        if t < 0 then begin
          t := 0;
          i := 0;
        end
        else
          i := t;
      end
      else
        i := 0;
      if t <> FListBox.TopIndex then
        FListBox.TopIndex := t;
      if i <> FListBox.ItemIndex then
        FListBox.ItemIndex := i;
      ListItemChanged;
    end;
    Result := True;
  end
  else begin
    Result := False;
    FInspector.HideLongHint(True);
  end;
end;

// ��������� � ������� ����������
procedure TGsvObjectInspectorInplaceEditor.KeyDown(var Key: Word;
  Shift: TShiftState);
var
  i:      Integer;
  NoList: Boolean;
begin
  NoList := True;
  if Assigned(FListBox) then begin
    if FListBox.Visible then begin
      // ����������� �� ������
      i := FListBox.ItemIndex;
      case Key of
        VK_DOWN:   SetListItem(i + 1);
        VK_UP:     SetListItem(i - 1);
        VK_NEXT:   SetListItem(i + FDropDownCount - 1);
        VK_PRIOR:  SetListItem(i - FDropDownCount + 1);
        VK_HOME:   SetListItem(0);
        VK_END:    SetListItem(FListBox.Items.Count - 1);
        VK_ESCAPE: CloseUp(False);
        VK_RETURN: CloseUp(True);
      end;
      Key    := 0;
      NoList := False;
    end
  end;
  if NoList then begin
    if (ssAlt in Shift) and (Key = VK_DOWN) then begin
      // ���������� ����������� ���������� ����������: Alt + Down
      Key := 0;
      if HAS(_DIALOG, FPropertyInfo) then
        ShowDialog
      else begin
        NoList := True;
        DropDown;
      end;
    end;
  end;
  if NoList then begin
    // ����������� �� �������������� ���������
    case Key of
      VK_DOWN, VK_UP, VK_PRIOR, VK_NEXT:
      begin
        FInspector.SetSelectedRowByKey(Key);
        Key := 0;
      end;
      VK_HOME, VK_END:
      begin
        if ssCtrl in Shift then begin
          FInspector.SetSelectedRowByKey(Key);
          Key := 0;
        end;
      end;
      VK_ESCAPE, VK_RETURN: Key := 0;
      VK_LEFT, VK_SUBTRACT, VK_OEM_MINUS:
      begin
        if Assigned(FPropertyInfo) then begin
          if FPropertyInfo.Kind = pkSet then begin
            FInspector.ExpandingOrChangeBoolean(True, tctCollapse);
            Key := 0;
          end;
        end;
      end;
      VK_RIGHT, VK_ADD, VK_OEM_PLUS:
      begin
        if Assigned(FPropertyInfo) then begin
          if FPropertyInfo.Kind = pkSet then begin
            FInspector.ExpandingOrChangeBoolean(True, tctExpand);
            Key := 0;
          end;
        end;
      end;
    end;
  end;
  inherited;
  // ��� ��������� �������� ���� ������� ������, ��� ������ ��������
  // ���������� ���� ��������������, ���� �� �����
  if Key = 0 then
    FInspector.HideLongHint(True)
  else
    ShowEditHint;
end;

// ��������� �������� �������� ��� ������� ������� Enter
procedure TGsvObjectInspectorInplaceEditor.KeyPress(var Key: Char);
begin
  if Key = #13 then begin
    if HAS(_INPUT_TEXT, FPropertyInfo) then begin
      // ��������� �������� ��������
      FInspector.ValueChanged(FPropertyInfo, EditText);
      // ����� �������� ������������ � ������������� ������ �������� ��
      // ��� ������, ���� ��������� ���� ���������� ��� ������������,
      // ��������, ��� ����� ����� ���� ������� �����
      SetNewEditText(FInspector.DoGetStringValue(FPropertyInfo));
    end
    else if HAS(_DIALOG, FPropertyInfo) then
      ShowDialog
    else if FPropertyInfo.Kind = pkSet then
      FInspector.ExpandingOrChangeBoolean(True, tctChange);
    // �� ��������� ���� �������� ������ ������� � ������������� �����
    Key := #0;
  end
  else if Key = #32 then begin
    if FPropertyInfo.Kind = pkSet then begin
      FInspector.ExpandingOrChangeBoolean(True, tctChange);
      Key := #0;
    end;
  end;
  inherited;
end;

procedure TGsvObjectInspectorInplaceEditor.KeyUp(var Key: Word;
  Shift: TShiftState);
var
  NoList: Boolean;
begin
  NoList := True;
  if Assigned(FListBox) then begin
    if FListBox.Visible then begin
      NoList := False;
      Key    := 0;
    end;
  end;
  if NoList then begin
    case Key of
      VK_DOWN, VK_UP, VK_PRIOR, VK_NEXT, VK_ESCAPE, VK_RETURN: Key := 0;
      VK_F1: FInspector.DoHelp;
    end;
  end;
  inherited;
end;

// ��������� ��������� ������ �� ����� �������
procedure TGsvObjectInspectorInplaceEditor.Change;
begin
  inherited;
  // ���� ����������� ����������, �� ���������� ���������. ����������
  // �����������, ����� �������� �������� ����� ��������� ��������,
  // ����� ���� ������������ ������� ����������� ������ � �����������
  // �������������
  if FLockModify then
    Exit;
  if Assigned(FPropertyInfo) then begin
    if FPropertyInfo^.Kind = pkImmediateText then begin
      // ����������� ��������� �������� �������� �������
      FInspector.ValueChanged(FPropertyInfo, EditText);
      // ��������� ��������� �������������, ���������� ������� �����������
      Modified := False;
    end;
  end;
  // ��������� ���� ������� ������ (���� ��� �����)
  ShowEditHint;
end;

procedure TGsvObjectInspectorInplaceEditor.ValidateError;
begin
end;

procedure TGsvObjectInspectorInplaceEditor.ValidateEdit;
begin
end;

{ TGsvCustomObjectInspectorGrid }

constructor TGsvCustomObjectInspectorGrid.Create(AOwner: TComponent);
const
  st = [csCaptureMouse, csOpaque, csClickEvents, csDoubleClicks, csNeedsBorderPaint];
begin
  // �������������� ������ ������� ������� �������
  SetLength(FRows, PROP_LIST_DELTA);
  FProperties := TGsvObjectInspectorProperties.Create(Self);
  FGlyphs     := TBitmap.Create;
  FGlyphs.LoadFromResourceName(HInstance, 'GSVOBJECTINSPECTORGLYPHS');

  FMouseDivPos       := -1;
  FFontHeight        := 13;
  FLevelIndent       := GLYPH_MAGRIN * 2 + GLYPH_TREE_SIZE;

  FRowHeight         := 18;
  FDividerPosition   := 100;
  FFolderFontColor   := clBtnText;
  FFolderFontStyle   := [fsBold];
  FLongTextHintTime  := 3000;
  FLongEditHintTime  := 3000;
  FAutoSelect        := True;
  FMaxTextLength     := 256;
  FDropDownCount     := 8;
  FHideReadOnly      := False;

  inherited Create(AOwner);
  if NewStyleControls then
    ControlStyle := st
  else
    ControlStyle := st + [csFramed];
  Width          := 200;
  Height         := 100;
  DoubleBuffered := True;
  ShowHint       := False;
  ParentColor    := False;
  Color          := clBtnFace;
  Font.Color     := clBtnText;
  FBorderStyle   := bsSingle;
end;

destructor TGsvCustomObjectInspectorGrid.Destroy;
begin
  FRows := nil;
  FProperties.Free;
  FGlyphs.Free;
  inherited Destroy;
end;

procedure TGsvCustomObjectInspectorGrid.SetBorderStyle(
  const Value: TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.SetRowHeight(const Value: Integer);
begin
  if (FRowHeight <> Value) and (Value >= 12) then begin
    FRowHeight := Value;
    UpdateScrollBar;
    Invalidate;
  end;
end;

// ��������� ������� ����� ����������� � ������ �����������
procedure TGsvCustomObjectInspectorGrid.SetDividerPosition(
  const Value: Integer);
begin
  if (FDividerPosition <> Value) and (Value >= DIVIDER_LIMIT) and
    (Value < (ClientWidth - DIVIDER_LIMIT)) then
  begin
    FDividerPosition := Value;
    Invalidate;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.SetFolderFontColor(
  const Value: TColor);
begin
  if FFolderFontColor <> Value then begin
    FFolderFontColor := Value;
    Invalidate;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.SetFolderFontStyle(
  const Value: TFontStyles);
begin
  if FFolderFontStyle <> Value then begin
    FFolderFontStyle := Value;
    Invalidate;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.SetLongTextHintTime(
  const Value: Cardinal);
begin
  if FLongTextHintTime <> Value then begin
    FLongTextHintTime := Value;
    HideLongHint;
    if (FLongTextHintTime = 0) and (FLongEditHintTime = 0) and
        Assigned(FHintWindow) then
    begin
      // ���������� ���� �����, ���� ��� �� �����
      FHintWindow.Free;
      FHintWindow := nil;
    end;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.SetLongEditHintTime(
  const Value: Cardinal);
begin
  if FLongEditHintTime <> Value then begin
    FLongEditHintTime := Value;
    HideLongHint;
    if (FLongTextHintTime = 0) and (FLongEditHintTime = 0) and
        Assigned(FHintWindow) then
    begin
      FHintWindow.Free;
      FHintWindow := nil;
    end;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.SetMaxTextLength(
  const Value: Integer);
begin
  if FMaxTextLength <> Value then begin
    FMaxTextLength := Value;
    if Assigned(FEditor) then
      FEditor.MaxLength := FMaxTextLength;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.SetHideReadOnly(
  const Value: Boolean);
begin
  if FHideReadOnly <> Value then begin
    FHideReadOnly := Value;
    NewObject;
  end;
end;

function TGsvCustomObjectInspectorGrid.GetLayout: string;
var
  h:  TGsvObjectInspectorHistory;
  hn: string;
begin
  Result := '';
  hn := FProperties.HistoryName;
  if hn <> '' then begin
    h := TGsvObjectInspectorHistory.Create;
    try
      FProperties.FillHistory(h);
      Result := h.ToString(hn);
    finally
      h.Free;
    end;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.SetLayout(const Value: string);
var
  t, s: Integer;
begin
  if FProperties.SetLayout(Value, t, s) then begin
    CreateRows;
    FTopRow   := t;
    FSelected := -1;
    UpdateScrollBar;
    SetSelectedRow(s);
  end;
end;

procedure TGsvCustomObjectInspectorGrid.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;
end;

// ��������� ������� �� ������������� ���������� - ��� �������� �
// ��������� ������� �������� ������������� ��������, �� �� ��������
// ����������� ��������
procedure TGsvCustomObjectInspectorGrid.WMVScroll(var Msg: TWMVScroll);
var
  rc: Integer;
  si: TScrollInfo;
begin
  inherited;
  rc := ClientHeight div FRowHeight;
  with Msg do begin
    case ScrollCode of
      SB_LINEUP:   SetTopRow(FTopRow - 1);
      SB_LINEDOWN: SetTopRow(FTopRow + 1);
      SB_PAGEUP:   SetTopRow(FTopRow - rc);
      SB_PAGEDOWN: SetTopRow(FTopRow + rc);
      SB_THUMBPOSITION, SB_THUMBTRACK:
      begin
        si.cbSize := SizeOf(TScrollInfo);
        SI.fMask  := SIF_TRACKPOS;
        if GetScrollInfo(Handle, SB_VERT, si) then
          SetTopRow(si.nTrackPos);
      end;
    end;
  end;
end;

// ��������� ������� �� ������ �����-����
procedure TGsvCustomObjectInspectorGrid.WMGetDlgCode(
  var Msg: TWMGetDlgCode);
begin
  inherited;
  Msg.Result := DLGC_WANTARROWS;
end;

// ���� ���� �������� ������� ����������, �� ���������� ���� (���� �� ����)
procedure TGsvCustomObjectInspectorGrid.CMMouseLeave(
  var Message: TMessage);
begin
  inherited;
  HideLongHint;
end;

procedure TGsvCustomObjectInspectorGrid.WMShowDialog(
  var Message: TMessage);
var
  r: TRect;
  p: TPoint;
begin
  if csDesigning in ComponentState then
    Exit;
  if not FEditor.Visible then
    Exit;
  if not Assigned(FEditor.FPropertyInfo) then
    Exit;
  if not Assigned(FOnShowDialog) then
    Exit;
  r := FEditor.ClientRect;
  p := FEditor.ClientOrigin;
  OffsetRect(r, p.X, p.Y);
  FOnShowDialog(Self, FEditor.FPropertyInfo, r);
  Invalidate;
  ShowEditor;
end;

procedure TGsvCustomObjectInspectorGrid.WMHelp(var aMessage: TMessage);
var
  hi: PHELPINFO;
  pt: TPoint;
  r:  Integer;
begin
  if not Assigned(FOnHelp) then
    Exit;
  hi := PHELPINFO(aMessage.LParam);
  pt := ScreenToClient(hi.MousePos);
  r  := FTopRow + (pt.Y div FRowHeight);
  if (r >= 0) and (r <= High(FRows)) then begin
    if FRows[r].Help <> 0 then
      FOnHelp(Self, FRows[r]);
  end;
end;

// ���� ���������� ���� � �������� ����� �����������
function TGsvCustomObjectInspectorGrid.DividerHitTest(X: Integer): Boolean;
const
  G = 2;
begin
  Result := (X >= (FDividerPosition - G)) and (X <= (FDividerPosition + G));
end;

// �������� ������ ���� ������� �������
procedure TGsvCustomObjectInspectorGrid.EnumProperties;
var
  p:     PGsvObjectInspectorPropertyInfo;
  Index: Integer;
begin
  HideLongHint;
  HideEditor;
  FProperties.Clear;
  Index := 0;
  if Assigned(FOnEnumProperties) then begin
    FOnEnumProperties(Self, Index, p);
    while Assigned(p) do begin
      FProperties.Add(p);
      Inc(Index);
      FOnEnumProperties(Self, Index, p);
    end;
  end;
  // ������� ������ ������������ �������
  CreateRows;
  FTopRow   := FProperties.TopRow;
  FSelected := -1;
  UpdateScrollBar;
  if FRowsCount <> 0 then
    SetSelectedRow(FProperties.Selected)
  else
    Invalidate;
end;

// �������� ������ ������������ ������� �� ������ ������� ������ � �����������
// �� �������� Expanded
procedure TGsvCustomObjectInspectorGrid.CreateRows;
var
  i: Integer;

  // ���������� ��������
  procedure AddRow(p: PGsvObjectInspectorPropertyInfo);
  begin
    Assert(Assigned(p));
    // ���������� �������� �� ������ ���� �� ����� ���� ����������� ���� �������
    if FHideReadOnly and (p^.Kind = pkReadOnlyText) then
      Exit;
    if FRowsCount > High(FRows) then
      SetLength(FRows, Length(FRows) + PROP_LIST_DELTA);
    FRows[FRowsCount] := p;
    Inc(FRowsCount);
  end;

  // ������� ������ � ���� ��� ���������
  procedure SkipLevel(ALevel: Integer);
  begin
    while i < FProperties.Count do begin
      if FProperties[i]^.Level >= ALevel then
        Inc(i)
      else
        Break;
    end;
  end;

  // ����������� ���������� ������ ������ ����������� ��������� �������
  procedure FillLevel(ALevel: Integer);
  var
    p: PGsvObjectInspectorPropertyInfo;
  begin
    while i < FProperties.Count do begin
      p := FProperties[i];
      if p^.Level = ALevel then begin
        AddRow(p);
        if p^.HasChildren then begin
          if p^.Expanded then begin
            Inc(i);
            FillLevel(ALevel + 1);
          end
          else begin
            Inc(i);
            SkipLevel(ALevel + 1);
          end
        end
        else
          Inc(i);
      end
      else
        Break;
    end;
  end;

begin
  FRowsCount := 0;
  i          := 0;
  FillLevel(0);
end;

// ���������� ������� ������� ������������� ���������� �
// ����������� �� ����� ������������ ������� � ��������� �� ����������
procedure TGsvCustomObjectInspectorGrid.UpdateScrollBar;
var
  si: TScrollInfo;
  rc: Integer;
begin
  if not HandleAllocated then
    Exit;
  rc := ClientHeight div FRowHeight;
  si.cbSize := SizeOf(si);
  si.fMask  := SIF_PAGE or SIF_POS or SIF_RANGE;
  si.nMin   := 0;
  if (FRowsCount <= rc) then si.nMax := 0
  else                       si.nMax := FRowsCount;
  if si.nMax <> 0 then si.nPage := rc + 1
  else                 si.nPage := 0;
  if (si.nMax <> 0) and (FTopRow > 0) then begin
    si.nPos      := FTopRow;
    si.nTrackPos := FTopRow;
  end
  else begin
    if (si.nMax = 0) and (FTopRow <> 0) then
      FTopRow := 0;
    si.nPos      := 0;
    si.nTrackPos := 0;
  end;
  SetScrollInfo(Handle, SB_VERT, si, True);
end;

// ����������� ���� ��������� ��� ������� ������
procedure TGsvCustomObjectInspectorGrid.ShowLongHint(const Rect: TRect;
  const AText: String; IsEditHint: Boolean);
begin
  // ��������� � ������ ��������������
  if csDesigning in ComponentState then
    Exit;
  // ���������, ���� �� ������ ����� �����������
  if (not IsEditHint) and (FLongTextHintTime = 0) then
    Exit;
  if IsEditHint and (FLongEditHintTime = 0) then
    Exit;
  // ������� ���� ����� (���� ��� ��� ���)
  if not Assigned(FHintWindow) then begin
    if not HandleAllocated then
      Exit;
    FHintWindow := TGsvObjectInspectorHintWindow.Create(Self)
  end;
  // �������� ��������� ����������� �����
  FHintWindow.ActivateHint(Rect, AText, IsEditHint);
end;

// ������� ���� ���������
procedure TGsvCustomObjectInspectorGrid.HideLongHint(HardHide: Boolean);
begin
  if Assigned(FHintWindow) then
    FHintWindow.HideLongHint(HardHide);
end;

// ����������� ���� ��������� ���� �� ����� ��� ������� ���, ���� �� �����
procedure TGsvCustomObjectInspectorGrid.ShowEditor;
var
  y0: Integer;
begin
  // ���������� ��� ��������������
  if csDesigning in ComponentState then
    Exit;
  if (FRowsCount = 0) or (FTopRow < 0) or
     (FSelected < 0) or (FSelected >= FRowsCount) then
  begin
    HideEditor;
    Exit;
  end;
  // ������� ����, ���� ��� ��� ���
  if not Assigned(FEditor) then begin
    if not HandleAllocated then
      Exit;
    FEditor           := TGsvObjectInspectorInplaceEditor.Create(Self);
    FEditor.Parent    := Self;
    FEditor.MaxLength := FMaxTextLength;
  end;
  // ���� ���������� �������� ������� ���� ���������, �� ���������� ���
  // � �������� ��� ����� �����
  if HAS(_EDITOR, FRows[FSelected]) then begin
    y0 := (FSelected - FTopRow) * FRowHeight;
    FEditor.ShowEditor(FDividerPosition + 2, y0, ClientWidth, y0 + FRowHeight,
      FRows[FSelected], DoGetStringValue(FRows[FSelected]));
    UpdateFocus;
  end
  else
    HideEditor;
end;

// ������� ���� ���������
procedure TGsvCustomObjectInspectorGrid.HideEditor;
begin
  if Assigned(FEditor) then
    FEditor.HideEditor;
end;

// ���������� ������ � ������� ���� �������������� ��� ��������� ������
procedure TGsvCustomObjectInspectorGrid.UpdateEditor;
begin
  if not Assigned(FEditor) then
    Exit;
  if not FEditor.Visible then
    Exit;
  if FEditor.Modified then
    Exit;
  if (FRowsCount = 0) or (FTopRow < 0) or
     (FSelected < 0) or (FSelected >= FRowsCount) then
    Exit;
  FEditor.SetNewEditText(DoGetStringValue(FRows[FSelected]));
end;

// ��������� ������ �����
procedure TGsvCustomObjectInspectorGrid.UpdateFocus;
begin
  if Visible and Enabled then
    if Assigned(FEditor) then
      if FEditor.Visible and FEditor.Enabled and Focused and (not FEditor.Focused) then
        FEditor.SetFocus;
end;

// ��������� ������ �������� ������������� ��������
procedure TGsvCustomObjectInspectorGrid.SetTopRow(ATopRow: Integer);
var
  rc, d: Integer;
begin
  HideLongHint;
  if (FRowsCount = 0) or (ATopRow < 0) then
    Exit;
  rc := ClientHeight div FRowHeight;
  d  := FRowsCount - rc;
  if ATopRow > d then
    ATopRow := d;
  if ATopRow < 0 then
    ATopRow := 0;
  if FTopRow = ATopRow then begin
    UpdateFocus;
    Exit;
  end;
  FTopRow := ATopRow;
  HideEditor;
  UpdateScrollBar;
  Invalidate;
  ShowEditor;
end;

// ��������� ������ ����������� ��������
procedure TGsvCustomObjectInspectorGrid.SetSelectedRow(ARow: Integer);
var
  rc:             Integer;
  tr:             Integer;
  NeedInvalidate: Boolean;
begin
  HideLongHint;
  if FRowsCount = 0 then
    Exit;
  if ARow >= FRowsCount then
    ARow := FRowsCount - 1;
  if ARow < 0 then
    ARow := 0;
  DoHint(FRows[ARow]);
  if FSelected = ARow then begin
    UpdateFocus;
    Exit;
  end;
  FSelected      := ARow;
  rc             := ClientHeight div FRowHeight;
  NeedInvalidate := True;
  // ��������� ��������� �������� ������������� ��������
  if FTopRow < 0 then
    SetTopRow(FSelected);
  if FSelected < FTopRow then begin
    // ���������� �������� �� ����� - ����������� �� ���������
    SetTopRow(FSelected);
    NeedInvalidate := False;
  end
  else if FSelected >= (FTopRow + rc) then begin
    tr := FTopRow;
    SetTopRow(FSelected - rc + 1);
    // ������������� ������� ����������� ���� ���������� �������� ������
    NeedInvalidate := (tr = FTopRow);
  end;
  if not NeedInvalidate then begin
    UpdateFocus;
    Exit;
  end;
  // ����������� ��������� ��� ������ ����������� ��������
  HideEditor;
  Invalidate;
  ShowEditor;
  UpdateFocus;
end;

// ��������� �������� ������ �� ���������� ����
procedure TGsvCustomObjectInspectorGrid.SetSelectedRowByMouse(X, Y: Integer);
var
  sr: Integer;
begin
  if (X < 0) or (X > ClientWidth) then
    Exit;
  sr := FSelected;
  // ��������� ��������
  SetSelectedRow(FTopRow + (Y div FRowHeight));
  // ���� ���������� ��� ���������� ��������, �� �����������
  // ���������� ��� ����������� ���������� ������� ������ ���
  // ���������� �������� ���� ���� pkBoolean �� ���������������
  if sr = FSelected then
    ExpandingOrChangeBoolean(X < FDividerPosition, tctChange);
end;

// ��������� ����������� �������� �������� ���� Boolean ��� ��������
// ��������� �� ���������������
procedure TGsvCustomObjectInspectorGrid.ChangeBoolean(
  Info: PGsvObjectInspectorPropertyInfo);
var
  OrdVal:  LongInt; // ���������� �������� ���������� ��������
begin
  Assert(Assigned(Info));
  OrdVal := DoGetIntegerValue(Info);
  DoSetIntegerValue(Info, GsvChangeBit(OrdVal, Info^.Tag));
end;

// ��������� ������ ������������ ������� ��� ��������� �������� Expanded
// �������� �������� ��� ��������� �������� ���� ���� pkBoolean ��
// ���������������
procedure TGsvCustomObjectInspectorGrid.ExpandingOrChangeBoolean(
  ExpandingOnly: Boolean; ChangeType: TGsvObjectInspectorTreeChangeType);
var
  p:   PGsvObjectInspectorPropertyInfo;
  pcw: Integer;
  e:   Boolean;
begin
  HideLongHint;
  if (FRowsCount = 0) or (FSelected < 0) and (FSelected >= FRowsCount) then
    Exit;
  p := FRows[FSelected];
  if not Assigned(p) then
    Exit;
  if not p^.HasChildren then begin
    // ���� ���������� �������� �� ����� �������� ����������, �� ��������� ���
    // ���������� � ���� ������ ������. ���� �������� ���� Boolean, ��
    // ������� ��� �������� �� ���������������
    if not ExpandingOnly then begin
      if p^.Kind = pkBoolean then begin
        ChangeBoolean(p);
        Invalidate;
      end;
    end;
    UpdateFocus;
    Exit;
  end;
  case ChangeType of
    tctChange:   e := not p^.Expanded;
    tctCollapse: e := False;
    tctExpand:   e := True;
    else         e := p^.Expanded;
  end;
  // ������ �������� �������� Extended, �������������
  // ������ ������� � �������������� ������� ���� ����������
  if p^.Expanded <> e then begin
    p^.Expanded := e;
    pcw := ClientWidth;
    CreateRows;
    UpdateScrollBar;
    HideEditor;
    Invalidate;
    ShowEditor;
    // ���� ������ ���������� ������� �����������, ������
    // ������� ���������� �������� � ��� �������� ����� ����������� �
    // ����. ���� ��� ���� ������� �������� �� ������������,
    // �� ���� ������������ ������� ������ �������
    if pcw < ClientWidth then
      if FTopRow <> 0 then
        SetTopRow(0);
  end;
end;

// ��������� �� ��������� �� ����������
procedure TGsvCustomObjectInspectorGrid.SetSelectedRowByKey(Key: Word);
var
  rc: Integer;
begin
  rc := ClientHeight div FRowHeight;
  case Key of
    VK_UP:    SetSelectedRow(FSelected - 1);
    VK_DOWN:  SetSelectedRow(FSelected + 1);
    VK_PRIOR: SetSelectedRow(FSelected - rc);
    VK_NEXT:  SetSelectedRow(FSelected + rc);
    VK_HOME:  SetSelectedRow(0);
    VK_END:   SetSelectedRow(FRowsCount - 1);
  end;
end;

// ���� ����� ���������� �������� ��� ��������� �������� ��������
procedure TGsvCustomObjectInspectorGrid.ValueChanged(
  Info: PGsvObjectInspectorPropertyInfo; const Value: String);
begin
  if FRowsCount <> 0 then
    if HAS(_INPUT_TEXT, Info) then
      if DoGetStringValue(Info) <> Value then
        DoSetStringValue(Info, Value);
end;

procedure TGsvCustomObjectInspectorGrid.CreateParams(
  var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited;
  with Params do begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
      Style   := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
  with Params.WindowClass do
    Style := Style and (CS_HREDRAW or CS_VREDRAW);
end;

procedure TGsvCustomObjectInspectorGrid.CreateWnd;
begin
  inherited;
  UpdateScrollBar;
end;

procedure TGsvCustomObjectInspectorGrid.Paint;
var
  i:      Integer;
  x0, x1: Integer;
  y0, y1: Integer;
  iMax:   Integer;
  dy, dg: Integer;
  r:      TRect;
  IntVal: Integer;

  procedure DrawLine(AColor: TColor; AX0, AY0, AX1, AY1: Integer);
  begin
    with Canvas do begin
      Pen.Color := AColor;
      MoveTo(AX0, AY0);
      LineTo(AX1, AY1);
    end;
  end;

  procedure DrawString;
  begin
    Canvas.TextRect(r, r.Left + VALUE_LEFT_MARGIN, r.Top + dy,
      TextWithLimit(FRows[i]^.LastValue));
  end;

  procedure DrawFloat;
  var
    f: Extended;
    v: String;
  begin
    v := FRows[i]^.LastValue;
    if v <> '' then begin
      try
        f := StrToFloat(v);
        if FRows[i]^.FloatFormat <> '' then
          v := Trim(FormatFloat(FRows[i]^.FloatFormat, f))
        else
          v := FloatToStr(f);
      except
      end;
    end;
    Canvas.TextRect(r, VALUE_LEFT_MARGIN + r.Left, r.Top + dy, v);
  end;

  procedure DrawTreeGlyph;
  var
    sr, dr: TRect;
  begin
    // ���������� ��� ��������� ������
    dr.Left   := x0 + GLYPH_MAGRIN - FLevelIndent;
    dr.Top    := y0 + dg;
    dr.Right  := dr.Left + GLYPH_TREE_SIZE;
    dr.Bottom := dr.Top + GLYPH_TREE_SIZE;
    // ���������� ������ � ��������� bitmap
    if FRows[i]^.Expanded then sr.Left := 1
    else                       sr.Left := FGlyphs.Height + 1;
    sr.Top    := 1;
    sr.Right  := sr.Left + GLYPH_TREE_SIZE;
    sr.Bottom := sr.Top + GLYPH_TREE_SIZE;
    // ���������
    Canvas.CopyRect(dr, FGlyphs.Canvas, sr);
  end;

  procedure DrawBoolean;
  var
    sr, dr: TRect;
  begin
    // ���������� ��� ����������� ������������ ������ CheckBox
    dr.Left   := r.Left + VALUE_LEFT_MARGIN;
    dr.Top    := r.Top + (r.Bottom - r.Top - GLYPH_CHECK_SIZE) div 2;
    dr.Right  := dr.Left + GLYPH_CHECK_SIZE;
    dr.Bottom := dr.Top + GLYPH_CHECK_SIZE;
    // ���������� ������ � �������� bitmap'e
    if GsvGetBit(IntVal, FRows[i]^.Tag) then
      sr.Left := FGlyphs.Height * 3
    else
      sr.Left := FGlyphs.Height * 2;
    sr.Top    := 0;
    sr.Right  := sr.Left + GLYPH_CHECK_SIZE;
    sr.Bottom := sr.Top + GLYPH_CHECK_SIZE;
    // ��������� ������
    Canvas.CopyRect(dr, FGlyphs.Canvas, sr);
  end;

  procedure DrawColor;
  var
    dr:  TRect;
    pc:  TColor;
    bc:  TColor;
  begin
    Canvas.TextRect(r, r.Left + VALUE_LEFT_MARGIN * 2 + 2 + COLOR_RECT_WIDTH,
      r.Top + dy, FRows[i]^.LastValue);
    dr.Left   := r.Left + VALUE_LEFT_MARGIN;
    dr.Top    := y0 + dg;
    dr.Right  := dr.Left + COLOR_RECT_WIDTH;
    dr.Bottom := dr.Top + COLOR_RECT_HEIGHT;
    pc := Canvas.Pen.Color;
    bc := Canvas.Brush.Color;
    Canvas.Pen.Color := clBlack;
    case FRows[i]^.Kind of
      pkColor,
      pkColorRGB: Canvas.Brush.Color := IntVal;
    end;
    Canvas.Rectangle(dr);
    Canvas.Pen.Color   := pc;
    Canvas.Brush.Color := bc;
  end;

begin
  inherited;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);

  if FRowsCount = 0 then
    Exit;

  if (Font.Name  <> Canvas.Font.Name) or
     (Font.Size  <> Canvas.Font.Size) or
     (Font.Style <> Canvas.Font.Style) or
     (FFontHeight = 0) then
  begin
    // ���������� ������ ������ � ��������
    Canvas.Font := Font;
    FFontHeight := Canvas.TextHeight('M');
  end;
  // ������������ �������� ��� ������������� ������
  dy := ((FRowHeight - FFontHeight) div 2) - 1;
  if dy < 0 then
    dy := 0;
  // ������������ �������� ��� ������������� ����������� �������
  dg := ((FRowHeight - GLYPH_TREE_SIZE) div 2) + 1;
  if dg < 0 then
    dg := 0;
  // ������ ���������� ��������, ��������� ��� �������� ��������
  // � ���� ����������
  iMax := FTopRow + ClientHeight div FRowHeight;
  if (ClientHeight mod FRowHeight) <> 0 then
    Inc(iMax); // ���� �������� ������� ��������
  if iMax > Pred(FRowsCount) then
    iMax := Pred(FRowsCount);
  // �������� �� ���� ������� ���������
  for i := FTopRow to iMax do begin
    // �������������� ����� �����
    y0 := (i - FTopRow) * FRowHeight;
    y1 := y0 + FRowHeight;
    DrawLine(clBtnShadow, 0, y1, ClientWidth, y1);
    // ����������� ������ ����������� ���������
    x0 := (FRows[i]^.Level + 1) * FLevelIndent;
    x1 := FDividerPosition;
    if FRows[i]^.HasChildren then
      DrawTreeGlyph;
    // ��������� �������� ��������
    SetRect(r, x0, y0 + 2, x1 - 1, y1 - 1);
    if FRows[i]^.Kind = pkFolder then begin
      // ���� �������� - �����, �� ������ �� ��� ������ ����
      Canvas.Font.Color := FFolderFontColor;
      Canvas.Font.Style := FFolderFontStyle;
      r.Right := ClientWidth;
      Canvas.TextRect(r, r.Left, r.Top + dy, DoGetCaption(FRows[i]));
      Canvas.Font.Color := Font.Color;
      Canvas.Font.Style := [];
    end
    else begin
      Canvas.TextRect(r, r.Left, r.Top + dy, DoGetCaption(FRows[i]));
      // ��������� ����� �����������
      DrawLine(clBtnShadow, x1, y0 + 1, x1, y1);
      DrawLine(clBtnHighlight, x1 + 1, y0 + 1, x1 + 1, y1);
    end;
    // ��������� �������� ��������
    r.Left  := x1 + 2;
    r.Right := ClientWidth;
    if i = FSelected then begin
      // ��������� ������� ����������� ��������
      DrawLine(clBtnShadow, 0, y0, ClientWidth, y0);
      DrawLine(clBtnText, 0, y0 + 1, ClientWidth, y0 + 1);
      DrawLine(clBtnFace, 0, y1 - 1, ClientWidth, y1 - 1);
      DrawLine(clBtnHighlight, 0, y1, ClientWidth, y1);
      DrawLine(clBtnText, 0, y0 + 1, 0, y1 - 1);
    end;
    if HAS(_INTEGER, FRows[i]) then
      IntVal := DoGetIntegerValue(FRows[i]);
    FRows[i]^.LastValue := DoGetStringValue(FRows[i]);
    case FRows[i]^.Kind of
      pkText,
      pkDropDownList,
      pkDialog,
      pkReadOnlyText,
      pkImmediateText,
      pkTextList,
      pkSet,
      pkTextDialog:
        DrawString;
      pkBoolean:
        DrawBoolean;
      pkColor,
      pkColorRGB:
        DrawColor;
      pkFloat:
        DrawFloat;
    end;
  end;
end;

// ������������ ����� ����������� ��� ��������� �������� ���� ����������
procedure TGsvCustomObjectInspectorGrid.Resize;
begin
  inherited;
  if (FDividerPosition > (ClientWidth - DIVIDER_LIMIT)) then
    FDividerPosition := ClientWidth - DIVIDER_LIMIT;
  if (FDividerPosition < DIVIDER_LIMIT) then
    FDividerPosition := DIVIDER_LIMIT;
  UpdateScrollBar;
  Invalidate;
  HideLongHint;
  HideEditor;
  ShowEditor;
end;

// ��� ��������� ������ ����� ������������ ���
procedure TGsvCustomObjectInspectorGrid.DoEnter;
begin
  inherited;
  UpdateFocus;
end;

// ��� ������ ������ ����� �������� ����
procedure TGsvCustomObjectInspectorGrid.DoExit;
begin
  inherited;
  HideLongHint;
end;

// ����� �������� ���� ������� ������������� ������� ����������� �� ��������
procedure TGsvCustomObjectInspectorGrid.Loaded;
begin
  inherited;
  FDividerPosition := ClientWidth div 2;
end;

procedure TGsvCustomObjectInspectorGrid.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sel: Integer;
  xt:  Integer;
  xc:  Integer;
begin
  inherited;
  if Enabled and Visible and (not Focused) then
    SetFocus;
  if FRowsCount = 0 then
    Exit;
  if (Button <> mbLeft) then
    Exit;
  if DividerHitTest(X) then begin
    // ������ ����������� ����� �����������. ��� ����������� �������� ��������
    FMouseDivPos := X;
    HideEditor;
  end
  else begin
    sel := FSelected;
    // �������� �������� �� ����������� �����
    SetSelectedRowByMouse(X, Y);
    if sel <> FSelected then begin
      // ���� ��������� ����������, �� ������������ ��������� �����
      // �� ����������� ����� � ��� ��������� �������������
      // ��� ����������� ���������� ������� (���� � ��� ���� �����������)
      // ��� �������� �������� ���������� �������� �� ���������������
      if (FSelected >= 0) and (FSelected < FRowsCount) then begin
        xt := FRows[FSelected]^.Level * FLevelIndent;
        xc := FDividerPosition + VALUE_LEFT_MARGIN + 2 + GLYPH_CHECK_SIZE;
        if (X >= xt) and (X < (xt + FLevelIndent)) then
          ExpandingOrChangeBoolean(True, tctChange)
        else if ((X > FDividerPosition) and (X < xc)) then
          ExpandingOrChangeBoolean(False, tctChange);
      end;
    end;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.MouseMove(Shift: TShiftState;
  X, Y: Integer);
var
  cur:      Integer;
  i:        Integer;
  ry:       Integer;
  rx:       Integer;
  tw:       Integer;
  ww:       Integer;
  HintProp: PGsvObjectInspectorPropertyInfo;
  HintRect: TRect;
  s:        String;
const
  GAP     = 2; // ������ ������
  MIN_CAP = 4; // ����������� ������� ����� ���������
begin
  inherited;
  if FRowsCount = 0 then begin
    if Cursor <> crDefault then
      Cursor := crDefault;
    Exit;
  end;
  if FMouseDivPos = -1 then begin
    if DividerHitTest(X) then
      cur := crHSplit
    else
      cur := crDefault;
    if Cursor <> cur then
      Cursor := cur;
  end
  else begin
    if (X >= DIVIDER_LIMIT) and (X < (ClientWidth - DIVIDER_LIMIT)) then
      DividerPosition := X;
  end;
  if Cursor <> crDefault then
    Exit;

  // ���������� ����, ���� ������ ��������� ��� �������� �� ����� ���������
  s := '';
  SetRectEmpty(HintRect);
  i := FTopRow + (Y div FRowHeight);
  if (i < 0) or (i >= FRowsCount) then begin
    HideLongHint;
    Exit;
  end;
  ry := (i - FTopRow) * FRowHeight;
  HintProp := FRows[i];
  Assert(Assigned(HintProp));
  if HintProp^.Kind = pkFolder then begin
    s  := DoGetCaption(HintProp);
    rx := FLevelIndent * (HintProp^.Level + 1);
    ww := ClientWidth - rx - 1;
    Canvas.Font.Style := FFolderFontStyle;
    tw := Canvas.TextWidth(s);
    Canvas.Font.Style := [];
    if tw > ww then begin
      tw := Canvas.TextWidth(s);
      if (rx + MIN_CAP) < ClientWidth then
        SetRect(HintRect, rx - GAP - 1, ry, rx + tw + GAP - 1, ry + FRowHeight + 1)
      else
        SetRect(HintRect, 0, ry, tw + GAP * 2, ry + FRowHeight + 1)
    end;
  end
  else begin
    if X < FDividerPosition then begin
      s  := DoGetCaption(HintProp);
      rx := FLevelIndent * (HintProp^.Level + 1);
      ww := FDividerPosition - rx - 1;
      tw := Canvas.TextWidth(s);
      if tw > ww then begin
        if (rx + MIN_CAP) < FDividerPosition then
          SetRect(HintRect, rx - GAP - 1, ry, rx + tw + GAP - 1,
            ry + FRowHeight + 1)
        else
          SetRect(HintRect, 0, ry, tw + GAP * 2, ry + FRowHeight + 1)
      end;
    end
    else begin
      if Assigned(FEditor) then
        if (i = FSelected) and FEditor.Visible then
          Exit;
      s  := TextWithLimit(DoGetStringValue(HintProp));
      rx := FDividerPosition + 3;
      ww := ClientWidth - rx - 1;
      tw := Canvas.TextWidth(s);
      if tw > ww then
        SetRect(HintRect, rx - GAP - 1, ry, rx + tw + GAP - 1,
          ry + FRowHeight + 1);
    end;
  end;
  if IsRectEmpty(HintRect) or (s = '') then
    HideLongHint
  else
    ShowLongHint(HintRect, s);
end;

procedure TGsvCustomObjectInspectorGrid.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button <> mbLeft then
    Exit;
  if FMouseDivPos <> -1 then begin
    // ���������� ����������� ����� ����������� � ����������� ���������
    FMouseDivPos := -1;
    Invalidate;
    ShowEditor;
  end;
end;

// ��������� ������ ����
function TGsvCustomObjectInspectorGrid.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  if (FRowsCount = 0) or (FTopRow < 0) then
    Exit;
  SetTopRow(FTopRow + 1);
end;

// ��������� ������ �����
function TGsvCustomObjectInspectorGrid.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  if (FRowsCount = 0) or (FTopRow < 0) then
    Exit;
  SetTopRow(FTopRow - 1);
end;

// ��������� �� �������� �� ������� ������
procedure TGsvCustomObjectInspectorGrid.KeyDown(var Key: Word;
  Shift: TShiftState);
var
  tct: TGsvObjectInspectorTreeChangeType;
begin
  case Key of
    VK_LEFT, VK_SUBTRACT, VK_OEM_MINUS: tct := tctCollapse;
    VK_RIGHT, VK_ADD, VK_OEM_PLUS:      tct := tctExpand;
    else                                tct := tctNone;
  end;
  if tct <> tctNone then begin
    if (FSelected >= 0) and (FSelected < FRowsCount) then begin
      if FRows[FSelected]^.HasChildren then begin
        Key := 0;
        inherited;
        ExpandingOrChangeBoolean(True, tct);
        Exit;
      end;
    end;
  end;
  SetSelectedRowByKey(Key);
  Key := 0;
  inherited;
  HideLongHint(True);
end;

// ���������� ��� ����������� ���������� �� �������� Enter ��� Space
procedure TGsvCustomObjectInspectorGrid.KeyPress(var Key: Char);
begin
  if (Key = #13) or (Key = #32) then begin
    if (FSelected >= 0) and (FSelected < FRowsCount) then begin
      if FRows[FSelected]^.HasChildren then
        ExpandingOrChangeBoolean(True, tctChange)
      else if FRows[FSelected].Kind = pkBoolean then
        ExpandingOrChangeBoolean(False, tctChange);
    end;
  end;
  Key := #0;
  inherited;
end;

procedure TGsvCustomObjectInspectorGrid.KeyUp(var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    DoHelp;
  Key := 0;
  inherited;
end;

// ����� �������� �����������, ����������� �������� �������� � ���� ������
function TGsvCustomObjectInspectorGrid.DoGetStringValue(
  Info: PGsvObjectInspectorPropertyInfo): String;
begin
  Result := '';
  if not Assigned(Info) then
    Exit;
  if Assigned(FOnGetStringValue) then
    FOnGetStringValue(Self, Info, Result);
end;

// ����� �������� �����������, ���������������� �������� �������� �� ���
// ���������� �������������
procedure TGsvCustomObjectInspectorGrid.DoSetStringValue(
  Info: PGsvObjectInspectorPropertyInfo; const Value: String);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Assigned(Info) then
    Exit;
  if Assigned(FOnSetStringValue) then begin
    FOnSetStringValue(Self, Info, Value);
    SmartInvalidate;
  end;
end;

function TGsvCustomObjectInspectorGrid.DoGetIntegerValue(
  Info: PGsvObjectInspectorPropertyInfo): LongInt;
begin
  Result := 0;
  if csDesigning in ComponentState then
    Exit;
  if not Assigned(Info) then
    Exit;
  if HAS(_INTEGER, Info) and Assigned(FOnGetIntegerValue) then
    FOnGetIntegerValue(Self, Info, Result);
end;

procedure TGsvCustomObjectInspectorGrid.DoSetIntegerValue(
  Info: PGsvObjectInspectorPropertyInfo; const Value: LongInt);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Assigned(Info) then
    Exit;
  if HAS(_INTEGER, Info) and Assigned(FOnSetIntegerValue) then
    FOnSetIntegerValue(Self, Info, Value);
end;

procedure TGsvCustomObjectInspectorGrid.DoShowDialog;
begin
  PostMessage(Handle, WM_GSV_OBJECT_INSPECTOR_SHOW_DIALOG, 0, 0);
end;

// ����� �������� �����������, ������� ��������� ������ ��������
procedure TGsvCustomObjectInspectorGrid.DoFillList(
  Info: PGsvObjectInspectorPropertyInfo; List: TStrings);
begin
  if csDesigning in ComponentState then
    Exit;
  if Assigned(FOnFillList) and Assigned(Info) and Assigned(List) then
    FOnFillList(Self, Info, List);
end;

procedure TGsvCustomObjectInspectorGrid.DoHelp;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Assigned(FOnHelp) then
    Exit;
  if (FSelected >= 0) and (FSelected < FRowsCount) then
    FOnHelp(Self, FRows[FSelected]);
end;

procedure TGsvCustomObjectInspectorGrid.DoHint(
  Info: PGsvObjectInspectorPropertyInfo);
begin
  if csDesigning in ComponentState then
    Exit;
  if Assigned(FOnHint) and Assigned(Info) then
    FOnHint(Self, Info);
end;

function TGsvCustomObjectInspectorGrid.DoGetCaption(
  Info: PGsvObjectInspectorPropertyInfo): string;
begin
  if Assigned(Info) then begin
    Result := Info^.Caption;
    if Assigned(FOnGetCaption) and (not (csDesigning in ComponentState)) then
      FOnGetCaption(Self, Info, Result);
  end
  else
    Result := '';
end;

// ������ ��������� ������ �������
procedure TGsvCustomObjectInspectorGrid.NewObject;
begin
  EnumProperties;
end;

// ������� ������� ���������� - �������������� ������ �����������
procedure TGsvCustomObjectInspectorGrid.Clear;
begin
  HideLongHint;
  HideEditor;
  FProperties.Clear;
  FRowsCount := 0;
  FTopRow    := -1;
  FSelected  := -1;
  UpdateScrollBar;
  Invalidate;
  DoHint(nil);
end;

// ���� ����� ����� ���� ���� ������ �� ���������� ��� �������� ����, ���
// ������� ��������� �������� �������� ����� ���������. ����� ����� ��������
// � ��� �������, ����� ���������� �����-���� ����� �������� ������ ����������,
// �� ��������� � ���������� ������ ����� (��������, ������� �� ������ ������
// ������������). ���� �������� ����� �����, �� ��������� ����� �������
// �������������
procedure TGsvCustomObjectInspectorGrid.AcceptChanges;
begin
  if not Assigned(FEditor) then
    Exit;
  if (FRowsCount = 0) or (FSelected < 0) or (FSelected >= FRowsCount) then
    Exit;
  if FEditor.Visible and FEditor.Modified then begin
    ValueChanged(FRows[FSelected], FEditor.EditText);
    FEditor.Modified := False;
  end;
end;

{ � ������� �� Invalidate, ����� SmartInvalidate ��������� ���������
  ������ � ��� ������, ���� � ��������������� ������� ����������
  ���� ��� ��������� �������, ������������ � ������ ������
  �����������. ���� �������������� ����������� ������ �
  ��� ������, ���� ������������� ����� �� ��� �������, �� ����,
  �� ��������� � �������� ��������������. ����� SmartInvalidate
  ����� �������� �� ������� Application.OnIdle, �� ������-����
  ������� ��� �� ������-���� ������� �������
}
procedure TGsvCustomObjectInspectorGrid.SmartInvalidate;
var
  iMax: Integer;
  i:    Integer;
begin
  // ���������� �� ������, ���� ������� ��������� �������, ��� ����� ����
  // ����������
  if FInvalidateLock then
    Exit;
  try
    FInvalidateLock := True;
    // ������ ���������� ��������, ��������� ��� �������� ��������
    // � ���� ����������
    iMax := FTopRow + ClientHeight div FRowHeight;
    if (ClientHeight mod FRowHeight) <> 0 then
      Inc(iMax); // ���� �������� ������� ��������
    if iMax > Pred(FRowsCount) then
      iMax := Pred(FRowsCount);
    // �������� �� ���� ������� ���������
    if iMax > 0 then begin
      for i := FTopRow to iMax do begin
        if FRows[i]^.LastValue <> DoGetStringValue(FRows[i]) then begin
          Invalidate;
          UpdateEditor;
          Break;
        end;
      end;
    end;
  finally
    FInvalidateLock := False;
  end;
end;

procedure TGsvCustomObjectInspectorGrid.ExpandAll;
begin
  FProperties.ExpandAll(True);
  CreateRows;
  FTopRow   := -1;
  FSelected := -1;
  UpdateScrollBar;
  SetSelectedRow(0);
end;

procedure TGsvCustomObjectInspectorGrid.CollapseAll;
begin
  FProperties.ExpandAll(False);
  CreateRows;
  Invalidate;
  FTopRow   := -1;
  FSelected := -1;
  UpdateScrollBar;
  SetSelectedRow(0);
end;

function TGsvCustomObjectInspectorGrid.InplaceEditor: TCustomEdit;
begin
  Result := FEditor;
end;

function TGsvCustomObjectInspectorGrid.SelectedLeftBottom: TPoint;
var
  b: Integer;
begin
  if FSelected >= 0 then begin
    b      := (FSelected - FTopRow) * FRowHeight + FRowHeight;
    Result := ClientToScreen(Point(0, b));
  end
  else
    Result := ClientToScreen(Point(0, 0));
end;

function TGsvCustomObjectInspectorGrid.SelectedCenter: TPoint;
var
  y: Integer;
begin
  if FSelected >= 0 then begin
    y      := (FSelected - FTopRow) * FRowHeight + (FRowHeight div 2);
    Result := ClientToScreen(Point(ClientWidth div 2, y));
  end
  else
    Result := ClientToScreen(Point(0, 0));
end;

function TGsvCustomObjectInspectorGrid.SelectedInfo:
  PGsvObjectInspectorPropertyInfo;
begin
  if FSelected >= 0 then
    Result := FRows[FSelected]
  else
    Result := nil;
end;

function TGsvCustomObjectInspectorGrid.SelectedText: string;
begin
  if FSelected >= 0 then
    Result := DoGetStringValue(FRows[FSelected])
  else
    Result := '';
end;

// ��������� ����������� �������� �� ��� �����
procedure TGsvCustomObjectInspectorGrid.SetSelected(const aName: string);
var
  rc, s: Integer;
begin
  s := FProperties.SetSelected(aName);
  CreateRows;
  FTopRow   := 0;
  FSelected := -1;
  rc        := ClientHeight div FRowHeight;
  if s >= 0 then begin
    FTopRow := s - rc;
    if FTopRow < 0 then
      FTopRow := 0;
  end;
  UpdateScrollBar;
  if s >= 0 then
    SetSelectedRow(s);
end;

procedure TGsvCustomObjectInspectorGrid.ValidateStringValue(
  const Value: String);
begin
  if Assigned(FEditor) then
    FEditor.ValidateStringValue(Value);
end;

end.
