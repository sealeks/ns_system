unit DialogExprU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TDialogExpr = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute(val: string): boolean;
    { Public declarations }
  end;

var
  DialogExpr: TDialogExpr;

implementation

uses FormFindExprU;



 function TDialogExpr.Execute(val: string): boolean;
 begin
   self.Label1.Caption:=val;
   if Showmodal=MrNo then result:=false else result:=true;
 end;

{$R *.dfm}

procedure TDialogExpr.Button1Click(Sender: TObject);
begin
 // ignoerrep:=true;
end;

procedure TDialogExpr.Button2Click(Sender: TObject);
begin
  ignoallerrrep:=true;
end;

end.
