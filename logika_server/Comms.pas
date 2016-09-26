// a FREEWARE Delphi Component
// TComPort component, version 1.71
// for Delphi 2.0, 3.0, 4.0
// written by Dejan Crnila, 1998-1999
// email: emilija.crnila@guest.arnes.si, dejan@macek.si

unit Comms;

interface

uses
  Windows, Messages, Classes, SysUtils, GenAlg, Controls;

type
  TBaudRate = (br110, br300, br600, br1200, br2400, br4800, br9600,
               br14400, br19200, br38400, br56000, br57600, br115200);
  TPortType = (COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8);
  TStopBits = (sbOneStopBit, sbOne5StopBits, sbTwoStopBits);
  TDataBits = (dbFive, dbSix, dbSeven, dbEight);
  TParityBits = (prNone, prOdd, prEven, prMark, prSpace);
  TDtrFlowControl = (dtrDisable, dtrEnable, dtrHandshake);
  TRtsFlowControl = (rtsDisable, rtsEnable, rtsHandshake, rtsToggle);
  TEvent = (evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS,
            evDSR, evError, evRLSD, evRx80Full);
  TEvents = set of TEvent;
  TSyncMethod = (smSynchronize, smWindow, smNone);
  TRxCharEvent = procedure(Sender: TObject; InQue: Integer) of object;

  TComPort = class;

  TComThread = class(TThread)
  private
    Owner: TComPort;
    Mask: DWORD;
    StopEvent: THandle;
  protected
    procedure Execute; override;
    procedure DoEvents;
    procedure SendEvents;
    procedure DispatchComMsg;
    procedure Stop;
  public
    constructor Create(AOwner: TComPort);
    destructor Destroy; override;
  end;

  TComTimeouts = class(TPersistent)
  private
    ComPort: TComPort;
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
    constructor Create(AComPort: TComPort);
  published
    property ReadInterval: Integer read FReadInterval write SetReadInterval;
    property ReadTotalMultiplier: Integer read FReadTotalM write SetReadTotalM;
    property ReadTotalConstant: Integer read FReadTotalC write SetReadTotalC;
    property WriteTotalMultiplier: Integer read FWriteTotalM write SetWriteTotalM;
    property WriteTotalConstant: Integer read FWriteTotalC write SetWriteTotalC;
  end;

  TFlowControl = class(TPersistent)
  private
    ComPort: TComPort;
    FOutCtsFlow: Boolean;
    FOutDsrFlow: Boolean;
    FControlDtr: TDtrFlowControl;
    FControlRts: TRtsFlowControl;
    FXonXoffOut: Boolean;
    FXonXoffIn:  Boolean;
    procedure SetOutCtsFlow(Value: Boolean);
    procedure SetOutDsrFlow(Value: Boolean);
    procedure SetControlDtr(Value: TDtrFlowControl);
    procedure SetControlRts(Value: TRtsFlowControl); 
    procedure SetXonXoffOut(Value: Boolean);
    procedure SetXonXoffIn(Value: Boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AComPort: TComPort);
  published
    property OutCtsFlow: Boolean read FOutCtsFlow write SetOutCtsFlow;
    property OutDsrFlow: Boolean read FOutDsrFlow write SetOutDsrFlow;
    property ControlDtr: TDtrFlowControl read FControlDtr write SetControlDtr;
    property ControlRts: TRtsFlowControl read FControlRts write SetControlRts;
    property XonXoffOut: Boolean read FXonXoffOut write SetXonXoffOut;
    property XonXoffIn:  Boolean read FXonXoffIn write SetXonXoffIn;
  end;

  TParity = class(TPersistent)
  private
    ComPort: TComPort;
    FBits: TParityBits;
    FCheck: Boolean;
    FReplace: Boolean;
    FReplaceChar: Byte;
    procedure SetBits(Value: TParityBits);
    procedure SetCheck(Value: Boolean);
    procedure SetReplace(Value: Boolean);
    procedure SetReplaceChar(Value: Byte);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AComPort: TComPort);
  published
    property Bits: TParityBits read FBits write SetBits;
    property Check: Boolean read FCheck write SetCheck;
    property Replace: Boolean read FReplace write SetReplace;
    property ReplaceChar: Byte read FReplaceChar write SetReplaceChar;
  end;

  TComPort = class(TComponent)
  private
    EventThread: TComThread;
    ThreadCreated: Boolean;
    Stack: TStack;
    FHandle: THandle;
    FWindow: THandle;
    FConnected: Boolean;
    FBaudRate: TBaudRate;
    FPort: TPortType;
    FStopBits: TStopBits;
    FDataBits: TDataBits;
    FDiscardNull: Boolean;
    FEventChar: Byte;
    FEvents: TEvents;
    FWriteBufSize: DWORD;
    FReadBufSize: DWORD;
    FParity: TParity;
    FTimeouts: TComTimeouts;
    FFlowControl: TFlowControl;
    FSyncMethod: TSyncMethod;
    FOnRxChar: TRxCharEvent;
    FOnTxEmpty: TNotifyEvent;
    FOnBreak: TNotifyEvent;
    FOnRing: TNotifyEvent;
    FOnCTS: TNotifyEvent;
    FOnDSR: TNotifyEvent;
    FOnRLSD: TNotifyEvent;
    FOnError: TNotifyEvent;
    FOnRxFlag: TNotifyEvent;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FOnRx80Full: TNotifyEvent;
    procedure SetBaudRate(Value: TBaudRate);
    procedure SetPort(Value: TPortType);
    procedure SetStopBits(Value: TStopBits);
    procedure SetDataBits(Value: TDataBits);
    procedure SetDiscardNull(Value: Boolean);
    procedure SetEventChar(Value: Byte);
    procedure SetWriteBufSize(Value: DWORD);
    procedure SetReadBufSize(Value: DWORD);
    procedure SetSyncMethod(Value: TSyncMethod);
    procedure DoOnRxChar;
    procedure DoOnTxEmpty;
    procedure DoOnBreak;
    procedure DoOnRing;
    procedure DoOnRxFlag;
    procedure DoOnCTS;
    procedure DoOnDSR;
    procedure DoOnError;
    procedure DoOnRLSD;
    procedure DoOnRx80Full;
    procedure InitOverlapped(var PO: POverlapped);
    procedure DoneOverlapped(var PO: POverlapped);
    function ComString: String;
  protected
    procedure CreateHandle;
    procedure DestroyHandle;
    procedure SetTimeouts;
    procedure SetDCB;
    procedure SetComm;
    procedure SetupComPort;
    procedure WindowMethod(var Message: TMessage);
  public
    property Connected: Boolean read FConnected;
    property Handle: THandle read FHandle;
    procedure Open;
    procedure Close;
    function InQue: DWORD;
    function OutQue: DWORD;
    function HighCTS: Boolean;
    function HighDSR: Boolean;
    function HighRLSD: Boolean;
    function HighRing: Boolean;
    procedure SetDTR(State: Boolean);
    procedure SetRTS(State: Boolean);
    procedure SetXonXoff(State: Boolean);
    procedure SetBreak(State: Boolean);
    function Write(var Buffer; Count: DWORD; WaitFor: Boolean): DWORD;
    function WriteString(Str: String; WaitFor: Boolean): DWORD;
    function Read(var Buffer; Count: DWORD; WaitFor: Boolean): DWORD;
    function ReadString(var Str: String; Count: DWORD; WaitFor: Boolean): DWORD;
    function PendingIO: Boolean;
    function WaitForLastIO: DWORD;
    procedure AbortAllIO;
    procedure ShowPropForm;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate;
    property Port: TPortType read FPort write SetPort;
    property Parity: TParity read FParity write FParity;
    property StopBits: TStopBits read FStopBits write SetStopBits;
    property DataBits: TDataBits read FDataBits write SetDataBits;
    property DiscardNull: Boolean read FDiscardNull write SetDiscardNull;
    property EventChar: Byte read FEventChar write SetEventChar;
    property Events: TEvents read FEvents write FEvents;
    property WriteBufSize: DWORD read FWriteBufSize write SetWriteBufSize;
    property ReadBufSize: DWORD read FReadBufSize write SetReadBufSize;
    property FlowControl: TFlowControl read FFlowControl write FFlowControl;
    property Timeouts: TComTimeouts read FTimeouts write FTimeouts;
    property SyncMethod: TSyncMethod read FSyncMethod write SetSyncMethod;
    property OnRxChar: TRxCharEvent read FOnRxChar write FOnRxChar;
    property OnTxEmpty: TNotifyEvent read FOnTxEmpty write FOnTxEmpty;
    property OnBreak: TNotifyEvent read FOnBreak write FOnBreak;
    property OnRing: TNotifyEvent read FOnRing write FOnRing;
    property OnCTS: TNotifyEvent read FOnCTS write FOnCTS;
    property OnDSR: TNotifyEvent read FOnDSR write FOnDSR;
    property OnRLSD: TNotifyEvent read FOnRLSD write FOnRLSD;
    property OnRxFlag: TNotifyEvent read FOnRxFlag write FOnRxFlag;
    property OnError: TNotifyEvent read FOnError write FOnError;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnRx80Full: TNotifyEvent read FOnRx80Full
                                      write FOnRx80Full;
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

// TComThread

constructor TComThread.Create(AOwner: TComPort);
var
  AMask: DWORD;
begin
  inherited Create(True);
  StopEvent := CreateEvent(nil, True, False, nil);
  Owner := AOwner;
  AMask := 0;
  if evRxChar in Owner.FEvents then AMask := AMask or EV_RXCHAR;
  if evRxFlag in Owner.FEvents then AMask := AMask or EV_RXFLAG;
  if evTxEmpty in Owner.FEvents then AMask := AMask or EV_TXEMPTY;
  if evRing in Owner.FEvents then AMask := AMask or EV_RING;
  if evCTS in Owner.FEvents then AMask := AMask or EV_CTS;
  if evDSR in Owner.FEvents then AMask := AMask or EV_DSR;
  if evRLSD in Owner.FEvents then AMask := AMask or EV_RLSD;
  if evError in Owner.FEvents then AMask := AMask or EV_ERR;
  if evBreak in Owner.FEvents then AMask := AMask or EV_BREAK;
  if evRx80Full in Owner.FEvents then AMask := AMask or EV_RX80FULL;
  SetCommMask(Owner.FHandle, AMask);
  Resume;
end;

procedure TComThread.Execute;
var
  EventHandles: Array[0..1] of THandle;
  Overlapped: TOverlapped;
  Signaled, BytesTrans: DWORD;
begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);
  EventHandles[0] := StopEvent;
  EventHandles[1] := Overlapped.hEvent;
  repeat
    WaitCommEvent(Owner.FHandle, Mask, @Overlapped);
    Signaled := WaitForMultipleObjects(2, PWOHandleArray(@EventHandles), False, INFINITE);
    case Signaled of
      WAIT_OBJECT_0: Break;
      WAIT_OBJECT_0 + 1: if GetOverlappedResult(Owner.FHandle, Overlapped,
                              BytesTrans, False) then DispatchComMsg;
      else Break;
    end;
  until False;
  PurgeComm(Owner.FHandle, PURGE_TXABORT or PURGE_RXABORT or
     PURGE_TXCLEAR or PURGE_RXCLEAR);
  CloseHandle(Overlapped.hEvent);
  CloseHandle(StopEvent);
end;

procedure TComThread.Stop;
begin
  SetEvent(StopEvent);
end;

destructor TComThread.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TComThread.DispatchComMsg;
begin
  if (Owner.SyncMethod = smSynchronize) then
    Synchronize(DoEvents)
  else
    if (Owner.SyncMethod = smWindow) then
      SendEvents
    else
      DoEvents;
end;

procedure TComThread.SendEvents;
begin
  if (EV_RXCHAR and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_RXCHAR, 0);
  if (EV_TXEMPTY and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_TXEMPTY, 0);
  if (EV_BREAK and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_BREAK, 0);
  if (EV_RING and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_RING, 0);
  if (EV_CTS and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_CTS, 0);
  if (EV_DSR and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_DSR, 0);
  if (EV_RXFLAG and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_RXFLAG, 0);
  if (EV_RLSD and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_RLSD, 0);
  if (EV_ERR and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_ERR, 0);
  if (EV_RX80FULL and Mask) > 0 then
    SendMessage(Owner.FWindow, CM_COMPORT, EV_RX80FULL, 0);
end;

procedure TComThread.DoEvents;
begin
  if (EV_RXCHAR and Mask) > 0 then Owner.DoOnRxChar;
  if (EV_TXEMPTY and Mask) > 0 then Owner.DoOnTxEmpty;
  if (EV_BREAK and Mask) > 0 then Owner.DoOnBreak;
  if (EV_RING and Mask) > 0 then Owner.DoOnRing;
  if (EV_CTS and Mask) > 0 then Owner.DoOnCTS;
  if (EV_DSR and Mask) > 0 then Owner.DoOnDSR;
  if (EV_RXFLAG and Mask) > 0 then Owner.DoOnRxFlag;
  if (EV_RLSD and Mask) > 0 then Owner.DoOnRLSD;
  if (EV_ERR and Mask) > 0 then Owner.DoOnError;
  if (EV_RX80FULL and Mask) > 0 then Owner.DoOnRx80Full;
end;

// TComTimeouts

constructor TComTimeouts.Create(AComPort: TComPort);
begin
  ComPort := AComPort;
  FReadInterval := -1;
  FWriteTotalM := 100;
  FWriteTotalC := 1000;
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

// TFlowControl

constructor TFlowControl.Create(AComPort: TComPort);
begin
  ComPort := AComPort;
end;

procedure TFlowControl.AssignTo(Dest: TPersistent);
begin
  if Dest is TFlowControl then begin
    with TFlowControl(Dest) do begin
      FOutCtsFlow := Self.FOutCtsFlow;
      FOutDsrFlow := Self.FOutDsrFlow;
      FControlDtr := Self.FControlDtr;
      FControlRts := Self.FControlRts;
      FXonXoffOut := Self.FXonXoffOut;
      FXonXoffIn  := Self.FXonXoffIn;
      ComPort     := Self.ComPort;
    end
  end
  else
    inherited AssignTo(Dest);
end;

procedure TFlowControl.SetControlDtr(Value: TDtrFlowControl);
begin
  if Value <> FControlDtr then begin
    FControlDtr := Value;
    ComPort.SetDCB;
  end;
end;

procedure TFlowControl.SetControlRts(Value: TRtsFlowControl);
begin
  if Value <> FControlRts then begin
    FControlRts := Value;
    ComPort.SetDCB;
  end;
end;

procedure TFlowControl.SetOutCtsFlow(Value: Boolean);
begin
  if Value <> FOutCtsFlow then begin
    FOutCtsFlow := Value;
    ComPort.SetDCB;
  end;
end;

procedure TFlowControl.SetOutDsrFlow(Value: Boolean);
begin
  if Value <> FOutDsrFlow then begin
    FOutDsrFlow := Value;
    ComPort.SetDCB;
  end;
end;

procedure TFlowControl.SetXonXoffIn(Value: Boolean);
begin
  if Value <> FXonXoffIn then begin
    FXonXoffIn := Value;
    ComPort.SetDCB;
  end;
end;

procedure TFlowControl.SetXonXoffOut(Value: Boolean);
begin
  if Value <> FXonXoffOut then begin
    FXonXoffOut := Value;
    ComPort.SetDCB;
  end;
end;

// TParity

constructor TParity.Create(AComPort: TComPort);
begin
  ComPort := AComPort;
end;

procedure TParity.AssignTo(Dest: TPersistent);
begin
  if Dest is TParity then begin
    with TParity(Dest) do begin
      FBits        := Self.FBits;
      FCheck       := Self.FCheck;
      FReplace     := Self.FReplace;
      FReplaceChar := Self.FReplaceChar;
      ComPort      := Self.ComPort;
    end
  end
  else
    inherited AssignTo(Dest);
end;

procedure TParity.SetBits(Value: TParityBits);
begin
  if Value <> FBits then begin
    FBits := Value;
    ComPort.SetDCB;
  end;
end;

procedure TParity.SetCheck(Value: Boolean);
begin
  if Value <> FCheck then begin
    FCheck := Value;
    ComPort.SetDCB;
  end;
end;

procedure TParity.SetReplace(Value: Boolean);
begin
  if Value <> FReplace then begin
    FReplace := Value;
    ComPort.SetDCB;
  end;
end;

procedure TParity.SetReplaceChar(Value: Byte);
begin
  if Value <> FReplaceChar then begin
    FReplaceChar := Value;
    ComPort.SetDCB;
  end;
end;

// TComPort

constructor TComPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnected := False;
  FBaudRate := br9600;
  FPort := COM1;
  FStopBits := sbOneStopBit;
  FDataBits := dbEight;
  FEvents := [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak,
             evCTS, evDSR, evError, evRLSD, evRx80Full];
  FWriteBufSize := 1024;
  FReadBufSize := 1024;
  FHandle := INVALID_HANDLE_VALUE;
  FParity := TParity.Create(Self);
  FFlowControl := TFlowControl.Create(Self);
  FTimeouts := TComTimeouts.Create(Self);
  Stack := TStack.Create;
end;

destructor TComPort.Destroy;
begin
  Close;
  Stack.Free;
  FFlowControl.Free;
  FTimeouts.Free;
  FParity.Free;
  inherited Destroy;
end;

procedure TComPort.CreateHandle;
begin
  FHandle := CreateFile(
    PChar(ComString),
    GENERIC_READ or GENERIC_WRITE,
    0,
    nil,
    OPEN_EXISTING,
    FILE_FLAG_OVERLAPPED,
    0);

  if FHandle = INVALID_HANDLE_VALUE then
    raise EComPort.Create('Unable to open com port: ' + LastErr);
end;

procedure TComPort.DestroyHandle;
begin
  if FHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FHandle);
end;

procedure TComPort.WindowMethod(var Message: TMessage);
begin
  with Message do
    if Msg = CM_COMPORT then begin
      if (wParam = EV_RXCHAR) then DoOnRxChar;
      if (wParam = EV_TXEMPTY) then DoOnTxEmpty;
      if (wParam = EV_BREAK) then DoOnBreak;
      if (wParam = EV_RING) then DoOnRing;
      if (wParam = EV_CTS) then DoOnCTS;
      if (wParam = EV_DSR) then DoOnDSR;
      if (wParam = EV_RXFLAG) then DoOnRxFlag;
      if (wParam = EV_RLSD) then DoOnRLSD;
      if (wParam = EV_ERR) then DoOnError;
      if (wParam = EV_RX80FULL) then DoOnRx80Full;
    end else
      Result := DefWindowProc(FWindow, Msg, wParam, lParam);
end;

procedure TComPort.Open;
begin
  Close;
  CreateHandle;
  FConnected := True;
  try
    SetupComPort;
  except
    DestroyHandle;
    FConnected := False;
    raise;
  end;
  if (FSyncMethod = smWindow) then
    FWindow := AllocateHWnd(WindowMethod);
  if (FEvents = []) then
    ThreadCreated := False
  else begin
    EventThread := TComThread.Create(Self);
    ThreadCreated := True;
  end;
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TComPort.Close;
begin
  if FConnected then begin
    AbortAllIO;
    if ThreadCreated then
      EventThread.Free;
    DestroyHandle;
    FConnected := False;
    if FSyncMethod = smWindow then
      DeallocateHWnd(FWindow);
    if Assigned(FOnClose) then
      FOnClose(Self);
  end;
end;

procedure TComPort.SetTimeouts;
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

procedure TComPort.SetDCB;
var
  DCB: TDCB;
  Temp: DWORD;
begin
  if FConnected then begin
    FillChar(DCB, SizeOf(DCB), 0);

    DCB.DCBlength := SizeOf(DCB);
    DCB.XonChar := #17;
    DCB.XoffChar := #19;
    DCB.XonLim := FReadBufSize div 4;
    DCB.XoffLim := DCB.XonLim;
    DCB.EvtChar := Char(FEventChar);

    DCB.Flags := DCB.Flags or dcb_Binary;
    if FDiscardNull then
      DCB.Flags := DCB.Flags or dcb_Null;

    with FFlowControl do begin
      if FOutCtsFlow then
        DCB.Flags := DCB.Flags or dcb_OutxCtsFlow;
      if FOutDsrFlow then
        DCB.Flags := DCB.Flags or dcb_OutxDsrFlow;
      Temp := 0;
      case FControlDtr of
        dtrDisable:   Temp := DTR_CONTROL_DISABLE;
        dtrEnable:    Temp := DTR_CONTROL_ENABLE;
        dtrHandshake: Temp := DTR_CONTROL_HANDSHAKE;
      end;
      DCB.Flags := DCB.Flags or Integer(dcb_DtrControl and (Temp shl 4));
      case FControlRts of
        rtsDisable:   Temp := RTS_CONTROL_DISABLE;
        rtsEnable:    Temp := RTS_CONTROL_ENABLE;
        rtsHandshake: Temp := RTS_CONTROL_HANDSHAKE;
        rtsToggle:    Temp := RTS_CONTROL_TOGGLE;
      end;
      DCB.Flags := DCB.Flags or Integer(dcb_RtsControl and (Temp shl 12));
      if FXonXoffOut then
        DCB.Flags := DCB.Flags or dcb_OutX;
      if FXonXoffIn then
        DCB.Flags := DCB.Flags or dcb_InX;
    end;

    case FParity.FBits of
      prNone:  DCB.Parity := NOPARITY;
      prOdd:   DCB.Parity := ODDPARITY;
      prEven:  DCB.Parity := EVENPARITY;
      prMark:  DCB.Parity := MARKPARITY;
      prSpace: DCB.Parity := SPACEPARITY;
    end;

    if FParity.FCheck then
      DCB.Flags := DCB.Flags or dcb_Parity;

    if FParity.FReplace then begin
      DCB.Flags := DCB.Flags or dcb_ErrorChar;
      DCB.ErrorChar := Char(FParity.ReplaceChar);
    end;

    case FStopBits of
      sbOneStopBit:   DCB.StopBits := ONESTOPBIT;
      sbOne5StopBits: DCB.StopBits := ONE5STOPBITS;
      sbTwoStopBits:  DCB.StopBits := TWOSTOPBITS;
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

    if not SetCommState(FHandle, DCB) then
      raise EComPort.Create('Unable to set com state: ' + LastErr);
  end;
end;

procedure TComPort.SetComm;
begin
  if FConnected then begin
    if not SetupComm(FHandle, FReadBufSize, FWriteBufSize) then
      raise EComPort.Create('Unable to set com state: ' + LastErr);
  end;
end;

procedure TComPort.SetupComPort;
begin
  SetComm;
  SetDCB;
  SetTimeouts;
end;

function TComPort.InQue: DWORD;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
  if not ClearCommError(FHandle, Errors, @ComStat) then
    raise EComPort.Create('Unable to read com status: ' + LastErr);
  Result := ComStat.cbInQue;
end;

function TComPort.OutQue: DWORD;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
  if not ClearCommError(FHandle, Errors, @ComStat) then
    raise EComPort.Create('Unable to read com status: ' + LastErr);
  Result := ComStat.cbOutQue;
end;

function TComPort.HighCTS: Boolean;
var
  Status: DWORD;
begin
  if not GetCommModemStatus(FHandle, Status) then
    raise EComPort.Create('Unable to read com status: ' + LastErr);
  Result := (MS_CTS_ON and Status) <> 0
end;

function TComPort.HighDSR: Boolean;
var
  Status: DWORD;
begin
  if not GetCommModemStatus(FHandle, Status) then
    raise EComPort.Create('Unable to read com status: ' + LastErr);
  Result := (MS_DSR_ON and Status) <> 0
end;

function TComPort.HighRLSD: Boolean;
var
  Status: DWORD;
begin
  if not GetCommModemStatus(FHandle, Status) then
    raise EComPort.Create('Unable to read com status: ' + LastErr);
  Result := (MS_RLSD_ON and Status) <> 0
end;

function TComPort.HighRing: Boolean;
var
  Status: DWORD;
begin
  if not GetCommModemStatus(FHandle, Status) then
    raise EComPort.Create('Unable to read com status: ' + LastErr);
  Result := (MS_RING_ON and Status) <> 0
end;

procedure TComPort.SetBreak(State: Boolean);
var
  Act: DWORD;
begin
  if State then
    Act := Windows.SETBREAK
  else
    Act := Windows.CLRBREAK;

  if not EscapeCommFunction(FHandle, Act) then
    raise EComPort.Create('Unable to set signal: ' + LastErr);
end;

procedure TComPort.SetDTR(State: Boolean);
var
  Act: DWORD;
begin
  if State then
    Act := Windows.SETDTR
  else
    Act := Windows.CLRDTR;

  if not EscapeCommFunction(FHandle, Act) then
    raise EComPort.Create('Unable to set signal: ' + LastErr);
end;

procedure TComPort.SetRTS(State: Boolean);
var
  Act: DWORD;
begin
  if State then
    Act := Windows.SETRTS
  else
    Act := Windows.CLRRTS;

  if not EscapeCommFunction(FHandle, Act) then
    raise EComPort.Create('Unable to set signal: ' + LastErr);
end;

procedure TComPort.SetXonXoff(State: Boolean);
var
  Act: DWORD;
begin
  if State then
    Act := Windows.SETXON
  else
    Act := Windows.SETXOFF;

  if not EscapeCommFunction(FHandle, Act) then
    raise EComPort.Create('Unable to set signal: ' + LastErr);
end;

function TComPort.Write(var Buffer; Count: DWORD; WaitFor: Boolean): DWORD;
var
  Success, Pending, Pop: Boolean;
  ErrCode, BytesTrans: DWORD;
  PO: POverlapped;
begin
  InitOverlapped(PO);
  Stack.Push(PO);
  Pending := False;
  Pop := True;

  Success := WriteFile(FHandle, Buffer, Count, BytesTrans, PO);
  if not Success then begin
    ErrCode := GetLastError;
    if ErrCode = ERROR_IO_PENDING then begin
      if WaitFor then begin
        BytesTrans := WaitForLastIO;
        Success := True;
      end
      else
        Pending := True;
      Pop := False;
    end
  end;

  if Pop then begin
    PO := Stack.Pop;
    DoneOverlapped(PO);
  end;

  if not (Success or Pending) then
    raise EComPort.Create('Operation failed: ' + LastErr);

  if Pending then
    Result := NOT_FINISHED
  else
    Result := BytesTrans;
end;

function TComPort.WriteString(Str: String; WaitFor: Boolean): DWORD;
var
  Success, Pending, Pop: Boolean;
  ErrCode, BytesTrans: DWORD;
  PO: POverlapped;
begin
  InitOverlapped(PO);
  Stack.Push(PO);
  Pending := False;
  Pop := True;

  Success := WriteFile(FHandle, Str[1], Length(Str), BytesTrans, PO);
  if not Success then begin
    ErrCode := GetLastError;
    if ErrCode = ERROR_IO_PENDING then begin
      if WaitFor then begin
        BytesTrans := WaitForLastIO;
        Success := True;
      end else
        Pending := True;
      Pop := False;
    end;
  end;

  if Pop then begin
    PO := Stack.Pop;
    DoneOverlapped(PO);
  end;

  if not (Success or Pending) then
    raise EComPort.Create('Operation failed: ' + LastErr);

  if Pending then
    Result := NOT_FINISHED
  else
    Result := BytesTrans;
end;

function TComPort.Read(var Buffer; Count: DWORD; WaitFor: Boolean): DWORD;
var
  Success, Pending, Pop: Boolean;
  ErrCode, BytesTrans: DWORD;
  PO: POverlapped;
begin
  InitOverlapped(PO);
  Stack.Push(PO);
  Pending := False;
  Pop := True;

  Success := ReadFile(FHandle, Buffer, Count, BytesTrans, PO);
  if not Success then begin
    ErrCode := GetLastError;
    if ErrCode = ERROR_IO_PENDING then begin
      if WaitFor then begin
        BytesTrans := WaitForLastIO;
        Success := True;
      end else
        Pending := True;
      Pop := False;
    end;
  end;

  if Pop then begin
    PO := Stack.Pop;
    DoneOverlapped(PO);
  end;

  if not (Success or Pending) then
    raise EComPort.Create('Operation failed: ' + LastErr);

  if Pending then
    Result := NOT_FINISHED
  else
    Result := BytesTrans;
end;

function TComPort.ReadString(var Str: String; Count: DWORD; WaitFor: Boolean): DWORD;
var
  Success, Pending, Pop: Boolean;
  ErrCode, BytesTrans: DWORD;
  PO: POverlapped;
begin
  SetLength(Str, Count);

  InitOverlapped(PO);
  Stack.Push(PO);
  Pending := False;
  Pop := True;

  Success := ReadFile(FHandle, Str[1], Count, BytesTrans, PO);
  if not Success then begin
    ErrCode := GetLastError;
    if ErrCode = ERROR_IO_PENDING then begin
      if WaitFor then begin
        BytesTrans := WaitForLastIO;
        Success := True;
      end else
        Pending := True;
      Pop := False;
    end;
  end;

  if Pop then begin
    PO := Stack.Pop;
    DoneOverlapped(PO);
  end;

  if not (Success or Pending) then
    raise EComPort.Create('Operation aborted: ' + LastErr);

  if Pending then
    Result := NOT_FINISHED
  else
    Result := BytesTrans;
end;

function TComPort.PendingIO: Boolean;
begin
  Result := not Stack.IsEmpty;
end;

function TComPort.WaitForLastIO: DWORD;
var
  Signaled, BytesTrans: DWORD;
  Success: Boolean;
  PO: POverlapped;
begin
  if PendingIO then begin
    PO := Stack.Pop;
    Signaled := WaitForSingleObject(PO^.hEvent, INFINITE);

    Success := (Signaled = WAIT_OBJECT_0) and
          (GetOverlappedResult(FHandle, PO^, BytesTrans, False));

    DoneOverlapped(PO);
    if Success then
      Result := BytesTrans
    else
      raise EComPort.Create('Operation failed: ' + LastErr);
  end else
    Result := NO_OPERATION;
end;

procedure TComPort.AbortAllIO;
var
  PO: POverlapped;
begin
  if PendingIO then begin
    try
      if not PurgeComm(FHandle, PURGE_TXABORT or PURGE_RXABORT) then
        raise EComPort.Create('Cannot abort operation: ' + LastErr);
    finally
      while (not Stack.IsEmpty) do begin
        PO := Stack.Pop;
        DoneOverlapped(PO);
      end;
    end;
  end;
end;

procedure TComPort.ShowPropForm;
begin
end;

procedure TComPort.SetBaudRate(Value: TBaudRate);
begin
  if Value <> FBaudRate then begin
    FBaudRate := Value;
    SetDCB;
  end;
end;

procedure TComPort.SetDataBits(Value: TDataBits);
begin
  if Value <> FDataBits then begin
    FDataBits := Value;
    SetDCB;
  end;
end;

procedure TComPort.SetDiscardNull(Value: Boolean);
begin
  if Value <> FDiscardNull then begin
    FDiscardNull := Value;
    SetDCB;
  end;
end;

procedure TComPort.SetEventChar(Value: Byte);
begin
  if Value <> FEventChar then begin
    FEventChar := Value;
    SetDCB;
  end;
end;

procedure TComPort.SetPort(Value: TPortType);
begin
  if Value <> FPort then begin
    FPort := Value;
    if FConnected then begin
      Close;
      Open;
    end;
  end;
end;

procedure TComPort.SetReadBufSize(Value: DWORD);
begin
  if Value <> FReadBufSize then begin
    FReadBufSize := Value;
    SetComm;
  end;
end;

procedure TComPort.SetStopBits(Value: TStopBits);
begin
  if Value <> FStopBits then begin
    FStopBits := Value;
    SetDCB;
  end;
end;

procedure TComPort.SetWriteBufSize(Value: DWORD);
begin
  if Value <> FWriteBufSize then begin
    FWriteBufSize := Value;
    SetComm;
  end;
end;

procedure TComPort.SetSyncMethod(Value: TSyncMethod);
begin
  if Value <> FSyncMethod then begin
    if FConnected then
      raise EComPort.Create('Cannot set SyncMethod while connected')
    else
      FSyncMethod := Value;
  end;
end;

procedure TComPort.DoOnRxChar;
begin
  if Assigned(FOnRxChar) then FOnRxChar(Self, Integer(InQue));
end;

procedure TComPort.DoOnBreak;
begin
  if Assigned(FOnBreak) then FOnBreak(Self);
end;

procedure TComPort.DoOnRing;
begin
  if Assigned(FOnRing) then FOnRing(Self);
end;

procedure TComPort.DoOnTxEmpty;
begin
  if Assigned(FOnTxEmpty) then FOnTxEmpty(Self);
end;

procedure TComPort.DoOnCTS;
begin
  if Assigned(FOnCTS) then FOnCTS(Self);
end;

procedure TComPort.DoOnDSR;
begin
  if Assigned(FOnDSR) then FOnDSR(Self);
end;

procedure TComPort.DoOnRLSD;
begin
  if Assigned(FOnRLSD) then FOnRLSD(Self);
end;

procedure TComPort.DoOnError;
begin
  if Assigned(FOnError) then FOnError(Self);
end;

procedure TComPort.DoOnRxFlag;
begin
  if Assigned(FOnRxFlag) then FOnRxFlag(Self);
end;

procedure TComPort.DoOnRx80Full;
begin
  if Assigned(FOnRx80Full) then FOnRx80Full(Self);
end;

procedure TComPort.InitOverlapped(var PO: POverlapped);
begin
  New(PO);
  FillChar(PO^, SizeOf(TOverlapped), 0);
  PO^.hEvent := CreateEvent(nil, True, False, nil);
end;

procedure TComPort.DoneOverlapped(var PO: POverlapped);
begin
  CloseHandle(PO^.hEvent);
  Dispose(PO);
end;

function TComPort.ComString: String;
begin
  case FPort of
    COM1: Result := 'COM1';
    COM2: Result := 'COM2';
    COM3: Result := 'COM3';
    COM4: Result := 'COM4';
    COM5: Result := 'COM5';
    COM6: Result := 'COM6';
    COM7: Result := 'COM7';
    COM8: Result := 'COM8';
  end;
end;

end.
