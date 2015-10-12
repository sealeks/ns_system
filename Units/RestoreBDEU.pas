unit RestoreBDEU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ConstDef,Buttons, DB, DBTables,fLoadU;

type
  TRestoreBDE = class(TForm)
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    ListBox1: TListBox;
    Timer1: TTimer;
    Image1: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
   
    procedure WorkTabale(tb: string;namebase: string);
    { Public declarations }
  end;

var
  RestoreBDE: TRestoreBDE;



implementation





procedure TRestoreBDE.WorkTabale(tb: string;namebase: string);
begin

  Panel3.Caption:='Идет проверка таблицы';
  Panel4.Caption:=tb;
   RestoreBDE.Show;
  self.Repaint;

  Application.ProcessMessages;
  KPdxRepair1.DatabaseName:=NameBase;

   if not KPdxRepair1.CheckTable(tb) then
 begin
    ListBox1.AddItem(tb +' неисправен',nil);
    Panel3.Caption:='Восстановливается таблица';
       if KPdxRepair1.RepairTable(tb) then
          ListBox1.AddItem('     В   ' + tb +'  восстановление проведено',nil) else
                ListBox1.AddItem('     В   ' + tb +'  восстановление не удалось',nil)
     end
  else ListBox1.AddItem('В   ' + tb +'   ошибок не обнаружено',nil);
  self.Repaint;
  Application.ProcessMessages;

end;

{$R *.dfm}

procedure TRestoreBDE.FormCreate(Sender: TObject);
begin
self.Timer1.Enabled:=false;
end;

procedure TRestoreBDE.Timer1Timer(Sender: TObject);
begin
ModalResult:=MrOk;
end;






end.
