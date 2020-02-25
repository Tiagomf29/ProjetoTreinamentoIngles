unit UDM;

interface

uses
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection;

type
  TDM = class(TDataModule)
    conexao: TZConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
