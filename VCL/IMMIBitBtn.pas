unit IMMIBitBtn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,
  constDef,
  memStructsU,IMMIButtonEditorU,
  ParamU,
  IMMISpeedBtnEditor, FormManager, sRegistrationForm, LoginError ;

type
  TIMMIBitBtn = class(TBitBtn)
  private
     fParam: TParamButtonControl;
     fUpFormManager: TFormManager;
     fDownFormManager: TFormManager;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OnMouseDownProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUpProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;

    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm(desi: Tcomponent);
  published
    { Published declarations }
    property Param: TParamButtonControl read fParam write fParam;
    property DownFormManager: TFormManager  read fDownFormManager write fDownFormManager;
    property UpFormManager: TFormManager  read fUpFormManager write fUpFormManager;
  end;

implementation

uses QueryForm;

constructor TIMMIBitBtn.Create(AOwner: TComponent);
begin
     inherited;
     OnMouseDown := OnMouseDownProc;
     OnMouseUp := OnMouseUpProc;
     fUpFormManager:=TFormManager.create(self);
     fDownFormManager:=TFormManager.create(self);
     cursor := crHandPoint;
     param := TParamButtonControl.Create;
     NumGlyphs := 4;
     caption := '';
end;

procedure TIMMIBitBtn.ImmiInit (var Msg: TMessage);
begin
  param.Init (Name);
end;

procedure TIMMIBitBtn.ImmiUnInit (var Msg: TMessage);
begin
  param.UnInit;
end;

procedure TIMMIBitBtn.ImmiUpdate (var Msg: TMessage);
begin
    param.immiUpdate;
    Enabled:=param.isEnabled;
    visible:=param.isvisible;
end;

procedure TIMMIBitBtn.OnMouseDownProc(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
begin
      if param.bitid<0 then
     begin
     if param.value=0 then param.Turnon else param.TurnOff;
     end else
     begin
       if (round(Param.Value) and (1 shl param.bitid))=0 then param.TurnOn else param.TurnOff;
     end;
     fDownFormManager.Activate;
end;

procedure TIMMIBitBtn.OnMouseUpProc(Sender: TObject; Button: TMouseButton;
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
   { if param.bitid<0 then
     begin
     if param.Value<>0 then param.Turnoff else param.TurnOn;
     end else
     begin
       if (round(Param.Value) and (1 shl param.bitid))<>0 then param.TurnOn else param.TurnOff;
     end; }
     fupFormManager.Activate
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

procedure  TIMMIBitBtn.ShowPropForm(desi: Tcomponent);
begin

with TButtonEditorFrm.Create(nil) do begin
    edit1.Text:=self.caption;
    Editexpr1.Text := self.param.rtName;
    Editexpr2.Text := self.param.ExprEnabled;
    Editexpr3.Text := self.param.rtnameplus;
    SpinEdit1.Value :=self.param.Access;
   // Image1.Picture.Bitmap.Assign(Glyph);
    checkbox1.checked:=self.param.isLogin;
    checkbox2.checked:=self.param.isreset;
    checkbox3.checked:=self.param.isoff;
    edit2.text:=self.param.QueryString;
    formM.assign(self.fUpFormManager);
    des:=desi;
    if ShowModal = mrOK then begin
     self.caption:=edit1.Text;
     self.param.rtName:=Editexpr1.Text;
     self.param.ExprEnabled:=Editexpr2.Text;
     self.param.rtnameplus:=Editexpr3.Text;
     self.param.Access:=SpinEdit1.Value;
    // Glyph.Assign(Image1.Picture.Bitmap);
     self.param.isLogin:=checkbox1.checked;
     self.param.isreset:=checkbox2.checked;
     self.param.isoff:=checkbox3.checked;
     self.param.QueryString:=edit2.text;
     self.UpFormManager.assign(formM);
    end;
    Free;
 end;
end;

procedure TIMMIBitBtn.ShowPropFormMsg(var Msg: TMessage);
begin
  immiUninit(Msg);
  //showPropForm;
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

destructor TIMMIBitBtn.Destroy;
begin
fUpFormManager.Free;
fDownFormManager.Free;
inherited;
end;

end.
