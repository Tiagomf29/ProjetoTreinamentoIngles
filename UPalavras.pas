unit UPalavras;

interface
uses
  ZDataSet, UDM, System.SysUtils, System.Generics.Collections,FMX.Dialogs;

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
  public
    property id : Integer read getId write setId;
    property palavraIngles : String read getPalavraIngles write setPalavrasIngles;
    property palavraPortugues : String read getPalavraPortugues write setPalavrasPortuguess;
    property ativo : Boolean read getAtivo write setAtivo;
    property frase : Boolean read getFrase write setFrase;
    property qtdeSeqAcertos : SmallInt read getQtdeSeqAcertos write setQtdeSeqAcertos;

    function listaPalavrasIngles(AParam1,AParam2 : SmallInt): TObjectList<TPalavras>;

    procedure setObject(APalavraIngles : String);
    procedure recordObjectInsercao();
    procedure recordObjectAtualizacao();
    procedure recordObjectDelete();
    procedure atualizaStatusExibicaoPalavras(palavra : String; qtde : smallint);
    procedure atualizaQtdePalavrasFecharTela();

    constructor Create();
    destructor Destroy; override;
    
  end;

implementation

{ TPalavras }

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

  dia := Copy(DateToStr(Now+3),1,2);
  mes := Copy(DateToStr(Now+3),4,2);
  ano := Copy(DateToStr(Now+3),7,4);

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

function TPalavras.getAtivo: Boolean;
begin
  
  if  FAtivo = 'T' then
    Result := True
  else
    Result := False;  
 
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

function TPalavras.listaPalavrasIngles(AParam1,AParam2 : SmallInt): TObjectList<TPalavras>;
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
  FQry.SQL.Add('and data_seq_acertos <='+QuotedStr(mes+'/'+dia+'/'+ano));
  if AParam1 > 0 then
  begin
    FQry.SQL.Add(' and id between '+IntToStr(AParam1)+' and '+IntToStr(AParam2));
    FQry.SQL.Add(' order by 1');
  end 
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
    qry.SQL.Add('(id,palavraingles,palavraportugues,ativo)');
    qry.SQL.Add('values');
    qry.SQL.Add('(:id,:ingles,:portugues,:ativo)');
    qry.ParamByName('id').AsInteger :=FId;
    qry.ParamByName('ingles').AsString:= FPalavraIngles;
    qry.ParamByName('portugues').AsString := FPalavraPortugues;
    qry.ParamByName('ativo').AsString := FAtivo;

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
