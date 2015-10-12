unit FormDTU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,DateUtils;

type
  TFormDT = class(TForm)
    Label1: TLabel;
    FromDate: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    function Exec(var st, sp:TdateTime; f: integer): boolean;
    { Public declarations }
  end;

var
  FormDT: TFormDT;

implementation

{$R *.dfm}

function TFormDT.Exec(var st, sp:TdateTime; f: integer): boolean;
var st1,sp1: TdateTime;
begin
     result:=false;
     st1:=st;
     sp1:=sp;
     if ((st1=0) or (sp1=0) or (st1>=sp1)) then
       begin
        st1:=incDay(Now,-1);
        sp1:=Now;
       end;
     FromDate.DateTime:=trunc(st1);



     if self.ShowModal=MrOK then
       begin

            begin
               st:=FromDate.DateTime;



               result:=true;
            end;

       end;
end;




end.
