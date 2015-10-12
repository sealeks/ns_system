unit ServiceArchU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,dm1Us;

type
  TNS_ArchiveService = class(TService)
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  NS_ArchiveService: TNS_ArchiveService;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  NS_ArchiveService.Controller(CtrlCode);
end;

function TNS_ArchiveService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TNS_ArchiveService.ServiceCreate(Sender: TObject);
begin
    dm1:=Tdm1s.Create(self);
    dm1.Myserv:=self;
   // dm1.PopupMenu1.Items[4].Visible:=false;
   // dm1.PopupMenu1.Items[3].Visible:=false;;
   // dm1.Button3.Visible:=false;
end;

procedure TNS_ArchiveService.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
    dm1.RunSt:=true;
end;

procedure TNS_ArchiveService.ServicePause(Sender: TService; var Paused: Boolean);
begin
  dm1.RunSt:=false;
end;

procedure TNS_ArchiveService.ServiceShutdown(Sender: TService);
begin
   dm1.RunSt:=false;
end;

procedure TNS_ArchiveService.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
    dm1.RunSt:=true;
end;

procedure TNS_ArchiveService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
   
   dm1.RunSt:=false;
end;

end.
