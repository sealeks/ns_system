unit DBConnetCofig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ValEdit, DBManagerFactoryU,MainDataModuleU,
  ExtCtrls;

type
  TFormDBConfig = class(TForm)
    ValueListEditor1: TValueListEditor;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);

  private
      module: TMainDataModule;
    { Private declarations }
  public
    function Exec(type_: integer; var constr: string): boolean;
    procedure FillList();
    procedure ApplyList();
    { Public declarations }
  end;

var
  FormDBConfig: TFormDBConfig;

implementation

{$R *.dfm}

function TFormDBConfig.Exec(type_: integer; var constr: string): boolean;

begin
  result:=false;
  module:=TDBManagerFactory.buildManager(type_,constr);
  if module=nil then
    begin
      Showmessage('Менеджер СУБД не найден!');
      exit;
    end;
  Panel1.Visible:=(type_=BDE_MANAGER);
  ValueListEditor1.Visible:= not Panel1.Visible;
  FillList();
  if (ShowModal=mrOk) then
    begin
      result:=true;
      ApplyList();
      if (type_<>BDE_MANAGER) then constr:=module.Prop else
      constr:='';
    end;
   module.Free;
end;

procedure TFormDBConfig.FillList();
begin
   if (Panel1.Visible) then exit;
   ValueListEditor1.Values['Server']:=module.Server;
   ValueListEditor1.Values['DataBase']:=module.DataBase;
   ValueListEditor1.Values['Schema']:=module.Schema;
   ValueListEditor1.Values['User']:=module.User;
   ValueListEditor1.Values['Password']:=module.Password;
   if (module.Port>0) then ValueListEditor1.Values['Port']:=inttostr(module.Port);
end;

procedure TFormDBConfig.ApplyList();
begin
   if (Panel1.Visible) then exit;
   module.Server:=ValueListEditor1.Values['Server'];
   module.DataBase:=ValueListEditor1.Values['DataBase'];
   module.Schema:=ValueListEditor1.Values['Schema'];
   module.User:=ValueListEditor1.Values['User'];
   module.Password:=ValueListEditor1.Values['Password'];
   module.Port:=strtointdef(ValueListEditor1.Values['Port'],0);
end;

procedure TFormDBConfig.Button1Click(Sender: TObject);
begin
   ApplyList();
   try
     module.TestConnect;
     Showmessage('Тест успешно завершен!');
   except
     on  ExDB: exception do
     MessageBox(0,PChar('Ошибка подключения!  '+ char(13)+
               'Сообщение: '+ ExDB.Message),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);

   end;
    module.DisConnect;
end;

end.
