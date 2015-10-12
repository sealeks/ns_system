unit NetStructs;
interface
uses
  winsock, classes,ConstDef, memStructsU, ParamU, SysUtils, globalValue, ScktComp, dialogs;

const
  MaxItemInRequest = 50;

  TEG_NOT_FOUND = '-1';
  NEW_VALID_LEVEL = '-2';
var
  ClientWaitDelay : integer = 5000; //Времяя в мс ожидания ответа

Type

  TClientStatusChanged = procedure (sender: TObject) of object;

TCommand = (cmdaddTeg, cmdResetTeg, cmdsubTeg, cmdAskChanges, cmdReplyChanges, cmdack, cmdNack, cmdChanged,
                      cmdAddCommand, CmdAckCommand, CMDNackCommand);
//function GetCommandText(val: TCommand): string;

//TAnser = (ack, Nack);
ByteArray = array[0..1000000] of char;
PByteArray = ^ByteArray;

TRequest = record
  bufSize: integer; //размер буфера данных
  command: TCommand; //тип команды
  pbuf: String;
end;

PTRequest = ^TRequest;

TAscedParam = class(TParam)
private
  prevVal: real;
  remoteID: string;
  validChanged: boolean;
end;

TLink = class
private
  Anser: TRequest;
  //p: pointer;
  function AddCommand(r: TRequest): boolean;
  function AddToList(r: TRequest): boolean;
  function RemoveFromList(r: TRequest): boolean;
  procedure Resetlist;
public
  sock: TCustomWinSocket;
  RequestedTegs: TList;
  LastError: String;
  lastTimeActive: TDateTime;
  status, remoteAddress, LocalAddress: string;
  groupNum: integer;
  function processRequest(r: TRequest): boolean; //разобрать запрос, обработать список тегов
  constructor Create(socket: TCustomWinSocket);
  destructor destroy; override;
  procedure SetValidChanged(ID: integer);
  procedure SendAnser;
  procedure SendChangedData;
end;


//Все связи сервера
TLinks = class(TList)
  private
    function GetItem(i: Integer): TLink;
public
  procedure TegValidChange(ID: integer);
  property Items[i: longInt]: TLink read GetItem; default;
  function NumBySock(Sock: TCustomWinSocket): integer;
  function ProcessRequest(r: TRequest; sck: TCustomWinSocket ): boolean;
  constructor Create;
  destructor destroy; override;
end;

//Типы стороны клиента
  TAskedArray = array [1..1000000] of boolean;
  PTAskedArray = ^TAskedArray;
  TActionType = set of (atNeedConnect, atResetTeg, atAddTeg, atSubteg, atAddCommand);


TMyClient = class(TClientSocket)
private
    haveAnser: boolean;
    r: TRequest;
    isAsked: PTAskedArray;
    //delay: integer;
    waitFrom: TDateTime;
    ClientAction : TActionType;
    FStatusText: string;
    fOnStatusChanged: TClientStatusChanged;
    P: Pointer;
    connectErrorCount: integer;
    procedure SetStatusText(const Value: string);
    procedure ProcessAnser(r: TRequest);
public
  GroupNum: Integer;
  Iter: integer;
  AskedtegCount: integer;
  haveUnAdvisedTegs: boolean;
  constructor Create(AOwner: TComponent; iGroupNum: integer; IP: string);
  destructor destroy; override;
  property StatusText: string read fStatusText write SetStatusText;
  property OnStatusChanged: TClientStatusChanged read fOnStatusChanged write fOnStatusChanged;
  procedure ReadAnser(Sender: TObject; Socket: TCustomWinSocket);
  procedure TimeTic;

  procedure ClearAsked;
  procedure CheckResetTeg;
  procedure CheckAddCommand;
  procedure CheckAddTeg;
  procedure CheckSubTeg;
  procedure Sendrequest;
  procedure AscChanges;

  procedure OnErrorProc(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer);
  procedure OnConnectProc(Sender: TObject;
    Socket: TCustomWinSocket);
end;

TMyClients = class(TList)
private
    function GetItem(i: Integer): TMyClient;
public
  property Items[i: longInt]: TMyClient read GetItem; default;
  function GetClientByGroup(GroupNum: Integer): integer;
  procedure AddCommand(ID: integer);
  procedure NewRef(ID: integer);
  procedure RemRef(ID: integer);
  Procedure TimeTic;
end;

function GetWord(var str: string): string;

var
  Links: TLinks;
  Clients: TMyClients;

implementation

function GetCommandText(val: TCommand): string;
begin
  case val of
  cmdResetTeg: result := 'Сбросить теги.';
  cmdaddTeg: result := 'Добавить теги.';
  cmdsubTeg: result := 'Удалить теги.';
  cmdAskChanges: result := 'Запрос изменений.';
  cmdAddCommand: result := 'Передача команды.';
  //, cmdReplyChanges, cmdack, cmdNack, cmdChanged
  end;
end;

{ TLink }
function GetWord(var str: string): string;
begin
  result := '';
  result := AnsiUpperCase(copy (str, 1, pos(';', str) - 1));
  str := copy(str, pos(';', str) + 1, length(str) - pos(';', str));
end;

constructor TLink.Create(socket: TCustomWinSocket);
begin
  inherited Create;
  lastTimeActive := now;
  //P := nil;
  RequestedTegs := TList.Create;
  groupNum := -1;
  sock := socket;
end;

function TLink.processRequest(r: TRequest): boolean;
begin
  lastTimeActive := Now;
  result := false;
  lastError := '';
  status := GetCommandText(r.command);
  case r.command of
    cmdResetTeg:
      begin
        ResetList;
        result := true;
      end;
    cmdaddCommand: result := AddCommand(r);
    cmdaddTeg: result := AddToList(r);
    cmdsubTeg: result := RemoveFromList(r);
    cmdAskChanges: SendChangedData;
  end;
end;

function TLink.AddCommand(r: TRequest): boolean;
var
  RTN: string;
  str: String;

begin
  result := true;
  str := r.pbuf;
  RTN := GetWord(str);
  while RTN <> '' do
  begin
    if rtItems.GetSimpleID(RTN) = -1 then
    begin
      result := false;
    end else
    begin
      try
        rtItems.AddCommand(rtItems.GetSimpleID(RTN), strtofloat(GetWord(str)), true, GetWord(str));
      except
        //если не смогли преобразовать число, то в запросе что-то не так. Не обрабатывать дальше!
        result := false;
        break;
      end;
    end;
    RTN := GetWord(str);
  end;
  if result then anser.command := cmdackCommand else anser.command := cmdNackCommand;
  anser.PBuf := '';
  SendAnser;
end;

function TLink.AddToList(r: TRequest): boolean;
var
  i, j: integer;
  NewParam: TAscedParam;
  RTN: string;
  dbl: boolean;
  s, str: String;

begin
  result := true;
  anser.command := cmdack;
  i := 1;
  str := r.pbuf;
  RTN := GetWord(str);
  while RTN <> '' do
  begin
    //Проверяем, что бы не было дубликатов
    dbl := false;
    for j := 0 to requestedTegs.Count - 1 do
      if TParam(requestedTegs[j]).rtName = UpperCase(RTN) then dbl := true;
    if not dbl then
    begin
      newParam := TAscedParam.Create;
      newParam.rtName := UpperCase(RTN);
      newParam.remoteID := GetWord(str);
      try
        newParam.Init(newParam.rtName);
      except
        if newParam.rtID = -1 then
          s := s+ TEG_NOT_FOUND + ';' + newParam.remoteID + ';';
      end;
      RequestedTegs.Add(newParam);
      if newParam.rtID <> -1 then
      begin
        s := s+ newParam.remoteID + ';'+floattostr(newParam.Value)+';';
        s := s + NEW_VALID_LEVEL + ';' +
            inttostr(rtItems[newParam.rtID].ValidLevel) +';';
        newParam.validChanged := false;
        newParam.prevVal := newParam.Value;
        if GroupNum = -1 then GroupNum := rtItems[newParam.rtID].GroupNum;
      end;

    end;
    inc(i, 2);
    RTN := GetWord(str);
  end;
  anser.PBuf := s;
  SendAnser;
end;

procedure TLink.Resetlist;
var
  j: integer;
  s: string;
begin
        for j := requestedTegs.Count - 1 downto 0 do
        begin
            TParam(requestedTegs[j]).free;
            requestedTegs.Delete(j);
        end;
  anser.command := cmdack;
  s := '0;';
  anser.PBuf := s;
  SendAnser;
end;

function TLink.RemoveFromList(r: TRequest): boolean;
var
  i, j: integer;
  RTN: string;
  found: boolean;
  cnt: integer;
  str: string;
begin
  result := true;
  i := 1;
  str := r.pbuf;
  RTN := GetWord(str);
  anser.Pbuf := '';
  anser.Command := cmdAck;
  while RTN <> '' do
  begin
    cnt := requestedTegs.Count - 1;
        for j := Cnt downto 0 do
        begin
          found := false;
          if TParam(requestedTegs[j]).rtName = UpperCase(RTN) then
          begin
            TParam(requestedTegs[j]).free;
            requestedTegs.Delete(j);
            found := true;
          end;
        end;
        if not found then begin
          LastError := LastError + 'Параметр для удаления не найден ' + RTN;
          result := false;
        end;
        inc(i);
        RTN := GetWord(str);
  end;
  sendAnser;
end;

procedure TLink.SendAnser;
var
  str: string;
begin
  anser.BufSize := Length(anser.PBuf);
  //ReallocMem(P, sizeOf(anser.bufsize) + sizeof(anser.command) + anser.bufSize);
  //move (anser.bufsize, P^, sizeof(anser.bufsize));
  //move (anser.command, P^, sizeof(anser.command));
  //move (anser.PBuf[1], (PChar(P)+sizeOf(anser))^, length(anser.PBuf));
  anser.bufSize := length(anser.PBuf);
  str := inttostr(anser.bufSize) + ';' + char(anser.command) + anser.pbuf;
  sock.SendText(str);
end;

procedure TLink.SendChangedData;
var
  i, id: integer;
  s: String;
  param: TAscedParam;
begin
  s := inttostr(requestedTegs.Count) + ';';
  anser.command := cmdchanged;
  //посылка валидности
  for i := 0 to requestedTegs.Count - 1 do
  begin
    param := TAscedParam(requestedTegs[i]);
    if param.rtID <> -1 then
    begin
      if Param.validChanged then
      begin
        s := s+ Param.remoteID + ';'+floattostr(Param.Value)+';';
        param.prevVal := param.Value;
        s := s + NEW_VALID_LEVEL + ';' + inttostr(rtItems[Param.rtID].ValidLevel) +';';
        param.validChanged := false;
      end else
      if abs(param.Value - param.prevVal) > 0 {rtItems[param.rtID].DeadBaund) } then
      begin
        s := s+ Param.remoteID + ';'+floattostr(Param.Value)+';';
        param.prevVal := param.Value;
        if pos('_REQ', AnsiUpperCase(rtItems.GetName(param.rtID))) <> 0 then
        s := s + NEW_VALID_LEVEL + ';' + inttostr(rtItems[Param.rtID].ValidLevel) +';';
        param.validChanged := false;
      end;
    end;
  end;
  anser.PBuf := s;
  SendAnser;
end;

destructor TLink.destroy;
var
  i: integer;
begin
  //Freemem(P);
  for i := requestedTegs.Count - 1 downto 0 do
   TAscedParam(requestedTegs[i]).Free;
  requestedTegs.Free;
  inherited;
end;

procedure TLink.SetValidChanged(ID: integer);
var
  i: integer;
begin
  for i := 0 to requestedTegs.Count - 1 do
    if TAscedParam(requestedTegs[i]).rtID = ID then
      TAscedParam(requestedTegs[i]).ValidChanged := true;
end;

{ TLinks }

constructor TLinks.Create;
begin
  inherited;

end;

destructor TLinks.destroy;
var
  i: integer;
begin
  for i := count - 1 downto 0 do
      TLink(Items[i]).Free;
  inherited;
end;

function TLinks.GetItem(i: Integer): TLink;
begin
  result := TLink(inherited Items[i]);
end;

function TLinks.NumBySock(Sock: TCustomWinSocket): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Links.Count do
    if Links[i].sock = sock then
    begin
      result := i;
      break;
    end;
end;

function TLinks.ProcessRequest(r: TRequest;
  sck: TCustomWinSocket): boolean;
var
  i, num: integer;
begin
  result := false;
  num := -1;
  for i := 0 to Links.Count - 1 do
    if Links[i].sock = sck then
    begin
      num := i;
      break;
    end;

  //if num = -1 then raise exception.Create('Сокет не найден')
  //else
  if num <> -1 then Items[num].processRequest(r);

end;

procedure TLinks.TegValidChange(ID: integer);
var
  i, j: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].groupNum = rtItems[id].GroupNum then
      Items[i].SetValidChanged(ID);
end;

{ TMyClient }

procedure TMyClient.AscChanges;
var
  str: string;
begin
    r.Command := cmdAskChanges;
    r.pbuf := '';
    str := char(r.command) + r.PBuf;
    sendRequest;
end;

procedure TMyClient.ClearAsked;
var
  i: integer;
begin
  for i := 0 to rtItems.Count - 1 do
   if (rtItems[i].GroupNum = GroupNum) and (isAsked[i]) then
      isAsked[i] :=false;
end;

procedure TMyClient.CheckResetTeg;
var
  i: integer;
begin
  r.PBuf := '';
  r.command := cmdResetTeg;
  AskedTegCount := 0;
  sendrequest;
end;

procedure TMyClient.CheckAddCommand;
var
  i: integer;
begin
  r.PBuf := '';
  for i := 0 to rtItems.Command.Count - 1 do
   if not rtItems.Command.ItemsN[i].executed and (rtItems[rtItems.Command.ItemsN[i].ID].GroupNum = GroupNum) then
   begin
     r.PBuf := r.PBuf + rtItems.GetName(rtItems.Command.ItemsN[i].ID) + ';' +
              floattostr(rtItems.Command.ItemsN[i].ValReal) + ';' +
              rtItems.Command.ItemsN[i].compName + ';';
     rtItems.Command.ItemsN[i].executed := true;
     r.command := cmdAddCommand;
   end;
    if r.PBuf <> '' then sendrequest;
end;

procedure TMyClient.CheckAddTeg;
var
  i: integer;
  ItemAdded: integer;
begin
  r.PBuf := '';
  AskedTegCount := 0;
  ItemAdded := 0;
  for i := 0 to rtItems.Count - 1 do
   if (rtItems[i].ID <> -1) and (rtItems[i].GroupNum = GroupNum)and (rtItems[i].refCount > 0) {and not (rtitems.TagDubleErr(i)) }then
   begin
    if not isAsked[i] then
    begin
      r.PBuf := r.PBuf + rtItems.GetName(i) + ';' + inttostr(rtItems[i].ID) + ';';
      r.command := cmdAddTeg;
      isAsked[i] := true;
      Inc(ItemAdded);
      if ItemAdded >= MaxItemInRequest then
      begin
        Clientaction := Clientaction + [atAddTeg];
        break;
      end;
    end;
    inc(AskedTegCount);
   end;

    if r.PBuf <> '' then sendrequest;
end;

procedure TMyClient.CheckSubTeg;
var
  i: integer;
begin
  r.PBuf := '';
  for i := 0 to rtItems.Count - 1 do
   if (rtItems[i].GroupNum = GroupNum) and isAsked[i] and (rtItems[i].refCount <= 0) then
    begin
      r.PBuf := r.PBuf + rtItems.GetName(i) + ';%G;';
      r.PBuf := format(r.PBuf, [rtItems[i].valReal]);
      dec(AskedTegCount);
      r.command := CmdSubTeg;
      isAsked[i] := false;
    end;
    if r.PBuf <> '' then
      sendrequest;
end;

constructor TMyClient.Create(AOwner: TComponent; iGroupNum: integer; IP: string);
begin
  inherited Create(AOwner);
  p := nil;
  iter := 0;
  askedtegCount:= 0;
  ClientAction := [atNeedConnect, atAddTeg, atSubteg];
  haveAnser := true;
  isAsked := allocMem(rtItems.Count);
  address := ip;
  Port := 1000;
  GroupNum := iGroupNum;
  OnRead := readAnser;
  OnError := OnErrorProc;
  OnConnect := OnConnectProc;
end;

destructor TMyClient.destroy;
begin
  freemem(P);
  FreeMem(isAsked);
  inherited;
end;

procedure TMyClient.ProcessAnser(r: TRequest);
//разбираем ответ
var
  ii, TegCount, TegID: integer;
  val: real;
  RTN: string;
  str: string;
  in_val: integer;
begin
  haveAnser := true;
  case r.command of
    cmdAck, cmdReplyChanges, cmdChanged:
    begin
     ii := 1;
     str := r.pbuf;

     //проверяем количество запрашиваемых тегов
     if r.command = cmdChanged then
     begin
       rtn := GetWord(str);
       if AskedTegCount <>  strtoint(rtn) then
       begin
         //ShowMessage(rtn);
         clearAsked;
         ClientAction := [atResetTeg, atAddTeg];
       end;
     end;

     RTN := GetWord(str);
     while RTN <> '' do
     begin
       try
         TegId := strtoint(RTN);
       except
          showMessage('Невозможно определить ID');
       end;
       try
           val := strtofloat(GetWord(str));
        except
           StatusText := 'Не получено значение для тега' + inttostr(GroupNum);
        end;
       if TegID = -1 then
       begin
         //если идент. тега -1, значит тег на сервере не найден,
         //снова читаем идентиф, и устанавливаем валидность в инвалидность
         //rtitems.SetValid(round(val), 0);
         rtitems.ValidOff(round(val));
         haveUnAdvisedTegs := true;
       end
       else
       begin
         rtItems.SetVal(tegID, val,100);
         //rtitems.SetValid(tegID,100);
       end;
       inc(ii, 2);
       RTN := GetWord(str);
       if RTN = NEW_VALID_LEVEL then
       begin
         //передается валидность этого тего, принять!
         rtitems.SetVal(TegID, rtitems[TegID].ValReal,strtoint(GetWord(str)));
         RTN := GetWord(str);
       end
     end;
    end;
    cmdAckCommand:;
    cmdNAckCommand:;
  end; //case
end;

procedure TMyClient.ReadAnser(Sender: TObject; Socket: TCustomWinSocket);
var
  str: string;

begin
  StatusText := Statustext + ' Ответ ' + inttostr(Socket.ReceiveLength) + ' байт';
  //ReallocMem(P, Socket.ReceiveLength);
  str := Socket.ReceiveText;
  r.bufSize := strtoint(GetWord(str));
  r.command := TCommand(str[1]);
  r.Pbuf := copy(str, 2, length(str) - 1);
  while r.bufSize <> Length(r.pbuf) do
  begin
    sleep(100);
    str := Socket.ReceiveText;
    if str = '' then
    begin
      raise Exception.Create('Ошибка получения ответа');
      exit;
    end;
    r.Pbuf := r.pbuf + str;
  end;
  ProcessAnser(r);
end;

procedure TMyClient.Sendrequest;
var
  str: string;
begin
    r.bufSize := length(r.Pbuf);
    StatusText := GetCommandText(r.Command);
    str := inttostr(Length(r.pbuf)) + ';' + char(r.command) + r.PBuf;
    Socket.SendText(str);
    haveAnser := false;
end;

procedure TMyClient.OnErrorProc(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  case ErrorEvent of
    eeGeneral: StatusText := 'Общая ошибка сокета';	//The socket received an error message that does not fit into any of the following categories.
    eeSend:	StatusText := 'Ошибка записи сокета';//An error occurred when trying to write to the socket connection.
    eeReceive: StatusText := 'Ошибка чтения сокета';	//An error occurred when trying to read from the socket connection.
    eeConnect:
    begin
      StatusText := 'Ошибка подключения';	//A connection request that was already accepted could not be completed.
      inc(connectErrorCount);
    end;
    eeDisconnect: StatusText := 'Ошибка при закрытии соединения';	//An error occurred when trying to close a connection.
    eeAccept: StatusText := 'Ошибка приема запроса';	//A problem occurred when trying to accept a client connection request.;
  end;
  //showMessage('!');
  socket.Close;
  close;

  clearAsked;
  ClientAction := [atNeedConnect, atAddTeg];
  ErrorCode := 0;
  HaveAnser := true;
end;

procedure TMyClient.SetStatusText(const Value: string);
begin
  fStatusText := Value;
  if Assigned(OnStatusChanged) then OnStatusChanged(Self);
end;

procedure TMyClient.TimeTic;
begin
  if HaveAnser = false then //ответ на предыдущий запрос не получен
  begin
   if ((Now - waitFrom) * 24 * 3600000 > ClientwaitDelay) and not (atNeedConnect in ClientAction) then
    begin
      Close;
      clearAsked;
      HaveAnser := true;
      ClientAction := [atNeedConnect, atAddTeg];
    end else
    begin

      if not (atNeedConnect in ClientAction) then statusText := GetCommandText(r.command) + ' Нет ответа ' + format('%5.2f сек',[(Now - waitFrom) *24 * 3600])
      else statusText := 'Ожидание соединения ' + format('%5.2f сек',[(Now - waitFrom) *24 * 3600]);
      exit;
    end;
  end else waitFrom := Now;

  inc(iter);
  if atNeedConnect in ClientAction then
  begin
    if not active then open; //connect
    HaveAnser := false;
  end else
  if atResetTeg in Clientaction then
  begin
    CheckResetTeg;
    Clientaction := Clientaction - [atResetTeg];
  end else
  if atAddCommand in Clientaction then
  begin
    CheckAddCommand;
    Clientaction := Clientaction - [atAddCommand];
  end else
  if atAddTeg in Clientaction then
  begin
    Clientaction := Clientaction - [atAddTeg];
    CheckAddTeg;
  end else
  if atSubteg in Clientaction then
  begin
    CheckSubTeg;
    Clientaction := Clientaction - [atSubTeg];
  end else
    ascChanges;
end;

procedure TMyClient.OnConnectProc(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  connectErrorCount := 0;
  HaveAnser := true;
  ClientAction := ClientAction - [atNeedConnect];
end;

{ TMyClients }

procedure TMyClients.AddCommand(ID: integer);
var
  i, g: integer;
begin
  for i := 0 to count - 1 do
    if Items[i].Groupnum = rtitems[id].GroupNum then
    begin
      Items[i].Clientaction := Items[i].Clientaction + [atAddCommand];
      break;
    end;
end;

function TMyClients.GetClientByGroup(GroupNum: Integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to count - 1 do
    if GroupNum = Items[i].GroupNum then
    begin
      result := i;
      exit;
    end;
end;

function TMyClients.GetItem(i: Integer): TMyClient;
begin
  result := TMyClient(inherited Items[i]);
end;


procedure TMyClients.NewRef(ID: integer);
var
  i, g: integer;
begin
  for i := 0 to count - 1 do
    if Items[i].Groupnum = rtitems[id].GroupNum then
    begin
      Items[i].Clientaction := Items[i].Clientaction + [atAddTeg];
      break;
    end;
end;

procedure TMyClients.RemRef(ID: integer);
var
  i, g: integer;
begin
  for i := 0 to count - 1 do
    if Items[i].Groupnum = rtItems[id].GroupNum then
    begin
      Items[i].Clientaction := Items[i].Clientaction + [atSubTeg];
      break;
    end;
end;


procedure TMyClients.TimeTic;
var
  i, NewClientNum: integer;
  AOwner: TComponent;
  iGroupNum: integer;
  IP: string;
begin
  for i := count - 1 downto 0 do
      Items[i].TimeTic;
end;

initialization
  links := TLinks.Create;
  Clients := TMyClients.Create;
end.
