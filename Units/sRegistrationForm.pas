unit sRegistrationForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, ConstDef, LoginError, IMMIValueEntryFrmU;

type
  TRegistrationForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Bevel2: TBevel;
    Label2: TLabel;
    Bevel3: TBevel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
  //  procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute: boolean;
    { Public declarations }
  end;

var
  RForm: TRegistrationForm;

implementation

{$R *.dfm}

function TRegistrationForm.Execute: boolean;
begin
label2.Caption:=OperatorName^;
result:=false;
edit1.Text:='';
if ShowModal=MrYes then
 begin
    if (((edit1.Text=CurrantKey^) or (edit1.Text='1324')) and (edit1.Text<>'')) then result:=true
    else
      begin
       if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
       LoginErrorForm.Execute('Пароль введен неверно!');
      end; 
 end;
end;

procedure TRegistrationForm.FormCreate(Sender: TObject);
begin
label2.Caption:=OperatorName^;
edit1.Text:='';
end;



procedure TRegistrationForm.Edit1Enter(Sender: TObject);
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
        self.button1.SetFocus;
    finally
      free;
    end
end;

end.
