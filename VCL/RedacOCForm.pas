unit RedacOCForm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, FormManager, Spin;

type
  TOKBottomDlgForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    SpinEdit1: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Label71: TLabel;
    Label79: TLabel;
    ComboBox2: TComboBox;
    Label68: TLabel;
    CheckBox4: TCheckBox;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure UpDateUst(Root: TComponent);
    procedure CheckBox2Click(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
      valueF: TFormManager;
    { Private declarations }
  public
   function Execute(Root: TComponent;var value: TFormManager): integer;
    { Public declarations }
  end;

var
  OKBottomDlgForm: TOKBottomDlgForm;

implementation
{$R *.dfm}

function  TOKBottomDlgForm.Execute(Root: TComponent;var value: TFormManager): integer;
var i: integer;
begin
valueF:=value;
      ListBox1.Clear;
      ListBox1.Items.AddStrings(value.OpenForm);
      ListBox2.Clear;
      ListBox2.Items.AddStrings(value.CloseForm);

if Root<>nil then
  begin
    for i:=0 to Root.ComponentCount-1 do
      if ((Root.Components[i] is TForm) and
           (ListBox1.Items.IndexOf((Root.Components[i] as TForm).Caption)<0) and
               (ListBox2.Items.IndexOf((Root.Components[i] as TForm).Caption)<0))
      then self.ListBox3.Items.Add((Root.Components[i] as TForm).Caption)
  end;
 CheckBox1.Checked:=valuef.ShowMod;
 CheckBox2.Checked:=valuef.NotCloseModal;
 CheckBox3.Checked:=valuef.CaverModal;
 CheckBox4.Checked:=valuef.ClickManagment;
 if (valuef.FPosition.FormTop<0) or (valuef.FPosition.FormLeft<0) then
           Combobox2.ItemIndex:=1;
 spinedit1.Value:=valuef.FPosition.Formleft;
 spinedit3.Value:=valuef.FPosition.FormTop;
 result:=ShowModal;
end;


procedure TOKBottomDlgForm.SpeedButton2Click(Sender: TObject);
var i: integer;
begin
i:=0;
while i<ListBox3.Items.Count do
begin
 if ((Listbox3.Selected[i]) and  (Listbox1.Items.IndexOf(Listbox3.Items[i])<0) and (Listbox2.Items.IndexOf(Listbox3.Items[i])<0)) then
  begin
  listbox1.Items.Add(Listbox3.Items[i]);
  listbox3.Items.Delete(i);
  end;
inc(i);  
end;
end;

procedure TOKBottomDlgForm.SpeedButton4Click(Sender: TObject);
var i: integer;
begin
i:=0;
while i<ListBox3.Items.Count do
begin
 if ((Listbox3.Selected[i]) and  (Listbox1.Items.IndexOf(Listbox3.Items[i])<0) and (Listbox2.Items.IndexOf(Listbox3.Items[i])<0)) then
 begin
  listbox2.Items.Add(Listbox3.Items[i]);
  listbox3.Items.Delete(i);

 end;
inc(i);
end;
end;

procedure TOKBottomDlgForm.SpeedButton1Click(Sender: TObject);
var i: integer;
begin
i:=0;
while i<ListBox1.Items.Count do
 if (Listbox1.Selected[i]) then
 begin
 Listbox3.Items.Add(Listbox1.Items[i]);
 Listbox1.Items.Delete(i)
 end
 else inc(i);
//UpDateUst;
end;

procedure TOKBottomDlgForm.SpeedButton3Click(Sender: TObject);
var i: integer;
begin
i:=0;
while i<ListBox2.Items.Count do
 if (Listbox2.Selected[i]) then
 begin
 Listbox3.Items.Add(Listbox2.Items[i]);
 Listbox2.Items.Delete(i)
 end
 else inc(i);
//UpDateUst;
end;

procedure TOKBottomDlgForm.OKBtnClick(Sender: TObject);
begin
valueF.OpenForm.Clear;
valueF.CloseForm.Clear;
valuef.OpenForm.AddStrings(Listbox1.Items);
valuef.CloseForm.AddStrings(Listbox2.Items);
valuef.ClickManagment:=CheckBox4.Checked;
valuef.ShowMod:=CheckBox3.Checked;
valuef.NotCloseModal:=CheckBox2.Checked;
valuef.CaverModal:=CheckBox3.Checked;
valuef.FPosition.FormLeft:=self.SpinEdit3.Value;
valuef.FPosition.FormTop:=self.SpinEdit1.Value;
ModalResult:=MrOk;
end;

procedure TOKBottomDlgForm.CancelBtnClick(Sender: TObject);
begin
valueF:=nil;
ModalResult:=MrNo;
end;

procedure TOKBottomDlgForm.FormCreate(Sender: TObject);
begin
self.CheckBox1.Checked:=false;
self.CheckBox2.Checked:=false;
end;

procedure TOKBottomDlgForm.CheckBox1Click(Sender: TObject);
begin
//UpDateUst
end;

procedure TOKBottomDlgForm.UpDateUst;
begin
if ListBox1.Items.Count=0 then
begin
  CheckBox1.Enabled:=false;
   CheckBox1.Checked:=false;
end
  else  CheckBox1.Enabled:=true;
if ((ListBox2.Items.Count=0)) then
   begin
    CheckBox2.Enabled:=false;
    CheckBox2.Checked:=false;
   end
else
    CheckBox2.Enabled:=true;
end;

procedure TOKBottomDlgForm.CheckBox2Click(Sender: TObject);
begin
//UpDateUst;
end;



procedure TOKBottomDlgForm.SpinEdit3Change(Sender: TObject);
begin
if (SpinEdit3.value<0) or (SpinEdit1.value<0) then  ComboBox2.itemindex:=1 else ComboBox2.itemindex:=0;
end;

procedure TOKBottomDlgForm.ComboBox2Change(Sender: TObject);
begin
 if ComboBox2.itemindex=1 then
   begin
     SpinEdit3.value:=-1;
     SpinEdit1.value:=-1;
   end else
   begin
     if  SpinEdit3.value<0 then SpinEdit3.value:=1;
     if  SpinEdit1.value<0 then SpinEdit1.value:=1;
   end;
end;

end.
