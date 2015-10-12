unit FormDTU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,DateUtils;

type
  TFormDT = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    FromDate: TDateTimePicker;
    EndDate: TDateTimePicker;
    FromHour: TEdit;
    FromHourUpDown: TUpDown;
    EndHourUpDown: TUpDown;
    EndHour: TEdit;
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
     FromDate.DateTime:=st1;
     EndDate.DateTime:=sp1;
     if self.ShowModal=MrOK then
       begin
          if FromDate.DateTime<EndDate.DateTime then
            begin
               st:=FromDate.DateTime;
               sp:=EndDate.DateTime;
               result:=true;
            end;

       end;
end;




end.
