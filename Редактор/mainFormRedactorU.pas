unit mainFormRedactorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,FormComponentU,FormExprQueekU,
  Dialogs, Buttons, ComCtrls, redactor, Menus, StdCtrls, Grids, ExtCtrls, ExtDlgs,
  ImgList, ToolWin,IMMIFormx,Constdef, SYButton, ftopMenuU,globalValue,SelectFormPU,
  AxCtrls, OleCtrls, VCF1, mdCONTROLS, FileCtrl, ValEdit, ObjInsp1, ConfigurationSRedactor,
  CheckLst, EditExpr, ColorStringGrid, Mask, Ex_Grid, Ex_Inspector, Registry, IniFiles, ConfigurationSys,
  AppEvnts;



type
  TmainFormRedactor = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    Memo2: TMemo;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N13: TMenuItem;
    N8: TMenuItem;
    Ghfdrf1: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N28: TMenuItem;
    ImageList1: TImageList;
    ImageList2: TImageList;
    N29: TMenuItem;
    ImageList3: TImageList;
    ImageList4: TImageList;
    OpenDialog1: TOpenDialog;
    N3: TMenuItem;
    PopupMenu1: TPopupMenu;
    rrrrr1: TMenuItem;
    rrrrrrrrrr1: TMenuItem;
    rrrrrrrrr1: TMenuItem;
    ImageList5: TImageList;
    PopupMenu2: TPopupMenu;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    ImageList6: TImageList;
    ImageList7: TImageList;
    ImageList8: TImageList;
    N20: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    Panel8: TPanel;
    Panel3: TPanel;
    ToolBar3: TToolBar;
    ToolButton3: TToolButton;
    Panel4: TPanel;
    N39: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure hull(Sender: TObject);
    procedure NfixClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure ValueListEditor1SelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure N8Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowCreate(var Msg: TMessage); message WM_IMMIITEMCREATED;
    procedure ToolButton18Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure Ghfdrf1Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure ClassTreeClick(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure initilize;
    procedure deinitilize;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N3gClick(Sender: TObject);
    procedure SelectLast(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure N35Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N36Click(Sender: TObject);
    procedure ToolButton24Click(Sender: TObject);
    procedure ToolButton25Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure crhb1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure InitFormProp;
    procedure WriteFormProp;
    procedure FormActivate(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
  private
    { Private declarations }
  public
    curpr: integer;
    actPr: integer;
    classL: Tlist;
    nullbuttonList: TList;
    buttonList: TList;
    toolList: TList;
    directbm: TBitmap;
    noicon: TBitmap;
    il,ilg: TImageList;
    ti: Timage;
    ProjectName: String;
    Applist: TStringList;
    appnamelist: TStringList;
    ai: string;
    // блок сохранения настроек
     mainform_left: word;
     mainform_top: word;
     mainform_width: word;
     mainform_height: word;
     objectform_left: word;
     objectform_top: word;
     objectform_width: word;
     objectform_height: word;
     objectform_visible: boolean;
     veiwform_left: word;
     veiwform_top: word;
     veiwform_width: word;
     veiwform_height: word;
     veiwform_visible: boolean;
     exprform_left: word;
     exprform_top: word;
     exprform_width: word;
     exprform_height: word;
     exprform_visible: boolean;
     scrform_left: word;
     scrform_top: word;
     scrform_width: word;
     scrform_height: word;
     scrform_visible: boolean;
    { Public declarations }
  end;

var
  mainFormRedactor: TmainFormRedactor;
  ttt: TControl;
  activForm: TForm;
  activRed: TRedactor;
  actived: boolean;
  actbutt: Ttoolbutton;
  cc: string;
  status: boolean = true;
  k: integer;

implementation

{$R *.dfm}
{$R hend.res}


procedure TmainFormRedactor.SpeedButton2Click(Sender: TObject);
begin
   activRed.CreateFormPr;
   activred.PropertyForm;
   activred.UpdateCheckForm;
   activred.DisplayControl;
end;

procedure TmainFormRedactor.SpeedButton1Click(Sender: TObject);
var I,j: integer;
begin
if ((Sender is TToolButton) and (activred<>nil) and ((Sender as TToolButton).tag<classL.Count) and ((Sender as TToolButton).tag>-1)) then
  begin
      actbutt:=Sender as TToolButton;
      ActivRed.StartCreate(classL.items[(sender as tComponent).Tag]);
      if sCreateObj in activRed.sSistem then
          begin
            for i:=0 to self.componentCount-1 do
                if self.components[i] is TToolButton then (self.components[i] as TToolButton).Down:=false;
               (sender as TToolButton).Down:=true;
           end
      else
          begin
            for i:=0 to nullbuttonList.Count-1 do
              TToolbutton(nullbuttonList.Items[i]).Down:=true;
            for i:=0 to buttonList.Count-1 do
              TToolbutton(buttonList.Items[i]).Down:=false;
          end
  end
else
    begin
            for i:=0 to nullbuttonList.Count-1 do
              TToolbutton(nullbuttonList.Items[i]).Down:=true;
            for i:=0 to buttonList.Count-1 do
              TToolbutton(buttonList.Items[i]).Down:=false;
    end


end;


procedure TmainFormRedactor.hull(Sender: TObject);
begin
if (Sender is TForm) then

begin
ttt:=(Sender as TForm);
end;
end;


procedure TmainFormRedactor.NfixClick(Sender: TObject);
begin
  activRed.FixedElement;
end;

procedure TmainFormRedactor.N5Click(Sender: TObject);
begin
  if  (not (rForm in activRed.ReadctorStatus) or
       not (rProject in activRed.ReadctorStatus)) then
              N7.Enabled:=true  else   N7.Enabled:=false;
  ActivRed.SaveProject;
end;

procedure TmainFormRedactor.N6Click(Sender: TObject);
var Action: TCloseAction;
begin
  FormClose(nil,Action);
  exit;
end;

procedure TmainFormRedactor.N7Click(Sender: TObject);
var Action: TCloseAction;
begin
 WriteFormProp;
 ProjectName:='';
 try

  activRed.SaveAndCloseAllForm;
  activRed.PropertyForm;
  ActivRed.UpdateCheckForm;
  activred.DisplayControl;
  if activRed.RedactorForm.Count<1 then
      N2.Enabled:=false;

 except
 end;
 SelectFormP.toolbutton12.Enabled:=false;
 SelectFormP.toolbutton14.Enabled:=false;
 SelectFormP.toolbutton21.Enabled:=false;
 n29.Enabled:=false;
 n20.Enabled:=false;
 //n12.Enabled:=false;
 //ggggg1.Enabled:=false;
// crhb1.Enabled:=false;
 fTopMenu.Height:=0;
 activred.DeletefromTree;
 actPr:=-1;
  InitFormProp;
end;

procedure TmainFormRedactor.N4Click(Sender: TObject);
begin
  activRed.SaveFormAs;
end;

procedure TmainFormRedactor.ValueListEditor1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
 CanSelect:=false;
end;

procedure TmainFormRedactor.N8Click(Sender: TObject);
begin
  activRed.OpenForm('');
  activred.PropertyForm;
  activred.UpdateCheckForm;
  activred.DisplayControl;
end;

procedure TmainFormRedactor.N11Click(Sender: TObject);
begin
  activRed.showForm;
  activRed.PropertyForm;
end;

procedure TmainFormRedactor.N12Click(Sender: TObject);
begin
  ActivRed.StartCompile;
  Show;
end;

procedure TmainFormRedactor.N1Click(Sender: TObject);
begin
  if (rForm in activRed.ReadctorStatus) then  N13.Enabled:=true
  else   N13.Enabled:=false;
  if (rForm in activRed.ReadctorStatus) then  N4.Enabled:=true
  else   N4.Enabled:=false;
  if (rProject in activRed.ReadctorStatus) then
    begin
      N5.Enabled:=true;
      N13.Enabled:=false;
      N4.Enabled:=false;
    end
  else
    N5.Enabled:=false;
  if  ((rForm in activRed.ReadctorStatus) or
       (rProject in activRed.ReadctorStatus)) then
               N7.Enabled:=true  else   N7.Enabled:=false;
  n3gclick(nil);
end;

procedure TmainFormRedactor.N13Click(Sender: TObject);
begin
ActivRed.CloseForm;
ActivRed.PropertyForm;
activred.DisplayControl;
end;

procedure TmainFormRedactor.N10Click(Sender: TObject);
begin
   if (rForm in activRed.ReadctorStatus) then N11.Enabled:=true
   else N11.Enabled:=false;
end;

procedure TmainFormRedactor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteFormProp;
  ProjectName:='';
  ActivRed.SaveAndCloseAllForm;
  if (ActivRed.ComponentCount>0) then abort;
  classL.Free;
  self.deinitilize;
  Application.Terminate;
end;

procedure TmainFormRedactor.ShowCreate(var Msg: TMessage);
var i: integer;
begin
  if (ActivRed<>nil) then
    begin
     actbutt.Down:=false;
     for i:=0 to nullbuttonList.Count-1 do
          TToolbutton(nullbuttonList.Items[i]).Down:=true;
    end;
end;

procedure TmainFormRedactor.ToolButton18Click(Sender: TObject);
var i: integer;
begin
 ActivRed.StartCreate(classL.items[(sender as tComponent).Tag]);
 actbutt.Down:=false;
 for i:=0 to nullbuttonList.Count-1 do
          TToolbutton(nullbuttonList.Items[i]).Down:=true;

end;

procedure TmainFormRedactor.N16Click(Sender: TObject);
begin
  ActivRed.SelectAll;
end;

procedure TmainFormRedactor.Ghfdrf1Click(Sender: TObject);
begin
  N14.Enabled:=false;
  N15.Enabled:=false;
  N16.Enabled:=false;
  N17.Enabled:=false;
  N18.Enabled:=false;
  if  ActivRed.copytrue then N17.Enabled:=true;
  if  ActivRed.NumSelected>0 then
   begin
     N14.Enabled:=true;
     N15.Enabled:=true;
     N18.Enabled:=true;
   end;
  if ActivRed.RedactorForm.Count>0 then N16.Enabled:=true;
end;

procedure TmainFormRedactor.N14Click(Sender: TObject);
begin
  ActivRed.COPYCOM(nil);
end;

procedure TmainFormRedactor.N15Click(Sender: TObject);
begin
  ActivRed.CUTCOM(nil);
end;

procedure TmainFormRedactor.N17Click(Sender: TObject);
begin
  ActivRed.PASTCOM(nil);
end;

procedure TmainFormRedactor.N18Click(Sender: TObject);
begin
  ActivRed.FIXED(nil);
end;

procedure TmainFormRedactor.N21Click(Sender: TObject);
begin
  WinExec(Pchar(activred.DirProject+'\exe\DicEdit.exe'),SW_RESTORE)
end;

procedure TmainFormRedactor.N22Click(Sender: TObject);
begin
 if FormComponent<>nil then N23.Checked:= (FormComponent.Visible) and (FormComponent.Showing);
 if FormExprQueek<>nil then  N37.Checked:= (FormExprQueek.Visible) and (FormExprQueek.Showing);
 if SelectFormP<>nil then  N38.Checked:= (SelectFormP.Visible) and (SelectFormP.Showing);
 if activred<>nil then
   begin
     n39.Visible:=activred.ScriptValid;
     n39.Enabled:=activred.ScriptActiv;
   end;
end;

procedure TmainFormRedactor.N20Click(Sender: TObject);
begin
  activred.UnFIXED(activred.actWind);
end;

procedure TmainFormRedactor.N28Click(Sender: TObject);
begin
 activRed.EditPackage(PackageIni);
end;

procedure TmainFormRedactor.initilize;
var i,j,k: integer;
hh: TXPTabSheet;
uu: TXPToolBar;
bb: TToolButton;
bitm: TBitmap;
bitm1: TBitmap;
menit: TMenuItem;
begin

 ti:=Timage.Create(nil);
 ti.Stretch:=true;
 ilg:=TImageList.Create(self);
 ilg:=TImageList.CreateSize(16,16);
 k:=0;
 classL:=Tlist.Create;
 nullbuttonList:=TList.Create;
 buttonList:=TList.Create;
 toolList:=TList.Create;
 directbm:=TBitmap.Create;
 directbm.LoadFromResourceName(HInstance,'DIRECT');
 Application.Tag:=1000;
 actived:=false;
 activRed:=TRedactor.Create(self,FormComponent.ObjInsp11);
 FormComponent.ComboBox1.Text:='';
 FormComponent.Edit1.Text:='';
 activRed.ComboBox:=FormComponent.ComboBox1;
 activRed.editO:=FormComponent.Edit1;
 activRed.gridf:=FormExprQueek.StringGrid1;
 activred.CheckBoxForm:=SelectFormP.CheckListBox1;
 n39.Visible:=activred.ScriptValid;
 n39.Enabled:=activred.ScriptActiv;
 if  fileexists(FormsDir+'GlobalPicture.bmp') then
 activRed.ProjectBitmap.LoadFromFile(FormsDir+'GlobalPicture.bmp');
 PopupMenu1.Items.Clear;
  for i:=0 to activRed.ClassTree.Count-1 do
  begin
    uu:=TXPToolBar.Create(Panel4);
    uu.Constraints.Maxheight:=38;
    uu.parent:=Panel4;
    uu.Align:=altop;
    uu.AutoSize:=true;
    toolList.Add(uu);
    il:=TImageList.Create(self);
    il.Height:=24;
    il.width:=24;
    il.ImageType:=itMask;
    menit:=TMenuItem.Create(self);
    menit.Caption:=activRed.ClassTree.Strings[i];
    menit.OnClick:=ClassTreeClick;
    PopupMenu1.Items.Add(menit);
    menit.Tag:=i;
       for j:=0 to TStringlist(activRed.ClassTree.Objects[i]).count-1 do
         begin
           bb:=TToolButton.Create(self);
           bb.Parent:=uu;
           bb.Style:=tbsCheck	;
           uu.ButtonHeight:=26;
           uu.ButtonWidth:=26;
           bitm:= TUnitClass(TStringlist(TStringlist(activRed.ClassTree.Objects[i]).Objects[j])).TPBitmap;
           bitm.Height:=24;
           bitm.width:=24;
           uu.Transparent:=true;
           bitm1:=TBitmap.Create;
           bitm1.Assign(bitm);
           ilg.Overlay(k,0);
           ilg.ShareImages:=false;
           il.Add(bitm,nil);
           ilg.Add(bitm1,nil);
           uu.Images:=il;
           bb.OnClick:=self.SpeedButton1Click;
           bb.ImageIndex:=j;
           cc:=TUnitClass(TStringlist(TStringlist(activRed.ClassTree.Objects[i]).Objects[j])).TPClass.ClassName;
           bb.ParentShowHint:=false;
           classL.Add(TUnitClass(TStringlist(TStringlist(activRed.ClassTree.Objects[i]).Objects[j])).TPClass);
           bb.Tag:=classL.Count-1;
           bb.ShowHint:=true;
           bb.Hint:= TUnitClass(TStringlist(TStringlist(activRed.ClassTree.Objects[i]).Objects[j])).TPClass.ClassName;
           bb.Parent:=uu;
           buttonList.Add(bb);
           inc(k);
         end;
         bb:=TToolButton.Create(self);
         bb.Style:=tbsCheck			;
         il.Add(directbm,nil);
         bb.Parent:=uu;
         bb.ImageIndex:=TStringlist(activRed.ClassTree.Objects[i]).count;
         bb.Down:=true;
         bb.Tag:=-1;
         bb.OnClick:=self.SpeedButton1Click;
         nullbuttonList.Add(bb);
         if  PopupMenu1.Items.Command>0 then
            ClassTreeClick(PopupMenu1.Items[0]);

  end;
  FormComponent.setvalid;
end;

procedure TmainFormRedactor.deinitilize;
var i: integer;
begin
  while panel4.ControlCount>0 do
   panel4.RemoveControl(panel4.Controls[0]);
  ti.Free;
  ilg.Free;
  activred.BeforeDestruction;
  buttonList.free;
  toolList.free;
end;

procedure TmainFormRedactor.FormCreate(Sender: TObject);
begin
 curpr:=-1;
 actPr:=-1;
 ftopmenu.FormStyle:=fsStayOnTop;
 ProjectName:='';
 SelectFormP:=TSelectFormP.Create(self);

 FormComponent:=TFormComponent.Create(self);

 FormExprQueek:=TFormExprQueek.Create(self);

 //initilize;
 //FormComponent.UpdateObjPaint;
 Applist:=TStringList.Create;
 AppNameList:=TStringList.Create;
 n29.Enabled:=false;
 n20.Enabled:=false;;
 //InitFormProp;
 // Show;
end;

procedure TmainFormRedactor.Button1Click(Sender: TObject);
begin
 
 deinitilize;
end;

procedure TmainFormRedactor.Button2Click(Sender: TObject);
begin
 initilize;
 
end;

procedure TmainFormRedactor.SelectLast(Sender: TObject);
  var fl: boolean;
    strpro: TstringList;
    str: Widestring;
    i: integer;
begin
self.Hide;
SelectFormP.Hide;
FormExprQueek.Hide;
FormComponent.Hide;
//if sender is TMenuItem then
  begin
 // str:=trimRight(trimLeft(appList.Strings[(sender as TMenuItem).tag]));
  fl:=true;
  strpro:=TstringList.Create;
 // if ((rForm in Activred.ReadctorStatus) or (rProject in Activred.ReadctorStatus)) then
 // fl:=Activred.SaveAndCloseAllForm;
  if fl then
   begin
 //  if fileexists(trim(str)) then
     begin
     // ProjectName:=(sender as TMenuItem).Caption;
    //  deinitilize;
      InitialSys;
      ai:='';
      initilize;
      activRed.OpenProject(trim(Uppercase(str)));
      if activred<>nil then
        for i:=0 to activred.RedactorForm.Count-1 do
         if  tobject(activred.RedactorForm.Items[i]) is TForm then
          begin
            if  trim(tform(activred.RedactorForm.Items[i]).Name)=trim(ai) then
            activred.ShowWindD(tform(activred.RedactorForm.Items[i]));
          end;


     // actPr:=(sender as TMenuItem).tag;
      fTopMenu.Height:=20;
      ftopmenu.MainMenu1.Items[0].Enabled:=false;
      ftopmenu.MainMenu1.Items[1].Enabled:=false;
      ftopmenu.MainMenu1.Items[2].Enabled:=false;
      ftopmenu.MainMenu1.Items[3].Enabled:=false;
      ftopmenu.MainMenu1.Items[4].Enabled:=false;
      ftopmenu.MainMenu1.Items[5].Enabled:=false;
      SelectformP.ToolButton12.Enabled:=true;
      SelectformP.ToolButton14.Enabled:=true;
      SelectformP.ToolButton21.Enabled:=true;
      n29.Enabled:=true;
      n20.Enabled:=true;
      N2.Enabled:=true;
     end;
    end;
   end;
   strpro.Free;
  InitFormProp;
  self.Show;
end;

procedure TmainFormRedactor.N3gClick(Sender: TObject);
var lastprList: TstringList;
    i: integer;
    ite: TMenuItem;
    Registry : TRegistry;

    itemsAp: TMenuItem;
begin
 Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey('SOFTWARE\IMMI', True);
    n3.Clear;
    Registry.OpenKey('APP LIST', True);
    AppList.Clear;
    AppNameList.Clear;
    Registry.GetValueNames(AppList);
    for i := AppList.Count - 1 downto 0 do
      if not FileExists(AppList.strings[i]) then AppList.Delete(i);
    for i := 0 to AppList.Count - 1 do
      begin
        AppNameList.Add(Registry.ReadString(appList.strings[i]));
        itemsAp:=TMenuItem.Create(n3);
        itemsAp.Caption:=Registry.ReadString(appList.strings[i]);
        itemsAp.Tag:=i;
        itemsAp.OnClick:=SelectLast;
        n3.Add(itemsAp);
      end;
  finally
    Registry.Free;
  end;
 // if curpr>0 then
   begin
    N9.Caption:=GetCurrentApp;//appNamelist.strings[curpr];
    n9.OnClick:=SelectLast;
    n9.Tag:=curpr;
    n9.Enabled:=true;
   end
   { else
   begin
    N9.Caption:='Пусто';
    n9.OnClick:=nil;
    n9.Tag:=-1;
    n9.Enabled:=false;
   end;     }
end;

procedure TmainFormRedactor.N23Click(Sender: TObject);
begin
activred.ConvActForm;
end;

procedure TmainFormRedactor.ClassTreeClick(Sender: TObject);
var i: integer;
begin
if sender=nil then exit;
if not (sender is TMenuItem) then exit;
ToolButton3.Caption:=(Sender as TMenuItem).Caption;
for i:=0 to toollist.Count-1 do
if (sender as TComponent).Tag=i then
                    TToolBar(toollist.items[i]).Visible:=true else
                        TToolBar(toollist.items[i]).Visible:=false;
ToolButton3.AutoSize:=true;
panel3.Width:=2+ToolButton3.Width;
end;





procedure TmainFormRedactor.ToolButton7Click(Sender: TObject);
begin
   Panel8.Visible:= not Panel8.Visible;
end;

procedure TmainFormRedactor.ToolButton12Click(Sender: TObject);
begin
if (SelectformP.Visible) and (SelectformP.Showing) then SelectformP.Hide else

begin
 SelectformP.FormStyle:=fsStayOntop;
 SelectformP.Show;
end;
end;

procedure TmainFormRedactor.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin

activred.ReplaceExpr;
activred.PropertyForm;


end;



procedure TmainFormRedactor.N35Click(Sender: TObject);
begin
activred.FindInExpr;
end;

procedure TmainFormRedactor.N33Click(Sender: TObject);
begin
if Activred=nil then
  begin
   N34.Enabled:=false;
   N35.Enabled:=false;
   N36.Enabled:=false;
   Exit;
  end;

N34.Enabled:=(activred.NumSelected<>0);
N35.Enabled:=(activred.ComponentCount<>0);
N36.Enabled:=(activred.ComponentCount<>0);
end;

procedure TmainFormRedactor.N36Click(Sender: TObject);
begin
 activred.FindInExprErr;
end;

procedure TmainFormRedactor.ToolButton24Click(Sender: TObject);
begin
if (FormComponent.Visible) and (FormComponent.Showing) then FormComponent.Hide else
 begin

  FormComponent.FormStyle:=fsStayonTop;
  FormComponent.Show;
 end;
end;

procedure TmainFormRedactor.ToolButton25Click(Sender: TObject);
begin
 if (FormexprQueek.Visible) and (FormexprQueek.Showing) then FormexprQueek.Hide else
 begin

  FormexprQueek.FormStyle:=fsStayonTop;
  FormexprQueek.Show;
 end;
end;


procedure TmainFormRedactor.N34Click(Sender: TObject);
begin
 activred.PopMenuShowTegs(nil);
end;

procedure TmainFormRedactor.crhb1Click(Sender: TObject);
begin
 Activred.StartScriptRedac;
end;

procedure TmainFormRedactor.FormDestroy(Sender: TObject);
begin
Applist.free;
AppNameList.free;
end;

procedure TmainFormRedactor.InitFormProp;
var Reg : TRegistry;
    prNamR: string;

begin
     try
     mainform_left:=10;
     mainform_top:=20;
     mainform_width:=830;
     mainform_height:=88;
     objectform_left:=10;
     objectform_top:=355;
     objectform_width:=280;
     objectform_height:=425;
     objectform_visible:=true;
     veiwform_left:=10;
     veiwform_top:=107;
     veiwform_width:=280;
     veiwform_height:=240;
     veiwform_visible:=true;
     exprform_left:=10;
     exprform_top:=790;
     exprform_width:=280;
     exprform_height:=160;
     exprform_visible:=false;
     scrform_left:=450;
     scrform_top:=350;
     scrform_width:=500;
     scrform_height:=500;
     scrform_visible:=false;
     reg := TRegistry.Create;
    try
    with reg do
    begin
       prNamR:=ProjectName;
       if trim(prNamR)='' then prNamR:='nillPr';
       Reg.RootKey := HKEY_LOCAL_MACHINE;
       Reg.OpenKey('SOFTWARE\IMMISOFT', true);
       Reg.OpenKey(prNamR, True);
       mainform_left:=ReadInteger('mainform_left');
       mainform_top:=ReadInteger('mainform_top');
       mainform_width:=ReadInteger('mainform_width');;
       mainform_height:=ReadInteger('mainform_height');;
       objectform_left:=ReadInteger('objectform_left');;
       objectform_top:=ReadInteger('objectform_top');;
       objectform_width:=ReadInteger('objectform_width');;
       objectform_height:=ReadInteger('objectform_height');;
       objectform_visible:=ReadBool('objectform_visible');
       veiwform_left:=ReadInteger('veiwform_left');;
       veiwform_top:=ReadInteger('veiwform_top');;
       veiwform_width:=ReadInteger('veiwform_width');;
       veiwform_height:=ReadInteger('veiwform_height');;
       veiwform_visible:=ReadBool('veiwform_visible');;
       exprform_left:=ReadInteger('exprform_left');;
       exprform_top:=ReadInteger('exprform_top');;
       exprform_width:=ReadInteger('exprform_width');;
       exprform_height:=ReadInteger('exprform_height');;
       exprform_visible:=ReadBool('exprform_visible');;
       {scrform_left:=ReadInteger('exprform_height');
       scrform_top:=ReadInteger('scrform_top');
       scrform_width:=ReadInteger('scrform_width');
       scrform_height:=ReadInteger('scrform_height');
       scrform_visible:=ReadBool('scrform_visible');}
       ai:=readstring('activform');
   end;
  finally
    reg.Free;
  end;
     if screen.Width>mainform_width then self.Width:=mainform_width else self.Width:=screen.Width-40;
     if screen.Height>mainform_Height then self.Height:=mainform_Height else self.Height:=screen.Height-40;
     if (mainform_left>-1) and (mainform_left<(screen.Width-mainform_width)) then self.Left:=mainform_left
     else self.Left:=10;
     if (mainform_top>-1) and (mainform_top<(screen.Height-mainform_height)) then self.Top:=mainform_top
     else self.Top:=20;

     if screen.Width>objectform_width then FormComponent.Width:=objectform_width else FormComponent.Width:=screen.Width-40;
     if screen.Height>objectform_Height then FormComponent.Height:=objectform_Height else FormComponent.Height:=screen.Height-40;
     if (objectform_left>-1) and (objectform_left<(screen.Width-objectform_width)) then FormComponent.Left:=objectform_left
     else FormComponent.Left:=10;
     if (objectform_top>-1) and (objectform_top<(screen.Height-objectform_height)) then FormComponent.Top:=objectform_top
     else FormComponent.Top:=355;
     FormComponent.Visible:=objectform_visible;

     if screen.Width>veiwform_width then SelectFormP.Width:=veiwform_width else SelectFormP.Width:=screen.Width-40;
     if screen.Height>veiwform_Height then SelectFormP.Height:=veiwform_Height else SelectFormP.Height:=screen.Height-40;
     if (veiwform_left>-1) and (veiwform_left<(screen.Width-veiwform_width)) then SelectFormP.Left:=veiwform_left
     else SelectFormP.Left:=10;
     if (veiwform_top>-1) and (veiwform_top<(screen.Height-veiwform_height)) then SelectFormP.Top:=veiwform_top
     else SelectFormP.Top:=107;
     SelectFormP.Visible:=veiwform_visible;

     if screen.Width>exprform_width then FormExprQueek.Width:=exprform_width else FormExprQueek.Width:=screen.Width-40;
     if screen.Height>exprform_Height then FormExprQueek.Height:=exprform_Height else FormExprQueek.Height:=screen.Height-40;
     if (exprform_left>-1) and (exprform_left<(screen.Width-exprform_width)) then FormExprQueek.Left:=exprform_left
     else FormExprQueek.Left:=10;
     if (exprform_top>-1) and (exprform_top<(screen.Height-exprform_height)) then FormExprQueek.Top:=exprform_top
     else FormExprQueek.Top:=790;
     if screen.Height<801 then FormExprQueek.top:=700;
     FormExprQueek.Visible:=exprform_visible;


     if FormExprQueek.Visible then  FormExprQueek.Show else FormExprQueek.Hide;
     if  SelectFormP.Visible then   SelectFormP.Show else  SelectFormP.Hide;
     if FormComponent.Visible then  FormComponent.Show else FormComponent.Hide;
     except
     end;
end;

procedure TmainFormRedactor.WriteFormProp;
var Reg : TRegistry;
    prNamR: string;
    l,t,w,h: integer;
    vi: boolean;
begin
     reg := TRegistry.Create;
      prNamR:=ProjectComment;
       if trim(prNamR)='' then prNamR:='nillPr';
    try
    with reg do
    begin
       prNamR:=ProjectName;
       if trim(prNamR)='' then prNamR:='nillPr';
       Reg.RootKey := HKEY_LOCAL_MACHINE;
       Reg.OpenKey('SOFTWARE\IMMISOFT', True);
       Reg.OpenKey(prNamR, True);
       WriteInteger('mainform_left',self.Left);
       WriteInteger('mainform_top',self.top);
       WriteInteger('mainform_width',self.Width);
       WriteInteger('mainform_height',self.Height);
       WriteInteger('objectform_left',FormComponent.Left);
       WriteInteger('objectform_top',FormComponent.top);
       WriteInteger('objectform_width',FormComponent.Width);
       WriteInteger('objectform_height',FormComponent.Height);
       WriteBool('objectform_visible',FormComponent.Visible);
       WriteInteger('veiwform_left',SelectFormP.Left);
       WriteInteger('veiwform_top',SelectFormP.top);
       WriteInteger('veiwform_width',SelectFormP.Width);
       WriteInteger('veiwform_height',SelectFormP.Height);
       WriteBool('veiwform_visible',SelectFormP.Visible);
       WriteInteger('exprform_left',FormExprQueek.Left);
       WriteInteger('exprform_top',FormExprQueek.top);
       WriteInteger('exprform_width',FormExprQueek.Width);
       WriteInteger('exprform_height',FormExprQueek.Height);
       WriteBool('exprform_visible',FormExprQueek.Visible);
       if activred<>nil then
       begin
      // activred.GetFormscr(vi,l,t,w,h);
      // WriteInteger('exprform_left',L);
      // WriteInteger('exprform_top',t);
      // WriteInteger('exprform_width',W);
      // WriteInteger('exprform_height',H);
       WriteBool('exprform_visible',Vi);
       end;
       try
        if (activred<>nil) and (activred.actWind<>nil) then
         Writestring('activform',activred.actWind.Name);
       except
       end;  
   end;
  finally
    FreeAndNil(reg);
  end;
end;

procedure TmainFormRedactor.FormActivate(Sender: TObject);
begin
Sender:=Sender;
end;

procedure TmainFormRedactor.ApplicationEvents1Activate(Sender: TObject);
begin
if (SelectformP.Visible) and (SelectformP.Showing) then
 begin
  SelectformP.FormStyle:=fsStayonTop;
  SelectformP.Show;
 end;
if (FormexprQueek.Visible) and (FormexprQueek.Showing) then
 begin
  FormexprQueek.FormStyle:=fsStayonTop;
  FormexprQueek.Show;
 end;
if (FormComponent.Visible) and (FormComponent.Showing) then
 begin
  FormComponent.FormStyle:=fsStayonTop;
  FormComponent.Show;
 end;
FormStyle:=fsStayOnTop;
Show;
end;

end.

