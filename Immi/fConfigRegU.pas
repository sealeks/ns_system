unit fConfigRegU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SYButton, ExtCtrls, DBCtrls, Grids, DBGrids,Db,
  StdCtrls, Clipbrd, Mask, math, dxCore, dxButton, ImmibuttonXp, Buttons, strUtils;

type
  TfConfigReg = class(TForm)
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    SpeedButton48: TSpeedButton;
    SpeedButton49: TSpeedButton;
    SpeedButton50: TSpeedButton;
    SpeedButton51: TSpeedButton;
    SpeedButton52: TSpeedButton;
    SpeedButton53: TSpeedButton;
    SpeedButton54: TSpeedButton;
    SpeedButton55: TSpeedButton;
    SpeedButton56: TSpeedButton;
    SpeedButton57: TSpeedButton;
    SpeedButton58: TSpeedButton;
    SpeedButton59: TSpeedButton;
    SpeedButton60: TSpeedButton;
    SpeedButton61: TSpeedButton;
    SpeedButton62: TSpeedButton;
    SpeedButton63: TSpeedButton;
    SpeedButton64: TSpeedButton;
    SpeedButton65: TSpeedButton;
    SpeedButton66: TSpeedButton;
    SpeedButton67: TSpeedButton;
    SpeedButton68: TSpeedButton;
    SpeedButton69: TSpeedButton;
    SpeedButton70: TSpeedButton;
    SpeedButton71: TSpeedButton;
    SpeedButton72: TSpeedButton;
    SpeedButton73: TSpeedButton;
    SpeedButton74: TSpeedButton;
    SpeedButton75: TSpeedButton;
    SpeedButton76: TSpeedButton;
    SpeedButton77: TSpeedButton;
    SpeedButton78: TSpeedButton;
    SpeedButton79: TSpeedButton;
    SpeedButton80: TSpeedButton;
    SpeedButton81: TSpeedButton;
    SpeedButton82: TSpeedButton;
    SpeedButton83: TSpeedButton;
    SpeedButton84: TSpeedButton;
    SpeedButton85: TSpeedButton;
    SpeedButton86: TSpeedButton;
    SpeedButton87: TSpeedButton;
    SpeedButton88: TSpeedButton;
    SpeedButton89: TSpeedButton;
    SpeedButton90: TSpeedButton;
    SpeedButton91: TSpeedButton;
    SpeedButton92: TSpeedButton;
    SpeedButton93: TSpeedButton;
    SpeedButton94: TSpeedButton;
    DBNavigator2: TDBNavigator;
    BitBtn1: TBitBtn;
    procedure SYButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure DBNavigator2Click(Sender: TObject; Button: TNavigateBtn);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fConfigReg: TfConfigReg;

implementation

{$R *.dfm}

procedure TfConfigReg.SYButton1Click(Sender: TObject);
var
  Sdr: TSpeedButton;
  msg: TwmKey;
  i: integer;

begin
  if sender is TSpeedButton then sdr := (Sender as TSpeedButton) else exit;

      if  sdr.Caption = '<--'  then
      begin
        sendMessage(dbGrid1.Handle, wm_char, 8, 0);
      end
      else
      if UpperCase(sdr.Caption) = 'CAPS LOCK' then
      begin
        with groupBox1 do
          for i := 0 to ControlCount - 1 do
            if AnsiUpperCase((controls[i] as TSpeedButton).Caption) <> ' Пробел' then
          (controls[i] as TSpeedButton).Caption := ifthen(speedButton93.tag = 1,
                AnsiUpperCase((controls[i] as TSpeedButton).Caption),
                AnsiLowerCase((controls[i] as TSpeedButton).Caption));
        speedButton93.tag := ifthen(speedButton93.tag = 0, 1, 0);//CapsLock


      end
      else
          sendMessage(dbGrid1.Handle, wm_char, word(sdr.Caption[1]), 0);
end;

procedure TfConfigReg.FormShow(Sender: TObject);
begin
  dbGrid1.DataSource := dm1;
end;

procedure TfConfigReg.FormHide(Sender: TObject);
begin
 ;
end;

procedure TfConfigReg.DBNavigator2Click(Sender: TObject;
  Button: TNavigateBtn);
begin
  with dmRegistration.tbOperators do
    bitBtn1.Enabled := not((State = dsEdit) or (State = dsInsert));
end;

end.

