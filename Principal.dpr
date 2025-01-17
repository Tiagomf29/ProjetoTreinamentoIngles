program Principal;

uses
  Vcl.Forms,
  UPalavrasIngles in 'UPalavrasIngles.pas' {frmPrincipal},
  UDM in 'UDM.pas' {DM: TDataModule},
  UCadastroPalavras in 'UCadastroPalavras.pas' {frmCadastroPalavras},
  UPalavras in 'UPalavras.pas',
  UParametros in 'UParametros.pas' {frmParametros},
  parametros in 'parametros.pas',
  Vcl.Themes,
  Vcl.Styles,
  UProgresso in 'UProgresso.pas' {frmProgresso},
  UConexaoBanco in 'UConexaoBanco.pas',
  UCategorias in 'UCategorias.pas',
  UParamCategorias in 'UParamCategorias.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Graphite');

  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
  
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
