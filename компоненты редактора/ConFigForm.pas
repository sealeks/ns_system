unit ConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, FileCtrl, CheckLst,StrUtils,globalValue;

type
  TForm11 = class(TForm)
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
  Red: TComponent;
  RemoveList: TList;
  AddList: TList;
  destructor Destroy; override;
  procedure Shows(path: string);
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses Redactor;

 procedure TForm11.Shows(path: string);
 var
  fi: TextFile;
  filn: string;
  formf: string;
  fileNameP: string;
  i: integer;
  sf: TForm;
  FormStringList: TStringList;
 begin
  RemoveList:=TList.Create;
  AddList:=TList.Create;
  ListBox1.Clear;

  ListBox1.Items.LoadFromFile(FormsDir+'config.cfg');

  if showmodal=MrOk then
    begin
    ListBox1.Items.SaveToFile(FormsDir+'config.cfg');
    while 0<RemoveList.Count do
    begin
      i:=0;
      while i<(red as TRedactor).RedactorForm.Count do
       begin
       if (red as TRedactor).RedactorForm.Items[i]=RemoveList.Items[0] then
          begin
             tform((red as TRedactor).RedactorForm.Items[i]).Free;
             (red as TRedactor).RedactorForm.Delete(i);
          end else inc(i);
       end;
      RemoveList.Delete(0);
    end;
      (red as TRedactor).updatelist;
     { (red as TRedactor).ActivWind:=(red as TRedactor).RedactorForm.Count-1; }
      (red as TRedactor).PropertyForm;
    end else
    begin
      while 0<addList.Count do
    begin
      i:=0;
      while i<(red as TRedactor).RedactorForm.Count do
       begin
       if (red as TRedactor).RedactorForm.Items[i]=addList.Items[0] then
          begin
             tform((red as TRedactor).RedactorForm.Items[i]).Free;
             (red as TRedactor).RedactorForm.Delete(i);
          end else inc(i);
       end;
      addList.Delete(0);
    end;
      (red as TRedactor).updatelist;
     { (red as TRedactor).ActivWind:=(red as TRedactor).RedactorForm.Count-1;}
      (red as TRedactor).PropertyForm;

    end;
  RemoveList.Free;
  AddList.Free;
end;






procedure TForm11.Button3Click(Sender: TObject);
begin
Modalresult:=MrOk;
end;

procedure TForm11.Button2Click(Sender: TObject);
begin
ModalResult:=MrNo;
end;

destructor TForm11.Destroy;
begin

 inherited;

end;

procedure TForm11.Button1Click(Sender: TObject);
var fl: boolean;
    i: integer;
    str: string;
begin
   OpenDialog1.InitialDir:=FormsDir;
  if OpenDialog1.Execute then
  begin
  str:=LeftStr(ExtractFileName(OpenDialog1.FileName),Length(ExtractFileName(OpenDialog1.FileName))-4);
  if listbox1.Items.IndexOf(str)<0 then
    begin
      listbox1.Items.Add(str);
      fl:=false;
      for i:=0 to (red as TRedactor).RedactorForm.Count-1 do
        if  tform((red as TRedactor).RedactorForm.Items[i]).Caption=str then fl:=true;
       if not fl then (red as TRedactor).OpenForm(OpenDialog1.FileName);
       AddList.Add((red as TRedactor).RedactorForm.last)
    end
  end;
  { (red as TRedactor).ActivWind:=(red as TRedactor).RedactorForm.Count-1;   }
   (red as TRedactor).PropertyForm;
  self.Show;
end;

procedure TForm11.Button4Click(Sender: TObject);
var i,j: integer;
    formn: TForm;
begin
 i:=0;
 while i<listbox1.Items.Count do
   begin
     if listbox1.Selected[i] then
        begin
         if MessageBox(0,PChar('Удалить форму "'+ listbox1.Items.strings[i]+ '" из прокта?'),'Удаление',
         MB_YESNOCANCEL+MB_ICONQUESTION+MB_TOPMOST)=IDYES then
            begin
              formn:=nil;
              for j:=0 to (red as TRedactor).RedactorForm.Count-1 do
                  if  tform((red as TRedactor).RedactorForm.Items[j]).Caption=listbox1.Items.Strings[i]
                                                  then formn:=tform((red as TRedactor).RedactorForm.Items[j]);
               if formn<>nil then RemoveList.add(formn);

               listbox1.Items.Delete(i);
               dec(i);
            end;
        end;
       inc(i);
   end;
end;

procedure TForm11.SpeedButton1Click(Sender: TObject);
var i,j: integer;
begin
  for i:=Listbox1.Count-1 downto 0 do
     if Listbox1.Selected[i]  then
          begin
              if ((i+1)=Listbox1.Count) then j:=i else j:=i+1;
              Listbox1.Items.Exchange(i,j);
               Listbox1.Selected[j]:=true;
          end;
       
end;

procedure TForm11.SpeedButton2Click(Sender: TObject);
var i,j: integer;
begin
  for i:=0 to Listbox1.Count-1 do
     if Listbox1.Selected[i]  then
          begin
              if (i=0) then j:=i else j:=i-1;
              Listbox1.Items.Exchange(i,j);
              Listbox1.Selected[j]:=true;
          end;

end;

end.
