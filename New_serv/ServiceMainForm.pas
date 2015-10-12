unit ServiceMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,ServerU;

type
  TNS_KoyoIOService = class(TService)
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
  NS_KoyoIOService: TNS_KoyoIOService;

implementation

{$R *.DFM}


procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  NS_KoyoIOService.Controller(CtrlCode);
end;

function TNS_KoyoIOService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TNS_KoyoIOService.ServiceStart(Sender: TService; var Started: Boolean);
begin
 // Application.CreateForm(TFormComServer, FormComServer);
//  FormComServer.PopupMenu1.Items.Items[4].Free;
if FormComServer.fSattus=ssStop then  FormComServer.it1Click(nil);
  FormComServer.PopupMenu1.Items[1].Visible:=false;
  FormComServer.PopupMenu1.Items[2].Visible:=false;
  FormComServer.PopupMenu1.Items[3].Visible:=false;
 // FormComServer.PopupMenu1.Items[0].Visible:=false;
end;

procedure TNS_KoyoIOService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
 if FormComServer.fSattus=ssStart then   FormComServer.it2Click(nil);
end;

procedure TNS_KoyoIOService.ServiceShutdown(Sender: TService);
begin
  // FormComServer.N3Click(nil);
   FormComServer.Free;  
end;

end.
