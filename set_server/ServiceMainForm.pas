unit ServiceMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TNS_SET_ServIO = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
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
  NS_SET_ServIO: TNS_SET_ServIO;

implementation

uses ServerSETU;

{$R *.DFM}


procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  NS_SET_ServIO.Controller(CtrlCode);
end;

function TNS_SET_ServIO.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TNS_SET_ServIO.ServiceStart(Sender: TService; var Started: Boolean);
begin

  FormSETServer.PopupMenu1.Items[3].Visible:=false;
end;

procedure TNS_SET_ServIO.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
   FormSETServer.Stop;
  // FormSETServer.Free;
end;

procedure TNS_SET_ServIO.ServiceShutdown(Sender: TService);
begin
   FormSETServer.Stop;

  // FormSETServer.Free;
end;

procedure TNS_SET_ServIO.ServiceCreate(Sender: TObject);
begin
FormSETServer:=TFormSETServer.Create(self);
end;

procedure TNS_SET_ServIO.ServiceDestroy(Sender: TObject);
begin
FormSETServer.Free;
end;

end.
