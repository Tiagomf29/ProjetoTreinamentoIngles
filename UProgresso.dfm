object frmProgresso: TfrmProgresso
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Progresso'
  ClientHeight = 143
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object progresso: TGauge
    Left = 0
    Top = 0
    Width = 457
    Height = 143
    Align = alClient
    ForeColor = clNavy
    Progress = 0
    ExplicitLeft = 280
    ExplicitTop = 72
    ExplicitWidth = 100
    ExplicitHeight = 100
  end
  object timer: TTimer
    OnTimer = timerTimer
    Left = 208
    Top = 16
  end
end
