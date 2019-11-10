{****************************************************************************** }
{ prefs1 - Modify settings form                                                 }
{ bb - sdtp - november 2019                                                     }
{*******************************************************************************}

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
    LLangue: TLabel;
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

