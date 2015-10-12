unit frmTegListU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, memStructsU, ParamU, math;

type
  TfrmTegList = class(TForm)
    StringGrid2: TStringGrid;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RequestedTegs: TList;
  end;

var
  frmTegList: TfrmTegList;

implementation

{$R *.dfm}

procedure TfrmTegList.FormCreate(Sender: TObject);
begin
 RequestedTegs := nil;
 with stringGrid2 do
 begin
   cells[0, 0] := '№';
   cells[1, 0] := 'ID';
   cells[2, 0] := 'Тег';
   cells[3, 0] := 'Значение';
   cells[4, 0] := 'Состояние';
 end;
end;

procedure TfrmTegList.Timer1Timer(Sender: TObject);
 var
  i, linknum, ID: integer;
  LinkNumStr: String;
begin
 if RequestedTegs = nil then exit;

 StringGrid2.RowCount := max(2, RequestedTegs.Count + 1);
 if StringGrid2.RowCount = 2 then
   for i := 0 to StringGrid2.ColCount - 1 do StringGrid2.cells[i, 1] := '';
 with StringGrid2 do
 for i := topRow - 1 to topRow + VisibleRowCount - 2 do
   begin
     if i >= RequestedTegs.Count then break;
     cells[0, i + 1] := inttostr(i);
     ID := rtItems.GetSimpleID(TParam(RequestedTegs[i]).rtName);
     cells[1, i + 1] := inttostr(ID);
     cells[2, i + 1] := TParam(RequestedTegs[i]).rtName;
     cells[3, i + 1] := floattostr(rtItems[ID].ValReal);
   end;
end;

procedure TfrmTegList.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TfrmTegList.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

end.
