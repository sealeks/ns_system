unit FormComponentU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Ex_Grid, Ex_Inspector, ObjInsp1, ComCtrls, StdCtrls,
  ToolWin, ExtCtrls;

type
  TFormComponent = class(TForm)
    ImageList6: TImageList;
    ImageList7: TImageList;
    Panel10: TPanel;
    Panel11: TPanel;
    ToolBar4: TToolBar;
    ExprOnBut: TToolButton;
    IntBut: TToolButton;
    StrBut: TToolButton;
    FlBut: TToolButton;
    EnBut: TToolButton;
    setBut: TToolButton;
    clBut: TToolButton;
    AllBut: TToolButton;
    ExprOnlBut: TToolButton;
    Panel9: TPanel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ObjInsp11: TObjInsp1;
    TabSheet2: TTabSheet;
    ObjInsp12: TObjInsp1;
    TabSheet3: TTabSheet;
    ObjInsp13: TObjInsp1;
    procedure ExprOnButClick(Sender: TObject);
    procedure IntButClick(Sender: TObject);
    procedure StrButClick(Sender: TObject);
    procedure FlButClick(Sender: TObject);
    procedure EnButClick(Sender: TObject);
    procedure setButClick(Sender: TObject);
    procedure clButClick(Sender: TObject);
    procedure AllButClick(Sender: TObject);
    procedure ExprOnlButClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
  public
    procedure UpdateObjPaint;
    procedure setvalid;
    { Public declarations }
  end;

var
  FormComponent: TFormComponent;

implementation
uses mainFormRedactorU;
{$R *.dfm}

procedure TFormComponent.ExprOnButClick(Sender: TObject);
begin
  if tpExprString in  ObjInsp11.ShowProperty then
     ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty-[tpExprString]
  else
     ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty+[tpExprString];
  UpdateObjPaint;
  activred.PropertyForm;
end;

procedure TFormComponent.IntButClick(Sender: TObject);
begin
 if tpInteger in  ObjInsp11.ShowProperty then
    ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty-[tpInteger]
 else
    ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty+[tpInteger];
  UpdateObjPaint;
  activred.PropertyForm;
end;

procedure TFormComponent.StrButClick(Sender: TObject);
begin
 if tpString in  ObjInsp11.ShowProperty then
    ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty-[tpString]
 else
    ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty+[tpString];
  UpdateObjPaint ;
  activred.PropertyForm;
end;

procedure TFormComponent.FlButClick(Sender: TObject);
begin
   if tpFloat in  ObjInsp11.ShowProperty then
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty-[tpFloat]
   else
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty+[tpFloat];
  UpdateObjPaint;
  activred.PropertyForm;
end;

procedure TFormComponent.EnButClick(Sender: TObject);
begin
   if tpEnumeration in  ObjInsp11.ShowProperty then
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty-[tpEnumeration]
   else
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty+[tpEnumeration];
  UpdateObjPaint;
  activred.PropertyForm;
end;

procedure TFormComponent.setButClick(Sender: TObject);
begin
  if tpSet in  ObjInsp11.ShowProperty then
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty-[tpSet]
  else
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty+[tpset];
  UpdateObjPaint;
  activred.PropertyForm;
end;

procedure TFormComponent.clButClick(Sender: TObject);
begin
   if tpClass in  ObjInsp11.ShowProperty then
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty-[tpClass]
   else
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty+[tpClass];
  UpdateObjPaint;
  activred.PropertyForm;
end;

procedure TFormComponent.AllButClick(Sender: TObject);
begin
   ObjInsp11.ShowProperty:=[tpExprString,tpInteger,tpstring,tpSet,tpClass,tpEnumeration,tpFloat];
   UpdateObjPaint;
   activred.PropertyForm;
end;

procedure TFormComponent.ExprOnlButClick(Sender: TObject);
begin
   if tpExprOnly in  ObjInsp11.ShowProperty then
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty-[tpExprOnly]
   else
      ObjInsp11.ShowProperty:=self.ObjInsp11.ShowProperty+[tpExprOnly];
     UpdateObjPaint;
   activred.PropertyForm;
end;

procedure TFormComponent.PageControl1Change(Sender: TObject);
begin
   if activred=nil then exit;
   ToolBar4.Enabled:=(PageControl1.ActivePage=TabSheet1);
   activred.objIn:=TObjInsp1(PageControl1.ActivePage.Controls[0]);
   TObjInsp1(PageControl1.ActivePage.Controls[0]).IDesig:=activred;
   activred.objIn.ShowS(activred);
end;

procedure TFormComponent.UpdateObjPaint;
begin
  if (tpExprString in  ObjInsp11.ShowProperty) and not (tpExprOnly in  ObjInsp11.ShowProperty) then  ExprOnBut.Down:=true else ExprOnBut.Down:=false;
  if (tpInteger in  ObjInsp11.ShowProperty) and not (tpExprOnly in  ObjInsp11.ShowProperty) then  IntBut.Down:=true else IntBut.Down:=false;
  if (tpString in  ObjInsp11.ShowProperty) and not (tpExprOnly in  ObjInsp11.ShowProperty)  then  StrBut.Down:=true else StrBut.Down:=false;
  if (tpFloat in  ObjInsp11.ShowProperty) and not (tpExprOnly in  ObjInsp11.ShowProperty)  then  FlBut.Down:=true else FlBut.Down:=false;
  if (tpEnumeration in  ObjInsp11.ShowProperty) and not (tpExprOnly in  ObjInsp11.ShowProperty)  then  EnBut.Down:=true else EnBut.Down:=false;
  if (tpSet in  ObjInsp11.ShowProperty) and not (tpExprOnly in  ObjInsp11.ShowProperty)  then  setBut.Down:=true else SetBut.Down:=false;
  if (tpClass in  ObjInsp11.ShowProperty) and not (tpExprOnly in  ObjInsp11.ShowProperty)  then  clBut.Down:=true else ClBut.Down:=false;
  if (ObjInsp11.ShowProperty=[tpExprString,tpInteger,tpstring,tpSet,tpClass,tpEnumeration,tpFloat]) and not (tpExprOnly in  ObjInsp11.ShowProperty)  then
   AllBut.Down:=true else allBut.Down:=false;
  if (tpExprOnly in  ObjInsp11.ShowProperty) then  ExprOnlBut.Down:=true else ExprOnlBut.Down:=false;
end;

procedure TFormComponent.setvalid;
begin
    TabSheet2.TabVisible:=activred.ScriptValid;
end;

end.
