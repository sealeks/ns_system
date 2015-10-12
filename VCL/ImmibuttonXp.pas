unit ImmibuttonXp;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,
  constDef, CommCtrl,
  memStructsU,ComCtrls,
  ParamU,dxButton,   Spin,
  IMMISpeedBtnEditor,FormManager, sRegistrationForm, LoginError;

type
  TImmiUpDown = class (TSpinButton)
    private
         fParam: TParamButtonControl;
         fpers: double;
         procedure setpers(val:double);
   public
        procedure downClk(sender: TObject);
        procedure upClk(sender: TObject);
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
         procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
        procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
        procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
        property OnDownClick;
        property OnUpClick;
   published
    { Published declarations }
         property Param: TParamButtonControl read fParam write fParam;
         property pers: double read fpers write setpers;
   end;
type
  TImmiButtonXp = class(TdxButton)
  private
     fParam: TParamButtonControl;
     fKeySet: string;
     fFormManager: TFormManager;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OnMouseDownProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiKeySet (var Msg: TMessage); message WM_IMMIKEYSET;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;

    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm(desi: Tcomponent);
  published
    { Published declarations }
    property Param: TParamButtonControl read fParam write fParam;
    property FormManager: TFormManager  read fFormManager write fFormManager;
    property KeySet: string read fKeySet write fKeySet;
  end;

implementation

uses QueryForm;

constructor TImmiButtonXp.Create(AOwner: TComponent);
begin
     inherited;
     OnMouseDown := OnMouseDownProc;
 //   OnMouseUp := OnMouseUpProc;
     fFormManager:=TFormManager.create(self);
     cursor := crHandPoint;
     param := TParamButtonControl.Create;
          caption := '';
end;

procedure TImmiButtonXp.ImmiKeySet (var Msg: TMessage);
begin
   if trim(fkeyset)='' then exit;

   if msg.lparam=strtointdef(fkeyset,-1000) then
     begin
     self.OnMouseDownProc(nil,mbLeft,
                                      [], 0, 0)
     // ShowMessage(inttostr(msg.lparam)+'-'+fkeyset);
     end;
end;

procedure TImmiButtonXp.ImmiInit (var Msg: TMessage);
begin
  param.Init (Name);

end;

procedure TImmiButtonXp.ImmiUnInit (var Msg: TMessage);
begin
  param.UnInit;
end;

procedure TIMMIButtonXp.ImmiUpdate (var Msg: TMessage);
begin
    param.immiUpdate;
    self.Enabled:=param.isEnabled;
    self.visible:=param.isvisible;
end;

procedure TImmiButtonXp.OnMouseDownProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
begin
     if AccessLevel^<param.Access then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;
      if param.isLogin then
        begin
          if RForm=nil then RForm:=TRegistrationForm.Create(self);
          if not RForm.Execute then exit;
       end;

     if param.QueryString='' then
     begin
     if param.bitid<0 then
     begin
     if not param.isOff then param.TurnOn else param.TurnOff;
     end else
     begin
       if (round(Param.Value) and (1 shl param.bitid))=0 then param.TurnOn else param.TurnOff;
     end;
     if param.isReset then
     begin
      if param.bitid<0 then
      begin
        if not param.isOff then param.TurnOff else param.TurnOn;
      end else
      begin
       if (round(Param.Value) and (1 shl param.bitid))=0 then param.TurnOff else param.TurnOn;
      end;
     end;
     fFormManager.Activate
     end
    else
    begin
    if formQ=nil then formQ:=TQueryForm.Create(self);
   formq.Label1.Caption:=param.QueryString;
    formq.ImmiButtonXp1.Param.isEnabled:=Param.isEnabled;
    formq.ImmiButtonXp1.Param.rtName:=Param.rtName;
    formq.ImmiButtonXp1.Param.isOff:=Param.isOff;
    formq.ImmiButtonXp1.Param.Access:=Param.Access;
     formq.ImmiButtonXp1.FormManager.OpenForm.Assign(FormManager.OpenForm);
     formq.ImmiButtonXp1.FormManager.CloseForm.Assign(FormManager.CloseForm);
    formq.ShowModal;
    end;
end;



procedure  TIMMIButtonxp.ShowPropForm(desi: Tcomponent);
begin

with TSpeedBtnEditorFrm.Create(nil) do begin
    edit1.Text:=self.caption;
    Editexpr1.Text := self.param.rtName;
    Editexpr2.Text := self.param.ExprEnabled;
    Editexpr3.Text := self.param.rtnameplus;
    Editexpr4.Text := self.param.ExprVisible;
    SpinEdit1.Value :=self.param.Access;
    Image1.Picture.Bitmap.Assign(Glyph);
    checkbox1.checked:=self.param.isLogin;
    checkbox2.checked:=self.param.isreset;
    checkbox3.checked:=self.param.isoff;
    edit2.text:=self.param.QueryString;
    formM.assign(self.FormManager);
    des:=desi;
    if ShowModal = mrOK then begin
     self.caption:=edit1.Text;
     self.param.rtName:=Editexpr1.Text;
     self.param.ExprEnabled:=Editexpr2.Text;
     self.param.ExprVisible:=Editexpr4.Text;
     self.param.rtnameplus:=Editexpr3.Text;
     self.param.Access:=SpinEdit1.Value;
     Glyph.Assign(Image1.Picture.Bitmap);
     self.param.isLogin:=checkbox1.checked;
     self.param.isreset:=checkbox2.checked;
     self.param.isoff:=checkbox3.checked;
     self.param.QueryString:=edit2.text;
     self.FormManager.assign(formM);
    end;
    Free;
  end;
end;

procedure TImmiButtonXp.ShowPropFormMsg(var Msg: TMessage);
begin
  immiUninit(Msg);
//  showPropForm;
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

destructor TImmiButtonXp.Destroy;
begin
fFormManager.Free;
param.free;
inherited;
end;


procedure TimmiUpDown.setpers(val:double);
begin
    if (val<=100) and (val>0) then
       fpers:=val;
end;

constructor TimmiUpDown.Create(AOwner: TComponent);
begin
    inherited;
    // OnMouseDown := OnMouseDownProc;
    fpers:=1;
    cursor := crHandPoint;
    param := TParamButtonControl.Create;
    OnDownClick:=downClk;
    OnUpClick:=upClk;
end;


destructor TimmiUpDown.Destroy;
begin
   param.free;
   inherited;
end;

procedure TimmiUpDown.ImmiInit(var Msg: TMessage);
begin
  param.Init (Name);
end;

procedure TimmiUpDown.ImmiUnInit (var Msg: TMessage);
begin
  param.UnInit;
end;

procedure TimmiUpDown.ImmiUpdate (var Msg: TMessage);
begin
    param.immiUpdate;
    self.Enabled:=param.isEnabled;
end;


procedure TimmiUpDown.downClk(sender: TObject);
begin
   param.Turndown(pers);
end;

procedure TimmiUpDown.upClk(sender: TObject);
begin
   param.TurnUp(pers);
end;


end.



procedure Register;
begin
  RegisterComponents('IMMICtrls', [ImmbuttonXp]);
end;

end.
