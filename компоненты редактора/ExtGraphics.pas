{
  Библиотека дополнительных утилит

  Дополнительные процедуры и функции для работы с графикой

  © Роман М. Мочалов, 1997-2001
  E-mail: roman@sar.nnov.ru
}

unit ExtGraphics;

interface

{$I EXT.INC}

uses
  Windows, SysUtils, Graphics;

{ Отрисовка прямоугольника с точечной 50% заливкой на окне с описателем
  Handle и на указанном контексте устройства. Используется для отрисовки
  линий изменения размера (например рамки окна, полоски разделителя).
  ПРИМЕЧАНИЕ. Перед вызовом второй функции следует вручную установить
  цвета точек линии через цвет заливки и цвет текста. }

procedure PaintResizeRect(Handle: THandle; Rect: TRect);
procedure PaintResizeRectDC(DC: HDC; Rect: TRect);

{ Отрисовка рамки кнопки ToolBar без заливки (при нажатии кнопка вдавливается). }

procedure PaintToolBarBtnFrame(DC: HDC; Rect: TRect; Pressed: Boolean);
procedure PaintToolBarBtnFrameEx(DC: HDC; Rect: TRect; Pressed: Boolean; SideFlags: Integer);

{ Отрисовка рамки кнопки скроллера (при нажатии кнопка становится плоской). }

procedure PaintScrollBtnFrame(DC: HDC; Rect: TRect; Pressed: Boolean);
procedure PaintScrollBtnFrameEx(DC: HDC; Rect: TRect; Pressed: Boolean; SideFlags: Integer);

{ Отрисовка кнопки выпадающего списка (первая - через вызов стандартной
  функции, вторая - вручную) }

procedure PaintBtnComboBox(DC: HDC; Rect: TRect; Pressed: Boolean);
procedure PaintBtnComboBox2(DC: HDC; Rect: TRect; Pressed: Boolean);

{ Отрисовка кнопки с ... (многоточием) }

procedure PaintBtnEllipsis(DC: HDC; Rect: TRect; Pressed: Boolean);

{ Вычисление высоты шрифта через Canvas.TextHeight }

function GetFontHeight(Font: TFont): Integer;

{ Вычисление (примерное) ширины строки из указанного количества символов. }

function GetFontWidth(Font: TFont; TextLength: Integer): Integer;

implementation

uses
  ExtSysUtils;

{ Отрисовка прямоугольника с точечной 50% заливкой }

var
  FPatternBitmap: TBitmap = nil;

function PatternBitmap: TBitmap;
const
  C: array[Boolean] of TColor = (clBlack, clWhite);
var
  X, Y: Integer;
begin
  if FPatternBitmap = nil then
  begin
    FPatternBitmap := TBitmap.Create;
    with FPatternBitmap do
    begin
      Monochrome := TRUE;
      Width := 8;
      Height := 8;
      for X := 0 to 7 do
        for Y := 0 to 7 do
          Canvas.Pixels[X, Y] := C[(X and 1) <> (Y and 1)];
    end;
  end;
  Result := FPatternBitmap;
end;

procedure PaintResizeRect(Handle: THandle; Rect: TRect);
var
  DC: HDC;
begin
  DC := GetDCEx(Handle, 0, DCX_LOCKWINDOWUPDATE);
  try
    { параметры вывода картинки: цвета фона и точек, режим - COPY }
    SetTextColor(DC, ColorToRGB(clWhite));
    SetBkColor(DC, ColorToRGB(clBlack));
    SetBkMode(DC, OPAQUE);
    SetRop2(DC, R2_COPYPEN);
    { рисуем }
    PaintResizeRectDC(DC, Rect);
  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure PaintResizeRectDC(DC: HDC; Rect: TRect);
var
  NewBrush, OldBrush: HBRUSH;
{$IFDEF EXT_D2}
  Point: TPoint;
{$ENDIF}
begin
  NewBrush := CreatePatternBrush(PatternBitmap.Handle);
  UnrealizeObject(NewBrush);
{$IFDEF EXT_D2}
  SetBrushOrgEx(DC, 0, 0, Point);
{$ELSE}
  SetBrushOrgEx(DC, 0, 0, nil);
{$ENDIF}
  OldBrush := SelectObject(DC, NewBrush);
  with Rect do PatBlt(DC, Left, Top, Right - Left, Bottom - Top, PATINVERT);
  DeleteObject(SelectObject(DC, OldBrush));
end;

{ Отрисовка рамки кнопки без заливки }

procedure PaintToolBarBtnFrame(DC: HDC; Rect: TRect; Pressed: Boolean);
begin
  PaintToolBarBtnFrameEx(DC, Rect, Pressed, BF_RECT);
end;

procedure PaintToolBarBtnFrameEx(DC: HDC; Rect: TRect; Pressed: Boolean; SideFlags: Integer);
begin
  if not Pressed then
  begin
    DrawEdge(DC, Rect, BDR_RAISEDOUTER, SideFlags and (not BF_TOPLEFT));
    if SideFlags and BF_BOTTOM <> 0 then Dec(Rect.Bottom);
    if SideFlags and BF_RIGHT <> 0 then Dec(Rect.Right);
    DrawEdge(DC, Rect, BDR_RAISEDINNER, SideFlags and (not BF_BOTTOMRIGHT));
    if SideFlags and BF_TOP <> 0 then Inc(Rect.Top);
    if SideFlags and BF_LEFT <> 0 then Inc(Rect.Left);
    DrawEdge(DC, Rect, BDR_RAISEDINNER, SideFlags and (not BF_TOPLEFT));
    if SideFlags and BF_BOTTOM <> 0 then Dec(Rect.Bottom);
    if SideFlags and BF_RIGHT <> 0 then Dec(Rect.Right);
    DrawEdge(DC, Rect, BDR_RAISEDOUTER, SideFlags and (not BF_BOTTOMRIGHT));
  end
  else
  begin
    DrawEdge(DC, Rect, BDR_SUNKENOUTER, SideFlags and (not BF_TOPLEFT));
    if SideFlags and BF_BOTTOM <> 0 then Dec(Rect.Bottom);
    if SideFlags and BF_RIGHT <> 0 then Dec(Rect.Right);
    DrawEdge(DC, Rect, BDR_SUNKENINNER, SideFlags and (not BF_BOTTOMRIGHT));
    if SideFlags and BF_TOP <> 0 then Inc(Rect.Top);
    if SideFlags and BF_LEFT <> 0 then Inc(Rect.Left);
    DrawEdge(DC, Rect, BDR_SUNKENINNER, SideFlags and (not BF_TOPLEFT));
    if SideFlags and BF_BOTTOM <> 0 then Dec(Rect.Bottom);
    if SideFlags and BF_RIGHT <> 0 then Dec(Rect.Right);
    DrawEdge(DC, Rect, BDR_SUNKENOUTER, SideFlags and (not BF_BOTTOMRIGHT));
  end
end;

{ Отрисовка рамки кнопки строллера без заливки }

procedure PaintScrollBtnFrame(DC: HDC; Rect: TRect; Pressed: Boolean);
begin
  PaintScrollBtnFrameEx(DC, Rect, Pressed, BF_RECT);
end;

procedure PaintScrollBtnFrameEx(DC: HDC; Rect: TRect; Pressed: Boolean; SideFlags: Integer);
begin
  if not Pressed then
    PaintToolBarBtnFrameEx(DC, Rect, Pressed, SideFlags)
  else
    DrawEdge(DC, Rect, BDR_SUNKENOUTER, SideFlags or BF_FLAT);
end;

{ Отрисовка кнопки выпадающего списка }

procedure PaintBtnComboBox(DC: HDC; Rect: TRect; Pressed: Boolean);
var
  Flags: Integer;
begin
  Flags := 0;
  if Pressed then Flags := DFCS_FLAT or DFCS_PUSHED;
  DrawFrameControl(DC, Rect, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
end;

procedure PaintBtnComboBox2(DC: HDC; Rect: TRect; Pressed: Boolean);
var
  Flags, DX: Integer;
begin
  Flags := 0;
  if Pressed then Flags := DFCS_FLAT;
  DrawEdge(DC, Rect, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
  Flags := (Rect.Right - Rect.Left) div 2 - 1 + Ord(Pressed);
  DX := (Rect.Right - Rect.Left) mod 2 - 1;
  PatBlt(DC, Rect.Left + Flags - 2 + DX, Rect.Top + Flags - 1, 7, 1, BLACKNESS);
  PatBlt(DC, Rect.Left + Flags - 1 + DX, Rect.Top + Flags + 0, 5, 1, BLACKNESS);
  PatBlt(DC, Rect.Left + Flags - 0 + DX, Rect.Top + Flags + 1, 3, 1, BLACKNESS);
  PatBlt(DC, Rect.Left + Flags + 1 + DX, Rect.Top + Flags + 2, 1, 1, BLACKNESS);
end;

{ Отрисовка кнопки с ... (многоточием) }

procedure PaintBtnEllipsis(DC: HDC; Rect: TRect; Pressed: Boolean);
var
  Flags: Integer;
begin
  Flags := 0;
  if Pressed then Flags := BF_FLAT;
  DrawEdge(DC, Rect, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
  Flags := (Rect.Right - Rect.Left) div 2 - 1 + Ord(Pressed);
  PatBlt(DC, Rect.Left + Flags, Rect.Top + Flags, 2, 2, BLACKNESS);
  PatBlt(DC, Rect.Left + Flags - 3, Rect.Top + Flags, 2, 2, BLACKNESS);
  PatBlt(DC, Rect.Left + Flags + 3, Rect.Top + Flags, 2, 2, BLACKNESS);
end;

{ Вычисление высоту шрифта }

function GetFontHeight(Font: TFont): Integer;
var
  DC: HDC;
  Canvas: TCanvas;
begin
  { получаем контекст экрана }
  DC := GetDC(0);
  try
    { создаем полотно }
    Canvas := TCanvas.Create;
    try
      { обязательные параметры }
      Canvas.Handle := DC;
      Canvas.Font := Font;
      { результат }
      Result := Canvas.TextHeight('^j');
    finally
      Canvas.Free;
    end;
  finally
    ReleaseDC(0, DC);
  end;
end;

{ Вычисление (примерное) ширины строки из указанного количества символов. }

function GetFontWidth(Font: TFont; TextLength: Integer): Integer;
var
  DC: HDC;
  Canvas: TCanvas;
  TM: TTextMetric;
begin
  { получаем контекст экрана }
  DC := GetDC(0);
  try
    { создаем полотно }
    Canvas := TCanvas.Create;
    try
      { обязательные параметры }
      Canvas.Handle := DC;
      Canvas.Font := Font;
      { параметры шрифта }
      GetTextMetrics(DC, TM);
      { результат }
      Result := TextLength * (Canvas.TextWidth('0') - TM.tmOverhang) + TM.tmOverhang + 4;
    finally
      Canvas.Free;
    end;
  finally
    ReleaseDC(0, DC);
  end;
end;

initialization

finalization
  FreeAndNil(FPatternBitmap);

end.
