unit ifpii_controls;
{$I ifps3_def.inc}
interface
uses
  ifpscomp, ifps3common, ifps3utl, ifpiclass,  TypInfo, SysUtils;
{
  Will register files from:
    Controls

  Register the STD, Classes (at least the types&consts) and Graphics libraries first

}

procedure SIRegister_Controls_TypesAndConsts(Cl: TIFPSCompileTimeClassesImporter);

procedure SIRegisterTControl(Cl: TIFPSCompileTimeClassesImporter);
procedure SIRegisterTWinControl(Cl: TIFPSCompileTimeClassesImporter); // requires TControl
procedure SIRegisterTGraphicControl(cl: TIFPSCompileTimeClassesImporter); // requires TControl
procedure SIRegisterTCustomControl(cl: TIFPSCompileTimeClassesImporter); // requires TWinControl
procedure SIRegisterFreeClass(Cl: TIFPSCompileTimeClassesImporter; ClassP: TClass; ansect: TClass);

procedure SIRegister_Controls(Cl: TIFPSCompileTimeClassesImporter);


implementation
uses
{$IFDEF CLX}
  QControls;
{$ELSE}
  Controls;
{$ENDIF}

procedure SIRegisterTControl(Cl: TIFPSCompileTimeClassesImporter);
begin
  with Cl.Add(cl.FindClass('TComponent'), TControl) do
  begin
    RegisterMethod('constructor Create(AOwner: TComponent);');
    RegisterMethod('procedure BringToFront;');
    RegisterMethod('procedure Hide;');
    RegisterMethod('procedure Invalidate;virtual;');
    RegisterMethod('procedure refresh;');
    RegisterMethod('procedure Repaint;virtual;');
    RegisterMethod('procedure SendToBack;');
    RegisterMethod('procedure Show;');
    RegisterMethod('procedure Update;');
    RegisterMethod('procedure SetBounds(x,y,w,h: Integer);virtual;');
    RegisterProperty('Left', 'Integer', iptRW);
    RegisterProperty('Top', 'Integer', iptRW);
    RegisterProperty('Width', 'Integer', iptRW);
    RegisterProperty('Height', 'Integer', iptRW);
    RegisterProperty('Hint', 'String', iptRW);
    RegisterProperty('Align', 'TAlign', iptRW);
    RegisterProperty('ClientHeight', 'Longint', iptRW);
    RegisterProperty('ClientWidth', 'Longint', iptRW);
    RegisterProperty('ShowHint', 'Boolean', iptRW);
    RegisterProperty('Visible', 'Boolean', iptRW);
    RegisterProperty('ENABLED', 'BOOLEAN', iptrw);
    RegisterProperty('HINT', 'STRING', iptrw);

    {$IFNDEF MINIVCL}
    RegisterMethod('function Dragging: Boolean;');
    RegisterProperty('HasParent', 'Boolean', iptr);
    RegisterMethod('procedure BEGINDRAG(IMMEDIATE:BOOLEAN)');
    RegisterMethod('function CLIENTTOSCREEN(POINT:TPOINT):TPOINT');
    RegisterMethod('procedure ENDDRAG(DROP:BOOLEAN)');
    {$IFNDEF CLX}
    RegisterMethod('function GETTEXTBUF(BUFFER:PCHAR;BUFSIZE:INTEGER):INTEGER');
    RegisterMethod('function GETTEXTLEN:INTEGER');
    RegisterMethod('procedure SETTEXTBUF(BUFFER:PCHAR)');
    RegisterMethod('function PERFORM(MSG:CARDINAL;WPARAM,LPARAM:LONGINT):LONGINT');
    {$ENDIF}
    RegisterMethod('function SCREENTOCLIENT(POINT:TPOINT):TPOINT');
    RegisterProperty('CURSOR', 'TCURSOR', iptrw);
    {$ENDIF}
  end;
end;


procedure SIRegisterFreeClass(Cl: TIFPSCompileTimeClassesImporter; ClassP: TClass; ansect: TClass);
var
    pn: string;
    i: integer;
    Props: PPropList;
    TypeData: PTypeData;
   // добавлено
  begin
  if (cl.FindClass(ClassP.ClassName)<>nil) then exit;
   with Cl.Add(cl.FindClass(ansect.ClassName), ClassP) do
  begin
   try
   TypeData := GetTypeData(classP.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   GetPropInfos(classP.ClassInfo, Props);
   for i := 0 to TypeData^.PropCount - 1 do
      begin

        pn:=Props^[i]^.PropType^^.Name;
        RegisterProperty(Props^[i]^.Name ,pn,iptRW);
        if Props^[i]^.PropType^^.Kind = tkClass then
         begin
          SIRegisterFreeClass(Cl, GetTypeData(Props^[i]^.PropType^).ClassType,GetTypeData(Props^[i]^.PropType^).ClassType.ClassParent);
          RegisterProperty(Props^[i]^.Name ,pn,iptR);
         end;
      end;
   finally
     Freemem(Props);
   end;
   end;
end;




procedure SIRegisterTWinControl(Cl: TIFPSCompileTimeClassesImporter); // requires TControl
begin
  with Cl.Add(cl.FindClass('TControl'), TWinControl) do
  begin

    with Cl.FindClass('TControl') do
    begin
      RegisterProperty('Parent', 'TWinControl', iptRW);
    end;


    {$IFNDEF MINIVCL}
    RegisterMethod('function HandleAllocated: Boolean;');
    RegisterMethod('procedure HandleNeeded;');
    RegisterMethod('procedure EnableAlign;');
    RegisterMethod('procedure RemoveControl(AControl: TControl);');
    RegisterMethod('procedure InsertControl(AControl: TControl);');
    RegisterMethod('procedure Realign;');
    RegisterMethod('procedure ScaleBy(M, D: Integer);');
    RegisterMethod('procedure ScrollBy(DeltaX, DeltaY: Integer);');
    RegisterMethod('procedure SetFocus; virtual;');
    {$IFNDEF CLX}
    RegisterProperty('Handle', 'Longint', iptRW);
    RegisterMethod('procedure PAINTTO(DC:Longint;X,Y:INTEGER)');
    {$ENDIF}
    RegisterProperty('Showing', 'Boolean', iptR);
    RegisterProperty('TabOrder', 'Integer', iptRW);
    RegisterProperty('TabStop', 'Boolean', iptRW);

    RegisterMethod('function CANFOCUS:BOOLEAN');
    RegisterMethod('function CONTAINSCONTROL(CONTROL:TCONTROL):BOOLEAN');
    RegisterMethod('procedure DISABLEALIGN');
    RegisterMethod('function FOCUSED:BOOLEAN');
    RegisterMethod('procedure UPDATECONTROLSTATE');

    RegisterProperty('BRUSH', 'TBRUSH', iptr);
    RegisterProperty('CONTROLS', 'TCONTROL INTEGER', iptr);
    RegisterProperty('CONTROLCOUNT', 'INTEGER', iptr);
    RegisterProperty('HELPCONTEXT', 'LONGINT', iptrw);
    {$ENDIF}
  end;
end;
procedure SIRegisterTGraphicControl(cl: TIFPSCompileTimeClassesImporter); // requires TControl
begin
  Cl.Add(cl.FindClass('TControl'), TGraphicControl);
end;

procedure SIRegisterTCustomControl(cl: TIFPSCompileTimeClassesImporter); // requires TWinControl
begin
  Cl.Add(cl.FindClass('TWinControl'), TCustomControl);
end;

procedure SIRegister_Controls_TypesAndConsts(Cl: TIFPSCompileTimeClassesImporter);
begin
 Cl.se.AddTypeS('TMouseEvent', 'procedure(Sender: TObject; Button: Byte; Shift: Byte; X, Y: Integer);');
  cl.se.AddTypeS('TMouseMoveEvent', 'procedure(Sender: TObject; Shift: Byte; X, Y: Integer);');
  cl.se.AddTypeS('TKeyEvent', 'procedure(Sender: TObject; var Key: Word; Shift: Byte);');
  cl.se.AddTypeS('TKeyPressEvent', 'procedure(Sender: TObject; var Key: Char);');
  cl.se.AddTypeS('TMouseButton', '(mbLeft, mbRight, mbMiddle)');
  cl.se.AddTypeS('TDragMode', '(dmManual, dmAutomatic)');
  cl.se.AddTypeS('TDragState', '(dsDragEnter, dsDragLeave, dsDragMove)');
  cl.se.AddTypeS('TDragKind', '(dkDrag, dkDock)');
  cl.se.AddTypeS('TDragOverEvent', 'procedure(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean)');
  cl.se.AddTypeS('TDragDropEvent', 'procedure(Sender, Source: TObject;X, Y: Integer)');
  cl.se.AddTypeS('TEndDragEvent', 'procedure(Sender, Target: TObject; X, Y: Integer)');

  cl.se.addTypeS('TAlign', '(alNone, alTop, alBottom, alLeft, alRight, alClient)');

  cl.se.AddConstantN('akLeft', 'Byte')^.Value.Value := #1;
  cl.se.AddConstantN('akTop', 'Byte')^.Value.Value := #2;
  cl.se.AddConstantN('akRight', 'Byte')^.Value.Value := #4;
  cl.se.AddConstantN('akbottom', 'Byte')^.Value.Value := #8;
  cl.se.AddConstantN('mrNone', 'Integer')^.Value.Value := TransLongintToStr(0);
  cl.se.AddConstantN('mrOk', 'Integer')^.Value.Value := TransLongintToStr(1);
  cl.se.AddConstantN('mrCancel', 'Integer')^.Value.Value := TransLongintToStr(2);
  cl.se.AddConstantN('mrAbort', 'Integer')^.Value.Value := TransLongintToStr(3);
  cl.se.AddConstantN('mrRetry', 'Integer')^.Value.Value := TransLongintToStr(4);
  cl.se.AddConstantN('mrIgnore', 'Integer')^.Value.Value := TransLongintToStr(5);
  cl.se.AddConstantN('mrYes', 'Integer')^.Value.Value := TransLongintToStr(6);
  cl.se.AddConstantN('mrNo', 'Integer')^.Value.Value := TransLongintToStr(7);
  cl.se.AddConstantN('mrAll', 'Integer')^.Value.Value := TransLongintToStr(8);
  cl.se.AddConstantN('mrNoToAll', 'Integer')^.Value.Value := TransLongintToStr(9);
  cl.se.AddConstantN('mrYesToAll', 'Integer')^.Value.Value := TransLongintToStr(10);
  cl.se.AddConstantN('crDefault', 'Integer')^.Value.Value := TransLongintToStr(0);
  cl.se.AddConstantN('crNone', 'Integer')^.Value.Value := TransLongintToStr(-1);
  cl.se.AddConstantN('crArrow', 'Integer')^.Value.Value := TransLongintToStr(-2);
  cl.se.AddConstantN('crCross', 'Integer')^.Value.Value := TransLongintToStr(-3);
  cl.se.AddConstantN('crIBeam', 'Integer')^.Value.Value := TransLongintToStr(-4);
  cl.se.AddConstantN('crSize', 'Integer')^.Value.Value := TransLongintToStr(-22);
  cl.se.AddConstantN('crSizeNESW', 'Integer')^.Value.Value := TransLongintToStr(-6);
  cl.se.AddConstantN('crSizeNS', 'Integer')^.Value.Value := TransLongintToStr(-7);
  cl.se.AddConstantN('crSizeNWSE', 'Integer')^.Value.Value := TransLongintToStr(-8    );
  cl.se.AddConstantN('crSizeWE', 'Integer')^.Value.Value := TransLongintToStr(-9    );
  cl.se.AddConstantN('crUpArrow', 'Integer')^.Value.Value := TransLongintToStr(-10);
  cl.se.AddConstantN('crHourGlass', 'Integer')^.Value.Value := TransLongintToStr(-11);
  cl.se.AddConstantN('crDrag', 'Integer')^.Value.Value := TransLongintToStr(-12);
  cl.se.AddConstantN('crNoDrop', 'Integer')^.Value.Value := TransLongintToStr(-13  );
  cl.se.AddConstantN('crHSplit', 'Integer')^.Value.Value := TransLongintToStr(-14);
  cl.se.AddConstantN('crVSplit', 'Integer')^.Value.Value := TransLongintToStr(-15);
  cl.se.AddConstantN('crMultiDrag', 'Integer')^.Value.Value := TransLongintToStr(-16);
  cl.se.AddConstantN('crSQLWait', 'Integer')^.Value.Value := TransLongintToStr(-17);
  cl.se.AddConstantN('crNo', 'Integer')^.Value.Value := TransLongintToStr(-18);
  cl.se.AddConstantN('crAppStart', 'Integer')^.Value.Value := TransLongintToStr(-19);
  cl.se.AddConstantN('crHelp', 'Integer')^.Value.Value := TransLongintToStr(-20);
end;

procedure SIRegister_Controls(Cl: TIFPSCompileTimeClassesImporter);
begin
  SIRegister_Controls_TypesAndConsts(cl);

  SIRegisterTControl(Cl);
  SIRegisterTWinControl(Cl);
  SIRegisterTGraphicControl(cl);
  SIRegisterTCustomControl(cl);
end;

// MiniVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

end.
