unit fTopMenuU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus,  constDef, IMMIformx, ExtCtrls,
  immiImg1, IMMILabelFullU, IMMIShape,ActiveX,operatorconfig, OperatorRegU,
  IMMIAlarmTriangle, IMMIArmatVl, IMMIArmatBm, IMMIRegul, IMMITube,
  IMMIGoU, IMMIEditReal, IMMITrackBar, IMMISpeedButton, GlobalValue,
  IMMIBitBtn, IMMIValueEntryU, ConfigurationSys,  LoginError,
  StdCtrls;

type
  TfTopMenu = class(TForm)
    MainMenu1: TMainMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N9: TMenuItem;
    N11: TMenuItem;
    Timer1: TTimer;
    Timer2: TTimer;
    TimeN: TMenuItem;
    procedure N1Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure nToolBoxClick(Sender: TObject);
    procedure N19Click(Sender: TObject);
   // procedure OpenHome(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure onClickM(sender: Tobject);
    function CreateSavedForm(FormName: String): TComponent;
    procedure GetOpenIMMIFormsList(list: TStrings);
    procedure GetAllIMMIFormsList(list: TStrings);
    procedure GetSavedNotLoadedIMMIFormsList(list: TStrings);//все созраненные и не загруженные формы
    function GetFormExt(frm: TForm): TIMMIFormExt;
  //  procedure RemSizers(frm: TForm);
  end;

var
  fTopMenu: TfTopMenu;
  lastForm: Tform;
  countDRes: integer;
  hj: boolean;
implementation

uses  DM1U, IMMIFormU, MemStructsU,
  SelectAppFormU, fToolBoxU, TimersFormU, FormReRegistU;

{$R *.DFM}


procedure TfTopMenu.N1Click(Sender: TObject);
  var
  hW: HWND;
  exeN: string;
begin
  hW := findWindow(NIL, 'Журнал IMMI');
  {exeN:= application.ExeName;
   if length(exen)>0 then
   while (exeN[length(exen)]<>'\') and (length(exen)>0) do exeN:=copy(exeN,1,length(exen)-1);
   exeN:= exen+'NS_Journal.exe non';}
  if hw = 0 then WinExec(PansiChar('NS_Journal.exe non'), SW_SHOWNORMAL)
  else
  begin
     ShowWindow (hW, SW_SHOWMINIMIZED);
     ShowWindow (hW, SW_SHOWNORMAL);
  end;
//    fTrend.Show;
end;


procedure TfTopMenu.onClickM(sender: Tobject);
  begin
    if sender is TmenuItem then
      begin
        if (sender as TmenuItem).owner is Tform then
          if  ((sender as TmenuItem).owner as Tform).Showing then
             ((sender as TmenuItem).owner as Tform).hide else
             ((sender as TmenuItem).owner as Tform).Show;
      end;
end;

procedure TfTopMenu.N9Click(Sender: TObject);
var
   i: integer;
begin
  if  ((AccessLevel<>nil) and (AccessLevel^ < 2000)) then
     begin
      if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для завершения работы программы!');
        if rtitems.GetSimpleID('accessnostop')>-1 then
        begin
        rtitems.SetVal(rtitems.GetSimpleID('accessnostop') , 1,0);
        rtitems.SetVal(rtitems.GetSimpleID('accessnostop') , 0,0);
        end;

     end
  else 
  begin
      postMessage (Application.Handle, WM_IMMIFirstUpd, -1, -1);
   //  if FindWindow('TForm1','Сервер данных Logika')>0 then SendMessage(FindWindow('TForm1','Сервер данных Logika'),WM_ALLETHERSERVERDESTROY,0,0);
    //  if FindWindow('TForm1','Сервер данных')>0 then SendMessage(FindWindow('TForm1','Сервер данных'),WM_ALLETHERSERVERDESTROY,0,0);
     for i := 0 to Screen.FormCount - 1 do
         if (Screen.Forms[i] is TIMMIForm) then
            if (Screen.Forms[i] as TIMMIForm).visible then
               (Screen.Forms[i] as TIMMIForm).Hide;
     if rtitems.GetSimpleID('rOperator')>-1 then
              begin
               try
                rtitems.AddCommand(rtItems[rtitems.GetID('rOperator')].ID,-1,true);
               except
             end;
           end;
     application.terminate;
    
  end;
 // CoUnInitialize;
end;

procedure TfTopMenu.N2Click(Sender: TObject);
var
  hW: HWND;
  ExeN: string;
begin
  hW := findWindow(NIL, 'NS_Trend');
  {exeN:= application.ExeName;
   if length(exen)>0 then
   while (exeN[length(exen)]<>'\') and (length(exen)>0) do exeN:=copy(exeN,1,length(exen)-1);
   exeN:= exen+'NS_Trend.exe';
  ExeN:= application.GetNamePath+'NS_Trend.exe non';}
  if hw = 0 then WinExec(PansiChar('NS_Trend.exe non'), SW_SHOWNORMAL)
  else
  begin
     ShowWindow (hW, SW_SHOWMINIMIZED);
     ShowWindow (hW, SW_SHOWNORMAL);
  end;
//    fTrend.Show;
end;

procedure TfTopMenu.N5Click(Sender: TObject);
begin
  OperatorReg.showW;
end;

procedure TfTopMenu.N6Click(Sender: TObject);
begin
    rtitems.oper.RegistUser(-1,'')
end;

procedure TfTopMenu.N7Click(Sender: TObject);
begin
   if  rtitems.oper.usCur>-1 then
    try
      FormReRegist.showW;
    except
    end;

end;

procedure TfTopMenu.N8Click(Sender: TObject);
begin
  //   RegistrationConnect;
     If AccessLevel^ > 8000 then
       { configureUsersEx }
       begin
         FormOperatorConf.showW;
       end
     else begin
      if LoginErrorForm=nil then LoginErrorForm:=TLoginError.Create(Application.MainForm);
            LoginErrorForm.Execute('Недостаточный уровень доступа для конфигурирования!');
     end
end;

procedure TfTopMenu.FormCreate(Sender: TObject);
begin
  left := 0;
  top := 0;
  height := 20;
  width := 1280;
  if not fileexists('NS_Report.exe') then N3.Visible:=false;
  if not fileexists('NS_Trend.exe') then N2.Visible:=false;
  if not fileexists('NS_Journal.exe') then N1.Visible:=false;

end;
procedure TfTopMenu.N11Click(Sender: TObject);
var
  i: integer;
begin
//Файл/сохранить
  with TSelectAppForm.Create(Self) do
  try
    caption := 'Сохранить форму';
    GetOpenIMMIFormsList(listBox1.Items);
    if ShowModal = mrOK then
      for i := 0 to listBox1.Count - 1 do
        if listBox1.Selected[i] then
        begin
          //RemSizers(listBox1.Items.Objects[i] as TForm);
          //(GetFormExt(listBox1.Items.Objects[i] as TForm)).SaveOwnerForm ;
        end;
  finally
    free;
  end;
end;

function TfTopMenu.CreateSavedForm(FormName: String): TComponent;
var
  StrStream:TFileStream;
  BinStream: TMemoryStream;
begin
  with TForm.Create(owner) do
  begin
  StrStream := TFileStream.Create(dirForms + FormName + '.frm', fmOpenRead);
  StrStream.ReadComponent(owner.Components[componentIndex]);
  StrStream.Free;
  end;

end;

procedure TfTopMenu.N13Click(Sender: TObject);
var
  i: integer;
begin
//Файл/открыть
  with TSelectAppForm.Create(Self) do
  try
    caption := 'Открыть форму';
    GetAllIMMIFormsList(listBox1.items);
    if ShowModal = mrOK then
      for i := 0 to listBox1.Count - 1 do
        if listBox1.selected[i] then
        begin
           if listBox1.Items.Objects[i] is TForm then
             (listBox1.Items.Objects[i] as TForm).Show//показать форму, если она уже загружена
           else
             CreateSavedForm(listBox1.Items[i]);
        end
        else begin  //скрыть форму, если она загружена и не выбрана
          if listBox1.Items.Objects[i] is TForm then ;
             //(listBox1.Items.Objects[i] as TForm).free;
        end;
  finally
    free;
  end;
end;

procedure TfTopMenu.N15Click(Sender: TObject);
var
  i: integer;
begin
//Файл/закрыть
  with TSelectAppForm.Create(Self) do
  try
    caption := 'Закрыть форму';
    GetOpenIMMIFormsList(listBox1.items);
    if ShowModal = mrOK then
      for i := 0 to listBox1.Count - 1 do
        if listBox1.Selected[i] then
        begin
          if GetFormExt(listBox1.Items.Objects[i] as TForm).isModified then
            if MessageDlg('Закрыть несохраненную форму?',
                        mtConfirmation	, [mbYes, mbNo], 0) = mrNo then exit;
          listBox1.Items.Objects[i].free;
        end;
  finally
    free;
  end;
end;

procedure TfTopMenu.GetAllIMMIFormsList(list: TStrings);
begin
  GetOpenImmiFormsList(list);
  GetSavedNotLoadedIMMIFormsList(List);
end;

procedure TfTopMenu.GetOpenIMMIFormsList(list: TStrings);
var
  i, j: integer;
begin
    for i := 0 to screen.FormCount -1 do
      for j := 0 to screen.Forms[i].ComponentCount - 1 do
        if screen.Forms[i].Components[j] is TIMMIFormExt then
        begin
          list.Objects[list.Add(screen.Forms[i].Caption)] := screen.Forms[i];
          break;
        end;
end;

procedure TfTopMenu.GetSavedNotLoadedIMMIFormsList(list: TStrings);
var
  str: string;
  i, j: integer;
  sr: TSearchRec;
  formLoaded: boolean;
begin

    //Поиск сохраненных форм на диске,
    //если уже закружена, не добавлять
    if FindFirst(dirForms + '*.frm', faAnyFile, sr) = 0 then
    begin
      repeat
        formLoaded := false;
        str := copy(sr.Name, 1, length(sr.Name) - 4 );
        for i := 0 to screen.FormCount -1 do
        if str = screen.Forms[i].Caption then //форма уже загружена
          //list.Objects[j] := screen.Forms[i];
          formLoaded:= true;
        if not FormLoaded then j := list.Add(str);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
end;

function TfTopMenu.GetFormExt(frm: TForm): TIMMIFormExt;
var
  i: integer;
begin
//Возвращает расширитель формы
  result := nil;
  for i := 0 to frm.ComponentCount - 1 do
    if frm.Components[i] is TImmiFormExt then
    begin
      result := frm.Components[i] as TImmiFormExt;
      break
    end;
end;

procedure TfTopMenu.N16Click(Sender: TObject);
begin
//Создать панель
    with TPanel.Create(lastForm) do
    begin
      parent := lastForm;
      dragmode := dmAutomatic;
      dragKind := dkDock;
    end;

end;

procedure TfTopMenu.nToolBoxClick(Sender: TObject);
begin
  if (Sender as TMenuItem).Checked then FToolBox.Show
    else fToolBox.Hide;
end;

procedure TfTopMenu.N19Click(Sender: TObject);
var
  i: integer;
  f: textfile;
  str: string;
begin
//Файл/открыть
  with TSelectAppForm.Create(Self) do
  try
    caption := 'Начальные окна';
    GetAllIMMIFormsList(listBox1.items);
    if fileExists('firstForms.cfg') then
    try
      system.assign(f, 'firstForms.cfg');
      reset(f);
      repeat
        readln(f, str);
        for i := 0 to listbox1.Count - 1 do
        if listBox1.Items[i] = str then
          listBox1.selected[i] := true;
      until EOF(f);
    finally
      system.close(f);
    end;
    if ShowModal = mrOK then
      try //записать все настройки в файл
        system.assign(f, 'firstForms.cfg');
        rewrite(f);
          for i := 0 to listBox1.Count - 1 do
            if listBox1.selected[i] then
              writeln(f, listbox1.Items[i]);
      finally
        system.close(f);
      end;
  finally
    free;
  end;
end;

{procedure TfTopMenu.RemSizers(frm: TForm);
var
  i: integer;
  flag: boolean;
begin
//Убираем все компоненты управления размером
  repeat
  for i := 0 to frm.ComponentCount - 1 do
  begin
    flag := false;
    if frm.Components[i] is TDdhSizerControl then
    begin
      frm.Components[i].free;
      flag := true;
      break
    end;
  end;
  until not flag;
end;           }

{procedure TfTopMenu.OpenHome(Sender: TObject);
var
  i: integer;
  f: textfile;
  str: string;
begin
//Файл/открыть/Начальные окна
  with TSelectAppForm.Create(Self) do
  try
    caption := 'Начальные окна';
    GetAllIMMIFormsList(listBox1.items);
    if fileExists('firstForms.cfg') then
    try
      system.assign(f, 'firstForms.cfg');
      reset(f);
      repeat
        readln(f, str);
        for i := 0 to listbox1.Count - 1 do
        if listBox1.Items[i] = str then
          listBox1.selected[i] := true;
      until EOF(f);
    finally
      system.close(f);
    end;

      for i := 0 to listBox1.Count - 1 do
        if listBox1.selected[i] then
        begin
           if listBox1.Items.Objects[i] is TForm then
             (listBox1.Items.Objects[i] as TForm).Show//показать форму, если она уже загружена
           else
             CreateSavedForm(listBox1.Items[i]);
        end
        else begin  //скрыть форму, если она загружена и не выбрана
          if listBox1.Items.Objects[i] is TForm then
            (listBox1.Items.Objects[i] as TForm).free;
        end;
  finally
    free;
  end;
end;          }


procedure TfTopMenu.N12Click(Sender: TObject);
begin
timersForm.ShowModal;
end;

procedure TfTopMenu.N14Click(Sender: TObject);
begin
 // if  fDeblok.Visible = false then fDeblok.Visible:= true
//  else  fDeblok.Hide;
end;

procedure TfTopMenu.N3Click(Sender: TObject);
var
  hW: HWND;
  ExeN: string;
begin
  hW := findWindow(NIL, 'NS_Report');
  {exeN:= application.ExeName;
   if length(exen)>0 then
   while (exeN[length(exen)]<>'\') and (length(exen)>0) do exeN:=copy(exeN,1,length(exen)-1);
   exeN:= exen+'NS_Report.exe';       }
  //ExeN:=application.GetNamePath+'NS_Report.exe';
  if hw = 0 then WinExec(PansiChar('NS_Report.exe'), SW_SHOWNORMAL)
  else
  begin
     ShowWindow (hW, SW_SHOWMINIMIZED);
     ShowWindow (hW, SW_SHOWNORMAL);
  end;
end;

procedure TfTopMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 n9click(nil);
 abort;
end;

procedure TfTopMenu.Timer1Timer(Sender: TObject);
var cif: ^_STARTUPINFOA;
   pip: PROCESS_INFORMATION;

begin
end;        

procedure TfTopMenu.N4Click(Sender: TObject);
begin
n6.Visible:=(rtitems.oper.usCur>-1);
n7.Visible:=(rtitems.oper.usCur>-1);
n8.Visible:=AccessLevel^>8000;
end;

procedure TfTopMenu.Timer2Timer(Sender: TObject);
begin

self.TimeN.Caption:='  '+DateTimetostr(now)+'  ';

if OperatorName<>nil then
     begin
       if string(OperatorName^)<>'Незарегистрирован' then
       self.TimeN.Caption:=' '+ string(OperatorName^) +'  '+self.TimeN.Caption;
     end
 
end;

initialization
     countDRes:=0;
     RegisterAccessDLL;
 { RegisterClasses([TForm, TIMMIFormExt, TPanel,
                        TIMMIImg1, TIMMILabelFull, TIMMIShape,
                        TIMMIAlarmTriangle, TIMMIArmatVl, TIMMIArmatBm,
                        TIMMIRegul, TIMMITube,
                        TIMMIGo, TIMMIEditReal, TIMMITrackBar, TIMMISpeedButton,
                        TIMMIBitBtn, TIMMIValueEntry, TForm]);        }

finalization
UnRegisterAccessDLL;

end.
