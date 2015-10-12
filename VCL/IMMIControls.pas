unit IMMIControls;

interface

uses
    controls, constDef;

type
  TIMMIGraphicControl  = class(TGraphicControl)
  public
    procedure Init(ContName: String); virtual; abstract;
    procedure UnInit; virtual; abstract;
    procedure UpdateValue; virtual; abstract;
  end;



implementation
end.
