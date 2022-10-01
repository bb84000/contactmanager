program contactmgr;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, contactmgr1, impex1, lazbbaboutupdate, settings1, lazbbcomponents;

{$R *.res}
{$R contactmgr1.rc}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='ContactsMgr';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFContactManager, FContactManager);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TFImpex, FImpex);
  Application.CreateForm(TFSettings, FSettings);
  Application.Run;
end.

