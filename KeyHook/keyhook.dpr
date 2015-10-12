

library keyhook;

uses
  SysUtils,
  Windows,
  Messages,
  Constdef,
  Forms, dialogs;


const
  MMFName: PChar = 'KeyMMF';

type
  PGlobalDLLData = ^TGlobalDLLData;
  TGlobalDLLData = packed record
    SysHook: HWND; // ?????????? ????????????? ???????
    MyAppWnd: HWND; // ?????????? ?????? ??????????
  end;

var
  GlobalData: PGlobalDLLData;
  MMFHandle: THandle;





function KeyboardProc(code : integer; wParam : word; lParam : longint) : longint; stdcall;
begin

  if (GlobalData=nil) then exit;
  if (code < 0)then
  begin
   Result:= CallNextHookEx(GlobalData^.syshook, Code, wParam, lParam);
    Exit;
  end;

  if {code=WM_KEYUP} true then
   begin
    // if GlobalData<>nil then
    // begin
    // showMessage(inttostr(GlobalData^.MyAppWnd));
    if code=WM_KEYUP then lparam:=0 else lparam:=1;
     postMessage(GlobalData^.MyAppWnd, WM_IMMIKEYSET, lParam, wParam);
    // end;
     //PostThreadMessage(0, WM_IMMIKEYSET, wParam, lParam);
   end;

  CallNextHookEx(GlobalData^.syshook, Code, wParam, lParam);
  Result:= 0;

end;

{Процедура установки HOOK-а}
procedure hook(switch : Boolean; hMainProg: HWND) export; stdcall;
begin

  if (GlobalData=nil) then exit;
  if switch=true then
  begin
    GlobalData^.syshook:=SetWindowsHookEx(WH_KEYBOARD, @KeyboardProc, HInstance, 0);
    if GlobalData^.syshook=0 then
    MessageBox(0, 'Работа с функциональной клавиатурой не возможна !', 'Message from keyhook.dll', 0);
    if GlobalData<>nil then
    GlobalData^.MyAppWnd:= hMainProg;
     //showMessage(inttostr(MyAppWnd));
  end
  else
  begin
     if UnhookWindowsHookEx(GlobalData^.SysHook) then
    //  MessageBox(0, 'Не удалось НООК для функциональной клавиатуры !', 'Message from keyhook.dll', 0);
  end;
end;


procedure OpenGlobalData();
begin

  MMFHandle:= CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, SizeOf(HWND), MMFName);

  if MMFHandle = 0 then
    begin
      Exit;
    end;
  GlobalData:= MapViewOfFile(MMFHandle, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TGlobalDLLData));
  if GlobalData = nil then
    begin
      CloseHandle(MMFHandle);

      Exit;
    end;

end;

procedure CloseGlobalData();
begin
  UnmapViewOfFile(globaldata);
  CloseHandle(MMFHandle);
end;

procedure DLLEntryPoint(dwReason: DWord); stdcall;
begin
 case dwReason of
   // DLL_PROCESS_ATTACH:   OpenGlobalData;
    DLL_PROCESS_DETACH: CloseGlobalData;
  end;
end;

exports hook;

begin
 //DLLProc:= @DLLEntryPoint;
 //DLLEntryPoint(DLL_PROCESS_ATTACH);
 OpenGlobalData;
end.

