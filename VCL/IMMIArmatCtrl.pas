unit IMMIArmatCtrl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef, memStructsU, SwitchKnobFormU, Switch2FormU, ParamU;


type

  TCtrlType = (ctOne, ctTwo);

  TIMMIArmatCtrl = class(TGraphicControl)
  private
    { Private declarations }
    fonParamControl, fOffParamControl: string;
    fCtrlType: TCtrlType;
    fAccess: integer;

    procedure Valve1Click;
    procedure VentClick;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Click; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    { Published declarations }

    property Caption;
    property iOnParamControl: string read fonParamControl write fOnParamControl;
    property iOffParamControl: string read foffParamControl write fOffParamControl;

    property iCtrlType: TCtrlType read fCtrlType write fCtrlType;
    property iaccess: integer read faccess write faccess;

    property OnClick;
    property ShowHint;
  end;

procedure Register;

implementation

constructor TIMMIArmatCtrl.Create(AOwner: TComponent);
begin
    inherited;
    cursor := crHandPoint;
    fCtrlType := ctOne;
end;

destructor TIMMIArmatCtrl.Destroy;
begin
    inherited;
end;

procedure TIMMIArmatCtrl.VentClick;
begin
     if not assigned (SwitchKnobForm) then
        Application.CreateForm (TSwitchKnobForm, SwitchKnobForm);

     SwitchKnobForm.IMMISpeedButton1.Param.rtName := fonParamControl;
     SwitchKnobForm.IMMISpeedButton1.Param.access := faccess;
     SwitchKnobForm.Caption := caption;
     SwitchKnobForm.Left := left + width + 5;
     SwitchKnobForm.Top := top;
     if SwitchKnobForm.Left + SwitchKnobForm.width > screen.width then
          SwitchKnobForm.Left := left - SwitchKnobForm.width - 5;
     SwitchKnobForm.Show;
end;

procedure TIMMIArmatCtrl.Valve1Click;
begin
     if not assigned (Switch2Form) then
        Application.CreateForm (TSwitch2Form, Switch2Form);

     Switch2Form.Caption := caption;

     Switch2Form.IMMISpeedButton1.Param.access := faccess;
     Switch2Form.IMMISpeedButton1.Param.rtName := foffParamControl;

     Switch2Form.IMMISpeedButton2.Param.access := faccess;
     Switch2Form.IMMISpeedButton2.Param.rtName := fonParamControl;

     Switch2Form.IMMIImage1.Param.rtName := foffParamControl;
     Switch2Form.IMMIImage2.Param.rtName := fonParamControl;


     Switch2Form.Left := left + width + 5;
     Switch2Form.Top := top;
     if Switch2Form.Left + Switch2Form.width > screen.width then
          Switch2Form.Left := left - Switch2Form.width - 5;

     Switch2Form.Show;
end;

procedure TIMMIArmatCtrl.Click;

begin
     inherited;
     case fCtrlType of
          ctOne: VentClick;
          ctTwo: Valve1Click;
     end;
end;

procedure TIMMIArmatCtrl.Paint;
begin
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

procedure Register;
begin
  //RegisterComponents('IMMIOld', [TIMMIArmatCtrl]);
end;

end.
