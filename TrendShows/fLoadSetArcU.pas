unit fLoadSetArcU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfLoadSetArc = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowingA(var setupName: string): boolean;
  end;

var
  fLoadSetArc: TfLoadSetArc;

implementation


uses fTrendU;
{$R *.dfm}

function TfLoadSetArc.ShowingA(var setupName: string): boolean;
var i: integer;
begin
  if not FileExists(fTrend.BaseDir+'ArcSettin.arc') then

  FileClose(FileCreate(fTrend.BaseDir+'ArcSettin.arc'));
  ListBox1.Items.LoadFromFile(fTrend.BaseDir+'ArcSettin.arc');
  if ShowModal=MrOk then
    begin
      ListBox1.Items.SaveToFile(fTrend.BaseDir+'ArcSettin.arc');
      setupname:='';
      for i:=0 to  ListBox1.Items.Count-1 do
         if ListBox1.Selected[i] then setupname:=ListBox1.Items.Strings[i];
      result:=true;
      if  setupname='' then result:=false;
    end else result:=false;
end;


procedure TfLoadSetArc.Button2Click(Sender: TObject);
var i: integer;
begin
i:=0;
if MessageBox(0,'Удалить настройку?','Удаление настройки',MB_YESNO)=IDYES then
begin
        while i< ListBox1.Items.Count do
         if ListBox1.Selected[i] then ListBox1.Items.Delete(i) else inc(i);
ListBox1.Items.SaveToFile(fTrend.BaseDir+'ArcSettin.arc');
end;
end;

end.
