unit fLoadU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfLoad = class(TForm)
    Label1: TLabel;
    lLoadComp: TLabel;
    Image2: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ProcessLog(Msg: string);
  end;

var
  fLoad: TfLoad;

implementation

{$R *.DFM}
procedure TFLoad.ProcessLog(Msg: string);
begin
     lLoadComp.Caption := Copy(Msg, 1, 30);
     Refresh;
end;

end.
