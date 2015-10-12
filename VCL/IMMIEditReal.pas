unit IMMIEditReal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  constDef,
  memStructsU,
  ParamU,
  IMMIEditEditorU,
  ImmiValueEntryFrmU;

type
  TIMMIEditReal = class(TEdit)
  private
    { Private declarations }
    fparam: TParamControlEdit;
    stopUpdate: boolean;
    fShowDialog: boolean;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OnExitProc(Sender: TObject);
    procedure OnEnterProc(Sender: TObject);
    procedure OnKeyPressProc (Sender: TObject; var Key: Char);
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm;
  published
    { Published declarations }
    property param: TParamControlEdit read fParam write fParam;
    property ShowDialog: boolean read fShowDialog write fShowDialog;
  end;

  procedure Register;

implementation

constructor TIMMIEditReal.Create(AOwner: TComponent);
begin
     inherited;
     OnExit := OnExitProc;
     OnEnter := OnEnterProc;
     OnKeyPress := OnKeyPressProc;
     cursor := crHandPoint;
     stopUpdate := false;
     fparam := TParamControlEdit.Create;
end;

procedure TIMMIEditReal.ImmiInit (var Msg: TMessage);
begin
  param.Init (Name);
end;

procedure TIMMIEditReal.ImmiUnInit (var Msg: TMessage);
begin
  if ((Parent <> nil) and (Parent.Enabled) and (Parent.Visible)) then parent.SetFocus;
  param.UnInit;
end;

procedure TIMMIEditReal.ImmiUpdate (var Msg: TMessage);
begin
   if not stopupdate then
      if Param.isValid then
        text := format(Param.Format, [Param.Value])
      else text := '?????????';
end;

procedure TIMMIEditReal.OnKeyPressProc (Sender: TObject; var Key: Char);
begin
     if key = chr(13) then begin
        OnExit (sender);
        if ((Parent.Enabled) and (Parent.Visible)) then parent.SetFocus;
        //OnEnter(sender);
     end;
end;

procedure TIMMIEditReal.OnEnterProc(Sender: TObject);
begin
  if showDialog then
    with TImmiValueEntryFrm.Create(self) do
    try
      top := self.ClientToScreen(Point(0, 0)).Y - 30;
      left := self.ClientToScreen(Point(0, 0)).X;
      if (left + self.width + width > screen.width) then left := left - width
        else left := left + self.width;
      Value := Param.Value;

      minValue := param.MinValue;
      maxValue := param.MaxValue;

      if ShowModal = integer(mrOK) then
       self.text := edit1.text;
      if ((Parent <> nil) and (Parent.Enabled) and (Parent.Visible)) then self.Parent.SetFocus;
    finally
      free;
    end

  else
     StopUpdate := true;
end;

procedure TIMMIEditReal.OnExitProc(Sender: TObject);
var
   newValue: real;
begin
  try
     newValue := strtofloat(text);
  except
       if Parent.Enabled then setFocus;
        raise exception.create('Неправильное вещественное значение');
  end;
  if (newValue < param.minValue) or
               (NewValue > Param.MaxValue) then begin
        if ((Parent.Enabled) and (Parent.Visible)) then setFocus;
       raise exception.create (
                format('Значение за допустимыми пределами (min=%8.2f, max=%8.2f)',
                                                [param.minValue, param.maxValue]));
                                                abort;
  end;
  if Param.Value <> newValue then
     param.SetNewValue (NewValue);
  stopUpdate := false;
end;

procedure TIMMIEditReal.ShowPropForm;
begin
  with TEditEditorFrm.Create(nil) do begin
    Edit1.Text := param.rtName;
    Edit2.Text := param.format;
    Edit3.text := sysUtils.format('%8.2f', [param.MinValue]);
    Edit4.text := sysUtils.format('%8.2f', [param.MaxValue]);
    SpinEdit1.Value := param.Access;
    checkBox1.Checked := ShowDialog;
    if ShowModal = mrOK then begin
      param.rtName := Edit1.Text;
      param.format := Edit2.Text;
      param.Access := SpinEdit1.Value;
      ShowDialog := checkBox1.Checked;
      try
        param.MinValue := strtofloat(Edit3.text);
        param.MaxValue := strtofloat(Edit4.text);
      except
        MessageDlg('Неверное вещественное значение', mtError, [mbOK], 0);
      end;
    end;
    Free;
  end;
end;

procedure Register;
begin
  RegisterComponents('IMMICtrls', [TIMMIEditReal]);
end;

destructor TIMMIEditReal.Destroy;
begin
  fParam.Free;
  inherited;
end;

procedure TIMMIEditReal.ShowPropFormMsg(var Msg: TMessage);
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
