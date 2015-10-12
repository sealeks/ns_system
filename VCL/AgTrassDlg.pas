unit AgTrassDlg;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Agtrassing, Spin, 
  Agnumber; 
{ последний модуль использует компоненты ввода вещественных(или целых) чисел}

type
  TAgTrassingDlg = class(TForm)
    bOk: TButton;
    bCancel: TButton;
    gbxAxle: TGroupBox;
    nexMin: TAgNumEdit;
    nexMax: TAgNumEdit;
    LxMin: TLabel;
    LxMax: TLabel;
    LxTouch: TLabel;
    LxPrec: TLabel;
    sexTouch: TSpinEdit;
    sexPrec: TSpinEdit;
    cbxGrid: TCheckBox;
    gbyAxle: TGroupBox;
    LyMin: TLabel;
    LyMax: TLabel;
    LyTouch: TLabel;
    LyPrec: TLabel;
    neyMin: TAgNumEdit;
    neyMax: TAgNumEdit;
    seyTouch: TSpinEdit;
    seyPrec: TSpinEdit;
    cbyGrid: TCheckBox;
    procedure sexPrecKeyPress(Sender: TObject; var Key: Char);
    procedure sexPrecExit(Sender: TObject);
  end;

var
  AgTrassingDlg: TAgTrassingDlg;

type

 TAgTrassingDlgData=record
   xMin,yMin,xMax,yMax:extended;
   xPrec,yPrec,xTouch,yTouch:integer;
   xGrid,yGrid:boolean;
 end;
 const AgTrassingDataNumber=10;
  // количество полей - измен€йте при модификации
 const DivChar=#9; // символ разделени€ полей в строковой записи


 function ConvertToAgTrassingDlgData(
           axMin,ayMin,axMax,ayMax:extended;
           axPrec,ayPrec,axTouch,ayTouch:integer;
           axGrid,ayGrid:boolean                ):TAgTrassingDlgData;

   // дл€ сохранени€ в файлах настроек
 function AgTrassingDlgDataToStr(const D:TAgTrassingDlgData):string;
 function StrToAgTrassingDlgData(const s:string; var D:TAgTrassingDlgData):boolean;


 // функции св€зи параметрами с TAgTrassing
 function GetAgTrassingDlgData(const T:TAgTrassing;
                                var Data:TAgTrassingDlgData):boolean;
 function SetAgTrassingDlgData(T:TAgTrassing;const Data:TAgTrassingDlgData):boolean;

 // надстройки дл€ сохранени€ параметров графиков в файлах
 function AgTrassingSettingToStr(const T:TAgTrassing):string;
 function StrToAgTrassingSetting(const S:string; T:TAgTrassing):boolean;


  function ShowModalAgTrassingDlg(var Data:TAgTrassingDlgData):integer;
 function ConnectAgTrassingDlg(T:TAgTrassing):integer;


implementation

{$R *.DFM}

  function BoolToInt(value:boolean):integer;
   begin if value then Result:=1 else Result:=0; end;

  function IntToBool(value:integer):boolean;
   begin if value=0 then Result:=false else Result:=true; end;


 function ConvertToAgTrassingDlgData;
  begin
   with Result do
    begin
     xMin:=axMin; yMin:=ayMin;
     if axMax<>xMin then xMax:=axMax else xMax:=xMin+1;
     if ayMax<>yMin then yMax:=ayMax else ymax:=yMin+1;
     if Abs(axPrec)<2 then xPrec:=2 else if Abs(axPrec)>6 then xPrec:=6
                                         else xPrec:=Abs(axPrec);
     if Abs(ayPrec)<2 then yPrec:=2 else if Abs(ayPrec)>6 then yPrec:=6
                                         else yPrec:=Abs(ayPrec);
     if Abs(axTouch)<2 then xTouch:=2 else if Abs(axTouch)>20 then xTouch:=20
                                         else xTouch:=Abs(axTouch);
     if Abs(ayTouch)<2 then yTouch:=2 else if Abs(ayTouch)>20 then yTouch:=20
                                         else yTouch:=Abs(ayTouch);

     xGrid:=axGrid; yGrid:=ayGrid;
    end;
  end;

 function AgTrassingDlgDataToStr(const D:TAgTrassingDlgData):string;
  begin
   with D do
    Result:=Concat(FloatToStr(xMin),DivChar,FloatToStr(yMin),DivChar,
                   FloatToStr(xMax),DivChar,FloatToStr(yMax),DivChar,
                   IntToStr(xPrec),DivChar,IntToStr(yPrec),DivChar,
                   IntToStr(xTouch),DivChar,IntToStr(xTouch),DivChar,
                   IntToStr(BoolToInt(xGrid)),DivChar,IntToStr(BoolToInt(yGrid)));
  end;

 function StrToAgTrassingDlgData(const s:string; var D:TAgTrassingDlgData):boolean;
 var LocData:TAgTrassingDlgData;
    kl,il:integer;
    arS:array[1..AgTrassingDataNumber] of string;
    inFl:boolean;
 begin
  Result:=false;
  if S='' then exit;
  kL:=0;  inFl:=false;
  il:=1;
  repeat
   if (S[il]<>' ') and (S[il]<>#9) then
    begin
     if Not(inFl) then Inc(kL);
     inFl:=true;
     if kl<=AgTrassingDataNumber then arS[kL]:=Concat(arS[kL],S[il]);
    end
   else inFl:=false;
   Inc(il);
  until (il>Length(S)) or (kL=AgTrassingDataNumber);
  if kl<AgTrassingDataNumber then exit; { ! }
  with LocData do
   try
     xMin:=StrToFloat(arS[1]);
     yMin:=StrToFloat(arS[2]);
     xMax:=StrToFloat(arS[3]);
     yMax:=StrToFloat(arS[4]);
     xPrec:=StrToInt(arS[5]);
     yPrec:=StrToInt(arS[6]);
     xTouch:=StrToInt(arS[7]);
     yTouch:=StrToInt(arS[8]);
     xGrid:=IntToBool(StrToInt(arS[9]));
     yGrid:=IntToBool(StrToInt(arS[10]));
    except
     on {E:} EConvertError do
      begin
       Result:=false;
       exit;
     {
      ShowMessage(E.ClassName + CRLF + E.Message);
     }end
   end;
  Result:=true;
  D:=LocData;
 end;


 function GetAgTrassingDlgData(const T:TAgTrassing;
                                var Data:TAgTrassingDlgData):boolean;
  begin
   Result:=false;
   if T=nil then exit else Result:=true;
   with Data,T do
    begin
        xMin:=X1;
        xMax:=X2;
        yMin:=Y1;
        yMax:=Y2;
        xPrec:=PrecX;
        yPrec:=PrecY;
        xTouch:=TouchX;
        yTouch:=TouchY;
        xGrid:=GridX;
        yGrid:=GridY;
    end;
  end;

 function SetAgTrassingDlgData(T:TAgTrassing;const Data:TAgTrassingDlgData):boolean;
  begin
   Result:=false;
   if T=nil then exit else Result:=true;
    with Data,T do
    begin
      DrawFlag:=false;
        PrecX:=xPrec;
        PrecY:=yPrec;
        TouchX:=xTouch;
        TouchY:=yTouch;
        GridX:=xGrid;
        GridY:=yGrid;
        SetRange(xMin,yMin,xmax,yMax);
       DrawFlag:=true;
    end;
  end;

 function AgTrassingSettingToStr(const T:TAgTrassing):string;
 var LocData:TAgTrassingDlgData;
  begin
   Result:='';
   if T=nil then exit;
   if Not (GetAgTrassingDlgData(T,LocData)) then exit
   else Result:=AgTrassingDlgDataToStr(LocData);
  end;

 function StrToAgTrassingSetting(const S:string; T:TAgTrassing):boolean;
 var LocData:TAgTrassingDlgData;
  begin
   Result:=false;
   if T=nil then exit;
   if Not StrToAgTrassingDlgData(S,LocData) then exit
   else
    begin
     SetAgTrassingDlgData(T,LocData);
     result:=true;
    end;
  end;


// ----------------------- собственно работа с окном

 function ShowModalAgTrassingDlg(var Data:TAgTrassingDlgData):integer;
var TDlg:TAgTrassingDlg;
   function SetIntValue(MRes,OldValue:integer; var NewValue:integer):integer;
     begin
      Result:=mrOk;
      if (NewValue=OldValue) and (MRes=mrNone) then Result:=mrNone
      else  NewValue:=OldValue;
     end;
   function SetExtValue(MRes:integer; OldValue:extended; var NewValue:extended):integer;
     begin
      Result:=mrOk;
      if (NewValue=OldValue) and (MRes=mrNone) then Result:=mrNone
      else  NewValue:=OldValue;
     end;
   function SetBoolValue(MRes:integer;OldValue:boolean; var NewValue:boolean):integer;
     begin
      Result:=mrOk;
      if (NewValue=OldValue) and (MRes=mrNone) then Result:=mrNone
      else  NewValue:=OldValue;
     end;
{ ----------- }
 begin
  Result:=-1;
  TDlg:=TAgTrassingDlg.Create(Application);
  try
   with TDlg do
    begin
     with Data do
       begin
        nexMin.Value:=xMin;
        nexMax.Value:=xMax;
        neyMin.Value:=yMin;
        neyMax.Value:=yMax;
        sexPrec.Value:=xPrec;
        seyPrec.Value:=yPrec;
        sexTouch.Value:=xTouch;
        seyTouch.Value:=yTouch;
        cbxGrid.Checked:=xGrid;
        cbyGrid.Checked:=yGrid;
       end;
     ShowModal;
     Result:=ModalResult;
     if Result=mrOk then
      with Data do
       begin
        Result:=mrNone;
        Result:=SetExtValue(Result,nexMin.value,xMin);
        Result:=SetExtValue(Result,nexMax.value,xMax);
        Result:=SetExtValue(Result,neyMin.value,yMin);
        Result:=SetExtValue(Result,neyMax.value,yMax);
        Result:=SetIntValue(Result,sexPrec.value,xPrec);
        Result:=SetIntValue(Result,seyPrec.value,yPrec);
        Result:=SetIntValue(Result,sexTouch.value,xTouch);
        Result:=SetIntValue(Result,seyTouch.value,yTouch);
        Result:=SetBoolValue(Result,cbxGrid.Checked,xGrid);
        Result:=SetBoolValue(Result,cbyGrid.Checked,yGrid);
       end;
    end;
   finally TDlg.Free;
  end;
 end;



 function ConnectAgTrassingDlg(T:TAgTrassing):integer;
 var Data:TAgTrassingDlgData;
  begin
   Result:=-1;
   if T=Nil then exit;
   if Not(GetAgTrassingDlgData(T,Data)) then exit;
   Result:=ShowModalAgTrassingDlg(Data);
   if Result=mrOk then
     if (SetAgTrassingDlgData(T,Data)) then
      begin
       T.Draw;
     { T.Repaint;
      }
     end;
 end;


{ ------------------- Auto metods ------------------------------------------ }
procedure TAgTrassingDlg.sexPrecKeyPress(Sender: TObject; var Key: Char);
begin
 with Sender as TSpinEdit do
  begin
    if (Key<'0') or (Key>'9') then
     if Not(Key in [#8,#13,#16]) then Key:=#0;
  end;
end;

procedure TAgTrassingDlg.sexPrecExit(Sender: TObject);
begin
 with Sender as TSpinEdit do
  begin
   if Text='' then Value:=MinValue;
   SelStart:=Length(Text);
  end;
end;

end.
