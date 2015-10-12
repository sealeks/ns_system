unit FormReRegistU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImmiValueEntryFrmU, memstructsU, LoginError;

type
  TFormReRegist = class(TForm)
    Edit1: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    procedure Edit1Enter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
        curid: integer;
        procedure showW;
        procedure Fills;
    { Public declarations }
  end;

var
  FormReRegist: TFormReRegist;

implementation

{$R *.dfm}

procedure TFormReRegist.showW;
begin
   Fills;
   edit1.Text:='';
     edit2.Text:='';
     edit3.Text:='';
   Showmodal;
end;

procedure TFormReRegist.Fills;
begin
  if rtitems.oper.usCur>-1 then label5.Caption:= rtitems.oper.GetName(rtitems.oper.usCur) else
     label5.Caption:='';
    curid:=rtitems.oper.usCur;
end;

procedure TFormReRegist.Edit1Enter(Sender: TObject);
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
      (Edit1).PasswordChar := '*';
      if ShowModal = integer(mrOK) then
       (sender as TEdit).text := edit1.text;
   //  SetFocus;
    finally
      free;
    end
end;

procedure TFormReRegist.Button1Click(Sender: TObject);
var LoginError :TLoginError;
begin
try
LoginError:=TLoginError.Create(nil);
   if curid>-1 then

          begin
            if edit2.Text<>edit3.Text then LoginError.Execute('Не совпадает подтверждение!') else
              if not rtitems.oper.changepassUser(curid,edit1.Text,edit2.text) then LoginError.Execute('Пароль введен неверно!');
          end;

finally
LoginError.Free;
end;
ModalResult:=mrOk;
end;

procedure TFormReRegist.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  edit1.OnEnter:=nil;
   edit2.OnEnter:=nil;
   edit3.OnEnter:=nil;
end;

end.
