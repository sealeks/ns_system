unit OperatorRegU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ImmiValueEntryFrmU, Memstructsu, LoginError;

type
  TOperatorReg = class(TForm)
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Edit1Enter(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    curid: integer;
    { Private declarations }
  public
     procedure showW;
    procedure Fills;
    { Public declarations }
  end;

var
  OperatorReg: TOperatorReg;

implementation

{$R *.dfm}

procedure TOperatorReg.showW;
begin
   Fills;
   edit1.OnEnter:=self.Edit1Enter;
   Showmodal;
end;

procedure TOperatorReg.Fills;
var i: integer;
begin
  self.ComboBox1.Items.Clear;
  for i:=0 to rtitems.oper.Count-1 do
    if (rtitems.oper.items[i].id>-1) and
    (rtitems.oper.usCur<>rtitems.oper.items[i].id)
    then self.ComboBox1.Items.Add(rtitems.oper.items[i].name);
  //  self.ComboBox1.Text:=rtitems.oper.GetName(rtitems.oper.usCur);
  button1.Enabled:=(rtitems.oper.usCur>-1);
  edit1.Text:='';
  curid:=rtitems.oper.usCur;
end;

procedure TOperatorReg.Edit1Enter(Sender: TObject);
begin
  with TImmiValueEntryFrm.Create(self) do
    try
      top := self.ClientToScreen(Point(0, 0)).Y - 30;
      left := self.ClientToScreen(Point(0, 0)).X;
      if (left + self.width + width > screen.width) then left := left - width
        else left := left + self.width;
      Value := 0;

      minValue := Low(Integer);
      maxValue := High(integer);
      Edit1.PasswordChar := '*';
      if ShowModal = integer(mrOK) then
       (sender as TEdit).text := edit1.text;
    //  SetFocus;
    finally
      free;
    end
end;

procedure TOperatorReg.ComboBox1Change(Sender: TObject);
begin
  button1.Enabled:=(self.ComboBox1.ItemIndex>-1);
  curid:=rtitems.oper.GetSimpleID(self.ComboBox1.Text)
end;

procedure TOperatorReg.Button1Click(Sender: TObject);
var LoginError :TLoginError;
begin
try
LoginError:=TLoginError.Create(nil);
if curid>-1 then
if not rtitems.oper.RegistUser(curid,edit1.Text) then
LoginError.Execute('Пароль введен неверно!');

finally
LoginError.Free;
end;
 modalresult:=mrOk;
end;

procedure TOperatorReg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  edit1.OnEnter:=nil;
end;

end.
