unit RestoreDataModU;

interface

uses
  SysUtils, Classes, DB, DBTables, ConstDef, dm2U, Variants, UMyTime,Forms,fLoadU, Dialogs;

type
  TRestoreDataMod = class(TDataModule)
    Query1: TTable;
    Db1: TDatabase;
  private
    { Private declarations }
  public
    procedure CheckandRestore;
    procedure  CheckTable(Tabn: string; db: string);
     function FindFileTableInDb(iFileName: String; iDataBaseName: string): boolean;
    { Public declarations }
  end;

var
  RestoreDataMod: TRestoreDataMod;


implementation

procedure  TRestoreDataMod.CheckandRestore;
var i: integer;
begin
  try

  CheckTable('trenddef','Trend');
  CheckTable('StStdef','Trend');
  for i:=1 to 254 do
     CheckTable(trim('StStdef'+inttostr(i)),'Trend');
  CheckTable('Groups','Trend');
  CheckTable('Trends','Trend');
 // CheckTable('TrendTest','Trend');

  CheckTable('trend' + datetoFileName(Date),'Trend');

  CheckTable(datetoFileName(Date),'Alarms');
  CheckTable('Access','Registration');
  CheckTable('Operators','Registration');

  except

  end;
  if RestoreBDE<>nil then begin
  RestoreBDE.Timer1.Enabled:=true;
  RestoreBDE.Hide;
  RestoreBDE.ShowModal;
  RestoreBDE.Free;
  end;
 Query1.Close;
// fload.Show;
end;



procedure  TRestoreDataMod.CheckTable(Tabn: string; db: string);
begin
  if not FindFileTableInDb(Tabn, db) then exit;

  try
  self.Query1.DatabaseName:=db;
  self.Query1.TableName:=Tabn;
  self.Query1.Open;
  except
    // Showmessage(Tabn);
   if RestoreBDE=nil then
   begin
   RestoreBDE:=TRestoreBDE.Create(Application);
  // Showmessage(Tabn);
   RestoreBDE.ListBox1.Clear;



  
   Application.ProcessMessages;
   end;
  RestoreBDE.WorkTabale(Tabn, db);
 end;
  self.Query1.Active:=false;
  self.Query1.Close;
//  self.Query1.SQL.Add('select * from ' + Tabn);
//  self.Query1.ExecSQL;
end;

{$R *.dfm}

function TRestoreDataMod.FindFileTableInDb(iFileName: String; iDataBaseName: string): boolean;
var st: string;
begin
result:=false;
try
// Db1.Close;
 DB1.AliasName:= iDataBaseName;
 //Db1.Open;
 Db1.Connected:=true;
 st:= Db1.Directory+''+iFileName+'.db';
 result:=FileExists(st);
 Db1.Close;
except
end;
end;


end.
