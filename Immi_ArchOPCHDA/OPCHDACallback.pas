{*******************************************************}
{                                                       }
{       OPC Data Access 2.0  Custom Interface           }
{                                                       }
{       Delphi Sample - Callback Interface              }
{*******************************************************}

unit OPCHDACallback;

interface

uses
  Windows, ActiveX, OPCHDA, OPCtypes, Dialogs;

type
  // class to receive IConnectionPointContainer data change callbacks
  TOPCHDADataCallback = class(TInterfacedObject, IOPCHDA_DataCallback)
  public
    GrList: Tobject;

     function OnDataChange(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            pItemValues:                POPCHDA_ITEMARRAY;
            phrErrors:                  PResultList): HResult; stdcall;
    function OnReadComplete(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            pItemValues:                POPCHDA_ITEMARRAY;
            phrErrors:                  PResultList): HResult; stdcall;
    function OnReadModifiedComplete(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            pItemValues:                POPCHDA_MODIFIEDITEMARRAY;
            phrErrors:                  PResultList): HResult; stdcall;
    function OnReadAttributeComplete(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            hClient:                    OPCHANDLE;
            dwNumItems:                 DWORD;
            pAttributeValues:           POPCHDA_ATTRIBUTEARRAY;
            phrErrors:                  PResultList): HResult; stdcall;
    function OnReadAnnotations(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            pAnnotationValues:          POPCHDA_ANNOTATIONARRAY;
            phrErrors:                  PResultList): HResult; stdcall;
    function OnInsertAnnotations(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwCount:                    DWORD;
            phClients:                  POPCHANDLEARRAY;
            phrErrors:                  PResultList): HResult; stdcall;
    function OnPlayback(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            ppItemValues:               POPCHDA_ITEMPTRARRAY;
            phrErrors:                  PResultList): HResult; stdcall;
    function OnUpdateComplete(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwCount:                    DWORD;
            phClients:                  POPCHANDLEARRAY;
            phrErrors:                  PResultList): HResult; stdcall;
    function OnCancelComplete(
            dwCancelID:                 DWORD): HResult; stdcall;

    constructor Create(grL: TObject);
  end;

implementation
uses  OPCHDAClient;

constructor TOPCHDADataCallback.Create(grL: TObject);
begin
   GrList:=grL;
   inherited Create;
end;
// TOPCDataCallback methods


 function TOPCHDADataCallback.OnDataChange(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            pItemValues:                POPCHDA_ITEMARRAY;
            phrErrors:                  PResultList): HResult;
                  var



  clItemList: TItemOPCHDAs;
  i: integer;




  begin
     try
     clItemList:= TItemOPCHDAs(GrList);
     for i:=0 to dwNumItems-1 do
       begin
         if (pItemValues[i].hClient>0) then
         begin
         if Failed(phrErrors[i]) then begin
             sleep(500);
           // clItemList.items[pItemValues[i].hClient-1].err:=-10;
            clItemList.items[pItemValues[i].hClient-1].stateIT:=his_Wait;
        end
        else begin
            clItemList.WriteData(pItemValues[i].hClient-1,pItemValues[i]);

        end;
        end;

       end;
        sleep(1000);
       clItemList.m_ReadTransactHandle:=0;
       except
       end;
       result:=S_OK;
   //    CoTaskMemFree(pItemValues);
    //   CoTaskMemFree(phrErrors);
            end;

 function TOPCHDADataCallback.OnReadComplete(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            pItemValues:                POPCHDA_ITEMARRAY;
            phrErrors:                  PResultList): HResult;

            var



  clItemList: TItemOPCHDAs;
  i: integer;




  begin
  try
     clItemList:= TItemOPCHDAs(GrList);
     for i:=0 to dwNumItems-1 do
       begin
         if (pItemValues[i].hClient>0) then
         begin
         if Failed(phrErrors[i]) then begin
             sleep(500);
            //clItemList.items[pItemValues[i].hClient-1].err:=-10;
            clItemList.items[pItemValues[i].hClient-1].stateIT:=his_Wait;
        end
        else begin
            //  clItemList.items[pItemValues[i].hClient-1].err:=-10;
         //   clItemList.items[pItemValues[i].hClient-1].stateIT:=his_Wait;
            clItemList.WriteData(pItemValues[i].hClient-1,pItemValues[i]);

        end;
        end;

       end;
       // sleep(1000);
       clItemList.m_ReadTransactHandle:=0;
       result:=S_OK;
   //    CoTaskMemFree(pItemValues);
    //   CoTaskMemFree(phrErrors);
    except
  //    ShowMessage('in call');
    end;
     end;

 function TOPCHDADataCallback.OnReadModifiedComplete(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            pItemValues:                POPCHDA_MODIFIEDITEMARRAY;
            phrErrors:                  PResultList): HResult;
            begin
            end;

 function TOPCHDADataCallback.OnReadAttributeComplete(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            hClient:                    OPCHANDLE;
            dwNumItems:                 DWORD;
            pAttributeValues:           POPCHDA_ATTRIBUTEARRAY;
            phrErrors:                  PResultList): HResult;
            begin
            end;

 function TOPCHDADataCallback.OnReadAnnotations(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            pAnnotationValues:          POPCHDA_ANNOTATIONARRAY;
            phrErrors:                  PResultList): HResult;
            begin
            end;
            
 function TOPCHDADataCallback.OnInsertAnnotations(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwCount:                    DWORD;
            phClients:                  POPCHANDLEARRAY;
            phrErrors:                  PResultList): HResult;
            begin
            end;

 function TOPCHDADataCallback.OnPlayback(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwNumItems:                 DWORD;
            ppItemValues:               POPCHDA_ITEMPTRARRAY;
            phrErrors:                  PResultList): HResult;
            begin
            end;

 function TOPCHDADataCallback.OnUpdateComplete(
            dwTransactionID:            DWORD;
            hrStatus:                   HResult;
            dwCount:                    DWORD;
            phClients:                  POPCHANDLEARRAY;
            phrErrors:                  PResultList): HResult;
            begin
            end;

 function TOPCHDADataCallback.OnCancelComplete(
            dwCancelID:                 DWORD): HResult;
            var
            clItemList: TItemOPCHDAs;




  begin
            clItemList:= TItemOPCHDAs(GrList);

            clItemList.items[clItemList.m_ReadTransactHandle-1].stateIT:=his_wait;
            clItemList.m_ReadTransactHandle:=0;
            clItemList.canceled:=false;
            result:=S_OK;
            end;

{function TOPCDataCallback.OnDataChange(dwTransid: DWORD;
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
 //   if Qualities[I] = OPC_QUALITY_GOOD then
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
   if (TItemOPCs(GrList).GetReadTransaction=dwTransid) then
  TItemOPCs(GrList).ClearCommandTransaction;
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
end;        }

end.

