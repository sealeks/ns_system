unit IMMIImg1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef,
  IMMIPropertysU,
  IMMIPropertysEditorU, FormManager, IMMIBorder;

type
  TIMMIImageList = class(TImageList)
end;

type

  TIMMIImg1 = class(TImage)
  private
    { Private declarations }
    fIMMIProp: TIMMIImgPropertys;
    fBorder: TBorder;
    fison: boolean;
    fborderComp: TImmiBorder;
    procedure SetIsOn(const Value: boolean);
  protected
    { Protected declarations }
  public
    { Public declarations }

    procedure Loaded; override;
    property isOn: boolean read fIsOn write SetIsOn;
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ImmiBlinkOn (var Msg: TMessage); message WM_IMMIBLINKON;
    procedure ImmiBlinkOff (var Msg: TMessage); message WM_IMMIBLINKOFF;
    procedure ShowPropForm(desi: TComponent);
    procedure ShowPropFormMsg (var Msg: TMessage); message WM_IMMSHOWPROPFORM;
  published
    { Published declarations }
    property Border: TBorder read fBorder write fBorder;
    property IMMIProp: TIMMIImgPropertys read fIMMIProp write fIMMIProp;
  end;

implementation

constructor TIMMIImg1.Create(AOwner: TComponent);
begin
  inherited;
  fIMMIProp := TIMMIImgPropertys.create(self);
  fBorder:=TBorder.create;
  //transparent := true;
  fIsOn := true;
end;


procedure TIMMIImg1.Loaded;
begin
inherited;

if (fBorder.PenWidth>0) and not (csDesigning in ComponentState)and ((fIMMIProp.param.rtName<>'') OR (fIMMIProp.param.rtNamePlus<>'')
 or (fIMMIProp.PrFormManager.OpenForm.Count>0) or (fIMMIProp.PrFormManager.CloseForm.Count>0)) then
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

procedure TIMMIImg1.ImmiInit (var Msg: TMessage);
begin
  IMMIProp.IMMIInit;
 
end;

procedure TIMMIImg1.ImmiUnInit (var Msg: TMessage);
begin
  IMMIProp.IMMIUnInit;

end;

procedure TIMMIImg1.ImmiUpdate (var Msg: TMessage);
begin
  IMMIProp.IMMIUpdate;

  enabled:=IMMIProp.param.isEnabled;
  if (IMMIProp.State = psinvisible) or (IMMIProp.State = psBlinkInvisible) then
    visible := false
  else
  begin
    visible := true;
    isOn := (IMMIProp.State = psOn) or (IMMIProp.State = psBlinkOn);
  end;

end;

procedure TIMMIImg1.ShowPropForm(desi: TComponent);
begin
  IMMIProp.ShowPropForm(desi);
  if assigned(IMMIProp.OnPicture) then
  begin
    picture.Assign(IMMIProp.OnPicture);
    stretch := IMMIProp.stretch;
  end;
end;

procedure TIMMIImg1.ShowPropFormMsg(var Msg: TMessage);
begin
  IMMIUninit(Msg);
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

procedure TIMMIImg1.ImmiBlinkOff(var Msg: TMessage);
begin
  IMMIProp.IMMIBlinkOff;

end;

procedure TIMMIImg1.ImmiBlinkOn(var Msg: TMessage);
begin
  IMMIProp.IMMIBlinkOn;

end;

procedure TIMMIImg1.SetIsOn(const Value: boolean);
begin
  if isOn <> value then
  begin
    fISOn := Value;
    if fIsOn then picture.assign (IMMIProp.OnPicture)
      else picture.assign (IMMIProp.OffPicture);
    repaint;
  end;
end;



destructor TIMMIImg1.destroy;
begin
  fIMMIProp.free;
  //if fborderComp<>nil then fborderComp.free;
  fBorder.free;

  inherited;
end;

end.
