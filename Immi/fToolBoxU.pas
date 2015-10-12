unit fToolBoxU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, ToolWin, constDef, ImgList;

type

  TfToolBox = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolBar2: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    TabSheet3: TTabSheet;
    ToolBar3: TToolBar;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fMode: integer;
    procedure SetMode(const Value: integer);
    { Private declarations }
  public
    { Public declarations }
    property Mode: integer read fMode write SetMode;
    procedure WMIMMIITEMCREATED (var Msg: TMessage); message WM_IMMIITEMCREATED;
  end;

var
  fToolBox: TfToolBox;

implementation

uses fTopMenuU;

{$R *.dfm}

procedure TfToolBox.ToolButton1Click(Sender: TObject);
begin
  Mode := (sender as TToolButton).Tag;
end;

procedure TfToolBox.FormHide(Sender: TObject);
var
  i: integer;
begin
 // Mode := tmRun;
 // fTopMenu.nToolBox.Checked := false;
 // for i := 1 to toolBar1.buttonCount - 1 do
 //   toolBar1.buttons[i].down := false;

end;

procedure TfToolBox.SetMode(const Value: integer);
begin
  fMode := Value;
  toolMode := fMode;
  SendMessageBroadcast(WM_IMMIMODECHANGED, toolMode, 0);
  PageControl1Change(Self);
end;

procedure TfToolBox.PageControl1Change(Sender: TObject);
var
  i, j, k: integer;
begin
  with pageControl1 do
  for i := 0 to PageCount - 1 do
    with Pages[i] do
    for j := 0 to ControlCount - 1 do
      if controls[j] is TToolBar then
        with controls[j] as TToolBar do
        for k := 0 to ButtonCount - 1 do
          with Buttons[k] do
            if Tag = toolMode then down := true else down := false;
end;

procedure TfToolBox.FormActivate(Sender: TObject);
begin
  PageControl1Change(self);
end;

procedure TfToolBox.FormShow(Sender: TObject);
begin
  Mode := tmPoint;
end;

procedure TfToolBox.WMIMMIITEMCREATED(var Msg: TMessage);
begin
  Mode := tmPoint;
end;

end.
