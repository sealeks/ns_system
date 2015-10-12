program NS_RunTime;

{%ToDo 'NS_RunTime.todo'}



uses
  Forms,
  GlobalValue,
  SysUtils,
  FormConnect,
  Windows,
  classes,
  DM1U in 'DM1U.pas' {Dm1: TDataModule},
  fLoadU in 'fLoadU.pas' {fLoad},
  ConstDef in '..\Units\ConstDef.pas',
  MemStructsU in '..\Units\MemStructsU.pas',
  IMMIFormU in '..\Units\IMMIFormU.pas' {IMMIForm},
  uMyTime in '..\Units\uMyTime.pas',
  SelectAppFormU in '..\Units\SelectAppFormU.pas' {SelectAppForm},
  fToolBoxU in 'fToolBoxU.pas' {fToolBox},
  fTopMenuU in 'fTopMenuU.pas' {fTopMenu},
  TimeSincronize in '..\Units\TimeSincronize.pas',
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  operatorconfig in 'operatorconfig.pas' {FormOperatorConf},
  OperatorRegU in 'OperatorRegU.pas' {OperatorReg},
  FormReRegistU in 'FormReRegistU.pas' {FormReRegist};

{$R *.RES}

var
  cif: ^_STARTUPINFOA;
   pip: PROCESS_INFORMATION;
   j: integer;
   keyHooK: procedure (switch : Boolean; hMainProg: HWND) stdcall;
   Hdll : HWND;
begin

   AppScript:=nil;
   new(cif);

  InitialSys;
  fLoad := TfLoad.Create(Application);
  try
  if fileexists(FirstPicturePath) then
  FirstPicture.LoadFromFile(FirstPicturePath);
  except
  end;
  fload.Image2.Picture.Assign(FirstPicture);
   Sincronize;
  fLoad.Show;
  fLoad.Update;
  Application.Initialize;
  FLoad.ProcessLog('Создется главное меню');
  Application.CreateForm(TfTopMenu, fTopMenu);
  Application.CreateForm(TFormOperatorConf, FormOperatorConf);
  Application.CreateForm(TOperatorReg, OperatorReg);
  Application.CreateForm(TFormReRegist, FormReRegist);
  ftopMenu.Tag:=100;
  ftopmenu.Timer1.Interval:=1000*deltareserver;
  Application.CreateForm(TfToolBox, fToolBox);
  Application.CreateForm(TIMMIForm, IMMIForm);
  FLoad.ProcessLog('Создается блок данных');
  Application.CreateForm(TDm1, Dm1);
  FLoad.ProcessLog('Создается журнал активных тревог');
  fTopMenu.Show;



  FLoad.ProcessLog('Определение политики безопасности');
  FLoad.ProcessLog('Визуализация форм и запуск');
  FormConnect.OpenProject('');
  FLoad.ProcessLog('Регистрация в базе данных');
  FLoad.ProcessLog('Приложение запущено');
  postMessage (Application.Handle, WM_IMMIFirstUpd, -1, -1);
  fLoad.hide;
  setaccessL(StartAcses);
  OperatorName^ := 'Незарегистрирован';
    fTopMenu.N4.Visible:=rtitems.oper.getRegist;
  //StartExeApp;
  if (AppScript<>nil) and (usescript) then
   AppScript.StartExe;
   @keyHook:=nil;
  Hdll:=LoadLibrary(PChar('keyhook.dll'));
  if Hdll > HINSTANCE_ERROR then
  begin            { если всё без ошибок, то }
     @keyHook:=GetProcAddress(Hdll, 'hook');     { получаем указатель на необходимую процедуру}
  if @keyHook<>nil then                                 { если всё без ошибок, то }
  keyhook(true, Application.handle);
  end;
  Application.Run;
  if hdll> HINSTANCE_ERROR then
  begin
  try
  keyhook(false, Application.handle);
  FreeLibrary(hdll);
  except
  end
  end;
  if Application.Terminated then
    begin
       dm1.BlinkTimer.Enabled:=false;
       dm1.Timer1.Enabled:=false;
        dm1.Timer2.Enabled:=false;
       if AppScriptPrep<>nil then
       begin
       AppScript.stopexe;
       AppScriptPrep.free;;
       end;
       if dm1.appForm<>nil then
       begin
           SendMessage(dm1.appForm.handle, WM_IMMIUnInit, 0, 0);
           dm1.appForm.Free;
       end;    
    end;
end.
