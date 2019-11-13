{****************************************************************************** }
{ settings1 - Modify settings form and record                                                }
{ bb - sdtp - november 2019                                                     }
{*******************************************************************************}

unit settings1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, laz2_DOM , laz2_XMLRead;

type

  // Define the classes in this Unit at the very start for clarity
  TFPrefs = Class;          // This is a forward class definition

  // Settings record management
  TConfig = class
  private
    FOnChange: TNotifyEvent;
    FOnStateChange: TNotifyEvent;
    FSavSizePos: Boolean;
    FWState: string;
    FLastUpdChk: Tdatetime;
    FNoChkNewVer: Boolean;
    FStartWin: Boolean;
    FStartMini: Boolean;
    FLangStr: String;
    FDataFolder: String;
    Parent: TObject;
    function readIntValue(inode : TDOMNode; Attrib: String): Int64;
    function readDateValue(inode : TDOMNode; Attrib: String): TDateTime;
  public
    constructor Create (Sender: TObject); overload;
    procedure SetSavSizePos (b: Boolean);
    procedure SetWState (s: string);
    procedure SetLastUpdChk (dt: TDateTime);
    procedure SetNoChkNewVer (b: Boolean);
    procedure SetStartWin (b: Boolean);
    procedure SetStartmini (b: Boolean);
    procedure SetLangStr (s: string);
    procedure SetDataFolder(s: string);
    function SaveXMLnode(iNode: TDOMNode): Boolean;
    function ReadXMLNode(iNode: TDOMNode): Boolean;

  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnStateChange: TNotifyEvent read FOnStateChange write FOnStateChange;
    property SavSizePos: Boolean read FSavSizePos write SetSavSizePos;
    property WState: string read FWState write SetWState;
    property LastUpdChk: Tdatetime read FLastUpdChk write SetLastUpdChk;
    property NoChkNewVer: Boolean read FNoChkNewVer write SetNoChkNewVer;
    property StartWin: Boolean read FStartWin write SetStartWin;
    property StartMini: Boolean read FStartMini write SetStartMini;
    property LangStr: String read FLangStr write SetLangStr;
    property DataFolder: string read FDataFolder write setDataFolder;
end;


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
    procedure CBStartupChange(Sender: TObject);
  private

  public

  end;

var
  FPrefs: TFPrefs;

implementation

{$R *.lfm}

constructor TConfig.Create(Sender: TObject);
begin
  Create;
  Parent:= Sender;
end;

procedure TConfig.SetSavSizePos(b: Boolean);
begin
  if FSavSizePos <> b then
  begin
    FSavSizePos:= b;
    if Assigned(FOnStateChange) then FOnStateChange(Self);
  end;
end;

procedure TConfig.SetWState(s: string);
begin
   if FWState <> s then
   begin
     FWState:= s;
     if Assigned(FOnStateChange) then FOnStateChange(Self);
   end;
end;

procedure TConfig.SetLastUpdChk(dt: TDateTime);
begin
   if FLastUpdChk <> dt then
   begin
     FLastUpdChk:= dt;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetNoChkNewVer(b: Boolean);
begin
   if FNoChkNewVer <> b then
   begin
     FNoChkNewVer:= b;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;


procedure TConfig.SetStartWin (b: Boolean);
begin
   if FStartWin <> b then
   begin
     FStartWin:= b;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetStartMini (b: Boolean);
begin
   if FStartMini <> b then
   begin
     FStartMini:= b;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetLangStr (s: string);
begin
  if FLangStr <> s then
  begin
    FLangStr:= s;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TConfig.SetDataFolder (s: string);
begin
  if FDataFolder <> s then
  begin
    FDataFolder:= s;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

function TConfig.readIntValue(inode : TDOMNode; Attrib: String): INt64;
var
  s: String;
begin
  s:= TDOMElement(iNode).GetAttribute(Attrib) ;
  try
    result:= StrToInt64(s);
  except
    result:= 0;
  end;
end;

function TConfig.readDateValue(inode : TDOMNode; Attrib: String): TDateTime;
var
  s: String;
begin
  s:= TDOMElement(iNode).GetAttribute(Attrib) ;
  try
    result:= StrToDateTime(s);
  except
    result:= now();
  end;
end;

function TConfig.SaveXMLnode(iNode: TDOMNode): Boolean;
begin
  Try
    TDOMElement(iNode).SetAttribute ('savsizepos', IntToStr(Integer(FSavSizePos)));
    TDOMElement(iNode).SetAttribute ('wstate', FWState);
    TDOMElement(iNode).SetAttribute ('lastupdchk', DateToStr(FLastUpdChk));
    TDOMElement(iNode).SetAttribute ('nochknewver', IntToStr(Integer(FNoChkNewVer)));
    TDOMElement(iNode).SetAttribute ('startwin', IntToStr(Integer(FStartWin)));
    TDOMElement(iNode).SetAttribute ('startmini',IntToStr(Integer(FStartMini)));
    TDOMElement(iNode).SetAttribute ('langstr', FLangStr);
    TDOMElement(iNode).SetAttribute ('datafolder', FDataFolder);
    Result:= True;
  except
    result:= False;
  end;
end;

function TConfig.ReadXMLNode(iNode: TDOMNode): Boolean;
begin
  try
    FSavSizePos:= Boolean(readIntValue(iNode, 'savsizepos'));
    FWState:= TDOMElement(iNode).GetAttribute('wstate');
    FLastUpdChk:= readDateValue(iNode, 'lastupdchk');
    FNoChkNewVer:= Boolean(readIntValue(iNode, 'nochknewver'));
    FStartWin:= Boolean(readIntValue(iNode, 'startwin'));
    FStartMini:= Boolean(readIntValue(iNode, 'startmini'));
    FLangStr:= TDOMElement(iNode).GetAttribute('langstr');
    FDataFolder:= TDOMElement(iNode).GetAttribute('datafolder');  ;
    result:= true;
  except
    Result:= False;
  end;
end;


{ TFPrefs : Settings dialog }

procedure TFPrefs.CBStartupChange(Sender: TObject);
begin
  CBMinimized.Enabled:= CBStartup.Checked;
end;



end.

