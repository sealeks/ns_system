unit ColorStringGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids;


type
TGridRow = class;
TGridRows = class;
TColorStringGrid = class;

  TGridRow = class(tCollectionItem)
  public
    font : TFont;
    Datetime: TDateTime;
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); override;
  end;

  TGridRows = class (tCollection)
  private
    function GetItem(i: longint): TGridRow;
    procedure SetItem(i: longInt; Item: tGridRow);
  public
    function Add : tGridRow;
    property Items[i: longint]: TGridRow read GetItem write SetItem;
  end;

  TColorStringGrid = class(TStringGrid)
  private
    { Private declarations }
    fminRowCount: integer;
    function GetRowCount : longInt;
    procedure SetRowCount ( count : longint);
    function GetRow (i: longint): TGridRow;
    procedure SetRow ( i : longint; Item : TGridRow);
  protected
    { Protected declarations }
  public
    { Public declarations }
    fRows : TGridRows;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
                                            AState: TGridDrawState); override;
    property Rows[i: longint] : TGridRow read GetRow write SetRow;
    procedure RemoveRow (Row : LongInt);
    procedure InsertRow (Row : LongInt);
  published
    { Published declarations }
    property RowCount : longint read GetRowCount write SetRowCount;
    property minRowCount : integer read fMinRowCount write fMinRowCount;
  end;

procedure Register;

implementation
//TGridRow
constructor TGridRow.Create(Collection: TCollection);
begin
     inherited Create(Collection);
     Font := TFont.Create;

end;

procedure TGridRow.Assign (Source: TPersistent);
begin
     if Source is TGridRow then
        Font.Assign (TGridRow(Source).Font)
     else inherited Assign( Source );
end;

//TGridRows
procedure TGridRows.SetItem ( i : integer; item: TGridRow );
begin
     TGridRow(inherited items[i]).Assign( item );
end;

function TGridRows.GetItem ( i : integer ) : TGridRow;
begin
     result := TGridRow (inherited Items[i]);
end;

function TGridRows.Add : TGridRow;
begin
     result := TGridRow(inherited Add)
end;

//TColorStringGrid
constructor TColorStringGrid.Create(AOwner: TComponent);
var
   i : integer;
begin
     inherited Create(AOwner);
     fRows := TGridRows.Create(TGridRow);
     for i := 1 to RowCount do fRows.Add.Font.Assign(font);
     minRowCount := 4;
end;

destructor TColorStringGrid.Destroy;
begin
     fRows.free;
     inherited destroy;
end;

procedure TColorStringGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
                                            AState: TGridDrawState);
var
   color : tcolor;
begin
     color := canvas.Font.Color;
     canvas.Font.Color := Rows[ARow].Font.Color;
     canvas.Font.Style := Rows[ARow].Font.Style;
     inherited DrawCell(ACol, ARow, ARect, AState);
     canvas.Font.Color := Color;
end;


function TColorStringGrid.GetRowCount : longInt;
begin
     result := inherited RowCount;
end;

procedure TColorStringGrid.SetRowCount ( Count : longint);
var
   i: integer;
begin

     if Count > RowCount then begin
        For i := Rowcount to Count-1 do
            fRows.Add.Font.Assign(font);
     end;
     if Count < RowCount then begin
        For i := Rowcount to Count-1 do
            Rows[i].Free;
     end;
     inherited RowCount := count;
end;

procedure TColorStringGrid.SetRow ( i : longint; Item : TGridRow);
begin
     TGridRow(inherited rows[i]).Assign( item );
end;

function TColorStringGrid.GetRow(i: longInt) : TGridRow;
begin
     result := fRows.Items[i];
end;

procedure TColorStringGrid.RemoveRow (Row : LongInt);
var r, c : integer;
begin
     for r := Row + 1 to Rowcount - 1 do begin
         for c := 0 to colCount - 1 do
             Cells [c, r - 1] := Cells [c, r];
         fRows.Items[R-1].Assign(fRows.Items[R]);
     end;
     for c := 0 to colCount - 1 do Cells [c, rowCount - 1] := '';
     if RowCount > minRowCount then begin
       inherited RowCount := inherited RowCount - 1;
       fRows.Items[fRows.Count-1].Free;
     end;
end;

procedure TColorStringGrid.InsertRow (Row : LongInt);
var r, c : integer;
begin
     inherited RowCount := inherited RowCount + 1;
     for r := Row + 1 to Rowcount - 1 do begin
         for c := 0 to colCount - 1 do
             Cells [c, r + 1] := Cells [c, r];
         fRows.Items[R-1].Assign(fRows.Items[R]);
     end;



end;

procedure Register;
begin
  RegisterComponents('IMMIService', [TColorStringGrid]);
end;

end.
