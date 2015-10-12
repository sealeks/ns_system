unit IMMIPropertysU;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef,
  memStructsU,
  Expr,
  ParamU,  FormManager,
  IMMIValueEntryFrmU,RxGif,
  IMMIPropertysEditorU;

type TFPosition = class(tpersistent)
  private
   fFormTop: integer;
   fFormLeft: integer;
  published
   property FormTop: integer read fFormTop write fFormTop;
   property FormLeft: integer read fFormLeft write fFormLeft;
end;



type

TParamAction = (paClick, paSwitch, PAGetValue);
TPropState = (psInvisible, psBlinkInvisible, psBlinkOn, psBlinkOff,psOn, psOff);
THackControl = class(TControl);

TIMMIPropertys = class (tPersistent)
private
    fOwner: TControl;

    fExprValue: tExpretion;
    fExprValueString: TExprStr;

    fOnPen, fOffPen: TPen;//IMMIShape

    fOnColor, fOffColor: TColor; //IMMIShape, IMMILabel

    FOnFont, fOffFont: TFont;//IMMILabel
    fTextFormat: string;


    fExprVisible: tExpretion;
    fExprVisibleString: TExprStr;

    fParam: TParamControl;
    fPA: TParamAction;

    fExprBlink: tExpretion;
    fExprBlinkString: TExprStr;
    fBlinkInvisible: boolean; //if true blink invisible else blink on-off
    fPrFormManager: TFormManager;
  public
    isOn, isVisible, isBlink, isBlinkOn, isControl: boolean;
    state: TPropState;
    constructor Create(AOwner: TControl);
    destructor Destroy; override;
    procedure ImmiInit;
    procedure ImmiUnInit;
    procedure ImmiUpdate;
    procedure ImmiBlinkOn;
    procedure ImmiBlinkOff;
    function  ShowPropForm(desi: TComponent): boolean; virtual;
    procedure SetInvisiblePages; virtual;
    procedure OnMouseDownProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUpProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
  published
    { Published declarations }
    property ExprVal: TExprStr read fExprValueString write fExprValueString;
    property ExprVisible: TExprStr read fExprVisibleString write fExprVisibleString;
    property ExprBlink: TExprStr read fExprBlinkString write fExprBlinkString;
    property Param: TParamControl read fparam write fParam;
    property PA: TParamAction read fPA write fPA;
    property BlinkInvisible: boolean read fBlinkInvisible write fBlinkInvisible;
    property PrFormManager: TFormManager  read fPrFormManager write fPrFormManager;
end;

TIMMIImgPropertys = class(TIMMIPropertys)
private
  fOnPicture, fOffPicture: tPicture; //TImg
  fStretch: boolean;
  procedure setOnPicture(value: TPicture);
  procedure setOffPicture(value: TPicture);
public
  constructor Create(AOwner: TControl);
  destructor Destroy; override;
  function ShowPropForm(desi: TComponent): boolean; Override;
  procedure SetInvisiblePages; override;

published
  property OnPicture: tPicture read fOnPicture write setOnpicture;
  property OffPicture: tPicture read fOffPicture write setOffPicture;
  property Stretch: boolean read fStretch write fStretch;
end;


TIMMIImgGifPropertys = class(TIMMIPropertys)
private
  fOnImage, fOffImage: TGIFImage; //TImg
  fStretch: boolean;
  procedure setOnImage(value: TGIFImage);
  procedure setOffImage(value: TGIFImage);
public
  constructor Create(AOwner: TControl);
  destructor Destroy; override;
  function ShowPropForm(desi: TComponent): boolean; Override;
  procedure SetInvisiblePages; override;

published
  property OnImage: TGIFImage read fOnImage write setOnImage;
  property OffImage: TGIFImage read fOffImage write setOffImage;
  property Stretch: boolean read fStretch write fStretch;
end;



implementation

{ TIMMIPropertys }

constructor TIMMIPropertys.Create(AOwner: TControl);
begin
  inherited Create;
  fparam := TParamControl.Create;
  fOwner := AOwner;
  fParam := TParamControl.Create;
  isVisible := true;
  isOn := true;
  fPrFormManager:=TFormManager.create(aowner);
end;

destructor TIMMIPropertys.Destroy;
begin
    fPrFormManager.free;
    fExprValue.free;
    fOnPen.free;
    fOffPen.free;
    FOnFont.free;
    fOffFont.free;
    fExprVisible.free;
    fParam.free;
    fExprBlink.free;
  inherited;
end;

procedure TIMMIPropertys.ImmiBlinkOff;
begin
  if isBlink then isBlinkOn := false;
end;

procedure TIMMIPropertys.ImmiBlinkOn;
begin
  if isBlink then isBlinkOn := true;
end;

procedure TIMMIPropertys.ImmiInit;
begin
  CreateAndInitExpretion(fExprValue, fExprValueString);
  CreateAndInitExpretion(fExprVisible, fExprVisibleString);
  CreateAndInitExpretion(fExprBlink, fExprBlinkString);


  if assigned(fExprBlink) then isBlink := true
  else isBlink := false;

  fParam.Init(fOwner.Name);
  if fParam.isIDValid then isControl := true else isControl := false;
  THackControl(fOwner).OnMouseDown := OnMouseDownProc;
  //THackControl(fOwner).OnMouseUp := OnMouseUpProc;
  if isControl then
  begin
    //THackControl(fOwner).OnMouseDown := OnMouseDownProc;
    THackControl(fOwner).OnMouseUp := OnMouseUpProc;
    fOwner.cursor := crHandPoint
  end else
  begin
   // THackControl(fOwner).OnMouseDown := nil;
    THackControl(fOwner).OnMouseUp := nil;
    fOwner.cursor := crDefault;
  end;

end;

procedure TIMMIPropertys.ImmiUnInit;
begin
  if assigned(fExprValue) then fExprValue.ImmiUnInit;
  if assigned(fExprVisible) then fExprVisible.ImmiUnInit;
  if assigned(fExprBlink) then fExprBlink.ImmiUnInit;
  fparam.UnInit;
end;

procedure TIMMIPropertys.ImmiUpdate;

begin

  if assigned(fExprValue) then
  begin
    fExprValue.ImmiUpdate;
    isOn := fExprValue.IsTrue;
  end;
  if assigned(fExprBlink) then
  begin
    fExprBlink.ImmiUpdate;
    isBlink := fExprBlink.IsTrue;
    if not isBlink then
    begin
      isBlinkOn := false;
    end;
  end;

  if assigned(fExprVisible) then
  begin
    fExprVisible.ImmiUpdate;
    isVisible := fExprVisible.IsTrue;
  end;
  if Not isVisible then
    State := psInvisible
  else
    if isBlink then
      begin
       if BlinkInvisible then
       begin
         if isBlinkOn then //если мигание положительное, то определяем состояние
         begin
           if isOn then state := psBlinkOn
           else state := psBlinkOff;
         end
         else state := psBlinkInvisible;//если мигание отрицательное, то невидим
       end
       else //мигаем видими
         if isBlinkOn then state := psBlinkOn
         else state := psBlinkOff;
      end
    else
      if isOn then State := psOn
      else State := psOff;
    fparam.immiUpdate;  
end;

procedure TIMMIPropertys.OnMouseDownProc(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  PrFormManager.Activate;
  if not isControl then exit;
  case PA of
    PAClick: param.TurnOn;
    PASwitch: if Param.isOn then param.TurnOff else param.TurnOn;
    PAGetValue:
      with TImmiValueEntryFrm.Create(fOwner) do
      try
        Value := Param.Value;
        minValue := param.MinEU;
        maxValue := param.MaxEU;
        if ShowModalAt(fOwner) = integer(mrOK) then
          Param.Value := Value;

      finally
          free;
      end;
    end; //case
    //sleep(50);
    //Application.ProcessMessages;

end;

procedure TIMMIPropertys.OnMouseUpProc(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case PA of
    PAClick: begin if (param.isreset) then param.TurnOff; end;
    PASwitch,
    PAGetValue:
  end;
end;

procedure TIMMIPropertys.SetInvisiblePages;
begin
    IMMIPropertysForm.tsLine.tabvisible := false;
    IMMIPropertysForm.tsFill.tabVisible := false;
    IMMIPropertysForm.tsFont.tabVisible := false;
    IMMIPropertysForm.tsPicture.tabVisible := false;
end;

function TIMMIPropertys.ShowPropForm(desi: TComponent): boolean;
var
  newForm: boolean;
begin
  result := false;
  newForm := false;
  if not assigned(IMMIPropertysForm) then
  begin
    IMMIPropertysForm := TIMMIPropertysForm.Create(nil);
    newForm := true;
  end;
  with IMMIPropertysForm do
  begin
    des:=desi;
    SetInvisiblePages;
    Edit1.Text := ExprVal;
    Edit3.Text := ExprVisible;
    editexpr1.text:=param.ExprEnabled;
    edit4.text := ExprBlink;
    Edit2.Text := Param.rtName;
    SpinEdit1.Value := Param.access;
    comboBox1.ItemIndex := integer(fPA);
    checkBox1.Checked := blinkInvisible;
    formM.assign(prformmanager);
      if ShowModal = mrOK then begin
        ExprVal := Edit1.Text;
        ExprVisible := Edit3.Text;
        ExprBlink := edit4.text;
        Param.rtName := Edit2.Text;
        Param.access := SpinEdit1.Value;
        PA := TParamAction(comboBox1.ItemIndex);
        blinkInvisible := checkBox1.Checked;
        param.ExprEnabled:= editexpr1.text;
        result := true;
        prformmanager.Assign(formM);
    end;
    if newForm then begin
      free;
      IMMIPropertysForm := nil;
    end;
  end;
end;

{ TIMMIImgPropertys }

constructor TIMMIImgPropertys.Create(AOwner: TControl);
begin
  inherited;
  fOnPicture := tPicture.Create;
  fOffPicture := tPicture.Create;
end;

procedure TIMMIImgPropertys.setOffPicture(value: TPicture);
begin
  foffPicture.assign(value)
end;

procedure TIMMIImgPropertys.setOnPicture(value: TPicture);
begin
  fonPicture.assign(value)
end;

destructor TIMMIImgPropertys.Destroy;
begin
  fOnPicture.free;
  fOffPicture.free;
  inherited;
end;

procedure TIMMIImgPropertys.SetInvisiblePages;
begin
  inherited;
  IMMIPropertysForm.tsPicture.tabVisible := true;
end;

function TIMMIImgPropertys.ShowPropForm(desi: TComponent): boolean;
var
  newForm: boolean;
begin
  newForm := false;
  if not assigned(IMMIPropertysForm) then
  begin
    IMMIPropertysForm := TIMMIPropertysForm.Create(nil);
    newForm := true;
  end;
  with IMMIPropertysForm do begin
    CheckBox2.Checked := Stretch;
    Image1.Picture.Assign(fOnPicture);
    Image2.Picture.Assign(fOffPicture);
    Image1.Stretch := Stretch;
    Image2.Stretch := Stretch;
    result := inherited ShowPropForm(desi);
    if result then begin
      fOnPicture.Assign(Image1.Picture);
      fOffPicture.Assign(Image2.Picture);
      Stretch := CheckBox2.Checked;
    end;
    if newForm then
    begin
      free;
      IMMIPropertysForm := nil;
    end;
  end;
end;



{ TIMMIImgGifPropertys }

constructor TIMMIImgGifPropertys.Create(AOwner: TControl);
begin
  inherited;
  fOnImage := tgifImage.Create;
  fOffImage := tgifImage.Create;
end;

procedure TIMMIImgGifPropertys.setOffImage(value: TGifImage);
begin
  foffimage.assign(value)
end;

procedure TIMMIImgGifPropertys.setOnImage(value: TgifImage);
begin
  fonImage.assign(value)
end;

destructor TIMMIImgGifPropertys.Destroy;
begin
  fOnImage.free;
  fOffImage.free;
  inherited;
end;

procedure TIMMIImgGifPropertys.SetInvisiblePages;
begin
  inherited;
  //IMMIPropertysForm.tsPicture.tabVisible := true;
end;

function TIMMIImgGifPropertys.ShowPropForm(desi: TComponent): boolean;
var
  newForm: boolean;
begin
 newForm := false;
  if not assigned(IMMIPropertysForm) then
  begin
    IMMIPropertysForm := TIMMIPropertysForm.Create(nil);
    newForm := true;
  end;
  with IMMIPropertysForm do begin
    CheckBox2.Checked := Stretch;
    Image1.Picture.Assign(fOnImage);
    Image2.Picture.Assign(fOffImage);
    Image1.Stretch := Stretch;
    Image2.Stretch := Stretch;
    result := inherited ShowPropForm(desi);
    if result then begin
      fOnImage.Assign(Image1.Picture);
      fOffImage.Assign(Image2.Picture);
      Stretch := CheckBox2.Checked;
    end;
    if newForm then
    begin
      free;
      IMMIPropertysForm := nil;
    end;
  end;
end;


end.
