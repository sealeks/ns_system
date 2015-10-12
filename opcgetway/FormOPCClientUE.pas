unit FormOPCClientUE;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OPCClient,  Grids, Menus, uMyTimer,OPCDA,
  ExtCtrls, Spin,  math,  MemStructsU,OPCerror, ActiveX, DDEClient,
   convFunc, GlobalValue,{Globalvar ,} GroupsU, ConstDef, ShellApi, Contnrs,
  Scope, IMMIScope, ComCtrls, ImgList, ColorStringGrid;


const
   WM_ICONNOTYFY=WM_USER+1324;


  type

  TFormDDEClient = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Cnfhn1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    Timer1: TTimer;
    ColorStringGrid1: TColorStringGrid;
    ColorStringGrid2: TColorStringGrid;
    ColorStringGrid4: TColorStringGrid;
    ColorStringGrid3: TColorStringGrid;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TreeView1: TTreeView;
    Timer3: TTimer;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    PanelOPCgroup: TPanel;
    PanelGroupOPC: TPanel;
    Label1: TLabel;
    OPCGroupName: TLabel;
    PanelOPCServer: TPanel;
    PanelServerOPC: TPanel;
    Label2: TLabel;
    ServerName: TLabel;
    Label3: TLabel;
    ServerStatus: TLabel;
    Label5: TLabel;
    lbVendorName: TLabel;
    Label7: TLabel;
    lbStartTime: TLabel;
    lbCurTime: TLabel;
    Label10: TLabel;
    lbLuTime111: TLabel;
    lbLUTIME: TLabel;
    Label8: TLabel;
    lbGroupCount: TLabel;
    lbVerOPC: TLabel;
    lbVerOPC11: TLabel;
    PanelDDETopicItem: TPanel;
    Panel2: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    PanelDDETopic: TPanel;
    Panel3: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure WMIconNotyfy(var messag: TMsg); message WM_ICONNOTYFY;
    procedure WMClose(var messag: TMsg); message WM_Close;
    procedure WMEterClose(var messag: TMsg); message WM_ALLETHERSERVERDESTROY;
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    DDEservliststr: TDDEServlist;
    fAnalizeObject: TObject;
    FNID: TNotifyIconData;
    fPrevRefMsg: integer;
    isConnection: boolean;
    Cursor: integer;
    tablCount: integer;
    ticknetid: integer;
    tablInit: boolean;
    activnetid: integer;
    laststate:  integer;
    lasttime: tdatetime;
    isAnalis: boolean;
    servlist: tstringList;
    analiztopic: string;
    analizeserver: string;
    analizecount: integer;
    procedure ButtonStartClick(Sender: TObject);
     procedure WMIMMINewRef(var Mess: TMessage); message WM_IMMINewRef;
    procedure WMIMMIRemRef(var Mess: TMessage); message WM_IMMIRemRef;
    procedure setAnalizeObject(val: Tobject);
    procedure AnalizeOPC(Sender: TObject);
    procedure AnalizeDDE(Sender: TObject);
    procedure AnalizeDDETopic(Sender: TObject);
  public
    { Public declarationsect }
     destructor Destroy; override;
     property AnalizeObject: TObject read fAnalizeObject write setAnalizeObject;
  end;

var
  FormDDEClient: TFormDDEClient;
//  rtItems : TanalogMems;
  ttimestartt: integer;
  yj: TDPoint;
  testCount: integer;

  function isOPC(val: string; var host: string; var grn: string): string;
  function isDDE(val: string; var host: string; var topic: string): string;
  procedure GetOPCConfig(val: string; var UR: DWORD; var PD: single; var Nadv: boolean);

implementation

{$R *.DFM}

function OPCIrr(val: Longint): string;
begin
    result:='';
    if (val=0) then result:='OK';
    if (val=OPC_E_UNKNOWNPATH) then result:='UNKNOWNPATH';
    if (val=OPC_E_BADRIGHTS) then result:='BADRIGHTS';
    if (val=OPC_E_BADTYPE) then result:='BADTYPE';
    if (val=OPC_E_BUSY) then result:='BUSY';
    if (val=OPC_E_DUPLICATENAME) then result:='DUPLICATENAME';
    if (val=OPC_E_INVALIDBRANCHNAME) then result:='INVALIDBRANCHNAME';
    if (val=OPC_E_INVALIDCONFIGFILE) then result:='INVALIDCONFIGFILE';
    if (val=OPC_E_INVALIDFILTER) then result:='INVALIDFILTER';
    if (val=OPC_E_INVALIDHANDLE) then result:='INVALIDHANDLE';

    if (val=OPC_E_INVALIDITEMID) then result:='INVALIDITEMID';
    if (val=OPC_E_INVALIDTIME) then result:='INVALIDTIME';
    if (val=OPC_E_INVALID_PID) then result:='INVALID_PID';
    if (val=OPC_E_NOINFO) then result:='NOINFO';
    if (val=OPC_E_PUBLIC) then result:='PUBLIC';
    if (val=OPC_E_RANGE) then result:='RANGE';
    if (val=OPC_E_UNKNOWNITEMID) then result:='UNKNOWNITEMID';
    if (val=OPC_E_UNKNOWNPATH) then result:='UNKNOWNPATH';
    if (val=OPC_S_ALREADYACKED) then result:='ALREADYACKED';

    if (val=OPC_S_CLAMP) then result:='CLAMP';
    if (val=OPC_S_INUSE) then result:='INUSE';
    if (val=OPC_S_INVALIDBUFFERTIME) then result:='INVALIDBUFFERTIME';
    if (val=OPC_S_INVALIDMAXSIZE) then result:='INVALIDMAXSIZE';
    if (val=OPC_S_UNSUPPORTEDRATE) then result:='UNSUPPORTEDRATE';
    if result='' then result:='NODEF';
end;

function DDEerrType(val: Longint): string;
begin
    result:='';
    if (val=0) then result:='OK';
    if (val=1) then result:='NULLDATA';
    if (val=2) then result:='CONVRT_ERR';
    if (val=3) then result:='NULLSTR';
    if (val=999) then result:='NORESPON';
end;

function OPCType(val: Longint): string;
begin
    result:='';
    if (val=0) then result:='empty';
    if (val=VT_NULL) then result:='null';
    if (val=VT_I2) then result:='int2';
    if (val=VT_I4) then result:='int4';
    if (val=VT_R4) then result:='real4';
    if (val=VT_R8) then result:='real8';
    if (val=VT_CY) then result:='currency';
    if (val=VT_DATE) then result:='date';
    if (val=VT_BSTR) then result:='bstr';
    if (val=VT_DISPATCH) then result:='dispatch';

    if (val=VT_ERROR) then result:='err';
    if (val=VT_BOOL) then result:='bool';
    if (val=VT_VARIANT) then result:='variant';
    if (val=VT_UNKNOWN) then result:='unknown';
    if (val=VT_DECIMAL) then result:='dec';
    if (val=VT_I1) then result:='char';
    if (val=VT_UI1) then result:='un char';
    if (val=VT_UI2) then result:='un short';
    if (val=VT_UI4) then result:='un long';
    if (val=VT_I8) then result:='int64';
    if (val=VT_UI8) then result:='un int64';
    if (val=VT_INT) then result:='int';
    if (val=VT_UINT) then result:='un int';
    if (val=VT_UI4) then result:='un long';
    if (val=VT_VOID) then result:='void';
    if (val=VT_HRESULT) then result:='hresult';
    if (val=VT_PTR) then result:='ptr';

    if (val=VT_SAFEARRAY) then result:='variant array';
    if (val=VT_CARRAY) then result:='style array';
    if (val=VT_USERDEFINED) then result:='user def';
    if (val=VT_LPSTR) then result:='pstring';
    if (val=VT_LPWSTR) then result:='pwidestring';

    if (val=VT_FILETIME) then result:='filetime';
    if (val=VT_BLOB) then result:='blob';
    if (val=VT_STREAM) then result:='stream';
    if (val=VT_VECTOR) then result:='vector';
    if (val=VT_ARRAY) then result:='array';

    if (val=VT_BYREF) then result:='byteref';
    if (val=VT_BLOB) then result:='blob';
    if (val=VT_RESERVED) then result:='reserved';
    if (val=VT_ILLEGAL) then result:='illegal';
    if (val=VT_ILLEGALMASKED) then result:='il mask';
    if (val=VT_TYPEMASK) then result:='type mask';

    if result='' then result:='nodef';
end;

procedure GetOPCConfig(val: string; var UR: DWORD; var PD: single; var Nadv: boolean);
var urStr, PDStr, flaStr: string;
    i: integer;
    flU, flP, FlA: boolean;
begin
   UR:=0;
   urStr:='';
   PDStr:='';
   flaStr:='';
   PD:=0;
   flU:=false;flP:=false;FlA:=false;
   val:=uppercase(trim(val));
   for i:=1 to length(val) do
     begin
        if (val[i]='U') then begin flU:=true; flP:=false; end;
        if (val[i]='P') then begin flU:=false; flP:=true; end;
        if (val[i]='N') then begin flA:=false; flA:=true;FlaStr:=val[i]; end;
        if (val[i]='/') or (val[i]='\') then begin flU:=false; flP:=false; flA:=false; end;
        if (val[i]<>'U') and (val[i]<>'P') and (val[i]<>'N') then
          begin
             if (flU) then urStr:=urStr+val[i];
             if (flP) then PDStr:=PDStr+val[i];
             if (flA) then FlaStr:=flaStr+val[i];
          end;
     end;
       urStr:=trim(urStr);
       PDStr:=trim(PDStr);
       FlaStr:=trim(FlaStr);
     try
       UR:=strtoint(urStr);
     except
     end;
      try
       PD:=strtofloat(PDStr);
     except
     end;
     Nadv:=(FlaStr<>'');
end;

function OPCQual(val: cardinal): string;
begin
    result:='';
   // if (val=0) then result:='OK';
    if (val=OPC_QUALITY_BAD) then result:='bad';
    if (val=OPC_QUALITY_UNCERTAIN) then result:='unc';
    if (val=OPC_QUALITY_GOOD) then result:='good';
    if result='' then result:='nodf';
end;


// for DDE
//
//   APPNAME -> dde[SERVERNAME|TOPICNAME][host:HOST]
//   TOPIC -> UR NUM RD MUM.NUM
      // SERVERNAME - имя сервера
      // TOPICNAME - DDE тема
      // HOST -хост
      //




function isDDE(val: string; var host: string; var topic: string): string;
 function getinVstring(var val: string; pref: string): string;
   var valU, PrefU, preftemp: string;
       i: integer;
   begin
     val:=trim(val);
     result:='';
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
    i: integer;
    derpos: integer;
begin
   result:='';
   host:='';
   topic:='';
   val:=trim(val);
   if val='' then exit;
   result:=trim(getinVstring(val,'DDE'));
   if result<>'' then
    begin
       derpos:=pos('|',result);
       if (derpos>0) then
         begin
            if (derpos<length(result)) then
            topic:=trim(copy(result,derpos+1,length(result)-derpos));
            result:=trim(copy(result,1,derpos-1));
         end;
    end;
   if ((result<>'') and (val<>'')) then
     begin
       tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);

         tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);

     end;
end;


// for OPC
//
//   APPNAME -> opc[SERVERNAME][host:HOST][group:OPCGROUPNAME]
//   TOPIC -> Unn/Pmm.m/N RD MUM.NUM
     // SERVER - имя сервера
     // HOST -хост
     // OPCGROUPNAME - имя группы OPC
     // U -период обновления данных
     // P - мертвая зона сервера в прцентах
     // N - синхронный интерфейс

function isOPC(val: string; var host: string; var grn: string): string;
 function getinVstring(var val: string; pref: string): string;
   var valU, PrefU, preftemp: string;
       i: integer;
   begin
     val:=trim(val);
     result:='';
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
    i: integer;
begin
   result:='';
   host:='';
   grn:='';
   val:=trim(val);
   if val='' then exit;
   result:=trim(getinVstring(val,'OPC'));
   if ((result<>'') and (val<>'')) then
     begin
       tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);
       if (length(tempval)>6) and (uppercase(copy(tempval,1,6))='GROUP:')
               then grn:=copy(tempval,7,length(tempval)-6);
         tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);
       if (length(tempval)>6) and (uppercase(copy(tempval,1,6))='GROUP:')
               then grn:=copy(tempval,7,length(tempval)-6);
     end;
end;





procedure TFormDDEClient.FormCreate(Sender: TObject);
var
  fl: integer;
  i,j, slave,k: integer;
  serv, group, configinfo,host,group1, app, topic: string;
  servliststr: tstringList;
  client: TOPCClient;
  trn, trn1, trnopcbush, trnddebush: TtReeNode;
  obj: Tobject;
  opcPD: single;
  opcUR: DWORD;
  indx: integer;
  topicList: TstringList;
  ddetopicList: TDDETopiclist;
  ddecli : TDDEClient;
  noadv: boolean;
begin
  tablCount:=0;
  tablInit:=false;
  Cursor:=0;
  fAnalizeObject:=nil;
  servliststr:=tstringList.Create;
  servlist:=tstringList.Create;
  DDEservliststr:=TDDEServlist.Create;
  ticknetid:=-1;
  activnetid:=-1;
  isConnection:=false;
  FNID.Wnd:=handle;
  FNID.uCallbackMessage:=WM_ICONNOTYFY;
  FNID.hIcon:=Icon.Handle;
  FNID.szTip:='DDE Client';
  FNID.uFlags:=nif_Message or nif_Icon or nif_Tip ;
  rtItems := TanalogMems.Create(PathMem);
  trnopcbush:=self.TreeView1.Items[1];
  trnddebush:=self.TreeView1.Items[2];
  testCount:=0;
  for i:=0 to rtitems.TegGroups.Count-1 do
   begin

      serv:=rtItems.TegGroups.Items[i].App;
      group:=rtItems.TegGroups.Items[i].Name;
      slave:=rtItems.TegGroups.Items[i].SlaveNum;
      configinfo:=rtItems.TegGroups.Items[i].Topic;
      GetOPCConfig(configinfo,opcUR,opcPD,noadv);
      serv:=isOPC(serv,host,group1);
      if (trim(serv)<>'') then
        begin
          fl:=-1;
          for j:=0 to servlist.Count-1 do
            begin
               if ((TOPCClient(servlist.Objects[j]).isCurTread(serv,group,slave,host)) and
                              (fl<0)) then
                  begin
                    fl:=j;
                  end;
            end;
          if (fl<0) then
           begin
           client:=TOPCClient.Create(serv,pathMem, slave,host, noadv);
           servlist.AddObject(serv,client);
           trn:=TreeView1.Items.AddChild(trnopcbush,serv+':'+inttostr(slave));
           trn.Data:=client.getServer;
           if host='' then
           trn.Text:=serv+':'+inttostr(slave)
           else
           trn.Text:='['+host+']'+serv+':'+inttostr(slave);
           trn.ImageIndex:=5;
           obj:=client.AddClGroup(group,slave,opcPD,opcUR);
           trn1:=TreeView1.Items.AddChild(trn,group);
           trn1.Data:=obj;
           trn1.Text:=group;
           trn1.ImageIndex:=6;
           end else
           begin
           client:=TOPCClient(servlist.Objects[fl]);
           obj:=client.AddClGroup(group,slave,opcPD,opcUR);
           for k:=0 to self.TreeView1.Items.Count-1 do
              if self.TreeView1.Items[k].Data=client then trn:=self.TreeView1.Items[k];
           if trn<>nil then
             begin
                 trn1:=TreeView1.Items.AddChild(trn,group);
                 trn1.Data:=obj;
                 trn1.Text:=group;
                 trn1.ImageIndex:=6;
             end;   
           end;
        end;
   end;
   for i:=0 to servlist.Count-1 do
     TOPCClient(servlist.Objects[i]).Resume;




   for i:=0 to rtItems.Count-1 do
    begin
     if (rtItems.Items[i].id>-1) then
      begin
        app:=isDDE(rtItems.TegGroups.GetAppbyNum(rtItems[i].GroupNum),host,topic);
        if (app<>'') then
          begin

            if (DDEservliststr.IndexOf(trim(app))<0) then
                begin
                ddetopicList:=TDDETopiclist.Create(app);
                DDEservliststr.AddObject(trim(app),ddetopicList);
                trn:=TreeView1.Items.AddChild(trnddebush,app);
                trn.Data:=ddetopicList;
                trn.Text:=app;
                trn.ImageIndex:=4;
                end;
                ddetopicList:=TDDETopiclist(DDEservliststr.objects[DDEservliststr.IndexOf(trim(app))]);
                indx:=DDEservliststr.IndexOf(trim(app));
                ddetopicList:=TDDETopiclist(DDEservliststr.objects[indx]);
                //topic:=rtItems.TegGroups.GetTopicbyNum(rtItems[i].GroupNum);
                  if (topic<>'') then
                     begin
                       topicList:=TstringList(DDEservliststr.objects[indx]);


                       if topicList.IndexOf(trim(topic))<0 then
                         begin
                            for j:=0 to TreeView1.Items.Count-1 do
                           if (TreeView1.Items[j].Data=ddetopicList) then
                           trn:=TreeView1.Items[j];
                            topicList.Add(trim(topic));
                            trn:=TreeView1.Items.AddChild(trn,topic);
                            trn.Text:=topic;
                            trn.Data:=TDDETopicItem.Create(topic,app);
                            trn.ImageIndex:=7;
                         end else
                           begin

                           end;
                     end;
          end;
        end;
    end;
 if (DDEservliststr.Count>0) then
 begin
    ddecl := TDDEClient.Create(PathMem);
    ddecl.Resume;
 end;

  rtItems.RegHandle('IMMIddebridge', self.handle, [IMMIall]);
  isConnection:=true;
  isAnalis:=false;

end;





procedure TFormDDEClient.ButtonstartClick(Sender: TObject);


begin

end;

procedure TFormDDEClient.N1Click(Sender: TObject);
begin
Show;
BringWindowToTop(handle);
end;

procedure TFormDDEClient.N3Click(Sender: TObject);  // завершить убрано
begin
Shell_NotifyIcon(NIM_DELETE,@FNID);
end;


procedure TFormDDEClient.WMClose(var messag: TMsg);
begin
messag.message:=0;
Hide;
end;

procedure TFormDDEClient.WMIconNotyfy(var messag: TMsg);
var pt: TPoint;
begin
if not isConnection then exit;
if messag.wParam=WM_RBUTTONDOWN then
begin
getCursorPos(pt);
popupmenu1.Popup(pt.X,pt.y);
end;

end;

destructor TFormDDEClient.Destroy;
begin

  FNID.uFlags:=0;
  Shell_NotifyIcon(NIM_DELETE,@FNID);
  inherited;
end;


procedure TFormDDEClient.WMEterClose(var messag: TMsg);
begin
  N3Click(nil);
end;


procedure TFormDDEClient.WMIMMIRemRef(var Mess: TMessage);
var i:integer;
begin

end;



procedure TFormDDEClient.WMIMMINewRef(var Mess: TMessage);
var i:integer;
begin


end;

procedure TFormDDEClient.FormDestroy(Sender: TObject);
begin
   rtItems.UnRegHandle(application.Handle);
 
   sleep(1000);
  // ddeclients.Free;
   if  (activnetid>-1) and (ticknetid>-1) then
         begin
         rtitems.decCounter(activnetid);
         rtitems.decCounter(ticknetid);
         end;
         rtitems.Free;


end;




 procedure TFormDDEClient.Timer3Timer(Sender: TObject);
begin
  try
   Timer3.Enabled:= not Shell_NotifyIcon(NIM_ADD,@FNID);
   except
   end;
end;

procedure TFormDDEClient.AnalizeOPC(Sender: TObject);
var i,j,k, ver: integer;
    opsList: TItemOPCs;
    servGrInfos: TOPCClientCell;
    tim: _FILETIME;
    tims: _SYSTEMTIME;
    verstr: string;
begin
  if (Sender<>nil) then
   begin


     if (Sender is TItemOPCs) then
       begin
           opsList:=TItemOPCs(sender);
          if not tablInit then
            begin
            self.OPCGroupName.Caption:=opsList.group;
              ColorStringGrid1.Cells[0, 0] := 'N';
              ColorStringGrid1.Cells[1, 0] := 'rtID';
              ColorStringGrid1.Cells[2, 0] := 'rtName';
              ColorStringGrid1.Cells[3, 0] := 'GroupId';
              ColorStringGrid1.Cells[4, 0] := 'Name';
              ColorStringGrid1.Cells[5, 0] := 'Path';
              ColorStringGrid1.Cells[6, 0] := 'RefCount';
              ColorStringGrid1.Cells[7, 0] := 'DirVal';
              ColorStringGrid1.Cells[8, 0] := 'time';
              ColorStringGrid1.Cells[9, 0] := 'Qual';
              ColorStringGrid1.Cells[10, 0] := 'Type';
              ColorStringGrid1.Cells[11, 0] := 'Val';
              ColorStringGrid1.Cells[12, 0] := 'VL';
              ColorStringGrid1.Cells[13, 0] := 'minEU';
              ColorStringGrid1.Cells[14, 0] := 'maxEU';
              ColorStringGrid1.Cells[15, 0] := 'MinRV';
              ColorStringGrid1.Cells[16, 0] := 'MaxRV';
              ColorStringGrid1.Cells[17, 0] := 'Err';
              tablInit:=true;
            end;

          k:=0;
           ColorStringGrid1.RowCount:=max(2,tablCount+1);
           for j:=0 to opsList.Count-1 do
              begin
                for i:=0 to opsList.items[j].count-1 do
                  begin

                    if ((k+1)>=ColorStringGrid1.TopRow) and (k<(ColorStringGrid1.TopRow+ColorStringGrid1.VisibleRowCount)) then
                      begin
                         if (opsList.items[j].activ<1) and (not opsList.RequestActive) then
                         ColorStringGrid1.Rows[k+1].Font.Color:=clGray else
                         if (opsList.items[j].err<>0) then
                         ColorStringGrid1.Rows[k+1].Font.Color:=clRed else
                         ColorStringGrid1.Rows[k+1].Font.Color:=clGreen;
                         ColorStringGrid1.Cells[0, k+1] := inttostr(j);
                         ColorStringGrid1.Cells[1, k+1] := inttostr(opsList.items[j].rtid[i]);
                         ColorStringGrid1.Cells[2, k+1] := Rtitems.GetName(opsList.items[j].rtid[i]);
                         ColorStringGrid1.Cells[3, k+1] := inttostr(opsList.items[j].ID);
                         ColorStringGrid1.Cells[4, k+1] := opsList.items[j].name;
                         ColorStringGrid1.Cells[5, k+1] := opsList.items[j].path;
                        // ColorStringGrid1.Cells[6, k+1] := inttostr(opsList.items[j].activ);
                         ColorStringGrid1.Cells[6, k+1] := inttostr(opsList.items[j].count);
                         ColorStringGrid1.Cells[7, k+1] := floattostr(opsList.items[j].val);
                         ColorStringGrid1.Cells[8, k+1] := timetostr(opsList.items[j].time);
                         ColorStringGrid1.Cells[9, k+1] := OPCQual(opsList.items[j].Qual);
                         ColorStringGrid1.Cells[10, k+1] := OPCType(opsList.items[j].dataType);
                         ColorStringGrid1.Cells[11, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].ValReal);
                         ColorStringGrid1.Cells[12, k+1] :=  inttostr(Rtitems.items[opsList.items[j].rtid[i]].ValidLevel);
                         ColorStringGrid1.Cells[13, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].MinEu);
                         ColorStringGrid1.Cells[14, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].MaxEu);
                         ColorStringGrid1.Cells[15, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].MinRaw);
                         ColorStringGrid1.Cells[16, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].MaxRaw);
                         ColorStringGrid1.Cells[17, k+1] :=OPCIrr(opsList.items[j].err);
                      end;
                     k:=k+1;
                  end;
              end;
       end;
      if (Sender is TOPCClientCell) then
        begin
           servGrInfos:=Sender as TOPCClientCell;
           serverName.Caption:=(servGrInfos).servername;

             if (servGrInfos).Status = osRunning then
               begin
                serverstatus.Caption:='Running';
                serverstatus.Font.Color:=clGreen;
               end;
              if (servGrInfos).Status = osFailed then
               begin
                serverstatus.Caption:='Failed';
                serverstatus.Font.Color:=clRed;
               end;
              if (servGrInfos).Status = osNoconfig then
               begin
                serverstatus.Caption:='NoConfig';
                serverstatus.Font.Color:=clRed;
               end;
              if (servGrInfos).Status = osSuspended then
               begin
                serverstatus.Caption:='Suspended';
                serverstatus.Font.Color:=clYellow;
               end;
             if (servGrInfos).Status = osStatusTest then
               begin
                serverstatus.Caption:='StatusTest';
                serverstatus.Font.Color:=clBlue;
               end;
             if (servGrInfos).Status = osNone then
               begin
                serverstatus.Caption:='None';
                serverstatus.Font.Color:=clRed;
               end;
               try
              if  (servGrInfos).m_Status<>nil then
             begin
               tim:=(servGrInfos).m_Status.ftStartTime;
               if FileTimeToSystemTime(tim, tims)=true then
                  lbStartTime.Caption:=DateTimeTostr(SystemTimeToDateTime(tims))
               else lbStartTime.Caption:='nodef';
                tim:=(servGrInfos).m_Status.ftCurrentTime;
               if FileTimeToSystemTime(tim, tims)=true then
                  lbCurTime.Caption:=DateTimeTostr(SystemTimeToDateTime(tims))
               else lbCurTime.Caption:='nodef';
               tim:=(servGrInfos).m_Status.ftLastUpdateTime;
               if FileTimeToSystemTime(tim, tims)=true then
                  lbLUTime.Caption:=DateTimeTostr(SystemTimeToDateTime(tims))
               else lbLUTime.Caption:='nodef';
               lbVendorName.Caption:=(servGrInfos).m_Status.szVendorInfo;
               lbGroupCount.Caption:=inttostr((servGrInfos).m_Status.dwGroupCount);
               verstr:='';
               for i:= (servGrInfos).m_Status.wMinorVersion to (servGrInfos).m_Status.wMajorVersion do
                 if (i<>(servGrInfos).m_Status.wMajorVersion) then verstr:=verstr+inttostr(i)+', ' else
                   verstr:=verstr+inttostr(i);
                lbVerOPC.Caption:=verstr;
             end else
             begin
               lbStartTime.Caption:='nodef';
               lbCurTime.Caption:='nodef';
               lbLUTime.Caption:='nodef';
               lbVendorName.Caption:='nodef';
               lbGroupCount.Caption:='nodef';
               lbVerOPC.Caption:='nodef';
             end;
             except
             end;
             ColorStringGrid2.RowCount:=max(servGrInfos.GroupCount+1,2);
             ColorStringGrid2.Cells[0, 0] := 'id';
             ColorStringGrid2.Cells[1, 0] := 'Host';
             ColorStringGrid2.Cells[2, 0] := 'Group Name';
             ColorStringGrid2.Cells[3, 0] := 'Grou Err';
             ColorStringGrid2.Cells[4, 0] := 'Item Count';
             ColorStringGrid2.Cells[5, 0] := 'Item err Count';
             for i:=0 to servGrInfos.GroupCount-1 do
                 begin
                     if (servGrInfos.GroupItemErrCount[i]>0) or (servGrInfos.GroupErr[i]<>0) then
                      ColorStringGrid2.Rows[i+1].Font.Color:=clRed else
                    //if (opsList.items[j].err<>0) then
                    ColorStringGrid2.Rows[i+1].Font.Color:=clGreen;  // else
                    //ColorStringGrid2.Rows[k+1].Font.Color:=clGreen;
                     ColorStringGrid2.Cells[0, i+1] := inttostr(i);
                     if servGrInfos.Host<>'' then
                     ColorStringGrid2.Cells[1, i+1] := servGrInfos.Host else
                     ColorStringGrid2.Cells[1, i+1] := 'local';
                     ColorStringGrid2.Cells[2, i+1] := servGrInfos.GroupName[i];
                     ColorStringGrid2.Cells[3, i+1] := inttostr(servGrInfos.GroupErr[i]);
                     ColorStringGrid2.Cells[4, i+1] := inttostr(servGrInfos.GroupItemCount[i]);
                     ColorStringGrid2.Cells[5, i+1] := inttostr(servGrInfos.GroupItemErrCount[i]);

                 end
        end;


   end;

end;

procedure TFormDDEClient.AnalizeDDETopic(Sender: TObject);
var j,k,i: integer;
    toplist: TservInfos;
begin
    if (Sender<>nil) then
     begin

         if (Sender is TservInfos) then
             begin
                if not tablInit then
               begin
                 ColorStringGrid4.Cells[0, 0] := 'N';
                 ColorStringGrid4.Cells[1, 0] := 'sever';
                 ColorStringGrid3.Cells[2, 0] := 'topic';
                 ColorStringGrid4.Cells[3, 0] := 'servHandle';

                  tablInit:=true;
               end;
               toplist:=Sender as TservInfos;
               k:=0;
               label13.Caption:=analizeserver;
               ColorStringGrid4.RowCount:=max(2, toplist.Count+1);
               for j:=0 to toplist.Count-1 do
               begin
                 //if (uppercase(ddelist.si.items[j].server)=analizeserver) then
                 begin
                    k:=k+1;
                    if (toplist.items[j].Connected) then
                     ColorStringGrid4.Rows[k].font.Color:=clGreen else
                         ColorStringGrid4.Rows[k].font.Color:=clRed;
                    ColorStringGrid4.Cells[0, k] := inttostr(k);
                    ColorStringGrid4.Cells[1, k] := analizeserver;
                    ColorStringGrid4.Cells[2, k] := toplist.items[j].topic;
                    ColorStringGrid4.Cells[3, k] := inttostr(toplist.items[j].conv);
                  end;
                end;
             end;

     end;

end;


procedure TFormDDEClient.AnalizeDDE(Sender: TObject);
var j,k,i: integer;
    ddelist: TItemDDEs;
begin
    if (Sender<>nil) then
     begin

         if (Sender is TItemDDEs) then
           begin
             ddelist:=Sender as TItemDDEs;
             ColorStringGrid3.RowCount:=max(2, tablCount+1);
             k:=0;
             label6.Caption:=self.analiztopic;
             label9.Caption:=self.analizeserver;
             if not tablInit then
               begin
                 ColorStringGrid3.Cells[0, 0] := 'N';
                 ColorStringGrid3.Cells[1, 0] := 'rtId';
                 ColorStringGrid3.Cells[2, 0] := 'rtName';
                 ColorStringGrid3.Cells[3, 0] := 'DDEName';
                 ColorStringGrid3.Cells[4, 0] := 'topic';
                 ColorStringGrid3.Cells[5, 0] := 'server';
                 ColorStringGrid3.Cells[6, 0] := 'DirVal';
                 ColorStringGrid3.Cells[7, 0] := 'actR';
                 ColorStringGrid3.Cells[8, 0] := 'minEU';
                 ColorStringGrid3.Cells[9, 0] := 'MaxEU';
                 ColorStringGrid3.Cells[10, 0] := 'MinRaw';
                 ColorStringGrid3.Cells[11, 0] := 'MaxRaw';
                 ColorStringGrid3.Cells[12, 0] := 'Val';
                 ColorStringGrid3.Cells[13, 0] := 'VL';
                 ColorStringGrid3.Cells[14, 0] := 'RC';
                 ColorStringGrid3.Cells[15, 0] := 'Error';
                  tablInit:=true;
               end;
             for j:=0 to ddelist.Count-1 do
               begin
               //  if (uppercase(ddelist.items[j].server)=self.analizeserver) and (uppercase(ddelist.items[j].topic)=self.analiztopic) then
                 begin
                 for i:=0 to ddelist.items[j].count-1 do
                 begin
                 k:=k+1;
                 if ((k+1)>=ColorStringGrid3.TopRow) and (k<(ColorStringGrid3.TopRow+ColorStringGrid1.VisibleRowCount+40)) then
                 begin
                 
                 if (ddelist.items[j].err<>0) then
                     ColorStringGrid3.Rows[k].font.Color:=clred else
                         ColorStringGrid3.Rows[k].font.Color:=clGreen;
                 ColorStringGrid3.Cells[0, k] := inttostr(k);
                 ColorStringGrid3.Cells[1, k] := inttostr(ddelist.items[j].rtid[i]);
                 ColorStringGrid3.Cells[2, k] := Rtitems.GetName(ddelist.items[j].rtid[i]);
                 ColorStringGrid3.Cells[3, k] := (ddelist.items[j].name);
                 ColorStringGrid3.Cells[4, k] := ddelist.items[j].topic;
                 ColorStringGrid3.Cells[5, k] := ddelist.items[j].server;
                 ColorStringGrid3.Cells[6, k] := ddelist.items[j].vals;
                 ColorStringGrid3.Cells[7, k] := inttostr(ddelist.items[j].Activ);
                 ColorStringGrid3.Cells[8, k] := floattostr(Rtitems.items[ddelist.items[j].rtid[i]].Mineu);
                 ColorStringGrid3.Cells[9, k] := floattostr(Rtitems.items[ddelist.items[j].rtid[i]].Maxeu);
                 ColorStringGrid3.Cells[10, k] := floattostr(Rtitems.items[ddelist.items[j].rtid[i]].Minraw);
                 ColorStringGrid3.Cells[11, k] := floattostr(Rtitems.items[ddelist.items[j].rtid[i]].Maxraw);
                 ColorStringGrid3.Cells[12, k] := floattostr(Rtitems.items[ddelist.items[j].rtid[i]].ValReal);
                 ColorStringGrid3.Cells[13, k] := inttostr(Rtitems.items[ddelist.items[j].rtid[i]].ValidLevel);
                 ColorStringGrid3.Cells[14, k] := inttostr(Rtitems.items[ddelist.items[j].rtid[i]].refCount);
                 ColorStringGrid3.Cells[15, k] := DDEerrType(ddelist.items[j].err);
                 end;
                 end;
                 end;
               end;
           end;





     end;
end;

procedure TFormDDEClient.FormHide(Sender: TObject);
begin
  //isAnalis:= false;
end;

procedure TFormDDEClient.setAnalizeObject(val: Tobject);
var i: integer;
begin
   if (val<>fAnalizeObject) then
    begin
       if (fAnalizeObject is TItemOPCs) then
             TItemOPCs(fAnalizeObject).RequestActive:=false;
       if (fAnalizeObject is TItemDDEs) then
             TItemDDEs(fAnalizeObject).RequestActive:=false;
      tablCount:=0;
      Cursor:=0;
      if (fAnalizeObject<>nil) then
       begin
        if (fAnalizeObject is TOPCClientCell) then
        TOPCClientCell(fAnalizeObject).AnalizeFunction:=nil;
         if (fAnalizeObject is TItemOPCs) then
         TItemOPCs(fAnalizeObject).AnalizeFunction:=nil;
         if (fAnalizeObject is TDDETopicItem) then
           ddecl.AnalizeFunction:=nil;
         if (fAnalizeObject is TDDETopiclist) then
           ddecl.AnalizeFunction:=nil;
         if (fAnalizeObject is TDDEServlist) then
           ddecl.AnalizeFunction:=nil;
          if (fAnalizeObject is TItemDDEs) then
           ddecl.AnalizeFunction:=nil;
         if (fAnalizeObject is TservInfos) then
           ddecl.AnalizeFunction:=nil;
       end;
       if (val<>nil) then
       begin

        if (val is TOPCClientCell) then
        begin
        TOPCClientCell(val).AnalizeFunction:=AnalizeOPC;

        end;
         if (val is TItemOPCs) then
         begin
         TItemOPCs(val).AnalizeFunction:=AnalizeOPC;

         end;

         if (val is TDDETopicItem) then
          begin
           analiztopic:=(val as TDDETopicItem).nametopic;
           analizeserver:=(val as TDDETopicItem).nameserver;
           if ddecl<>nil then
           begin
           val:=ddecl.SetAnObjectT(analizeserver,analiztopic);
          // analizecount:=ddecl;

           end;
           tablCount:=TItemDDEs(val).GetTabCount;
           ddecl.AnalizeFunction:=AnalizeDDE;
          end;

          if (val is TDDETopiclist) then
          begin
           analizeserver:=(val as TDDETopiclist).nameserver;
           if ddecl<>nil then
           val:=ddecl.SetAnObjectA(analizeserver);
          // else analizecount:=0;
           ddecl.AnalizeFunction:=AnalizeDDETopic;
          end;

         if (val is TDDEServlist) then
           ddecl.AnalizeFunction:=AnalizeDDE;

          tablInit:=false;

       end;
       fAnalizeObject:=val;

       if (fAnalizeObject<>nil) then
         begin
             if (fAnalizeObject is TItemOPCs) then
              for i:=0 to TItemOPCs(fAnalizeObject).count-1 do
                 tablCount:=tablCount+TItemOPCs(val).items[i].count;
             tablInit:=false;
         end;
    end;
    PanelOPCgroup.Visible:=(fAnalizeObject is TItemOPCs);
    PanelOPCserver.Visible:=(fAnalizeObject is TOPCClientCell);
    PanelDDETopicItem.Visible:=(fAnalizeObject is TDDETopicItem) or (fAnalizeObject is TItemDDEs);
    PanelDDETopic.Visible:=(fAnalizeObject is TDDETopiclist) or (fAnalizeObject is TServInfos);
    if (fAnalizeObject is TItemOPCs) then
             TItemOPCs(fAnalizeObject).RequestActive:=true;
    if (fAnalizeObject is TItemDDEs) then
             TItemDDEs(fAnalizeObject).RequestActive:=true;
end;

procedure TFormDDEClient.TreeView1Click(Sender: TObject);
var i: integer;
    NodeS: TTreeNode;
begin
     for i:=0 to self.TreeView1.Items.Count-1 do
      if  self.TreeView1.Items[i].Selected then
        NodeS:=self.TreeView1.Items[i];
    setAnalizeObject(Nodes.data);
end;

end.
