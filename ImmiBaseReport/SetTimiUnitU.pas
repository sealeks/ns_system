unit SetTimiUnitU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ComCtrls, ToolWin, ExtCtrls,ConstDef;

type
  TSetTimeForm = class(TForm)
    PanelBase: TPanel;
    ToolBar1: TToolBar;
    TbCustom: TToolButton;
    BaseTimePicker: TDateTimePicker;
    BaseDatePicker: TDateTimePicker;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    PanelCustom: TPanel;
    Label2: TLabel;
    TimePickerC1: TDateTimePicker;
    DatePickerC1: TDateTimePicker;
    Button3: TButton;
    Button4: TButton;
    ImageList1: TImageList;
    TbBase: TToolButton;
    TimePickerC2: TDateTimePicker;
    DatePickerC2: TDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    procedure BaseTimePickerChange(Sender: TObject);
    procedure BaseDatePickerChange(Sender: TObject);
    procedure TbBaseClick(Sender: TObject);
    procedure TimePickerC1Change(Sender: TObject);
    procedure DatePickerC2Change(Sender: TObject);
  private
    ftmstt: TDateTime;
    ftmstp: TDateTime;
    fcustom: boolean;
    ftp: integer;
    fdelt: integer;
    fsub: integer;
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateView;
    function Exec(tp: integer; var tmstt: TDateTime; var tmstp: TDateTime;
     var custom: boolean; delt: integer;
     sub: integer): boolean;
  end;

var
  SetTimeForm: TSetTimeForm;



implementation

uses RepOfficeF;

{$R *.dfm}

function formatTimeByTipe(tp: integer; cust: boolean): string;
begin
   result:='';
   if not cust then
   begin
   case tp of
   REPORTTYPE_MIN: result:='HH';
   REPORTTYPE_10MIN: result:='HH';
   end;
   end else
   begin
   case tp of
   REPORTTYPE_MIN: result:='HH:mm';
   REPORTTYPE_HOUR: result:='HH';
   REPORTTYPE_10MIN: result:='HH:mm';
   REPORTTYPE_30MIN: result:='HH:mm';
   end;
   end;
end;

function formatDateByTipe(tp: integer; cust: boolean): string;
begin
   result:='';
   if not cust then
   begin
   case tp of
   REPORTTYPE_YEAR: result:='yyyy';
   REPORTTYPE_MIN:  result:='dd.MM.yyyy';
   REPORTTYPE_HOUR: result:='dd.MM.yyyy';
   REPORTTYPE_DEC:  result:='MM.yyyy';
   REPORTTYPE_DAY:  result:='MM.yyyy';
   REPORTTYPE_MONTH: result:='yyyy';
   REPORTTYPE_10MIN: result:='dd.MM.yyyy';
   REPORTTYPE_30MIN: result:='dd.MM.yyyy';
   REPORTTYPE_QVART: result:='yyyy';
   end;
   end else
   begin
   case tp of
   REPORTTYPE_YEAR: result:='yyyy';
   REPORTTYPE_MIN:  result:='dd.mm.yyyy';
   REPORTTYPE_HOUR: result:='dd.mm.yyyy';
   REPORTTYPE_DEC:  result:='dd.mm.yyyy';
   REPORTTYPE_DAY:  result:='dd.mm.yyyy';
   REPORTTYPE_MONTH: result:='mm.yyyy';
   REPORTTYPE_10MIN: result:='dd.mm.yyyy';
   REPORTTYPE_30MIN: result:='dd.mm.yyyy';
   REPORTTYPE_QVART: result:='mm.yyyy';
   end;
   end;
end;


function TSetTimeForm.Exec(tp: integer; var tmstt: TDateTime; var tmstp: TDateTime;
 var custom: boolean; delt: integer;
    sub: integer): boolean;
begin
  result:=false;
  ftmstt:=tmstt;
  ftmstp:=tmstp;
  fcustom:=custom;
  ftp:=tp;
  fdelt:=delt;
  fsub:=sub;
  UpdateView;
  if (ShowModal=mrOk) then
    begin
      result:=true;
      tmstt:=ftmstt;
      tmstp:=ftmstp;
      custom:=fcustom;
    end;
end;

procedure TSetTimeForm.UpdateView;
begin
  TbCustom.visible:=fcustom;
  PanelCustom.Visible:=fcustom;
  TbBase.visible:=not fcustom;
  PanelBase.Visible:=not fcustom;
  BaseTimePicker.Format:=formatTimeByTipe(ftp,fcustom);
  BaseDatePicker.Format:=formatDateByTipe(ftp,fcustom);
  BaseTimePicker.Visible:=(BaseTimePicker.Format<>'');
  BaseTimePicker.DateTime:=ftmstt;
  BaseDatePicker.DateTime:=ftmstt;
  TimePickerC1.DateTime:=ftmstt;
  TimePickerC2.DateTime:=ftmstp;
  DatePickerC1.DateTime:=ftmstt;
  DatePickerC2.DateTime:=ftmstp;
  TimePickerC1.Format:=formatTimeByTipe(ftp,fcustom);
  DatePickerC1.Format:=formatDateByTipe(ftp,fcustom);
  TimePickerC2.Format:=formatTimeByTipe(ftp,fcustom);
  DatePickerC2.Format:=formatDateByTipe(ftp,fcustom);
  TimePickerC1.Visible:=(TimePickerC1.Format<>'');
  TimePickerC2.Visible:=(TimePickerC2.Format<>'');
  BaseTimePicker.DateTime:=ftmstt;
  BaseDatePicker.DateTime:=ftmstt;
end;


procedure TSetTimeForm.BaseTimePickerChange(Sender: TObject);
var tmp: TDateTime;
begin
 tmp:=trunc(BaseDatePicker.DateTime)+
            (BaseTimePicker.DateTime-trunc(BaseTimePicker.DateTime));
 RepincSubPeriod(ftp,tmp,-fdelt);
 CalculateRepPeriod(tmp,ftp,ftmstt,ftmstp,  fdelt, fsub);
 UpdateView;
end;

procedure TSetTimeForm.BaseDatePickerChange(Sender: TObject);
var tmp: TDateTime;
begin
 tmp:=trunc(BaseDatePicker.DateTime)+
            (BaseTimePicker.DateTime-trunc(BaseTimePicker.DateTime));
 RepincSubPeriod(ftp,tmp,-fdelt);
 CalculateRepPeriod(tmp,ftp,ftmstt,ftmstp,  fdelt, fsub);
 UpdateView;
end;

procedure TSetTimeForm.TbBaseClick(Sender: TObject);
begin
fcustom:=not fcustom;
if not fcustom then
  begin
    CalculateRepPeriod((ftmstt+ftmstp)/2,ftp,ftmstt,ftmstp,  fdelt, fsub);
  end;
UpdateView;
end;

procedure TSetTimeForm.TimePickerC1Change(Sender: TObject);
var tmp: TdateTime;
begin
tmp:=trunc(DatePickerC1.DateTime)+
            (TimePickerC1.DateTime-trunc(TimePickerC1.DateTime));

ftmstt:=tmp;
end;

procedure TSetTimeForm.DatePickerC2Change(Sender: TObject);
var tmp: TdateTime;
begin
tmp:=trunc(DatePickerC2.DateTime)+
            (TimePickerC2.DateTime-trunc(TimePickerC2.DateTime));

ftmstp:=tmp;
end;

end.
