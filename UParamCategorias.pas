unit UParamCategorias;

interface

uses
  ZDataSet, UDm, System.SysUtils;

Type

  TParam_Categorias = class

  private
    FIdCategoria: SmallInt;
    procedure setId(const Value: SmallInt);
    function getId: SmallInt;


  public
    property idCategoria: SmallInt read getId write setId;
    procedure recorObject();
    procedure deleteObject();
    class function getConsulta : string;

  end;

implementation

{ TParam_Categorias }

procedure TParam_Categorias.deleteObject;
var
  lQry: TZQuery;
begin
  lQry := TZQuery.Create(nil);
  try
    lQry.Connection := Dm.conexao;
    lQry.SQL.Clear;
    lQry.SQL.Add('delete from param_categoria where id_categoria = :id_categoria');
    lQry.ParamByName('id_categoria').AsInteger := FIdCategoria;
    lQry.ExecSQL;
  finally
    FreeAndNil(lQry);
  end;
end;

class function TParam_Categorias.getConsulta: string;
begin
  Result := 'select * from param_categoria';
end;

function TParam_Categorias.getId: SmallInt;
begin
  Result := FIdCategoria;
end;

procedure TParam_Categorias.recorObject;
var
  lQry: TZQuery;
begin
  lQry := TZQuery.Create(nil);
  try
    lQry.Connection := Dm.conexao;
    lQry.SQL.Clear;
    lQry.SQL.Add('update or insert into param_categoria values (:id_categoria) matching (id_categoria)');
    lQry.ParamByName('id_categoria').AsInteger := FIdCategoria;
    lQry.ExecSQL;
  finally
    FreeAndNil(lQry);
  end;
end;

procedure TParam_Categorias.setId(const Value: SmallInt);
begin
  FIdCategoria := Value;
end;

end.
