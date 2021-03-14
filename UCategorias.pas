unit UCategorias;

interface

type

  TCategorias = class
    Fid: SmallInt;
    FDescricao: string;

  private
    function getId: SmallInt;
    procedure setId(const Value: SmallInt);
    function getDescricao: string;
    procedure setDescricao(const Value: string);

  public
    property id: SmallInt read getId write setId;
    property descricao: string read getDescricao write setDescricao;

    class function getConsulta(): String;

  end;

implementation

{ TCategorias }

class function TCategorias.getConsulta: String;
begin
  Result := 'select * from categorias';
end;

function TCategorias.getDescricao: string;
begin
  Result := FDescricao;
end;

function TCategorias.getId: SmallInt;
begin
  Result := Fid;
end;

procedure TCategorias.setDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TCategorias.setId(const Value: SmallInt);
begin
  Fid := Value;
end;

end.
