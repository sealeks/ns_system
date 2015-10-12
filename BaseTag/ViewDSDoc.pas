unit ViewDSDoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Grids, StdCtrls, Spin, ExtCtrls, ComCtrls, convFunc;

type
  TDocV = packed record
    unUsed0: word;
    MemType: byte;
    addr: dword;
    Name: array[1..17] of Char;
    WI: array[1..17] of Char;
    Comment: array[1..164] of Char;
  end;

TDocFile = packed record
  header: array [1..1229] of byte;
  docV: array[1..100000] of TDocV;
end;

PTDocFile = ^TDocFile;

  TESDImpFrm = class(TForm)
    StringGrid1: TStringGrid;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    Expott1: TMenuItem;
    Edit1: TMenuItem;
    Sort1: TMenuItem;
    ProgressBar1: TProgressBar;
    ComboBox1: TComboBox;
    Exit1: TMenuItem;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Expott1Click(Sender: TObject);
    procedure Sort1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure FillGridLine (PdocFile: PTDocFile; RecCount : integer);
    procedure ExportDoc(FileName: string);
  public
    { Public declarations }
    procedure ShowDoc(FileName: string);
  end;

var
  ESDImpFrm: TESDImpFrm;
  PdocFile: PTDocFile;
  recCount: longInt;

function FullTrim(source: string): string;

implementation

{$R *.DFM}

function GetDocTypeLeter (Doctype: byte): string;
begin
  result := '';
  case docType of
    8: result := 'X';
    9: result := 'Y';
    10: result := 'C';
    12: result := 'S';
    13: result := 'T';
    15: result := 'GX';
    17: result := 'V';
    22: result := 'SP';
    27: result := 'B';
  end;
end;

procedure TESDImpFrm.FillGridLine (PdocFile: PTDocFile; RecCount : integer);
var
  docType: string;
  i: longInt;
  CellRow: longInt;
begin
  cellRow := 1;
  with StringGrid1 do
  begin
    for i := 1 to recCount do begin
      ProgressBar1.Position := i;
      docType := GetDocTypeLeter(PdocFile.DocV[i].MemType);
      if (ComboBox1.Text = '') or
          ((ComboBox1.Text <> 'B') and
           (ComboBox1.Text = docType) and
           ((Edit2.Tag <= PdocFile.DocV[i].addr) and
            (Edit3.Tag >= PdocFile.DocV[i].addr) or
            (Edit3.Tag = 0)
           ) or
          ((ComboBox1.Text = 'B') and
           (ComboBox1.Text = docType) and
           ((Edit2.Tag <= (PdocFile.DocV[i].addr div 16)) and
            (Edit3.Tag >= (PdocFile.DocV[i].addr div 16)) or
            (Edit3.Tag = 0)
           )
          )
         )  then
      begin
        Cells[0, cellRow] := docType;
        if docType <> 'B' then
          Cells[1, cellRow] := IntegerToOctString(PdocFile.DocV[i].addr)
        else
          Cells[1, cellRow] := IntegerToOctString(PdocFile.DocV[i].addr div 16) + '.' +
                            inttostr (PdocFile.DocV[i].addr mod 16);
        Cells[2, cellRow] := trim(PdocFile.DocV[i].Name);
        Cells[3, cellRow] := trim(PdocFile.DocV[i].WI);
        Cells[4, cellRow] := FullTrim(PdocFile.DocV[i].Comment);
        inc (cellRow);
      end;
    end;
    //clear free part of grid
    for i := CellRow to recCount do begin
      Cells[0, i] := '';
      Cells[1, i] := '';
      Cells[2, i] := '';
      Cells[3, i] := '';
      Cells[4, i] := '';
    end;
  end;
end;


procedure TESDImpFrm.ShowDoc(FileName: string);
 var
   dataFile: file;
   size: longInt;

begin
  try

    AssignFile(dataFile, FileName);
    Reset(dataFile, 1);	{ Record size = 1 }

    Size := FileSize(dataFile);
    GetMem(PDocFile, Size);
    BlockRead(dataFile, PDocFile^, Size);
  finally
    closeFile (dataFile);
  end;

  recCount := (size - sizeOf(PDocFile.Header)) div sizeof (TDocV);
  ProgressBar1.Max := recCount;
  ProgressBar1.Step := recCount div 10;
  StringGrid1.rowCount := recCount;
  FillGridLine (PdocFile, RecCount);
end;

function FullTrim(source: string): string;
var
  i: integer;
begin
  result := '';
  for i := 1 to length (source) do
    if ord(source[i]) > 30 then result := result + source[i];
end;

procedure TESDImpFrm.ExportDoc(FileName: string);
 var
   dataFile: TextFile;
   var i: integer;
begin
try
  AssignFile(dataFile, FileName);
  Rewrite(dataFile);	{ Record size = 1 }
  for i := 1 to StringGrid1.RowCount-1 do
  begin
    ProgressBar1.Position := i;
    if StringGrid1.Cells[0, i] <> '' then begin
      write (dataFile, StringGrid1.Cells[0, i] + StringGrid1.Cells[1, i] + ';');
      write (dataFile, StringGrid1.Cells[2, i] + ';');
      write (dataFile, StringGrid1.Cells[3, i] + ';');
      writeLn (dataFile, FullTrim(StringGrid1.Cells[4, i]) + ';');
    end;
  end;
finally
  closeFile (dataFile);
end;
end;

procedure TESDImpFrm.FormCreate(Sender: TObject);
begin
  with stringGrid1 do
  begin
    Cells[0, 0] := 'Тип';
    Cells[1, 0] := 'Адрес';
    Cells[2, 0] := 'Имя';
    Cells[3, 0] := 'Инфо';
    Cells[4, 0] := 'Комментарий';
  end;
end;

procedure TESDImpFrm.Expott1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if pos ('.', SaveDialog1.FileName) = 0 then
      SaveDialog1.FileName := SaveDialog1.FileName + '.csv';
    ExportDoc (SaveDialog1.FileName);
  end;
end;

function IsLessLine (Line1, Line2: integer) : boolean;
begin
  result := false;
    if PDocFile.DocV[Line1].MemType < PDocFile.DocV[Line2].MemType then
    begin
      result := true;
      exit;
    end;
    if (PDocFile.DocV[Line1].MemType = PDocFile.DocV[Line2].MemType) then
      if PDocFile.DocV[Line1].Addr < PDocFile.DocV[Line2].Addr then
      begin
        result := true;
        exit;
      end;
end;

function FindMinLine (firstLine, LastLine: integer) : integer;
var
  i: integer;
begin
  result := firstLine;
  for i := firstLine + 1 to LastLine do
    if IsLessLine (i, result) then result := i;
end;

Procedure SwapLines (Line1, Line2: integer);
var
  i: integer;
  docV: TDocV;
begin
  for i := 0 to 4 do begin
    docV := PdocFile.DocV[Line1];
    PdocFile.DocV[Line1] := PdocFile.DocV[Line2];
    PdocFile.DocV[Line2] := docV;
  end;
end;

procedure TESDImpFrm.Sort1Click(Sender: TObject);
var
  firstLine: integer;
begin
  for firstLine := 1 to RecCount do begin
    swapLines (firstLine, FindMinLine(firstLine, RecCount));
    ProgressBar1.Position := firstLine;
  end;
    FillGridLine (PdocFile, RecCount);
end;

procedure TESDImpFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  freeMem (PDocFile);
end;


procedure TESDImpFrm.Exit1Click(Sender: TObject);
begin
  application.Terminate;
end;

procedure TESDImpFrm.Edit2Exit(Sender: TObject);
begin
  try
    Edit2.tag := OctstringToInteger (Edit2.Text);
  except
    showMessage ('Неверное восьмеричное значение');
    edit2.setFocus;
  end;
end;

procedure TESDImpFrm.Edit3Exit(Sender: TObject);
begin
  try
    Edit3.tag := OctstringToInteger (Edit3.Text);
  except
    showMessage ('Неверное восьмеричное значение');
    edit3.setFocus;
  end;
end;

procedure TESDImpFrm.Button1Click(Sender: TObject);
begin
    FillGridLine (PdocFile, RecCount);
end;

end.
