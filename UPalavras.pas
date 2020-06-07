unit UPalavras;

interface
uses
  ZDataSet, UDM, System.SysUtils, System.Generics.Collections,FMX.Dialogs,
  System.Classes,DB,System.StrUtils, UConexaoBanco;

type

  TPalavras = class

  private
    FId : Integer;
    FPalavraIngles : String;
    FPalavraPortugues : String;
    FAtivo : String;
    FFrase : string;
    FQtdeSeqAcertos :SmallInt;
    FDataSeqAcertos : TDate;
    FFraseIntuitivaIngles : string;
    FFraseIntuitivaPortugues : string;
    FMp3 : TBlobData;
    FQry : TZQuery;
    Flista : TObjectList<TPalavras>;
    FConexao : TConexaoBanco;
    function getAtivo: Boolean;
    function getPalavraIngles: String;
    function getPalavraPortugues: String;
    procedure setAtivo(const Value: Boolean);
    procedure setPalavrasIngles(const Value: String);
    procedure setPalavrasPortuguess(const Value: String);
    function getId: Integer;
    procedure setId(const Value: Integer);
    function getFrase: Boolean;
    procedure setFrase(const Value: Boolean);
    function getQtdeSeqAcertos: SmallInt;
    procedure setQtdeSeqAcertos(const Value: SmallInt);
    function getMp3: TBlobData;
    procedure setMp3(const Value: TBlobData);
    function getdataSeqAcertos: TDate;
    procedure setdataSeqAcertos(const Value: TDate);
    function getLista: TObjectList<TPalavras>;
    procedure setLista(const Value: TObjectList<TPalavras>);
    function getFraseIntuitivaIngles: string;
    function getFraseIntuitivaPortugues: string;
    procedure setFraseIntuitivaIngles(const Value: string);
    procedure setFraseIntuitivaPortugues(const Value: string);
  public
    property id : Integer read getId write setId;
    property palavraIngles : String read getPalavraIngles write setPalavrasIngles;
    property palavraPortugues : String read getPalavraPortugues write setPalavrasPortuguess;
    property ativo : Boolean read getAtivo write setAtivo;
    property frase : Boolean read getFrase write setFrase;
    property qtdeSeqAcertos : SmallInt read getQtdeSeqAcertos write setQtdeSeqAcertos;
    property dataSeqAcertos : TDate read getdataSeqAcertos write setdataSeqAcertos;
    property mp3 : TBlobData read getMp3 write setMp3;
    property lista : TObjectList<TPalavras> read getLista write setLista;
    property fraseIntuitivaIngles : string read getFraseIntuitivaIngles write setFraseIntuitivaIngles;
    property fraseIntuitivaPortugues : string read getFraseIntuitivaPortugues write setFraseIntuitivaPortugues;

    function listaPalavrasIngles(AParam1,AParam2 : SmallInt; ordenarPalavra : Boolean = false; dividirPalavrasDia : Boolean = false): TObjectList<TPalavras>;
    function listaTodasPalavras(): TObjectList<TPalavras>;
    function estatistica1 : TList<string>;
    function estatistica2 : TList<string>;

    procedure setObject(APalavraIngles : String);
    procedure recordObjectInsercao();
    procedure recordObjectAtualizacao();
    procedure recordObjectDelete();
    procedure atualizaStatusExibicaoPalavras(palavra : String; qtde : smallint; qtdeParametroDiasDivididos : SmallInt);
    procedure atualizaQtdePalavrasFecharTela();
    procedure atualizaAudio(id : Integer; mp3 : TBlobData);
    procedure alterarStatusTotasPalavras(AAtivar : Boolean);
    procedure atualizaSeparaPalavrasBydata();
    procedure copyFromObjectFlista(ALista : TObjectList<Tpalavras>);
    function retornaNumeroPar(AValor : integer): Integer;

    constructor Create(); 
    destructor Destroy; override;
    
  end;

implementation

{ TPalavras }

procedure TPalavras.AlterarStatusTotasPalavras(AAtivar: Boolean);
var
  qryTemp : TZQuery;
begin
  
  qryTemp := TZQuery.Create(nil);
    
  try
  
    qryTemp.Connection := FConexao.conectar();
    qryTemp.Connection.StartTransaction;
  
    qryTemp.close;
    qryTemp.SQL.Add('update palavras set ');
    qryTemp.SQL.Add('ativo = '+QuotedStr(IfThen(AAtivar,'T','F')));

    qryTemp.ExecSQL;
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end;
end;

procedure TPalavras.atualizaAudio(id : Integer; mp3 : TBlobData);
var
  qryTemp : TZQuery;
begin

  qryTemp := TZQuery.Create(nil);
  
  try
  
    qryTemp.Connection := FConexao.conectar();
    qryTemp.Connection.StartTransaction;
  
    qryTemp.close;
    qryTemp.SQL.Add('update palavras set ');
    qryTemp.SQL.Add('mp3 =:mp3 ');
    qryTemp.SQL.Add('where id =:id');

    qryTemp.ParamByName('mp3').AsBlob := mp3;
    qryTemp.ParamByName('id').AsInteger := id;

    qryTemp.ExecSQL;
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end;
end;

procedure TPalavras.atualizaQtdePalavrasFecharTela;
var
  qryTemp : TZQuery;
begin

  qryTemp := TZQuery.Create(nil);
  
  try
  
    qryTemp.Connection := FConexao.conectar();
    qryTemp.Connection.StartTransaction;
    
    qryTemp.close;
    qryTemp.SQL.Add('update palavras set ');
    qryTemp.SQL.Add('qtdeseqacertos = 0 ');
    qryTemp.SQL.Add('where data_seq_acertos > current_date');

    qryTemp.ExecSQL;
    
  finally
    qryTemp.Connection.Commit;
    FreeAndNil(qryTemp);    
  end;
end;

procedure TPalavras.atualizaSeparaPalavrasBydata;
var
  qryTemp : TZQuery;
begin

  qryTemp := TZQuery.Create(nil);  
  try
  
    qryTemp.Connection := FConexao.conectar();
    qryTemp.Connection.StartTransaction;
  
    qryTemp.close;
    qryTemp.SQL.Add('update palavras set');
    qryTemp.SQL.Add('qtdeSeqAcertos =:qsa, data_seq_acertos =:dsa ');
    qryTemp.SQL.Add('where id =:id');
    
    qryTemp.ParamByName('id').AsInteger  := FId;
    qryTemp.ParamByName('qsa').AsInteger := FQtdeSeqAcertos;
    qryTemp.ParamByName('dsa').AsDate    := FDataSeqAcertos;
    
    qryTemp.ExecSQL;
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end;
end;

procedure TPalavras.atualizaStatusExibicaoPalavras(palavra : String; qtde : smallint; qtdeParametroDiasDivididos : SmallInt);
var
  qryTemp : TZQuery;
  dia,mes,ano : String;  
begin

  dia := Copy(DateToStr(Now+(qtdeParametroDiasDivididos+1)),1,2);
  mes := Copy(DateToStr(Now+(qtdeParametroDiasDivididos+1)),4,2);
  ano := Copy(DateToStr(Now+(qtdeParametroDiasDivididos+1)),7,4);

  qryTemp := TZQuery.Create(nil);
  
  try
  
    qryTemp.Connection := FConexao.conectar();
    qryTemp.Connection.StartTransaction;
  
    qryTemp.close;
    qryTemp.SQL.Add('update palavras set ');

    if qtde < 2 then
      qryTemp.SQL.Add('qtdeseqacertos =:qtde')
    else
      qryTemp.SQL.Add('qtdeseqacertos =0,data_seq_acertos = '+QuotedStr(mes+'/'+dia+'/'+ano));
      
    qryTemp.SQL.Add(' where palavraIngles =:palavra');
    
    qryTemp.ParamByName('palavra').AsString := palavra;
    
    if qtde < 2 then
      qryTemp.ParamByName('qtde').AsInteger := qtde;
    
    try
      qryTemp.ExecSQL;
    except on e: Exception do
      begin
        ShowMessage(e.Message);
      end;
    end;
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end; 
end;

procedure TPalavras.copyFromObjectFlista(ALista: TObjectList<Tpalavras>);
var
  i : Integer;
  palavras : TPalavras;
begin

  for i := 0 to ALista.Count -1 do
  begin  
    palavras.id := ALista.Items[i].id;
    palavras.palavraIngles := ALista.Items[i].palavraIngles;
    palavras.palavraPortugues := ALista.Items[i].palavraPortugues;
    palavras.ativo := ALista.Items[i].ativo;
    palavras.frase := ALista.Items[i].frase;
    palavras.qtdeSeqAcertos := ALista.Items[i].qtdeSeqAcertos;
    palavras.dataSeqAcertos := ALista.Items[i].dataSeqAcertos;
    palavras.fraseIntuitivaIngles := ALista.Items[i].fraseIntuitivaIngles;
    palavras.fraseIntuitivaPortugues := ALista.Items[i].fraseIntuitivaPortugues;

    Flista.Add(palavras);
    
  end;

end;

constructor TPalavras.Create;
begin
  Fconexao := TConexaoBanco.Create;
  Flista := TObjectList<TPalavras>.Create;  
end;

destructor TPalavras.Destroy;
begin
  FreeAndNil(Flista);
  FreeAndNil(Fconexao);
  inherited;
end;

function TPalavras.estatistica1: TList<string>;
var
  lista : TList<string>;
begin

  FQry := TZQuery.Create(nil);

  try

    FQry.Connection := FConexao.conectar();
  
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('select data_seq_acertos,count(*)as qtde from palavras group by data_seq_acertos');
    FQry.Open;  

    lista := TList<string>.Create;
  
    while not FQry.Eof do
    begin
      
      lista.add(FQry.FieldByName('data_seq_acertos').AsString +'  ====================>  '+FQry.FieldByName('qtde').AsString);

      FQry.Next;   
    end;

    Result := lista;
  finally
    FreeAndNil(FQry);
  end;
end;

function TPalavras.estatistica2: TList<string>;
var
  lista : TList<string>;
begin

  FQry := TZQuery.Create(nil);

  try
    FQry.Connection := FConexao.conectar();

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('select b.palavraingles,b.qtdeseqacertos from palavras b where frase = '+QuotedStr('F')+' and b.data_seq_acertos <= current_date order by 2 desc ');
    FQry.Open;  

    lista := TList<string>.Create;
  
    while not FQry.Eof do
    begin
      
      lista.add(FQry.FieldByName('palavraingles').AsString +':'+FQry.FieldByName('qtdeseqacertos').AsString);

      FQry.Next;   
    end;

    Result := lista;  
  finally
    FreeAndNil(FQry);
  end;
end;

function TPalavras.getAtivo: Boolean;
begin
  
  if  FAtivo = 'T' then
    Result := True
  else
    Result := False;  
 
end;

function TPalavras.getdataSeqAcertos: TDate;
begin
  Result := FDataSeqAcertos;
end;

function TPalavras.getFrase: Boolean;
begin

  if FFrase = 'T' then
    Result := True
  else 
    Result := False;   
  
end;

function TPalavras.getFraseIntuitivaIngles: string;
begin
  Result := FFraseIntuitivaIngles;
end;

function TPalavras.getFraseIntuitivaPortugues: string;
begin
  Result := FFraseIntuitivaPOrtugues;
end;

function TPalavras.getId: Integer;
begin
  Result := FId;
end;

function TPalavras.getLista: TObjectList<TPalavras>;
begin
  Result := Flista;
end;

function TPalavras.getMp3: TBlobData;
begin
  Result := mp3;
end;

function TPalavras.getPalavraIngles: String;
begin
  Result := FPalavraIngles;
end;

function TPalavras.getPalavraPortugues: String;
begin
  Result := FPalavraPortugues;
end;

function TPalavras.getQtdeSeqAcertos: SmallInt;
begin
  Result := FQtdeSeqAcertos;
end;

function TPalavras.listaPalavrasIngles(AParam1,AParam2 : SmallInt; ordenarPalavra : Boolean; dividirPalavrasDia : Boolean): TObjectList<TPalavras>;
var  
  palavraIngles : TPalavras;
  dia,mes,ano : string;
begin

  dia := Copy(DateToStr(Now),1,2);
  mes := Copy(DateToStr(Now),4,2);
  ano := Copy(DateToStr(Now),7,4);

  FQry := TZQuery.Create(nil);

  try
    FQry.Connection := FConexao.conectar();
  
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('select * from palavras ');
    FQry.SQL.Add('where ativo = ''T''');
    if dividirPalavrasDia then  
      FQry.SQL.Add('and data_seq_acertos <='+QuotedStr(mes+'/'+dia+'/'+ano));
    if (AParam1 > 0) or (AParam2 > 0) then
    begin
      FQry.SQL.Add(' and id between '+IntToStr(AParam1)+' and '+IntToStr(AParam2));
      FQry.SQL.Add(' order by 1');
    end 
    else
    if ordenarPalavra then
      FQry.SQL.Add(' order by 2')
    else
      FQry.SQL.Add(' order by 1');      
     
    FQry.Open;  
  
    while not FQry.Eof do
    begin
  
      palavraIngles := TPalavras.Create;

      palavraIngles.FID := FQry.FieldByName('ID').AsInteger;
      palavraIngles.FPalavraIngles := FQry.FieldByName('PALAVRAINGLES').AsString;
      palavraIngles.FPalavraPortugues := FQry.FieldByName('PALAVRAPORTUGUES').AsString;
      palavraIngles.FFraseIntuitivaIngles := FQry.FieldByName('frase_intuitiva_ingles').AsString;
      palavraIngles.FFraseIntuitivaPortugues := FQry.FieldByName('frase_intuitiva_portugues').AsString;
    
      Flista.Add(palavraIngles); 

      FQry.Next;   
    end;

    Result := Flista; 

  finally
    FreeAndNil(FQry);
  end;

end;

function TPalavras.listaTodasPalavras: TObjectList<TPalavras>;
var  
  palavra : TPalavras;
begin
 
  FQry := TZQuery.Create(nil);

  try
  
    FQry.Connection := FConexao.conectar();
 
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('select * from palavras order by 1');
    FQry.Open;  
  
    while not FQry.Eof do
    begin
  
      palavra := TPalavras.Create;

      palavra.FID := FQry.FieldByName('ID').AsInteger;
      palavra.FPalavraIngles := FQry.FieldByName('PALAVRAINGLES').AsString;
      palavra.FPalavraPortugues := FQry.FieldByName('PALAVRAPORTUGUES').AsString;
      palavra.FAtivo := FQry.FieldByName('ativo').AsString;
      palavra.frase := FQry.FieldByName('frase').AsBoolean;
      palavra.FQtdeSeqAcertos := FQry.FieldByName('QTDESEQACERTOS').AsInteger;
      palavra.FDataSeqAcertos := FQry.FieldByName('DATA_SEQ_ACERTOS').AsDateTime;
      palavra.FFraseIntuitivaIngles := FQry.FieldByName('frase_intuitiva_ingles').AsString;
      palavra.FFraseIntuitivaPortugues := FQry.FieldByName('frase_intuitiva_portugues').AsString;
    
      Flista.Add(palavra); 

      FQry.Next;   
    end;
      
    Result := Flista;   
     
  finally
    FreeAndNil(FQry);
  end;

end;

procedure TPalavras.recordObjectAtualizacao;
var
  qryTemp : TZQuery;
begin

  qryTemp := TZQuery.Create(nil);
  
  try
  
    qryTemp.Connection := FConexao.conectar();
    qryTemp.Connection.StartTransaction;
  
    qryTemp.close;
    qryTemp.SQL.Add('update palavras set');
    qryTemp.SQL.Add('palavraingles =:ingles,palavraportugues =:portugues,ativo =:ativo,frase =:frase, ');
    qryTemp.SQL.Add('frase_intuitiva_portugues =:fip, frase_intuitiva_ingles =:fii ');
    qryTemp.SQL.Add('where id =:id');
    qryTemp.ParamByName('id').AsInteger := FId;
    qryTemp.ParamByName('ingles').AsString:= FPalavraIngles;
    qryTemp.ParamByName('portugues').AsString := FPalavraPortugues;
    qryTemp.ParamByName('ativo').AsString := FAtivo;
    qryTemp.ParamByName('frase').AsString := FFrase;
    qryTemp.ParamByName('fip').AsString := FFraseIntuitivaPortugues;
    qryTemp.ParamByName('fii').AsString := FFraseIntuitivaIngles;
    

    qryTemp.ExecSQL;
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end; 
end;

procedure TPalavras.recordObjectDelete;
var
  qryTemp : TZQuery;
begin

  qryTemp := TZQuery.Create(nil);
  
  try
  
    qryTemp.Connection := FConexao.conectar();
    qryTemp.Connection.StartTransaction;
  
    qryTemp.close;
    qryTemp.SQL.Add('delete from palavras where id =:id');
    qryTemp.ParamByName('id').AsInteger :=FId;

    qryTemp.ExecSQL;
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end; 
end;

procedure TPalavras.recordObjectInsercao;
var
  qryTemp : TZQuery;
begin
  qryTemp := TZQuery.Create(nil);
  
  try
  
    qryTemp.Connection := FConexao.conectar();
    qryTemp.Connection.StartTransaction;
    
    qryTemp.close;
    qryTemp.SQL.Add('insert into palavras');
    qryTemp.SQL.Add('(id,palavraingles,palavraportugues,ativo,frase,qtdeseqacertos,data_seq_acertos,frase_intuitiva_portugues,frase_intuitiva_ingles)');
    qryTemp.SQL.Add('values');
    qryTemp.SQL.Add('(:id,:ingles,:portugues,:ativo,:frase,:qtdeAcertos,:dataAcertos,:fip,:fii)');
    qryTemp.ParamByName('id').AsInteger :=FId;
    qryTemp.ParamByName('ingles').AsString:= FPalavraIngles;
    qryTemp.ParamByName('portugues').AsString := FPalavraPortugues;
    qryTemp.ParamByName('ativo').AsString := FAtivo;
    qryTemp.ParamByName('frase').AsString := FFrase;
    qryTemp.ParamByName('qtdeAcertos').AsInteger := 0;
    qryTemp.ParamByName('fip').AsString := FFraseIntuitivaPortugues;
    qryTemp.ParamByName('fii').AsString := FFraseIntuitivaIngles;    
    

    if FDataSeqAcertos > StrToDate('30/12/1899') then
      qryTemp.ParamByName('dataAcertos').AsDate := FDataSeqAcertos
    else
      qryTemp.ParamByName('dataAcertos').AsDate := StrToDate('30/12/1899');

    qryTemp.ExecSQL;
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end;  
end;

function TPalavras.retornaNumeroPar(AValor: integer): Integer;
begin
  Result := AValor;
end;

procedure TPalavras.setAtivo(const Value: Boolean);
begin

  if Value then  
    FAtivo := 'T'
  else
    FAtivo := 'F';  
  
end;

procedure TPalavras.setdataSeqAcertos(const Value: TDate);
begin
  FDataSeqAcertos := Value;
end;

procedure TPalavras.setFrase(const Value: Boolean);
begin
  if Value then
    FFrase := 'T'                         
  else
    FFrase := 'F';  
end;

procedure TPalavras.setFraseIntuitivaIngles(const Value: string);
begin
  FFraseIntuitivaIngles := Value;
end;

procedure TPalavras.setFraseIntuitivaPortugues(const Value: string);
begin
  FFraseIntuitivaPortugues := Value;
end;

procedure TPalavras.setId(const Value: Integer);
begin
  FId := Value;
end;

procedure TPalavras.setLista(const Value: TObjectList<TPalavras>);
begin
  Flista := Value;
end;

procedure TPalavras.setMp3(const Value: TBlobData);
begin
  FMp3 := Value;
end;

procedure TPalavras.setObject(APalavraIngles: String);
begin

  FQry := TZQuery.Create(nil);
  try
    FQry.Connection := FConexao.conectar();

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('select * from palavras');
    FQry.SQL.Add('where palavraingles =:palavraIngles');
    FQry.ParamByName('palavraIngles').AsString := APalavraIngles;
    FQry.Open; 

    FID := FQry.FieldByName('id').AsInteger;
    FPalavraIngles := FQry.FieldByName('palavraingles').AsString;
    FPalavraPortugues := FQry.FieldByName('palavraPortugues').AsString;
    FFrase := FQry.FieldByName('frase').AsString;
    FQtdeSeqAcertos := FQry.FieldByName('qtdeSeqAcertos').AsInteger;
    FDataSeqAcertos := FQry.FieldByName('data_seq_acertos').AsDateTime;
    FFraseIntuitivaIngles := FQry.FieldByName('frase_intuitiva_ingles').AsString;
    FFraseIntuitivaPortugues := FQry.FieldByName('frase_intuitiva_portugues').AsString;
  finally
    FreeAndNil(FQry);
  end;
end;

procedure TPalavras.setPalavrasIngles(const Value: String);
begin
 FPalavraIngles := Value;
end;

procedure TPalavras.setPalavrasPortuguess(const Value: String);
begin
  FPalavraPortugues := Value;
end;

procedure TPalavras.setQtdeSeqAcertos(const Value: SmallInt);
begin
  FQtdeSeqAcertos := Value;
end;

end.
