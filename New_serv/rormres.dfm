object FormRecept: TFormRecept
  Left = 422
  Top = 161
  Width = 296
  Height = 192
  Caption = #1056#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1086#1087#1088#1086#1089#1072
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
    FFFFFFFFFFFFFF44444444444FFFFF477777777744FFFF479977777744FFFF47
    99777777444FFF4799777777444FFF4777777777444FFF4799777777444FFF47
    997777A7444FFF4777777777444FFF4444444444444FFFF477777777744FFFFF
    47777777774FFFFFF4444444444FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    288
    165)
  PixelsPerInch = 96
  TextHeight = 13
  object ColorStringGrid1: TColorStringGrid
    Left = 0
    Top = 0
    Width = 288
    Height = 128
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    DefaultRowHeight = 18
    RowCount = 5
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    minRowCount = 4
    ColWidths = (
      64
      108
      109)
  end
  object ImmiButtonXp1: TImmiButtonXp
    Left = 132
    Top = 137
    Cursor = crHandPoint
    Anchors = [akRight, akBottom]
    About = 'Design eXperience. '#169' 2002 M. Hoffmann'
    Version = '1.0.2g'
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
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
  object ImmiButtonXp2: TImmiButtonXp
    Left = 212
    Top = 137
    Cursor = crHandPoint
    Anchors = [akRight, akBottom]
    About = 'Design eXperience. '#169' 2002 M. Hoffmann'
    Version = '1.0.2g'
    Caption = #1054#1082
    TabOrder = 2
    ModalResult = 1
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
end
