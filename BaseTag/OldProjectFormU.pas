unit OldProjectFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,ImmiSys;

type
  TOldProjectForm = class(TForm)
    Edit2: TEdit;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    Edit3: TEdit;
    Label3: TLabel;
    SpeedButton3: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    function Exec(var dbstr: string; var formstr: string): boolean;
    { Public declarations }
  end;

var
  OldProjectForm: TOldProjectForm;

implementation

{$R *.dfm}

function TOldProjectForm.Exec(var dbstr: string; var formstr: string): boolean;
begin
   Edit2.Text:=dbstr;
   Edit2.Text:=formstr;
   if Showmodal=mrOk then
    begin
     result:=true;
     dbstr:=Edit2.Text;
     formstr:=Edit3.Text;
    end else result:=false;
end;

procedure TOldProjectForm.SpeedButton2Click(Sender: TObject);
var str: string;
begin
  with TImmiSysForm.Create(nil) do
     begin
         Caption:='Выбор папки dbdata';
         if Exec(str) then
           begin

               if not directoryExists(str) then
                 begin
                  MessageBox(0,PChar('Папки  '+str+ '  не существует!  '
                    ),'Сообщение',
                     MB_OK+MB_TOPMOST+MB_ICONERROR);
                  exit;

                  end;


               Edit2.Text:=str;


           end;

      free;

      end;
end;

procedure TOldProjectForm.SpeedButton3Click(Sender: TObject);
var str: string;
begin
     with TImmiSysForm.Create(nil) do
     begin
         Caption:='Выбор папки dbdata';
         if Exec(str) then
           begin
             Edit3.Text:='';
               if not directoryExists(str) then
                 begin
                  MessageBox(0,PChar('Папки  '+str+ '  не существует!  '
                    ),'Сообщение',
                     MB_OK+MB_TOPMOST+MB_ICONERROR);
                  exit;

                  end;


               Edit3.Text:=str;


           end;

      free;

      end;
end;

end.
