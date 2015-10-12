object FormSelectOsc: TFormSelectOsc
  Left = 375
  Top = 176
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1086#1089#1094#1080#1083#1086#1075#1088#1072#1084#1084#1099
  ClientHeight = 400
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  DesignSize = (
    546
    400)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 13
    Top = 34
    Width = 522
    Height = 27
  end
  object Label1: TLabel
    Left = 24
    Top = 40
    Width = 151
    Height = 13
    Caption = #1042#1099#1073#1088#1072#1085#1072' '#1086#1089#1094#1080#1083#1083#1086#1075#1088#1072#1084#1084#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 22
    Top = 10
    Width = 9
    Height = 13
    Caption = #1057
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 232
    Top = 9
    Width = 17
    Height = 13
    Caption = #1055#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 184
    Top = 40
    Width = 36
    Height = 13
    Caption = #1055#1091#1089#1090#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DateTimePicker1: TDateTimePicker
    Left = 40
    Top = 5
    Width = 177
    Height = 22
    Anchors = [akLeft, akBottom]
    Date = 36205.382976157410000000
    Time = 36205.382976157410000000
    TabOrder = 0
    OnChange = DateTimePicker1Change
  end
  object DateTimePicker2: TDateTimePicker
    Left = 256
    Top = 5
    Width = 177
    Height = 22
    Anchors = [akLeft, akBottom]
    Date = 36205.382976157410000000
    Time = 36205.382976157410000000
    TabOrder = 1
    OnChange = DateTimePicker2Change
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 72
    Width = 529
    Height = 289
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'tm'
        Title.Caption = #1042#1088#1077#1084#1103
        Width = 119
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'iName'
        Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'iComment'
        Title.Caption = #1050#1086#1084#1077#1085#1090#1072#1088#1080#1081
        Width = 324
        Visible = True
      end>
  end
  object Button1: TImmiButtonXp
    Left = 384
    Top = 368
    Cursor = crHandPoint
    About = 'Design eXperience. '#169' 2002 M. Hoffmann'
    Version = '1.0.2g'
    Caption = #1042#1099#1073#1086#1088
    TabOrder = 3
    ModalResult = 6
    Param.vals = 0
    Param.Access = 0
    Param.isOff = False
    Param.isLogin = False
    Param.isreset = False
    FormManager.ShowMod = False
    FormManager.NotCloseModal = False
    FormManager.CaverModal = False
    FormManager.BeepTime = 0
    FormManager.reinit = False
    FormManager.ClickManagment = False
    FormManager.FPosition.FormTop = -1
    FormManager.FPosition.FormLeft = -1
  end
  object Button2: TImmiButtonXp
    Left = 464
    Top = 368
    Cursor = crHandPoint
    About = 'Design eXperience. '#169' 2002 M. Hoffmann'
    Version = '1.0.2g'
    OnClick = Button2Click
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    ModalResult = 2
    Param.vals = 0
    Param.Access = 0
    Param.isOff = False
    Param.isLogin = False
    Param.isreset = False
    FormManager.ShowMod = False
    FormManager.NotCloseModal = False
    FormManager.CaverModal = False
    FormManager.BeepTime = 0
    FormManager.reinit = False
    FormManager.ClickManagment = False
    FormManager.FPosition.FormTop = -1
    FormManager.FPosition.FormLeft = -1
  end
  object TrendOs: TADOConnection
    LoginPrompt = False
    BeforeConnect = TrendOsBeforeConnect
    Left = 16
    Top = 368
  end
  object ADOQuery1: TADOQuery
    Connection = TrendOs
    Parameters = <>
    Left = 48
    Top = 368
  end
  object DataSource1: TDataSource
    Left = 112
    Top = 368
  end
end
