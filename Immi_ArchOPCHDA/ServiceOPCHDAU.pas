unit ServiceOPCHDAU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,FormHDAClientUE;

type
  TServiceOPCHDA = class(TService)
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
  ServiceOPCHDA: TServiceOPCHDA;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceOPCHDA.Controller(CtrlCode);
end;

function TServiceOPCHDA.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServiceOPCHDA.ServiceStart(Sender: TService; var Started: Boolean);
begin

   FormHDAClient:=TFormHDAClient.create(application);
  // FormHDAClient.n3.visible:=false;

end;

procedure TServiceOPCHDA.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  // FormDDEClient.Button7Click(nil);
   FormHDAClient.Free;
end;

procedure TServiceOPCHDA.ServiceShutdown(Sender: TService);
begin
    // FormDDEClient.Button7Click(nil);
     FormHDAClient.Free;
end;

end.
