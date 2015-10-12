unit ParamU;

interface
uses
  classes,  dialogs, sysUtils, messages,windows, Controls, StrUtils,  GlobalValue, GroupsU,
  memStructsU, constDef, calcU1, IMMIEditEditorU, Expr,LoginError,Forms,math;

Type

TParam = class(tPersistent)
private
    fvals: integer;
    frtName: TExprStr;
    function GetMaxEu: single;
    function GetMinEu: single;
    procedure SetrtName(const Value: TExprStr);
    function GetValidLevel: integer;
    function GetIsKvit: boolean;
    function GetIsValid: boolean;
    function GetComment: String;
    function GetIsOn: boolean;
protected
   rtID: longInt;

   function GetValue: real;
public
   bitid: longint;
   procedure Assign(Source: TPersistent); override;
  function Init (ControlName: string): boolean;  virtual;
   procedure UnInit; virtual;
   constructor Create;
   destructor Destroy; override;
   property Value: real read GetValue;
   property MinEu: single read GetMinEu;
   property MaxEu: single read GetMaxEu;
   property ValidLevel: integer read GetValidLevel;
   property IsOn: boolean read GetIsOn;
   property IsValid: boolean read GetIsValid;
   property IsAlarmKvit: boolean read GetIsKvit;
   property Comment: String read GetComment;
   function IsIDValid: boolean;
published
   property rtName: TExprStr read frtName write SetrtName;
   property vals: integer read fvals write fvals;
end;




TParamLabel = class(TParam)
private
   fFormat: String;
public
   constructor Create;
   procedure Assign(Source: TPersistent); override;
published
   property Format: String read fFormat write fFormat;
end;

TParamGraphic = class (TParam)
private
   fMinValue, fMaxValue: single;
public
   constructor Create;
published
   property minValue: single read fMinValue write fMinValue;
   property maxValue: single read fMaxValue write fMaxValue;
end;

TParamButtonControl = class (TParam)
private
   fQueryString: string;
   frtNamePlus: TExprStr;
   fAccess: integer;
   fExprEnabledString: TExprStr;
   fExprVisibleString: TExprStr;
   fExprEnable: tExpretion;
   fExprVisible: tExpretion;
   fisoff, fisLogin: boolean;
   identstr: TStringList;
   expcount: integer;
   fisreset: boolean;
   idAr: array [0..255] of integer;
   tes: TExpretion;
public
   isEnabled: boolean;
   isVisible: boolean;
   constructor Create;
   destructor Destroy; override;
   function Init (ControlName: string):boolean; override;
   procedure UnInit; override;
   procedure immiUpdate;
   procedure TurnOn;
   procedure TurnOff;
   procedure TurnUp(pers: double);
   procedure Turndown(pers: double);
   procedure Assign(Source: TPersistent); override;
published
   property Access: integer read fAccess write fAccess default 100;
  property ExprEnabled: TExprStr read fExprEnabledString write fExprEnabledString;
  property ExprVisible: TExprStr read fExprVisibleString write fExprVisibleString ;//default '';
  property QueryString: string read fQueryString write fQueryString;
  property isOff: boolean read fisoff write fisoff;
  property isLogin: boolean read fisLogin write fisLogin;
  property rtNamePlus: TExprStr read frtNamePlus write frtNamePlus;
  property isreset: boolean read fisreset write fisreset;
end;

TParamControl = class (TParamButtonControl)
private
   fMinValue, fMaxValue: single;
   fisQuery: boolean;
public
   constructor Create;
   procedure SetNewValue(Val: real);
   procedure Assign(Source: TPersistent); override;
   property Value: real read GetValue write SetNewValue;
published
   property minValue: single read fMinValue write fMinValue;
   property maxValue: single read fMaxValue write fMaxValue;
   property isQuery: boolean read fisQuery write fisQuery;
end;

TParamControlEdit = class (TParamControl)
private
   fFormat: String;
public
   constructor Create;
   procedure ShowPropForm;
   procedure Assign(Source: TPersistent); override;
published
   property format: String read fFormat write fFormat;
end;

procedure CreateAndInitParamControl(var Expr: TParamControl; ExprStr: String);



implementation

{************************TParam****************************}
constructor TParam.Create;
begin
     inherited;
     rtID := -1;
     bitId:=-1;
     fvals:=0;
end;

procedure TParam.Assign(Source: TPersistent);
begin
     fRTName := TParam(Source).rtName;
     RTID := TParam(Source).rtID;
     bitid:= TParam(Source).bitID;
     inherited Assign(Source);
end;

function TParam.Init(ControlName: string):boolean;
begin
     result:=false;
     if pos ('.', rtname) <> 0 then
       begin
       rtID := rtItems.getSimpleID(copy (rtname, 1, pos ('.', rtname)-1));
       bitid :=strtointdef(trim(copy (rtname, pos ('.', rtname) + 1, length(rtname) - pos ('.', rtname))),0);
       end else
       begin
       rtID := rtItems.getSimpleID(rtname);
        bitId:=-1;
       end;
     if rtID <> -1 then rtItems.IncCounter(rtID)
    else
       if rtName <> '' then
        result:=true// raise Exception.Create (controlName + ' параметр ' + self.rtName + ' не найден');
         //ShowMessage (controlName + ' параметр ' + self.rtName + 'не найден');
end;

procedure TParam.UnInit;
begin
 if rtID <> -1 then
 begin
   rtItems.decCounter(rtID);
   rtID := -1;
   bitid:=-1;
 end;
end;

{**************************TParamLabel********************************}
constructor TParamLabel.Create;
begin
     inherited;
     fformat := '%.2f';
end;

procedure TParamLabel.Assign(Source: TPersistent);
begin
     fFormat := TParamLabel(Source).format;
     inherited;
end;

{**************************TParamGraphic********************************}
constructor TParamGraphic.Create;
begin
     inherited;
     fminValue := 0;
     fmaxValue := 100;
end;

{**************************TParamButtonControl********************************}
procedure TParamButtonControl.TurnOn;
var j, grNum: integer;
begin
 // rtitems.tegGroups:=TGroups.Create(PathMem + 'groups.cfg');
  if (rtID = -1 ) and (expcount=0) then exit;
 { grNum:=rtitems.Items[rtitems.GetSimpleID(rtitems.GetName(rtId))].GroupNum;
  if pos('$ССЫЛОЧНАЯ', ANSIUPPERCASE(trim(rtitems.tegGroups.ItemNameByNum[grNum])))<>0  then
    begin
      grNum:=rtitems.getsimpleID(ANSIUPPERCASE(trim(rtitems.teggroups.ItemNameByNum[grNum])));
      if (rtID > -1 ) then rtItems.AddCommand(rtID, 1, true);
      if grNum>-1 then
       begin
        rtitems.setddeitem(grNum,rtitems.getddeitem(rtId));

        end;
        exit;
    end;     }

  if accessLevel^ >= access then
    begin
    if (rtID > -1 ) then
    begin
    if bitid<0 then
    begin
    if vals<1 then
    rtItems.AddCommand(rtID, 1, true) else rtItems.AddCommand(rtID, vals, true);
    end
    else
    begin
    rtitems.AddCommand(rtid,round(Value) or (1 shl bitid),true);
    end;
    end;
      for j:=0 to expcount-1 do
     if pos(trim(uppercase('!'+rtitems.GetName(idar[j]))),trim(uppercase(frtNameplus)))=0 then
     rtItems.AddCommand(idar[j], 1, true) else
     rtItems.AddCommand(idar[j], 0, true)
    end
  else {MessageDlg('Низкий уровень доступа', mterror, [mbOk], 0)} begin
      if AccessLevel^<faccess then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;
    end;
end;

procedure TParamButtonControl.TurnUp(pers: double);
begin
   if accessLevel^ >= access then
    begin
    if (rtID > -1 ) then
    begin
      rtitems.AddCommand(rtid, min(rtitems.items[rtid].maxEu,(rtitems.items[rtid].ValReal+(rtitems.items[rtid].maxEu-rtitems.items[rtid].minEu)*pers/100)),true);
    end;
    end;
end;

procedure TParamButtonControl.Turndown(pers: double);
begin
   if accessLevel^ >= access then
    begin
    if (rtID > -1 ) then
    begin
      rtitems.AddCommand(rtid,max(rtitems.items[rtid].minEu,(rtitems.items[rtid].ValReal-(rtitems.items[rtid].maxEu-rtitems.items[rtid].minEu)*pers/100)),true);
    end;
    end;
end;


procedure TParamButtonControl.TurnOff;
var j, grNum: integer;
begin
  if (rtID = -1 ) and (expcount=0) then exit;
  { grNum:=rtitems.Items[rtitems.GetSimpleID(rtitems.GetName(rtId))].GroupNum;
  if pos('$ССЫЛОЧНАЯ', ANSIUPPERCASE(trim(rtitems.tegGroups.ItemNameByNum[grNum])))<>0  then
  begin
      if (rtID > -1 ) then rtItems.AddCommand(rtID, 1, true);
      grNum:=rtitems.getsimpleID(ANSIUPPERCASE(trim(rtitems.teggroups.ItemNameByNum[grNum])));
      if grNum>-1 then
        begin
        rtitems.setddeitem(grNum,rtitems.getddeitem(rtId));

        end;
        exit;
    end;      }
  if accessLevel^ >= access then
     begin
     if (rtID > -1 ) then
     begin
     if bitid<0 then
     rtItems.AddCommand(rtID, 0, true) else
     rtitems.AddCommand(rtid,round(Value) and not (1 shl bitid),true);
     end;
      for j:=0 to expcount-1 do
     if pos( trim(uppercase('!'+rtitems.GetName(idar[j]))),trim(uppercase(frtNameplus)))=0 then
     rtItems.AddCommand(idar[j], 0, true) else rtItems.AddCommand(idar[j], 1, true)
     end
  else {MessageDlg('Низкий уровень доступа', mterror, [mbOk], 0)} begin
      if AccessLevel^<faccess then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;
    end;
end;

function TParamButtonControl.Init (ControlName: string): boolean;
var j: integer;
begin
result:=inherited Init(ControlName);
expcount:=0;
CreateAndInitExpretion(tes,frtnameplus);
identstr.clear;
if assigned(tes) then
begin
tes.AddIdentList(identstr);
if identstr.count>0 then
  begin
   for J:=0 to identstr.count-1 do
      begin
     if rtitems.getsimpleId(trim(identstr.strings[j]))>-1 then
        begin
          IdAr[j]:=rtitems.getsimpleId(identstr.strings[j]);
          inc(expcount);
        end;
     // if expcount=0 then
      //   begin
       //  showmessage({'Ошибка в непустом выражении '+rtname} //identstr.strings[j]);
        // rtId:=-1;
       // end;
      end;
    end;

end;
if assigned(tes) then tes.ImmiUnInit;
CreateAndInitExpretion(fExprEnable, fExprEnabledString);
CreateAndInitExpretion(fExprVisible, fExprVisibleString);
if  assigned(fExprEnable) then isEnabled:=false else isEnabled:=true;
if  assigned(fExprVisible) then isVisible:=false else isVisible:=true;
end;

procedure TParamButtonControl.UnInit;
begin
inherited;
 expcount:=0;

 if assigned(fExprEnable) then
                 fExprEnable.ImmiUnInit;
  if assigned(fExprVisible) then
                 fExprVisible.ImmiUnInit;
end;

procedure TParamButtonControl.ImmiUpdate;
begin
  if assigned(fExprEnable) then
  begin
    fExprEnable.ImmiUpdate;
    isEnabled := fExprEnable.IsTrue;
  end
 else
   isEnabled :=true;

 if assigned(fExprVisible) then
  begin
    fExprVisible.ImmiUpdate;
    isVisible := fExprVisible.IsTrue;
  end
 else
   isVisible :=true;
end;

constructor TParamButtonControl.Create;
begin
inherited;
identstr:=TStringList.create;
identstr.clear;
expcount:=0;
end;

destructor TParamButtonControl.Destroy;
begin
expcount:=0;
identstr.free;
inherited;
end;

{**************************TParamControl********************************}
procedure TParamControl.Assign(Source: TPersistent);
begin
  inherited;
  if (source is TParamControl) then
    MinValue := (source as TParamControl).MinValue;
  if (source is TParamControl) then
    MaxValue := (source as TParamControl).MaxValue;
end;

constructor TParamControl.Create;
begin
     inherited;
     fminValue := 0;
     fmaxValue := 100;
end;

procedure TParamControl.SetNewValue(Val: real);
begin
  if (rtID = -1 ) or (Value = Val) then exit;
  if accessLevel^ >= access then
  begin
     if fisQuery then
     begin

      if MessageBox(0,PChar('Установить значение парамета '+rtName+' равным  '+format('%8.2f',[val])+'   '),'Подтверждение',MB_YESNO+MB_ICONQUESTION+MB_TOPMOST)= IDYES then rtItems.AddCommand(rtID, Val, false);
     end else
     rtItems.AddCommand(rtID, Val, false)
  end
  else begin
    if AccessLevel^<faccess then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;

  end;
end;

{**************************TParamControlEdit********************************}
procedure TParamControlEdit.Assign(Source: TPersistent);
begin
  inherited;
  if (source is TParamControlEdit) then
    format := (source as TParamControlEdit).format;
end;

constructor TParamControlEdit.Create;
begin
     inherited;
     fformat := '%.2f';
end;

procedure TParamControlEdit.ShowPropForm;
begin
  with TEditEditorFrm.Create(nil) do begin
    Edit1.Text := rtName;
    Edit2.Text := format;
    Edit3.text := sysUtils.format('%8.2f', [MinValue]);
    Edit4.text := sysUtils.format('%8.2f', [MaxValue]);
    SpinEdit1.Value := Access;
    if ShowModal = mrOK then begin
      rtName := Edit1.Text;
      format := Edit2.Text;
      Access := SpinEdit1.Value;
      try
        MinValue := strtofloat(Edit3.text);
        MaxValue := strtofloat(Edit4.text);
      except
        MessageDlg('Неверное вещественное значение', mtError, [mbOK], 0);
      end;
    end;
    Free;
  end;
end;

procedure TParamButtonControl.Assign(Source: TPersistent);
begin
  inherited;
  if (source is TParamButtonControl) then
    Access := (source as TParamButtonControl).access;
end;

function TParam.GetValue: real;
begin
  if rtID <> -1 then
    result := rtItems.Items[rtID].ValReal
  else result := 0;
end;

function TParam.GetMaxEu: single;
begin
  if rtID <> -1 then
    result := rtItems.Items[rtID].MaxEu
  else result := 100;
end;

function TParam.GetMinEu: single;
begin
  if rtID <> -1 then
    result := rtItems.Items[rtID].MinEu
  else result := 100;
end;

procedure TParam.SetrtName(const Value: TExprStr);
begin
  if rtID <> -1 then
    Uninit;
    frtName := Value;
end;

destructor TParam.Destroy;
begin
  UnInit;
  inherited;
end;

function TParam.GetValidLevel: integer;
begin
  if rtID = -1 then Result := 0
    else result := rtItems[rtID].validLevel;
end;

function TParam.GetIsKvit: boolean;
begin
  if rtID = -1 then Result := true
    else result := rtItems[rtID].isAlarmKvit;
end;

function TParam.GetIsValid: boolean;
begin
  if rtID = -1 then Result := false
    else result := rtItems.isValid(rtID);
end;

function TParam.GetComment: String;
begin
  if rtID = -1 then Result := ''
    else result := rtItems.GetComment(rtID);
end;

function TParam.GetIsOn: boolean;
begin
  if rtID = -1 then Result := true
    else result := (value <> 0);
end;

function TParam.IsIDValid: boolean;
begin
  result := (rtID <> -1);
end;


procedure CreateAndInitParamControl(var Expr: TParamControl; ExprStr: String);
begin
  if (ExprStr <> '') and not Assigned (Expr) then
    Expr := TParamControl.Create;

  if assigned(Expr) then
  begin
    Expr.rtName := ExprStr;
    try
      Expr.Init('');
    except
      freeandNil(Expr);
      raise;
    end;
  end;
end;

end.
