{
  ���������� �������������� �����������

  ��������� ������� (������� �������)

  � ����� �. �������, 1997-2001
  E-mail: roman@sar.nnov.ru
}

unit Ex_Inspector;

interface

//{$I EX.INC}

uses
  Windows, Messages, CommCtrl, Classes, Controls, Graphics, Forms, StdCtrls,
  Math, Ex_Grid;

type

{ TInspectorEdit }

  TInspectorEdit = class(TGridEdit)
  protected
    procedure UpdateBounds(ScrollCaret: Boolean); override;
    procedure UpdateColors; override;
  public
    procedure Invalidate; override;
  end;

{ TCustomInspector }

  {
    ������� ����� ��� �������� ����������� ������� �� ������
    ObjectInspector � Delphi.

    ����������� ������ ������ TCustomGridView ��� �������� �������� ����
    (���� ������ �������, "����������" ����� � �.�.). ������ �������� ���
    ������� - ������� ���� ������� � ������� ��������. ������ ��������� �
    ��������� ��������������.

    ��������������� ������:

    IsCategoryRow - �������� �� ��������� ������ ������� � ���������
                    ���������. ��� ����� � ��������� ��������� �� ��������
                    �������������� ������� ������� (��� � Delphi 5.0),
                    ����� �������� �� ��� ������ ������� ������ clPurple.
                    ��������! ����� ������ ��������� ���������� �����
                    ������ ������ (������ 0) �������.

    �������������� ��������:

    NameFont -      ����� �������� �������.
    ValueFont -     ����� ��������.
    CategoryFont  - ����� ������ � ������� ���������.
  }

  TInspectorCategoryRowEvent = procedure(Sender: TObject; Row: Longint; var Category: Boolean) of object;

  TCustomInspector = class(TCustomGridView)
  private
    FNameFont: TFont;
    FValueFont: TFont;
    FCategoryFont: TFont;
    FHitTest: TPoint;
    FColUpdate: Integer;
    FOnGetCategoryRow: TInspectorCategoryRowEvent;
    procedure FontChanged(Sender: TObject);
    procedure SetCategoryFont(Value: TFont);
    procedure SetNameFont(Value: TFont);
    procedure SetValueFont(Value: TFont);
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
  protected
    procedure ChangeColumns; override;
    function ColResizeAllowed(X, Y: Integer): Boolean;
    procedure ColumnResizing(Column: Integer; var Width: Integer); override;
    function EditCanShow(Cell: TGridCell): Boolean; override;
    procedure GetCellColors(Cell: TGridCell; Canvas: TCanvas); override;
    function GetCellHintRect(Cell: TGridCell): TRect; override;
    function GetCellText(Cell: TGridCell): string; override;
    function GetCellTextIndent(Cell: TGridCell): TPoint; override;
    function GetEditClass(Cell: TGridCell): TGridEditClass; override;
    procedure GetEditListBounds(Cell: TGridCell; var Rect: TRect); override;
    function GetTipsRect(Cell: TGridCell): TRect; override;
    procedure HideCursor; override;
    procedure HideFocus; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure PaintCell(Cell: TGridCell; Rect: TRect); override;
    procedure PaintFocus; override;
    procedure Resize; override;
    procedure ShowCursor; override;
    procedure ShowFocus; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetColumnAt(X, Y: Integer): Integer; override;
    function GetEditRect(Cell: TGridCell): TRect; override;
    function GetFocusRect: TRect; override;
    function GetRowAt(X, Y: Integer): Integer; override;
    function IsCategoryRow(Row: Integer): Boolean; virtual;
    procedure UpdateColumnsSize; virtual;
    procedure UpdateScrollBars; override;
    property CategoryFont: TFont read FCategoryFont write SetCategoryFont;
    property NameFont: TFont read FNameFont write SetNameFont;
    property ValueFont: TFont read FValueFont write SetValueFont;
    property OnGetCategoryRow: TInspectorCategoryRowEvent read FOnGetCategoryRow write FOnGetCategoryRow;
  end;

{ TInspector }

  TExInspector = class(TCustomInspector)
  published
    property Align;
    property AllowEdit default True;
    property AlwaysEdit default True;
    property AlwaysSelected;
{$IFDEF EX_D4_UP}
    property Anchors;
{$ENDIF}
    property BorderStyle;
    property CategoryFont;
    property Color default clBtnFace;
{$IFDEF EX_D4_UP}
    property Constraints;
{$ENDIF}
    property Ctl3D;
    property ColumnsFullDrag default True;
    property DoubleBuffered default True;
    property Enabled;
    property EndEllipsis default False;
    property FlatBorder;
    property FlatScrollBars;
    property Font;
    property NameFont;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowCellTips;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property ValueFont;
    property Visible;
    property OnCellClick;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditAcceptKey;
    property OnEditButtonPress;
    property OnEditSelectNext;
    property OnEnter;
    property OnExit;
    property OnGetCategoryRow;
    property OnGetCellText;
    property OnGetEditList;
    property OnGetEditStyle;
    property OnGetEditText;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnKeyDown;
{$IFDEF EX_D4_UP}
    property OnMouseWheelDown;
    property OnMouseWheelUp;
{$ENDIF}
    property OnKeyPress;
    property OnKeyUp;
    property OnResize;
    property OnSetEditText;
    property OnStartDrag;
  end;

implementation



uses
  ExtStrUtils, ExtGraphics;

{ TInspectorEdit }

procedure TInspectorEdit.UpdateBounds(ScrollCaret: Boolean);
begin
  { ���������� ��������� }
  inherited;
  { ����������� ������ ������ }
  ButtonWidth := Height;
end;

procedure TInspectorEdit.UpdateColors;
begin
  { �������� ����� �� ��������� }
  inherited;
  { ����������� ��� � ���� ������ }
  Color := clWindow;
  Font.Color := clBtnText;
end;

procedure TInspectorEdit.Invalidate;
begin
  { ��������� ������ }
  inherited;
  { ��������� ����� }
  if Grid <> nil then Grid.InvalidateFocus;
end;

{ TCustomInspector }

constructor TCustomInspector.Create(AOwner: TComponent);
begin
  inherited;
  { ����� }
  Color := clBtnFace;
  { �������������� }
  RowSelect := False;
  AllowEdit := True;
  AlwaysEdit := True;
  { ������� }
  with Columns do
  begin
    { ������� ������� }
    with Add do
    begin
      Caption := 'Property';
      FixedSize := True;
      WordWrap := False;
      WantReturns := False;
      ReadOnly := True;
      TabStop := False;
    end;
    { ������� �������� }
    with Add do
    begin
      Caption := 'Value';
      WordWrap := False;
      WantReturns := False;
      FixedSize := True;
    end;
  end;
  { �������������� � �������� ��������� }
  Header.Synchronized := True;
  ShowHeader := False;
  { ������ ����� }
  Rows.AutoHeight := False;
  Rows.Height := 16;
  { ������ ��������� }
  HorzScrollBar.Visible := False;
  { ������� ��� }
  ColumnsFullDrag := True;
  DoubleBuffered := True;
  EndEllipsis := False;
  GridLines := False;
  TextTopIndent := 1;
  TextRightIndent := 1;
  { ������� ��������� ������ }
  CursorKeys := CursorKeys + [gkMouseMove];
  { ����� ������ }
  FNameFont := TFont.Create;
  FNameFont.Assign(Font);
  FNameFont.Color := clBtnText;
  FNameFont.OnChange := FontChanged;
  FValueFont := TFont.Create;
  FValueFont.Assign(Font);
  FValueFont.Color := clNavy;
  FValueFont.OnChange := FontChanged;
  FCategoryFont := TFont.Create;
  FCategoryFont.Assign(Font);
  FCategoryFont.Color := clPurple;
  FCategoryFont.Style := FValueFont.Style + [fsBold];
  FCategoryFont.OnChange := FontChanged;
end;

destructor TCustomInspector.Destroy;
begin
  FCategoryFont.Free;
  FValueFont.Free;
  FNameFont.Free;
  inherited;
end;

procedure TCustomInspector.FontChanged(Sender: TObject);
begin
  InvalidateGrid;
end;

procedure TCustomInspector.SetCategoryFont(Value: TFont);
begin
  FCategoryFont.Assign(Value);
end;

procedure TCustomInspector.SetNameFont(Value: TFont);
begin
  FNameFont.Assign(Value);
end;

procedure TCustomInspector.SetValueFont(Value: TFont);
begin
  FValueFont.Assign(Value);
end;

procedure TCustomInspector.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  FHitTest := ScreenToClient(SmallPointToPoint(Message.Pos));
end;

procedure TCustomInspector.WMSetCursor(var Message: TWMSetCursor);
begin
  with Message, FHitTest do
    if (HitTest = HTCLIENT) and not (csDesigning in ComponentState) then
      if ColResizeAllowed(X, Y) then
      begin
        Windows.SetCursor(Screen.Cursors[crHSplit]);
        Exit;
      end;
  inherited;
end;

procedure TCustomInspector.ChangeColumns;
begin
  inherited;
  { ����������� ������� ������� }
  UpdateColumnsSize;
end;

function TCustomInspector.ColResizeAllowed(X, Y: Integer): Boolean;
begin
  Result := (Columns.Count > 0) and (X >= Columns[0].Width - 4) and (X <= Columns[0].Width);
end;

procedure TCustomInspector.ColumnResizing(Column: Integer; var Width: Integer);
begin
  if Width > ClientWidth - 35 then Width := ClientWidth - 35;
  if Width < 35 then Width := 35;
end;


function TCustomInspector.EditCanShow(Cell: TGridCell): Boolean;
begin
  { ��� ����� ��������� ������ ����� �� ���������� }
  Result := (not IsCategoryRow(Cell.Row)) and inherited EditCanShow(Cell);
end;

procedure TCustomInspector.GetCellColors(Cell: TGridCell; Canvas: TCanvas);
begin
  Canvas.Brush.Color := Self.Color;
 // Canvas.Font := NameFont;
 { if IsCategoryRow(Cell.Row) then Canvas.Font := CategoryFont
  else if Cell.Col = 1 then Canvas.Font := ValueFont
  else if Cell.Col = 0 then Canvas.Font := NameFont
  else Canvas.Font := Self.Font; }
end;

function TCustomInspector.GetCellHintRect(Cell: TGridCell): TRect;
begin
  Result := inherited GetCellHintRect(Cell);
  { ��� ����� ��������� ������������� ��������� - ��� ������ }
  if IsCategoryRow(Cell.Row) then
  begin
    Result.Left := GetColumnRect(0).Left;
    Result.Right := GetColumnRect(1).Right;
  end;
end;

function TCustomInspector.GetCellText(Cell: TGridCell): string;
begin
  { ��� ����� ��������� ������ ������� ����� ����� ��, ��� � ������ }
  if (Cell.Col <> 0) and IsCategoryRow(Cell.Row) then Cell.Col := 0;
  Result := inherited GetCellText(Cell);
end;

function TCustomInspector.GetCellTextIndent(Cell: TGridCell): TPoint;
begin
  Result.X := 2 - Cell.Col+self.TextLeftIndent;
  Result.Y := TextTopIndent;
end;

function TCustomInspector.GetEditClass(Cell: TGridCell): TGridEditClass;
begin
  Result := TInspectorEdit;
end;

procedure TCustomInspector.GetEditListBounds(Cell: TGridCell; var Rect: TRect);
begin
  { ��������� ������������ ����� }
  Dec(Rect.Left, 2);
  { ��������� �� ��������� }
  inherited;
end;

function TCustomInspector.GetTipsRect(Cell: TGridCell): TRect;
var
  DX: Integer;
begin
  Result := inherited GetTipsRect(Cell);
  { ��� 2 ������� ������ ��������� ������� ��������� �� ������ 1 ������� }
  if (Cell.Col <> 0) and IsCategoryRow(Cell.Row) then
  begin
    DX := GetColumnRect(0).Left - Result.Left;
    OffsetRect(Result, DX, 0);
  end;
end;

procedure TCustomInspector.HideCursor;
begin
  { ��� ����� ��������� ������ ����� �� ������������, �������
    ������ ����� ������ ���� ������ }
  if IsCategoryRow(CellFocused.Row) then
  begin
    InvalidateFocus;
    Exit;
  end;
  inherited;
end;

procedure TCustomInspector.HideFocus;
begin
  { �� ��������� TCustomGridView ������ ������������� ������ ��������
    DrawFocusRect. � ��������� ����������� �������� DrawFocusRect,
    ���������� ������������� ������ ���� ������ (�������� ��������)
    ������ ��� �������� �����������, ��������� �������� ������� � �.�.,
    ����� ��������� "�����". ��� ��� � ���������� ����� �������� ������,
    �� ��������� ������� ������ ����� ������������ }
end;

procedure TCustomInspector.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { ������������� ����� �� ���� }
  if not AcquireFocus then
  begin
    MouseCapture := False;
    Exit;
  end;
  { ����� ������� }
  if Button = mbLeft then
  begin
    { ������� ������ ��������� ������� ������� }
    if ColResizeAllowed(X, Y) then
    begin
      { �������� ��������� ������� }
      StartColResize(Header.Sections[0], X, Y);
      { �� ������� ������ }
      Exit;
    end;
  end;
  { ���������� �� ��������� }
  inherited;
end;

procedure TCustomInspector.Paint;
begin
  inherited;
  { ������ ����� ������ ������ }
  PaintFocus;
end;

procedure TCustomInspector.PaintCell(Cell: TGridCell; Rect: TRect);
var
  R,fR: TRect;
  Rc: TColor;
begin
  { ������ ��������� ������ �� ��� ������ }
  fr.TopLeft:=Rect.TopLeft;
  fr.BottomRight:=Rect.BottomRight;
  if (cell.Col=0) and (Rect.Left<>0) then
    begin

      fr.Left:=0;

    end;
  if IsCategoryRow(Cell.Row) then
  begin
    Rect.Left := GetGridRect.Left;
    Rect.Right := GetGridRect.Right;
    { ������� �������� ����� ��������� �� ������ ������ }
    if Cell.Col <> 0 then Exit;
  end;                                                      
  { ������ ������ }
  inherited;
  { ��� ����� ��� ������ ������ ���������� �������������� ������� ����� }
  if Cell.Row <> CellFocused.Row then
  begin
    R := Rect;
    R.Top := R.Bottom - 1;
    with Canvas do
    begin
      { ����� ����� ����� }
       //Brush.Color := clGray xor clSilver;
       rc:=Font.Color;
      Font.Color := clBlack;
      Refresh;
      { ����� }
      PaintResizeRectDC(Handle, R);
      Font.Color:=rc;
    end;
  end;
  { ��� ����� ��� �������� ��������� ������ ������� ��������������
    ������� ������ }
  if (Cell.Col = 0) and (not IsCategoryRow(Cell.Row)) then
    with Canvas do
    begin
      Pen.Color := clBtnShadow;
      Pen.Width := 1;
      MoveTo(Rect.Right - 2, Rect.Top - 1);
      LineTo(Rect.Right - 2, Rect.Bottom);
      Pen.Color := clBtnHighlight;
      MoveTo(Rect.Right - 1, Rect.Bottom - 1);
      LineTo(Rect.Right - 1, Rect.Top - 1);
    end;
  { ������ ����� ������ }
  if Cell.Row = CellFocused.Row then
    { ������ ����� ����� ������ ��� ����� � ������� }
    with Canvas do
      DrawEdge(Handle, Rect, BDR_SUNKENOUTER, BF_BOTTOM)
  else
    { ������� ����� ����� ������ ������ ��� ����� ��� ������� }
    if Cell.Row = CellFocused.Row - 1 then
    begin
      R := Rect;
      R.Top := R.Bottom - 2;
      with Canvas do
      begin
        DrawEdge(Handle, R, BDR_SUNKENOUTER, BF_TOP);
        InflateRect(R, 0, -1);
        DrawEdge(Handle, R, BDR_SUNKENINNER, BF_TOP);
      end;
    end;
end;

procedure TCustomInspector.PaintFocus;
begin
  { ����� ������ �������� ��� ��������� ������ }
end;

procedure TCustomInspector.Resize;
begin
  { ����������� ������� }
  UpdateColumnsSize;
  { ��������� �� ��������� }
  inherited;
end;


procedure TCustomInspector.ShowCursor;
begin
  if IsCategoryRow(CellFocused.Row) then
  begin
    InvalidateFocus;
    Exit;
  end;
  inherited;
end;

procedure TCustomInspector.ShowFocus;
begin
  {}
end;

function TCustomInspector.GetColumnAt(X, Y: Integer): Integer;
var
  C1, C2: TGridCell;
  R: TRect;
begin
  { �������� ������� ������ }
  C1 := GridCell(0, VisOrigin.Row);
  C2 := GridCell(1, VisOrigin.Row + VisSize.Row - 1);
  { �������� ������������� ������� ����� }
  R := GetCellsRect(C1, C2);
  { ���� ����� ����� �� ����� - ���������� ������ ������� }
  if X < R.Left then
  begin
    Result := C1.Col;
    Exit;
  end;
  { ���� ����� ������ �� ����� - ���������� �������� ������� }
  if X >= R.Right then
  begin
    Result := C2.Col;
    Exit;
  end;
  { ����� �� ��������� }
  Result := inherited GetColumnAt(X, Y);
end;

function TCustomInspector.GetEditRect(Cell: TGridCell): TRect;
begin
  { �������� ������������� ������ }
  Result := inherited GetEditRect(Cell);
  { ��������� ������ }
  Dec(Result.Bottom, 1);
end;


function TCustomInspector.GetFocusRect: TRect;
begin
  { �������� ������������� ������, ��������� ������ }
  Result := GetRowRect(CellFocused.Row);
  Dec(Result.Top, 2);
end;

function TCustomInspector.GetRowAt(X, Y: Integer): Integer;
var
  C1, C2: TGridCell;
  R: TRect;
begin
  { �������� ������� ������ }
  C1 := GridCell(0, VisOrigin.Row);
  C2 := GridCell(1, VisOrigin.Row + VisSize.Row - 1);
  { �������� ������������� ������� ����� }
  R := GetCellsRect(C1, C2);
  { ���� ����� ������ �� ����� - ���������� ������ ������ }
  if Y < R.Top then
  begin
    Result := MaxIntValue([C1.Row - 1, 0]);
    Exit;
  end;
  { ���� ����� ����� �� ����� - ���������� �������� ����� }
  if Y >= R.Bottom then
  begin
    Result := MinIntValue([C2.Row + 1, Rows.Count - 1]);
    Exit;
  end;
  { ����� �� ��������� }
  Result := inherited GetRowAt(X, Y);
end;

function TCustomInspector.IsCategoryRow(Row: Integer): Boolean;
begin
  Result := False;
  if Assigned(FOnGetCategoryRow) then FOnGetCategoryRow(Self, Row, Result);
end;

procedure TCustomInspector.UpdateColumnsSize;
begin
  { � �� ���� �� ������ ��������� }
  if (FColUpdate = 0) and (Columns.Count = 2) then
  begin
    Inc(FColUpdate);
    try
      { ����������� ������ ������� �������� }
      Columns[1].Width := ClientWidth - Columns[0].Width;
      { ������� �� ����� ���� ������ 35 �������� }
      if Columns[1].Width < 35 then
      begin
        Columns[1].Width := 35;
        Columns[0].Width := ClientWidth - 35;
      end;
      { ����������� ������ ������� ���� }
      if Columns[0].Width < 35 then
      begin
        Columns[0].Width := 35;
        Columns[1].Width := ClientWidth - 35;
      end;
    finally
      Dec(FColUpdate);
    end;
  end;
end;

procedure TCustomInspector.UpdateScrollBars;
begin
  inherited;
  { ����� ������� ��������� ������������� ������� ����� �������, ��
    Resize �� ���������� - ���� ���������� ������� ������� }
  UpdateColumnsSize;
end;



end.
