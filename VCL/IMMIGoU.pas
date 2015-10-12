unit IMMIGoU;
{*********************************************************
Этот компонент ничего не делает, отображается рамочкой при
разарботке, при выполнении не виден, но курсор становится
рукой.
Предназначен для перезодов с кадра на кадр.
*********************************************************}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TIMMIGo = class(TGraphicControl)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property OnClick;
  end;

procedure Register;

implementation

constructor TIMMIGo.Create(AOwner: TComponent);
begin
    inherited;
    cursor := crHandPoint;
    width := 24;
    height := 12;
end;

procedure TIMMIGo.Paint;
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
  //RegisterComponents('IMMICtrls', [TIMMIGo]);
end;

end.
