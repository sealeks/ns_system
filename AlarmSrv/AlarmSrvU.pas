unit AlarmSrvU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  Forms, ActiveX,
  ConfigurationSys, MemStructsU, GlobalValue, constDef, ExtCtrls, AlarmSrvFormU;

type
  TNS_MemBaseService = class(TService)
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
  NS_MemBaseService: TNS_MemBaseService;

implementation


{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  NS_MemBaseService.Controller(CtrlCode);
end;

function TNS_MemBaseService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TNS_MemBaseService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Application.CreateForm(TAlarmSrvForm, AlarmSrvForm);
end;

procedure TNS_MemBaseService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  AlarmSrvForm.close;
  AlarmSrvForm.Free;
end;

procedure TNS_MemBaseService.ServiceShutdown(Sender: TService);
begin
  AlarmSrvForm.close;
  AlarmSrvForm.Free;
end;

end.
