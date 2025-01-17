unit UPalavrasIngles;

interface

uses
  Winapi.Windows,System.SysUtils,parametros,System.Types,UParametros,UPalavras,
  System.Generics.Collections,Vcl.Forms, Vcl.Dialogs,StrUtils,RDprint,Vcl.ExtCtrls,
  Vcl.Buttons, System.Classes, Vcl.Controls,Vcl.StdCtrls, Vcl.Menus, Vcl.ComCtrls, 
  Vcl.MPlayer, ZDataset, UDM;
type
  TfrmPrincipal = class(TForm)
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Palavras1: TMenuItem;
    RDP: TRDprint;
    Parmetros1: TMenuItem;
    Relatrios1: TMenuItem;
    Palavrasrestantes1: TMenuItem;
    StatusBar1: TStatusBar;
    mmo: TMemo;
    btnValidar: TBitBtn;
    sOBRE1: TMenuItem;
    ProgramafeitoporTiagoMartinsFerreira1: TMenuItem;
    N1: TMenuItem;
    Estatisticasdepalavrasacertadas1: TMenuItem;
    N2: TMenuItem;
    Acertossequenciais1: TMenuItem;
    lblTempo: TLabel;
    timer: TTimer;
    mp1: TMediaPlayer;
    pnltexto: TPanel;
    img: TImage;
    rcTexto: TRichEdit;
    mp2: TMediaPlayer;
    btnPlay: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure Palavras1Click(Sender: TObject);
    procedure Parmetros1Click(Sender: TObject);
    procedure Palavrasrestantes1Click(Sender: TObject);
    procedure btnValidarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn1Click(Sender: TObject);
    procedure Estatisticasdepalavrasacertadas1Click(Sender: TObject);
    procedure Acertossequenciais1Click(Sender: TObject);
    procedure timerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);

    function contagemPontos(AMsg: String): String;
  private
    procedure exibePalavrasInglesBanco();
    procedure traducaoInglesPortugues();
    procedure atualizaStatusBar(); 
    procedure propriedadeLabelPadrao();
    procedure reproduzirSomFrasesIngles();
    procedure reproduzirSomPalavrasIngles();
    procedure exibicaoTextoTraducaoIngles(AFrase : String);
    
    
    function palavraConcatenada(Apalavra1, APalavra2 : String; AQtdePalavras,AContador: Integer): String;
    function removerEspacosNoMeio( palavra : String):String;
    function categoriasParametrizadas():String;
    
    var
      lista: TObjectList<TPalavras>;
      palavras: TPalavras;
      par :  TParametros;
      tempoOld : TDateTime;
      listaPalavrasConcatenadas, listaPalavrasAcertadas : array of string;
      Acertos,AcertosTotal, Erros: Integer;

  public
     function retornaNumeroParFormualario(AValor : integer): Integer;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UCadastroPalavras, ComObj, UParamCategorias;

{$R *.dfm}

procedure TfrmPrincipal.Acertossequenciais1Click(Sender: TObject);
var
  palavra   : TPalavras;
  i,linha   : Integer;
  listaTemp : TList<string>;
begin

  palavra := TPalavras.Create;

  try
    RDP.CaptionSetup := 'Selecione uma impressora';
    RDP.Impressora   := Grafico;
    RDP.OpcoesPreview.CaptionPreview := 'Visualiza��o do relat�rio';
    RDP.OpcoesPreview.Preview := True;
    RDP.UsaGerenciadorImpr    := True;
    RDP.TamanhoQteLinhas      := 66;
    RDP.TamanhoQteColunas     := 96;
    RDP.Abrir;
     
    RDP.Impf(1,1,'------------------------------------------------------------------------------------------------',[negrito]);
      
    RDP.ImpF(3,17,'Estat�stica de acerto de palavras sequ�nciais por data corrente',[negrito]);

    RDP.Impf(5,1,'------------------------------------------------------------------------------------------------',[negrito]);

    linha:=7;

    listaTemp := palavra.estatistica2();

    try
      for i := 0 to listaTemp.Count-1 do
      begin
        RDP.Impf(linha,1,listaTemp.Items[i],[negrito]);
        Inc(linha);
        if linha = 65 then
        begin
          rdp.Novapagina;
          linha:=2;
        end;    
      end;

      rdp.Fechar;
      
    finally
      FreeAndNil(listaTemp);
    end;
      
  finally
    FreeAndNil(palavra);
  end;

end;

procedure TfrmPrincipal.atualizaStatusBar;
begin
  StatusBar1.Panels.Items[1].Text:= 'Acertos: '+ IntToStr(Acertos);
  StatusBar1.Panels.Items[2].Text:= 'Acertos total: '+ IntToStr(AcertosTotal);
  StatusBar1.Panels.Items[3].Text:= 'Erros: '+ IntToStr(Erros);
end;

procedure TfrmPrincipal.BitBtn1Click(Sender: TObject);
begin
  try
    ReproduzirSomFrasesIngles();
  except
   on e: Exception do
   begin
     MessageDlg('Nenhum som foi configurado para esta frase.',mtInformation,[mbOK],0);
     Abort;
   end;
  end;
end;

procedure TfrmPrincipal.btn1Click(Sender: TObject);
begin
  mp1.FileName := Trim('C:\Ingles\Mp3\'+Label1.Caption+'.mp3');
  mp1.Open;
  mp1.Play;
end;

procedure TfrmPrincipal.btnPlayClick(Sender: TObject);
begin
  reproduzirSomPalavrasIngles();
  mmo.SetFocus;
end;

procedure TfrmPrincipal.btnValidarClick(Sender: TObject);
var
  qtdePalavrasEdt, qtdePalavrasAleatorias : TStringDynArray;
begin

  if Label1.Caption = 'Parab�ns voce acertou todas as palavras!!'+#13+'Feche o programa para come�ar novamente.' then
  begin  
    timer.Enabled := False;
    abort;  
  end;
    
  qtdePalavrasEdt := SplitString(mmo.Text,',');
  qtdePalavrasAleatorias := SplitString(Label1.Caption,',');
  
  if Length(qtdePalavrasEdt) <>  Length(qtdePalavrasAleatorias) then
  begin
    MessageDlg('Quantidade de palavras digitadas � menor do que a quantidade exibida. Confira as palavras!',mtInformation,[mbOK],0);
    mmo.SetFocus;
    Abort;
  end;

  try
    traducaoInglesPortugues();
  except on Exception do
    begin
      mmo.Text := '';
      mmo.SetFocus; 
      Label1.Top:=11;
      Label1.Font.Size := 17;
      mmo.Font.Size := 10;
      mmo.Enabled:=false;
      atualizaStatusBar();
      timer.Enabled := False;
      MessageDlg('Parab�ns!! Voc� acertou todas as palavras',mtInformation,[mbOK],0);
      Abort;
    end;
  end;
  exibePalavrasInglesBanco();

end;



function TfrmPrincipal.categoriasParametrizadas: String;
var
  i : Integer;
  lQry : TZQuery;
begin
  Result := '';
  lQry := TZQuery.Create(nil);
  try
    lQry.Connection := DM.conexao;
    lQry.Close;
    lQry.SQL.Clear;
    lQry.SQL.Add(TParam_Categorias.getConsulta);
    lQry.Open;
    i := 1;
    while not lQry.Eof do
    begin

      if i = 1 then
        Result := lQry.FieldByName('id_categoria').AsString
      else
        Result := Result +','+lQry.FieldByName('id_categoria').AsString;

      Inc(i);
      lQry.Next;
    end;

  finally
    FreeAndNil(lQry);
  end;

end;

function TfrmPrincipal.contagemPontos(AMsg: String): String;
begin
  if AMsg = 'Voc� acertou!' then
    begin
      Acertos := Acertos + 1;
      AcertosTotal:= AcertosTotal +1;
    end
  else
    Erros := Erros + 1;

  Result := AMsg;
end;

procedure TfrmPrincipal.Estatisticasdepalavrasacertadas1Click(Sender: TObject);
var
  palavra : TPalavras;
  i,linha : Integer;
  listaTemp : TList<string>;
begin  

  RDP.CaptionSetup := 'Selecione uma impressora';
  RDP.Impressora   := Grafico;
  RDP.OpcoesPreview.CaptionPreview := 'Visualiza��o do relat�rio';
  RDP.OpcoesPreview.Preview := True;
  RDP.UsaGerenciadorImpr    := True;
  RDP.TamanhoQteLinhas      := 66;
  RDP.TamanhoQteColunas     := 96;
  RDP.Abrir;
     
  RDP.Impf(1,1,'------------------------------------------------------------------------------------------------',[negrito]);
      
  RDP.ImpF(3,25,'Estat�stica de palavras a serem treinadas por data',[negrito]);

  RDP.Impf(5,1,'------------------------------------------------------------------------------------------------',[negrito]);

  linha:=7;

  palavra := TPalavras.Create;
    
  try

    listaTemp := palavra.estatistica1;
    
    try
    
      for i := 0 to listaTemp.Count-1 do
      begin
        RDP.Impf(linha,1,listaTemp.Items[i],[negrito]);
        Inc(linha);
        if linha = 65 then
        begin
          rdp.Novapagina;
          linha:=2;
        end;    
      end;

      rdp.Fechar;
      
    finally
      FreeAndNil(listaTemp);
    end;
      
  finally
    FreeAndNil(palavra);    
  end;

end;

procedure TfrmPrincipal.exibePalavrasInglesBanco;
var
  par                                                            : TParametros;
  i,j,l,validador,divisaoPalavras,lNumeroAleatorio,lQtdePalavras : Integer;
  lPalavrasConcatenadas,texto                                    : String;
begin

  if Label1.Caption = 'Parab�ns voce acertou todas as palavras!!'+#13+'Feche o programa para come�ar novamente.' then
    abort;

  par := TParametros.Create(); 
  par.setObject(); 
  
  StatusBar1.Panels.Items[0].Text:= 'Qtde Palavras: '+  IntToStr(lista.Count);
  atualizaStatusBar();
  
  try

    case par.apresentacaoPalavras of
    
      1  : begin
             lQtdePalavras := 1;
             Label1.Top:=11;
             Label1.Font.Size := 36;
             mmo.Font.Size := 24;
             SetLength(listaPalavrasConcatenadas,1);
             mp1.Enabled:=True;
           end;
    
      4  : begin
             lQtdePalavras := 4;
             SetLength(listaPalavrasConcatenadas,4);
             propriedadeLabelPadrao();
           end;

      8  : begin    
             lQtdePalavras := 8;
             SetLength(listaPalavrasConcatenadas,8);
             propriedadeLabelPadrao();
           end;

      12 : begin    
             lQtdePalavras := 12;
             SetLength(listaPalavrasConcatenadas,12);
             propriedadeLabelPadrao();
           end;      
    end;

    for j := 1 to lQtdePalavras do
    begin 
      divisaoPalavras := (lQtdePalavras div 2);
      lNumeroAleatorio := Random(lista.Count);
      
      if not par.repetirPalavras then
      begin
        l:=0;              
        while l < length(listaPalavrasAcertadas)-1 do
        begin
          validador :=0;
          if listaPalavrasAcertadas[l] = IfThen(par.inglesToPortugues,lista.Items[lNumeroAleatorio].palavraIngles,lista.Items[lNumeroAleatorio].palavraPortugues)  then
          begin
            l:=0;
            validador:=100;
            lNumeroAleatorio := Random(lista.Count);
          end;
          if validador <> 100 then
            l:=l+1                                   
        end;      
      end;      
            
      listaPalavrasConcatenadas[j-1]:= IfThen(par.inglesToPortugues,lista.Items[lNumeroAleatorio].palavraIngles,lista.Items[lNumeroAleatorio].palavraPortugues);
      
      if (divisaoPalavras <> j) OR (lQtdePalavras<8) then      
        lPalavrasConcatenadas := palavraConcatenada(lPalavrasConcatenadas,IfThen(par.inglesToPortugues,lista.Items[lNumeroAleatorio].palavraIngles,lista.Items[lNumeroAleatorio].palavraPortugues),lQtdePalavras,j)
      else
        if (divisaoPalavras = j)and (lQtdePalavras>=8)then
          lPalavrasConcatenadas :=  palavraConcatenada(lPalavrasConcatenadas,IfThen(par.inglesToPortugues,lista.Items[lNumeroAleatorio].palavraIngles,lista.Items[lNumeroAleatorio].palavraPortugues),lQtdePalavras,j)+#13;  
    end;

   Label1.Visible := not par.somenteAudio;  

   Label1.Caption := IfThen(par.tpLetras = 1,UpperCase(lPalavrasConcatenadas),LowerCase(lPalavrasConcatenadas)); 

   exibicaoTextoTraducaoIngles(AnsiLowerCase(lista.Items[lNumeroAleatorio].fraseIntuitivaIngles));

   application.processmessages;
   
   if par.apresentacaoPalavras = 1 then
   begin     
     
     reproduzirSomPalavrasIngles();    

     if par.exibirPalavrasComFrases then
     begin
     
       try

         img.Picture := nil;
         //img.Picture.LoadFromFile('C:\Ingles\imagem\'+Label1.Caption+'.jpg');

       except on e: Exception do
         mmo.SetFocus;

       end;     

       application.processmessages;
       Sleep(1000);

       ReproduzirSomFrasesIngles();
     end;

   end;
   
  finally
    FreeAndNil(par);
  end;
  
end;

procedure TfrmPrincipal.exibicaoTextoTraducaoIngles(AFrase : String);
begin
   rcTexto.Clear;
   rcTexto.Lines.Add('Frase em ingl�s:');
   rcTexto.Lines.Add('');
   
   rcTexto.Lines.Add(AFrase);
   
   rcTexto.Lines.Add('');
   rcTexto.Lines.Add(''); 
   rcTexto.Lines.Add('Tradu��o:');
   rcTexto.Lines.Add('');
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  palavras.atualizaQtdePalavrasFecharTela();
  FreeAndNil(par);
  FreeAndNil(palavras);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  parametros : TParametros;
begin
  
  parametros := TParametros.Create;  
  
  try

    parametros.setObject();
  
    if (parametros.apresentacaoPalavras > 1) or not (parametros.exibirPalavrasComFrases) then
    begin
      frmPrincipal.Width:= 786;
      frmPrincipal.Height := 488;
    end ;

    btnPlay.Visible := not (parametros.apresentacaoPalavras > 1);

  finally
    FreeAndNil(parametros);
  end;    

  lblTempo.Caption := '00:00:00:000';
  tempoOld := Now;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin 
  // TIRA O SOM PADR�O DO WINDOWS AO CLICAR NOS BOT�ES
  SystemParametersInfo(SPI_SETBEEP, 0, nil, SPIF_SENDWININICHANGE);

  par := TParametros.Create(); 
  par.setObject();
  palavras := TPalavras.Create;
  lista := palavras.listaPalavrasIngles(par.filtroInicial,par.filtroFinal,(par.ordenarPalavras),(par.dividePalavrasDia),categoriasParametrizadas);
  if lista.Count = 0 then
  begin
    MessageDlg('Nenhum registro a ser exibido.',mtInformation,[mbOK],0);
    Label1.Caption := 'Sem palavras para ser exibido!';
    Abort;
  end;
  
  exibePalavrasInglesBanco();
end;

function TfrmPrincipal.palavraConcatenada(Apalavra1, APalavra2 : String; AQtdePalavras,AContador: Integer): String;
begin
  if Apalavra1 = '' then
    Apalavra1 := APalavra2+ IfThen(AQtdePalavras > 1, ',','')
  else
  if AContador <> AQtdePalavras then
    Apalavra1 := Apalavra1 + APalavra2 +','
  else
  Apalavra1 := Apalavra1 + APalavra2 ;

  Result:= Apalavra1;
end;

procedure TfrmPrincipal.Palavras1Click(Sender: TObject);
begin
  try
    frmCadastroPalavras := TfrmCadastroPalavras.Create(nil);
    frmCadastroPalavras.ShowModal;
  finally
    FreeAndNil(frmCadastroPalavras);
  end;
end;

procedure TfrmPrincipal.Palavrasrestantes1Click(Sender: TObject);
var
  palavrasTemp              : TPalavras;
  parTemp                   : TParametros;
  listaPalavrasRestanteTemp : TObjectList<TPalavras>;
  i,j,linha                 : Integer;
  validacao                 : boolean;
begin                                                                                 
  
  parTemp := TParametros.Create(); 
  parTemp.setObject(); 
  palavrasTemp := TPalavras.Create();
  palavrasTemp.listaPalavrasIngles(parTemp.filtroInicial,parTemp.filtroFinal,parTemp.ordenarPalavras,parTemp.dividePalavrasDia,categoriasParametrizadas);

  listaPalavrasRestanteTemp := TObjectList<TPalavras>.Create(False);
  try
    for i := 0 to palavrasTemp.lista.Count-1 do
      begin
        validacao := False;
        for j := 0 to Length(listaPalavrasAcertadas)-1 do
        begin
          if palavrasTemp.lista.Items[i].palavraIngles = listaPalavrasAcertadas[j] then
          begin
            validacao := True;
            break;
          end;
        end;
        if not validacao then         
          listaPalavrasRestanteTemp.Add(palavrasTemp.lista.Items[i]);         
      end;

      RDP.CaptionSetup := 'Selecione uma impressora';
      RDP.Impressora   := Grafico;
      RDP.OpcoesPreview.CaptionPreview := 'Visualiza��o do relat�rio';
      RDP.OpcoesPreview.Preview := True;
      RDP.UsaGerenciadorImpr    := True;
      RDP.TamanhoQteLinhas      := 66;
      RDP.TamanhoQteColunas     := 96;
      RDP.Abrir;
     
      RDP.Impf(1,1,'------------------------------------------------',[expandido, negrito]);
      
      RDP.ImpF(3,24,'Relat�rio de palavras restantes a serem sorteados',[negrito]);

      RDP.Impf(5,1,'------------------------------------------------',[expandido, negrito]);

      linha:=7;
    
      for i := 0 to listaPalavrasRestanteTemp.Count -1 do
      begin
        RDP.Impf(linha,1,listaPalavrasRestanteTemp.Items[i].palavraIngles,[expandido, negrito]);
        Inc(linha);
        if linha = 65
         then
        begin
          rdp.Novapagina;
          linha:=2;
        end;    
      end;

      rdp.Fechar;
  finally      
    FreeAndNil(listaPalavrasRestanteTemp);
    FreeAndNil(parTemp); 
    FreeAndNil(palavrasTemp);   
  end;
end;

procedure TfrmPrincipal.Parmetros1Click(Sender: TObject);
begin
  try
    frmParametros := TfrmParametros.Create(nil);
    frmParametros.ShowModal;  
  finally
    FreeAndNil(frmParametros);
  end;
end;

procedure TfrmPrincipal.propriedadeLabelPadrao;
begin
  Label1.Top:=12;
  Label1.Font.Size := 17;
  mmo.Font.Size := 10;
  mp1.Enabled := False;
  StatusBar1.Height := 25;
end;

function TfrmPrincipal.removerEspacosNoMeio( palavra: String): String;
var
  lista : TStringDynArray; 
  linha : string;
  i: Integer;
begin
  lista := SplitString(palavra,',');

  for i := 0 to Length(lista)-1 do
  begin
    linha := linha + Trim(lista[i]);
  end;
    
  Result := linha;
end;

procedure TfrmPrincipal.ReproduzirSomFrasesIngles;
var
  texto : string;
  i : Integer;
  voz : OLEVariant; 
begin

  for i := 0 to rcTexto.Lines.Count -1 do
  begin
    if i >= 2 then
    begin
      if copy(rcTexto.Lines[i],1,1)='' then
      begin
        break;
      end;

      texto := texto + rcTexto.Lines[i];
      
    end;        
  end;
  
  try

    //Ler texto em voz alta
    voz := CreateOLEObject ('SAPI.SpVoice');
    voz.Voice := voz.GetVoices.item(1);
    voz.Speak(texto, 0);
    mp1.Enabled := True;

    {
    mp2.FileName := 'C:\Ingles\Mp3\'+texto+'.mp3';
    mp2.Open;
    mp2.Play;
    }
    except on e: Exception do
     raise EAbort.Create('N�o conseguiu reproduzir o som para esta frase.');
  end  
  
end;

procedure TfrmPrincipal.reproduzirSomPalavrasIngles;
var
  voz : OleVariant;
begin
  try
    
  //Ler texto em voz alta
    voz := CreateOLEObject ('SAPI.SpVoice');
    voz.Voice := voz.GetVoices.item(1);
    voz.Speak(Label1.Caption, 0);
    mp1.Enabled := True;
     
    {
    mp1.FileName := 'C:\Ingles\Mp3\'+Label1.Caption+'.mp3';
    mp1.Open;
    mp1.Play;
    }
     
  except on e: Exception do
    begin
      MessageDlg('N�o conseguiu reproduzir o som para esta palavra.',mtInformation,[mbOK],0);
      Abort;
    end;
  end
end;

function TfrmPrincipal.retornaNumeroParFormualario(AValor: integer): Integer;
begin
  Result := AValor;
end;

procedure TfrmPrincipal.timerTimer(Sender: TObject);
begin
  lblTempo.Caption := FormatDateTime('HH:MM:SS', tempoOld - NOW);
end;

procedure TfrmPrincipal.traducaoInglesPortugues;
var
  palavrasTemp                        : TPalavras;
  j,l                                 : Integer; 
  lPalavraConcatenadaTemp,palavraEdit : String;
  lPalavrasErradas                    : TStringDynArray;
begin

  palavrasTemp := TPalavras.Create;

  try

    for j := 1 to Length(listaPalavrasConcatenadas) do
    begin
      palavrasTemp.setObject(UpperCase(listaPalavrasConcatenadas[j-1]));
      lPalavraConcatenadaTemp := palavraConcatenada(lPalavraConcatenadaTemp,palavrasTemp.palavraPortugues,Length(listaPalavrasConcatenadas),j);
    end;

    SetLength(listaPalavrasAcertadas, lista.Count);

    palavraEdit := removerEspacosNoMeio(Trim(AnsiUpperCase(mmo.Text)));
         
    // Verifica se a palavra foi traduzida corretamente
    if palavraEdit = ReplaceStr(Trim(AnsiUpperCase(lPalavraConcatenadaTemp)),',','') then
    begin

      rcTexto.Lines.Add(AnsiLowerCase(palavrasTemp.fraseIntuitivaPortugues));      

      if par.dividePalavrasDia then
      begin
        for j := 0 to Length(listaPalavrasConcatenadas)-1 do
        begin         
          palavrasTemp.setObject(listaPalavrasConcatenadas[j]);
          palavrasTemp.atualizaStatusExibicaoPalavras(listaPalavrasConcatenadas[j],palavrasTemp.qtdeSeqAcertos+1, par.quantidadeDiasDivisaoPalavras);
        end;
      end;
             
      for j := 0 to lista.Count -1 do
      begin
        // Verifica se todas as palavras j� foram acertadas ou n�o
        if listaPalavrasAcertadas[lista.Count-1]<> '' then
        begin
          Label1.Visible := True;
          Label1.Caption:='Parab�ns voce acertou todas as palavras!!'+#13+'Feche o programa para come�ar novamente.'; 
          raise Exception.Create('Error Message');                      
        end;                    
      end;

      // Verifica se a palavra acertada j� foi acertada anteriomente e n�o contabiliza ponto de acerto
      for l := 0 to lista.Count-1 do
      begin
        for j := 0 to Length(listaPalavrasConcatenadas)-1 do                              
          if UpperCase(listaPalavrasConcatenadas[j]) = listaPalavrasAcertadas[l] then
            AcertosTotal := AcertosTotal+1
      end;          

      // Armazena em array as palavras acertadas para saber posteriormente se a palavra acertada � repetida ou n�o
      for j := 0 to Length(listaPalavrasConcatenadas)-1 do            
      begin
        for l := 0 to Length(listaPalavrasAcertadas)-1 do
        begin
          if listaPalavrasAcertadas[l] = listaPalavrasConcatenadas[j] then
            break
          else
            if listaPalavrasAcertadas[l]= '' then
            begin
               Label1.Visible := True;
               contagemPontos('Voc� acertou!');
               listaPalavrasAcertadas[l]:= UpperCase(listaPalavrasConcatenadas[j]);
               break;
             end;
        end;                      
      end;              

      // Verifica se todas as palavras j� foram acertadas ou n�o
      if listaPalavrasAcertadas[lista.Count-1]<> '' then
      begin
        Label1.Visible := True;
        Label1.Caption:='Parab�ns voce acertou todas as palavras!!'+#13+'Feche o programa para come�ar novamente.'; 
        raise Exception.Create('Error Message');        
      end;
      
      // Se chegou at� aqui � porque a tradu��o foi feita corretamente e a mensagem na tela pode ser exibida.
      MessageDlg('Voc� acertou!',mtInformation,[mbOK],0);
      mmo.Text := '';
      mmo.SetFocus;
      Exit;
                          
    end;
  
    SetLength(lPalavrasErradas,Length(listaPalavrasConcatenadas));
    lPalavrasErradas :=  SplitString(lPalavraConcatenadaTemp,',');
    lPalavraConcatenadaTemp := '';
    
    for j := 0 to Length(lPalavrasErradas)-1 do
      lPalavraConcatenadaTemp:= lPalavraConcatenadaTemp +#13+ lPalavrasErradas[j];
      
    // Se chegou aqui � porque a palavra n�o foi traduzida corretamente. 

    if par.dividePalavrasDia then
    begin
      for j := 0 to Length(listaPalavrasConcatenadas)-1 do
      begin         
        palavrasTemp.setObject(listaPalavrasConcatenadas[j]);
        palavrasTemp.atualizaStatusExibicaoPalavras(listaPalavrasConcatenadas[j],0,par.quantidadeDiasDivisaoPalavras);
      end;
    end;
     
    MessageDlg(contagemPontos('Voc� errou!')+#13+#13+'Tradu��o:'+#13+ lPalavraConcatenadaTemp,mtInformation,[mbOK],0);
    lPalavraConcatenadaTemp := '';
    mmo.Text:= '';
    mmo.SetFocus;
    
  finally           
    FreeAndNil(palavrasTemp);        
  end;
end;

end.
