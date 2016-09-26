unit ServiceMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TNS_Logika_ServIO = class(TService)
    procedure ServiceStart(Sender: TService; var Started: boolean);
    procedure ServiceStop(Sender: TService; var Stopped: boolean);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  NS_Logika_ServIO: TNS_Logika_ServIO;

implementation

uses ServerLogikaU;

{$R *.DFM}


procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  NS_Logika_ServIO.Controller(CtrlCode);
end;

function TNS_Logika_ServIO.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TNS_Logika_ServIO.ServiceStart(Sender: TService; var Started: boolean);
begin

  FormLogikaServer.PopupMenu1.Items[3].Visible := False;
end;

procedure TNS_Logika_ServIO.ServiceStop(Sender: TService; var Stopped: boolean);
begin
  FormLogikaServer.Stop;
end;

procedure TNS_Logika_ServIO.ServiceShutdown(Sender: TService);
begin
  FormLogikaServer.Stop;
end;

procedure TNS_Logika_ServIO.ServiceCreate(Sender: TObject);
begin
  FormLogikaServer := TFormLogikaServer.Create(self);
end;

procedure TNS_Logika_ServIO.ServiceDestroy(Sender: TObject);
begin
  FormLogikaServer.Free;
end;

end.
