object frmParametros: TfrmParametros
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Par'#226'metros'
  ClientHeight = 234
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 153
    Height = 73
    Caption = 'Tipos de letras'
    Items.Strings = (
      'Exibir letras mai'#250'sculas'
      'Exibir letras minusculas')
    TabOrder = 0
  end
  object RadioGroup2: TRadioGroup
    Left = 155
    Top = 0
    Width = 322
    Height = 73
    Caption = 'Apresenta'#231#227'o de palavras'
    Columns = 2
    Items.Strings = (
      '1 palavra por vez'
      '4 palavras por vez'
      '8 palavras por vez'
      '12 palavras por vez')
    TabOrder = 1
  end
  object btnGravar: TBitBtn
    Left = 202
    Top = 205
    Width = 75
    Height = 25
    Caption = 'Gravar'
    TabOrder = 2
    OnClick = btnGravarClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 79
    Width = 177
    Height = 122
    Caption = 'Grupo de palavras para exibi'#231#227'o'
    TabOrder = 3
    object Label1: TLabel
      Left = 11
      Top = 23
      Width = 61
      Height = 13
      Caption = 'De: c'#243'digo - '
    end
    object Label2: TLabel
      Left = 11
      Top = 69
      Width = 62
      Height = 13
      Caption = 'At'#233': c'#243'digo -'
    end
    object Edit1: TEdit
      Left = 11
      Top = 42
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 11
      Top = 88
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 1
    end
  end
  object cbRepetirPalavras: TCheckBox
    Left = 192
    Top = 88
    Width = 161
    Height = 17
    Caption = 'Repetir palavras acertadas'
    TabOrder = 4
  end
  object cbParMesclaPalavrasDia: TCheckBox
    Left = 192
    Top = 134
    Width = 201
    Height = 17
    Caption = 'Divide Palavras por dia'
    TabOrder = 6
  end
  object cbOrdenarPalavras: TCheckBox
    Left = 192
    Top = 157
    Width = 201
    Height = 17
    Caption = 'Ordenar palavras alfabeticamente'
    Enabled = False
    TabOrder = 7
  end
  object cbPalavrasAleatorias: TCheckBox
    Left = 192
    Top = 111
    Width = 201
    Height = 17
    Caption = 'Palavras sorteadas aleat'#243'riamente'
    Enabled = False
    TabOrder = 5
  end
  object cbExibirSomenteAudio: TCheckBox
    Left = 192
    Top = 176
    Width = 153
    Height = 17
    Caption = 'somente '#225'udio em ingl'#234's'
    TabOrder = 8
  end
end
