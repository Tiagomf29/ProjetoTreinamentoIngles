unit UCadastroPalavras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,System.StrUtils,
  Vcl.DBGrids, Vcl.ExtCtrls, UDM, Data.DB, ZAbstractRODataset, ZAbstractDataset,MidasLib,
  ZDataset, Vcl.DBCtrls, Vcl.Mask, Datasnap.Provider, Datasnap.DBClient, System.Generics.Collections,
  Vcl.MPlayer, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  Vcl.ComCtrls;

type
  TfrmCadastroPalavras = class(TForm)
    Panel1: TPanel;
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
    gbPesquisa: TGroupBox;
    Nome: TLabel;
    edtPesquisa: TEdit;
    btnExportar: TBitBtn;
    dlgSave: TSaveDialog;
    DBGrid1: TDBGrid;
    btnImportar: TBitBtn;
    dlgOpen: TOpenDialog;
    documento: TXMLDocument;
    pb: TProgressBar;
    btnStatusPalavras: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure edtPesquisaChange(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure btnStatusPalavrasClick(Sender: TObject);
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

procedure TfrmCadastroPalavras.btnExportarClick(Sender: TObject);
var  
  elementoPrincipal, palavra :IXMLNode;
  i,contador: Integer;
  palavraTemp : TPalavras;
  listaTemp : TObjectList<TPalavras>;
begin

   contador := 0;
   documento.Active := True;
   palavraTemp := TPalavras.Create;
   
   try
     listaTemp := palavraTemp.listaTodasPalavras;
   
     pb.Max := listaTemp.Count;
     pb.Min := 1;
   
     elementoPrincipal := documento.AddChild('exportacaoDePalavras');
     
     for I := 0 to listaTemp.Count-1 do
     begin 

       palavra := elementoPrincipal.AddChild('palavra');
     
       palavra.AddChild('Sequencia').Text:= IntToStr(i+1);
       palavra.AddChild('codigo').Text:= IntToStr(listaTemp.Items[i].id);
       palavra.AddChild('palavraIngles').Text:= listaTemp.Items[i].palavraIngles;
       palavra.AddChild('palavraPortugues').Text:= listaTemp.Items[i].palavraPortugues;
       palavra.AddChild('ativo').Text := IfThen((listaTemp.Items[i].ativo),'true','false');
       palavra.AddChild('frase').Text:= IfThen((listaTemp.Items[i].frase),'true','false');
       palavra.AddChild('qtdeSeqAcertos').Text:= IntToStr(listaTemp.Items[i].qtdeSeqAcertos);     
       palavra.AddChild('dataSeqAcertos').Text:= DateToStr(listaTemp.Items[i].dataSeqAcertos);

       pb.Position := pb.Position + 1;
        
     end;     
     
     dlgSave.Title:= 'Exportar dados em xml';
     
     try
       if dlgSave.Execute() then
         documento.SaveToFile(dlgSave.FileName);  
       MessageDlg('Exportação realizado com sucesso!',mtInformation,[mbOK],0);
     except on e: Exception do
       begin
         if e.Message <> 'Parâmetro incorreto' then
           ShowMessage(e.Message);  
       end;
     end;

     pb.Position := 0;

     documento.XML.Clear;
     
   finally
      FreeAndNil(palavraTemp);
   end;
  
end;

procedure TfrmCadastroPalavras.btnFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCadastroPalavras.btnImportarClick(Sender: TObject);
var
  palavra : TPalavras;
  nodePalavras : IXMLNode;
  dia,mes,ano : string;
  contador : Integer;
begin
  contador := 0;
  
  if dlgOpen.Execute then
  begin
    documento.LoadFromFile(dlgOpen.FileName);
    documento.Active:=True;
  end 
  else
    Exit;

  nodePalavras := documento.DocumentElement.ChildNodes.FindNode('palavra');
  nodePalavras.ChildNodes.First; 

  repeat
    contador:= contador +1; 
    nodePalavras:= nodePalavras.NextSibling; 
  until nodePalavras = nil;

  pb.Min :=0;
  pb.Max := contador;

  documento.LoadFromFile(dlgOpen.FileName);
  documento.Active:=True;
  nodePalavras := documento.DocumentElement.ChildNodes.FindNode('palavra');
  nodePalavras.ChildNodes.First;
  
  repeat 

    palavra := TPalavras.Create;    

    try 
    
      palavra.setObject(nodePalavras.ChildValues['palavraIngles']);
      
      pb.Position:= pb.Position + 1;
      
      if palavra.palavraIngles = '' then      
        palavra.palavraIngles := nodePalavras.ChildValues['palavraIngles']
      else
        begin
          nodePalavras:= nodePalavras.NextSibling;
          Continue;  
        end;
      
      palavra.palavraPortugues := nodePalavras.ChildValues['palavraPortugues'];
      palavra.ativo :=  nodePalavras.ChildValues['ativo'];
      palavra.frase := nodePalavras.ChildValues['frase']; 
      palavra.qtdeSeqAcertos := nodePalavras.ChildValues['qtdeSeqAcertos'];
      
      dia := copy(nodePalavras.ChildValues['dataSeqAcertos'],1,2);
      mes := copy(nodePalavras.ChildValues['dataSeqAcertos'],4,2);
      ano := copy(nodePalavras.ChildValues['dataSeqAcertos'],7,4);

      palavra.dataSeqAcertos := StrToDate(dia+'/'+mes+'/'+ano);
       
      palavra.recordObjectInsercao();
        
      CDS.Refresh;
    
      nodePalavras:= nodePalavras.NextSibling;
      
    finally
      FreeAndNil(palavra);
    end;
          
  until nodePalavras = nil;

  documento.XML.Clear;
  
  MessageDlg('Importação realizada com sucesso!',mtInformation,[mbOK],0);

  pb.Position:=0;

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

procedure TfrmCadastroPalavras.btnStatusPalavrasClick(Sender: TObject);
var
  palavras : TPalavras;
begin

  palavras := TPalavras.Create;

  try
    if btnStatusPalavras.Caption = 'Ativar todas as palavras' then
    begin        
      palavras.AlterarStatusTotasPalavras(True);
      btnStatusPalavras.Caption := 'Desativar todas as palavras';
      CDS.Refresh;
      MessageDlg('Status atualizados com sucesso!',mtInformation,[mbOK],0);
    end
    else
      begin
        palavras.AlterarStatusTotasPalavras(false);
        btnStatusPalavras.Caption := 'Ativar todas as palavras';
        CDS.Refresh;
        MessageDlg('Status atualizados com sucesso!',mtInformation,[mbOK],0);
      end;
  finally
    FreeAndNil(palavras);
  end;  
  
end;

procedure TfrmCadastroPalavras.CDSAfterScroll(DataSet: TDataSet);
begin
  edtPalavraIngles.Text    := CDSPALAVRAINGLES.Value;
  edtPalavraPortugues.Text := CDSPALAVRAPORTUGUES.Value;
  
  if CDSATIVO.Value = 'T' then  
    cbbAtivo.ItemIndex := 0
  else
    cbbAtivo.ItemIndex := 1;

  statusBotaoNaoInserir(); 

end;

procedure TfrmCadastroPalavras.edtPesquisaChange(Sender: TObject);
begin
  cds.Filtered := True;
  CDS.Filter := ' palavraingles like '+QuotedStr('%'+edtPesquisa.Text+'%');
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
