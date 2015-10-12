unit MetaWraperU;

interface

uses
  Classes, ItemAdapterU, XMLIntf, XMLDoc,ValEdit,SysUtils, ConstDef, StrUtils;

type
  TMetaWraper = class(TItemWraper)
  private
    xmlnode: IXMLNode;
    itType: TNSNodeType;
    listitem: TList;
    fdoc: TXMLDocument;
    { Private declarations }
  protected
     function  GetName(Index: Integer): String;
     procedure SetName(Index: Integer; value: String);
     function  GetName_(): String;
     procedure SetName_(value: String);

     function  GetFooter(Index: Integer): String;
     procedure SetFooter(Index: Integer; value: String);
     function  GetFooter_(): String;
     procedure SetFooter_(value: String);

     function  GetAP(Index: Integer): boolean;
     procedure SetAP(Index: Integer; value: boolean);
     function  GetAP_(): String;
     procedure SetAP_(value: String);

     function  GetAC(Index: Integer): boolean;
     procedure SetAC(Index: Integer; value: boolean);
     function  GetAC_(): String;
     procedure SetAC_(value: String);


     function  GetTg(Index: Integer): String;
     procedure SetTg(Index: Integer; value: String);
     function  GetTg_(): String;
     procedure SetTg_(value: String);

     function  GetColorRow(Index: Integer): String;
     procedure SetColorRow(Index: Integer; value: String);
     function  GetColorRow_(): String;
     procedure SetColorRow_(value: String);


     function  GetDelt(Index: Integer): integer;
     procedure SetDelt(Index: Integer; value: integer);
     function  GetDelt_(): String;
     procedure SetDelt_(value: String);
     function  GetGroup(Index: Integer): integer;
     procedure SetGroup(Index: Integer; value: integer);
     function  GetGroup_(): String;
     procedure SetGroup_(value: String);
     function  GetHeight(Index: Integer): integer;
     procedure SetHeight(Index: Integer; value: integer);
     function  GetHeight_(): String;
     procedure SetHeight_(value: String);
     function  GetWidth(Index: Integer): integer;
     procedure SetWidth(Index: Integer; value: integer);
     function  GetWidth_(): String;
     procedure SetWidth_(value: String);
     function  GetSum(Index: Integer): boolean;
     procedure SetSum(Index: Integer; value: boolean);
     function  GetSum_(): String;
     procedure SetSum_(value: String);
     function  GetType(Index: Integer): integer;
     procedure SetType(Index: Integer; value: integer);
     function  GetType_(): String;
     procedure SetType_(value: String);
     function  GetRound(Index: Integer): integer;
     procedure SetRound(Index: Integer; value: integer);
     function  GetRound_(): String;
     procedure SetRound_(value: String);
     function  GetSumType(Index: Integer): integer;
     procedure SetSumType(Index: Integer; value: integer);
     function  GetSumType_(): String;
     procedure SetSumType_(value: String);
     function  GetFontSize(Index: Integer): integer;
     procedure SetFontSize(Index: Integer; value: integer);
     function  GetFontSize_(): String;
     procedure SetFontSize_(value: String);
     function  GetFill(Index: Integer): boolean;
     procedure SetFill(Index: Integer; value: boolean);
     function  GetFill_(): String;
     procedure SetFill_(value: String);
     function  GetInitPeriod_(): String;
     procedure SetInitPeriod_(value: String);
     function  GetInitPeriod(Index: Integer): boolean;
     procedure SetInitPeriod(Index: Integer; value: boolean);
     function  GetSubPeriod_(): String;
     procedure SetSubPeriod_(value: String);
     function  GetSubPeriod(Index: Integer): boolean;
     procedure SetSubPeriod(Index: Integer; value: boolean);
     function  GetColor(Index: Integer): String;
     procedure SetColor(Index: Integer; value: String);
     function  GetColor_(): String;
     procedure SetColor_(value: String);
     function  GetTextColor(Index: Integer): String;
     procedure SetTextColor(Index: Integer; value: String);
     function  GetTextColor_(): String;
     procedure SetTextColor_(value: String);
     function  GetFillColor(Index: Integer): String;
     procedure SetFillColor(Index: Integer; value: String);
     function  GetFillColor_(): String;
     procedure SetFillColor_(value: String);
     function  GetPenColor(Index: Integer): String;
     procedure SetPenColor(Index: Integer; value: String);
     function  GetPenColor_(): String;
     procedure SetPenColor_(value: String);
  public
   procedure setList(value: TList); override;
   constructor create(fdoc: TXMLDocument; le: TValueListEditor);
   destructor destroy;

   procedure setMap(); override;
   function setchange(key: integer; val: string): string; override;

   property Name[Index: Integer]: String read GetName write SetName;
   property Name_: String read GetName_ write SetName_;
   property Footer[Index: Integer]: String read GetFooter write SetFooter;
   property Footer_: String read GetFooter_ write SetFooter_;
   property Tg[Index: Integer]: String read GetTg write SetTg;
   property Tg_: String read GetTg_ write SetTg_;
   property ColorRow[Index: Integer]: String read GetColorRow write SetColorRow;
   property ColorRow_: String read GetColorRow_ write SetColorRow_;
   property Delt[Index: Integer]: integer read GetDelt write SetDelt;
   property Delt_: String read GetDelt_ write SetDelt_;
   property Group[Index: Integer]: integer read GetGroup write SetGroup;
   property Group_: String read GetGroup_ write SetGroup_;
   property Height[Index: Integer]: integer read GetHeight write SetHeight;
   property Height_: String read GetHeight_ write SetHeight_;
   property Width[Index: Integer]: integer read GetWidth write SetWidth;
   property Width_: String read GetWidth_ write SetWidth_;
   property Sum[Index: Integer]: boolean read GetSum write SetSum;
   property Sum_: String read GetSum_ write SetSum_;
   property AP[Index: Integer]: boolean read GetAP write SetAP;
   property AP_: String read GetAP_ write SetAP_;
   property AC[Index: Integer]: boolean read GetAC write SetAC;
   property AC_: String read GetAC_ write SetAC_;
   property _Type[Index: Integer]: integer read GetType write SetType;
   property _Type_: String read GetType_ write SetType_;
   property Round[Index: Integer]: integer read GetRound write SetRound;
   property Round_: String read GetRound_ write SetRound_;
   property SumType[Index: Integer]: integer read GetSumType write SetSumType;
   property SumType_: String read GetSumType_ write SetSumType_;
   property InitPeriod[Index: Integer]: boolean read GetInitPeriod write SetInitPeriod;
   property InitPeriod_: String read GetInitPeriod_ write SetInitPeriod_;
   property SubPeriod[Index: Integer]: boolean read GetSubPeriod write SetSubPeriod;
   property SubPeriod_: String read GetSubPeriod_ write SetSubPeriod_;
   property FontSize[Index: Integer]: integer read GetFontSize write SetFontSize;
   property FontSize_: String read GetFontSize_ write SetFontSize_;
   property Fill[Index: Integer]: boolean read GetFill write SetFill;
   property Fill_: String read GetFill_ write SetFill_;
   property Color[Index: Integer]: String read GetColor write SetColor;
   property Color_: String read GetColor_ write SetColor_;
   property TextColor[Index: Integer]: String read GetTextColor write SetTextColor;
   property TextColor_: String read GetTextColor_ write SetTextColor_;
   property FillColor[Index: Integer]: String read GetFillColor write SetFillColor;
   property FillColor_: String read GetFillColor_ write SetFillColor_;
   property PenColor[Index: Integer]: String read GetPenColor write SetPenColor;
   property PenColor_: String read GetPenColor_ write SetPenColor_;
  end;


  function HextoStr_(val: string): string;
  function StrtoHex_(val: string): string;


implementation

function getInitPeriodList(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('предпоследний');
 result.Add('текущий');
end;

function getInitPeriodstr(val: boolean): String;
begin
  result:='предпоследний';
  if (not val) then result:='текущий';
end;

function getstrInitPeriod(val: string): boolean;
begin
  if (trim(AnsiUpperCase(val))='ПРЕДПОСЛЕДНИЙ') then result:=true
  else
    begin
    if (trim(AnsiUpperCase(val))='ТЕКУЩИЙ') then result:=false
    else result:=false;
    end;
end;





function HextoBin_(val: string): integer;
var i: integer;
begin
   result:=0;
   val:=AnsiUppercase(val);
   for i:=1 to length(val) do
    begin
      result:=result*16;
      case val[i] of
       '1': result:=result+1;
       '2': result:=result+2;
       '3': result:=result+3;
       '4': result:=result+4;
       '5': result:=result+5;
       '6': result:=result+6;
       '7': result:=result+7;
       '8': result:=result+8;
       '9': result:=result+9;
       'A': result:=result+10;
       'B': result:=result+11;
       'C': result:=result+12;
       'D': result:=result+13;
       'E': result:=result+14;
       'F': result:=result+15;
       end;
     end;
    result:=result;
end;

function BintoHex_(val: integer): string;
var i: integer;
    tmpvl: integer;
begin
   result:='';

   for i:=0 to 7 do
    begin
      tmpvl:=(val shr (4*i)) and $F;
      case tmpvl of
       0: result:='0'+result;
       1: result:='1'+result;
       2: result:='2'+result;
       3: result:='3'+result;
       4: result:='4'+result;
       5: result:='5'+result;
       6: result:='6'+result;
       7: result:='7'+result;
       8: result:='8'+result;
       9: result:='9'+result;
       10: result:='A'+result;
       11: result:='B'+result;
       12: result:='C'+result;
       13: result:='D'+result;
       14: result:='E'+result;
       15: result:='F'+result;
       end;
     end;

end;

function HextoStr_(val: string): string;
var temp: integer;

begin
 result:='$00000000';
 if pos('$',val)>0 then
 if pos('$',val)=1 then val:=rightstr(val,length(val)-1);
   temp:=HexToBin_(val);
   result:='$'+BintoHex_(temp);
end;

function StrtoHex_(val: string): string;
var temp: integer;
begin
 result:='00000000';
 if pos('$',val)>0 then
 if pos('$',val)=1 then val:=rightstr(val,length(val)-1);

   temp:=HexToBin_(val);
   result:=BintoHex_(temp);

end;

constructor TMetaWraper.create(fdoc: TXMLDocument; le: TValueListEditor);
begin
  inherited create(le);
  listitem:=TList.Create;

end;

destructor TMetaWraper.destroy;
begin
  listitem.Free;
  inherited destroy;

end;


procedure TMetaWraper.setMap();
begin
         editor.Strings.Clear;

         case itType of




         cdtGroup:
            begin
               setPropertys('Имя',GetName_);
            end;


         cdtTrendArr:
            begin

             setPropertys('Имя',GetName_);

            end;

         cdtTrendHeader:
            begin

             setPropertys('Имя',GetName_);

            end;

         cdtReportHeader:
            begin

             setPropertys('Имя',GetName_);
             setPropertys('Размер шрифта',GetFontSize_);
             setPropertys('Цвет',GetColor_);
             setPropertys('Цвет текста',GetTextColor_);
            end;

         cdtReportArr:
            begin

             setPropertys('Имя',GetName_);
             setPropertys('Смещение',GetDelt_);
             setPropertys('Группировать',GetGroup_);
             setPropertys('Ширина колонки',GetWidth_);
             setPropertys('Высота колонки',GetHeight_);
             setPropertys('Итог',GetSum_,getBooleanList);
             setPropertys('Тип данных',GetType_,getTypRSL);
             setPropertys('Стартовый отчет',GetInitPeriod_,getInitPeriodList);
             setPropertys('Итог по группировке',GetSubPeriod_,getBooleanList);
             setPropertys('Автопечать',GetAP_,getBooleanList);
             setPropertys('Автовыход',GetAC_,getBooleanList);
             setPropertys('Резолюция',GetFooter_);
            end;

         cdtunit:
            begin
             setPropertys('Тег',GetTg_);
             setPropertys('Тип итога',GetSumType_,getTypAGRSL);
             setPropertys('Округление',GetRound_);
             setPropertys('Цвет',GetColorRow_);
            // setPropertys('Цвет текста',GetRound_);
            // setPropertys('Цвет текста2',GetRound_);

            end;

         cdttrend:
            begin
             setPropertys('Тег',GetTg_);
             setPropertys('Ширина поля',GetWidth_);
             setPropertys('Высота поля',GetHeight_);
             setPropertys('Цвет пера',GetPenColor_);
             setPropertys('Цвет заполнения',GetFillColor_);
             setPropertys('Заполнять',GetFill_,getBooleanList);

            end;

         cdtmsgtag:
            begin
               setPropertys('Имя',GetTg_);
            end;

         end;






      //   setPropertys('Имя',GetName_);

         setNew();
end;


function TMetaWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   case itType of

       cdtGroup:
         begin
         case key of
           0: begin Name_:=val;  result:=val; end;
           end;
         end;


       cdtTrendArr:
         begin
         case key of
           0: begin Name_:=val;  result:=val; end;
           end;
         end;

       cdtTrendHeader:
         begin
         case key of
           0: begin Name_:=val;  result:=val; end;
           end;
         end;

       cdtReportArr:
         begin
         case key of
           0: begin Name_:=val;  result:=val; end;
           1: Delt_:=val;
           2: Group_:=val;
           3: Width_:=val;
           4: Height_:=val;
           5: Sum_:=val;
           6: _Type_:=val;
           7: InitPeriod_:=val;
           8: SubPeriod_:=val;
           9: AP_:=val;
           10: AC_:=val;
           11: begin Footer_:=val;  result:=val; end;
         end;
         end;

       cdtReportHeader:
         begin
         case key of
           0: begin Name_:=val;  result:=val; end;
           1: Fontsize_:=val;
           2: Color_:=val;
           3: TextColor_:=val;
           end;
         end;

        cdtunit:
         begin
          case key of
           0: begin Tg_:=val;  result:=val; end;
           1: SumType_:=val;
           2: Round_:=val;
           3: ColorRow_:=val;

         end;
         end;

        cdttrend:
          begin
          case key of
           0: begin Tg_:=val;  result:=val; end;
           1: Width_:=val;
           2: Height_:=val;
           3: PenColor_:=val;
           4: FillColor_:=val;
           5: Fill_:=val;
         end;
         end;

         cdtmsgtag:
         begin
          case key of
           0: begin Tg_:=val;  result:=val; end;


         end;
         end;

  end;



end;

procedure TMetaWraper.setList(value: TList);
var i: integer;

begin
   listitem.Clear;
   SetLength(ids,value.Count);
   for i:=0 to value.Count-1 do
     begin
        ids[i]:=i;
        listitem.Add(value.Items[i]);
     end;
   idscount:=value.Count;
   if idscount>0 then
     itType:=gettypeMetaByname(IXMLNode(value.Items[0]).LocalName)
   else itType:=cdtErr;
end;

function TMetaWraper.GetName(Index: Integer): String;
begin
    result:='null';
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['name']) then
    result:=IXMLNode(listitem.Items[Index]).Attributes['name'];
end;

procedure TMetaWraper.SetName(Index: Integer; value: String);
begin
   IXMLNode(listitem.Items[Index]).Attributes['name']:=value;
end;

function TMetaWraper.GetFooter(Index: Integer): String;
begin
    result:='';
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['footer']) then
    result:=IXMLNode(listitem.Items[Index]).Attributes['footer'];
end;

procedure TMetaWraper.SetFooter(Index: Integer; value: String);
begin
   IXMLNode(listitem.Items[Index]).Attributes['footer']:=value;
end;


function TMetaWraper.GetName_(): String;
var i: integer;
begin
     result:=Name[0];
        for i:=1 to idscount-1 do
         if (Name[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetName_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Name[i]:=value;
end;

function TMetaWraper.GetFooter_(): String;
var i: integer;
begin
     result:=Footer[0];
        for i:=1 to idscount-1 do
         if (Footer[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetFooter_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Footer[i]:=value;
end;

function TMetaWraper.GetTg(Index: Integer): String;
begin
    result:='null';
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['tg']) then
    result:=IXMLNode(listitem.Items[Index]).Attributes['tg'];
end;

procedure TMetaWraper.SetTg(Index: Integer; value: String);
begin
   IXMLNode(listitem.Items[Index]).Attributes['tg']:=value;
end;


function TMetaWraper.GetTg_(): String;
var i: integer;
begin
     result:=Tg[0];
        for i:=1 to idscount-1 do
         if (Tg[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetTg_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Tg[i]:=value;
end;

function TMetaWraper.GetColorRow(Index: Integer): String;
begin
    result:='null';
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['colorrow']) then
    result:=IXMLNode(listitem.Items[Index]).Attributes['colorrow'];
end;

procedure TMetaWraper.SetColorRow(Index: Integer; value: String);
begin
   IXMLNode(listitem.Items[Index]).Attributes['colorrow']:=value;
end;


function TMetaWraper.GetColorRow_(): String;
var i: integer;
begin
     result:=ColorRow[0];
        for i:=1 to idscount-1 do
         if (ColorRow[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetColorRow_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ColorRow[i]:=value;
end;

function TMetaWraper.GetDelt(Index: Integer): integer;
begin
    result:=0;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['delt']) then
    result:=strtointdef(IXMLNode(listitem.Items[Index]).Attributes['delt'],0);
end;

procedure TMetaWraper.SetDelt(Index: Integer; value: integer);
begin
   IXMLNode(listitem.Items[Index]).Attributes['delt']:=inttostr(value);
end;


function TMetaWraper.GetDelt_(): String;
var i: integer;
begin
     result:=inttostr(Delt[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Delt[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetDelt_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Delt[i]:=strtointdef(value,0);
end;

function TMetaWraper.GetGroup(Index: Integer): integer;
begin
    result:=0;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['group']) then
    result:=strtointdef(IXMLNode(listitem.Items[Index]).Attributes['group'],0);
end;

procedure TMetaWraper.SetGroup(Index: Integer; value: integer);
begin
   IXMLNode(listitem.Items[Index]).Attributes['group']:=inttostr(value);
end;


function TMetaWraper.GetGroup_(): String;
var i: integer;
begin
     result:=inttostr(Group[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Group[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetGroup_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Group[i]:=strtointdef(value,0);
end;


function TMetaWraper.GetHeight(Index: Integer): integer;
begin
    result:=300;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['height']) then
    result:=strtointdef(IXMLNode(listitem.Items[Index]).Attributes['height'],300);
end;

procedure TMetaWraper.SetHeight(Index: Integer; value: integer);
begin
   IXMLNode(listitem.Items[Index]).Attributes['height']:=inttostr(value);
end;


function TMetaWraper.GetHeight_(): String;
var i: integer;
begin
     result:=inttostr(Height[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Height[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetHeight_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Height[i]:=strtointdef(value,0);
end;

function TMetaWraper.GetWidth(Index: Integer): integer;
begin
    result:=400;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['width']) then
    result:=strtointdef(IXMLNode(listitem.Items[Index]).Attributes['width'],400);
end;

procedure TMetaWraper.SetWidth(Index: Integer; value: integer);
begin
   IXMLNode(listitem.Items[Index]).Attributes['width']:=inttostr(value);
end;


function TMetaWraper.GetWidth_(): String;
var i: integer;
begin
     result:=inttostr(Width[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Width[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetWidth_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Width[i]:=strtointdef(value,0);
end;

function TMetaWraper.GetSum(Index: Integer): boolean;
begin
    result:=true;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['sum']) then
    result:=(strtointdef(IXMLNode(listitem.Items[Index]).Attributes['sum'],0)=1);
end;

procedure TMetaWraper.SetSum(Index: Integer; value: boolean);
begin
   if value then
   IXMLNode(listitem.Items[Index]).Attributes['sum']:='1' else
   IXMLNode(listitem.Items[Index]).Attributes['sum']:='0';
end;


function TMetaWraper.GetSum_(): String;
var i: integer;
begin
     result:=getbooleanstr(Sum[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(Sum[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetSum_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Sum[i]:=getstrboolean(value);
end;

function TMetaWraper.GetAP(Index: Integer): boolean;
begin
    result:=true;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['autoprint']) then
    result:=(strtointdef(IXMLNode(listitem.Items[Index]).Attributes['autoprint'],0)=1);
end;

procedure TMetaWraper.SetAP(Index: Integer; value: boolean);
begin
   if value then
   IXMLNode(listitem.Items[Index]).Attributes['autoprint']:='1' else
   IXMLNode(listitem.Items[Index]).Attributes['autoprint']:='0';
end;


function TMetaWraper.GetAP_(): String;
var i: integer;
begin
     result:=getbooleanstr(AP[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(AP[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetAP_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     AP[i]:=getstrboolean(value);
end;

function TMetaWraper.GetAC(Index: Integer): boolean;
begin
    result:=true;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['autoclose']) then
    result:=(strtointdef(IXMLNode(listitem.Items[Index]).Attributes['autoclose'],0)=1);
end;

procedure TMetaWraper.SetAC(Index: Integer; value: boolean);
begin
   if value then
   IXMLNode(listitem.Items[Index]).Attributes['autoclose']:='1' else
   IXMLNode(listitem.Items[Index]).Attributes['autoclose']:='0';
end;


function TMetaWraper.GetAC_(): String;
var i: integer;
begin
     result:=getbooleanstr(AC[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(AC[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetAC_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     AC[i]:=getstrboolean(value);
end;

function TMetaWraper.GetType(Index: Integer): integer;
begin
    result:=4;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['type']) then
    result:=strtointdef(IXMLNode(listitem.Items[Index]).Attributes['type'],4);
end;

procedure TMetaWraper.SetType(Index: Integer; value: integer);
begin
   IXMLNode(listitem.Items[Index]).Attributes['type']:=inttostr(value);
end;


function TMetaWraper.GetType_(): String;
var i: integer;
begin
     result:=InttoTypR(_Type[0]);
        for i:=1 to idscount-1 do
         if (InttoTypR(_Type[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetType_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     _Type[i]:=TypRtoInt(value);
end;

function TMetaWraper.GetRound(Index: Integer): integer;
begin
   result:=0;
   if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['round']) then
    result:=strtointdef(IXMLNode(listitem.Items[Index]).Attributes['round'],0);
end;

procedure TMetaWraper.SetRound(Index: Integer; value: integer);
begin

   IXMLNode(listitem.Items[Index]).Attributes['round']:=inttostr(value);
end;


function TMetaWraper.GetRound_(): String;
var i: integer;
begin
     result:=inttostr(Round[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Round[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetRound_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Round[i]:=strtointdef(value,0);
end;

function TMetaWraper.GetSumType(Index: Integer): integer;
begin
    result:=1;
   if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['sumtype']) then
    result:=strtointdef(IXMLNode(listitem.Items[Index]).Attributes['sumtype'],0);
end;

procedure TMetaWraper.SetSumType(Index: Integer; value: integer);
begin

   IXMLNode(listitem.Items[Index]).Attributes['sumtype']:=inttostr(value);
end;


function TMetaWraper.GetSumType_(): String;
var i: integer;
begin
     result:=InttoTypAGR(SumType[0]);
        for i:=1 to idscount-1 do
         if (InttoTypAGR(SumType[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetSumType_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     SumType[i]:=TypAGRtoInt(value);
end;

function TMetaWraper.GetFontSize(Index: Integer): integer;
begin
    result:=8;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['fontsize']) then
    result:=strtointdef(IXMLNode(listitem.Items[Index]).Attributes['fontsize'],0);
end;

procedure TMetaWraper.SetFontSize(Index: Integer; value: integer);
begin

   IXMLNode(listitem.Items[Index]).Attributes['fontsize']:=inttostr(value);
end;


function TMetaWraper.GetFontSize_(): String;
var i: integer;
begin
     result:=inttostr(FontSize[0]);
        for i:=1 to idscount-1 do
         if (inttostr(FontSize[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetFontSize_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FontSize[i]:=strtointdef(value,0);
end;

function TMetaWraper.GetFill(Index: Integer): boolean;
begin
    result:=false;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['fill']) then
    result:=(strtointdef(IXMLNode(listitem.Items[Index]).Attributes['fill'],0)=1);
end;

procedure TMetaWraper.SetFill(Index: Integer; value: boolean);
begin
   if value then
   IXMLNode(listitem.Items[Index]).Attributes['fill']:='1' else
   IXMLNode(listitem.Items[Index]).Attributes['fill']:='0';
end;


function TMetaWraper.GetFill_(): String;
var i: integer;
begin
     result:=getbooleanstr(Fill[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(Fill[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetFill_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Fill[i]:=getstrboolean(value);
end;

function TMetaWraper.GetInitPeriod(Index: Integer): boolean;
begin
    result:=false;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['initperiod']) then
    result:=(strtointdef(IXMLNode(listitem.Items[Index]).Attributes['initperiod'],0)=1);
end;

procedure TMetaWraper.SetInitPeriod(Index: Integer; value: boolean);
begin
   if value then
   IXMLNode(listitem.Items[Index]).Attributes['initperiod']:='1' else
   IXMLNode(listitem.Items[Index]).Attributes['initperiod']:='0';
end;


function TMetaWraper.GetInitPeriod_(): String;
var i: integer;
begin
     result:=getInitPeriodstr(InitPeriod[0]);
        for i:=1 to idscount-1 do
         if (getInitPeriodstr(InitPeriod[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetInitPeriod_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     InitPeriod[i]:=getstrInitPeriod(value);
end;

function TMetaWraper.GetSubPeriod(Index: Integer): boolean;
begin
    result:=false;
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['subperiod']) then
    result:=(strtointdef(IXMLNode(listitem.Items[Index]).Attributes['subperiod'],0)=1);
end;

procedure TMetaWraper.SetSubPeriod(Index: Integer; value: boolean);
begin
   if value then
   IXMLNode(listitem.Items[Index]).Attributes['subperiod']:='1' else
   IXMLNode(listitem.Items[Index]).Attributes['subperiod']:='0';
end;


function TMetaWraper.GetSubPeriod_(): String;
var i: integer;
begin
     result:=getbooleanstr(SubPeriod[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(SubPeriod[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetSubPeriod_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     SubPeriod[i]:=getstrboolean(value);
end;

function TMetaWraper.GetColor(Index: Integer): String;
begin
    result:='$00FFFFFF';
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['color']) then 
    result:=HextoStr_(IXMLNode(listitem.Items[Index]).Attributes['color']);
end;

procedure TMetaWraper.SetColor(Index: Integer; value: String);
var tmp: string;
begin
  tmp:=StrtoHex_(value);
   IXMLNode(listitem.Items[Index]).Attributes['color']:=StrtoHex_(value);
end;


function TMetaWraper.GetColor_(): String;
var i: integer;
begin
     result:=Color[0];
        for i:=1 to idscount-1 do
         if (Color[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetColor_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Color[i]:=value;
end;

function TMetaWraper.GetTextColor(Index: Integer): String;
begin
    result:='00000000';
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['textcolor']) then
    result:=HextoStr_(IXMLNode(listitem.Items[Index]).Attributes['textcolor']);
end;

procedure TMetaWraper.SetTextColor(Index: Integer; value: String);
begin
   IXMLNode(listitem.Items[Index]).Attributes['textcolor']:=StrtoHex_(value);
end;


function TMetaWraper.GetTextColor_(): String;
var i: integer;
begin
     result:=TextColor[0];
        for i:=1 to idscount-1 do
         if (TextColor[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetTextColor_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     TextColor[i]:=value;
end;

function TMetaWraper.GetPenColor(Index: Integer): String;
begin
    result:='00000000';
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['pencolor']) then
    result:=HextoStr_(IXMLNode(listitem.Items[Index]).Attributes['pencolor']);
end;

procedure TMetaWraper.SetPenColor(Index: Integer; value: String);
begin
   IXMLNode(listitem.Items[Index]).Attributes['pencolor']:=StrtoHex_(value);
end;


function TMetaWraper.GetPenColor_(): String;
var i: integer;
begin
     result:=PenColor[0];
        for i:=1 to idscount-1 do
         if (PenColor[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetPenColor_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     PenColor[i]:=value;
end;

function TMetaWraper.GetFillColor(Index: Integer): String;
begin
    result:='00000000';
    if assigned(IXMLNode(listitem.Items[Index]).AttributeNodes.Nodes['fillcolor']) then
    result:=HextoStr_(IXMLNode(listitem.Items[Index]).Attributes['fillcolor']);
end;

procedure TMetaWraper.SetFillColor(Index: Integer; value: String);
begin
   IXMLNode(listitem.Items[Index]).Attributes['fillcolor']:=StrtoHex_(value);
end;


function TMetaWraper.GetFillColor_(): String;
var i: integer;
begin
     result:=FillColor[0];
        for i:=1 to idscount-1 do
         if (FillColor[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TMetaWraper.SetFillColor_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FillColor[i]:=value;
end;


end.
