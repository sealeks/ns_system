unit Switch2FormU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IMMIFormU, Buttons, IMMISpeedButton, IMMIImage, ExtCtrls, StdCtrls,
  IMMIImg1, IMMIPanelU, SYButton, ImmiSyButton, dxCore, dxButton,
  ImmibuttonXp;

type
  TSwitch2Form = class(TIMMIForm)
    Label2: TLabel;
    IMMIPanel1: TIMMIPanel;
    Bevel2: TBevel;
    Label1: TLabel;
    IMMIPanel2: TIMMIPanel;
    Bevel4: TBevel;
    Label3: TLabel;
    IMMIPanel3: TIMMIPanel;
    Bevel1: TBevel;
    Image1: TImage;
    IMMIImage2: TIMMIImage;
    IMMIImage1: TIMMIImage;
    ImmiSyButton1: TImmiSyButton;
    ImmiSyButton2: TImmiSyButton;
    ImmiSyButton3: TImmiSyButton;
    IMMIImg11: TIMMIImg1;
    IMMIImg14: TIMMIImg1;
    IMMIImg15: TIMMIImg1;
    IMMIImg12: TIMMIImg1;
    IMMIImg13: TIMMIImg1;
    ImmiSyButton4: TImmiSyButton;
    ImmiSyButton5: TImmiSyButton;
    Bevel3: TBevel;
    IMMISpeedButton2: TImmiButtonXp;
    Button1: TImmiButtonXp;
    IMMISpeedButton1: TImmiButtonXp;
    procedure Button1Click(Sender: TObject);
    procedure IMMISpeedButton1Click(Sender: TObject);
    procedure IMMISpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure IMMIImg14Click(Sender: TObject);
    procedure IMMIImg11Click(Sender: TObject);
    procedure ImmiSyButton4Click(Sender: TObject);
    procedure ImmiSyButton1Click(Sender: TObject);
    procedure ImmiSyButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  Switch2Form: TSwitch2Form;

implementation

{$R *.DFM}
constructor TSwitch2Form.Create(AOwner: TComponent);
begin
     inherited;
     width := 205;
     height := 190;
end;

procedure TSwitch2Form.Button1Click(Sender: TObject);
begin
 // inherited;
 if Switch2Form.IMMISpeedButton1.Param.Value>0 then Switch2Form.IMMISpeedButton1.Param.TurnOff;
 if Switch2Form.IMMISpeedButton2.Param.Value>0 then Switch2Form.IMMISpeedButton2.Param.TurnOff;
end;

procedure TSwitch2Form.IMMISpeedButton1Click(Sender: TObject);
begin
 // if Switch2Form.IMMISpeedButton2.Down then Switch2Form.IMMISpeedButton2.Param.TurnOff;
end;

procedure TSwitch2Form.IMMISpeedButton2Click(Sender: TObject);
begin
 // if Switch2Form.IMMISpeedButton1.Down then Switch2Form.IMMISpeedButton1.Param.TurnOff;
 // if Switch2Form.IMMISpeedButton2.Down then Switch2Form.IMMISpeedButton2.Param.TurnOff;
end;


procedure TSwitch2Form.SpeedButton1Click(Sender: TObject);
begin
  inherited;
self.Close;
end;

procedure TSwitch2Form.IMMIImg14Click(Sender: TObject);
begin
inherited;
//self.IMMIImg14.IMMIProp.Param.TurnOn;
//self.IMMIImg15.IMMIProp.Param.TurnOn;

end;

procedure TSwitch2Form.IMMIImg11Click(Sender: TObject);
begin
inherited;
//self.IMMIImg11.IMMIProp.Param.TurnOn;
//self.IMMIImg15.IMMIProp.Param.TurnOff;
end;

procedure TSwitch2Form.ImmiSyButton4Click(Sender: TObject);
begin
  inherited;
self.ImmiSyButton5.Param.TurnOff;
end;

procedure TSwitch2Form.ImmiSyButton1Click(Sender: TObject);
begin
  inherited;
self.ImmiSyButton3.Param.TurnOff;
self.ImmiSyButton2.Param.TurnOff;

end;

procedure TSwitch2Form.ImmiSyButton2Click(Sender: TObject);
begin
  inherited;
self.ImmiSyButton3.Param.TurnOff;
end;

end.
