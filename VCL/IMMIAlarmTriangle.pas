unit IMMIAlarmTriangle;

interface

uses
  Classes, Messages, SysUtils, Graphics, Controls,
  dialogs,
  memStructsU, constDef, {GlobalVar,} IMMIAlTrgEditorU;

type

  TAlarmTriangleType = (atAlarm, atError);
  TAlarmTriangleMode = (amOn, amOFF, amBlink);
  TAlarmTriangleOrient = (aoUp, aoDown);

  TIMMIAlarmTriangle = class(TGraphicControl)
  private
    fAlarmIdent: TExprStr;
    fAlarmIdentID: integer;

    fAOrient: TAlarmTriangleOrient;
    faType: TAlarmTriangleType;
    fAMode: TAlarmTriangleMode;
    faState: TAlarmTriangleMode;

    procedure SetAOrient (Value: tAlarmTriangleOrient);
    procedure SetAType (Value: tAlarmTriangleType);
    procedure SetAMode (Value: tAlarmTriangleMode);
    procedure SetAState (Value: tAlarmTriangleMode);

  protected
    procedure Paint; override;
  public

    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ImmiBlinkOn (var Msg: TMessage); message WM_IMMIBLINKON;
    procedure ImmiBlinkOff (var Msg: TMessage); message WM_IMMIBLINKOFF;


    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm;
    constructor Create(AOwner: TComponent); override;

  published
    property AlarmIdent: TExprStr read fAlarmIdent write fAlarmIdent;

    property AType: TAlarmTriangleType read fAType write SetAType;
    property AMode: TAlarmTriangleMode read fAMode write SetAMode default amOn;
    property AState: TAlarmTriangleMode read fAState write SetAState default amOn;
    property AOrient: tAlarmTriangleOrient read fAOrient write SetAOrient;

    property ShowHint;
    property ParentShowHint;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

implementation

{ TIMMIAlarmTriangle }
constructor TIMMIAlarmTriangle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csReplicatable];
  Width := 15;
  Height := 15;
  fAlarmIdentID := -1;
  visible:=false;
end;

procedure TIMMIAlarmTriangle.SetAType(Value: tAlarmTriangleType);
begin
  if faType <> value then
  begin
     fAType := value;
     invalidate;
  end;
end;

procedure TIMMIAlarmTriangle.SetAMode(Value: tAlarmTriangleMode);
begin
  if faMode <> value then
  begin
     fAMode := value;
     if value <> amBlink then aState := value;
     invalidate;
  end;
end;

procedure TIMMIAlarmTriangle.SetaState(Value: tAlarmTriangleMode);
begin
  if faState <> value then
  begin
     fAState := value;
     if fAState = amOff then visible := false else visible := true;
     paint;
  end;
end;

procedure TIMMIAlarmTriangle.SetAOrient (Value: tAlarmTriangleOrient);
begin
     if fAOrient <> value then begin
        fAOrient := value;
        invalidate;
     end;
end;

procedure TIMMIAlarmTriangle.Paint;
var
  W, H: Integer;
  hW: integer;
begin
  with Canvas do
  begin
    Pen.Color := clRed;
    Pen.Width := 1;

    if AType = atAlarm then brush.color := clYellow
    else brush.color := clRed;

    W := Width-1;
    H := Height-1;
    hW := trunc(w / 2);


    Case AOrient of
      aoUp: Polygon([Point(1, h), Point(w, h),
                     Point(hw, 1), Point(1, h)]);
      aoDown: Polygon([Point(1, 1), Point(w, 1),
                     Point(hw, h), Point(1, 1)]);
    end;
  end;
end;

procedure TIMMIAlarmTriangle.ImmiInit (var Msg: TMessage);
begin
    fAlarmIdentID:=-1;
     if fAlarmIdent='' then exit;
    if fAlarmIdentID = -1 then
      fAlarmIdentID := rtItems.GetSimpleID(Alarmident);

   // if fAlarmIdentID = -1 then
      //fAlarmIdentID := alarms.GetID(Alarmident);

    if  fAlarmIdentID = -1 then
    begin
  //    raise Exception.Create('Идентификатор не определен: ' + Alarmident) ;
      exit;
    end else  aMode := amOff;

end;

procedure TIMMIAlarmTriangle.ImmiBlinkOn (var Msg: TMessage);
begin
  if aMode = amBlink then aState := amOn;
end;

procedure TIMMIAlarmTriangle.ImmiBlinkOff (var Msg: TMessage);
begin
  if aMode = amBlink then aState := amOff;
end;

procedure TIMMIAlarmTriangle.ImmiUpdate;
begin

   if fAlarmIdent='' then exit;

   if fAlarmIdentID = -1 then exit;

  {if fAlarmIdentID < alarmShift then
  begin}

   if rtItems[fAlarmIdentID].isAlarmOn and rtItems.isValid(fAlarmIdentID) then
   begin
     if rtItems[fAlarmIdentID].isAlarmKvit then aMode := amOn
     else aMode := amBlink
   end
   else aMode := amOff;

 //  aMode := amOff;
  // exit;
 // end; else
 { begin
   if alarms[fAlarmIdentID].isOn then
     if alarms[fAlarmIdentID].isKvit then aMode := amOn
     else aMode := amBlink
   else aMode := amOff;
  end;   }
  // if
end;


procedure TIMMIAlarmTriangle.ShowPropForm;
begin
  with TAlTrgFrm.Create(nil) do begin
    Edit1.Text := AlarmIdent;
    RadioGroup1.ItemIndex := Integer(aOrient);
    RadioGroup2.ItemIndex := Integer(aType);
    if ShowModal = mrOK then begin
      AlarmIdent := Edit1.Text;
      aOrient := TAlarmTriangleOrient(RadioGroup1.ItemIndex);
      aType := TAlarmTriangleType(RadioGroup2.ItemIndex);
    end;
    Free;
  end;
end;
procedure TIMMIAlarmTriangle.ShowPropFormMsg(var Msg: TMessage);
begin
  showPropForm;
  try
    IMMIInit(Msg);
  except
    on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], E.HelpContext);
        perform(WM_IMMSHOWPROPFORM, 0, 0);
      end;
  end;
end;

end.
