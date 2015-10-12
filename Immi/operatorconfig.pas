unit operatorconfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,math,
  Dialogs, Grids, ComCtrls, ToolWin, memstructsU;

type
  TFormOperatorConf = class(TForm)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    StringGrid1: TStringGrid;
    ToolButton3: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    { Private declarations }
    selectcol: integer;
    selectid: integer;
  public
    procedure showW;
    procedure Fills;
    { Public declarations }
  end;

var
  FormOperatorConf: TFormOperatorConf;

implementation

{$R *.dfm}

procedure TFormOperatorConf.showW;
begin
Fills;
showmodal;
end;

procedure TFormOperatorConf.Fills;
var i: integer;
begin
   self.StringGrid1.Cells[0,0]:='id';
   self.StringGrid1.Cells[1,0]:='Имя';
   self.StringGrid1.Cells[2,0]:='Уровень доступа';
   self.StringGrid1.RowCount:=max(1,rtitems.oper.Count+1);
    for i:=0 to  rtitems.oper.Count-1 do
      begin
        if  rtitems.oper.Items[i].id>-1 then
        begin
        self.StringGrid1.Cells[0,i+1]:= inttostr(rtitems.oper.Items[i].id);
        self.StringGrid1.Cells[1,i+1]:=trim(rtitems.oper.GetName(i));
        self.StringGrid1.Cells[2,i+1]:=inttostr(rtitems.oper.Items[i].accesslevel);
        end
      end;
end;

procedure TFormOperatorConf.ToolButton1Click(Sender: TObject);
var i: integer;
begin
 rtitems.oper.AddUser;
 fills;

end;

procedure TFormOperatorConf.ToolButton2Click(Sender: TObject);
begin
if selectid>-1 then
 rtitems.oper.RemoveUser(selectid);
 fills;
 selectid:=-1;
end;

procedure TFormOperatorConf.ToolButton3Click(Sender: TObject);
begin
  modalresult:=mrOk;
end;

procedure TFormOperatorConf.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  selectcol:=arow;
  selectid:=strtointdef(StringGrid1.Cells[0,arow],-1);
end;

procedure TFormOperatorConf.FormCreate(Sender: TObject);
begin
selectcol:=-1;
selectid:=-1;
end;

procedure TFormOperatorConf.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if selectid>-1 then
 if acol=1 then
   rtitems.oper.RenameUser(selectid,value);
  if (acol=2) and (strtointdef(Value,-1)>-1) then
   rtitems.oper.setAUser(selectid,strtointdef(Value,-1));
end;

end.
