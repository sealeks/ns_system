unit IMMIGridU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ParamU, MemStructsU, CalcU1, Expr, constDef;

type
  TIMMIGrid = class(TStringGrid)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure KeyPress(var Key: Char); override;
    procedure SetObject(ACol, ARow: Longint);
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure SaveToFile(FileName: string);
    procedure LoadFromFile(FileName: string);
  published
    { Published declarations }
  end;

procedure Register;

implementation

constructor TIMMIGrid.Create(AOwner: TComponent);
var
  i: integer;
begin
  inherited;
  options := options + [goEditing];
  ColCount := 3;
  fixedCols := 0;
  defaultRowHeight := 18;
  cells[0, 0] := 'Выражение';
  cells[1, 0] := 'Значение';
  cells[2, 0] := 'Описание';
  for i := 1 to rowCount - 1 do
    objects[0, i] := nil;
end;

procedure TIMMIGrid.SaveToFile(FileName: string);
var
 f: textFile;
 i, j: integer;
begin
  assignFile (f, FileName);
  if fileExists (FileName) then append(f)
  else rewrite (f);
  try
    writeLn(f, name);
    writeLn(f, inttostr(colCount));
    writeLn(f, inttostr(rowCount));
    for i := 1 to RowCount - 1 do
      for j := 0 to ColCount - 1 do
        writeln(f, cells[j, i]);
  finally
    close(f);
  end;
end;

procedure TIMMIGrid.LoadFromFile(FileName: string);
var
  f: textFile;
  i, j: integer;
  str: string;
begin
  assignFile (f, FileName);
  reset(f);
  try
    repeat readLn(f, str); until (str = Name) or EOF(f);
    if str <> name then exit;
    readLn(f, str);
    colCount := strtoInt(str);
    readLn(f, str);
    rowCount := strtoInt(str);
    for i := 1 to RowCount - 1 do
    begin
      for j := 0 to ColCount - 1 do
      begin
        readln(f, str);
        cells[j, i] := str;
      end;
      setObject(0, i);
    end;
  finally
    close(f);
  end;
end;

procedure TIMMIGrid.KeyPress(var Key: Char);
begin
  if not (goAlwaysShowEditor in Options) and (Key = #13) then
  begin
    if EditorMode then
    begin
       SetObject(Col, Row);
       if Row = RowCount - 1 then RowCount := RowCount + 1;
    end;
  end;
  inherited KeyPress(Key);
end;

procedure TIMMIGrid.ImmiUpdate;
var
  i: integer;
  fExpr: TExpretion;
  param: tParam;
   val: real;
begin
  for i:= 1 to rowCount - 1 do
  begin
    if objects[0, i] is tExpretion then
    begin
     fExpr := TExpretion(objects[0, i]);
     try
       fExpr.ImmiUpdate;
       val := fExpr.Value;
       if fexpr.validLevel > 90 then begin
          cells[1, i] := FloatToStrF(val, ffFixed, 10, 2);
        end else cells[1, i] := '?' + FloatToStr(val);
     except
       on E: Exception do
       begin
         cells[1, i] := '???';
         cells[2, i] := E.Message;
       end;
     end;
    end;

    if objects[0, i] is tParam then
    begin
      param := tParam(Objects[0, i]);
       if param.isValid then
          cells[1, i] := FloatToStr(param.Value)
       else cells[1, i] := '?' + FloatToStr(param.Value);
    end;
  end;
end;

procedure TIMMIGrid.SetObject(ACol, ARow: Longint);
var
  itsParam: boolean;
  val: string;

begin

  if (aCol = 0) then
  begin
    val := trim(cells[aCol, aRow]);
    if Val = '' then
    begin
      objects[aCol, aRow].Free;
      objects[aCol, aRow] := nil;
      cells[1, aRow] := '';
      cells[2, aRow] := '';
      exit;
    end;

    itsParam := (rtItems.GetSimpleID(val) <> -1);
    if ItsParam then
    begin
      objects[aCol, aRow].Free;
      objects[aCol, aRow] := TObject(TParam.Create);
      TParam(objects[aCol, aRow]).rtName := val;
      TParam(objects[aCol, aRow]).Init(self.Name);
      cells[2, aRow] := TParam(objects[aCol, aRow]).Comment;
    end;

    if not ItsParam then
    begin
      objects[aCol, aRow].Free;
      objects[aCol, aRow] := TObject(TExpretion.Create);
      try;
        TExpretion(objects[aCol, aRow]).Expr := val;
        TExpretion(objects[aCol, aRow]).IMMIInit;
        cells[2, aRow] := '';
      except
        objects[aCol, aRow].Free;
        objects[aCol, aRow] := nil;
        cells[1, aRow] := '';
        cells[2, aRow] := 'Ошибка в выражении';
      end;
    end;
  end;
end;

procedure Register;
begin
  //RegisterComponents('IMMI', [TIMMIGrid]);
end;

end.
