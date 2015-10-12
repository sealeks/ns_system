unit IMMIAnalogPropU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IMMIFormU, StdCtrls, ExtCtrls, IMMIShape, Ruler,
  IMMILabelU, IMMILabelFullU, IMMIValueEntryU, IMMIImg1, Buttons, Scope,
  IMMIScope, AvPr, SYButton, IMMIPanelU;

type
  TIMMIAnalogProp = class(TIMMIForm)
    IMMIPanel8: TIMMIPanel;
    IMMIPanel7: TIMMIPanel;
    Bevel1: TBevel;
    LName: TLabel;
    LComment: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    IMMILabel1: TIMMILabelFull;
    IMMIShape1: TIMMIShape;
    Ruler1: TRuler;
    AvPr1: TAvPr;
    IMMIPanel2: TIMMIPanel;
    SYButton2: TSYButton;
    IMMIPanel9: TIMMIPanel;
    IMMIPanel11: TIMMIPanel;
    Label7: TLabel;
    IMMILabelFull2: TIMMILabelFull;
    Image3: TImage;
    IMMIPanel12: TIMMIPanel;
    Label8: TLabel;
    IMMILabelFull3: TIMMILabelFull;
    Image2: TImage;
    IMMIPanel13: TIMMIPanel;
    IMMILabelfull4: TIMMILabelFull;
    Label9: TLabel;
    Image1: TImage;
    IMMIPanel10: TIMMIPanel;
    Label6: TLabel;
    IMMILabelFull1: TIMMILabelFull;
    Image4: TImage;
    IMMIPanel1: TIMMIPanel;
    IMMIPanel3: TIMMIPanel;
    Label5: TLabel;
    IMMIValueEntry1: TIMMIValueEntry;
    IMMILabel2: TIMMILabelFull;
    IMMIPanel4: TIMMIPanel;
    Label4: TLabel;
    IMMIValueEntry2: TIMMIValueEntry;
    IMMILabel3: TIMMILabelFull;
    IMMIPanel5: TIMMIPanel;
    Label10: TLabel;
    IMMIValueEntry3: TIMMIValueEntry;
    IMMILabel4: TIMMILabelFull;
    IMMIPanel6: TIMMIPanel;
    IMMILabel5: TIMMILabelFull;
    IMMIValueEntry4: TIMMIValueEntry;
    Label11: TLabel;
    IMMIPanel14: TIMMIPanel;
    Label12: TLabel;

    procedure show;
    procedure FormCreate(Sender: TObject);
    procedure SYButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IMMIAnalogProp: TIMMIAnalogProp;

implementation

{$R *.DFM}

procedure TIMMIAnalogProp.FormCreate(Sender: TObject);
begin
  inherited;
  width := 228;
  height := 170;
end;

procedure TIMMIAnalogProp.show;
begin
   if IMMILabel2.iExprVal = '' then
  begin
   IMMIPanel6.Visible:=false;
   IMMIPanel13.Visible:=false;
  end
   else
  begin
   IMMIPanel6.Visible:=true;
   IMMIPanel13.Visible:=true;
  end;

    if IMMILabel5.iExprVal = '' then
     begin
   IMMIPanel3.Visible:=false;
   IMMIPanel10.Visible:=false;
  end
   else
  begin
   IMMIPanel3.Visible:=true;
   IMMIPanel10.Visible:=true;
  end;




  if IMMILabel4.iExprVal = '' then
    begin
   IMMIPanel5.Visible:=false;
   IMMIPanel12.Visible:=false;
  end
   else
  begin
   IMMIPanel5.Visible:=true;
   IMMIPanel12.Visible:=true;
  end;

 if IMMILabel3.iExprVal = '' then
    begin
   IMMIPanel4.Visible:=false;
   IMMIPanel11.Visible:=false;
  end
   else
  begin
   IMMIPanel4.Visible:=true;
   IMMIPanel11.Visible:=true;
  end;
  inherited;
    Immipanel1.Visible:=false;
end;

procedure TIMMIAnalogProp.SYButton1Click(Sender: TObject);
begin
  inherited;
   if Immipanel1.Visible=false then Immipanel1.Visible:=true else Immipanel1.Visible:=false;
end;

end.
