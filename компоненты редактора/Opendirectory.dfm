object Form12: TForm12
  Left = 349
  Top = 211
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #1054#1090#1082#1088#1099#1090#1080#1077' '#1082#1072#1090#1072#1083#1086#1075#1072
  ClientHeight = 196
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 16
    Top = 8
    Width = 313
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object DriveComboBox1: TDriveComboBox
    Left = 336
    Top = 8
    Width = 113
    Height = 19
    TabOrder = 1
    OnChange = DriveComboBox1Change
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 16
    Top = 40
    Width = 305
    Height = 113
    ItemHeight = 16
    TabOrder = 2
    OnChange = DirectoryListBox1Change
  end
  object Button1: TButton
    Left = 296
    Top = 168
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 384
    Top = 168
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = Button2Click
  end
  object FileListBox1: TFileListBox
    Left = 328
    Top = 40
    Width = 129
    Height = 113
    ItemHeight = 13
    TabOrder = 5
  end
end
