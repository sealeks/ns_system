unit rtThreadU;

interface

uses
  Classes, SysUtils, windows, DDEML, DDEMan1;

type
  trtThread = class(TThread)
  public
    isTerminated: boolean;
    constructor Create(rtItems: TrtItems; DDEClients: TDDEGroups);
  private
    { Private declarations }
    iGlobal: integer;
    frtBase : TrtItems;
    fDDEClients: TDDEGroups;
    procedure updateItems;
    procedure updateGroups;
    procedure TerminateCaption;
    function RequestData(const Item: string; DDEConv: TDDEClientConv): PChar;
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure rtThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ rtThread }
function TrtThread.RequestData(const Item: string; DDEConv: TDDEClientConv): PChar;
var
  hData: HDDEData;
  ddeRslt: LongInt;
  hItem: HSZ;
  pData: Pointer;
  Len: Integer;
begin
  Result := nil;
  if (DDEConv.Conv = 0) or DDEConv.WaitStat then Exit;
  hItem := DdeCreateStringHandle(ddeMgr.DdeInstId, PChar(Item), CP_WINANSI);
  if hItem <> 0 then
  begin
    hData := DdeClientTransaction(nil, 0, DDEConv.Conv, hItem, CF_TEXT,
      XTYP_REQUEST, 10000, @ddeRslt);
    DdeFreeStringHandle(ddeMgr.DdeInstId, hItem);
    if hData <> 0 then
    try
      pData := DdeAccessData(hData, @Len);
      if pData <> nil then
      try
        Result := StrAlloc(Len + 1);
        StrCopy(Result, pData);
      finally
        DdeUnaccessData(hData);
      end;
    finally
      DdeFreeDataHandle(hData);
    end;
  end;
end;


constructor TrtThread.Create(rtItems: TrtItems; DDEClients: TDDEGroups);
begin
     frtBase := rtItems;
     fDDEClients := DDEClients;
     inherited Create(false);
end;

procedure TrtThread.updateItems;
begin
{       for i := 0 to frtBase.count - 1 do begin
          if terminated then break;
            frtBase.items[i].Update(fDDEClients);
       end;
 }      frtBase.items[iGlobal].UpdateValue(fDDEClients);
end;

procedure TrtThread.updateGroups;
begin
     fDDEClients.UpdateValue;
end;

procedure TrtThread.TerminateCaption;
begin
end;

procedure TrtThread.Execute;
var
   i: integer;
begin
  { Place thread code here }
//    priority := tpIdle;
    isterminated := false;
     while not terminated do begin
       Synchronize(updateGroups);
       for i := 0 to frtBase.count - 1 do begin
          iGlobal := i;
//          Synchronize(updateItems);
//          sleep(50);
          updateItems;
          if terminated then break;
       end;
    end;
    isterminated := true;
    Synchronize(TerminateCaption);
end;

end.
