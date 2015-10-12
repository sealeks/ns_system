unit GroupsU;

interface
uses classes, Grids, sysUtils, stdCtrls;

type
TGroup = record
 Num: integer;
 Name, App, Topic: string;
 SlaveNum: integer;
end;
PTGroup = ^TGroup;

TGroups = class (TList)
private
    filename: string;
    procedure loadFromFile(FN: string);
    function Get(Index: Integer): PTGroup;
    procedure Put(Index: Integer; const Value: PTGroup);
    function GetNamebyNum(Num: integer): string;
    function GetNumbyName(Nm: string): integer;
    function GetIdxName(Index: string): integer;
public
  constructor Create(FN: string);
  procedure SaveToFile(FN: string);
  property Items[Index: Integer]: PTGroup read Get write Put;
  property ItemNameByNum[Index: Integer]: string read GetNameByNum; default;
  property ItemNum[Index: string]: integer read GetNumByName;
  property Idx[Index: string]: integer read GetIdxName;
  procedure Add(gr: PTGroup); overload;
  procedure Add(Name, App, Topic: string); overload;
  procedure DeleteGroup(Name: string);
  function GetAppbyNum(Num: integer): string;
  function GetTopicbyNum(Num: integer): string;
  function GetSlavebyNum(Num: integer): integer;//return -1 if not found
  function GetIdxByNum(Num: integer): integer;//return -1 if not found
  function GetFreeNum: integer;
  procedure FillStrings(cb: TStrings);
  destructor Destroy; override;
end;

procedure FillGridFromCSV(gr: tStringGrid; fn: string);
procedure SaveGridToCSV(gr: tStringGrid; fn: string);

implementation

function GetWord(var str: string; comp: char): string;
begin
  result := trim (copy(str, 1, pos(comp, str) - 1));
  if pos(comp, str) = 0 then
  begin
   result := str;
   str := '';
  end
  else
    str := copy(str, pos(comp, str) + 1, length(str) - pos(comp, str));
end;

procedure FillGridFromCSV(gr: tStringGrid; fn: string);
var
 f: textFile;
 str: string;
 curCol, curRow: integer;
begin
  assignFile(f,fn);
  if not FileExists(fn) then
    raise Exception.Create('Файл '+ fn + 'не найден');
  try
    reset(f);
    curRow := 0;
    while not eof(f) do
    begin
     readln(f, str);
     curCol := 0;
     if gr.RowCount <= curRow then Gr.RowCount := Gr.RowCount + 1;
     while str <> '' do
     begin
       if Gr.ColCount <= curCol then Gr.ColCount := Gr.ColCount + 1;
       gr.Cells[curCol, curRow] := GetWord(str, ';');
       inc(curCol);
     end;
     inc(curRow);
    end;
  finally
   close(f);
  end;
end;


procedure SaveGridToCSV(gr: tStringGrid; fn: string);
var
 f: textFile;
 i, j: integer;
begin
  assignFile(f,fn);
  try
    rewrite(f);
    for i := 0 to gr.RowCount - 1 do
      for j := 0 to gr.colCount - 1 do
        if j < gr.colCount - 1 then
          write(f, gr.cells[j, i], ';')
        else writeln(f, gr.cells[j, i]);
  finally
   close(f);
  end;
end;

{ TGroups }

procedure TGroups.Add(gr: PTGroup);
var
  i: integer;
begin
  gr.Num := GetFreeNum;
  inherited Add(gr);
end;

procedure TGroups.Add(Name, App, Topic: string);
var
  f: textFile;
  str: string;
  it: PTGroup;
begin
     new(It);
     it.Num := GetFreeNum;
     it.Name := Name;
     it.App := App;
     it.Topic := Topic;
     add(It);
     savetofile(fileName);
end;

constructor TGroups.Create(FN: string);
begin
 inherited Create;
 loadFromFile(FN);
end;

procedure TGroups.DeleteGroup(Name: string);
var
  i: integer;
begin
  for i := 0 to count - 1 do
   if PTGroup(items[i]).Name = Name then
   begin
     dispose(items[i]);
     delete(i);
     break;
   end;
  savetofile(fileName);
end;

destructor TGroups.Destroy;
begin
  while Count <> 0 do
  begin
   dispose(items[count-1]);
   delete(count-1);
  end;
  inherited;
end;

procedure TGroups.FillStrings(cb: TStrings);
var
  i: integer;
begin
    for i := 0 to Count - 1 do
      cb.Add(Items[i].Name);
end;

function TGroups.Get(Index: Integer): PTGroup;
begin
  result := PTGroup(inherited Items[index]);
end;

function TGroups.GetAppbyNum(Num: integer): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to count - 1 do
   if PTGroup(items[i]).Num = num then
   begin
     result := PTGroup(items[i]).App;
     break;
   end;
end;

function TGroups.GetFreeNum: integer;
var
  num: integer;
begin
  num := 1;
  while getNameByNum(num) <> '' do inc(num);
  result := num;
end;

function TGroups.GetIdxByNum(Num: integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to count - 1 do
   if PTGroup(items[i]).Num = num then
   begin
     result := i;
     break;
   end;
end;

function TGroups.GetIdxName(Index: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to count - 1 do
   if PTGroup(items[i]).Name = Index then
   begin
     result := i;
     break;
   end;
end;

function TGroups.GetNamebyNum(Num: integer): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to count - 1 do
   if PTGroup(items[i]).Num = num then
   begin
     result := PTGroup(items[i]).name;
     break;
   end;
end;

function TGroups.GetNumbyName(Nm: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to count - 1 do
   if AnsiUpperCase(PTGroup(items[i]).Name) = AnsiUpperCase(nm) then
   begin
     result := PTGroup(items[i]).Num;
     break;
   end;
end;

function TGroups.GetSlavebyNum(Num: integer): Integer;
var
 i: integer;
begin
  result := -1;
  for i := 0 to count - 1 do
   if PTGroup(items[i]).Num = num then
   begin
     result := PTGroup(items[i]).SlaveNum;
     break;
   end;
end;

function TGroups.GetTopicbyNum(Num: integer): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to count - 1 do
   if PTGroup(items[i]).Num = num then
   begin
     result := PTGroup(items[i]).Topic;
     break;
   end;
end;

procedure TGroups.loadFromFile(FN: string);
var
  f: textFile;
  str: string;
  it: PTGroup;
begin
 if not FileExists(FN) then raise Exception.Create('Файл не найден: ' + FN);
 fileName := fn;
 assignFile (f, FN);
 reset(f);
 readLn(f, str);
 try
   while not eof(f) do
   begin
     readLn(f, str);
     new(It);
     it.Num := strtoint(getWord(str, ';'));
     it.Name := getWord(str, ';');
     it.App := getWord(str, ';');
     it.Topic := getWord(str, ';');
     it.SlaveNum := strtoint(getWord(str, ';'));
     inherited add(It);
   end;
 finally
   closefile(f);
 end;
end;

procedure TGroups.Put(Index: Integer; const Value: PTGroup);
begin
  inherited Items[index] := Pointer(value);
end;

procedure TGroups.SaveToFile(FN: string);
var
  f: textFile;
  i: integer;
begin
 assignFile (f, FN);
 rewrite(f);
 try
   writeln(f, '№ группы;Название;Приложение;Тема;№ ведмого');
   for i := 0 to Count - 1 do
     writeln(f, items[i].num, ';', items[i].name, ';', items[i].App, ';',
                items[i].Topic, ';', items[i].SlaveNum);
 finally
   closefile(f);
 end;
end;

end.
