unit ServiceOPCGatwayU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,FormOPCClientUE;

type
  TServiceOPCGatway = class(TService)
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
  ServiceOPCGatway: TServiceOPCGatway;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceOPCGatway.Controller(CtrlCode);
end;

function TServiceOPCGatway.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServiceOPCGatway.ServiceStart(Sender: TService; var Started: Boolean);
begin
   FormDDEClient:=TFormDDEClient.create(application);
   FormDDEClient.n3.visible:=false;

end;

procedure TServiceOPCGatway.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  // FormDDEClient.Button7Click(nil);
   FormDDEClient.Free;
end;

procedure TServiceOPCGatway.ServiceShutdown(Sender: TService);
begin
    // FormDDEClient.Button7Click(nil);
     FormDDEClient.Free;
end;

end.
