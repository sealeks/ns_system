unit ifpii_graphics;

{$I ifps3_def.inc}
interface
uses
  ifpscomp, ifps3common, ifps3utl, ifpiclass;

{
  Will register files from:
    Graphics


Register the STD library first

}

procedure SIRegister_Graphics_TypesAndConsts(Cl: TIFPSCompileTimeClassesImporter);
procedure SIRegisterTGRAPHICSOBJECT(Cl: TIFPSCompileTimeClassesImporter);
procedure SIRegisterTFont(Cl: TIFPSCompileTimeClassesImporter);
procedure SIRegisterTPEN(Cl: TIFPSCompileTimeClassesImporter);
procedure SIRegisterTBRUSH(Cl: TIFPSCompileTimeClassesImporter);
procedure SIRegisterTCanvas(cl: TIFPSCompileTimeClassesImporter);


procedure SIRegister_Graphics(Cl: TIFPSCompileTimeClassesImporter);

implementation
uses
  Classes {$IFDEF CLX},QControls,QGraphics{$ELSE},Controls, Graphics{$ENDIF};

procedure SIRegisterTGRAPHICSOBJECT(Cl: TIFPSCompileTimeClassesImporter);
begin
  with Cl.Add(cl.FindClass('TPERSISTENT'), TGRAPHICSOBJECT) do
  begin
    RegisterProperty('ONCHANGE', 'TNOTIFYEVENT', iptrw);
  end;
end;

procedure SIRegisterTFont(Cl: TIFPSCompileTimeClassesImporter);
begin
  with Cl.Add(cl.FindClass('TGraphicsObject'), TFont) do
  begin
    RegisterMethod('constructor Create;');
{$IFNDEF CLX}
    RegisterProperty('Handle', 'Integer', iptR);
{$ENDIF}
    RegisterProperty('PixelsPerInch', 'Integer', iptRW);
    RegisterProperty('Color', 'Integer', iptRW);
    RegisterProperty('Height', 'Integer', iptRW);
    RegisterProperty('Name', 'string', iptRW);
    RegisterProperty('Pitch', 'Byte', iptRW);
    RegisterProperty('Size', 'Integer', iptRW);
    RegisterProperty('Handle', 'Integer', iptRW);
    RegisterProperty('PixelsPerInch', 'Integer', iptRW);
  end;
end;

procedure SIRegisterTCanvas(cl: TIFPSCompileTimeClassesImporter); // requires TPersistent
begin
  with Cl.Add(cl.FindClass('TPersistent'), TCanvas) do
  begin
    RegisterMethod('procedure Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);');
    RegisterMethod('procedure Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);');
    RegisterMethod('procedure Draw(X, Y: Integer; Graphic: TGraphic);');
    RegisterMethod('procedure Ellipse(X1, Y1, X2, Y2: Integer);');
{$IFNDEF CLX}
    RegisterMethod('procedure FloodFill(X, Y: Integer; Color: TColor; FillStyle: Byte);');
{$ENDIF}
    RegisterMethod('procedure LineTo(X, Y: Integer);');
    RegisterMethod('procedure MoveTo(X, Y: Integer);');
    RegisterMethod('procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);');
    RegisterMethod('procedure Rectangle(X1, Y1, X2, Y2: Integer);');
    RegisterMethod('procedure Refresh;');
    RegisterMethod('procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);');
    RegisterMethod('function TextHeight(Text: string): Integer;');
    RegisterMethod('procedure TextOut(X, Y: Integer; Text: string);');
    RegisterMethod('function TextWidth(Text: string): Integer;');
{$IFNDEF CLX}
    RegisterProperty('Handle', 'Integer', iptRw);
{$ENDIF}
    RegisterProperty('Pixels', 'Integer Integer Integer', iptRW);
    RegisterProperty('Brush', 'TBrush', iptR);
    RegisterProperty('CopyMode', 'Byte', iptRw);
    RegisterProperty('Font', 'TFont', iptR);
    RegisterProperty('Pen', 'TPen', iptR);
  end;
end;

procedure SIRegisterTPEN(Cl: TIFPSCompileTimeClassesImporter);
begin
  with Cl.Add(cl.FindClass('TGRAPHICSOBJECT'), TPEN) do
  begin
    RegisterMethod('constructor CREATE');
    RegisterProperty('COLOR', 'TCOLOR', iptrw);
    RegisterProperty('MODE', 'TPENMODE', iptrw);
    RegisterProperty('STYLE', 'TPENSTYLE', iptrw);
    RegisterProperty('WIDTH', 'INTEGER', iptrw);
  end;
end;

procedure SIRegisterTBRUSH(Cl: TIFPSCompileTimeClassesImporter);
begin
  with Cl.Add(cl.FindClass('TGRAPHICSOBJECT'), TBrush) do
  begin
    RegisterMethod('constructor CREATE');
    RegisterProperty('COLOR', 'TCOLOR', iptrw);
    RegisterProperty('STYLE', 'TBRUSHSTYLE', iptrw);
  end;
end;

procedure SIRegister_Graphics_TypesAndConsts(Cl: TIFPSCompileTimeClassesImporter);
begin
  cl.se.AddConstantN('clScrollBar', 'Integer')^.Value.Value := TransLongintToStr(clScrollBar);
  cl.se.AddConstantN('clBackground', 'Integer')^.Value.Value := TransLongintToStr(clBackground);
  cl.se.AddConstantN('clActiveCaption', 'Integer')^.Value.Value := TransLongintToStr(clActiveCaption);
  cl.se.AddConstantN('clInactiveCaption', 'Integer')^.Value.Value := TransLongintToStr(clInactiveCaption);
  cl.se.AddConstantN('clMenu', 'Integer')^.Value.Value := TransLongintToStr(clMenu);
  cl.se.AddConstantN('clWindow', 'Integer')^.Value.Value := TransLongintToStr(clWindow);
  cl.se.AddConstantN('clWindowFrame', 'Integer')^.Value.Value := TransLongintToStr(clWindowFrame);
  cl.se.AddConstantN('clMenuText', 'Integer')^.Value.Value := TransLongintToStr(clMenuText);
  cl.se.AddConstantN('clWindowText', 'Integer')^.Value.Value := TransLongintToStr(clWindowText);
  cl.se.AddConstantN('clCaptionText', 'Integer')^.Value.Value := TransLongintToStr(clCaptionText);
  cl.se.AddConstantN('clActiveBorder', 'Integer')^.Value.Value := TransLongintToStr(clActiveBorder);
  cl.se.AddConstantN('clInactiveBorder', 'Integer')^.Value.Value := TransLongintToStr(clInactiveCaption);
  cl.se.AddConstantN('clAppWorkSpace', 'Integer')^.Value.Value := TransLongintToStr(clAppWorkSpace);
  cl.se.AddConstantN('clHighlight', 'Integer')^.Value.Value := TransLongintToStr(clHighlight);
  cl.se.AddConstantN('clHighlightText', 'Integer')^.Value.Value := TransLongintToStr(clHighlightText);
  cl.se.AddConstantN('clBtnFace', 'Integer')^.Value.Value := TransLongintToStr(clBtnFace);
  cl.se.AddConstantN('clBtnShadow', 'Integer')^.Value.Value := TransLongintToStr(clBtnShadow);
  cl.se.AddConstantN('clGrayText', 'Integer')^.Value.Value := TransLongintToStr(clGrayText);
  cl.se.AddConstantN('clBtnText', 'Integer')^.Value.Value := TransLongintToStr(clBtnText);
  cl.se.AddConstantN('clInactiveCaptionText', 'Integer')^.Value.Value := TransLongintToStr(clInactiveCaptionText);
  cl.se.AddConstantN('clBtnHighlight', 'Integer')^.Value.Value := TransLongintToStr(clBtnHighlight);
  cl.se.AddConstantN('cl3DDkShadow', 'Integer')^.Value.Value := TransLongintToStr(cl3DDkShadow);
  cl.se.AddConstantN('cl3DLight', 'Integer')^.Value.Value := TransLongintToStr(cl3DLight);
  cl.se.AddConstantN('clInfoText', 'Integer')^.Value.Value := TransLongintToStr(clInfoText);
  cl.se.AddConstantN('clInfoBk', 'Integer')^.Value.Value := TransLongintToStr(clInfoBk);

  cl.se.AddConstantN('clBlack', 'Integer')^.Value.Value := TransLongintToStr($000000);
  cl.se.AddConstantN('clMaroon', 'Integer')^.Value.Value := TransLongintToStr($000080);
  cl.se.AddConstantN('clGreen', 'Integer')^.Value.Value := TransLongintToStr($008000);
  cl.se.AddConstantN('clOlive', 'Integer')^.Value.Value := TransLongintToStr($008080);
  cl.se.AddConstantN('clNavy', 'Integer')^.Value.Value := TransLongintToStr($800000);
  cl.se.AddConstantN('clPurple', 'Integer')^.Value.Value := TransLongintToStr($800080);
  cl.se.AddConstantN('clTeal', 'Integer')^.Value.Value := TransLongintToStr($808000);
  cl.se.AddConstantN('clGray', 'Integer')^.Value.Value := TransLongintToStr($808080);
  cl.se.AddConstantN('clSilver', 'Integer')^.Value.Value := TransLongintToStr($C0C0C0);
  cl.se.AddConstantN('clRed', 'Integer')^.Value.Value := TransLongintToStr($0000FF);
  cl.se.AddConstantN('clLime', 'Integer')^.Value.Value := TransLongintToStr($00FF00);
  cl.se.AddConstantN('clYellow', 'Integer')^.Value.Value := TransLongintToStr($00FFFF);
  cl.se.AddConstantN('clBlue', 'Integer')^.Value.Value := TransLongintToStr($FF0000);
  cl.se.AddConstantN('clFuchsia', 'Integer')^.Value.Value := TransLongintToStr($FF00FF);
  cl.se.AddConstantN('clAqua', 'Integer')^.Value.Value := TransLongintToStr($FFFF00);
  cl.se.AddConstantN('clLtGray', 'Integer')^.Value.Value := TransLongintToStr($C0C0C0);
  cl.se.AddConstantN('clDkGray', 'Integer')^.Value.Value := TransLongintToStr($808080);
  cl.se.AddConstantN('clWhite', 'Integer')^.Value.Value := TransLongintToStr($FFFFFF);
  cl.se.AddConstantN('clNone', 'Integer')^.Value.Value := TransLongintToStr($1FFFFFFF);
  cl.se.AddConstantN('clDefault', 'Integer')^.Value.Value := TransLongintToStr($20000000);
  cl.se.AddConstantN('fsBold', 'Integer')^.Value.Value := #1;
  cl.se.AddConstantN('fsItalic', 'Integer')^.Value.Value := #2;
  cl.se.AddConstantN('fsUnderline', 'Integer')^.Value.Value := #4;
  cl.se.AddConstantN('fsStrikeout', 'Integer')^.Value.Value := #8;

  cl.se.AddTypeS('TFontPitch', '(fpDefault, fpVariable, fpFixed)');
  cl.se.AddTypeS('TPenStyle', '(psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame)');
  cl.se.AddTypeS('TPenMode', '(pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, pmMergePenNot, pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotMerge, pmMask, pmNotMask, pmXor, pmNotXor)');
  cl.se.AddTypeS('TBrushStyle', '(bsSolid, bsClear, bsHorizontal, bsVertical, bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross)');
  cl.se.addTypeS('TColor', 'integer');
end;


procedure SIRegister_Graphics(Cl: TIFPSCompileTimeClassesImporter);
begin
  SIRegister_Graphics_TypesAndConsts(Cl);
  SIRegisterTGRAPHICSOBJECT(Cl);
  SIRegisterTFont(Cl);
  SIRegisterTPEN(cl);
  SIRegisterTBRUSH(cl);
  SIRegisterTCanvas(cl);
end;

// MiniVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


End.








