unit ScriptFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ToolWin, Menus,
  SynEditHighlighter, SynHighlighterPas, SynEdit, SynMemo,
  SynCompletionProposal, strutils, ImgList, SynHighlighterAsm, Spin, ActBoolExpr,
  EditExpr;

type
  TScriptForm = class(TForm)
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    SynPasSyn1: TSynPasSyn;
    SynCompletionProposal1: TSynCompletionProposal;
    Panel2: TPanel;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    ImageList2: TImageList;
    SynAsmSyn1: TSynAsmSyn;
    Panel3: TPanel;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Panel5: TPanel;
    Memo2: TMemo;
    ImageList3: TImageList;
    ImageList5: TImageList;
    ImageList6: TImageList;
    PanelEdit: TPanel;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    ToolBar3: TToolBar;
    PanelIV: TToolButton;
    Label2: TLabel;
    ImageList4: TImageList;
    exprstrin: TEditExpr;
    ToolBar2: TToolBar;
    ToolButton5: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    ImageList7: TImageList;
    ImageList8: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TreeView1: TTreeView;
    ImageList9: TImageList;
    PopupMenu2: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ToolBar5: TToolBar;
    ToolButton11: TToolButton;
    ImageList10: TImageList;
    Memo4: TMemo;
    TreeView2: TTreeView;
    ImageList11: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    toolbuttonss: TToolButton;
    Memo5: TMemo;
    TabSheet3: TTabSheet;
    ToolBar6: TToolBar;
    TreeView3: TTreeView;
    ToolButton3q: TToolButton;
    ToolButton4q: TToolButton;
    ToolButton5q: TToolButton;
    ImageList12: TImageList;
    ImageList13: TImageList;
    ImageList14: TImageList;
    ImageList15: TImageList;
    ToolButton9: TToolButton;
    Panel4: TPanel;
    SpinEdit2: TSpinEdit;
    Label3: TLabel;
    PopupMenu3: TPopupMenu;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    D1: TMenuItem;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Memo1: TSynMemo;
    SynMemo1: TSynMemo;
    PageControl3: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    Memo3: TSynMemo;
    SynMemo2: TSynMemo;
  //  procedure ToolButton1Click(Sender: TObject);
   // procedure ToolButton2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure SynCompletionProposal1Execute(Kind: SynCompletionType;
      Sender: TObject; var AString: String; var x, y: Integer;
      var CanExecute: Boolean);
    procedure Memo1Exit(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure TreeView1Edited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure TreeView1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure toolbuttonsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure PanelIVClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure exprstrinChange(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure addtosysMode(cataloge: TstringList; trn: TTreenode; indx: integer;  ident: integer);
    procedure TreeView2Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure ToolButton3qClick(Sender: TObject);
    procedure ToolButton4qClick(Sender: TObject);
    procedure ToolButton5qClick(Sender: TObject);
    procedure TreeView3Edited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure TreeView3Click(Sender: TObject);
    procedure TreeView1GetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeView3DblClick(Sender: TObject);
    procedure toolbuttonssClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
  private
    { Private declarations }
    fMC: TObject;
    ASc: TComponent;
    procedure SetMC(value: TObject);
    function  SetPanelIV(comp: TObject): boolean;
    function  SetPanelTY(comp: TObject): boolean;
    function  SetPanelCl(comp: TObject): boolean;
  public
    eventF,trigerE,trigerB,trigerV,trigerT,trigerU,trigerFin,trigerSt: TTreenode;
    syscDat,syscWin,syscExp,syscForm,syscStr, syscMath: TTreenode;
    VarGlobe,FormGlobe,compGlobe: TTreenode;
    CompL: TStringList;
    newst: boolean;
    curobjF: tObject;
    formListF:TList;
     CompListF:TList;
    procedure updatemet;
    procedure updateComp;
    procedure updateshow;
    procedure Sets;

    procedure Gets;
//    procedure EXecute(AppSc: Tcomponent;methComp: Tcomponent);
    procedure EXecuteByName(AppSc: Tcomponent;methComp: Tobject);

    procedure SetProc;
    procedure setproerr(tcomp: tobject;pos: integer);
    { Public declarations }
    Property MC: Tobject read fMC write setMc;
  end;

var
  ScriptForm: TScriptForm;
  StrLP: TStringList;

implementation

uses AppImmi, ifps3test1,UserScriptU;

{$R *.dfm}





procedure TScriptForm.EXecuteByName(AppSc: Tcomponent;methComp: Tobject);
var num: integer;
begin
asc:=AppSc;

 //if methComp=nil then methComp:=TApplicationImmi(asc).initializationSc;
 if (methcomp=nil) and (fmc<>nil) then methComp:=fmc;

MC:=methComp;

if newst then
begin
 newst:=false;
 self.updatemet;
end;
updateshow;;
memo3.text:='';
pagecontrol1.ActivePageIndex:=0;
updateshow;;
 //pagecontrol1.ActivePageIndex:=0;
//updateshow;;
show;
end;



procedure TScriptForm.setproerr(tcomp: tobject;pos: integer);
var mcn: TMethodInform;
begin
 if tcomp is TMethodInform then
   begin
   mcn:=TMethodInform(tcomp);
   mc:=mcn;
   end else
   begin
     if (tcomp=TApplicationImmi(asc).initializationSc) or
           (tcomp=TApplicationImmi(asc).finalizationSc) then
        mc:=tcomp;
   end;

end;

procedure TScriptForm.SetProc;
var   num: integer;
begin
end;



procedure TScriptForm.SetMC(value: TObject);
begin
  //if (value<>fMC) then
    begin
       self.PageControl2.ActivePageIndex:=0;
       self.PageControl3.ActivePageIndex:=0;
       if (fMC<>nil) then Sets;
       fMC:=value;
       if fmc=nil then fMC:=TApplicationImmi(asc).initializationSc;
       if (fMC<>nil) then  Gets;
       memo2.Lines.Clear;
       if fMc is TMethodInform then
       begin
       if (TMethodInform(fMC).MethodType=mkSimpleFunc) and  (TMethodInform(fMC).procfunc) then
       memo2.Text:=('   '+'  function ' +TMethodInform(fMC).MethodName+''+TMethodInform(fMC).MethodDecl+':'+ TMethodInform(fMC).resultf)
       else
       memo2.Text:=('   '+'  procedure ' +TMethodInform(fMC).MethodName+''+TMethodInform(fMC).MethodDecl+'');
       end else
       begin
       if fMC=TApplicationImmi(asc).finalizationSc then
            memo2.Text:='Finalization';
         if fMC=TApplicationImmi(asc).initializationSc then
            memo2.Text:='Initialization';
       end
    end;

end;


procedure TScriptForm.N3Click(Sender: TObject);
begin
if self.SaveDialog1.Execute then
  memo1.Lines.SaveToFile(self.OpenDialog1.FileName);
end;

procedure TScriptForm.SynCompletionProposal1Execute(
  Kind: SynCompletionType; Sender: TObject; var AString: String; var x,
  y: Integer; var CanExecute: Boolean);
 var asl, bsl: TStrings;
    str: string;
 begin
// showmessage('1');
 SynCompletionProposal1.ItemList.Clear;
// showmessage('2');
 SynCompletionProposal1.InsertList.Clear;
// showmessage('3');
 asl:=self.SynCompletionProposal1.ItemList;
// showmessage('4');
 bsl:=self.SynCompletionProposal1.InsertList;
// showmessage('5');
 str:=self.Memo1.LineText;
// showmessage('6');
 FillPropList(CompL,asl,bsl,str);
// showmessage('7');
 SynCompletionProposal1.ResetAssignedList;
// showmessage('8');
 CanExecute:=(SynCompletionProposal1.InsertList.count>0);
 end;


procedure TScriptForm.updateshow;
var newC,new, fnd: TTreenode;
    i,j,inx: integer;
    fx: boolean;
    redcomp: TComponent;
    compname,temp: string;
begin
 if newst then
   begin
   exit;
   end;
 i:=0;
// if pagecontrol1.ActivePageIndex=0 then
 begin
 while i<TreeView1.Items.Count do
   begin
    fx:=false;
    for j:=0 to TapplicationImmi(asc).mainproc.ComponentCount-1 do
        if (self.TreeView1.Items[i].Data=TapplicationImmi(asc).mainproc.Components[j])
         then fx:=true;

    if (fx) or  (self.TreeView1.Items[i]=eventF)
    or  (self.TreeView1.Items[i]=trigerE)
    or  (self.TreeView1.Items[i]=trigerB)
    or  (self.TreeView1.Items[i]=trigerV)
     or  (self.TreeView1.Items[i]=trigerT)
      or  (self.TreeView1.Items[i]=trigerU)
     or (self.TreeView1.Items[i]=trigerFin)
     or (self.TreeView1.Items[i]=trigerSt)
     then inc(i) else
        self.TreeView1.Items[i].Delete;

   end;
   i:=0;
 while i<TapplicationImmi(asc).mainproc.ComponentCount do
   begin
    fx:=false;
    for j:=0 to TreeView1.Items.Count-1 do
        if (self.TreeView1.Items[j].Data=TapplicationImmi(asc).mainproc.Components[i])  then fx:=true;
    if (not fx)  then
     begin
      if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType=mkEventForm then
      begin
        newc:=eventF;
        inx:=6;
      end;
       if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType=mkBoolExpr then
      begin
        newc:=trigerB;
        inx:=7;
      end;
       if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType=mkValueExpr then
      begin
        newc:=trigerV;
        inx:=8;
      end;
      if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType= mkTimerTrigger then
      begin
        newc:=trigerT;
        inx:=9;
      end;
        if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType= mkSimpleFunc then
      begin
        newc:=trigerU;
        if not TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).procfunc then inx:=11 else inx:=12;
      end;
      if TapplicationImmi(asc).mainproc.Components[i] is TMethodInform then new:=self.TreeView1.Items.AddChild(newc,TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodName);
      new.ImageIndex:=inx;
      new.Data:=TMethodInform(TapplicationImmi(asc).mainproc.Components[i]);
   end;
   inc(i);
   end;
   for j:=0 to TreeView1.Items.Count-1 do
        if (self.TreeView1.Items[j].Data<>nil) and
          (TComponent(self.TreeView1.Items[j].Data) is TMethodInform) and
            (uppercase(trim(TMethodInform(self.TreeView1.Items[j].Data).MethodName))<>uppercase(trim(self.TreeView1.Items[j].Text)))  then
                 self.TreeView1.Items[j].Text:=TMethodInform(self.TreeView1.Items[j].Data).MethodName;
 if fMC<>nil then
 fnd:=nil;
  if Tobject(fMC) is TMethodInform then
    for j:=0 to TreeView1.Items.Count-1 do
      if (self.TreeView1.Items[j].Data<>nil) and
          (Tobject(self.TreeView1.Items[j].Data) is TMethodInform) and
         ( fMC=Tobject(self.TreeView1.Items[j].Data)) then fnd:=self.TreeView1.Items[j];
     if fnd<>nil then
      begin
      if not fnd.Expanded then fnd.Expand(true);
      self.TreeView1.Select(fnd);
      end;
    if fMC<>nil then
   if (fMC<>nil ) and (Tobject(fMC) is TMethodInform) then
    begin
      curobjF:=TapplicationImmi(asc).GetFirstObj(fMC);
      case TMethodInform(fMc).MethodType of
        mkEventForm:
         begin
          self.ToolBar2.Enabled:=false;
          self.Paneliv.Enabled:=false;
          self.ToolBar2.Visible:=false;
          self.Spinedit1.Enabled:=false;
          self.Label1.Enabled:=false;
          self.exprstrin.Enabled:=false;
          self.exprstrin.Text:='';
          Paneledit.Visible:=false;
          self.ToolButton9.Enabled:=false;
          self.ToolButton9.Visible:=false;
          Panel4.Visible:=false;
         end;
         mkBoolExpr:
         begin
           self.exprstrin.Enabled:=true;
           self.ToolBar2.Enabled:=true;
           self.ToolBar2.Visible:=true;
          self.PanelIV.Enabled:=true;
         // self.PanelTY.Enabled:=true;
           self.Spinedit1.Enabled:=false;
          self.Label1.Enabled:=false;
          self.SetPanelIV(curobjF);
          self.SetPanelTY(curobjF);
          if curobjF<>nil then
           begin
             if curobjF is TActExpr then
                if (curobjF as TActExpr).typeUse=tuTimer then
                 begin
                    self.Spinedit1.Enabled:=true;
                    self.Label1.Enabled:=true;
                   self.SetPanelCl(curobjF);
                 end else
                 begin
                  self.Spinedit1.Enabled:=false;
                  self.Label1.Enabled:=false;
                 end;
           end;
           Paneledit.Visible:=true;
            self.ToolButton9.Enabled:=false;
          self.ToolButton9.Visible:=false;
          Panel4.Visible:=false;
         end;
          mkValueExpr:
         begin
           self.exprstrin.Enabled:=true;
           self.ToolBar2.Enabled:=false;
           self.ToolBar2.Visible:=false;
          self.PanelIV.Enabled:=true;
          self.SetPanelIV(curobjF);
          //self.PanelTY.Enabled:=false;
           self.Spinedit1.Enabled:=false;
          self.Label1.Enabled:=false;
          Paneledit.Visible:=true;
           self.ToolButton9.Enabled:=false;
          self.ToolButton9.Visible:=false;
          Panel4.Visible:=false;
          spinedit1.Visible:=false;
          label1.Visible:=false;
         end;
        mkTimerTrigger:
         begin
            self.ToolBar2.Visible:=false;
           self.exprstrin.Enabled:=false;
           self.exprstrin.Text:='';
           self.ToolBar2.Enabled:=false;
          self.PanelIV.Enabled:=false;
         // self.PanelTY.Enabled:=false;
           self.Spinedit1.Enabled:=true;
          self.Label1.Enabled:=true;
          self.SetPanelCl(curobjF);
          Paneledit.Visible:=false;
           self.ToolButton9.Enabled:=false;
          self.ToolButton9.Visible:=false;
          Panel4.Visible:=true;
         end;
       mkSimpleFunc:
          begin
             self.ToolBar2.Enabled:=false;
          self.Paneliv.Enabled:=false;
          self.ToolBar2.Visible:=false;
          self.Spinedit1.Enabled:=false;
          self.Label1.Enabled:=false;
          self.exprstrin.Enabled:=false;
          self.exprstrin.Text:='';
          Paneledit.Visible:=false;
           self.ToolButton9.Enabled:=true;
          self.ToolButton9.Visible:=true;
          Panel4.Visible:=false;
         end;
     end;
    end else
    begin
      if (fMC=TapplicationImmi(asc).finalizationSc) or
         (fMC=TapplicationImmi(asc).initializationSc) then
            begin
               self.ToolBar2.Enabled:=false;
               self.Paneliv.Enabled:=false;
               self.Spinedit1.Enabled:=false;
               self.Label1.Enabled:=false;
               self.exprstrin.Enabled:=false;
               self.exprstrin.Text:='';
              Paneledit.Visible:=false;
               self.ToolButton9.Enabled:=false;
              self.ToolButton9.Visible:=false;
             Panel4.Visible:=false;
            end;
    end;
      for j:=0 to TreeView1.Items.Count-1 do
        if (TComponent(self.TreeView1.Items[j].Data) is TMethodInform) and
             (TMethodInform(self.TreeView1.Items[j].Data).MethodType=mkSimpleFunc) then
             begin
                 if TMethodInform(self.TreeView1.Items[j].Data).procfunc then
                 self.TreeView1.Items[j].ImageIndex:=12 else  self.TreeView1.Items[j].ImageIndex:=11;
             end;
     end;
    //  if pagecontrol1.ActivePageIndex=2 then
      begin
     j:=0;
     while j<TreeView3.Items.Count do
       if TreeView3.Items[j].Data=nil then
         begin
           if TapplicationImmi(asc).variableList.IndexOf(TreeView3.Items[j].Text)<0 then
             TreeView3.Items[j].Delete else inc(j);
         end else
         inc(j);

     for j:=0 to TapplicationImmi(asc).variableList.Count-1 do
      begin
        fx:=false;
         for i:=0 to TreeView3.Items.Count-1 do
           begin

            if TreeView3.Items[i].Data=nil then
            if Uppercase(TapplicationImmi(asc).variableList.Strings[j])=uppercase(TreeView3.Items[i].text) then
            fx:=true;
           end;
        if not fx then
          begin
             new:=self.TreeView3.Items.AddChild(VarGlobe,TapplicationImmi(asc).variableList.Strings[j]);
             new.imageindex:=1;
             new.Data:=nil;
          end;    
      end;
      updateComp;
      end;
end;


procedure TScriptForm.updateComp;
var j,i: integer;
    fnd: TTreenode;
begin
   TapplicationImmi(asc).getselectList(formListF,CompListF);
 j:=0;
     while j<TreeView3.Items.Count do
       begin
       if (TreeView3.Items[j].Data=nil) and
            ((TreeView3.Items[j].Parent=FormGlobe) or
               (TreeView3.Items[j].Parent=CompGlobe)) then
                TreeView3.Items[j].Delete else inc(j);
         end;{ else
         inc(j);  }
  j:=0;
     while j<TreeView3.Items.Count do
       begin
       if (TreeView3.Items[j].Data<>nil) and
            (TreeView3.Items[j].Parent=FormGlobe) and
            (formListF.IndexOf(TreeView3.Items[j].Data)<0) then
                TreeView3.Items[j].Delete else inc(j);
         end;
   j:=0;
    // for i:=0 to formListF.Count-1 do showmessage(tform(formListF.Items[i]).Caption);
     while j<TreeView3.Items.Count do
       begin
       if (TreeView3.Items[j].Data<>nil) and
            (Tobject(TreeView3.Items[j].Data) is TForm) and
            (TreeView3.Items[j].Parent=FormGlobe) and
            (formListF.IndexOf(TreeView3.Items[j].Data)>-1) then
               begin

               TreeView3.Items[j].Text:=tform(TreeView3.Items[j].Data).Name+'  {'+tform(TreeView3.Items[j].Data).Caption+'}';
                 formListF.Delete(formListF.IndexOf(TreeView3.Items[j].Data));
               end;
                inc(j);
         end;
    for i:=0 to formListF.Count-1 do
      begin
       fnd:=self.TreeView3.Items.AddChild(FormGlobe,tform(formListF.Items[i]).Name+'  {'+tform(formListF.Items[i]).Caption+'}');
       fnd.Data:=formListF.Items[i];
       fnd.ImageIndex:=5;
      end;
   

    j:=0;
     while j<TreeView3.Items.Count do
       begin
       if (TreeView3.Items[j].Data<>nil) and
            (TreeView3.Items[j].Parent=CompGlobe) and
            (CompListF.IndexOf(TreeView3.Items[j].Data)<0) then
                TreeView3.Items[j].Delete else inc(j);
         end;



   j:=0;
    // for i:=0 to formListF.Count-1 do showmessage(tform(formListF.Items[i]).Caption);
     while j<TreeView3.Items.Count do
       begin
       if (TreeView3.Items[j].Data<>nil) and
            (Tobject(TreeView3.Items[j].Data) is TComponent) and
            (TreeView3.Items[j].Parent=CompGlobe) and
            (CompListF.IndexOf(TreeView3.Items[j].Data)>-1) then
               begin

               TreeView3.Items[j].Text:=tComponent(TreeView3.Items[j].Data).Owner.Name+'->'+tComponent(TreeView3.Items[j].Data).Name;
                 CompListF.Delete(CompListF.IndexOf(TreeView3.Items[j].Data));
               end;
                inc(j);
         end;
    for i:=0 to CompListF.Count-1 do
      begin
       fnd:=self.TreeView3.Items.AddChild(CompGlobe,tcomponent(compListF.Items[i]).owner.Name+'->'+tcomponent(compListF.Items[i]).Name);
       fnd.Data:=CompListF.Items[i];
       fnd.ImageIndex:=3;
      end;
end;

procedure TScriptForm.updatemet;
var newC,newS,newV, new: TTreenode;
    i,inx: integer;
begin

  self.TreeView2.Items.Clear;
 newS:=self.TreeView2.TopItem;
 syscWin:=self.TreeView2.Items.AddChildObject(newS,'Windows-функции',nil);
 syscWin.ImageIndex:=1;
 addtosysMode(TapplicationImmi(asc).SysSc, syscWin, 7,10);
 syscForm:=self.TreeView2.Items.AddChildObject(newS,'Функции работы с окнами',nil);
 syscForm.ImageIndex:=2;
 addtosysMode(TapplicationImmi(asc).SysSc, syscForm, 8,11);
 syscExp:=self.TreeView2.Items.AddChildObject(newS,'Функции работы с выражениями',nil);
 syscExp.ImageIndex:=3;
 addtosysMode(TapplicationImmi(asc).SysSc, syscExp, 9,5);
 syscDat:=self.TreeView2.Items.AddChildObject(newS,'Функции дата-время',nil);
 syscDat.ImageIndex:=4;
 addtosysMode(TapplicationImmi(asc).SysSc, syscDat, 10,12);
 syscStr:=self.TreeView2.Items.AddChildObject(newS,'Строковые функции',nil);
 syscStr.ImageIndex:=5;
 addtosysMode(TapplicationImmi(asc).SysSc,  syscStr, 11,2);
 syscMath:=self.TreeView2.Items.AddChildObject(newS,'Математические функции',nil);
 syscMath.ImageIndex:=6;
 addtosysMode(TapplicationImmi(asc).SysSc,  syscMath, 12,3);

 newV:=self.TreeView3.TopItem;
 VarGlobe:=self.TreeView3.Items.AddChildObject(newV,'Глобальные переменные',nil);
 VarGlobe.Imageindex:=0;
 VarGlobe.Data:=VarGlobe;
 formGlobe:=self.TreeView3.Items.AddChildObject(newV,'Формы',nil);
 formGlobe.ImageIndex:=2;
 formGlobe.data:=formGlobe;
 compglobe:=self.TreeView3.Items.AddChildObject(newV,'Выделенные компоненты',nil);
 compglobe.ImageIndex:=4;
 compglobe.Data:=compglobe;
 self.TreeView1.Items.Clear;
 newC:=self.TreeView1.TopItem;
  trigerSt:=self.TreeView1.Items.AddChildObject(newc,'Инициализация',TapplicationImmi(asc).initializationSc);
 trigerSt.ImageIndex:=13;
 eventF:=self.TreeView1.Items.AddChild(newc,'Скрипты-события');
 eventF.ImageIndex:=1;
 eventF.Data:=nil;
 trigerE:=self.TreeView1.Items.AddChild(newc,'Скрипты-триггеры');
 trigerE.ImageIndex:=2;
 trigerE.Data:=nil;
 trigerB:=self.TreeView1.Items.AddChild( trigerE,'булев-триггеры');
 trigerB.ImageIndex:=3;
 trigerB.Data:=nil;
 trigerV:=self.TreeView1.Items.AddChild( trigerE,'триггеры-значения');
 trigerV.ImageIndex:=4;
 trigerV.Data:=nil;
 trigerT:=self.TreeView1.Items.AddChild( newc,'Циклические скрипты');
 trigerT.ImageIndex:=5;
 trigerT.Data:=nil;
 trigerU:=self.TreeView1.Items.AddChild( newc,'Пользовательские скрипты');
 trigerU.ImageIndex:=10;
 trigerU.Data:=nil;
 trigerFin:=self.TreeView1.Items.AddChildObject(newc,'Финализация',TapplicationImmi(asc).finalizationSc);
 trigerFin.ImageIndex:=14;
 eventF.Data:=nil;
 for i:=0 to TapplicationImmi(asc).mainproc.ComponentCount-1 do
   begin
      if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType=mkEventForm then
      begin
        newc:=eventF;
        inx:=6;
      end;
       if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType=mkBoolExpr then
      begin
        newc:=trigerB;
        inx:=7;
      end;
       if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType=mkValueExpr then
      begin
        newc:=trigerV;
        inx:=8;
      end;
       if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType= mkTimerTrigger then
      begin
        newc:=trigerT;
        inx:=9;
      end;
       if TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodType= mkSimpleFunc then
      begin
        newc:=trigerU;
        if not TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).procfunc then inx:=11 else inx:=12;
      end;
      if TapplicationImmi(asc).mainproc.Components[i] is TMethodInform then new:=self.TreeView1.Items.AddChild(newc,TMethodInform(TapplicationImmi(asc).mainproc.Components[i]).MethodName);
      new.ImageIndex:=inx;
      new.Data:=TMethodInform(TapplicationImmi(asc).mainproc.Components[i]);
   end;

 memo2.Lines.Clear;
 if fMC is TMethodInform then
  begin
  if (TMethodInform(fMC).MethodType=mkSimpleFunc) and  (TMethodInform(fMC).procfunc) then
       memo2.Text:=('   '+'  function ' +TMethodInform(fMC).MethodName+''+TMethodInform(fMC).MethodDecl+'' )
       else
       memo2.Text:=('   '+'  procedure ' +TMethodInform(fMC).MethodName+''+TMethodInform(fMC).MethodDecl+'');
  end else
  begin
      if (fMC=TapplicationImmi(asc).initializationSc) then   memo2.Text:='Initialization';
      if (fMC=TapplicationImmi(asc).finalizationSc) then   memo2.Text:='Finalization';
  end;

  for i:=0 to TapplicationImmi(asc).variableList.Count-1 do
    begin
      new:=self.TreeView3.Items.AddChild(VarGlobe,TapplicationImmi(asc).variableList.Strings[i]);
      new.imageindex:=1;
      new.Data:=nil;
    end;
end;

procedure TScriptForm.Memo1Exit(Sender: TObject);
begin
 // StrLP.Clear;
 // StrLP.AddStrings(memo1.Lines);
end;

procedure TScriptForm.Sets;
begin
if newst then exit;
   if (fMC<>nil) then
    begin
     if fMC is TMethodInform then
     begin
     TMethodInform(fMc).MethodContent.Clear;
     TMethodInform(fMc).MethodContent.Text:= memo1.Lines.text;
     end;
      if fMC=TApplicationIMMI(asc).finalizationSc then
     begin
     TApplicationIMMI(asc).finalizationSc.Clear;
     TApplicationIMMI(asc).finalizationSc.Text:= memo1.Lines.text;
     end;
      if fMC=TApplicationIMMI(asc).initializationSc then
     begin
     TApplicationIMMI(asc).initializationSc.Clear;
     TApplicationIMMI(asc).initializationSc.Text:= memo1.Lines.text;
     end;
    end;
end;



procedure TScriptForm.Gets;
begin
if newst then exit;
   if fMC<>nil then
    begin
      if fMC is TMethodInform then
      begin
      memo1.Lines.Clear;
      memo1.Lines.Text:=TMethodInform(fMc).MethodContent.Text;
      end;
         if fMC=TApplicationIMMI(asc).finalizationSc then
       begin
      memo1.Lines.Clear;
      memo1.Lines.Text:=TApplicationIMMI(asc).finalizationSc.Text;
      end;
         if fMC=TApplicationIMMI(asc).initializationSc then
       begin
      memo1.Lines.Clear;
      memo1.Lines.Text:=TApplicationIMMI(asc).initializationSc.Text;
      end;

    end;
end;

procedure TScriptForm.FormClick(Sender: TObject);
begin
  fMC:=nil;
  ASc:=nil;
end;

procedure TScriptForm.TreeView1Edited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
if  (Node.Data<>nil) and (Node.Data<>TApplicationIMMI(asc).initializationSc) and
       (Node.Data<>TApplicationIMMI(asc).finalizationSc) and
       (Tobject(Node.Data) is TMethodInform) and
       (trim(TMethodInform(Node.Data).MethodName)<>trim(s)) then
        begin
        try
        TApplicationImmi(asc).RenamNameMeth(trim(s),TComponent(Node.Data));
        except
        end;
        updateshow;
        end else
        begin
         s:=node.Text;
         self.updatemet;
        end;

end;




procedure TScriptForm.TreeView1Click(Sender: TObject);
var Node: TTreeNode;
begin
if self.TreeView1.SelectionCount=1 then
 begin
   node:=self.TreeView1.Selections[0];
   if TObject(node.Data) is TMethodInform then
     begin
      MC:=TMethodInform(node.Data);
      self.updateshow;
     end;
   if TObject(node.Data)=TApplicationIMMI(asc).initializationSc then
     begin
      MC:=TApplicationIMMI(node.Data);
      self.updateshow;
     end;
    if TObject(node.Data)=TApplicationIMMI(asc).finalizationSc then
     begin
      MC:=TApplicationIMMI(node.Data);
      self.updateshow;
     end;
  end;
  if Node.Data<>nil
  then
    begin
      if Tobject(Node.Data) is TMethodInform then
        begin
           //Toolbutton1.Enabled:=true;
           Toolbuttonss.Enabled:=true;
        end else
        begin
          // Toolbutton1.Enabled:=false;
           Toolbuttonss.Enabled:=false;
        end;
    end else
     begin
          // Toolbutton1.Enabled:=false;
           Toolbuttonss.Enabled:=false;
        end;
end;

procedure TScriptForm.ToolButton1Click(Sender: TObject);
begin
  if (fMC<>nil) then Sets;
  begin
  self.PageControl2.ActivePageIndex:=0;
  self.PageControl3.ActivePageIndex:=0;
  TApplicationImmi(asc).Compile;
  self.SynMemo1.Text:=TApplicationImmi(asc).pascaltext;
  //self.SynMemo2.Text:=TApplicationImmi(asc).assablertext;
  end;
end;

procedure TScriptForm.toolbuttonsClick(Sender: TObject);
begin
  MC:=TApplicationImmi(asc).CreateMethodforType(mkBoolExpr);
  self.updateshow;
end;

procedure TScriptForm.FormCreate(Sender: TObject);
begin
newst:=true;
curobjF:=nil;
formListF:=TList.Create;
CompListF:=TList.Create;
end;

procedure TScriptForm.ToolButton3Click(Sender: TObject);
begin
  MC:=TApplicationImmi(asc).CreateMethodforType(mkTimerTrigger);
  self.updateshow;
end;

function TScriptForm.SetPanelIV(comp: TObject): boolean;
begin
result:=false;
if curobjF=nil then exit;
if comp=nil then exit;
if (comp is  TActExpr) then
  begin
     if TActExpr(comp).IgnoreValid then
      begin
      PanelIV.ImageIndex:=1;
      PanelIV.Hint:='Включить учет валидности';
      end
      else
      begin
      PanelIV.ImageIndex:=0;
      PanelIV.Hint:='Выключить учет валидности';
      end;
       exprstrin.Text:=TActExpr(curobjF).ExprBool;
      result:=true;
  end;
end;

function TScriptForm.SetPanelTY(comp: TObject): boolean;
begin
result:=false;
if comp=nil then exit;
if (comp is  TActExpr) then
  begin
     case TActExpr(comp).TypeUse of
     tuNone:
      begin
      toolbutton5.ImageIndex:=0;
      toolbutton4.ImageIndex:=4;
      toolbutton6.ImageIndex:=3;
      toolbutton5.Down:=true;
      toolbutton4.Down:=false;
      toolbutton6.Down:=false;
      Spinedit1.Visible:=false;
      label1.Visible:=false;
      end;
     tuTimer:
      begin
      toolbutton5.ImageIndex:=5;
      toolbutton4.ImageIndex:=1;
      toolbutton6.ImageIndex:=3;
       toolbutton5.Down:=false;
      toolbutton4.Down:=true;
      toolbutton6.Down:=false;
      Spinedit1.Visible:=true;
      label1.Visible:=true;
      end;
     tuBlink:
      begin
      toolbutton5.ImageIndex:=5;
      toolbutton4.ImageIndex:=4;
      toolbutton6.ImageIndex:=2;
       toolbutton5.Down:=false;
      toolbutton4.Down:=false;
      toolbutton6.Down:=true;
      Spinedit1.Visible:=false;
      label1.Visible:=false;
      end;
    end;
    result:=true;
  end;
end;

function TScriptForm.SetPanelCl(comp:TObject): boolean;
begin
result:=false;
if comp=nil then exit;
if (comp is  TActExpr) then
  begin
     case TActExpr(comp).TypeUse of
     tuTimer:
      begin
      spinedit1.Value:=TActExpr(comp).Delay;
       spinedit2.Value:=TActExpr(comp).Delay;
      result:=true;
      end;
     end;
   end;
if (comp is  TScripttimer) then
  begin
   spinedit1.Value:=TScripttimer(comp).SInterval;
   spinedit2.Value:=TScripttimer(comp).SInterval;
   result:=true;
  end;
end;

procedure TScriptForm.ToolButton5Click(Sender: TObject);
begin
  if curobjF=nil then exit;
    if (curobjF is  TActExpr) then
      begin
        TActExpr(curobjF).TypeUse:=tuNone;
        self.updateshow;
      end;
end;

procedure TScriptForm.ToolButton4Click(Sender: TObject);
begin
   if curobjF=nil then exit;
    if (curobjF is  TActExpr) then
      begin
        TActExpr(curobjF).TypeUse:=tuTimer;
        self.updateshow;
      end;
end;

procedure TScriptForm.ToolButton6Click(Sender: TObject);
begin
    if curobjF=nil then exit;
    if (curobjF is  TActExpr) then
      begin
        TActExpr(curobjF).TypeUse:=tuBlink;
        self.updateshow;
      end;
end;

procedure TScriptForm.PanelIVClick(Sender: TObject);
begin
   if curobjF=nil then exit;
    if (curobjF is  TActExpr) then
      begin
        TActExpr(curobjF).IgnoreValid:= not TActExpr(curobjF).IgnoreValid;

        self.updateshow;
      end;
end;

procedure TScriptForm.SpinEdit1Change(Sender: TObject);
begin
  if curobjF=nil then exit;
    if (curobjF is  TActExpr) then
      begin
        TActExpr(curobjF).Delay:=TSpinedit(Sender).value;
        self.updateshow;
      end;
    if (curobjF is  TScriptTimer) then
      begin
        TScriptTimer(curobjF).SInterval:=TSpinedit(Sender).value;
        self.updateshow;
      end;
end;

procedure TScriptForm.exprstrinChange(Sender: TObject);
begin
   if curobjF=nil then exit;
    if (curobjF is  TActExpr) then
      begin
        TActExpr(curobjF).ExprBool:=exprstrin.Text;
        self.updateshow;
      end;
end;

procedure TScriptForm.ToolButton7Click(Sender: TObject);
begin
   MC:=TApplicationImmi(asc).CreateMethodforType(mkValueExpr);
  self.updateshow;
end;

procedure TScriptForm.ToolButton8Click(Sender: TObject);
var mcc: TComponent;
begin
    Mcc:=TApplicationImmi(asc).CreateMethodforType(mkSimpleFunc);
  if mcc<>nil then  MC:=mcc;
  self.updateshow;
end;

procedure TScriptForm.ToolButton9Click(Sender: TObject);
var  UserSc: TUserScript;
begin
   if mc=nil then exit;
   if TMethodInform(Mc).MethodType=mkSimpleFunc then
   try
     UserSc:=TUserScript.create(nil);
     UserSc.Execute(TMethodInform(fMc),TApplicationImmi(asc));
     UserSc.Free;;
   except
   end;
   MC:=fMC;
  self.updateshow;
end;

procedure TScriptForm.addtosysMode(cataloge: TstringList; trn: TTreenode; indx: integer; ident: integer);
var i: integer;
    new: TTreenode;
begin
  for i:=0 to cataloge.count-1 do
  begin
  if cataloge.Objects[i]<>nil then
  if cataloge.Objects[i] is TSysscriptDecl then
  if (cataloge.Objects[i] as TSysscriptDecl).typ=ident then
  begin
  new:=self.TreeView2.Items.AddChild(trn,cataloge.Strings[i]);
  new.ImageIndex:=indx;
  new.Data:=cataloge.Objects[i];
  end;
  end;
end;

procedure TScriptForm.TreeView2Click(Sender: TObject);
var Node: TTreeNode;
begin
 if self.TreeView2.SelectionCount=1 then
 begin
   node:=self.TreeView2.Selections[0];
   if TObject(node.Data) is TSysscriptDecl then
     begin
        Memo5.Text:={(TObject(node.Data) as TSysscriptDecl).MethName+'('+}
          (TObject(node.Data) as TSysscriptDecl).decl{+')';
        Memo4.Text:=(TObject(node.Data) as TSysscriptDecl).hint};
     end else
     begin
        Memo5.Text:='';
        Memo4.Text:='';
     end;
  end;
end;

procedure TScriptForm.TreeView1DblClick(Sender: TObject);
var Node: TTreeNode;
    insstr: string;
begin
   if self.TreeView2.SelectionCount=1 then
 begin
   node:=self.TreeView2.Selections[0];
   if TObject(node.Data) is TSysscriptDecl then
     begin
         insstr:=(TObject(node.Data) as TSysscriptDecl).MethName+'(';
        Memo1.Text:=StuffString(Memo1.Text,memo1.SelStart,0,insstr);
        memo1.SelStart:=memo1.SelStart+length(insstr);
     end
   end;
end;



procedure TScriptForm.ToolButton3qClick(Sender: TObject);
var NewN: string;
begin
if asc<>nil then
 begin
 newN:='';
 TApplicationImmi(asc).CreateVar(NewN);
 end;
 self.updateshow;
end;

procedure TScriptForm.ToolButton4qClick(Sender: TObject);
var Node: TTreeNode;
    NewN: string;
begin
  if asc<>nil then
  if self.TreeView3.SelectionCount=1 then
 begin
 node:=self.TreeView3.Selections[0];
 if node.Data=nil then
   begin
   NewN:=node.text;
   TApplicationImmi(asc).CreateVar(NewN);
   if newN<>node.text then node.text:=newN;
   end;
 self.updateshow;
 end;
end;

procedure TScriptForm.ToolButton5qClick(Sender: TObject);
var Node: TTreeNode;
begin
  if asc<>nil then
  if self.TreeView3.SelectionCount=1 then
 begin
 node:=self.TreeView3.Selections[0];
 if node.Data=nil then
   begin
   TApplicationImmi(asc).DeleteVar(node.text);

   end;
 self.updateshow;
 end;
end;

procedure TScriptForm.TreeView3Edited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
if node<>nil then
begin
if node.Data=nil then
  begin
   if not TApplicationImmi(asc).VarisName(node.text,s) then
   S:=node.text;
  end else S:=node.text;
end else
 { if TObject(node.Data) is TForm then
       TApplicationImmi(asc).RenameComp(TForm(node.Data).Name,S, TApplicationImmi(asc).IDesigS) else
          if (TObject(node.Data) is TComponent) and not (TObject(node.Data) is TTreenode) then
            TApplicationImmi(asc).RenameComp(TForm(node.Data).Name,S, TApplicationImmi(asc).IDesigS) else     }
S:=node.text;
end;

procedure TScriptForm.TreeView3Click(Sender: TObject);
var Node: TTreeNode;
begin
  begin
 node:=self.TreeView3.Selections[0];
 if node.Data=nil then
   begin
     self.ToolButton3q.Enabled:=true;
     self.ToolButton4q.Enabled:=true;
     self.ToolButton5q.Enabled:=true;
   end else
   begin
     self.ToolButton3q.Enabled:=true;
     self.ToolButton4q.Enabled:=false;
     self.ToolButton5q.Enabled:=false;
   end
   end;
end;

procedure TScriptForm.TreeView1GetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
if Node.Data<>nil
  then
    begin
      if Tobject(Node.Data) is TMethodInform then
        begin
           //Toolbutton1.Enabled:=true;
           Toolbuttonss.Enabled:=true;
        end else
        begin
          // Toolbutton1.Enabled:=false;
           Toolbuttonss.Enabled:=false;
        end;
    end;
end;

procedure TScriptForm.TreeView3DblClick(Sender: TObject);
var Node: TTreeNode;
    insstr: string;
begin
 if self.TreeView3.SelectionCount=1 then
 begin
   node:=self.TreeView3.Selections[0];
   if node.Data=nil then
     begin
         insstr:=node.Text;
         if pos(':',insstr)<>0 then
         insstr:=copy(insstr,1,pos(':',insstr)-1);
          Memo1.Text:=StuffString(Memo1.Text,memo1.SelStart,0,insstr);
        memo1.SelStart:=memo1.SelStart+length(insstr);
     end;
   if Tobject(node.Data) is TForm then
    begin
       insstr:=TForm(node.Data).Name;
       Memo1.Text:=StuffString(Memo1.Text,memo1.SelStart,0,insstr);
        memo1.SelStart:=memo1.SelStart+length(insstr);
    end;
   if (Tobject(node.Data) is TComponent) and not(Tobject(node.Data) is TForm) then
    begin
       insstr:=TComponent(node.Data).Owner.Name+'->'+TComponent(node.Data).Name;
       Memo1.Text:=StuffString(Memo1.Text,memo1.SelStart,0,insstr);
        memo1.SelStart:=memo1.SelStart+length(insstr);
    end;
   end;
end;

procedure TScriptForm.toolbuttonssClick(Sender: TObject);
begin
   TApplicationImmi(asc).DeleteMeth(Tcomponent(MC));
   MC:=TApplicationImmi(asc).initializationSc;
   self.updateshow;
end;

procedure TScriptForm.N5Click(Sender: TObject);
begin
if memo1.SelAvail then
  begin
     Memo1.CopyToClipboard;
  end;
end;

procedure TScriptForm.PopupMenu1Popup(Sender: TObject);
begin
     n7.Enabled:=memo1.SelAvail;
     n5.Enabled:=memo1.SelAvail;
     n6.Enabled:=Memo1.CanPaste;
     d1.Enabled:=(MC<>nil);
end;

procedure TScriptForm.N7Click(Sender: TObject);
begin
 if memo1.SelAvail then
  begin
     Memo1.CutToClipboard;
  end;
end;


procedure TScriptForm.N6Click(Sender: TObject);
begin
   Memo1.PasteFromClipboard;
end;

procedure TScriptForm.D1Click(Sender: TObject);
begin
    Memo1.SelectAll;
end;

procedure TScriptForm.TabSheet5Show(Sender: TObject);
begin
   if asc<>nil then
    begin
    TApplicationImmi(asc).printSb;
    self.SynMemo1.Text:=TApplicationImmi(asc).pascaltext;

    end;
end;

procedure TScriptForm.TabSheet7Show(Sender: TObject);
begin
   if (fMC<>nil) then Sets;
  begin
  TApplicationImmi(asc).printSb;
  self.SynMemo2.Text:=TApplicationImmi(asc).assablertext;
  end;
end;

procedure TScriptForm.FormDestroy(Sender: TObject);
begin
  formListF.Free;
  CompListF.free;
end;

procedure TScriptForm.TabSheet1Show(Sender: TObject);
begin
//self.updateshow;
end;

end.


