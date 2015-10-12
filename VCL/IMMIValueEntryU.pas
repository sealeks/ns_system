unit IMMIValueEntryU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, controls, Dialogs, Forms,
  ExtCtrls,IMMIBorder,
  constDef, memStructsU, ParamU, IMMIValueEntryFrmU;

type

  TIMMIValueEntry = class(TGraphicControl)
  private
    { Private declarations }
    fparam: TParamControlEdit;
    fborderComp: TImmiBorder;
    fBorder: TBorder;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Click; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm;


    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure Loaded; override;
  published
    { Published declarations }

    property iparam: TParamControlEdit read fParam write fParam;
    property Border: TBorder read fBorder write fBorder;
    property Enabled;
  end;

implementation

constructor TIMMIValueEntry.Create(AOwner: TComponent);
begin
     inherited;
     fparam := TParamControlEdit.Create;
     fBorder:=TBorder.create;
     if Enabled then
       cursor := crHandPoint;
     width := 24;
     height := 24;
end;

procedure TIMMIValueEntry.Loaded;
begin
inherited;
if (fBorder.PenWidth>0) and not (csDesigning in ComponentState) then
  begin
    fborderComp:=TImmiBorder.create(application);
    fborderComp.parent:=self.parent;
    fbordercomp.EnterColor:= fborder.EnterColor;
   // fbordercomp.ExprBlk:= fborder.ExprBlk;
   // fbordercomp.ExprOn:= fborder.ExprOn;
    fbordercomp.OutColor:= fborder.OutColor;
   // fbordercomp.OnColor:= fborder.OnColor;
   // fbordercomp.OffColor:= fborder.OffColor;
    fbordercomp.BlkColor:= fborder.BlkColor;
    fbordercomp.BorderType:= fborder.BorderType;
    fbordercomp.PenWidth:= fborder.PenWidth;
    fbordercomp.mousecontrol:=self;
  end;

end;

procedure TIMMIValueEntry.Click;
begin
 if Enabled then
  with TImmiValueEntryFrm.Create(self) do
    try
      Value := iParam.Value;

      minValue := iparam.MinValue;
      maxValue := iparam.MaxValue;

      if ShowModalAt(self) = integer(mrOK) then
        iParam.Value := Value;
    finally
      free;
    end;
end;

procedure TIMMIValueEntry.ImmiInit(var Msg: TMessage);
begin
  if iParam.rtName <> '' then Enabled := true
  else Enabled := false;
  iparam.Init('¬вод значени€');

end;

procedure TIMMIValueEntry.ImmiUnInit(var Msg: TMessage);
begin
    iparam.UnInit;
end;

procedure TIMMIValueEntry.ShowPropForm;
begin
  fParam.ShowPropForm;
end;


procedure TIMMIValueEntry.Paint;
begin
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

destructor TIMMIValueEntry.Destroy;
begin
  fParam.Free;
  fBorder.free;
  inherited;
end;

procedure TIMMIValueEntry.ShowPropFormMsg(var Msg: TMessage);
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

