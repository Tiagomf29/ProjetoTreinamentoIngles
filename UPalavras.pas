unit UPalavras;

interface
uses
  ZDataSet, UDM, System.SysUtils, System.Generics.Collections,FMX.Dialogs,System.Classes,DB,System.StrUtils;

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
    FMp3 : TBlobData;
    FQry : TZQuery;
    Flista : TObjectList<TPalavras>;
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
  public
    property id : Integer read getId write setId;
    property palavraIngles : String read getPalavraIngles write setPalavrasIngles;
    property palavraPortugues : String read getPalavraPortugues write setPalavrasPortuguess;
    property ativo : Boolean read getAtivo write setAtivo;
    property frase : Boolean read getFrase write setFrase;
    property qtdeSeqAcertos : SmallInt read getQtdeSeqAcertos write setQtdeSeqAcertos;
    property dataSeqAcertos : TDate read getdataSeqAcertos write setdataSeqAcertos;
    property mp3 : TBlobData read getMp3 write setMp3;

    function listaPalavrasIngles(AParam1,AParam2 : SmallInt; ordenarPalavra : Boolean = false; dividirPalavrasDia : Boolean = false): TObjectList<TPalavras>;
    function listaTodasPalavras(): TObjectList<TPalavras>;
    function estatistica1 : TList<string>;
    function estatistica2 : TList<string>;

    procedure setObject(APalavraIngles : String);
    procedure recordObjectInsercao();
    procedure recordObjectAtualizacao();
    procedure recordObjectDelete();
    procedure atualizaStatusExibicaoPalavras(palavra : String; qtde : smallint);
    procedure atualizaQtdePalavrasFecharTela();
    procedure atualizaAudio(id : Integer; mp3 : TBlobData);

    constructor Create();
    destructor Destroy; override;
    
  end;

implementation

{ TPalavras }

procedure TPalavras.atualizaAudio(id : Integer; mp3 : TBlobData);
var
  qry : TZQuery;
begin
  qry := TZQuery.Create(nil);
  qry.Connection := DM.conexao;
  try
    qry.close;
    qry.SQL.Add('update palavras set ');
    qry.SQL.Add('mp3 =:mp3 ');
    qry.SQL.Add('where id =:id');

    qry.ParamByName('mp3').AsBlob := mp3;
    qry.ParamByName('id').AsInteger := id;

    qry.ExecSQL;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TPalavras.atualizaQtdePalavrasFecharTela;
var
  qry : TZQuery;
begin
  qry := TZQuery.Create(nil);
  qry.Connection := DM.conexao;
  try
    qry.close;
    qry.SQL.Add('update palavras set ');
    qry.SQL.Add('qtdeseqacertos = 0 ');
    qry.SQL.Add('where data_seq_acertos > current_date');

    qry.ExecSQL;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TPalavras.atualizaStatusExibicaoPalavras(palavra : String; qtde : smallint);
var
  qry : TZQuery;
  dia,mes,ano : String;
  
begin

  dia := Copy(DateToStr(Now+4),1,2);
  mes := Copy(DateToStr(Now+4),4,2);
  ano := Copy(DateToStr(Now+4),7,4);

  qry := TZQuery.Create(nil);
  qry.Connection := DM.conexao;
  try
    qry.close;
    qry.SQL.Add('update palavras set ');

    if qtde < 10 then
      qry.SQL.Add('qtdeseqacertos =:qtde')
    else
      qry.SQL.Add('qtdeseqacertos =0,data_seq_acertos = '+QuotedStr(mes+'/'+dia+'/'+ano));
      
    qry.SQL.Add(' where palavraIngles =:palavra');
    
    qry.ParamByName('palavra').AsString := palavra;
    
    if qtde < 10 then
      qry.ParamByName('qtde').AsInteger := qtde;
    
    try
      qry.ExecSQL;
    except on e: Exception do
      begin
        ShowMessage(e.Message);
      end;
    end;
  finally
    FreeAndNil(qry);
  end; 
end;

constructor TPalavras.Create;
begin
  FQry := TZQuery.Create(nil);
  Flista := TObjectList<TPalavras>.Create;
  FQry.Connection := DM.conexao;
end;

destructor TPalavras.Destroy;
begin
  FreeAndNil(FQry);
  FreeAndNil(Flista);
  inherited;
end;

function TPalavras.estatistica1: TList<string>;
var
  lista : TList<string>;
begin
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
end;

function TPalavras.estatistica2: TList<string>;
var
  lista : TList<string>;
begin
  FQry.Close;
  FQry.SQL.Clear;
  FQry.SQL.Add('select b.palavraingles,b.qtdeseqacertos from palavras b where b.data_seq_acertos <= current_date order by 2 desc ');
  FQry.Open;  

  lista := TList<string>.Create;
  
  while not FQry.Eof do
  begin
      
    lista.add(FQry.FieldByName('palavraingles').AsString +':'+FQry.FieldByName('qtdeseqacertos').AsString);

    FQry.Next;   
  end;

  Result := lista;  
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

function TPalavras.getId: Integer;
begin
  Result := FId;
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

  FQry.Close;
  FQry.SQL.Clear;
  FQry.SQL.Add('select * from palavras where frase = '+QuotedStr('F'));
  FQry.SQL.Add('and ativo = ''T''');
  if dividirPalavrasDia then  
    FQry.SQL.Add('and data_seq_acertos <='+QuotedStr(mes+'/'+dia+'/'+ano));
  if AParam1 > 0 then
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
    
    Flista.Add(palavraIngles); 

    FQry.Next;   
  end;

  Result := Flista;    

end;

function TPalavras.listaTodasPalavras: TObjectList<TPalavras>;
var  
  palavra : TPalavras;
begin

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
    
    Flista.Add(palavra); 

    FQry.Next;   
  end;

  Result := Flista;    

end;

procedure TPalavras.recordObjectAtualizacao;
var
  qry : TZQuery;
begin
  qry := TZQuery.Create(nil);
  qry.Connection := DM.conexao;
  try
    qry.close;
    qry.SQL.Add('update palavras set');
    qry.SQL.Add('palavraingles =:ingles,palavraportugues =:portugues,ativo =:ativo ');
    qry.SQL.Add('where id =:id');
    qry.ParamByName('id').AsInteger := FId;
    qry.ParamByName('ingles').AsString:= FPalavraIngles;
    qry.ParamByName('portugues').AsString := FPalavraPortugues;
    qry.ParamByName('ativo').AsString := FAtivo;

    qry.ExecSQL;
  finally
    FreeAndNil(qry);
  end; 
end;

procedure TPalavras.recordObjectDelete;
var
  qry : TZQuery;
begin
  qry := TZQuery.Create(nil);
  qry.Connection := DM.conexao;
  try
    qry.close;
    qry.SQL.Add('delete from palavras where id =:id');
    qry.ParamByName('id').AsInteger :=FId;

    qry.ExecSQL;
  finally
    FreeAndNil(qry);
  end; 
end;

procedure TPalavras.recordObjectInsercao;
var
  qry : TZQuery;
begin
  qry := TZQuery.Create(nil);
  qry.Connection := DM.conexao;
  try
    qry.close;
    qry.SQL.Add('insert into palavras');
    qry.SQL.Add('(id,palavraingles,palavraportugues,ativo,frase,qtdeseqacertos,data_seq_acertos)');
    qry.SQL.Add('values');
    qry.SQL.Add('(:id,:ingles,:portugues,:ativo,:frase,:qtdeAcertos,:dataAcertos)');
    qry.ParamByName('id').AsInteger :=FId;
    qry.ParamByName('ingles').AsString:= FPalavraIngles;
    qry.ParamByName('portugues').AsString := FPalavraPortugues;
    qry.ParamByName('ativo').AsString := FAtivo;
    qry.ParamByName('frase').AsString := 'F';
    qry.ParamByName('qtdeAcertos').AsInteger := 0;

    if FDataSeqAcertos > StrToDate('30/12/1899') then
      qry.ParamByName('dataAcertos').AsDate := FDataSeqAcertos
    else
      qry.ParamByName('dataAcertos').AsDate := StrToDate('30/12/1899');

    qry.ExecSQL;
  finally
    FreeAndNil(qry);
  end;  
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

procedure TPalavras.setId(const Value: Integer);
begin
  FId := Value;
end;

procedure TPalavras.setMp3(const Value: TBlobData);
begin
  FMp3 := Value;
end;

procedure TPalavras.setObject(APalavraIngles: String);
begin
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
