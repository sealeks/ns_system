unit NetShare;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, Winsock, ComCtrls, StdCtrls, Buttons, Spin, GlobalValue,
  Grids,  ParamU, ExtCtrls,  Sockets, StrUtils, MATH, Menus, ShellApi, registry,
  memStructsU, constDef, {GlobalVar,} groupsU, configurationSys, NetStructs;


const
   WM_ICONNOTYFY=WM_USER+1324;

type

  TfrmNetShare = class(TForm)
    StatusBar1: TStatusBar;
    tmrClientTic: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Timer2: TTimer;
    ServerSocket1: TServerSocket;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ClientSocket1: TClientSocket;
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    SpinEdit1: TSpinEdit;
    Panel2: TPanel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit3: TSpinEdit;
    Button2: TButton;
    Button3: TButton;
    cbSelfCheck: TCheckBox;
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure tmrClientTicTimer(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
  private
    { Private declarations }
    requestReceived: boolean;
    r: TRequest;
    FNID: TNotifyIconData;
    Is_Icon_Norifyed: boolean;
    procedure refreshLinks;
    procedure DeleteLink(num: integer);
    procedure clearStringGrid(sg: TStringGrid);
    procedure RefreshGrid;
  public
    { Public declarations }
    function GetLocalIP: string;
    procedure ClientStatusChanged(sender: TObject);
    function  Notify_Icon: boolean;
    procedure WMIMMICommand(var Mess: TMessage); message WM_IMMICommand;
    procedure WMIMMIValid(var Mess: TMessage); message WM_IMMIValid;
    procedure WMIMMINewRef(var Mess: TMessage); message WM_IMMINewRef;
    procedure WMIMMIRemRef(var Mess: TMessage); message WM_IMMIRemRef;
    procedure WMIconNotyfy(var messag: TMsg); message WM_ICONNOTYFY;
    procedure WMClose(var messag: TMsg); message WM_Close;
    procedure WMEterClose(var messag: TMsg);
  end;

var
  frmNetShare: TfrmNetShare;

implementation

uses frmTegListU, frmTegListClientU;

{$R *.dfm}

procedure TfrmNetShare.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  newLink: TLink;
  i: integer;
begin
  newLink := nil;
  for i := Links.Count - 1 downto 0 do
    if Links[i].sock = Socket then
    begin
      deleteLink(i);
      break;
    end;

  newlink := TLink.Create(Socket);
  newLink.Status := 'Connected';
  newLink.remoteAddress := Socket.RemoteAddress;
  newLink.localAddress := Socket.localAddress;
  links.Add(newLink);
  RefreshLinks;
end;

procedure TfrmNetShare.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: integer;
  found: boolean;
begin
  found := false;
  for i:= 0 to Links.Count - 1 do
  begin
    if Links[i].sock = Socket then
    begin
      Links[i].Status := 'Disconnect';
      refreshLinks;
      found := true;
      break;
    end;
  end;
  //если времена не совпали, я связь уже мог убить сам
  //if not found then raise Exception.Create('Не найдена связь в списке!');
end;

procedure TfrmNetShare.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  str: string;
begin
  if requestReceived = true then
  begin
    //если все нормально , читаем начало запроса
    str := Socket.ReceiveText;
    r.bufSize := strtoint(GetWord(str));
    r.Pbuf := copy(str, 2, length(str) - 1);
    r.command := TCommand(str[1])
  end
  else
   begin
    //читаем продолжение запроса
    str := Socket.ReceiveText;
    if str = '' then
    begin
      raise Exception.Create('Ошибка получения запроса');
      exit;
    end;
    r.Pbuf := r.pbuf + str;
   end;

  requestReceived := (r.bufSize = Length(r.pbuf));


  if requestReceived then links.processRequest(r, Socket);
  refreshLinks;
end;

procedure TfrmNetShare.FormCreate(Sender: TObject);
var
  i, NewClientNum: integer;
  addr, app: string;
  regs: tregistry;
begin
   StatusBar1.Panels[0].Text := 'Начало работы ' + datetimetostr(Now);
   if not Is_Icon_Norifyed then Is_Icon_Norifyed := Notify_Icon;

  InitialSys;
  requestReceived := true;
  try
     rtItems := TAnalogMems.Create(PathMem);
     rtItems.Regs.RegHandle('NetShare', Handle, [IMMINewRef, IMMIRemRef, IMMICommand, immiValid]);
  except
     showMessage ('NetShare: Ошибка открытия базы данных');
     Application.Terminate;
     exit;
  end;
  //для каждой удаленной группы создаем своего клиента
 // Groups := TGroups.Create(PathMem + 'groups.cfg');
  for i := 0 to rtitems.tegGroups.Count - 1 do
  begin
   app := rtitems.tegGroups.GetAppbyNum(rtitems.tegGroups.Items[i].Num);
   if pos('\\', app) = 1 then
    begin
      addr := copy(app, 3, length(app) - 2);
      if pos('\', addr) <> 0 then addr := copy(addr, 1, pos('\', addr) - 1);
     if {not cbSelfCheck.Checked and }(addr = getLocalIP) then break;
      NewClientNum := Clients.Add(TMyClient.Create(self, rtitems.tegGroups.Items[i].Num, addr));
      Clients[NewClientNum].OnStatusChanged := ClientStatusChanged;
   end;
  end;
  with stringGrid1 do begin
    Cells[0, 0] := '№ гр.';
    Cells[1, 0] := 'Связь';
    Cells[2, 0] := 'Сост.';
    Cells[3, 0] := 'Итер.';
    Cells[4, 0] := 'Кол-во тегов';
  end;

  with stringGrid2 do begin
    Cells[0, 0] := '№';
    Cells[1, 0] := 'Связь';
    Cells[2, 0] := 'Кол-во тегов';
    Cells[3, 0] := 'Адрес';
    Cells[4, 0] := 'Имя ком-ра';
  end;

  Regs := TRegistry.Create;
  try
    Regs.RootKey := HKEY_LOCAL_MACHINE;
    regs.OpenKey('SOFTWARE\IMMI\ComPortSettings\Net_Share', True);
    try
      tmrClientTic.Interval := regs.ReadInteger('tmClientTic');
      ClientWaitDelay := regs.ReadInteger('ClientWaitDelay');
    except
    end;
    regs.CloseKey;
  finally
    regs.free;
  end;
  SpinEdit2.Value := tmrClientTic.Interval;
  SpinEdit3.Value := ClientWaitDelay;
end;

procedure TfrmNetShare.FormDestroy(Sender: TObject);
begin
  Links.Free;
end;

procedure TfrmNetShare.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  rtItems.Regs.UnRegHandle(Handle);
 // groups.Free;
end;

procedure TfrmNetShare.WMIMMINewRef(var Mess: TMessage);
begin
  if Mess.lParam <> -1 then
    Clients.NewRef(Mess.lParam);
end;

procedure TfrmNetShare.WMIMMIRemRef(var Mess: TMessage);
begin
  if Mess.lParam <> -1 then
    Clients.RemRef(Mess.lParam);
end;

procedure TfrmNetShare.Button3Click(Sender: TObject);
begin
  Clients.TimeTic;
  refreshGrid;;
end;

procedure TfrmNetShare.CheckBox1Click(Sender: TObject);
begin
  tmrClientTic.Enabled := CheckBox1.Checked;
end;

procedure TfrmNetShare.tmrClientTicTimer(Sender: TObject);
begin
 Clients.TimeTic;
 refreshGrid;;
end;

procedure TfrmNetShare.ClientStatusChanged(sender: TObject);
var
  i: integer;
begin
  for i := 0 to Clients.Count - 1 do
  begin
    stringGrid1.Cells[2, i+1] := Clients[i].StatusText;
  end;
end;

procedure TfrmNetShare.StringGrid2DblClick(Sender: TObject);
var
  linkNumStr: string;
begin
 LinkNumStr := stringGrid2.Cells[0, stringGrid2.Selection.Top];
 if LinkNumStr = '' then exit;

 frmTegList.RequestedTegs := Links[strtoint(linkNumStr)].RequestedTegs;
 frmTegList.Show;

end;

procedure TfrmNetShare.CheckBox2Click(Sender: TObject);
begin
 ServerSocket1.Active := (Sender as TCheckBox).Checked;
end;

procedure TfrmNetShare.StringGrid1DblClick(Sender: TObject);
var
  linkNumStr: string;
  GroupNum: integer;
  i, curLine: integer;
begin
 LinkNumStr := stringGrid1.Cells[0, StringGrid1.Selection.Top];
 if LinkNumStr = '' then exit;
 groupnum := strtoint(LinkNumStr);
 curLine := 1;
 clearStringGrid(frmTegListClient.stringGrid2);
 for i := 0 to rtItems.Count - 1 do
   if (rtitems[i].GroupNum = GroupNum) and (rtitems[i].RefCount <> 0) then
   with frmTegListClient.stringGrid2 do
   begin
     RowCount := CurLine + 1;
     cells[0, curLine] := inttostr(curLine - 1);
     cells[1, curLine] := inttostr(i);
     cells[2, curLine] := rtItems.GetName(i);
     cells[3, curLine] := floattostr(rtItems[i].ValReal);
     cells[4, curLine] := ifthen(rtItems[i].ValidLevel = 0, 'НЕ АКТИВЕН', 'АКТИВЕН'); ;
     inc(curLine);
   end;

 frmTegListClient.Show;
end;

procedure TfrmNetShare.Timer2Timer(Sender: TObject);
 var
  i: integer;
begin
  if not Is_Icon_Norifyed then Is_Icon_Norifyed := Notify_Icon;
  for i := 0 to Links.Count - 1 do
    if ((Now - Links[i].lastTimeActive) > (spinEdit1.Value * (1/24/3600))) then
      Links[i].status := 'Not active'
    else Links[i].status := 'Connect';
  for i := Links.Count - 1 downto 0 do
    if (Now - Links[i].lastTimeActive) > (spinEdit1.Value * (1/24/3600)*3) then
     deleteLink(i);
    refreshLinks;
end;

procedure TfrmNetShare.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var
  i: integer;
begin
  for i:= 0 to Links.Count - 1 do
  begin
    if Links[i].sock = Socket then
    begin
      Links[i].Status := 'Error = ' + inttostr(integer(ErrorEvent));
      //Links.Delete(i);
      break;
    end;
  end;
  ErrorCode := 0;
  refreshLinks;
end;

function TfrmNetShare.GetLocalIP: string;
var
 WSAData : TWSAData;
  p : PHostEnt;
  Name : array [0..$FF] of Char;
begin
  WSAStartup($0101, WSAData);
  GetHostName(name, $FF);
  p := GetHostByName(Name);
  result := inet_ntoa(PInAddr(p.h_addr_list^)^);
  WSACleanup;
end;

procedure TfrmNetShare.refreshLinks;
var
  i: integer;
begin
  with stringGrid2 do
  begin
    RowCount := MAX(links.count + 1, 2);
    for i := 0 to links.Count - 1 do
    begin
      cells[0, i + 1] := inttostr(i);
      cells[1, i + 1] := Links[i].Status;
      cells[2, i + 1] := inttostr(Links[i].RequestedTegs.Count);
      cells[3, i + 1] := Links[i].RemoteAddress;
      cells[4, i + 1] := Links[i].LocalAddress;
    end;
    for i := links.Count to RowCount do
    begin
      cells[0, i + 1] := '';
      cells[1, i + 1] := '';
      cells[2, i + 1] := '';
      cells[3, i + 1] := '';
      cells[4, i + 1] := '';
    end;
  end;
end;

procedure TfrmNetShare.DeleteLink(num: integer);
begin
  Links[num].Free;
  Links.Delete(num);

end;

procedure TfrmNetShare.clearStringGrid(sg: TStringGrid);
var
  i, j: integer;
begin
   for i := 1 to sg.RowCount - 1 do
     for j := 0 to sg.ColCount - 1 do
       sg.Cells[j, i] := '';

end;

procedure TfrmNetShare.RefreshGrid;
var
  i: integer;
begin
  stringGrid1.RowCount := Clients.Count + 2;
  for i := 0 to Clients.Count - 1 do
  begin
    stringGrid1.Cells[0, i+1] := IntToStr(Clients[i].GroupNum);
    stringGrid1.Cells[1, i+1] := ifthen(Clients[i].Active, 'True', 'False');;
    stringGrid1.Cells[2, i+1] := Clients[i].StatusText;
    if Clients[i].haveUnAdvisedTegs then
      stringGrid1.Cells[2, i+1] := 'ТЕГИ! ' + Clients[i].StatusText;
    stringGrid1.Cells[3, i+1] := inttostr(Clients[i].Iter);
    stringGrid1.Cells[4, i+1] := inttostr(Clients[i].AskedtegCount);
  end;
end;

procedure TfrmNetShare.WMClose(var messag: TMsg);
begin
  messag.message:=0;
  Hide;
end;

procedure TfrmNetShare.WMEterClose(var messag: TMsg);
begin
  messag.message:=0;
  Hide;
end;

procedure TfrmNetShare.WMIconNotyfy(var messag: TMsg);
var pt: TPoint;
begin
  if messag.wParam=WM_RBUTTONDOWN then
  begin
    getCursorPos(pt);
    popupmenu1.Popup(pt.X,pt.y);
  end;
end;


procedure TfrmNetShare.N1Click(Sender: TObject);
begin
  Show;
end;

procedure TfrmNetShare.N2Click(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE,@FNID);
  close;
  free;
end;

procedure TfrmNetShare.WMIMMICommand(var Mess: TMessage);
begin
  Clients.AddCommand(Mess.LParam);
end;

procedure TfrmNetShare.WMIMMIValid(var Mess: TMessage);
begin
    Links.TegValidChange(Mess.LParam);
end;

procedure TfrmNetShare.SpinEdit2Change(Sender: TObject);
var
  regs: tregistry;
begin
  Regs := TRegistry.Create;
  tmrClientTic.Interval := SpinEdit2.Value;
  try
    Regs.RootKey := HKEY_LOCAL_MACHINE;
    regs.OpenKey('SOFTWARE\IMMI\ComPortSettings\Net_Share', True);
    regs.WriteInteger('tmClientTic', SpinEdit2.Value);
    regs.CloseKey;
  finally
    regs.free;
  end;
end;

procedure TfrmNetShare.SpinEdit3Change(Sender: TObject);
var
  regs: tregistry;
begin
  Regs := TRegistry.Create;
  ClientWaitDelay := SpinEdit3.Value;
  try
    Regs.RootKey := HKEY_LOCAL_MACHINE;
    regs.OpenKey('SOFTWARE\IMMI\ComPortSettings\Net_Share', True);
    regs.WriteInteger('ClientWaitDelay', SpinEdit3.Value);
    regs.CloseKey;
  finally
    regs.free;
  end;
end;

function TfrmNetShare.Notify_Icon: boolean;
begin
   FNID.Wnd:=handle;
   FNID.uCallbackMessage:=WM_ICONNOTYFY;
   FNID.hIcon:=application.Icon.Handle;
   FNID.szTip:='IMMI_Net_Share';
   FNID.uFlags:=nif_Message or nif_Icon or nif_Tip ;
   result := Shell_NotifyIcon(NIM_ADD,@FNID);
end;

end.
