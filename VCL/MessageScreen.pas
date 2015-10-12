unit MessageScreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls,Expr,ConstDef;

type TParamTabel = class(TPersistent)
   private
      FParamList: TstringList;
      FMessageList: TstringList;
      Fparams: array  of tExpretion;


      fActveMessage: TStringList;
      fIsNull: boolean;
      fIsNumeration: boolean;

   public

      property ActveMessage: TStringList read fActveMessage;
      property isNull: boolean read  fIsNull;
      constructor Create;
      destructor Destroy;

      procedure Init;
      procedure UnInit;
      procedure Update;
   published
     property ParamList: TstringList read FParamList write FParamList;

     property MessageList: TstringList read FMessageList write FMessageList;
     property IsNumeration: boolean read fIsNumeration write fIsNumeration;

   end;




  type
  TMessageScreen = class(TMemo)
  private
     fListMess: TParamTabel;
     fHideIfNot: boolean;
    { Private declarations }
  protected
    { Protected declarations }
  public
  constructor create(Aowner: Tcomponent); override;
  destructor Destroy; override;
     procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;

    { Public declarations }
  published
  property ListMess: TParamTabel read fListMess write fListMess;
  property HideIfNot: boolean read fHideIfNot write fHideIfNot;

    { Published declarations }
  end;

procedure Register;

implementation

constructor TParamTabel.create;
begin
inherited;
fisNull:=true;
FParamList:=TStringList.Create;
FMessageList:=TStringList.Create;
fActveMessage:=TStringList.Create;
end;

destructor TParamTabel.destroy;
begin
FParamList.Destroy;
FMessageList.Destroy;
fActveMessage.destroy;
inherited;
end;

procedure TParamTabel.Init;
var i: integer;
begin
fisNull:=true;
SetLength(Fparams, FParamList.count);
for i:=0 to FParamList.count-1 do
  CreateAndInitExpretion(Fparams[i],  FParamList.Strings[i]);
fActveMessage.Clear;

end;

procedure TParamTabel.UnInit;
var i: integer;
begin
fisNull:=true;
for i:=0 to FParamList.count-1 do
  if assigned(Fparams[i]) then Fparams[i].ImmiUnInit;


end;


procedure TParamTabel.Update;
var i,j: integer;
    NumStr: string;
begin
j:=0;
fisNull:=true;
fActveMessage.Clear;
for i:=0 to FParamList.count-1 do
begin
  if assigned(Fparams[i]) then Fparams[i].ImmiUpdate;
  if  Fparams[i].isTrue then
  begin
  inc(j);
  if fIsNumeration then NumStr:=IntToStr(j)+'. ' else NumStr:='';
  fActveMessage.Add(NumStr+FMessageList.Strings[i]);
  fisNull:=false;
  end;
end;

end;

constructor TMessageScreen.create(Aowner: Tcomponent);
begin
inherited;
ListMess:=TParamTabel.Create;
end;

destructor TMessageScreen.Destroy;
begin
ListMess.Destroy;
inherited;
end;


procedure  TMessageScreen.ImmiInit(var Msg: TMessage);
begin
 ListMess.Init;

end;

procedure  TMessageScreen.ImmiUnInit(var Msg: TMessage);
begin
 ListMess.UnInit;

end;


procedure  TMessageScreen.ImmiUpdate(var Msg: TMessage);
begin


if self.fHideIfNot then
 begin
   if  ListMess.fIsNull
   then Visible:=false
   else Visible:=true;
 end;
 ListMess.Update;

 self.Lines:=ListMess.fActveMessage;
end;

procedure TMessageScreen.WMSetFocus(var Msg: TWMSetFocus);
begin

end;


procedure Register;
begin
  //RegisterComponents('IMMI', [TMessageScreen]);
end;

end.
