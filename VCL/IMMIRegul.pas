unit IMMIRegul;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  IMMIRegulU,
  memStructsU,
  IMMIRegulEditF,
  frmRegSetupU,
  IMMIBorder,
  constDef,Expr,Scope, IMMIPropertysU, LoginError;

type
  tRegulData = class(tPersistent)
  private
     fcaption,fParamDName1,fParamDName2,fParamDName3,fNameParam,fNameEd: String;
     fParamSP, fParamPV, fParamFlySP, fIMSP, fIMPV, {fBaz_Rg,}fParamD1,fParamD2,fParamD3, fExprAvString, fExprPrString: TExprStr;
     fNagStr, fVagStr, fNpgStr, fVpgStr: TExprStr;
     fKp1, fTi1: TExprStr;
     fKp2, fTi2, fdEps, fTd: TExprStr;
     fDDb, fTfull, fTimp,fVsp, fRv: TExprStr;
     fAvtomat: TExprStr;
     fParamMax, fParamMin: single;
     fAccess,fCorrectAccess: integer;
     fisQuery: boolean;
     procedure SetAccess (Value: integer);
  public
     constructor Create;
  published
     property avtomat: TExprStr read favtomat write favtomat;
     property caption: String read fCaption write fCaption;
     property ParamSp: TExprStr read fParamSp write fParamSp;
     property ParamFlySp: TExprStr read fParamFlySp write fParamFlySp;
     property ParamPV: TExprStr read fParamPV write fParamPV;
     property IMSp: TExprStr read fIMSp write fIMSp;
     property IMPV: TExprStr read fIMPV write fIMPV;
     property ParamMax: single read fParamMax write fParamMax;
     property ParamMin: single read fParamMin write fParamMin;
     property Kp1: TExprStr read fKp1 write fKp1;
     property Ti1: TExprStr read fTi1 write fTi1;
      property Kp2: TExprStr read fKp2 write fKp2;
     property Ti2: TExprStr read fTi2 write fTi2;
      property dEps: TExprStr read fdEps write fdEps;
       property Td: TExprStr read fTd write fTd;

        property DDb: TExprStr read fDDb write fDDb;
      property Tfull: TExprStr read fTfull write fTfull;
     property Timp: TExprStr read fTimp write fTimp;
      property Vsp: TExprStr read fVsp write fVsp;
       property Rv: TExprStr read fRv write fRv;
    // property Baz_Rg: TExprStr read fBaz_Rg write fBaz_Rg;
     property ParamD1: TExprStr read fParamD1 write fParamD1;
     property ParamDName1: string read fParamDName1 write fParamDName1;
     property ParamD2: TExprStr read fParamD2 write fParamD2;
     property ParamDName2: string read fParamDName2 write fParamDName2;
     property ParamD3: TExprStr read fParamD3 write fParamD3;
     property ParamDName3: string read fParamDName3 write fParamDName3;
     property NameParam: string read fNameParam write fNameParam;
     property NameEd: string read fNameEd write fNameEd;
     property iBnNag: TExprStr  read fNagStr write fNagStr;
     property iBnVag: TExprStr  read fVagStr write fVagStr;
     property iBnNpg: TExprStr  read fNpgStr write fNpgStr;
     property iBnVpg: TExprStr  read fVpgStr write fVpgStr;
    // property ExprAv: TExprStr  read fExprAvString write fExprAvString;
    // property ExprPr: TExprStr  read fExprPrString write fExprPrString;
     property Access: integer read fAccess write SetAccess;
     property CorrectAccess: integer read fCorrectAccess write fCorrectAccess;
     property isQuery: boolean read fisQuery write fisQuery;

  end;

  TIMMIRegul = class(TImage)
  private
    { Private declarations }
    fKeySet: string;
    fRegulData: tRegulData;
    fRegulDatares: tRegulData;
    ffTop, ffLeft: integer;
    fBaz_Rg, fSentFro,fexprEnable : TExprStr;
    fBaz_RgEx, fSentFroex,fEnableex: TExpretion;
    fViwBaz_Rg: boolean;
    fisOn, fIsonBr, fNoavt: boolean;
    currentD: string;
    fBorder: TBorder;
    fRevers: boolean;
    fFPosition: TFPosition;
    flabelFormat: string;
    regFr: TIMMIFormregul;
    fborderComp: TImmiBorder;
  protected
    { Protected declarations }
    procedure Click; override;
    procedure setBaz_Rg(value: TExprStr);
    procedure setison(value: boolean);
    procedure setisonBr(value: boolean);
    procedure setRevers(value: boolean);
    public
    { Public declarations }
     isActive: boolean;
     breakState: boolean;
     reguldat: tRegulData;
    property isON: boolean read fIson write setisOn;
    property isONBr: boolean read fIsonBr write setisOnBr;
    constructor Create(AOwner: TComponent); override;
    procedure ShowPropForm;
    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ImmiKeySet (var Msg: TMessage); message WM_IMMIKEYSET;
    destructor Destroy; override;
    procedure ClickChange;
    procedure Loaded; override;
  published
    { Published declarations }
    property Border: TBorder read fBorder write fBorder;
    property FPosition: TFPosition read fFPosition write fFPosition;
    property Revers: boolean read fRevers write setRevers;
    property RegulData: tRegulData read fRegulData write fRegulData;
    property RegulDatares: tRegulData read fRegulDatares write fRegulDatares;
    property Baz_Rg: TExprStr read fBaz_Rg write setBaz_Rg;
    property exprEnable: TExprStr read fexprEnable write fexprEnable;
    property fLeft: integer read ffLeft write ffLeft default -1;
    property fTop: integer read ffTop write ffTop default -1;
    property ViwBaz_Rg: boolean read fViwBaz_Rg write fViwBaz_Rg;
    property SentFro: TExprStr  read fSentFro write fSentFro;
    property Noavt: boolean read fNoavt write fNoavt;
    property labelFormat: string read flabelFormat write flabelFormat;
    property KeySet: string read fKeySet write fKeySet;
  end;

implementation

constructor TIMMIRegul.Create(AOwner: TComponent);
begin
     inherited;
     regulData := tRegulData.Create;
     regulDatares := tRegulData.Create;
     cursor := crHandPoint;
     fftop:=-10;
     ffleft:=-10;
     fison:=true;
     fViwBaz_Rg:=true;
     isActive:=false;
     reguldat:=freguldata;
     IsonBr:=true;
      fFPosition:=TFPosition.Create;
    fFPosition.FormTop:=-1;
    fFPosition.FormLeft:=-1;
    fBorder:=TBorder.create;

end;

procedure TIMMIRegul.Loaded;
begin
inherited;
if (fBorder.PenWidth>0) and not (csDesigning in ComponentState) then
  begin
    fborderComp:=TImmiBorder.create(application);
    fborderComp.parent:=self.parent;
    fbordercomp.EnterColor:= fborder.EnterColor;
   // fbordercomp.ExprBlk:= fborder.ExprBlk;
   // fbordercomp.ExprOn:= fborder.ExprOn;
    fbordercomp.OutColor:= fborder.OutColor;
   // fbordercomp.OnColor:= fborder.OnColor;
   // fbordercomp.OffColor:= fborder.OffColor;
    fbordercomp.BlkColor:= fborder.BlkColor;
    fbordercomp.BorderType:= fborder.BorderType;
    fbordercomp.PenWidth:= fborder.PenWidth;
    fbordercomp.mousecontrol:=self;
  end;

end;

destructor TIMMIRegul.Destroy;
begin
   regulData.Destroy;
   regulDatares.Destroy;
    fFPosition.Free;
   fBorder.free;
    inherited;
end;

procedure TIMMIRegul.ImmiKeySet (var Msg: TMessage);
begin
   if trim(fkeyset)='' then exit;
   if msg.lparam=strtointdef(fkeyset,-1000) then
     Click;
end;


procedure TIMMIRegul.ImmiInit (var Msg: TMessage);
begin
  CreateAndInitExpretion( fBaz_RgEx, fBaz_Rg);
  CreateAndInitExpretion( fSentFroex, fSentFro);
  CreateAndInitExpretion( fEnableex, fexprEnable);
   if assigned(fBaz_RgEx) then begin
   fBaz_RgEx.ImmiUpdate;
   isOn:=not fBaz_RgEx.isTrue;
     fIsonBr:=true;
   end;
end;

procedure TIMMIRegul.ImmiUnInit (var Msg: TMessage);
begin
   if assigned(fBaz_RgEx) then fBaz_RgEx.ImmiUnInit;
   if assigned(fSentFroex) then fSentFroex.ImmiUnInit;
   if assigned(fEnableex) then fEnableex.ImmiUnInit;
    breakState:=false;
end;



procedure TIMMIRegul.ImmiUpdate (var Msg: TMessage);
var
   islast, isLastBring: boolean;

begin
 islast:=ison;
  if assigned(fBaz_RgEx) then begin
  fBaz_RgEx.IMMIUpdate;
 isOn:=fBaz_RgEx.isTrue;
  if assigned(fSentFroex) then
  begin
   fSentFroex.IMMIUpdate;
   isOnBr:=fSentFroex.isTrue;

  end
   else isOnBr:=true;
  if ((isLast<>isOn) and (isActive)) then
  begin
  // breakState:=true;
   Regfr.fregset.Close;
   ClickChange;
  end;
   //if IMMIFormRegul.scopeList1.Indicators.count>0 then TIndicator(IMMIFormRegul.scopeList1.Indicators.Items[0]);

  end;
  if assigned(fEnableex) then
   begin
     fEnableex.ImmiUpdate;
     if fEnableex.isTrue<>self.Enabled then
       begin
                 self.Enabled:=fEnableex.isTrue;
     // Showmessage('rrr');
       if (frmRegSetup<>nil) and not (self.Enabled) then frmRegSetup.Close;
       if (RegFr<>nil) and not (self.Enabled) then RegFr.Close;
       end;
   end else self.Enabled:=true;

end;


procedure TIMMIRegul.setBaz_Rg(value: TExprStr);
begin
{if rtitems.GetSimpleID(value)>-1 then regulDatares := tRegulData.Create else
    if assigned(regulDatares ) then  regulDatares.free; }
 fBaz_Rg:=value;
end;

procedure TIMMIRegul.setIsOn(value: boolean);
begin
    if fison<>value then
    begin
       if fison then reguldat:=freguldata else reguldat:=freguldatares;

    end;
   fison:=value;

end;


procedure TIMMIRegul.setIsOnBr(value: boolean);
begin
   if value<>fisonBr then
     begin
       if value then
       BringToFront
       else SendToBack;
     end;
   fisonBr:=value;
end;

procedure TIMMIRegul.setRevers(value: boolean);
var rev: TRegulData;
begin
  if not (Application.Tag=1000) then exit;
  if ((value<>fRevers) and assigned(reguldatares)) then
    begin
      rev:=freguldata;
      freguldata:=freguldatares;
      freguldatares:=rev;
    end;
  fRevers:=value;
  end;


procedure TIMMIRegul.Click;
var
i,j, id, idIm, idpv: integer;
regulF: TIMMIFormregul;
mineupstr, maxeupstr: string;

begin

  if labelFormat='' then labelFormat:='%3.0f';
  inherited;
   id:=rtItems.GetSimpleID(regulDat.ParamPV);
    if not integer(GetKeyState(VK_SHIFT))<0 then
      begin
        if regFr=nil then
          begin
          if RegulList.Count=0 then
             begin
              regFr:=TIMMIFormregul.Create(application);
              regFr.fregset:=TfrmRegSetup.Create(regFr);
              RegulList.add(regFr);
              regulF:=regFr;

            end
          end;
      j:=0;
      while RegulList.Count>1 do
        if  regFr<>RegulList.items[j] then TForm(RegulList.items[j]).close else inc(j);
      regFr:=RegulList.items[0];
      regfr.fregset.Close;
      if regFr.regul<>self then
         if assigned(regFr.pointActiv) then regFr.pointActiv^:=false;
      regulF:=regFr;
      regulF.regul:=self;
      regFr.regul:=self;
      end else
      begin
          if (regFr=nil) or not (regFr.regul=self) then
            begin
            regFr:=TIMMIFormregul.Create(application);
            regFr.fregset:=TfrmRegSetup.Create(regFr);
            RegulList.Insert(0,regFr);
           end;
          for i:=0 to  RegulList.Count-1 do
              if regFr<>TForm(RegulList.Items[i]) then TForm(RegulList.Items[i]).Show;
         regulF:=regFr;
         regulF.regul:=self;
         regFr.regul:=self;
      end;
   regFr.regul:=self;

//  RegFr.Label1.Caption:=self.Name;
   if frmRegSetup<>nil then regulF.Close;
   isActive:=true;
 { if not assigned (IMMIFormRegul) then
     Application.CreateForm (TIMMIFormregul, IMMIFormregul);  }

  if (self.Border.EnterColor<>clNone) then
     RegulF.Label2.Color:=self.Border.EnterColor
  else
     RegulF.Label2.Color:=$00C3C3C3;

  with RegulF do begin
    Hide;
    immigroupbox1.Visible:=true;
    immigroupbox3.Visible:=true;
    immigroupbox3.top:=213;
    immigroupbox6.top:=213;
    sybutton1.Top:=215;
    immigroupbox2.top:=339;
    immigroupbox5.top:=281;
     if AccessLevel^<regulDat.Access then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;


     speedbutton2.Visible:=  (regulDat.ParamSP<>'');
     speedbutton3.Visible:=  (regulDat.ParamSP<>'');
     paramspedit.Visible:=   (regulDat.ParamSP<>'');
     paramsptb.Visible:=   (regulDat.ParamSP<>'');
     //Immishape1.Visible:=   (regulDat.ParamSP<>'');
     mineupstr:= '';
     maxeupstr:= '';

  //  if frmRegSetup=nil then frmRegSetup:=TfrmRegSetup.Create(Application);
    fregset.IMMILabelFull1.iExprVal:=RegulDat.fKp1;
    fregset.IMMILabelFull2.iExprVal:=RegulDat.fKp2;
    fregset.IMMIValueEntry1.iparam.rtName:=RegulDat.fKp1;
    fregset.IMMIValueEntry2.iparam.rtName:=RegulDat.fKp2;
    fregset.IMMILabelFull3.iExprVal:=RegulDat.fti1;
    fregset.IMMILabelFull4.iExprVal:=RegulDat.fTi2;
    fregset.IMMIValueEntry3.iparam.rtName:=RegulDat.fti1;
    fregset.IMMIValueEntry4.iparam.rtName:=RegulDat.fTi2;
     fregset.IMMIValueEntry5.iparam.rtName:=RegulDat.fdEps;
     fregset.IMMILabelFull5.iExprVal:=RegulDat.fdEps;
     fregset.TDEntry.iparam.rtName:=RegulDat.fTd;
     fregset.IMMILabelFull6.iExprVal:=RegulDat.fTd;
     fregset.IMMILabelFull7.iExprVal:=RegulDat.fddb;
     fregset.IMMIValueEntry7.iparam.rtName:=RegulDat.fddb;
      fregset.IMMILabelFull8.iExprVal:=RegulDat.ftfull;
     fregset.IMMIValueEntry8.iparam.rtName:=RegulDat.ftfull;
      fregset.IMMILabelFull9.iExprVal:=RegulDat.ftimp;
     fregset.IMMIValueEntry9.iparam.rtName:=RegulDat.ftimp;
     fregset.IMMILabelFull10.iExprVal:=RegulDat.fvsp;
     fregset.IMMIValueEntry10.iparam.rtName:=RegulDat.fvsp;
      fregset.IMMILabelFull11.iExprVal:=RegulDat.frv;
     fregset.IMMIValueEntry11.iparam.rtName:=RegulDat.frv;
    fregset.Panel1.Visible:=true;
    fregset.Panel2.Visible:=true;
    fregset.Panel3.Visible:=true;
    fregset.Panel4.Visible:=true;
     fregset.Panel5.Visible:=true;
      fregset.Panel6.Visible:=true;
       fregset.immiPanel1.Visible:=true;
    fregset.immiPanel2.Visible:=true;
    fregset.immiPanel3.Visible:=true;
    fregset.immiPanel4.Visible:=true;
     fregset.immiPanel5.Visible:=true;
    if RegulDat.fKp1='' then fregset.Panel1.Visible:=false;
    if RegulDat.fKp2='' then fregset.Panel2.Visible:=false;
    if RegulDat.fTi1='' then fregset.Panel3.Visible:=false;
    if RegulDat.fTi2='' then fregset.Panel4.Visible:=false;
     if RegulDat.fdeps='' then fregset.Panel5.Visible:=false;
      if RegulDat.fTd='' then fregset.Panel6.Visible:=false;
       if RegulDat.fDDb='' then fregset.immiPanel1.Visible:=false;
    if RegulDat.fTfull='' then fregset.immiPanel2.Visible:=false;
    if RegulDat.fTimp='' then fregset.immiPanel3.Visible:=false;
    if RegulDat.fVsp='' then fregset.immiPanel4.Visible:=false;
     if RegulDat.fRv='' then fregset.immiPanel5.Visible:=false;
    if trim(regulDat.avtomat)<>'' then
    immigroupBox2.ExprEnable:='!'+regulDat.avtomat else immigroupBox2.ExprEnable:='1';
    reguldat.fExprAvString:='';
    reguldat.fExprPrString:='';
    IMMILabelFull4.formatStr:=labelFormat;
    ParamPVEdit.formatStr:=labelFormat;
    Avpr1.iBnNag:=regulDat.fNagStr;
    Avpr1.iBnVag:=regulDat.fVagStr;
    Avpr1.iBnNpg:=regulDat.fNpgStr;
    Avpr1.iBnVpg:=regulDat.fVpgStr;
    if  regulDat.ParamPV<>'' then
      begin
      if id>-1 then begin
       Avpr1.Min:=rtItems.Items[id].MinEU;
       Avpr1.Max:=rtItems.Items[id].MaxEU;
       if (Avpr1.Min<>Avpr1.Max) then
       begin
       mineupstr:= floattostr( rtItems.Items[id].MinEU);
       maxeupstr:= floattostr( rtItems.Items[id].MaxEU);
       end;
     end;
     reguldat.fExprAvString:='0';
     reguldat.fExprprString:='0';
    if ((Avpr1.iBnNag<>'') and (Avpr1.iBnVag='')) then reguldat.fExprAvString:=regulDat.ParamPV+ '<' + regulDat.fNagStr;
    if ((Avpr1.iBnVag<>'') and (Avpr1.iBnNag<>'')) then reguldat.fExprAvString:='('+ regulDat.ParamPV+ '<' + regulDat.fNagStr+')|(' + regulDat.ParamPV+ '>' + regulDat.fVagStr+')';
    if ((Avpr1.iBnVag<>'') and (Avpr1.iBnNag='')) then reguldat.fExprAvString:= regulDat.ParamPV+ '>' + regulDat.fVagStr;
    if ((Avpr1.iBnNpg<>'') and (Avpr1.iBnVpg='')) then reguldat.fExprprString:=regulDat.ParamPV+ '<' + regulDat.fNpgStr;
    if ((Avpr1.iBnVpg<>'') and (Avpr1.iBnNpg<>'')) then reguldat.fExprprString:='('+ regulDat.ParamPV+ '<' + regulDat.fNpgStr +')|(' + regulDat.ParamPV+ ' > '  + regulDat.fVpgStr+')';
    if ((Avpr1.iBnVpg<>'') and (Avpr1.iBnNpg='')) then reguldat.fExprprString:=regulDat.ParamPV+ '>' + regulDat.fVPgStr;

    end;
   // labelFormat := '%8.3f';
   // if regulDat.ParamMax >= 1 then labelFormat := '%.2f';
   // if regulDat.ParamMax >= 10 then labelFormat := '%.1f';
   // if regulDat.ParamMax >= 100 then labelFormat := '%.0f';

    with ParamPVInd do begin
       if  regulDat.ParamPV<>'' then
      begin
      iExpr := regulDat.ParamPV;
      if id>-1 then begin
      iMaxValue := rtItems.Items[id].MaxEU;
      iMinValue := rtItems.Items[id].MinEU;

      end;
      end;
      if regulDat.fExprAvString<>'' then
      ExprAv:=regulDat.fExprAvString;
      if  regulDat.fExprPrString<>'' then
      ExprPr:=regulDat.fExprPrString;
    end;
    with ParamFlySpInd do begin
      iExpr := regulDat.ParamFlySp;
      iMaxValue := 100{rtItems.Items[rtItems.GetSimpleID(regulDat.ParamPV)].MaxEU};
      iMinValue := 0 {rtItems.Items[rtItems.GetSimpleID(regulDat.ParamPV)].MinEU};

    end;
    with paramPVEdit do begin
      iExprVal:= regulDat.ParamPV;
    end;
      with IMPVEdit do begin
      iExprVal:= regulDat.IMPV;
    end;
    with paramSPTB.Param do begin
      rtName := regulDat.ParamSP;
      ImmiScope2.exprUpdate;
       if  regulDat.ParamPV<>'' then
      begin
      if id>-1 then begin
      MaxValue := rtItems.Items[id].MaxEU;
      MinValue := rtItems.Items[id].MinEU;
      end;
      end;
      Access := regulDat.Access;
    end;

    immiSyButton1.Param.rtName:='';
    immiimg11.IMMIProp.ExprVisible:='0';
    immiSyButton2.Param.rtName:='';
    immiimg14.IMMIProp.ExprVisible:='0';
    immiSyButton8.Param.rtName:='';
    immiimg17.IMMIProp.ExprVisible:='0';

    if trim(regulDat.avtomat)<>'' then
    begin
    immiimg12.IMMIProp.ExprVal:=regulDat.avtomat;
    immiimg13.IMMIProp.ExprVal:='!'+regulDat.avtomat;
    end else
    begin
    immiimg12.IMMIProp.ExprVal:='';
    immiimg13.IMMIProp.ExprVal:='';
    end;
    immiimg11.IMMIProp.ExprVal:=regulDat.ParamD1;
    immiimg14.IMMIProp.ExprVal:=regulDat.ParamD2;
    immiimg17.IMMIProp.ExprVal:=regulDat.ParamD3;

    if (regulDat.ParamD1<>'') then
    begin
    immiSyButton1.Param.rtName:=regulDat.ParamD1;
    immiSyButton1.Param.ExprVisible:='1';
    immiimg11.IMMIProp.ExprVisible:='1';
    end
    else
    begin
    immiSyButton1.Param.rtName:='';
    immiSyButton1.Param.ExprVisible:='0';
    immiimg11.IMMIProp.ExprVisible:='0';
    end;
    if (regulDat.ParamD2<>'') then
    begin
    immiSyButton2.Param.rtName:=regulDat.ParamD2;
    immiimg14.IMMIProp.ExprVisible:='1';
    immiSyButton2.Param.ExprVisible:='1';
    end
    else
    begin
    immiSyButton2.Param.rtName:='';
    immiimg14.IMMIProp.ExprVisible:='0';
    immiSyButton2.Param.ExprVisible:='0';
    end;
    if (regulDat.ParamD3<>'') then
    begin
    immiSyButton8.Param.rtName:=regulDat.ParamD3;
    immiimg17.IMMIProp.ExprVisible:='1';
    immiSyButton8.Param.ExprVisible:='1';
    end
    else
    begin
    immiSyButton8.Param.rtName:='';
    immiimg17.IMMIProp.ExprVisible:='0';
    immiSyButton8.Param.ExprVisible:='0';
    end;
    immiSyButton1.Caption:=regulDat.ParamDName1;
    immiSyButton2.Caption:=regulDat.ParamDName2;
    immiSyButton8.Caption:=regulDat.ParamDName3;
    if trim(regulDat.avtomat)<>'' then
    immiSyButton3.Param.rtName:=regulDat.avtomat else
    immiSyButton3.Param.rtName:='';

    immiSyButton6.Param.Access:=regulDat.Access;
    immiSyButton7.Param.Access:=regulDat.Access;
    immiSyButton3.Param.Access:=regulDat.Access;
    immiSyButton4.Param.Access:=regulDat.Access;
    IMPVInd.iExpr := regulDat.IMPV;
   { IMPVEdit.param.rtName := regulData.IMPV;
    IMPVEdit.param.Access := regulData.Access;  }
    IMSPEdit.iparam.rtName := regulDat.IMSP;
    IMSPEdit.iparam.Access := regulDat.Access;
    IMSPTB.Param.rtName := regulDat.IMSP;
    IMSPTB.Param.Access := regulDat.Access;
    if Trim(flabelformat)='' then flabelFormat:='%8.0f';
    if trim(regulDat.ParamPV)<>'' then
    begin
    if id>-1 then begin
    paramLabel0.Caption := trim(format (flabelFormat, [rtItems.Items[id].MinEU]));
    paramLabel50.Caption :=trim( format (flabelFormat, [(rtItems.Items[id].MaxEU-rtItems.Items[id].MinEU)/2 +
             rtItems.Items[id].MinEU]));
    paramLabel100.Caption :=trim( format (flabelFormat, [rtItems.Items[id].MaxEU]));
    end;
    end;
    caption:= string(regulDat.IMPV);
    Label2.Caption := regulDat.caption;
    Label12.Caption := Caption;
    Immilabelfull4.iExprVal:=regulDat.ParamSP;
    Immilabelfull5.iExprVal:=regulDat.IMSP;
    idim:=rtitems.GetSimpleID(regulDat.IMPV);
    if idim>-1 then
     begin
        Label6.Caption:=rtitems.GetEU(idim);
        Label15.Caption:=trim(format ('%8.0f', [rtItems.Items[idim].MaxEU]));
        Label8.Caption:=trim(format ('%8.0f', [(rtItems.Items[idim].MaxEU+rtItems.Items[idim].MinEU)/2]));
        Label11.Caption:=trim(format ('%8.0f', [rtItems.Items[idim].MinEU]));
        imsptb.param.maxValue:=round(rtItems.Items[idim].MaxEU);
        imsptb.param.minValue:=round(rtItems.Items[idim].MinEU);
        impvind.imaxValue:=rtItems.Items[idim].MaxEU;
        impvind.iminValue:=rtItems.Items[idim].MinEU;
     end else
     begin
        Label6.Caption:='%';
        Label15.Caption:='100';
        Label8.Caption:='50';
        Label11.Caption:='0';
        imsptb.param.maxValue:=100;
        imsptb.param.minValue:=0;
        impvind.imaxValue:=100;
        impvind.iminValue:=0;
     end;
;
    if ((regulDat.ParamD1='') and  (regulDat.ParamD2='') and (regulDat.ParamD3='')) then
      begin
        immiGroupBox2.Top:=283;
         immiGroupBox5.Visible:=false;
        Height:=575;
      end
    else
      begin

        immiGroupBox5.Visible:=true;
        immiGroupBox2.Top:=336;
        Height:=628;
      end;
       if  ((fBaz_Rg='') or (not fViwBaz_Rg)) then
        begin
         immigroupbox6.Visible:=false;
        end
       else
         begin
         immigroupbox6.Visible:=true;
         immiimg15.IMMIProp.ExprVal:='!'+fBaz_Rg;
         immiimg16.IMMIProp.ExprVal:=fBaz_Rg;
         immiSyButton7.Param.rtName:=fBaz_Rg;
         end;

    IMMILabelfull1.iExprVisible:=regulDat.fParamD1;
     if  regulDat.ParamPV<>'' then
      begin
    immiGroupBox1.Caption:={rtItems.GetComment(rtItems.GetSimpleID(regulDat.ParamPV))}reguldat.fNameParam;
      end; {else label5.Caption:=regulDat.IMSp; }
       with paramSPEdit.iParam do begin
      if regulDat.fisQuery then
      begin
      rtName := regulDat.ParamSP;
      MaxValue := regulDat.ParamMax;
      MinValue := regulDat.ParamMin;
      isQuery:=regulDat.fisQuery;
      Access := regulDat.Access;
      end else
      begin
       rtName := regulDat.ParamSP;
      MaxValue := regulDat.ParamMax;
      idpv:=rtitems.getsimpleid(regulDat.ParamPV);
      if idpv>-1 then
      begin
      MinValue := rtItems.Items[idpv].MinEU;
      MaxValue := rtItems.Items[idpv].MaxEU;
      end else
      begin
       MinValue := 0;
      MaxValue := 100;
      end;
      isQuery:=regulDat.fisQuery;
      Access := regulDat.Access;
      end;
    end;
   ImmiScope2.Indicator.gPen.Color:=clYellow;
   ImmiScope2.exprUpdate;
    if  regulDat.ParamPV<>'' then
      begin
       ImmiScope2.expr:=regulDat.ParamPv;
       ImmiScope2.exprUpdate;
       ImmiScope2.Expr1:=regulDat.IMPV;
      end else
      begin
      ImmiScope2.expr:=reguldat.IMPV;
      ImmiScope2.exprUpdate;
      ImmiScope2.Expr1:='';
      end;
   Label3.Caption:=regulDat.fNameEd;

   Label3.Caption:=regulDat.fNameEd;
    if ((fFPosition.FormTop>-1) and (fFPosition.FormLeft>-1) and (RegulList.Count=1)) then
             begin
               top:=fFPosition.FormTop;
               left:=fFPosition.FormLeft;
             end else
             begin
                top := self.ClientToScreen(Point(0, 0)).Y+5+self.Height;
                left := self.ClientToScreen(Point(0, 0)).X+5+self.Width;
                if (self.owner is TForm) then
                  begin
                   if  ((top+height)>((self.owner as TForm).top+(self.owner as TForm).Height)) then top:=top-height-10-self.Height;
                   if  ((left+width)>((self.owner as TForm).Left+(self.owner as TForm).Width)) then left:=left-width-10-self.width;
                   if top<20 then top:=20;
                   if left<20 then left:=20;
                  end

              end;
    if  regulDat.ParamPV='' then
      begin
        immigroupbox1.Visible:=false;
        immigroupbox3.top:=immigroupbox3.top-169;
        immigroupbox6.top:=immigroupbox3.top-169;
        sybutton1.Top:=sybutton1.Top-169;
        immigroupbox2.top:=immigroupbox2.top-169;
        immigroupbox5.top:=immigroupbox5.top-169;

     end;
      if  ((fNoavt) or
      ((reguldat.avtomat='') and (AccessLevel^<reguldat.fCorrectAccess) and (not ViwBaz_Rg))) then
       begin
          immigroupbox3.Visible:=false;
         immigroupbox2.top:=immigroupbox2.top-68;
        immigroupbox5.top:=immigroupbox5.top-68;

       end;

    clientheight:=immigroupbox2.Top+immigroupbox2.Height+5;
    pointActiv:=@isActive;
     if AccessLevel^<reguldat.fCorrectAccess then Sybutton1.Visible:=false else Sybutton1.Visible:=true;
     if ((regulDat.ParamSP='') and (regulDat.ParamFlySP<>'') and (mineupstr<>'') and (maxeupstr<>'')) then
            immilabelfull4.iExprval:= mineupstr + ' + (' + maxeupstr + '-' + mineupstr +') * '+regulDat.ParamFlySP + ' / 100 ';
     Show;
  end;
end;


procedure TIMMIRegul.ClickChange;
var
i,j, id,idpv,idim: integer;
regulF: TIMMIFormregul;
mineupstr, maxeupstr: string;

begin
   if labelFormat='' then labelFormat:='%3.0f';
  if regFr=nil then exit;
   regulF:=regFr;

//  RegFr.Label1.Caption:=self.Name;
   if frmRegSetup<>nil then frmRegSetup.Close;
   isActive:=true;

   mineupstr:= '';
   maxeupstr:= '';

  id:=rtItems.GetSimpleID(regulDat.ParamPV);
  
  if (self.Border.EnterColor<>clNone) then
     RegulF.Label2.Color:=self.Border.EnterColor
  else
     RegulF.Label2.Color:=$00C3C3C3;

  with RegulF do begin
    Hide;
    immigroupbox1.Visible:=true;
    immigroupbox3.Visible:=true;
    immigroupbox3.top:=213;
    immigroupbox6.top:=213;
    sybutton1.Top:=215;
    immigroupbox2.top:=339;
    immigroupbox5.top:=281;
     if AccessLevel^<regulDat.Access then
         begin
          if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для данной операции!');
          exit;
         end;

    if frmRegSetup=nil then frmRegSetup:=TfrmRegSetup.Create(Application);

     speedbutton2.Visible:=  (regulDat.ParamSP<>'');
     speedbutton3.Visible:=  (regulDat.ParamSP<>'');
     paramspedit.Visible:=   (regulDat.ParamSP<>'');
     paramsptb.Visible:=   (regulDat.ParamSP<>'');
     //Immishape1.Visible:=   (regulDat.ParamSP<>'');


    frmRegSetup.IMMILabelFull1.iExprVal:=RegulDat.fKp1;
    frmRegSetup.IMMILabelFull2.iExprVal:=RegulDat.fKp2;
    frmRegSetup.IMMIValueEntry1.iparam.rtName:=RegulDat.fKp1;
    frmRegSetup.IMMIValueEntry2.iparam.rtName:=RegulDat.fKp2;
    frmRegSetup.IMMILabelFull3.iExprVal:=RegulDat.fti1;
    frmRegSetup.IMMILabelFull4.iExprVal:=RegulDat.fTi2;
    frmRegSetup.IMMIValueEntry3.iparam.rtName:=RegulDat.fti1;
    frmRegSetup.IMMIValueEntry4.iparam.rtName:=RegulDat.fTi2;
     frmRegSetup.IMMIValueEntry5.iparam.rtName:=RegulDat.fdEps;
     frmRegSetup.IMMILabelFull5.iExprVal:=RegulDat.fdEps;
     fregset.TDEntry.iparam.rtName:=RegulDat.fTd;
     fregset.IMMILabelFull6.iExprVal:=RegulDat.fTd;
      fregset.IMMILabelFull7.iExprVal:=RegulDat.fddb;
     fregset.IMMIValueEntry7.iparam.rtName:=RegulDat.fddb;
      fregset.IMMILabelFull8.iExprVal:=RegulDat.ftfull;
     fregset.IMMIValueEntry8.iparam.rtName:=RegulDat.ftfull;
      fregset.IMMILabelFull9.iExprVal:=RegulDat.ftimp;
     fregset.IMMIValueEntry9.iparam.rtName:=RegulDat.ftimp;
     fregset.IMMILabelFull10.iExprVal:=RegulDat.fvsp;
     fregset.IMMIValueEntry10.iparam.rtName:=RegulDat.fvsp;
      fregset.IMMILabelFull11.iExprVal:=RegulDat.frv;
     fregset.IMMIValueEntry11.iparam.rtName:=RegulDat.frv;
    frmRegSetup.Panel1.Visible:=true;
    frmRegSetup.Panel2.Visible:=true;
    frmRegSetup.Panel3.Visible:=true;
    frmRegSetup.Panel4.Visible:=true;
     frmRegSetup.Panel5.Visible:=true;
     fregset.immiPanel1.Visible:=true;
    fregset.immiPanel2.Visible:=true;
    fregset.immiPanel3.Visible:=true;
    fregset.immiPanel4.Visible:=true;
     fregset.immiPanel5.Visible:=true;
    if RegulDat.fKp1='' then frmRegSetup.Panel1.Visible:=false;
    if RegulDat.fKp2='' then frmRegSetup.Panel2.Visible:=false;
    if RegulDat.fTi1='' then frmRegSetup.Panel3.Visible:=false;
    if RegulDat.fTi2='' then frmRegSetup.Panel4.Visible:=false;
     if RegulDat.fdeps='' then frmRegSetup.Panel5.Visible:=false;
     if RegulDat.fDDb='' then fregset.immiPanel1.Visible:=false;
    if RegulDat.fTfull='' then fregset.immiPanel2.Visible:=false;
    if RegulDat.fTimp='' then fregset.immiPanel3.Visible:=false;
    if RegulDat.fVsp='' then fregset.immiPanel4.Visible:=false;
     if RegulDat.fRv='' then fregset.immiPanel5.Visible:=false;



     immiSyButton1.Param.rtName:='';
    immiimg11.IMMIProp.ExprVisible:='0';
    immiSyButton2.Param.rtName:='';
    immiimg14.IMMIProp.ExprVisible:='0';
    immiSyButton8.Param.rtName:='';
    immiimg17.IMMIProp.ExprVisible:='0';

    if trim(regulDat.avtomat)<>'' then
    begin
    immiimg12.IMMIProp.ExprVal:=regulDat.avtomat;
    immiimg13.IMMIProp.ExprVal:='!'+regulDat.avtomat;
    end else
    begin
    immiimg12.IMMIProp.ExprVal:='';
    immiimg13.IMMIProp.ExprVal:='';
    end;
    immiimg11.IMMIProp.ExprVal:=regulDat.ParamD1;
    immiimg14.IMMIProp.ExprVal:=regulDat.ParamD2;
    immiimg17.IMMIProp.ExprVal:=regulDat.ParamD3;

    if (regulDat.ParamD1<>'') then
    begin
    immiSyButton1.Param.rtName:=regulDat.ParamD1;
    immiSyButton1.Param.ExprVisible:='1';
    immiimg11.IMMIProp.ExprVisible:='1';
    end
    else
    begin
    immiSyButton1.Param.rtName:='';
    immiSyButton1.Param.ExprVisible:='0';
    immiimg11.IMMIProp.ExprVisible:='0';
    end;
    if (regulDat.ParamD2<>'') then
    begin
    immiSyButton2.Param.rtName:=regulDat.ParamD2;
    immiimg14.IMMIProp.ExprVisible:='1';
    immiSyButton2.Param.ExprVisible:='1';
    end
    else
    begin
    immiSyButton2.Param.rtName:='';
    immiimg14.IMMIProp.ExprVisible:='0';
    immiSyButton2.Param.ExprVisible:='0';
    end;
    if (regulDat.ParamD3<>'') then
    begin
    immiSyButton8.Param.rtName:=regulDat.ParamD3;
    immiimg17.IMMIProp.ExprVisible:='1';
    immiSyButton8.Param.ExprVisible:='1';
    end
    else
    begin
    immiSyButton8.Param.rtName:='';
    immiimg17.IMMIProp.ExprVisible:='0';
    immiSyButton8.Param.ExprVisible:='0';
    end;
    immiSyButton1.Caption:=regulDat.ParamDName1;
    immiSyButton2.Caption:=regulDat.ParamDName2;
    immiSyButton8.Caption:=regulDat.ParamDName3;







    if trim(regulDat.avtomat)<>'' then
    immigroupBox2.ExprEnable:='!'+regulDat.avtomat else immigroupBox2.ExprEnable:='1';
    reguldat.fExprAvString:='';
    reguldat.fExprPrString:='';

    Avpr1.iBnNag:=regulDat.fNagStr;
    Avpr1.iBnVag:=regulDat.fVagStr;
    Avpr1.iBnNpg:=regulDat.fNpgStr;
    Avpr1.iBnVpg:=regulDat.fVpgStr;
    if  regulDat.ParamPV<>'' then
      begin
     id:=rtItems.GetSimpleID(regulDat.ParamPV);
     if id>-1 then begin
    Avpr1.Min:=rtItems.Items[rtItems.GetSimpleID(regulDat.ParamPV)].MinEU;
    Avpr1.Max:=rtItems.Items[rtItems.GetSimpleID(regulDat.ParamPV)].MaxEU;
           if (Avpr1.Min<>Avpr1.Max) then
       begin
       mineupstr:= floattostr( rtItems.Items[id].MinEU);
       maxeupstr:= floattostr( rtItems.Items[id].MaxEU);
       end; end;
     reguldat.fExprAvString:='0';
     reguldat.fExprprString:='0';
    if ((Avpr1.iBnNag<>'') and (Avpr1.iBnVag='')) then reguldat.fExprAvString:=regulDat.ParamPV+ '<' + regulDat.fNagStr;
    if ((Avpr1.iBnVag<>'') and (Avpr1.iBnNag<>'')) then reguldat.fExprAvString:='('+ regulDat.ParamPV+ '<' + regulDat.fNagStr+')|(' + regulDat.ParamPV+ '>' + regulDat.fVagStr+')';
    if ((Avpr1.iBnVag<>'') and (Avpr1.iBnNag='')) then reguldat.fExprAvString:= regulDat.ParamPV+ '>' + regulDat.fVagStr;
    if ((Avpr1.iBnNpg<>'') and (Avpr1.iBnVpg='')) then reguldat.fExprprString:=regulDat.ParamPV+ '<' + regulDat.fNpgStr;
    if ((Avpr1.iBnVpg<>'') and (Avpr1.iBnNpg<>'')) then reguldat.fExprprString:='('+ regulDat.ParamPV+ '<' + regulDat.fNpgStr +')|(' + regulDat.ParamPV+ ' > '  + regulDat.fVpgStr+')';
    if ((Avpr1.iBnVpg<>'') and (Avpr1.iBnNpg='')) then reguldat.fExprprString:=regulDat.ParamPV+ '>' + regulDat.fVPgStr;

    end;


    with ParamPVInd do begin
       if  regulDat.ParamPV<>'' then
      begin
      iExpr := regulDat.ParamPV;
      if id>-1 then begin
      iMaxValue := rtItems.Items[id].MaxEU;
      iMinValue := rtItems.Items[id].MinEU; end;
      end;
      if regulDat.fExprAvString<>'' then
      ExprAv:=regulDat.fExprAvString;
      if  regulDat.fExprPrString<>'' then
      ExprPr:=regulDat.fExprPrString;
    end;
    with ParamFlySpInd do begin
      iExpr := regulDat.ParamFlySp;
      iMaxValue := 100{rtItems.Items[rtItems.GetSimpleID(regulDat.ParamPV)].MaxEU};
      iMinValue := 0 {rtItems.Items[rtItems.GetSimpleID(regulDat.ParamPV)].MinEU};

    end;
    with paramPVEdit do begin
      iExprVal:= regulDat.ParamPV;
    end;
      with IMPVEdit do begin
      iExprVal:= regulDat.IMPV;
    end;

   
    with paramSPTB.Param do begin
      rtName := regulDat.ParamSP;
      ImmiScope2.exprUpdate;
       if  regulDat.ParamPV<>'' then
      begin
      if id>-1 then begin
      MaxValue := rtItems.Items[id].MaxEU;
      MinValue := rtItems.Items[id].MinEU; end;

      end;
      Access := regulDat.Access;
    end;

    if trim(regulDat.avtomat)<>'' then
    begin
    immiimg12.IMMIProp.ExprVal:=regulDat.avtomat;
    immiimg13.IMMIProp.ExprVal:='!'+regulDat.avtomat;
    end else
    begin
    immiimg12.IMMIProp.ExprVal:='';
    immiimg13.IMMIProp.ExprVal:='';
    end;
    immiimg11.IMMIProp.ExprVal:=regulDat.ParamD1;
    immiimg14.IMMIProp.ExprVal:=regulDat.ParamD2;
    immiimg17.IMMIProp.ExprVal:=regulDat.ParamD3;
    immiSyButton1.Param.rtName:=regulDat.ParamD1;
    immiSyButton2.Param.rtName:=regulDat.ParamD2;
    immiSyButton8.Param.rtName:=regulDat.ParamD3;
    immiSyButton1.Caption:=regulDat.ParamDName1;
    immiSyButton2.Caption:=regulDat.ParamDName2;
    immiSyButton8.Caption:=regulDat.ParamDName3;
    if trim(regulDat.avtomat)<>'' then
    immiSyButton3.Param.rtName:=regulDat.avtomat else
    immiSyButton3.Param.rtName:='';

    immiSyButton6.Param.Access:=regulDat.Access;
    immiSyButton7.Param.Access:=regulDat.Access;
    immiSyButton3.Param.Access:=regulDat.Access;
    immiSyButton4.Param.Access:=regulDat.Access;
    IMPVInd.iExpr := regulDat.IMPV;

    IMSPEdit.iparam.rtName := regulDat.IMSP;
    IMSPEdit.iparam.Access := regulDat.Access;
    IMSPTB.Param.rtName := regulDat.IMSP;
    IMSPTB.Param.Access := regulDat.Access;
    if Trim(flabelformat)='' then flabelFormat:='%8.0f';
    idim:=rtitems.GetSimpleID(regulDat.IMPV);
    if idim>-1 then
     begin
        Label6.Caption:=rtitems.GetEU(idim);
        Label15.Caption:=trim(format ('%8.0f', [rtItems.Items[idim].MaxEU]));
        Label8.Caption:=trim(format ('%8.0f', [(rtItems.Items[idim].MaxEU+rtItems.Items[idim].MinEU)/2]));
        Label11.Caption:=trim(format ('%8.0f', [rtItems.Items[idim].MinEU]));
        imsptb.param.maxValue:=round(rtItems.Items[idim].MaxEU);
        imsptb.param.minValue:=round(rtItems.Items[idim].MinEU);
        impvind.imaxValue:=rtItems.Items[idim].MaxEU;
        impvind.iminValue:=rtItems.Items[idim].MinEU;
     end else
     begin
        Label6.Caption:='%';
        Label15.Caption:='100';
        Label8.Caption:='50';
        Label11.Caption:='0';
        imsptb.param.maxValue:=100;
        imsptb.param.minValue:=0;
        impvind.imaxValue:=100;
        impvind.iminValue:=0;
     end;
    if trim(regulDat.ParamPV)<>'' then
    begin
    if id>-1 then begin
    paramLabel0.Caption := trim(format (flabelFormat, [rtItems.Items[id].MinEU]));
    paramLabel50.Caption :=trim( format (flabelFormat, [(rtItems.Items[id].MaxEU-rtItems.Items[id].MinEU)/2 + rtItems.Items[id].MinEU]));
    paramLabel100.Caption :=trim( format (flabelFormat, [rtItems.Items[id].MaxEU])); end;
    end;
    caption:= string(regulDat.IMPV);
    Label2.Caption := regulDat.caption;
    Label12.Caption := Caption;
    Immilabelfull4.iExprVal:=regulDat.ParamSP;
    Immilabelfull5.iExprVal:=regulDat.IMSP;
    if ((regulDat.ParamD1='') and  (regulDat.ParamD2='') and (regulDat.ParamD3='')) then
      begin
        immiGroupBox2.Top:=283;
         immiGroupBox5.Visible:=false;
        Height:=575;
      end
    else
      begin

        immiGroupBox5.Visible:=true;
        immiGroupBox2.Top:=336;
        Height:=628;
      end;
       if  ((fBaz_Rg='') or (not fViwBaz_Rg)) then
        begin
         immigroupbox6.Visible:=false;
        end
       else
         begin
         immigroupbox6.Visible:=true;
         immiimg15.IMMIProp.ExprVal:='!'+fBaz_Rg;
         immiimg16.IMMIProp.ExprVal:=fBaz_Rg;
         immiSyButton7.Param.rtName:=fBaz_Rg;
         end;

     if ((regulDat.fParamD2<>'') and (regulDat.fParamD3<>'')) then  IMMILabelfull1.iExprVisible:='1';
     if  regulDat.ParamPV<>'' then
      begin
    immiGroupBox1.Caption:={rtItems.GetComment(rtItems.GetSimpleID(regulDat.ParamPV))}reguldat.fNameParam;
      end;
    with paramSPEdit.iParam do begin
      if regulDat.fisQuery then
      begin
      rtName := regulDat.ParamSP;
      MaxValue := regulDat.ParamMax;
      MinValue := regulDat.ParamMin;
      isQuery:=regulDat.fisQuery;
      Access := regulDat.Access;
      end else
      begin
       rtName := regulDat.ParamSP;
      MaxValue := regulDat.ParamMax;
      idpv:=rtitems.getsimpleid(regulDat.ParamPV);
      if idpv>-1 then
      begin
      MinValue := rtItems.Items[idpv].MinEU;
      MaxValue := rtItems.Items[idpv].MaxEU;
      end else
      begin
       MinValue := 0;
      MaxValue := 100;
      end;
      isQuery:=regulDat.fisQuery;
      Access := regulDat.Access;
      end;
    end;
   ImmiScope2.Indicator.gPen.Color:=clYellow;
   ImmiScope2.exprUpdate;
    if  regulDat.ParamPV<>'' then
      begin
       ImmiScope2.expr:=regulDat.ParamPv;
       ImmiScope2.exprUpdate;
       ImmiScope2.Expr1:=regulDat.IMPV;
      end else
      begin
      ImmiScope2.expr:=reguldat.IMPV;
      ImmiScope2.exprUpdate;
      ImmiScope2.Expr1:='';
      end;
   Label3.Caption:=regulDat.fNameEd;

   Label3.Caption:=regulDat.fNameEd;

    if  regulDat.ParamPV='' then
      begin
        immigroupbox1.Visible:=false;
        immigroupbox3.top:=immigroupbox3.top-169;
        immigroupbox6.top:=immigroupbox3.top-169;
        sybutton1.Top:=sybutton1.Top-169;
        immigroupbox2.top:=immigroupbox2.top-169;
        immigroupbox5.top:=immigroupbox5.top-169;

     end;
      if  ((fNoavt) or
      ((reguldat.avtomat='') and (AccessLevel^<reguldat.fCorrectAccess) and (not ViwBaz_Rg))) then
       begin
          immigroupbox3.Visible:=false;
         immigroupbox2.top:=immigroupbox2.top-68;
        immigroupbox5.top:=immigroupbox5.top-68;

       end;

    clientheight:=immigroupbox2.Top+immigroupbox2.Height+5;
    pointActiv:=@isActive;
     if AccessLevel^<reguldat.fCorrectAccess then Sybutton1.Visible:=false else Sybutton1.Visible:=true;
     RegulF.label5.Caption:='';
     if ((regulDat.ParamSP='') and (regulDat.ParamFlySP<>'') and (mineupstr<>'') and (maxeupstr<>'')) then
            immilabelfull4.iExprval:= mineupstr + ' + (' + maxeupstr + '-' + mineupstr +') * '+regulDat.ParamFlySP + ' / 100 ';
     Show;
  end;
end;



constructor TRegulData.Create;
begin
 inherited;
 fParamMax:=100;
end;


procedure TRegulData.SetAccess(value: integer);
begin
     faccess := value;
end;

procedure TIMMIRegul.ShowPropForm;
begin
     with tregulEditF.create(nil) do
       try
       if  self.Noavt then combobox1.ItemIndex:=1
        else combobox1.ItemIndex:=0;
        editexpr27.Text:=self.Baz_Rg;
        editexpr26.Text:=self.exprEnable;
        editexpr28.Text:=self.SentFro;
        edit1.Text:=labelformat;
        if (self.FPosition.FormTop<0) or (self.FPosition.FormTop<0)  then
        combobox2.itemindex:=1 else combobox2.itemindex:=0;
        spinedit1.Value:=fposition.FormLeft;
        spinedit2.Value:=fposition.Formtop;
        prcaption.Text:=RegulData.caption;
        praccess.Value:=RegulData.Access;
        pravtomat.Text:=RegulData.avtomat;
        prparampv.Text:=RegulData.ParamPV;
        prparamsp.Text:=RegulData.ParamSP;
        prparamflysp.Text:=RegulData.ParamFlySp;
        prIMpv.Text:=RegulData.IMPV;
        primsp.Text:=reguldata.IMSp;
        prkp1.Text:=RegulData.Kp1;
        prkp2.Text:=RegulData.Kp2;
        prti1.Text:=RegulData.Ti1;
        prti2.Text:=RegulData.Ti2;
        prtd.Text:=RegulData.Td;
        prdeps.Text:=RegulData.dEps;
        prddb.Text:=RegulData.DDb;
        prtfull.Text:=RegulData.Tfull;
        prtimp.Text:=RegulData.Timp;
        prvsp.Text:=RegulData.Vsp;
        prrv.text:=RegulData.Rv;
        prparamdname1.Text:=RegulData.ParamDName1;
        prparamdname2.Text:=RegulData.ParamDName2;
        prparamdname3.Text:=RegulData.ParamDName3;
        prparamd1.Text:=RegulData.ParamD1;
        prparamd2.Text:=RegulData.ParamD2;
        prparamd3.Text:=RegulData.ParamD3;
        pribnnag.Text:=RegulData.iBnNag;
        pribnnpg.Text:=RegulData.iBnNpg;
        pribnvag.Text:=RegulData.iBnvag;
        pribnvpg.Text:=RegulData.iBnvpg;
        PRNAMEPARAM.Text:=RegulData.nameparam;
        PRNAMEed.Text:=RegulData.nameed;
        prisquery.Checked:=RegulData.isQuery;
        prparammin.Data:=RegulData.fParamMin;
        prparammax.Data:=RegulData.fParamMax;


        prcaption1.Text:=RegulDatares.caption;
        praccess1.Value:=RegulDatares.Access;
        pravtomat1.Text:=RegulDatares.avtomat;
        prparampv1.Text:=RegulDatares.ParamPV;
        prparamsp1.Text:=RegulDatares.ParamPV;
        prparamflysp1.Text:=RegulDatares.ParamFlySp;
        prIMpv1.Text:=RegulDatares.IMPV;
        primsp1.Text:=reguldatares.IMSp;
        prkp11.Text:=RegulDatares.Kp1;
        prkp21.Text:=RegulDatares.Kp2;
        prti11.Text:=RegulDatares.Ti1;
        prti21.Text:=RegulDatares.Ti2;
        prtd1.Text:=RegulDatares.Td;
        prdeps1.Text:=RegulDatares.dEps;
        prddb1.Text:=RegulDatares.DDb;
        prtfull1.Text:=RegulDatares.Tfull;
        prtimp1.Text:=RegulDatares.Timp;
        prvsp1.Text:=RegulDatares.Vsp;
        prrv1.text:=RegulDatares.Rv;
        prparamdname11.Text:=RegulDatares.ParamDName1;
        prparamdname21.Text:=RegulDatares.ParamDName2;
        prparamdname31.Text:=RegulDatares.ParamDName3;
         prparamd11.Text:=RegulDatares.ParamD1;
        prparamd21.Text:=RegulDatares.ParamD2;
        prparamd31.Text:=RegulDatares.ParamD3;
        pribnnag1.Text:=RegulDatares.iBnNag;
        pribnnpg1.Text:=RegulDatares.iBnNpg;
        pribnvag1.Text:=RegulDatares.iBnvag;
        pribnvng1.Text:=RegulDatares.iBnvpg;

        PRNAMEPARAM1.Text:=RegulDatares.nameparam;
        PRNAMEed1.Text:=RegulDatares.nameed;
        prisquery1.Checked:=RegulDatares.isQuery;
        prparammin1.Data:=RegulDatares.fParamMin;
        prparammax1.Data:=RegulDatares.fParamMax;
    
          {Edit1.Text := RegulData.caption;

          Edit2.text := RegulData.avtomat;
          Edit3.text := regulData.Kp1;
          Edit4.text := regulData.Ti1;
          SpinEdit1.Value := RegulData.access;

          StringGrid1.Cells[1,1] := RegulData.ParamPV;
          StringGrid1.Cells[1,2] := RegulData.ParamSP;
          StringGrid1.Cells[1,3] := RegulData.ParamFlySP;
          StringGrid1.Cells[1,4] := floattostr(RegulData.ParamMin);
          StringGrid1.Cells[1,5] := floattostr(RegulData.ParamMax);

          StringGrid1.Cells[2,1] := RegulData.IMPV;
          StringGrid1.Cells[2,2] := RegulData.IMSP;
          StringGrid1.Cells[2,3] := 'XXXXX';
          StringGrid1.Cells[2,4] := 'const = 0';
          StringGrid1.Cells[2,5] := 'const = 100';}

          if ShowModal = mrOK then begin


         self.Noavt:=(combobox1.ItemIndex=1);
         self.Baz_Rg:=editexpr27.Text;
         self.exprEnable:=editexpr26.Text;
         self.SentFro:=editexpr28.Text;
         labelformat:=edit1.Text;
         fposition.FormLeft:=spinedit1.Value;
         fposition.Formtop:=spinedit2.Value;
         RegulData.caption:=prcaption.Text;
         RegulData.Access:=praccess.Value;
         RegulData.avtomat:=pravtomat.Text;
         RegulData.ParamPV:=prparampv.Text;
         RegulData.ParamSP:= prparamsp.Text;
         RegulData.ParamFlySp:= prparamflysp.Text;
         RegulData.IMPV:=prIMpv.Text;
         reguldata.IMSp:=primsp.Text;
         RegulData.Kp1:=prkp1.Text;
         RegulData.Kp2:=prkp2.Text;
         RegulData.Ti1:=prti1.Text;
         RegulData.Ti2:=prti2.Text;
         RegulData.Td:=prtd.Text;
         RegulData.dEps:=prdeps.Text;
         RegulData.DDb:=prddb.Text;
         RegulData.Tfull:=prtfull.Text;
         RegulData.Timp:=prtimp.Text;
         RegulData.Vsp:=prvsp.Text;
         RegulData.Rv:=prrv.text;
         RegulData.ParamDName1:=prparamdname1.Text;
         RegulData.ParamDName2:=prparamdname2.Text;
         RegulData.ParamDName3:=prparamdname3.Text;
         RegulData.ParamD1:=prparamd1.Text;
         RegulData.ParamD2:=prparamd2.Text;
         RegulData.ParamD3:=prparamd3.Text;
         RegulData.iBnNag:=pribnnag.Text;
         RegulData.iBnNpg:=pribnnpg.Text;
         RegulData.iBnvag:=pribnvag.Text;
         RegulData.iBnvpg:=pribnvpg.Text;
         RegulData.nameparam:=PRNAMEPARAM.Text;
         RegulData.nameed:=PRNAMEed.Text;
         RegulData.isQuery:=prisquery.Checked;
         RegulData.fParamMin:=prparammin.Data;
         RegulData.fParamMax:=prparammax.Data;


        RegulDatares.caption:=prcaption1.Text;
        RegulDatares.Access:=praccess1.Value;
        RegulDatares.avtomat:=pravtomat1.Text;
        RegulDatares.ParamPV:=prparampv1.Text;
        RegulDatares.ParamPV:=prparamsp1.Text;
        RegulDatares.ParamFlySp:=prparamflysp1.Text;
        RegulDatares.IMPV:=prIMpv1.Text;
        reguldatares.IMSp:=primsp1.Text;
        RegulDatares.Kp1:=prkp11.Text;
        RegulDatares.Kp2:=prkp21.Text;
        RegulDatares.Ti1:=prti11.Text;
        RegulDatares.Ti2:=prti21.Text;
        RegulDatares.Td:=prtd1.Text;
        RegulDatares.dEps:=prdeps1.Text;
        RegulDatares.DDb:=prddb1.Text;
        RegulDatares.Tfull:=prtfull1.Text;
        RegulDatares.Timp:=prtimp1.Text;
        RegulDatares.Vsp:=prvsp1.Text;
        RegulDatares.Rv:=prrv1.text;
        RegulDatares.ParamDName1:=prparamdname11.Text;
        RegulDatares.ParamDName2:=prparamdname21.Text;
        RegulDatares.ParamDName3:=prparamdname31.Text;
        RegulDatares.ParamD1:=prparamd11.Text;
        RegulDatares.ParamD2:=prparamd21.Text;
        RegulDatares.ParamD3:=prparamd31.Text;
        RegulDatares.iBnNag:=pribnnag1.Text;
        RegulDatares.iBnNpg:=pribnnpg1.Text;
        RegulDatares.iBnvag:=pribnvag1.Text;
        RegulDatares.iBnvpg:=pribnvng1.Text;
        RegulDatares.nameparam:=PRNAMEPARAM1.Text;
        RegulDatares.nameed:=PRNAMEed1.Text;
        RegulDatares.isQuery:=prisquery1.Checked;
        RegulDatares.fParamMin:=prparammin1.Data;
        RegulDatares.fParamMax:=prparammax1.Data;

          end;
       finally
          Free;
       end;
     end;

procedure TIMMIRegul.ShowPropFormMsg(var Msg: TMessage);
begin
  //IMMIUninit(Msg);

  ShowPropForm;

  try
    //IMMIInit(Msg);
  except
    on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], E.HelpContext);
        perform(WM_IMMSHOWPROPFORM, 0, 0);
      end;
  end;
end;

end.
