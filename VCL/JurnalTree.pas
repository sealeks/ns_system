unit JurnalTree;

interface

uses
  SysUtils, Classes, Controls, ComCtrls, DBTables, Messages, constDef, dialogs;

type
  TJurnalTree = class(TTreeView)
  private
    { Private declarations }
    qry2, qry3: TQuery;
    isInit: boolean;
    fOnExpandSave: TTVExpandingEvent;
    BaseNode, lastFilteredNode: TTreeNode;
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure FillNodeListByParent(parent: string; List: TStringList);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function HasChildGG(GroupName: string): boolean;
    procedure GetSelection(TegList: TStringList);
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('IMMIJurnal', [TJurnalTree]);
end;

{ TJurnalTree }

function TJurnalTree.HasChildGG(GroupName: string): boolean;
begin
    with qry3 do
    begin
      SQL.Clear;
      SQL.add('select * from groups where (parent = "' + GroupName + '") and (isTag = 0)');
      open;
      result := RecordCount > 0;
      close;
    end;
end;

procedure TJurnalTree.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  i: integer;
begin
  if node.HasChildren and (node.Count = 0) then
    with qry2 do
    begin
      SQL.Clear;
      SQL.add('select * from groups where parent ="' + Node.Text + '"');
      open;
      //сначала добавляем группы
      for i := 0 to RecordCount - 1 do
      begin
       if not fieldByName('isTag').AsBoolean then
         with Items.AddChild(Node,fieldbyname('Name').asString) do
         begin
          hasChildren := hasChildGG(text);
         end;
         next;
       end;
      //затем добавляем теги
      {first;
      for i := 0 to RecordCount - 1 do
      begin
       if fieldByName('isTag').AsBoolean then
        with TreeView1.Items.AddChild(Node,fieldbyname('Name').asString) do
        begin
          hasChildren := false;
        end;
        next;
       end;}
      close;
    end;
  if assigned(fOnExpandSave) then fOnExpandSave(Sender, Node, AllowExpansion);
end;

procedure TJurnalTree.FillNodeListByParent(parent: string; List: TStringList);
var
  i: integer;
  query: TQuery;
begin
  query := TQuery.Create(self);
  query.databasename := 'trend';
  try
    with query do
    begin
      SQL.Clear;
      SQL.add('select * from groups where parent ="' + parent + '"');
      open;
      //сначала добавляем группы
      for i := 0 to RecordCount - 1 do
      begin
       if fieldByName('isTag').AsInteger = 1 then
         begin
         list.Add(fieldByName('Name').AsString)

         end
       else
         FillNodeListByParent(fieldByName('Name').AsString, list);
       next;
       end;
      //затем добавляем теги
      {first;
      for i := 0 to RecordCount - 1 do
      begin
       if fieldByName('isTag').AsBoolean then
        with TreeView1.Items.AddChild(Node,fieldbyname('Name').asString) do
        begin
          hasChildren := false;
        end;
        next;
       end;}
      close;
    end;
  finally
    Query.free;
  end;
end;

constructor TJurnalTree.Create(AOwner: TComponent);
var
  i: integer;
begin
  inherited;
  fOnExpandSave := OnExpanding;
  OnExpanding := TreeViewExpanding;
  qry2 := TQuery.Create(self);
  qry2.databaseName := 'Trend';
  qry3 := TQuery.Create(self);
  qry3.databaseName := 'Trend';
end;

destructor TJurnalTree.Destroy;
begin
  qry2.free;
  qry3.free;
  inherited;
end;

procedure TJurnalTree.GetSelection(TegList: TStringList);
begin
  if AnsiUpperCase(Selected.Text) <> AnsiUpperCase('Все события') then
  FillNodeListByParent(Selected.Text,TegList);
end;

procedure TJurnalTree.ImmiInit(var Msg: TMessage);
var
  i: integer;
begin
  //заполняем дерево сортировки
    if not isInit then
    begin
    Items.Clear;
    with qry2 do
    begin
      SQL.Clear;
      SQL.add('select * from groups where parent="Все события"');
      open;
      BaseNode := Items.AddChild(nil,'Все события');
      for i := 0 to RecordCount - 1 do
        with Items.AddChild(nil,fieldbyname('Name').asString) do
        begin
          hasChildren := HasChildGG(fieldbyname('Name').asString);
          next;
        end;
      close;
    end;
  lastFilteredNode := baseNode;
  isinit := true;
  end;
end;

end.
