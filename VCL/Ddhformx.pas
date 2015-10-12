unit DdhFormX;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls;

type
  TDdhFormExt = class(TComponent)
  private
    // window procedures
    OldWndProc, NewWndProc: Pointer;
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
    procedure SetBackBitmap (Value: TBitmap);
  protected
    function FormHandle: THandle;
    procedure NewWndMethod (var Msg: TMessage);
    procedure BackBitmapChanged (Sender: TObject);
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
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
  end;

procedure Register;

implementation

constructor TDdhFormExt.Create (AOwner: TComponent);
var
  I: Integer;
begin
    if (AOwner = nil) then
      raise Exception.Create (
        'Owner of DdhFormExt component is nil');
    if not (AOwner is TForm) then
      raise Exception.Create (
      'Owner of DdhFormExt component must be a form');
  // create a single instance only
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TDdhFormExt then
      raise Exception.Create (
        'DdhFormExt component duplicated in ' +
        AOwner.Name);
  // default creation
  inherited Create (AOwner);
  // form subclassing (runtime only)
  if not (csDesigning in ComponentState) then
  begin
    NewWndProc := MakeObjectInstance (NewWndMethod);
    OldWndProc := Pointer (SetWindowLong (
      FormHandle, gwl_WndProc, Longint (NewWndProc)));
  end
  else
  begin
    // default values
    NewWndProc := nil;
    OldWndPRoc := nil;
  end;
  fBackBitmap := TBitmap.Create;
  fBackBitmap.OnChange := BackBitmapChanged;
end;

destructor TDdhFormExt.Destroy;
begin
  if Assigned (NewWndProc) then
  begin
    FreeObjectInstance (NewWndProc);
    {SetWindowLong (FormHandle, gwl_WndProc,
      Longint (OldWndProc));}
  end;
  fBackBitmap.Free;
  inherited Destroy;
end;

function TDdhFormExt.FormHandle: THandle;
begin
  Result := (Owner as TForm).Handle;
end;

// custom window procedure

procedure TDdhFormExt.NewWndMethod (var Msg: TMessage);
var
  ix, iy: Integer;
  ClientWidth, ClientHeight: Integer;
  BmpWidth, BmpHeight: Integer;
  hCanvas, BmpCanvas: THandle;
  pMinMax: PMinMaxInfo;
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
  end;
  // call the default window procedure for every message
  Msg.Result := CallWindowProc (OldWndProc,
    FormHandle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

// property related methods

procedure TDdhFormExt.SetBackBitmap(Value: TBitmap);
begin
  fBackBitmap.Assign (Value);
end;

procedure TDdhFormExt.BackBitmapChanged (Sender: TObject);
begin
  (Owner as TForm).Invalidate;
end;

procedure Register;
begin
  RegisterComponents('DDHB', [TDdhFormExt]);
end;

end.
