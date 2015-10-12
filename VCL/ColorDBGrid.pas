unit ColorDBGrid;
{Класс находит в сетке столбцы с названием Level и  State
  Определяет цвет строки в соответствии со значением этих столбцов
  Скрывает эти столбцы, устанавливая ширину = 0
  Если не находит столбцы, то работает как стандартный Grid
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB;

type
  TColorDBGrid = class(TDBGrid)
  private
    { Private declarations }
    fLevelColumn, fStateColumn, ftm, fcoment : integer;
  protected
    { Protected declarations }

  public
    { Public declarations }

    procedure DrawCellNew(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
    constructor Create(AOwner: TComponent); override;
    procedure DrawCell(ACol, ARow: Longint; ARect:
                             TRect; AState: TGridDrawState); override;

  published
    { Published declarations }
end;

procedure Register;

implementation
constructor TColorDBGrid.Create(AOwner: TComponent);
begin
     fLevelColumn := -1;
     fStateColumn := -1;
     ftm:=-1;
     fcoment:=-1;
     inherited Create(AOwner);
     options := options - [dgColumnResize];
end;


procedure TColorDBGrid.DrawCell(ACol, ARow: Longint; ARect:
                             TRect; AState: TGridDrawState);
var
   ACol1, ARow1: LongInt;
   Level : integer;
   State, coment: string;
   tms: tdatetime;
   i: integer;
   OldActive: integer;
   dtf: TDateTimeField;
begin
  inherited DrawCell(ACol, ARow, ARect, AState);

  try
  if not Assigned(DataSource) or not Assigned(DataSource.dataSet) then exit;
  if (fLevelColumn = -1) or (fStateColumn = -1) then begin
    for i := 0 to Columns.Count-1 do
    begin
      if trim(uppercase(Columns[i].FieldName)) = trim(uppercase('ilevel')) then fLevelColumn := i;
    //for i := 0 to Columns.Count-1 do
      if trim(uppercase(Columns[i].FieldName)) =trim(uppercase('istate')) then fStateColumn := i;
    // for i := 0 to Columns.Count-1 do
      if Columns[i].FieldName = 'tm' then ftm := i;
   // for i := 0 to Columns.Count-1 do
      if trim(uppercase(Columns[i].FieldName)) = trim(uppercase('icomment')) then fcoment := i;
    end;
  end;
  ACol1 := ACol;
  ARow1 := ARow;
  if dgIndicator in options then dec(ACol1);
 if dgTitles in options then Dec(ARow1);
 if (fLevelColumn = -1) or (fStateColumn = -1) or (ACol1 < 0) or
     ((ARow = 0) and (dgTitles in options)) then exit;
  if (Columns[fLevelColumn].width <> 0) or (Columns[fStateColumn].width <> 0) then
  begin
   //  Columns[fLevelColumn].width := 0;
   // Columns[fStateColumn].width := 0;
  end;

//  color := Columns[ACol1].Font.Color;
      OldActive := DataLink.ActiveRecord;
      try
        DataLink.ActiveRecord := ARow1;
        level := 0;
        if Assigned(Columns[fLevelColumn].Field) then
          level := Columns[fLevelColumn].Field.AsInteger;
        if Assigned(Columns[fStateColumn].Field) then
          State := trim(Columns[fStateColumn].Field.Asstring);
         if Assigned(Columns[ftm].Field) then
          begin
          //  tms := Columns[ftm].Field.asdatetime;
            //Columns[ftm].Field.DataType:=ftstring;
            dtf:=TDateTimeField(Columns[ftm].Field);//.DisplayFormat:='yyyy-mm-dd hh:nn:ss.zzz';

          end;
        if Assigned(Columns[fcoment].Field) then
          Coment:= trim(Columns[fcoment].Field.Asstring);
          if length(coment)>4 then coment:=copy(coment,1, 4);
      finally
        DataLink.ActiveRecord := OldActive;
      end;

    if (level < 500) and (State = 'A_On') then
                                         Canvas.Font.Color := RGB(255, 128, 0);
     if (level < 500) and (State = 'A_Kvit') then
                                           Canvas.Font.Color := clGray;
     if (level < 500) and (State = 'A_Off') then
                                           Canvas.Font.Color := $0000C1C1;
     if (level > 500) and (State = 'A_On') then
                                           Canvas.Font.Color := clRed;
     if (level > 500) and (State = 'A_Kvit') then
                                           Canvas.Font.Color := clOlive;
     if (level > 500) and (State = 'A_Off') then
                                           Canvas.Font.Color := clPurple;
    if (State = 'Event') then
       begin
         if level<500 then Canvas.Font.Color := $FF8000 else Canvas.Font.Color:=$008080FF;


                                   if coment='*[->' then
                                   else dtf.DisplayFormat:='dd.mm.yyyy hh:nn:ss';
                                   dtf.DisplayFormat:='dd.mm.yyyy hh:nn:ss.zzz';
       end else dtf.DisplayFormat:='dd.mm.yyyy hh:nn:ss';


    if (State = 'Command') then
                                           Canvas.Font.Color := clGreen;

  except
  end;
  DrawCellNew(ACol, ARow, ARect, AState);
//  Columns[ACol1].Font.Color := Color;
end;

procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment);
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
var
  Left: Integer;
begin
    case Alignment of
      taLeftJustify:
        Left := ARect.Left + DX;
      taRightJustify:
        Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
    else { taCenter }
      Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
        - (ACanvas.TextWidth(Text) shr 1);
    end;
    ExtTextOut(ACanvas.Handle, Left, ARect.Top + DY, ETO_OPAQUE or
      ETO_CLIPPED, @ARect, PChar(Text), Length(Text), nil);
end;


procedure TColordbGrid.DrawCellNew(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
  function RowIsMultiSelected: Boolean;
  var
    Index: Integer;
  begin
    Result := (dgMultiSelect in Options) and Datalink.Active and
      SelectedRows.Find(Datalink.Datasource.Dataset.Bookmark, Index);
  end;

var
  OldActive: Integer;
  Highlight: Boolean;
  Value: string;
  DrawColumn: TColumn;
  FrameOffs: Byte;
begin
  if csLoading in ComponentState then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ARect);
    Exit;
  end;

  Dec(ARow, 1);
  Dec(ACol, 1);

  if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
    [dgRowLines, dgColLines]) then
  begin
    InflateRect(ARect, -1, -1);
    FrameOffs := 1;
  end
  else
    FrameOffs := 2;

  if (gdFixed in AState) and (ACol < 0) then
  begin
    Canvas.Brush.Color := FixedColor;
    Canvas.FillRect(ARect);
    if Assigned(DataLink) and DataLink.Active  then
    begin
      if ARow >= 0 then
      begin
        OldActive := DataLink.ActiveRecord;
        try
          Datalink.ActiveRecord := ARow;
        finally
          Datalink.ActiveRecord := OldActive;
        end;
      end;
    end;
  end
  else with Canvas do
  begin
    DrawColumn := Columns[ACol];
    if gdFixed in AState then
    begin
      Font := DrawColumn.Title.Font;
      Brush.Color := DrawColumn.Title.Color;
    end
    else
    begin
//      Font := DrawColumn.Font;
      Brush.Color := DrawColumn.Color;
    end;
    if ARow < 0 then with DrawColumn.Title do
      WriteText(Canvas, ARect, FrameOffs, FrameOffs, Caption, Alignment)
    else if (DataLink = nil) or not DataLink.Active then
      FillRect(ARect)
    else
    begin
      Value := '';
      OldActive := DataLink.ActiveRecord;
      try
        DataLink.ActiveRecord := ARow;
        if Assigned(DrawColumn.Field) then
          Value := DrawColumn.Field.DisplayText;
        Highlight := HighlightCell(ACol, ARow, Value, AState);
        if Highlight then
        begin
          Brush.Color := clHighlight;
          Font.Color := clHighlightText;
        end;
    //    if DefaultDrawing then
          WriteText(Canvas, ARect, 2, 2, Value, DrawColumn.Alignment);
        if Columns.State = csDefault then
          DrawDataCell(ARect, DrawColumn.Field, AState);
        DrawColumnCell(ARect, ACol, DrawColumn, AState);
      finally
        DataLink.ActiveRecord := OldActive;
      end;
      if {DefaultDrawing and} (gdSelected in AState)
        and ((dgAlwaysShowSelection in Options) or Focused)
        and not (csDesigning in ComponentState)
        and not (dgRowSelect in Options)
        and (UpdateLock = 0)
        and (ValidParentForm(Self).ActiveControl = Self) then
        Windows.DrawFocusRect(Handle, ARect);
    end;
  end;
  if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
    [dgRowLines, dgColLines]) then
  begin
    InflateRect(ARect, 1, 1);
    DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
    DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_TOPLEFT);
  end;
end;

procedure Register;
begin
  RegisterComponents('IMMIService', [TColorDBGrid]);
end;

end.
