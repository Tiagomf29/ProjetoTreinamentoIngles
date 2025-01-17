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
    FPalavrasAleatorias : string;
    FDividePalavrasDia : string;
    FOrdenarPalavras : string;
    FSomenteAudio : string;
    FExibirPalavrasComFrases : string;
    FQuantidadeDiasDivisaoPalavras : SmallInt;
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
    function getDividePalavrasDia: Boolean;
    function getOrdenarPalavras: Boolean;
    function getPalavrasAleatorias: Boolean;
    procedure setDividePalavrasDia(const Value: Boolean);
    procedure setOrdenarPalavras(const Value: Boolean);
    procedure setPalavrasAleatorias(const Value: Boolean);
    function getSomenteAudio: Boolean;
    procedure setSomenteAudio(const Value: Boolean);
    function getExibirPalavrasComFrases: Boolean;
    procedure setExibirPalavrasComFrases(const Value: Boolean);
    function getQuantidadeDiasDivisaoPalavras: SmallInt;
    procedure setQuantidadeDiasDivisaoPalavras(const Value: SmallInt);

  public
    property id: Integer read getId write setId;
    property tpLetras: SmallInt read getTpLetras write setTpLetras;
    property apresentacaoPalavras: SmallInt read getApresentacaoPalavras write setApresentacaoPalavras;
    property filtroInicial :SmallInt read getfiltroInicial write setFiltroInicial;
    property filtroFinal :SmallInt read getfiltroFinal write setfiltroFinal;
    property repetirPalavras : Boolean read getRepetirPalavras write setRepetirPalavras;
    property inglesToPortugues : Boolean read getInglesToPortugues write setInglesToPortugues;
    property palavrasAleatorias : Boolean read getPalavrasAleatorias write setPalavrasAleatorias;
    property dividePalavrasDia :Boolean read getDividePalavrasDia write setDividePalavrasDia;
    property ordenarPalavras: Boolean read getOrdenarPalavras write setOrdenarPalavras;
    property somenteAudio: Boolean read getSomenteAudio write setSomenteAudio;
    property exibirPalavrasComFrases: Boolean read getExibirPalavrasComFrases write setExibirPalavrasComFrases;
    property quantidadeDiasDivisaoPalavras :SmallInt read getQuantidadeDiasDivisaoPalavras write setQuantidadeDiasDivisaoPalavras;

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

function TParametros.getDividePalavrasDia: Boolean;
begin
  if FDividePalavrasDia = 'T' then
    Result := true
  else
    Result :=False;
end;

function TParametros.getExibirPalavrasComFrases: Boolean;
begin
  if FExibirPalavrasComFrases = 'T' then
    Result := true
  else
    Result :=False;
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

function TParametros.getOrdenarPalavras: Boolean;
begin
  if FOrdenarPalavras = 'T' then
    Result := true
  else
    Result :=False;
end;

function TParametros.getPalavrasAleatorias: Boolean;
begin
  if FPalavrasAleatorias = 'T' then
    Result := true
  else
    Result :=False;
end;

function TParametros.getQuantidadeDiasDivisaoPalavras: SmallInt;
begin
  Result := FQuantidadeDiasDivisaoPalavras;
end;

function TParametros.getRepetirPalavras: Boolean;
begin  
  if FRepetirPalavras = 'T' then
    Result := true
  else
    Result :=False;
end;

function TParametros.getSomenteAudio: Boolean;
begin
  if FSomenteAudio = 'T' then
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
  qryTemp : TZQuery;
begin

  qryTemp := TZQuery.Create(nil);

  try
  
    qryTemp.Connection := DM.conexao;

    qryTemp.Connection.StartTransaction;

    qryTemp.Close;
    qryTemp.SQL.Clear;
    qryTemp.SQL.Add('update parametros set tp_letras =:tp_letras, apresentacao_palavras =:apresentacao_palavras,'); 
    qryTemp.SQL.Add('filtro_palavras_in =:filtroIN, filtro_palavras_fi =:filtroFI,exibir_Palavra_com_frase =:epcf,');
    qryTemp.SQL.Add('repetir_palavra =:rp,ingles_to_portugues =:itp, palavras_aleatorias =:pa, divide_palavras_dia =:dpd, ordenar_palavras =:op,');
    qryTemp.SQL.Add('somenteAudio =:sa,qtde_dias_divisao_palavras =:qddp');

    qryTemp.ParamByName('tp_letras').AsInteger              := FTpLetras;
    qryTemp.ParamByName('apresentacao_palavras').AsInteger  := FApresentacaoPalavras;
    qryTemp.ParamByName('filtroIN').AsInteger               := FfiltroInicial;
    qryTemp.ParamByName('filtroFI').AsInteger               := FfiltroFinal;
    qryTemp.ParamByName('rp').AsString                      := FRepetirPalavras;
    qryTemp.ParamByName('itp').AsString                     := FInglesToPortugues;
    qryTemp.ParamByName('pa').AsString                      := FPalavrasAleatorias;
    qryTemp.ParamByName('dpd').AsString                     := FDividePalavrasDia;
    qryTemp.ParamByName('op').AsString                      := FOrdenarPalavras;
    qryTemp.ParamByName('sa').AsString                      := FSomenteAudio;
    qryTemp.ParamByName('epcf').AsString                    := FExibirPalavrasComFrases;
    qryTemp.ParamByName('qddp').AsInteger                   := FQuantidadeDiasDivisaoPalavras;

    qryTemp.ExecSQL;
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end;
  
end;

procedure TParametros.setApresentacaoPalavras(const Value: SmallInt);
begin
  FApresentacaoPalavras := Value;
end;

procedure TParametros.setDividePalavrasDia(const Value: Boolean);
begin
  if Value then
    FDividePalavrasDia := 'T'
  else
    FDividePalavrasDia := 'F';
end;

procedure TParametros.setExibirPalavrasComFrases(const Value: Boolean);
begin
  if Value then
    FExibirPalavrasComFrases := 'T'
  else
    FExibirPalavrasComFrases := 'F';
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
  qryTemp : TZQuery;
begin

  qryTemp := TZQuery.Create(nil);
  
  try

    qryTemp.Connection :=  DM.conexao;

    qryTemp.Connection.StartTransaction;
  
    qryTemp.Close;
    qryTemp.SQL.Clear;
    qryTemp.SQL.Add('select * from parametros ');
    qryTemp.Open;
    
    FId                   := qryTemp.FieldByName('id').AsInteger;
    FTpLetras             := qryTemp.FieldByName('tp_letras').AsInteger;
    FApresentacaoPalavras := qryTemp.FieldByName('apresentacao_palavras').AsInteger;
    FfiltroInicial        := qryTemp.FieldByName('filtro_palavras_in').AsInteger;
    FfiltroFinal          := qryTemp.FieldByName('filtro_palavras_fi').AsInteger;
    FRepetirPalavras      := qryTemp.FieldByName('repetir_palavra').AsString;
    FInglesToPortugues    := qryTemp.FieldByName('ingles_to_portugues').AsString;
    FPalavrasAleatorias   := qryTemp.FieldByName('palavras_aleatorias').AsString;
    FDividePalavrasDia    := qryTemp.FieldByName('divide_palavras_dia').AsString;
    FOrdenarPalavras      := qryTemp.FieldByName('ordenar_palavras').AsString;
    FSomenteAudio         := qryTemp.FieldByName('somenteAudio').AsString;
    FExibirPalavrasComFrases := qryTemp.FieldByName('exibir_Palavra_com_frase').AsString;
    FQuantidadeDiasDivisaoPalavras := qryTemp.FieldByName('qtde_dias_divisao_palavras').AsInteger;
    
  finally
    qryTemp.Connection.Commit();
    FreeAndNil(qryTemp);
  end;
    
end;

procedure TParametros.setOrdenarPalavras(const Value: Boolean);
begin
  if Value then
    FOrdenarPalavras := 'T'
  else
    FOrdenarPalavras := 'F';
end;

procedure TParametros.setPalavrasAleatorias(const Value: Boolean);
begin
  if Value then
    FPalavrasAleatorias := 'T'
  else
    FPalavrasAleatorias := 'F';
end;

procedure TParametros.setQuantidadeDiasDivisaoPalavras(const Value: SmallInt);
begin
   FQuantidadeDiasDivisaoPalavras := Value;
end;

procedure TParametros.setRepetirPalavras(const Value: Boolean);
begin
  if Value then
    FRepetirPalavras := 'T'
  else
    FRepetirPalavras := 'F';  
end;

procedure TParametros.setSomenteAudio(const Value: Boolean);
begin
  if Value then
    FSomenteAudio := 'T'
  else
    FSomenteAudio := 'F';
end;

procedure TParametros.setTpLetras(const Value: SmallInt);
begin
  FTpLetras := Value;
end;

end.
