object ImmiSysForm: TImmiSysForm
  Left = 512
  Top = 252
  Width = 462
  Height = 268
  Caption = 'C'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 376
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 376
    Top = 40
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object DriveComboBox1: TDriveComboBox
    Left = 8
    Top = 208
    Width = 353
    Height = 19
    TabOrder = 2
    OnChange = DriveComboBox1Change
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 8
    Top = 25
    Width = 353
    Height = 177
    ItemHeight = 16
    TabOrder = 3
    OnChange = DriveComboBox1Change
    OnClick = DirectoryOutline1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 1
    Width = 353
    Height = 21
    TabOrder = 4
    Text = 'Edit1'
  end
end
