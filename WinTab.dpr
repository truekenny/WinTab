program WinTab;

uses
  Vcl.Forms,
  UnitM in 'UnitM.pas' {Frm};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TFrm, Frm);
  Application.Run;
end.
