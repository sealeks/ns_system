unit AddPFU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAddPForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
   Nm: string;
   function GetNm: integer;
    { Public declarations }
  end;



implementation

{$R *.dfm}

function TAddPForm.GetNm: integer;
begin
  result:=self.ShowModal;
  if result=mrOk then
    Nm:=self.Edit1.Text;
end;

end.
