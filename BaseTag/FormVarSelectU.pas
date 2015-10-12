unit FormVarSelectU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MemStructsU, StdCtrls, ComCtrls, ImgList,ConstDef;

type
  TFormVarSelect = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ImageList1: TImageList;
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
  public
    function Exec(var str: String; trtit: TAnalogMems; typ: integer): boolean;
    { Public declarations }
  end;

var
  FormVarSelect: TFormVarSelect;

implementation

{$R *.dfm}



function TFormVarSelect.Exec(var str: String; trtit: TAnalogMems; typ: integer): boolean;
var i: integer;
begin
   result:=false;
   if trtit=nil then exit;
   for i:=0 to trtit.Count-1 do
     begin
       if trtit.Items[i].ID>-1 then
       begin
       case typ of
       REPORTTYPE_MIN:
         begin
            if trtit.Items[i].Logged then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := 0;
                end;
         end;

       REPORTTYPE_10MIN, REPORTTYPE_30MIN:
         begin
            if trtit.Items[i].Logged then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := 0;
                end;
              if trtit.Items[i].logTime in [REPORTTYPE_MIN] then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := trtit.Items[i].logTime;
                end;
         end;

       REPORTTYPE_HOUR:
         begin
            if trtit.Items[i].Logged then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := 0;
                end;
          if trtit.Items[i].logTime in [REPORTTYPE_MIN,REPORTTYPE_10MIN,REPORTTYPE_30MIN] then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := trtit.Items[i].logTime;
                end;
         end;

        REPORTTYPE_DAY:
         begin
            if trtit.Items[i].logTime in [REPORTTYPE_HOUR,REPORTTYPE_MIN,REPORTTYPE_10MIN,REPORTTYPE_30MIN] then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := trtit.Items[i].logTime;
                end;

         end;
         REPORTTYPE_DEC:
         begin
            if trtit.Items[i].logTime in [REPORTTYPE_HOUR,REPORTTYPE_DAY,REPORTTYPE_10MIN,REPORTTYPE_30MIN] then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := trtit.Items[i].logTime;
                end;

         end;

         REPORTTYPE_MONTH:
         begin
            if trtit.Items[i].logTime in [REPORTTYPE_DAY,REPORTTYPE_DEC] then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := trtit.Items[i].logTime;
                end;
         end;

         REPORTTYPE_QVART:
         begin
            if trtit.Items[i].logTime in [REPORTTYPE_DAY,REPORTTYPE_DEC,REPORTTYPE_MONTH] then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := trtit.Items[i].logTime;
                end;
         end;

         REPORTTYPE_YEAR:
         begin
            if trtit.Items[i].logTime in [REPORTTYPE_DAY,REPORTTYPE_DEC,REPORTTYPE_MONTH] then
              with ListView1.Items.Add do
                begin
                   caption := trtit.GetName(i);
                   ImageIndex := trtit.Items[i].logTime;
                end;
         end;


        end;
         end;

         
     end;
     if ShowModal=MrOk then
        begin
           str:=label2.Caption;
           result:=true;
        end else result:= false;
end;



procedure TFormVarSelect.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
label2.Caption:=Item.Caption;
end;

end.
