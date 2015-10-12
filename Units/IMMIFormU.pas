unit IMMIFormU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, StdCtrls, ExtCtrls, Menus, Buttons,
  MemStructsU, ConstDef,
  IMMILabelU,
  IMMITrackBar, IMMIBitBtn, IMMIEditReal, IMMISpeedButton,
  IMMIShape, IMMIImage, IMMIControls, calcU1, IMMIImg, IMMIImg1;

type
  TIMMIForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure Show;
    function ShowModal: integer; override;
    procedure Hide;
    procedure UpdateValue;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FPicture: TPicture;
    procedure SetPicture(const Value: TPicture);
  public
    { Public declarations }
    procedure IMMIUpdate (var msg: TMessage); message WM_IMMIUPDATE;
    procedure IMMIBlinkOn (var msg: TMessage); message WM_IMMIBLINKON;
    procedure IMMIBlinkOff (var msg: TMessage); message WM_IMMIBLINKOFF;
    procedure SaveToFile(FileName: string);
    procedure LoadFromFile(FileName: string);
  end;

var
  IMMIForm: TIMMIForm;

implementation


{$R *.DFM}

procedure TIMMIForm.IMMIUpdate (var msg: TMessage);
begin
  broadcast (msg);
end;

procedure TIMMIForm.IMMIBlinkOn (var msg: TMessage);
begin
  broadcast (msg);
end;

procedure TIMMIForm.IMMIBlinkOff (var msg: TMessage);
begin
  broadcast (msg);
end;


procedure TIMMIForm.Show;
begin
  if visible then hide;
  //define rtID for spetial component, inc rtLink Counter
   notifyControls (WM_IMMIInit);
   notifyControls (WM_IMMIUpdate);
   postMessage(Handle, WM_IMMIUpdate, 0, 0);
  inherited Show;
end;

function TIMMIForm.ShowModal: integer;
begin
  if visible then hide;
  //define rtID for spetial component, inc rtLink Counter
   notifyControls (WM_IMMIInit);
   postMessage(Handle, WM_IMMIUpdate, 0, 0);
  result := inherited ShowModal;
end;

procedure TIMMIForm.Hide;
begin
        if Visible then begin
          //define rtID for spetial component, inc rtLink Counter
         notifyControls (WM_IMMIUnInit);
     end;
     inherited Hide;
end;

procedure TIMMIForm.UpdateValue;
begin
        if Visible then begin
          //define rtID for spetial component, inc rtLink Counter
         notifyControls (WM_IMMIUpdate);
     end;
end;

procedure TIMMIForm.FormCreate(Sender: TObject);
begin
  top := 20;
  left := 0;
  case resolution of
  r640:
    begin
     height := 370;
     width := 640;
    end;
  r800:
    begin
     height := 435;
     width := 800;
    end;
  r1024:
    begin
     height := 603;
     width := 1024;
    end;
  end;
end;
procedure TIMMIForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     if Visible then Hide;
end;

procedure TIMMIForm.SaveToFile(FileName: string);
var
 f: TextFile;
 str: string;
begin
  assignFile (f, FileName);
  str := '';
  if fileExists (FileName) then
    append (f)
  else rewrite (f);
  try
    if str <> name then writeLn(f, name);
    writeln (f, top);
    writeln (f, left);
    writeln (f, height);
    writeln (f, width);
  finally
    system.close(f);
  end;
end;

procedure TIMMIForm.LoadFromFile(FileName: string);
var
  f: textFile;
  str: string;
  temp: integer;
begin
  assignFile (f, FileName);
  reset(f);
  try
    repeat readLn(f, str); until (str = Name) or EOF(f);
    if str <> name then exit;
    Readln (f, temp); top := temp;
    Readln (f, temp); left := temp;
    Readln (f, temp); height := temp;
    Readln (f, temp); width := temp;
  finally
    system.close(f);
  end;
end;

procedure TIMMIForm.SetPicture(const Value: TPicture);
begin
  FPicture := Value;
end;

end.

