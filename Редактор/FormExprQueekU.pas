unit FormExprQueekU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Grids, ColorStringGrid, ComCtrls, ToolWin, ExtCtrls;
type
   tCusG = class(TCustomGrid);
type
  TFormExprQueek = class(TForm)
    Panel7: TPanel;
    Panel12: TPanel;
    ToolBar5: TToolBar;
    ToolButton13: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ImageList7: TImageList;
    ToolButton1: TToolButton;
    StringGrid1: TColorStringGrid;
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton26Click(Sender: TObject);
    procedure ToolButton27Click(Sender: TObject);
    procedure ToolButton28Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure StringGrid1Exit(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure setEnDo;
    procedure setDo;
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormExprQueek: TFormExprQueek;

implementation
   uses mainFormRedactorU;
{$R *.dfm}

procedure TFormExprQueek.ToolButton13Click(Sender: TObject);
begin
   activred.ExprTrue:=ToolButton13.Down;
   if ToolButton13.Down then ToolButton13.ImageIndex:=1
   else ToolButton13.ImageIndex:=0;
end;

procedure TFormExprQueek.ToolButton26Click(Sender: TObject);
begin
   activred.PopMenuShowTegs(nil);
end;

procedure TFormExprQueek.ToolButton27Click(Sender: TObject);
begin
   activred.FindInExpr;
end;

procedure TFormExprQueek.ToolButton28Click(Sender: TObject);
begin
  activred.FindInExprErr;
end;

procedure TFormExprQueek.StringGrid1DblClick(Sender: TObject);
begin
  if csDesigning in StringGrid1.ComponentState then Beep;
end;

procedure TFormExprQueek.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
  var i: integer;
begin
  if not activred.IdentStrings.Find(value,i) then
  toolbutton1.Enabled:=true;
end;
procedure TFormExprQueek.StringGrid1Exit(Sender: TObject);
begin
   Beep;
end;

procedure TFormExprQueek.ToolButton1Click(Sender: TObject);
var i: integer;
begin
 activred.ReplaceExpr;
  activred.PropertyForm;
  tCusG(StringGrid1).InplaceEditor.Deselect;
  //activred.PopMenuShowTegsforForm;
  for i:=0 to StringGrid1.RowCount-1 do
  if activred.CheckExprstr(StringGrid1.Cells[0,i]) then
       StringGrid1.fRows.Items[i].font.Color:=clGreen
  else
       //StringGrid1.fRows.Items[arow].font.Color:=clRed;nd;
 // setDo;
end;

procedure TFormExprQueek.setEnDo;
begin
//toolbutton1.Enabled:=false;

end;

procedure TFormExprQueek.setDo;
var i: integer;
begin
activred.ReplaceExpr;
  //activred.PropertyForm;
  tCusG(StringGrid1).InplaceEditor.Deselect;
  //activred.PopMenuShowTegsforForm;
  for i:=0 to StringGrid1.RowCount-1 do
  if activred.CheckExprstr(StringGrid1.Cells[0,i]) then
       StringGrid1.fRows.Items[i].font.Color:=clGreen
  else
       //StringGrid1.fRows.Items[arow].font.Color:=clRed;nd;
  //setEnDo;
 // activred.PropertyForm;
end;

procedure TFormExprQueek.StringGrid1KeyPress(Sender: TObject;
  var Key: Char);
begin
if byte(key)=VK_RETURN then ToolButton1Click(nil);
end;

end.
