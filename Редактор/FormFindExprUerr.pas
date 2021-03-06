unit FormFindExprUerr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,StrUtils,
  Dialogs, StdCtrls, ExtCtrls, EditExpr, Grids, ColorStringGrid, expr, TypInfo, Constdef,
  ComCtrls, DialogExprU;

type
  TFormFindExprerr = class(TForm)
    EditExpr1: TEditExpr;
    bStop: TButton;
    bExit: TButton;
    bStart: TButton;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    ProgressBar1: TProgressBar;
    bNoReplace: TButton;
    bReplace: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    cboxFormCoose: TComboBox;
    Label1: TLabel;
    Label6: TLabel;
    procedure bStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure bReplaceClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNoReplaceClick(Sender: TObject);
    procedure bRepAllClick(Sender: TObject);
    procedure EditExpr1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ReplaceExpr;
    procedure ColorStringGrid1SetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure ColorStringGrid1DrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    rbLoc_SelCom: TRadioButton;
    rbLoc_Form: TRadioButton;
    rbLoc_All: TRadioButton;

    rbAct_Selc: TRadioButton;
    rbAct_UpOne: TRadioButton;
    rbAct_NoSelc: TRadioButton;
    DesigCom: TComponent;
    CompList: TList;
    procedure Execute(Mother: TComponent);
    procedure G1B1Click(sender: TObject);
    function  ReplaseInExpr(sorsestr: String; findst: string; repstr: string): string;
    procedure ExecFind;
    function ErrExprDialog(expval: string): boolean;

  end;



var
  FormFindExprErr: TFormFindExprErr;
  k: integer;
  nextEx: boolean;
  isStop: boolean;
  curform: TForm;
  replase: boolean;
  stringObj: string;
  isTableRep: boolean;
  CountReplase: integer;
  ignoallerrrep: boolean;
  DialogExpr: TDialogExpr;
implementation

uses Redactor, Controlddh;


var IdentStrings: TMyStringList;
{$R *.dfm}

procedure TFormFindExprErr.Execute(Mother: TComponent);
var i: integer;
begin
  CompList.clear;
  DesigCom:=Mother;
  if DesigCom=nil then exit;
  if DesigCom.ComponentCount=0 then exit;
  EditExpr1.Text:='';
  ////ColorStringGrid1.RowCount:=0;
  //ColorStringGrid1.Cells[0,0]:='';
  ProgressBar1.Position:=0;
  cboxFormCoose.Items.Clear;
  for i:=0 to DesigCom.ComponentCount-1 do
      cboxFormCoose.Items.AddObject(tform(DesigCom.Components[i]).Caption,DesigCom.Components[i]);
  curform:=(DesigCom as TRedactor).actWind;
  cboxFormCoose.Text:=curform.caption;
  label5.Visible:=false;
  if (DesigCom as TRedactor).NumSelected=0 then
        begin
          rbLoc_Form.Checked:=true;
          rbLoc_SelCom.Checked:=false;
          rbLoc_SelCom.Enabled:=false;
          G1B1Click(self.rbLoc_Form);
        end
  else
        begin
          rbLoc_Form.Enabled:=true;
          rbLoc_SelCom.Checked:=true;
          G1B1Click(self.rbLoc_SelCom);
        end;
  rbAct_NoSelc.Checked:=true;
  G1B1Click(self.rbAct_NoSelc);
  G1B1Click(nil);
  isTableRep:=false;
  ShowModal;
  (DesigCom as TRedactor).PropertyForm;
  (DesigCom as TRedactor).PopMenuShowTegsforForm;
end;

procedure TFormFindExprErr.bStartClick(Sender: TObject);
begin

 Countreplase:=0;
 CompList.Clear;
 //ColorStringGrid1.RowCount:=0;
 //ColorStringGrid1.Cells[0,0]:='';
   begin
     if not (rbAct_Selc.Checked ) then
     begin
       bNoReplace.visible:=false;
       bReplace.Visible:=true;
       bReplace.Caption:='�����';
     end;
   end;
 bExit.Visible:=false;
 bStart.Visible:=false;
 bStop.Visible:=true;
 label5.Visible:=true;
 ProgressBar1.Position:=0;
 nextex:=true;
 isStop:=false;
 ignoallerrrep:=false;


 ExecFind;


 ProgressBar1.Position:=100;
 if (CountReplase=0) and not (isStop) then
      ShowMessage('������������ ��������, ��������������� �������, �� �������');
 Panel1.Enabled:=true;
 bNoReplace.Visible:=false;
 bReplace.Visible:=false;
 bExit.Visible:=true;
 bStart.Visible:=true;
 bStop.Visible:=false;
 label5.Visible:=false;
 label2.Caption:='';
 if (DesigCom as TRedactor).NumSelected=0 then
   begin
     if rbLoc_SelCom.Checked then
       rbLoc_Form.Checked:=true;
     rbLoc_SelCom.Enabled:=false
   end
 else rbLoc_SelCom.Enabled:=true;
   EditExpr1.Text:='';

end;

procedure TFormFindExprErr.FormCreate(Sender: TObject);
begin
 EditExpr1.Text:='';
 rbLoc_SelCom:=RadioGroup1.Buttons[0];
 rbLoc_Form:=RadioGroup1.Buttons[1];
 rbLoc_All:=RadioGroup1.Buttons[2];
 //rbAct_InTable:=RadioGroup2.Buttons[2];
 rbAct_Selc:=RadioGroup2.Buttons[0];
 rbAct_UpOne:=RadioGroup2.Buttons[1];
 rbAct_NoSelc:=RadioGroup2.Buttons[2];
 IdentStrings:=TMyStringList.Create;
 rbLoc_SelCom.Checked:=true;
 rbAct_Selc.Checked:=true;
 rbAct_Selc.Checked:=true;
 rbLoc_SelCom.OnClick:=G1B1Click;
 rbLoc_Form.OnClick:=G1B1Click;
 rbLoc_All.OnClick:=G1B1Click;
 rbAct_Selc.OnClick:=G1B1Click;
 rbAct_UpOne.OnClick:=G1B1Click;
 //rbAct_InTable.OnClick:=G1B1Click;
 rbAct_NoSelc.OnClick:=G1B1Click;
 cboxFormCoose.OnChange:=G1B1Click;
 cboxFormCoose.Items.Clear;
 DialogExpr:=TDialogExpr.Create(Application);
 CompList:=TList.Create;
 ProgressBar1.Position:=0;
end;


procedure TFormFindExprErr.G1B1Click(sender: TObject);
begin
  if sender=rbLoc_SelCom then
    begin
      if (rbAct_Selc.Checked) or (rbAct_UpOne.Checked) then
            rbAct_NoSelc.Checked:=true;
            rbAct_Selc.Enabled:=false;
            rbAct_UpOne.Enabled:=false;
    end;

  if sender=rbLoc_Form then
    begin
            rbAct_Selc.Enabled:=true;
            rbAct_UpOne.Enabled:=true;
    end;

  if sender=rbLoc_All then
    begin
      if (rbAct_Selc.Checked) then
            rbAct_NoSelc.Checked:=true;
      rbAct_Selc.Enabled:=false;
      rbAct_UpOne.Enabled:=true;
    end;

  if (sender=rbAct_Selc) then
    begin
      //ColorStringGrid1.Visible:=false;
    end;

  if (sender=rbAct_NoSelc) then
    begin
      //ColorStringGrid1.Visible:=false;
    end;

  if (sender=rbAct_UpOne) or (sender=rbAct_NoSelc) then
    begin
      //ColorStringGrid1.Visible:=false;
      EditExpr1.Visible:=true;
    end;

  //if sender=rbAct_InTable then
   // begin
       //ColorStringGrid1.Visible:=true;
      // EditExpr1.Visible:=false;
   // end;

  if (sender=self.rbAct_Selc) or (sender=self.rbAct_NoSelc) then
    begin
      //ColorStringGrid1.Visible:=false;
      EditExpr1.Visible:=true;
    end;

  if sender=cboxFormCoose then
           if cboxFormCoose.items.IndexOf(cboxFormCoose.Text)>-1 then
               if cboxFormCoose.items.Objects[cboxFormCoose.items.IndexOf(cboxFormCoose.Text)]<>nil
                      then curform:=cboxFormCoose.items.Objects[cboxFormCoose.items.IndexOf(cboxFormCoose.Text)] as tform;

  if rbLoc_Form.Checked then
    begin
      cboxFormCoose.Visible:=true;
      if curform<>nil then cboxFormCoose.Text:=curform.Caption;
    end
  else cboxFormCoose.Visible:=false;

  label6.Visible:=cboxFormCoose.Visible;
  EditExpr1.Text:='';
  //ColorStringGrid1.RowCount:=0;
  //ColorStringGrid1.Cells[0,0]:='';

end;


procedure TFormFindExprErr.bExitClick(Sender: TObject);
begin
  Modalresult:=MrOk;
end;

procedure TFormFindExprErr.ExecFind;
var

  i, j: integer;
  Expr: TExpretion;
  TypeData: PTypeData;
  Props: PPropList;
  curObj: TComponent;
  findstr: string;
  findIdentStrings: TMyStringList;
  label rl;

  function AddPropertyList(Source: TObject; IdentStrings: TMyStringList; stringObjloc: string): boolean;
  var
    ExprStr: TExprStr;
    ChildProp: TObject;
    i: integer;
    Props: PPropList;
    lastForm: TForm;
    isSeach: boolean;
    prefobj: string;
  begin
   if DesigCom=nil then exit;
      result:=true;
   TypeData := GetTypeData(Source.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
       GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   try
     GetPropInfos(Source.ClassInfo, Props);
     if Source is TComponent then prefobj:='.'+ TComponent(Source).Name else
                prefobj:='.'+ Source.ClassName;
     for i := 0 to TypeData^.PropCount - 1 do
       if Props^[i]^.PropType^^.Name = 'TExprStr' then
        begin
         replase:=false;
         label2.Caption:='';
         ExprStr:=GetStrProp(Source, Props^[i]^.Name);
         isSeach:=not (DesigCom as TRedactor).CheckExprstr(exprstr);
         if isSeach  then
          begin
            replase:=false;
            inc(CountReplase);
            label2.Caption:=stringObj+prefobj+'.'+Props^[i]^.Name;
            if false then
              begin
              {  Application.ProcessMessages;
                if not isStop then
                  begin
                    IdentStrings.Add(GetStrProp(Source, Props^[i]^.Name));
                    if CompList.IndexOf(curObj)<0 then
                             CompList.Add(curObj);
                  end
                else exit    }
              end
            else
              begin
                if  isStop then
                   exit;
                if (rbAct_UpOne.Checked) then
                  begin
                    (DesigCom as TRedactor).DeleteSelected(false);
                    (DesigCom as TRedactor).SelectComponent(curObj);
                  //  if (curObj.owner is TForm) and (lastForm<>(curObj.owner as TForm)) then
                   //   begin
                    //   lastForm:=(curObj.owner as TForm);
                     //  lastForm.BringToFront;
                    //  end;

                  end;
                if CompList.IndexOf(curObj)<0 then
                             CompList.Add(curObj);
                EditExpr1.Text:=ExprStr;
                nextex:=false;
                application.ProcessMessages;
                BringToFront;
                if (rbAct_UpOne.Checked) or (rbAct_NoSelc.Checked) then
                                                                      EditExpr1.ReadOnly:=false;

                if not rbAct_Selc.Checked then
                          while not nextex do
                                      Application.ProcessMessages;
                if isStop then
                  begin
                    EditExpr1.ReadOnly:=true;
                    result:=false;
                    exit;
                  end;
                if replase then

                     begin
                       if (uppercase(EditExpr1.Text)<>uppercase(ExprStr)) and
                           ((rbAct_UpOne.Checked) or (self.rbAct_NoSelc.Checked)) then
                             begin
                              bNoReplace.visible:=false;
                              bReplace.Visible:=true;
                              bReplace.Caption:='�����';
                              if not ((DesigCom as TRedactor).CheckExprstr(EditExpr1.Text)) and
                                 not (ignoallerrrep) then
                                 begin
                                    if (ErrExprDialog(EditExpr1.Text)) then setStrProp(Source, Props^[i]^.Name,EditExpr1.Text);
                                 end
                              else
                                 setStrProp(Source, Props^[i]^.Name,EditExpr1.Text);
                             end;
                     end;

               Application.ProcessMessages;
               EditExpr1.ReadOnly:=true;
             end;
          end;
        end
       else
        if Props^[i]^.PropType^^.Kind = tkClass then
         begin
           ChildProp := GetObjectProp(Source, Props^[i]^.Name);
           if assigned(ChildProp) then
             AddPropertyList(ChildProp, IdentStrings,stringObj+prefobj);
           if isstop then exit;
         end;
   finally
     Freemem(Props);
   end;
  end;


begin
 findIdentStrings:=TMyStringList.Create;
 findIdentStrings.Duplicates := dupIgnore;
 findIdentStrings.Sorted := true;
 IdentStrings.Clear;
 Panel1.Enabled:=false;
 try
   Expr := TExpretion.Create;
   IdentStrings.Duplicates := dupIgnore;
   IdentStrings.Sorted := true;
   if rbLoc_Form.Checked then
    begin
     for i := 0 to curform.ComponentCount-1 do
      begin
        stringObj:=curform.Caption;
        curObj:=curform.Components[i];
        if not (curform.Components[i] is TContainerComponent) then
           if not AddPropertyList(curobj, IdentStrings,stringObj) or isstop then
             begin
               ProgressBar1.Position:=0;
              goto rl;
             end;
        if curform.ComponentCount>0 then
           ProgressBar1.Position:=round(100*i*1.0/(curform.ComponentCount*1.0));
      end;
    end
   else
    if rbLoc_All.Checked then
     begin
     for i := 0 to DesigCom.ComponentCount-1 do
        for j := 0 to DesigCom.Components[i].ComponentCount-1 do
         begin
            stringObj:=tform((DesigCom as TRedactor).Components[i]).caption;
            curObj:=(DesigCom as TRedactor).Components[i].Components[j];
            if not ((DesigCom as TRedactor).Components[i].Components[j] is TContainerComponent) then
               if not AddPropertyList(DesigCom.Components[i].Components[j], IdentStrings,stringObj) or isstop then
                  begin
                    ProgressBar1.Position:=0;
                    goto rl;
                  end;
            if DesigCom.ComponentCount*DesigCom.Components[i].ComponentCount>0 then
                 ProgressBar1.Position:=round(100*(i*DesigCom.Components[i].ComponentCount+j)*1.0/(DesigCom.ComponentCount*DesigCom.Components[i].ComponentCount*1.0));

         end;
     end
    else
     begin
       for j := 0 to (DesigCom as TRedactor).Count-1 do
         begin
           curObj:=((DesigCom as TRedactor).get(j) as TComponent);
           stringObj:=tform(curObj.Owner).caption;
           if not (curObj is TContainerComponent) then
               if not AddPropertyList(curObj , IdentStrings,stringObj) or isstop then
                  begin
                    ProgressBar1.Position:=0;
                    goto rl;
                  end;
           if (DesigCom as TRedactor).Count>0 then
                 ProgressBar1.Position:=round(100*(j)*1.0/((DesigCom as TRedactor).Count));
         end;
     end;

 rl:

 finally
   Expr.Free;
  
 end;

 if rbAct_Selc.Checked then
   begin
     (DesigCom as TRedactor).DeleteSelected(false);
       for i:=0 to CompList.Count-1 do
          (DesigCom as TRedactor).SelectComponent(TComponent(complist.items[i]));
     (DesigCom as TRedactor).PropertyForm;
       (DesigCom as TRedactor).PopMenuShowTegsforForm;
       Self.BringToFront;     
   end;

// if rbAct_InTable.Checked then
  // begin
        //ColorStringGrid1.RowCount:=IdentStrings.Count;
        //for i:=0 to IdentStrings.Count-1 do
          //ColorStringGrid1.Cells[0,i]:=IdentStrings.Strings[i];
  // end;
 findIdentStrings.Free;
end;

procedure TFormFindExprErr.bReplaceClick(Sender: TObject);
begin
 if isTableRep then
  begin
    bNoReplace.Visible:=false;
    bReplace.Visible:=false;
    bStart.Visible:=true;
    bNoReplace.Caption:='����������';
    bReplace.Caption:='��������';
    Panel1.Enabled:=true;
    ReplaceExpr;
    isTableRep:=false;
  end
 else
  begin
   nextex:=true;
   replase:=true;
  end;
end;

procedure TFormFindExprErr.bStopClick(Sender: TObject);
begin
  isStop:=true;
  nextex:=true;
end;

procedure TFormFindExprErr.FormDestroy(Sender: TObject);
begin
 CompList.Free;
 IdentStrings.Free;
 DialogExpr.Free;
end;

function TFormFindExprErr.ReplaseInExpr(sorsestr: String; findst: string; repstr: string): string;

begin
 result:=repstr;
end;

procedure TFormFindExprErr.bNoReplaceClick(Sender: TObject);
var i: integer;
begin
 if isTableRep then
  begin
     for i:=0 to IdentStrings.Count-1 do
          //ColorStringGrid1.Cells[0,i]:=IdentStrings.Strings[i];
     bNoReplace.Visible:=false;
     bReplace.Visible:=false;
     bStart.Visible:=true;
     bNoReplace.Caption:='����������';
     bReplace.Caption:='��������';
     Panel1.Enabled:=true;
     isTableRep:=false;
     ProgressBar1.Position:=100;
  end
 else
  nextex:=true;

end;

procedure TFormFindExprErr.bRepAllClick(Sender: TObject);
begin
 nextex:=true;
 replase:=true;
 bNoReplace.Visible:=false;
 bReplace.Visible:=false;
end;

procedure TFormFindExprErr.EditExpr1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if EditExpr1.ReadOnly then exit;
   bNoReplace.Visible:=true;
   bReplace.Visible:=true;
   bNoReplace.Caption:='����������';
   bReplace.Caption:='��������';
end;

procedure TFormFindExprErr.ReplaceExpr;
  var j,i,repindex: integer;
      TypeData: PTypeData;
       Expr: TExpretion;
 procedure ReplaceIdent(Source: TObject; SourceStr, DestinationStr: String);
  var
    ExprStr: TExprStr;
    ChildProp: TObject;
    i: integer;
    Props: PPropList;
    exprProp: TExprstr;
    Expr: TExpretion;
  begin
   Expr := TExpretion.Create;
   TypeData := GetTypeData(Source.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   try
     GetPropInfos(Source.ClassInfo, Props);
     for i := 0 to TypeData^.PropCount - 1 do
       if Props^[i]^.PropType^^.Name = 'TExprStr' then
        begin
         exprProp:=GetStrProp(Source, Props^[i]^.Name);
         if (ExprProp=SourceStr) then
         SetStrProp(Source, Props^[i]^.Name, DestinationStr);
        end
       else
        if Props^[i]^.PropType^^.Kind = tkClass then
         begin
           ChildProp := GetObjectProp(Source, Props^[i]^.Name);
           if assigned(ChildProp) then
               ReplaceIdent(ChildProp, SourceStr, DestinationStr);;
         end;
   finally
     Freemem(Props);
   end;
   Expr.Free;
  end;


begin
  Expr := TExpretion.Create;
           for j := 0 to IdentStrings.Count - 1 do
             //begin
            // if //ColorStringGrid1.Cells[0,i] <> IdentStrings.Strings[j] then
             // begin
             //�� ���� ���������� ������ ��������������
              // for i:=0 to CompList.Count-1 do
               //  ReplaceIdent(TComponent(complist.items[i]), IdentStrings.Strings[j], //ColorStringGrid1.Cells[0,j]);
              // IdentStrings.Replase(IdentStrings.Strings[j], //ColorStringGrid1.Cells[0,j]);
               // if CompList.Count>0 then ProgressBar1.Position:=round(100*i/CompList.Count);
               // Application.ProcessMessages;
             // end;
           // end;
 Expr.Free;
end;


procedure TFormFindExprErr.ColorStringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin

  bNoReplace.Visible:=true;
  bReplace.Visible:=true;
  bStart.Visible:=false;
  bNoReplace.Caption:='��������';
  bReplace.Caption:='��������';
  Panel1.Enabled:=false;
  isTableRep:=true;
  ProgressBar1.Position:=0;
end;

function TFormFindExprErr.ErrExprDialog(expval: string): boolean;
var ans: integer;
    Dialstr: string;
begin
   DialStr:='��������� '+expval +' ���������� � ���������� ������ �����������';
   result:=DialogExpr.Execute(DialStr);
end;


procedure TFormFindExprErr.ColorStringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 //if (DesigCom as TRedactor).CheckExprstr(//ColorStringGrid1.Cells[Acol,Arow]) then
    //ColorStringGrid1.Rows[arow].font.Color:=clGreen else //ColorStringGrid1.Rows[arow].font.Color:=clRed;
end;

end.
