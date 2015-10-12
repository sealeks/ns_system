unit IMMImaskPanel;

interface

uses
  SysUtils, Classes, Controls,messages, ExtCtrls,Dialogs, IMMIPanelU, ComCtrls, paramu, constdef;

type
TOrientPanel = (opHor, opVer);

type
  TIMMImaskPanel = class(TIMMIPanel)
  private
      fmaxVal: longword;
      forientation: TOrientPanel;
      fbitmax: byte;
      ftbar: ttoolbar;
      fparam: TParamControlEdit;
      curval: longword;
      finvers: boolean;
    { Private declarations }
  protected
   procedure setmaxval(val: longword);
   procedure setorientation(val: TOrientPanel);
   procedure showbuttonstate;
    { Protected declarations }
  public
    procedure IMMIInit (var msg: TMessage); message WM_IMMIINIT;
    procedure IMMIUNInit (var msg: TMessage); message WM_IMMIUNINIT;
    procedure IMMIUpdate (var msg: TMessage); message WM_IMMIUPDATE;
    procedure IMMIBlinkOn (var msg: TMessage); message WM_IMMIBLINKON;
    procedure IMMIBlinkOff (var msg: TMessage); message WM_IMMIBLINKOFF;
   constructor Create(AOwner: Tcomponent); override;
   destructor Destroy; override;
   procedure buttonsClick(sender: TObject);
    { Public declarations }
  published
    property maxVal: longword read fmaxVal write setmaxval;
    property orientation: TOrientPanel read forientation write setorientation;
    property param: TParamControlEdit read fparam write fparam;
    property invers: boolean read finvers write finvers;
   // property  tbar: ttoolbar read ftbar write ftbar;
    { Published declarations }
  end;

procedure Register;

implementation

constructor TIMMImaskPanel.Create(AOwner: TComponent);
begin
inherited;
 ftbar:=ttoolbar.Create(self);
 ftbar.Align:=alClient;
 ftbar.Parent:=self;
 fparam:=TParamControlEdit.create;
end;

destructor TIMMImaskPanel.Destroy;
begin
fparam.free;
ftbar.Free;
inherited;
end;

procedure TIMMImaskPanel.setorientation(val: TOrientPanel);
begin
 forientation:=val;
 if val=opHor then ftbar.Align:=altop else ftbar.Align:=alleft;
 if val=ophor then
  begin
     ftbar.Height:=self.Height-2;
       ftbar.width:=self.width-2;
     ftbar.ButtonHeight:=self.Height-8;
     ftbar.ButtonWidth:=ftbar.ButtonHeight;
  end else
  begin
     ftbar.Height:=self.Height-2;
       ftbar.width:=self.width-2;
     ftbar.ButtonWidth:=self.Width-8;
     ftbar.ButtonHeight:=ftbar.ButtonWidth;
  end
end;

procedure TIMMImaskPanel.setmaxval(val: longword);
var g: byte;
    newbutt: TToolButton;
     i: integer;
begin
g:=0;
fmaxval:=val;
if val>0 then
  begin
    while val>0 do
     begin
       val:=val div 2;
       inc(g);
     end;
  end;
 fbitmax:=g;
 if self.ftbar.ButtonCount<>g then
   begin
    if self.ftbar.ButtonCount<g then
      begin
       while self.ftbar.ButtonCount<g do
        begin
         newbutt:=TToolButton.Create(self);
         newbutt.Tag:=1 shl (self.ftbar.ButtonCount-1);
         newbutt.onClick:=self.buttonsClick;
         newbutt.Parent:=self.ftbar;
         self.ftbar.Update;
        end;
      end else
      begin
        while self.ftbar.ButtonCount>g do
        begin
          self.ftbar.Buttons[self.ftbar.ButtonCount-1].Free;
        end;
      end;
   end;
   if not finvers then
   begin
   for i:=0 to self.ftbar.ButtonCount-1 do
     self.ftbar.Buttons[i].Tag:=1 shl (i);
   end else
   begin
   for i:=0 to self.ftbar.ButtonCount-1 do
     self.ftbar.Buttons[i].Tag:=1 shl (self.ftbar.ButtonCount-i-1);
   end;
end;

procedure TIMMImaskPanel.buttonsClick(sender: TObject);
var mask,mask2: Longword;
    val: Longword;
    i: integer;
begin
  val:=round(fparam.value);
 // if fparam.ValidLevel<89 then exit;
  // showmessage(inttostr((sender as ttoolbutton).Tag));
  if ((sender as ttoolbutton).TAG AND VAL)>0 then
   begin
      mask:=not ((sender as ttoolbutton).Tag);
      mask2:=0;
      for I:=0 to self.ftbar.ButtonCount-1 do mask2:=mask2 shl 1 + 1;
      //showmessage(inttostr(mask));
      mask:=mask and mask2;
      val:=val and mask;
      //showmessage(inttostr(MASK2)+'  '+inttostr(MASK)+'  '+inttostr(val));
   end else
   begin
      mask:=((sender as ttoolbutton).Tag);
      val:=val or mask;
     // showmessage(inttostr(MASK)+'  '+inttostr(val));
   end;
fparam.SetNewValue(val);



end;


procedure TIMMImaskPanel.IMMIBlinkOff(var msg: TMessage);
begin
   inherited;
end;

procedure TIMMImaskPanel.IMMIBlinkOn(var msg: TMessage);
begin
   inherited;
end;

procedure TIMMImaskPanel.IMMIInit(var msg: TMessage);
begin
   inherited;
    fparam.Init('¬вод значени€');;
end;


procedure TIMMImaskPanel.IMMIUNInit(var msg: TMessage);
begin
 inherited;
 fparam.unInit;
end;

procedure TIMMImaskPanel.IMMIUpdate(var msg: TMessage);
begin
   inherited;
   fparam.immiUpdate;
   if curval<>round(fparam.Value) then
    begin
     curval:=round(fparam.Value);
     showbuttonstate;
    end;
end;

procedure TIMMImaskPanel.showbuttonstate;
var i: integer;
begin
  for i:=0 to self.ftbar.ButtonCount-1  do
   self.ftbar.Buttons[i].Down:=((round(param.Value) and (1 shl i))=0);
end;

procedure Register;
begin
 // RegisterComponents('IMMICtrls', [TIMMImaskPanel]);
end;

end.
