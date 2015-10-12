unit IMMIformx;
{$M+}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  TypInfo,
  Controls, Forms, Dialogs, ExtCtrls, constDef,Menus,
    IMMIPropertysU,
  IMMILabelFullU, IMMIImg1, IMMIShape, stdCtrls,
  IMMIAlarmTriangle, IMMIArmatVl, IMMIArmatBm, IMMITube,
  IMMIGoU, IMMIEditReal, IMMITrackBar, IMMISpeedButton, IMMIBitBtn, IMMIValueEntryU;


type
  TControlHack = class(TComponent);
  TWinControlHack = class(TWinControl);
  TIMMIFormExt = class(TComponent)
  private
    // window procedures
    fProjectImage: boolean;
    OldWndProc, NewWndProc: Pointer;
    fNoImage: boolean;

    // MinMaxInfo data
    fMaximizedWidth: Integer;
    fMaximizedHeight: Integer;
    fMaximizedPosX: Integer;
    fMaximizedPosY: Integer;
    fMinimumTrackWidth: Integer;
    fMinimumTrackHeight: Integer;
    fMaximumTrackWidth: Integer;
    fMaximumTrackHeight: Integer;
    // background bitmap
    fBackBitmap: TBitmap;
    FOnHideOld: TNotifyEvent;//saved hide proc
    FOnShowOld: TNotifyEvent;
    fFormVisible: boolean;
    procedure SetBackBitmap (Value: TBitmap);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    function FormHandle: THandle;
    procedure NewWndMethod (var Msg: TMessage);
    procedure BackBitmapChanged (Sender: TObject);
  public
    IsModified: boolean;
    RightClickedCtrl: TComponent;

    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveOwnerForm;
  //  procedure PopMenuShowProp(Sender: TObject);
    procedure PopMenuBringToFront(Sender: TObject);
    procedure PopMenuSendToBack(Sender: TObject);
   // procedure SetNewObjectPropertys(comp: TControl; Msg: TMessage);
  //  procedure WinCtrlMouseDown(Sender: TObject; Button: TMouseButton;
  //             Shift: TShiftState; X, Y: Integer);

  published
    property BackBitmap: TBitmap
      read fBackBitmap write SetBackBitmap;
    property MaximizedWidth: Integer
      read fMaximizedWidth write fMaximizedWidth
      default 0;
    property MaximizedHeight: Integer
      read fMaximizedHeight write fMaximizedHeight
      default 0;
    property MaximizedPosX: Integer
      read fMaximizedPosX write fMaximizedPosX
      default 0;
    property MaximizedPosY: Integer
      read fMaximizedPosY write fMaximizedPosY
      default 0;
    property MinimumTrackWidth: Integer
      read fMinimumTrackWidth write fMinimumTrackWidth
      default 0;
    property MinimumTrackHeight: Integer
      read fMinimumTrackHeight write fMinimumTrackHeight
      default 0;
    property MaximumTrackWidth: Integer
      read fMaximumTrackWidth write fMaximumTrackWidth
      default 0;
    property MaximumTrackHeight: Integer
      read fMaximumTrackHeight write fMaximumTrackHeight
      default 0;
    property OnHideOld: TNotifyEvent read FOnHideOld write FOnHideOld;
    property OnShowOld: TNotifyEvent read FOnShowOld write FOnShowOld;
    property ProjectImage: boolean read fProjectImage write fProjectImage;
    property NoImage: boolean read fNoImage write fNoImage  default false;
  end;

procedure Register;

implementation
uses
  IMMIRegul;

constructor TIMMIFormExt.Create (AOwner: TComponent);
var
  I: Integer;
begin
    if (AOwner = nil) then
      raise Exception.Create (
        'Owner of IMMIFormExt component is nil');
    if not (AOwner is TForm) then
      raise Exception.Create (
      'Owner of IMMIFormExt component must be a form');
  // create a single instance only
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TIMMIFormExt then
      raise Exception.Create (
        'IMMIFormExt component duplicated in ' +
        AOwner.Name);
  // default creation
  inherited Create (AOwner);
  // form subclassing (runtime only)
  {if not (csDesigning in ComponentState) then
  begin   }
    NewWndProc := MakeObjectInstance (NewWndMethod);
    OldWndProc := Pointer (SetWindowLong (
      FormHandle, gwl_WndProc, Longint (NewWndProc)));
   OnHideOld := (aOwner as TForm).OnHide;
    (aOwner as TForm).OnHide := FormHide;
   OnShowOld := (aOwner as TForm).OnShow;
   (aOwner as TForm).OnShow := FormShow;
 { end
  else
  begin
    // default values
    NewWndProc := nil;
    OldWndPRoc := nil;
  end; }
  fBackBitmap := TBitmap.Create;
  fBackBitmap.OnChange := BackBitmapChanged;
  isModified := true;


end;

destructor TIMMIFormExt.Destroy;
begin
  if Assigned (NewWndProc) then
  begin
    if owner<>nil then
    begin
    (Owner as TForm).OnHide := OnHideOld;
     OnHideOld :=nil;

    (Owner as TForm).OnShow := OnShowOld;
    OnShowOld:= nil;
    FreeObjectInstance (NewWndProc);
    SetWindowLong (FormHandle, gwl_WndProc,
      Longint (OldWndProc));
    end;  
  end;
 // fBackBitmap.Free;
  //menu.Free;
  inherited Destroy;
end;

function TIMMIFormExt.FormHandle: THandle;
begin
  Result := (Self.Owner as TForm).Handle;
end;

// custom window procedure

procedure TIMMIFormExt.NewWndMethod (var Msg: TMessage);
var
  ix, iy, i,j: Integer;
  ClientWidth, ClientHeight: Integer;
  BmpWidth, BmpHeight: Integer;
  hCanvas, BmpCanvas: THandle;
  pMinMax: PMinMaxInfo;
  ctrl: TControl;
  pt: TPoint;
  //MsgKey: TMessage;
  Props: PPropList;
  TypeData: PTypeData;
  IMMIProp: TIMMIImgPropertys;
begin
  case Msg.Msg of
    wm_EraseBkgnd:
      if (fBackBitmap.Height <> 0) or
        (fBackBitmap.Width <> 0) then
      begin
        ClientWidth := (Owner as TForm).ClientWidth;
        ClientHeight := (Owner as TForm).ClientHeight;
        BmpWidth := fBackBitmap.Width;
        BmpHeight := fBackBitmap.Height;
        BmpCanvas := fBackBitmap.Canvas.Handle;
        hCanvas := THandle (Msg.wParam);
        for iy := 0 to ClientHeight div BmpHeight do
          for ix := 0 to ClientWidth div BmpWidth do
            BitBlt (hCanvas, ix * BmpWidth, iy * BmpHeight,
              BmpWidth, BmpHeight, BmpCanvas,
              0, 0, SRCCOPY);
        Msg.Result := 1; // message handled
        Exit; // skip default processing
      end;
    wm_GetMinMaxInfo:
      if fMaximizedWidth + fMaximizedHeight + fMaximizedPosX +
        fMaximizedPosY + fMinimumTrackWidth + fMinimumTrackHeight +
        fMaximumTrackWidth + fMaximumTrackHeight <> 0 then
      begin
        pMinMax := PMinMaxInfo (Msg.lParam);
        if fMaximizedWidth <> 0 then
          pMinMax.ptMaxSize.X := fMaximizedWidth;
        if fMaximizedHeight <> 0 then
          pMinMax.ptMaxSize.Y := fMaximizedHeight;
        if fMaximizedPosX <> 0 then
          pMinMax.ptMaxPosition.X := fMaximizedPosX;
        if fMaximizedPosY <> 0 then
          pMinMax.ptMaxPosition.Y := fMaximizedPosY;
        if fMinimumTrackWidth <> 0 then
          pMinMax.ptMinTrackSize.X := fMinimumTrackWidth;
        if fMinimumTrackHeight <> 0 then
          pMinMax.ptMinTrackSize.Y := fMinimumTrackHeight;
        if fMaximumTrackWidth <> 0 then
          pMinMax.ptMaxTrackSize.X := fMaximumTrackWidth;
        if fMaximumTrackHeight <> 0 then
          pMinMax.ptMaxTrackSize.Y := fMaximumTrackHeight;
        Msg.Result := 0; // message handled
        Exit; // skip default processing
      end;
    WM_IMMIUpdate:
      if ToolMode = tmRun then
       { (Self.Owner as TWinControl).BroadCast (Msg);   }
       Immi_BroadCast(Self.Owner,Msg);
    WM_IMMIBlinkOn,
    WM_IMMIBlinkOff:
        {(Self.Owner as TWinControl).BroadCast (Msg); }
         Immi_BroadCast(Self.Owner,Msg);
    WM_IMMIKEYSET:
        begin
          //SHowMessage(inttostr(msg.lparam));
          (Self.Owner as TWinControl).BroadCast (Msg);

        end;
   { WM_IMMISaveFORM:
      SaveOwnerForm;
    WM_LBUTTONDOWN:
      begin
        case ToolMode of
          tmPoint:
            begin
             SetCapture((self.Owner as TForm).Handle);
              with TWMMouse(Msg) do
                ctrl := (self.Owner as TForm).ControlAtpos(point(xpos, ypos), true, true);
              with ctrl do
                  if ctrl <> nil then
                  begin
                    TDdhSizerControl.Create(owner, ctrl);
                    exit;
                  end;
              end;
          tmCreateIMMILabelFull:
              SetNewObjectPropertys(TIMMILabelFull.Create(SELF.Owner), Msg);
          tmCreateIMMIImg1:
            begin
              ctrl := TIMMIImg1.Create(SELF.Owner);
              with ctrl do
              begin
                parent := (owner as TForm);
                top := TWMMouse(Msg).YPos - Height;
                left := TWMMouse(Msg).XPos;
                TControlHack(ctrl).SetDesigning (true, true)
              end;
            end;
          tmCreateIMMIShape:
              with TIMMIShape.Create(SELF.Owner) do
              begin
                parent := (owner as TForm);
                top := TWMMouse(Msg).YPos - Height;
                left := TWMMouse(Msg).XPos;
              end;
          tmCreateAlarmTriangle:
              SetNewObjectPropertys(TIMMIAlarmTriangle.Create(SELF.Owner), Msg);
          tmCreateArmatVl:
              SetNewObjectPropertys(TIMMIArmatVl.Create(SELF.Owner), Msg);
          tmCreateArmatBm:
              SetNewObjectPropertys(TIMMIArmatBm.Create(SELF.Owner), Msg);
          tmCreateRegul:
              SetNewObjectPropertys(TIMMIRegul.Create(SELF.Owner), Msg);
          tmCreateTube:
              SetNewObjectPropertys(TIMMITube.Create(SELF.Owner), Msg);

          tmCreateGo:
              SetNewObjectPropertys(TIMMIGo.Create(SELF.Owner), Msg);
          tmCreateEditReal:
              SetNewObjectPropertys(TIMMIEditReal.Create(SELF.Owner), Msg);
          tmCreateTrackBar:
              SetNewObjectPropertys(TIMMITrackBar.Create(SELF.Owner), Msg);
          tmCreateSpeedButton:
              SetNewObjectPropertys(TIMMISpeedButton.Create(SELF.Owner), Msg);
          tmCreateBitBtn:
              SetNewObjectPropertys(TIMMIBitBtn.Create(SELF.Owner), Msg);
          tmCreateValueEntry:
              SetNewObjectPropertys(TIMMIValueEntry.Create(SELF.Owner), Msg);

        end;
      end;//
    WM_RBUTTONDOWN:
        if ToolMode <> tmrun then
            begin
              with TWMMouse(Msg) do
                RightClickedCtrl := (Self.Owner as TForm).ControlAtpos(point(xpos, ypos), true, true);
                if RightClickedCtrl <> nil then
                  with TWMMouse(Msg) do pt := (self.owner as TForm).clienttoscreen(point(xPos, yPos));
                     menu.Popup(pt.x, pt.Y);
                begin
                  TypeData := GetTypeData(ctrl.classInfo);
                  if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
                  GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
                  try
                     GetPropInfos(ctrl.ClassInfo, Props);
                     IMMIProp := GetObjectProp(ctrl, 'IMMIProp') as TIMMIImgPropertys; //props^[42]
                     if (IMMIProp is TIMMIImgPropertys) then IMMIProp.ShowPropForm;
                  finally
                      Freemem(Props);
                  end;
                  exit;
                  end;
            end;
    WM_IMMIMODECHANGED:
      begin
        if msg.WParam = tmRun then
          for i := 0 to (Self.Owner as TComponent).ComponentCount - 1 do
          begin
            TControlHack(Self.Owner.components[i]).SetDesigning (false, true);
            if (Self.Owner.components[i] is TWinControl) then
              //?????SetMethodProp(Self.Owner.components[i], 'OnMouseDown', TMethod(WinCtrlMouseDown));
              if (Self.Owner.components[i] is TButton) then
                (Self.Owner.components[i] as TButton).OnMouseDown := WinCtrlMouseDown
              else
              if (Self.Owner.components[i] is TEdit) then
                (Self.Owner.components[i] as TEdit).OnMouseDown := WinCtrlMouseDown
          end
        else
          for i := 0 to (Self.Owner as TComponent).ComponentCount - 1 do
          begin
            TControlHack(Self.Owner.components[i]).SetDesigning (true, true);
              if (Self.Owner.components[i] is TButton) then
                (Self.Owner.components[i] as TButton).OnMouseDown := WinCtrlMouseDown
              else
              if (Self.Owner.components[i] is TEdit) then
                (Self.Owner.components[i] as TEdit).OnMouseDown := WinCtrlMouseDown
          end;
        (self.owner as TForm).invalidate;

      end;    }
  end;
  // call the default window procedure for every message
  Msg.Result := CallWindowProc (OldWndProc,
    FormHandle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

// property related methods

procedure TIMMIFormExt.SetBackBitmap(Value: TBitmap);
begin
  fBackBitmap.Assign (Value);
end;

procedure TIMMIFormExt.BackBitmapChanged (Sender: TObject);
begin
  (Owner as TForm).Invalidate;
end;

procedure Register;
begin
  //RegisterComponents('IMMI', []);
end;

procedure TIMMIFormExt.FormHide(Sender: TObject);
var Msg: TMessage;
begin
  if fFormVisible then
  begin
    fFormVisible := false;
   { TWinControlHack(Owner).NotifyControls(WM_IMMIUnInit);}
    Msg.Msg:=WM_IMMIUnInit;
    Immi_BroadCast(Self.Owner,Msg);
  end;

  if Assigned(FOnHideOld) then FOnHideOld(Owner);
end;

procedure TIMMIFormExt.FormShow(Sender: TObject);
var Msg: TMessage;
begin
 msg.Msg:=WM_IMMIUnInit;
  if fFormVisible then //если форма уже видна, то сначала деинициализировать
   { TWinControlHack(Owner).NotifyControls(WM_IMMIUnInit);}
     Immi_BroadCast(Self.Owner,Msg);
  fFormVisible := true;
  msg.Msg:=WM_IMMIUnInit;
 { TWinControlHack(Owner).NotifyControls(WM_IMMIInit);  }
 msg.Msg:=WM_IMMIInit;
  Immi_BroadCast(Self.Owner,Msg);
  Msg.Msg:=WM_IMMIUpdate;
 if application.tag<>1000 then{ TWinControlHack(Owner).NotifyControls(WM_IMMIUpdate)}Immi_BroadCast(Self.Owner,Msg);;

  if Assigned(FOnShowOld) then FOnShowOld(Owner);
end;

procedure TIMMIFormExt.SaveOwnerForm;
var
  BinStream:TMemoryStream;
  StrStream: TFileStream;
begin
    begin
      BinStream := TMemoryStream.Create;
      try
        StrStream := TFileStream.Create(DirForms + (self.Owner as TForm).Caption + '.frm', fmCreate);
        try
          BinStream.WriteComponent(self.owner);
          BinStream.Seek(0, soFromBeginning);
          ObjectBinaryToText(BinStream, StrStream);
          isModified := false;
        finally
          StrStream.Free;
        end;
      finally
        BinStream.Free
      end;
    end;
end;

procedure TIMMIFormExt.PopMenuBringToFront(Sender: TObject);
begin
  if RightClickedCtrl is TControl then (RightClickedCtrl as TControl).BringToFront;
end;

procedure TIMMIFormExt.PopMenuSendToBack(Sender: TObject);
begin
  if RightClickedCtrl is TControl then (RightClickedCtrl as TControl).SendToBack;
end;

{procedure TIMMIFormExt.PopMenuShowProp(Sender: TObject);
begin
  if RightClickedCtrl is TControl then (RightClickedCtrl as TControl).Perform(WM_IMMSHOWPROPFORM, 0, 0);
end;

procedure TIMMIFormExt.SetNewObjectPropertys(comp: TControl; Msg: TMessage);
begin
  with comp do
  begin
    parent := (owner as TForm);
    top := TWMMouse(Msg).YPos - Height;
    left := TWMMouse(Msg).XPos;
    TControlHack(comp).SetDesigning (true, true);
    comp.perform(WM_IMMIINIT, 0, 0);
  end;
  SendMessageBroadcast(WM_IMMIITEMCREATED, 0, 0);
end;

procedure TIMMIFormExt.WinCtrlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
    if (button = mbLeft) and (ToolMode = tmpoint) then
       TDdhSizerControl.Create(self.owner, Sender as TControl);
    if (button = mbRight) and (ToolMode <> tmrun) then
    begin
       pt := (Sender as TControl).clienttoscreen(point(x, y));
       menu.Popup(pt.x, pt.Y);
    end;
end;           }

end.
