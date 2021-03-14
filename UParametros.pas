unit UParametros;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,System.StrUtils,System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  parametros, Vcl.DBLookup, Vcl.Samples.Spin, Vcl.CheckLst, ZDataSet, UDm;

type
  TfrmParametros = class(TForm)
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    btnGravar: TBitBtn;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    grpmetodoEstudo: TGroupBox;
    cbParMesclaPalavrasDia: TCheckBox;
    btnutilitario: TBitBtn;
    cbExibirSomenteAudio: TCheckBox;
    cbexibirPlavrasEFrase: TCheckBox;
    grpOutros: TGroupBox;
    cbPalavrasAleatorias: TCheckBox;
    cbOrdenarPalavras: TCheckBox;
    cbRepetirPalavras: TCheckBox;
    seQuantidadeDias: TSpinEdit;
    chkApresentarPalavrasPortugues: TCheckBox;
    GroupBox2: TGroupBox;
    chkCategorias: TCheckListBox;
    btnMarcarTodos: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure btnutilitarioClick(Sender: TObject);
    procedure cbParMesclaPalavrasDiaClick(Sender: TObject);
    procedure btnMarcarTodosClick(Sender: TObject);
  private
    procedure salvarParametro();
    procedure populaCheckListBoxCategorias();
    procedure marcarCategorias();
    procedure atualizaCategorias();

  public
    { Public declarations }
  end;

var
  frmParametros: TfrmParametros;

implementation
uses
 UPalavras, UProgresso, UCategorias, UParamCategorias;

{$R *.dfm}

procedure TfrmParametros.marcarCategorias;
var
  lQry : TZQuery;
  i    : SmallInt;
begin
  lQry := TZQuery.Create(nil);
  try
    lQry.Connection := DM.conexao;
    lQry.Close;
    lQry.SQL.Clear;
    lQry.SQL.Add(TParam_Categorias.getConsulta);
    lQry.Open;

    while not lQry.Eof do
    begin

      for i := 0 to chkCategorias.Items.Count -1 do
      begin
        if Integer(chkCategorias.Items.Objects[i])= lQry.FieldByName('id_categoria').AsInteger then
          chkCategorias.Checked[i]:=True;
      end;

      lQry.Next;

    end;

  finally
    FreeAndNil(lQry);
  end;
end;

procedure TfrmParametros.atualizaCategorias;
var
  lQry : TZQuery;
  i    : SmallInt;
  lParamCategoria : TParam_Categorias;
begin
  lQry := TZQuery.Create(nil);
  try
    lQry.Connection := DM.conexao;
    lQry.Close;
    lQry.SQL.Clear;
    lQry.SQL.Add(TParam_Categorias.getConsulta);
    lQry.Open;

    for i := 0 to chkCategorias.Items.Count -1 do
    begin
      lParamCategoria := TParam_Categorias.Create;
      try
        lParamCategoria.idCategoria := Integer(chkCategorias.Items.Objects[i]);
        if chkCategorias.Checked[i] then
          lParamCategoria.recorObject()
        else
          lParamCategoria.deleteObject();
      finally
        FreeAndNil(lParamCategoria);
      end;
    end;
  finally
    FreeAndNil(lQry);
  end;
end;

procedure TfrmParametros.btnGravarClick(Sender: TObject);
begin

  salvarParametro();
  atualizaCategorias();
  MessageDlg('Registro gravado com sucesso!'+#13+'Inicie o programa novamente.',mtInformation,[mbOK],0);
  close;

end;

procedure TfrmParametros.btnMarcarTodosClick(Sender: TObject);
var
  i : Integer;
begin
  if btnMarcarTodos.Caption = 'Marcar todos' then
  begin
    for i := 0 to chkCategorias.Items.Count -1 do
      chkCategorias.Checked[i]:=True;

    btnMarcarTodos.Caption := 'Desmarcar todos'
  end
  else
  begin
    for i := 0 to chkCategorias.Items.Count -1 do
      chkCategorias.Checked[i]:=False;

    btnMarcarTodos.Caption := 'Marcar todos';
  end;

end;

procedure TfrmParametros.btnutilitarioClick(Sender: TObject);
begin
   salvarParametro();
   
   frmProgresso := TfrmProgresso.Create(nil);
   
   try

     if MessageDlg('Tem certeza que deseja reorganizar as palavras cadastradas para os próximos '+seQuantidadeDias.Text +' dias?',mtConfirmation,
               [mbYes,mbNo],0,mbNo)= mrYes then
     begin   
       frmProgresso.ShowModal(); 
     end;
   finally
     FreeAndNil(frmProgresso);
   end;
 
end;

procedure TfrmParametros.cbParMesclaPalavrasDiaClick(Sender: TObject);
begin
  if cbParMesclaPalavrasDia.Checked then
  begin
    btnutilitario.Enabled    := True;
    seQuantidadeDias.Enabled := True;
  end
  else
    begin
      btnutilitario.Enabled    := False;
      seQuantidadeDias.Enabled := False;
    end;
end;

procedure TfrmParametros.FormShow(Sender: TObject);
var
  par: Tparametros;
begin

  par := Tparametros.Create;

  try
    par.setObject();

    cbRepetirPalavras.Checked      := (par.repetirPalavras);
    cbParMesclaPalavrasDia.Checked := (par.dividePalavrasDia);
    cbOrdenarPalavras.Checked      := (par.ordenarPalavras);
    cbPalavrasAleatorias.Checked   := (par.palavrasAleatorias);
    cbExibirSomenteAudio.Checked   := (par.somenteAudio);
    cbexibirPlavrasEFrase.Checked  := (par.exibirPalavrasComFrases);
    chkApresentarPalavrasPortugues.Checked := ( not par.inglesToPortugues);

    if par.tpLetras = 1 then
      RadioGroup1.ItemIndex := 0
    else
      RadioGroup1.ItemIndex :=1;  

    case par.apresentacaoPalavras of
  
      1  : RadioGroup2.ItemIndex  := 0;  
      4  : RadioGroup2.ItemIndex  := 1;
      8  : RadioGroup2.ItemIndex  := 2;
      12 : RadioGroup2.ItemIndex  := 3;
  
    end;

    seQuantidadeDias.Text := IntToStr(par.quantidadeDiasDivisaoPalavras);
    
    Edit1.Text := IntToStr(par.filtroInicial);
    Edit2.Text := IntToStr(par.filtroFinal);

  finally
    FreeAndNil(par);
  end;

  btnutilitario.Enabled := (cbParMesclaPalavrasDia.Checked);
  seQuantidadeDias.Enabled := (cbParMesclaPalavrasDia.Checked);
  populaCheckListBoxCategorias();
  marcarCategorias();
end;

procedure TfrmParametros.populaCheckListBoxCategorias;
var
  lQry : TZQuery;
  contador : SmallInt;
begin
  lQry := TZQuery.Create(nil);
  try

    lQry.Connection := dm.conexao;
    lQry.Close;
    lQry.SQL.Clear;
    lQry.SQL.Add(TCategorias.getConsulta);
    lQry.Open;

    while not lQry.Eof do
    begin
      chkCategorias.Items.AddObject(lQry.FieldByName('descricao').AsString,TObject(lQry.FieldByName('id').AsInteger));
      lQry.Next;
    end;

  finally
    FreeAndNil(lQry);
  end;
end;

procedure TfrmParametros.RadioGroup2Click(Sender: TObject);
begin
  if RadioGroup2.ItemIndex = 0 then
  begin
    cbExibirSomenteAudio.Enabled  := True;
    cbexibirPlavrasEFrase.Enabled := True;
  end
  else
  begin
    cbExibirSomenteAudio.Enabled  := False;  
    cbExibirSomenteAudio.Checked  := False;
    cbexibirPlavrasEFrase.Enabled := False;
    cbexibirPlavrasEFrase.Checked := False;
  end;
end;

procedure TfrmParametros.salvarParametro;
var
par : TParametros;
begin
  par := TParametros.Create;

  try
    if RadioGroup1.ItemIndex = 0 then
      par.tpLetras:=1
    else
      par.tpLetras:=2;

    if RadioGroup2.ItemIndex = 0 then
      par.apresentacaoPalavras :=1  
    else
    if RadioGroup2.ItemIndex = 1 then
       par.apresentacaoPalavras := 4
    else
      if RadioGroup2.ItemIndex = 2 then
        par.apresentacaoPalavras := 8
      else
        par.apresentacaoPalavras := 12; 

    par.filtroInicial      := StrToInt(Edit1.Text);
    par.filtroFinal        := StrToInt(Edit2.Text);
    par.repetirPalavras    := cbRepetirPalavras.Checked;
    par.palavrasAleatorias := cbPalavrasAleatorias.Checked;
    par.dividePalavrasDia  := cbParMesclaPalavrasDia.Checked;  
    par.ordenarPalavras    := cbOrdenarPalavras.Checked;
    par.somenteAudio       := cbExibirSomenteAudio.Checked;
    par.exibirPalavrasComFrases := cbexibirPlavrasEFrase.Checked;
    par.quantidadeDiasDivisaoPalavras := StrToInt(seQuantidadeDias.Text);
    par.inglesToPortugues := not chkApresentarPalavrasPortugues.Checked;

    par.recordObject;

  finally
    FreeAndNil(par);
  end;
     
end;

end.
