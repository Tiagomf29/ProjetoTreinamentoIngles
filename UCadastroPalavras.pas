unit UCadastroPalavras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,System.StrUtils,
  Vcl.DBGrids, Vcl.ExtCtrls, UDM, Data.DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, Vcl.DBCtrls, Vcl.Mask, Datasnap.Provider, Datasnap.DBClient;

type
  TfrmCadastroPalavras = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    lblPalavraIngles: TLabel;
    lblPalavraPortugues: TLabel;
    QRY: TZQuery;
    DTS: TDataSource;
    QRYID: TIntegerField;
    QRYPALAVRAINGLES: TWideStringField;
    QRYPALAVRAPORTUGUES: TWideStringField;
    QRYATIVO: TWideStringField;
    Label1: TLabel;
    edtPalavraIngles: TEdit;
    edtPalavraPortugues: TEdit;
    cbbAtivo: TComboBox;
    Panel2: TPanel;
    btnInserir: TBitBtn;
    btnSalvar: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnExcluir: TBitBtn;
    btnFechar: TBitBtn;
    CDS: TClientDataSet;
    DSP: TDataSetProvider;
    CDSID: TIntegerField;
    CDSPALAVRAINGLES: TWideStringField;
    CDSPALAVRAPORTUGUES: TWideStringField;
    CDSATIVO: TWideStringField;
    procedure FormShow(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
  private
    procedure statusBotaoInserir();
    procedure statusBotaoNaoInserir();
    var
      statusInsercao : Boolean;
  public
    { Public declarations }
  end;

var
  frmCadastroPalavras: TfrmCadastroPalavras;

implementation
uses
 UPalavras;

{$R *.dfm}

{ TfrmCadastroPalavras }

procedure TfrmCadastroPalavras.btnAlterarClick(Sender: TObject);
begin
  statusBotaoInserir();
  statusInsercao := false;
end;

procedure TfrmCadastroPalavras.btnCancelarClick(Sender: TObject);
begin
  statusBotaoNaoInserir();
end;

procedure TfrmCadastroPalavras.btnExcluirClick(Sender: TObject);
var
  palavra : TPalavras;
begin

  if CDSID.Value <1 then
  begin
    MessageDlg('Nenhum registro selecionado. Verifique!',mtInformation,[mbOK],0);
    Abort;
  end;

  if MessageDlg('Tem certeza que deseja excluir o registro selecionado?',mtInformation,[mbYes,mbNo],0)=mrYes then
  begin
    palavra := TPalavras.Create;
    try
      palavra.id := CDSID.Value;
      palavra.recordObjectDelete();
    finally
      FreeAndNil(palavra);
    end;

    statusBotaoNaoInserir();
    cds.Refresh;
    MessageDlg('Registro excluído com sucesso!',mtInformation,[mbOK],0);
    
  end;
end;

procedure TfrmCadastroPalavras.btnFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCadastroPalavras.btnInserirClick(Sender: TObject);
begin
  statusBotaoInserir();
  cbbAtivo.ItemIndex:=0;
  edtPalavraIngles.Text := '';
  edtPalavraPortugues.Text := '';
  statusInsercao := true;
end;

procedure TfrmCadastroPalavras.btnSalvarClick(Sender: TObject);
var
  palavras : TPalavras;
begin

  if edtPalavraIngles.Text = '' then
  begin
    MessageDlg('Informe a palavra em inglês.',mtInformation,[mbOK],0);
    edtPalavraIngles.SetFocus;
    Abort;
  end
  else
    if edtPalavraPortugues.Text ='' then
    begin
      MessageDlg('Informe a palavra em português.',mtInformation,[mbOK],0);
      edtPalavraPortugues.SetFocus;
      Abort;    
    end;
    
  palavras := TPalavras.Create;

  try
    palavras.id := CDSID.Value;
    palavras.palavraIngles := edtPalavraIngles.Text;
    palavras.palavraPortugues := edtPalavraPortugues.Text;
    palavras.ativo := (cbbAtivo.ItemIndex = 0);

    if statusInsercao then    
      palavras.recordObjectInsercao()
    else
      palavras.recordObjectAtualizacao();

    statusBotaoNaoInserir();
  
    cds.Refresh;
    
  finally
    FreeAndNil(palavras);
  end;

  btnInserir.SetFocus;
  MessageDlg('Registro gravado com sucesso!',mtInformation,[mbOK],0);
  
end;

procedure TfrmCadastroPalavras.CDSAfterScroll(DataSet: TDataSet);
begin
  edtPalavraIngles.Text := CDSPALAVRAINGLES.Value;
  edtPalavraPortugues.Text := CDSPALAVRAPORTUGUES.Value;
  if CDSATIVO.Value = 'T' then  
    cbbAtivo.ItemIndex := 0
  else
    cbbAtivo.ItemIndex := 1;

  statusBotaoNaoInserir();  
end;

procedure TfrmCadastroPalavras.FormShow(Sender: TObject);
begin
  QRY.Active := True;
  CDS.Active := True;
  statusBotaoNaoInserir();
end;

procedure TfrmCadastroPalavras.statusBotaoInserir;
begin
  btnInserir.Enabled := False;
  btnSalvar.Enabled :=True;
  btnAlterar.Enabled := False;
  btnCancelar.Enabled := True;
  btnExcluir.Enabled := False;
  btnFechar.Enabled := False;
  edtPalavraIngles.Enabled := True;
  edtPalavraPortugues.Enabled := True;
  cbbAtivo.Enabled := True;
  edtPalavraIngles.SetFocus;
end;

procedure TfrmCadastroPalavras.statusBotaoNaoInserir;
begin
  btnInserir.Enabled := True;
  btnSalvar.Enabled :=False;
  btnAlterar.Enabled := True;
  btnCancelar.Enabled := False;
  btnExcluir.Enabled := True;
  btnFechar.Enabled := True;
  edtPalavraIngles.Enabled := False;
  edtPalavraPortugues.Enabled := False;
  cbbAtivo.Enabled := False;
end;

end.
