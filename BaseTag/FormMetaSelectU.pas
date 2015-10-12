unit FormMetaSelectU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MemStructsU, StdCtrls, ComCtrls, ImgList, ExtCtrls,ConstDef,MainDataModuleU;

type
     TTrdfMsgType = (trdfmOn, trdfmOff, trdfmAl, trdfmAll);
     TTrdfMsgTypeSet = set of TTrdfMsgType;

type
  TFormMetaSelect = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ImageList1: TImageList;
    Image1: TImage;
    Panel1: TPanel;
    PanelMessage: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Edit1: TEdit;
    Button3: TButton;
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
     fmsgset: TTrdfMsgTypeSet;
     ftrtit: TObject;
     fstr: string;
     ftyp: integer;
     ffilter: string;
     procedure setmsgset(val: TTrdfMsgTypeSet);
    { Private declarations }
  public
    function Execs(trtit: TAnalogMems; typ: integer): boolean; overload;
    function Execs(trtit: TTrenddefList; typ: integer): boolean; overload;
    function Exec(var str: TStringList; trtit: TObject; typ: integer): boolean;
    property  msgset: TTrdfMsgTypeSet read fmsgset write setmsgset;
    procedure UpdateView;
    { Public declarations }
  end;

var
  FormMetaSelect: TFormMetaSelect;

implementation

{$R *.dfm}

function includeTg_(on_,off_,al_: boolean; vl: TTrdfMsgTypeSet): boolean;
begin
  result:=true;
  if (trdfmAll in vl) then exit;
  if (trdfmOn in vl) and on_ then exit;
  if (trdfmOff in vl) and off_ then exit;
  if (trdfmAl in vl) and al_ then exit;
  result:=false;
end;

function TFormMetaSelect.Exec(var str: TStringList; trtit: TObject; typ: integer): boolean;
var i: integer;
begin
   fmsgset:=[trdfmOn, trdfmOff, trdfmAl, trdfmAll];
//   PanelMessage.Visible:=(typ=0);
   if trtit=nil then exit;
   ftyp:=typ;
   ftrtit:=trtit;
   UpdateView;
   ffilter:='';
   Edit1.Text:=ffilter;
   label2.Caption:='';
    if (ShowModal=MrOk) and (trim(label2.Caption)<>'') then
        begin

           str.Clear;
           for i:=0 to ListView1.Items.Count-1 do
             if ListView1.Items[i].Selected then
               str.Add(ListView1.Items[i].Caption);

           //str:=label2.Caption;
           result:=true;
        end else
        begin
        str.Clear;
        result:= false;

        end;

end;




function TFormMetaSelect.Execs(trtit: TAnalogMems; typ: integer): boolean;
var i: integer;
begin
   ListView1.Items.BeginUpdate;
   result:=false;
   self.ListView1.Items.Clear;
   if trtit=nil then exit;
   for i:=0 to trtit.Count-1 do
     begin
       if trtit.Items[i].ID>-1 then
       begin

       if (typ in REPORT_SET) then
            if trtit.Items[i].logTime=typ then
               if ((trim(self.ffilter)='') or
                     (pos(ansiuppercase(trim(self.ffilter)),
                         ansiuppercase(trtit.GetName(i)))>0 )) then
              with ListView1.Items.Add do

                begin
                   begin
                   caption := trtit.GetName(i);
                   ImageIndex := 0;
                   end;
                end;



       if (typ=1000) then
            if trtit.Items[i].Logged then
              if ((trim(self.ffilter)='') or
                     (pos(ansiuppercase(trim(self.ffilter)),
                         ansiuppercase(trtit.GetName(i)))>0 )) then
              with ListView1.Items.Add do
                begin

                   begin
                   caption := trtit.GetName(i);
                   ImageIndex := 1;
                   end;
                end;

        if (typ=0) then
        if ((trim(self.ffilter)='') or (
                     pos(ansiuppercase(trim(self.ffilter)),
                         ansiuppercase(trtit.GetName(i)))>0 )) then
        if includeTg_(trtit.Items[i].OnMsged,trtit.Items[i].OffMsged,
        (trtit.Items[i].Alarmed or trtit.Items[i].AlarmedLocal),msgset) then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := 2;
                end;
        end;
      end;

   ListView1.Items.EndUpdate;
end;


function TFormMetaSelect.Execs(trtit: TTrenddefList; typ: integer): boolean;
var i: integer;
begin
   ListView1.Items.BeginUpdate;
   result:=false;
   self.ListView1.Items.Clear;
   if trtit=nil then exit;
   for i:=0 to trtit.Count-1 do
     begin
      // if trtit.Items[i].ID>-1 then
       begin

       if (typ in REPORT_SET) then
            if PTrenddefRec(trtit.Objects[i])^.logtime=typ then
            if ((trim(self.ffilter)='') or
                     (pos(ansiuppercase(trim(self.ffilter)),
                         ansiuppercase(PTrenddefRec(trtit.Objects[i])^.iname))>0 )) then
              with ListView1.Items.Add do
                begin
                   caption := PTrenddefRec(trtit.Objects[i])^.iname;
                   ImageIndex := 0;
                end;



       if (typ=1000) then
            if PTrenddefRec(trtit.Objects[i])^.logged then
            if ((trim(self.ffilter)='') or
                     (pos(ansiuppercase(trim(self.ffilter)),
                         ansiuppercase(PTrenddefRec(trtit.Objects[i])^.iname))>0 )) then
              with ListView1.Items.Add do
                begin
                   caption := PTrenddefRec(trtit.Objects[i])^.iname;
                   ImageIndex := 1;
                end;

        if (typ=0) then
        if ((trim(self.ffilter)='') or
                  (pos(ansiuppercase(trim(self.ffilter)),ansiuppercase(PTrenddefRec(trtit.Objects[i])^.iname))>0 ))
        then
        if (includeTg_(PTrenddefRec(trtit.Objects[i])^.onmsg,PTrenddefRec(trtit.Objects[i])^.offmsg,
        PTrenddefRec(trtit.Objects[i])^.almsg,msgset)) then
              with ListView1.Items.Add do
                begin
                   caption := PTrenddefRec(trtit.Objects[i])^.iname;
                   ImageIndex := 2;
                end;
        end;
      end;




   ListView1.Items.EndUpdate;
end;




procedure TFormMetaSelect.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
label2.Caption:=Item.Caption;
end;

procedure TFormMetaSelect.setmsgset(val: TTrdfMsgTypeSet);
begin
 if val<>fmsgset then
   begin
     fmsgset:=val;
     UpdateView;
   end;
end;

procedure TFormMetaSelect.CheckBox4Click(Sender: TObject);
begin
 if CheckBox4.Checked then
 begin
 fmsgset:=[trdfmOn, trdfmOff, trdfmAl, trdfmAll];
 end
 else fmsgset:=fmsgset-[trdfmAll];

end;

procedure TFormMetaSelect.CheckBox3Click(Sender: TObject);
begin
 if CheckBox3.Checked then
  fmsgset:=fmsgset+[ trdfmAl] else
 fmsgset:=fmsgset-[ trdfmAl];

end;

procedure TFormMetaSelect.CheckBox2Click(Sender: TObject);
begin
 if CheckBox2.Checked then
  fmsgset:=msgset+[ trdfmOff] else
 fmsgset:=msgset-[ trdfmOff];

end;

procedure TFormMetaSelect.CheckBox1Click(Sender: TObject);
begin
if CheckBox1.Checked then
  fmsgset:=msgset+[ trdfmOn] else
 fmsgset:=msgset-[ trdfmOn];

end;

procedure TFormMetaSelect.UpdateView;
begin
CheckBox1.Checked:=(trdfmOn in msgset);
CheckBox2.Checked:=(trdfmOff in msgset);
CheckBox3.Checked:=(trdfmAl in msgset);
CheckBox4.Checked:=(trdfmAll in msgset);
CheckBox1.Visible:=(ftyp=0);
CheckBox2.Visible:=(ftyp=0);
CheckBox3.Visible:=(ftyp=0);
CheckBox4.Visible:=(ftyp=0);
Edit1.Text:=ffilter;
  if (ftrtit is TAnalogMems) then
       Execs(TAnalogMems(ftrtit),ftyp);
   if (ftrtit is TTrenddefList) then
       Execs(TTrenddefList(ftrtit),ftyp)
end;

procedure TFormMetaSelect.Button3Click(Sender: TObject);
begin
   UpdateView;
end;

procedure TFormMetaSelect.Edit1Change(Sender: TObject);
begin
    ffilter:=Edit1.Text;
end;

end.
