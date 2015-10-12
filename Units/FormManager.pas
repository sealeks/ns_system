unit FormManager;

interface
uses SysUtils, Classes, dbTables, messages, Forms, Windows, controls;


type TPosition = class(tpersistent)
  private
   fFormTop: integer;
   fFormLeft: integer;
  published
   property FormTop: integer read fFormTop write fFormTop;
   property FormLeft: integer read fFormLeft write fFormLeft;
end;


type  TFormManager = class (tpersistent)
private

  fOpenForm: TStringList;
  fCloseForm: TStringList;
  fShowMod: boolean;
  fNotCloseModal: boolean;
  fCaverModal: boolean;
  fsetBeep: boolean;
  fBeepTime: integer;
  freinit: boolean;
  fClickManagment: boolean;
   fFPosition: TPosition;
  {fCloseAllCurent: boolean;   }
public
  selff: TControl;
  constructor create(selfs: TControl);
  destructor  destroy; override;
  procedure Activate;
  procedure Assign(Source: TPersistent); override;
published
  property OpenForm: TStringList read fOpenForm write fOpenForm;
  property CloseForm: TStringList read fCloseForm write fCloseForm;
  property ShowMod: boolean read fShowMod write fShowMod;
  property NotCloseModal: boolean read fNotCloseModal write fNotCloseModal;
  property CaverModal: boolean read fCaverModal write fCaverModal;
  property setBeep: boolean read fSetBeep write fSetBeep default false;
 { property CloseAllCurent: boolean  read fCloseAllCurent write fCloseAllCurent default false;  }
  property BeepTime: integer read fBeepTime write fBeepTime default 100;
  property reinit: boolean read freinit write freinit;
  property ClickManagment: boolean read fClickManagment write fClickManagment;
   property FPosition: TPosition read fFPosition write fFPosition;
end;




implementation

 constructor TFormManager.create(selfs: TControl);
begin
inherited create;
selff:=selfs;
fOpenForm:=tStringList.Create;
fCloseForm:=tStringList.Create;
fFPosition:=TPosition.Create;
fFPosition.FormTop:=-1;
fFPosition.FormLeft:=-1;
fClickManagment:=false;
end;

destructor TFormManager.destroy;
begin
selff:=nil;
fFPosition.free;
fOpenForm.free;
fCloseForm.free;
inherited destroy;
end;

procedure TFormManager.Activate;
var
 i,j,k: integer;
 formmodal: TForm;

begin
   formmodal:=nil;
  i:=0;
   {if fCloseAllCurent then
        while i<Application.ComponentCount do
         begin
          if ((Application.components[i] is Tform) and
            (fOpenForm.IndexOf((Application.components[i] as Tform).caption)<0)  and
            ((Application.components[i] as Tform).Tag<100) and ((Application.components[i] as Tform)<>Application.MainForm)) then  (Application.components[i] as Tform).Hide;
           inc(i);
         end;        }
j:=0;
k:=-1;



  if (not fCaverModal) then
     begin
      for i:=0 to Application.ComponentCount-1 do
        if ((Application.Components[i] is TForm) and (fsModal in TForm(Application.Components[i]).FormState)) then  exit;
     end
  else
     begin
      for i:=0 to Application.ComponentCount-1 do
        if ((Application.Components[i] is TForm) and (fsModal in TForm(Application.Components[i]).FormState)) then
        begin
        TForm(Application.Components[i]).ModalResult:=MrNo;
        TForm(Application.Components[i]).Hide;
        end;
     end;
i:=0;
 if (((fCloseForm.count>0) or (fOpenForm.count>0))) then
   begin
     while i<Application.ComponentCount do
       begin
          if ((Application.components[i] is Tform) and
               (fCloseForm.IndexOf((Application.components[i] as Tform).caption)<>-1) and
            (Application.components[i] as Tform).Showing) then
              begin
              if not (fNotCloseModal and ((fsModal in TForm(Application.Components[i]).FormState))) then
                 begin
                    if  (fsModal in TForm(Application.Components[i]).FormState) then
                    TForm(Application.Components[i]).ModalResult:=MrNo;
                    (Application.components[i] as Tform).Hide;
                 end;
               end;
          if ((Application.components[i] is Tform) and
            (fOpenForm.IndexOf((Application.components[i] as Tform).caption)<>-1)) then
            begin
              //if freinit then (Application.components[i] as Tform).hide;
              if fClickManagment then
                begin
                 if ((fFPosition.FormTop>-1) and (fFPosition.FormLeft>-1)) then
                  begin
                   (Application.components[i] as Tform).top:=fFPosition.FormTop;
                   (Application.components[i] as Tform).left:=fFPosition.FormLeft;
                  end else
                  begin
                  if (selff<>nil) and (selff is TControl) then
                  begin
                  (Application.components[i] as Tform).top := selff.ClientToScreen(Point(0, 0)).Y+5+selff.Height;
                  (Application.components[i] as Tform).left := selff.ClientToScreen(Point(0, 0)).X+5+selff.Width;
                  if (selff.owner is TForm) then
                   begin
                   if  (((Application.components[i] as Tform).top+(Application.components[i] as Tform).height)>((selff.owner as TForm).top+(selff.owner as TForm).Height)) then
                   (Application.components[i] as Tform).top:=(Application.components[i] as Tform).top-(Application.components[i] as Tform).height-10-selff.Height;
                   if  (((Application.components[i] as Tform).left+(Application.components[i] as Tform).width)>((selff.owner as TForm).Left+(selff.owner as TForm).Width)) then
                   (Application.components[i] as Tform).left:=(Application.components[i] as Tform).left-(Application.components[i] as Tform).width-10-selff.width;
                   if(Application.components[i] as Tform).top<20 then (Application.components[i] as Tform).top:=20;
                   if (Application.components[i] as Tform).left<20 then (Application.components[i] as Tform).left:=20;
                   end
                  end;
                  end;
                end;
              (Application.components[i] as Tform).Show;
              if (fOpenForm.IndexOf((Application.components[i] as Tform).caption))>k then
              begin
               formmodal:=(Application.components[i] as Tform);
               k:=(fOpenForm.IndexOf((Application.components[i] as Tform).caption));
              end;
            end;
           inc(i);
       end;
       if fShowMod Then
         begin
           formmodal.Hide;
           formmodal.Visible:=false;
           if fsetBeep then Beep(1000,fBeepTime);
           formmodal.ShowModal;
         end;
   end;


end;


procedure TFormManager.Assign(Source: TPersistent);
begin
if Source is TFormManager then
  begin
    fOpenForm.Assign((Source as TFormManager).fOpenForm);
    fCloseForm.Assign((Source as TFormManager).fcloseForm);
    fShowMod:=(Source as TFormManager).fShowMod;
    fNotCloseModal:=(Source as TFormManager).fNotCloseModal;
    fCaverModal:=(Source as TFormManager).fCaverModal;
    fFPosition.fFormTop:=(Source as TFormManager).fFPosition.fFormTop;
    fFPosition.fFormLeft:=(Source as TFormManager).fFPosition.fFormLeft;
  end;

end;

end.
