unit IMMILabelRotateU;

interface

uses controls, classes, stdctrls, messages, sysUtils, Forms, Graphics,
     constDef, Expr,ImmilabelFullU,PDJRotoLabel, dialogs, IMMIPropertysU, windows;

type
   TWinCont = class(TWinControl);



  TIMMILabelRotate = class(TPDJRotoLabel)
  private
    { Private declarations }
    //Show value
     initcolor: TColor;
    fExprValue: tExpretion;
    fExprValueString: TExprStr;
     fisgraphic: boolean;
     fFPosition: TFPosition;
    //change color
    fExprColor: tExpretion;
    fExprColorString: TExprStr;
    fColorOn, fColorOff: TColor;
    //Check visibility
    fExprVisible,fExprBlink: tExpretion;
    fExprVisibleString, fExprBlinkString: TExprStr;
    fnotbouds: boolean;
    fBounds: tboundsString;
    fisDiscret: boolean;
    fnoActive: boolean;
    //flabelFormat: string;
  protected
    { Protected declarations }
    procedure Click; override;
  public
    { Public declarations }
    formatStr: string;
    fColMinute: integer;
    procedure Loaded; override;
    procedure ShowPropForm;
    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }

  //  property labelFormat: string read flabelFormat write flabelFormat;
    property FPosition: TFPosition read fFPosition write fFPosition;
    property iExprVal: TExprStr read fExprValueString write fExprValueString;
    property iExprColor: TExprStr read fExprColorString write fExprColorString;
    property iColorOn: TColor read fColorOn write fColorOn;
    property iColorOff: TColor read fColorOff write fColorOff;
    property iExprVisible: TExprStr read fExprVisibleString write fExprVisibleString;
     property iExprBlink: TExprStr read fExprBlinkString write fExprBlinkString;
    property iBounds: TBoundsString read fBounds write fBounds;
    property isGraphic: boolean read fisgraphic write fisgraphic;
    property isDiscret: boolean read fisDiscret write fisDiscret;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ImmiBlinkOn (var Msg: TMessage); message WM_IMMIBLINKON;
    procedure ImmiBlinkOff (var Msg: TMessage); message WM_IMMIBLINKOFF;
    property ColMinute: integer read fColMinute write fColMinute;
    property notbouds: boolean read fnotbouds write fnotbouds;
    property noActive: boolean read fnoActive write fnoActive;
  end;

procedure Register;




implementation

Uses IMMIAnalogPropU, MemStructsU, AnalogpropGraphic, IMMILabelREditorU;

procedure Register;
begin
 // RegisterComponents('IMMISample', [TIMMILabelRotate]);
end;


procedure TIMMILabelRotate.ShowPropForm;
begin
 with TLabelREditorFrm.Create(nil) do begin
    Edit1.Text := self.Caption;
    Edit2.Text := iExprVal;
    Edit3.Text := iExprVisible;
    Edit4.Text := iExprColor;
    editexpr1.text:= iExprBlink;
    editexpr2.text:= iBounds.vag;
    editexpr4.text:= iBounds.vpg;
    editexpr3.text:= iBounds.npg;
    editexpr5.text:= iBounds.nag;
    ColorBox1.Selected := iColorOn;
    ColorBox2.Selected := iColorOff;
    checkbox1.checked:=not noActive;
    checkbox2.checked:=transparent;
    label16.color:=self.color;
    label16.font.assign(self.font);
    label16.Transparent:=self.transparent;
    label16.caption:=self.caption;
    combobox2.ItemIndex:=integer(self.Angle);
    label16.angle:=self.angle;
    if isgraphic then Radiogroup1.itemindex:=1 else
    Radiogroup1.itemindex:=0;
    if (self.fposition.formleft<0)and (self.fposition.formtop<0) then
           Combobox1.itemindex:=0 else Combobox1.itemindex:=1;
    spinedit1.value:=self.fposition.formleft;
    spinedit2.value:=self.fposition.formtop;
    spinedit3.value:=self.colminute;
    if isdiscret then radiogroup2.itemindex:=0 else radiogroup2.itemindex:=1;
    updateS;
    if ShowModal = mrOK then begin
      self.caption := Edit1.Text;
      iExprVal := Edit2.Text;
      iExprVisible := Edit3.Text;
      iExprColor := Edit4.Text;
      iColorOn := ColorBox1.Selected;
      iColorOff := ColorBox2.Selected;
      noActive:= not checkbox1.checked;
      isgraphic:=(Radiogroup1.itemindex=1);
      if Combobox1.itemindex=0 then
        begin
          self.fposition.formleft:=-1;
          self.fposition.formtop:=-1;
        end else
        begin
          self.fposition.formleft:=spinedit1.value;
          self.fposition.formtop:=spinedit2.value;
        end;
        self.color:=label16.color;
        self.font.assign(label16.font);
        self.Transparent:=label16.transparent;
       self.colminute:=spinedit3.value;
       iExprBlink:=editexpr1.text;
       iBounds.vag:=editexpr2.text;
       iBounds.vpg:=editexpr4.text;
       iBounds.npg:=editexpr3.text;
       iBounds.nag:=editexpr5.text;
       if  combobox2.ItemIndex<0 then combobox2.ItemIndex:=0;
       self.Angle:=label16.angle;
    end;
    Free;
  end;
end;

procedure TIMMILabelRotate.ShowPropFormMsg(var Msg: TMessage);
begin
   IMMIUninit(Msg);

  ShowPropForm;

  try
    IMMIInit(Msg);
  except
    on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], E.HelpContext);
        perform(WM_IMMSHOWPROPFORM, 0, 0);
      end;
  end;
end;

procedure TIMMILabelRotate.Click;
var
  id: longInt;
  i,j: integer;
  alg: TAnalogGraph;
begin
  inherited;
  if fnoActive then Exit;
    if not integer(GetKeyState(VK_SHIFT))<0 then
      begin
        if AnalogGraphList.Count=0 then
           begin
              Alg:=TAnalogGraph.Create(application);
              AnalogGraphList.add(Alg);
           end;
        while AnalogGraphList.Count>1 do
        TForm(AnalogGraphList.last).close;
        alg:=AnalogGraphList.Items[0];
      end else
      begin
        Alg:=TAnalogGraph.Create(application);
        for i:=0 to  AnalogGraphList.Count-1 do
          TForm(AnalogGraphList.Items[i]).Show;
        AnalogGraphList.Insert(0,Alg);
     end;
     // Alg:=TAnalogGraph.Create(application);
     if IMMIAnalogProp=nil then IMMIAnalogProp:=TIMMIAnalogProp.Create(application);

  if (fExprValueString <> '') and rtItems.isIdent(fExprValueString) then
  begin
    if not fisgraphic then
      begin
        with IMMIAnalogProp do
          begin
          // width:=228;
           id := rtItems.GetSimpleID(fExprValueString);
           Hide;
           LName.Caption := fExprValueString;
           if id>-1 then LComment.Caption := rtItems.GetComment(ID);
           IMMILabel1.iExprVal := fExprValueString;
           IMMILabel2.iExprVal := iBounds.Nag;
           IMMILabel3.iExprVal := iBounds.Npg;
           IMMILabel4.iExprVal := iBounds.Vpg;
           IMMILabel5.iExprVal := iBounds.Vag;
           IMMILabelfull1.iExprVal := iBounds.Nag;
           IMMILabelfull2.iExprVal := iBounds.Npg;
           IMMILabelfull3.iExprVal := iBounds.Vpg;
           IMMILabelfull4.iExprVal := iBounds.Vag;
           IMMIValueEntry1.iParam.rtName := iBounds.Nag;
           IMMIValueEntry2.iParam.rtName := iBounds.Npg;
           IMMIValueEntry3.iParam.rtName := iBounds.Vpg;
           IMMIValueEntry4.iParam.rtName := iBounds.Vag;
           IMMIValueEntry1.iParam.access := iBounds.iaccess;
           IMMIValueEntry2.iParam.access := iBounds.iaccess;
           IMMIValueEntry3.iParam.access := iBounds.iaccess;
           IMMIValueEntry4.iParam.access := iBounds.iaccess;
           if id>-1 then begin
           IMMIValueEntry1.iParam.MinValue := rtItems[ID].MinEu;
           IMMIValueEntry2.iParam.MinValue := rtItems[ID].MinEu;
           IMMIValueEntry3.iParam.MinValue := rtItems[ID].MinEu;
           IMMIValueEntry4.iParam.MinValue := rtItems[ID].MinEu;
           IMMIValueEntry1.iParam.MaxValue := rtItems[ID].MaxEu;
           IMMIValueEntry2.iParam.MaxValue := rtItems[ID].MaxEu;
           IMMIValueEntry3.iParam.MaxValue := rtItems[ID].MaxEu;
           IMMIValueEntry4.iParam.MaxValue := rtItems[ID].MaxEu;

           IMMIShape1.iMinValue := rtItems[ID].MinEu;
           IMMIShape1.iMaxValue := rtItems[ID].MaxEu;
           Label1.Caption := floattostr (rtItems[ID].MinEu);
           Label2.Caption := floattostr (rtItems[ID].MaxEu);
           Label3.Caption :=
           floattostr ((rtItems[ID].MaxEu - rtItems[ID].MinEu) / 2);
           end;
            IMMIShape1.iExpr := fExprValueString;
           if (((iBounds.NAG='') and (iBounds.NPG='') and (iBounds.VAG='')and (iBounds.VPG=''))) then
           begin
              Avpr1.Min:=0;
              Avpr1.Max:=100;
           end
           else
           begin
             if id>-1 then begin
             Avpr1.Min:=rtItems.Items[rtItems.GetSimpleID(iExprVal)].MinEU;
             Avpr1.Max:=rtItems.Items[rtItems.GetSimpleID(iExprVal)].MaxEU;
             end;
           end;
           Avpr1.iBnNag:=iBounds.Nag;
           Avpr1.iBnVag:=iBounds.Vag;
           Avpr1.iBnNpg:=iBounds.Npg;
           Avpr1.iBnVpg:=iBounds.Vpg;
           immipanel9.Visible:=false;
            if (((iBounds.NAG='') and (iBounds.NPG='') and (iBounds.VAG='')and (iBounds.VPG=''))) then
           immipanel9.Visible:=false else  immipanel9.Visible:=true;
                if ((accesslevel^<iBounds.iaccess) or ((iBounds.NAG='') and (iBounds.NPG='') and (iBounds.VAG='')and (iBounds.VPG=''))) then
             begin
              immipanel7.Visible:=false;
             end
           else
             begin
               immipanel7.Visible:=false;
             end;

           if ((fFPosition.FormTop>-1) and (fFPosition.FormLeft>-1)) then
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
           Show;
          end
      end
   else

       with Alg do
          begin
            
            if fcolminute=0 then
             begin
             ImmiScope1.colminute:=10;
             label11.caption:='10';
            label12.caption:='5';
             end
             else
            begin
            ImmiScope1.colminute:=self.colminute;
            label11.caption:=inttostr(colminute);
            label12.caption:=inttostr(round(colminute/2));
            end;
            if (self.font.color<>clWindowtext) and (self.font.color<>clBlack) then
            ImmiScope1.indicator.gPen.color:=self.font.color else ImmiScope1.indicator.gPen.color:=clYellow;
            if (self.font.color<>clWindowtext) and (self.font.color<>clBlack) then
            Immilabel1.font.color:=self.font.color else Immilabel1.font.color:=clYellow;
            Immilabel1.icoloroff:=self.icoloroff;
            Immilabel1.icoloron:=self.icoloron;
            Immilabel1.iExprval:=self.iExprval;
            ImmiScope1.indicator.isDiscret:=self.isDiscret;
            Immipanel1.Visible:=false;
            Immipanel3.Visible:=false;
            Immipanel4.Visible:=false;
            Immipanel5.Visible:=false;
            Immipanel6.Visible:=false;
            Immipanel7.Visible:=false;
            Immipanel10.Visible:=false;
            Immipanel11.Visible:=false;
            Immipanel12.Visible:=false;
            Immipanel13.Visible:=false;
          //  hide;
           Immiscope1.ibnNag:=ibounds.Nag;
           Immiscope1.ibnVag:=ibounds.Vag;
           Immiscope1.ibnNpg:=ibounds.Npg;
           Immiscope1.ibnVpg:=ibounds.Vpg;
           //ImmiScope1.Indicator.gPen.Color:=clYellow;
           ImmiScope1.exprUpdate;
           ImmiScope1.expr:=fExprValueString;
           Immipanel1.Visible:=false;

           id := rtItems.GetSimpleID(fExprValueString);
           Hide;
           Caption := fExprValueString;
           //LComment.Caption := rtItems.GetComment(ID);
          // IMMILabel1.font.color:=font.color;
           IMMILabel1.formatstr:= formatstr;
           IMMILabel2.formatstr := formatstr;
           IMMILabel3.formatstr := formatstr;
           IMMILabel4.formatstr := formatstr;
           IMMILabel5.formatstr := formatstr;
           IMMILabelfull1.formatstr := formatstr;
           IMMILabelfull2.formatstr := formatstr;
           IMMILabelfull3.formatstr := formatstr;
           IMMILabelfull4.formatstr := formatstr;

           IMMILabel1.iExprVal := fExprValueString;
           IMMILabel2.iExprVal := iBounds.Nag;
           IMMILabel3.iExprVal := iBounds.Npg;
           IMMILabel4.iExprVal := iBounds.Vpg;
           IMMILabel5.iExprVal := iBounds.Vag;
           IMMILabelfull1.iExprVal := iBounds.Nag;
           IMMILabelfull2.iExprVal := iBounds.Npg;
           IMMILabelfull3.iExprVal := iBounds.Vpg;
           IMMILabelfull4.iExprVal := iBounds.Vag;
           IMMIValueEntry1.iParam.rtName := iBounds.Nag;
           IMMIValueEntry2.iParam.rtName := iBounds.Npg;
           IMMIValueEntry3.iParam.rtName := iBounds.Vpg;
           IMMIValueEntry4.iParam.rtName := iBounds.Vag;
           IMMIValueEntry1.iParam.access := iBounds.iaccess;
           IMMIValueEntry2.iParam.access := iBounds.iaccess;
           IMMIValueEntry3.iParam.access := iBounds.iaccess;
           IMMIValueEntry4.iParam.access := iBounds.iaccess;
           if id>-1 then begin
           IMMIValueEntry1.iParam.MinValue := rtItems[ID].MinEu;
           IMMIValueEntry2.iParam.MinValue := rtItems[ID].MinEu;
           IMMIValueEntry3.iParam.MinValue := rtItems[ID].MinEu;
           IMMIValueEntry4.iParam.MinValue := rtItems[ID].MinEu;
           IMMIValueEntry1.iParam.MaxValue := rtItems[ID].MaxEu;
           IMMIValueEntry2.iParam.MaxValue := rtItems[ID].MaxEu;
           IMMIValueEntry3.iParam.MaxValue := rtItems[ID].MaxEu;
           IMMIValueEntry4.iParam.MaxValue := rtItems[ID].MaxEu;

           IMMIShape1.iMinValue := rtItems[ID].MinEu;
           IMMIShape1.iMaxValue := rtItems[ID].MaxEu;
           if id>-1 then label1.Caption:=rtItems.GetComment(ID);

           Avpr1.Min:=rtItems.Items[rtItems.GetSimpleID(iExprVal)].MinEU;
           Avpr1.Max:=rtItems.Items[rtItems.GetSimpleID(iExprVal)].MaxEU;
           end;
           

       //    ImmiScope1.minValEu:=self.minValEu;
          //  ImmiScope1.maxValEu:=self.maxValEu;
           IMMILabel1.Color:=self.Color;
           IMMIShape1.iExpr := fExprValueString;
           Avpr1.iBnNag:=iBounds.Nag;
           Avpr1.iBnVag:=iBounds.Vag;
           Avpr1.iBnNpg:=iBounds.Npg;
           Avpr1.iBnVpg:=iBounds.Vpg;





             if IMMILabel5.iExprVal = '' then
              begin
              IMMIPanel6.Visible:=false;
              IMMIPanel13.Visible:=false;
              end
           else
              begin
              IMMIPanel6.Visible:=true;
              IMMIPanel13.Visible:=true;
              end;


           if IMMILabel4.iExprVal = '' then
              begin
              IMMIPanel5.Visible:=false;
              IMMIPanel12.Visible:=false;
              end
           else
              begin
             IMMIPanel5.Visible:=true;
             IMMIPanel12.Visible:=true;
              end;


           if IMMILabel3.iExprVal = '' then
             begin
             IMMIPanel4.Visible:=false;
             IMMIPanel11.Visible:=false;
             end
           else
             begin
             IMMIPanel4.Visible:=true;
             IMMIPanel11.Visible:=true;
             end;


           if IMMILabel2.iExprVal = '' then
              begin
              IMMIPanel3.Visible:=false;
              IMMIPanel10.Visible:=false;
              end
           else
              begin
              IMMIPanel3.Visible:=true;
              IMMIPanel10.Visible:=true;
              end;







           if (((iBounds.NAG='') and (iBounds.NPG='') and (iBounds.VAG='')and (iBounds.VPG=''))) then
               immipanel9.Visible:=false else  immipanel9.Visible:=true;
           if ((accesslevel^<iBounds.iaccess) or ((iBounds.NAG='') and (iBounds.NPG='') and (iBounds.VAG='')and (iBounds.VPG=''))) then
               begin
              Immipanel7.Visible:=false;
              Immipanel1.Visible:=false;
               end
           else
                begin
               Immipanel7.Visible:=true;
                end;
           Immipanel1.Visible:=false;
         //  if AnalogGraphList.Count>1 then fFPosition.FormTop:=-1;
          Alg.Repaint;
           if ((fFPosition.FormTop>-1) and (fFPosition.FormLeft>-1) and (AnalogGraphList.Count<2)) then
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


             Show;
               TWinCont(alg).AdjustSize;
               TWinCont(alg).Resize;
          end

      end

end;

constructor TIMMILabelRotate.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
    fBounds := TBoundsString.Create;
    caption := '%8.2f';
    fFPosition:=TFPosition.Create;
    fFPosition.FormTop:=-1;
    fFPosition.FormLeft:=-1;
    fisgraphic:=true;
end;

destructor TIMMILabelRotate.Destroy;
begin
     fFPosition.Free;
     fExprValue.free;
     fExprColor.free;
     fExprVisible.free;
     fBounds.free;
     inherited;
end;

procedure TIMMILabelRotate.ImmiInit (var Msg: TMessage);
begin
   CreateAndInitExpretion(fExprValue, fExprValueString);
  CreateAndInitExpretion(fExprColor, fExprColorString);
  CreateAndInitExpretion(fExprBlink, fExprBlinkString);
  CreateAndInitExpretion(fExprVisible, fExprVisibleString);
  if not notbouds then
  begin
  CreateAndInitExpretion(ibounds.fnagex, ibounds.fnag);
  CreateAndInitExpretion(ibounds.fvagex, ibounds.fvag);
  CreateAndInitExpretion(ibounds.fnpgex, ibounds.fnpg);
  CreateAndInitExpretion(ibounds.fvpgex, ibounds.fvpg);
  end;
  if formatStr = '' then formatStr := Caption;

  if assigned(fExprValue) then
  begin
    if rtItems.isIdent(fExprValueString) then
    begin
      showHint := true;
      if rtItems.GetSimpleID(fExprValueString)>-1
       then
      hint := rtItems.GetComment(rtItems.GetSimpleID(fExprValueString));
      cursor := crHandPoint;
    end;
  end;
end;

procedure TIMMILabelRotate.ImmiUnInit (var Msg: TMessage);
begin
 if assigned(fExprValue) then fExprValue.ImmiUnInit;
  if assigned(fExprColor) then fExprColor.ImmiUnInit;
  if assigned(fExprVisible) then fExprVisible.ImmiUnInit;
  if assigned(fExprBlink) then fExprBlink.ImmiUnInit;
   if not notbouds then
  begin
     if assigned(ibounds.fnagex) then ibounds.fnagex.ImmiUnInit;
     if assigned(ibounds.fvagex) then ibounds.fvagex.ImmiUnInit;
     if assigned(ibounds.fnpgex) then ibounds.fnpgex.ImmiUnInit;
     if assigned(ibounds.fvpgex) then ibounds.fvpgex.ImmiUnInit;
  end;
end;

procedure TIMMILabelRotate.Loaded;
begin
   inherited;
   initcolor:=font.color;
end;

procedure TIMMILabelRotate.ImmiUpdate;
var
   val: real;
   str: string;
   newCap: string;
   newColor: tColor;
begin

  //Update value
  if not notbouds then
  begin
     if assigned(ibounds.fnagex) then ibounds.fnagex.ImmiUpdate;
     if assigned(ibounds.fvagex) then ibounds.fvagex.ImmiUpdate;
     if assigned(ibounds.fnpgex) then ibounds.fnpgex.ImmiUpdate;
     if assigned(ibounds.fvpgex) then ibounds.fvpgex.ImmiUpdate;

  end;

  if assigned(fExprBlink) then fExprBlink.ImmiUpdate;
  if assigned(fExprValue) then
  begin
   try
     fExprValue.ImmiUpdate;
     val := fExprValue.Value;
     str := TrimLeft(format(formatStr, [val]));
     if fExprValue.validLevel > 90 then begin
        newCap := str;
      end else newCap := '?' + str;
   except
     raise;
     newCap := '???';
   end;
   if newCap <> Caption then
   begin
     caption := newCap;
     if not transparent then paint
     else invalidate;
   end;
  end;

  //update color
  if assigned(fExprColor) then
  begin
    fExprColor.ImmiUpdate;
    if fExprColor.IsTrue then newColor := fColorOn
    else newColor := fColorOff;
    if font.color <> newColor then font.color := newColor;
  end;

  //Check Visible
  if assigned(fExprVisible) then
  begin
    fExprVisible.ImmiUpdate;
    if fExprVisible.IsTrue <> Visible then
      visible := fExprVisible.IsTrue;
  end;
end;

procedure TIMMILabelRotate.ImmiBlinkOn (var Msg: TMessage);
begin
      if assigned(fExprColor) then exit;
     if assigned(fExprBlink) then
       if assigned(fExprBlink) then
       begin
          if fExprBlink.isTrue then font.Color:=self.iColorOn
           else  font.Color:=self.initcolor;
       end;
end;

procedure TIMMILabelRotate.ImmiBlinkOff (var Msg: TMessage);
begin
   if assigned(fExprColor) then exit;
     if assigned(fExprBlink) then
       begin
          if fExprBlink.isTrue then font.Color:=self.iColorOff
           else  font.Color:=self.initcolor;
       end;
end;


 end.
