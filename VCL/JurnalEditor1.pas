unit JurnalEditor1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin, ExtCtrls, Expr, DesignEditors, DesignIntf, MemStructsU;

type
  TfrmJurnalEditor = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tsMain: TTabSheet;
    Label1: TLabel;
    cbDate: TCheckBox;
    cbTime: TCheckBox;
    cbComment: TCheckBox;
    cbLevel: TCheckBox;
    cbParam: TCheckBox;
    cbOper: TCheckBox;
    cbState: TCheckBox;
    Label2:TLabel;
    seWidth0: TSpinEdit;
    seWidth1: TSpinEdit;
    Label3: TLabel;
    seWidth2: TSpinEdit;
    Label4: TLabel;
    seWidth3: TSpinEdit;
    Label5: TLabel;
    seWidth4: TSpinEdit;
    Label6: TLabel;
    seWidth5: TSpinEdit;
    Label7: TLabel;
    seWidth6: TSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    seLevelFrom: TSpinEdit;
    seLevelTo: TSpinEdit;
    Label11: TLabel;
    Label12: TLabel;
    TabSheet2: TTabSheet;
    Label13: TLabel;
    ebCMDShow: TEdit;
    ebCmdPrint: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    cbmsNew: TCheckBox;
    cbmsout: TCheckBox;
    cbMSKvit: TCheckBox;
    ebmsNew: TEdit;
    Label16: TLabel;
    ebmsOut: TEdit;
    ebmsKvit: TEdit;
    Label17: TLabel;
    cbmsOn: TCheckBox;
    cbmsoff: TCheckBox;
    cbmsCmd: TCheckBox;
    Label18: TLabel;
    ebmsOn: TEdit;
    ebmsoff: TEdit;
    ebmsCmd: TEdit;
    Label19: TLabel;
    ebDate: TEdit;
    ebTimeFrom: TEdit;
    ebTimeTo: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    cbJurnalTree: TComboBox;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    CheckBox2: TCheckBox;
    procedure ebCMDShowExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure checkExprOverride;
  end;

TJurnalEditor = class(TComponentEditor)
public
  procedure ExecuteVerb(Index: Integer); override;
  function GetVerb(Index: Integer): string; override;
  function GetVerbCount: Integer; override;
end;


implementation
uses Jurnal;

{$R *.dfm}

{ TfrmJurnalEditor }

procedure TfrmJurnalEditor.checkExprOverride;
begin
      cbMsnew.Enabled := (ebmsNew.Text = '');
      cbMsOut.Enabled := (ebmsOut.Text = '');
      cbMsKvit.Enabled := (ebmsKvit.Text = '');
      cbMsOn.Enabled := (ebmsOn.Text = '');
      cbMsOff.Enabled := (ebmsOff.Text = '');
      cbMsCmd.Enabled := (ebmsCmd.Text = '');
end;

procedure TfrmJurnalEditor.ebCMDShowExit(Sender: TObject);
begin
  if not assigned(rtItems) then exit;
  if CheckExpr((sender as TEdit).Text) <> cesCorr then
  begin
    ShowMessage('Неверное выражение: ' + (sender as TEdit).Text);
    (Sender as TEdit).SetFocus;
  end;
end;

{ TIMMILabelEditor }

procedure TJurnalEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  if Index = 0 then begin
    (Component as TJurnal).ShowPropForm;
    Designer.Modified;
  end;
end;

function TJurnalEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TJurnalEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.
