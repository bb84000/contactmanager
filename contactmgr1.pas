{****************************************************************************** }
{ Contacts manager main form  - bb - sdtp - november 2019                       }
{*******************************************************************************}

unit contactmgr1;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Win32Proc,
  {$ENDIF} Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, contacts1, laz2_DOM, laz2_XMLRead, laz2_XMLWrite,
  Types, lazbbosversion,
  lazbbutils, impex1, lclintf, Menus, ExtDlgs, fphttpclient, fpopenssl,
  openssl, strutils, lazbbabout, settings1, lazbbinifiles,
  LazUTF8, Clipbrd, UniqueInstance, lazbbalert, lazbbchknewver, lazbbautostart;

type
  TSaveMode = (None, Setting, All);
  { TFContactManager }

  TFContactManager = class(TForm)
    BtnDelete: TSpeedButton;
    BtnAbout: TSpeedButton;
    BtnEmailWk: TSpeedButton;
    BtnSearch: TSpeedButton;
    BtnWeb: TSpeedButton;
    BtnPrefs: TSpeedButton;
    BtnQuit: TSpeedButton;
    BtnValid: TSpeedButton;
    BtnAdd: TSpeedButton;
    BtnLast: TSpeedButton;
    BtnLocate: TSpeedButton;
    BtnNext: TSpeedButton;
    BtnCoord: TSpeedButton;
    BtnPrev: TSpeedButton;
    BtnCancel: TSpeedButton;
    BtnWebWk: TSpeedButton;
    EAutre: TEdit;
    EAutreWk: TEdit;
    EBox: TEdit;
    EBoxWk: TEdit;
    EService: TEdit;
    ECountry: TEdit;
    ECountryWk: TEdit;
    EEmailWk: TEdit;
    ELatitudeWk: TEdit;
    ELieuditWk: TEdit;
    ELongitude: TEdit;
    ELongitudeWk: TEdit;
    EMobileWk: TEdit;
    EFonction: TEdit;
    EBpWk: TEdit;
    ESearch: TEdit;
    EPhoneWk: TEdit;
    EPostcodeWk: TEdit;
    EDate: TEdit;
    ELatitude: TEdit;
    EDatemodif: TEdit;
    EStreetWk: TEdit;
    ECompany: TEdit;
    ETownWk: TEdit;
    EWeb: TEdit;
    ELieudit: TEdit;
    EMobile: TEdit;
    EName: TEdit;
    EEmail: TEdit;
    EBP: TEdit;
    EPhone: TEdit;
    EPostcode: TEdit;
    EStreet: TEdit;
    ESurname: TEdit;
    ETown: TEdit;
    EWebWk: TEdit;
    GBOrder: TGroupBox;
    ImgContact: TImage;
    LImageFile: TLabel;
    LAutre: TLabel;
    LAutreWk: TLabel;
    LBContacts: TListBox;
    LBox: TLabel;
    LBoxWk: TLabel;
    LBP: TLabel;
    LBPWk: TLabel;
    LService: TLabel;
    LCountry: TLabel;
    LCountryWk: TLabel;
    LCP: TLabel;
    LCPWk: TLabel;
    LDateModif: TLabel;
    LEmailWk: TLabel;
    LLatitudeWk: TLabel;
    LLongitude: TLabel;
    LDateCre: TLabel;
    LLatitude: TLabel;
    LLongitudeWk: TLabel;
    LMobileWk: TLabel;
    LFonction: TLabel;
    LPhoneWk: TLabel;
    LStreetWk: TLabel;
    LCompany: TLabel;
    LWeb: TLabel;
    LMobile: TLabel;
    LName: TLabel;
    LEmail: TLabel;
    LPhone: TLabel;
    LStreet: TLabel;
    LSurname: TLabel;
    LWebWk: TLabel;
    MnuVisitweb: TMenuItem;
    MnuDelete: TMenuItem;
    MnuSendmail: TMenuItem;
    MenuItem4: TMenuItem;
    MnuCopy: TMenuItem;
    MnuLocate: TMenuItem;
    MnuCoord: TMenuItem;
    OPictDialog: TOpenPictureDialog;
    PMnuChooseImg: TMenuItem;
    PMnuChangeImg: TMenuItem;
    PMnuDeleteImg: TMenuItem;
    PCtrl1: TPageControl;
    PnlImage: TPanel;
    PnlWork: TPanel;
    PnlPerso: TPanel;
    PnlInfos: TPanel;
    PMnuImg: TPopupMenu;
    PMnuList: TPopupMenu;
    PPerso: TPanel;
    PWork: TPanel;
    PListBox: TPanel;
    PnlButtons: TPanel;
    PnlOrder: TPanel;
    RBLatit: TRadioButton;
    RBNameSurname: TRadioButton;
    RBPostcode: TRadioButton;
    RBSurnameName: TRadioButton;
    RBTown: TRadioButton;
    RBNone: TRadioButton;
    RBCountry: TRadioButton;
    RBlongit: TRadioButton;
    BtnImport: TSpeedButton;
    BtnFirst: TSpeedButton;
    BtnEmail: TSpeedButton;
    TSPerso: TTabSheet;
    TSWork: TTabSheet;
    UniqueInstance1: TUniqueInstance;
    procedure BtnAboutClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnEmailClick(Sender: TObject);
    procedure BtnImportClick(Sender: TObject);
    procedure BtnLocateClick(Sender: TObject);
    procedure BtnNavClick(Sender: TObject);
    procedure BtnPrefsClick(Sender: TObject);
    procedure BtnQuitClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure BtnValidClick(Sender: TObject);
    procedure BtnWebClick(Sender: TObject);
    procedure EContactChange(Sender: TObject);
    procedure ESearchChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LBContactsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure LBContactsSelectionChange(Sender: TObject; User: boolean);
    procedure MnuCopyClick(Sender: TObject);
    procedure PMnuChooseImgClick(Sender: TObject);
    procedure PMnuDeleteImgClick(Sender: TObject);
    procedure PMnuListPopup(Sender: TObject);
    procedure PPersoClick(Sender: TObject);
    procedure PWorkClick(Sender: TObject);
    procedure RBSortClick(Sender: TObject);
  private
    First: boolean;
    OS, OSTarget, CRLF: string;
    CompileDateTime: TDateTime;
    UserPath, UserAppsDataPath: string;
    ProgName: string;
    ConfigFile: string;
    SortType: TChampsCompare;
    CurIndex: integer;
    CurContChanged: boolean;
    ButtonStates: array [0..14] of boolean;
    NewContact: boolean;
    version: string;
    BaseUpdateUrl, ChkVerURL: string;
    UpdateAvailable, UpdateAlertBox: string;

    NoLongerChkUpdates, LastUpdateSearch: string;
    NoChkNewVer: boolean;
    LieuditCaption, BPCaption: string;
    CPCaption, TownCaption: string;
    CommentCaption, ImageFileCaption: string;
    LieuditWkCaption, BPWkCaption: string;
    CPWkCaption, TownWkCaption: string;
    settings: TConfig;
    LangStr: string;
    SettingsChanged: boolean;
    ContactsChanged: boolean;
    LangFile: TBbIniFile;
    LangNums: TStringList;
    LangFound: boolean;
    OsInfo: TOSInfo;
    Newsearch: boolean;
    previndex: integer;
    MnuRetrieveGPSCaption: string;
    MnuLocateCaption: string;
    MnuCopyCaption: string;
    MnuDeleteCaption: string;
    MnuSendmailCaption: string;
    MnuVisitwebCaption: string;
    MouseIndex: integer;
    ContactNotFound, ContactNoOtherFound: string;
    CntImportd, CntExportd, CntImportds, CntExportds: string;
    ConfirmDeleteContact: string;
    MailSubject: string;
    ImgContactHintEmpty, ImgContactHintFull: string;
    canCloseMsg: string;
    YesBtn, NoBtn, CancelBtn: string;
    Use64bitcaption: string;

    HttpErrMsgNames: array [0..16] of string;
    procedure LoadCfgFile(filename: string);
    procedure DisplayList;
    procedure DisplayContact;
    procedure SetContactChange(val: boolean);
    procedure SaveButtonStates;
    procedure RestoreButtonStates;
    procedure DisableButtons;
    function SaveConfig(Typ: TSaveMode): boolean;
    procedure SettingsOnChange(Sender: TObject);
    procedure SettingsOnStateChange(Sender: TObject);
    procedure ContactsOnChange(Sender: TObject);
    procedure ModLangue;
    procedure SetEditState(val: boolean);
    function ShowAlert(Title, AlertStr, StReplace, NoShow: string;
      var Alert: boolean): boolean;
    procedure EnableLocBtns;
  public
    FImpex_ImportBtn_Caption: string;
    FImpex_ExportBtn_Caption: string;
    csvheader: string;
    ListeContacts: TContactsList;
    ContactMgrAppsData: string;
  end;

var
  FContactManager: TFContactManager;

implementation

{$R *.lfm}



{ TFContactManager }

procedure TFContactManager.FormCreate(Sender: TObject);
var
  s: string;
begin
  First := True;
  // Compilation date/time
  try
    CompileDateTime := Str2Date(
{$I %DATE%}
      , 'YYYY/MM/DD') + StrToTime(
{$I %TIME%}
      );
  except
    CompileDateTime := now();
  end;
  OS := 'Unk';
  UserPath := GetUserDir;
  UserAppsDataPath := UserPath;
  {$IFDEF Linux}
  OS := 'Linux';
  CRLF := #10;
  LangStr := GetEnvironmentVariable('LANG');
  x := pos('.', LangStr);
  LangStr := Copy(LangStr, 0, 2);
  wxbitsrun := 0;
  {$ENDIF}
  {$IFDEF WINDOWS}
  OS := 'Windows ';
  CRLF := #13#10;
  // get user data folder
  s := ExtractFilePath(ExcludeTrailingPathDelimiter(GetAppConfigDir(False)));
  if Ord(WindowsVersion) < 7 then
    UserAppsDataPath := s                     // NT to XP
  else
    UserAppsDataPath := ExtractFilePath(ExcludeTrailingPathDelimiter(s)) + 'Roaming';
  // Vista to W10
  LazGetShortLanguageID(LangStr);
  {$ENDIF}
  GetSysInfo(OsInfo);
  ProgName := 'ContactMgr';
  // Chargement des chaînes de langue...
  LangFile := TBbIniFile.Create(ExtractFilePath(Application.ExeName) + 'contactmgr.lng');
  LangNums := TStringList.Create;
  ContactMgrAppsData := UserAppsDataPath + PathDelim + ProgName + PathDelim;
  if not DirectoryExists(ContactMgrAppsData) then
    CreateDir(ContactMgrAppsData);
  if not DirectoryExists(ContactMgrAppsData + PathDelim + 'images') then
    CreateDir(ContactMgrAppsData + PathDelim + 'images');
  settings := TConfig.Create(ProgName);
  settings.OnChange := @SettingsOnChange;
  settings.OnStateChange := @SettingsOnStateChange;
  ListeContacts := TContactsList.Create(ProgName);
  ListeContacts.OnChange := @ContactsOnChange;
  LImageFile.Caption := '';
  CropBitmap(BtnCoord.Glyph, MnuCoord.Bitmap, BtnCoord.Enabled);
  CropBitmap(BtnLocate.Glyph, MnuLocate.Bitmap, BtnLocate.Enabled);
  CropBitmap(BtnDelete.Glyph, MnuDelete.Bitmap, BtnDelete.Enabled);
end;

procedure TFContactManager.FormDestroy(Sender: TObject);
begin
  FreeAndNil(settings);
  FreeAndNil(ListeContacts);
  FreeAndNil(LangFile);
  FreeAndNil(LangNums);
end;

// Display infos on contact under the mouse cursor in a hint

procedure TFContactManager.LBContactsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: integer);
var
  s, s1: string;
begin
  if LBContacts.Count = 0 then
    exit;
  MouseIndex := LBContacts.ItemAtPos(Point(X, Y), False);
  if (MouseIndex >= 0) and (previndex <> MouseIndex) then
  begin
    s := '';
    s1 := '';
    s := ListeContacts.GetItem(MouseIndex).Surname;
    if length(s) > 0 then
      s := s + ' ';
    s := s + ListeContacts.GetItem(MouseIndex).Name;
    if length(s) = 1 then
      s := 'Contact ' + IntToStr(MouseIndex);       // only the space
    s1 := ListeContacts.GetItem(MouseIndex).Street;
    if length(s1) > 0 then
      s := s + #10 + s1;
    s1 := ListeContacts.GetItem(MouseIndex).BP;
    if length(s1) > 0 then
      s1 := s1 + ' ';
    s1 := s1 + ListeContacts.GetItem(MouseIndex).Lieudit;
    if length(s1) > 1 then
      s := s + #10 + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Postcode;
    if length(s1) > 0 then
      s1 := s1 + ' ';
    s1 := s1 + ListeContacts.GetItem(MouseIndex).Town;
    if length(s1) > 1 then
      s := s + #10 + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Phone;
    if length(s1) > 0 then
      s := s + #10 + LPhone.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Box;
    if length(s1) > 0 then
      s := s + #10 + LBox.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Mobile;
    if length(s1) > 0 then
      s := s + #10 + LMobile.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Autre;
    if length(s1) > 0 then
      s := s + #10 + LAutre.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Email;
    if length(s1) > 0 then
      s := s + #10 + LEmail.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Web;
    if length(s1) > 0 then
      s := s + #10 + LWeb.Caption + ': ' + s1;
    LBContacts.Hint := s;
    Application.ActivateHint(Mouse.CursorPos);
    previndex := MouseIndex;
  end;
end;



procedure TFContactManager.FormActivate(Sender: TObject);
var
  i: integer;
  CurVer, NewVer: int64;
  s: string;
  errmsg: string;
begin
  inherited;
  if not First then
    exit;
  {$IFDEF WIN32}
  OSTarget := '32 bits';
  {$ENDIF}
  {$IFDEF WIN64}
  OSTarget := '64 bits';
  {$ENDIF}
  ConfigFile := ContactMgrAppsData + ProgName + '.xml';

  if not FileExists(ConfigFile) then
  begin
    if FileExists(ContactMgrAppsData + ProgName + '.bk0') then
    begin
      RenameFile(ContactMgrAppsData + ProgName + '.bk0', ConfigFile);
      for i := 1 to 5 do
        if FileExists(ContactMgrAppsData + ProgName + '.bk' + IntToStr(i))
        // Renomme les précédentes si elles existent
        then
          RenameFile(ContactMgrAppsData + ProgName + '.bk' + IntToStr(i),
            ContactMgrAppsData + ProgName + '.bk' + IntToStr(i - 1));
    end
    else
    begin
      // Create a fake contact to avoid errors
      //Contact:= Default(TContact);
      //Contact.Name:= 'Bidon';
      //ListeContacts.AddContact(Contact);
      SaveConfig(All);
    end;
  end;
  BaseUpdateUrl :=
    'https://www.sdtp.com/versions/version.php?program=contactmgr&version=%s&language=%s';
  ChkVerURL := 'https://www.sdtp.com/versions/versions.csv';
  version := GetVersionInfo.ProductVersion;
  LoadCfgFile(ConfigFile);

  //Aboutbox.Caption:= 'A propos du Gestionnaire de contacts';            // in ModLangue
  AboutBox.Image1.Picture.Icon.LoadFromResourceName(HInstance, 'MAINICON');
  AboutBox.LProductName.Caption := GetVersionInfo.FileDescription;
  AboutBox.LCopyright.Caption :=
    GetVersionInfo.CompanyName + ' - ' + DateTimeToStr(CompileDateTime);
  AboutBox.LVersion.Caption := 'Version: ' + Version + ' (' + OS + OSTarget + ')';
  //AboutBox.UrlUpdate:= BaseUpdateURl+Version+'&language='+Settings.LangStr;    // In Modlang
  // AboutBox.LUpdate.Caption:= 'Recherche de mise à jour';      // in Modlangue
  AboutBox.LUpdate.Hint := LastUpdateSearch + ': ' + DateToStr(Settings.LastUpdChk);
  AboutBox.UrlWebsite := GetVersionInfo.Comments;
  FPrefs.LStatus.Caption := OsInfo.VerDetail;
  ;
  CurIndex := 0;
  if ListeContacts.Count > 0 then
    DisplayList
  else
  begin
    // Disable non pertinent controls when list is blank
    BtnFirst.Enabled := False;
    BtnPrev.Enabled := False;
    BtnNext.Enabled := False;
    BtnLast.Enabled := False;
    BtnDelete.Enabled := False;
    BtnCoord.Enabled := False;
    BtnLocate.Enabled := False;
    ESearch.Enabled := False;
    BtnSearch.Enabled := False;
    BtnEmail.Enabled := False;
    BtnWeb.Enabled := False;
    BtnEmailWk.Enabled := False;
    BtnWebWk.Enabled := False;
    PMnuChooseImg.Visible:= False;
    PMnuChangeImg.Visible:= False;
    PMnuDeleteImg.Visible:= False;
    // Disable all edit
    for i := 0 to PnlPerso.ControlCount - 1 do
    if (PnlPerso.Controls[i] is TEdit) then PnlPerso.Controls[i].Enabled:= false;
    for i := 0 to PnlWork.ControlCount - 1 do
    if (PnlWork.Controls[i] is TEdit) then Pnlwork.Controls[i].Enabled:= false;

  end;
  case ListeContacts.SortType of
    cdcName: RBNameSurname.Checked := True;
    cdcSurname: RBSurnameName.Checked := True;
    cdcPostcode: RBPostCode.Checked := True;
    cdcTown: RBTown.Checked := True;
    cdcCountry: RBCountry.Checked := True;
    cdcLongit: RBLongit.Checked := True;
    cdcLatit: RBLatit.Checked := True;
  end;

  // Positionne les faux onglets et positionne sur l'onglet personnel
  PPerso.Left := 2;
  PWork.left := PPerso.Width + PPerso.Left;
  PPersoClick(Sender);
  NewContact := False;
  ContactsChanged := False;

  Application.Title := Caption;
  if (OSINfo.Architecture = 'x86_64') and (OsTarget = '32 bits') then
  begin
    ShowMessage(use64bitcaption);
  end;
  Application.ProcessMessages;
  //Dernière recherche il y a plus de 7 jours ?
  errmsg := '';
  if (Trunc(Now) > Settings.LastUpdChk + 7) and (not Settings.NoChkNewVer) then
  begin
    Settings.LastUpdChk := Trunc(Now);
    s := GetLastVersion(ChkVerURL, 'contactmgr', errmsg);
    if length(s) = 0 then
    begin
      ShowMessage(TranslateHttpErrorMsg(errmsg, HttpErrMsgNames));
      exit;
    end;
    NewVer := VersionToInt(s);
    // Cannot get new version
    if NewVer < 0 then
      exit;
    CurVer := VersionToInt(version);
    if NewVer > CurVer then
    begin
      AboutBox.LUpdate.Caption := Format(UpdateAvailable, [s]);
      if ShowAlert(Caption, UpdateAlertBox, s, NoLongerChkUpdates, NoChkNewVer) then
      begin
        OpenURL(Format(BaseUpdateURl, [version, Settings.LangStr]));
        Settings.NoChkNewVer := AlertBox.CBNoShowAlert.Checked;
      end;
    end;
  end;
end;


// Window Change of position

procedure TFContactManager.FormChangeBounds(Sender: TObject);
begin
  SettingsOnStateChange(Sender);
end;

// Close application

procedure TFContactManager.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  // Don't close if changes pending
  CloseAction := caFree;
  if not BtnQuit.Enabled then
  begin
    case MsgDlg(Caption, Format(canCloseMsg, [#10, #10, #10]), mtWarning,
        [mbYes, mbNo, mbCancel], [YesBtn,
        NoBtn, CancelBtn]) of
      mrYes: BtnValidClick(Sender);
      mrNo: BtnCancelClick(Sender);
      else
        CloseAction := caNone;
    end;
  end;
  if Settings.StartWin then
    SetAutostart(progname, Application.exename)
  else
    UnSetAutostart(progname);
  if (SettingsChanged or ContactsChanged) then
    SaveConfig(All);
end;

// Display alertbox for new version available

function TFContactManager.ShowAlert(Title, AlertStr, StReplace, NoShow: string;
  var Alert: boolean): boolean;
begin
  Result := False;
  with AlertBox do
  begin
    Caption := Title;
    Image1.Picture.Icon.LoadFromResourceName(HInstance, 'MAINICON');
    MAlert.Text := Format(UpdateAlertBox, [version + #10, streplace]);
    CBNoShowAlert.Caption := NoShow;
    CBNoShowAlert.Checked := Alert;
    if not Alert then
      if ShowModal = mrOk then
      begin
        Result := True;
        Alert := CBNoShowAlert.Checked;
      end;
  end;
end;

// Load configuration and database from file

procedure TFContactManager.LoadCfgFile(filename: string);
var
  CfgXML: TXMLDocument;
  RootNode, SettingsNode: TDOMNode;
  winstate: TWindowState;
  i: integer;
begin
  ReadXMLFile(CfgXml, filename);
  RootNode := CfgXML.DocumentElement;
  SettingsNode := RootNode.FindNode('settings');
  settings.LoadXMLNode(SettingsNode);
  if assigned(CfgXML) then
    CfgXML.Free;
  if Settings.SavSizePos then
    try
      WinState := TWindowState(StrToInt('$' + Copy(Settings.WState, 1, 4)));
      if Winstate = wsMinimized then
        Application.Minimize
      else
        WindowState := WinState;
      Top := StrToInt('$' + Copy(Settings.WState, 5, 4));
      Left := StrToInt('$' + Copy(Settings.WState, 9, 4));
      Height := StrToInt('$' + Copy(Settings.WState, 13, 4));
      Width := StrToInt('$' + Copy(Settings.WState, 17, 4));
    except
    end;
  if Settings.StartWin and settings.StartMini then
    Application.Minimize;
  ;
  // Détermination de la langue (si pas dans settings, langue par défaut)
  if Settings.LangStr = '' then
    Settings.LangStr := LangStr;
  LangFile.ReadSections(LangNums);
  if LangNums.Count > 1 then
    for i := 0 to LangNums.Count - 1 do
    begin
      FPrefs.CBLangue.Items.Add(LangFile.ReadString(LangNums.Strings[i], 'Language',
        'Aucune'));
      if LangNums.Strings[i] = Settings.LangStr then
        LangFound := True;
    end;
  // Si la langue n'est pas traduite, alors on passe en Anglais
  if not LangFound then
  begin
    Settings.LangStr := 'en';
  end;
  Modlangue;
  SettingsChanged := False;
  ListeContacts.Reset;
  ListeContacts.LoadXMLfile(filename);
end;

// Save configuration and database to file

function TFContactManager.SaveConfig(typ: TSaveMode): boolean;
var
  CfgXML: TXMLDocument;
  RootNode, ContactsNode, SettingsNode: TDOMNode;
  FilNamWoExt: string;
  i: integer;
begin
  Result := False;
  if FileExists(ConfigFile) then
  begin
    ReadXMLFile(CfgXml, ConfigFile);
    RootNode := CfgXML.DocumentElement;
  end
  else
  begin
    CfgXML := TXMLDocument.Create;
    RootNode := CfgXML.CreateElement('config');
    CfgXML.Appendchild(RootNode);
  end;
  if (Typ = All) then
  begin
    ContactsNode := RootNode.FindNode('contacts');
    if ContactsNode <> nil then
      RootNode.RemoveChild(ContactsNode);
    ContactsNode := CfgXML.CreateElement('contacts');
    ListeContacts.SaveToXMLnode(ContactsNode);
    RootNode.Appendchild(ContactsNode);
  end;
  if (Typ = Setting) or (Typ = All) then
  begin
    SettingsNode := RootNode.FindNode('settings');
    if SettingsNode <> nil then
      RootNode.RemoveChild(SettingsNode);
    SettingsNode := CfgXML.CreateElement('settings');
    Settings.DataFolder := ContactMgrAppsData;
    Settings.WState := '';
    if Top < 0 then
      Top := 0;
    if Left < 0 then
      Left := 0;
    Settings.WState := IntToHex(Ord(WindowState), 4) + IntToHex(Top,
      4) + IntToHex(Left, 4) + IntToHex(Height, 4) + IntToHex(Width, 4);
    Settings.SaveXMLnode(SettingsNode);
    RootNode.Appendchild(SettingsNode);
    // On sauvegarde les versions précédentes
    FilNamWoExt := TrimFileExt(ConfigFile);
    if FileExists(FilNamWoExt + '.bk5')                   // Efface la plus ancienne
    then
      DeleteFile(FilNamWoExt + '.bk5');                // si elle existe
    for i := 4 downto 0 do
      if FileExists(FilNamWoExt + '.bk' + IntToStr(i))
      // Renomme les précédentes si elles existent
      then
        RenameFile(FilNamWoExt + '.bk' + IntToStr(i), FilNamWoExt + '.bk' + IntToStr(i + 1));
    if FileExists(ConfigFile) then
      RenameFile(ConfigFile, FilNamWoExt + '.bk0');
    // Et on sauvegarde la nouvelle config
    writeXMLFile(CfgXML, ConfigFile);
    Result := True;
  end;
end;

// Selection in list box has changed

procedure TFContactManager.LBContactsSelectionChange(Sender: TObject; User: boolean);
begin
  if LBContacts.Count = 0 then exit;
  CurIndex := ListeContacts.GetItem(LBContacts.ItemIndex).Index1;
  BtnFirst.Enabled := boolean(LBContacts.ItemIndex);
  BtnPrev.Enabled := BtnFirst.Enabled;
  BtnLast.Enabled := boolean(LBContacts.Count - 1 - LBContacts.ItemIndex);
  BtnNext.Enabled := BtnLast.Enabled;
  //If postcode and town is blank, no search possible
  EnableLocBtns;
  DisplayContact;
end;


// Copy main data from the selected contact in the clipboard

procedure TFContactManager.MnuCopyClick(Sender: TObject);
begin
  Clipboard.AsText := LBContacts.Hint;
end;



// Choose a contact image (popup menu on image, must be valdated)

procedure TFContactManager.PMnuChooseImgClick(Sender: TObject);
var
  filename: string;
  Image1: TImage;
  rInt: longint;
  nimgfile: string;
begin

  if OPictDialog.Execute then
  begin
    filename := OPictDialog.FileName;
    Image1 := TImage.Create(self);
    Image1.Picture.LoadFromFile(filename);
    ImageFitToSize(Image1, ImgContact.Width, ImgContact.Height);
    Randomize;
    rInt := random(10000);
    //nimgfile := ContactMgrAppsData + 'images' + PathDelim + LowerCase(
    //  ListeContacts.GetItem(LBContacts.ItemIndex).Name + Format('%d', [rInt]) + '.jpg');
    nimgfile := ContactMgrAppsData + 'images' + PathDelim + LowerCase(
          EName.Text+ Format('%d', [rInt]) + '.jpg');
    Image1.Picture.SaveToFile(nimgfile);
    ImgContact.Picture.Assign(Image1.Picture.Bitmap);
    LIMageFile.Caption := nimgfile;
    Image1.Free;
  end;
end;

// Delete current contact image (popup menu on image, must be valdated)

procedure TFContactManager.PMnuDeleteImgClick(Sender: TObject);
begin
  LImageFile.Caption := '';
  ImgContact.Picture.Assign(nil);
end;




// Popup menu for listbox items

procedure TFContactManager.PMnuListPopup(Sender: TObject);
var
  s, cname: string;
  i: integer;
begin
  LBContacts.ItemIndex := MouseIndex;
  i := LBContacts.ItemIndex;
  s := ListeContacts.GetItem(i).Surname;
  if length(s) > 0 then
    s := s + ' ';
  cname := ListeContacts.GetItem(i).Name;
  if length(cname) > 0 then
    s := s + cname;
  if length(s) = 0 then
    s := 'Contact ' + IntToStr(i);
  MnuCoord.Caption := Format(MnuRetrieveGPSCaption, [s]);
  MnuLocate.Caption := Format(MnuLocateCaption, [s]);
  MnuCopy.Caption := Format(MnuCopyCaption, [s]);
  MnuDelete.Caption := Format(MnuDeleteCaption, [s]);
  MnuSendmail.Caption := Format(MnuSendmailCaption, [s]);
  MnuVisitweb.Caption := Format(MnuVisitwebCaption, [s]);
  MnuSendmail.Enabled := not (length(ListeContacts.GetItem(i).Email) = 0);
  MnuVisitweb.Enabled := not (length(ListeContacts.GetItem(i).Web) = 0);
  CropBitmap(BtnEmail.Glyph, MnuSendMail.Bitmap, BtnEmail.Enabled);
  CropBitmap(BtnWeb.Glyph, MnuVisitweb.Bitmap, BtnWeb.Enabled);
end;


// Display the list of contacts in left listbox

procedure TFContactManager.DisplayList;
var
  i: integer;
  MyContact: TContact;
  s: string;
  ndx: integer;
begin
  ndx := 0;
  LBContacts.Clear;
  if ListeContacts.Count > 0 then
  begin
    for i := 0 to ListeContacts.Count - 1 do
    begin
      MyContact := ListeContacts.GetItem(i);
      with MyContact do
      begin
        if length(surname) > 0 then
        begin
          if length(Name) > 0 then
            s := surname + ' ' + Name
          else
            s := surname;
        end
        else
          s := Name;
        if index1 = curindex then
          ndx := i;        // Repositionner après tri
      end;
      LBContacts.Items.Add(s);
    end;
    LBContacts.ItemIndex := ndx;
    curindex := ListeContacts.GetItem(ndx).Index1;

  end;
  DisplayContact;
end;

// Display infos on selected contact in right panel edit boxes
// Edit fields can exacxty match 'E'+contact field name (case insensitive)

procedure TFContactManager.DisplayContact;
var
  n: integer;
  DecSep: char;
  i, j: integer;
  MyEdit: TEdit;
begin
  SetContactChange(False);
  n := LBContacts.ItemIndex;
  if (n > LBContacts.Count - 1) then exit;
  DecSep := DefaultFormatSettings.DecimalSeparator;
  DefaultFormatSettings.DecimalSeparator := '.';
  for i := 0 to length(AFieldNames) - 1 do
  begin
    MyEdit := TEdit(FindComponent('E' + AFieldNames[i]));
    if ListeContacts.count>0 then
    begin
      if Assigned(MyEdit) then
          MyEdit.Text := ListeContacts.GetItemFieldString(n, AFieldNames[i]);
    end else
    begin
      if Assigned(MyEdit) then
          MyEdit.Text := '';
      // disable related controls
      for j := 0 to PnlPerso.ControlCount - 1 do
      if (PnlPerso.Controls[j] is TEdit) then PnlPerso.Controls[j].Enabled:= false;
      for j := 0 to PnlWork.ControlCount - 1 do
      if (PnlWork.Controls[j] is TEdit) then Pnlwork.Controls[j].Enabled:= false;
      PMnuChooseImg.Visible:= false;
      BtnDelete. Enabled:= false;
    end;
  end;
  BtnEmail.Enabled := boolean(length(EEMail.Text));
  // pas de bouton Email si pas d'email !
  BtnWeb.Enabled := boolean(length(EWeb.Text));
  try
    LIMageFile.Caption := ListeContacts.GetItem(n).Imagepath;
    ImgContact.Picture.LoadFromFile(ListeContacts.GetItem(n).Imagepath);
    PMnuChooseImg.Visible := False;
    PMnuChangeImg.Visible := True;
    PMnuDeleteImg.Visible := True;
    ImgContact.Hint := Format(ImgContactHintFull,
      [#10, ListeContacts.GetItem(n).Imagepath]);
  except
    ImgContact.Picture := nil;
    PMnuChooseImg.Visible := True;
    PMnuChangeImg.Visible := False;
    PMnuDeleteImg.Visible := False;
    ImgContact.Hint := ImgContactHintEmpty;
  end;
  BtnWebWk.Enabled := boolean(length(EWebWk.Text));
  DefaultFormatSettings.DecimalSeparator := decSep;
  SetContactChange(True);
end;

// Click on quit button

procedure TFContactManager.BtnQuitClick(Sender: TObject);
begin
  //SetAutostart (ProgName, Application.ExeName);
  UnsetAutostart(ProgName);
  Close;
end;

// Click on search button

procedure TFContactManager.BtnSearchClick(Sender: TObject);
var
  i, ns: integer;
  fnd: boolean;
  s: string;
begin
  if newsearch then
    ns := 0
  else
    ns := LBContacts.ItemIndex + 1;
  if (ns > LBContacts.Count - 1) or (Length(ESearch.Text) = 0) then
    exit;
  for i := ns to LBContacts.Count - 1 do
  begin
    fnd := False;
    if rbNone.Checked or RBNameSurname.Checked or RBSurnameName.Checked then
      s := UpperCase(ListeContacts.GetItem(i).Name + ListeContacts.GetItem(i).Surname);
    if RBPostcode.Checked or RBTown.Checked then
      s := UpperCase(ListeContacts.GetItem(i).PostCode + ListeContacts.GetItem(i).Town);
    if RBCountry.Checked then
      s := UpperCase(ListeContacts.GetItem(i).Country);
    if RBlongit.Checked then
      s := UpperCase(FloatToStr(ListeContacts.GetItem(i).Longitude));
    if RBLatit.Checked then
      s := UpperCase(FloatToStr(ListeContacts.GetItem(i).Latitude));
    if pos(UpperCase(Esearch.Text), s) > 0 then
    begin
      LBContacts.ItemIndex := i;
      newsearch := False;
      fnd := True;
      break;
    end;
  end;
  if newsearch then
    MsgDlg(Caption, ESearch.Text + ': ' + ContactNotFound, mtInformation, [mbOK], ['OK'])
  else if (ns > 0) and (not (fnd)) then
    MsgDlg(Caption, ESearch.Text + ': ' + ContactNoOtherFound, mtInformation, [mbOK], ['OK']);
end;

// Click on valid button. All changes done on the current contact are saved

procedure TFContactManager.BtnValidClick(Sender: TObject);
var
  tmpContact: TContact;
  oldind: integer;
begin
  oldind := LBContacts.ItemIndex;
  with tmpContact do
  begin
    tmpContact:= Default(TContact);
    Name := EName.Text;
    Surname := ESurname.Text;
    Street := EStreet.Text;
    BP := EBP.Text;
    Lieudit := ELieudit.Text;
    Postcode := EPostcode.Text;
    Town := ETown.Text;
    Country := ECountry.Text;
    Phone := EPhone.Text;
    Box := EBox.Text;
    Mobile := EMobile.Text;
    Autre := EAutre.Text;
    Email := EEmail.Text;
    Web := EWeb.Text;
    Longitude := StringToFloat(ELongitude.Text);
    Latitude := StringToFloat(ELatitude.Text);
    Date := StringToDateTime(EDate.Text);
    DateModif := now();
    //image
    fonction := EFonction.Text;
    Company := ECompany.Text;
    Service := EService.Text;
    StreetWk := EStreetWk.Text;
    BPWk := EBPWk.Text;
    LieuditWk := ELieuditWk.Text;
    PostcodeWk := EPostcodeWk.Text;
    TownWk := ETownWk.Text;
    CountryWk := ECountryWk.Text;
    PhoneWk := EPhoneWk.Text;
    BoxWk := EBoxWK.Text;
    MobileWk := EMobileWk.Text;
    AutreWk := EAutreWk.Text;
    EmailWk := EEmailWk.Text;
    WebWk := EWebWK.Text;
    LongitudeWk := StringToFloat(ELongitudeWk.Text);
    LatitudeWk := StringToFloat(ELatitudeWk.Text);
    if ListeContacts.count> 0 then
    begin
      Index1 := ListeContacts.GetItem(LBContacts.ItemIndex).Index1;
      Comment := ListeContacts.GetItem(LBContacts.ItemIndex).Comment;
      if LIMageFile.Caption <> ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath then
      begin
        if FileExists(ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath) then
           deletefile(ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath);
      end;

    end;
    Imagepath := LIMageFile.Caption;
  end;
  if NewContact then
  begin
    RestoreButtonStates;
    ListeContacts.AddContact(tmpContact);
  end else ListeContacts.ModifyContact(LBContacts.ItemIndex, tmpContact);
  Esearch.Enabled := True;
  RBSortClick(Sender);
  DisplayList;
  SetEditState(False);
  if oldInd < 0 then
  begin
    oldind:= 0;
    BtnDelete.Enabled:= true;
  end;
  LBContacts.ItemIndex := Oldind;


end;

// Click on web button : open contact wen site in user browser

procedure TFContactManager.BtnWebClick(Sender: TObject);
begin
  OpenURL(ListeContacts.GetItem(LBContacts.ItemIndex).Web);
end;

// Enable events fired when a contact edit field change

procedure TFContactManager.SetContactChange(val: boolean);
var
  i: integer;
begin
  for i := 0 to PnlPerso.ControlCount - 1 do
    if (PnlPerso.Controls[i] is TEdit) then
      if val then
      begin
        TEdit(PnlPerso.Controls[i]).OnChange := @EContactChange;
      end
      else
      begin
        TEdit(PnlPerso.Controls[i]).OnChange := nil;
        TEdit(PnlPerso.Controls[i]).Color := clDefault;
      end;
  for i := 0 to PnlWork.ControlCount - 1 do
    if (PnlWork.Controls[i] is TEdit) then
      if val then
      begin
        TEdit(PnlWork.Controls[i]).OnChange := @EContactChange;
      end
      else
      begin
        TEdit(PnlWork.Controls[i]).OnChange := nil;
        TEdit(PnlWork.Controls[i]).Color := clDefault;
      end;
  if val then
    ImgContact.OnPictureChanged := @EContactChange
  else
    ImgContact.OnPictureChanged := nil;
end;

//Save buttons states in an array

procedure TFContactManager.SaveButtonStates;
var
  i: integer;
  j: integer;
begin
  if CurContChanged then
    exit;
  j := 0;
  for i := 0 to PnlButtons.ControlCount - 1 do
    if (PnlButtons.Controls[i] is TSpeedButton) then
    begin
      ButtonStates[j] := PnlButtons.Controls[i].Enabled;
      Inc(j);
    end;
  CurContChanged := True;
end;

// Restore buttons state (recorded in an array before disable)

procedure TFContactManager.RestoreButtonStates;
var
  i: integer;
  j: integer;
begin
  j := 0;
  for i := 0 to PnlButtons.ControlCount - 1 do
    if (PnlButtons.Controls[i] is TSpeedButton) then
    begin
      PnlButtons.Controls[i].Enabled := ButtonStates[j];
      Inc(j);
    end;
  CurContChanged := False;
end;

// Disable all buttons during edit

procedure TFContactManager.DisableButtons;
var
  i: integer;
begin
  for i := 0 to PnlButtons.ControlCount - 1 do
    if (PnlButtons.Controls[i] is TSpeedButton) then
    begin
      PnlButtons.Controls[i].Enabled := False;
    end;
end;

// Fired when right panel edit fields change

procedure TFContactManager.EContactChange(Sender: TObject);
begin
  SaveButtonStates;
  DisableButtons;
  Esearch.Enabled := False;
  BtnValid.Enabled := True;
  BtnCancel.Enabled := True;
  LBContacts.Enabled := False;
  GBOrder.Enabled := False;
  TEdit(Sender).Color := clGradientActiveCaption;
  NewContact := False;
end;

// Event fired when typing a search

procedure TFContactManager.ESearchChange(Sender: TObject);
begin
  Newsearch := True;
end;


// Click on import/export button
// Launch impex form, then process choice done

procedure TFContactManager.BtnImportClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  FImpex.ImpexContacts := TContactsList.Create('');
  case FImpex.ShowModal of
    // mrOK : Import,
    mrOk:
    begin
      for i := 0 to Fimpex.ImpexContacts.Count - 1 do
      begin
        ListeContacts.AddContact(Fimpex.ImpexContacts.GetItem(i));
      end;
      if Fimpex.ImpexContacts.Count > 1 then
        s := CntImportds
      else
        s := CntImportd;
      MsgDlg(Caption, Format(s, [Fimpex.ImpexContacts.Count, FImpex.CBType.Text]),
        mtInformation, [mbOK], ['OK'], 0);
      ListeContacts.SortType := SortType;
      DisplayList;
    end;
    // mrYes : Export
    mrYes:
    begin
      if Fimpex.ImpexSelcount > 1 then
        s := CntExportds
      else
        s := CntEXportd;
      MsgDlg(Caption, Format(s, [Fimpex.ImpexSelcount, FImpex.CBType.Text]),
        mtInformation, [mbOK], ['OK'], 0);
    end;
  end;
  FImpex.ImpexContacts.Free;
end;


// Geolocalisation function using google maps search
// Coordinates retrieval is experimental and based on google maps
// analysed answer page; no warranty !

procedure TFContactManager.BtnLocateClick(Sender: TObject);
var
  smap, stmp: string;
  HTTPCli1: TFPHTTPClient;
  p: integer;
  sstreet, slieu, spost, stown, scountry: string;
  A: TStringArray;
begin
  smap := 'https://www.google.fr/maps/search/';
  // check if perso or work
  if PCtrl1.ActivePage = TSPerso then
  begin
    sstreet := EStreet.Text;
    slieu := ELieudit.Text;
    spost := EPostcode.Text;
    stown := ETown.Text;
    scountry := ECountry.Text;
  end
  else
  begin
    sstreet := EStreetWk.Text;
    slieu := ELieuditWk.Text;
    spost := EPostcodeWK.Text;
    stown := ETownWk.Text;
    scountry := ECountryWk.Text;
  end;
  if length(sstreet) > 0 then
    smap := smap + sstreet + '+'
  else
  begin
    if length(slieu) > 0 then
      smap := smap + slieu + '+';
  end;
  smap := smap + ',';
  if length(spost) > 0 then
    smap := smap + spost + '+';
  if length(stown) > 0 then
    smap := smap + stown;
  if length(scountry) > 0 then
    smap := smap + ',' + scountry;
  smap := StringReplace(smap, ' ', '+', [rfReplaceAll]);
  // Display location on the map
  if (TSpeedButton(Sender) = BtnLocate) or (TMenuItem(Sender) = MnuLocate) then
    OpenURL(smap);
  // Try to retrieve coordinates
  if (TSpeedButton(Sender) = BtnCoord) or (TMenuItem(Sender) = MnuCoord) then
  begin
    { SSL initialization has to be done by hand here }
    InitSSLInterface;
    HTTPCli1 := TFPHTTPClient.Create(nil);
    HTTPCli1.AllowRedirect := True;
    try
      stmp := HTTPCli1.get(smap);
      p := pos('/@', stmp);
      stmp := copy(stmp, p + 2, 30);
      A := stmp.Split(',');
      if PCtrl1.ActivePage = TSPerso then
      begin
        ELatitude.Text := A[0];
        ELongitude.Text := A[1];
      end
      else
      begin
        ELatitudeWk.Text := A[0];
        ELongitudeWk.Text := A[1];
      end;
    except
      on e: Exception do
        ShowMessage(TranslateHttpErrorMsg(e.message, HttpErrMsgNames));
    end;
    HTTPCli1.Free;
  end;
end;

// Delete the selected contact (only after validation, operation can be cancelled)

procedure TFContactManager.BtnDeleteClick(Sender: TObject);
var
  imgfile: string;
begin
  if MsgDlg(Caption, Format(ConfirmDeleteContact,
    [ListeContacts.GetItem(LBContacts.ItemIndex).Name + ' ' +
    ListeContacts.GetItem(LBContacts.ItemIndex).Surname]), mtWarning,
    mbYesNo, [YesBtn, NoBtn], 0) = mrYes then
  begin
    if (LBContacts.ItemIndex >= 0) and (LBContacts.ItemIndex < LBContacts.Count) then
    begin
      imgfile := ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath;
      if Fileexists(imgfile) then
        DeleteFile(imgfile);
      ListeContacts.Delete(LBContacts.ItemIndex);
    end;
    DisplayList;
  end;
end;

// Send an email via the email client

procedure TFContactManager.BtnEmailClick(Sender: TObject);
begin
  OpenURL('mailto:' + ListeContacts.GetItem(LBContacts.ItemIndex).Email +
    '?subject=' + MailSubject + '&body=' + MailSubject);
end;

// non edit functions are disabled

procedure TFContactManager.SetEditState(val: boolean);
begin
  SetContactChange(val);
  DisplayContact;
  SetContactChange(not val);
  RestoreButtonStates;
  LBContacts.Enabled := not val;
  GBOrder.Enabled := not val;
  Esearch.Enabled := not val;
  NewContact := val;
end;

// Cancel all changes pending on the selected contact

procedure TFContactManager.BtnCancelClick(Sender: TObject);
begin
  // Todo manage blank base situation
  if ListeContacts.count= 0 then
  begin
    if fileexists(LImageFile.Caption) then deletefile(LImageFile.Caption);
    LImageFile.Caption:= '';
  end else
    if LIMageFile.Caption <> ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath then
    begin
      if fileexists(LImageFile.Caption) then deletefile(LImageFile.Caption);
      LIMageFile.Caption := ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath;
    end;
    SetEditState(False);
end;


// Click on add contact button
// Insert a blank record (only after validation)

procedure TFContactManager.BtnAddClick(Sender: TObject);
var
  i: integer;
begin
  if ListeContacts.count= 0 then
  begin
    // Enable all edit, they are disbled if listecontacts is blank
    for i := 0 to PnlPerso.ControlCount - 1 do
    if (PnlPerso.Controls[i] is TEdit) then PnlPerso.Controls[i].Enabled:= true;
    for i := 0 to PnlWork.ControlCount - 1 do
    if (PnlWork.Controls[i] is TEdit) then Pnlwork.Controls[i].Enabled:= true;
    PMnuChooseImg.Visible:= true;
  end;
  SetContactChange(False);
  // prevent unwanted firing of the event during the process
  EName.Text := '';
  ESurname.Text := '';
  EStreet.Text := '';
  EBP.Text := '';
  ELieudit.Text := '';
  EPostcode.Text := '';
  ETown.Text := '';
  ECountry.Text := '';
  EPhone.Text := '';
  EBox.Text := '';
  EMobile.Text := '';
  EAutre.Text := '';
  EEmail.Text := '';
  BtnEmail.Enabled := boolean(length(EEMail.Text));
  // pas de bouton Email si pas d'email !
  EWeb.Text := '';
  BtnWeb.Enabled := boolean(length(EWeb.Text));
  ELongitude.Text := '';
  ELatitude.Text := '';
  EDate.Text := DateTimeToStr(now);
  EDatemodif.Text := DateTimeToStr(now);
  ImgContact.Picture := nil;
  EFonction.Text := '';
  ECompany.Text := '';
  EService.Text := '';
  EStreetWk.Text := '';
  EBPWk.Text := '';
  ELieuditWk.Text := '';
  EPostcodeWk.Text := '';
  ETownWk.Text := '';
  ECountryWk.Text := '';
  EPhoneWk.Text := '';
  EBoxWK.Text := '';
  EMobileWk.Text := '';
  EAutreWk.Text := '';
  EEmailWk.Text := '';
  BtnEmailWk.Enabled := boolean(length(EEmailWk.Text));
  EWebWK.Text := '';
  BtnWebWk.Enabled := boolean(length(EWebWk.Text));
  ELongitudeWk.Text := '';
  ELatitudeWk.Text := '';
  NewContact := True;
  SaveButtonStates;
  DisableButtons;
  BtnValid.Enabled := True;
  BtnCancel.Enabled := True;
  LBContacts.Enabled := False;
  GBOrder.Enabled := False;
  Esearch.Enabled := False;
end;

// Click on the About button
// lanch aboutbox form

procedure TFContactManager.BtnAboutClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

// Click on one of the four navigation buttons

procedure TFContactManager.BtnNavClick(Sender: TObject);
begin
  if (TSpeedButton(Sender) = BtnNext) and (LBContacts.ItemIndex <
    LBContacts.Count - 1) then
    LBContacts.ItemIndex := LBContacts.ItemIndex + 1;
  if (TSpeedButton(Sender) = BtnPrev) and (LBContacts.ItemIndex > 0) then
    LBContacts.ItemIndex := LBContacts.ItemIndex - 1;
  if (TSpeedButton(Sender) = BtnFirst) and (LBContacts.ItemIndex > 0) then
    LBContacts.ItemIndex := 0;
  if (TSpeedButton(Sender) = BtnLast) and (LBContacts.ItemIndex <
    LBContacts.Count - 1) then
    LBContacts.ItemIndex := LBContacts.Count - 1;
end;


// Click on preferences button
// launch preferences form

procedure TFContactManager.BtnPrefsClick(Sender: TObject);
var
  oldndx: integer;
begin
  Fprefs.Edatafolder.Text := ContactMgrAppsData;
  Fprefs.CBStartup.Checked := Settings.StartWin;
  Fprefs.CBSavePos.Checked := Settings.SavSizePos;
  Fprefs.CBMinimized.Checked := Settings.StartMini;
  Fprefs.CBUpdate.Checked := Settings.NoChkNewVer;
  FPrefs.CBLangue.ItemIndex := LangNums.IndexOf(Settings.LangStr);
  oldndx := FPrefs.CBLangue.ItemIndex;
  FPrefs.CBMinimized.Enabled := FPrefs.CBStartup.Checked;
  if FPrefs.ShowModal = mrOk then
  begin
    Settings.StartWin := Fprefs.CBStartup.Checked;
    Settings.SavSizePos := Fprefs.CBSavePos.Checked;
    Settings.StartMini := Fprefs.CBMinimized.Checked;
    Settings.NoChkNewVer := Fprefs.CBUpdate.Checked;
    Settings.LangStr := LangNums.Strings[FPrefs.CBLangue.ItemIndex];
    if FPrefs.CBLangue.ItemIndex <> oldndx then
      ModLangue;
    DisplayContact;                                // Needed to change language on hints
  end;
end;

// Replace lazarus tabs with coloured panels

procedure TFContactManager.PPersoClick(Sender: TObject);
begin
  PCtrl1.ActivePage := TSPerso;
  PWork.Color := clDefault;
  PPerso.color := clGradientActiveCaption;
  EnableLocBtns;
end;

procedure TFContactManager.PWorkClick(Sender: TObject);
begin
  PCtrl1.ActivePage := TSWork;
  PPerso.color := clDefault;
  PWork.color := clGradientActiveCaption;
  EnableLocBtns;
end;

// Disable or enable location and coordinates buttons
// If postcode and town fields are blank, no maps search possible

procedure TFContactManager.EnableLocBtns;
begin
  if LBContacts.ItemIndex < 0 then
    exit;
  if (PCtrl1.ActivePage = TSPerso) then
  begin
    BtnCoord.Enabled := not ((length(ListeContacts.GetItem(
      LBContacts.ItemIndex).Postcode) = 0) and
      (length(ListeContacts.GetItem(LBContacts.ItemIndex).town) = 0));
    BtnLocate.Enabled := BtnCoord.Enabled;
  end
  else
  begin
    BtnCoord.Enabled := not ((length(ListeContacts.GetItem(
      LBContacts.ItemIndex).PostcodeWk) = 0) and
      (length(ListeContacts.GetItem(LBContacts.ItemIndex).TownWk) = 0));
    BtnLocate.Enabled := BtnCoord.Enabled;
  end;
end;

// Change of sort order fired by a click on sort radioboxes

procedure TFContactManager.RBSortClick(Sender: TObject);
begin
  if TRadioButton(Sender) = RBNameSurname then
    ListeContacts.SortType := cdcName;
  if TRadioButton(Sender) = RBSurnameName then
    ListeContacts.SortType := cdcSurname;
  if TRadioButton(Sender) = RBPostcode then
    ListeContacts.SortType := cdcPostcode;
  if TRadioButton(Sender) = RBTown then
    ListeContacts.SortType := cdcTown;
  if TRadioButton(Sender) = RBCountry then
    ListeContacts.SortType := cdcCountry;
  if TRadioButton(Sender) = RBlongit then
    ListeContacts.SortType := cdcLongit;
  if TRadioButton(Sender) = RBlatit then
    ListeContacts.SortType := cdcLatit;
  DisplayList;
end;

// Event fired by any change of settings values

procedure TFContactManager.SettingsOnChange(Sender: TObject);
begin
  SettingsChanged := True;
end;

// Event fired by any state change (window state and position)

procedure TFContactManager.SettingsOnStateChange(Sender: TObject);
begin
  SettingsChanged := True;
end;

// Event fired by any change in contact list

procedure TFContactManager.ContactsOnChange(Sender: TObject);
begin
  ContactsChanged := True;
end;

// To be called in form activation routine of loadconfig routine or when language
// is changed in preferences

procedure TFContactManager.ModLangue;
const
  dquot = '"';     // Double quote
  dquotv = '","';   // Double cote  plus comma plus double quote
begin
  with LangFile do
  begin
    //Main Form
    Caption := ReadString(Settings.LangStr, 'Caption', 'Gestionnaire de Contacts');
    // Components
    YesBtn := ReadString(Settings.LangStr, 'YesBtn', 'Oui');
    NoBtn := ReadString(Settings.LangStr, 'NoBtn', 'Non');
    CancelBtn := ReadString(Settings.LangStr, 'CancelBtn', 'Annuler');
    // AboutBox
    Aboutbox.Caption := ReadString(Settings.LangStr, 'Aboutbox.Caption',
      'A propos du Gestionnaire de Contacts');
    AboutBox.LUpdate.Caption :=
      ReadString(Settings.LangStr, 'AboutBox.LUpdate.Caption', 'Recherche de mise à jour');
    AboutBox.UrlUpdate := Format(BaseUpdateURl, [Version, Settings.LangStr]);
    // Main form
    PPerso.Caption := ReadString(Settings.LangStr, 'PPerso.Caption', PPerso.Caption);
    PWork.Caption := ReadString(Settings.LangStr, 'PWork.Caption', PWork.Caption);
    GBOrder.Caption := ReadString(Settings.LangStr, 'GBOrder.Caption', GBOrder.Caption);
    RBNone.Caption := ReadString(Settings.LangStr, 'RBNone.Caption', RBNone.Caption);
    RBTown.Caption := ReadString(Settings.LangStr, 'RBTown.Caption', RBTown.Caption);
    RBNameSurname.Caption := ReadString(Settings.LangStr, 'RBNameSurname.Caption',
      RBNameSurname.Caption);
    RBCountry.Caption := ReadString(Settings.LangStr, 'RBCountry.Caption',
      RBCountry.Caption);
    RBSurnameName.Caption := ReadString(Settings.LangStr, 'RBSurnameName.Caption',
      RBSurnameName.Caption);
    RBPostcode.Caption := ReadString(Settings.LangStr, 'RBPostcode.Caption',
      RBPostcode.Caption);
    RBlongit.Caption := ReadString(Settings.LangStr, 'RBlongit.Caption',
      RBlongit.Caption);
    RBLatit.Caption := ReadString(Settings.LangStr, 'RBLatit.Caption', RBLatit.Caption);
    BtnImport.Hint := ReadString(Settings.LangStr, 'BtnImport.Hint', BtnImport.Hint);
    BtnFirst.Hint := ReadString(Settings.LangStr, 'BtnFirst.Hint', BtnFirst.Hint);
    BtnPrev.Hint := ReadString(Settings.LangStr, 'BtnPrev.Hint', BtnPrev.Hint);
    BtnNext.Hint := ReadString(Settings.LangStr, 'BtnNext.Hint', BtnNext.Hint);
    BtnLast.Hint := ReadString(Settings.LangStr, 'BtnLast.Hint', BtnLast.Hint);
    BtnDelete.Hint := ReadString(Settings.LangStr, 'BtnDelete.Hint', BtnDelete.Hint);
    BtnAdd.Hint := ReadString(Settings.LangStr, 'BtnAdd.Hint', BtnAdd.Hint);
    BtnValid.Hint := ReadString(Settings.LangStr, 'BtnValid.Hint', BtnValid.Hint);
    BtnCancel.Hint := ReadString(Settings.LangStr, 'BtnCancel.Hint', BtnCancel.Hint);
    BtnCoord.Hint := ReadString(Settings.LangStr, 'BtnCoord.Hint', BtnCoord.Hint);
    BtnLocate.Hint := ReadString(Settings.LangStr, 'BtnLocate.Hint', BtnLocate.Hint);
    BtnPrefs.Hint := ReadString(Settings.LangStr, 'BtnPrefs.Hint', BtnPrefs.Hint);
    BtnAbout.Hint := ReadString(Settings.LangStr, 'BtnAbout.Hint', BtnAbout.Hint);
    BtnQuit.Hint := ReadString(Settings.LangStr, 'BtnQuit.Hint', BtnQuit.Hint);
    BtnSearch.Hint := ReadString(Settings.LangStr, 'BtnSearch.Hint', BtnSearch.Hint);
    LName.Caption := ReadString(Settings.LangStr, 'LName.Caption', LName.Caption);
    LSurname.Caption := ReadString(Settings.LangStr, 'LSurname.Caption',
      LSurname.Caption);
    LStreet.Caption := ReadString(Settings.LangStr, 'LStreet.Caption', LStreet.Caption);
    BPCaption := ReadString(Settings.LangStr, 'BPCaption', 'BP');
    LieuditCaption := ReadString(Settings.LangStr, 'LieuditCaption', 'Lieudit');
    LBP.Caption := BPCaption + ', ' + LieuditCaption;
    CPCaption := ReadString(Settings.LangStr, 'CPCaption', 'CP');
    TownCaption := ReadString(Settings.LangStr, 'TownCaption', 'Ville');
    LCP.Caption := CPCaption + ', ' + TownCaption;
    LCountry.Caption := ReadString(Settings.LangStr, 'LCountry.Caption',
      LCountry.Caption);
    LPhone.Caption := ReadString(Settings.LangStr, 'LPhone.Caption', LPhone.Caption);
    LBox.Caption := ReadString(Settings.LangStr, 'LBox.Caption', LBox.Caption);
    LMobile.Caption := ReadString(Settings.LangStr, 'LMobile.Caption', LMobile.Caption);
    LAutre.Caption := ReadString(Settings.LangStr, 'LAutre.Caption', LAutre.Caption);
    LEmail.Caption := ReadString(Settings.LangStr, 'LEmail.Caption', LEmail.Caption);
    LWeb.Caption := ReadString(Settings.LangStr, 'LWeb.Caption', LWeb.Caption);
    LLongitude.Caption := ReadString(Settings.LangStr, 'LLongitude.Caption',
      LLongitude.Caption);
    LLatitude.Caption := ReadString(Settings.LangStr, 'LLatitude.Caption',
      LLatitude.Caption);
    LDateCre.Caption := ReadString(Settings.LangStr, 'LDateCre.Caption',
      LDateCre.Caption);
    LDatemodif.Caption := ReadString(Settings.LangStr, 'LDatemodif.Caption',
      LDatemodif.Caption);
    CommentCaption := ReadString(Settings.LangStr, 'CommentCaption', 'Commentaire');
    ImageFileCaption := ReadString(Settings.LangStr, 'ImageFileCaption', 'Fichier image');
    LFonction.Caption := ReadString(Settings.LangStr, 'LFonction.Caption',
      LFonction.Caption);
    LCompany.Caption := ReadString(Settings.LangStr, 'LCompany.Caption',
      LCompany.Caption);
    LStreetWk.Caption := ReadString(Settings.LangStr, 'LStreetWk.Caption',
      LStreetWk.Caption);
    BPWkCaption := ReadString(Settings.LangStr, 'BPWkCaption', 'BP Pro');
    LieuditWkCaption := ReadString(Settings.LangStr, 'LieuditWkCaption', 'Lieudit pro');
    LBPWk.Caption := BPWkCaption + ', ' + LieuditWkCaption;
    CPWkCaption := ReadString(Settings.LangStr, 'CPWkCaption', 'CP pro');
    TownWkCaption := ReadString(Settings.LangStr, 'TownWkCaption', 'Ville pro');
    LCPWk.Caption := CPWkCaption + ', ' + TownWkCaption;
    LCountryWk.Caption := ReadString(Settings.LangStr, 'LCountryWk.Caption',
      LCountryWk.Caption);
    LPhoneWk.Caption := ReadString(Settings.LangStr, 'LPhoneWk.Caption',
      LPhoneWk.Caption);
    LBoxWk.Caption := ReadString(Settings.LangStr, 'LBoxWk.Caption', LBoxWk.Caption);
    LMobileWk.Caption := ReadString(Settings.LangStr, 'LMobileWk.Caption',
      LMobileWk.Caption);
    LAutreWk.Caption := ReadString(Settings.LangStr, 'LAutreWk.Caption',
      LAutreWk.Caption);
    LEmailWk.Caption := ReadString(Settings.LangStr, 'LEmailWk.Caption',
      LEmailWk.Caption);
    LWebWk.Caption := ReadString(Settings.LangStr, 'LWebWk.Caption', LWebWk.Caption);
    LLongitudeWk.Caption := ReadString(Settings.LangStr, 'LLongitudeWk.Caption',
      LLongitudeWk.Caption);
    LLatitudeWk.Caption := ReadString(Settings.LangStr, 'LLatitudeWk.Caption',
      LLatitudeWk.Caption);
    ImgContactHintEmpty := ReadString(Settings.LangStr, 'ImgContactHintEmpty',
      'Cliquez avec le bouton droit de la souris pour ajouter une image');
    ImgContactHintFull := ReadString(Settings.LangStr, 'ImgContactHintFull',
      'Cliquez avec le bouton droit de la souris pour changer ou supprimer cette image%sFichier image: %s');
    OPictDialog.Title := ReadString(Settings.LangStr, 'OPictDialog.Title',
      OPictDialog.Title);
    ContactNotFound := ReadString(Settings.LangStr, 'ContactNotFound',
      'Pas de contact trouvé');
    ContactNoOtherFound := ReadString(Settings.LangStr, 'ContactNoOtherFound',
      'Pas d''autre contact trouvé');
    CntImportd := ReadString(Settings.LangStr, 'CntImportd', '%d contact %s importé ');
    CntExportd := ReadString(Settings.LangStr, 'CntExportd', '%d contact %s exporté');
    CntImportds := ReadString(Settings.LangStr, 'CntImportds',
      '%d contacts %s importés ');
    CntExportds := ReadString(Settings.LangStr, 'CntExportds',
      '%d contacts %s exportés');
    MailSubject := ReadString(Settings.LangStr, 'MailSubject',
      'Courrier du gestionnaire de contacts');
    ConfirmDeleteContact := ReadString(Settings.LangStr, 'ConfirmDeleteContact',
      'Voulez-vous vraiment supprimer le contact %s ?');
    CanCloseMsg := ReadString(Settings.LangStr, 'CanCloseMsg',
      'Une modification est en cours.%s' +
      'Pour la valider et quitter, cliquez sur le bouton "Oui".%s' +
      'Pour l''annuler et quitter, cliquer sur le bouton "Non".%s' +
      'Pour revenir au programme, cliquer sur le bouton "Annuler".');
    Use64bitcaption := ReadString(Settings.LangStr, 'Use64bitcaption',
      'Utilisez la version 64 bits de ce programme');

    NoLongerChkUpdates := ReadString(Settings.LangStr,
      'NoLongerChkUpdates', 'Ne plus rechercher les mises à jour');
    LastUpdateSearch := ReadString(Settings.LangStr, 'LastUpdateSearch',
      'Dernière recherche de mise à jour');
    UpdateAvailable := ReadString(Settings.LangStr, 'UpdateAvailable',
      'Nouvelle version %s disponible');
    UpdateAlertBox := ReadString(Settings.LangStr, 'UpdateAlertBox',
      'Version actuelle: %sUne nouvelle version %s est disponible');
    // Settings
    FPrefs.Caption := ReadString(Settings.LangStr, 'FPrefs.Caption', FPrefs.Caption);
    FPrefs.GroupBox1.Caption :=
      ReadString(Settings.LangStr, 'FPrefs.GroupBox1.Caption', FPrefs.GroupBox1.Caption);
    FPrefs.LDataFolder.Caption :=
      ReadString(Settings.LangStr, 'FPrefs.LDataFolder.Caption', FPrefs.LDataFolder.Caption);
    FPrefs.CBStartup.Caption :=
      ReadString(Settings.LangStr, 'FPrefs.CBStartup.Caption', FPrefs.CBStartup.Caption);
    FPrefs.CBMinimized.Caption :=
      ReadString(Settings.LangStr, 'FPrefs.CBMinimized.Caption', FPrefs.CBMinimized.Caption);
    FPrefs.CBSavePos.Caption :=
      ReadString(Settings.LangStr, 'FPrefs.CBSavePos.Caption', FPrefs.CBSavePos.Caption);
    FPrefs.CBUpdate.Caption := ReadString(Settings.LangStr,
      'FPrefs.CBUpdate.Caption', FPrefs.CBUpdate.Caption);
    FPrefs.LLangue.Caption := ReadString(Settings.LangStr, 'FPrefs.LLangue.Caption',
      FPrefs.LLangue.Caption);
    FPrefs.BtnCancel.Caption := CancelBtn;
    // Import/export
    FImpex.Caption := ReadString(Settings.LangStr, 'FImpex.Caption', FImpex.Caption);
    FImpex.RBImport.Caption := ReadString(Settings.LangStr,
      'FImpex.RBImport.Caption', FImpex.RBImport.Caption);
    Fimpex.RBExport.Caption := ReadString(Settings.LangStr,
      'Fimpex.RBExport.Caption', Fimpex.RBExport.Caption);
    FImpex.LSepar.Caption := ReadString(Settings.LangStr, 'FImpex.LSepar.Caption',
      FImpex.LSepar.Caption);
    FImpex.LDelim.Caption := ReadString(Settings.LangStr, 'FImpex.LDelim.Caption',
      FImpex.LDelim.Caption);
    FImpex.LFilename.Caption :=
      ReadString(Settings.LangStr, 'FImpex.LFilename.Caption', FImpex.LFilename.Caption);
    FImpex.LCode.Caption := ReadString(Settings.LangStr, 'FImpex.LCode.Caption',
      FImpex.LCode.Caption);
    FImpex.SGImpex.Columns[0].Title.Caption :=
      ReadString(Settings.LangStr, 'FImpex.SGImpex.Col0.Title',
      FImpex.SGImpex.Columns[0].Title.Caption);
    FImpex.SGImpex.Columns[1].Title.Caption :=
      ReadString(Settings.LangStr, 'FImpex.SGImpex.Col1.Title',
      FImpex.SGImpex.Columns[1].Title.Caption);
    FImpex.OD1.Title := ReadString(Settings.LangStr, 'FImpex.OD1.Title',
      FImpex.OD1.Title);
    FImpex.SD1.Title := ReadString(Settings.LangStr, 'FImpex.SD1.Title',
      FImpex.SD1.Title);
    FImpex_ImportBtn_Caption :=
      ReadString(Settings.LangStr, 'FImpex.ImportBtn.Caption', 'Importation');
    FImpex_ExportBtn_Caption :=
      ReadString(Settings.LangStr, 'FImpex.ExportBtn.Caption', 'Exportation');
    FImpex.BtnCancel.Caption := FPrefs.BtnCancel.Caption;
    // popup menus
    MnuRetrieveGPSCaption := ReadString(Settings.LangStr, 'MnuRetrieveGPSCaption',
      'Récupérer les données GPS de %s');
    MnuLocateCaption := ReadString(Settings.LangStr, 'MnuLocateCaption',
      'Localiser %s sur une carte');
    MnuCopyCaption := ReadString(Settings.LangStr, 'MnuCopyCaption',
      'Copier les données de %s');
    MnuDeleteCaption := ReadString(Settings.LangStr, 'MnuDeleteCaption',
      'Supprimer le contact %s');
    MnuSendmailCaption := ReadString(Settings.LangStr, 'MnuSendmail',
      'Envoyer un courriel personnel à %s');
    MnuVisitwebCaption := ReadString(Settings.LangStr, 'MnuVisitwebCaption',
      'Visister le site Web personnel de %s');
    PMnuChooseImg.Caption := ReadString(Settings.LangStr, 'PMnuChoose.Caption',
      PMnuChooseImg.Caption);
    PMnuChangeImg.Caption := ReadString(Settings.LangStr, 'PMnuChange.Caption',
      PMnuChangeImg.Caption);
    PMnuDeleteImg.Caption := ReadString(Settings.LangStr, 'PMnuDelete.Caption',
      PMnuDeleteImg.Caption);
    // Translate default header of csv export
    csvheader := dquot + LName.Caption + dquotv + LSurname.Caption + dquotv +
      LStreet.Caption + dquotv + BPCaption + dquotv + LieuditCaption +
      dquotv + CPCaption + dquotv + TownCaption + dquotv + LCountry.Caption + dquotv + LPhone.Caption + dquotv +
      LBox.Caption + dquotv + LMobile.Caption + dquotv + LAutre.Caption +
      dquotv + LEmail.Caption + dquotv + LWeb.Caption + dquotv +
      LLongitude.Caption + dquotv + LLatitude.Caption + dquotv + LDateCre.Caption + dquotv +
      LDateModif.Caption + dquotv + CommentCaption + dquotv +
      'Index' + dquotv + ImageFileCaption + dquotv + LFonction.Caption + dquotv +
      LService.Caption + dquotv + LCompany.Caption + dquotv +
      LStreetWk.Caption + dquotv + BPWkCaption + dquotv +
      LieuditWkCaption + dquotv + CPWkCaption + dquotv + TownWkCaption +
      dquotv + LCountryWk.Caption + dquotv + LPhoneWk.Caption +
      dquotv + LBoxWk.Caption + dquotv + LMobileWk.Caption + dquotv + LAutreWk.Caption + dquotv +
      LEmailWk.Caption + dquotv + LWebWk.Caption + dquotv +
      LLongitudeWk.Caption + dquotv + LLatitudeWk.Caption + dquotv +
      'Version' + dquotv + 'Tag' + dquot;
    // HTTP Error messages
    HttpErrMsgNames[0] := ReadString(Settings.LangStr, 'SErrInvalidProtocol',
      'Protocole "%s" invalide');
    HttpErrMsgNames[1] := ReadString(Settings.LangStr, 'SErrReadingSocket',
      'Erreur de lecture des données à partir du socket');
    HttpErrMsgNames[2] := ReadString(Settings.LangStr, 'SErrInvalidProtocolVersion',
      'Version de protocole invalide en réponse: %s');
    HttpErrMsgNames[3] := ReadString(Settings.LangStr, 'SErrInvalidStatusCode',
      'Code de statut de réponse invalide: %s');
    HttpErrMsgNames[4] := ReadString(Settings.LangStr, 'SErrUnexpectedResponse',
      'Code de statut de réponse non prévu: %s');
    HttpErrMsgNames[5] := ReadString(Settings.LangStr, 'SErrChunkTooBig',
      'Bloc trop grand');
    HttpErrMsgNames[6] := ReadString(Settings.LangStr, 'SErrChunkLineEndMissing',
      'Fin de ligne du bloc manquante');
    HttpErrMsgNames[7] := ReadString(Settings.LangStr, 'SErrMaxRedirectsReached',
      'Nombre maximum de redirections atteint: %s');
    // Socket error messages
    HttpErrMsgNames[8] := ReadString(Settings.LangStr, 'strHostNotFound',
      'Résolution du nom d''hôte pour "%s" impossible.');
    HttpErrMsgNames[9] := ReadString(Settings.LangStr, 'strSocketCreationFailed',
      'Echec de la création du socket: %s');
    HttpErrMsgNames[10] := ReadString(Settings.LangStr, 'strSocketBindFailed',
      'Echec de liaison du socket: %s');
    HttpErrMsgNames[11] := ReadString(Settings.LangStr, 'strSocketListenFailed',
      'Echec de l''écoute sur le port n° %s, erreur %s');
    HttpErrMsgNames[12] := ReadString(Settings.LangStr, 'strSocketConnectFailed',
      'Echec de la connexion à %s');
    HttpErrMsgNames[13] := ReadString(Settings.LangStr, 'strSocketAcceptFailed',
      'Connexion refusée d''un client sur le socket: %s, erreur %s');
    HttpErrMsgNames[14] := ReadString(Settings.LangStr, 'strSocketAcceptWouldBlock',
      'La connexion pourrait bloquer le socket: %s');
    HttpErrMsgNames[15] := ReadString(Settings.LangStr, 'strSocketIOTimeOut',
      'Impossible de fixer le timeout E/S à %s');
    HttpErrMsgNames[16] := ReadString(Settings.LangStr, 'strErrNoStream',
      'Flux du socket non assigné');
  end;

end;

end.
