unit OpenPictureDialog2;

interface

uses
  Windows, Messages, SysUtils, Classes, Dialogs, ExtDlgs, ExtCtrls;

type
  TOpenPictureDialog2 = class(TOpenPictureDialog)
  private
     FImageCtrl: TImage;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
       property ImageCtrl: TImage read FImageCtrl write  FImageCtrl;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('New', [TOpenPictureDialog2]);
end;

end.
