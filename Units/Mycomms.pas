unit MyComms;

interface

uses
  Windows, Messages, Classes, SysUtils, GenAlg, Controls, InterfaceServerU;




type
  TPortType = (COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8);
  TBaudRate = (br110, br300, br600, br1200, br2400, br4800, br9600,
               br14400, br19200, br38400, br56000, br57600, br115200);
  TPortErr = (perNone, perRead, perWrite);
  TStopBits = (sbOneStopBit, sbOne5StopBits, sbTwoStopBits);
  TDataBits = (dbFive, dbSix, dbSeven, dbEight);
  TParityBits = (prNone, prOdd, prEven, prMark, prSpace);
  TOperationKind = (okWrite, okRead);
  TAsync = record
    Overlapped: TOverlapped;
    Kind: TOperationKind;
    Data: Pointer;
    Size: Integer;
  end;
  PAsync = ^TAsync;
  TMyComPort = class;

  TComTimeouts = class(TPersistent)
  private
    ComPort: TMyComPort;
    FReadInterval: Integer;
    FReadTotalM: Integer;
    FReadTotalC: Integer;
    FWriteTotalM: Integer;
    FWriteTotalC: Integer;
    procedure SetReadInterval(Value: Integer);
    procedure SetReadTotalM(Value: Integer);
    procedure SetReadTotalC(Value: Integer);
    procedure SetWriteTotalM(Value: Integer);
    procedure SetWriteTotalC(Value: Integer);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AComPort: TMyComPort);
  published
    property ReadInterval: Integer read FReadInterval write SetReadInterval;
    property ReadTotalMultiplier: Integer read FReadTotalM write SetReadTotalM;
    property ReadTotalConstant: Integer read FReadTotalC write SetReadTotalC;
    property WriteTotalMultiplier: Integer read FWriteTotalM write SetWriteTotalM;
    property WriteTotalConstant: Integer read FWriteTotalC write SetWriteTotalC;
  end;

  TMyComPort = class(TInterfaceServer)
  private
    FConnected: Boolean;
    FPort: Word;

    procedure SetBaudRate(Value: TBaudRate);
    procedure SetPort(Value: Word);
    procedure SetStopBits(Value: TStopBits);
    procedure SetDataBits(Value: TDataBits);

  protected

    FBaudRate: TBaudRate;
    FStopBits: TStopBits;
    FDataBits: TDataBits;
    FParity: TParityBits;
    FHandle: THandle;
    FTimeouts: TComTimeouts;
    ftrd: integer;
    fred: integer;
    flCtrl: boolean;
    fModbus: boolean;
    function  ComTimer(vl: integer): boolean;
    procedure DoneAsync(var AsyncPtr: PAsync);
    procedure InitAsync(var AsyncPtr: PAsync);
    procedure CreateHandle;
    procedure DestroyHandle;
    procedure SetupComPort;
    procedure SetDCB;
    procedure SetTimeouts;

    procedure initComset;


  public
    fComstr: string;
    procedure setComset(val: TComset); override;
    property Connected: Boolean read FConnected;
    property Handle: THandle read FHandle;
    function Open: boolean; override;
    procedure Close; override;
    function Write(var Buffer; Count: DWORD; WaitFor: Boolean): DWORD;
    function WriteString(Str: String; WaitFor: Boolean): DWORD;
    function Read(var Buffer; Count: DWORD; WaitFor: Boolean): DWORD;
    function ReadString(var Str: String; Count: DWORD; WaitFor: Boolean): DWORD;
    procedure PugeCom;
    function ComString: String;
    constructor Create(AOwner: TComponent;st: Tcomset; modbus: boolean = false);
    destructor Destroy; override;
    function ReadSettings: boolean; override;
  published
    property Port: Word read FPort write SetPort;
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate;
    property Parity: TParityBits read FParity write FParity;
    property StopBits: TStopBits read FStopBits write SetStopBits;
    property DataBits: TDataBits read FDataBits write SetDataBits;
    property Timeouts: TComTimeouts read FTimeouts write FTimeouts;
    property CurCoSet: TComset read  fcomset write setComset;

  end;

  EComPort   = class(Exception);

const
  dcb_Binary           = $00000001;
  dcb_Parity           = $00000002;
  dcb_OutxCtsFlow      = $00000004;
  dcb_OutxDsrFlow      = $00000008;
  dcb_DtrControl       = $00000030;
  dcb_DsrSensivity     = $00000040;
  dcb_TXContinueOnXOff = $00000080;
  dcb_OutX             = $00000100;
  dcb_InX              = $00000200;
  dcb_ErrorChar        = $00000400;
  dcb_Null             = $00000800;
  dcb_RtsControl       = $00003000;
  dcb_AbortOnError     = $00004000;

  NOT_FINISHED         = $FFFFFFFF;
  NO_OPERATION         = $FFFFFFFE;

  CM_COMPORT           = WM_USER + 9; // change this if used by other unit


implementation

function LastErr: String;
begin
  Result := IntToStr(GetLastError);
end;

function GetTOValue(Value: Integer): DWORD;
begin
  if Value = -1 then
    Result := MAXDWORD
  else
    Result := Value;
end;

// TComTimeouts

constructor TComTimeouts.Create(AComPort: TMyComPort);
begin
  ComPort := AComPort;
  FReadInterval :=3000;
  FWriteTotalM := 10000;
  FWriteTotalC := 10000;
end;

procedure TComTimeouts.AssignTo(Dest: TPersistent);
begin
  if Dest is TComTimeouts then begin
    with TComTimeouts(Dest) do begin
      FReadInterval := Self.FReadInterval;
      FReadTotalM := Self.FReadTotalM;
      FReadTotalC := Self.FReadTotalC;
      FWriteTotalM := Self.FWriteTotalM;
      FWriteTotalC := Self.FWriteTotalC;
      ComPort := Self.ComPort;
    end
  end
  else
    inherited AssignTo(Dest);
end;

procedure TComTimeouts.SetReadInterval(Value: Integer);
begin
  if Value <> FReadInterval then begin
    FReadInterval := Value;
    ComPort.SetTimeouts;
  end;
end;

procedure TComTimeouts.SetReadTotalC(Value: Integer);
begin
  if Value <> FReadTotalC then begin
    FReadTotalC := Value;
    ComPort.SetTimeouts;
  end;
end;

procedure TComTimeouts.SetReadTotalM(Value: Integer);
begin
  if Value <> FReadTotalM then begin
    FReadTotalM := Value;
    ComPort.SetTimeouts;
  end;
end;

procedure TComTimeouts.SetWriteTotalC(Value: Integer);
begin
  if Value <> FWriteTotalC then begin
    FWriteTotalC := Value;
    ComPort.SetTimeouts;
  end;
end;

procedure TComTimeouts.SetWriteTotalM(Value: Integer);
begin
  if Value <> FWriteTotalM then begin
    FWriteTotalM := Value;
    ComPort.SetTimeouts;
  end;
end;


// TMyComPort

constructor TMyComPort.Create(AOwner: TComponent; st: Tcomset; modbus: boolean = false);
begin
  inherited Create(AOwner);
  FTimeouts:=TComTimeouts.Create(self);
  self.fcomset:=st;
  self.fModbus:=modbus;
  initComset;
end;

destructor TMyComPort.Destroy;
begin
  Close;
  FTimeouts.Free;
  inherited Destroy;
end;

procedure TMyComPort.CreateHandle;
var tmp: string;
begin
  FHandle := CreateFile(
    PChar(ComString)  ,
    GENERIC_READ or GENERIC_WRITE,
    0,
    nil,
    OPEN_EXISTING,
     FILE_FLAG_OVERLAPPED,
    0);

  if FHandle = INVALID_HANDLE_VALUE then
    raise EComPort.Create('Unable to open com port: ' + ComString);
end;

procedure TMyComPort.DestroyHandle;
begin
  if FHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FHandle);
end;


function TMyComPort.ComTimer(vl: integer): boolean;
var tempTimer: THandle;
    tempDue: TLargeInteger;
    Signaled: DWORD;
begin
  result:=false;
  tempDue:=-10000*vl;
  tempTimer:=CreateWaitableTimer(nil,false,nil);
  if (0<>tempTimer) then
     begin
     SetWaitableTimer(tempTimer,tempDue,0, nil,nil,false);
     Signaled := WaitForSingleObject(tempTimer, vl);
     result := (Signaled = WAIT_OBJECT_0);
     end;
end;

function TMyComPort.Open: boolean;
begin
  try
  Close;
  initComset;
  CreateHandle;
  FConnected := True;
  result:=false;

    self.initComset;
    SetupComPort;
    SetCommMask(FHandle,EV_TXEMPTY or EV_DSR or EV_RLSD);
    if self.flCtrl then
     begin
       EscapeCommFunction(FHandle, CLRRTS	);
     end;
    PurgeComm(FHandle,PURGE_TXABORT or PURGE_TXCLEAR);
    PurgeComm(FHandle,PURGE_RXABORT or PURGE_RXCLEAR);
    result:=true;
  except
    DestroyHandle;
    FConnected := False;
    result:=false;
    //raise;
  end;
end;

procedure TMyComPort.Close;
begin
  if FConnected then begin
    DestroyHandle;
    FConnected := False;
  end;
end;

procedure TMyComPort.SetDCB;
const
CControlRTS: array[0..3] of Integer =
    (RTS_CONTROL_DISABLE shl 12,
     RTS_CONTROL_ENABLE shl 12,
     RTS_CONTROL_HANDSHAKE shl 12,
     RTS_CONTROL_TOGGLE shl 12);
  CControlDTR: array[0..2] of Integer =
    (DTR_CONTROL_DISABLE shl 4,
     DTR_CONTROL_ENABLE shl 4,
     DTR_CONTROL_HANDSHAKE shl 4);
var
  DCB: TDCB;
begin
  if FConnected then begin
    if not GetCommState(FHandle, DCB) then
      raise EComPort.Create('Unable to get com dcb: ' + LastErr);

    DCB.DCBlength := SizeOf(DCB);

    case FParity of
      prNone:  DCB.Parity := NOPARITY;
      prOdd:   DCB.Parity := ODDPARITY;
      prEven:  DCB.Parity := EVENPARITY;
      prMark:  DCB.Parity := MARKPARITY;
      prSpace: DCB.Parity := SPACEPARITY;
    end;

    case FStopBits of
      sbOneStopBit:   DCB.StopBits := ONESTOPBIT;
      sbOne5StopBits: DCB.StopBits := ONE5STOPBITS;
      sbTwoStopBits:  DCB.StopBits := TWOSTOPBITS;

        end;


     if self.flCtrl then
     begin
     DCB.Flags:=DCB.Flags or CControlDTR[0]
        or CControlRTS[1];
     DCB.Flags := DCB.Flags or dcb_DSRSensivity;
     DCB.Flags := DCB.Flags and not dcb_OutxCTSFlow;
     DCB.Flags := DCB.Flags  and not dcb_OutxDSRFlow;
     end else

     begin
     DCB.Flags:=DCB.Flags or CControlDTR[0]
        or CControlRTS[0];
     DCB.Flags := DCB.Flags and not dcb_DSRSensivity;
     DCB.Flags := DCB.Flags and not dcb_OutxCTSFlow;
     DCB.Flags := DCB.Flags  and not dcb_OutxDSRFlow;
     end;

    case FBaudRate of
      br110:    DCB.BaudRate := CBR_110;
      br300:    DCB.BaudRate := CBR_300;
      br600:    DCB.BaudRate := CBR_600;
      br1200:   DCB.BaudRate := CBR_1200;
      br2400:   DCB.BaudRate := CBR_2400;
      br4800:   DCB.BaudRate := CBR_4800;
      br9600:   DCB.BaudRate := CBR_9600;
      br14400:  DCB.BaudRate := CBR_14400;
      br19200:  DCB.BaudRate := CBR_19200;
      br38400:  DCB.BaudRate := CBR_38400;
      br56000:  DCB.BaudRate := CBR_56000;
      br57600:  DCB.BaudRate := CBR_57600;
      br115200: DCB.BaudRate := CBR_115200;
    end;

    DCB.ByteSize := Integer(FDataBits) + 5;
  //  DCB.EofChar := CHAR($0A);
    if not SetCommState(FHandle, DCB) then
      raise EComPort.Create('Unable to set com state: ' + LastErr);
  end;
end;

procedure TMyComPort.SetTimeouts;
var
  Timeouts: TCommTimeouts;
begin
  if FConnected then begin
    Timeouts.ReadIntervalTimeout := GetTOValue(FTimeouts.FReadInterval);
    Timeouts.ReadTotalTimeoutMultiplier := GetTOValue(FTimeouts.FReadTotalM);
    Timeouts.ReadTotalTimeoutConstant := GetTOValue(FTimeouts.FReadTotalC);
    Timeouts.WriteTotalTimeoutMultiplier := GetTOValue(FTimeouts.FWriteTotalM);
    Timeouts.WriteTotalTimeoutConstant := GetTOValue(FTimeouts.FWriteTotalC);

    if not SetCommTimeouts(FHandle, Timeouts) then
      raise EComPort.Create('Unable to set com state: ' + LastErr);
  end;
end;

procedure TMyComPort.SetupComPort;
begin
  SetDCB;
  SetTimeouts;
end;

function TMyComPort.Write(var Buffer; Count: DWORD; WaitFor: Boolean): DWORD;
var
  Success: Boolean;
  BytesTrans: DWORD;
begin
  Success := WriteFile(FHandle, Buffer, Count, BytesTrans, nil);
  Result := BytesTrans;
  if not Success then
    raise EComPort.Create('WriteFile buf failed: ' + LastErr);
end;

function TMyComPort.WriteString(Str: String; WaitFor: Boolean): DWORD;
var
  Success: Boolean;
  BytesTrans, Signaled: DWORD;
   MASK: CARDINAL;
  AsyncPtr: PAsync;
  curres: integer;
begin
   if self.flCtrl then
   begin
   if EscapeCommFunction(FHandle, SETRTS) then
    sleep (self.ftrd);
   end;

  InitAsync(AsyncPtr);
  try

  WriteFile(FHandle, Str[1], Length(Str), BytesTrans, @AsyncPtr.Overlapped);
   Signaled := WaitForSingleObject(AsyncPtr^.Overlapped.hEvent, fcomset.wait);
  Success := (Signaled = WAIT_OBJECT_0) and
      (GetOverlappedResult(FHandle, AsyncPtr^.Overlapped, BytesTrans, False));
  if not Success then
  begin
  result:=0;
  PurgeComm(FHandle,PURGE_TXABORT or PURGE_TXCLEAR);
  end
  else result:=bytestrans;
  finally
  DoneAsync(AsyncPtr);
  end;





  if self.flCtrl then
   begin
    sleep(self.fred);
    EscapeCommFunction(FHandle, CLRRTS	);
   end;
  PurgeComm(FHandle,PURGE_RXABORT or PURGE_RXCLEAR);
  PurgeComm(FHandle,PURGE_TXABORT or PURGE_TXCLEAR);


end;

function TMyComPort.Read(var Buffer; Count: DWORD; WaitFor: Boolean): DWORD;
var
  Success: Boolean;
  BytesTrans: DWORD;
begin
  Success := ReadFile(FHandle, Buffer, Count, BytesTrans, nil);
  Result := BytesTrans;
  if not Success then
    raise EComPort.Create('ReadFile buffer failed: ' + LastErr);
end;




function TMyComPort.ReadString(var Str: String; Count: DWORD; WaitFor: Boolean): DWORD;
var
  Success: Boolean;
  BytesTrans, Signaled: DWORD;
  MASK: CARDINAL;
  AsyncPtr: PAsync;
  curres: integer;

begin
  curres:=1;
  if self.flCtrl then
  begin
  InitAsync(AsyncPtr);
  try
  mask:=ev_rlsd;
  WaitCommEvent(FHandle, mask , @AsyncPtr^.Overlapped);

  Signaled := WaitForSingleObject(AsyncPtr^.Overlapped.hEvent, fcomset.wait);
  Success := (Signaled = WAIT_OBJECT_0);
      (GetOverlappedResult(FHandle, AsyncPtr^.Overlapped, BytesTrans, False));
  Result := BytesTrans;
  if not Success then
   curres:=0;
  finally
    DoneAsync(AsyncPtr);
  end;
  if curres=0 then exit;
  end;

  InitAsync(AsyncPtr);
  try
  SetLength(Str, Count);
  ReadFile(FHandle, Str[1], Count, BytesTrans, @AsyncPtr^.Overlapped);
  Signaled := WaitForSingleObject(AsyncPtr^.Overlapped.hEvent, fcomset.wait);
  Success := (Signaled = WAIT_OBJECT_0);
      (GetOverlappedResult(FHandle, AsyncPtr^.Overlapped, BytesTrans, False));
  Result := BytesTrans;
  if not Success then
  begin
  result:=0;
  PurgeComm(FHandle,PURGE_RXABORT or PURGE_RXCLEAR);
  //PurgeComm(FHandle,PURGE_RXCLEAR);
  end
  else result:=bytestrans;
  finally
    DoneAsync(AsyncPtr);
  end;

// PurgeComm(FHandle,PURGE_TXABORT or PURGE_TXCLEAR);
// PurgeComm(FHandle,PURGE_RXABORT or PURGE_RXCLEAR);
 // sleep(500);
end;


procedure TMyComPort.PugeCom;
begin
 if self.flCtrl then
 begin
 fcomset.prttm:=10;
 sleep(fcomset.prttm);
 PurgeComm(FHandle,PURGE_TXABORT or PURGE_TXCLEAR);
 PurgeComm(FHandle,PURGE_RXABORT or PURGE_RXCLEAR);
 end;
end;



procedure TMyComPort.SetBaudRate(Value: TBaudRate);
begin
  if Value <> FBaudRate then begin
    FBaudRate := Value;
    SetDCB;
  end;
end;

procedure TMyComPort.SetDataBits(Value: TDataBits);
begin
  if Value <> FDataBits then begin
    FDataBits := Value;
    SetDCB;
  end;
end;


procedure TMyComPort.SetPort(Value: Word);
begin
  if Value <> fport then begin
    FPort := Value;
    if FConnected then begin
      Close;
      Open;
    end;
  end;
end;

procedure TMyComPort.SetStopBits(Value: TStopBits);
begin
  if Value <> FStopBits then begin
    FStopBits := Value;
    SetDCB;
  end;
end;


function TMyComPort.ComString: String;
begin
    if Port>0 then result:='\\.\COM'+inttostr(fport);
end;

procedure TMyComPort.InitAsync(var AsyncPtr: PAsync);
begin
  New(AsyncPtr);
  with AsyncPtr^ do
  begin
    FillChar(Overlapped, SizeOf(TOverlapped), 0);
    Overlapped.hEvent := CreateEvent(nil, True, True, nil);
    Data := nil;
    Size := 0;
  end;
end;

// clean-up of PAsync variable
procedure TMyComPort.DoneAsync(var AsyncPtr: PAsync);
begin
  with AsyncPtr^ do
  begin
    CloseHandle(Overlapped.hEvent);
    if Data <> nil then
      FreeMem(Data);
  end;
  Dispose(AsyncPtr);
  AsyncPtr := nil;
end;

procedure TMyComPort.setComset(val: TComset);
var chcomsetting: boolean;
    chtimeout: boolean;

   // chtimeout: boolean;
begin
   chcomsetting:=false;
   chtimeout:=false;

       begin
        if ((val.br<>fcomset.br) or
             (val.db<>fcomset.db) or
              (val.sb<>fcomset.sb) or
               (val.pt<>fcomset.pt) or
                  (val.flCtrl<>fcomset.flCtrl)) then 
                  begin
                     if val.br=110 then  self.fBaudRate:=br110 else
                        if val.br=300 then  self.fBaudRate:=br300 else
                          if val.br=600 then  self.fBaudRate:=br600 else
                             if val.br=1200 then  self.fBaudRate:=br1200 else
                                 if val.br=2400 then  self.fBaudRate:=br2400 else
                                    if val.br=4800 then  self.fBaudRate:=br4800 else
                                       if val.br=9600 then  self.fBaudRate:=br9600 else
                                          if val.br=14400 then  self.fBaudRate:=br14400 else
                                            if val.br=19200 then  self.fBaudRate:=br19200 else
                                                if val.br=38400 then  self.fBaudRate:=br38400 else
                                                   if val.br=56000 then  self.fBaudRate:=br56000 else
                                                      if val.br=115200 then  self.fBaudRate:=br115200 else
                                                           self.fBaudRate:=br9600;

                     if val.db=5 then self.fDataBits:=dbFive else
                         if val.db=6 then self.fDataBits:=dbSix else
                             if val.db=7 then self.fDataBits:=dbSeven else
                                self.fDataBits:=dbEight;


                     if val.sb=3 then self.FStopBits:=sbOne5StopBits else
                          if val.sb=2 then self.FStopBits:=sbTwoStopBits else
                             self.FStopBits:=sbOneStopBit;



                     if val.pt=1 then self.FParity:=prOdd else
                           if val.pt=2 then self.FParity:=prEven else
                                if val.pt=3 then self.FParity:=prMark else
                                    if val.pt=4 then self.FParity:=prSpace else
                                       self.FParity:=prNone;

                     self.flCtrl:=val.flCtrl;
                     self.SetDCB;
                  end;

                   if (val.ri<>fcomset.ri) or
                       (val.rtm<>fcomset.rtm) or
                         (val.rtc<>fcomset.rtc) or
                            (val.wtm<>fcomset.wtm) or
                              (val.wtc<>fcomset.wtc) then
                                begin
                                  self.Timeouts.ReadInterval:=val.ri;
                                  self.Timeouts.ReadTotalMultiplier:=val.rtm;
                                  self.Timeouts.ReadTotalConstant:=val.rtc;
                                  self.Timeouts.WriteTotalMultiplier:=val.wtm;
                                  self.Timeouts.WriteTotalConstant:=val.wtc;
                                  self.SetTimeouts;
                                end;

                   if ((val.trd<>fcomset.trd) or
                          (val.red<>fcomset.red) or
                                 (val.bs<>fcomset.bs)) then
                         begin
                           //self.blockSize:=val.bs;
                           self.fred:=val.red;
                           self.ftrd:=val.trd;
                         end;

       end;
     fcomset:=val;
end;

procedure TMyComPort.initComset;
var chcomsetting: boolean;
    chtimeout: boolean;
    val: TComset;
   // chtimeout: boolean;
begin
   chcomsetting:=false;
   chtimeout:=false;
   val:=self.fcomset;
   fport:=val.Com;
   if val.br=110 then  self.fBaudRate:=br110 else
                        if val.br=300 then  self.fBaudRate:=br300 else
                          if val.br=600 then  self.fBaudRate:=br600 else
                             if val.br=1200 then  self.fBaudRate:=br1200 else
                                 if val.br=2400 then  self.fBaudRate:=br2400 else
                                    if val.br=4800 then  self.fBaudRate:=br4800 else
                                       if val.br=9600 then  self.fBaudRate:=br9600 else
                                          if val.br=14400 then  self.fBaudRate:=br14400 else
                                            if val.br=19200 then  self.fBaudRate:=br19200 else
                                                if val.br=38400 then  self.fBaudRate:=br38400 else
                                                   if val.br=56000 then  self.fBaudRate:=br56000 else
                                                      if val.br=115200 then  self.fBaudRate:=br115200 else
                                                           self.fBaudRate:=br9600;

   if val.db=5 then self.fDataBits:=dbFive else
                         if val.db=6 then self.fDataBits:=dbSix else
                             if val.db=7 then self.fDataBits:=dbSeven else
                                self.fDataBits:=dbEight;

   if val.sb=3 then self.FStopBits:=sbOne5StopBits else
                          if val.sb=2 then self.FStopBits:=sbTwoStopBits else
                             self.FStopBits:=sbOneStopBit;



   if val.pt=1 then self.FParity:=prOdd else
                           if val.pt=2 then self.FParity:=prEven else
                                if val.pt=3 then self.FParity:=prMark else
                                    if val.pt=4 then self.FParity:=prSpace else
                                       self.FParity:=prNone;

   self.flCtrl:=val.flCtrl;




   self.Timeouts.ReadInterval:=val.ri;
                                  self.Timeouts.ReadTotalMultiplier:=val.rtm;
                                  self.Timeouts.ReadTotalConstant:=val.rtc;
                                  self.Timeouts.WriteTotalMultiplier:=val.wtm;
                                  self.Timeouts.WriteTotalConstant:=val.wtc;




   //self.blockSize:=val.bs;
                           self.fred:=val.red;
                           self.ftrd:=val.trd;



end;

function TMyComPort.ReadSettings: boolean;
var
  f: textFile;
  str: string;
  temp: integer;
begin
  result := true;
  fport := self.fcomset.Com;
  parity := TParityBits(self.fcomset.pt);
  baudrate := Tbaudrate(self.fcomset.br);
  stopBits := TStopBits(self.fcomset.sb);
  DataBits := TDataBits(self.fcomset.db);
 // self.blockSize:= self.fcomset.bs;
  Timeouts.ReadInterval:=self.fcomset.ri;
  Timeouts.ReadTotalMultiplier:=self.fcomset.rtm;
  Timeouts.ReadTotalConstant:=self.fcomset.rtc;
  Timeouts.WriteTotalMultiplier:=self.fcomset.wtm;
  Timeouts.ReadTotalConstant:=self.fcomset.wtc;

end;






end.


