///////////////////////////////////////////////
//
//   FVG Components Library.
//   Components: TFloatEdit
//   Requires:   none
//
//   (C) Damage, Inc. 2001.
//   (C) Filippov V. DamageInc@e-mail.ru.
//
//   Have a nice DamagIng!
///////////////////////////////////////////////

unit FloatEdits;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Math, ClipBrd;

type
  TOnShowCursor=procedure (Sender:TObject;ShowCursor:boolean) of object;

  TDataFormat=class(TPersistent)
  private
    fFloatFormat:TFloatFormat;
    fPrecision:integer;
    fDigits:integer;
    fOnChange:TNotifyEvent;
    procedure SetFloatFormat(V:TFloatFormat);
    procedure SetPD(Index:integer;V:integer);
    procedure Change;
  public
    constructor Create;virtual;
    property OnChange:TNotifyEvent read fOnChange write fOnChange;
  published
    property FloatFormat:TFloatFormat read fFloatFormat write SetFloatFormat default ffGeneral;
    property Precision:integer index 0 read fPrecision write SetPD default 8;
    property Digits:integer index 1 read fDigits write SetPD default 16;
  end;

  TFloatEdit=class(TCustomControl)
  private
    fOnChange: TNotifyEvent; // дописано SKA
    fOnlyInt:boolean;
    fBorderStyle:TBorderStyle;
    fData:double;
    fText:string;
    fDataFormat:TDataFormat;
    StartPoint:integer;
    fCurPos:Longint;
    fDefDecSep:char;
    Created:boolean;
    fSelStart,fSelLength:integer;
    fAutoSelect:boolean;
    ShiftDownPos:integer;
    MouseSel:boolean;
    fReadOnly:boolean;
    StartIndex:integer;
    MouseEnter:boolean;
    procedure SetBorderStyle(V:TBorderStyle);
    procedure SetOnlyInt(V:boolean);
    procedure SetData(V:double);
    function  GetData:double;
    procedure SetText(V:string);
    procedure SetDecimalSeparator(t:string);
    procedure SetDefDecSep(V:char);
    function  CanConvert(s:string):boolean;
    function  Convert(s:string):double;
    procedure SetCurPos(V:Longint);
    procedure SetSelStart(V:integer);
    procedure SetSelLength(V:integer);
    procedure SetAutoSelect(V:boolean);
    procedure DataFormatChange(Sender:TObject);
    procedure DrawCursor;
    function  KeyDataToShiftState(KeyData: Longint):TShiftState;
    procedure CMFontChanged(var Message: TMessage);message CM_FONTCHANGED;
    procedure CMColorChanged(var Message: TMessage);message CM_COLORCHANGED;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message:TWMKillFocus);message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message:TWMLButtonDown);message WM_LButtonDown;
    procedure WMRButtonDown(var Message:TWMRButtonDown);message WM_RButtonDown;
    procedure WMLButtonUp(var Message:TWMLBUTTONUP);message WM_LBUTTONUP;
    procedure WMMouseLeave(var Message:TWMMOUSE);message CM_MOUSELEAVE;
    procedure WMMouseMove(var Message:TWMMOUSEMOVE);message WM_MOUSEMOVE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TWMNoParams); message CM_EXIT;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
  protected
    procedure Paint;override;
    procedure Resize;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    property Canvas;
    property CurPos:Longint read fCurPos write SetCurPos;
    procedure Invalidate;override;
    property SelStart:integer read fSelStart write SetSelStart;
    property SelLength:integer read fSelLength write SetSelLength;
    procedure SelectAll;
    property ParentCtl3D;
    property Ctl3D;
    property DoubleBuffered;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange; //дописано мной - SKA
    property OnlyInt:boolean read fOnlyInt write SetOnlyInt;
    property BorderStyle:TBorderStyle read fBorderStyle write SetBorderStyle;
    property Data:double read GetData write SetData;
    property Text:string read fText write SetText;
    property DataFormat:TDataFormat read fDataFormat write fDataFormat;
    property DefDecSep:char read fDefDecSep write SetDefDecSep;
    property AutoSelect:boolean read fAutoSelect write SetAutoSelect;
    property ReadOnly:boolean read fReadOnly write fReadOnly;
    property Anchors;
    property Font;
    property Color;
    property Constraints;
    property DragCursor;
    property DragMode;
    property DragKind;
    property Enabled;
    property TabOrder;
    property TabStop;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnStartDock;
    property OnStartDrag;
  end;


procedure Register;

implementation
{$R FloatEdit.dcr}

constructor TFloatEdit.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 ControlStyle := [csCaptureMouse, csClickEvents,csSetCaption, csOpaque, csDoubleClicks];
 Created:=false;
 fDataFormat:=TDataFormat.Create;
 fDataFormat.OnChange:=DataFormatChange;
 fBorderStyle:=bsSingle;
 fOnlyInt:=false;
 fDefDecSep:='.';
 StartPoint:=2;
 Height:=20;
 Width:=80;
 fData:=0;
 fText:='';
 TabStop:=true;
 fCurPos:=1;
 fSelStart:=0;  fSelLength:=0;
 StartIndex:=0;
 fReadOnly:=false;
 Color:=clWhite;
 MouseEnter:=false;
 Created:=true;
end;

destructor TFloatEdit.Destroy;
begin
 fDataFormat.Free;
 Created:=false;
 inherited;
end;

procedure TFloatEdit.Resize;
begin
 DrawCursor;
end;

procedure TFloatEdit.CMColorChanged(var Message: TMessage);
begin
 Invalidate;
end;

procedure TFloatEdit.CMFontChanged(var Message: TMessage);
begin
 Canvas.Font:=Font;
 Invalidate;
end;

procedure TFloatEdit.Invalidate;
var
 r:TRect;
begin
 if Parent=nil then Exit;
 if Created then if Self.Visible then
    begin
     r:=Rect(0,0,Width,Height);
     InvalidateRect(Self.Handle,@r,false);
    end;
end;

procedure TFloatEdit.Paint;

 function CopyEx(t:string;s,l:integer):string;
 begin
  if s<=0 then l:=l+s-1;
  Result:=Copy(t,max(s,1),l);
 end;

var
 TextSize:TSize;
 s,bsel,asel,sel:string;
 i,fSelStartL:integer;
 r:TRect;
 fc:TColor;
begin
 if csDestroying in ComponentState then Exit;
 with Canvas do
  begin
   Brush.Color:=Color;
   Pen.Color:=Color;
   Rectangle(StartPoint,StartPoint,Width-StartPoint,Height-StartPoint);

   s:=Text;
   i:=Pos('.',s);
   if i>0 then s[i]:=fDefDecSep else
      begin
       i:=Pos(',',s);
       if i>0 then s[i]:=fDefDecSep;
      end;
   s:=Copy(s,StartIndex+1,Length(s)-StartIndex);
   fSelStartL:=fSelStart-StartIndex;
   //определяем части текста до, внутри и после выделения
//   if not Focused then Sel:=0 else
   bSel:=CopyEx(s,1,fSelStartL);
   Sel:=CopyEx(s,fSelStartL+1,fSelLength);
   aSel:=CopyEx(s,fSelStartL+fSelLength+1,Length(s)-fSelStartL-fSelLength);
   //Рисуем выделение
   if Focused then
      begin
       Brush.Color:=clHighLight;
       r:=Rect(StartPoint+1+TextWidth(bSel),StartPoint+1,StartPoint+TextWidth(bSel+Sel)+1,Height-StartPoint-1);
       FillRect(r);
      end;
   //Выводим текст
   TextSize:=TextExtent(s);
   Brush.Style:=bsClear;
   fc:=Font.Color;
   TextOut(StartPoint+1,(Height-2*StartPoint-TextSize.cy) div 2+StartPoint,bSel);
   if Focused then Font.Color:=clHighlightText;
   TextOut(PenPos.x,PenPos.y,Sel);
   Font.Color:=fc;
   TextOut(PenPos.x,PenPos.y,aSel);
  end;

 if fBorderStyle=bsSingle then
    with Canvas do
     begin
      Pen.Color:=clGray;
      Polyline([Point(0,Height-2),Point(0,0),Point(Width-1,0)]);
      Pen.Color:=clBlack;
      Polyline([Point(1,Height-3),Point(1,1),Point(Width-2,1)]);
      Pen.Color:=clSilver;
      Polyline([Point(1,Height-2),Point(Width-2,Height-2),Point(Width-2,0)]);
      Pen.Color:=clWhite;
      Polyline([Point(0,Height-1),Point(Width-1,Height-1),Point(Width-1,-1)]);
     end;
 if fCurPos>Length(Text) then CurPos:=Length(Text);
end;

procedure TFloatEdit.DrawCursor;
var
 s:string;
 cp:TSize;
 i:integer;
 NeedInvalidate:boolean;
begin
 if csDesigning in ComponentState then Exit;
 DestroyCaret;
 if csDestroying in ComponentState then Exit;
 NeedInvalidate:=false;
 //Определяем StartIndex
 if Canvas.TextWidth(Copy(Text,StartIndex+1,fCurPos-StartIndex))>Width-2*StartPoint-3{} then
    begin
     i:=0;
     while (Canvas.TextWidth(Copy(Text,fCurPos-i+1,i))<(Width-2*StartPoint-3{}) div 2) do inc(i);
     StartIndex:=fCurPos-i+1;
     NeedInvalidate:=true;
    end else
     if fCurPos<=StartIndex then
        begin
         i:=0;
         while (Canvas.TextWidth(Copy(Text,fCurPos-i+1,i))<(Width-2*StartPoint-3) div 2)and(i<Length(Text)) do inc(i);
         StartIndex:=fCurPos-i;
         if Canvas.TextWidth(Copy(Text,1,Length(Text)))<=Width-2*StartPoint-3 then StartIndex:=0;
         NeedInvalidate:=true;
        end;
 if Canvas.TextWidth(Copy(Text,StartIndex+1,Length(Text)-StartIndex))<Width-2*StartPoint-3 then
    begin
     i:=0;
     while (Canvas.TextWidth(Copy(Text,StartIndex-i+1,Length(Text)))<=Width-2*StartPoint-3)and(i<=Length(Text)) do inc(i);
     StartIndex:=StartIndex-i+1;
     NeedInvalidate:=true;
    end;
 if NeedInvalidate then
    begin
     if StartIndex<0 then StartIndex:=0;
     Invalidate;
    end;
 //Далее выводим мигающий курсор
 if not Focused then Exit;
 s:=Copy(Text,StartIndex+1,CurPos-StartIndex);
 cp:=Canvas.TextExtent(s);
 CreateCaret(Handle,0,1,Height-2*StartPoint-2);
 SetCaretPos(StartPoint+1+cp.cx,StartPoint+1);
 ShowCaret(Handle);
end;

procedure TFloatEdit.SetBorderStyle(V:TBorderStyle);
begin
 if fBorderStyle<>V then
    begin
    fBorderStyle:=V;
    if V=bsSingle then StartPoint:=2 else StartPoint:=0;
    Invalidate;
   end;
end;

procedure TFloatEdit.SetOnlyInt(V:boolean);
begin
 if fOnlyInt<>V then
    begin
     fOnlyInt:=V;
     if V then fText:=IntToStr(Round(Data));
     Invalidate;
    end;
end;

procedure TFloatEdit.DataFormatChange(Sender:TObject);
begin
 DecimalSeparator:='.';
 fText:=FloatToStrF(Data,fDataFormat.FloatFormat,fDataFormat.Precision,fDataFormat.Digits);
 if fOnlyInt then fText:=FloatToStr(Round(Data));
 Invalidate;
end;

procedure TFloatEdit.SetCurPos(V:Longint);
begin
 if CurPos<>V then
    begin
     if V<0 then V:=0;
     if V>Length(fText) then V:=Length(fText);
     fCurPos:=V;
     DrawCursor;
    end;
end;

procedure TFloatEdit.SetDefDecSep(V:char);
begin
 if (V='.')or(V=',') then
    if V<>fDefDecSep then
       begin
        fDefDecSep:=V;
        Invalidate;
       end;
end;

procedure TFloatEdit.SetDecimalSeparator(t:string);
var
 i:integer;
begin
 if Length(t)=0 then Exit;
 i:=1;
 while (t[i]<>'.')and(t[i]<>',')and(i<Length(t)) do inc(i);
 if i<=Length(t) then
    if (t[i]='.')or(t[i]=',') then DecimalSeparator:=t[i];
end;

function TFloatEdit.CanConvert(s:string):boolean;
var
 f:double;
 i,n:integer;
begin
{$O-}
 Result:=false;
 if (s='--')or(s='++') then Exit;
 Result:=true;
 if Length(s)=0 then Exit;
 i:=1; n:=0;
 while i<=Length(s) do
  begin
   if (s[i]='E') then inc(n);
   inc(i);
  end;
 if (n>1)or(s[1]='E') then
    begin
     Result:=false;
     Exit;
    end;
 if not Result then Exit;
 try
  SetDecimalSeparator(s);
  f:=Convert(s);
 except
  Result:=false;
 end;
{$O+} 
end;

function TFloatEdit.Convert(s:string):double;
begin
 Result:=0.0;
 if Length(s)=0 then Exit;
 if Length(s)=1 then if (s[1]='-')or(s[1]='+') then Exit;
 Result:=StrToFloat(s);
end;

procedure TFloatEdit.SetData(V:double);
begin
 if fData<>V then
    begin
     if fOnlyInt then V:=Round(V);
     fData:=V;
     DecimalSeparator:=fDefDecSep;
     fText:=FloatToStrF(V,fDataFormat.FloatFormat,fDataFormat.Precision,fDataFormat.Digits);
     Invalidate;
     SetCurPos(Length(Text));
    end;
end;

function TFloatEdit.GetData:double;
begin
 Result:=fData;
end;

procedure TFloatEdit.SetText(V:string);
begin
 if fText<>V then
    if CanConvert(V) then
       begin
        if fOnlyInt then
           if Length(V)>1 then V:=IntToStr(Round(Convert(V)));
        if (Length(V)<>0) then
           fData:=Convert(V) else fData:=0.0;
        fText:=V;
        Invalidate;
       end;
end;

procedure TFloatEdit.SetSelStart(V:integer);
begin
 if (fSelStart<>V)and(V>=0)and(V<=Length(Text)) then
    begin
     fSelStart:=V;
     Invalidate;
    end;
end;

procedure TFloatEdit.SetSelLength(V:integer);
begin
 if (fSelLength<>V)and(V>=0)and(V<=Length(Text)) then
    begin
     fSelLength:=V;
     if (not MouseSel)and(GetKeyState(VK_SHIFT)>=0)and(V>0) then CurPos:=fSelStart+V;
     if V=0 then fSelStart:=0;
     Invalidate;
    end; 
end;

procedure TFloatEdit.SelectAll;
begin
 fSelStart:=0; fSelLength:=Length(Text);
 CurPos:=Length(Text);
 ShiftDownPos:=0;
 Invalidate;
end;

procedure TFloatEdit.SetAutoSelect(V:boolean);
begin
 if fAutoSelect<>V then fAutoSelect:=V;
end;

procedure TFloatEdit.CMEnter(var Message: TCMGotFocus);
begin
 inherited;
 DrawCursor;
 SetFocus;
 if not MouseEnter then
    if fAutoSelect then SelectAll;
end;

procedure TFloatEdit.CMExit(var Message: TWMNoParams);
begin
 if csDesigning in ComponentState then Exit;
 DestroyCaret;
 Self.DataFormatChange(Self);
 inherited;
end;

procedure TFloatEdit.WMSetFocus(var Message:TWMSetFocus);
begin
 inherited;
 DrawCursor;
 if not MouseEnter then
    if fAutoSelect then SelectAll;
end;

procedure TFloatEdit.WMKillFocus(var Message:TWMKillFocus);
begin
 if csDesigning in ComponentState then Exit;
 DestroyCaret;
 Invalidate;
 inherited;
end;

function TFloatEdit.KeyDataToShiftState(KeyData: Longint):TShiftState;
const
  AltMask = $20000000;
begin
  Result := [];
  if GetKeyState(VK_SHIFT)<0   then Include(Result,ssShift);
  if GetKeyState(VK_CONTROL)<0 then Include(Result,ssCtrl);
  if KeyData and AltMask <> 0 then Include(Result, ssAlt);
end;

procedure TFloatEdit.CNKeyDown(var Message: TWMKeyDown);
var
 s:string;
 Key:word;
 p:PChar;
 t:string;
 th:THandle;
 ss:TKeyboardState;
begin
 if csDesigning in ComponentState then Exit;
 Key:=Message.CharCode;
 case Key of
  48..57,69,101,187..190:
   if not fReadOnly then
      begin
       if fOnlyInt then if (Key=188)or(Key=190) then Exit;
       if fSelLength>0 then Perform(cn_KeyDown,8,0); // <- если есть выделение, надо сначала удалить выделенное
       s:=Text;
       if Key>=187 then Key:=Key-144;
       Insert(chr(Key),s,fCurPos+1);
       Text:=s;
       if CanConvert(s) then CurPos:=fCurPos+1;
       if Assigned(FOnChange) then FOnChange(Self); //Дописано SKA
      end;
  8: begin  //Back Space
      if not fReadOnly then
      begin
         if fSelLength=0 then
            begin
             CurPos:=fCurPos-1;
             Text:=Copy(fText,1,CurPos)+Copy(fText,CurPos+2,Length(fText)-1-CurPos);
            end else Perform(cn_KeyDown,vk_Delete,0);
          if Assigned(FOnChange) then FOnChange(Self); //Дописано SKA
      end;
     end;
  vk_home: begin
            if KeyDataToShiftState(Message.KeyData)=[ssShift] then
               begin
                SelStart:=0; SelLength:=ShiftDownPos;
               end;
            CurPos:=0;
           end;
  vk_End: begin
           if KeyDataToShiftState(Message.KeyData)=[ssShift] then
              begin
               SelStart:=ShiftDownPos; SelLength:=Length(fText)-ShiftDownPos;
              end;
           CurPos:=Length(fText);
          end;
  vk_Delete: if not fReadOnly then
             begin
              if fSelLength=0 then
                 Text:=Copy(fText,1,CurPos)+Copy(fText,CurPos+2,Length(fText)-1-CurPos)
                 else
                  begin
                   if KeyDataToShiftState(Message.KeyData)=[ssShift] then
                      begin
                       FillChar(ss,256,0);
                       ss[vk_Shift]:=0;        // меняем состояние
                       ss[vk_Control]:=255;    // клавиатуры:
                       SetKeyboardState(ss);   // Shift=Off, Ctrl=On
                       Perform(cn_KeyDown,vk_Insert,0);
                       ss[vk_Shift]:=255;      // а потом
                       ss[vk_Control]:=0;      // восстанавливаем
                       SetKeyboardState(ss);   // как было
                      end;
                   Text:=Copy(fText,1,fSelStart)+Copy(fText,fSelStart+fSelLength+1,Length(fText)-fSelStart-fSelLength);
                   CurPos:=fSelStart;
                   SelLength:=0;
                  end;
                  if Assigned(FOnChange) then FOnChange(Self); //Дописано SKA
                 end;
  vk_Left: begin
            CurPos:=fCurPos-1;
            if (KeyDataToShiftState(Message.KeyData)=[ssShift])or(MouseSel) then
               if CurPos>=ShiftDownPos then SelLength:=fSelLength-1
                  else
                  begin
                   SelStart:=fCurPos;
                   SelLength:=ShiftDownPos-fCurPos;
                  end;
           end;
  vk_Right:begin
            CurPos:=fCurPos+1;
            if (KeyDataToShiftState(Message.KeyData)=[ssShift])or(MouseSel) then
               begin
                if CurPos<=ShiftDownPos then
                   begin
                    SelStart:=fCurPos;
                    SelLength:=ShiftDownPos-fCurPos;
                   end else
                   begin
                    SelStart:=ShiftDownPos;
                    SelLength:=fCurPos-fSelStart;
                   end;
               end;
           end;
  ord('C'): if KeyDataToShiftState(Message.KeyData)=[ssCtrl] then
            begin
               Perform(cn_KeyDown,vk_Insert,0);
               if Assigned(FOnChange) then FOnChange(Self); //Дописано SKA\
            end;
  ord('V'): if KeyDataToShiftState(Message.KeyData)=[ssCtrl] then
               begin
                FillChar(ss,256,0);
                ss[vk_Shift]:=255;    // меняем состояние
                ss[vk_Control]:=0;    // клавиатуры:
                SetKeyboardState(ss); // Shift=On, Ctrl=Off
                Perform(cn_KeyDown,vk_Insert,0);
                ss[vk_Shift]:=0;      // а потом
                ss[vk_Control]:=255;  // восстанавливаем
                SetKeyboardState(ss); // как было
                if Assigned(FOnChange) then FOnChange(Self); //Дописано SKA\
               end;
  ord('X'): if KeyDataToShiftState(Message.KeyData)=[ssCtrl] then
               begin
                Perform(cn_KeyDown,vk_Insert,0);
                Perform(cn_KeyDown,vk_Delete,0);
                if Assigned(FOnChange) then FOnChange(Self); //Дописано SKA\
               end;
  vk_Insert: begin  // вставка/копирование из/в буфер
              if KeyDataToShiftState(Message.KeyData)=[ssCtrl] then
                if fSelLength>0 then
                   begin
                    t:=Copy(Text,fSelStart+1,fSelLength);
                    GetMem(p,Length(t)+1);
                    StrPCopy(p,t);
                    Clipboard.SetTextBuf(p);
                    FreeMem(p);
                   end;
              if KeyDataToShiftState(Message.KeyData)=[ssShift] then
                 begin
                  if fSelLength>0 then
                     begin
                      FillChar(ss,256,0);
                      ss[vk_Shift]:=0;        // меняем состояние
                      SetKeyboardState(ss);   // Shift=Off, Ctrl=On
                      Perform(cn_KeyDown,vk_Delete,0);
                      ss[vk_Shift]:=255;      // а потом
                      SetKeyboardState(ss);   // как было
                      SelLength:=0;
                     end;
                  th:=Clipboard.GetAsHandle(CF_TEXT);
                  p:=GlobalLock(th);
                  t:=StrPas(p);
                  GlobalUnlock(th);
                  Text:=Copy(Text,1,fCurPos)+t+Copy(Text,fCurPos+1,Length(Text)-fCurPos);
                  CurPos:=fCurPos+Length(t);
                  Perform(cn_KeyDown,vk_Shift,0);
                 end;
                 if Assigned(FOnChange) then FOnChange(Self); //Дописано SKA\
             end;
  vk_Shift: if fSelLength=0 then ShiftDownPos:=CurPos;
 else inherited;//Parent.Perform(Message.Msg,Message.CharCode,Message.Unused);
 end;
 if (not((KeyDataToShiftState(Message.KeyData)=[ssShift])or
    (Key=vk_Tab)or(KeyDataToShiftState(Message.KeyData)=[ssCtrl])))and(not MouseSel) then SelLength:=0;
end;

procedure TFloatEdit.WMLButtonDown(var Message:TWMLButtonDown);
var
 i:integer;
begin
 inherited;
 if Message.Msg=wm_LButtonDown then
    begin
     MouseEnter:=true;
     SetFocus;
     MouseEnter:=false;
     SelLength:=0;
    end;
 i:=1;
 while (Canvas.TextWidth(Copy(fText,1+StartIndex,i))<Message.XPos)and(i<Length(fText)) do inc(i);
 if (Message.XPos-Canvas.TextWidth(Copy(fText,1+StartIndex,i-1))-StartPoint-1)>=(Canvas.TextWidth(Copy(fText,i+StartIndex,1)) div 2) then
    CurPos:=i+StartIndex else CurPos:=i-1+StartIndex;
 if Message.Msg=wm_LButtonDown then Perform(cn_KeyDown,vk_shift,0);
end;

procedure TFloatEdit.WMRButtonDown(var Message:TWMRButtonDown);
begin
 inherited;
 Perform(cm_Enter,0,0);
end;

procedure TFloatEdit.WMMouseMove(var Message:TWMMOUSEMOVE);
begin
 inherited;
 if Cursor=crDefault then Screen.Cursor:=crIBeam;
 if Message.Keys=1 then
    begin
     WMLButtonDown(Message);
     MouseSel:=true;
     dec(fCurPos);
     Perform(cn_KeyDown,vk_right,0);
    end;
end;

procedure TFloatEdit.WMLBUTTONUP(var Message:TWMLBUTTONUP);
begin
 inherited;
 MouseSel:=false;
 Screen.Cursor:=crDefault;
end;

procedure TFloatEdit.WMMouseLeave(var Message:TWMMOUSE);
begin
 inherited;
 Screen.Cursor:=crDefault;
end;


//******************************************************************************
//
//   TDataFormat
//
//******************************************************************************
constructor TDataFormat.Create;
begin
 inherited Create;
 fFloatFormat:=ffGeneral;
 fPrecision:=8;
 fDigits:=16;
end;

procedure TDataFormat.Change;
begin
 if Assigned(OnChange) then OnChange(Self);
end;

procedure TDataFormat.SetFloatFormat(V:TFloatFormat);
begin
 if V<>ffCurrency then
 if fFloatFormat<>V then
    begin
     fFloatFormat:=V;
     Change;
    end;
end;

procedure TDataFormat.SetPD(Index:integer;V:integer);
begin
 case Index of
  0: if fPrecision<>V then begin fPrecision:=V; Change; end;
  1: if fDigits<>V then begin fDigits:=V; Change; end;
 end;
end;

//******************************************************************************
procedure Register;
begin
  RegisterComponents('Additional', [TFloatEdit]);
 // RegisterComponents('Additional', [TSybutton]);
end;

end.
