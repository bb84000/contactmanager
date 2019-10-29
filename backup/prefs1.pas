unit prefs1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFPrefs }

  TFPrefs = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    CBSavePos: TCheckBox;
    CBStartup: TCheckBox;
    CBMinimized: TCheckBox;
    CBUpdate: TCheckBox;
    CBLangue: TComboBox;
    EDataFolder: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LDataFolder: TLabel;
    LStatus: TLabel;
    PnlButtons: TPanel;
    PnlStatus: TPanel;
    procedure CBMinimizedChange(Sender: TObject);
  private

  public

  end;

var
  FPrefs: TFPrefs;

implementation

{$R *.lfm}

{ TFPrefs }

procedure TFPrefs.CBMinimizedChange(Sender: TObject);
begin

end;

end.

