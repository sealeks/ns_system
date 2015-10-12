object frmSelectDir: TfrmSelectDir
  Left = 279
  Top = 207
  Width = 507
  Height = 167
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1082#1072#1090#1072#1083#1086#1075
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 392
    Top = 0
    Width = 107
    Height = 133
    Align = alRight
    TabOrder = 0
    object Button1: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = #1061#1086#1088#1086#1096#1086
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 16
      Top = 40
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object ShellTreeView: TShellTreeView
    Left = 0
    Top = 0
    Width = 392
    Height = 133
    ObjectTypes = [otFolders]
    Root = 'rfMyComputer'
    UseShellImages = True
    Align = alClient
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowButtons = False
    ShowRoot = False
    TabOrder = 1
  end
end
