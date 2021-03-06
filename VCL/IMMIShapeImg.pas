 unit IMMIShapeImg;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  ExtCtrls,
  StdCtrls,
  Graphics,
  constDef,IMMIShape,
  memStructsU,
  Expr, ImControlBridge,
  IMMIShapeEditorU;

 type

  TIMMIShapeForm = class(TShape)
  private
    { Private declarations }
    fFillRec: tFillRec;
    fvalue: single;
    fExpr: tExpretion;
    fExprString: TExprStr;
    fMinValue, fMaxValue: single;
    //Check visibility
    fExprVisible: tExpretion;
    fExprVisibleString: TExprStr;
    fExprPrString,fExprAvString: TExprStr;
    facolor, fpcolor, fccolor: TColor;
    fExprPr,fExprAv: TExpretion;
    fPicture: TBitmap;
    ffillForm: boolean;
   // fCollar: TImControlBridge;

    procedure SetValue (val: single);

  protected
   // procedure SetCollar(value: TImControlBridge);
    { Protected declarations }
    procedure SetPicture(value: TBitMap);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    procedure SetFillRec(fr: tFillrec);
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ShowPropForm;
    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
  published
    { Published declarations }
    property ifillRec: tFillRec read fFillRec write SetFillRec;
    property ivalue: single read fValue write SetValue;
    property iminValue: single read fminValue write fminValue;
    property imaxValue: single read fmaxValue write fmaxValue;
    property iExpr: TExprStr read fExprString write fExprString;
    property iExprVisible: TExprStr read fExprVisibleString write fExprVisibleString;
    property ExprAv: TExprStr read fExprAvString write fExprAvString;
    property ExprPr: TExprStr read fExprPrString write fExprPrString;
    property aColor: TColor read facolor write facolor;
    property pColor: TColor read fpcolor write fpcolor;
    property Picture: TBitmap read FPicture write SetPicture;
    property fillForm: boolean read ffillForm write ffillForm;
   end;

implementation

{*.dcr}
{*******************TFillRec**********************}




{*******************TFillRec**********************}
constructor TIMMIShapeForm.Create(AOwner: TComponent);
begin
     inherited;
     ffillRec := TFillRec.Create;
     fpicture := Tbitmap.Create;
     iMinValue := 0;
     iMaxValue := 100;
     iValue := 0;
end;

 procedure TIMMIShapeForm.SetPicture(value: TBitMap);
begin
   fPicture.Assign(value);
   brush.Bitmap:=self.fpicture;
   Paint;
end;

procedure TIMMIShapeForm.ImmiInit (var Msg: TMessage);
begin
  CreateAndInitExpretion(fExpr, fExprString);
  CreateAndInitExpretion(fExprVisible, fExprVisibleString);
  if fExprAvString<>'' then  CreateAndInitExpretion(fExprAv, fExprAvString);
  if fExprPrString<>'' then  CreateAndInitExpretion(fExprPr, fExprPrString);
 // if fcollar<>nil then fCollar.ImmiInit;
end;

procedure TIMMIShapeForm.ImmiUnInit (var Msg: TMessage);
begin
  if assigned(fExpr) then fExpr.ImmiUnInit;
  if assigned(fExprVisible) then fExprVisible.ImmiUnInit;
  if assigned(fExprAv) then fExprAv.ImmiUnInit;
  if assigned(fExprPr) then fExprPr.ImmiUnInit;
 // if fcollar<>nil then fCollar.ImmiUnInit;
end;

procedure TIMMIShapeForm.ImmiUpdate;
var lastcolor: Tcolor;
begin
    lastcolor:=fccolor;
    fccolor:=ifillrec.Brush.Color;
       if  assigned(fExprPr) then
         begin
            fExprPr.ImmiUpdate;
            if fExprPr.isTrue then
            begin
            fccolor:=fpcolor;
            end;
         end;

       if  assigned(fExprAv) then
         begin
            fExprAv.ImmiUpdate;
            if fExprAv.isTrue then
             begin
              fccolor:=facolor;

             end;
         end;
 // if  lastcolor<>fccolor then refresh;
  if assigned(fExpr) then
  begin
     fExpr.ImmiUpdate;
     ivalue := fExpr.Value;
  end;
  if assigned(fExprVisible) then
  begin
     fExprVisible.ImmiUpdate;
     visible := fExprVisible.isTrue;
  end;
  //if fcollar<>nil then fCollar.immiupdate;
end;

procedure TIMMIShapeForm.Paint;
var
  X, Y, W, H, S: Integer;
  percentFill: real;
  srsRct, dstRct: TRect;
  tempImg: TImage;

begin

  percentFill := 100 / (imaxValue - iminValue) *
                                           (iValue - iminValue);
//������ ������� ������ ������ ������ � ��������� ��� �� �������
//������ ������ ������� � ��������� �������

  srsRct.Top := 0;
  srsRct.Left := 0 ;
  srsRct.Bottom := height;
  srsRct.Right := width;
  tempImg := TImage.Create(nil);
  tempImg.height := self.Height;
  tempImg.width := self.Width;
  if ffillform then
  begin
    if (self.Align<>alClient) then
      if not (csDesigning in componentstate) then
        begin
          Align:=alClient;
          pen.Style:=psClear;
          pen.Width:=0;
          self.SendToBack;
        end;
  end;
  with tempImg.canvas do
  begin
    //�������� ��� � ��������
    CopyRect(srsRct, Canvas, srsRct);
    //��������������� ������
    Pen := self.Pen;
    Brush := Self.Brush;
    brush.Bitmap:=fpicture;
    X := Pen.Width div 2;
    Y := X;
    W := self.Width - Pen.Width + 1;
    H := self.Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then S := W else S := H;
    if Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    //������ ������ ������ ����
    case Shape of

      stRectangle, stSquare:
        Rectangle(X, Y, X + W, Y + H);
      stRoundRect, stRoundSquare:
        RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
      stCircle, stEllipse:
        Ellipse(X, Y, X + W, Y + H);
    end;
    //������������ ��� ��������������
    case ifillRec.fillStyle of
      fsUp: begin
        dstRct.TopLeft := point(X, Y);
        dstRct.BottomRight := Point(X + W, Y + round(H  * (100 - PercentFill) / 100));
      end;
      fsDown: begin
        dstRct.TopLeft := point(X, Y + round(H  * PercentFill / 100));
        dstRct.BottomRight := Point(X + W, Y + H);
      end;
      fsLeft: begin
        dstRct.TopLeft := point(X, Y);
        dstRct.BottomRight := Point(X + round(W  * (100 - PercentFill) / 100), Y + H);
      end;
      fsRight: begin
        dstRct.TopLeft := point(X + round(W  * PercentFill / 100), Y);
        dstRct.BottomRight := Point(X + W, Y + H);
      end;
    end;
    //�������� ��� �� �������
    canvas.CopyRect(dstRct, tempImg.Canvas, dstrct);

    //�������� ���� �������
    Brush.Color := fccolor;
    //������ ������ ������ �������
    case Shape of
      stRectangle, stSquare:
        Rectangle(X, Y, X + W, Y + H);
      stRoundRect, stRoundSquare:
        RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
      stCircle, stEllipse:
        Ellipse(X, Y, X + W, Y + H);
    end;
    //������������ ������ �������
    case ifillRec.fillStyle of
      fsDown: begin
        dstRct.TopLeft := point(X, Y);
        dstRct.BottomRight := Point(X + W, Y + round(H  * PercentFill / 100));
      end;
      fsUp: begin
        dstRct.TopLeft := point(X, Y + round(H  * (100 - PercentFill) / 100));
        dstRct.BottomRight := Point(X + W, Y + H);
      end;
      fsRight: begin
        dstRct.TopLeft := point(X, Y);
        dstRct.BottomRight := Point(X + round(W  * PercentFill / 100), Y + H);
      end;
      fsLeft: begin
        dstRct.TopLeft := point(X + round(W  * (100 - PercentFill) / 100), Y);
        dstRct.BottomRight := Point(X + W, Y + H);
      end;
    end;
    //�������� �������
    canvas.CopyRect(dstRct, tempImg.Canvas, dstrct);
  end;
  
   {
 }
    tempImg.Free;
{  with Canvas do
  begin
    canvas.Pen := self.Pen;
    canvas.pen.Style := psClear;
    canvas.pen.Width := 0;
    Brush := ifillRec.Brush;
    X := self.Pen.Width;
    Y := X;
    W := Width - self.Pen.Width * 2 + 1;
    H := Height - self.Pen.Width * 2 + 1;
    if W < H then S := W else S := H;
    if Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    case Shape of
      stRectangle, stSquare: begin
        case ifillRec.fillStyle of
          fsUp: Rectangle(X, round(Y + H - H * PercentFill / 100),
                                     X + W, round(Y + H));
          fsDown: Rectangle(X, Y, X + W, round(Y + H * PercentFill / 100));
          fsRight: Rectangle(X, Y, round(X + W * PercentFill / 100), Y + H);
          fsLeft: Rectangle(round(X + W - W * PercentFill / 100), Y,
                                    round(X + W), Y + H);
        end;
      end;
      stRoundRect, stRoundSquare:;
//        RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
      stCircle, stEllipse:;
//        Ellipse(X, Y, X + W, Y + H);
    end;
  end;}
end;

{procedure TIMMIShape.SetCollar(value: TImControlBridge);
begin
  if value=nil then
    begin
     if fCollar<>nil then
     fCollar.DelFromList(self);
     fCollar:=nil;
     exit;
    end;
  if value is TImControlBridge then
                if value<>fcollar then
                  begin
                   value.AddToList(self);
                   fCollar:=value;
                  end;

end;    }

procedure TIMMIShapeForm.SetValue (val: single);
begin
     if fValue <> val then begin
       fvalue := val;
       paint;
     end;
end;

procedure TIMMIShapeForm.SetFillRec(fr: tFillrec);
begin
     ifillRec.Assign(fr);
     paint;
end;

procedure TIMMIShapeForm.ShowPropForm;
begin
  with TShapeEditorFrm.Create(nil) do begin
    comboBox1.ItemIndex := integer(shape);
    ColorBox1.Selected := self.brush.color;
    Edit1.Text := iExprVisible;
    ColorBox2.Selected := iFillRec.brush.color;
    Edit2.Text := iExpr;
    Edit3.text := format('%8.2f', [iMinValue]);
    Edit4.text := format('%8.2f', [iMaxValue]);
    comboBox2.ItemIndex := integer(iFillRec.FillStyle);
    if ShowModal = mrOK then begin
      shape := TShapeType(comboBox1.ItemIndex);
      self.brush.color := ColorBox1.Selected;
      iExprVisible := Edit1.Text;
      iFillRec.brush.color := ColorBox2.Selected;
      iExpr := Edit2.Text;
      try
        iMinValue := strtofloat(Edit3.text);
        iMaxValue := strtofloat(Edit4.text);
      except
        MessageDlg('�������� ������������ ��������', mtError, [mbOK], 0);
      end;
      iFillRec.FillStyle := TFillStyle(comboBox2.ItemIndex);
    end;
    Free;
  end;
end;

procedure TIMMIShapeForm.ShowPropFormMsg(var Msg: TMessage);
begin
  IMMIUnInit(Msg);
  showPropForm;
  try
    IMMIInit(Msg);
  except
    on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], E.HelpContext);
        perform(WM_IMMSHOWPROPFORM, 0, 0);
      end;
  end;
end;



end.
