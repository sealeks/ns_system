unit UpdateTrDfU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,globalValue,
  Dialogs, ComCtrls, StdCtrls, MainDataModuleU, DBManagerFactoryU, MemStructsU, ConstDef;

type
  TFormTrDfUpdate = class(TForm)
    rewrite: TCheckBox;
    delold: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    ProgressBar1: TProgressBar;
    procedure Button2Click(Sender: TObject);
  private
    frtit: TanalogMems;
    trdf: TTrenddefList;
    Thread: TTrendDefThread;
    flst: TTrenddefList;
    { Private declarations }
  public
    constructor Create(owner: TComponent);
    destructor destroy;
    function Exec(rtit: TanalogMems; lst: TTrenddefList): boolean;
    procedure Prepare;
    function Write: integer;
    procedure Progress (progress: integer;  err: integer);
    procedure Complete (err: integer);
    { Public declarations }
  end;

var
  FormTrDfUpdate: TFormTrDfUpdate;

implementation

{$R *.dfm}


constructor TFormTrDfUpdate.Create(owner: TComponent);
begin
  inherited create(owner);
  trdf:=TTrenddefList.create;
  Thread:=nil;
end;

destructor TFormTrDfUpdate.destroy;
begin
   trdf.Free;
end;

function TFormTrDfUpdate.Exec(rtit: TanalogMems; lst: TTrenddefList): boolean;
begin
   result:=false;
   frtit:=rtit;
   flst:=lst;
   if self.ShowModal=MrOk then
     result:=true;
   Button1.Enabled:=true;
   Button2.Enabled:=true;

end;

procedure TFormTrDfUpdate.Prepare;
var i,cod: integer;
begin
  trdf.Clear;
  for i:=0 to frtit.Count-1 do
   begin
     if frtit[i].ID>-1 then
     begin
      if (rewrite.Checked) or ((flst<>nil) and (flst.Count=0)) then
        begin
        cod:=frtit[i].ID;
    //    if cod=1011 then
        // cod:=1011;
        end
        else cod:=-1;
        trdf.AddItems( cod,
              frtit.GetName(i),
              frtit.GetComment(i),
              frtit.GetEU(i),
              frtit[i].MinEu,
              frtit[i].MaxEu,
              frtit[i].MinRaw,
              frtit[i].MaxRaw,
              frtit[i].logDB,
              frtit[i].logTime,
              frtit[i].TimeStamp,
              frtit[i].OnMsged,
              frtit[i].OffMsged,
              frtit[i].Alarmed or frtit[i].AlarmedLocal,
              frtit[i].Logged
        )
     end;
   end;
end;

function TFormTrDfUpdate.Write;
begin

end;

procedure TFormTrDfUpdate.Progress (progress: integer;  err: integer);
begin
  self.ProgressBar1.Position:=progress;
end;

procedure TFormTrDfUpdate.Complete (err: integer);
begin
  if err=NSDB_REQEST_OK then
   begin
    self.ModalResult:=MrOk;
   end else
   begin
   NSDBErrorMessage(err);
   self.ModalResult:=MrOk;
   end;

end;

procedure TFormTrDfUpdate.Button2Click(Sender: TObject);
begin
   Prepare;
   Thread:=TTrendDefThread.create(dbmanager,connectionstr,trdf,
   Progress, Complete ,tdoUpdate, rewrite.Checked, delold.Checked);
   Button1.Enabled:=false;
   Button2.Enabled:=false;
end;

end.
