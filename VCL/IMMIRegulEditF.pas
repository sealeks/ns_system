unit IMMIRegulEditF;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Grids, Spin, EditExpr, ComCtrls, FloatEdits;

type
  TRegulEditF = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    prcaption: TEdit;
    prAccess: TSpinEdit;
    prparampv: TEditExpr;
    Label6: TLabel;
    Label7: TLabel;
    prIMpv: TEditExpr;
    Label8: TLabel;
    Label9: TLabel;
    prparamsp: TEditExpr;
    primsp: TEditExpr;
    Label10: TLabel;
    prparamflysp: TEditExpr;
    pravtomat: TEditExpr;
    Label11: TLabel;
    Label12: TLabel;
    prkp1: TEditExpr;
    prkp2: TEditExpr;
    Label13: TLabel;
    Label14: TLabel;
    prti1: TEditExpr;
    prti2: TEditExpr;
    prtd: TEditExpr;
    Label4: TLabel;
    Label5: TLabel;
    Label15: TLabel;
    prddb: TEditExpr;
    prtfull: TEditExpr;
    Label16: TLabel;
    Label17: TLabel;
    prtimp: TEditExpr;
    prVsp: TEditExpr;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    prParamD1: TEditExpr;
    prParamD2: TEditExpr;
    prParamD3: TEditExpr;
    Label22: TLabel;
    prParamDName1: TEdit;
    prParamDName2: TEdit;
    prParamDName3: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    prdeps: TEditExpr;
    prrv: TEditExpr;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    pribnnag: TEditExpr;
    pribnnpg: TEditExpr;
    Label29: TLabel;
    Label30: TLabel;
    pribnvag: TEditExpr;
    pribnvpg: TEditExpr;
    Label31: TLabel;
    Label32: TLabel;
    prcorrectaccess: TSpinEdit;
    Label33: TLabel;
    TabSheet2: TTabSheet;
    Label18: TLabel;
    Label34: TLabel;
    prcaption1: TEdit;
    praccess1: TSpinEdit;
    prparampv1: TEditExpr;
    Label35: TLabel;
    Label36: TLabel;
    primpv1: TEditExpr;
    Label37: TLabel;
    Label38: TLabel;
    prparamsp1: TEditExpr;
    primsp1: TEditExpr;
    Label39: TLabel;
    prparamflysp1: TEditExpr;
    pravtomat1: TEditExpr;
    Label40: TLabel;
    Label41: TLabel;
    prkp11: TEditExpr;
    prkp21: TEditExpr;
    Label42: TLabel;
    Label43: TLabel;
    prti11: TEditExpr;
    prti21: TEditExpr;
    prtd1: TEditExpr;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    prddb1: TEditExpr;
    prtfull1: TEditExpr;
    Label47: TLabel;
    Label48: TLabel;
    prtimp1: TEditExpr;
    prvsp1: TEditExpr;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    prparamd11: TEditExpr;
    prparamd21: TEditExpr;
    prparamd31: TEditExpr;
    Label52: TLabel;
    prparamdname11: TEdit;
    prparamdname21: TEdit;
    prparamdname31: TEdit;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    prdeps1: TEditExpr;
    prrv1: TEditExpr;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    pribnnag1: TEditExpr;
    pribnnpg1: TEditExpr;
    Label59: TLabel;
    Label60: TLabel;
    pribnvag1: TEditExpr;
    pribnvng1: TEditExpr;
    Label61: TLabel;
    Label62: TLabel;
    SpinEdit2: TSpinEdit;
    Label63: TLabel;
    EditExpr26: TEditExpr;
    Label64: TLabel;
    Label65: TLabel;
    EditExpr27: TEditExpr;
    EditExpr28: TEditExpr;
    Label66: TLabel;
    prnameparam: TEdit;
    Label67: TLabel;
    Label69: TLabel;
    prnameed: TEdit;
    Label70: TLabel;
    prnameparam1: TEdit;
    Label72: TLabel;
    prnameed1: TEdit;
    prisquery1: TCheckBox;
    prisquery: TCheckBox;
    PRPARAMMIN: TFloatEdit;
    prparammax: TFloatEdit;
    Label73: TLabel;
    Label74: TLabel;
    prparammin1: TFloatEdit;
    prparammax1: TFloatEdit;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Edit1: TEdit;
    Label68: TLabel;
    ComboBox2: TComboBox;
    SpinEdit1: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Label71: TLabel;
    Label79: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RegulEditF: TRegulEditF;

implementation

{$R *.DFM}

procedure TRegulEditF.FormCreate(Sender: TObject);
begin
   //  StringGrid1.Cells[0, 1] := 'Значение';
   //  StringGrid1.Cells[0, 2] := 'Задание';
   //  StringGrid1.Cells[0, 3] := 'Задание плавающее';
    // StringGrid1.Cells[0, 4] := 'Минимум';
    // StringGrid1.Cells[0, 5] := 'Максимум';
   //  StringGrid1.Cells[1, 0] := 'Параметр';
   //  StringGrid1.Cells[2, 0] := 'Исп. мех.';
end;

procedure TRegulEditF.ComboBox1Change(Sender: TObject);
begin
if ComboBox1.itemindex=0 then
  begin
  spinedit1.value:=1;
  spinedit2.value:=1;
  end else
  begin
  spinedit1.value:=-1;
   spinedit2.value:=-1;
  end;
end;

procedure TRegulEditF.SpinEdit1Change(Sender: TObject);
begin
if (spinedit1.value<0) or (spinedit3.value<0) then
  combobox2.itemindex:=1 else combobox2.itemindex:=0;
end;

procedure TRegulEditF.ComboBox2Change(Sender: TObject);
begin
  if combobox2.itemindex=1 then
    begin
     if spinedit1.value>-1 then spinedit1.value:=-1;
     if spinedit3.value>-1 then spinedit3.value:=-1;
    end else
    begin
      if spinedit1.value<0 then spinedit1.value:=1;
     if spinedit3.value<0 then spinedit3.value:=1;
    end;
end;

end.
