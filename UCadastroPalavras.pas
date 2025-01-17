unit UCadastroPalavras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,System.StrUtils,
  Vcl.DBGrids,UDM, Data.DB, ZAbstractRODataset,ZAbstractDataset,MidasLib,
  ZDataset, Vcl.DBCtrls,Datasnap.Provider, Datasnap.DBClient, System.Generics.Collections,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,Vcl.ComCtrls, Vcl.ExtCtrls, Xml.Win.msxmldom;
type
  TfrmCadastroPalavras = class(TForm)
    Panel1: TPanel;
    QRY: TZQuery;
    DTS: TDataSource;
    QRYID: TIntegerField;
    QRYPALAVRAINGLES: TWideStringField;
    QRYPALAVRAPORTUGUES: TWideStringField;
    QRYATIVO: TWideStringField;
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
    dlgSave: TSaveDialog;
    DBGrid1: TDBGrid;
    dlgOpen: TOpenDialog;
    documento: TXMLDocument;
    pb: TProgressBar;
    QRYFRASE: TWideStringField;
    QRYQTDESEQACERTOS: TSmallintField;
    QRYDATA_SEQ_ACERTOS: TDateField;
    QRYMP3: TBlobField;
    CDSFRASE: TWideStringField;
    pnl1: TPanel;
    btnExportar: TBitBtn;
    btnStatusPalavras: TBitBtn;
    btnImportar: TBitBtn;
    grp1: TGroupBox;
    lblPalavraIngles: TLabel;
    edtPalavraIngles: TEdit;
    cbAtivo: TCheckBox;
    cbFrase: TCheckBox;
    edtPalavraPortugues: TEdit;
    Label1: TLabel;
    edtFraseIngles: TEdit;
    Label2: TLabel;
    edtFrasePortugues: TEdit;
    Label3: TLabel;
    QRYFRASE_INTUITIVA_INGLES: TWideStringField;
    QRYFRASE_INTUITIVA_PORTUGUES: TWideStringField;
    CDSFRASE_INTUITIVA_INGLES: TWideStringField;
    CDSFRASE_INTUITIVA_PORTUGUES: TWideStringField;
    cbxTipo: TComboBox;
    Label4: TLabel;
    QRYCATEGORIA: TSmallintField;
    CDSQTDESEQACERTOS: TSmallintField;
    CDSDATA_SEQ_ACERTOS: TDateField;
    CDSMP3: TBlobField;
    CDSCATEGORIA: TSmallintField;
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
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1CellClick(Column: TColumn);
  private
    procedure statusBotaoInserir();
    procedure statusBotaoNaoInserir();
    procedure popularComboboxCategorias();
    var
      statusInsercao : Boolean;
      
  public
    { Public declarations }
  end;

var
  frmCadastroPalavras: TfrmCadastroPalavras;

implementation
uses
 UPalavras, Ucategorias;

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
  CDS.First();
  CDS.Refresh();
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
    MessageDlg('Registro exclu�do com sucesso!',mtInformation,[mbOK],0);
    
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
       palavra.AddChild('frase_intuitiva_ingles').Text:= listaTemp.Items[i].fraseIntuitivaIngles;
       palavra.AddChild('frase_intuitiva_portugues').Text:= listaTemp.Items[i].fraseIntuitivaPortugues;
       palavra.AddChild('categoria').Text := IntToStr(listaTemp.Items[i].categoria);

       pb.Position := pb.Position + 1;
        
     end;     
     
     dlgSave.Title:= 'Exportar dados em xml';
     
     try
       if dlgSave.Execute() then
       begin
         documento.SaveToFile(dlgSave.FileName);  
         MessageDlg('Exporta��o realizado com sucesso!',mtInformation,[mbOK],0);
       end;
     except on e: Exception do
       begin
         if e.Message <> 'Par�metro incorreto' then
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
      palavra.categoria:= nodePalavras.ChildValues['categoria'];

       if not VarIsNull(nodePalavras.ChildNodes['frase_intuitiva_ingles'].NodeValue) then
         palavra.fraseIntuitivaIngles := nodePalavras.ChildValues['frase_intuitiva_ingles'];

       if not VarIsNull(nodePalavras.ChildNodes['frase_intuitiva_portugues'].NodeValue) then      
           palavra.fraseIntuitivaPortugues := nodePalavras.ChildValues['frase_intuitiva_portugues'];      
             
      palavra.recordObjectInsercao();
        
      CDS.Refresh;
    
      nodePalavras:= nodePalavras.NextSibling;
      
    finally
      FreeAndNil(palavra);
    end;
          
  until nodePalavras = nil;

  documento.XML.Clear;
  
  MessageDlg('Importa��o realizada com sucesso!',mtInformation,[mbOK],0);

  pb.Position:=0;

end;

procedure TfrmCadastroPalavras.btnInserirClick(Sender: TObject);
begin
  statusBotaoInserir();
  cbAtivo.Checked := True;
  edtPalavraIngles.Text := '';
  edtPalavraPortugues.Text := '';
  edtFraseIngles.Text := '';
  edtFrasePortugues.Text := '';
  statusInsercao := true;
end;

procedure TfrmCadastroPalavras.btnSalvarClick(Sender: TObject);
var
  palavras : TPalavras;
begin

  if edtPalavraIngles.Text = '' then
  begin
    MessageDlg('Informe a palavra em ingl�s.',mtInformation,[mbOK],0);
    edtPalavraIngles.SetFocus;
    Abort;
  end
  else
    if edtPalavraPortugues.Text ='' then
    begin
      MessageDlg('Informe a palavra em portugu�s.',mtInformation,[mbOK],0);
      edtPalavraPortugues.SetFocus;
      Abort;    
    end;
    
  palavras := TPalavras.Create;

  try
    palavras.id := CDSID.Value;
    palavras.palavraIngles := edtPalavraIngles.Text;
    palavras.palavraPortugues := edtPalavraPortugues.Text;
    palavras.ativo := (cbAtivo.Checked = True);
    palavras.frase := (cbFrase.Checked = True);
    palavras.fraseIntuitivaIngles := edtFraseIngles.Text;
    palavras.fraseIntuitivaPortugues := edtFrasePortugues.Text;
    palavras.categoria := Integer(cbxTipo.Items.Objects[cbxTipo.ItemIndex]);

    if statusInsercao then
      palavras.recordObjectInsercao()
    else
      palavras.recordObjectAtualizacao();

    statusBotaoNaoInserir();

    QRY.Close;
    QRY.SQL.Clear;
    qry.SQL.Add(TPalavras.getConsulta);
    QRY.Open;

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
  edtFraseIngles.Text      := CDSFRASE_INTUITIVA_INGLES.Value;
  edtFrasePortugues.Text   := CDSFRASE_INTUITIVA_PORTUGUES.Value;
  cbxTipo.ItemIndex        := cbxTipo.Items.IndexOfObject(TObject(CDSCATEGORIA.Value));

  if CDSATIVO.Value = 'T' then
    cbAtivo.Checked := True
  else
    cbAtivo.Checked := False;

  if CDSFRASE.Value = 'T' then
    cbFrase.Checked := True
  else
    cbFrase.Checked := False;
    
  statusBotaoNaoInserir(); 

end;

procedure TfrmCadastroPalavras.DBGrid1CellClick(Column: TColumn);
var
  palavras : TPalavras;
begin 
  
  if (DBGrid1.SelectedField.FieldName = 'Ativo') and (btnInserir.Enabled = True) then
  begin

    if cbAtivo.Checked = True then
      cbAtivo.Checked := False
    else
      cbAtivo.Checked := True;          

    palavras := TPalavras.Create;

    try
    
      palavras.id               := CDSID.Value;
      palavras.palavraIngles    := edtPalavraIngles.Text;
      palavras.palavraPortugues := edtPalavraPortugues.Text;
      palavras.ativo            := (cbAtivo.Checked = True);
      palavras.frase            := (cbFrase.Checked = True);
      palavras.categoria        := Integer(cbxTipo.Items.Objects[cbxTipo.ItemIndex]);

      palavras.recordObjectAtualizacao();

      CDS.Refresh();
      
    finally
      FreeAndNil(palavras);
    end;

  end 
  else
    if (DBGrid1.SelectedField.FieldName = 'FRASE') and (btnInserir.Enabled = True) then
    begin

      if cbFrase.Checked = True then
        cbFrase.Checked := False
      else
        cbFrase.Checked := True;          

      palavras := TPalavras.Create;

      try
    
        palavras.id               := CDSID.Value;
        palavras.palavraIngles    := edtPalavraIngles.Text;
        palavras.palavraPortugues := edtPalavraPortugues.Text;
        palavras.ativo            := (cbAtivo.Checked = True);
        palavras.frase            := (cbFrase.Checked = True);
        palavras.categoria        := Integer(cbxTipo.Items.Objects[cbxTipo.ItemIndex]);

        palavras.recordObjectAtualizacao();

        CDS.Refresh();
      
      finally
        FreeAndNil(palavras);
      end;

    end;
      
end;

procedure TfrmCadastroPalavras.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Check: Integer;
  R: TRect;
begin
  inherited;

  // Pinta a coluna FRASE na cor preta para n�o aparecer o texto da coluna (T ou F)
  if (Column.FieldName = 'FRASE') then
  begin
    (Sender as TDBGrid).Canvas.Brush.Color:= clBlack;
  end;

  // Pinta a coluna Ativo na cor preta para n�o aparecer o texto da coluna (T ou F)
  if (Column.FieldName = 'Ativo') then
  begin
    (Sender as TDBGrid).Canvas.Brush.Color:= clBlack;
  end;  
 
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;
 
  // Desenha um checkbox no dbgrid
  if Column.FieldName = 'Ativo' then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
 
    if ((Sender as TDBGrid).DataSource.Dataset.FieldByName('Ativo').AsString = 'T') then
      Check := DFCS_CHECKED
    else
      Check := 0;
 
    R := Rect;
    InflateRect(R, -2, -2); { Diminue o tamanho do CheckBox }
    DrawFrameControl(TDBGrid(Sender).Canvas.Handle, R, DFC_BUTTON,
      DFCS_BUTTONCHECK or Check);
  end;

  // Desenha um checkbox no dbgrid
  if Column.FieldName = 'FRASE' then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
 
    if ((Sender as TDBGrid).DataSource.Dataset.FieldByName('FRASE').AsString = 'T') then
      Check := DFCS_CHECKED
    else
      Check := 0;
 
    R := Rect;
    InflateRect(R, -2, -2); { Diminue o tamanho do CheckBox }
    DrawFrameControl(TDBGrid(Sender).Canvas.Handle, R, DFC_BUTTON,
      DFCS_BUTTONCHECK or Check);
  end;    

end;

procedure TfrmCadastroPalavras.edtPesquisaChange(Sender: TObject);
begin
  cds.Filtered := True;
  CDS.Filter := ' palavraingles like '+QuotedStr('%'+edtPesquisa.Text+'%');
end;

procedure TfrmCadastroPalavras.FormShow(Sender: TObject);
begin
  popularComboboxCategorias();
  QRY.Active := True;
  CDS.Active := True;
  statusBotaoNaoInserir();
end;

procedure TfrmCadastroPalavras.popularComboboxCategorias;
var
  lQry : TZQuery;
  i    : Integer;
begin
  lQry := TZQuery.Create(nil);
  try

    lQry.Connection := dm.conexao;
    lQry.Close;
    lQry.SQL.Clear;
    lQry.SQL.Add(TCategorias.getConsulta);
    lQry.Open;

    while not lQry.Eof do
    begin
      cbxTipo.Items.AddObject(lQry.FieldByName('descricao').AsString, TObject(lQry.FieldByName('id').AsInteger));
      lQry.Next;
    end;

  finally
    FreeAndNil(lQry);
  end;
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
  edtFraseIngles.Enabled := True;
  edtFrasePortugues.Enabled := True;
  cbAtivo.Enabled := True;
  cbFrase.Enabled := True;
  cbxTipo.Enabled := True;
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
  edtFraseIngles.Enabled :=False;
  edtFrasePortugues.Enabled := False;
  cbAtivo.Enabled := False;
  cbFrase.Enabled := False;
  cbxTipo.Enabled := False;
end;

end.
