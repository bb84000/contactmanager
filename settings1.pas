{****************************************************************************** }
{ settings1 - Modify settings form and record                                                }
{ bb - sdtp - november 2019                                                     }
{*******************************************************************************}

unit settings1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, laz2_DOM, laz2_XMLRead, laz2_XMLWrite, lazbbutils, lazbbinifiles;

type

  // Define the classes in this Unit at the very start for clarity
  TFSettings = Class;          // This is a forward class definition

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
    FAppName: String;
    FVersion: String;
    FLastVersion: String;
  public
    constructor Create (AppName: string);
    procedure SetSavSizePos (b: Boolean);
    procedure SetWState (s: string);
    procedure SetLastUpdChk (dt: TDateTime);
    procedure SetNoChkNewVer (b: Boolean);
    procedure SetStartWin (b: Boolean);
    procedure SetStartmini (b: Boolean);
    procedure SetLangStr (s: string);
    procedure SetDataFolder(s: string);
    procedure SetVersion(s: string);
    procedure SetLastVersion(s: String);
    function SaveXMLnode(iNode: TDOMNode): Boolean;
    function SaveToXMLfile(filename: string): Boolean;
    function LoadXMLNode(iNode: TDOMNode): Boolean;
    function LoadXMLFile(filename: string): Boolean;
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
    property AppName: string read FAppName write FAppName;
    property Version: string read FVersion write SetVersion;
    property LastVersion: string read FLastVersion write SetLastVersion;

end;


  { TFSettings }

  TFSettings = class(TForm)
    BtnCancel: TBitBtn;
    BtnOK: TBitBtn;
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
    procedure Translate(LngFile: TBbIniFile);
  end;

var
  FSettings: TFSettings;

implementation

{$R *.lfm}

constructor TConfig.Create(AppName: string);
begin
  inherited Create;
  FAppName:= AppName;
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

procedure TConfig.SetVersion(s:string);
begin
  if FVersion <> s then
  begin
    FVersion:= s;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TConfig.SetLastVersion(s:string);
begin
  if FLastVersion <> s then
  begin
    FLastVersion:= s;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

function TConfig.SaveXMLnode(iNode: TDOMNode): Boolean;
begin
  Try
    TDOMElement(iNode).SetAttribute ('version', FVersion);
    TDOMElement(iNode).SetAttribute ('lastversion', FLastVersion);
    TDOMElement(iNode).SetAttribute ('savsizepos', BoolToString(FSavSizePos));
    TDOMElement(iNode).SetAttribute ('wstate', FWState);
    TDOMElement(iNode).SetAttribute ('lastupdchk', TimeDateToString(FLastUpdChk));
    TDOMElement(iNode).SetAttribute ('nochknewver', BoolToString(FNoChkNewVer));
    TDOMElement(iNode).SetAttribute ('startwin', BoolToString(FStartWin));
    TDOMElement(iNode).SetAttribute ('startmini',BoolToString(FStartMini));
    TDOMElement(iNode).SetAttribute ('langstr', FLangStr);
    TDOMElement(iNode).SetAttribute ('datafolder', FDataFolder);
    Result:= True;
  except
    result:= False;
  end;
end;

function TConfig.SaveToXMLfile(filename: string): Boolean;
var
  SettingsXML: TXMLDocument;
  RootNode, SettingsNode :TDOMNode;
begin
  result:= false;
  if FileExists(filename)then
  begin
    ReadXMLFile(SettingsXML, filename);
    RootNode := SettingsXML.DocumentElement;
  end else
  begin
    SettingsXML := TXMLDocument.Create;
    RootNode := SettingsXML.CreateElement(lowercase(FAppName));
    SettingsXML.Appendchild(RootNode);
  end;
  SettingsNode:= RootNode.FindNode('settings');
  if SettingsNode <> nil then RootNode.RemoveChild(SettingsNode);
  SettingsNode:= SettingsXML.CreateElement('settings');
  SaveXMLnode(SettingsNode);
  RootNode.Appendchild(SettingsNode);
  writeXMLFile(SettingsXML, filename);
  result:= true;
  if assigned(SettingsXML) then SettingsXML.free;
end;

function TConfig.LoadXMLNode(iNode: TDOMNode): Boolean;
var
  i: integer;
  UpCaseAttrib: string;
begin
  Result := false;
  if (iNode = nil) or (iNode.Attributes = nil) then exit;
  // Browse settings attributes
  for i:= 0 to iNode.Attributes.Length-1 do
  try
    UpCaseAttrib:=UpperCase(iNode.Attributes.Item[i].NodeName);
    if UpCaseAttrib='VERSION' then FVersion:= iNode.Attributes.Item[i].NodeValue;
    if UpCaseAttrib='LASTVERSION' then FLastVersion:= iNode.Attributes.Item[i].NodeValue;
    if UpCaseAttrib='SAVSIZEPOS' then FSavSizePos:= StringToBool(iNode.Attributes.Item[i].NodeValue);
    if UpCaseAttrib='WSTATE' then  FWState:= iNode.Attributes.Item[i].NodeValue;
    if UpCaseAttrib='LASTUPDCHK' then FLastUpdChk:= StringToTimeDate(iNode.Attributes.Item[i].NodeValue,'dd/mm/yyyy hh:nn:ss');
    if UpCaseAttrib='NOCHKNEWVER' then FNoChkNewVer:= StringToBool(iNode.Attributes.Item[i].NodeValue);
    if UpCaseAttrib='STARTWIN' then FStartWin:= StringToBool(iNode.Attributes.Item[i].NodeValue);
    if UpCaseAttrib='STARTMINI' then FStartMini:= StringToBool(iNode.Attributes.Item[i].NodeValue);
    if UpCaseAttrib='LANGSTR' then FLangStr:= iNode.Attributes.Item[i].NodeValue;
    if UpCaseAttrib='DATAFOLDER' then FDataFolder:= iNode.Attributes.Item[i].NodeValue;
    result:= true;
  except
    Result:= False;
  end;
end;

function TConfig.LoadXMLFile(filename: string): Boolean;
var
  SettingsXML: TXMLDocument;
  RootNode,SettingsNode : TDOMNode;
begin
  result:= false;
  if not FileExists(filename) then
  begin
    SaveToXMLfile(filename);
  end;
  ReadXMLFile(SettingsXML, filename);
  RootNode := SettingsXML.DocumentElement;
  SettingsNode:= RootNode.FindNode('settings');
  if SettingsNode= nil then exit;
  LoadXMLnode(SettingsNode);
  If assigned(SettingsNode) then SettingsNode.free;
  result:= true;
end;

{ TFSettings : Settings dialog }

procedure TFSettings.CBStartupChange(Sender: TObject);
begin
  CBMinimized.Enabled:= CBStartup.Checked;
end;

procedure TFSettings.Translate(LngFile: TBbIniFile);
var
  DefaultCaption: String;
begin
  if assigned (Lngfile) then
  with LngFile do
  begin
    BtnOK.Caption:= ReadString('Common', 'OKBtn', BtnOK.Caption);
    BtnCancel.Caption:= ReadString('Common', 'CancelBtn', BtnCancel.Caption);
    DefaultCaption:= ReadString('Common', 'Caption', '...');
    Caption:=Format(ReadString('FSettings','Caption','Préférences de %s'), [DefaultCaption]);
    GroupBox1.Caption:=ReadString('FSettings', 'GroupBox1.Caption',GroupBox1.Caption);
    LDataFolder.Caption:=ReadString('FSettings', 'LDataFolder.Caption',LDataFolder.Caption);
    CBStartup.Caption:=ReadString('FSettings', 'CBStartup.Caption',CBStartup.Caption);
    CBMinimized.Caption:=ReadString('FSettings', 'CBMinimized.Caption',CBMinimized.Caption);
    CBSavePos.Caption:=ReadString('FSettings', 'CBSavePos.Caption',CBSavePos.Caption);
    CBUpdate.Caption:=ReadString('FSettings', 'CBUpdate.Caption',CBUpdate.Caption);
    LLangue.Caption:=ReadString('FSettings', 'LLangue.Caption',LLangue.Caption);
  end;
end;

end.

