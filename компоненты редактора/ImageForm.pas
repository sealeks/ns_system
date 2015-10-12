unit ImageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,ExtDlgs;

type
  TForm18 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function RedPic(var TP: TPicture): boolean;
    function RedBit(var TP: TBitmap): boolean;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    CurrentBit: TPicture;
    { Private declarations }
  public
    ImagProject: boolean;
    BitmapProject: Tbitmap;
    { Public declarations }
  end;

var
  Form18: TForm18;

implementation

{$R *.dfm}

procedure TForm18.Button3Click(Sender: TObject);
var oPic: TOpenPictureDialog;
begin
oPic:=TOpenPictureDialog.Create(self);
if oPic.Execute then
begin
Image1.Picture.LoadFromFile(oPic.FileName);
CurrentBit:=Image1.Picture;
end;
end;

procedure TForm18.Button2Click(Sender: TObject);
begin
  ModalResult := mrNo;
end;

function TForm18.RedBit(var TP: TBitmap): boolean;
var bPic: TPicture;
begin
bPic:=TPicture.Create;
bPic.Bitmap.Assign(TP);
RedPic(bPic);
tp.Assign(bPic.Bitmap);
bPic.Free;

end;

function TForm18.RedPic(var TP: TPicture): boolean;
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

procedure TForm18.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TForm18.Button4Click(Sender: TObject);
begin
CurrentBit.BitMap:=nil;
Image1.Picture.Bitmap:=nil;
Panel1.Caption:='[Нет]';
end;

procedure TForm18.FormCreate(Sender: TObject);
begin
 ImagProject:=false;
 BitmapProject:=Tbitmap.Create;
end;

procedure TForm18.CheckBox1Click(Sender: TObject);
begin
inherited;
if CheckBox1.Checked then
  begin
    ImagProject:=true;
    button4.Enabled:=false;
    button3.Enabled:=false;
    if BitmapProject<>nil then
    begin
     if ((BitmapProject<>nil) and (CurrentBit<>nil)) then
     begin
     image1.Picture.Bitmap.Assign(BitmapProject);
     CurrentBit.Bitmap.Assign(BitmapProject);
     end;
    end
    else
      begin
      image1.Picture.Bitmap:=nil;
      Panel1.Caption:='[Нет картинки проекта]';
      end;
   end
else
   begin
    ImagProject:=false;
    button4.Enabled:=true;
    button3.Enabled:=true;
    CurrentBit.BitMap:=nil;
    Image1.Picture.Bitmap:=nil;
    Panel1.Caption:='[Нет]';
   end;
end;


procedure TForm18.FormClose(Sender: TObject; var Action: TCloseAction);
begin
BitmapProject.Free;
end;

end.
