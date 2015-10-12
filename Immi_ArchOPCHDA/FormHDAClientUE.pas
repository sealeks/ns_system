unit FormHDAClientUE;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OPCHDAClient,  Grids, Menus, uMyTimer,OPCDA, DateUtils,
  ExtCtrls, Spin,  math,  MemStructsU,OPCerror, ActiveX,   Dm2UOPC, DB,
   convFunc, GlobalValue,{Globalvar ,} GroupsU, ConstDef, ShellApi, Contnrs,
  Scope, IMMIScope, ComCtrls, ImgList, ColorStringGrid, OPCtypes;


const
   WM_ICONNOTYFY=WM_USER+1324;


  type

  TFormHDAClient = class(TForm)
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
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TreeView1: TTreeView;
    Timer3: TTimer;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    PanelOPCgroup: TPanel;
    ColorStringGrid1: TColorStringGrid;
    PanelGroupOPC: TPanel;
    Label1: TLabel;
    OPCGroupName: TLabel;
    PanelOPCServer: TPanel;
    ColorStringGrid2: TColorStringGrid;
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
    ColorStringGrid3: TColorStringGrid;
    Panel2: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    PanelDDETopic: TPanel;
    ColorStringGrid4: TColorStringGrid;
    Panel3: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    PugeTimer: TTimer;
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
    procedure PugeTimerTimer(Sender: TObject);
  private
    dmodul: TDm2OPC;
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
    function  PugeAchive: boolean;
  public
    { Public declarationsect }
     destructor Destroy; override;
     property AnalizeObject: TObject read fAnalizeObject write setAnalizeObject;
  end;

var
  FormHDAClient: TFormHDAClient;
//  rtItems : TanalogMems;
  ttimestartt: integer;
  yj: TDPoint;
  testCount: integer;
  PugeTime: integer;
//function isOPC(val: string): string;
procedure GetOPCHDAConfig(val: string; var TA: integer; var HR: integer; var MR: integer;var Nadv: boolean);

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

//      Topic= Tnn/Hnn/Mnn/N
//       Tnn  таймаут транзакции запроса
//       Hnn  Правая граница диапазона часового цикла опроса (мин)
//       Mnn  Правая граница диапазона минутного цикла опроса (cek)
//       N -синхронный опрос ( по умолчанию асинхронный)

procedure GetOPCHDAConfig(val: string; var TA: integer; var HR: integer; var MR: integer;var Nadv: boolean);
var TStr, MStr,HStr, flaStr: string;
    i: integer;
    flT, flH,flM, FlA: boolean;
begin
   TA:=120;
   HR:=60;
   MR:=30;
   TStr:='';
   HStr:='';
   MStr:='';
   flaStr:='';

   flT:=false;flM:=false;flH:=false;FlA:=false;
   val:=uppercase(trim(val));
   for i:=1 to length(val) do
     begin
        if (val[i]='T') then begin flT:=true ;flM:=false;flH:=false;FlA:=false; end;
        if (val[i]='H') then begin flT:=false ;flM:=false;flH:=true;FlA:=false; end;
        if (val[i]='M') then begin flT:=false ;flM:=true;flH:=false;FlA:=false; end;
        if (val[i]='N') then begin flT:=false;flM:=false;flH:=false;FlA:=false;FlaStr:=val[i]; end;
        if (val[i]='/') or (val[i]='\') then begin flT:=false;flM:=false;flH:=false;FlA:=false; end;
        if (val[i]<>'T') and (val[i]<>'H') and (val[i]<>'M')and (val[i]<>'N') then
          begin
             if (flT) then TStr:=TStr+val[i];
             if (flH) then HStr:=HStr+val[i];
             if (flM) then MStr:=MStr+val[i];
             if (flA) then FlaStr:=flaStr+val[i];
          end;
     end;
       TStr:=trim(TStr);
       HStr:=trim(HStr);
       MStr:=trim(MStr);
       FlaStr:=trim(FlaStr);
     try
       TA:=strtoint(TStr);
     except
     end;
         try
       HR:=strtoint(HStr);
     except
     end;

         try
       MR:=strtoint(MStr);
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





function isDDE(val: string; var host: string; var topic: string): string;
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
//   TOPIC -> UR NUM RD MUM.NUM

function isOPC(val: string; var host: string; var grn: string): string;
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
    i: integer;
begin
   result:='';
   host:='';
   grn:='';
   val:=trim(val);
   if val='' then exit;
   result:=trim(getinVstring(val,'OPC_HDA'));
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





procedure TFormHDAClient.FormCreate(Sender: TObject);
var
  fl: integer;
  i,j, slave,k: integer;
  serv, group, configinfo,host,group1, app, topic: string;
  servliststr: tstringList;
  client: TOPCHDAClient;
  trn, trn1, trnopcbush, trnddebush: TtReeNode;
  obj: Tobject;
  opcTO: integer;
  opcHR: integer;
  opcMR: integer;
  indx: integer;
  topicList: TstringList;
  noadv: boolean;
begin
  tablCount:=0;
  PugeTime:=-1;
  tablInit:=false;
  Cursor:=0;
  fAnalizeObject:=nil;
  servliststr:=tstringList.Create;
  servlist:=tstringList.Create;

  ticknetid:=-1;
  activnetid:=-1;
  isConnection:=false;
  FNID.Wnd:=handle;
  FNID.uCallbackMessage:=WM_ICONNOTYFY;
  FNID.hIcon:=Icon.Handle;
  FNID.szTip:='HDA Client';
  FNID.uFlags:=nif_Message or nif_Icon or nif_Tip ;
  rtItems := TanalogMems.Create(PathMem);
  trnopcbush:=self.TreeView1.Items[1];

  testCount:=0;
   sleep(20000);
  for i:=0 to rtitems.TegGroups.Count-1 do
   begin

      serv:=rtItems.TegGroups.Items[i].App;
      group:=rtItems.TegGroups.Items[i].Name;
      slave:=rtItems.TegGroups.Items[i].SlaveNum;
      configinfo:=rtItems.TegGroups.Items[i].Topic;
      GetOPCHDAConfig(configinfo,opcTO,opcHR,opcMR,noadv);
      serv:=isOPC(serv,host,group1);

      if (trim(serv)<>'') then
        begin
          fl:=-1;
          // servlist<>nil then Showmessage(inttostr(i)+'servl<>nil'+inttostr(j));
          for j:=0 to servlist.Count-1 do
            begin

               if ((TOPCHDAClient(servlist.Objects[j]).isCurTread(serv,group,slave,host)) and
                              (fl<0)) then
                  begin
                    fl:=j;
                  end;
            end;

          if (fl<0) then
           begin
           client:=TOPCHDAClient.Create(serv,pathMem, slave,host,opcTO,opcHR,opcMR, noadv);

           servlist.AddObject(serv,client);
           trn:=TreeView1.Items.AddChild(trnopcbush,serv+':'+inttostr(slave));
           trn.Data:=client.getServer;
           if host='' then
           trn.Text:=serv+':'+inttostr(slave)
           else
           trn.Text:='['+host+']'+serv+':'+inttostr(slave);
           trn.ImageIndex:=5;

          // if client=nil then
         //  Showmessage('client');
           obj:=client.AddClGroup(group,slave,0,0);
         //  Showmessage(inttostr(fl)+'haha'+inttostr(j));
           trn1:=TreeView1.Items.AddChild(trn,group);
           trn1.Data:=obj;
           trn1.Text:=group;
           trn1.ImageIndex:=6;
           end else
           begin
           client:=TOPCHDAClient(servlist.Objects[fl]);

           obj:=client.AddClGroup(group,slave,0,0);
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
     TOPCHDAClient(servlist.Objects[i]).Resume;
  rtItems.RegHandle('IMMIopchdabridge', self.handle, [IMMIall]);
  isConnection:=true;
  isAnalis:=false;
  dmodul:=TDm2OPC.Create(nil);
end;





procedure TFormHDAClient.ButtonstartClick(Sender: TObject);


begin

end;

procedure TFormHDAClient.N1Click(Sender: TObject);
begin
Show;
BringWindowToTop(handle);
end;

procedure TFormHDAClient.N3Click(Sender: TObject);  // завершить убрано
begin
Shell_NotifyIcon(NIM_DELETE,@FNID);
end;


procedure TFormHDAClient.WMClose(var messag: TMsg);
begin
messag.message:=0;
Hide;
end;

procedure TFormHDAClient.WMIconNotyfy(var messag: TMsg);
var pt: TPoint;
begin
if not isConnection then exit;
if messag.wParam=WM_RBUTTONDOWN then
begin
getCursorPos(pt);
popupmenu1.Popup(pt.X,pt.y);
end;

end;

destructor TFormHDAClient.Destroy;
begin

  FNID.uFlags:=0;
  Shell_NotifyIcon(NIM_DELETE,@FNID);
  inherited;
end;


procedure TFormHDAClient.WMEterClose(var messag: TMsg);
begin
  N3Click(nil);
end;


procedure TFormHDAClient.WMIMMIRemRef(var Mess: TMessage);
var i:integer;
begin

end;



procedure TFormHDAClient.WMIMMINewRef(var Mess: TMessage);
var i:integer;
begin


end;

procedure TFormHDAClient.FormDestroy(Sender: TObject);
begin
   rtItems.UnRegHandle(application.Handle);
   dmodul.free;
   sleep(1000);
  // ddeclients.Free;
   if  (activnetid>-1) and (ticknetid>-1) then
         begin
         rtitems.decCounter(activnetid);
         rtitems.decCounter(ticknetid);
         end;
         rtitems.Free;


end;




 procedure TFormHDAClient.Timer3Timer(Sender: TObject);
begin
  try
   Timer3.Enabled:= not Shell_NotifyIcon(NIM_ADD,@FNID);
   except
   end;
end;

procedure TFormHDAClient.AnalizeOPC(Sender: TObject);

function FTtoDTF(tim: _FILETIME): TDateTime;   // FT в DT
var  temp: TSystemTime;
     tim1: _FILETIME;
begin
   FileTimeToLocalFileTime(tim,tim1);
   FileTimeToSystemTime(tim1,temp);
   result:=SystemTimeToDateTime(temp);
end;

var i,j,k, ver: integer;
    opsList: TItemOPCHDAs;
    servGrInfos: TOPCHDAClientCell;
    tim: _FILETIME;
    tims: _SYSTEMTIME;
    verstr: string;
begin
  if (Sender<>nil) then
   begin


     if (Sender is TItemOPCHDAs) then
       begin
           opsList:=TItemOPCHDAs(sender);
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
                         if opsList.items[j].stateIT=his_Reading  then
                         ColorStringGrid1.Rows[k+1].Font.Color:=clred else
                         if opsList.items[j].stateIT=his_NeedRead then
                         ColorStringGrid1.Rows[k+1].Font.Color:=clGreen else
                         ColorStringGrid1.Rows[k+1].Font.Color:=clGray;
                         ColorStringGrid1.Cells[0, k+1] := inttostr(j);
                         ColorStringGrid1.Cells[1, k+1] := inttostr(opsList.items[j].RTID);
                         ColorStringGrid1.Cells[2, k+1] := Rtitems.GetName(opsList.items[j].rtID);
                         ColorStringGrid1.Cells[3, k+1] := inttostr(opsList.items[j].ID);
                         ColorStringGrid1.Cells[4, k+1] := opsList.items[j].name;
                         ColorStringGrid1.Cells[5, k+1] := opsList.items[j].path;
                        // ColorStringGrid1.Cells[6, k+1] := inttostr(opsList.items[j].activ);
                         ColorStringGrid1.Cells[6, k+1] := inttostr(opsList.items[j].count);
                         ColorStringGrid1.Cells[7, k+1] := floattostr(opsList.items[j].val);
                         ColorStringGrid1.Cells[8, k+1] := DATEtimetostr(FTtoDTF(opsList.items[j].lastTime));
                         ColorStringGrid1.Cells[9, k+1] := DATEtimetostr(FTtoDTF(opsList.items[j].lastTimeP));
                         ColorStringGrid1.Cells[10, k+1] := OPCType(opsList.items[j].dataType);
                       //  ColorStringGrid1.Cells[11, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].ValReal);
                      //   ColorStringGrid1.Cells[12, k+1] :=  inttostr(Rtitems.items[opsList.items[j].rtid[i]].ValidLevel);
                      //   ColorStringGrid1.Cells[13, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].MinEu);
                      //   ColorStringGrid1.Cells[14, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].MaxEu);
                      //   ColorStringGrid1.Cells[15, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].MinRaw);
                      //   ColorStringGrid1.Cells[16, k+1] := floattostr(Rtitems.items[opsList.items[j].rtid[i]].MaxRaw);
                         ColorStringGrid1.Cells[17, k+1] :=OPCIrr(opsList.items[j].err);
                      end;
                     k:=k+1;
                  end;
              end;
       end;
      if (Sender is TOPCHDAClientCell) then
        begin
           servGrInfos:=Sender as TOPCHDAClientCell;
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
              if  (servGrInfos).m_Status>-1 then
             begin
            {   tim:=(servGrInfos).ftStartTime;
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
                lbVerOPC.Caption:=verstr;   }
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
             ColorStringGrid2.RowCount:=max({servGrInfos.GroupCount}1+1,2);
             ColorStringGrid2.Cells[0, 0] := 'id';
             ColorStringGrid2.Cells[1, 0] := 'Host';
             ColorStringGrid2.Cells[2, 0] := 'Group Name';
             ColorStringGrid2.Cells[3, 0] := 'Grou Err';
             ColorStringGrid2.Cells[4, 0] := 'Item Count';
             ColorStringGrid2.Cells[5, 0] := 'Item err Count';
             for i:=0 to {servGrInfos.GroupCount}1-1 do
                 begin
                     if (servGrInfos.GroupItemErrCount[i]>0) or (servGrInfos.GroupErr<>0) then
                      ColorStringGrid2.Rows[i+1].Font.Color:=clRed else
                    //if (opsList.items[j].err<>0) then
                    ColorStringGrid2.Rows[i+1].Font.Color:=clGreen;  // else
                    //ColorStringGrid2.Rows[k+1].Font.Color:=clGreen;
                     ColorStringGrid2.Cells[0, i+1] := inttostr(i);
                     if servGrInfos.Host<>'' then
                     ColorStringGrid2.Cells[1, i+1] := servGrInfos.Host else
                     ColorStringGrid2.Cells[1, i+1] := 'local';
                     ColorStringGrid2.Cells[2, i+1] := servGrInfos.GroupName[i];
                     ColorStringGrid2.Cells[3, i+1] := inttostr(servGrInfos.GroupErr);
                     ColorStringGrid2.Cells[4, i+1] := inttostr(servGrInfos.GroupItemCount[i]);
                     ColorStringGrid2.Cells[5, i+1] := inttostr(servGrInfos.GroupItemErrCount[i]);

                 end
        end;


   end;

end;



procedure TFormHDAClient.FormHide(Sender: TObject);
begin
  //isAnalis:= false;
end;

procedure TFormHDAClient.setAnalizeObject(val: Tobject);
var i: integer;
begin
   if (val<>fAnalizeObject) then
    begin


      tablCount:=0;
      Cursor:=0;
      if (fAnalizeObject<>nil) then
       begin
        if (fAnalizeObject is TOPCHDAClientCell) then
        TOPCHDAClientCell(fAnalizeObject).AnalizeFunction:=nil;
         if (fAnalizeObject is TItemOPCHDAs) then
         begin
        
         TItemOPCHDAs(fAnalizeObject).AnalizeFunction:=nil;
         end;

       end;
       if (val<>nil) then
       begin

        if (val is TOPCHDAClientCell) then
        begin
        TOPCHDAClientCell(val).AnalizeFunction:=AnalizeOPC;

        end;
         if (val is TItemOPCHDAs) then
         begin
         TItemOPCHDAs(val).AnalizeFunction:=AnalizeOPC;

         end;





          tablInit:=false;

       end;
       fAnalizeObject:=val;

       if (fAnalizeObject<>nil) then
         begin
             if (fAnalizeObject is TItemOPCHDAs) then
              for i:=0 to TItemOPCHDAs(fAnalizeObject).count-1 do
                 tablCount:=tablCount+TItemOPCHDAs(val).items[i].count;
             tablInit:=false;
         end;
    end;
    PanelOPCgroup.Visible:=(fAnalizeObject is TItemOPCHDAs);
    PanelOPCserver.Visible:=(fAnalizeObject is TOPCHDAClientCell);
    PanelDDETopicItem.Visible:=false;
    PanelDDETopic.Visible:=false;


end;

procedure TFormHDAClient.TreeView1Click(Sender: TObject);
var i: integer;
    NodeS: TTreeNode;
begin
     for i:=0 to self.TreeView1.Items.Count-1 do
      if  self.TreeView1.Items[i].Selected then
        NodeS:=self.TreeView1.Items[i];
    setAnalizeObject(Nodes.data);
end;

procedure TFormHDAClient.PugeTimerTimer(Sender: TObject);
begin
 if PugeTime<>DayOfTheMonth(now) then
   begin
      PugeAchive;
      PugeTime:=DayOfTheMonth(now);
   end;
end;

function  TFormHDAClient.PugeAchive: boolean;
 var
   fn, s ,ooo: string;
   per: integer;
   h: string;
   delR: integer;
   tforH, tforD, tforM: TdateTime;
begin
  { if deletecircle<0 then exit;
   if deletecircle<1 then

       delR:=1 else delR:=deletecircle;
   tforH:=incMonth(now,-delR*12);
   tforD:=incMonth(now,-delR*24*12);
   tforM:=incMonth(now,-delR*24*12*12);
  // ooo:=datetimetostr(tforH);
   //ooo:=datetimetostr(tforD);
   //ooo:=datetimetostr(tforM);
   //ooo:=datetimetostr(tforH);
   try
  dmodul.qTrend.Sql.Clear;
  result:=false;
  fn:='_arch';
  if TableExist(fn, dmodul.Trend) then
    begin
       with dmodul.qTrend do
          begin
          SQL.Clear;
          SQL.Add('delete from ' + fn +' where (period=4 and tm<:tH) or (period=6 and tm<:tD) or (period=7 and tm<:tM)');
          Parameters.parambyname('tH').DataType:=ftString;
          Parameters.parambyname('tH').value:=selfFormatDateTime(tforH);
          Parameters.parambyname('tD').DataType:=ftString;
          Parameters.parambyname('tD').value:=selfFormatDateTime(tforD);
          Parameters.parambyname('tM').DataType:=ftString;
          Parameters.parambyname('tM').value:=selfFormatDateTime(tforM);
           try
            ExecSQL;
            result:=true;
           except

           end;
         end;
         end;
        except

    end;        }
end;



end.
