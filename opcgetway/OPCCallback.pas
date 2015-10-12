{*******************************************************}
{                                                       }
{       OPC Data Access 2.0  Custom Interface           }
{                                                       }
{       Delphi Sample - Callback Interface              }
{*******************************************************}

unit OPCCallback;

interface

uses
  Windows, ActiveX, OPCDA;

type
  // class to receive IConnectionPointContainer data change callbacks
  TOPCDataCallback = class(TInterfacedObject, IOPCDataCallback)
  public
    GrList: Tobject;

    function OnDataChange(dwTransid: DWORD; hGroup: OPCHANDLE;
      hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;
      phClientItems: POPCHANDLE; pvValues: POleVariant; pwQualities: PWORD;
      pftTimeStamps: PFileTime; pErrors: PHResult): HResult; stdcall;
    function OnReadComplete(dwTransid: DWORD; hGroup: OPCHANDLE;
      hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;
      phClientItems: POPCHANDLE; pvValues: POleVariant; pwQualities: PWORD;
      pftTimeStamps: PFileTime; pErrors: PHResult): HResult; stdcall;
    function OnWriteComplete(dwTransid: DWORD; hGroup: OPCHANDLE;
      hrMastererr: HResult; dwCount: DWORD; pClienthandles: POPCHANDLE;
      pErrors: PHResult): HResult; stdcall;
    function OnCancelComplete(dwTransid: DWORD; hGroup: OPCHANDLE):
      HResult; stdcall;
    constructor Create(grL: TObject);
  end;

implementation
uses  OPCClient;

constructor TOPCDataCallback.Create(grL: TObject);
begin
   GrList:=grL;
   inherited Create;
end;
// TOPCDataCallback methods



function TOPCDataCallback.OnDataChange(dwTransid: DWORD;
  hGroup: OPCHANDLE; hrMasterquality: HResult; hrMastererror: HResult;
  dwCount: DWORD; phClientItems: POPCHANDLE; pvValues: POleVariant;
  pwQualities: PWORD; pftTimeStamps: PFileTime; pErrors: PHResult): HResult;
var
  ClientItems: POPCHANDLEARRAY;
  Values: POleVariantArray;
  Qualities: PWORDARRAY;
  TimeStamp: PFileTimeArray;
  I: Integer;
  val:OPCITEMSTATE;
begin
  Result := S_OK;
 
  try
  TItemOPCs(GrList).GroupStatus:=  TItemOPCs(GrList).GroupStatus+[gsReading];
  if (TItemOPCs(GrList).GetReadTransaction=dwTransid) then
  TItemOPCs(GrList).ClearReadTransaction;

  ClientItems := POPCHANDLEARRAY(phClientItems);
  Values := POleVariantArray(pvValues);
  Qualities := PWORDARRAY(pwQualities);
  TimeStamp:= PFileTimeArray(pftTimeStamps);
  for I := 0 to dwCount - 1 do
   // if Qualities[I] = OPC_QUALITY_GOOD then
    begin
         val.wQuality:=Qualities[I];
         val.hClient:=ClientItems[i];
         val.ftTimeStamp:=TimeStamp[i];
         val.vDataValue:=Values[i];
         TItemOPCs(GrList).Setval(val);
    end;
  finally
   TItemOPCs(GrList).GroupStatus:=  TItemOPCs(GrList).GroupStatus-[gsReading];
  // CoTaskMemFree(pvValues);
 //  CoTaskMemFree(pErrors);
 //  CoTaskMemFree(pwQualities);
 //  CoTaskMemFree(pftTimeStamps);
  end
end;


function TOPCDataCallback.OnReadComplete(dwTransid: DWORD;
  hGroup: OPCHANDLE; hrMasterquality: HResult; hrMastererror: HResult;
  dwCount: DWORD; phClientItems: POPCHANDLE; pvValues: POleVariant;
  pwQualities: PWORD; pftTimeStamps: PFileTime; pErrors: PHResult): HResult;
begin
  Result := OnDataChange(dwTransid, hGroup, hrMasterquality, hrMastererror,
    dwCount, phClientItems, pvValues, pwQualities, pftTimeStamps, pErrors);
end;

function TOPCDataCallback.OnWriteComplete(dwTransid: DWORD;
  hGroup: OPCHANDLE; hrMastererr: HResult; dwCount: DWORD;
  pClienthandles: POPCHANDLE; pErrors: PHResult): HResult;
begin
  try
   TItemOPCs(GrList).GroupStatus:=  TItemOPCs(GrList).GroupStatus+[gsWriting];
  // if (TItemOPCs(GrList).GetCommandTransaction=dwTransid) then
 // TItemOPCs(GrList).ClearCommandTransaction;
  finally
   TItemOPCs(GrList).GroupStatus:=  TItemOPCs(GrList).GroupStatus-[gsWriting];
  end;
  Result := S_OK;
end;

function TOPCDataCallback.OnCancelComplete(dwTransid: DWORD;
  hGroup: OPCHANDLE): HResult;
begin
  // we don't use this facility
  Result := S_OK;
end;

end.

