unit ServerU;

interface




uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, serverClasses, Comms, PLCComPort, Db, DBTables, Grids, DBGrids, math,
  uMyTimer, ServerThreadU, MemStructsU, ExtCtrls, ShellApi,MyComms,
    Spin, convFunc, {GlobalVar,} GroupsU, ConstDef, Menus, ComCtrls, ToolWin,globalValue,
  ImgList, ColorStringGrid,StrUtils,InterfaceServerU,rormres;

const
   WM_ICONNOTYFY=WM_USER+1324;

type
   TstatusServer = (ssStart, ssStop, ssNone);


type

  TFormComServer = class(TForm)
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    it1: TMenuItem;
    it2: TMenuItem;
    N3: TMenuItem;
    ImageList1: TImageList;
    PanelComD: TPanel;
    PanelSlaveD: TPanel;
    ColorStringGrid1: TColorStringGrid;
    ColorStringGrid2: TColorStringGrid;
    N1: TMenuItem;
    Timer1: TTimer;
//  procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItem1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure it1Click(Sender: TObject);
    procedure it2Click(Sender: TObject);
  private

    fAnalizeObject: TObject;
    fReadShapes: TList;
    fWriteShapes: TList;
    fPrevRefMsg: integer;
    FNID: TNotifyIconData;
    threadCOMList: TStringList;
    finittab: boolean;
    fcursor: integer;
    destructor Destroy; override;
    procedure setAnalizeObject(val: Tobject);
    procedure AnalizePortComD(Sender: TObject; val: integer; val1: integer);
    procedure AnalizeSlaveComD(Sender: TObject);
    procedure ChangeCL(var val: string; subval: string; nums: integer);
    procedure ChangeCommandLine(var val: string; stt: integer; stp: integer);
    procedure ChangeLine(comnum: integer; stt: integer; stp: integer);
    procedure Start;
    procedure Stop;
  public
    { Public declarations }
     fSattus: TstatusServer;
    procedure WMIconNotyfy(var messag: TMsg); message WM_ICONNOTYFY;
    procedure WMClose(var messag: TMsg); message WM_Close;
    procedure WMEterClose(var messag: TMsg); message WM_ALLETHERSERVERDESTROY;
    property AnalizeObject: TObject read fAnalizeObject write setAnalizeObject;
  end;

var
  FormComServer: TFormComServer;
function isCom(val: string;temp: string; var ComSet: TComSEt): integer;
implementation

{$R *.DFM}

// com1[br9600,7bd,1sb,pt1,trd50,red50,ri300,rtm3000,rtc3000,wtm3000,wtc3000]

function getparity(val: integer): string;
begin
  result:='none';
  if val=1 then result:='odd';
  if val=2 then result:='even';
  if val=3 then result:='mark';
  if val=4 then result:='space';
end;

function getRerr(val: integer): string;
begin
case val of
ERRP_R_NONE: result:='Ok';
ERRP_R_1:    result:='er_NoInit';
ERRP_R_2: result:='er_NoResp';
ERRP_R_3: result:='er_NoData';
ERRP_R_4: result:='er_CRC';
ERRP_R_5: result:='er_NoUnIit';
else  result:='er_Undef';
end;
end;

function getWerr(val: integer): string;
begin
case val of
ERRP_W_NONE: result:='Ok';
ERRP_W_1:    result:='er_Lblock';
ERRP_W_2:    result:='er_NoInit';
ERRP_W_3: result:='er_NoResp';
ERRP_W_4: result:='NoUnIit';
else  result:='er_Undef';
end;
end;

function getdatabit(val: integer): string;
begin
  result:='8';
  if val=5 then result:='5';
  if val=6 then result:='6';
  if val=7 then result:='7';
end;

function getstopbit(val: integer): string;
begin
  result:='1';
  if val=2 then result:='2';
  if val=3 then result:='1.5';

end;

function isCom(val: string;temp: string; var ComSet: TComSEt): integer;
  function findValNum(val: string; str: string):integer;
    var pos_,i: integer;
        numstr: string;
        fl: boolean;
    begin
       fl:=true;
       result:=-1000;
       numstr:='';
       val:=trim(uppercase(val));
       str:=trim(uppercase(str));
       pos_:=pos(val,str);
       if pos_<1 then exit;
       for i:=pos_+length(val) to length(str) do
         begin
           if fl then
            begin
             if ((str[i]=';') or (str[i]=',') or (str[i]=';')) then fl:=false else
             numstr:=numstr+str[i];
            end;
         end;
       try
         result:=strtoint(numstr);
       except
       end;
    end;

  function findtext(val: string; str: string):String;
    var pos_,i: integer;
        numstr: string;
        fl: boolean;
    begin
       fl:=true;
       result:='';
       numstr:='';
       val:=trim(uppercase(val));
       str:=trim(uppercase(str));
       pos_:=pos(val,str);
       if pos_<1 then exit;
       for i:=pos_+length(val) to length(str) do
         begin
           if fl then
            begin
             if ((str[i]=';') or (str[i]=',') or (str[i]=';')) then fl:=false else
             numstr:=numstr+str[i];
            end;
         end;
       try
         result:=numstr;
       except
       end;
    end;


 function getinVstring(var val: string; pref: string): string;
   var valU, PrefU, preftemp: string;
       i: integer;
   begin
     val:=trim(val);
     PrefU:=trim(uppercase(pref));
     valU:=trim(uppercase(val));
     if ((length(valU)+3)<(length(PrefU))) then
       begin
         val:='';
         result:='';
         exit;
       end;
    // if (pref<>'') then
       begin
          preftemp:=copy(valU,1,length(prefU)+1);
          if ((pref+'[')=(preftemp)) then
            begin
              i:=length(preftemp)+1;
              while ((ValU[i]<>']') and (i<=length(ValU))) do
                begin
                  result:=result+Val[i];
                  i:=i+1;
                end;
              if (i<length(ValU)) then val:=copy(val,i+1,length(valU)-i+1) else
              val:='';
            end;
       end;
   end;

var valUp,tempval: string;
    i,tempnum: integer;
    derpos: integer;
begin
   result:=-1;
   ComSet.Com:=1;
   ComSet.br:=9600;
   ComSet.db:=7;
   ComSet.sb:=1;
   ComSet.pt:=0;
   ComSet.trd:=60;
   ComSet.red:=50;
   ComSet.ri:=100;
   ComSet.rtm:=3000;
   ComSet.rtc:=3000;
   ComSet.wtm:=3000;
   ComSet.wtc:=3000;
   ComSet.bs:=64;
   ComSet.flCtrl:=false;
   ComSet.frt:=60;
   ComSet.trc:=3;
   ComSet.tstrt:=-1;
   ComSet.tstp:=61;
   ComSet.prttm:=500;
   Comset.wait:=3000;
   Comset.name:='';
   val:=trim(val);
   if val='' then exit;
   tempval:=trim(getinVstring(val,uppercase(temp)));

   if tempval<>'' then
    begin
           tempnum:=findValNum('com',tempval);
           if tempnum>0 then
             begin
             result:=tempnum;
             ComSet.Com:=tempnum;
             end
             else
             begin
             result:=1;
             ComSet.Com:=1;
             end;
           // com1[br9600,bd7,sb1,pt1,trd50,red50,ri300,rtm3000,rtc3000,wtm3000,wtc3000]
           tempnum:=findValNum('br',tempval);
           if tempnum>0 then
             ComSet.br:=tempnum;

            tempnum:=findValNum('bd',tempval);
           if (tempnum>4) and (tempnum<9) then
             ComSet.db:=tempnum;

           tempnum:=findValNum('sb',tempval);
           if (tempnum>0) and (tempnum<=3) then
             ComSet.sb:=tempnum;

           tempnum:=findValNum('pt',tempval);
           if (tempnum>-1) and (tempnum<5) then
             ComSet.pt:=tempnum;
           // com1[br9600,bd7,sb1,pt1,trd50,red50,ri300,rtm3000,rtc3000,wtm3000,wtc3000]

           tempnum:=findValNum('trd',tempval);
           if ((tempnum>-1) or (uppercase(temp)='ETH')) then
             begin
             ComSet.trd:=tempnum;
             ComSet.flCtrl:=true;
             end;

           tempnum:=findValNum('red',tempval);
           if  ((tempnum>-1) or (uppercase(temp)='ETH')) then
             begin
             ComSet.red:=tempnum;
             ComSet.flCtrl:=true;
             end;

           tempnum:=findValNum('ri',tempval);
           if (tempnum>-1) then
              ComSet.ri:=tempnum;

           tempnum:=findValNum('rtm',tempval);
           if (tempnum>-1) then
              ComSet.rtm:=tempnum;

           tempnum:=findValNum('rtc',tempval);
           if (tempnum>-1) then
              ComSet.rtc:=tempnum;

            tempnum:=findValNum('wtm',tempval);
           if ((tempnum>-1) or (uppercase(temp)='ETH')) then
              ComSet.wtm:=tempnum;

           tempnum:=findValNum('wtc',tempval);
           if (tempnum>-1) then
              ComSet.wtc:=tempnum;

           tempnum:=findValNum('bs',tempval);
           if (tempnum>-1) then
              ComSet.bs:=tempnum;

            tempnum:=findValNum('frt',tempval);
           if (tempnum>-1) then
              ComSet.frt:=tempnum;

           tempnum:=findValNum('frd',tempval);
           if (tempnum>-1) then
              ComSet.frd:=tempnum;

           tempnum:=findValNum('trc',tempval);
           if (tempnum>-1) then
              ComSet.trc:=tempnum;

           tempnum:=findValNum('tstrt',tempval);
           if (tempnum>-1) then
              ComSet.tstrt:=tempnum;
           tempnum:=findValNum('tstp',tempval);
           if (tempnum>-1) then
              ComSet.tstp:=tempnum;
           tempnum:=findValNum('prttm',tempval);
           if (tempnum>-1) then
              ComSet.prttm:=tempnum;
           tempnum:=findValNum('wait',tempval);
           if (tempnum>-1) then
              ComSet.wait:=tempnum;
           Comset.name:=findtext('name',tempval);



     end;
      if ((comset.trd=0) and (comset.red=0)) then
            comset.flCtrl:=false else
            comset.flCtrl:=true;
end;









procedure TFormComServer.FormCreate(Sender: TObject);
var
  i,j, slave,k, comN, Bound,temComNum, TempEthNum, idxThr: integer;
  serv, group, configinfo,host,group1, app, topic: string;
  ComSet: TComSEt;
  ServerThread: TServerThread;
  trn, trn1, trnopcbush, trnddebush: TtReeNode;
  acs: TAscItems;
begin
  fSattus:=ssStart;
  threadCOMList:=TStringList.Create;

  FNID.Wnd:=handle;
  FNID.uCallbackMessage:=WM_ICONNOTYFY;
  FNID.hIcon:=Icon.Handle;
  FNID.szTip:='DirectNet Com Server';
  FNID.uFlags:=nif_Message or nif_Icon or nif_Tip ;


  Start;

end;






procedure TFormComServer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 rtItems.Regs.UnRegHandle(Handle);
;
end;



procedure TFormComServer.Start;
var
  i,j, slave,k, comN, Bound,temComNum, TempEthNum, idxThr: integer;
  serv, group, configinfo,host,group1, app, topic: string;
  ComSet: TComSEt;
  ServerThread: TServerThread;
  trn, trn1, trnopcbush, trnddebush: TtReeNode;
  acs: TAscItems;
begin
  rtItems := TanalogMems.Create(PathMem);
  trnopcbush:=self.TreeView1.Items[1];
  for i:=0 to rtitems.TegGroups.Count-1 do
   begin
      serv:=rtItems.TegGroups.Items[i].App;
      group:=rtItems.TegGroups.Items[i].Name;
      topic:=rtItems.TegGroups.Items[i].Topic;
      slave:=rtItems.TegGroups.Items[i].SlaveNum;
      if trim(uppercase(serv))=trim(uppercase('DirectKoyoServ')) then
        begin
           temComNum:=isCOM(topic,'COM',ComSet);
           tempEthNum:=isCOM(topic,'ETH',ComSet);

           if ((temComNum>0) or (tempEthNum>0)) and (slave>0) then
             begin
                 if (temComNum>0) then
                 begin
                 isCOM(topic,'COM',ComSet);
                 idxThr:=threadCOMList.IndexOf('COM'+inttostr(temComNum))
                 end
                 else
                 begin
                  isCOM(topic,'ETH',ComSet);
                  idxThr:=threadCOMList.IndexOf('ETH'+inttostr(slave));
                 end;
                if (idxThr>-1) and (temComNum>0) then
                  begin

                     ServerThread:=TServerThread(threadCOMList.Objects[idxThr]);
                     acs:=ServerThread.AddItem(slave,group,ComSet);
                     for k:=0 to TreeView1.Items.Count-1 do
                     if (TreeView1.Items[k].Data=ServerThread) then
                       begin
                         trn:=TreeView1.Items[k];
                         trn.ImageIndex:=2;
                         trn.StateIndex:=2;
                         trn.SelectedIndex:=3;
                         trn1:=TreeView1.Items.AddChild(trn,group+'['+inttostr(slave)+']');
                         trn1.ImageIndex:=3;
                         trn1.StateIndex:=3;
                         trn1.SelectedIndex:=3;
                          trn1.Data:=pointer(acs);
                       end;

                  end else
                  begin
                    if (temComNum>0) then
                    begin
                    trn:=TreeView1.Items.AddChild(trnopcbush,'COM'+inttostr(temComNum));
                    ServerThread:=TServerThread.create(PathMem,temComNum,ComSet);
                    threadCOMList.AddObject('COM'+inttostr(temComNum),ServerThread);
                    end else
                    begin
                    trn:=TreeView1.Items.AddChild(trnopcbush,'Eth'+inttostr(slave));
                    ServerThread:=TServerThread.create(PathMem,ComSet,slave);
                    threadCOMList.AddObject('Eth'+inttostr(slave),ServerThread);
                    end;

                    acs:=ServerThread.AddItem(slave,group,ComSet);
                    trn.Data:=ServerThread;
                    trn1:=TreeView1.Items.AddChild(trn,group+'['+inttostr(slave)+']');
                    trn1.ImageIndex:=3;
                    trn1.StateIndex:=3;
                    trn1.SelectedIndex:=3;
                    trn1.Data:=pointer(acs);
                  end;
             end;
        end;
   end;
   for i:=0 to threadCOMList.Count-1 do
     TServerThread(threadCOMList.Objects[i]).Resume;
     rtItems.Regs.RegHandle('ImmiKoyoServ', Handle, [IMMINewRef, IMMIRemRef]);
 fSattus:=ssStart;
end;



procedure TFormComServer.Stop;
var
  i,j, slave,k, comN, Bound,temComNum, TempEthNum, idxThr: integer;
  serv, group, configinfo,host,group1, app, topic: string;
  ComSet: TComSEt;
  ServerThread: TServerThread;
  trn, trn1, trnopcbush, trnddebush: TtReeNode;
  acs: TAscItems;
  term: boolean;
begin

  try
  fSattus:=ssNone;
  rtItems.Regs.UnRegHandle(Handle);
  for i:=0 to threadCOMList.Count-1 do
   begin
     TServerThread(threadCOMList.Objects[i]).Terminate;
   //  TServerThread(threadCOMList.Objects[i]).WaitFor;

     //TServerThread(threadCOMList.Objects[i]).Terminate;
   end;
  for i:=0 to threadCOMList.Count-1 do
   begin
     //TServerThread(threadCOMList.Objects[i]).Terminate;
     TServerThread(threadCOMList.Objects[i]).WaitFor;

     //TServerThread(threadCOMList.Objects[i]).Terminate;
   end;
  // term:=true;
  // while (term) do
  // begin
  // term:=false;
  // for i:=0 to threadCOMList.Count-1 do
  //   begin
  //     if not TServerThread(threadCOMList.Objects[i]).term then
  //     term:=true;

    // end;
     sleep(1000);
  // end;


   for i:=0 to threadCOMList.Count-1 do
   begin
     TServerThread(threadCOMList.Objects[i]).Free;
   end;
   threadCOMList.Clear;
   trn:=nil;
   i:=0;
   while i<TreeView1.Items.Count do
       begin;
       if self.TreeView1.Items[i].Text='RS' then
       begin
         trn:=self.TreeView1.Items[i];
         while trn.Count>0 do
              trn.Item[0].Free;
       end;
       inc(i);
       end;
   rtItems.Free;

   finally
   fSattus:=ssStop;
   end;
end;




procedure TFormComServer.MenuItem1Click(Sender: TObject);
begin
  Show;
  BringWindowToTop(handle);
end;

procedure TFormComServer.WMClose(var messag: TMsg);
begin
messag.message:=0;
Hide;
end;


procedure TFormComServer.WMIconNotyfy(var messag: TMsg);
var pt: TPoint;
begin
if  fSattus=ssNone then exit;
if messag.wParam=WM_RBUTTONDOWN then
begin
getCursorPos(pt);
popupmenu1.Popup(pt.X,pt.y);
end;

end;

destructor TFormComServer.Destroy;
begin
  //server.Free;
  FNID.uFlags:=0;
  Shell_NotifyIcon(NIM_DELETE,@FNID);
  inherited;


end;


procedure TFormComServer.WMEterClose(var messag: TMsg);
begin
 messag.message:=0;
 Hide;
end;

procedure TFormComServer.N3Click(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE,@FNID);
FormComServer.Close;
stop;

end;



procedure TFormComServer.TreeView1Click(Sender: TObject);
var i: integer;
    NodeS: TTreeNode;
begin
     for i:=0 to self.TreeView1.Items.Count-1 do
      if  self.TreeView1.Items[i].Selected then
        NodeS:=self.TreeView1.Items[i];
    setAnalizeObject(Nodes.data);
end;


procedure TFormComServer.setAnalizeObject(val: Tobject);
var i: integer;
begin
   if (val<>fAnalizeObject) then
    begin
      if (fAnalizeObject<>nil) then
       begin
        if (fAnalizeObject is TServerThread) then
        TServerThread(fAnalizeObject).AnalizeFunc:=nil;
        if (fAnalizeObject is TAscItems) then
        TAscItems(fAnalizeObject).AnalizeFunc:=nil;
       end;

       if (val<>nil) then
       begin
        if (val is TServerThread) then
        begin
        TServerThread(val).AnalizeFunc:=AnalizePortComD;
        end;
        if (val is TAscItems) then
        begin
        TAscItems(val).AnalizeFunc:=AnalizeSlaveComD;
        end;
       end;
    end;
    fAnalizeObject:=val;
    PanelComD.Visible:=(fAnalizeObject is TServerThread);
    PanelSlaveD.Visible:=(fAnalizeObject is TAscItems);
    finittab:=true;
    fcursor:=0;
end;

procedure TFormComServer.AnalizePortComD(Sender: TObject; val: integer; val1: integer);
 var tst: TServerThread ;
     i,j: integer;
     asc: TAscItems ;
begin
   if (sender is TServerThread) then
     begin
        tst:=(sender as TServerThread);
        if finittab then
        begin
        ColorStringGrid2.Cells[0, 0] := 'num';
        ColorStringGrid2.Cells[1, 0] := 'group';
        ColorStringGrid2.Cells[2, 0] := 'br';
        ColorStringGrid2.Cells[3, 0] := 'databit';
        ColorStringGrid2.Cells[4, 0] := 'stopbit';
        ColorStringGrid2.Cells[5, 0] := 'parity';
        ColorStringGrid2.Cells[6, 0] := 'ri';
        ColorStringGrid2.Cells[7, 0] := 'rtm';
        ColorStringGrid2.Cells[8, 0] := 'rtc';
        ColorStringGrid2.Cells[9, 0] := 'wtm';
        ColorStringGrid2.Cells[10, 0] := 'wtc';
        ColorStringGrid2.Cells[11, 0] := 'fconrl';
        ColorStringGrid2.Cells[12, 0] := 'red';
        ColorStringGrid2.Cells[13, 0] := 'trd';
        ColorStringGrid2.Cells[14, 0] := 'block';
        ColorStringGrid2.Cells[15, 0] := 'count';
           ColorStringGrid2.Cells[16, 0] := 'ReadErr';
        ColorStringGrid2.Cells[17, 0] := 'WriteErr';
        ColorStringGrid2.Cells[18, 0] := 'delay';
        ColorStringGrid2.Cells[19, 0] := 'forcedelay';
        ColorStringGrid2.Cells[20, 0] := 'trcount';
        ColorStringGrid2.Cells[21, 0] := 'tstrt';
        ColorStringGrid2.Cells[22, 0] := 'tstp';
        ColorStringGrid2.Cells[23, 0] := 'prottm';
        ColorStringGrid2.Cells[24, 0] := 'wait';
        ColorStringGrid2.RowCount:=tst.itemsList.Count+1;
        finittab:=false;
        end;

        for j:=0 to tst.itemsList.Count-1 do
               begin

                 asc:=TAscItems(tst.itemsList.objects[j]);
                       if (asc.ProterrR=0) and (asc.ProterrW=0) then
                 ColorStringGrid2.fRows.Items[j+1].font.color:=clgreen else
                     ColorStringGrid2.fRows.Items[j+1].font.color:=clred;
                     if ((val)=j) then
                      begin
                       if  val<=ColorStringGrid2.fRows.Count then
                            ColorStringGrid2.fRows.Items[val+1].font.color:=clBlue;
                      end;
                     // else
                    //         ColorStringGrid2.fRows.Items[val+1].font.style:=ColorStringGrid2.fRows.Items[val+1].font.style-[fsBold];
                 ColorStringGrid2.Cells[0, j+1] := inttostr(j);
                 ColorStringGrid2.Cells[1, j+1] := asc.groupname;
                 ColorStringGrid2.Cells[2, j+1] := inttostr(asc.fComSet.br);
                 ColorStringGrid2.Cells[3, j+1] := getdatabit(asc.fComSet.db);
                 ColorStringGrid2.Cells[4, j+1] := getstopbit(asc.fComSet.sb);
                 ColorStringGrid2.Cells[5, j+1] := getparity(asc.fComSet.pt);
                 ColorStringGrid2.Cells[6, j+1] := inttostr(asc.fComSet.ri);
                 ColorStringGrid2.Cells[7, j+1] := inttostr(asc.fComSet.rtm);
                 ColorStringGrid2.Cells[8, j+1] := inttostr(asc.fComSet.rtc);
                 ColorStringGrid2.Cells[9, j+1] := inttostr(asc.fComSet.wtm);
                 ColorStringGrid2.Cells[10, j+1] := inttostr(asc.fComSet.wtc);
                 if  asc.fComSet.flCtrl then
                  begin
                   ColorStringGrid2.Cells[11, j+1] := 'flcont';
                   ColorStringGrid2.Cells[12, j+1] := inttostr(asc.fComSet.red);
                   ColorStringGrid2.Cells[13, j+1] := inttostr(asc.fComSet.trd);
                  end
                 else
                  begin
                   ColorStringGrid2.Cells[11, j+1] := '-';
                   ColorStringGrid2.Cells[12, j+1] := '-';
                   ColorStringGrid2.Cells[13, j+1] := '-';
                  end;
                 ColorStringGrid2.Cells[14, j+1] := inttostr(asc.fComSet.bs);
                 ColorStringGrid2.Cells[15, j+1] := inttostr(asc.Count);
                 ColorStringGrid2.Cells[16, j+1] := getRerr(asc.ProterrR);
                 ColorStringGrid2.Cells[17, j+1] := getWerr(asc.ProterrW);
                 ColorStringGrid2.Cells[18, j+1] := inttostr(asc.fComSet.frt);
                 ColorStringGrid2.Cells[19, j+1] := inttostr(asc.fComSet.frd);
                 ColorStringGrid2.Cells[20, j+1] := inttostr(asc.fComSet.trc);
                 ColorStringGrid2.Cells[21, j+1] := inttostr(asc.fComSet.tstrt);
                 ColorStringGrid2.Cells[22, j+1] := inttostr(asc.fComSet.tstp);
                  if  asc.fComSet.flCtrl then
                  begin
                 ColorStringGrid2.Cells[23, j+1] := inttostr(asc.fComSet.prttm);
                 end else
                   ColorStringGrid2.Cells[23, j+1] := '-';
                 ColorStringGrid2.Cells[24, j+1] := inttostr(asc.fComSet.wait);
               end;
     end;
end;

procedure TFormComServer.AnalizeSlaveComD(Sender: TObject);
  var asc: TAscItems ;
      j: integer;
begin
    if (sender is TAscItems) then
     begin
       asc:=(sender as TAscItems);
       if finittab then
       begin
       ColorStringGrid1.Cells[0, 0] := 'ID';
       ColorStringGrid1.Cells[1, 0] := 'Элемент';
       ColorStringGrid1.Cells[2, 0] := 'name';
       ColorStringGrid1.Cells[3, 0] := 'Адрес';
       ColorStringGrid1.Cells[4, 0] := 'Преобразование';
       ColorStringGrid1.Cells[5, 0] := '№ бита';
       ColorStringGrid1.Cells[6, 0] := 'Предыдущее значение';
       ColorStringGrid1.Cells[7, 0] := 'minRaw';
       ColorStringGrid1.Cells[8, 0] := 'maxRaw';
       ColorStringGrid1.Cells[9, 0] := 'minEu';
       ColorStringGrid1.Cells[10, 0] := 'maxEu';
       ColorStringGrid1.Cells[11, 0] := 'ref';
       ColorStringGrid1.Cells[12, 0] := 'active';
       ColorStringGrid1.RowCount:=asc.Count+1;
       finittab:=false;
      end;
      for j:=0 to asc.Count-1 do
               begin

                 ColorStringGrid1.Cells[0, j+1] := inttostr(j);
                 ColorStringGrid1.Cells[1, j+1] := inttostr(asc[j].id);
                 ColorStringGrid1.Cells[2, j+1] := asc[j].name;
                 ColorStringGrid1.Cells[3, j+1] := inttostr(asc[j].addr);;
                 ColorStringGrid1.Cells[4, j+1] := inttostr(asc[j].bitNumber);;
                 ColorStringGrid1.Cells[5, j+1] := floattostr(asc[j].prevValue);
                 ColorStringGrid1.Cells[6, j+1] := floattostr(asc[j].minRaw);;
                 ColorStringGrid1.Cells[7, j+1] := floattostr(asc[j].maxRaw);;
                 ColorStringGrid1.Cells[8, j+1] := floattostr(asc[j].MinEu);;
                 ColorStringGrid1.Cells[9, j+1] := floattostr(asc[j].maxEU);;
                 ColorStringGrid1.Cells[10, j+1] := inttostr(asc.fComSet.wtc);
                 ColorStringGrid1.Cells[11, j+1] := floattostr(asc[j].ref);
                 if asc[j].activ then
                 ColorStringGrid1.Cells[12, j+1] := 'A' else
                 ColorStringGrid1.Cells[12, j+1] := 'N';
             end;
      end;
end;


procedure TFormComServer.N1Click(Sender: TObject);
var I,j,num: integer;
    num1,num2: integer;
begin
  num:=0;
   FormRecept.ColorStringGrid1.Cells[1,0]:=
   'Время старта';
   FormRecept.ColorStringGrid1.Cells[2,0]:=
   'Время окончания';
  for i:=0 to threadCOMList.Count-1 do
   if TServerThread(threadCOMList.Objects[i]).itemsList.Count>0 then inc(num);
    FormRecept.ColorStringGrid1.RowCount:=1+num;
  for i:=0 to threadCOMList.Count-1 do
   if TServerThread(threadCOMList.Objects[i]).itemsList.Count>0  then
    begin
     inc(num);
       FormRecept.ColorStringGrid1.Cells[1,num-1]:=
            inttostr(TAscItems(TServerThread(threadCOMList.Objects[i]).itemsList.Objects[0]).fComSet.tstrt);
       FormRecept.ColorStringGrid1.Cells[2,num-1]:=
            inttostr(TAscItems(TServerThread(threadCOMList.Objects[i]).itemsList.Objects[0]).fComSet.tstp);
    end;
   if FormRecept.ShowModal=MrOk then
     begin
       num:=0;
       for i:=0 to threadCOMList.Count-1 do
         if TServerThread(threadCOMList.Objects[i]).itemsList.Count>0 then
         begin
         inc(num);
          for  j:=0 to TServerThread(threadCOMList.Objects[i]).itemsList.Count-1 do
            begin
            try

            num1:=strtointdef(trim(FormRecept.ColorStringGrid1.Cells[1,num]),0);
            num2:=strtointdef(trim(FormRecept.ColorStringGrid1.Cells[2,num]),61);
            TAscItems(TServerThread(threadCOMList.Objects[i]).itemsList.Objects[j]).fComSet.tstrt:=num1;
            TAscItems(TServerThread(threadCOMList.Objects[i]).itemsList.Objects[j]).fComSet.tstp:=num2;
            ChangeLine(TServerThread(threadCOMList.Objects[i]).fcomNum,
                  num1,
                  num2);
            except
            end;
            end;
            end;
        try
        rtitems.TegGroups.SaveToFile(Pathmem + 'Groups.cfg');
        except
        end;
     end;
end;


procedure TFormComServer.ChangeCommandLine(var val: string; stt: integer; stp: integer);
begin
   ChangeCL(val,'tstrt',stt);
   ChangeCL(val,'tstp',stp);
end;

procedure TFormComServer.ChangeLine(comnum: integer; stt: integer; stp: integer);
var i,g: integer;
    val: string;
    k: TComSet;
begin
   for i:=0 to rtitems.TegGroups.Count-1 do
     begin
      g:=isCom(rtitems.TegGroups.Items[i].Topic,'COM',k);
      if (g=comnum) then
        begin
        val:=rtitems.TegGroups.Items[i].Topic;
        ChangeCommandLine(val,stt,stp);
        rtitems.TegGroups.Items[i].Topic:=val;
        end;
     end;
     rtitems.TegGroups.Items[i].Topic:=val;
end;



procedure TFormComServer.ChangeCL(var val: string; subval: string; nums: integer);
var vals: string;
    begstr, endstr: string;
    begI, endI,i: integer;

begin
  if length(trim(val))<1 then
   exit;
  vals:=uppercase(val);
  begI:=pos(uppercase(subval),vals);
  if pos(uppercase(subval),vals)>0 then
    begin
      begstr:=LeftStr(val,begI-1);
      endI:=begI+5;
      while (val[endI]<>',') and (val[endI]<>']') and (endI<=length(val)) do
       begin
          inc(endI);
       end;
       endstr:=RightStr(val,length(val)-endI+1);
    end else
    begin
      begI:=pos(']',val);
      if begI>0 then
           begin
             begstr:=LeftStr(val,begI-1);
             endstr:=RightStr(val,length(val)-begI+1);
              val:=begstr+','+subval+inttostr(nums)+endstr;
              EXIT;
           end else exit;
    end;
    val:=begstr+subval+inttostr(nums)+endstr;
end;

procedure TFormComServer.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=not Shell_NotifyIcon(NIM_ADD,@FNID);
end;

procedure TFormComServer.PopupMenu1Popup(Sender: TObject);
begin
  it1.Visible:=(self.fSattus=ssStop);
  it2.Visible:=(self.fSattus=ssStart);
end;

procedure TFormComServer.it1Click(Sender: TObject);
begin
start;
end;

procedure TFormComServer.it2Click(Sender: TObject);
begin
  stop;
end;

end.
