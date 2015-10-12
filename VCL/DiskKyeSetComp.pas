unit DiskKyeSetComp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,
  constDef,
  memStructsU,
  ParamU,
  IMMISpeedBtnEditor,FormManager, sRegistrationForm, LoginError;

type
  TDiskKyeSetComp = class(TLabel)
  private
  fParam: TParamButtonControl;
  fFormManager: TFormManager;
  fKeySet: string;
  fKeySetUp: string;
  fKeySetDown: string;
  fAnalogParam: TParamControl;
  fdeltval: real;
  fisReset: boolean;
    { Private declarations }
  protected
    { Protected declarations }
  public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
  procedure ImmiKeySet (var Msg: TMessage); message WM_IMMIKEYSET;
  procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
  procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    { Public declarations }
  published
    { Published declarations }
  property Param: TParamButtonControl read fParam write fParam;
  property AnalogParam: TParamControl read fAnalogParam write fAnalogParam;
  property FormManager: TFormManager  read fFormManager write fFormManager;
  property KeySet: string read fKeySet write fKeySet;
  property KeySetUp: string read fKeySetUp write fKeySetUp;
  property KeySetDown: string read fKeySetDown write fKeySetDown;
  property deltval: real read fdeltval write fdeltval;
  property isReset: boolean read fisReset write fisReset;
  end;

procedure Register;

implementation

uses QueryForm;

constructor TDiskKyeSetComp.Create(AOwner: TComponent);
begin
     inherited;
     fFormManager:=TFormManager.create(self);
     param := TParamButtonControl.Create;
     fAnalogParam:=TParamControl.create;


end;

destructor TDiskKyeSetComp.destroy;
begin
     param.free;
     fFormManager.Free;
     fAnalogParam.free;
     inherited;
end;



procedure TDiskKyeSetComp.ImmiInit (var Msg: TMessage);
begin

  param.Init (Name);
  Analogparam.Init (Name);
end;

procedure TDiskKyeSetComp.ImmiUnInit (var Msg: TMessage);
begin
  param.UnInit;
  Analogparam.UnInit;
end;

procedure TDiskKyeSetComp.ImmiUpdate (var Msg: TMessage);
begin
    if not (csdesigning in ComponentState) then
    begin
    autosize:=true;
    caption:='';
    height:=0;
    width:=0;
    
    end;
    param.immiUpdate;
    Analogparam.immiUpdate;
end;

procedure TDiskKyeSetComp.ImmiKeySet (var Msg: TMessage);
var newVal: real;
begin
  // ShowMessage('hhhh');

   if trim(fkeyset)<>'' then
   begin

   if msg.lparam=strtointdef(fkeyset,-1000) then
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
     if not param.isOff then param.TurnOn else param.TurnOff;
     if fisReset then
       if not param.isOff then param.TurnOff else param.TurnOn;
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
   end;

   if trim(fkeysetUp)<>'' then
     begin
      if msg.lparam=strtointdef(fkeysetUp,-1000) then
       begin
        if analogparam.isEnabled then
        begin
        newval:=analogparam.value+fdeltval;
        analogparam.SetNewValue (NewVal);
        end;
      end;
     end;
   if trim(fkeysetDown)<>'' then
     begin
      if msg.lparam=strtointdef(fkeysetDown,-1000) then
       begin
        if analogparam.isEnabled then
        begin
        newval:=analogparam.value-fdeltval;
        AnalogParam.SetNewValue (NewVal);
        end;
       end;
     end;
end;



procedure Register;
begin
  RegisterComponents('IMMICtrls', [TDiskKyeSetComp]);
end;

end.
 