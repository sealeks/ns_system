unit PrintMainDlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls {StdCtrls, DB, DBTables};

type
  TPrintMainDialog = class(TForm)
    CancelTButton: TButton;
    okTButton: TButton;
    GroupBox1: TGroupBox;
    CsvTRadioButton: TRadioButton;
    HtmTRadioButton: TRadioButton;
    RtfTRadioButton: TRadioButton;
    TxtTRadioButton: TRadioButton;
    InternetTRadioButton: TRadioButton;
    GroupBox2: TGroupBox;
    LayoutTButton: TButton;
    SetupTButton: TButton;
    PrinterTLabel: TLabel;
    WinTRadioButton: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  PrintMainDialog: TPrintMainDialog;

implementation

{$R *.DFM}

end.



