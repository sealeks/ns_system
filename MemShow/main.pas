unit main;

{ Copyright (c) 1996 by Charlie Calvert

  Example of using memory mapped files }

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  Buttons, ExtCtrls, Grids, math,  SetTag,
  MemStructsU, ComCtrls, constDef, strUtils,globalValue, Menus,
  ColorStringGrid;

type
  tbaseType = (btAnalog, btCalc);

  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    PageControl1: TPageControl;
    TabSheetTeg: TTabSheet;
    TabSheetZurnal: TTabSheet;
    sgAlarms: TStringGrid;
    TabSheetEvents: TTabSheet;
    TabSheetRegs: TTabSheet;
    StringGrid3: TStringGrid;
    TabSheetActiveAlarms: TTabSheet;
    sgActiveAlarms: TStringGrid;
    TabSheetCommand: TTabSheet;
    sgCommand: TStringGrid;
    TabLog: TTabSheet;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    AllInvalid1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    FilterTag: TEdit;
    Label1: TLabel;
    N3: TMenuItem;
    N4: TMenuItem;
    Allinc1: TMenuItem;
    Alldec1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    SaveDialog1: TSaveDialog;
    StringGrid1: TColorStringGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    scLog: TColorStringGrid;
    ButtonLog: TButton;
    N7: TMenuItem;
    rKvit1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    function ColbyName (Caption: string): integer;
    procedure ButtonLogClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure sgAlarmsRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure sgAlarmsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgActiveAlarmsSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure Button7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure AllInvalid1Click(Sender: TObject);
    procedure Allinc1Click(Sender: TObject);
    procedure Alldec1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure rKvit1Click(Sender: TObject);

  public
        flogvis: boolean;
        curId: integer;
        changeFo: TFormSetTag;
        whatBase: TBaseType;
        procedure upd;
        procedure UpdateCommand;
        procedure UpdateEvents;
        procedure UpdateRegs;
        procedure UpdateJurnal;
        procedure UpdateAlarms;
        procedure UpdateLog;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

/////////////////////////////////////////////////////////
// Open a map file and prepare to access it
/////////////////////////////////////////////////////////

function getmsgcolor(val: byte): Tcolor;
begin
  if val<3 then result:=clTeal else
      if val<5 then result:=TColor($000080FF) else
         if val<9 then result:=clRed else
           if val<17 then result:=clRed;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  curId:=-1;
  flogvis:=true;
  with sgActiveAlarms do
  begin
     cells[0,0] := '№';
     cells[1,0] := 'Время';
     cells[2,0] := 'Комментарий';
     cells[3,0] := 'Параметр';
     cells[4,0] := 'Квит';
     cells[5,0] := 'Вкл';
  end;


  try
     stringgrid1.cells[0,0] := '№';
     stringgrid1.cells[1,0] := 'Имя';
     stringgrid1.cells[2,0] := 'Тип';
     stringgrid1.cells[3,0] := 'Значение';
     stringgrid1.cells[4,0] := 'Действит.';
     stringgrid1.cells[5,0] := 'Время';
     stringgrid1.cells[6,0] := 'Кол.ссылок';
     stringgrid1.cells[7,0] := 'Коммент.';
     stringgrid1.cells[8,0] := 'Квит.';
     stringgrid1.cells[9,0] := 'Тревога.';


    rtItems := TanalogMems.Create(PathMem);
    changeFo:=TFormSetTag.Create(rtItems);
    upd;
  except
    timer1.Enabled := false;
    showMessage ('Ошибкаинициализации формы');
    application.terminate;
  end;
  with sgAlarms do
  begin
    Cells[1, 0] := 'Время/дата';
    Cells[2, 0] := 'Комментарий';
    Cells[3, 0] := 'Параметр';
  end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     changeFo.Free;
     rtItems.free;
end;

function TForm1.ColbyName (Caption: string): integer;
var
   i: integer;
begin
     result := -1;
     for i := 0 to stringgrid1.ColCount - 1 do
         if stringgrid1.Cells[i, 0] = caption then
            result := i;
end;

procedure TForm1.UpdateLog;

var i,j: integer;
begin
if not flogvis then exit;
 if rtItems.fdebugBase=nil then exit;
 scLog.RowCount := max(2, rtItems.fdebugBase.Count + 1);
  for i := scLog.TopRow - 1 to scLog.TopRow + scLog.VisibleRowCount-1 do
  begin
    j:=i;
    if i >= rtItems.fdebugBase.Count then exit;
    if i > scLog.RowCount + 1 then scLog.RowCount := scLog.RowCount + 1;
    scLog.fRows.Items[i + 1].font.color:=getmsgcolor(rtItems.fdebugBase.items_[j].level);
    scLog.Cells[0, i + 1] := inttostr(rtItems.fdebugBase.items_[j].number);
    scLog.Cells[1, i + 1] := formatdatetime('yy-mm-dd hh:nn:ss.zzz',rtItems.fdebugBase.items_[j].time);
    scLog.Cells[2, i+1] := rtItems.fdebugBase.items_[j].application;
    scLog.Cells[3, i+1] :=rtItems.fdebugBase.items_[j].debugmessage;
    scLog.Cells[4, i+1] := inttostr(rtItems.fdebugBase.items_[j].level);
  end;
end;

procedure TForm1.upd;
function gettipeCol(val: PTAnalogMem): Tcolor;
begin
  if val.ID<0 then result:=clLtGray
    else
     if (val.logTime  in [REPORTTYPE_YEAR, REPORTTYPE_MIN, REPORTTYPE_HOUR,
                                            REPORTTYPE_DEC, REPORTTYPE_DAY, REPORTTYPE_MONTH]) then
       result:=clOlive else
          if val.ValidLevel>=VALID_LEVEL then result:=clGreen else
                            result:=TColor($00595959);



end;
var
   i: integer;
   count : integer;
   shift : integer;
   j,k: integer;
   temp: string;
begin
   shift := 0;
   count := 0;
   case whatBase of
     btAnalog:
     begin
     if (trim(filterTag.Text)='') then
     Count := rtItems.Count
     else
       begin
         Count:=0;
         for i:=0 to rtitems.Count-1 do

            begin
              if POS(uppercase(trim(filterTag.Text)),uppercase(trim(rtitems.GetName(i))))>0 then
                begin
                   Count:=Count+1;
                end;
            end;
       end;
     end;
     btCalc: begin

                  Count := 0;
                  shift := calcShift;
     end;
   end;
   stringgrid1.rowCount := count + 1;
    j:=0;
    k:=min(stringgrid1.TopRow,0)-1;

    if (trim(filterTag.Text)<>'')
    then
    begin
    for i := 0 to rtitems.Count-1 do
    begin

      if i < 0 then continue;
      if i >= rtItems.Count then exit;
        if (((POS(uppercase(trim(filterTag.Text)),uppercase(trim(rtitems.GetName(i+shift))))>0){ and not
        (trim(filterTag.Text)='')) or (trim(filterTag.Text)=''})) then
        begin
        k:=k+1;
        stringgrid1.fRows.Items[k + 1].font.color:=gettipeCol(rtItems.Items[i+shift]);
        temp:=uppercase(trim(rtitems.GetName(i+shift)));
        if stringgrid1.Cells[ColbyName('№'), k + 1] <> inttostr(rtItems.Items[i+shift].ID) then
                stringgrid1.Cells[ColbyName('№'), k + 1] := inttostr(rtItems.Items[i+shift].ID);
        if stringgrid1.Cells[ColbyName('Имя'),k + 1] <> rtItems.GetName(i+shift) then
                stringgrid1.Cells[ColbyName('Имя'),k + 1] := rtItems.GetName(i+shift);
        if stringgrid1.Cells[ColbyName('Тип'),k + 1] <> getTypeDataItem(rtItems[i+shift].logtime) then
                stringgrid1.Cells[ColbyName('Тип'),k + 1] := getTypeDataItem(rtItems[i+shift].logtime);
        if stringgrid1.Cells[ColbyName('Значение'), k + 1] <> floattostr(rtItems.Items[i+shift].Valreal) then
                stringgrid1.Cells[ColbyName('Значение'), k + 1] := floattostr(rtItems.Items[i+shift].Valreal);
        if stringgrid1.Cells[ColbyName('Действит.'), k + 1] <> inttostr(rtItems.Items[i+shift].ValidLevel) then
                stringgrid1.Cells[ColbyName('Действит.'), k + 1] := inttostr(rtItems.Items[i+shift].ValidLevel);
        if stringgrid1.Cells[ColbyName('Кол.ссылок'), k + 1] <> inttostr(rtItems.Items[i+shift].refCount) then
                stringgrid1.Cells[ColbyName('Кол.ссылок'), i + 1] := inttostr(rtItems.Items[i+shift].refCount);
        if stringgrid1.Cells[ColbyName('Коммент.'), k + 1] <> rtItems.GetComment(i+shift) then
                stringgrid1.Cells[ColbyName('Коммент.'), k + 1] := rtItems.GetComment(i+shift);

        if stringgrid1.Cells[ColbyName('Квит.'), k + 1] <> ifthen(rtItems.Items[i+shift].isAlarmKvit, 'Истина', 'Ложь') then
                stringgrid1.Cells[ColbyName('Квит.'), k + 1] := ifthen(rtItems.Items[i+shift].isAlarmKvit, 'Истина', 'Ложь');
        if stringgrid1.Cells[ColbyName('Тревога.'), k + 1] <> ifthen(rtItems.Items[i+shift].isAlarmOn, 'Истина', 'Ложь') then
                stringgrid1.Cells[ColbyName('Тревога.'), k + 1] := ifthen(rtItems.Items[i+shift].isAlarmOn, 'Истина', 'Ложь');
        if (rtItems.Items[i+shift].logTime in REPORT_SET) or (rtItems.Items[i+shift].Logged) then
           begin
           if stringgrid1.Cells[ColbyName('Время'), k + 1] <> formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',rtItems.Items[i+shift].TimeStamp) then
                stringgrid1.Cells[ColbyName('Время'), k + 1] := formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',rtItems.Items[i+shift].TimeStamp);

           end
                else  stringgrid1.Cells[ColbyName('Время'), k + 1] :='';
        end else
         temp:=uppercase(trim(rtitems.GetName(i+shift)));

    end;
    end else



    begin
    for i := stringgrid1.TopRow-5 to stringgrid1.TopRow+stringgrid1.VisibleRowCount+5 do
    begin

      if i < 0 then continue;
      if i >= rtItems.Count then exit;

        begin

        temp:=uppercase(trim(rtitems.GetName(i+shift)));
        if stringgrid1.Cells[ColbyName('№'), i + 1] <> inttostr(rtItems.Items[i+shift].ID) then
                stringgrid1.Cells[ColbyName('№'), i + 1] := inttostr(rtItems.Items[i+shift].ID);
        if stringgrid1.Cells[ColbyName('Имя'),i + 1] <> rtItems.GetName(i+shift) then
                stringgrid1.Cells[ColbyName('Имя'),i + 1] := rtItems.GetName(i+shift);
        if stringgrid1.Cells[ColbyName('Тип'),i + 1] <> getTypeDataItem(rtItems[i+shift].logtime) then
                stringgrid1.Cells[ColbyName('Тип'),i + 1] := getTypeDataItem(rtItems[i+shift].logtime);
        if stringgrid1.Cells[ColbyName('Значение'), i + 1] <> floattostr(rtItems.Items[i+shift].Valreal) then
                stringgrid1.Cells[ColbyName('Значение'), i + 1] := floattostr(rtItems.Items[i+shift].Valreal);
        if stringgrid1.Cells[ColbyName('Действит.'), i + 1] <> inttostr(rtItems.Items[i+shift].ValidLevel) then
                stringgrid1.Cells[ColbyName('Действит.'), i + 1] := inttostr(rtItems.Items[i+shift].ValidLevel);
        if stringgrid1.Cells[ColbyName('Кол.ссылок'), i + 1] <> inttostr(rtItems.Items[i+shift].refCount) then
                stringgrid1.Cells[ColbyName('Кол.ссылок'), i + 1] := inttostr(rtItems.Items[i+shift].refCount);
        if stringgrid1.Cells[ColbyName('Коммент.'), i + 1] <> rtItems.GetComment(i+shift) then
                stringgrid1.Cells[ColbyName('Коммент.'), i + 1] := rtItems.GetComment(i+shift);
       if stringgrid1.Cells[ColbyName('Тревога.'), i + 1] <> ifthen(rtItems.Items[i+shift].isAlarmOn, 'Истина', 'Ложь') then
              stringgrid1.Cells[ColbyName('Тревога.'), i + 1] := ifthen(rtItems.Items[i+shift].isAlarmOn, 'Истина', 'Ложь');
        if stringgrid1.Cells[ColbyName('Квит.'), i + 1] <> ifthen(rtItems.Items[i+shift].isAlarmKvit, 'Истина', 'Ложь') then
                stringgrid1.Cells[ColbyName('Квит.'), i + 1] := ifthen(rtItems.Items[i+shift].isAlarmKvit, 'Истина', 'Ложь');
        if (rtItems.Items[i+shift].logTime in REPORT_SET) or (rtItems.Items[i+shift].Logged) then
           begin
           if stringgrid1.Cells[ColbyName('Время'), i + 1] <> formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',rtItems.Items[i+shift].TimeStamp) then
                stringgrid1.Cells[ColbyName('Время'), i + 1] := formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',rtItems.Items[i+shift].TimeStamp);

           end
                else  stringgrid1.Cells[ColbyName('Время'), i + 1] :='';
        stringgrid1.fRows.Items[i + 1].font.color:=gettipeCol(rtItems.Items[i+shift]);
        end

    end;
    stringgrid1.Repaint;
   end;



    if (stringgrid1.RowCount > 1) and (stringgrid1.fixedRows = 0) then
       stringgrid1.fixedRows := 1;
end;

procedure TForm1.UpdateCommand;
var
   i: integer;
   Base: TCommandMems;
begin
  Base := rtItems.command;
  with sgCommand do
  begin

    if rowCount <= base.Count then
       rowCount := base.Count + 1;
    for i := 0 to base.Count - 1 do
    begin
        Cells[0, i + 1] := inttostr(base.Items[i].Number);
        Cells[1, i + 1] := inttostr(base.Items[i].ID);
        Cells[2, i + 1] := floattostr(base.Items[i].PrevVal);
        Cells[3, i + 1] := floattostr(base.Items[i].ValReal);
        Cells[4, i + 1] := ifthen(rtItems.command.Items[i].executed, 'T', 'F');
        Cells[5, i + 1] := rtItems.command.Items[i].CompName;
        Cells[6, i + 1] := rtItems.command.Items[i].UserName;
    end;
    for i := base.Count + 1 to RowCount - 1 do
    begin
      Cells[0, i] := '';
      Cells[1, i] := '';
      Cells[2, i] := '';
      Cells[3, i] := '';
      Cells[4, i] := '';
      Cells[5, i] := '';
      Cells[6, i] := '';
    end;
  end;
end;

procedure TForm1.UpdateRegs;
var
   i: integer;
begin
  if stringgrid3.rowCount <= rtItems.Regs.Count then
    stringgrid3.rowCount := rtItems.Regs.Count + 1;
  for i := 0 to rtItems.Regs.Count - 1 do
  begin
    stringgrid3.Cells[0, i + 1] := inttostr(rtItems.Regs.Items[i].Number);
    stringgrid3.Cells[1, i + 1] := rtItems.Regs.Items[i].Name;
    stringgrid3.Cells[2, i + 1] := inttostr(rtItems.Regs.Items[i].Handle);
  end;
end;



procedure TForm1.Timer1Timer(Sender: TObject);
begin
//     upd;
     if PageControl1.ActivePage = TabSheetActiveAlarms then updateAlarms;
     if PageControl1.ActivePage = TabSheetTeg then upd;
     if PageControl1.ActivePage = TabSheetZurnal then updateJurnal;
     if PageControl1.ActivePage = TabSheetEvents then updateEvents;
     if PageControl1.ActivePage = TabSheetCommand then updateCommand;
     if PageControl1.ActivePage = TabSheetRegs then updateRegs;
     if PageControl1.ActivePage = TabLog then
     updateLog;
end;
procedure TForm1.ButtonLogClick(Sender: TObject);
begin
    flogvis:=not flogvis;
    if flogvis then
     ButtonLog.Caption:='Stop' else
     ButtonLog.Caption:='Start';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    // rtItems.decCounter(rtItems.GetID (Edit1.Text));
end;


procedure TForm1.TrackBar1Change(Sender: TObject);
var
   shift: integer;
begin
  shift := 0;
  case whatBase of
    btAnalog: shift := 0;
    btcalc: shift := calcShift;
  end;
   //  rtItems.AddCommand(strtoint(label1.caption)  + shift,
        //                   1.0 * TrackBar1.Position /10.0,
          //                 false);
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);
begin
    curId:=strtointdef(StringGrid1.Cells[0,Row],-1);
    // label1.caption := stringGrid1.Cells[0, row];
   //  edit1.OnChange := nil;
   //  Edit1.text := stringGrid1.Cells[1, row];
   //  Edit1.tag := strtoint(stringGrid1.Cells[0, row]);
   //  edit1.OnChange := Edit1Change;
end;



procedure TForm1.Button4Click(Sender: TObject);
var
   i: longInt;
   shift: LongInt;
begin
  if TButton(sender).Caption = 'AllValid' then
    for i := 0 to rtItems.Count - 1 do
      rtItems.SetVal(i, rtItems[i].ValReal,100);
//  if TButton(sender).Caption = 'AllInValid' then
//    for i := 0 to rtItems.Count - 1 do
 //     rtItems.SetValid(i, 0);
 // if TButton(sender).Caption = 'ChangeValid' then
    //  if rtItems.isValid(strtoint(label1.caption)) then
      //  rtItems.SetValid(strtoint(label1.caption), 0)
     // else rtItems.SetValid(strtoint(label1.caption), 100);

  shift := calcShift;
 // for i := shift to shift + rtItems.calc.Count - 1 do
   // rtItems.SetVal(i,rtitems.Items[i].ValReal, 100);
end;



procedure TForm1.Button3Click(Sender: TObject);
var
   i: longInt;
begin
     for i := 0 to rtItems.Count - 1 do
     begin
       while rtItems.Items[i].refCount > 0 do rtItems.DecCounter(i);
       while rtItems.Items[i].refCount < 0 do rtItems.IncCounter(i);
     end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    whatBase := btAnalog;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    whatBase := btCalc;
end;

function MyCompareText (str1, str2: string): integer;
var
 minLength: integer;
 i: integer;
begin
  result := 0;
  minLength := minIntValue ([length(str1), length(Str2)]);
  for i:=1 to minLength do begin
    if str1[i] > str2[i] then result := 1;
    if str1[i] < str2[i] then result := -1;
    if result <> 0 then exit;
  end;
  IF length(str1) < length(Str2) then result := -1;
end;


procedure TForm1.Edit1Change(Sender: TObject);
var
  compRes: integer;
  i: integer;

begin
  with stringGrid1 do
  for i := 0 to rtItems.Count - 1 do
  begin
   // compRes := MycompareText(UpperCase(rtItems.GetName(i)), UpperCase(Edit1.Text));
    if compRes = 0 then
    begin
      StringGrid1.OnSelectCell := nil;
      Row := i+1;
 //     edit1.Tag := i;
   //   label1.caption := inttostr(edit1.Tag);
      StringGrid1.OnSelectCell := StringGrid1SelectCell;
      exit;
    end;
  end;
end;



procedure TForm1.TrackBar2Change(Sender: TObject);
var
   shift: integer;
begin
  shift := 0;
  case whatBase of
    btAnalog: shift := 0;
    btcalc: shift := calcShift;
  end;
    // rtItems.SetValue(strtoint(label1.caption)  + shift,
    //                       1.0*TrackBar2.Position/10);

end;


procedure TForm1.Timer2Timer(Sender: TObject);
var
  i: integer;
begin
    for i := 0 to rtItems.Count - 1 do
      if (rtItems[i].ID <> -1) and (pos('_req', rtItems.GetName(i))=0) and ((pos('k', rtItems.GetName(i)) = 1) or (pos('K', rtItems.GetName(i)) = 1)) then
          rtItems.SetVal(i, round(random),100)
    else
    if (pos('_req', rtItems.GetName(i))<>0) then rtItems.SetVal(i, round(random) + 1,100);
    //if rtItems.GetSimpleID('JurnalShow') <> -1 then rtItems.SetValue(rtItems.GetSimpleID('JurnalShow'), 1);
end;

procedure TForm1.sgAlarmsRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  showMessage(';');
end;

procedure TForm1.sgAlarmsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  // Edit1.text := sgAlarms.Cells[3, arow];
end;

procedure TForm1.UpdateJurnal;
var
 i: integer;
begin
  sgAlarms.RowCount := max(2, rtItems.alarms.Count + 1);
  for i := sgAlarms.TopRow - 1 to sgAlarms.TopRow + sgAlarms.VisibleRowCount do
  begin
    if i >= rtItems.alarms.Count then exit;
    if i > sgAlarms.RowCount + 1 then sgAlarms.RowCount := sgAlarms.RowCount + 1;
    sgAlarms.Cells[0, i + 1] := inttostr(rtItems.alarms[i].number);
    sgAlarms.Cells[1, i + 1] := formatdatetime('hh:mm:ss.zzz',rtItems.alarms[i].time);
    case rtItems.alarms[i].typ of
     msNew: sgAlarms.Cells[2, i+1] := rtItems.GetAlarmMsg(rtItems.alarms[i].tegID);
     msKvit: sgAlarms.Cells[2, i+1] := 'КВИТИРОВАНИЕ :' + rtItems.GetAlarmMsg(rtItems.alarms[i].tegID);
     msOut: sgAlarms.Cells[2, i+1] := 'УХОД :' + rtItems.GetAlarmMsg(rtItems.alarms[i].tegID);
     msOn: sgAlarms.Cells[2, i+1] := 'ВКЛЮЧЕНИЕ :' + rtItems.GetOnMsg(rtItems.alarms[i].tegID);
     msOff: sgAlarms.Cells[2, i+1] := 'ВЫКЛЮЧЕНИЕ :' + rtItems.GetOffMsg(rtItems.alarms[i].tegID);
     msCmd: sgAlarms.Cells[2, i+1] := 'КОМАНДА :' + rtItems.GetComment(rtItems.alarms[i].tegID);
    end;
    sgAlarms.Cells[3, i+1] := rtItems.GetName(rtItems.alarms[i].tegID);
    sgAlarms.Cells[4, i+1] := inttostr(rtItems.alarms[i].number);
  end;
end;

procedure TForm1.UpdateAlarms;
var
 i, j: integer;
begin
 with sgActiveAlarms do
 begin
  //чистим грязь
  for i := rtItems.activealarms.Count + 1 to RowCount - 1 do
    for j := 0 to ColCount - 1 do Cells[j, i] := '';

  for i := 0 to rtItems.activealarms.Count - 1 do
  begin
    if i > RowCount - 2 then RowCount := RowCount + 1;
    Cells[0, i + 1] := inttostr(rtItems.activealarms[i].number);
    Cells[1, i + 1] := datetimetostr(rtItems.activealarms[i].time);
    Cells[2, i+1] := rtItems.GetAlarmMsg(rtItems.activealarms[i].tegID);
    Cells[3, i+1] := rtItems.GetName(rtItems.activealarms[i].tegID);
    Cells[4, i+1] := ifthen(rtItems.activealarms[i].isKvit, 'T', 'F');
    Cells[5, i+1] := ifthen(rtItems.Activealarms[i].isOff, 'F', 'T');
  end;
 end;
end;

procedure TForm1.sgActiveAlarmsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  // Edit1.text := sgActiveAlarms.Cells[3, arow];
end;

procedure TForm1.UpdateEvents;
var
   i: integer;
   Base: TCommandMems;
begin

 // Base := rtItems.ValCh;

 { with stringGrid2 do
  begin

    if rowCount <= base.Count then
       rowCount := base.Count + 1;
    for i := 0 to base.Count - 1 do
    begin
        Cells[0, i + 1] := inttostr(base.Items[i].Number);
        Cells[1, i + 1] := inttostr(base.Items[i].ID);
        Cells[2, i + 1] := floattostr(base.Items[i].PrevVal);
        Cells[3, i + 1] := floattostr(base.Items[i].ValReal);
        if rtItems.command.Items[i].executed then
           Cells[4, i + 1] := 'T'
        else
           Cells[4, i + 1] := 'F';
    end;
    for i := base.Count + 1 to RowCount - 1 do
    begin
      Cells[0, i] := '';
      Cells[1, i] := '';
      Cells[2, i] := '';
      Cells[3, i] := '';
      Cells[4, i] := '';
    end;
  end;      }
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  rtItems.activeAlarms.KvitAll;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
   i: longInt;
begin
     for i := 0 to rtItems.Count - 1 do
     if rtItems[i].ID <> -1 then
       if rtItems.Items[i].refCount <= 0 then rtItems.IncCounter(i);
end;
procedure TForm1.TrackBar3Change(Sender: TObject);
begin
 // if trackBar3.position <> 0 then
 // begin
 //   timer2.Interval := (11 - trackBar3.position) * 250;
 //   label4.Caption := 'Имитатор нагрузки ' + floattostr(timer2.Interval / 1000) + ' сек.';
 //   timer2.Enabled := true;
 // end
 // else
 // begin
 //   timer2.Enabled := false;
  //  label4.Caption := 'Имитатор нагрузки остановлен';
  //end;


end;

procedure TForm1.Button7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     //rtItems.AddCommand(strtoint(label1.caption), 1, true);
end;

procedure TForm1.Button7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    // rtItems.AddCommand(strtoint(label1.caption), 0, true);
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
    changeFo.Execute(curId);
end;

procedure TForm1.N2Click(Sender: TObject);
var i: integer;
begin
  for i := 0 to rtItems.Count - 1 do
      rtItems.SetVal(i,rtitems[i].ValReal ,100);
end;

procedure TForm1.AllInvalid1Click(Sender: TObject);
var i: integer;
begin
    for i := 0 to rtItems.Count - 1 do
      rtItems.ValidOff(i);
end;

procedure TForm1.Allinc1Click(Sender: TObject);
 var i: integer;
begin
     for i := 0 to rtItems.Count - 1 do
      rtItems.IncCounter(i);
end;

procedure TForm1.Alldec1Click(Sender: TObject);
var i: integer;
begin
      for i := 0 to rtItems.Count - 1 do
      rtItems.DecCounter(i);
end;

procedure TForm1.N6Click(Sender: TObject);
var fn: string;
    i,j: integer;
    text_str: string;
    SL: TstringList;
    temp: boolean;
begin
 temp:=flogvis;
SL:=TstringList.Create;
with self.SaveDialog1 do
 begin
    if SaveDialog1.Execute then
     begin



  flogvis:=false;
  for j := 0 to rtItems.fdebugBase.Count-1 do
  begin
    scLog.fRows.Items[j + 1].font.color:=getmsgcolor(rtItems.fdebugBase[j].level);
    scLog.Cells[0, j + 1] := inttostr(rtItems.fdebugBase.items_[j].number);
    scLog.Cells[1, j + 1] := formatdatetime('yy-mm-dd hh:nn:ss.zzz',rtItems.fdebugBase.items_[j].time);
    scLog.Cells[2, j+1] := rtItems.fdebugBase.items_[j].application;
    scLog.Cells[3, j+1] :=rtItems.fdebugBase.items_[j].debugmessage;
    scLog.Cells[4, j+1] := inttostr(rtItems.fdebugBase[j].level);
  end;

  for i := 0 to scLog.RowCount-2 do
  begin
    text_str:=scLog.Cells[0, i + 1]+';'+
    scLog.Cells[1, i + 1]+';'+
    scLog.Cells[2, i + 1]+';'+
    scLog.Cells[3, i + 1]+';'+
    scLog.Cells[4, i + 1]+';';
    SL.Add(text_str)
  end;
  SL.SaveToFile(SaveDialog1.FileName+'.csv');
 end;
 end;
flogvis:=temp;
SL.Free;
end;

procedure TForm1.rKvit1Click(Sender: TObject);
var i: integer;
begin
i:=rtitems.GetSimpleID('rKvit');
if i<0 then exit;
if rtitems.Items[i].ID<0 then exit;
rtitems.AddCommand(i,1,false);
rtitems.Items[i].ValReal:=0;
end;

end.
