unit SelectFormVCLU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, checklst, Db, Grids, DBGrids, dbTables, Spin, ConstDef,
  SYButton,  ExtCtrls, ComCtrls, ImgList, ADODB, globalvalue, MainDataModuleU,
  xmldom, XMLIntf, msxmldom, XMLDoc, dxCore, dxButton, ImmibuttonXp, ConfigurationSys;

const
   ROOT_TREE_TREND=0;
   ROOT_SGROUP_TREND=1;
   ROOT_GROUP_TREND=2;
   ROOT_ITEM_TREND=3;


type atype = array  of string;


type
  TSelectFormVCL = class(TForm)
    TreeView1: TTreeView;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    ImageList2: TImageList;
    ListView1: TListView;
    XMLInfo: TXMLDocument;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    ImmiButtonXp1: TImmiButtonXp;
    ImmiButtonXp2: TImmiButtonXp;
    procedure View;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);

  private
    { Private declarations }
     BaseNode, lastFilteredNode: TTreeNode;
     tegList: TstringList;
     fTRDF: TTrenddefList;
     procedure LoadListParam(val: IXMLNode);
     procedure LoadTree;
     procedure AddMetaNode(xmlParent: IXMLNode; parent: TTreenode; nm: string);
  public
    selectS: integer;
    namepar: integer;
    { Public declarations }

    procedure SelectTextFieldEx(var pen: string);
    constructor create(Sender: TComponent; TRDF: TTrenddefList); 
  end;

var
  SelectFormVCL: TSelectFormVCL;


implementation

function getImgIndex(val: TNSNodeType): integer;
begin
  result:=-1;
  case val of
   cdtTrendList: result:=ROOT_TREE_TREND;
   cdtTrendHeader: result:=ROOT_SGROUP_TREND;
   cdtTrendArr:  result:=ROOT_GROUP_TREND;
   cdttrend:  result:=ROOT_ITEM_TREND;
   end;
end;

{$R *.DFM}
const
MaxKotel   = 20;    //максимальное колличество котлов
MaxGorelka = 20;    //максимальное колличество горелок на один котел


constructor TSelectFormVCL.create(Sender: TComponent; TRDF: TTrenddefList);
begin
  inherited create(Sender);
  fTRDF:=TRDF;

end;


procedure TSelectFormVCL.Button2Click(Sender: TObject);
begin
     ModalResult := -1;
     namepar:=-1;
end;

procedure TSelectFormVCL.Button3Click(Sender: TObject);
begin
     ModalResult := -2;
     namepar:=-2;
end;

procedure TSelectFormVCL.Button1Click(Sender: TObject);
begin
    ModalResult := MrOk;
end;


procedure TSelectFormVCL.SelectTextFieldEx(var pen: string);
var
 resultmodal: integer;
 TableState : boolean;
 Mark: TbookMark;

begin
    if TreeView1.Selected<>nil then
    TreeView1.Deselect(TreeView1.Selected);
    self.ListView1.Items.Clear;
    selectS:=-1;
    self.View;
    self.Label2.Caption:='Пусто';
    if ShowModal=MrOk then
      pen:=label2.Caption
      else
        pen:='';

end;


procedure TSelectFormVCL.FormCreate(Sender: TObject);
var i: integer;
begin
tegList:=TstringList.Create;
self.LoadTree;

end;



procedure TSelectFormVCL.FormActivate(Sender: TObject);
var I: integer;
begin


end;


procedure TSelectFormVCL.View;
var i: integer;
    query: TQuery;
begin




end;

procedure TSelectFormVCL.LoadTree;
var i,j: integer;
    tmpXML: IXMLNode;
    nf: string;
begin

  nf:='AppMetaInfo.xml';
  if not FileExists(nf) then
   begin
      try
        InitialSys;
        nf:=PathMem+'AppMetaInfo.xml';
      except
      end
   end;


  if FileExists(nf) then
    begin
      XMLInfo.FileName:=nf;
      XMLInfo.Active:=true;
      for i:=0 to XMLInfo.DocumentElement.ChildNodes.Count-1 do
        begin
         if XMLInfo.DocumentElement.ChildNodes[i].LocalName='TrendList' then
           begin
             tmpXML:=XMLInfo.DocumentElement.ChildNodes[i];
             AddMetaNode(tmpXML,TreeView1.TopItem,'');
             exit;
           end;
        end;
         XMLInfo.Active:=false;
    end;
end;


procedure TSelectFormVCL.AddMetaNode(xmlParent: IXMLNode; parent: TTreenode; nm: string);
var i: integer;
   str: string;
   tmpTreenode: TTreenode;
   tmptype: TNSNodeType;
begin
tmptype:=gettypeMetaByname(xmlParent.LocalName);
if tmptype<>cdtTrendList then
tmpTreenode:=TreeView1.Items.AddChild(parent,getTextMetaByName(xmlParent)) else
tmpTreenode:=TreeView1.Items.AddChild(parent,'Графики');
tmpTreenode.ImageIndex:=getImgIndex(tmptype);
tmpTreenode.Data:=Pointer(xmlParent);
if (tmptype=cdtmeta) then tmpTreenode.ImageIndex:=integer(cdtmeta);
for i:=0 to xmlParent.ChildNodes.Count-1 do
   AddMetaNode(xmlParent.ChildNodes[i], tmpTreenode, xmlParent.ChildNodes[i].LocalName);
end;


procedure TSelectFormVCL.TreeView1GetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
if node=nil then exit;
node.SelectedIndex:=node.ImageIndex;
end;



procedure TSelectFormVCL.TreeView1Change(Sender: TObject; Node: TTreeNode);
var tmpXML: IXMLNode;
    test: string;
begin
if Node=nil then
   begin
    ListView1.Items.Clear;
    exit;
   end;
 case Node.ImageIndex of
   ROOT_TREE_TREND:
      begin
       ListView1.Items.Clear;
       label2.Caption:='Пусто';
      end;
   ROOT_SGROUP_TREND,ROOT_GROUP_TREND: begin
        ListView1.Items.Clear;
        if Node.Data=nil then exit;
        tmpXML:=IXMLNode(Node.Data);
        LoadListParam(tmpXML);
        label2.Caption:='Пусто';
      end;
   ROOT_ITEM_TREND: begin
        ListView1.Items.Clear;
        if Node.Data=nil then exit;
        tmpXML:=IXMLNode(Node.Data);
        LoadListParam(tmpXML);
        if assigned(tmpXML.AttributeNodes.Nodes['tg']) then
          label2.Caption:=tmpXML.Attributes['tg'];
      end;
    end;
  //  test:=ParameterList.GetText;
  //  test:=ParameterList.GetText;
end;

procedure TSelectFormVCL.LoadListParam(val: IXMLNode);
var tmptype: TNSNodeType;
    i: integer;
    li: TListItem;
    tmpstr: string;
    tmpid: PTrenddefRec;
begin
 if val=nil then exit;
 tmptype:=gettypeMetaByname(val.LocalName);
 if (tmptype=cdttrend) then
  begin

    if assigned(val.AttributeNodes.Nodes['tg']) then
     begin
       li:=ListView1.Items.Add;
       li.Caption:=val.Attributes['tg'];
      if fTRDF<>nil then
       begin
         tmpstr:=val.Attributes['tg'];
         tmpid:=fTRDF.GetInfo(tmpstr);
         if tmpid<>nil then
          begin
           li.Caption:='['+ val.Attributes['tg']+']  '+tmpid^.comment;
          end;
       end;
       li.ImageIndex:=ROOT_ITEM_TREND;
       li.Data:=TObject(val);
     end;
  end;

 if (tmptype=cdtTrendHeader) or (tmptype=cdtTrendArr) or (tmptype=cdtTrendList) then
  begin
   for i:=0 to val.ChildNodes.Count-1 do
     LoadListParam(val.ChildNodes[i]);
  end;

end;

procedure TSelectFormVCL.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
if ((item=nil) or (item.Data=nil)) then
  begin
    label2.Caption:='Пусто';
  end;
try
 if assigned(IXMLNode(item.Data).AttributeNodes.Nodes['tg']) then
 label2.Caption:=IXMLNode(item.Data).Attributes['tg']
 else label2.Caption:='Пусто';
except
  label2.Caption:='Пусто';
end
end;

end.

