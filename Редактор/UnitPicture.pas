unit UnitPicture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,ExtDlgs;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function RedPic(var TP: TPicture): boolean;
    function RedBit(var TP: TBitmap): boolean;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    CurrentBit: TPicture;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button3Click(Sender: TObject);
var oPic: TOpenPictureDialog;
begin
oPic:=TOpenPictureDialog.Create(self);
if oPic.Execute then
begin
Image1.Picture.LoadFromFile(oPic.FileName);
CurrentBit:=Image1.Picture;
end;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  ModalResult := mrNo;
end;

function TForm4.RedBit(var TP: TBitmap): boolean;
var bPic: TPicture;
begin
bPic:=TPicture.Create;
bPic.Bitmap.Assign(TP);
RedPic(bPic);
tp.Assign(bPic.Bitmap);
bPic.Free;

end;

function TForm4.RedPic(var TP: TPicture): boolean;
begin
if CurrentBit=nil then CurrentBit:=TPicture.Create;
if ( not tp.Bitmap.Empty ) then
begin
CurrentBit.BitMap.Assign(tp.Bitmap);
Panel1.Caption:='';
Image1.Picture.Bitmap.Assign(TP.Bitmap);
end
else
Panel1.Caption:='[Нет]';
if ShowModal=MrOK
then
begin
TP.Bitmap.Assign(CurrentBit.BitMap);
result:=true;
end
else Result:=false;
Image1.Picture.Bitmap:=nil;
CurrentBit:=nil;

end;

procedure TForm4.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TForm4.Button4Click(Sender: TObject);
begin
CurrentBit.BitMap:=nil;
Image1.Picture.Bitmap:=nil;
Panel1.Caption:='[Нет]';
end;

end.
