unit SelectAppFormU;

interface

uses
  Windows, Messages, SysUtils,MemStructsU, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TSelectAppForm = class(TForm)
    Panel2: TPanel;
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Button3: TButton;

    procedure ListBox1DblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

    { Private declarations }
  public
     rtit: TAnalogMems;
     procedure show();  overload;
     procedure show(filter: string);  overload;
    { Public declarations }
  end;

var
  SelectAppForm: TSelectAppForm;

implementation

{$R *.dfm}

procedure TSelectAppForm.ListBox1DblClick(Sender: TObject);
begin
  button1.Click;
end;

procedure TSelectAppForm.show();
var i: integer;
begin
  ListBox1.Items.BeginUpdate;
  for i:=0 to rtIt.Count - 1 do
      if rtIt[i].ID <> -1 then
       if (trim(edit1.Text)='') or (pos(trim(edit1.Text),trim(rtIt.GetName(i)))>0) then
        ListBox1.AddItem (rtIt.GetName(i), nil);
        ListBox1.MultiSelect := false;
        ListBox1.Sorted := true;
  ListBox1.Items.EndUpdate;
end;

procedure TSelectAppForm.show(filter: string);
var i: integer;
begin
  ListBox1.Items.BeginUpdate;
  self.Edit1.Text:=filter;
  for i:=0 to rtIt.Count - 1 do
      if rtIt[i].ID <> -1 then
       if (trim(edit1.Text)='') or (pos(trim(edit1.Text),trim(rtIt.GetName(i)))>0) then
        ListBox1.AddItem (rtIt.GetName(i), nil);
        ListBox1.MultiSelect := false;
        ListBox1.Sorted := true;
        ListBox1.Items.EndUpdate;

end;

procedure TSelectAppForm.FormResize(Sender: TObject);
var
  i, MaxItemLength: integer;
begin
  MaxItemLength := 0;
  for i := 0 to ListBox1.Items.Count - 1 do
    if MaxItemLength < length(ListBox1.Items[i]) then
        maxItemLength := length(ListBox1.Items[i]);
  ListBox1.Columns := trunc(ListBox1.Width / ((MaxItemLength + 5) * 5));
end;

procedure TSelectAppForm.Button3Click(Sender: TObject);
begin
self.ListBox1.Clear;
self.show;
end;

end.
