unit FormNewVarU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,AppImmi;

type
  TFormNewVar = class(TForm)
    Edit1: TEdit;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    canc: boolean;
    ascp:TApplicationImmi;
    nameV: string;
    typeV: string;
    decl: string;
    posV: integer;
    { Private declarations }
  public
     function Execute(var name: string; asc:TApplicationImmi): boolean;
     procedure Gets;
    { Public declarations }
  end;

var
  FormNewVar: TFormNewVar;



implementation

{$R *.dfm}

function TFormNewVar.Execute(var name: string; asc:TApplicationImmi): boolean;
begin
 result:=true;
 ascp:=asc;
 if asc=nil then
    begin
      result:=false;
      exit;
    end;
   posV:=TApplicationImmi(ascp).variableList.IndexOf(name);
  decl:=name;
  self.ComboBox1.Items.Clear;
  self.ComboBox1.Items.Text:=TApplicationImmi(ascp).TypeList.Text;
  Gets;
  if self.ShowModal=MrOk then name:=decl;
  result:=canc;
end;

procedure TFormNewVar.Gets;
var inx: integer;
    varS, TypS: string;
begin
   inx:=TApplicationImmi(ascp).variableList.IndexOf(decl);
   if pos(':',decl)<>0 then
    begin
      nameV:=trim(copy(decl,1,pos(':',decl)-1));
      typeV:=trim(copy(decl,pos(':',decl)+1,length(decl)-1));
      inx:=TApplicationImmi(ascp).TypeList.IndexOf(trim(typeV));
      if inx<0 then typeV:='boolean';

      self.ComboBox1.Text:= typeV;
      Edit1.Text:=NameV;
     // self.ComboBox1.Text:=typeV;
      decl:=nameV+': '+typeV;

    end;
end;

procedure TFormNewVar.ComboBox1Change(Sender: TObject);
begin
decl:=NameV+': '+combobox1.Text;
Gets;
end;

procedure TFormNewVar.Button1Click(Sender: TObject);
begin
 canc:=true;
 if posV=-1 then
   TApplicationImmi(ascp).variableList.Add(decl)
 else  TApplicationImmi(ascp).variableList.Strings[posV]:=decl;
 ModalResult:=MrOk;
end;

procedure TFormNewVar.Button2Click(Sender: TObject);
begin
 canc:=false;
 ModalResult:=MrNo;
end;

procedure TFormNewVar.Edit1Change(Sender: TObject);
begin
if (TApplicationImmi(ascp).findVar(edit1.Text)=posV)
 or (TApplicationImmi(ascp).findVar(edit1.Text)<0) then
   begin
     NameV:=self.Edit1.Text;
     decl:=NameV+': '+combobox1.Text;
   end;
Button1.Enabled:=(TApplicationImmi(ascp).findVar(edit1.Text)=posV)
 or (TApplicationImmi(ascp).findVar(edit1.Text)<0);
end;

end.
