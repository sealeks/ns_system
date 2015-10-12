unit ServiceForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,  DM1Us, Dm2Us,  GlobalValue,
  ExtCtrls;

type
  TService1 = class(TService)
    Timer1: TTimer;
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceExecute(Sender: TService);
   // function GetServiceController: TServiceController;
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  Service1: TService1;
  starttime: TDateTime;
implementation

{$R *.DFM}



procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Service1.Controller(CtrlCode);

end;



function TService1.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TService1.ServiceCreate(Sender: TObject);
begin
   //service1.ServiceType:=stWin32;
  //  starttime:=now;
    Dm2:=TDm2s.Create(self);
   Dm1:=TDm1s.Create(self);
   if FindWindow('TForm1','Сервер данных Logika')=0 then WinExec(PChar(PathEthSer),SW_RESTORE);
   WinExec(PChar(PathSer),SW_RESTORE);
   //Service1.ServiceExecute(self);
end;

procedure TService1.ServiceStart(Sender: TService; var Started: Boolean);
begin
started:=true;
end;

procedure TService1.ServiceExecute(Sender: TService);
begin
while not Terminated do begin
      ServiceThread.ProcessRequests(True);
    end;


end;

end.
