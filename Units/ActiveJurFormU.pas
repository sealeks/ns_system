unit ActiveJurFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImmiFormU, dxCore, dxButton, ImmibuttonXp, Grids,
  ColorStringGrid, IMMIEventActive, ExtCtrls, IMMIPanelU, IMMIformx;

type
  TActiveJurForm = class(TForm)
    IMMIPanel2: TIMMIPanel;
    ImmiButtonXp2: TImmiButtonXp;
    IMMIEventActive1: TIMMIEventActive;
    IMMIFormExt1: TIMMIFormExt;
    procedure ImmiButtonXp2Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure ImmiButtonXp1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ActiveJurForm: TActiveJurForm;

implementation

{$R *.dfm}

procedure TActiveJurForm.ImmiButtonXp2Click(Sender: TObject);
begin
self.close;
IMMIEventActive1.isstop:=true;
end;

procedure TActiveJurForm.FormClick(Sender: TObject);
begin
self.borderstyle:=bsSizeable;
end;

procedure TActiveJurForm.ImmiButtonXp1Click(Sender: TObject);
begin
//IMMIEventActive1.isstop:= not IMMIEventActive1.isstop;
//if IMMIEventActive1.isstop then
   //ImmiButtonXp1.caption:='Пуск' else ImmiButtonXp1.caption:='Стоп';
end;

end.
