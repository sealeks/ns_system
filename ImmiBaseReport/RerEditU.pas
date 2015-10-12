unit RerEditU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus;

type
  TRepEdit = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    RichEdit1: TMemo;
    RichEdit2: TMemo;
    procedure N1Click(Sender: TObject);
    procedure RichEdit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function EditRep(RepN: String; name: string): integer;
    procedure RebildCom;
  end;



implementation

Uses UnitExpr,
 memStructsU;
{$R *.dfm}

function TRepEdit.EditRep(RepN: String; name: string): integer;
begin
    self.RichEdit1.Lines.Clear;
    self.RichEdit2.Lines.Clear;
    self.Label1.Caption:=RepN;
    if (FileExists(name)) then
     try
       self.RichEdit1.Lines.LoadFromFile(name);
       RebildCom;
     except
     end;
    result:=self.ShowModal;
end;

procedure TRepEdit.N1Click(Sender: TObject);
var FE: TFormExpr;
    tg: string;
begin
 try
 FE:=TFormExpr.Create(self);
 if FE.Execute(tg)
 then
 RichEdit1.Lines.Add(tg)
 finally
 FE.Free;
 end;
end;

procedure TRepEdit.RebildCom;
var i: integer;
begin
 if rtitems=nil then exit;
   while (RichEdit2.Lines.Count<RichEdit1.Lines.Count) do RichEdit2.Lines.Add('');

 for i:=0 to RichEdit1.Lines.Count-1 do
  if (rtitems.GetID(trim(RichEdit1.Lines.Strings[i]))<0) then
    RichEdit2.Lines.Strings[i]:='!!! Îøèáêà'
  else
    RichEdit2.Lines.Strings[i]:=rtitems.GetComment(rtitems.GetID(trim(RichEdit1.Lines.Strings[i])));
end;

procedure TRepEdit.RichEdit1Change(Sender: TObject);
begin
   RebildCom;
end;

end.
