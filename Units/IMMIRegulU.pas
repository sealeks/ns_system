unit IMMIRegulU;

interface

uses
  Windows, Messages,  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IMMIFormU, StdCtrls, ComCtrls, IMMITrackBar, IMMIEditReal, Buttons,
  IMMISpeedButton, ExtCtrls, IMMIShape,
  frmRegSetupU,Constdef,
  IMMIGroupBoxU, IMMIImg1, SYButton, ImmiSyButton, IMMIPanelU,
  IMMIValueEntryU, IMMILabelFullU, Scope, IMMIScope, IMMIBitBtn, Ruler,
  AvPr, memStructsU;
type

  boolp =^ boolean;

type
  TRegulList = class(TList);


  type
  
  TIMMIFormRegul = class(TIMMIForm)
    IMMIGroupBox1: TIMMIGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    ParamFlySpInd: TIMMIShape;
    ParamPVInd: TIMMIShape;
    ParamLabel50: TLabel;
    ParamLabel0: TLabel;
    ParamLabel100: TLabel;
    IMMIGroupBox2: TIMMIGroupBox;
    IMPVind: TIMMIShape;
    Label11: TLabel;
    Label8: TLabel;
    Label15: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    Bevel3: TBevel;
    IMMIGroupBox3: TIMMIGroupBox;
    ImmiSyButton3: TImmiSyButton;
    IMMIImg13: TIMMIImg1;
    ImmiSyButton4: TImmiSyButton;
    SYButton1: TSYButton;
    Ruler2: TRuler;
    Ruler3: TRuler;
    IMMIGroupBox5: TIMMIGroupBox;
    IMMIGroupBox6: TIMMIGroupBox;
    ImmiSyButton6: TImmiSyButton;
    ImmiSyButton7: TImmiSyButton;
    IMMIImg12: TIMMIImg1;
    IMMIImg15: TIMMIImg1;
    IMMIImg16: TIMMIImg1;
    IMMIImg11: TIMMIImg1;
    IMMIImg14: TIMMIImg1;
    IMMIImg17: TIMMIImg1;
    Label3: TLabel;
    Label5: TLabel;
    IMSPTB: TIMMITrackBar;
    ParamSptb: TIMMITrackBar;
    ParamPvEdit: TIMMILabelFull;
    IMPVEdit: TIMMILabelFull;
    Label6: TLabel;
    Label12: TLabel;
    Label4: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    ImmiScope2: TImmiScope;
    AvPr1: TAvPr;
    Ruler1: TRuler;
    IMMILabelFull1: TIMMILabelFull;
    IMMILabelFull2: TIMMILabelFull;
    IMMILabelFull3n: TIMMILabelFull;
    Image1: TImage;
    Image2: TImage;
    IMMILabelFull4: TIMMILabelFull;
    ParamSpEdit: TIMMIValueEntry;
    IMMIShape1: TIMMIShape;
    IMSPEDIT: TIMMIValueEntry;
    IMMILabelFull5: TIMMILabelFull;
    IMMIShape2: TIMMIShape;
    ImmiSyButton1: TIMMIBitBtn;
    ImmiSyButton2: TIMMIBitBtn;
    ImmiSyButton8: TIMMIBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ImmiSyButton4Click(Sender: TObject);
    procedure ImmiSyButton6Click(Sender: TObject);
    procedure ImmiSyButton1Click(Sender: TObject);
    procedure ImmiSyButton2Click(Sender: TObject);
    procedure ImmiSyButton8Click(Sender: TObject);
    procedure IMMISpeedButton1Click(Sender: TObject);
    procedure IMMISpeedButton2Click(Sender: TObject);
    procedure IMMISpeedButton6Click(Sender: TObject);
    procedure IMMISpeedButton5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IMMIHide (var Msg : TMsg); Message WM_IMMICLOSEALL;
    procedure ImmiSyButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
    regul: TComponent;
    pointActiv: boolP;
    fregset:TfrmRegSetup;
    { Public declarations }
  end;

var
  //IMMIFormRegul: TIMMIFormRegul;
  Regullist: TRegulList;
implementation

uses IMMIRegul;


{$R *.DFM}

procedure TIMMIFormRegul.IMMIHide (var Msg : TMsg);
    begin
       self.Close;
    end;

procedure TIMMIFormRegul.FormCreate(Sender: TObject);
begin
  inherited;
  left := 550;
  width := 255;
  height := 640;
end;


procedure TIMMIFormRegul.Button1Click(Sender: TObject);
begin
  inherited;
  with fregset do
  begin
  
      if not TIMMIRegul(regul).isONBr then
      Panel7.Caption:=string(self.caption) else Panel7.Caption:=string(self.caption);
      IMMILabelFull1.iExprVal:=TIMMIRegul(regul).RegulDat.Kp1;
      IMMILabelFull2.iExprVal:=TIMMIRegul(regul).RegulDat.Kp2;
      IMMIValueEntry1.iparam.rtName:=TIMMIRegul(regul).RegulDat.Kp1;
      IMMIValueEntry2.iparam.rtName:=TIMMIRegul(regul).RegulDat.Kp2;
      IMMILabelFull3.iExprVal:=TIMMIRegul(regul).RegulDat.ti1;
      IMMILabelFull4.iExprVal:=TIMMIRegul(regul).RegulDat.Ti2;
      IMMIValueEntry3.iparam.rtName:=TIMMIRegul(regul).RegulDat.ti1;
      IMMIValueEntry4.iparam.rtName:=TIMMIRegul(regul).RegulDat.Ti2;
      IMMIValueEntry5.iparam.rtName:=TIMMIRegul(regul).RegulDat.dEps;
      IMMILabelFull5.iExprVal:=TIMMIRegul(regul).RegulDat.dEps;
      tdentry.iparam.rtName:=TIMMIRegul(regul).RegulDat.Td;
      IMMILabelFull6.iExprVal:=TIMMIRegul(regul).RegulDat.Td;
      IMMIValueEntry7.iparam.rtName:=TIMMIRegul(regul).RegulDat.ddb;
      IMMILabelFull8.iExprVal:=TIMMIRegul(regul).RegulDat.tfull;
      IMMIValueEntry8.iparam.rtName:=TIMMIRegul(regul).RegulDat.tfull;
      IMMILabelFull9.iExprVal:=TIMMIRegul(regul).RegulDat.timp;
      IMMIValueEntry9.iparam.rtName:=TIMMIRegul(regul).RegulDat.timp;
      IMMILabelFull10.iExprVal:=TIMMIRegul(regul).RegulDat.vsp;
      IMMIValueEntry10.iparam.rtName:=TIMMIRegul(regul).RegulDat.vsp;
      IMMILabelFull11.iExprVal:=TIMMIRegul(regul).RegulDat.rv;
      IMMIValueEntry11.iparam.rtName:=TIMMIRegul(regul).RegulDat.rv;
      Panel1.Visible:=true;
      Panel2.Visible:=true;
      Panel3.Visible:=true;
      Panel4.Visible:=true;
      Panel5.Visible:=true;
      Panel6.Visible:=true;
      immiPanel1.Visible:=true;
      immiPanel2.Visible:=true;
      immiPanel3.Visible:=true;
      immiPanel4.Visible:=true;
      immiPanel5.Visible:=true;
      if TIMMIRegul(regul).RegulDat.Kp1='' then Panel1.Visible:=false;
      if TIMMIRegul(regul).RegulDat.Kp2='' then Panel2.Visible:=false;
      if TIMMIRegul(regul).RegulDat.Ti1='' then Panel3.Visible:=false;
      if TIMMIRegul(regul).RegulDat.Ti2='' then Panel4.Visible:=false;
      if TIMMIRegul(regul).RegulDat.deps='' then Panel5.Visible:=false;
      if TIMMIRegul(regul).RegulDat.Td='' then Panel6.Visible:=false;
      if TIMMIRegul(regul).RegulDat.DDb='' then immiPanel1.Visible:=false;
      if TIMMIRegul(regul).RegulDat.Tfull='' then immiPanel2.Visible:=false;
      if TIMMIRegul(regul).RegulDat.Timp='' then immiPanel3.Visible:=false;
      if TIMMIRegul(regul).RegulDat.Vsp='' then immiPanel4.Visible:=false;
      if TIMMIRegul(regul).RegulDat.Rv='' then immiPanel5.Visible:=false;






      top := self.ClientToScreen(Point(0, 0)).Y + 100;
      left := self.left + self.width;
      if (left + width > screen.width) then left := self.left - width;
      Show;
  end;
end;
procedure TIMMIFormRegul.ImmiSyButton4Click(Sender: TObject);
begin
  inherited;
   immiSyButton3.Param.TurnOff;

end;

procedure TIMMIFormRegul.ImmiSyButton6Click(Sender: TObject);
begin
  inherited;
   immiSyButton7.Param.TurnOff;
end;

procedure TIMMIFormRegul.ImmiSyButton1Click(Sender: TObject);
begin
  inherited;
   //if immiimg14.Visible then ImmiSyButton2.Param.TurnOff;
   //if immiimg17.Visible then  ImmiSyButton8.Param.TurnOff;
end;

procedure TIMMIFormRegul.ImmiSyButton2Click(Sender: TObject);
begin
  inherited;
    //if immiimg11.Visible then ImmiSyButton1.Param.TurnOff;
    //if immiimg17.Visible then ImmiSyButton8.Param.TurnOff;
end;

procedure TIMMIFormRegul.ImmiSyButton8Click(Sender: TObject);
begin
  inherited;
    //if immiimg11.Visible then  ImmiSyButton1.Param.TurnOff;
    //if immiimg14.Visible then ImmiSyButton2.Param.TurnOff;
end;

procedure TIMMIFormRegul.IMMISpeedButton1Click(Sender: TObject);
begin
  inherited;
  if ParamSPtb.Position<ParamSPtb.max then ParamSPtb.Position:= ParamSPtb.Position+round(1.0*(ParamSPtb.Max - ParamSPtb.Min)/100);
end;

procedure TIMMIFormRegul.IMMISpeedButton2Click(Sender: TObject);
begin
  inherited;
    if ParamSPtb.Position>ParamSPtb.min then ParamSPtb.Position:= ParamSPtb.Position-round(1.0*(ParamSPtb.Max - ParamSPtb.Min)/100) ;
end;

procedure TIMMIFormRegul.IMMISpeedButton6Click(Sender: TObject);
begin
  inherited;
   if IMSPTB.Param.Value<IMSPTB.Param.maxEU then
    IMSPTB.Param.Value:=IMSPTB.Param.Value+(IMSPTB.Param.maxEU - IMSPTB.Param.minEU)*0.01;
end;

procedure TIMMIFormRegul.IMMISpeedButton5Click(Sender: TObject);
begin
  inherited;
    if IMSPTB.Param.Value>IMSPTB.Param.minEu then
  IMSPTB.Param.Value:=IMSPTB.Param.Value-(IMSPTB.Param.maxEU - IMSPTB.Param.minEU)*0.01;
end;

procedure TIMMIFormRegul.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var i: integer;
begin
  inherited;
  if fregset<>nil then  fregset.Close;
  IF assigned(pointActiv) then pointActiv^:=false;
    if (RegulList=nil) or (RegulList.Count<2) then exit;
  i:=0;
  while i<RegulList.Count do
   begin
      if RegulList.Items[i]=self then
          begin
            RegulList.Delete(i);
            self.Free;
            self.regul:=nil;
            self:=nil;
            exit;
         end else inc(i);
   end;
end;


procedure TIMMIFormRegul.ImmiSyButton7Click(Sender: TObject);
begin

  inherited;
  immiSyButton7.Param.TurnOn;
end;

initialization
RegulList:=TRegulList.Create;
finalization
begin
{while AnalogGraphList.Count>0 do
begin
Tobject(AnalogGraphList.items[i]).Free;
AnalogGraphList.Delete(0);
end;}
RegulList.Free;
end;


end.
