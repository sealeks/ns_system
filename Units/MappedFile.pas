unit MappedFile;

interface

uses Windows, sysUtils;

type
TMappedFile = class
private
       hMapping: THandle;
       function OpenMappedFile: Boolean;
public
      mapName, filename: string;
      Data: pointer;
      FileSize: DWORD;
      constructor Create (fileNm, mapNm: string); //mapNm - имя файла в памяти
      destructor Destroy; override;
end;


implementation
constructor TMappedFile.Create (fileNm, mapNm : string);
begin
     mapName := mapNm;
     fileName := fileNm;
     if not OpenMappedFile then
        raise Exception.Create ('Невозможно загрузить файл ' +
                                                      fileName +' в память');
end;

destructor Tmappedfile.Destroy;
begin
    if not UnMapViewOfFile(Data) then
      raise Exception.Create('No unmapping '+ mapName);
    if not CloseHandle(hMapping) then
      raise Exception.Create('No closing' + mapName);
    inherited;
end;

function TMappedFile.OpenMappedFile: Boolean;
var
  hFile: THandle;
  HighSize: DWORD;

begin
  Result := False;

  if Length(FileName) = 0 then Exit;
    hFile := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
             FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_ALWAYS,
             FILE_FLAG_RANDOM_ACCESS, 0);

  if (hFile = 0) then Exit;

  FileSize := GetFileSize(hFile, @HighSize);

  hMapping := CreateFileMapping(hFile, nil, PAGE_READWRITE,
                               0, 0, PChar(mapName));

  if (hMapping = 0) then begin
    CloseHandle(hFile);
    Exit;
  end;

  CloseHandle(hFile);

  Data := MapViewOfFile(hMapping, FILE_MAP_ALL_ACCESS, 0, 0, 0);

  if (Data <> nil) then Result := True;
end;

end.
