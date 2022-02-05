program SharedMemoryDemo;

uses
  Vcl.Forms,
  ufmMain in 'ufmMain.pas' {frmMain},
  Common.Thread in 'Common.Thread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
