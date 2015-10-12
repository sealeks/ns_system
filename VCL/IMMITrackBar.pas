unit IMMITrackBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, CommCtrl, //Themes,
  constDef,
  memStructsU,
  ParamU,Expr,
  IMMITrackBEditorU;

type
  TIMMITrackBar = class(TTrackBar)
  private
    { Private declarations }

    ffillColor: Tcolor;
    fParam: TParamControl;

  protected

    { Protected declarations }
  public
    { Public declarations }
   // procedure Paint; override;

    constructor Create(AOwner: TComponent); override;
    procedure OnChangeProc(Sender: TObject);
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    //procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure ShowPropForm;
  published
    { Published declarations }
    property Param: TParamControl read fParam write fParam;
    property fillColor: Tcolor read  ffillColor write ffillColor default clGreen;


  end;

implementation

constructor TIMMITrackBar.Create(AOwner: TComponent);
begin
     inherited;
     min := 0;
     max := 10000;
     frequency := 1000;
     OnChange := OnChangeProc;
     cursor := crHandPoint;
     fParam := TParamControl.Create;
end;

procedure TIMMITrackBar.ImmiInit (var Msg: TMessage);
begin
  param.Init (Name);


end;

procedure TIMMITrackBar.ImmiUnInit (var Msg: TMessage);
begin


  param.UnInit;
end;

procedure TIMMITrackBar.ImmiUpdate (var Msg: TMessage);
var
   SaveOnChange : TNotifyEvent;
begin

      if Param.isValid then begin
        SaveOnChange := onChange;
        onChange := nil;
        position := round((Param.Value - Param.minValue) /
                             (Param.MaxValue - Param.minValue) * (max - min));
        onChange := SaveOnChange;
      end else caption := '?????????';
end;

procedure TIMMITrackBar.OnChangeProc(Sender: TObject);
var
   newValue: real;
begin
     newValue := Param.minValue + position / (max - min) * (Param.MaxValue - Param.minValue);
     if Param.Value <> newValue then
        param.SetNewValue (NewValue);
        repaint;
end;

procedure TIMMITrackBar.ShowPropForm;
begin
  with TTrackBEditorFrm.Create(nil) do begin
    Edit1.Text := param.rtName;
    Edit2.text := format('%8.2f', [param.MinValue]);
    Edit3.text := format('%8.2f', [param.MaxValue]);
    SpinEdit1.Value := param.Access;
    if ShowModal = mrOK then begin
      param.rtName := Edit1.Text;
      param.Access := SpinEdit1.Value;
      try
        param.MinValue := strtofloat(Edit2.text);
        param.MaxValue := strtofloat(Edit3.text);
      except
        MessageDlg('Неверное вещественное значение', mtError, [mbOK], 0);
      end;
    end;
    Free;
  end;

end;

{procedure TIMMITrackBar.WMPaint(var Message: TWMPaint);
var
  hdc1: HDC;
   R: TRect;
  Rgn: HRGN;
  hbrush1:  HBRUSH;
  HObj1: HGDIOBJ;
  barf: integer;
begin
inherited;
Hdc1:=GetDC(Handle);
r.Left:=5;
r.Right:=self.Width-5;
r.Top:=self.top+5;
r.Bottom:=self.height-5;
InflateRect(R, 0, 0);
hbrush1:=CreateSolidBrush(integer(ffillColor));
HObj1:=Selectobject(hDC1,hbrush1);
barf:=round(r.Left+((r.Right-r.Left)*1.0 * ((position - min) * 1.0)/((max-min)*1.0)));
Rectangle(hDC1,r.Left,r.Top, barf,r.Bottom);
DeleteObject(HObj1);
DeleteDC(hdc1);
end; }


procedure TIMMITrackBar.ShowPropFormMsg(var Msg: TMessage);
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
