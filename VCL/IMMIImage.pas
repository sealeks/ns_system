unit IMMIImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef,
  memStructsU,
  ParamU;


type
  TIMMIImage = class(TImage)
  private
    { Private declarations }
    fParam: tParam;
    fOnPicture, fOffPicture: tPicture;
    isOn: boolean;
    procedure SetOnPicture (source: tPicture);
    procedure SetOffPicture (source: tPicture);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
  published
    { Published declarations }
    property Param: tParam read fParam write fParam;
    property OnPicture: tPicture read fOnPicture write SetOnPicture;
    property OffPicture: tPicture read fOffPicture write SetOffPicture;
  end;

procedure Register;

implementation

constructor TIMMIImage.Create(AOwner: TComponent);
begin
     inherited;
     fParam := tParam.Create;
     fOnPicture := tPicture.Create;
     fOffPicture := tPicture.Create;
     isOn := false;
end;

procedure TIMMIImage.ImmiInit (var Msg: TMessage);
begin
  Param.Init(name);
end;

procedure TIMMIImage.ImmiUnInit (var Msg: TMessage);
begin
  Param.UnInit;
end;

procedure TIMMIImage.ImmiUpdate (var Msg: TMessage);
var
   mustOn: boolean;
begin
     mustOn := (fParam.Value <> 0);
     if isOn <> mustOn then begin
        isOn := mustOn;
        if isOn then
           picture.Assign(fOnPicture)
        else
           picture.Assign(fOffPicture);
     end;
end;

procedure TIMMIImage.SetOnPicture (source: tPicture);
begin
     fOnPicture.Assign(source);
end;

procedure TIMMIImage.SetOffPicture (source: tPicture);
begin
     fOffPicture.Assign(source);
end;

procedure Register;
begin
  RegisterComponents('IMMIold', [TIMMIImage]);
end;

end.
