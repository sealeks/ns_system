unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, StdCtrls, Grids, DBGrids, PrintReport;


type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    Table1: TTable;
    DBGrid1: TDBGrid;
    HeaderTEdit: TEdit;
    Heading1TEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Heading2TEdit: TEdit;
    TextTEdit: TEdit;
    Label4: TLabel;
    StringsTMemo: TMemo;
    WrappedTextTEdit: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    TextFileTButton: TButton;
    CSVFileTButton: TButton;
    HTMLFileTButton: TButton;
    PaperTButton: TButton;
    Query1: TQuery;
    DataSource2: TDataSource;
    DBGrid2: TDBGrid;
    Label8: TLabel;
    Header1TEdit: TEdit;
    PrintTButton: TButton;
    RTFFileTButton: TButton;
    procedure TextFileTButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CSVFileTButtonClick(Sender: TObject);
    procedure HTMLFileTButtonClick(Sender: TObject);
    procedure PaperTButtonClick(Sender: TObject);
    procedure PrintTButtonClick(Sender: TObject);
    procedure RTFFileTButtonClick(Sender: TObject);
    procedure PrintAggGroupTButtonClick(Sender: TObject);
  private
    { Private declarations }
    PrintReport : TReport;
//    PrintReport : TTYReport;
    procedure OutputData;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.FormCreate(Sender: TObject);
begin
    PrintReport := TReport.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    PrintReport.Free;
end;


procedure TForm1.OutputData;
begin

    PrintReport.Clear;

    PrintReport.PrintHeader( HeaderTEdit.Text );
    PrintReport.PrintHeader( Header1TEdit.Text );

    PrintReport.PrintHeading1( Heading1TEdit.Text );
    PrintReport.PrintHeading2( Heading2TEdit.Text );
    PrintReport.PrintText( TextTEdit.Text );
//   PrintReport.PrintWrappedText( WrappedTextTEdit.Text );

    PrintReport.PrintWrappedText(
        '0 The quick brown fox jumped over the lazy doggy.  ' +
        '1 The quick brown fox jumped over the lazy doggy.  ' +
        '2 The quick brown fox jumped over the lazy dog''''s breakfast.  ' +
        '3 The quick brown fox jumped over the lazy poodle.  ' +
        '4 The quick brown fox jumped.  ' +
        '5 The quick brown fox jumped over the gargantuan lazy dog.  ' +
        '6 The quick brown fox jumped over snail.  ' +
        '7 The quick brown fox fell asleep on the lazy dog.  ' +
        '8 The quick brown fox jumped over the lazy dog and 10000 other dogs.  ' +
        '9 The quick brown fox jumped high over the lazy dog.  ' +
        '10 The quick brown fox jumped over the lazy dog.  '
    );

    PrintReport.PrintStrings( StringsTMemo.Lines );


    Query1.First;

    PrintReport.PrintDBGridBlock( DBGrid2, 'Block 1 Caption...',
        Query1.FieldByName( 'Grouping' ) );
    PrintReport.PrintDBGridBlock( DBGrid2, 'Block 2 Caption...',
        Query1.FieldByName( 'Grouping' ) );
    PrintReport.PrintDBGridBlock( DBGrid2, 'Block 3 Caption...',
        Query1.FieldByName( 'Grouping' ) );

    PrintReport.PrintDBGrid( DBGrid1, '(Grid Caption) Customer Details...' );
    PrintReport.PrintDBGrid( DBGrid1, '(Grid Caption) Customer Details...' );

end;


procedure TForm1.TextFileTButtonClick(Sender: TObject);
begin
    OutputData;
    PrintReport.DestFileName := 'Print.txt';
    PrintReport.OutputToText;
end;

procedure TForm1.CSVFileTButtonClick(Sender: TObject);
begin
    OutputData;
    PrintReport.DestFileName := 'Print.csv';
    PrintReport.OutputToCSV;
end;

procedure TForm1.HTMLFileTButtonClick(Sender: TObject);
begin
    OutputData;
    PrintReport.DestFileName := 'Print.htm';
    PrintReport.OutputToHTML;
end;

procedure TForm1.RTFFileTButtonClick(Sender: TObject);
begin
    OutputData;
    PrintReport.DestFileName := 'Print.rtf';
    PrintReport.OutputToRtf;
end;

procedure TForm1.PaperTButtonClick(Sender: TObject);
begin
    OutputData;
    PrintReport.OutputToPrinter;
end;


procedure TForm1.PrintTButtonClick(Sender: TObject);
begin
    OutputData;
    PrintReport.IniFileName := ExtractFilePath( ParamStr(0) ) + '\Print.ini';
    PrintReport.IniSection := 'TEST';
    PrintReport.Execute;
end;



procedure TForm1.PrintAggGroupTButtonClick(Sender: TObject);
begin
    // Add similar code to PrintRaceGroupsTButtonClick(Sender: TObject)
    // event handler
end;

end.


