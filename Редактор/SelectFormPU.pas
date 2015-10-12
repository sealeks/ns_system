unit SelectFormPU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, ComCtrls, StdCtrls, CheckLst, ToolWin, ExtCtrls;

type
  TSelectFormP = class(TForm)
    PopupMenu2: TPopupMenu;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    ImageList5: TImageList;
    Panel15: TPanel;
    Panel16: TPanel;
    ToolBar6: TToolBar;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton12: TToolButton;
    ToolButton14: TToolButton;
    ToolButton21: TToolButton;
    CheckListBox1: TCheckListBox;
    OpenDialog1: TOpenDialog;
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectFormP: TSelectFormP;

implementation

uses  mainFormRedactorU;

{$R *.dfm}

procedure TSelectFormP.N24Click(Sender: TObject);
var i: integer;
begin
   for i:=0 to CheckListBox1.Items.Count-1 do
      if CheckListBox1.Selected[i] then
         activred.ShowWindD(tform(CheckListBox1.Items.Objects[i]))

end;

procedure TSelectFormP.N25Click(Sender: TObject);
var i: integer;
begin
   for i:=0 to CheckListBox1.Items.Count-1 do
       if CheckListBox1.Selected[i] then
           activred.HideWindD(tform(CheckListBox1.Items.Objects[i]))
end;

procedure TSelectFormP.N26Click(Sender: TObject);
 var i: integer;
 select: TObject;
begin
   for i:=0 to CheckListBox1.Items.Count-1 do
       if CheckListBox1.Selected[i] then
          begin
              select:=CheckListBox1.Items.Objects[i];
              activred.incformpos(tform(CheckListBox1.Items.Objects[i]));
          end;
   for i:=0 to CheckListBox1.Items.Count-1 do
       if CheckListBox1.Items.Objects[i]=select then
            CheckListBox1.Selected[i]:=true
end;

procedure TSelectFormP.N27Click(Sender: TObject);
var i: integer;
  select: TObject;
begin
   for i:=0 to CheckListBox1.Items.Count-1 do
      if CheckListBox1.Selected[i] then
        begin
           if CheckListBox1.Items.Objects[i]=nil then showmessage('');
           select:=CheckListBox1.Items.Objects[i];
           activred.decformpos(tform(CheckListBox1.Items.Objects[i]));
        end;
   for i:=0 to CheckListBox1.Items.Count-1 do
      if CheckListBox1.Items.Objects[i]=select then
        CheckListBox1.Selected[i]:=true
end;

procedure TSelectFormP.N30Click(Sender: TObject);
var i: integer;
begin
  activRed.OpenForm('');
  if activred.ComponentCount>0 then
  begin
 // toolbutton17.Enabled:=true;
 // toolbutton18.Enabled:=true;
  end;
  activred.PropertyForm;
  activred.UpdateCheckForm;
  activred.DisplayControl;
end;

procedure TSelectFormP.N31Click(Sender: TObject);
var i: integer;
    str: PChar;
begin
  if activred=nil then exit;
  if activred.ComponentCount=0 then exit;
  for i:=0 to CheckListBox1.Items.Count-1 do
     if CheckListBox1.Selected[i] then
        begin
          str:=pchar('Вы действительно собираетесь удалить форму из проекта  "'+tform(CheckListBox1.Items.Objects[i]).caption+'" ?');
          if MessageBox(0,str,'Удаление форм',MB_YESNO+MB_ICONQUESTION+MB_TOPMOST)=IDYES then
             begin
               activred.DelCompSc(tform(CheckListBox1.Items.Objects[i]));
               tform(CheckListBox1.Items.Objects[i]).Close;

               activred.RemoveComponent(tform(CheckListBox1.Items.Objects[i]));
               if activred.ComponentCount>0 then
                   activred.actWind:=(tform(CheckListBox1.Items.Objects[0]))
               else
                   activred.SaveAndCloseAllForm;
               CheckListBox1.Items.Objects[i].Free;
             end;
        end;
   activred.PropertyForm;
   activred.UpdateCheckForm;
   activred.DisplayControl;
end;

procedure TSelectFormP.N32Click(Sender: TObject);
begin
     activRed.CreateFormPr;
 //  toolbutton17.Enabled:=true;
  // toolbutton18.Enabled:=true;
   activred.PropertyForm;
   activred.UpdateCheckForm;
   activred.DisplayControl;
end;

procedure TSelectFormP.CheckListBox1Click(Sender: TObject);

 var i: integer;
tb: TToolButton;
begin
  if not (sender is TTreeNode) then exit;
  if (sender as TTreeNode).Data=nil then exit;
  if (TObject((sender as TTreeNode).Data) is TForm) then
    begin
      activred.ShowWindD((Tobject((sender as TTreeNode).Data) as TForm));
     (Tobject((sender as TTreeNode).Data) as TForm).BringToFront;
    end
  else
    activred.SelectComponent(TObject((sender as TTreeNode).Data) as TComponent)
end;


procedure TSelectFormP.CheckListBox1ClickCheck(Sender: TObject);
var i: integer;
begin
 for i:=0 to CheckListBox1.Items.Count-1 do
                      if CheckListBox1.Checked[i] then
                                 tform(CheckListBox1.Items.Objects[i]).Visible:=true else
                                 tform(CheckListBox1.Items.Objects[i]).Visible:=false;

end;

end.
