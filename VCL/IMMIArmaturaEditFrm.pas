unit IMMIArmaturaEditFrm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, Dialogs, Spin, DSGNINTF, IMMIArmatura,
  IMMIArmatVl;

type
  TArmatEditDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    ComboBox1: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    CheckBox1: TCheckBox;
    TabSheet4: TTabSheet;
    CheckBox2: TCheckBox;
    TabSheet5: TTabSheet;
    Edit1: TEdit;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ColorDialog1: TColorDialog;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Edit5: TEdit;
    Label6: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    ComboBox2: TComboBox;
    IMMIArmatVl1: TIMMIArmatVl;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Paint; override;
    procedure DrawValve;
  end;

  TArmatEditor = class (TComponentEditor)
  public
    procedure Edit; override;
  end;

var
  ArmatEditDlg: TArmatEditDlg;


Procedure Register;
implementation

{$R *.DFM}

procedure TArmatEditDlg.ComboBox1Change(Sender: TObject);
begin
     PageControl1.ActivePage := PageControl1.Pages[0];
     case ComboBox1.ItemIndex of
     0: begin
             TabSheet2.TabVisible := False;
             TabSheet5.TabVisible := False;
        end;
     1: begin
             TabSheet2.TabVisible := True;
             TabSheet5.TabVisible := True;
        end;
     2: begin
             TabSheet2.TabVisible := False;
             TabSheet5.TabVisible := False;
        end;
     end;
     update;
end;

procedure TArmatEditDlg.FormCreate(Sender: TObject);
begin
  TabSheet2.TabVisible := False;
  TabSheet5.TabVisible := False;
  edit1.Text := '';
  edit2.Text := '';
  edit3.Text := '';
  edit4.Text := '';
  edit5.Text := '';
end;

procedure TArmatEditDlg.SpeedButton1Click(Sender: TObject);
begin
     colorDialog1.Color := SpeedButton1.Tag;
     If colorDialog1.Execute then
        SpeedButton1.Tag := colorDialog1.Color;
     invalidate;
end;

procedure TArmatEditDlg.DrawValve;
begin
   with ArmatEditDlg.Canvas do begin
     case ArmatEditDlg.PageControl1.ActivePage.PageIndex of
       0:
       begin
           Brush.Color := SpeedButton1.Tag;
           Pen.Color := SpeedButton2.Tag;
       end;
       1:
       begin
           Brush.Color := SpeedButton3.Tag;
           Pen.Color := SpeedButton4.Tag;
       end;
       2:
       begin
           Brush.Color := SpeedButton5.Tag;
           Pen.Color := SpeedButton6.Tag;
       end;
     end;
       Polygon ([Point(180, 10), Point(230, 30),
                 Point(230, 10), Point(180, 30),
                 Point(180, 10)]);
     end;
end;

procedure TArmatEditDlg.SpeedButton2Click(Sender: TObject);
begin
     colorDialog1.Color := SpeedButton2.Tag;
     If colorDialog1.Execute then
        SpeedButton2.Tag := colorDialog1.Color;
     invalidate;
end;

procedure TArmatEditDlg.PageControl1Change(Sender: TObject);
begin
  invalidate;
end;

procedure TArmatEditDlg.Paint;
begin
     inherited;
     DrawValve;
end;


procedure TArmatEditDlg.SpeedButton3Click(Sender: TObject);
begin
     colorDialog1.Color := SpeedButton3.Tag;
     If colorDialog1.Execute then
        SpeedButton3.Tag := colorDialog1.Color;
     invalidate;
end;

procedure TArmatEditDlg.SpeedButton4Click(Sender: TObject);
begin
     colorDialog1.Color := SpeedButton4.Tag;
     If colorDialog1.Execute then
        SpeedButton4.Tag := colorDialog1.Color;
     invalidate;
end;


procedure TArmatEditDlg.SpeedButton5Click(Sender: TObject);
begin
     colorDialog1.Color := SpeedButton5.Tag;
     If colorDialog1.Execute then
        SpeedButton5.Tag := colorDialog1.Color;
     invalidate;
end;

procedure TArmatEditDlg.SpeedButton6Click(Sender: TObject);
begin
     colorDialog1.Color := SpeedButton6.Tag;
     If colorDialog1.Execute then
        SpeedButton6.Tag := colorDialog1.Color;
     invalidate;
end;

procedure TArmatEditDlg.CheckBox1Click(Sender: TObject);
begin
     if CheckBox1.Checked then begin
        label6.Visible := true;
        edit5.Visible := true;
        SpeedButton5.Visible := true;
        SpeedButton6.Visible := true;
     end else begin
        edit5.Visible := false;
        label6.Visible := false;
        SpeedButton5.Visible := false;
        SpeedButton6.Visible := false
     end;
end;

procedure TArmatEditDlg.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
  begin
    spinEdit1.Visible := true;
    edit2.Visible := true;
    edit3.Visible := true;
    label2.Visible := true;
    label3.Visible := true;
    label4.Visible := true;
  end else begin
    spinEdit1.Visible := false;
    edit2.Visible := false;
    edit3.Visible := false;
    label2.Visible := false;
    label3.Visible := false;
    label4.Visible := false;
  end;

end;
{*********************TArmatEditor***************}
procedure TArmatEditor.Edit;
begin
     ArmatEditDlg := tArmatEditDlg.create(Application);
     with TIMMIArmat(Component) do begin
          ArmatEditDlg.ComboBox1.ItemIndex := ord(armatType);
          ArmatEditDlg.ComboBox2.ItemIndex := ord(armatOrient);

          ArmatEditDlg.Edit1.Text := OnStyle.Param.rtName;
          ArmatEditDlg.SpeedButton1.Tag := OnStyle.brush.Color;
          ArmatEditDlg.SpeedButton2.Tag := OnStyle.pen.Color;

          ArmatEditDlg.Edit4.Text := OffStyle.Param.rtName;
          ArmatEditDlg.SpeedButton3.Tag := OffStyle.brush.Color;
          ArmatEditDlg.SpeedButton4.Tag := OffStyle.pen.Color;

          ArmatEditDlg.Edit5.Text := errorStyle.Param.rtName;
          ArmatEditDlg.SpeedButton5.Tag :=  ErrorStyle.brush.Color;
          ArmatEditDlg.SpeedButton6.Tag := ErrorStyle.pen.Color;
          ArmatEditDlg.CheckBox1.Checked := UseError;

          ArmatEditDlg.CheckBox2.Checked := UseControl;
          ArmatEditDlg.spinEdit1.Value := access;
          ArmatEditDlg.Edit2.Text := onParamControl;
          ArmatEditDlg.Edit3.Text := offParamControl;

          if ArmatEditDlg.ShowModal = mrOK then begin
            armatType := TArmatType(ArmatEditDlg.ComboBox1.ItemIndex);
            armatOrient := TArmatOrient(ArmatEditDlg.ComboBox2.ItemIndex);

            OnStyle.Param.rtName := ArmatEditDlg.Edit1.Text;
            OnStyle.brush.Color := ArmatEditDlg.SpeedButton1.Tag;
            OnStyle.pen.Color := ArmatEditDlg.SpeedButton2.Tag;

            OffStyle.Param.rtName := ArmatEditDlg.Edit4.Text;
            OffStyle.brush.Color := ArmatEditDlg.SpeedButton3.Tag;
            OffStyle.pen.Color := ArmatEditDlg.SpeedButton4.Tag;

            ErrorStyle.Param.rtName := ArmatEditDlg.Edit5.Text;
            ErrorStyle.brush.Color := ArmatEditDlg.SpeedButton5.Tag;
            ErrorStyle.pen.Color := ArmatEditDlg.SpeedButton6.Tag;
            UseError := ArmatEditDlg.CheckBox1.Checked;

            UseControl := ArmatEditDlg.CheckBox2.Checked;
            access := ArmatEditDlg.spinEdit1.Value;
            onParamControl := ArmatEditDlg.Edit2.Text;
            offParamControl := ArmatEditDlg.Edit3.Text;
          end;
     end;
     ArmatEditDlg.Free;
end;

{*******************************************************}
procedure Register;
begin
     RegisterComponentEditor(TIMMIArmat, TArmatEditor);
end;
end.

