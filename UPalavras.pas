unit UPalavras;

interface
uses
  ZDataSet, UDM, System.SysUtils, System.Generics.Collections;

type

  TPalavras = class

  private
    FId : Integer;
    FPalavraIngles : String;
    FPalavraPortugues : String;
    FAtivo : String;
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
  public
    property id : Integer read getId write setId;
    property palavraIngles : String read getPalavraIngles write setPalavrasIngles;
    property palavraPortugues : String read getPalavraPortugues write setPalavrasPortuguess;
    property ativo : Boolean read getAtivo write setAtivo;

    function listaPalavrasIngles(AParam1,AParam2 : SmallInt): TObjectList<TPalavras>;

    procedure setObject(APalavraIngles : String);
    procedure recordObjectInsercao();
    procedure recordObjectAtualizacao();
    procedure recordObjectDelete();

    constructor Create();
    destructor Destroy; override;
    
  end;

implementation

{ TPalavras }

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

function TPalavras.listaPalavrasIngles(AParam1,AParam2 : SmallInt): TObjectList<TPalavras>;
var  
  palavraIngles : TPalavras;
begin

  FQry.Close;
  FQry.SQL.Clear;
  FQry.SQL.Add('select * from palavras where frase = '+QuotedStr('F'));
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
end;

procedure TPalavras.setPalavrasIngles(const Value: String);
begin
 FPalavraIngles := Value;
end;

procedure TPalavras.setPalavrasPortuguess(const Value: String);
begin
  FPalavraPortugues := Value;
end;

end.
