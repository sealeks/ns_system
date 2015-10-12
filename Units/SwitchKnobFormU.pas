unit SwitchKnobFormU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IMMIFormU, Buttons, IMMISpeedButton, StdCtrls, ExtCtrls, IMMIImg1,
  SYButton, ImmiSyButton, IMMIPanelU;

type
  TSwitchKnobForm = class(TIMMIForm)
    IMMISpeedButton1: TIMMISpeedButton;
    Bevel1: TBevel;
    IMMIImg12: TIMMIImg1;
    Label2: TLabel;
    IMMIPanel2: TIMMIPanel;
    Bevel4: TBevel;
    Label3: TLabel;
    IMMIImg11: TIMMIImg1;
    IMMIImg14: TIMMIImg1;
    IMMIImg15: TIMMIImg1;
    ImmiSyButton1: TImmiSyButton;
    ImmiSyButton2: TImmiSyButton;
    ImmiSyButton3: TImmiSyButton;
    IMMIPanel1: TIMMIPanel;
    Bevel2: TBevel;
    Label1: TLabel;
    IMMIImg13: TIMMIImg1;
    IMMIImg16: TIMMIImg1;
    ImmiSyButton4: TImmiSyButton;
    ImmiSyButton5: TImmiSyButton;
    IMMISpeedButton4: TIMMISpeedButton;
    Bevel3: TBevel;
    IMMISpeedButton3: TIMMISpeedButton;
    IMMISpeedButton2: TIMMISpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure ImmiSyButton4Click(Sender: TObject);
    procedure ImmiSyButton1Click(Sender: TObject);
    procedure ImmiSyButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SwitchKnobForm: TSwitchKnobForm;

implementation

{$R *.DFM}

procedure TSwitchKnobForm.FormCreate(Sender: TObject);
begin
  inherited;
   width := 208;
     height := 190;
end;

procedure TSwitchKnobForm.ImmiSyButton4Click(Sender: TObject);
begin
  inherited;
self.ImmiSyButton5.Param.TurnOff;
end;

procedure TSwitchKnobForm.ImmiSyButton1Click(Sender: TObject);
begin
  inherited;
self.ImmiSyButton3.Param.TurnOff;
self.ImmiSyButton2.Param.TurnOff;
end;

procedure TSwitchKnobForm.ImmiSyButton2Click(Sender: TObject);
begin
  inherited;
self.ImmiSyButton3.Param.TurnOff;
end;

end.
