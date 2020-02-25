unit parametros;

interface

type

  TParametros = class

  private

    FId: Integer;
    FTpLetras: SmallInt;
    FApresentacaoPalavras: SmallInt;
    FFiltroInicial : SmallInt;
    FFiltroFinal : SmallInt;
    FRepetirPalavras : String;
    FInglesToPortugues : string;
    function getApresentacaoPalavras: SmallInt;
    function getId: Integer;
    function getTpLetras: SmallInt;
    procedure setApresentacaoPalavras(const Value: SmallInt);
    procedure setId(const Value: Integer);
    procedure setTpLetras(const Value: SmallInt);
    function getfiltroFinal: SmallInt;
    function getfiltroInicial: SmallInt;
    procedure setfiltroFinal(const Value: SmallInt);
    procedure setFiltroInicial(const Value: SmallInt);
    function getRepetirPalavras: Boolean;
    procedure setRepetirPalavras(const Value: Boolean);
    function getInglesToPortugues: Boolean;
    procedure setInglesToPortugues(const Value: Boolean);

  public
    property id: Integer read getId write setId;
    property tpLetras: SmallInt read getTpLetras write setTpLetras;
    property apresentacaoPalavras: SmallInt read getApresentacaoPalavras write setApresentacaoPalavras;
    property filtroInicial :SmallInt read getfiltroInicial write setFiltroInicial;
    property filtroFinal :SmallInt read getfiltroFinal write setfiltroFinal;
    property repetirPalavras : Boolean read getRepetirPalavras write setRepetirPalavras;
    property inglesToPortugues : Boolean read getInglesToPortugues write setInglesToPortugues;

    procedure setObject();
    procedure recordObject();

  end;

implementation
uses
  UDM, ZDataSet, System.SysUtils;
  

{ TParametros }

function TParametros.getApresentacaoPalavras: SmallInt;
begin
  Result := FApresentacaoPalavras;
end;

function TParametros.getfiltroFinal: SmallInt;
begin
  Result := FfiltroFinal;
end;

function TParametros.getfiltroInicial: SmallInt;
begin
  Result := FfiltroInicial;
end;

function TParametros.getId: Integer;
begin
  Result := FId;
end;

function TParametros.getInglesToPortugues: Boolean;
begin
  if FInglesToPortugues = 'T' then
    Result := true
  else
    Result :=False;
end;

function TParametros.getRepetirPalavras: Boolean;
begin  
  if FRepetirPalavras = 'T' then
    Result := true
  else
    Result :=False;
end;

function TParametros.getTpLetras: SmallInt;
begin
  Result := FTpLetras;
end;

procedure TParametros.recordObject;
var
  qry : TZQuery;
begin

  qry := TZQuery.Create(nil);

  try
  
    qry.Connection := DM.conexao;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('update parametros set tp_letras =:tp_letras, apresentacao_palavras =:apresentacao_palavras,'); 
    qry.SQL.Add('filtro_palavras_in =:filtroIN, filtro_palavras_fi =:filtroFI, repetir_palavra =:rp,ingles_to_portugues =:itp');
    qry.ParamByName('tp_letras').AsInteger := FTpLetras;
    qry.ParamByName('apresentacao_palavras').AsInteger := FApresentacaoPalavras;
    qry.ParamByName('filtroIN').AsInteger := FfiltroInicial;
    qry.ParamByName('filtroFI').AsInteger := FfiltroFinal;
    qry.ParamByName('rp').AsString := FRepetirPalavras;
    qry.ParamByName('itp').AsString := 'T';
    
    qry.ExecSQL;
  finally
    FreeAndNil(qry);
  end;
  
end;

procedure TParametros.setApresentacaoPalavras(const Value: SmallInt);
begin
  FApresentacaoPalavras := Value;
end;

procedure TParametros.setfiltroFinal(const Value: SmallInt);
begin
  FfiltroFinal := Value;
end;

procedure TParametros.setFiltroInicial(const Value: SmallInt);
begin
  FfiltroInicial:=Value;
end;

procedure TParametros.setId(const Value: Integer);
begin
  FId := Value;
end;

procedure TParametros.setInglesToPortugues(const Value: Boolean);
begin
  if Value then
    FInglesToPortugues := 'T'
  else
    FInglesToPortugues := 'F';
end;

procedure TParametros.setObject();
var
  qry : TZQuery;
begin

  qry := TZQuery.Create(nil);
  
  try

    qry.Connection :=  DM.conexao;
  
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from parametros ');
    qry.Open;
    FId := qry.FieldByName('id').AsInteger;
    FTpLetras := qry.FieldByName('tp_letras').AsInteger;
    FApresentacaoPalavras := qry.FieldByName('apresentacao_palavras').AsInteger;
    FfiltroInicial := qry.FieldByName('filtro_palavras_in').AsInteger;
    FfiltroFinal := qry.FieldByName('filtro_palavras_fi').AsInteger;
    FRepetirPalavras := qry.FieldByName('repetir_palavra').AsString;
    FInglesToPortugues := qry.FieldByName('ingles_to_portugues').AsString;
    
  finally
    FreeAndNil(qry);
  end;
    
end;

procedure TParametros.setRepetirPalavras(const Value: Boolean);
begin
  if Value then
    FRepetirPalavras := 'T'
  else
    FRepetirPalavras := 'F';  
end;

procedure TParametros.setTpLetras(const Value: SmallInt);
begin
  FTpLetras := Value;
end;

end.
