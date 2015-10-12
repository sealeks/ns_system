unit IMMIArmatBm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef,
  memStructsU,
  Expr,
  SwitchKnobFormU, Switch2FormU,
  IMMIArmatBMEditorU, IMMIPropertysU, LoginError, IMMIBorder;


type

  TMode = (imOn, imBlink, imOFF, imErr, imErrBlink);

  TIMMIArmatBm = class(TImage)
  private
    { Private declarations }
    fCaptionF: string;
    fExprOn: tExpretion;
    fExprOff: tExpretion; //on picture blink invisible
    fExprErr: tExpretion;
    fExprErrBlink: tExpretion; //error picture blink invisible
    fFPosition: TFPosition;
    fExprOnStr, fExprOffStr, fExprErrStr, fExprErrBlinkStr: TExprStr;
    fPictureOn, fPictureOff, fPictureErr: tPicture;
    fborderComp: TImmiBorder;
    fMode, fState: TMode;

    fonParamControl, fOffParamControl,fAut_DistParamControl,fLocalParamControl: TExprStr;
    fAccess: integer;
    fOpenStop: boolean;
    fCaption: TCaption;
    fExprEnable: tExpretion;
    fExprEnableString: TExprStr;
     fBorder: TBorder;
    procedure SetPictureOn (source: tPicture);
    procedure SetPictureOff (source: tPicture);
    procedure SetPictureErr (source: tPicture);

    procedure SetMode (Value: tMode);
    procedure SetState (Value: tMode);

    procedure Valve1Click;
    procedure VentClick;

  protected
    { Protected declarations }
    procedure Click; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
     procedure Loaded; override;
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
    property FPosition: TFPosition read fFPosition write fFPosition;
    property iExprOn: TExprStr read fExprOnStr write fExprOnStr;
    property iExprOff: TExprStr read fExprOffStr write fExprOffStr;
    property iExprErr: TExprStr read fExprErrStr write fExprErrStr;
    property iExprErrBlink: TExprStr read fExprErrBlinkStr write fExprErrBlinkStr;

    property iPictureOff: tPicture read fPictureOff write SetPictureOff;
    property iPictureOn: tPicture read fPictureOn write SetPictureOn;
    property iPictureErr: tPicture read fPictureErr write SetPictureErr;

    property iMode: TMode read fMode write SetMode;
    property iState: TMode read fState write SetState;

    property iOnParamControl: TExprStr read fonParamControl write fOnParamControl;
    property iOffParamControl: TExprStr read foffParamControl write fOffParamControl;
    property iAut_DistParamControl: TExprStr read fAut_DistParamControl write fAut_DistParamControl;
    property iLocalParamControl: TExprStr read fLocalParamControl write fLocalParamControl;
    property OpenStop: boolean  read fOpenStop write fOpenStop;
    property CaptionF: string read fCaptionF write fCaptionF;
    property iaccess: integer read faccess write faccess;
     property ExprEnable: TExprStr read fExprEnableString write fExprEnableString;
    property Border: TBorder read fBorder write fBorder;
  end;

implementation

constructor TIMMIArmatBm.Create(AOwner: TComponent);
begin
    inherited;

    fExprOn := tExpretion.Create;
    fExprOff := tExpretion.Create; //on picture blink invisible
    fExprErr:= tExpretion.Create;
    fExprErrBlink := tExpretion.Create; //error picture blink invisible

    fPictureOn := tPicture.Create;
    fPictureOff := tPicture.Create;
    fPictureErr := tPicture.Create;
    fBorder:=TBorder.create;
    iMode := imOn;

    Width := 41;
    Height := 25;
     fFPosition:=TFPosition.Create;
    fFPosition.FormTop:=-1;
    fFPosition.FormLeft:=-1;
//    autoSize := true;
end;

destructor TIMMIArmatBm.Destroy;
begin
   fBorder.free;
    fExprOn.free;;
    fExprOff.free;
    fExprErr.Free;
    fExprErrBlink.Free;
    fFPosition.Free;
    fPictureOn.Free;
    fPictureOff.Free;
    fPictureErr.Free;

    inherited;
end;

procedure TIMMIArmatBm.ImmiInit (var Msg: TMessage);
begin
  fExprOn.Expr := fExprOnStr;
  fExprOn.ImmiInit;
  fExprOff.Expr := fExprOffStr;
  fExprOff.ImmiInit;

  fExprErr.Expr := fExprErrStr;
  fExprErr.ImmiInit;
  fExprErrBlink.Expr := fExprErrBlinkStr;
  fExprErrBlink.ImmiInit;
  CreateAndInitExpretion(fExprEnable, fExprEnableString);
  if ionParamControl <> '' then cursor := crHandPoint;
end;


procedure TIMMIArmatBm.ImmiUnInit (var Msg: TMessage);
begin
  fExprOn.ImmiUninit;
  fExprOff.ImmiUnInit;
  fExprErr.ImmiUnInit;
  fExprErrBlink.ImmiUnInit;
  if assigned(fExprEnable) then fExprEnable.ImmiUnInit;
end;

procedure TIMMIArmatBm.ImmiUpdate (var Msg: TMessage);
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
  if assigned(fExprEnable) then
  begin
    fExprEnable.ImmiUpdate;
    if ((fExprEnable.IsTrue) and not Enabled) then Enabled:=true;
     if (not (fExprEnable.IsTrue) and Enabled) then Enabled:=false;

  end;
end;

procedure TIMMIArmatBm.ImmiBlinkOn (var Msg: TMessage);
begin
  if iMode = imBlink then iState := imOn;
  if iMode = imErrBlink then iState := imErr;
end;

procedure TIMMIArmatBm.ImmiBlinkOff (var Msg: TMessage);
begin

  if iMode = imBlink then iState := imOff;
  if iMode = imErrBlink then iState := imOff;
end;

procedure TIMMIArmatBm.SetPictureOn (source: tPicture);
begin
     fPictureOn.Assign(source);
     Picture := fPictureOn;
//     Picture.Assign(source);
end;

procedure TIMMIArmatBm.SetPictureOff (source: tPicture);
begin
     fPictureOff.Assign(source);
end;

procedure TIMMIArmatBm.SetPictureErr (source: tPicture);
begin
     fPictureErr.Assign(source);
end;

procedure TIMMIArmatBm.SetMode(Value: tMode);
begin
  iState := value;
  if fMode <> value then
  begin
    fMode := value;
  end;
end;

procedure TIMMIArmatBm.SetState(Value: tMode);
begin
if (fpictureon.bitmap.empty) and
      (fpictureoff.bitmap.empty) and
          (fPictureErr.bitmap.empty)
        then exit;
  if fState <> value then
  begin
    fState := value;
    case fState of
      imOn: picture := fPictureOn;
      imOff: picture := fPictureOff;
      imErr:picture := fPictureErr;
    end;
    paint;
  end;
end;

procedure TIMMIArmatBm.ShowPropForm;
begin
  with TArmatBmEditorFrm.Create(nil) do begin
    Edit1.Text := iExprOn;
    Edit2.Text := iExprOff;
    Edit3.Text := iExprErr;
    Edit4.Text := iExprErrBlink;
    Edit5.Text := iOnParamControl;
    Edit6.Text := iOffParamControl;
    Edit7.Text := self.Caption;
    Edit8.Text := self.Hint;
    editexpr1.Text:=self.ExprEnable;
    SpinEdit1.Value := iAccess;
    Image1.Picture.Assign(iPictureOn);
    Image2.Picture.Assign(iPictureOff);
    Image3.Picture.Assign(iPictureErr);
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
      iPictureOn := Image1.Picture;
      iPictureOff := Image2.Picture;
      iPictureErr := Image3.Picture;
      self.ExprEnable:=editexpr1.Text;
    end;
    Free;
  end;
end;

procedure TIMMIArmatBm.VentClick;
begin
      if not Enabled then exit;
      if AccessLevel^<faccess then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;

     if not assigned (SwitchKnobForm) then
        Application.CreateForm (TSwitchKnobForm, SwitchKnobForm);

       SwitchKnobForm.IMMISpeedButton4.Param.ExprEnabled:='';
       SwitchKnobForm.IMMISpeedButton3.Param.ExprEnabled:='';
       SwitchKnobForm.IMMISpeedButton2.Param.ExprEnabled:='';
       SwitchKnobForm.IMMISpeedButton1.Param.ExprEnabled:='';

       SwitchKnobForm.IMMISpeedButton1.Param.rtName := fonParamControl;
       SwitchKnobForm.IMMISpeedButton1.Param.access := faccess;
       SwitchKnobForm.IMMISpeedButton2.Param.rtName := fonParamControl;
       SwitchKnobForm.IMMISpeedButton2.Param.access := faccess;
       SwitchKnobForm.IMMISpeedButton3.Param.rtName := foffParamControl;
       SwitchKnobForm.IMMISpeedButton3.Param.access := faccess;
       SwitchKnobForm.IMMISpeedButton4.Param.rtName := foffParamControl;
       SwitchKnobForm.IMMISpeedButton4.Param.access := faccess;
       SwitchKnobForm.ImmiSyButton1.Param.Access:=faccess;
       SwitchKnobForm.ImmiSyButton2.Param.Access:=faccess;
       SwitchKnobForm.ImmiSyButton3.Param.Access:=faccess;
       SwitchKnobForm.ImmiSyButton4.Param.Access:=faccess;
       SwitchKnobForm.ImmiSyButton5.Param.Access:=faccess;
       if (fLocalParamControl='') then
            begin
       SwitchKnobForm.IMMISpeedButton4.Param.ExprEnabled:=fAut_DistParamControl;
       SwitchKnobForm.IMMISpeedButton3.Param.ExprEnabled:=fAut_DistParamControl;
       SwitchKnobForm.IMMISpeedButton2.Param.ExprEnabled:=fAut_DistParamControl;
       SwitchKnobForm.IMMISpeedButton1.Param.ExprEnabled:=fAut_DistParamControl;
           end else begin
       SwitchKnobForm.IMMISpeedButton4.Param.ExprEnabled:=fAut_DistParamControl+' & !'+fLocalParamControl;
       SwitchKnobForm.IMMISpeedButton3.Param.ExprEnabled:=fAut_DistParamControl+' & !'+fLocalParamControl;
       SwitchKnobForm.IMMISpeedButton2.Param.ExprEnabled:=fAut_DistParamControl+' & !'+fLocalParamControl;
       SwitchKnobForm.IMMISpeedButton1.Param.ExprEnabled:=fAut_DistParamControl+' & !'+fLocalParamControl;
           end;
       SwitchKnobForm.IMMISpeedButton1.Visible:=false;
       SwitchKnobForm.IMMISpeedButton2.Visible:=false;
       SwitchKnobForm.IMMISpeedButton3.Visible:=false;
       SwitchKnobForm.IMMISpeedButton4.Visible:=false;
      IF  fonParamControl<>'' then
     begin
     if  fOpenStop then SwitchKnobForm.IMMISpeedButton1.Visible:=true else
          SwitchKnobForm.IMMISpeedButton2.Visible:=true;
     end
     else
     begin


       if fOpenStop then SwitchKnobForm.IMMISpeedButton3.Visible:=true else
      SwitchKnobForm.IMMISpeedButton4.Visible:=true;

     end;
     SwitchKnobForm.Caption := fCaptionF;
      SwitchKnobForm.Label2.Caption:=caption;
    {  if  fOpenStop then
      begin
        SwitchKnobForm.IMMISpeedButton1.Visible:=true;
        SwitchKnobForm.IMMISpeedButton2.Visible:=false;
      end
       else
       begin
        SwitchKnobForm.IMMISpeedButton1.Visible:=false;
        SwitchKnobForm.IMMISpeedButton2.Visible:=true;
      end ; }
       SwitchKnobForm.IMMISpeedButton4.Param.ExprEnabled:='';
       SwitchKnobForm.IMMISpeedButton3.Param.ExprEnabled:='';
       SwitchKnobForm.IMMISpeedButton2.Param.ExprEnabled:='';
       SwitchKnobForm.IMMISpeedButton1.Param.ExprEnabled:='';

      IF  fonParamControl<>'' then SwitchKnobForm.ImmiImg12.IMMIProp.ExprVal:=fonParamControl else  SwitchKnobForm.ImmiImg12.IMMIProp.ExprVal:='! '+foffParamControl;
     if fAut_DistParamControl='' then
       begin
         SwitchKnobForm.Height:=205;
         SwitchKnobForm.IMMIImg11.Visible:=false;
         SwitchKnobForm.IMMISpeedButton4.Param.ExprEnabled:='1';
         SwitchKnobForm.IMMISpeedButton3.Param.ExprEnabled:='1';
         SwitchKnobForm.IMMISpeedButton2.Param.ExprEnabled:='1';
         SwitchKnobForm.IMMISpeedButton1.Param.ExprEnabled:='1';
       end
     else
        begin
          SwitchKnobForm.Height:=285;
         SwitchKnobForm.IMMIImg11.IMMIProp.ExprVal:=fAut_DistParamControl;
         SwitchKnobForm.IMMIImg11.IMMIProp.Param.rtName:=fAut_DistParamControl;
          if (fLocalParamControl='') then
            begin
             SwitchKnobForm.IMMIPanel2.Visible:=false;
              SwitchKnobForm.IMMIPanel1.BringToFront;
              SwitchKnobForm.IMMIPanel1.Visible:=true;
              SwitchKnobForm.IMMIImg13.IMMIProp.ExprVal:='! ' + fAut_DistParamControl;
              SwitchKnobForm.IMMIImg16.IMMIProp.ExprVal:=fAut_DistParamControl;
              SwitchKnobForm.ImmiSyButton5.Param.rtName:=fAut_DistParamControl;
              SwitchKnobForm.IMMISpeedButton4.Param.ExprEnabled:=fAut_DistParamControl;
              SwitchKnobForm.IMMISpeedButton3.Param.ExprEnabled:=fAut_DistParamControl;
              SwitchKnobForm.IMMISpeedButton2.Param.ExprEnabled:=fAut_DistParamControl;
              SwitchKnobForm.IMMISpeedButton1.Param.ExprEnabled:=fAut_DistParamControl;
            end else
            begin
              SwitchKnobForm.IMMIPanel1.Visible:=false;
              SwitchKnobForm.IMMIPanel2.BringToFront;
              SwitchKnobForm.IMMIPanel2.Visible:=true;
              SwitchKnobForm.IMMIImg11.IMMIProp.ExprVal:='! '+fAut_DistParamControl+'& !' + fLocalParamControl;
              SwitchKnobForm.IMMIImg14.IMMIProp.ExprVal:=fAut_DistParamControl+'& !' + fLocalParamControl;
              SwitchKnobForm.IMMIImg15.IMMIProp.ExprVal:=fLocalParamControl;
              SwitchKnobForm.ImmiSyButton2.Param.rtName:=fAut_DistParamControl;
              SwitchKnobForm.ImmiSyButton3.Param.rtName:=fLocalParamControl;
                     SwitchKnobForm.IMMISpeedButton4.Param.ExprEnabled:=fAut_DistParamControl+' & !'+fLocalParamControl;
       SwitchKnobForm.IMMISpeedButton3.Param.ExprEnabled:=fAut_DistParamControl+' & !'+fLocalParamControl;
       SwitchKnobForm.IMMISpeedButton2.Param.ExprEnabled:=fAut_DistParamControl+' & !'+fLocalParamControl;
       SwitchKnobForm.IMMISpeedButton1.Param.ExprEnabled:=fAut_DistParamControl+' & !'+fLocalParamControl;

            end;
        end;
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

procedure TIMMIArmatBm.Valve1Click;
begin
     if not Enabled then exit;
     if AccessLevel^<faccess then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;

     if not assigned (Switch2Form) then
        Application.CreateForm (TSwitch2Form, Switch2Form);

     Switch2Form.Caption :=fCaptionF;
     Switch2Form.Label2.Caption:=caption;
     Switch2Form.IMMISpeedButton1.Param.access := faccess;
     Switch2Form.IMMISpeedButton1.Param.rtName := foffParamControl;
    // Switch2Form.IMMISpeedButton1.Param.rtNamePlus :='!'+ fonParamControl;
      if (fLocalParamControl='') then Switch2Form.IMMIPanel3.ExprEnable:= fAut_DistParamControl else
          Switch2Form.IMMIPanel3.ExprEnable:= fAut_DistParamControl +' & !'+fLocalParamControl;
     Switch2Form.IMMISpeedButton2.Param.access := faccess;
     Switch2Form.IMMISpeedButton2.Param.rtName := fonParamControl;
   //  Switch2Form.IMMISpeedButton2.Param.rtNamePlus :='!'+ foffParamControl;
    // Switch2Form.Button1.Param.rtNamePlus:= '!'+fonParamControl+' | !'+foffParamControl;

     Switch2Form.IMMIImage1.Param.rtName := foffParamControl;
     Switch2Form.IMMIImage2.Param.rtName := fonParamControl;
     Switch2Form.ImmiSyButton1.Param.Access:=faccess;
     Switch2Form.ImmiSyButton2.Param.Access:=faccess;
     Switch2Form.ImmiSyButton3.Param.Access:=faccess;
     Switch2Form.ImmiSyButton4.Param.Access:=faccess;
     Switch2Form.ImmiSyButton5.Param.Access:=faccess;
     Switch2Form.Button1.Param.Access:=faccess;
     if fAut_DistParamControl='' then
       begin
         Switch2Form.Height:=205;
         Switch2Form.IMMIImg11.Visible:=false;

       end
     else
        begin
          Switch2Form.Height:=290;
         {Switch2Form.IMMIImg11.IMMIProp.ExprVal:=fAut_DistParamControl;
         Switch2Form.IMMIImg11.IMMIProp.Param.rtName:=fAut_DistParamControl;}
         if (fLocalParamControl='') then
            begin
              Switch2Form.IMMIPanel2.Visible:=false;
              Switch2Form.IMMIPanel1.BringToFront;
              Switch2Form.IMMIPanel1.Visible:=true;
              Switch2Form.IMMIImg12.IMMIProp.ExprVal:='! ' + fAut_DistParamControl;
              Switch2Form.IMMIImg13.IMMIProp.ExprVal:=fAut_DistParamControl;
              Switch2Form.ImmiSyButton5.Param.rtName:=fAut_DistParamControl;
            end else
            begin
              Switch2Form.IMMIPanel1.Visible:=false;
              Switch2Form.IMMIPanel2.BringToFront;
              Switch2Form.IMMIPanel2.Visible:=true;
              Switch2Form.IMMIImg11.IMMIProp.ExprVal:='! '+fAut_DistParamControl+'& !' + fLocalParamControl;
              Switch2Form.IMMIImg14.IMMIProp.ExprVal:=fAut_DistParamControl+'& !' + fLocalParamControl;
              Switch2Form.IMMIImg15.IMMIProp.ExprVal:=fLocalParamControl;
              Switch2Form.ImmiSyButton2.Param.rtName:=fAut_DistParamControl;
              Switch2Form.ImmiSyButton3.Param.rtName:=fLocalParamControl;

              Switch2Form.IMMIImg11.IMMIProp.Param.rtName:=fAut_DistParamControl;
              Switch2Form.IMMIImg14.IMMIProp.Param.rtName:=fAut_DistParamControl;
              Switch2Form.IMMIImg15.IMMIProp.ExprVal:=fLocalParamControl;
              Switch2Form.IMMIImg15.IMMIProp.Param.rtName:=fLocalParamControl;
            end;
        end;

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

procedure TIMMIArmatBm.Click;
begin
     inherited;
    if ((ionParamControl = '') AND (iOffParamControl = '')) then exit;
    if ((iOffParamControl <> '') AND (iONParamControl <> '')) then Valve1Click
    else VentClick;
end;

procedure TIMMIArmatBm.ShowPropFormMsg(var Msg: TMessage);
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

procedure TIMMIArmatBm.Loaded;
begin
inherited;
if (fBorder.PenWidth>0) and not (csDesigning in ComponentState)and ((fOnParamControl<>'') OR (fOffParamControl<>'')) then
  begin
    fborderComp:=TImmiBorder.create(application);
    fborderComp.parent:=self.parent;
    fbordercomp.EnterColor:= fborder.EnterColor;
   // fbordercomp.ExprBlk:= fborder.ExprBlk;
   // fbordercomp.ExprOn:= fborder.ExprOn;
    fbordercomp.OutColor:= fborder.OutColor;
   // fbordercomp.OnColor:= fborder.OnColor;
   // fbordercomp.OffColor:= fborder.OffColor;
    fbordercomp.BlkColor:= fborder.BlkColor;
    fbordercomp.BorderType:= fborder.BorderType;
    fbordercomp.PenWidth:= fborder.PenWidth;
    fbordercomp.mousecontrol:=self;
  end;

end;


end.
