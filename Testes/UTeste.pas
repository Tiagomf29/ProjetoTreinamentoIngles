unit UTeste;

interface

uses
  DUnitX.TestFramework, Upalavras, SysUtils, UDM, Classes;

type
  [TestFixture]
  TMyTestObject = class
  private
    palavras : TPalavras;
    conexao  : TDM;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    [TestCase('TestA','BOX')]
    [TestCase('TestB','RED')]
    [TestCase('TestC','GET')]
    procedure validaAtualizacao(AValue : String);
    [Test]
    [TestCase('TestA1','BOX')]
    [TestCase('TestB2','RED')]
    [TestCase('TestC3','GET')]
    procedure validaCarregamentoPalavras(AValue : String);
  end;

implementation

procedure TMyTestObject.Setup;
begin
  palavras := TPalavras.Create;
  conexao  := TDM.Create(nil);
  conexao.conexao.Connect;
end;

procedure TMyTestObject.TearDown;
begin
  FreeAndNil(palavras);
  FreeAndNil(conexao);
end;

procedure TMyTestObject.validaAtualizacao(AValue: String);
begin
  try
    palavras.setObject(AValue);
    palavras.recordObjectAtualizacao();
  except on e: Exception do
    Assert.Fail(e.Message);
  end;
end;

procedure TMyTestObject.validaCarregamentoPalavras(AValue : String);
var
  lista : TStringList;
  i,j : Integer;
begin
  Assert.IsNotNull(AValue,'Parametro não pode ser vazio!');
  
  lista := TStringList.Create;
  try
    for i := 0 to Length(AValue) do
      lista.Add(AValue[i]);
      
    palavras.setObject(AValue);
    for j := 0 to 9 do      
      Assert.DoesNotContain(lista,IntToStr(j),'Caracter inválido para a palavra');
  finally
    FreeAndNil(lista);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
