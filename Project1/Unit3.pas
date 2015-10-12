unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IMMIRegul, MemStructsU, 
  IMMIformx;

type
  TForm3 = class(TForm)
    IMMIRegul1: TIMMIRegul;
    IMMIFormExt1: TIMMIFormExt;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
MemStructsU.rtItems := TAnalogMems.CreateW('F:\гусев\prj\');
end;

end.
