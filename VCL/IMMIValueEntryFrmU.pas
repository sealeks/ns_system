unit IMMIValueEntryFrmU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;
type
  TImmiValueEntryFrm = class(TForm)
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button13: TButton;
    Button12: TButton;
    Button14: TButton;
    Button15: TButton;
    Button2: TButton;
    Edit1: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function ShowModalAt (Sender: TControl): integer;
  private
    { Private declarations }
  protected
  public
    { Public declarations }
    value: single;
    minValue, MaxValue: real;
  end;

var
  ImmiValueEntryFrm: TImmiValueEntryFrm;

implementation

{$R *.DFM}

procedure TImmiValueEntryFrm.FormCreate(Sender: TObject);
begin
  inherited;
  width := 152;
  height := 194;
end;


procedure TImmiValueEntryFrm.Button3Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('1'), 0);
end;

procedure TImmiValueEntryFrm.Button4Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('2'), 0);
end;

procedure TImmiValueEntryFrm.Button5Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('3'), 0);
end;

procedure TImmiValueEntryFrm.Button6Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('4'), 0);
end;

procedure TImmiValueEntryFrm.Button7Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('5'), 0);
end;

procedure TImmiValueEntryFrm.Button8Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('6'), 0);
end;

procedure TImmiValueEntryFrm.Button9Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('7'), 0);
end;

procedure TImmiValueEntryFrm.Button10Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('8'), 0);
end;

procedure TImmiValueEntryFrm.Button11Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('9'), 0);
end;

procedure TImmiValueEntryFrm.Button13Click(Sender: TObject);
begin
  Edit1.Perform(WM_char, ord('0'), 0);
end;

procedure TImmiValueEntryFrm.Button12Click(Sender: TObject);
begin
  if Edit1.Text[1] = '-' then
    Edit1.Text := copy (Edit1.Text, 2, Length(Edit1.Text) - 1)
  else
    Edit1.Text := '-' + Edit1.Text;
end;

procedure TImmiValueEntryFrm.Button14Click(Sender: TObject);
begin
  if pos(',', Edit1.Text) = 0 then
    Edit1.Perform(WM_char, ord(','), 0);
end;

procedure TImmiValueEntryFrm.Button15Click(Sender: TObject);
begin
  Edit1.Text := copy(Edit1.Text, 1, length(Edit1.Text) - 1);
end;


procedure TImmiValueEntryFrm.Button1Click(Sender: TObject);
var
  newVal: real;
begin
  try
    newVal := strtofloat(edit1.text);
  except
    raise Exception.create ('Ќеправильное вещественное значение');
  end;
  if (newVal < minValue) or
               (NewVal > MaxValue) then
       raise exception.create (
                format('«начение за допустимыми пределами (min=%8.2f, max=%8.2f)',
                                                [minValue, maxValue]));
  Value := NewVal;
  ModalResult := mrOk;
end;

procedure TImmiValueEntryFrm.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TImmiValueEntryFrm.FormShow(Sender: TObject);
begin
  inherited;
  Edit1.Text := floattostr(Value);
  edit1.SetFocus;
end;

procedure TImmiValueEntryFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if activeControl <> Edit1 then
    Edit1.Perform(WM_CHAR, Key, 0);
end;

function TImmiValueEntryFrm.ShowModalAt(Sender: TControl): integer;
begin
      top := Sender.ClientToScreen(Point(0, 0)).Y - 30;
      left := sender.ClientToScreen(Point(0, 0)).X;
      if (left + sender.width + width > screen.width) then left := left - width
        else left := left + sender.width;
      result := ShowModal;
end;

end.
