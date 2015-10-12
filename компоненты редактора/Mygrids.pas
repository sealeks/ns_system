
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1999-2002 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit Mygrids;

{$R-,T-,H+,X+}

interface

uses Messages, {$IFDEF LINUX} WinUtils, {$ENDIF} Windows, SysUtils, Classes,
  Variants, Graphics, Menus, Controls, Forms, grids, StdCtrls, Mask;


type
  TSelection = record
    StartPos, EndPos: Integer;
  end;


type
   TMyCustomListBox = class(TCustomMultiSelectListControl)
  private
    FAutoComplete: Boolean;
    FCount: Integer;
    FItems: TStrings;
    FFilter: String;
    FLastTime: Cardinal;
    FBorderStyle: TBorderStyle;
    FCanvas: TCanvas;
    FColumns: Integer;
    FItemHeight: Integer;
    FOldCount: Integer;
    FStyle: TListBoxStyle;
    FIntegralHeight: Boolean;
    FSorted: Boolean;
    FExtendedSelect: Boolean;
    FTabWidth: Integer;
    FSaveItems: TStringList;
    FSaveTopIndex: Integer;
    FSaveItemIndex: Integer;
    FOnDrawItem: TDrawItemEvent;
    FOnMeasureItem: TMeasureItemEvent;
    FOnData: TLBGetDataEvent;
    FOnDataFind: TLBFindDataEvent;
    FOnDataObject: TLBGetDataObjectEvent;
    function GetItemHeight: Integer;
    function GetTopIndex: Integer;
    procedure LBGetText(var Message: TMessage); message LB_GETTEXT;
    procedure LBGetTextLen(var Message: TMessage); message LB_GETTEXTLEN;
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetColumnWidth;
    procedure SetColumns(Value: Integer);
    procedure SetCount(const Value: Integer);
    procedure SetExtendedSelect(Value: Boolean);
    procedure SetIntegralHeight(Value: Boolean);
    procedure SetItemHeight(Value: Integer);
    procedure SetItems(Value: TStrings);
    procedure SetSelected(Index: Integer; Value: Boolean);
    procedure SetSorted(Value: Boolean);
    procedure SetStyle(Value: TListBoxStyle);
    procedure SetTabWidth(Value: Integer);
    procedure SetTopIndex(Value: Integer);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    function GetScrollWidth: Integer;
    procedure SetScrollWidth(const Value: Integer);
  protected
    FMoving: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function DoGetData(const Index: Integer): String;
    function DoGetDataObject(const Index: Integer): TObject;
    function DoFindData(const Data: String): Integer;
    procedure WndProc(var Message: TMessage); override;
    procedure DragCanceled; override;
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); virtual;
    function GetCount: Integer; override;
    function GetSelCount: Integer; override;
    procedure MeasureItem(Index: Integer; var Height: Integer); virtual;
    function InternalGetItemData(Index: Integer): Longint; dynamic;
    procedure InternalSetItemData(Index: Integer; AData: Longint); dynamic;
    function GetItemData(Index: Integer): LongInt; dynamic;
    function GetItemIndex: Integer; override;
    function GetSelected(Index: Integer): Boolean;
    procedure KeyPress(var Key: Char); override;
    procedure SetItemData(Index: Integer; AData: LongInt); dynamic;
    procedure ResetContent; dynamic;
    procedure DeleteString(Index: Integer); dynamic;
    procedure SetMultiSelect(Value: Boolean); override;
    procedure SetItemIndex(const Value: Integer); override;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Columns: Integer read FColumns write SetColumns default 0;
    property ExtendedSelect: Boolean read FExtendedSelect write SetExtendedSelect default True;
    property IntegralHeight: Boolean read FIntegralHeight write SetIntegralHeight default False;
    property ItemHeight: Integer read GetItemHeight write SetItemHeight;
    property ParentColor default False;
    property Sorted: Boolean read FSorted write SetSorted default False;
    property Style: TListBoxStyle read FStyle write SetStyle default lbStandard;
    property TabWidth: Integer read FTabWidth write SetTabWidth default 0;

    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
    property OnData: TLBGetDataEvent read FOnData write FOnData;
    property OnDataObject: TLBGetDataObjectEvent read FOnDataObject write FOnDataObject;
    property OnDataFind: TLBFindDataEvent read FOnDataFind write FOnDataFind;
  public
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddItem(Item: String; AObject: TObject); override;
    procedure Clear; override;
    procedure ClearSelection; override;
    procedure CopySelection(Destination: TCustomListControl); override;
    procedure DeleteSelected; override;
    function ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
    function ItemRect(Index: Integer): TRect;
    procedure SelectAll; override;
    property AutoComplete: Boolean read FAutoComplete write FAutoComplete default True;
    property Canvas: TCanvas read FCanvas;
    property Count: Integer read GetCount write SetCount;
    property Items: TStrings read FItems write SetItems;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property ScrollWidth: Integer read GetScrollWidth write SetScrollWidth default 0;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;
  published
    property TabStop default True;
  end;

  TListBox = class(TMyCustomListBox)
  published
    property Style;
    property AutoComplete;
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property ImeMode;
    property ImeName;
    property IntegralHeight;
    property ItemHeight;
    property Items;
    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollWidth;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property TabWidth;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnData;
    property OnDataFind;
    property OnDataObject;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

   TMyCustomGrid = class(TCustomGrid)
  private
    FAnchor: TGridCoord;
    FBorderStyle: TBorderStyle;
    FCanEditModify: Boolean;
    FColCount: Longint;
    FColWidths: Pointer;
    FTabStops: Pointer;
    FCurrent: TGridCoord;
    FDefaultColWidth: Integer;
    FDefaultRowHeight: Integer;
    FFixedCols: Integer;
    FFixedRows: Integer;
    FFixedColor: TColor;
    FGridLineWidth: Integer;
    FOptions: TGridOptions;
    FRowCount: Longint;
    FRowHeights: Pointer;
    FScrollBars: TScrollStyle;
    FTopLeft: TGridCoord;
    FSizingIndex: Longint;
    FSizingPos, FSizingOfs: Integer;
    FMoveIndex, FMovePos: Longint;
    FHitTest: TPoint;
    FInplaceEdit: TInplaceEdit;
    FInplaceCol, FInplaceRow: Longint;
    FColOffset: Integer;
    FDefaultDrawing: Boolean;
    FEditorMode: Boolean;
  {  function CalcCoordFromPoint(X, Y: Integer;
      const DrawInfo: TGridDrawInfo): TGridCoord;
    procedure CalcDrawInfoXY(var DrawInfo: TGridDrawInfo;
      UseWidth, UseHeight: Integer);
    function CalcMaxTopLeft(const Coord: TGridCoord;
      const DrawInfo: TGridDrawInfo): TGridCoord;
    procedure CancelMode;
    procedure ChangeSize(NewColCount, NewRowCount: Longint);
    procedure ClampInView(const Coord: TGridCoord);
    procedure DrawSizingLine(const DrawInfo: TGridDrawInfo);
    procedure DrawMove;
    procedure GridRectToScreenRect(GridRect: TGridRect;
      var ScreenRect: TRect; IncludeLine: Boolean);
    procedure Initialize;
    procedure InvalidateRect(ARect: TGridRect);
    procedure ModifyScrollBar(ScrollBar, ScrollCode, Pos: Cardinal;
      UseRightToLeft: Boolean);
    procedure MoveAdjust(var CellPos: Longint; FromIndex, ToIndex: Longint);
    procedure MoveAnchor(const NewAnchor: TGridCoord);
    procedure MoveAndScroll(Mouse, CellHit: Integer; var DrawInfo: TGridDrawInfo;
      var Axis: TGridAxisDrawInfo; Scrollbar: Integer; const MousePt: TPoint);
    procedure MoveCurrent(ACol, ARow: Longint; MoveAnchor, Show: Boolean);
    procedure MoveTopLeft(ALeft, ATop: Longint);
    procedure ResizeCol(Index: Longint; OldSize, NewSize: Integer);
    procedure ResizeRow(Index: Longint; OldSize, NewSize: Integer);
    procedure SelectionMoved(const OldSel: TGridRect);
    procedure ScrollDataInfo(DX, DY: Integer; var DrawInfo: TGridDrawInfo);
    procedure TopLeftMoved(const OldTopLeft: TGridCoord);
    procedure UpdateScrollPos;
    procedure UpdateScrollRange;
    function GetColWidths(Index: Longint): Integer;
    function GetRowHeights(Index: Longint): Integer;
    function GetSelection: TGridRect;
    function GetTabStops(Index: Longint): Boolean;
    function GetVisibleColCount: Integer;
    function GetVisibleRowCount: Integer;
    function IsActiveControl: Boolean;
    procedure ReadColWidths(Reader: TReader);
    procedure ReadRowHeights(Reader: TReader);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetCol(Value: Longint);
    procedure SetColCount(Value: Longint);
    procedure SetColWidths(Index: Longint; Value: Integer);
    procedure SetDefaultColWidth(Value: Integer);
    procedure SetDefaultRowHeight(Value: Integer);
    procedure SetEditorMode(Value: Boolean);
    procedure SetFixedColor(Value: TColor);
    procedure SetFixedCols(Value: Integer);
    procedure SetFixedRows(Value: Integer);
    procedure SetGridLineWidth(Value: Integer);
    procedure SetLeftCol(Value: Longint);
    procedure SetOptions(Value: TGridOptions);
    procedure SetRow(Value: Longint);
    procedure SetRowCount(Value: Longint);
    procedure SetRowHeights(Index: Longint; Value: Integer);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetSelection(Value: TGridRect);
    procedure SetTabStops(Index: Longint; Value: Boolean);
    procedure SetTopRow(Value: Longint);
    procedure UpdateEdit;
    procedure UpdateText;
    procedure WriteColWidths(Writer: TWriter);
    procedure WriteRowHeights(Writer: TWriter);
    procedure CMCancelMode(var Msg: TMessage); message CM_CANCELMODE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure WMCancelMode(var Msg: TWMCancelMode); message WM_CANCELMODE;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;  }
  public
    FGridState: TGridState;
    FSaveCellExtents: Boolean;
    DesignOptionsBoost: TGridOptions;
    VirtualView: Boolean;
    procedure UpdateText;
   { procedure CalcDrawInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcFixedInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcSizingState(X, Y: Integer; var State: TGridState;
      var Index: Longint; var SizingPos, SizingOfs: Integer;
      var FixedInfo: TGridDrawInfo); virtual;
    procedure ChangeGridOrientation(RightToLeftOrientation: Boolean);
    function CreateEditor: TInplaceEdit; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure AdjustSize(Index, Amount: Longint; Rows: Boolean); reintroduce; dynamic;
    function BoxRect(ALeft, ATop, ARight, ABottom: Longint): TRect;
    procedure DoExit; override;
    function CellRect(ACol, ARow: Longint): TRect;
    function CanEditAcceptKey(Key: Char): Boolean; dynamic;
    function CanGridAcceptKey(Key: Word; Shift: TShiftState): Boolean; dynamic;
    function CanEditModify: Boolean; dynamic;
    function CanEditShow: Boolean; virtual;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure FocusCell(ACol, ARow: Longint; MoveAnchor: Boolean);
    function GetEditText(ACol, ARow: Longint): string; dynamic;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); dynamic;
    function GetEditLimit: Integer; dynamic;
    function GetEditMask(ACol, ARow: Longint): string; dynamic;
    function GetEditStyle(ACol, ARow: Longint): TEditStyle; dynamic;
    function GetGridWidth: Integer;
    function GetGridHeight: Integer;
    procedure HideEdit;
    procedure HideEditor;
    procedure ShowEditor;
    procedure ShowEditorChar(Ch: Char);
    procedure InvalidateEditor;
    procedure InvalidateGrid;
    procedure MoveColumn(FromIndex, ToIndex: Longint);
    procedure ColumnMoved(FromIndex, ToIndex: Longint); dynamic;
    procedure MoveRow(FromIndex, ToIndex: Longint);
    procedure RowMoved(FromIndex, ToIndex: Longint); dynamic;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); virtual; abstract;
    procedure DefineProperties(Filer: TFiler); override;
    procedure MoveColRow(ACol, ARow: Longint; MoveAnchor, Show: Boolean);
    function SelectCell(ACol, ARow: Longint): Boolean; virtual;
    procedure SizeChanged(OldColCount, OldRowCount: Longint); dynamic;
    function Sizing(X, Y: Integer): Boolean;
    procedure ScrollData(DX, DY: Integer);
    procedure InvalidateCell(ACol, ARow: Longint);
    procedure InvalidateCol(ACol: Longint);
    procedure InvalidateRow(ARow: Longint);
    procedure TopLeftChanged; dynamic;
    procedure TimedScroll(Direction: TGridScrollDirection); dynamic;
    procedure Paint; override;
    procedure ColWidthsChanged; dynamic;
    procedure RowHeightsChanged; dynamic;
    procedure DeleteColumn(ACol: Longint); virtual;
    procedure DeleteRow(ARow: Longint); virtual;
    procedure UpdateDesigner;
    function BeginColumnDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function BeginRowDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function CheckColumnDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function CheckRowDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function EndColumnDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function EndRowDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;         }
    property BorderStyle;
    property Col;
    property Color;
    property ColCount;
    property ColWidths;
    property DefaultColWidth;
    property DefaultDrawing;
    property DefaultRowHeight;
    property EditorMode;
    property FixedColor;
    property FixedCols;
    property FixedRows;
    property GridHeight;
    property GridLineWidth;
    property GridWidth;
    property HitTest;
    property InplaceEditor;
    property LeftCol;
    property Options;
    property ParentColor;
    property Row;
    property RowCount;
    property RowHeights;
    property ScrollBars;
    property Selection;
    property TabStops;
    property TopRow;
    property VisibleColCount;
    property VisibleRowCount;
  {  constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function MouseCoord(X, Y: Integer): TGridCoord; }
  published
    property TabStop default True;
  end;


  TMyInplaceEdit = class(TCustomMaskEdit)
  private
    FGrid: TMyCustomGrid;
    FClickTime: Longint;
    procedure InternalMove(const Loc: TRect; Redraw: Boolean);
    procedure SetGrid(Value: TMyCustomGrid);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMPaste(var Message); message WM_PASTE;
    procedure WMCut(var Message); message WM_CUT;
    procedure WMClear(var Message); message WM_CLEAR;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DblClick; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    function EditCanModify: Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure BoundsChanged; virtual;
    procedure UpdateContents; virtual;
    procedure WndProc(var Message: TMessage); override;
    property  Grid: TMyCustomGrid read FGrid write FGrid;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Deselect;
    procedure Hide;
    procedure Invalidate; reintroduce;
    procedure Move(const Loc: TRect);
    function PosEqual(const Rect: TRect): Boolean;
    procedure SetFocus; reintroduce;
    procedure UpdateLoc(const Loc: TRect);
    function Visible: Boolean;
  end;


  TMyInplaceEditList = class(TMyInplaceEdit)
  private
    FButtonWidth: Integer;
    FPickList: TMyCustomListBox;
    FActiveList: TWinControl;
    FEditStyle: TEditStyle;
    FDropDownRows: Integer;
    FListVisible: Boolean;
    FTracking: Boolean;
    FPressed: Boolean;
    FPickListLoaded: Boolean;
    FOnGetPickListitems: TOnGetPickListItems;
    FOnEditButtonClick: TNotifyEvent;
    FMouseInControl: Boolean;
    function GetPickList: TMyCustomListBox;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CancelMode;
    procedure WMCancelMode(var Message: TMessage); message WM_CancelMode;
    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message wm_LButtonDblClk;
    procedure WMPaint(var Message: TWMPaint); message wm_Paint;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SetCursor;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure BoundsChanged; override;
    function ButtonRect: TRect;
    procedure CloseUp(Accept: Boolean); dynamic;
    procedure DblClick; override;
    procedure DoDropDownKeys(var Key: Word; Shift: TShiftState); virtual;
    procedure DoEditButtonClick; virtual;
    procedure DoGetPickListItems; dynamic;
    procedure DropDown; dynamic;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function OverButton(const P: TPoint): Boolean;
    procedure PaintWindow(DC: HDC); override;
    procedure StopTracking;
    procedure TrackButton(X,Y: Integer);
    procedure UpdateContents; override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(Owner: TComponent); override;
    procedure RestoreContents;
    property ActiveList: TWinControl read FActiveList write FActiveList;
    property ButtonWidth: Integer read FButtonWidth write FButtonWidth;
    property DropDownRows: Integer read FDropDownRows write FDropDownRows;
    property EditStyle: TEditStyle read FEditStyle;
    property ListVisible: Boolean read FListVisible write FListVisible;
    property PickList: TMyCustomListBox read GetPickList write FPickList;
    property PickListLoaded: Boolean read FPickListLoaded write FPickListLoaded;
    property Pressed: Boolean read FPressed;
    property OnEditButtonClick: TNotifyEvent read FOnEditButtonClick
      write FOnEditButtonClick;
    property OnGetPickListitems: TOnGetPickListItems read FOnGetPickListitems
      write FOnGetPickListitems;
  end;

 procedure KillMessage(Wnd: HWnd; Msg: Integer);

implementation

uses Math, Consts, RTLConsts, Themes;




constructor TMyInplaceEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  BorderStyle := bsNone;
  DoubleBuffered := False;
end;

procedure TMyInplaceEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TMyInplaceEdit.SetGrid(Value: TMyCustomGrid);
begin
  FGrid := Value;
end;

procedure TMyInplaceEdit.CMShowingChanged(var Message: TMessage);
begin
  { Ignore showing using the Visible property }
end;

procedure TMyInplaceEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in Grid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TMyInplaceEdit.WMPaste(var Message);
begin
  if not EditCanModify then Exit;
  inherited
end;

procedure TMyInplaceEdit.WMClear(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;

procedure TMyInplaceEdit.WMCut(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;

procedure TMyInplaceEdit.DblClick;
begin
  Grid.DblClick;
end;

function TMyInplaceEdit.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := Grid.DoMouseWheel(Shift, WheelDelta, MousePos);
end;

function TMyInplaceEdit.EditCanModify: Boolean;
begin
  Result := Grid.CanEditModify;
end;

procedure TMyInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    Grid.KeyDown(Key, Shift);
    Key := 0;
  end;

  procedure ParentEvent;
  var
    GridKeyDown: TKeyEvent;
  begin
    GridKeyDown := Grid.OnKeyDown;
    if Assigned(GridKeyDown) then GridKeyDown(Grid, Key, Shift);
  end;

  function ForwardMovement: Boolean;
  begin
    Result := goAlwaysShowEditor in Grid.Options;
  end;

  function Ctrl: Boolean;
  begin
    Result := ssCtrl in Shift;
  end;

  function Selection: TSelection;
  begin
    SendMessage(Handle, EM_GETSEL, Longint(@Result.StartPos), Longint(@Result.EndPos));
  end;

  function CaretPos: Integer;
  var
    P: TPoint;
  begin
    Windows.GetCaretPos(P);
    Result := SendMessage(Handle, EM_CHARFROMPOS, 0, MakeLong(P.X, P.Y));
  end;

  function RightSide: Boolean;
  begin
    with Selection do
      Result := (CaretPos = GetTextLen) and
        ((StartPos = 0) or (EndPos = StartPos)) and (EndPos = GetTextLen);
   end;

  function LeftSide: Boolean;
  begin
    with Selection do
      Result := (CaretPos = 0) and (StartPos = 0) and
        ((EndPos = 0) or (EndPos = GetTextLen));
  end;

begin
  case Key of
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_ESCAPE: SendToParent;
    VK_INSERT:
      if Shift = [] then SendToParent
      else if (Shift = [ssShift]) and not Grid.CanEditModify then Key := 0;
    VK_LEFT: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_RIGHT: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_HOME: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_END: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_F2:
      begin
        ParentEvent;
        if Key = VK_F2 then
        begin
          Deselect;
          Exit;
        end;
      end;
    VK_TAB: if not (ssAlt in Shift) then SendToParent;
    VK_DELETE:
      if Ctrl then
        SendToParent
      else
        if not Grid.CanEditModify then Key := 0;
  end;
  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;

procedure TMyInplaceEdit.KeyPress(var Key: Char);
var
  Selection: TSelection;
begin
  Grid.KeyPress(Key);
  if (Key in [#32..#255]) and not Grid.CanEditAcceptKey(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  case Key of
    #9, #27: Key := #0;
    #13:
      begin
        SendMessage(Handle, EM_GETSEL, Longint(@Selection.StartPos), Longint(@Selection.EndPos));
        if (Selection.StartPos = 0) and (Selection.EndPos = GetTextLen) then
          Deselect else
          SelectAll;
        Key := #0;
      end;
    ^H, ^V, ^X, #32..#255:
      if not Grid.CanEditModify then Key := #0;
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

procedure TMyInplaceEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  Grid.KeyUp(Key, Shift);
end;

procedure TMyInplaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if (GetParentForm(Self) = nil) or GetParentForm(Self).SetFocusedControl(Grid) then Dispatch(Message);
        Exit;
      end;
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited WndProc(Message);
end;

procedure TMyInplaceEdit.Deselect;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, Longint($FFFFFFFF));
end;

procedure TMyInplaceEdit.Invalidate;
var
  Cur: TRect;
begin
  ValidateRect(Handle, nil);
  InvalidateRect(Handle, nil, True);
  Windows.GetClientRect(Handle, Cur);
  MapWindowPoints(Handle, Grid.Handle, Cur, 2);
  ValidateRect(Grid.Handle, @Cur);
  InvalidateRect(Grid.Handle, @Cur, False);
end;

procedure TMyInplaceEdit.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
    if Focused then Windows.SetFocus(Grid.Handle);
  end;
end;

function TMyInplaceEdit.PosEqual(const Rect: TRect): Boolean;
var
  Cur: TRect;
begin
  GetWindowRect(Handle, Cur);
  MapWindowPoints(HWND_DESKTOP, Grid.Handle, Cur, 2);
  Result := EqualRect(Rect, Cur);
end;

procedure TMyInplaceEdit.InternalMove(const Loc: TRect; Redraw: Boolean);
begin
  if IsRectEmpty(Loc) then Hide
  else
  begin
    CreateHandle;
    Redraw := Redraw or not IsWindowVisible(Handle);
    Invalidate;
    with Loc do
      SetWindowPos(Handle, HWND_TOP, Left, Top, Right - Left, Bottom - Top,
        SWP_SHOWWINDOW or SWP_NOREDRAW);
    BoundsChanged;
    if Redraw then Invalidate;
    if Grid.Focused then
      Windows.SetFocus(Handle);
  end;
end;

procedure TMyInplaceEdit.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 2, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TMyInplaceEdit.UpdateLoc(const Loc: TRect);
begin
  InternalMove(Loc, False);
end;

function TMyInplaceEdit.Visible: Boolean;
begin
  Result := IsWindowVisible(Handle);
end;

procedure TMyInplaceEdit.Move(const Loc: TRect);
begin
  InternalMove(Loc, True);
end;

procedure TMyInplaceEdit.SetFocus;
begin
  if IsWindowVisible(Handle) then
    Windows.SetFocus(Handle);
end;

procedure TMyInplaceEdit.UpdateContents;
begin
  Text := '';
  EditMask := Grid.GetEditMask(Grid.Col, Grid.Row);
  Text := Grid.GetEditText(Grid.Col, Grid.Row);
  MaxLength := Grid.GetEditLimit;
end;





 type
  TPopupListbox = class(TMyCustomListBox)
  private
    FSearchText: String;
    FSearchTickCount: Longint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

procedure TPopupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    AddBiDiModeExStyle(ExStyle);
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TPopupListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, wm_SetFocus, 0, 0);
end;

procedure TPopupListbox.Keypress(var Key: Char);
var
  TickCount: Integer;
begin
  case Key of
    #8, #27: FSearchText := '';
    #32..#255:
      begin
        TickCount := GetTickCount;
        if TickCount - FSearchTickCount > 2000 then FSearchText := '';
        FSearchTickCount := TickCount;
        if Length(FSearchText) < 32 then FSearchText := FSearchText + Key;
        SendMessage(Handle, LB_SelectString, WORD(-1), Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

procedure TPopupListbox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  TMyInplaceEditList(Owner).CloseUp((X >= 0) and (Y >= 0) and
      (X < Width) and (Y < Height));
end;

{ TMyInplaceEditList }

constructor TMyInplaceEditList.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FEditStyle := esSimple;
end;

procedure TMyInplaceEditList.BoundsChanged;
var
  R: TRect;
begin
  SetRect(R, 2, 2, Width - 2, Height);
  if EditStyle <> esSimple then
    if not Grid.UseRightToLeftAlignment then
      Dec(R.Right, ButtonWidth)
    else
      Inc(R.Left, ButtonWidth - 2);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
  if SysLocale.FarEast then
    SetImeCompositionWindow(Font, R.Left, R.Top);
end;

procedure TMyInplaceEditList.CloseUp(Accept: Boolean);
var
  ListValue: Variant;
begin
  if ListVisible and (ActiveList = FPickList) then
  begin
    if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    if PickList.ItemIndex <> -1 then
      ListValue := PickList.Items[PickList.ItemIndex];
    SetWindowPos(ActiveList.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    FListVisible := False;
    Invalidate;
    if Accept then
      if (not VarIsEmpty(ListValue) or VarIsNull(ListValue))
         and (ListValue <> Text) then
      begin
        { Here we store the new value directly in the edit control so that
          we bypass the CMTextChanged method on TCustomMaskedEdit.  This
          preserves the old value so that we can restore it later by calling
          the Reset method. }
        Perform(WM_SETTEXT, 0, Longint(string(ListValue)));
        Modified := True;
        with Grid do
          SetEditText(Col, Row, ListValue);
      end;
  end;
end;

procedure TMyInplaceEditList.DoDropDownKeys(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP, VK_DOWN:
      if ssAlt in Shift then
      begin
        if ListVisible then CloseUp(True) else DropDown;
        Key := 0;
      end;
    VK_RETURN, VK_ESCAPE:
      if ListVisible and not (ssAlt in Shift) then
      begin
        CloseUp(Key = VK_RETURN);
        Key := 0;
      end;
  end;
end;

procedure TMyInplaceEditList.DoEditButtonClick;
begin
  if Assigned(FOnEditButtonClick) then
    FOnEditButtonClick(Grid);
end;

procedure TMyInplaceEditList.DoGetPickListItems;
begin
  if not PickListLoaded then
  begin
    if Assigned(OnGetPickListItems) then
      OnGetPickListItems(Grid.Col, Grid.Row, PickList.Items);
    PickListLoaded := (PickList.Items.Count > 0);
  end;
end;

function TMyInplaceEditList.GetPickList: TMyCustomListBox;
var
  PopupListbox: TPopupListbox;
begin
  if not Assigned(FPickList) then
  begin
    PopupListbox := TPopupListbox.Create(Self);
    PopupListbox.Visible := False;
    PopupListbox.Parent := Self;
    PopupListbox.OnMouseUp := ListMouseUp;
    PopupListbox.IntegralHeight := True;
    PopupListbox.ItemHeight := 11;
    FPickList := PopupListBox;
  end;
  Result := FPickList;
end;

procedure TMyInplaceEditList.DropDown;
var
  P: TPoint;
  I,J,Y: Integer;
begin
  if not ListVisible then
  begin
    ActiveList.Width := Width;
    if ActiveList = FPickList then
    begin
      DoGetPickListItems;
      TPopupListbox(PickList).Color := Color;
      TPopupListbox(PickList).Font := Font;
      if (DropDownRows > 0) and (PickList.Items.Count >= DropDownRows) then
        PickList.Height := DropDownRows * TPopupListbox(PickList).ItemHeight + 4
      else
        PickList.Height := PickList.Items.Count * TPopupListbox(PickList).ItemHeight + 4;
      if Text = '' then
        PickList.ItemIndex := -1
      else
        PickList.ItemIndex := PickList.Items.IndexOf(Text);
      J := PickList.ClientWidth;
      for I := 0 to PickList.Items.Count - 1 do
      begin
        Y := PickList.Canvas.TextWidth(PickList.Items[I]);
        if Y > J then J := Y;
      end;
      PickList.ClientWidth := J;
    end;
    P := Parent.ClientToScreen(Point(Left, Top));
    Y := P.Y + Height;
    if Y + ActiveList.Height > Screen.Height then Y := P.Y - ActiveList.Height;
    SetWindowPos(ActiveList.Handle, HWND_TOP, P.X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    FListVisible := True;
    Invalidate;
    Windows.SetFocus(Handle);
  end;
end;

procedure TMyInplaceEditList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (EditStyle = esEllipsis) and (Key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    DoEditButtonClick;
    KillMessage(Handle, WM_CHAR);
  end
  else
    inherited KeyDown(Key, Shift);
end;

procedure TMyInplaceEditList.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(ActiveList.ClientRect, Point(X, Y)));
end;

procedure TMyInplaceEditList.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Button = mbLeft) and (EditStyle <> esSimple) and
    OverButton(Point(X,Y)) then
  begin
    if ListVisible then
      CloseUp(False)
    else
    begin
      MouseCapture := True;
      FTracking := True;
      TrackButton(X, Y);
      if Assigned(ActiveList) then
        DropDown;
    end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TMyInplaceEditList.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
begin
  if FTracking then
  begin
    TrackButton(X, Y);
    if ListVisible then
    begin
      ListPos := ActiveList.ScreenToClient(ClientToScreen(Point(X, Y)));
      if PtInRect(ActiveList.ClientRect, ListPos) then
      begin
        StopTracking;
        MousePos := PointToSmallPoint(ListPos);
        SendMessage(ActiveList.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
        Exit;
      end;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TMyInplaceEditList.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  WasPressed: Boolean;
begin
  WasPressed := Pressed;
  StopTracking;
  if (Button = mbLeft) and (EditStyle = esEllipsis) and WasPressed then
    DoEditButtonClick;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TMyInplaceEditList.PaintWindow(DC: HDC);
var
  R: TRect;
  Flags: Integer;
  W, X, Y: Integer;
  Details: TThemedElementDetails;
begin
  if EditStyle <> esSimple then
  begin
    R := ButtonRect;
    Flags := 0;
    case EditStyle of
      esPickList:
        begin
          if ThemeServices.ThemesEnabled then
          begin
            if ActiveList = nil then
              Details := ThemeServices.GetElementDetails(tcDropDownButtonDisabled)
            else
              if Pressed then
                Details := ThemeServices.GetElementDetails(tcDropDownButtonPressed)
              else
                if FMouseInControl then
                  Details := ThemeServices.GetElementDetails(tcDropDownButtonHot)
                else
                  Details := ThemeServices.GetElementDetails(tcDropDownButtonNormal);
            ThemeServices.DrawElement(DC, Details, R);
          end
          else
          begin
            if ActiveList = nil then
              Flags := DFCS_INACTIVE
            else if Pressed then
              Flags := DFCS_FLAT or DFCS_PUSHED;
            DrawFrameControl(DC, R, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
          end;
        end;
      esEllipsis:
        begin
          if ThemeServices.ThemesEnabled then
          begin
            if Pressed then
              Details := ThemeServices.GetElementDetails(tbPushButtonPressed)
            else
              if FMouseInControl then
                Details := ThemeServices.GetElementDetails(tbPushButtonHot)
              else
                Details := ThemeServices.GetElementDetails(tbPushButtonNormal);
            ThemeServices.DrawElement(DC, Details, R);
          end
          else
          begin
            if Pressed then Flags := BF_FLAT;
            DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
          end;

          X := R.Left + ((R.Right - R.Left) shr 1) - 1 + Ord(Pressed);
          Y := R.Top + ((R.Bottom - R.Top) shr 1) - 1 + Ord(Pressed);
          W := ButtonWidth shr 3;
          if W = 0 then W := 1;
          PatBlt(DC, X, Y, W, W, BLACKNESS);
          PatBlt(DC, X - (W * 2), Y, W, W, BLACKNESS);
          PatBlt(DC, X + (W * 2), Y, W, W, BLACKNESS);
        end;
    end;
    ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
  end;
  inherited PaintWindow(DC);
end;

procedure TMyInplaceEditList.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TMyInplaceEditList.TrackButton(X,Y: Integer);
var
  NewState: Boolean;
  R: TRect;
begin
  R := ButtonRect;
  NewState := PtInRect(R, Point(X, Y));
  if Pressed <> NewState then
  begin
    FPressed := NewState;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TMyInplaceEditList.UpdateContents;
begin
  ActiveList := nil;
  PickListLoaded := False;
  FEditStyle := Grid.GetEditStyle(Grid.Col, Grid.Row);
  if EditStyle = esPickList then
    ActiveList := PickList;
  inherited UpdateContents;
end;

procedure TMyInplaceEditList.RestoreContents;
begin
  Reset;
  Grid.UpdateText;
end;

procedure TMyInplaceEditList.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> ActiveList) then
    CloseUp(False);
end;

procedure TMyInplaceEditList.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TMyInplaceEditList.WMKillFocus(var Message: TMessage);
begin
  if not SysLocale.FarEast then inherited
  else
  begin
    ImeName := Screen.DefaultIme;
    ImeMode := imDontCare;
    inherited;
    if HWND(Message.WParam) <> Grid.Handle then
      ActivateKeyboardLayout(Screen.DefaultKbLayout, KLF_ACTIVATE);
  end;
  CloseUp(False);
end;

function TMyInplaceEditList.ButtonRect: TRect;
begin
  if not Grid.UseRightToLeftAlignment then
    Result := Rect(Width - ButtonWidth, 0, Width, Height)
  else
    Result := Rect(0, 0, ButtonWidth, Height);
end;

function TMyInplaceEditList.OverButton(const P: TPoint): Boolean;
begin
  Result := PtInRect(ButtonRect, P);
end;

procedure TMyInplaceEditList.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  with Message do
  if (EditStyle <> esSimple) and OverButton(Point(XPos, YPos)) then
    Exit;
  inherited;
end;

procedure TMyInplaceEditList.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TMyInplaceEditList.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  if (EditStyle <> esSimple) and OverButton(P) then
    Windows.SetCursor(LoadCursor(0, idc_Arrow))
  else
    inherited;
end;

procedure TMyInplaceEditList.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    wm_KeyDown, wm_SysKeyDown, wm_Char:
      if EditStyle = esPickList then
      with TWMKey(Message) do
      begin
        DoDropDownKeys(CharCode, KeyDataToShiftState(KeyData));
        if (CharCode <> 0) and ListVisible then
        begin
          with TMessage(Message) do
            SendMessage(ActiveList.Handle, Msg, WParam, LParam);
          Exit;
        end;
      end
  end;
  inherited;
end;

procedure TMyInplaceEditList.DblClick;
var
  Index: Integer;
  ListValue: string;
begin
  if (EditStyle = esSimple) or Assigned(Grid.OnDblClick) then
    inherited
  else if (EditStyle = esPickList) and (ActiveList = PickList) then
  begin
    DoGetPickListItems;
    if PickList.Items.Count > 0 then
    begin
      Index := PickList.ItemIndex + 1;
      if Index >= PickList.Items.Count then
        Index := 0;
      PickList.ItemIndex := Index;
      ListValue := PickList.Items[PickList.ItemIndex];
      Perform(WM_SETTEXT, 0, Longint(ListValue));
      Modified := True;
      with Grid do
        SetEditText(Col, Row, ListValue);
      SelectAll;
    end;
  end
  else if EditStyle = esEllipsis then
    DoEditButtonClick;
end;

procedure TMyInplaceEditList.CMMouseEnter(var Message: TMessage);
begin
  inherited;

  if ThemeServices.ThemesEnabled and not FMouseInControl then
  begin
    FMouseInControl := True;
    Invalidate;
  end;
end;

procedure TMyInplaceEditList.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if ThemeServices.ThemesEnabled and FMouseInControl then
  begin
    FMouseInControl := False;
    Invalidate;
  end;
end;






constructor TMyCustomListBox.Create(AOwner: TComponent);
const
  ListBoxStyle = [csSetCaption, csDoubleClicks, csOpaque];
begin
  inherited Create(AOwner);
  if NewStyleControls then
    ControlStyle := ListBoxStyle else
    ControlStyle := ListBoxStyle + [csFramed];
  Width := 121;
  Height := 97;
  TabStop := True;
  ParentColor := False;
  FAutoComplete := True;
 // FItems := TListBoxStrings.Create;
  //TListBoxStrings(FItems).ListBox := Self;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  FItemHeight := 16;
  FBorderStyle := bsSingle;
  FExtendedSelect := True;
  FOldCount := -1;
end;

destructor TMyCustomListBox.Destroy;
begin
  inherited Destroy;
  FCanvas.Free;
  FItems.Free;
  FSaveItems.Free;
end;

procedure TMyCustomListBox.AddItem(Item: String; AObject: TObject);
var
  S: String;
begin
  SetString(S, PChar(Item), StrLen(PChar(Item)));
  Items.AddObject(S, AObject);
end;

function TMyCustomListBox.GetItemData(Index: Integer): LongInt;
begin
  Result := SendMessage(Handle, LB_GETITEMDATA, Index, 0);
end;

procedure TMyCustomListBox.SetItemData(Index: Integer; AData: LongInt);
begin
  SendMessage(Handle, LB_SETITEMDATA, Index, AData);
end;

function TMyCustomListBox.InternalGetItemData(Index: Integer): LongInt;
begin
  Result := GetItemData(Index);
end;

procedure TMyCustomListBox.InternalSetItemData(Index: Integer; AData: LongInt);
begin
  SetItemData(Index, AData);
end;

procedure TMyCustomListBox.DeleteString( Index: Integer );
begin
  SendMessage(Handle, LB_DELETESTRING, Index, 0);
end;

procedure TMyCustomListBox.ResetContent;
begin
  if Style in [lbVirtual, lbVirtualOwnerDraw] then exit;
  SendMessage(Handle, LB_RESETCONTENT, 0, 0);
end;

procedure TMyCustomListBox.Clear;
begin
  FItems.Clear;
end;

procedure TMyCustomListBox.ClearSelection;
var
  I: Integer;
begin
  if MultiSelect then
    for I := 0 to Items.Count - 1 do
      Selected[I] := False
  else
    ItemIndex := -1;
end;

procedure TMyCustomListBox.CopySelection(Destination: TCustomListControl);
var
  I: Integer;
begin
  if MultiSelect then
  begin
    for I := 0 to Items.Count - 1 do
      if Selected[I] then
        Destination.AddItem(PChar(Items[I]), Items.Objects[I]);
  end
  else
    if ItemIndex <> -1 then
      Destination.AddItem(PChar(Items[ItemIndex]), Items.Objects[ItemIndex]);
end;

procedure TMyCustomListBox.DeleteSelected;
var
  I: Integer;
begin
  if MultiSelect then
  begin
    for I := Items.Count - 1 downto 0 do
      if Selected[I] then
        Items.Delete(I);
  end
  else
    if ItemIndex <> -1 then
      Items.Delete(ItemIndex);
end;

procedure TMyCustomListBox.SetColumnWidth;
var
  ColWidth: Integer;
begin
  if (FColumns > 0) and (Width > 0) then
  begin
    ColWidth := Trunc(ClientWidth / FColumns);
    if ColWidth < 1 then ColWidth := 1;
    SendMessage(Handle, LB_SETCOLUMNWIDTH, ColWidth, 0);
  end;
end;

procedure TMyCustomListBox.SetColumns(Value: Integer);
begin
  if FColumns <> Value then
    if (FColumns = 0) or (Value = 0) then
    begin
      FColumns := Value;
      RecreateWnd;
    end else
    begin
      FColumns := Value;
      if HandleAllocated then SetColumnWidth;
    end;
end;

function TMyCustomListBox.GetItemIndex: Integer;
begin
  if MultiSelect then
    Result := SendMessage(Handle, LB_GETCARETINDEX, 0, 0)
  else
    Result := SendMessage(Handle, LB_GETCURSEL, 0, 0);
end;

function TMyCustomListBox.GetCount: Integer;
begin
  if Style in [lbVirtual, lbVirtualOwnerDraw] then
    Result := FCount
  else
    Result := Items.Count;
end;

function TMyCustomListBox.GetSelCount: Integer;
begin
  Result := SendMessage(Handle, LB_GETSELCOUNT, 0, 0);
end;

procedure TMyCustomListBox.SetItemIndex(const Value: Integer);
begin
  if GetItemIndex <> Value then
    if MultiSelect then SendMessage(Handle, LB_SETCARETINDEX, Value, 0)
    else SendMessage(Handle, LB_SETCURSEL, Value, 0);
end;

procedure TMyCustomListBox.SetExtendedSelect(Value: Boolean);
begin
  if Value <> FExtendedSelect then
  begin
    FExtendedSelect := Value;
    RecreateWnd;
  end;
end;

procedure TMyCustomListBox.SetIntegralHeight(Value: Boolean);
begin
  if Value <> FIntegralHeight then
  begin
    FIntegralHeight := Value;
    RecreateWnd;
    RequestAlign;
  end;
end;

function TMyCustomListBox.GetItemHeight: Integer;
var
  R: TRect;
begin
  Result := FItemHeight;
  if HandleAllocated and (FStyle = lbStandard) then
  begin
    Perform(LB_GETITEMRECT, 0, Longint(@R));
    Result := R.Bottom - R.Top;
  end;
end;

procedure TMyCustomListBox.SetItemHeight(Value: Integer);
begin
  if (FItemHeight <> Value) and (Value > 0) then
  begin
    FItemHeight := Value;
    RecreateWnd;
  end;
end;

procedure TMyCustomListBox.SetTabWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if FTabWidth <> Value then
  begin
    FTabWidth := Value;
    RecreateWnd;
  end;
end;

procedure TMyCustomListBox.SetMultiSelect(Value: Boolean);
begin
  if FMultiSelect <> Value then
  begin
    FMultiSelect := Value;
    RecreateWnd;
  end;
end;

function TMyCustomListBox.GetSelected(Index: Integer): Boolean;
var
  R: Longint;
begin
  R := SendMessage(Handle, LB_GETSEL, Index, 0);
  if R = LB_ERR then
    raise EListError.CreateResFmt(@SListIndexError, [Index]);
  Result := LongBool(R);
end;

procedure TMyCustomListBox.SetSelected(Index: Integer; Value: Boolean);
begin
  if FMultiSelect then
  begin
    if SendMessage(Handle, LB_SETSEL, Longint(Value), Index) = LB_ERR then
      raise EListError.CreateResFmt(@SListIndexError, [Index]);
  end
  else
    if Value then
    begin
      if SendMessage(Handle, LB_SETCURSEL, Index, 0) = LB_ERR then
        raise EListError.CreateResFmt(@SListIndexError, [Index])
    end
    else
      SendMessage(Handle, LB_SETCURSEL, -1, 0);
end;

procedure TMyCustomListBox.SetSorted(Value: Boolean);
begin
  if Style in [lbVirtual, lbVirtualOwnerDraw] then exit;
  if FSorted <> Value then
  begin
    FSorted := Value;
    RecreateWnd;
  end;
end;

procedure TMyCustomListBox.SetStyle(Value: TListBoxStyle);
begin
  if FStyle <> Value then
  begin
    if Value in [lbVirtual, lbVirtualOwnerDraw] then
    begin
      Items.Clear;
      Sorted := False;
    end;
    FStyle := Value;
    RecreateWnd;
  end;
end;

function TMyCustomListBox.GetTopIndex: Integer;
begin
  Result := SendMessage(Handle, LB_GETTOPINDEX, 0, 0);
end;

procedure TMyCustomListBox.LBGetText(var Message: TMessage);
var
  S: string;
begin
  if Style in [lbVirtual, lbVirtualOwnerDraw] then
  begin
    if Assigned(FOnData) and (Message.WParam > -1) and (Message.WParam < Count) then
    begin
      S := '';
      OnData(Self, Message.wParam, S);
      StrCopy(PChar(Message.lParam), PChar(S));
      Message.Result := Length(S);
    end
    else
      Message.Result := LB_ERR;
  end
  else
    inherited;
end;

procedure TMyCustomListBox.LBGetTextLen(var Message: TMessage);
var
  S: string;
begin
  if Style in [lbVirtual, lbVirtualOwnerDraw] then
  begin
    if Assigned(FOnData) and (Message.WParam > -1) and (Message.WParam < Count) then
    begin
      S := '';
      OnData(Self, Message.wParam, S);
      Message.Result := Length(S);
    end
    else
      Message.Result := LB_ERR;
  end
  else
    inherited;
end;

procedure TMyCustomListBox.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TMyCustomListBox.SetTopIndex(Value: Integer);
begin
  if GetTopIndex <> Value then
    SendMessage(Handle, LB_SETTOPINDEX, Value, 0);
end;

procedure TMyCustomListBox.SetItems(Value: TStrings);
begin
  if Style in [lbVirtual, lbVirtualOwnerDraw] then
    case Style of
      lbVirtual: Style := lbStandard;
      lbVirtualOwnerDraw: Style := lbOwnerDrawFixed;
    end;
  Items.Assign(Value);
end;

function TMyCustomListBox.ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
var
  Count: Integer;
  ItemRect: TRect;
begin
  if PtInRect(ClientRect, Pos) then
  begin
    Result := TopIndex;
    Count := Items.Count;
    while Result < Count do
    begin
      Perform(LB_GETITEMRECT, Result, Longint(@ItemRect));
      if PtInRect(ItemRect, Pos) then Exit;
      Inc(Result);
    end;
    if not Existing then Exit;
  end;
  Result := -1;
end;

function TMyCustomListBox.ItemRect(Index: Integer): TRect;
var
  Count: Integer;
begin
  Count := Items.Count;
  if (Index = 0) or (Index < Count) then
    Perform(LB_GETITEMRECT, Index, Longint(@Result))
  else if Index = Count then
  begin
    Perform(LB_GETITEMRECT, Index - 1, Longint(@Result));
    OffsetRect(Result, 0, Result.Bottom - Result.Top);
  end else FillChar(Result, SizeOf(Result), 0);
end;

procedure TMyCustomListBox.CreateParams(var Params: TCreateParams);
type
  PSelects = ^TSelects;
  TSelects = array[Boolean] of DWORD;
const
  Styles: array[TListBoxStyle] of DWORD =
    (0, LBS_OWNERDRAWFIXED, LBS_OWNERDRAWVARIABLE, LBS_OWNERDRAWFIXED,
     LBS_OWNERDRAWFIXED);
  Sorteds: array[Boolean] of DWORD = (0, LBS_SORT);
  MultiSelects: array[Boolean] of DWORD = (0, LBS_MULTIPLESEL);
  ExtendSelects: array[Boolean] of DWORD = (0, LBS_EXTENDEDSEL);
  IntegralHeights: array[Boolean] of DWORD = (LBS_NOINTEGRALHEIGHT, 0);
  MultiColumns: array[Boolean] of DWORD = (0, LBS_MULTICOLUMN);
  TabStops: array[Boolean] of DWORD = (0, LBS_USETABSTOPS);
  CSHREDRAW: array[Boolean] of DWORD = (CS_HREDRAW, 0);
  Data: array[Boolean] of DWORD = (LBS_HASSTRINGS, LBS_NODATA);
var
  Selects: PSelects;
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'LISTBOX');
  with Params do
  begin
    Selects := @MultiSelects;
    if FExtendedSelect then Selects := @ExtendSelects;
    Style := Style or (WS_HSCROLL or WS_VSCROLL or
      Data[Self.Style in [lbVirtual, lbVirtualOwnerDraw]] or
      LBS_NOTIFY) or Styles[FStyle] or Sorteds[FSorted] or
      Selects^[FMultiSelect] or IntegralHeights[FIntegralHeight] or
    //  MultiColumns[FColumns <> 0] or BorderStyles[FBorderStyle] or
      TabStops[FTabWidth <> 0];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
    WindowClass.style := WindowClass.style and not (CSHREDRAW[UseRightToLeftAlignment] or CS_VREDRAW);
  end;
end;

procedure TMyCustomListBox.CreateWnd;
var
  W, H: Integer;
begin
  W := Width;
  H := Height;
  inherited CreateWnd;
  SetWindowPos(Handle, 0, Left, Top, W, H, SWP_NOZORDER or SWP_NOACTIVATE);
  if FTabWidth <> 0 then
    SendMessage(Handle, LB_SETTABSTOPS, 1, Longint(@FTabWidth));
  SetColumnWidth;
  if (FOldCount <> -1) or Assigned(FSaveItems) then
  begin
    if (Style in [lbVirtual, lbVirtualOwnerDraw]) then
      Count := FOldCount;
    if FSaveItems <> nil then
    begin
      FItems.Assign(FSaveItems);
      FreeAndNil(FSaveItems);
    end;
    SetTopIndex(FSaveTopIndex);
    SetItemIndex(FSaveItemIndex);
    FOldCount := -1;
  end;
end;

procedure TMyCustomListBox.DestroyWnd;
begin
  if (FItems.Count > 0) then
  begin
    if (Style in [lbVirtual, lbVirtualOwnerDraw]) then
      FOldCount := FItems.Count
    else
    begin
      FSaveItems := TStringList.Create;
      FSaveItems.Assign(FItems);
    end;
    FSaveTopIndex := GetTopIndex;
    FSaveItemIndex := GetItemIndex;
  end;
  inherited DestroyWnd;
end;

procedure TMyCustomListBox.WndProc(var Message: TMessage);
begin
  {for auto drag mode, let listbox handle itself, instead of TControl}
  if not (csDesigning in ComponentState) and ((Message.Msg = WM_LBUTTONDOWN) or
    (Message.Msg = WM_LBUTTONDBLCLK)) and not Dragging then
  begin
    if DragMode = dmAutomatic then
    begin
      if IsControlMouseMsg(TWMMouse(Message)) then
        Exit;
      ControlState := ControlState + [csLButtonDown];
      Dispatch(Message);  {overrides TControl's BeginDrag}
      Exit;
    end;
  end;
  inherited WndProc(Message);
end;

procedure TMyCustomListBox.WMLButtonDown(var Message: TWMLButtonDown);
var
  ItemNo : Integer;
  ShiftState: TShiftState;
begin
  ShiftState := KeysToShiftState(Message.Keys);
  if (DragMode = dmAutomatic) and FMultiSelect then
  begin
    if not (ssShift in ShiftState) or (ssCtrl in ShiftState) then
    begin
      ItemNo := ItemAtPos(SmallPointToPoint(Message.Pos), True);
      if (ItemNo >= 0) and (Selected[ItemNo]) then
      begin
        BeginDrag (False);
        Exit;
      end;
    end;
  end;
  inherited;
  if (DragMode = dmAutomatic) and not (FMultiSelect and
    ((ssCtrl in ShiftState) or (ssShift in ShiftState))) then
    BeginDrag(False);
end;

procedure TMyCustomListBox.CNCommand(var Message: TWMCommand);
begin
  case Message.NotifyCode of
    LBN_SELCHANGE:
      begin
        inherited Changed;
        Click;
      end;
    LBN_DBLCLK: DblClick;
  end;
end;

procedure TMyCustomListBox.WMPaint(var Message: TWMPaint);

  procedure PaintListBox;
  var
    DrawItemMsg: TWMDrawItem;
    MeasureItemMsg: TWMMeasureItem;
    DrawItemStruct: TDrawItemStruct;
    MeasureItemStruct: TMeasureItemStruct;
    R: TRect;
    Y, I, H, W: Integer;
  begin
    { Initialize drawing records }
    DrawItemMsg.Msg := CN_DRAWITEM;
    DrawItemMsg.DrawItemStruct := @DrawItemStruct;
    DrawItemMsg.Ctl := Handle;
    DrawItemStruct.CtlType := ODT_LISTBOX;
    DrawItemStruct.itemAction := ODA_DRAWENTIRE;
    DrawItemStruct.itemState := 0;
    DrawItemStruct.hDC := Message.DC;
    DrawItemStruct.CtlID := Handle;
    DrawItemStruct.hwndItem := Handle;

    { Intialize measure records }
    MeasureItemMsg.Msg := CN_MEASUREITEM;
    MeasureItemMsg.IDCtl := Handle;
    MeasureItemMsg.MeasureItemStruct := @MeasureItemStruct;
    MeasureItemStruct.CtlType := ODT_LISTBOX;
    MeasureItemStruct.CtlID := Handle;

    { Draw the listbox }
    Y := 0;
    I := TopIndex;
    GetClipBox(Message.DC, R);
    H := Height;
    W := Width;
    while Y < H do
    begin
      MeasureItemStruct.itemID := I;
      if I < Items.Count then
        MeasureItemStruct.itemData := Longint(Pointer(Items.Objects[I]));
      MeasureItemStruct.itemWidth := W;
      MeasureItemStruct.itemHeight := FItemHeight;
      DrawItemStruct.itemData := MeasureItemStruct.itemData;
      DrawItemStruct.itemID := I;
      Dispatch(MeasureItemMsg);
      DrawItemStruct.rcItem := Rect(0, Y, MeasureItemStruct.itemWidth,
        Y + Integer(MeasureItemStruct.itemHeight));
      Dispatch(DrawItemMsg);
      Inc(Y, MeasureItemStruct.itemHeight);
      Inc(I);
      if I >= Items.Count then break;
    end;
  end;

begin
  if Message.DC <> 0 then
    { Listboxes don't allow paint "sub-classing" like the other windows controls
      so we have to do it ourselves. }
    PaintListBox
  else inherited;
end;

procedure TMyCustomListBox.WMSize(var Message: TWMSize);
begin
  inherited;
  SetColumnWidth;
end;

procedure TMyCustomListBox.DragCanceled;
var
  M: TWMMouse;
  MousePos: TPoint;
begin
  with M do
  begin
    Msg := WM_LBUTTONDOWN;
    GetCursorPos(MousePos);
    Pos := PointToSmallPoint(ScreenToClient(MousePos));
    Keys := 0;
    Result := 0;
  end;
  DefaultHandler(M);
  M.Msg := WM_LBUTTONUP;
  DefaultHandler(M);
end;

procedure TMyCustomListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  Flags: Longint;
  Data: String;
begin
  if Assigned(FOnDrawItem) then FOnDrawItem(Self, Index, Rect, State) else
  begin
    FCanvas.FillRect(Rect);
    if Index < Count then
    begin
      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      if not UseRightToLeftAlignment then
        Inc(Rect.Left, 2)
      else
        Dec(Rect.Right, 2);
      Data := '';
      if (Style in [lbVirtual, lbVirtualOwnerDraw]) then
        Data := DoGetData(Index)
      else
        Data := Items[Index];
      DrawText(FCanvas.Handle, PChar(Data), Length(Data), Rect, Flags);
    end;
  end;
end;

procedure TMyCustomListBox.MeasureItem(Index: Integer; var Height: Integer);
begin
  if Assigned(FOnMeasureItem) then FOnMeasureItem(Self, Index, Height)
end;

procedure TMyCustomListBox.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    State := TOwnerDrawState(LongRec(itemState).Lo);
    FCanvas.Handle := hDC;
    FCanvas.Font := Font;
    FCanvas.Brush := Brush;
    if (Integer(itemID) >= 0) and (odSelected in State) then
    begin
      FCanvas.Brush.Color := clHighlight;
      FCanvas.Font.Color := clHighlightText
    end;
    if Integer(itemID) >= 0 then
      DrawItem(itemID, rcItem, State) else
      FCanvas.FillRect(rcItem);
    if odFocused in State then DrawFocusRect(hDC, rcItem);
    FCanvas.Handle := 0;
  end;
end;

procedure TMyCustomListBox.CNMeasureItem(var Message: TWMMeasureItem);
begin
  with Message.MeasureItemStruct^ do
  begin
    itemHeight := FItemHeight;
    if FStyle = lbOwnerDrawVariable then
      MeasureItem(itemID, Integer(itemHeight));
  end;
end;

procedure TMyCustomListBox.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  inherited;
end;

procedure TMyCustomListBox.SelectAll;
var
  I: Integer;
begin
  if FMultiSelect then
    for I := 0 to Items.Count - 1 do
      Selected[I] := True;
end;

procedure TMyCustomListBox.KeyPress(var Key: Char);

  procedure FindString;
  var
    Idx: Integer;
  begin
    if Style in [lbVirtual, lbVirtualOwnerDraw] then
      Idx := DoFindData(FFilter)
    else
      Idx := SendMessage(Handle, LB_FINDSTRING, -1, LongInt(PChar(FFilter)));
    if Idx <> LB_ERR then
    begin
      if MultiSelect then
      begin
        ClearSelection;
        SendMessage(Handle, LB_SELITEMRANGE, 1, MakeLParam(Idx, Idx))
      end;
      ItemIndex := Idx;
      Click;
    end;
    if not (Ord(Key) in [VK_RETURN, VK_BACK, VK_ESCAPE]) then
      Key := #0;  // Clear so that the listbox's default search mechanism is disabled
  end;

var
  Msg: TMsg;
begin
  inherited KeyPress(Key);
  if not FAutoComplete then exit;
  if GetTickCount - FLastTime >= 500 then
    FFilter := '';
  FLastTime := GetTickCount;

  if Ord(Key) <> VK_BACK then
  begin
    if Key in LeadBytes then
    begin
      if PeekMessage(Msg, Handle, WM_CHAR, WM_CHAR, PM_REMOVE) then
      begin
        FFilter := FFilter + Key + Chr(Msg.wParam);
        Key := #0;
      end;
    end
    else
      FFilter := FFilter + Key;
  end
  else
  begin
    while ByteType(FFilter, Length(FFilter)) = mbTrailByte do
      Delete(FFilter, Length(FFilter), 1);
    Delete(FFilter, Length(FFilter), 1);
  end;

  if Length(FFilter) > 0 then
    FindString
  else
  begin
    ItemIndex := 0;
    Click;
  end;
end;

procedure TMyCustomListBox.SetCount(const Value: Integer);
var
  Error: Integer;
begin
  if Style in [lbVirtual, lbVirtualOwnerDraw] then
  begin
    // Limited to 32767 on Win95/98 as per Win32 SDK
    Error := SendMessage(Handle, LB_SETCOUNT, Value, 0);
    if (Error <> LB_ERR) and (Error <> LB_ERRSPACE) then
      FCount := Value
    else
      raise Exception.CreateFmt(SErrorSettingCount, [Name]);
  end
  else
    raise Exception.CreateFmt(SListBoxMustBeVirtual, [Name]);
end;

function TMyCustomListBox.DoGetData(const Index: Integer): String;
begin
  if Assigned(FOnData) then FOnData(Self, Index, Result);
end;

function TMyCustomListBox.DoGetDataObject(const Index: Integer): TObject;
begin
  if Assigned(FOnDataObject) then FOnDataObject(Self, Index, Result);
end;

function TMyCustomListBox.DoFindData(const Data: String): Integer;
begin
  if Assigned(FOnDataFind) then
    Result := FOnDataFind(Self, Data)
  else
    Result := -1;
end;

function TMyCustomListBox.GetScrollWidth: Integer;
begin
  Result := SendMessage(Handle, LB_GETHORIZONTALEXTENT, 0, 0);
end;

procedure TMyCustomListBox.SetScrollWidth(const Value: Integer);
begin
  if Value <> ScrollWidth then
    SendMessage(Handle, LB_SETHORIZONTALEXTENT, Value, 0);
end;


procedure KillMessage(Wnd: HWnd; Msg: Integer);
// Delete the requested message from the queue, but throw back
// any WM_QUIT msgs that PeekMessage may also return
var
  M: TMsg;
begin
  M.Message := 0;
  if PeekMessage(M, Wnd, Msg, Msg, pm_Remove) and (M.Message = WM_QUIT) then
    PostQuitMessage(M.wparam);
end;

procedure TMyCustomGrid.UpdateText;
begin
  if (FInplaceCol <> -1) and (FInplaceRow <> -1) then
    SetEditText(FInplaceCol, FInplaceRow, FInplaceEdit.Text);
end;

end.
