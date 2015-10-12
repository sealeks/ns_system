unit AnalogpropGraphic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IMMIShape, IMMIValueEntryU, StdCtrls, IMMILabelFullU,
  Scope, IMMIScope,IMMIFormU, SYButton, AvPr, IMMIPanelU, Ruler;


type
  TAnalogGraphList = class(TList);


type
  TAnalogGraph = class(TIMMIForm)
    IMMIPanel8: TIMMIPanel;
    IMMIPanel9: TIMMIPanel;
    IMMIPanel2: TIMMIPanel;
    Shape1: TShape;
    IMMILabel1: TIMMILabelFull;
    Bevel1: TBevel;
    Label1: TLabel;
    IMMIShape1: TIMMIShape;
    AvPr1: TAvPr;
    ImmiScope1: TImmiScope;
    IMMIPanel11: TIMMIPanel;
    Label7: TLabel;
    IMMILabelFull2: TIMMILabelFull;
    IMMIPanel12: TIMMIPanel;
    Label8: TLabel;
    IMMILabelFull3: TIMMILabelFull;
    IMMIPanel13: TIMMIPanel;
    IMMILabelfull4: TIMMILabelFull;
    Label9: TLabel;
    IMMIPanel10: TIMMIPanel;
    Label6: TLabel;
    IMMILabelFull1: TIMMILabelFull;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    IMMIPanel7: TIMMIPanel;
    SYButton1: TSYButton;
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
    Label3: TLabel;
    IMMIValueEntry3: TIMMIValueEntry;
    IMMILabel4: TIMMILabelFull;
    IMMIPanel6: TIMMIPanel;
    IMMILabel5: TIMMILabelFull;
    IMMIValueEntry4: TIMMIValueEntry;
    Label2: TLabel;
    IMMIPanel14: TIMMIPanel;
    Label10: TLabel;
    Image5: TImage;
    Ruler1: TRuler;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure SYButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  //AnalogGraph: TAnalogGraph;
  AnalogGraphList: TAnalogGraphList;
  i: integer;
implementation

{$R *.dfm}

procedure TAnalogGraph.SYButton1Click(Sender: TObject);
begin

  if Immipanel1.Visible=false then Immipanel1.Visible:=true else Immipanel1.Visible:=false;
end;



procedure TAnalogGraph.FormCreate(Sender: TObject);
begin
  inherited;
show;
hide;
end;


procedure TAnalogGraph.FormClose(Sender: TObject;
  var Action: TCloseAction);
   var i: integer;
begin
  inherited;
   self.AutoSize:=true;
  if (AnalogGraphList=nil) or (AnalogGraphList.Count<2) then exit;
  i:=0;
  while i<AnalogGraphList.Count do
   begin
      if AnalogGraphList.Items[i]=self then
          begin
            AnalogGraphList.Delete(i);
            self.Free;
            exit;
         end else inc(i);
   end;

end;

procedure TAnalogGraph.FormShow(Sender: TObject);
begin
  inherited;
  self.AutoSize:=true;
end;

procedure TAnalogGraph.FormActivate(Sender: TObject);
begin
  inherited;
   self.AutoSize:=true;
end;

initialization
AnalogGraphList:=TAnalogGraphList.Create;
finalization
begin
{while AnalogGraphList.Count>0 do
begin
Tobject(AnalogGraphList.items[i]).Free;
AnalogGraphList.Delete(0);
end;}
AnalogGraphList.Free;
end;


end.
