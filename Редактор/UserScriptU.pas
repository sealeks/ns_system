unit UserScriptU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, AppImmi;

type
  TUserScript = class(TForm)
    Edit1: TEdit;
    ComboBox1: TComboBox;
    RichEdit1: TRichEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox2: TComboBox;

    function Execute(methCom: TMethodInform; asc:TApplicationImmi): boolean;
    procedure sets;
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RichEdit1Change(Sender: TObject);
  private
     methComp: TMethodInform;
     canc: boolean;
    ascp:TApplicationImmi;
    funcproc: boolean;
    nameF: string;
    decl: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserScript: TUserScript;

implementation

{$R *.dfm}

function TUserScript.Execute(methCom: TMethodInform; asc:TApplicationImmi): boolean;
begin
 result:=true;
 if methCom=nil then exit;
 if methCom.MethodType<>mkSimpleFunc then exit;
 self.ComboBox2.Items.Clear;
 if asc<>nil then self.ComboBox2.Items.AddStrings(asc.TypeList);
  methComp:=methCom;
  ascp:=asc;
  funcproc:=methComp.procfunc;
  nameF:=methComp.MethodName;
  decl:= methComp.MethodDecl;
  sets;
  self.ShowModal;
  result:=canc;
end;

procedure TUserScript.sets;
begin
   Edit1.Text:=methComp.MethodName;
  // Label1.Visible:=methComp.procfunc;
  // Combobox2.Visible:=methComp.procfunc;
   if methComp.procfunc then
    begin
    Combobox1.Text:='function';
    if combobox2.Items.IndexOf(trim(methComp.resultf))>-1 then
      combobox2.Text:=trim(methComp.resultf) else
     combobox2.Text:=trim('BOOLEAN');
    label2.visible:=true;
    combobox2.visible:=true;
    end
    else
    begin
     Combobox1.Text:='procedure';
     label2.visible:=false;
     combobox2.visible:=false;
    end;
    Edit1Change(nil);

end;

procedure TUserScript.ComboBox1Change(Sender: TObject);
begin
if self.ComboBox1.Text='procedure' then methComp.procfunc:=false else
        methComp.procfunc:=true;
        sets;
end;

procedure TUserScript.Edit1Change(Sender: TObject);
var k: integer;
begin
k:=ascp.methodList.IndexOf(Edit1.Text);
button2.Enabled:= not ( (k>-1) and (ascp.methodList.Objects[k]<>methComp));
end;

procedure TUserScript.Button2Click(Sender: TObject);
begin
   // methComp.procfunc:=funcproc;
   methComp.resultf:=trim(self.ComboBox2.Text);
  methComp.MethodName:=edit1.Text;
  methComp.MethodDecl:=trimright(self.RichEdit1.Text);
    canc:=true;
    Modalresult:=mrOk;
end;

procedure TUserScript.Button1Click(Sender: TObject);
begin
  methComp.procfunc:=funcproc;
  methComp.MethodName:=nameF;
  methComp.MethodDecl:=decl ;
   canc:=false;
   Modalresult:=mrCancel;
end;

procedure TUserScript.RichEdit1Change(Sender: TObject);
begin
  methComp.MethodDecl:=trimright(richedit1.Text);
  
end;

end.
