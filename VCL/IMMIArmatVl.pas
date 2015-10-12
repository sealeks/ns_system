unit IMMIArmatVl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef,
  memStructsU,
  Expr,
  SwitchKnobFormU, Switch2FormU,
  IMMIArmatVlEditorU,IMMIPropertysU;


type

  TMode = (imOn, imBlink, imOFF, imErr, imErrBlink);
  TOrient = (ioHor, ioVert);

  TIMMIArmatVl = class(TGraphicControl)
  private
    { Private declarations }
    fFPosition: TFPosition;
    fExprOn: tExpretion;
    fExprOff: tExpretion; //on picture blink invisible
    fExprErr: tExpretion;
    fExprErrBlink: tExpretion; //error picture blink invisible

    fExprOnStr, fExprOffStr, fExprErrStr, fExprErrBlinkStr: TExprStr;

    fMode, fState: TMode;
    fOrient: TOrient;

    fCaption: TCaption;

    fonParamControl, fOffParamControl: string;
    fAccess: integer;

    procedure SetMode (Value: tMode);
    procedure SetState (Value: tMode);
    procedure SetOrient (Value: tOrient);

    procedure Valve1Click;
    procedure VentClick;

  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Click; override;
  public
    { Public declarations }
    property FPosition: TFPosition read fFPosition write fFPosition;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ImmiBlinkOn (var Msg: TMessage); message WM_IMMIBLINKON;
    procedure ImmiBlinkOff (var Msg: TMessage); message WM_IMMIBLINKOFF;

    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm;
  published
    { Published declarations }

    property Caption: TCaption read fCaption write fCaption;
    property iExprOn: TExprStr read fExprOnStr write fExprOnStr;
    property iExprOff: TExprStr read fExprOffStr write fExprOffStr;
    property iExprErr: TExprStr read fExprErrStr write fExprErrStr;
    property iExprErrBlink: TExprStr read fExprErrBlinkStr write fExprErrBlinkStr;

    property iMode: TMode read fMode write SetMode;
    property iState: TMode read fState write SetState;
    property iOrient: TOrient read fOrient write SetOrient default ioHor;
    property ShowHint;

    property iOnParamControl: string read fonParamControl write fOnParamControl;
    property iOffParamControl: string read foffParamControl write fOffParamControl;
    property iaccess: integer read faccess write faccess;
  end;

implementation

constructor TIMMIArmatVl.Create(AOwner: TComponent);
begin
    inherited;

    fExprOn := tExpretion.Create;
    fExprOff := tExpretion.Create; //on picture blink invisible
    fExprErr:= tExpretion.Create;
    fExprErrBlink := tExpretion.Create; //error picture blink invisible

    fMode := imOff;

    Width := 41;
    Height := 25;
      fFPosition:=TFPosition.Create;
    fFPosition.FormTop:=-1;
    fFPosition.FormLeft:=-1;
end;

destructor TIMMIArmatVl.Destroy;
begin
    fExprOn.free;;
    fExprOff.free;
    fExprErr.Free;
    fExprErrBlink.Free;
    fFPosition.free;
    inherited;
end;

procedure TIMMIArmatVl.ImmiInit (var Msg: TMessage);
begin
  fExprOn.Expr := fExprOnStr;
  fExprOn.ImmiInit;
  fExprOff.Expr := fExprOffStr;
  fExprOff.ImmiInit;

  fExprErr.Expr := fExprErrStr;
  fExprErr.ImmiInit;
  fExprErrBlink.Expr := fExprErrBlinkStr;
  fExprErrBlink.ImmiInit;

  if ionParamControl <> '' then cursor := crHandPoint;
end;


procedure TIMMIArmatVl.ImmiUnInit (var Msg: TMessage);
begin
  fExprOn.ImmiUninit;
  fExprOff.ImmiUnInit;
  fExprErr.ImmiUnInit;
  fExprErrBlink.ImmiUnInit;
end;

procedure TIMMIArmatVl.ImmiUpdate (var Msg: TMessage);
var
   newMode: TMode;

begin
  newMode := imBlink;

  fExprErr.ImmiUpdate;

  if fExprErr.IsTrue then
  begin
    fExprErrBlink.ImmiUpdate;
    if fExprErrBlink.IsTrue then newMode := imErrBlink
    else newMode := imErr;
  end
  else begin
    fExprOn.ImmiUpdate;
    if fExprOn.IsTrue then newmode := imOn
    else begin
      fExprOff.ImmiUpdate;
      if fExprOff.IsTrue then newmode := imOff;
    end;
  end;

  iMode := newMode;
end;

procedure TIMMIArmatVl.ImmiBlinkOn (var Msg: TMessage);
begin
  if iMode = imBlink then iState := imOn;
  if iMode = imErrBlink then iState := imErr;
end;

procedure TIMMIArmatVl.ImmiBlinkOff (var Msg: TMessage);
begin
  if iMode = imBlink then iState := imOff;
  if iMode = imErrBlink then iState := imOff;
end;

procedure TIMMIArmatVl.Paint;
var
  X, Y, W, H: Integer;
begin
  with Canvas do
  begin
    X := Pen.Width div 2;
    Y := X;
    W := Width - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;

    case iState of
    imOn:
         begin
              Pen.Color := clBlack;
              Brush.Color := clLime;
         end;
    imOff:
         begin
              Pen.Color := clBlack;
              Brush.Color := clSilver;
         end;
    imErr:
         begin
              Pen.Color := clRed;
              Brush.Color := clYellow;
         end;
    end;

    Case iOrient of
       ioHor:
       begin
         Polygon([Point(x, y), Point(x+w-1, y+h-1), Point(x+w-1, y),
                      Point(x, y+h-1), Point(x, y)]);
       end;
       ioVert: Polygon([Point(x, y), Point(x+w-1, y+h-1), Point(x, y+h-1),
                      Point(x+w-1, y), Point(x, y)]);
    end;
  end;
end;

procedure TIMMIArmatVl.SetMode(Value: tMode);
begin
  iState := value;
  if fMode <> value then
  begin
    fMode := value;
  end;
end;

procedure TIMMIArmatVl.SetState(Value: tMode);
begin
  if fState <> value then
  begin
    fState := value;
    paint;
  end;
end;

procedure TIMMIArmatVl.SetOrient(Value: tOrient);
begin
  if fOrient <> value then
  begin
    fOrient := value;
    invalidate;
  end;
end;

procedure TIMMIArmatVl.VentClick;
begin
     if not assigned (SwitchKnobForm) then
        Application.CreateForm (TSwitchKnobForm, SwitchKnobForm);

     SwitchKnobForm.IMMISpeedButton1.Param.rtName := fonParamControl;
     SwitchKnobForm.IMMISpeedButton1.Param.access := faccess;
     SwitchKnobForm.Caption := caption;
       with SwitchKnobForm do
             begin
             if ((fFPosition.FormTop>-1) and (fFPosition.FormLeft>-1)) then
             begin
               top:=fFPosition.FormTop;
               left:=fFPosition.FormLeft;
             end else
             begin
                top := self.ClientToScreen(Point(0, 0)).Y+5+self.Height;
                left := self.ClientToScreen(Point(0, 0)).X+5+self.Width;
                if (self.owner is TForm) then
                  begin
                   if  ((top+height)>((self.owner as TForm).top+(self.owner as TForm).Height)) then top:=top-height-10-self.Height;
                   if  ((left+width)>((self.owner as TForm).Left+(self.owner as TForm).Width)) then left:=left-width-10-self.width;
                   if top<20 then top:=20;
                   if left<20 then left:=20;
                  end

              end;
              end;
     SwitchKnobForm.Show;
end;

procedure TIMMIArmatVl.Valve1Click;
begin
     if not assigned (Switch2Form) then
        Application.CreateForm (TSwitch2Form, Switch2Form);

     Switch2Form.Caption := caption;

     Switch2Form.IMMISpeedButton1.Param.access := faccess;
     Switch2Form.IMMISpeedButton1.Param.rtName := foffParamControl;

     Switch2Form.IMMISpeedButton2.Param.access := faccess;
     Switch2Form.IMMISpeedButton2.Param.rtName := fonParamControl;

     Switch2Form.IMMIImage1.Param.rtName := foffParamControl;
     Switch2Form.IMMIImage2.Param.rtName := fonParamControl;


             with Switch2Form do
             begin
             if ((fFPosition.FormTop>-1) and (fFPosition.FormLeft>-1)) then
             begin
               top:=fFPosition.FormTop;
               left:=fFPosition.FormLeft;
             end else
             begin
                top := self.ClientToScreen(Point(0, 0)).Y+5+self.Height;
                left := self.ClientToScreen(Point(0, 0)).X+5+self.Width;
                if (self.owner is TForm) then
                  begin
                   if  ((top+height)>((self.owner as TForm).top+(self.owner as TForm).Height)) then top:=top-height-10-self.Height;
                   if  ((left+width)>((self.owner as TForm).Left+(self.owner as TForm).Width)) then left:=left-width-10-self.width;
                   if top<20 then top:=20;
                   if left<20 then left:=20;
                  end

              end;
              end;
     Switch2Form.Show;
end;

procedure TIMMIArmatVl.Click;
begin
     inherited;
    if ionParamControl = '' then exit;
    if iOffParamControl <> '' then Valve1Click
    else VentClick;
end;

procedure TIMMIArmatVl.ShowPropForm;
begin
  with TArmatVlEditorFrm.Create(nil) do begin
    Edit1.Text := iExprOn;
    Edit2.Text := iExprOff;
    Edit3.Text := iExprErr;
    Edit4.Text := iExprErrBlink;
    Edit5.Text := iOnParamControl;
    Edit6.Text := iOffParamControl;
    Edit7.Text := self.Caption;
    Edit8.Text := self.Hint;
    SpinEdit1.Value := iAccess;
    ComboBox1.ItemIndex := Integer(iOrient);
    if ShowModal = mrOK then begin
      iExprOn := Edit1.Text;
      iExprOff := Edit2.Text;
      iExprErr := Edit3.Text;
      iExprErrBlink := Edit4.Text;
      iOnParamControl := Edit5.Text;
      iOffParamControl := Edit6.Text;
      self.Caption := Edit7.Text;
      self.Hint := Edit8.Text;
      if self.hint <> '' then self.showHint := true else self.showHint := false;
      iAccess := SpinEdit1.Value;
      iOrient := tOrient(ComboBox1.ItemIndex);
    end;
    Free;
  end;
end;

procedure TIMMIArmatVl.ShowPropFormMsg(var Msg: TMessage);
begin
  immiUninit(Msg);
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
