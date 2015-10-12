unit Cvtype;

{� ������ ������ ���������� ������ ������
 ��� ����� ���� TPoint,
 ��� �����-�������,
 ��� ������, ��������� �� �����,
 � ��� ���������� ������� �������������� ��� Extended           }

interface

 uses WinTypes,Classes,Graphics;

{����������� ��������� ��� ��������� ����� �����������
 ����� ������ }
const PtEndStyle=15;      { ������������ ����� ����� �������     }
        mpNone=0;               { ��� ������� � ������           }
        mpCircle=1;             {������ ������ �����             }
        mpUpTreangle=2;         {������������ �����������..      }
        mpTreangle=3;           {����������� � ������� � �����   }
        mpRect=4;               {������� � ������� � �����       }
        mpRomb=5;               {-/- ����                        }
        mpCross=6;              {�����                           }
        mpDiag=7;               { ����� � ���� "�"               }
        mpArrow=8;              {������������� ����� - �������� }
        mpPoint=9;              {�����                           }
      mpNN=10;                  {�� ���������  ��� �������       }
        mpFillCircle=11;        { �� ��, ��� � ����,             }
        mpUpFillTreangle=12;    {   �� � �����������             }
        mpFillTreangle=13;
        mpFillRect=14;
        mpFillRomb=15;

type
    TMarkStyle=0..ptEndStyle; {��� �����-������� � ������(�� int)}

    TDataPoint=class {��������� ���� ����� ��������������� ������
                      - ��������� ��� ������ �� ������� �����
                      ��� ������ � ��������� �������� ��
                      �������������� ��������� ����� � ��� TPoint}
      private
       function GetPoint:TPoint;
       procedure SetPoint(Value:TPoint);
      public
        X,Y:integer;
       property Point:TPoint read GetPoint write SetPoint;
    end;

    TMark=class {�������� ��� � ��������� ������ � ������� ���
                 ������ � ������� - ���� ��������� �� ���� ������ -
                 ������ ���������� ��������� ����� � �������� �
                 ������������ � ������������� ������                }
     public
      Font:TFont;        {����� ������ ��� ��������� �������� }
      Color:TColor;      {���� ������ �������                 }
      Style:TMarkStyle;  {����� �������                       }
      Radius:byte;       {������ ������� -�� �����- � Create  }
      constructor Create;           {���. ��������� �����     }
      destructor Destroy; override; {��� Font.Free            }
      procedure Draw(const Cv:TCanvas;Pt:Tpoint);
       {��������� ������ � ������� � ����� Pt �� ������� Cv   }
      procedure DrawTitle(const S:string; const Cv:TCanvas;Pt:Tpoint);
       {��������� ������� S ��� ����� Pt �� ������� Cv
          - ������������ ������ ����������� � ������ ������   }
    end;

    TCurve=class  {�������� ���������� ������ �������� �����
                   � ����� ��� �������� � ���������� ����� ������
                   �� �����-���� ������� � ���� ������� ����� �
                   ��������� ��� ������ ����� ����� ������ Draw ���
                   ��������� ������� � ��������
                   (��������� ��������� ������ � ������ Titled=true }
     private
      DataList:TStringList;  {������ ����� � ��������� ��� �����
                              � ������ ������� � ���� ��������
                              ������ TdataPoint                     }
      FMaxCount:integer;     {����������� ���������� �����
                              ���������-����� ������ � ������ �����
                              - ��������������� � �����-�� ��������
                              �������� - � ������ ���������� �����,
                              ����� ����� ����� ����� ������ �����
                              ��������� ������ -������ ������� ������
                              ����� ������
                              (��� �����. �������� ������ ������     }
      function GetData(Index:integer):Tpoint;
       {��� ��������-������� - ������ � ����� ����. �������� ������  }
      function GetCount:integer; {������ ���������� DataList.Count   }
      function GetColor:TColor;
      procedure SetColor(Value:TColor);
     public
      Titled : boolean;  {true - ���������� ����� DrawTitle -
                          ��� ��������� �������� (�������� ��������
                          � �����, ����� ��������� ��������
                          �� ������ ����� �� ����������              }
      Pen:TPen;          {����, �-� �������� ������                  }
      Mark:TMark;        {������ - �������� �� ����� � �������� �����
                          ��� ���� ����� �� ������                   }
      Name:string;       {��� �������� ������ �� ������ ��������     }
{      procedure Assign(const Source:TCurve); virtual;
        ��� ������������ �� ����������� ����� � ������� ������
  }
      procedure SetMaxCount(Value:integer);
       {��������� �� private ��� ����. ��������������� ������        }

      constructor Create;
      destructor Destroy; override;
      procedure ClearPoints; { ������� ��� ����� �� ������           }
      procedure AddPoint(const S:string; Pt:Tpoint);
           { ��������� � ������ ����� � ������� - ���� �����
            ���������� DataList.Count>FMaxCount,�� ���������
            ������� ������� ������ � ������ ��������������           }
      procedure AddDataPoint(X,Y:extended;Pt:Tpoint);
           { ���������� ����., �� ������� ��� ����� ��������� � ����
             (X;Y) ��������� (10.2;234) - ������ - 3 �����           }
      procedure GoStepX(St:integer);
           { ����� ����� ������ ����� �� St ��������
             ��� ����������� ������                                  }
      procedure GoStepY(St:integer);
           { �� ��, �� ����� �� Y-��� ���� �� St ������              }
      procedure Draw(const Cv:TCanvas);
           { ���������� ��������� ������ �� �����-���� ������� Cv    }
      procedure DrawExample(const Cv:TCanvas;Left,Top,Width:integer);
           {��������� ������� ������ � ����� ������-������� -
              ������ ����� ������� ������������
              ��� ���������� ������ ������ �������� � ���� �������
               Width-����� �������  }

      property DataPoint[index:integer]:tPoint read GetData;
           {��������-������ ��� ������� � ����� ������ ����� ������
            � ������ ������ �� �������� 0,0                          }
      property Count:integer read GetCount; {��� ��������� �������   }
      property MaxCount:integer read FMaxCount write SetMaxCount;
           {��. ����������� ��� ���� ������                          }
      property Color:tColor read GetColor write SetColor;
           {Color ������ ��� ��������� ������� � ���� Pen.Color      }
     end;

{ ___________________________________________________________________}
{                                                                    }
{ ��������� ���������� �������, ������������ ��� ������ � ������� �
 ������, ���������� ���������� ������ ������ � ������� ���� Extended }
{ -------------------------------------------------------------------}
function ExtInt(Value,Diver:extended):extended; {������� ������      }
function ExtMod(Value,Diver:extended):extended;
                                          {������� ������� ������    }
function StepPrecision(ScrDim:integer;ExtDim:extended;
  Prec:integer):extended;
           {���������� � ������ ��������� (Prec-�������� � ������)
            ��� �������� ����� �������� � �������� ��������          }
function ExtPtInRect(X1,Y1,X2,Y2,XPt,YPt:extended):boolean;
           {true - ���� ����� � ������������ XPt,YPt
                                ����� ������ ��� �� ������� �������  }

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
implementation

{$IFDEF WIN32}
  uses Sysutils;
{$ELSE}
  uses Winprocs,Sysutils;
{$ENDIF}


{ ___________________________________________________________________}
{  ������� ������ ���������� �������                                 }

function ExtInt(Value,Diver:extended):extended;
 begin
  if Diver=0 then Result:=0
  else Result:=Diver*(Int(Value/Diver));
 end;

 function ExtMod(Value,Diver:extended):extended;
 begin
  if Diver=0 then Result:=0
  else Result:=Diver*(Frac(Value/Diver));
 end;

function StepPrecision(ScrDim:integer;ExtDim:extended;
  Prec:integer):extended;
 var LocSt,LocV:extended;
 begin
  Result:=-1;
  if (ScrDim=0) or (Prec=0) then exit;
  if ExtDim=0 then begin Result:=0; exit; end;
  LocSt:=1;
  LocV:=ExtDim/ScrDim;
  while Int(10*LocV)=0 do
   begin
    LocSt:=LocSt*10;
    LocV:=LocV*LocSt;
   end;
  if Frac(LocV)>=0.5 then LocV:=LocV+1;
  LocV:=Int(10*Abs(Prec)*LocV)/(10*Abs(Prec));
  Result:=(LocV/LocSt);
 end;

function ExtPtInRect(X1,Y1,X2,Y2,XPt,YPt:extended):boolean;
  begin
   if (XPt>=X1) and (XPt<=X2) and (YPt>=Y1) and (YPt<=Y2) then
    Result:=True
   else Result:=false;
  end;

{ ----------------------------------------------------------------  }
{ *********************    TDataPoint      ************************ }
 function TDataPoint.GetPoint:TPoint;
  begin
   Result.X:=X;
   Result.Y:=Y;
  end;
 procedure TDataPoint.SetPoint(Value:TPoint);
  begin
   X:=Value.X;
   Y:=Value.Y;
  end;
{ _________________________________________________________________ }
{ *********************    TMark           ************************ }
{ ----------------------------------------------------------------  }
constructor TMark.Create;
 begin
  inherited Create;
   Radius:=4; { ��� ���������� 800�600 ����� Radius=3               }
   Font:=TFont.Create;
   Font.Color:=clYellow;
   Font.Size:=8;
   Style:=mpNone;
   Color:=clRed;
 end;

destructor TMark.Destroy;
 begin
  Font.Free;
  inherited Destroy;
 end;

procedure TMark.Draw(const Cv:TCanvas;Pt:Tpoint);
var LocB:byte;
 begin
  with Cv,Pt do
   begin
    { ��� ��������� ������ �������� �� ����������� }
    Pen.Style:=psSolid;
    Pen.Width:=1;
    Pen.Color:=Color;     { � ����� ��������� ����� ����:
                            Cv.Pen.Color:=Self.Color !              }
    Brush.Color:=Color;   { ��������! ��� �������� � �����
                            ���� ���������� ����� �� ��� � ���� ����}
    if Style<=10 then Brush.Style:=bsClear else Brush.Style:=bsSolid;
                     { ���� Style>10 �� ��� ����������� �����-������}
    LocB:=Style;     { ��. ���� }
    if LocB>10 then LocB:=LocB mod 10;
       { ��� ����������� ����� ������ ����, �� � ����. �����������  }
    case LocB of
    mpCircle: Ellipse(X-Radius,Y-Radius,X+Radius,Y+Radius);
    mpUpTreangle: Polygon([Point(X,Y-Radius),
                           Point(X-Radius,Y+Radius),
                           Point(X+Radius,Y+Radius)]);
    mpTreangle: Polygon([Point(X-Radius,Y-Radius),
                         Point(X,Y+Radius),
                         Point(X+Radius,Y-Radius)]);
    mpRect:   Rectangle(X-Radius,Y-Radius,X+Radius,Y+Radius);
    mpRomb:   Polygon([Point(X-Radius,Y-Radius),
                        Point(X+Radius,Y-Radius),
                        Point(X+Radius,Y+Radius),
                        Point(X-Radius,Y+Radius)]);
    mpCross: begin
              Pen.Width:=2;
              MoveTo(X-Radius,Y);
              LineTo(X+Radius,Y);
              MoveTo(X,Y-Radius);
              LineTo(X,Y+Radius);
             end;
    mpDiag: begin
              MoveTo(X-Radius,Y-Radius);
              LineTo(X+Radius,Y+Radius);
              MoveTo(X+Radius,Y-Radius);
              LineTo(X-Radius,Y+Radius);
            end;
    mpArrow: begin
              MoveTo(X-Radius,Y);
              LineTo(X+Radius,Y);
              MoveTo(X,Y-Radius);
              LineTo(X,Y+Radius);
              MoveTo(X-Radius,Y-Radius);
              LineTo(X+Radius,Y+Radius);
              MoveTo(X+Radius,Y-Radius);
              LineTo(X-Radius,Y+Radius);
             end;
    mpPoint:  Pixels[X,Y]:=Pen.Color;
    end; { case }
   end; { with Cv,Pt }
 end;

 procedure TMark.DrawTitle(const S:string; const Cv:TCanvas;Pt:Tpoint);
  begin
   if S='' then exit; { ������ ������� �������� �� ����            }
   with Cv do
    begin
      Font.Assign(Self.Font);
             { ��������� ������ Cv.Font ���������� ��� ����������  }
       { Font.Color:=Self.Color; }
      SetTextAlign(Handle,ta_left+ta_bottom);
             {������� ����� � ������ �� �����                      }
      Brush.Style:=bsClear; { ������ ����� ����� �� �����������
                              bsClear �����. ���������� ��� �������}
      TextOut(Pt.X+1,Pt.Y-1,S);
    end;
  end;

{ _________________________________________________________________ }
{ *********************    TCurve          ************************ }
{ ----------------------------------------------------------------  }

{ ------------------private  - ������ ������� --------------------  }
function TCurve.GetData(Index:integer):Tpoint;
  begin
   Result.X:=0;  { ���-�� ���������� ������ }
   Result.Y:=0;
   if (DataList.Count=0)or (index<0) or (index>=DataList.Count) then exit;
   Result:=((DataList.Objects[Index])as TDataPoint).Point;
  end;

function TCurve.GetCount:integer;
 begin
  Result:=DataList.Count;
 end;

procedure TCurve.SetMaxCount(Value:integer);
 begin
  if Value<=1 then exit; { c������� ������ ������ ����� }
  FMaxCount:=Value;
  while FMaxCount<DataList.Count do
    DataList.Delete(0); { ������������ ������ ����� � �����. � �����
                          ������������ ����� ����� ������            }
 end;

function TCurve.GetColor:TColor;
 begin
   Result:=Pen.Color;
 end;
procedure TCurve.SetColor(Value:TColor);
 begin
   Pen.Color:=Value;
 end;
{------------ public ������ ----------------------------------------}

 procedure TCurve.ClearPoints;
  begin
   DataList.Clear;
  end;

 procedure TCurve.AddPoint(const S:string; Pt:Tpoint);
 var TMP_Data : TDataPoint;
  begin
   with DataList do
    if Count>0 then
      if ((Objects[Count-1] as TDataPoint).X=Pt.X)
       and ((Objects[Count-1] as TDataPoint).Y=Pt.Y) then
          begin  { ����������� ����� ��������� � ��������� � ������ }
           Strings[Count-1]:=S;{ �������� ������� �����             }
           exit;
          end;
   TMP_Data:= TDataPoint.Create;
   TMP_Data.Point:=Pt;            {����. ����� ����� � ���. �����.  }
   DataList.AddObject(S,TMP_Data);{�����. ������ �� �������-��������}
   if DataList.Count>FMaxCount then DataList.Delete(0);
         {��� ���������� ����� ��.-��� � ������ ������ �������      }
  end;

procedure TCurve.AddDataPoint(X,Y:extended;Pt:Tpoint);
 var TMP_Data : TDataPoint;
     LocS:String;
  begin
   LocS:=Concat('(',FloatToStrF(X,ffgeneral,3,3),', ',
                    FloatToStrF(Y,ffgeneral,3,3),')');
                 {������ ������� ����� � ������ �� ���������        }
    {����������� - ��. ���� ��� AddPoint }
   with DataList do
    if Count>0 then
      if ((Objects[Count-1] as TDataPoint).X=Pt.X)
       and ((Objects[Count-1] as TDataPoint).Y=Pt.Y) then
          begin
           Strings[Count-1]:=LocS;
           exit;
          end;
   TMP_Data:= TDataPoint.Create;
   TMP_Data.Point:=Pt;
   DataList.AddObject(LocS,TMP_Data);
   if DataList.Count>FMaxCount then DataList.Delete(0);
  end;

procedure TCurve.GoStepX(St:integer);
var il:integer;
 begin
  il:=0;
  while il<DataList.Count do  { �������� ���� ������ ����� }
   begin
    (DataList.Objects[il] as TDataPoint).X:=
       (DataList.Objects[il] as TDataPoint).X-St;
    Inc(il);
   end;
 end;

procedure TCurve.GoStepY(St:integer);
var il:integer;
 begin
  il:=0;
  while il<DataList.Count do  { �������� ���� ������ ����� }
   begin
    (DataList.Objects[il] as TDataPoint).Y:=
       (DataList.Objects[il] as TDataPoint).Y+St;
    Inc(il);
   end;
 end;

procedure TCurve.Draw(const Cv:TCanvas);
var il:integer;
    LocPt1,LocPt2:TPoint;
    {��� ���������� ����� ��� ����������� ���������� ������
     ������. ������� �����:
      1. ������ ����� �� ����� 1 � ����� 2
      2. ������ ����� (���� ����� ����� �������) � ����� 1
      3. ������ ������� (���� ����) � ����� 1               }
 begin
  Cv.Pen.Assign(Pen); {������ ���. ���� �������� }
  with Cv,DataList do
   begin
    if Count<=0 then exit; { ������ ������ ����� }
    LocPt1:=(Objects[0] as TDataPoint).Point;
    LocPt2:=LocPt1;
    MoveTo(LocPt1.X,LocPt1.Y);
     il:=1;
     while il<Count do { ������ ���� ������ ����� ������� � 1}
       begin
         LocPt1:=(Objects[il] as TDataPoint).Point;
         LineTo(LocPt1.X,LocPt1.Y);
         if Mark.Style<>mpNone then   {����� ����� ��������  }
                Mark.Draw(Cv,LocPt2); {- ��� � ������        }
         if Titled then               {������� �������       }
            Mark.DrawTitle(Strings[il-1],Cv,LocPt2);
         LocPt2:=LocPt1;
         Pen.Assign(Self.Pen);     {��� �����. ����� ��������
                                     ��������� ����          }
         MoveTo(LocPt1.X,LocPt1.Y);{��� �����. �����
                                     ��������� ���������     }
         Inc(il);
       end; { while }
     { � ����� ������ ��������� ���������� ����� � �������
       ��� ��������� ����� ������                            }
     if Mark.Style<>mpNone then
        begin
         Mark.Draw(Cv,LocPt1);
         Pen.Assign(Self.Pen);
        end;
       if Titled then
        begin
         Mark.DrawTitle(Strings[il-1],Cv,LocPt1);
        end;
   end; {with Cv,DataList.... }
 end;

 procedure TCurve.DrawExample(const Cv:TCanvas;Left,Top,Width:integer);
  begin
   Cv.Pen.Assign(Self.Pen);
    with Cv do
     begin
      MoveTo(Left,Top);
      LineTo(Left+Width,Top);
      Mark.Draw(Cv,Classes.Point(Left+Width div 2,Top));
     end; 
  end;

 constructor TCurve.Create;
  begin
   Inherited Create;
   Titled:=false;
   Name:='';
   DataList:=TStringList.Create;
   Mark:=TMark.Create;
   Pen:=TPen.Create;
   FMaxCount:=100;{�� ����� - �� ����� ��� �������� ���������� �����}
  end;

 destructor TCurve.Destroy;
  begin
   DataList.Free;
   Mark.free;
   Pen.free;
   Inherited Destroy;
  end;

end.
