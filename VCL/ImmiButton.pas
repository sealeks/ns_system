unit ImmiButton;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,
  constDef,
  memStructsU,
  ParamU,
  IMMISpeedBtnEditor,
  FormManager, sRegistrationForm, LoginError;

type
  TImmiButton = class(TButton)
  private
     fParam: TParamButtonControl;
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
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;

    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm;
  published
    { Published declarations }
    property Param: TParamButtonControl read fParam write fParam;
    property FormManager: TFormManager  read fFormManager write fFormManager;
  end;

implementation

uses QueryForm;

constructor TImmiButton.Create(AOwner: TComponent);
begin
     inherited;
     OnMouseDown := OnMouseDownProc;
 //   OnMouseUp := OnMouseUpProc;
     fFormManager:=TFormManager.create(self);
     cursor := crHandPoint;
     param := TParamButtonControl.Create;
          caption := '';
end;

procedure TImmiButton.ImmiInit (var Msg: TMessage);
begin
  param.Init (Name);
end;

procedure TImmiButton.ImmiUnInit (var Msg: TMessage);
begin
  param.UnInit;
end;

procedure TIMMIButton.ImmiUpdate (var Msg: TMessage);
begin
    param.immiUpdate;
    self.Enabled:=param.isEnabled;
end;

procedure TImmiButton.OnMouseDownProc(Sender: TObject; Button: TMouseButton;
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
     fFormManager.Activate;
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



procedure TImmiButton.ShowPropForm;
begin
  with TSpeedBtnEditorFrm.Create(nil) do begin
    Edit1.Text := param.rtName;
   // SpinEdit1.Value := param.Access;
    //Image1.Picture.Bitmap.Assign(Glyph);
    if ShowModal = mrOK then begin
      param.rtName := Edit1.Text;
      param.Access := SpinEdit1.Value;
    //  Glyph.Assign(Image1.Picture.Bitmap);
      Self.caption := '';
    end;
    Free;
  end;
end;

procedure TImmiButton.ShowPropFormMsg(var Msg: TMessage);
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

destructor TImmiButton.Destroy;
begin

fFormManager.Free;
inherited;
end;

end.
