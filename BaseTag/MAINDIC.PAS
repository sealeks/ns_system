unit MAINDIC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ImgList, Menus, StdCtrls, FloatEdits,
  ExtCtrls,
  IDGlobal,
  MemStructsU, constDef, calcU1,
  SelectAppFormU, ViewDSDoc, ConvFunc, FrmDfltNewU, GroupsU, frmEditCSVU,
  frmGrpNewU, FrmGrpDblU, Grids, ColorStringGrid, IMMIAlarmActive,globalValue,
  Buttons;

type
  tbaseType = (btAnalog, btCalc);

  TDicEditForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label10: TLabel;
    Edit4: TEdit;
    Edit3: TEdit;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox1: TCheckBox;
    FloatEdit1: TFloatEdit;
    CheckBox2: TCheckBox;
    Edit6: TEdit;
    ComboBox1: TComboBox;
    CheckBox5: TCheckBox;
    FloatEdit7: TFloatEdit;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    FloatEdit2: TFloatEdit;
    FloatEdit3: TFloatEdit;
    FloatEdit4: TFloatEdit;
    FloatEdit5: TFloatEdit;
    Edit7: TEdit;
    FloatEdit6: TFloatEdit;
    Edit2: TEdit;
    Edit5: TEdit;
    ComboBox2: TComboBox;
    ImageList1: TImageList;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Edit1: TEdit;
    ToolBar2: TToolBar;
    ComboBox3: TComboBox;
    Label15: TLabel;
    MainMenu1: TMainMenu;
    N6: TMenuItem;
    N7: TMenuItem;
    yttt1: TMenuItem;
    PLCDirect1: TMenuItem;
    csv2: TMenuItem;
    N1: TMenuItem;
    csv1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    FloatEdit8: TFloatEdit;
    Label16: TLabel;
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowItem(num: longInt);
    procedure ShowItemFirst(Sender: TObject);
    procedure ShowItemprev(Sender: TObject);
    procedure ShowItemNext(Sender: TObject);
    procedure ShowItemLast(Sender: TObject);
    procedure ShowItemNew(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure PLCDirect1Click(Sender: TObject);
    procedure csv2Click(Sender: TObject);
    procedure csv1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FloatEdit8Change(Sender: TObject);
  private
    { Private declarations }
    fisChanged: boolean;
    procedure SetIsChanged(const Value: boolean);
  public
    { Public declarations }
    curItem: longint;
    enableAlarmDefinition: boolean;
    property isChanged: boolean read fisChanged write SetIsChanged;
    procedure ShowItembyName(Name : string);
    function FindLesses: integer;
    function FindBiggest: integer;
    function FindNextLess(var curIt: integer): boolean;  //curIt изменяется, если найдено
    function FindNextMore(var curIt: integer): boolean;  //curIt изменяется, если найдено
    function GetStartAddr(typeMod:string): string;
    function ShiftAddr(typeMod, Item: string; shiftWord: integer): string;
    function DefDflt(var dfltBCD, dfltAlarmedLocal: boolean;
                           var dfltGroup, dfltAlCase: string;
                           var dfltAlLevel: integer;
                           var dfltMinEu, dfltMaxEu,
                           dfltMinRaw, dfltMaxRaw,
                           dfltAlConst: real): TModalResult;
  end;

var
  DicEditForm: TDicEditForm;
  groups, alarmGroups: TGroups;


implementation

{$R *.dfm}
function cbSelectItem(cb: tComboBox; it: string): boolean;  //выбирает в выпадающем списке совпадающую заись
var
  i: integer;
begin
result := false;
for i :=0 to cb.Items.Count - 1 do
  if UpperCase(cb.Items[i]) = UpperCase(it) then
  begin
    cb.ItemIndex := i;
    result := true;
    exit;
  end;
end;
{ TForm1 }

procedure TDicEditForm.SetIsChanged(const Value: boolean);
begin
  fisChanged := Value;
  if fIsChanged then
  begin
    ToolButton1.Enabled := false;
    ToolButton2.Enabled := false;
    ToolButton3.Enabled := false;
    ToolButton4.Enabled := false;
    ToolButton5.Enabled := false;
    ToolButton6.Enabled := false;
    ToolButton7.Enabled := true;
    ToolButton8.Enabled := true;
  end else
  begin
    if curItem <> FindLesses then
    begin
      ToolButton1.Enabled := true;
      ToolButton2.Enabled := true;
    end;
    if curItem <> FindBiggest then
    begin
      ToolButton3.Enabled := true;
      ToolButton4.Enabled := true;
    end;
    ToolButton5.Enabled := true;
    ToolButton6.Enabled := true;
    ToolButton7.Enabled := false;
    ToolButton8.Enabled := false;
  end;
end;

procedure TDicEditForm.Edit1Change(Sender: TObject);
begin
  isChanged := true;
end;

procedure TDicEditForm.FormCreate(Sender: TObject);
begin
  copyFileto(PathMem + 'Analog.mem',PathMem + 'Analog.old');
  copyFileto(PathMem + 'Strings.mem',PathMem + 'Strings.old');
  try
    rtItems := TanalogMems.Create(PathMem);
    groups := TGroups.Create(PathMem + 'groups.cfg');
    groups.FillStrings(combobox2.Items);
    AlarmGroups := TGroups.Create(PathMem + 'alarmGroups.cfg');
    alarmGroups.FillStrings(combobox3.Items);
    ShowitemFirst(self);
    if ParamCount <> 0 then ShowItembyName(paramStr(1));
  except
    on E: Exception do
    begin
      showMessage (E.Message);
      application.terminate;
    end;
  end;
end;

procedure TDicEditForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  groups.Free;  
  rtItems.free;
end;

procedure TDicEditForm.ShowItembyName(Name: string);
var
  i: integer;
begin
    for  i := 0 to rtitems.Count - 1 do
      if UpperCase(rtItems.GetName(i)) = UpperCase(Name) then
      begin
        ShowItem(i);
        break;
      end;
end;

procedure TDicEditForm.ShowItem(num: longInt);
begin
  Edit1.Text := rtItems.GetName(num);
  Edit2.Text := rtItems.GetComment(num);
  Edit3.Text := rtItems.GetOnMsg(num);
  Edit4.Text := rtItems.GetOffMsg(num);
  Edit5.Text := rtItems.GetDDEItem(num);
  Edit6.Text := rtItems.GetAlarmMsg(num);
  Edit7.Text := rtItems.GetEU(num);
  FloatEdit1.Text := floattostr(rtItems.Items[num].LogDB);
  FloatEdit2.Text := floattostr(rtItems.Items[num].MinRaw);
  FloatEdit3.Text := floattostr(rtItems.Items[num].MaxRaw);
  FloatEdit4.Text := floattostr(rtItems.Items[num].MinEu);
  FloatEdit5.Text := floattostr(rtItems.Items[num].MaxEu);
  FloatEdit6.Text := floattostr(rtItems.Items[num].DeadBaund);
  FloatEdit7.Text := floattostr(rtItems.Items[num].AlarmConst);
  FloatEdit8.Text := inttostr(rtItems.Items[num].logtime);
  checkBox1.Checked := rtItems.Items[num].Logged;
  checkBox2.Checked := rtItems.Items[num].AlarmedLocal;
  checkBox3.Checked := rtItems.Items[num].OnMsged;
  checkBox4.Checked := rtItems.Items[num].OffMsged;
  checkBox5.Checked := rtItems[num].AlarmLevel > 500;

  comboBox1.ItemIndex := integer(rtItems[num].AlarmCase);
  comboBox2.ItemIndex := combobox2.Items.IndexOf(Groups[rtItems[num].GroupNum]);
  comboBox3.ItemIndex := combobox3.Items.IndexOf(AlarmGroups[rtItems[num].AlarmGroup]);

  curItem := num;

  isChanged := false;
end;

procedure TDicEditForm.ShowItemFirst(Sender: TObject);
begin
  if rtItems.Count <> 0 then
  begin
    ShowItem(findLesses);

    ToolButton1.Enabled := false;
    ToolButton2.Enabled := false;
    ToolButton3.Enabled := true;
    ToolButton4.Enabled := true;
  end
  else ShowItemNew(self);
end;

procedure TDicEditForm.ShowItemprev(Sender: TObject);
begin
  if rtItems.Count = 0 then ShowitemNew(self)
  else
    if FindNextLess(curItem) then
      ShowItem(curItem)
    else
    begin
      ToolButton1.Enabled := false;
      ToolButton2.Enabled := false;
      ToolButton3.Enabled := true;
      ToolButton4.Enabled := true;
    end;
end;

procedure TDicEditForm.ShowItemNext(Sender: TObject);
begin
  if rtItems.Count = 0 then ShowitemNew(self)
  else
    if FindNextMore(curItem) then
      ShowItem(curItem)
    else
    begin
      ToolButton1.Enabled := true;
      ToolButton2.Enabled := true;
      ToolButton3.Enabled := false;
      ToolButton4.Enabled := false;
    end;
end;

procedure TDicEditForm.ShowItemLast(Sender: TObject);
begin
  if rtItems.Count <> 0 then
  begin
    ShowItem(findBiggest);

    ToolButton1.Enabled := true;
    ToolButton2.Enabled := true;
    ToolButton3.Enabled := false;
    ToolButton4.Enabled := false;
  end
  else ShowItemNew(self);
end;

procedure TDicEditForm.ShowItemNew(Sender: TObject);
var
  i: integer;
begin
  rtItems.Items[curitem].LogDB := Strtofloat(floatEdit1.Text);

  Edit1.Text := '';
  if rtItems.Count = 0 then
  begin
    Edit2.Text := '';
    Edit3.Text := '';
    Edit4.Text := '';
    floatEdit1.Text := '0';

    checkBox1.Checked := false;
    checkBox2.Checked := false;
    checkBox3.Checked := false;
    checkBox4.Checked := false;

    isChanged := true;
    curItem := 0;
  end
  else
  begin
    //ищем пустую запись, если нет, добавляем в конец
    curItem := -1;
    for  i := 0 to rtitems.Count - 1 do
      if rtItems[i].ID = -1 then
      begin
        curitem := i;
        break;
      end;
    if CurItem = -1 then
    begin
      CurItem := rtitems.Count;
    end;
  end;

end;

procedure TDicEditForm.ToolButton6Click(Sender: TObject);
var
  NextItem : integer;
begin
  //записать измененные даннные
  nextItem := Curitem;
  //если мы на последней записи, показать предыдущую, иначе следующую
  if not FindNextMore(NextItem) then FindNextLess(NextItem);
  rtItems.FreeItem(CurItem);
  rtItems.WriteToFile(curItem); //записать на диск саму запись
  ShowItem(nextItem);
end;

procedure TDicEditForm.ToolButton7Click(Sender: TObject);
begin
  //Если запись новая, то надо проверить, нет ли повторения имен
  if rtItems[CurItem].ID = -1 then
    if rtItems.GetSimpleID(edit1.Text) <> -1 then
      raise Exception.Create('Дублирование имен!');

  //если мы добавляли запись, то увеличиваем количество
  if CurItem = rtItems.Count then
  begin
    rtItems.Count := rtItems.Count  + 1;
    rtItems.FreeItem(CurItem);
  end;
  //записать измененные даннные
  rtItems[CurItem].ID := curItem;
  rtItems.SetName(curitem, edit1.Text);
  rtItems.SetComment(curitem, edit2.Text);
  rtItems.SetOnMsg(curitem, edit3.Text);
  rtItems.SetOffMsg(curitem, edit4.Text);
  rtItems.SetDDEItem(curItem, Edit5.Text);
  rtItems.SetAlarmMsg(curItem, Edit6.Text);
  rtItems.SetEU(curItem, Edit7.Text);
 
  rtItems.Items[curitem].LogDB := Strtofloat(FloatEdit1.Text);
  rtItems.Items[curitem].MinRaw := Strtofloat(FloatEdit2.Text);
  rtItems.Items[curitem].MaxRaw := Strtofloat(FloatEdit3.Text);
  rtItems.Items[curitem].MinEu := Strtofloat(FloatEdit4.Text);
  rtItems.Items[curitem].MaxEu := Strtofloat(FloatEdit5.Text);
  rtItems.Items[curitem].DeadBaund := Strtofloat(FloatEdit6.Text);
  rtItems.Items[curitem].AlarmConst := Strtofloat(FloatEdit7.Text);
  rtItems.Items[curitem].LogTime := round(Strtofloat(FloatEdit8.Text));
  rtItems.Items[curitem].Logged := checkBox1.Checked;
  rtItems.Items[curitem].AlarmedLocal := checkBox2.Checked;
  rtItems.Items[curitem].OnMsged := checkBox3.Checked;
  rtItems.Items[curitem].OffMsged := checkBox4.Checked;

  if checkBox5.Checked then rtItems[curItem].AlarmLevel := 600
  else rtItems[curItem].AlarmLevel := 400;

  rtItems[curItem].AlarmCase := tAlarmCase(comboBox1.ItemIndex);
  rtItems[curItem].GroupNum := Groups.ItemNum[ComboBox2.Items[ComboBox2.ItemIndex]];
  rtItems[curItem].AlarmGroup := AlarmGroups.ItemNum[ComboBox3.Items[ComboBox3.ItemIndex]];

  rtItems.WriteToFile(curItem); //записать на диск саму запись
  isChanged := false;

end;

procedure TDicEditForm.ToolButton8Click(Sender: TObject);
begin
  showItem(CurItem);
  if rtItems[curItem].ID = -1 then
    ShowItemNext(self);
  isChanged := false;

end;

procedure TDicEditForm.ToolButton11Click(Sender: TObject);
var
  i: integer;
begin
  with TSelectAppForm.Create(self) do
  try
    for i:=0 to rtItems.Count - 1 do
      if rtItems[i].ID <> -1 then
        ListBox1.AddItem (rtItems.GetName(i), nil);
    ListBox1.MultiSelect := false;
    ListBox1.Sorted := true;
    if ShowModal = mrOK then
      showItem(rtItems.GetSimpleID(ListBox1.Items[ListBox1.ItemIndex]));
  finally
    free;
  end;
end;

procedure TDicEditForm.PLCDirect1Click(Sender: TObject);
var
  i: integer;
  rtName: string;
  isNew: boolean;
  dfltBCD, dfltAlarmedLocal, KnowDflt: boolean;
  dfltGroup, dfltAlCase: string;
  dfltAlLevel: integer;
  dfltMinEu, dfltMaxEu, dfltMinRaw, dfltMaxRaw, dfltAlConst: real;
  ImportTo, StartAddr: string; //address of V-memory, where will be imported to
  bitsCount, StartWordAddr: integer;
  shiftWord: integer;
  ReplaceAll: boolean;
begin
  openDialog1.DefaultExt := 'esd';
  openDialog1.Filter := 'Текст с разделителями(*.esd)|*.esd';
  ReplaceAll := false;
  KnowDflt := false;
  enableAlarmDefinition := false;
  if OpenDialog1.Execute then
  begin
    with  TESDImpFrm.Create(self) do
    begin
      ShowDoc (OpenDialog1.FileName);
      Sort1Click(self);
      if showModal = mrOK then
      begin
        ImportTo := Edit2.Text;

        shiftWord := 0;

        if (trim(StringGrid1.Cells[0, 1]) <> 'B') and (trim(StringGrid1.Cells[0, 1]) <> 'V' ) then
        begin
          StartAddr := GetStartAddr(StringGrid1.Cells[0, 1]);
          bitsCount := OctStringToInteger(edit2.text);
          StartWordAddr := OctStringToInteger(StartAddr) + bitsCount div 16;
          importTo := IntegerToOctString(StartWordAddr);

          if not InputQuery('Начальный адрес', 'Импортировать в V:', ImportTo) then exit;
          //новый адрес известен, теперь рассчитать смещение для битов
          shiftWord := OctStringToInteger(importTo) - StartWordAddr;
        end;

        for i := 1 to StringGrid1.RowCount-1 do
        begin
          if StringGrid1.Cells[2, i] = '' then continue;
          ProgressBar1.Position := i;

           rtName := StringGrid1.Cells[2, i];
           isNew := true;
           if rtItems.GetSimpleID(rtName) <> -1 then begin
             ShowItem(rtItems.GetSimpleID(rtName));
             isNew := false;
             if not replaceAll then
               case MessageDlg('Параметр '+ rtName + ' существует. Изменить?',
                           mtConfirmation, [mbYes, mbAll, mbNo, mbCancel], 0) of
                 mrAll: replaceAll := true;
                 mrCancel:  exit;
                 mrNo: continue;//skip this record
               end;
           end else ShowItemNew(self);

           if isNew and not KnowDflt then
             if DefDflt(dfltBCD, dfltAlarmedLocal,
                           dfltGroup, dfltAlCase,
                           dfltAlLevel,
                           dfltMinEu, dfltMaxEu,
                           dfltMinRaw, dfltMaxRaw,
                           dfltAlConst) <> mrOK then exit
             else KnowDflt := true;


           self.Edit1.Text := rtName;
           self.Edit2.Text := StringGrid1.Cells[4, i];
           Self.Edit5.Text := 'V' + ShiftAddr(StringGrid1.Cells[0, i], StringGrid1.Cells[1, i], shiftWord);

           if isNew then
           with self do
           begin
             if dfltBCD then
             begin
               Edit5.Text := Edit5.Text + ':B';
               floatEdit1.Text := format('%g', [(dfltMaxEu - dfltMinEu) / 200]); //0.5%
             end;
             comboBox2.Text := dfltGroup;
             floatEdit2.text := format('%g', [dfltMinRaw]);
             floatEdit3.text := format('%g', [dfltMaxRaw]);
             floatEdit4.text := format('%g', [dfltMinEu]);
             floatEdit5.text := format('%g', [dfltMaxEu]);
             checkBox2.Checked := dfltAlarmedlocal;
             edit6.Text := edit2.Text;
             CheckBox5.Checked := (dfltAlLevel > 500);
             comboBox1.ItemIndex := integer(dfltAlCase);
             floatEdit7.Text := format('%g', [dfltAlConst]);
         //    floatEdit8.Text := format('%g', [dfltAlConst]);
           end;
           ToolButton7Click(self);
        end;
      end;
      free;
    end;
  end;
  enableAlarmDefinition := true;
end;

procedure TDicEditForm.csv2Click(Sender: TObject);
var
  i, j: integer;
  nameCol: integer;
  replaceAll: boolean;
  rtName: string;
begin
  replaceAll := false;
  nameCol := -1;
  openDialog1.DefaultExt := 'csv';
  openDialog1.Filter := 'Текст с разделителями(*.csv)|*.csv';
  if openDialog1.Execute then
  with TFrmEditCSV.Create(self) do
  try
    fillGridFromCSV(StringGrid1, openDialog1.fileName);
    for i := 0 to StringGrid1.ColCount - 1 do
      if UpperCase(StringGrid1.Cells[i, 0]) = 'NAME' then NameCol :=i
      else
        if (UpperCase(StringGrid1.Cells[i, 0]) <> 'GROUP') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ITEM') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'COMMENT') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'LOGGED') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'LOGTIME') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'LOGDB') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'MINRAW') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'MAXRAW') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'MINEU') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'MAXEU') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMEDLOCAL') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMMSG') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMLEVEL') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMCASE') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMCONST') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'EU') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMGROUP') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'DEADBAUND')
        then
           raise exception.Create('Заголовок не определен "' + StringGrid1.Cells[i, 0] + '"');
    if NameCol = -1 then raise exception.Create('Поле NAME не найдено');

    for j := 1 to StringGrid1.RowCount - 1 do
    begin
      if StringGrid1.Cells[NameCol, j] = '' then continue;
        rtName := StringGrid1.Cells[nameCol, j];
        if rtItems.GetSimpleID(rtName) <> -1 then
        begin
          ShowItem(rtItems.GetSimpleID(rtName));
          if not replaceAll then
            case MessageDlg('Параметр '+ rtName + ' существует. Изменить?',
                        mtConfirmation, [mbYes, mbAll, mbNo, mbCancel], 0) of
              mrAll: replaceAll := true;
              mrCancel:  exit;
              mrNo: continue;//skip this record
            end;
        end else ShowItemNew(self);

        self.Edit1.Text := rtName;

        for i := 0 to StringGrid1.ColCount - 1 do
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'GROUP') then
          begin
            self.comboBox2.ItemIndex := self.comboBox2.Items.IndexOf(StringGrid1.Cells[i, j]);
            if self.comboBox2.ItemIndex = -1 then
             raise Exception.Create('Группа не определена ' + StringGrid1.Cells[i, j] +
                                        ' параметр ' + StringGrid1.Cells[NameCol, j]);
          end else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ITEM') then
            self.edit5.Text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'COMMENT') then
            self.edit2.Text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'LOEDGGED') then
              checkBox1.Checked := (UpperCase(StringGrid1.Cells[i, j]) = 'TRUE') else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'LOGDB') then
              floatEdit1.text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'MINRAW') then
              floatEdit2.text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'MAXRAW') then
              floatEdit3.text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'MINEU') then
              floatEdit4.text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'MAXEU') then
              floatEdit5.text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMEDLOCAL') then
              checkBox2.Checked := (UpperCase(StringGrid1.Cells[i, j]) = 'TRUE')else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMMSG') then
            self.edit6.Text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'DEADBAUND') then
            self.edit7.Text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMLEVEL') then
              CheckBox5.Checked := strtoint(StringGrid1.Cells[i, j]) > 500 else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMCASE') then
            cbSelectItem(self.comboBox1, StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'EU') then
          self.FloatEdit6.Text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMCONST') then
          self.FloatEdit7.Text := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMGROUP') then
          self.ComboBox3.Text := StringGrid1.Cells[i, j];
        ToolButton7Click(self);
    end; //for row.count
  finally
    free;
  end;
end;

procedure TDicEditForm.csv1Click(Sender: TObject);
var
  i: integer;
  f: TextFile;
begin
 if SaveDialog1.Execute then
 if not FileExists(SaveDialog1.FileName) or
   ((FileExists(SaveDialog1.FileName) and
    (MessageDlg('Файл ' + ExtractFileName(SaveDialog1.FileName) + ' существует. Перезаписать?',
        mtConfirmation, [mbYes, mbNo], 0) = IDYes))) then
 try
   assignFile(f, SaveDialog1.FileName);
   rewrite(f);

   writeln(f, 'Name', ';', 'Group', ';', 'Item', ';', 'Comment', ';',
                'Logged', ';', 'LogTime', ';', 'LogDB', ';',
                'MinRaw', ';', 'MaxRaw', ';', 'MinEu', ';', 'MaxEu', ';',
                'OnMsged', 'OnMsgPos', 'offMsged', 'OffMsgPos',
                'AlarmedLocal', ';', 'AlarmMsg', ';', 'AlarmLevel', ';',
                'AlarmCase', ';', 'AlarmConst', ';',
                'DeadBaund', ';', 'EU', ';', 'AlarmGroup'
          );
   for i := 0 to rtItems.Count - 1 do
     if rtItems[i].ID <> -1 then
     begin
       writeln(f, rtItems.GetName(i), ';', groups[rtItems[i].GroupNum], ';',
                rtItems.GetDDEItem(i), ';', rtItems.GetComment(i), ';',
                rtItems[i].Logged, ';', rtItems[i].LogTime, ';', rtItems[i].LogDB:8:3, ';',
                rtItems[i].MinRaw:8:3, ';', rtItems[i].MaxRaw:8:3, ';',
                rtItems[i].MinEu:8:3, ';',rtItems[i].MaxEu:8:3, ';',
                rtItems[i].OnMsged, rtItems.GetOnMsg(i), rtItems[i].offMsged, rtItems.GetOffMsg(i),
                rtItems[i].AlarmedLocal, ';', rtItems.GetAlarmMsg(i), ';',
                rtItems[i].AlarmLevel, ';', rtItems.GetAlarmCase(i), ';',
                rtItems[i].AlarmConst:8:3, ';', rtItems[i].DeadBaund:8:3, ';', rtItems.GetEU(i), ';', alarmgroups[rtItems[i].AlarmGroup]
        );
     end;
 finally
   closeFile(f);
 end;
end;

function TDicEditForm.GetStartAddr(typeMod:string): string;
begin
 if trim(typeMod) = 'V' then result := '0';
 if trim(typeMod) = 'B' then result := '0';
 if trim(typeMod) = 'GX' then result := '40000';
 if trim(typeMod) = 'GY' then result := '40200';
 if trim(typeMod) = 'S' then result := '41000';
 if trim(typeMod) = 'T' then result := '41100';
 if trim(typeMod) = 'SP' then result := '41200';
 if trim(typeMod) = 'X' then result := '40400';
 if trim(typeMod) = 'Y' then result := '40500';
 if trim(typeMod) = 'C' then result := '40600';
end;

function TDicEditForm.ShiftAddr(typeMod, Item: string; shiftWord: integer): string;
var
  itemWordAddr, ItemBitsAddr, bitsCount: integer;
begin
 result := Item;
 if (trim(typeMod) <> 'B') and (trim(typeMod) <> 'V' ) then
 begin
   bitsCount := OctStringToInteger(Item);
   ItemWordAddr := OctStringToInteger(GetStartAddr(typeMod)) + bitsCount div 16;
   ItemBitsAddr := bitsCount mod 16;
   result := IntegerToOctString(ItemWordAddr + ShiftWord) + '.' + IntToStr(ItemBitsAddr);
 end;
end;

function TDicEditForm.DefDflt(var dfltBCD, dfltAlarmedLocal: boolean;
                           var dfltGroup, dfltAlCase: string;
                           var dfltAlLevel: integer;
                           var dfltMinEu, dfltMaxEu,
                           dfltMinRaw, dfltMaxRaw,
                           dfltAlConst: real): TModalResult;
var
  inputOK: boolean;
begin
  with TFrmDfltNew.Create(self) do
  begin

    repeat
      groups.FillStrings(comboBox2.Items);
      comboBox2.ItemIndex := 0;
      result := ShowModal;

      inputOk := true;
      if result = mrCancel then exit;

      try
        dfltBCD := checkBox2.Checked;
        dfltGroup := ComboBox2.Items[ComboBox2.ItemIndex];
        dfltMinRaw := strtofloat(edit2.text);
        dfltMaxRaw := strtofloat(edit3.text);
        dfltMinEU := strtofloat(edit4.text);
        dfltMaxEU := strtofloat(edit5.text);
        dfltAlarmedLocal := checkBox1.Checked;
        dfltAlCase := comboBox1.items[comboBox1.Itemindex];
        case radioGroup1.Itemindex of
          0: dfltAlLevel := 400;
          1: dfltAlLevel := 600;
        end;//case
        dfltAlConst := strtofloat(edit1.text);
      except
        MessageDlg ('Ввод неверен', mterror, [mbOk], 0);
        inputOk := false;
      end;
    until inputOk = true;
    free;
  end;
end;
procedure TDicEditForm.N4Click(Sender: TObject);
var
  tempGroups: TGroups;
begin
  with TFrmEditCSV.Create(self) do
  try
  begin
   fillGridFromCSV(StringGrid1, PathMem + 'groups.cfg');
   if showModal = mrOK then
   try
     SaveGridToCSV(StringGrid1, PathMem + 'groups.cfg');
     TempGroups := TGroups.Create(PathMem + 'groups.cfg');
     Groups.Free;
     Groups := TempGroups;
   except
     Groups.SaveToFile(PathMem + 'groups.cfg');
     raise Exception.Create('Ошибка. Изменения групп не сохранены.');
   end;
  end;
  finally
    free;
  end;
end;

procedure TDicEditForm.N3Click(Sender: TObject);
var
  Group: PTGroup;
begin
  new(Group);//память будет уничтжаться при унитожении списка
  with TFrmGrpNew.Create(self) do
  try
    if showModal = mrOk then
    begin
      if Groups.itemNum[Edit1.Text] <> -1 then
       raise Exception.Create('Группа уже существует.');
      group.Num := -1; //Когда будем добавлять в список, будет заменен на первый свободный номер группы
      group.Name := Edit1.Text;
      group.App := Edit2.Text;
      group.Topic := Edit3.Text;
      group.SlaveNum := spinEdit1.Value;
      groups.Add(Group);
      groups.SaveToFile(PathMem + 'groups.cfg');
    end;
  finally
    free;
  end;
end;

procedure TDicEditForm.N5Click(Sender: TObject);
var
  nm: string;

begin
  with TFrmGrpDbl.Create(self) do
  begin
      enableAlarmDefinition := false;
      Groups.FillStrings(cbGRP1.Items);
      Groups.FillStrings(cbGRP2.Items);
      cbGRP1.ItemIndex := 0;
      cbGRP2.ItemIndex := 1;
      if showModal = mrOk then
      begin
          if Ed1.Text = '' then
            raise Exception.Create('Префикс не может быть пуст');

          if cbGRP1.Text = cbGRP2.Text then
            raise Exception.Create('Группы должны быть различные');

          ShowItemFirst(self);
          repeat
            if self.comboBox2.Text = cbGRP1.Text then
            begin
              nm := edit1.Text;
              ShowItemNew(Self);
              if pos('$', edit1.text) <> 1 then
                self.Edit1.Text := Ed1.Text + nm
              else
                self.Edit1.Text := '$' + Ed1.Text + copy(nm, 2, Length(nm) - 1);
              self.comboBox2.ItemIndex := cbGRP2.ItemIndex;
              ToolButton7Click(self); //сохранить новую запись
              showItem(rtItems.GetSimpleID(nm));
              ShowItemNext(self);
            end;
          until curItem = rtItems.Count;
      end;
  end;
end;

procedure TDicEditForm.Button1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to rtItems.count - 1 do
  begin
    rtItems[i].EUPos := -1;
    rtItems[i].DeadBaund := 0;
    rtItems.writeToFile(i);
    if rtItems[i].NamePos = 0 then ShowMessage('Namepos = 0');
  end;
end;


function TDicEditForm.FindNextLess(var CurIt: integer): boolean;
var
  i, less: integer;
  CurName: string;
begin
  less := -1;
  result := false;
  curName := UpperCase(rtItems.GetName(CurIt));
  for i := 0 to rtItems.Count - 1 do
    if rtItems[i].ID <> -1 then
      if (less = -1) and (UpperCase(rtItems.GetName(i)) < curName) then less := i
      else if (less <> -1) and (UpperCase(rtItems.GetName(i)) < curName) and
           (UpperCase(rtItems.GetName(less)) < UpperCase(rtItems.GetName(i))) then less := i;
  if less <> -1 then
  begin
    curIt := less;
    result := true;
  end;
end;

function TDicEditForm.FindNextMore(var curIt: integer): boolean;
var
  i, more: integer;
  CurName: string;
begin
  more := -1;
  result := false;
  curName := UpperCase(rtItems.GetName(CurIt));
  for i := 0 to rtItems.Count - 1 do
    if rtItems[i].ID <> -1 then
      if (more = -1) and (UpperCase(rtItems.GetName(i)) > curName) then more := i
      else if (more <> -1) and (UpperCase(rtItems.GetName(i)) > curName) and
           (UpperCase(rtItems.GetName(more)) > UpperCase(rtItems.GetName(i))) then more := i;
  if more <> -1 then
  begin
    curIt := more;
    result := true;
  end;
end;

function TDicEditForm.FindBiggest: integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to rtItems.Count - 1 do
    if rtItems[i].ID <> -1 then
      if UpperCase(rtItems.GetName(i)) > UpperCase(rtItems.GetName(result)) then result := i;
end;

function TDicEditForm.FindLesses: integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to rtItems.Count - 1 do
    if rtItems[i].ID <> -1 then
      if UpperCase(rtItems.GetName(i)) < UpperCase(rtItems.GetName(result)) then result := i;
end;

procedure TDicEditForm.FloatEdit8Change(Sender: TObject);
begin
   isChanged := true;
end;

end.
