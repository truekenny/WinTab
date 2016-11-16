object Frm: TFrm
  Left = 0
  Top = 0
  Caption = 'Frm'
  ClientHeight = 411
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 32
    Top = 24
  end
  object PopupMenu: TPopupMenu
    Left = 88
    Top = 24
    object pmQuit: TMenuItem
      Caption = 'Quit'
      OnClick = pmQuitClick
    end
  end
end
