unit ActBoolExpr;

interface

uses
  SysUtils, Classes, constDef, expr,Messages, dialogs, controls, windows, forms,ExtCtrls;

type TTypeUseAct = (tuNone, tuTimer, tuBlink );

type
  TActExpr = class(TComponent)
  private
    { Private declarations }
    fExprBool: TExprStr;
    fexpession: tExpretion;
    fison: boolean;
    fvalid: integer;
    fChangestate: TEprBoolNotyfy;
    fChangeValue: TEprValueNotyfy;
    fvalue: double;
    fIgnoreValid: boolean;
    ftimer: TTimer;
    fBlinkstate: boolean;
    fTypeUse: TTypeUseAct;
    fDelay: Integer;
  protected
    procedure setIson(val: boolean);
    procedure setDelay(val: integer);
    procedure setValue(val: double);
    procedure SetTypeUse(val: TTypeUseAct);
    procedure TimerProc(Sender: TObject);
    { Protected declarations }
  public
    constructor Create(Aowner: TComponent); override;
    property  IsOn: boolean read fisOn write setison;
    property  Value: double read fValue write setValue;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ImmiBlinkOn (var Msg: TMessage); message WM_IMMIBLINKON;
    procedure ImmiBlinkOff (var Msg: TMessage); message WM_IMMIBLINKOFF;
    { Public declarations }
  published
      property ExprBool: TExprStr read fExprBool write fExprBool;
      property OnstateIMMIExpr: TEprBoolNotyfy read fChangestate write fChangestate;
      property OnValueIMMIExpr: TEprValueNotyfy read fChangeValue write fChangeValue;
      property IgnoreValid: boolean read fIgnoreValid write fIgnoreValid;
      property TypeUse: TTypeUseAct read fTypeUse write SetTypeUse;
      property Delay: Integer read fDelay write setDelay;
    { Published declarations }
  end;

 type TScriptTimer = class(TTimer)
     private
       fSInterval: integer;
       procedure setSInterval(val: integer);
     public
     constructor Create(AOwner: TComponent); override;
     published
      property SInterval: integer read fSInterval write setSInterval;
  end;

 type
  TAppExpr = class(TComponent)
  private
       OldWndProc, NewWndProc: Pointer;
       finit: boolean;
    { Private declarations }
  protected
    function FormHandle: THandle;
    procedure NewWndMethod (var Msg: TMessage);
    { Protected declarations }
  public
   constructor Create (AOwner: TComponent); override;
   destructor Destroy; override;
    { Public declarations }
  published

    { Published declarations }
  end;




procedure Register;

implementation


constructor TActExpr.Create(Aowner: TComponent);
begin
  inherited ;
  fExprBool:='';
  fexpession:=nil;
  fison:=false;
  fChangestate:=nil;
  fTypeUse:=tuNone;
  fBlinkstate:=false;
  fvalid:=0;
  fdelay:=60000;
end;

procedure TActExpr.SetTypeUse(val: TTypeUseAct);
begin
  if val<>fTypeUse then
    begin
      case val of
        tuNone:
          begin
            if ftimer<>nil then ftimer.free;
            ftimer:=nil;
            fBlinkstate:=false;
          end;
        tuTimer:
          begin
            ftimer:=Ttimer.Create(self);
            ftimer.OnTimer:=TimerProc;
            ftimer.Enabled:=true;
            fBlinkstate:=false;
          end;
        tuBlink:
          begin
            if ftimer<>nil then ftimer.free;
            ftimer:=nil;
          end;
       end;
     fTypeUse:=val;  
    end;
end;

procedure TActExpr.setDelay(val: integer);
begin
  if val<>fDelay then
    begin
      if val<100 then
        val:=60000;
      fDelay:=val;
      if ftimer<>nil then ftimer.Interval:=val;
    end;
end;

procedure TActExpr.TimerProc(Sender: TObject);
begin
   if not assigned(fChangestate) then exit;
   fblinkState:=not fblinkState;
   if (fIgnoreValid) or ((fvalid>80) and (not fIgnoreValid)) then
   fChangestate(fison,fblinkState);
end;

procedure TActExpr.ImmiBlinkOn (var Msg: TMessage);
begin
   if fTypeUse<>tuBlink then exit;
   if not assigned(fChangestate) then exit;
   if not assigned(fexpession) then exit;
   fblinkState:=true;
   if (fIgnoreValid) or ((fvalid>80) and (not fIgnoreValid)) then
   fChangestate(fison,fblinkState);
end;

procedure TActExpr.ImmiBlinkOff (var Msg: TMessage);
begin
   if fTypeUse<>tuBlink then exit;
   if not assigned(fChangestate) then exit;
   if not assigned(fexpession) then exit;
   fblinkState:=false;
   if (fIgnoreValid) or ((fvalid>80) and (not fIgnoreValid)) then
   fChangestate(fison,fblinkState);
end;

procedure TActExpr.setIson(val: boolean);
begin
 if val<>fIson then
  begin
    fIson:=val;
    if assigned(fChangestate) then fChangestate(fison,fblinkState);
  end;
end;

procedure TActExpr.setValue(val: double);
begin
   if val<>fvalue then
  begin
    fvalue:=val;
   // showmessage(floattostr(fvalue));
    if assigned(fChangeValue) then fChangeValue(fvalue);

  end;
end;

procedure TActExpr.ImmiInit (var Msg: TMessage);
begin
  CreateAndInitExpretion(fexpession, fExprBool);
  if (assigned(fexpession)) then
  begin
      if assigned(fChangeValue) then fChangeValue(fvalue);
      if assigned(fChangestate) then fChangestate(fison,fblinkState);
  end;
end;

procedure TActExpr.ImmiUnInit (var Msg: TMessage);
begin
  if assigned(fexpession) then
  begin
  fexpession.ImmiUnInit;
 //fexpession.Free;
  end;
end;

procedure TActExpr.ImmiUpdate (var Msg: TMessage);
begin
  if assigned(fexpession) then
  begin
  //  showmessage('update');
    fexpession.ImmiUpdate;
    fvalid:=fexpession.validLevel;
    if (fIgnoreValid) or ((fvalid>80) and (not fIgnoreValid)) then
     begin
      isOn:=fexpession.isTrue;
      value:=fexpession.value;
     end;
  end;
end;





constructor TAppExpr.Create (AOwner: TComponent);
var
  I: Integer;
begin
    finit:=false;
    if (AOwner = nil) then
      raise Exception.Create (
        'Owner of TAppExpr component is nil');
    if not (AOwner is TForm) then
      raise Exception.Create (
      'Owner of TAppExpr component must be a form');
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TAppExpr then
      raise Exception.Create (
        'TAppExpr component duplicated in ' +
        AOwner.Name);

  inherited Create (AOwner);
    NewWndProc := MakeObjectInstance (NewWndMethod);
    OldWndProc := Pointer (SetWindowLong (
      FormHandle, gwl_WndProc, Longint (NewWndProc)));
end;

destructor TAppExpr.Destroy;
begin
  if Assigned (NewWndProc) then
  begin
    if owner<>nil then
    begin
    FreeObjectInstance (NewWndProc);
    SetWindowLong (FormHandle, gwl_WndProc,
      Longint (OldWndProc));
    end;
  end;
  inherited Destroy;
end;

function TAppExpr.FormHandle: THandle;
begin
  Result := (Self.Owner as TForm).Handle;
end;

// custom window procedure

procedure TAppExpr.NewWndMethod (var Msg: TMessage);

begin
 if finit then
  case Msg.Msg of
    WM_IMMIUpdate,
    WM_IMMIUnInit,
    WM_IMMIBlinkOn,
    WM_IMMIBlinkOff:
         // showmessage('ggggg');
         Immi_BroadCast(Self.Owner,Msg);

  end else

    case Msg.Msg of
    WM_IMMIUpdate, WM_IMMIUnInit:
      begin
        Msg.Msg:=WM_IMMIInit;
        Immi_BroadCast(Self.Owner,Msg);
        finit:=true;
      end;

   end;

  Msg.Result := CallWindowProc (OldWndProc,
    FormHandle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure TScriptTimer.setSInterval(val: integer);
begin
  if val<>fSInterval then
  begin
   if val<100 then val:=60000;
   fSInterval:=val;
   Interval:=val;
  end;
end;

constructor TScriptTimer.Create(AOwner: TComponent);
begin
inherited;
interval:=60000;
fSInterval:=60000;

end;
procedure Register;
begin

end;

end.
 