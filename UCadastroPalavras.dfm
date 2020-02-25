object frmCadastroPalavras: TfrmCadastroPalavras
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cadastro de Palavras'
  ClientHeight = 474
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 732
    Height = 169
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 568
    object lblPalavraIngles: TLabel
      Left = 8
      Top = 16
      Width = 68
      Height = 13
      Caption = 'Palavra Ingl'#234's'
    end
    object lblPalavraPortugues: TLabel
      Left = 8
      Top = 64
      Width = 88
      Height = 13
      Caption = 'Palavra Portugu'#234's'
    end
    object Label1: TLabel
      Left = 8
      Top = 113
      Width = 25
      Height = 13
      Caption = 'Ativo'
    end
    object edtPalavraIngles: TEdit
      Left = 8
      Top = 35
      Width = 516
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object edtPalavraPortugues: TEdit
      Left = 8
      Top = 83
      Width = 516
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
    end
    object cbbAtivo: TComboBox
      Left = 8
      Top = 130
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      TabOrder = 2
      Items.Strings = (
        'Sim'
        'N'#227'o')
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 217
    Width = 732
    Height = 257
    Align = alBottom
    DataSource = DTS
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel2: TPanel
    Left = 0
    Top = 169
    Width = 732
    Height = 48
    TabOrder = 1
    object btnInserir: TBitBtn
      Left = 126
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Inserir'
      TabOrder = 0
      OnClick = btnInserirClick
    end
    object btnSalvar: TBitBtn
      Left = 207
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Salvar'
      TabOrder = 1
      OnClick = btnSalvarClick
    end
    object btnAlterar: TBitBtn
      Left = 288
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Alterar'
      TabOrder = 2
      OnClick = btnAlterarClick
    end
    object btnCancelar: TBitBtn
      Left = 369
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = btnCancelarClick
    end
    object btnExcluir: TBitBtn
      Left = 450
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Excluir'
      TabOrder = 4
      OnClick = btnExcluirClick
    end
    object btnFechar: TBitBtn
      Left = 531
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Fechar'
      TabOrder = 5
      OnClick = btnFecharClick
    end
  end
  object QRY: TZQuery
    Connection = DM.conexao
    SQL.Strings = (
      'select * from palavras order by 1')
    Params = <>
    Left = 328
    Top = 312
    object QRYID: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'C'#243'digo'
      FieldName = 'ID'
      Required = True
    end
    object QRYPALAVRAINGLES: TWideStringField
      DisplayLabel = 'Ingl'#234's'
      DisplayWidth = 30
      FieldName = 'PALAVRAINGLES'
      Required = True
      Size = 60
    end
    object QRYPALAVRAPORTUGUES: TWideStringField
      DisplayLabel = 'Portugu'#234's'
      DisplayWidth = 30
      FieldName = 'PALAVRAPORTUGUES'
      Required = True
      Size = 60
    end
    object QRYATIVO: TWideStringField
      DisplayLabel = 'Ativo'
      FieldName = 'ATIVO'
      Required = True
      Size = 1
    end
  end
  object DTS: TDataSource
    AutoEdit = False
    DataSet = CDS
    Left = 152
    Top = 296
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP'
    AfterScroll = CDSAfterScroll
    Left = 248
    Top = 272
    object CDSID: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'C'#243'digo'
      DisplayWidth = 5
      FieldName = 'ID'
      Required = True
    end
    object CDSPALAVRAINGLES: TWideStringField
      DisplayLabel = 'Palavra Ingl'#234's'
      DisplayWidth = 60
      FieldName = 'PALAVRAINGLES'
      Required = True
      Size = 60
    end
    object CDSPALAVRAPORTUGUES: TWideStringField
      DisplayLabel = 'Palavra Portugues'
      DisplayWidth = 60
      FieldName = 'PalavraPortugues'
      Required = True
      Size = 60
    end
    object CDSATIVO: TWideStringField
      FieldName = 'Ativo'
      Required = True
      Size = 1
    end
  end
  object DSP: TDataSetProvider
    DataSet = QRY
    Left = 296
    Top = 264
  end
end
