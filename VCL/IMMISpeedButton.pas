unit IMMISpeedButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons,
  constDef,
  memStructsU,
  ParamU,
  IMMISpeedBtnEditor,FormManager, sRegistrationForm, LoginError;

type
  TIMMISpeedButton = class(TSpeedButton)
  private
    { Private declarations }
    fParam: tParamButtonControl;
    fUpFormManager: TFormManager;
    fDownFormManager: TFormManager;
    fmustDown: boolean;
  protected
    procedure setmustDown (val: boolean);
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure Click; override;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;

    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm(desi: Tcomponent);
  published
    { Published declarations }
    property Param: tParamButtonControl read fParam write fParam;
    property mustDown: boolean read fmustDown write setmustDown;
    property DownFormManager: TFormManager  read fDownFormManager write fDownFormManager;
    property UpFormManager: TFormManager  read fUpFormManager write fUpFormManager;
  end;



implementation

uses QueryForm;

constructor TIMMISpeedButton.Create(AOwner: TComponent);
begin
     inherited;
     cursor := crHandPoint;
     AllowAllUp := true;
     GroupIndex := 1;
     NumGlyphs := 4;
     fParam := tParamButtonControl.Create;
    fUpFormManager:=TFormManager.create(self);
    fDownFormManager:= TFormManager.create(self);
end;

procedure TIMMISpeedButton.ImmiInit (var Msg: TMessage);
begin
  Param.Init (Name);
  Enabled:=param.isEnabled;
  fmustDown:=(fParam.Value <> 0);
  down:=fmustDown;
end;

procedure TIMMISpeedButton.setmustDown (val: boolean);
begin
if (val<>fmustDown) then
   begin
      fmustDown:=val;
      down:=val;
   end;
end;

procedure TIMMISpeedButton.ImmiUnInit (var Msg: TMessage);
begin
  Param.UnInit;
end;

procedure TIMMISpeedButton.ImmiUpdate (var Msg: TMessage);

begin


     mustDown := (fParam.Value <> 0);



if param.ExprEnabled<>'' then
begin
  param.immiUpdate;
 Enabled:=param.isEnabled;
end;
if param.ExprVisible<>'' then
begin
  param.immiUpdate;
 Visible:=param.isVisible;
end;
end;

procedure TIMMISpeedButton.Click;
begin


     if AccessLevel^<param.Access then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;

  inherited;

      if param.isLogin then
        begin
          if RForm=nil then RForm:=TRegistrationForm.Create(self);
          if not RForm.Execute then exit;
       end;

     if param.QueryString='' then
     begin

        begin
         if param.bitid<0 then
          begin
          if param.value=0 then param.TurnOn else param.TurnOff;
          end else
          begin
          if (round(Param.Value) and (1 shl param.bitid))=0 then param.TurnOn else param.TurnOff;
          end;
        fUpFormManager.Activate;
        end
    end
    else
    begin
    if formQ=nil then formQ:=TQueryForm.Create(self);
    formq.Label1.Caption:=param.QueryString;
    formq.ImmiButtonXp1.Param.isEnabled:=Param.isEnabled;
    formq.ImmiButtonXp1.Param.rtName:=Param.rtName;
    formq.ImmiButtonXp1.Param.isOff:=Param.isOff;
    formq.ImmiButtonXp1.Param.Access:=Param.Access;
    formq.ImmiButtonXp1.FormManager.OpenForm.Assign(fupFormManager.OpenForm);
    formq.ImmiButtonXp1.FormManager.CloseForm.Assign(fupFormManager.CloseForm);
    formq.ShowModal;
    end;

end;


procedure TIMMISpeedButton.ShowPropForm(desi: Tcomponent);
begin
  with TSpeedBtnEditorFrm.Create(nil) do begin
    edit1.Text:=self.caption;
    Editexpr1.Text := self.param.rtName;
    Editexpr2.Text := self.param.ExprEnabled;
    Editexpr3.Text := self.param.rtnameplus;
    SpinEdit1.Value :=self.param.Access;
    Image1.Picture.Bitmap.Assign(Glyph);
    checkbox1.checked:=self.param.isLogin;
    checkbox2.checked:=self.param.isreset;
    Editexpr4.Text := self.param.ExprVisible;
    checkbox3.checked:=self.param.isoff;
    edit2.text:=self.param.QueryString;
    formM.assign(self.UpFormManager);
    checkbox2.visible:=false;
    checkbox3.visible:=false;
    des:=desi;
    if ShowModal = mrOK then begin
     self.caption:=edit1.Text;
     self.param.rtName:=Editexpr1.Text;
     self.param.ExprEnabled:=Editexpr2.Text;
     self.param.rtnameplus:=Editexpr3.Text;
     self.param.ExprVisible:=Editexpr4.Text;
     self.param.Access:=SpinEdit1.Value;
     Glyph.Assign(Image1.Picture.Bitmap);
     self.param.isLogin:=checkbox1.checked;
     self.param.isreset:=checkbox2.checked;
     self.param.isoff:=checkbox3.checked;
     self.param.QueryString:=edit2.text;
     self.UpFormManager.assign(formM);
    end;
    Free;
  end;
end;

procedure TIMMISpeedButton.ShowPropFormMsg(var Msg: TMessage);
begin
  immiUninit(Msg);
 // showPropForm;
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

destructor TIMMISpeedButton.Destroy;
begin
fUpFormManager.Free;
fDownFormManager.Free;
inherited;
end;


end.
