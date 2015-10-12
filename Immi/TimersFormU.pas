unit TimersFormU;      // Настойка таймеров

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IMMIFormU, SYButton, Spin, DB,
  DBTables, Grids, DBGrids, IMMIGridU,ConstDef, Clipbrd,IMMIEditReal,
  IMMIValueEntryU, IMMILabelFullU;

type
  TTimersForm = class(TIMMIForm)
    Bevel1: TBevel;
    seKotel: TSpinEdit;
    seGorelka: TSpinEdit;
    SYButton1: TSYButton;
    SYButton2: TSYButton;
    Label1: TLabel;
    Label2: TLabel;
    IMMIGrid1: TIMMIGrid;
    Label3: TLabel;
    Label4: TLabel;
    IMMIValueEntry1: TIMMIValueEntry;
    IMMILabelFull1: TIMMILabelFull;
    Label5: TLabel;
    Label6: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    DataSource1: TDataSource;
    QuerySet: TQuery;
    QuerySetname: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IMMIGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SYButton1Click(Sender: TObject);
    procedure SYButton2Click(Sender: TObject);
    procedure initform;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TimersForm: TTimersForm;

implementation

{$R *.dfm}


procedure TTimersForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Visible then Hide;
end;

procedure TTimersForm.FormCreate(Sender: TObject);
begin
inherited;
  top := 200;
  left :=200;
  height := 274;
  width := 465;
end;

procedure TTimersForm.FormActivate(Sender: TObject);
begin
initform;
end;

procedure TTimersForm.initform;
var msg: TMessage;
    s,i: byte;

begin
s:=QuerySet.RecordCount;
if s = 0 then exit;   // проверка на отсутствие таймеров
IMMIGrid1.RowCount:=s+1;
i:=1;
QuerySet.First;
while  i < S+1 do
        begin
        IMMIGrid1.Cells[0,i]:=QuerySetname.AsString;
        IMMIGrid1.SetObject(0,i);
        inc(i);
        QuerySet.Next;
        end;
if  label3.Caption='Пусто' then
        begin
        label3.Caption:=IMMIGrid1.Cells[0,1];
        IMMILabelFull1.iExprVal:=IMMIGrid1.Cells[0,1];
        IMMILabelFull1.ImmiInit(msg);
        IMMIValueEntry1.iparam.rtName:=IMMIGrid1.Cells[0,1];
        IMMIValueEntry1.ImmiInit(msg);
        end;
end;

procedure TTimersForm.IMMIGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var msg: TMessage;

begin
inherited;
label3.Caption:=IMMIGrid1.Cells[0,ARow];
IMMILabelFull1.iExprVal:=IMMIGrid1.Cells[0,ARow];
IMMILabelFull1.ImmiInit(msg);
IMMIValueEntry1.iparam.rtName:=IMMIGrid1.Cells[0,ARow];
IMMIValueEntry1.ImmiInit(msg);
end;

procedure TTimersForm.SYButton1Click(Sender: TObject);
var i1,i2,i3: string;
begin
  inherited;
i1:='"k'+inttostr(sekotel.Value);
i2:=i1+'g'+inttostr(segorelka.Value);
i3:='"g'+inttostr(segorelka.Value);
if (sekotel.Value > 0) and (segorelka.Value = 0) then
        begin
        with  QuerySet do
                begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT Name FROM ddeitem WHERE Name LIKE '+i1+'_tm%"');
                Open;
                initform;
                end;

        end;
if (sekotel.Value > 0) and (segorelka.Value > 0) then
        begin
        with  QuerySet do
                begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT Name FROM ddeitem WHERE Name LIKE '+i2+'_tm%"');
                Open;
                initform;
                end;
        end;
if (sekotel.Value = 0) and (segorelka.Value > 0) then
        begin
        with  QuerySet do
                begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT Name FROM ddeitem WHERE Name LIKE '+i3+'_tm%"');
                Open;
                initform;
                end;
        end;

end;

procedure TTimersForm.SYButton2Click(Sender: TObject);
begin
  inherited;
sekotel.Value := 0;
segorelka.Value := 0;
with  QuerySet do
                begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT name FROM ddeitem WHERE Name LIKE "%tm%"');
                Open;
                initform;
                end;
end;

end.
