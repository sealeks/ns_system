unit NetShareSrvU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TIMMI_Net_Share = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceShutdown(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  IMMI_Net_Share: TIMMI_Net_Share;

implementation

uses NetShare;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  IMMI_Net_Share.Controller(CtrlCode);
end;

function TIMMI_Net_Share.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TIMMI_Net_Share.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  //Sleep(5000);
  //Application.ShowMainForm:=false;
  Application.CreateForm(TfrmNetShare, frmNetShare);
  //frmNetShare.Show;
  frmNetShare.N2.Visible := false;
end;

procedure TIMMI_Net_Share.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  frmNetShare.close;
  frmNetShare.free;
end;

procedure TIMMI_Net_Share.ServiceShutdown(Sender: TService);
begin
  frmNetShare.close;
  frmNetShare.free;
end;

end.
