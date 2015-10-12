unit IMMIImg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef,
  memStructsU,
  Expr,
  IMMIImgEditorU,
  ParamU,
  IMMIValueEntryFrmU;


type
  TParamAction = (paClick, paSwitch, PAGetValue);

  TIMMIImg = class(TImage)
  private
    { Private declarations }
    fExprValue: tExpretion;
    fExprValueString: string;
    isExprTrue: boolean;

    fExprVisible: tExpretion;
    fExprVisibleString: string;

    fParam: TParamControl;
    fPA: TParamAction;

    fOnPicture, fOffPicture: tPicture;

    procedure SetOnPicture (source: tPicture);
    procedure SetOffPicture (source: tPicture);

    procedure OnMouseDownProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUpProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure SetDesigning(Value: Boolean; SetChildren: Boolean=True);
    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm;
  published
    { Published declarations }
    property iExprVal: string read fExprValueString write fExprValueString;
    property iExprVisible: string read fExprVisibleString write fExprVisibleString;
    property iParam: TParamControl read fparam write fParam;
    property iPA: TParamAction read fPA write fPA;

    property OnPicture: tPicture read fOnPicture write SetOnPicture;
    property OffPicture: tPicture read fOffPicture write SetOffPicture;
  end;

implementation

constructor TIMMIImg.Create(AOwner: TComponent);
begin
     inherited;
     fOnPicture := tPicture.Create;
     fOffPicture := tPicture.Create;
     transparent := true;
     isExprTrue := true;
     fparam := TParamControl.Create;

     OnMouseDown := OnMouseDownProc;
     OnMouseUp := OnMouseUpProc;
end;

procedure TIMMIImg.ImmiInit (var Msg: TMessage);
begin
    if (fExprValueString <> '') and (not Assigned (fExprValue)) then
      fExprValue := tExpretion.Create;

  if assigned(fExprValue) then
  begin
    fExprValue.Expr := fExprValueString;
    fExprValue.ImmiInit;
  end;

    if (fExprVisibleString <> '') and (not Assigned (fExprVisible)) then
      fExprVisible := tExpretion.Create;

  if assigned(fExprVisible) then
  begin
    fExprVisible.Expr := fExprVisibleString;
    fExprVisible.ImmiInit;
  end;

  fParam.Init(Name);
  if fParam.isIDValid then cursor := crHandPoint else cursor := crDefault;


    if isExprTrue then picture.assign (fOnPicture)
    else picture.assign (fOffPicture);



end;

procedure TIMMIImg.ImmiUnInit (var Msg: TMessage);
begin
  if assigned(fExprValue) then fExprValue.ImmiUnInit;
  if assigned(fExprVisible) then fExprVisible.ImmiUnInit;
end;

procedure TIMMIImg.ImmiUpdate (var Msg: TMessage);
begin
  if assigned(fExprValue) then
  begin
    fExprValue.ImmiUpdate;
    if fExprValue.IsTrue <> isExprTrue then
    begin
      isExprTrue := fExprValue.IsTrue;
      if isExprTrue then picture.assign (fOnPicture)
      else picture.assign (fOffPicture);
    end;
  end;

  if assigned(fExprVisible) then
  begin
    fExprVisible.ImmiUpdate;
    if fExprVisible.IsTrue <> visible then
      visible := fExprVisible.IsTrue;
  end;
end;

procedure TIMMIImg.SetOnPicture (source: tPicture);
begin
     fOnPicture.Assign(source);
     picture.Assign(source);
end;

procedure TIMMIImg.SetOffPicture (source: tPicture);
begin
     fOffPicture.Assign(source);
end;

procedure TIMMIImg.ShowPropForm;
begin
  with TIMMIImgForm.Create(nil) do begin
    Edit1.Text := iExprVal;
    Edit3.Text := iExprVisible;
    Image1.Picture.Assign(fOnPicture);
    Image2.Picture.Assign(fOffPicture);
    Edit2.Text := iParam.rtName;
    SpinEdit1.Value := iParam.access;
    comboBox1.ItemIndex := integer (fPA);
    if ShowModal = mrOK then begin
      iExprVisible := Edit3.Text;
      fOnPicture.Assign(Image1.Picture);
      fOffPicture.Assign(Image2.Picture);
      picture.Assign(Image1.Picture);
      iParam.rtName := Edit2.Text;
      iParam.access := SpinEdit1.Value;
      fPA := TParamAction(comboBox1.ItemIndex);
    end;
    Free;
  end;
end;

procedure TIMMIImg.SetDesigning(Value, SetChildren: Boolean);
begin
  inherited;
end;

procedure TIMMIImg.OnMouseDownProc(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Msg: TMessage;
begin
  case fPA of
    PAClick: iparam.TurnOn;
    PASwitch: if iParam.isOn then iparam.TurnOff else iparam.TurnOn;
    PAGetValue:
      with TImmiValueEntryFrm.Create(self) do
      try
        Value := iParam.Value;
        minValue := iparam.MinEU;
        maxValue := iparam.MaxEU;
        if ShowModalAt(self) = integer(mrOK) then
          iParam.Value := Value;
      finally
          free;
      end;
    end; //case
    ImmiUpdate (Msg);
end;

procedure TIMMIImg.OnMouseUpProc(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Msg: TMessage;
begin
  case fPA of
    PAClick: iparam.TurnOff;
    PASwitch,
    PAGetValue:
  end;
  ImmiUpdate (Msg);
end;

procedure TIMMIImg.ShowPropFormMsg(var Msg: TMessage);
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
