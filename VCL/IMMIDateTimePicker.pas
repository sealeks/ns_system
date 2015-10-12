unit IMMIDateTimePicker;

interface

uses
  SysUtils, Classes, Controls, ComCtrls, Messages, expr, paramu, constdef, dialogs;

type
  TIMMIDateTimePicker = class(TDateTimePicker)
  private
    { Private declarations }
    fparamDateTime: TParamControl;
    fparamDateTimeStr: TExprStr;
  protected
    { Protected declarations }
    procedure Change; override;
  public
    { Public declarations }
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUpdate;
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
  published
    { Published declarations }
    property paramDateTime: TExprStr read fParamDateTimeStr write fParamDateTimeStr;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('IMMIJurnal', [TIMMIDateTimePicker]);
end;

{ TIMMIDateTimePicker }

procedure TIMMIDateTimePicker.Change;
begin
  inherited;
  if assigned(fParamDateTime) then fParamDateTime.SetNewValue(DateTime)
end;

constructor TIMMIDateTimePicker.create(AOwner: TComponent);
begin
  inherited;
end;

destructor TIMMIDateTimePicker.destroy;
begin
  fParamDateTime.free;
  inherited;
end;

procedure TIMMIDateTimePicker.ImmiInit(var Msg: TMessage);
begin
  CreateAndInitParamControl(fParamDateTime, fParamDateTimeStr);
  change;
end;

procedure TIMMIDateTimePicker.ImmiUnInit(var Msg: TMessage);
begin
    fParamDateTime.UnInit;
end;

procedure TIMMIDateTimePicker.ImmiUpdate(var Msg: TMessage);
begin
  if assigned(fParamDateTime) then
  begin
    fParamDateTime.ImmiUpdate;
    if fParamDateTime.Value <> DateTime then dateTime := fParamDateTime.Value;
  end;
end;

end.
