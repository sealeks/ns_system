unit ListDrawGrid;

///////////////////////////////////////////////////////////////////////////
//*                                                                     *//
//*  TListDrawGrid component by Elliott Shevin                          *//
//*  (initial release)                                                  *//
//*                                                                     *//
//*  This component adds a TStrings to a TDrawGrid--sort of a           *//
//*  OwnerDrag TListBox that can scroll either vertically or            *//
//*  horizontally.                                                      *//
//*  Cells are added, deleted, and manipulated in the grid by using     *//
//*  the Items property, just as with a TListBox.                       *//
//*                                                                     *//
//*  If the developer so desires, it permits multiselect, and dragging  *//
//*  of cells from one area of the grid to another.                     *//
//*                                                                     *//
//*  TListDrawGrid wasn't designed with columns and rows of different   *//
//*  sizes in mind. Programmers interested in extending it to           *//
//*  accommodate them are free to do so. Please contact me if           *//
//*  you've made such improvements.                                     *//
//*  Likewise fixed rows and columns.                                   *//
//*  Even so, I didn't know how to suppress such options in a           *//
//*  TDragGrid descendant, or have the energy to change TListDrawGrid   *//
//*  to a TCustomGrid descendant instead. Please bear with me.          *//
//*                                                                     *//
//*  Added properties:                                                  *//
//*      Items : Corresponds to the Items property of a TListBox        *//
//*      Orientation : oRowMajor or oColumnMajor                        *//
//*      DragCells   : boolean to permit the user to drag cells         *//
//*                       around the grid                               *//
//*      MultiSelect : boolean to permit the user to use Shift and      *//
//*                       Ctrl to select multiple cells                 *//
//*      Selected[index] : indicates whether the associated cell        *//
//*                       is selected                                   *//
//*                                                                     *//
//*  Added methods:                                                     *//
//*       InvalidateCell(index) : invalidates the indexed cell--a       *//
//*             change from the same method of TDrawGrid, in that       *//
//*             index is a substitute for column and row                *//
//*       IndexToCell(index, ACol, ARow) : sets ACol and ARow to        *//
//*             the column and row corresponding to index;              *//
//*             both values are set to -1 if index doesn't specify      *//
//*             an occupied cell.                                       *//
//*       ScrollCellIntoView(index) : forces the cell specified         *//
//*             by index to be scrolled into view                       *//
//***********************************************************************//


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids;

type
  TListDrawGrid = class;

  TOrientation  = (oColumnMajor,oRowMajor);

  TNewDrawCellEvent = procedure(Sender: TObject; ACol, ARow: Longint;
                         IRect: TRect; State: TGridDrawState; Index : integer)
                             of object;
  TIsDragging = (dsNotDragging,dsMouseDown,dsDragging);

  TDrawGridStringList = class(TStringList)
  private
    parent   : TListDrawGrid;
    fSelected : array of boolean;
    SelAnchor : integer;
    function  GetSelected(index : integer) : boolean;
    procedure SetSelected(index : integer; value : boolean);
  public
    UpdateDeferred : boolean;
    constructor Create(AParent : TListDrawGrid);
    procedure Clear; override;
    procedure Exchange(Index1, Index2 : integer); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property  Selected[index : integer] : boolean
                           read GetSelected write SetSelected;
  end;

  TListDrawGrid = class(TDrawGrid)
  private
    fOnDrawCell   : TNewDrawCellEvent;
    fOnDragDrop   : TDragDropEvent;
    fOnChange     : TNotifyEvent;
    fOnClick      : TNotifyEvent;
    fOnSelectCell : TSelectCellEvent;
    fOnMouseUp    : TMouseEvent;
    fOnMouseDown  : TMouseEvent;
    fOnMouseMove  : TMouseEvent;

    fMultiSelect  : boolean;
    fDragCells    : boolean;

    FocusCol      : integer;
    FocusRow      : integer;
    fOrientation  : TOrientation;
    IsDragging    : TIsDragging;
    xDragDelta    : integer;
    yDragDelta    : integer;
    xDragOrigin    : integer;
    yDragOrigin    : integer;
    MouseTimer     : UINT;
    MouseDowned    : boolean;
    procedure CalculateColsAndRows;
    procedure KillTheTimer;

    procedure DoDrawCell(Sender: TObject; ACol, ARow: Longint;
                 Rect: TRect; State: TGridDrawState);
    procedure DoDragDrop(Sender, Source: TObject; X, Y: Integer);


    function  CellToIndex(ACol, ARow : integer) : integer;
    function  ButtonState(msg : TWMMOUSE) : TMouseButton;
    function  ShiftState(msg : TWMMOUSE) : TShiftState;
    function  Min(a,b : integer) : integer;
    function  Max(a,b : integer) : integer;
    procedure ForceSelected(Index : integer);
    procedure ForceUnSelected(Index : integer);
    procedure DoSelectCell(Sender: TObject; ACol, ARow: Longint;
                    var CanSelect: Boolean);
    procedure SetOrientation(value : TOrientation);

    { Private declarations }
  protected
    procedure DoMouseUp(var Msg : TWMMOUSE);
                   message WM_LBUTTONUP;
    procedure DoMouseDown(var Msg : TWMMOUSE);
                   message WM_LBUTTONDOWN;
    procedure DoMouseMove(var Msg : TWMMOUSE);
                   message WM_MOUSEMOVE;
    procedure MouseTimerTimer(var Msg : TMessage);
                   message WM_TIMER;
    procedure DoResize(var Msg : TMessage);
                   message WM_SIZE;
    procedure RowHeightsChanged; override;
    procedure ColWidthsChanged;  override;

    function  GetSelected(index : integer) : boolean;
    procedure SetSelected(index : integer; value : boolean);
    { Protected declarations }
  public
    Items     : TDrawGridStringList;
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    function    ItemIndex : integer;
    function    SelCount  : integer;
    procedure   Clear;
    procedure   InvalidateCell(Index : integer);
    procedure   IndexToCell(Index : integer; var ACol, ARow : integer);
    property    Selected[index :integer] : boolean
                     read GetSelected write SetSelected;
    procedure   ScrollCellIntoView(index : integer);
    { Public declarations }
  published
    property Orientation : TOrientation
                        read fOrientation write SetOrientation;
    property MultiSelect  : boolean
                        read fMultiSelect write fMultiSelect;
    property DragCells    : boolean
                        read fDragCells   write fDragCells;
    property OnSelectCell : TSelectCellEvent
                                            read fOnSelectCell write fOnSelectCell;
    property OnDrawCell : TNewDrawCellEvent read fOnDrawCell write fOnDrawCell;
    property OnChange   : TNotifyEvent      read fOnChange   write fOnChange;
    property OnClick    : TNotifyEvent      read fOnClick    write fOnClick;
    property OnDragDrop : TDragDropEvent    read fOnDragDrop write fOnDragDrop;
    property OnMouseUp  : TMouseEvent       read fOnMouseUp  write fOnMouseUp;
    property OnMouseDown: TMouseEvent       read fOnMouseDown write fOnMouseDown;
    property OnMouseMove: TMouseEvent       read fOnMouseMove write fOnMouseMove;
    { Published declarations }
  end;

procedure Register;

implementation

constructor TListDrawGrid.Create(AOwner : TComponent);
begin
   inherited Create(AOwner);

   fOnDrawCell   := nil;
   fOnSelectCell := nil;
   fOnChange     := nil;
   fOnClick      := nil;
   fOnDragDrop   := nil;
   fOrientation  := oRowMajor;
   fMultiSelect  := true;
   fDragCells    := true;

   MouseDowned   := false;

   if not (csDesigning in ComponentState) then begin
      Items  := TDrawGridStringList.Create(Self);
      inherited OnSelectCell := DoSelectCell;
      inherited OnDrawCell   := DoDrawCell;

      FocusCol      := -1;
      FocusRow      := -1;
      IsDragging    := dsNotDragging;
      xDragDelta    := GetSystemMetrics(SM_CXDRAG);
      yDragDelta    := GetSystemMetrics(SM_CYDRAG);
      MouseTimer    := 0;
   end;
end;

function  TListDrawGrid.ButtonState(msg : TWMMOUSE) : TMouseButton;
begin
   if (msg.Keys and MK_LBUTTON) <> 0
      then result := mbLeft
      else
          if (msg.Keys and MK_RBUTTON) <> 0
              then result := mbRight
              else result := mbMiddle;
end;

function  TListDrawGrid.ShiftState(msg : TWMMOUSE) : TShiftState;
begin
   result := [];
   if (msg.Keys and MK_CONTROL) <> 0
      then result := result + [ssCtrl];
   if (msg.Keys and MK_SHIFT) <> 0
      then result := result + [ssShift];
end;

// Respond to left-clicks.
procedure TListDrawGrid.DoMouseDown
               (var Msg : TWMMOUSE);
var
   ARow, ACol   : integer;
   index        : integer;
   MousePos     : TPoint;
   ClientPos    : TPoint;
begin
   MouseDowned  := true;

   // Perform a SelectCell operation.
   MouseToCell(msg.Xpos,msg.Ypos,ACol,ARow);
   SelectCell(ACol, ARow);

   index := CellToIndex(ACol,ARow);

   // If the selected cell is occupied and selected and the left mouse
   // button is used and fDragCells is true, start a drag.
   if index >= 0
      then begin
              if (msg.Keys = MK_LBUTTON) and (fDragCells)
                  then begin
                        IsDragging := dsMouseDown;
                        xDragOrigin := msg.Xpos;
                        yDragOrigin := msg.Ypos;
              end;
   end;

   if Assigned(fOnMouseDown)
       then begin
              MousePos.x := msg.XPos;
              MousePos.y := msg.YPos;
              ClientPos := ScreenToClient(MousePos);
              fOnMouseDown(Self, ButtonState(msg), ShiftState(msg),
                            ClientPos.x, ClientPos.y);
   end;
end;

procedure TListDrawGrid.DoMouseMove
               (var Msg : TWMMOUSE);
const
   RingCell     : integer = -1;
var
   MousePos     : TPoint;
   ClientPos    : TPoint;
   ACol,ARow    : integer;
   CurrCell     : integer;
   RingRect     : TRect;
begin
   KillTheTimer;
   GetCursorPos(MousePos);
   ClientPos := ScreenToClient(MousePos);

   // If the user has released the mouse button, cancel a drag
   // and exit.
   if HiWord(GetKeyState(VK_LBUTTON)) = 0
      then begin
             IsDragging := dsNotDragging;
             Cursor     := crDefault;
             exit;
   end;

   // If the mouse has moved enough to establish a drag, change
   // the cursor and set IsDragging. IsDragging won't be set to
   // dsMouseDown unless fDragCells is true.
   case IsDragging of
      dsMouseDown : if (abs(msg.XPos - xDragOrigin) >= xDragDelta)
                            or (abs(msg.YPos - yDragOrigin) >= yDragDelta)
                       then begin
                          IsDragging := dsDragging;
                          if SelCount > 1
                                then Self.Cursor := crMultiDrag
                                else Self.Cursor := crDrag;
                          SetCapture(Self.Handle);
                          RingCell := -1;
                       end;

      // If dragging, and the mouse has left the control, set the cursor
      // back to the default, and set the timer.
      // If the mouse has returned to the control, set the cursor back
      // to the drag cursor and disable the timer.
      dsDragging  : begin
                        MouseToCell(ClientPos.X,ClientPos.Y,ACol,ARow);
                        CurrCell := CellToIndex(ACol,ARow);

                        // If the mouse has moved to a new cell, redraw the
                        // last cell.
                        if CurrCell <> RingCell
                           then begin
                                  if RingCell >= 0 then begin
                                     InvalidateCell(RingCell);
                                     IndexToCell(RingCell,ACol,ARow);
                                     RingRect := CellRect(ACol,ARow);
                                     if (RingRect.Left <> RingRect.Right)
                                               or (RingRect.Top <> RingRect.Bottom)
                                         then InvalidateCell(RingCell);
                                  end;
                                  RingCell := -1;

                                  // If the cell over which the mouse sits is not
                                  // selected, draw a frame around it.
                                  if not Selected[CurrCell]
                                      then begin
                                         IndexToCell(CurrCell,ACol,ARow);
                                         RingRect := CellRect(ACol,ARow);
                                         if (RingRect.Left <> RingRect.Right)
                                               or (RingRect.Top <> RingRect.Bottom)
                                            then begin
                                                    with RingRect do begin
                                                       Left    := Left    + 1;
                                                       Right   := Right   - 2;
                                                       Top     := Top     + 1;
                                                       Bottom  := Bottom  - 2;
                                                    end;
                                                    with Canvas do begin
                                                       Brush.Color := -Self.Color;
                                                       Pen.Color   := Self.Color;
                                                       Brush.Style := bsBDiagonal;
                                                       Canvas.FrameRect(RingRect);
                                                    end;
                                            end;
                                         RingCell := CurrCell;
                                  end;
                        end;
                        with ClientPos do
                            if (x >= 0) and (x <  Width)
                                        and (y >= 0)
                                        and (y <  Height)
                               then begin
                                      KillTheTimer;
                                      if SelCount > 1
                                          then Self.Cursor := crMultiDrag
                                          else Self.Cursor := crDrag;
                               end
                               else begin
                                      MouseTimer := SetTimer
                                                  (Self.Handle,1,100,nil);
                                      Self.Cursor        := crDefault;
                               end;
                    end;
      else IsDragging := dsNotDragging;
   end;

   if Assigned(fOnMouseMove)
       then begin
              MousePos.x := msg.XPos;
              MousePos.y := msg.YPos;
              ClientPos := ScreenToClient(MousePos);
              fOnMouseMove(Self, ButtonState(msg), ShiftState(msg),
                            ClientPos.x, ClientPos.y);
   end;
end;

procedure TListDrawGrid.DoMouseUp
                (var Msg : TWMMOUSE);
var
    MousePos   : TPoint;
    ClientPos  : TPoint;
    ACol, ARow : integer;
    Ctrl       : boolean;
    State      : TKeyboardState;
begin
    // If the mouse button never went down, exit.
    if not MouseDowned
       then exit;

    MouseDowned := false;

    GetKeyboardState(State);
    Ctrl  := ((State[vk_Control]   and 128) <> 0);
    if Ctrl
       then exit;

    Cursor  := crDefault;
    ReleaseCapture;
    if IsDragging = dsDragging
       then DoDragDrop(Self,Self,msg.XPos,msg.YPos)
       else begin
              // Perform a SelectCell operation, possibly to free
              // selections of other cells.
              MouseToCell(msg.Xpos,msg.Ypos,ACol,ARow);
              SelectCell(ACol, ARow);
       end;
    IsDragging := dsNotDragging;

    if Assigned(fOnMouseUp)
       then begin
              MousePos.x := msg.XPos;
              MousePos.y := msg.YPos;
              ClientPos := ScreenToClient(MousePos);
              fOnMouseUp(Self, ButtonState(msg), ShiftState(msg),
                            ClientPos.x, ClientPos.y);
    end;

    if Assigned(fOnMouseUp)
        then fOnMouseMove(Self, ButtonState(msg), ShiftState(msg),
                            ClientPos.x, ClientPos.y);
    if Assigned(fOnClick)
        then fOnClick(Self);
end;

// When the timer fires, scroll up or down according to the
// current position of the mouse. If there's no more room to
// scroll, disable the timer.
procedure TListDrawGrid.MouseTimerTimer(var msg : TMessage);
var
    MousePos   : TPoint;
    ClientPos  : TPoint;
begin
    GetCursorPos(MousePos);
    ClientPos := ScreenToClient(MousePos);

    if Orientation = oRowMajor then begin
        if ClientPos.y < 0
          then if TopRow > 0
                   then TopRow := TopRow - 1
                   else KillTheTimer;
        if ClientPos.y > Height
          then if TopRow < (RowCount - 1)
                   then TopRow := TopRow + 1
                   else KillTheTimer;
    end
    else begin
        if ClientPos.x < 0
          then if LeftCol > 0
                   then LeftCol := LeftCol - 1
                   else KillTheTimer;
        if ClientPos.x > Width
          then if LeftCol < (ColCount - 1)
                   then LeftCol := LeftCol + 1
                   else KillTheTimer;
    end;
end;

procedure TListDrawGrid.DoResize(var msg: TMessage);
begin
   CalculateColsAndRows;
end;

procedure TListDrawGrid.CalculateColsAndRows;
var
     glw, bw : integer;
begin
     if (csDesigning in ComponentState)
        then exit;

     glw := Max(GridLineWidth,1);
     bw  := Max(BorderWidth,1);

     if (Orientation = oRowMajor) and (DefaultColWidth > 0)
        then begin
               ColCount := (Width - GetSystemMetrics(SM_CXVSCROLL)
                                  - glw - (2 * bw))
                                  div (DefaultColWidth + glw);
               RowCount := (Items.Count + ColCount - 1)
                                  div ColCount
     end
     else if DefaultRowHeight > 0 then begin
               RowCount := (Height - GetSystemMetrics(SM_CYHSCROLL)
                                   - glw - (2 * bw))
                                  div (DefaultRowHeight + glw);
               ColCount := (Items.Count + RowCount - 1)
                                      div RowCount;
     end;
     Invalidate;
end;

procedure TListDrawGrid.SetOrientation(value : TOrientation);
begin
   if (csDesigning in ComponentState) or (csLoading in ComponentState)
      then begin
              fOrientation := value;
              CalculateColsAndRows;
      end
      else raise Exception.Create
                     ('TListDrawGrid Orientation cannot be '
                          + 'set except when designing.');
end;


procedure TListDrawGrid.DoDrawCell(Sender: TObject; ACol, ARow: Longint;
                    Rect: TRect; State: TGridDrawState);
var
   index    : integer;
   PassRect : TRect;
begin
   index := CellToIndex(ACol,ARow);
   Canvas.Brush.Style := bsSolid;

   // Fill the rectangle with the control's color. If the index isn't
   // pointing at an occupied cell, exit.
   Canvas.Brush.Color := Color;
   Canvas.FillRect(Rect);
   if index < 0
     then exit;

   if Items.Selected[index]
      then begin
             Canvas.Brush.Color := TColor(GetSysColor(COLOR_HIGHLIGHT));
             Canvas.Font.Color  := TColor(GetSysColor(COLOR_HIGHLIGHTTEXT));
      end
      else begin
             Canvas.Brush.Color := TColor(GetSysColor(COLOR_BTNFACE));
             Canvas.Font.Color  := TColor(GetSysColor(COLOR_BTNTEXT));
      end;

   if Assigned(fOnDrawCell) then begin
      with Rect do
         PassRect := Classes.Rect(Left,
                                  Top,
                                  Left + ColWidths[ACol] - 1,
                                  Top  + RowHeights[ARow] - 1);
      fOnDrawCell(Sender, ACol, ARow, PassRect, State, Index);
   end;
end;

// ItemIndex implements an ItemIndex function.
function  TListDrawGrid.ItemIndex : integer;
var
    i : integer;
begin
    result := -1;
    for i := 0 to Items.Count - 1 do
       if Items.Selected[i] then begin
          result := i;
          break;
       end;
end;

// SelCount implements a SelCount function.
function  TListDrawGrid.SelCount  : integer;
var
    i : integer;
begin
    result := 0;
    for i := 0 to Items.Count - 1 do
       if Items.Selected[i] then inc(result);
end;

procedure TListDrawGrid.Clear;
begin
   Items.Clear;
end;

// CellToIndex returns the index value corresponding to a given cell.
function TListDrawGrid.CellToIndex(ACol,ARow : integer) : integer;
begin
      if (ARow < 0)
           or (ARow >= RowCount)
           or (ACol <  0)
           or (ACol >= ColCount)
        then result := -1
        else begin
                if fOrientation = oRowMajor
                     then result := ARow * ColCount + ACol
                     else result := ACol * RowCount + ARow;
                if (result < 0) or (result >= Items.Count)
                    then result := -1;
        end;
end;

// CellToIndex returns the column and row corresponding to a given index.
procedure TListDrawGrid.IndexToCell(Index : integer; var ACol, ARow : integer);
begin
   if (Index < 0) or (Index >= Items.Count)
      then begin
            ACol  := -1;
            ARow  := -1;
            exit;
   end;

   if fOrientation = oRowMajor
      then begin
            ARow  := Index div ColCount;
            ACol  := Index mod ColCount;
      end
      else begin
            ACol  := Index div RowCount;
            ARow  := Index mod RowCount;
      end;
end;

// ForceSelected and ForceUnselected ensure that the cell at position
// [index] is Selected or UnSelected, and invalidates the cell if the
// status has changed.
procedure TListDrawGrid.ForceSelected(Index : integer);
begin
   if not Selected[index] then begin
      Items.Selected[index] := true;
      InvalidateCell(Index);
   end;
end;

procedure TListDrawGrid.ForceUnSelected(Index : integer);
begin
   if Selected[index] then begin
      Items.Selected[index] := false;
      InvalidateCell(Index);
   end;
end;

// Min and Max functions, so we don't have to include the Math unit.
function TListDrawGrid.Min(a,b : integer) : integer;
begin
   if a < b
      then result := a
      else result := b;
end;

function TListDrawGrid.Max(a,b : integer) : integer;
begin
   if a > b
      then result := a
      else result := b;
end;


procedure TListDrawGrid.DoSelectCell(Sender: TObject; ACol, ARow: Longint;
                    var CanSelect: Boolean);
var
   index         : integer;
   j             : integer;
   i             : integer;
   istart,istop  : integer;
   State         : TKeyboardState;
   Shift         : boolean;
   Ctrl          : boolean;
   LButton       : boolean;
begin
   GetKeyboardState(State);
   Shift := ((State[vk_Shift]     and 128) <> 0);
   Ctrl  := ((State[vk_Control]   and 128) <> 0);
   LButton := ((State[VK_LBUTTON] and 128) <> 0);

   // If MultiSelect is false, set Shift and Ctrl to false as well, to
   // nullify any multiselect attempt.
   if not fMultiSelect then begin
     Shift  := false;
     Ctrl   := false;
   end;

   index := CellToIndex(ACol,ARow);

   // CanSelect will be True if the Index is within Items. Otherwise,
   // set CanSelect to False and bail.
   CanSelect := (index < Items.Count) and (index >= 0);
   if not CanSelect
      then exit;

   // If Shift is the left mouse button alone and the selected cell is
   // already selected, exit now--a drag may be starting.
   if (Selected[index]) and (not Shift) and (not Ctrl) and (LButton)
       then begin
              Application.ProcessMessages;
              exit;
   end;

   // Indicate which cell now has the focus, for use in InvalidateCell.
   FocusRow := ARow;
   FocusCol := ACol;

   // If the Shift key is not depressed, or there is no SelAnchor,
   // the user is selecting a single cell; if the cell is being
   // de-selected, cancel the SelAnchor setting. If Ctrl is not pressed,
   // clear all Selected first. Then select the cell being selected, and
   // ensure that SelAnchor points to it.
   with Items do begin
      if (not Shift) or (SelAnchor < 0)
          then begin
                 if Ctrl
                     then begin
                              Items.Selected[index]
                                            := not Items.Selected[index];
                              if Items.Selected[index]
                                 then SelAnchor := index
                                 else SelAnchor := -1;
                              InvalidateCell(index);
                     end
                     else begin
                              for j := 0 to Items.Count - 1 do
                                  if Selected[j] then
                                     ForceUnselected(j);
                              ForceSelected(index);
                              SelAnchor  := index;
                           end;
                 end

      // If the Shift key is depressed, and SelAnchor was other than -1,
      // determine whether the selected cell precedes or follows SelAnchor,
      // select all cells between the two, and deselect all others.
      else begin
                istart := min(index,SelAnchor);
                istop  := max(index,SelAnchor);

                i := 0;
                while i < istart do begin
                   ForceUnselected(i);
                   inc(i);
                end;
                while i <= istop do begin
                   ForceSelected(i);
                   inc(i);
                end;
                while i < Count do begin
                   ForceUnselected(i);
                   inc(i);
                end;
      end;
   end;

   if Assigned(fOnSelectCell)
      then fOnSelectCell(Self, ACol, ARow, CanSelect);

   Application.ProcessMessages;
end;


function TListDrawGrid.GetSelected(index : integer) : boolean;
begin
   result := Items.Selected[index];
end;

procedure TListDrawGrid.SetSelected(index : integer; value : boolean);
begin;
   Items.Selected[index] := value;
   InvalidateCell(Index);
end;

procedure TListDrawGrid.InvalidateCell(Index : integer);
var
   ARow, ACol : longint;
   State      : TGridDrawState;
   Rect       : TRect;
begin
   if Items.UpdateDeferred then exit;

   IndexToCell(Index,ACol,ARow);

   Rect  := CellRect(ACol, ARow);
   if (Rect.Top = Rect.Bottom) and (Rect.Left = Rect.Right)
      then exit;

   if Items.Selected[index]
      then State := [gdSelected]
      else State := [];
   if (ARow < FixedRows) or (ACol < FixedCols)
      then State := State + [gdFixed];
   if (ARow = FocusRow) and (ACol = FocusCol)
      then State := State + [gdFocused];

   DoDrawCell(Self, ACol, ARow, Rect, State);
end;

destructor TListDrawGrid.Destroy;
begin
   KillTheTimer;
   Items.free;

   inherited;
end;

procedure TListDrawGrid.KillTheTimer;
begin
   if MouseTimer <> 0 then begin
      KillTimer(Self.Handle,1);
      MouseTimer := 0;
   end;
end;

procedure TListDrawGrid.RowHeightsChanged;
begin
  inherited RowHeightsChanged;
  PostMessage(Self.Handle,WM_SIZE,0,0);
end;

procedure TListDrawGrid.ColWidthsChanged;
begin
  inherited ColWidthsChanged;
  PostMessage(Self.Handle,WM_SIZE,0,0);
end;


procedure TListDrawGrid.ScrollCellIntoView(index : integer);
var
    c, r   : integer;
    cr     : TRect;
begin
    IndexToCell(index,c,r);
    if (c < 0) or (r < 0)
        then exit;

    if fOrientation = oRowMajor
       then repeat
          cr := CellRect(c,r);
          if (cr.Bottom - cr.Top) < DefaultRowHeight then begin
              if r < TopRow
                  then TopRow := TopRow - 1
                  else TopRow := TopRow + 1;
              Refresh;
          end;
       until (cr.Bottom - cr.Top) >= DefaultRowHeight

       else repeat
          cr := CellRect(c,r);
          if (cr.Right - cr.Left) < DefaultColWidth then begin
              if c < LeftCol
                  then LeftCol := LeftCol - 1
                  else LeftCol := LeftCol + 1;
              Refresh;
          end;
       until (cr.Left - cr.Left) >= DefaultColWidth;

       InvalidateCell(index);
end;

//======================================================================

constructor TDrawGridStringList.Create(AParent : TListDrawGrid);
begin
   inherited Create;
   Self.Parent := AParent;
   SetLength(fSelected,25);
   UpdateDeferred := false;
   SelAnchor      := -1;
end;


procedure TDrawGridStringList.Delete(Index: Integer);
var
   i  : integer;
begin
   // Deselect all cells in the grid.
   for i := Index to High(fSelected) - 1 do
       fSelected[i] := false;

   inherited;

   if Assigned(Parent.fOnChange)
      then Parent.fOnChange(Parent);

   if Parent.Orientation = oRowMajor
      then Parent.RowCount := (Self.Count + Parent.ColCount - 1)
                                      div Parent.ColCount
      else Parent.ColCount := (Self.Count + Parent.RowCount - 1)
                                      div Parent.RowCount;

   if not UpdateDeferred
        then Parent.Invalidate;

   // If SelAnchor was the deleted cell, or if SelAnchor is now
   // beyond the last cell, cancel it.
   if (SelAnchor = Index) or (SelAnchor >= Count)
       then SelAnchor := -1;
end;

procedure TDrawGridStringList.Insert(Index: Integer; const S: string);
var
   i  : integer;
begin
   for i := High(fSelected) - 1 downto Index do
      fSelected[i + 1] := fSelected[i];
   fSelected[index] := false;

   inherited;

   // If the count of the TDrawGridStringList has met the count
   // of fSelected, add 25 elements to fSelected.
   if Self.Count >= Length(fSelected)
     then SetLength(fSelected,Length(fSelected) + 25);

   if Assigned(Parent.fOnChange)
      then Parent.fOnChange(Parent);

   if Parent.Orientation = oRowMajor
      then Parent.RowCount := (Self.Count + Parent.ColCount - 1)
                                      div Parent.ColCount
      else Parent.ColCount := (Self.Count + Parent.RowCount - 1)
                                      div Parent.RowCount;

   if not UpdateDeferred
        then Parent.Invalidate;
end;

procedure TDrawGridStringList.Exchange(Index1, Index2 : integer);
var
   tr         : integer;
   tc         : integer;
   Sel1, Sel2 : boolean;
begin
   Sel1  := Selected[Index1];
   Sel2  := Selected[Index2];
   inherited;
   Selected[Index1] := Sel2;
   Selected[Index2] := Sel1;
   if not UpdateDeferred then begin
      Parent.InvalidateCell(Index1);
      Parent.InvalidateCell(Index2);
   end;

   if Selected[Index1]
     then SelAnchor := Index1
     else if Selected[Index2]
              then SelAnchor := Index2;

   // Make sure the current selected cell is visible.
   if SelAnchor > -1 then
      with Parent do begin
         if Orientation = oRowMajor
            then begin
                   tr := SelAnchor div ColCount;  // Target row
                   if (tr < TopRow) or (tr > (TopRow + VisibleRowCount - 1))
                      then TopRow := tr;
            end
            else begin
                   tc := SelAnchor div RowCount;  // Target column
                   if (tc < LeftCol) or (tc <= (LeftCol + VisibleColCount - 1))
                      then LeftCol := tc;
            end;
      end;
end;

// It may be redundant, but when Clear is called, set all fSelected
// values to False, and clear SelAnchor.
procedure TDrawGridStringList.Clear;
var
   i  : integer;
begin
   for i := Low(fSelected) to High(fSelected) do
      fSelected[i] := false;

   inherited;

   Parent.RowCount := (Self.Count + Parent.ColCount - 1) div Parent.ColCount;

   if Assigned(Parent.fOnChange)
      then Parent.fOnChange(Parent);

   if not UpdateDeferred
        then Parent.Invalidate;

   SelAnchor := -1;
end;

function TDrawGridStringList.GetSelected(index : integer) : boolean;
begin
   result := fSelected[index];
end;

procedure TDrawGridStringList.SetSelected(index : integer; value : boolean);
begin;
   fSelected[index] := value;
end;

procedure TDrawGridStringList.BeginUpdate;
begin
   UpdateDeferred := true;
end;

procedure TDrawGridStringList.EndUpdate;
begin
   UpdateDeferred := false;
   Parent.Invalidate;
end;


procedure TListDrawGrid.DoDragDrop(Sender, Source: TObject; X, Y: Integer);
var
   ACol,ARow      : integer;
   dest           : integer;
   l              : TStringList;
   i              : integer;
begin
   if Assigned(fOnDragDrop)
      then begin
             fOnDragDrop(Sender, Source, X, Y);
             exit;
   end;

          MouseToCell(X,Y,ACol,ARow);
          dest  := CellToIndex(ACol,ARow);
          if dest < 0
             then exit;
          if Selected[dest]
             then exit;

          l     := TStringList.Create;

          Items.BeginUpdate;
          for i := Items.Count - 1 downto 0 do
             if Selected[i]
                 then begin
                        l.AddObject(Items.Strings[i],Items.Objects[i]);
                        Items.Delete(i);
                        if i < dest         // If deleting from before the
                           then dec(dest);  // destination, compensate.
             end;
          while l.Count > 0 do begin
             Items.InsertObject(dest,l.Strings[0],l.Objects[0]);
             l.Delete(0);
          end;
          l.Free;
          Items.EndUpdate;

          if Assigned(fOnChange)
              then fOnChange(Self);
end;



//======================================================================

procedure Register;
begin
  RegisterComponents('C', [TListDrawGrid]);
end;

end.
