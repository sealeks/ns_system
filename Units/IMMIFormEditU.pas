unit IMMIFormEditU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  IMMIFormU, ConstDef, IMMIImg;

type
  TIMMIFormEdit = class(TIMMIForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    StartDragPoint: TPoint;
    Selected: TControl;
    FDefClientProc: TFarProc;
    FClientInstance: TFarProc;
    procedure ClientWndProc(var Message: TMessage);
  public
    { Public declarations }
    procedure IMMIEditForm (var msg: TMessage); message WM_IMMIEDITFORM;
    procedure IMMIRunForm (var msg: TMessage); message WM_IMMIRUNFORM;
    procedure IMMISaveForm (var msg: TMessage); message WM_IMMISaveFORM;
    procedure ControlDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ControlOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;

  TEditControl = class (TControl);
var
  IMMIFormEdit: TIMMIFormEdit;

implementation

{$R *.dfm}

{ TIMMIFormEdit }

procedure TIMMIFormEdit.IMMIEditForm(var msg: TMessage);
var
  i: integer;
begin
  for i := 0 to ControlCount - 1 do
  begin
//    if Controls[i] is TImage then
//    begin    TControl
//      (Controls[i] as TImage).OnDragOver := ControlDragOver;
       TEditControl(Controls[i]).OnMouseDown := ControlOnMouseDown;
       TEditControl(Controls[i]).SetDesigning(true);
       TEditControl(Controls[i]).repaint;
//    end;
  end;
//  OnDragOver := ControlDragOver;
//  OnMouseDown := ControlOnMouseDown;
end;

procedure TIMMIFormEdit.IMMIRunForm(var msg: TMessage);
begin

end;

procedure TIMMIFormEdit.IMMISaveForm(var msg: TMessage);
begin

end;

procedure TIMMIFormEdit.ControlOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

{  inherited;
  Selected := Sender as TControl;
  StartDragPoint.X := X;
  StartDragPoint.y := Y;
  if Sender is TImage then
  begin
   (Sender as TImage).BeginDrag(true);
  end;}
end;



procedure TIMMIFormEdit.ControlDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  if sender <> self then
  begin
    (Source as TControl).left :=
      (Sender as TControl).ClientToParent (Point(x, Y), Self).X - StartDragPoint.X;
    (Source as TControl).Top :=
      (Sender as TControl).ClientToParent (Point(x, Y), Self).Y - StartDragPoint.Y;
  end else
  begin
    (Source as TControl).left := X - StartDragPoint.X;
    (Source as TControl).Top := Y  - StartDragPoint.Y;
  end;
   accept := true;
end;

procedure TIMMIFormEdit.ClientWndProc(var Message: TMessage);

begin
  with Message do
      Result := CallWindowProc(FDefClientProc, Handle, Msg, wParam, lParam);
{  with Message do
    case Msg of
      WM_Paint :
        if Selected <> nil then
          with selected, canvas do
          begin
            Pen.Style := psDash;
            Brush.Style := bsClear;
    	    Rectangle(Left, Top, Left + width, Top + Height);
	  end;
    end;}
end;


procedure TIMMIFormEdit.FormCreate(Sender: TObject);
begin
  FClientInstance := Classes.MakeObjectInstance(ClientWndProc);
  FDefClientProc := Pointer(GetWindowLong(Handle, GWL_WNDPROC));
  SetWindowLong(Handle, GWL_WNDPROC, Longint(FClientInstance));
  inherited;
end;

end.


