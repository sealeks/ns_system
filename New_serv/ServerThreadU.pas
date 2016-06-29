unit ServerThreadU;

interface

uses
  Classes, serverClasses, windows, memStructsU, sysUtils, plcComPort,
  convFunc, InterfaceServerU, {GlobalVar,} MyComms, DateUtils, StrUtils, Constdef;

type
  TMyNotyfy = procedure (Sender: TObject; val: integer; val1: integer) of Object;



type
  TServerThread = class(TThread)//(TThread)

    { Private declarations }
    private
    fisExecuted: boolean;//stop in that plase what I want
    farchdev: TKoyoArchDevItems;
    fpath: string;
    finitvar: boolean;
    finitserv: boolean;
    WriteErrorCount: integer;
    fanalizefunc: TMyNotyfy;
    //ForceControl: boolean;
    curReadid: integer;
    curforceReadid: integer;
    firstreq: boolean;
    PredLastCommand : integer;
    setreuestid: integer;
    inread: boolean;
    procedure Resetactiv;
    procedure InitVar;
    procedure UnInitVar;
    procedure InitServ;
    procedure UnInitServ;
    procedure AddItems_;
    procedure RemoveItems_;


    function findIteminList(id: integer): PtAskItem;

    procedure Analize;
    function GetforceAsk: integer;
    procedure SetforceAsk(val: integer;comid: integer;  zval: real);

    function ClearforceAsk: integer;

  protected
    procedure Log(mess: string; lev: byte = 2);
//    procedure SetRTItems; //for synhronize
  public
  fisstopped: boolean;
    server: tserver;
    fcomNum: integer;
    itemsList: TStringList;
    frtItems : TanalogMems;
    procedure Stops;
    procedure reset;
    constructor create(irtItems : string; comNum: integer; comset: TCOMSet); overload;
    constructor create(irtItems : string;  comset: TCOMSet; slavenum: integer); overload;
    destructor destroy; override;
    function  DoRW: boolean;
    function  term: boolean;
    function  AddItem(slave: Integer; grname: string; comset: TCOMSet): TAscItems;
    property  isExecuted: boolean read fisExecuted write fisExecuted default false;
    property  analizefunc: TMyNotyfy read fanalizefunc write fanalizefunc;
    property  ForceAsk: integer read GetforceAsk;
    procedure Execute; override;
  end;


function GetConvFromItem (item: string): TConvType;
function GetBitFromItem (item: string): integer;
function GetAddrFromItem (item: string): integer;


implementation




// ��� ����� �� ���������
function GetConvFromItem (item: string): TConvType;
var
  str: string;
begin
 result:=ctErr;
 item:=trim(uppercase(item));
 if (length(item)<2) then exit;
 if (length(item)=1) then exit;
 if ((item[1]<>'V') and (item[1]<>'A')) then exit;
 if item[1]='A'  then
   begin
     result:=ctArch;
     exit;
   end;
  str := upperCase(copy (item, pos (':', item) + 1, length(item) - pos (':', item) + 1));
  if pos ('.', item) <> 0 then
     str := copy(str, 1, pos ('.', item) - 1);
  result := ctNone;
  if str = 'B' then result := ctB;
  if str = 'D' then result := ctD;
  if str = 'R' then result := ctR;
  if (str = 'DB') or (str = 'BD') then result := ctBD;
end;


//  ������ ����� �� ���������
function GetAddrFromItem (item: string): integer;
var
  minPos: integer;
begin
  result:=-1;

  item:=trim(uppercase(item));
  if (length(item)<2) then exit;
  if ((item[1]<>'V') and (item[1]<>'A')) then exit;
  if item[1]='A'  then
   begin
     if (length(item)<3) then exit;
     if item[2]<>':'  then exit;
     item:=rightstr(item, length(item)-2);
     result:=strtointdef(item,-1);
     exit;
   end;

  minPos := length(item) + 1;
  if pos('V', item)=0 then exit;           //��������� �� 29.4
  if pos (':', item) <> 0 then minPos := pos (':', item);
  if (pos ('.', item) <> 0) and (pos ('.', item) < minPos) then
    minPos := pos ('.', item);
  //delete first symbol and modifycators
  item := copy (item, 2, minPos - 2);
  result := octStringToInteger (item) + 1;
end;


//  ����� ���� �� ���������

function GetBitFromItem (item: string): integer;
var
  str: string;
begin
  result := -1;
  if (length(item)<2) then exit;
  if pos ('.', item) <> 0 then
  begin
    str := upperCase(copy (item, pos ('.', item)+1, length(item) - pos ('.', item)));
    try
      result := strtoint(str);
    except
     // showMessage ('������ ��� ����������� ������ ����: ' + item);
    end;
  end;
end;


constructor TServerThread.create(irtItems : string; comNum: integer;comset: TCOMSet);
var fff:  string;
begin
  inherited create(false);
  IsMultiThread:=true;
  fpath := irtItems;
  fComNum:=comNum;
 // ForceControl:=false;
  itemsList:=TStringList.Create;
  finitvar:=false;
  finitserv:=false;
  server:=Tserver.Create(nil,comset);
  fanalizefunc:=nil;
  curReadid:=-1;
  curforceReadid:=-1;
  PredLastCommand:=0;
  setreuestid:=-1;
  farchdev:=nil;
end;


constructor TServerThread.create(irtItems : string;  comset: TCOMSet; slavenum: integer);
var fff:  string;
begin
  inherited create(false);
  fpath := irtItems;
 // ForceControl:=false;
  itemsList:=TStringList.Create;
  finitvar:=false;
  finitserv:=false;
  server:=Tserver.Create(slavenum,comset);
  fanalizefunc:=nil;
  curReadid:=-1;
  curforceReadid:=-1;
  PredLastCommand:=0;
  setreuestid:=-1;
  inread:=false;
  farchdev:=nil;
end;


destructor TServerThread.destroy;
begin
self.Terminate;
while not Terminated do
  sleep(50);
  UnInitVar;
  UnInitserv;
  itemsList.Free;
  fanalizefunc:=nil;
  server.close;
  server.Free;
  farchdev:=nil;
inherited destroy;

end;



procedure TServerThread.InitVar;
begin
   if frtItems=nil then frtItems := TanalogMems.Create(fpath);
   farchdev:=TKoyoArchDevItems.create(frtItems,server);
   frtItems.SetAppName('#KoyoServ'+inttostr(fcomNum));
   server.frtItems:=frtItems;
   finitVar:=(frtItems<>nil);
end;


procedure TServerThread.UnInitVar;
begin
   if (farchdev<>nil) then FreeAndNil(farchdev);
   if (frtItems<>nil) then FreeAndNil(frtItems);
   finitVar:=false;
end;

procedure TServerThread.InitServ;
begin
   if  (frtItems=nil) then exit;
   self.AddItems_;
   finitserv:=server.Open;
   if not finitserv then
    begin
     sleep(1000);
     exit;
    end;

   ClearforceAsk;
   PredLastCommand:=frtItems.command.CurLine;
   firstreq:=true;
end;

procedure TServerThread.UnInitServ;
begin
   RemoveItems_;
   finitserv:=false;
end;




function TServerThread.findIteminList(id: integer): PtAskItem;
var i, fidx: integer;
    acs: TAscItems;
begin
   result:=nil;
   for i:=0 to itemsList.Count-1 do
     begin
       acs:=TAscItems(itemsList.objects[i]);
       if (acs<>nil) then
         begin
           fidx:=acs.FindItem(id);
           if (fidx>-1) then
             begin
                result:=acs.items[fidx];
                exit;
             end;
         end;
     end;
end;

function TServerThread.DoRW:boolean;
var
  i,k: longInt;
  newValue: longInt;

 // cN: longInt;
  commandValue, mask, prevVal: word;

  newComValue: single;
  str: string;
  j : longInt;
  Last: longInt;
   numit: integer;
   ascit: PtAskItem;
   acs: TAscItems;
   fa: integer;
 // tstrt,tstp: integer;



{***********************************************************************}
{ Writing pareameters                                                   }
{***********************************************************************}
  function WriteCommand: boolean;
  var j: integer;



  function ExecuteCommand: boolean;
begin
      result:=true;
      if frtItems.Command[j].Executed then exit
      else
      if (frtItems.Command[j].ID <> -1)then
      begin
        if (frtItems.Command[j].ID=setreuestid) then
          begin
            if (frtItems.Command[j].ValReal<2) then
            begin
            firstreq:=true;
            frtitems.SetVal(setreuestid,1,100);
            frtItems.SetCommandExecuted(j);
            result:=true;
            exit;
            end else
             begin
            firstreq:=false;
            frtitems.SetVal(setreuestid,2,100);
            frtItems.SetCommandExecuted(j);
            result:=true;
            exit;
            end
          end;
        SetforceAsk(frtItems.Command[j].ID,j,frtItems.Command[j].ValReal);
        ascit := findIteminList(frtItems.Command[j].ID);
        if ascit=nil then result:=false;
        newComValue := frtItems.Command[j].ValReal;
        if ascit <> nil then
        begin
        if not ((ascit.conv=ctD) or (ascit.conv=ctR)) then
        begin
          frtItems.SetCommandExecuted(j);
          if ascit.minRaw < ascit.maxRaw then
          begin
          if NewComValue >= ascit.maxEU then
            commandValue := round(ascit.maxRaw)
          else if NewComValue <= ascit.minEu then
              commandValue := round(ascit.minRaw)
             else begin
              commandValue := round(ascit.minRaw +
                                   (newComValue - ascit.minEU) *
                                   (ascit.maxRaw - ascit.minRaw)/
                                   (ascit.maxEU - ascit.minEU));
             end;
          end else
           begin
           if NewComValue >= ascit.maxEU then
            commandValue := round(ascit.minRaw)
          else if NewComValue <= ascit.minEu then
              commandValue := round(ascit.maxRaw)
             else begin
              commandValue := round(ascit.minRaw +
                                   (newComValue - ascit.minEU) *
                                   (ascit.maxRaw - ascit.minRaw)/
                                   (ascit.maxEU - ascit.minEU));
             end;
          end;

          case ascit.conv of
            ctB   : commandValue := BINtoBCD(commandValue);
          end;

          if ascit.bitNumber <> -1 then
          begin
            case ascit.conv of
              ctNone: prevVal := server.Items[ascit.GroupNum, ascit.Addr];
              ctB   : prevVal := server.ItemsB[ascit.GroupNum, ascit.Addr];
            else prevVal := server.Items[ascit.GroupNum, ascit.Addr];
            end;

            mask := 1 shl ascit.bitNumber;
            if commandValue = 0 then
            begin
              mask := not mask;
              commandValue := prevVal and mask;
            end
            else commandValue := prevVal or mask;
          end
          end
          else
          begin
            frtItems.SetCommandExecuted(j);
            setlength(str,4);
            if (ascit.conv=ctR) then
            begin
             if newComValue>ascit.MaxEu then newComValue:=ascit.MaxEu;
             if newComValue<ascit.MinEu then newComValue:=ascit.MinEU;
             PSingle(str)^:=newComValue
            end
            else
            PLongInt(str)^:=round(newComValue);
          end;

          if not ((ascit.conv=ctD) or (ascit.conv=ctR)) then
          begin
          setlength(str,2);
          PWord(str)^ := commandValue;
          end;

           numit:=frtitems.TegGroups.Idx[frtitems.TegGroups.ItemNameByNum[ascit.GroupNum]];                   // ��������� �� 29.04
             if ((numit<0) or (frtitems.TegGroups.Items[numit].SlaveNum<0)) then exit;

          try
            Server.PLCwriteString (frtitems.TegGroups.GetSlaveByNum(ascit.GroupNum), ascit.Addr, str);
             setlength(str,0);
          except

            on E: Exception do
            begin
              setlength(str,0);
              raise;
            end;
          end; //except
        end;
      end;
end;


begin
  result:=false;
  setlength (str, 2);
    try
      Last := PredLastCommand;

      if Last < frtItems.Command.CurLine then
        for j := Last to frtItems.Command.CurLine - 1 do
        begin
          result:=ExecuteCommand;
          inc(predLastCommand); //�����������, ���� ������� �����������
        end;

      if Last > frtItems.Command.CurLine then begin
        for j := Last to  frtItems.Command.Count - 1 do
        begin
          result:=ExecuteCommand;
          inc(predLastCommand)
        end;
        predLastCommand := 0;
        for j := 0 To frtItems.Command.CurLine - 1 do
        begin
          result:=ExecuteCommand;
          inc(predLastCommand)
        end;
      end;


    except
      if   WriteErrorCount < 3 then begin
        inc (WriteErrorCount);
        frtItems.ClearCommandExecuted(j);
      end else WriteErrorCount := 0; //���������� ������� ��� ���� ��������� �������� ������

    end;
   end;
{***********************************************************************}
{ Reading pareameters                                                   }
{***********************************************************************}
  begin
    inread:=true;
    result:=false;
    setlength (str, 2);
    synchronize(Analize);
    Resetactiv;
    server.updateData;
    if itemsList.Count>0 then acs:=TAscItems(itemsList.objects[0]);
  {  if  (acs<>nil)  then
      begin
       tstrt:=-1;//acs.fComSet.tstrt;
       tstp:=61;//acs.fComSet.tstp;
      end else   }
     // begin
      // tstrt:=-1;
     //  tstp:=61;
     // end;
   if (predLastCommand<>frtItems.Command.CurLine) then
     WriteCommand;
   curforceReadid:=ForceAsk;
  // if (  ( (tstrt<=minuteofthehour(now)) and (tstp>=minuteofthehour(now)) )
   //     or (firstreq) or (curforceReadid>-1)
   //   ) then

   for k:=0 to itemsList.Count-1 do
     begin
     if (predLastCommand<>frtItems.Command.CurLine) then
     WriteCommand;
     acs:=TAscItems(itemsList.objects[k]);
     server.setCurCoSet(acs.fComSet);
     curforceReadid:=ForceAsk;
     if ( (self.curforceReadid=k) or
       { (} (self.curforceReadid<0) {and ((tstrt<=minuteofthehour(now)) and (tstp>minuteofthehour(now))) )}
        or (firstreq)
      ) then

        begin
        //  if acs.freq_in>-1 then
          begin

       //   frtitems.SetVal(acs.freq_in,1,100);
          end;
          for i := 0 to  acs.count - 1 do
             begin
             result:=true;
                begin
                curReadid:=k;
                if (predLastCommand<>frtItems.Command.CurLine) then
                   begin
                   if  WriteCommand then
                   server.updateData;
                   end;
                   //  if PredLastCommand <> frtItems.Command.CurLine then break;

                if acs[i].Name[1] = '$' then
                   begin
                   frtItems.SetVal (acs[i].ID,
                        integer(not Server.IsGroupValid(frtItems[i].GroupNum)),100);
                   continue;
                   end;

                   //if server.RequestActive and (frtItems[acs[i].ID].refCount = 0) then continue;

                   // if acs[i].ID = -1 then continue;
                if ((acs[i].activ) and (acs[i].ID > -1)) then
                   begin
                    server.setcurBlock(acs.getcurblock(i));
                    try
                      case acs[i].conv of
                       ctNone: newValue := server.Items[acs[i].GroupNum, acs[i].Addr];
                       ctB   : newValue := server.ItemsB[acs[i].GroupNum, acs[i].Addr];
                       ctD   : newValue := server.ItemsD[acs[i].GroupNum, acs[i].Addr];
                       ctR   : newValue := server.ItemsD[acs[i].GroupNum, acs[i].Addr];
                       ctBD  : newValue := server.ItemsBD[acs[i].GroupNum, acs[i].Addr];
                       else newValue := server.Items[acs[i].GroupNum, acs[i].Addr];
                      end;
                      acs.ProterrW:=server.getProterrW;
                      acs.ProterrR:=server.getProterrR;
                      if acs.freqId>-1 then
                         begin
                           //frtitems.SetValid(acs.freqId,100);
                           if (server.getProterrR=0) then
                             begin
                             frtitems.SetVal(acs.freqId,1,100);
                             acs.freqTime:=now;
                             end
                             else
                             begin
                             if (secondsbetween(now,acs.freqTime)>acs.ReadTimeOUT) then
                             frtitems.SetVal(acs.freqId,0,100)
                             end;
                         end;
                         //synchronize(Analize);

                      if ((server.isValid) and (server.getProterrR=0)) then
                        begin
                         if acs[i].bitNumber <> -1 then
                             newValue := (newValue shr acs[i].bitNumber) and 1;

                       //  frtItems.SetValid (acs[i].ID, Server.ValidLevel);
                         if not server.isValid then continue; //break;//
                                  //���� �������� ���������� ������ ��� �� �������� ������� ����
                                 //�� ������ �� ������
                         if ((acs[i].prevValue - acs[i].DeadBaund) < newValue) and
                                 (newValue < (acs[i].prevValue + acs[i].DeadBaund))then
                         continue;
                         if (acs[i].conv=ctR) then
                         begin
                            frtItems.SetVal(acs[i].ID,Psingle(@newValue)^,100);
                           // frtItems.SetValid (acs[i].ID, 100);
                         end else
                         begin
                         if acs[i].maxRaw>acs[i].minRaw then
                              begin
                              if NewValue >= acs[i].maxRaw then
                               frtItems.SetVal(acs[i].ID, acs[i].maxEU,100)
                              else if NewValue <= acs[i].minRaw then
                                       frtItems.SetVal(acs[i].ID, acs[i].minEU,100)
                                   else
                                       frtItems.SetVal(acs[i].ID,
                                                acs[i].minEU +
                                                   (newValue - acs[i].minRaw) /
                                                       (acs[i].maxRaw - acs[i].minRaw) *
                                                          (acs[i].maxEU - acs[i].minEU),100);
                              end
                              else
                              begin
                               if NewValue >= acs[i].minRaw then
                                frtItems.SetVal(acs[i].ID, acs[i].maxEU,100)
                               else if NewValue <= acs[i].maxRaw then
                                      frtItems.SetVal(acs[i].ID, acs[i].maxEU,100)
                                    else
                                      frtItems.SetVal(acs[i].ID,
                                          acs[i].minEU +
                                             (newValue - acs[i].minRaw) /
                                              (acs[i].maxRaw - acs[i].minRaw) *
                                                       (acs[i].maxEU - acs[i].minEU),100);

                              end;
                            acs.SetPrevValue(i, newValue);
                         //   frtItems.SetValid (acs[i].ID, 100);
                        end
                        end else
                              begin

                                frtItems.ValidOff (acs[i].ID);
                              end;
                    except
                     //  frtItems.SetValid (acs[i].ID, Server.ValidLevel);
                    end;
                   end;
                end;
             acs.NewItems := false;
             end;
          // if (acs.freq_in>-1) then
           //  begin
           //  frtitems.SetValid(acs.freq_in,100);
            // frtitems.SetValue(acs.freq_in,0);
            //   frtitems.SetVal(acs.freq_in,0,100);
          //   end;
        end;

     if acs<>nil then
       if (acs.GetSyncTime) and (acs.needSync) then
         if server<>nil then
           if server.serverinf<>nil then
                 server.serverinf.setTimeSync(acs.fslave,now);

     end;
  
   firstreq:=false;
   if (setreuestid>-1) then frtitems.SetVal(setreuestid,0,100);

   if farchdev<>nil then
      farchdev.readDevs;
   Sleep(100);
   inread:=false;
end;


function TServerThread.AddItem(slave: Integer; grname: string; comset: TCOMSet): TAscItems;
var
  item: PTaskItem;
  slavestr: string;
  listinx,i: integer;
  AskItems_:  TAscItems;
begin
      if frtItems=nil then frtItems := TanalogMems.Create(fpath);
      result:=nil;
      if slave<0 then exit;
      slavestr:=inttostr(slave);
      listinx:=itemslist.IndexOf(slavestr);
      AskItems_:=nil;
      if listinx<0 then
       begin
        AskItems_:=TAscItems.create(comset,slave, frtItems);
        itemslist.AddObject(slavestr,AskItems_)
       end else
          AskItems_:=TAscItems(itemslist.Objects[listinx]);
       AskItems_.groupname:=trim(grname);

       result:=AskItems_;

end;

procedure TServerThread.AddItems_;
var i,j: integer;
       AskItems_:  TAscItems;
       item: PTaskItem;
       conv_: TConvType;
       item_addr, bitpos_, typ_: integer;
begin
   setreuestid:=frtitems.GetSimpleID(trim(uppercase('koyo_query')));
   if (setreuestid>-1)then
      begin
        //frtitems.SetValid(setreuestid,100);
        frtitems.SetVal(setreuestid,2,100);
      end;
   for i:=0 to itemslist.Count-1 do
     begin
        AskItems_:=TAscItems(itemslist.Objects[i]);
         if AskItems_<>nil then
         begin
            AskItems_.freqId:=frtitems.GetSimpleID(trim(uppercase(AskItems_.groupname+'_REQ')));
            if (AskItems_.freqId>-1) then
              begin
                AskItems_.freqTime:=Now;
                //frtitems.SetValid(AskItems_.freqId,100);
                frtitems.SetVal(AskItems_.freqId,0,0);
              end;
          {  AskItems_.freqDirectId:=frtitems.GetSimpleID(trim(uppercase(AskItems_.groupname+'_REQFORCE')));
            if (AskItems_.freqDirectId>-1) then
              begin
                AskItems_.freqDirectTime:=Now;
                ForceControl:=true;
               // frtitems.SetValid(AskItems_.freqDirectId,100);
                frtitems.SetVal(AskItems_.freqDirectId,0,100);
              end;
             AskItems_.freq_in:=frtitems.GetSimpleID(trim(uppercase(AskItems_.groupname+'_INREQ')));
            if (AskItems_.freq_in>-1) then
              begin
                AskItems_.freqTime:=Now;
               // frtitems.SetValid(AskItems_.freq_in,100);
                frtitems.SetVal(AskItems_.freq_in,0,100);
              end; }
         end;

        for j:=0 to frtitems.Count-1 do
          begin
            if ((frtitems.Items[i].ID>-1) and (AskItems_.freqId<>frtitems.Items[j].ID)) then
              begin
                if UpperCase(frtitems.TegGroups.ItemNameByNum[frtItems[j].GroupNum])=UpperCase(AskItems_.groupname) then
                  begin
                        try
                        conv_:=GetConvFromItem(frtItems.GetDDEItem(j));
                        item_addr:=GetAddrFromItem (UpperCase(frtItems.GetDDEItem(j)));
                        bitpos_:=GetBitFromItem(UpperCase(frtItems.GetDDEItem(j)));
                        typ_:=frtItems[j].logTime;
                        if (item_addr>-1) then
                        begin
                        case conv_ of
                         ctNone, ctB, ctD, ctBD, ctR:
                          begin
                          if (typ_<>REPORTTYPE_HOUR) then
                          begin
                          if bitpos_<16 then
                          begin
                          New(Item);
                          item.Name := UpperCase(frtItems.GetName(j));
                          item.GroupNum := frtItems[j].GroupNum;
                          item.MinRaw := frtItems[j].MinRaw;
                          item.MaxRaw := frtItems[j].MaxRaw;
                          item.MinEU := frtItems[j].MinEu;
                          item.MaxEU := frtItems[j].MaxEu;
                          item.DeadBaund := 0; //frtItems[j].DeadBaund;
                          item.ref:=frtItems[j].refCount;
                          item.PrevValue := 0;
                          if item.Name[1] <> '$' then
                           begin
                            item.Conv := GetConvFromItem (UpperCase(frtItems.GetDDEItem(j))); //all what after :
                            item.bitNumber := GetBitFromItem (UpperCase(frtItems.GetDDEItem(j))); //all what after :
                            item.Addr := GetAddrFromItem (UpperCase(frtItems.GetDDEItem(j))); //from second letter to . or :
                           end else
                           begin
                            item.Conv := ctNone;
                            item.bitNumber := -1;
                            item.Addr := 0;

                           end;
                           item.id := frtItems[j].ID;;
                           askItems_.Insert(item);
                           end else
                             log('��� tg='+frtItems.GetName(j)+' �� ��� �������� ��� ��������. ������� ��������� ��������. ����� ���� ���� �����������. sc='+frtItems.GetDDEItem(j), _DEBUG_ERROR);
                           end else
                             log('��� tg='+frtItems.GetName(j)+' �� ��� �������� ��� ��������. ������� ��������� �������� sc='+frtItems.GetDDEItem(j), _DEBUG_ERROR);
                           end;
                          ctArch:
                           begin
                              if AskItems_.GetReport then
                              begin
                              if (typ_=REPORTTYPE_HOUR) then
                                begin
                                  farchdev.AddItems(frtItems[j].ID,frtitems.TegGroups.GetIdxByNum(frtItems[j].GroupNum));
                                  log('��� tg='+frtItems.GetName(j)+' ��� �������� ��� ��������. sc='+frtItems.GetDDEItem(j));
                                end else
                                  log('��� tg='+frtItems.GetName(j)+' �� ��� �������� ��� ��������. ������� ����� ���', _DEBUG_ERROR);
                              end;
                           end;
                          ctErr:
                           begin
                              log('��� tg='+frtItems.GetName(j)+' �� ��� ��������!!! �������� �������� sc='+frtItems.GetDDEItem(j),_DEBUG_ERROR);
                           end;
                         end;
                         end else
                           begin
                              log('��� tg='+frtItems.GetName(j)+' �� ��� ��������!!! �������� �������� ��� ����� sc='+frtItems.GetDDEItem(j),_DEBUG_ERROR);
                           end;
                  except
                  log('��� tg='+frtItems.GetName(j)+' �� ��� ��������!!! �������� �������� ��� ����� sc='+frtItems.GetDDEItem(j),_DEBUG_ERROR);
                  end;
                  end;
              end;
          end;
     end;
end;


procedure TServerThread.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;

procedure TServerThread.RemoveItems_;
var i: integer;
begin
   for i:=0 to itemsList.Count-1 do
     if TAscItems(itemslist.Objects[i])<>nil then
          TAscItems(itemslist.Objects[i]).Free;
   itemsList.Clear;
end;


procedure TServerThread.Resetactiv;
var i,j: integer;
      AskItems_:  TAscItems;
       item: PTaskItem;
begin
   for i:=0 to itemslist.Count-1 do
     begin
        AskItems_:=TAscItems(itemslist.Objects[i]);
        for j:=0 to AskItems_.Count-1 do
         begin
          AskItems_[j].ref:=frtItems[AskItems_[j].id].refCount;
          AskItems_[j].activ:=(AskItems_[j].ref>0);
         end;
    end;
end;

procedure TServerThread.Analize;
var i: integer;
    AskItems_:  TAscItems;
begin
   //exit;
   if self.Terminated then exit;
   if assigned(analizefunc) then
        fanalizefunc(self,self.curReadid,self.curforceReadid) else
           for i:=0 to itemslist.Count-1 do
            begin
              AskItems_:=TAscItems(itemslist.Objects[i]);
              if assigned(AskItems_.analizefunc) then
               begin
                 AskItems_.analizefunc(AskItems_);
                 exit;
               end;
            end;
end;




function TServerThread.term: boolean;
begin
   result:=self.Terminated ;
end;

function TServerThread.GetforceAsk: integer;
var i: integer;
    AskItems_:  TAscItems;
begin
           result:=-1;
           exit;
       //    if not ForceControl then exit;
           for i:=0 to itemslist.Count-1 do
            begin
              AskItems_:=TAscItems(itemslist.Objects[i]);
              if AskItems_<>nil then
              {  if (AskItems_.freqDirectId>-1) then
                  if frtitems.Items[AskItems_.freqDirectId].ValReal>0 then
                   begin
                    if (secondsbetween(now,AskItems_.freqDirectTime)<AskItems_.DirectTimeOUT) then
                    begin
                    result:=i;
                    exit;
                    end else
                    begin
                     // frtitems.SetValid(AskItems_.freqDirectid,100);
                      frtitems.SetVal(AskItems_.freqDirectid,0,100);
                    end;
                   end;    }
            end;
end;

function TServerThread.ClearforceAsk: integer;
var i: integer;
    AskItems_:  TAscItems;
begin

           result:=-1;
           exit;

       {    if not ForceControl then exit;
           for i:=0 to itemslist.Count-1 do
            begin
              AskItems_:=TAscItems(itemslist.Objects[i]);
              //frtitems.SetValid(AskItems_.freqDirectid,100);
              frtitems.SetVal(AskItems_.freqDirectid,0,100);
            end;    }
end;

procedure TServerThread.SetforceAsk(val: integer; comid: integer; zval: real);
var i,j: integer;
    AskItems_, AskItems1_:  TAscItems;
begin

          exit;
         { if not ForceControl then exit;
           for i:=0 to itemslist.Count-1 do
            begin
              AskItems_:=TAscItems(itemslist.Objects[i]);
              if AskItems_<>nil then
                if (AskItems_.freqDirectId=val) and (val>-1) then
                begin
                  if frtitems.Items[AskItems_.freqDirectId].ValReal>0 then
                    begin
                    if (zval>0) then
                      begin
                      AskItems_.freqDirectTime:=now;
                      frtItems.SetCommandExecuted(comid);
                      frtitems.SetVal(AskItems_.freqDirectId,1,100);
                    //  frtitems.SetValid(AskItems_.freqDirectId,100);

                       for j:=0 to itemslist.Count-1 do
                         begin
                          AskItems1_:=TAscItems(itemslist.Objects[j]);
                          if AskItems1_<>nil then
                            begin
                              if j<>i then
                                begin
                                  if (AskItems1_.freqDirectId>-1) then
                                   begin
                                     //  frtitems.SetValid(AskItems1_.freqDirectId,100);
                                       frtitems.SetVal(AskItems1_.freqDirectId,0,100);
                                   end;
                                end;
                            end;
                         end;


                      end else
                      begin
                      AskItems_.freqDirectTime:=now;
                      frtItems.SetCommandExecuted(comid);
                      frtitems.SetVal(AskItems_.freqDirectId,0,100);
                     // frtitems.SetValid(AskItems_.freqDirectId,100);
                      end;
                    end
                    else
                    begin
                       for j:=0 to itemslist.Count-1 do
                         begin
                          AskItems1_:=TAscItems(itemslist.Objects[j]);
                          if AskItems1_<>nil then
                            begin
                              if j=i then
                                begin
                                // frtitems.SetValid(val,100);
                                 frtitems.SetVal(val,0,100);
                                 AskItems1_.freqDirectTime:=now;
                                 frtItems.SetCommandExecuted(comid);
                                end
                              else
                                begin
                                  if (AskItems1_.freqDirectId>-1) then
                                   begin
                                    //   frtitems.SetValid(AskItems1_.freqDirectId,100);
                                       frtitems.SetVal(AskItems1_.freqDirectId,0,100);
                                   end;
                                end;
                            end;
                         end;
                    end;
                    exit;
               end;
              end;     }
end;

procedure TServerThread.Stops;
var i: integer;
     AskItems_:  TAscItems;
begin
     for i:=0 to itemslist.Count-1 do
     begin
        AskItems_:=TAscItems(itemslist.Objects[i]);
         if AskItems_<>nil then
         begin
            if (AskItems_.freqId>-1) then   frtitems.SetVal(AskItems_.freqId,0,100);
            AskItems_.AllInvalid;
         end;
      end;
   synchronize(reset);
end;

procedure TServerThread.reset;
begin
 fisExecuted:=false;
  
end;

procedure TServerThread.Execute;

begin
try
fisExecuted:=true;
while not Terminated and fisExecuted do
begin

if not finitvar then synchronize(InitVar) else
 if not finitserv then synchronize(Initserv) else
  //synchronize(Analize);
  begin
   // if true then
   begin
  if not DORW then sleep (1000)
   else
    sleep (100);
   end;
  end;
end;
except
end;
fisExecuted:=false;
Stops;
end;

end.
