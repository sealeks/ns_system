unit IMMIImggif;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef,
  IMMIPropertysU,Gifctrl,
  IMMIPropertysEditorU;


type

  TIMMIImggif = class(TRxGIFAnimator)
  private
    { Private declarations }
    fIMMIProp: TIMMIImggifPropertys;
    fison: boolean;

    procedure SetIsOn(const Value: boolean);
  protected
    { Protected declarations }
  public
    { Public declarations }
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
    property IMMIProp: TIMMIImgGifPropertys read fIMMIProp write fIMMIProp;
  end;

implementation

constructor TIMMIImggif.Create(AOwner: TComponent);
begin
  inherited;
  fIMMIProp := TIMMIImgGifPropertys.create(self);
  transparent := true;
  fIsOn := true;
end;

procedure TIMMIImggif.ImmiInit (var Msg: TMessage);
begin
  IMMIProp.IMMIInit;
end;

procedure TIMMIImggif.ImmiUnInit (var Msg: TMessage);
begin
  IMMIProp.IMMIUnInit;
end;

procedure TIMMIImggif.ImmiUpdate (var Msg: TMessage);
begin
  IMMIProp.IMMIUpdate;

  if (IMMIProp.State = psinvisible) or (IMMIProp.State = psBlinkInvisible) then
    visible := false
  else
  begin
    visible := true;
    isOn := (IMMIProp.State = psOn) or (IMMIProp.State = psBlinkOn);
  end;

end;

procedure TIMMIImggif.ShowPropForm(desi: TComponent);
begin
  IMMIProp.ShowPropForm(desi);
  if assigned(IMMIProp.OnImage) then
  begin
    Image.Assign(IMMIProp.OnImage);
    stretch := IMMIProp.stretch;
  end;
end;

procedure TIMMIImggif.ShowPropFormMsg(var Msg: TMessage);
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

procedure TIMMIImggif.ImmiBlinkOff(var Msg: TMessage);
begin
  IMMIProp.IMMIBlinkOff;
end;

procedure TIMMIImggif.ImmiBlinkOn(var Msg: TMessage);
begin
  IMMIProp.IMMIBlinkOn;
end;

procedure TIMMIImggif.SetIsOn(const Value: boolean);
begin
  if isOn <> value then
  begin
    fISOn := Value;
    if fIsOn then Image.assign (IMMIProp.OnImage)
      else Image.assign (IMMIProp.OffImage);
    repaint;
  end;
end;

destructor TIMMIImggif.destroy;
begin
  fIMMIProp.free;
  inherited;
end;


















end.
