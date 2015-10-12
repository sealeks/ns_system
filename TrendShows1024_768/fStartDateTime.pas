unit fStartDateTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin;

type
  TfDateTime = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    dtpDateStart: TDateTimePicker;
    dtpTimeStart: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit2: TSpinEdit;
    Label5: TLabel;
    SpinEdit3: TSpinEdit;
    Label6: TLabel;
    SpinEdit4: TSpinEdit;
    procedure SpinEdit4Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDateTime: TfDateTime;

implementation

uses fTrendU;

{$R *.dfm}

procedure TfDateTime.SpinEdit4Change(Sender: TObject);
begin
  if SpinEdit4.value < 0 then SpinEdit4.value := 0;
end;

procedure TfDateTime.SpinEdit3Change(Sender: TObject);
begin
  if SpinEdit3.value < 0 then SpinEdit3.value := 0;
end;

procedure TfDateTime.SpinEdit2Change(Sender: TObject);
begin
  if SpinEdit2.value < 0 then SpinEdit2.value := 0;

end;

procedure TfDateTime.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.value < 0 then SpinEdit1.value := 0;
end;

procedure TfDateTime.FormCreate(Sender: TObject);
begin
fDateTime.Height:=255;
fDateTime.Width:=330;
end;

end.
