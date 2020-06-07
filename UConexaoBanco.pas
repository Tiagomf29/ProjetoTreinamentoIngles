unit UConexaoBanco;

interface
uses
  System.SysUtils,ZConnection, System.Classes, ZAbstractConnection;
  
type
 TConexaoBanco = class

  private
    conexaoZeos : TZConnection;
   
  public
    function conectar(): TZConnection; 
    constructor Create();
    destructor Destroy; override;
    
end;

implementation

{ tConexaoBanco }

function TConexaoBanco.conectar():TZConnection;
begin
  conexaoZeos.Database := 'C:\Ingles\Banco\BANCO.FDB';
  conexaoZeos.Name := 'conexaoBanco';
  conexaoZeos.Password := 'masterkey';
  conexaoZeos.Protocol := 'firebird-3.0';
  conexaoZeos.User := 'sysdba';
  conexaoZeos.Connected := True;

  Result := conexaoZeos;
end;

constructor TConexaoBanco.Create();
begin
  inherited;
  conexaoZeos := TZConnection.Create(nil);
end;

destructor TConexaoBanco.Destroy;
begin
  FreeAndNil(conexaoZeos);
  inherited;
end;

end.
