unit ServerLogikaU;

interface




uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LogikaClasses, Comms, DB, DBTables, Grids, DBGrids, Math,
  uMyTimer, LogikaThreadU, MemStructsU, ExtCtrls, ShellApi, MyComms,
  Spin, convFunc, GroupsU, ConstDef, Menus, ComCtrls, ToolWin, globalValue,
  ImgList, ColorStringGrid, StrUtils, LogikaComPortU, InterfaceServerU;

const
  WM_ICONNOTYFY = WM_USER + 1324;

type
  TstatusServer = (ssStart, ssStop, ssNone);


type

  TFormLogikaServer = class(TForm)
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    it1: TMenuItem;
    it2: TMenuItem;
    N3: TMenuItem;
    ImageList1: TImageList;
    PanelSlave: TPanel;
    PanelCom: TPanel;
    ComGrid: TColorStringGrid;
    SlaveGrid: TColorStringGrid;

    Timer1: TTimer;
    Image1: TImage;
    Image2: TImage;
    Timer2: TTimer;
    Timer4: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure it1Click(Sender: TObject);
    procedure it2Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure setTheardAnalize(val: boolean);
    procedure TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure Timer4Timer(Sender: TObject);
  private
    fStatus: TstatusServer;
    fAnalizeObject: TObject;
    fReadShapes: TList;
    fWriteShapes: TList;
    fPrevRefMsg: integer;
    FNID: TNotifyIconData;
    threadCOMList: TStringList;
    finittab: boolean;
    fcursor: integer;
    RS: TTreeNode;
    trayok: boolean;
    destructor Destroy; override;
    procedure setStatus(val: TstatusServer);
    procedure AnalizeCom(Sender: TObject; val: integer; val1: integer);
    procedure AnalizeSlave(Sender: TObject; val: integer; val1: integer);


    procedure SetAnalize(Sender: TObject);
    procedure OffAnalize;

  public
    { Public declarations }
    procedure Start;
    procedure Stop;
    procedure seticonSt;
    procedure WMIconNotyfy(var messag: TMsg); message WM_ICONNOTYFY;
    procedure WMClose(var messag: TMsg); message WM_Close;
    procedure WMEterClose(var messag: TMsg); message WM_ALLETHERSERVERDESTROY;
    property Status: TstatusServer read fStatus write setStatus;

  end;

var
  FormLogikaServer: TFormLogikaServer;

implementation

{$R *.DFM}

// com1[br9600,7bd,1sb,pt1,trd50,red50,ri300,rtm3000,rtc3000,wtm3000,wtc3000]

function getparity(val: integer): string;
begin
  Result := 'none';
  if val = 1 then
    Result := 'odd';
  if val = 2 then
    Result := 'even';
  if val = 3 then
    Result := 'mark';
  if val = 4 then
    Result := 'space';
end;




function getdatabit(val: integer): string;
begin
  Result := '8';
  if val = 5 then
    Result := '5';
  if val = 6 then
    Result := '6';
  if val = 7 then
    Result := '7';
end;

function getstopbit(val: integer): string;
begin
  Result := '1';
  if val = 2 then
    Result := '2';
  if val = 3 then
    Result := '1.5';

end;


procedure TFormLogikaServer.FormCreate(Sender: TObject);
var
  i: integer;
  serv, group, configinfo, host, group1, app, topic: string;
begin
  IsMultiThread := True;
  fStatus := ssStart;
  threadCOMList := TStringList.Create;
  FNID.Wnd := handle;
  FNID.uCallbackMessage := WM_ICONNOTYFY;
  FNID.hIcon := Icon.Handle;
  FNID.szTip := 'Logika Server';
  FNID.uFlags := nif_Message or nif_Icon or nif_Tip;
  for i := 0 to TreeView1.Items.Count - 1 do
    if trim(uppercase(TreeView1.Items[i].Text)) = 'RS' then
      RS := TreeView1.Items[i];
  Start;

end;



procedure TFormLogikaServer.Start;
var
  i, j, slave, k, comN, Bound, temComNum, TempEthNum, idxThr, jj: integer;
  serv, group, configinfo, host, group1, app, topic: string;
  ComSet: TComSEt;
  ServerThread: TLogikaServerThread;
  ChildComtrn, ChildSlavetrn: TtReeNode;
  tempStrList: TStringList;

begin
  try
    tempStrList := TStringList.Create;
    rtItems := TanalogMems.Create(PathMem);

    for i := 0 to rtitems.TegGroups.Count - 1 do
    begin
      serv := rtItems.TegGroups.Items[i].App;
      group := rtItems.TegGroups.Items[i].Name;
      topic := rtItems.TegGroups.Items[i].Topic;
      slave := rtItems.TegGroups.Items[i].SlaveNum;
      if trim(uppercase(serv)) = trim(uppercase('LOGIKASERV')) then
      begin
        temComNum := isCOM(topic, 'COM', ComSet);
        if not tempStrList.Find(IntToStr(temComNum), jj) and (temComNum > 0) then
        begin
          tempStrList.Add(IntToStr(temComNum));
          ServerThread := TLogikaServerThread.Create(PathMem, temComNum, ComSet);
          threadCOMList.AddObject('COM' + IntToStr(temComNum), ServerThread);
          ChildComtrn := TreeView1.Items.AddChildObject(
            RS, 'COM' + IntToStr(temComNum), ServerThread.server);
          ChildComtrn.ImageIndex := 2;

          for j := 0 to ServerThread.server.Count - 1 do
          begin
            ChildSlavetrn := TreeView1.Items.AddChildObject(
              ChildComtrn, ServerThread.server.items[j].NameDev,
              ServerThread.server.items[j]);
            ChildSlavetrn.ImageIndex := 3;
          end;
        end;
      end;
    end;
    for i := 0 to threadCOMList.Count - 1 do
      TLogikaServerThread(threadCOMList.Objects[i]).Resume;
    rtItems.Regs.RegHandle('LogikaServ', Handle, [IMMINewRef, IMMIRemRef]);
    Status := ssStart;
  finally
    tempStrList.Free;
  end;
end;



procedure TFormLogikaServer.Stop;
var
  i, j, slave, k, comN, Bound, temComNum, TempEthNum, idxThr: integer;
  serv, group, configinfo, host, group1, app, topic: string;
  ComSet: TComSEt;
  ServerThread: TLogikaServerThread;
  trn, trn1, trnopcbush, trnddebush: TtReeNode;
  term: boolean;
begin

  try
    Hide;
    OffAnalize;
    rtItems.Regs.UnRegHandle(Handle);
    for i := 0 to threadCOMList.Count - 1 do
    begin
      TLogikaServerThread(threadCOMList.Objects[i]).Terminate;
      TLogikaServerThread(threadCOMList.Objects[i]).WaitFor;
    end;

    for i := 0 to threadCOMList.Count - 1 do
      TLogikaServerThread(threadCOMList.Objects[i]).Free;

    threadCOMList.Clear;
    trn := nil;
    i := 0;
    while i < TreeView1.Items.Count do
    begin
      if self.TreeView1.Items[i].Text = 'RS' then
      begin
        trn := self.TreeView1.Items[i];
        while trn.Count > 0 do
          trn.Item[0].Free;
      end;
      Inc(i);
    end;
    rtItems.Free;

  finally
    Status := ssStop;
  end;
end;


procedure TFormLogikaServer.MenuItem1Click(Sender: TObject);
begin
  Show;
  setTheardAnalize(True);
  BringWindowToTop(handle);
end;


procedure TFormLogikaServer.WMClose(var messag: TMsg);
begin
  messag.message := 0;
  OffAnalize;
  Hide;
end;


procedure TFormLogikaServer.WMIconNotyfy(var messag: TMsg);
var
  pt: TPoint;
begin
  if Status = ssNone then
    exit;
  if messag.wParam = WM_RBUTTONDOWN then
  begin
    popupmenu1.Items[0].Visible := (Status <> ssStop);
    getCursorPos(pt);
    popupmenu1.Popup(pt.X, pt.y);
  end;

end;

destructor TFormLogikaServer.Destroy;
begin
  FNID.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @FNID);
  inherited;
end;


procedure TFormLogikaServer.WMEterClose(var messag: TMsg);
begin
  messag.message := 0;
  Hide;
end;

procedure TFormLogikaServer.N3Click(Sender: TObject);
begin
  Hide;
  OffAnalize;
  Shell_NotifyIcon(NIM_DELETE, @FNID);
  stop;
  Close;
end;



procedure TFormLogikaServer.AnalizeCom(Sender: TObject; val: integer; val1: integer);

  function gttip(vl: TNetType): string;
  begin
    case vl of
      ntAPS: Result := 'proxy';
      else
        Result := 'direct';
    end;
  end;

var
  tst: TDeviceItems;
  i, j: integer;
begin
  if (Sender is TDeviceItems) then
  begin
    tst := (Sender as TDeviceItems);
    ComGrid.Cells[0, 0] := 'id';
    ComGrid.Cells[1, 0] := 'name';
    ComGrid.Cells[2, 0] := 'slave';
    ComGrid.Cells[3, 0] := 'proxy';
    ComGrid.Cells[4, 0] := 'max';
    ComGrid.Cells[5, 0] := 'br';
    ComGrid.Cells[6, 0] := 'typ';
    ComGrid.Cells[7, 0] := 'cursor';
    ComGrid.Cells[8, 0] := 'cr';
    ComGrid.Cells[9, 0] := 'error';


    ComGrid.RowCount := tst.Count + 1;
    for j := 0 to tst.Count - 1 do
    begin

      case tst.items[j].error of
        ANSWER_OK: ComGrid.fRows.Items[j + 1].font.Color := clGreen;
        ERROR_CRC: ComGrid.fRows.Items[j + 1].font.Color := $000080FF;
        else
          ComGrid.fRows.Items[j + 1].font.Color := clRed;
      end;
      ComGrid.Cells[0, j + 1] := IntToStr(j);
      ComGrid.Cells[1, j + 1] := tst.items[j].NameDev;
      ComGrid.Cells[2, j + 1] := IntToStr(tst.items[j].slavenum);
      ComGrid.Cells[3, j + 1] := IntToStr(tst.items[j].Proxy);
      ComGrid.Cells[4, j + 1] := IntToStr(tst.MaxUSD);
      ComGrid.Cells[5, j + 1] := IntToStr(tst.items[j].ComSet.br);
      ComGrid.Cells[6, j + 1] := gttip(tst.typeReq);
      ComGrid.Cells[7, j + 1] := IntToStr(tst.items[j].Cursor);
      ComGrid.Cells[8, j + 1] := tst.items[j].Curread;
      ComGrid.Cells[9, j + 1] := ComLerrorStr(tst.items[j].error);

      if tst.items[j].inReqest then
        ComGrid.Rows[j + 1].font.style := [fsBold]
      else
        ComGrid.Rows[j + 1].font.style := [];
      ComGrid.Refresh;
    end;
  end;
end;

procedure TFormLogikaServer.AnalizeSlave(Sender: TObject; val: integer; val1: integer);

  function uitipetostr(uit_: TItemReqType): string;
  begin
    case uit_ of
      rtCurrent: Result := 'curr';
      rtArray: Result := 'arre';
      rtArchive: Result := 'repo';
    end;
  end;

  function _uitipetostr(uit_: TUnitItemType): string;
  begin
    case uit_ of
      uiReal: Result := 'real';
      uiInteger: Result := 'intr';
      uiTime: Result := 'time';
    end;
  end;

var
  DI: TDeviceItem;
  j: integer;
begin
  if (Sender is TDeviceItem) then
  begin
    DI := Sender as TDeviceItem;
    begin
      SlaveGrid.Cells[0, 0] := 'ID';
      SlaveGrid.Cells[1, 0] := 'name';
      SlaveGrid.Cells[2, 0] := 'k';
      SlaveGrid.Cells[3, 0] := 'num';
      SlaveGrid.Cells[4, 0] := 'ind';
      SlaveGrid.Cells[5, 0] := 'reqType';
      SlaveGrid.Cells[6, 0] := 'cast';
      SlaveGrid.Cells[7, 0] := 'err';
      SlaveGrid.Cells[8, 0] := 'dVal';
      SlaveGrid.Cells[9, 0] := 'Val';
      SlaveGrid.Cells[10, 0] := 'minR';
      SlaveGrid.Cells[11, 0] := 'maxR';
      SlaveGrid.Cells[12, 0] := 'minEU';
      SlaveGrid.Cells[13, 0] := 'maxEU';
      SlaveGrid.Cells[14, 0] := 'rc';
      SlaveGrid.Cells[15, 0] := 'buff';
      SlaveGrid.Cells[16, 0] := 'VL';
    end;

    SlaveGrid.RowCount := DI.unitList.Count + 1;

    for j := 0 to DI.unitList.Count - 1 do
    begin
      SlaveGrid.Cells[0, j + 1] := IntToStr(j);
      SlaveGrid.Cells[1, j + 1] := DI.unitList.items[j].Name;
      SlaveGrid.Cells[2, j + 1] := IntToStr(DI.unitList.items[j].chanalNum);
      SlaveGrid.Cells[3, j + 1] := IntToStr(DI.unitList.items[j].paramNum);
      SlaveGrid.Cells[4, j + 1] := IntToStr(DI.unitList.items[j].index);
      SlaveGrid.Cells[5, j + 1] := uitipetostr(DI.unitList.items[j].reqType);
      SlaveGrid.Cells[6, j + 1] := _uitipetostr(DI.unitList.items[j].uiType);
      SlaveGrid.Cells[7, j + 1] := IntToStr(DI.unitList.items[j].error);
      SlaveGrid.Cells[8, j + 1] := DI.unitList.items[j].device_val;
      SlaveGrid.Cells[9, j + 1] := floattostr(DI.unitList.Val[j]);
      SlaveGrid.Cells[10, j + 1] := floattostr(DI.unitList.items[j].minRaw);
      SlaveGrid.Cells[11, j + 1] := floattostr(DI.unitList.items[j].maxRaw);
      SlaveGrid.Cells[12, j + 1] := floattostr(DI.unitList.items[j].minEU);
      SlaveGrid.Cells[13, j + 1] := floattostr(DI.unitList.items[j].maxEU);
      SlaveGrid.Cells[14, j + 1] := IntToStr(DI.unitList.refCount[j]);
      SlaveGrid.Cells[15, j + 1] := IntToStr(DI.unitList.buff[j]);
      SlaveGrid.Cells[16, j + 1] := IntToStr(DI.unitList.valid[j]);
    end;
  end;
end;


procedure TFormLogikaServer.Timer1Timer(Sender: TObject);
begin
  // timer1.Enabled:=not Shell_NotifyIcon(NIM_ADD,@FNID);
end;

procedure TFormLogikaServer.PopupMenu1Popup(Sender: TObject);
begin
  it1.Visible := (Status = ssStop);
  it2.Visible := (Status = ssStart);
end;

procedure TFormLogikaServer.it1Click(Sender: TObject);
begin
  start;
end;

procedure TFormLogikaServer.it2Click(Sender: TObject);
begin
  stop;
end;

procedure TFormLogikaServer.SetAnalize(Sender: TObject);
begin
  if fAnalizeObject <> nil then
  begin
    if fAnalizeObject is TDeviceItems then
      TDeviceItems(fAnalizeObject).analizefunc := nil;
    if fAnalizeObject is TDeviceItem then
      TDeviceItem(fAnalizeObject).analizefunc := nil;
  end;
  if Sender <> nil then
  begin
    if Sender is TDeviceItems then
    begin
      TDeviceItems(Sender).analizefunc := AnalizeCom;
      PanelCom.Visible := True;
      PanelSlave.Visible := False;
      fAnalizeObject := Sender;
    end;
    if Sender is TDeviceItem then
    begin
      TDeviceItem(Sender).analizefunc := AnalizeSlave;
      PanelCom.Visible := False;
      PanelSlave.Visible := True;
      fAnalizeObject := Sender;
    end;
  end
  else
    OffAnalize;

end;

procedure TFormLogikaServer.OffAnalize;
begin
  if fAnalizeObject <> nil then
  begin
    if fAnalizeObject is TDeviceItems then
      TDeviceItems(fAnalizeObject).analizefunc := nil;
    if fAnalizeObject is TDeviceItem then
      TDeviceItem(fAnalizeObject).analizefunc := nil;
  end;
  PanelCom.Visible := False;
  PanelSlave.Visible := False;
  setTheardAnalize(False);
end;

procedure TFormLogikaServer.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if (Node <> nil) then
  begin
    if (Node.Data <> fAnalizeObject) then
    begin
      SetAnalize(Node.Data);
    end;
  end;
end;


procedure TFormLogikaServer.setTheardAnalize(val: boolean);
var
  i: integer;
begin
  for i := 0 to threadCOMList.Count - 1 do
    TLogikaServerThread(threadCOMList.Objects[i]).An := val;
end;

procedure TFormLogikaServer.TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  if Node <> nil then
    Node.SelectedIndex := Node.ImageIndex;
end;

procedure TFormLogikaServer.setStatus(val: TstatusServer);
begin
  fStatus := val;
end;



procedure TFormLogikaServer.Timer4Timer(Sender: TObject);
begin
  seticonSt;
  timer4.Enabled := not trayOk;
end;

procedure TFormLogikaServer.seticonSt;
var
  test: longbool;
begin
  if fStatus = ssStart then
    FNID.hIcon := self.Image1.picture.Icon.Handle
  else
    FNID.hIcon := self.Image2.picture.Icon.Handle;
  try
    if not trayOk then
    begin
      test := Shell_NotifyIcon(NIM_ADD, @FNID);
      if test then
        trayOk := True;
    end
    else
      Shell_NotifyIcon(NIM_MODIFY, @FNID);
  except
  end;

end;

end.
