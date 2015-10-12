unit SetTag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,MemStructsU;

type
  TFormSetTag = class(TForm)
    CheckVal: TCheckBox;
    EditValCur: TEdit;
    Label1: TLabel;
    LabelTag: TLabel;
    EditValNew: TEdit;
    ButtVl: TButton;
    Label3: TLabel;
    CheckValDir: TCheckBox;
    CheckVLdir: TCheckBox;
    ButtVal: TButton;
    Label4: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckRefDir: TCheckBox;
    Button6: TButton;
    rcLab: TLabel;
    CheckCmd: TCheckBox;
    Label2: TLabel;
    EditVLNew: TEdit;
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckValClick(Sender: TObject);
    procedure CheckVLClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ButtValClick(Sender: TObject);
    procedure ButtVlClick(Sender: TObject);
  private
    ids: integer;
    frtItems : TAnalogMems;
    procedure UpdateData;
    procedure setData;
    { Private declarations }
  public
    constructor Create(val : TAnalogMems);
    procedure Execute(id: integer);
    { Public declarations }
  end;

var
  FormSetTag: TFormSetTag;

implementation

{$R *.dfm}

constructor TFormSetTag.Create(val : TAnalogMems);
begin
  frtItems:=val;
  inherited create(nil);
end;

procedure TFormSetTag.Execute(id: integer);
begin
  if frtItems=nil then exit;
  if id>=frtItems.Count then exit;
  if id<0 then exit;
  if frtItems.Items[id].ID<0 then exit;
  ids:=id;


  UpdateData;
  Show;
end;

procedure TFormSetTag.UpdateData;
begin
  LabelTag.Caption:=frtItems.GetName(ids);
  EditValCur.Text:=format('%8.3f',[frtItems.Items[ids].ValReal]);
  EditValNew.Text:=format('%8.3f',[frtItems.Items[ids].ValReal]);
 // EditVLCur.Text:=format('%d',[frtItems.Items[ids].ValidLevel]);
  EditVlNew.Text:=format('%d',[frtItems.Items[ids].ValidLevel]);
  rcLab.Caption:=format('%d',[frtItems.Items[ids].refcount]);
end;

procedure TFormSetTag.setData;
begin
  if (CheckCmd.Checked) then
   begin

        frtItems.AddCommand(ids,strtofloat(EditValNew.Text), true);
   end
  else
   begin
      if ({EditValNew.Text<>EditValCur.Text} true) then
        begin
          try
          if (CheckValDir.Checked) then
             frtItems.Items[ids].ValReal:=strtofloat(EditValNew.Text)
          else
             frtItems.SetVal(ids,strtofloat(EditValNew.Text),strtointdef(EditVlNew.Text,frtItems.Items[ids].ValidLevel));
          except
          end;

        end;

   end;

 {  if (CheckVl.Checked) then
   begin
      if (EditVlNew.Text<>EditVlCur.Text) then
        begin
          try
          if (CheckVlDir.Checked) then
             frtItems.Items[ids].ValidLevel:=strtointdef(EditVlNew.Text,frtItems.Items[ids].ValidLevel)
          else
             if not (strtointdef(EditVlNew.Text,frtItems.Items[ids].ValidLevel)>VALID_LEVEL) then
             frtItems.ValidOff(ids)
             else frtItems.SetVal(ids,frtItems.Items[ids].ValReal,strtointdef(EditVlNew.Text,frtItems.Items[ids].ValidLevel));
          except
          end;

        end;
   end;  }
   UpdateData;
end;

procedure TFormSetTag.Button4Click(Sender: TObject);
begin
  setData;
end;

procedure TFormSetTag.Button3Click(Sender: TObject);
begin
  if (CheckRefDir.Checked) then
        frtItems.Items[ids].refCount:=frtItems.Items[ids].refCount+1
  else
       frtItems.IncCounter(ids);
   UpdateData;
end;

procedure TFormSetTag.Button5Click(Sender: TObject);
begin
  if (CheckRefDir.Checked) then
        frtItems.Items[ids].refCount:=frtItems.Items[ids].refCount-1
  else
       frtItems.DecCounter(ids);
  UpdateData;
end;

procedure TFormSetTag.CheckValClick(Sender: TObject);
begin
  EditValNew.Enabled:=CheckVal.Checked;
   ButtVaL.Enabled:=CheckVal.Checked;
end;

procedure TFormSetTag.CheckVLClick(Sender: TObject);
begin
//  EditVlNew.Enabled:=CheckVl.Checked;
 // ButtVL.Enabled:=CheckVl.Checked;
end;

procedure TFormSetTag.Button6Click(Sender: TObject);
begin
Close;
end;

procedure TFormSetTag.ButtValClick(Sender: TObject);
begin
if not self.CheckVaL.Checked then exit;
if frtItems.Items[ids].ValReal=0 then
   frtItems.SetVal(ids,frtItems.Items[ids].maxEu,strtointdef(EditVlNew.Text,frtItems.Items[ids].ValidLevel)) else
   frtItems.SetVal(ids,0,strtointdef(EditVlNew.Text,frtItems.Items[ids].ValidLevel));
   UpdateData;
end;

procedure TFormSetTag.ButtVlClick(Sender: TObject);
begin
// if not self.CheckVL.Checked then exit;
 if frtItems.Items[ids].Validlevel=0 then
   frtItems.SetVal(ids,strtofloat(EditValNew.Text),100) else
   frtItems.Validoff(ids);
   UpdateData;
end;

end.
