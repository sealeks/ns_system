unit EtherServerU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, InterfaceServerU, constdef;

const
  HEIAPIVersion: word = 3;

const
  HEIP_HOST: word = 1;

const
  HEIP_IPX: word = 2;

const
  HEIP_IP: word = 3;   ///

const
  HEIT_HOST: integer = 1;

const
  HEIT_IPX: integer = 2;

const
  HEIT_WINSOCK: word = 4; ////

const
  HEIT_OTHER_TRANSPORT: integer = 8;

const
  HEIT_UNIX: integer = 16;



type
  Encryption = record
    Algorithm: byte;
    Unused: array [0..3] of byte;
    Key: array [0..60] of byte;
  end;

  AddressingType = record
    case byte of
      0: (b1, b2, b3, b4: char);
      1: (w1, w2: word);
      2: (iAddr: longword);
  end;

  AddressHalf = record

    case integer of
      // HOST
      0: (Famaly: smallint;
        Nodenum: array [0..6] of char;
        LANNum: word);
      // IPX
      1: (Famaly1: smallint;
        NetNum: array [0..4] of char;
        Nodenum1: array [0..6] of char;
        LANNum1: word);
      // IP
      2: (Famaly2: smallint;
        Port: word;
        AddrType: AddressingType;
        Zero: array [0..8] of char;);
  end;

  Address = record
    Addr: AddressHalf;
    Raw: array [0..20] of byte;
  end;

  ENetaddress = record
    ENetaddress: Address;
  end;

  pENetaddress = ^ENetaddress;

  HEITransport = record
    Transport: word;
    Protocol: word;
    Encrypt: Encryption;
    ENeyAddress: pENetaddress;
    Reserved: array  [0..48] of byte;
  end;

  pHEITransport = ^HEITransport;

  HEIDevice = record
    Address: Address;
    wParam: word;
    dw_Param: DWORD;
    Timeout: word;
    Retrys: word;
    EnetAddress: array  [0..5] of byte;
    RetryCount: word;
    BadCRCCount: word;
    LatePacketCount: word;
    ParallelPackets: boolean;
    UseAddressedBroadcast: boolean;
    UseBroadcast: boolean;
    dwParam: DWORD;
    DataOffset: word;
    pTransport: pHEITransport;
    SizeOfData: integer;
    pData: ^byte;
    pBuffer: ^integer;
    LastAppVal: word;
    UseProxy: byte;
    ProxyBase: byte;
    ProxySlot: byte;
    ProxyDevNum: byte;
    Reserved: array [0..44] of byte;
  end;

  Devicedef = record
    PLCFamily: byte;
    PLCTYPE: byte;
    ModuleType: byte;
    StatusCode: byte;
    EthernetAddress: array [0..6] of byte;
    RamSize: word;
    FlashSize: word;
    DIPSettings: byte;
    MediaType: byte;
    EPFCount: DWORD;
    Status: byte;
    RunRelay: byte;
    BattLow: byte;
    UnusedBits: byte;
    BattRamSize: word;
    ExtraDIPS: byte;
    ModelNumber: byte;
    EtherSpeed: byte;
    PLDRev: array [0..2] of byte;
    Unused: array [0..14] of byte;
  end;

  arDevicedef = array [0..20] of ^Devicedef;

  parDevicedef = ^arDevicedef;

  pByte = ^byte;

  pInt = ^integer;

  pLongInt = ^longint;

  pHEIDevice = ^Heidevice;

  parByte = array [0..3] of byte;

  pBuf = ^parByte;


  arInt = array [0..20] of integer;

  parInt = ^arInt;

  BufWord = array [0..20] of word;

  pBufWord = ^BufWord;

  arpHEIDevice = array [0..20] of pHEIDevice;
  parHEIDevice = ^arpHEIDevice;

type
  DeviceI = class
  public
    NumDev: pWord;
    pData: pInt;
    id: integer;
    Timeout: word;
    retry: word;
    pdefdef: Devicedef;
    UseAddr: boolean;
    dev: Heidevice;
    connected: boolean;
    ererrorInit: integer;
    errorread: integer;
    errorrwrite: integer;
    them: string;
    constructor Create;
    destructor Destroy;
  end;

type
  TEtherServer = class(TInterfaceServer)
  private
    TPs: HEITransport;
    Dev: pHEIDevice;
    rc: integer;
    pdefdef: parDevicedef;
    DDSize: word;
    pBufer: pBuf;
    retryErr: integer;
    fServerName: string;

  public
    blockSize: integer;
    Devise: DeviceI;
    FConnected: boolean;
    erropen: byte;
    ftime: TTime;
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    function ConnectDriver: integer;
    function DisConnectDriver: integer;

    procedure ConnectDevise();
    procedure DisConnectDevise();

    procedure Connect;
    procedure Disconnect;


    function PLCWriteString(slaveNumber: byte; startAddress: integer;
      NewValue: string): integer; override;
    function PLCReadString1(slaveNumber: byte; startAddress, dataSize: integer;
      var Data: string): integer; override;
    function ReadSettings: boolean; override;

    procedure setProperty();

    function Open: boolean; override;
    procedure Close; override;
    { Public declarations }
  published
    { Published declarations }
  end;

function PASCAL_HEIOpen(Ver: word): integer; stdcall; external 'hei_pas.dll';
function PASCAL_HEIClose: integer; stdcall; external 'hei_pas.dll';
function PASCAL_HEIOpenTransport(TP: PHEITransport;
  HEIAPIVersion: word; EnetAdress: longint): integer; stdcall; external 'hei_pas.dll';
function PASCAL_HEICloseTransport(TP: PHEITransport): integer;
  stdcall; external 'hei_pas.dll';
function PASCAL_HEIQueryDeviceData(TP: pHEITransport; Device: pHEIDevice;
  DeviceCount: pWord; HEIAPIVersion: word; DataType: word; pData: parByte;
  SizeofData: word): integer; stdcall; external 'hei_pas.dll';
function PASCAL_HEIOpenDevice(TP: pHEITransport; device: pHEIDevice;
  HEIAPIVersion: word; Timeout: word;
  Retrys: word; UseAddressedBroadcast: boolean): integer;
  stdcall; external 'hei_pas.dll';
function PASCAL_HEICloseDevice(device: pHEIDevice): integer;
  stdcall; external 'hei_pas.dll';
function PASCAL_HEIReadDeviceDef(device: pHEIDevice; pModuleDefInfo: parDevicedef;
  DDSize: word): integer; stdcall; external 'hei_pas.dll';
function PASCAL_HEICCMRequest(device: pHEIDevice; bWrite: boolean; DataType: byte;
  DataAddress: word; DataLength: word; pBuffer: Pbuf): integer;
  stdcall; external 'hei_pas.dll';
function PASCAL_HEIQueryDevices(P: pHEITransport; Device: pHEIDevice;
  DeviceCount: pWord; HEIAPIVersion: word): integer; stdcall; external 'hei_pas.dll';

implementation

constructor DeviceI.Create;
begin
  inherited Create;
  connected := False;
  ererrorInit := -1;
  ;
  new(dev.pData);
  UseAddr := True;
end;

destructor DeviceI.Destroy;
begin
  id := id;
  timeout := timeout;
  retry := retry;
  inherited Destroy;
end;

constructor TEtherServer.Create(aOwner: TComponent);
begin
  inherited;
  FConnected := False;

  erropen := 0;
  Devise := DeviceI.Create;
  new(Devise.NumDev);
  new(Devise.pData);
end;

destructor TEtherServer.Destroy;
begin
  DisConnect;
  dispose(Devise.pData);
  dispose(Devise.NumDev);
  Devise.Free;
  inherited Destroy;
end;




//- ������� ��������-----

function TEtherServer.ConnectDriver: integer;
var
  rc: integer;
begin
  if FConnected then
    exit;
  FConnected := False;
  rc := PASCAL_HEIOpen(HEIAPIVersion);
  if rc <> 0 then
  begin
    erropen := rc;
    exit;
  end;

  new(tps.ENeyAddress);
  rc := PASCAL_HEIOpenTransport(addr(TPS), HEIAPIVersion, 0);
  if rc <> 0 then
  begin
    erropen := rc;     //�� ������� ���������������� ���������','������!',MB_OK);
    rc := PASCAL_HEIClose;
  end
  else
    FConnected := True;
end;

function TEtherServer.DisConnectDriver: integer;
begin
  if FConnected then
  begin
    PASCAL_HEICloseTransport(@TPs);
    dispose(tps.ENeyAddress);
    PASCAL_HEIClose;
  end;
  FConnected := False;
end;




procedure TEtherServer.ConnectDevise();
begin
  Devise.ererrorInit := 0;
  Devise.NumDev^ := 1;
  if not FConnected then
    exit;
  rc := PASCAL_HEIQueryDeviceData(@TPs, @Devise.dev, Devise.NumDev,
    HEIAPIVersion, 32, ParByte(Devise.pData), 4);
  if rc <> 0 then
  begin
    Devise.ererrorInit := rc;
    exit;
  end;
  if Devise.numDev^ > 1 then
  begin
    Devise.ererrorInit := -2;
    exit;
  end;
  if Devise.numDev^ < 1 then
  begin
    Devise.ererrorInit := -1;
    exit;
  end;
  try
    Rc := PASCAL_HEIOpenDevice(@TPs, @Devise.dev, HEIAPIVersion,
      Devise.Timeout, Devise.retry, True);
    if Rc <> 0 then
    begin
      Devise.ererrorInit := rc;
      exit;
    end
    else
      try
        rc := PASCAL_HEIReadDeviceDef(@Devise.dev, @Devise.pdefdef, 42);
        if rc <> 0 then
          Devise.ererrorInit := rc
        else
          Devise.connected := True;

      except
        Devise.ererrorInit := -1;
      end;
  except
    Devise.ererrorInit := -1;
  end;
end;

procedure TEtherServer.DisConnectDevise();
begin
  if not FConnected then
    exit;
  try
    if Devise.connected then
    begin
      rc := PASCAL_HEICloseDevice(pHEIDevice(dev));
      if rc <> 0 then
        Devise.ererrorInit := -5;
    end
  except
    Devise.ererrorInit := -5;
  end;
end;



procedure TEtherServer.Connect;
begin
  ConnectDriver;
  ConnectDevise;
end;


procedure TEtherServer.DisConnect;
begin
  DisConnectDevise;
  DisConnectDriver;
end;


procedure TEtherServer.setProperty();
begin

end;


function TEtherServer.Open: boolean;
begin
  setProperty();
  Connect;
  Result := True;
end;

procedure TEtherServer.Close;
begin
  DisConnect;
end;

function TEtherServer.ReadSettings: boolean;
begin
  TPs.Transport := fcomset.rtc;
  TPs.Protocol := fcomset.rtm;
  Devise.Timeout := fcomset.wait;
  Devise.pData^ := fcomset.slave;
  Devise.retry := fcomset.trc;
end;


function TEtherServer.PLCReadString1(slaveNumber: byte;
  startAddress, dataSize: integer; var Data: string): integer;
var
  rc: integer;
  i: integer;
begin

  Result := ERRP_R_1;

  if not Devise.connected then
    Open;
  if not Devise.connected then
    exit;
  if not FConnected then
    exit;
  setLength(Data, dataSize * 2);
  try
    rc := PASCAL_HEICCMRequest(@Devise.dev, False, $31, startAddress, dataSize, pBuf(Data));
    if rc <> 0 then
    begin
      if rc = 32774 then
      begin
        proterrR := ERRP_R_1;
        Close;
        Devise.connected := False;
        Devise.errorrwrite := rc;
      end;
      //  result:=10;
      Devise.errorrwrite := rc;
      proterrR := ERRP_R_1;
      Result := ERRP_R_1;
      // raise Exception.Create('');
    end
    else
    begin
      Devise.errorrwrite := 0;
      proterrR := ERRP_R_NONE;
      Result := ERRP_R_NONE;
      sleep(50);
    end;
  except
    proterrR := 1234;
    Result := proterrR;
  end;
end;


function TEtherServer.PLCWriteString(slaveNumber: byte; startAddress: integer;
  NewValue: string): integer;
var
  i, rc: integer;
begin
  Result := ERRP_W_1;
  if not Devise.connected then
    Open;
  if not Devise.connected then
    exit;
  if not FConnected then
    exit;
  if not Devise.connected then
    exit;
  Devise.errorrwrite := 0;
  //setLength(Data,size);
  rc := PASCAL_HEICCMRequest(@Devise.dev, True, $31, startAddress, length(NewValue),
    pBuf(NewValue));
  if rc <> 0 then
  begin
    //result:=10;
    if rc = 32774 then
    begin
      proterrR := ERRP_R_1;
      Close;
      Devise.connected := False;
      Devise.errorrwrite := rc;
    end;
    proterrW := ERRP_W_1;
    Result := ERRP_W_1;
    sleep(50);
    raise Exception.Create('');
  end
  else
  begin
    Devise.errorrwrite := 0;
    proterrW := ERRP_W_NONE;
    Result := ERRP_W_NONE;
  end;
end;



end.
