unit UPalavrasIngles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,System.Types,UParametros,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, StrUtils, CnClasses,
  CnTimer, CnRS232Dialog, Vcl.Tabs, CnTabSet, frxClass, frxExportPDF, RpDefine,
  RpCon, RpConDS, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Menus, RDprint, Vcl.ComCtrls;

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
    procedure FormShow(Sender: TObject);
    procedure Palavras1Click(Sender: TObject);
    procedure Parmetros1Click(Sender: TObject);
    procedure Palavrasrestantes1Click(Sender: TObject);
    procedure btnValidarClick(Sender: TObject);
  private
    procedure exibePalavrasInglesBanco();
    procedure traducaoInglesPortugues();
    procedure atualizaStatusBar();
    function contagemPontos(AMsg: String): String;
    function palavraConcatenada(Apalavra1, APalavra2 : String; AQtdePalavras,AContador: Integer): String;
    function removerEspacosNoMeio( palavra : String):String;
    
    var
    listaPalavrasConcatenadas, listaPalavrasAcertadas : array of string;
    Acertos,AcertosTotal, Erros: Integer;

  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UPalavras,UCadastroPalavras, System.Generics.Collections,parametros;

{$R *.dfm}

procedure TfrmPrincipal.atualizaStatusBar;
begin
  StatusBar1.Panels.Items[1].Text:= 'Acertos: '+ IntToStr(Acertos);
  StatusBar1.Panels.Items[2].Text:= 'Acertos total: '+ IntToStr(AcertosTotal);
  StatusBar1.Panels.Items[3].Text:= 'Erros: '+ IntToStr(Erros);
end;

procedure TfrmPrincipal.btnValidarClick(Sender: TObject);
var
  qtdePalavrasEdt, qtdePalavrasAleatorias : TStringDynArray;
begin

  if Label1.Caption = 'Parabêns voce acertou todas as palavras!!'+#13+'Feche o programa para começar novamente.' then  
    abort;  
    
  qtdePalavrasEdt := SplitString(mmo.Text,',');
  qtdePalavrasAleatorias := SplitString(Label1.Caption,',');

  if Length(qtdePalavrasEdt) <>  Length(qtdePalavrasAleatorias) then
  begin
    MessageDlg('Quantidade de palavras digitadas é menor do que a quantidade exibida. Confira as palavras!',mtInformation,[mbOK],0);
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
      MessageDlg('Parabêns!! Você acertou todas as palavras',mtInformation,[mbOK],0);
      Abort;
    end;
  end;
  exibePalavrasInglesBanco();

end;

function TfrmPrincipal.contagemPontos(AMsg: String): String;
begin
  if AMsg = 'Você acertou!' then
    begin
      Acertos := Acertos + 1;
      AcertosTotal:= AcertosTotal +1;;
    end
  else
    Erros := Erros + 1;

  Result := AMsg;
end;

procedure TfrmPrincipal.exibePalavrasInglesBanco;
var
  palavrasTemp: TPalavras;
  listaTemp: TObjectList<TPalavras>;
  i,j,l,validador,divisaoPalavras, lNumeroAleatorio : Integer;
  lQtdePalavras : Integer;
  lPalavrasConcatenadas : String;
  par :  TParametros;
  palavrasSorteadas : TList<string>;
  
begin

  if Label1.Caption = 'Parabêns voce acertou todas as palavras!!'+#13+'Feche o programa para começar novamente.' then
    abort;

  par := TParametros.Create(); 
  par.setObject(); 
  palavrasTemp := TPalavras.Create;
  palavrasSorteadas := TList<String>.Create;
  listaTemp := palavrasTemp.listaPalavrasIngles(par.filtroInicial,par.filtroFinal);
  
  StatusBar1.Panels.Items[0].Text:= 'Qtde Palavras: '+  IntToStr(listaTemp.Count);
  atualizaStatusBar();
  
  try

    if par.apresentacaoPalavras = 1 then
    begin
      lQtdePalavras := 1;
      Label1.Top:=11;
      Label1.Font.Size := 36;
      mmo.Font.Size := 24;
      SetLength(listaPalavrasConcatenadas,1);
    end
    else
    if (par.apresentacaoPalavras = 4) or (par.apresentacaoPalavras = 8) or (par.apresentacaoPalavras = 12) then
    begin
      Label1.Top:=11;
      Label1.Font.Size := 17;
      mmo.Font.Size := 10;
    end;
 
    if par.apresentacaoPalavras = 4 then   
    begin
      lQtdePalavras := 4;
      SetLength(listaPalavrasConcatenadas,4);
    end
    else
    if par.apresentacaoPalavras = 8 then
    begin
      lQtdePalavras := 8;
      SetLength(listaPalavrasConcatenadas,8);
    end
    else
    if par.apresentacaoPalavras = 12 then
    begin
      lQtdePalavras := 12;
      SetLength(listaPalavrasConcatenadas,12);
    end;

    for j := 1 to lQtdePalavras do
    begin 
      divisaoPalavras := (lQtdePalavras div 2);
      lNumeroAleatorio := Random(listaTemp.Count);
      
      if not par.repetirPalavras then
      begin
        l:=0;              
        while l < length(listaPalavrasAcertadas)-1 do
        begin
          validador :=0;
          if listaPalavrasAcertadas[l] = IfThen(par.inglesToPortugues,listaTemp.Items[lNumeroAleatorio].palavraIngles,listaTemp.Items[lNumeroAleatorio].palavraPortugues)  then
          begin
            l:=0;
            validador:=100;
            lNumeroAleatorio := Random(listaTemp.Count);
          end;
          if validador <> 100 then
            l:=l+1
        end;      
      end;      
            
      listaPalavrasConcatenadas[j-1]:= IfThen(par.inglesToPortugues,listaTemp.Items[lNumeroAleatorio].palavraIngles,listaTemp.Items[lNumeroAleatorio].palavraPortugues);
      
      if (divisaoPalavras <> j) OR (lQtdePalavras<8) then      
        lPalavrasConcatenadas := palavraConcatenada(lPalavrasConcatenadas,IfThen(par.inglesToPortugues,listaTemp.Items[lNumeroAleatorio].palavraIngles,listaTemp.Items[lNumeroAleatorio].palavraPortugues),lQtdePalavras,j)
      else
        if (divisaoPalavras = j)and (lQtdePalavras>=8)then
          lPalavrasConcatenadas :=  palavraConcatenada(lPalavrasConcatenadas,IfThen(par.inglesToPortugues,listaTemp.Items[lNumeroAleatorio].palavraIngles,listaTemp.Items[lNumeroAleatorio].palavraPortugues),lQtdePalavras,j)+#13;  
    end;
   
   Label1.Caption := IfThen(par.tpLetras = 1,UpperCase(lPalavrasConcatenadas),LowerCase(lPalavrasConcatenadas)) ;
   
  finally
    FreeAndNil(palavrasTemp);
    FreeAndNil(par);
    FreeAndNil(palavrasSorteadas);
  end;
  
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
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
  palavrasTemp: TPalavras;
  listaTemp: TObjectList<TPalavras>;
  listaPalavrasRestanteTemp: TObjectList<TPalavras>;
  i,j,linha : Integer;
  validacao : boolean;
  par :  TParametros;
  
begin
  par := TParametros.Create(); 
  par.setObject(); 
  palavrasTemp := TPalavras.Create;
  listaTemp := palavrasTemp.listaPalavrasIngles(par.filtroInicial,par.filtroFinal); 
  listaPalavrasRestanteTemp := TObjectList<TPalavras>.Create;
  try
    for i := 0 to listaTemp.Count-1 do
      begin
        validacao := False;
        for j := 0 to Length(listaPalavrasAcertadas)-1 do
        begin
          if listaTemp.Items[i].palavraIngles = listaPalavrasAcertadas[j] then
          begin
            validacao := True;
            break;
          end;
        end;
        if not validacao then         
          listaPalavrasRestanteTemp.Add(listaTemp.Items[i]);         
      end;

      RDP.CaptionSetup := 'Selecione uma impressora';
      RDP.Impressora   := Grafico;
      RDP.OpcoesPreview.CaptionPreview := 'Visualização do relatório';
      RDP.OpcoesPreview.Preview := True;
      RDP.UsaGerenciadorImpr    := True;
      RDP.TamanhoQteLinhas      := 66;
      RDP.TamanhoQteColunas     := 96;
      RDP.Abrir;

      linha:=2;
    
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
    FreeAndNil(par);
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

procedure TfrmPrincipal.traducaoInglesPortugues;
var
  listaPalavrasTemp       : TObjectList<TPalavras>; 
  palavrasTemp            : TPalavras;
  j,l                     : Integer; 
  lPalavraConcatenadaTemp,palavraEdit : String;
  lPalavrasErradas        : TStringDynArray;
  par                     : TParametros;  
  palavrasSorteadas       : TList<string>;
  
begin

  par := TParametros.Create();   
  palavrasTemp := TPalavras.Create;

  try
  
    par.setObject();
  
    listaPalavrasTemp := palavrasTemp.listaPalavrasIngles(par.filtroInicial,par.filtroFinal);
    
    for j := 1 to Length(listaPalavrasConcatenadas) do
    begin
      palavrasTemp.setObject(UpperCase(listaPalavrasConcatenadas[j-1]));  
      lPalavraConcatenadaTemp := palavraConcatenada(lPalavraConcatenadaTemp,palavrasTemp.palavraPortugues,Length(listaPalavrasConcatenadas),j);                                  
    end;
      
    SetLength(listaPalavrasAcertadas, listaPalavrasTemp.Count);

    palavraEdit := removerEspacosNoMeio(Trim(AnsiUpperCase(mmo.Text)));
         
    // Verifica se a palavra foi traduzida corretamente
    if palavraEdit = ReplaceStr(Trim(AnsiUpperCase(lPalavraConcatenadaTemp)),',','') then
    begin

       for j := 0 to Length(listaPalavrasConcatenadas)-1 do
       begin         
         palavrasTemp.setObject(listaPalavrasConcatenadas[j]);
         palavrasTemp.atualizaStatusExibicaoPalavras(listaPalavrasConcatenadas[j],palavrasTemp.qtdeSeqAcertos+1);
       end;
             
      for j := 0 to listaPalavrasTemp.Count -1 do
      begin
        // Verifica se todas as palavras já foram acertadas ou não
        if listaPalavrasAcertadas[listaPalavrasTemp.Count-1]<> '' then
        begin
          Label1.Caption:='Parabêns voce acertou todas as palavras!!'+#13+'Feche o programa para começar novamente.'; 
          raise Exception.Create('Error Message');                      
        end;                    
      end;

      // Verifica se a palavra acertada já foi acertada anteriomente e não contabiliza ponto de acerto
      for l := 0 to listaPalavrasTemp.Count-1 do
      begin
        for j := 0 to Length(listaPalavrasConcatenadas)-1 do                              
          if UpperCase(listaPalavrasConcatenadas[j]) = listaPalavrasAcertadas[l] then
          begin
            AcertosTotal := AcertosTotal+1;
            //raise Exception.Create('Você acertou! Mas palavra é repetida.');
          end;
      end;          

      // Armazena em array as palavras acertadas para saber posteriormente se a palavra acertada é repetida ou não
      for j := 0 to Length(listaPalavrasConcatenadas)-1 do            
      begin
        for l := 0 to Length(listaPalavrasAcertadas)-1 do
        begin
          if listaPalavrasAcertadas[l] = listaPalavrasConcatenadas[j] then
          begin
            break;        
          end
          else
            if listaPalavrasAcertadas[l]= '' then
            begin
               contagemPontos('Você acertou!')  ;
               listaPalavrasAcertadas[l]:= UpperCase(listaPalavrasConcatenadas[j]);
               break;
             end;
        end;                      
      end;              

      // Verifica se todas as palavras já foram acertadas ou não
      if listaPalavrasAcertadas[listaPalavrasTemp.Count-1]<> '' then
      begin
        Label1.Caption:='Parabêns voce acertou todas as palavras!!'+#13+'Feche o programa para começar novamente.'; 
        raise Exception.Create('Error Message');        
      end;
      
      // Se chegou até aqui é porque a tradução foi feita corretamente e a mensagem na tela pode ser exibida.
      MessageDlg('Você acertou!',mtInformation,[mbOK],0);
      mmo.Text := '';
      mmo.SetFocus;
      Exit;
                          
    end;
  
    SetLength(lPalavrasErradas,Length(listaPalavrasConcatenadas));
    lPalavrasErradas :=  SplitString(lPalavraConcatenadaTemp,',');
    lPalavraConcatenadaTemp := '';
    
    for j := 0 to Length(lPalavrasErradas)-1 do
    begin
      lPalavraConcatenadaTemp:= lPalavraConcatenadaTemp +#13+ lPalavrasErradas[j];
    end;
      
    // Se chegou aqui é poruqe a palavra não foi traduzida corretamente. 

     for j := 0 to Length(listaPalavrasConcatenadas)-1 do
     begin         
       palavrasTemp.setObject(listaPalavrasConcatenadas[j]);
       palavrasTemp.atualizaStatusExibicaoPalavras(listaPalavrasConcatenadas[j],0);
     end;
     
    MessageDlg(contagemPontos('Você errou!')+#13+#13+'Tradução:'+#13+ lPalavraConcatenadaTemp,mtInformation,[mbOK],0);
    lPalavraConcatenadaTemp := '';
    mmo.Text:= '';
    mmo.SetFocus;
    
  finally           
    FreeAndNil(palavrasTemp);
    FreeAndNil(par);         
  end;
end;

end.
