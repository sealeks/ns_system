unit ImmiAppEvnts;

interface

uses controls, classes, stdctrls, messages, sysUtils, Forms, Graphics,
     constDef, Expr, IMMILabelEditorU, dialogs, IMMIPropertysU, windows, AppEvnts;



type
   TImmiAppEvents = class(TApplicationEvents)
   private
   fOnKeyEvent: TKeyPressEvent;
   public
     constructor Create(Aowner: TComponent); override;
   published
   procedure OnMess(Var Msg: tagMsg; var Handled: boolean);
   property OnKeyEvent: TKeyPressEvent read fOnKeyEvent write  fOnKeyEvent;
end;

procedure Register;

implementation

constructor TImmiAppEvents.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  if not (csDesigning in ComponentState) then
    OnMessage:=OnMess;
end;

procedure TImmiAppEvents.OnMess(Var Msg: tagMsg; var Handled: boolean);
var i: TObject;
    j: char;
    k: byte;
begin
   k:=msg.wParam;;
   j:=char(k);
   if (MSg.message=WM_KEYDOWN) and assigned(fOnKeyEvent) then OnKeyEvent(i,j);
     inherited;
end;

procedure Register;
begin
  RegisterComponents('IMMISample', [TImmiAppEvents]);
end;

end.