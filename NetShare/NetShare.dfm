object frmNetShare: TfrmNetShare
  Left = 652
  Top = 317
  Width = 657
  Height = 357
  Caption = 'frmNetShare'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
    FFFFFFFFFFFFFFFFF11111FFFFFFFFF111BBB111FFFFFF11BBBBBB111FFFF11B
    BBBBBBBB11FFF1BB44BBB44BB1FF11BB44BBB44BB11F1BBB44BB444BBB1F1BBB
    44B4444BBB1F11BB4444B44BB11FF1BB444BB44BB1FFF11B44BBB44B11FFFF11
    BBBBBBB11FFFFFF111BBB111FFFFFFFFF11111FFFFFFFFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 311
    Width = 649
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 649
    Height = 311
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1050#1083#1080#1077#1085#1090
      object StringGrid1: TStringGrid
        Left = 0
        Top = 0
        Width = 512
        Height = 283
        Align = alClient
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnDblClick = StringGrid1DblClick
        ColWidths = (
          41
          56
          224
          64
          64)
      end
      object Panel2: TPanel
        Left = 512
        Top = 0
        Width = 129
        Height = 283
        Align = alRight
        TabOrder = 1
        object Label2: TLabel
          Left = 8
          Top = 8
          Width = 100
          Height = 13
          Caption = #1055#1077#1088#1080#1086#1076' '#1086#1087#1088#1086#1089#1072' ('#1084#1089')'
        end
        object Label3: TLabel
          Left = 8
          Top = 56
          Width = 112
          Height = 13
          Caption = #1054#1078#1080#1076#1072#1085#1080#1077' '#1086#1090#1074#1077#1090#1072' ('#1084#1089')'
        end
        object Button1: TButton
          Left = 16
          Top = 136
          Width = 75
          Height = 25
          Caption = #1055#1086#1096#1072#1075#1086#1074#1086
          TabOrder = 0
          Visible = False
          OnClick = Button3Click
        end
        object CheckBox1: TCheckBox
          Left = 16
          Top = 168
          Width = 49
          Height = 17
          Caption = #1040#1074#1090#1086
          Checked = True
          State = cbChecked
          TabOrder = 1
          Visible = False
          OnClick = CheckBox1Click
        end
        object SpinEdit2: TSpinEdit
          Left = 8
          Top = 24
          Width = 89
          Height = 22
          Increment = 100
          MaxValue = 0
          MinValue = 0
          TabOrder = 2
          Value = 1000
          OnChange = SpinEdit2Change
        end
        object SpinEdit3: TSpinEdit
          Left = 8
          Top = 72
          Width = 89
          Height = 22
          Increment = 100
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 1000
          OnChange = SpinEdit3Change
        end
        object Button2: TButton
          Left = 16
          Top = 112
          Width = 75
          Height = 25
          Caption = #1058#1077#1075#1080
          TabOrder = 4
          OnClick = StringGrid1DblClick
        end
        object cbSelfCheck: TCheckBox
          Left = 16
          Top = 184
          Width = 97
          Height = 17
          Caption = 'SelfTest'
          Checked = True
          State = cbChecked
          TabOrder = 5
          Visible = False
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1077#1088#1074#1077#1088
      ImageIndex = 1
      object StringGrid2: TStringGrid
        Left = 0
        Top = 0
        Width = 520
        Height = 276
        Align = alClient
        FixedCols = 0
        RowCount = 25
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnDblClick = StringGrid2DblClick
        ColWidths = (
          97
          82
          85
          77
          105)
      end
      object Panel1: TPanel
        Left = 520
        Top = 0
        Width = 121
        Height = 276
        Align = alRight
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 32
          Width = 79
          Height = 13
          Caption = #1054#1078#1080#1076#1072#1085#1080#1077' ('#1089#1077#1082')'
        end
        object CheckBox2: TCheckBox
          Left = 8
          Top = 8
          Width = 97
          Height = 17
          Caption = #1057#1077#1088#1074#1077#1088' '#1075#1086#1090#1086#1074
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CheckBox2Click
        end
        object SpinEdit1: TSpinEdit
          Left = 8
          Top = 48
          Width = 89
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 10
        end
        object Button3: TButton
          Left = 16
          Top = 144
          Width = 75
          Height = 25
          Caption = #1058#1077#1075#1080
          TabOrder = 2
          OnClick = StringGrid2DblClick
        end
      end
    end
  end
  object tmrClientTic: TTimer
    Interval = 100
    OnTimer = tmrClientTicTimer
    Left = 608
    Top = 240
  end
  object Timer2: TTimer
    Interval = 3000
    OnTimer = Timer2Timer
    Left = 608
    Top = 264
  end
  object ServerSocket1: TServerSocket
    Active = True
    Port = 1000
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 544
    Top = 232
  end
  object PopupMenu1: TPopupMenu
    Left = 572
    Top = 264
    object N1: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074' '#1086#1082#1085#1077
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = N2Click
    end
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    Left = 572
    Top = 232
  end
end
