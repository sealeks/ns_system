unit FormDelListU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormDelList = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
  private
    { Private declarations }
  public
    function GetStr(vl: TStringList): Tobject;
    { Public declarations }
  end;

var
  FormDelList: TFormDelList;

implementation

{$R *.dfm}



function TFormDelList.GetStr(vl: TStringList): TObject;
var i: integer;
begin
   result:=nil;
   if vl=nil then exit;
    self.ListBox1.Items.Assign(vl);
   if self.ShowModal=mrOk then
     begin
       for i:=0 to self.ListBox1.Items.Count-1 do
         if self.ListBox1.Selected[i] then
           begin
           result:=vl.Objects[i];
           exit;
           end;
     end;
end;

end.
