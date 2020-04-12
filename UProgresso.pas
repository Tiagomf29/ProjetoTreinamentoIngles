unit UProgresso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Gauges, System.Generics.Collections,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TfrmProgresso = class(TForm)
    timer: TTimer;
    progresso: TGauge;
    procedure timerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure executarUtilitario();
  public
    { Public declarations }
  end;

var
  frmProgresso: TfrmProgresso;

implementation
uses 
  UPalavras,Parametros; 

{$R *.dfm}

procedure TfrmProgresso.executarUtilitario;
var
  lDataInicial               : TDate;
  lQtdePalavraPorDia,i,j     : Integer;
  palavrasTemp,palavrasTemp2 : TPalavras;
  parametrosTemp             : TParametros;
  listaTmp                   : TObjectList<TPalavras>;
begin
  
  parametrosTemp := TParametros.Create;

  // criei a rotina para conseguir destruir o primeiro objeto criado por conta do memoy leak
  
  palavrasTemp2  := TPalavras.Create;
  
  palavrasTemp2.listaPalavrasIngles(parametrosTemp.filtroInicial,parametrosTemp.filtroFinal,(parametrosTemp.ordenarPalavras),(parametrosTemp.dividePalavrasDia));

  listaTmp       := TObjectList<TPalavras>.Create;
  
  try
    for I := 0 to palavrasTemp2.lista.Count -1 do
    begin

      palavrasTemp := TPalavras.Create;
  
      palavrasTemp.id               := palavrasTemp2.lista.Items[i].id;
      palavrasTemp.palavraIngles    := palavrasTemp2.lista.Items[i].palavraIngles;
      palavrasTemp.palavraPortugues := palavrasTemp2.lista.Items[i].palavraPortugues;

      listaTmp.Add(palavrasTemp);
    end;
  finally
    FreeAndNil(palavrasTemp2);
  end;

  // Fim da rotina memory leak
    
  lQtdePalavraPorDia := listaTmp.Count div 4;

  lDataInicial       := Now;
  j                  := 1;
  
  progresso.MaxValue := listaTmp.Count;
  progresso.MinValue := 0;
  
  try
     
    for i := 0 to listaTmp.Count -1 do
    begin
         
      palavrasTemp                    := TPalavras.Create;     
  
      try
     
        palavrasTemp.id               := listaTmp.Items[i].id;
        palavrasTemp.qtdeSeqAcertos   := 0;
        palavrasTemp.dataSeqAcertos   := lDataInicial;

        palavrasTemp.atualizaSeparaPalavrasBydata();
       
      finally
        FreeAndNil(palavrasTemp);
      end;

      if lQtdePalavraPorDia = j then
      begin
        J := 1;
        lDataInicial := lDataInicial +1;
        progresso.Progress := progresso.Progress +1;
      end
      else
        begin
          Inc(j);
          progresso.Progress := progresso.Progress +1;
        end;      
     
    end;

    timer.Enabled := False;
    MessageDlg('Organização de palavras por dia concluído com sucesso!',mtInformation,[mbOK],0);     
    
  finally
    FreeAndNil(parametrosTemp);
    FreeAndNil(listaTmp);
    FreeAndNil(palavrasTemp);       
  end;

end;

procedure TfrmProgresso.FormShow(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TfrmProgresso.timerTimer(Sender: TObject);
begin
  executarUtilitario();
  timer.Enabled := False;
  frmProgresso.Close;
end;

end.
