unit frmSelectDirU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellCtrls, ExtCtrls;

type
  TfrmSelectDir = class(TForm)
    Panel1: TPanel;
    ShellTreeView: TShellTreeView;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSelectDir: TfrmSelectDir;

implementation

{$R *.dfm}

end.
