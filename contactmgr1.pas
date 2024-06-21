//******************************************************************************
// Contacts manager main form
// bb - sdtp - january 2023
//*******************************************************************************

unit contactmgr1;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Win32Proc,
  {$ENDIF} LMessages, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Buttons, contacts1, laz2_DOM, laz2_XMLRead, Types, FileUtil,
  lazbbutils, impex1, lclintf, Menus, ExtDlgs, fphttpclient, fpopenssl, openssl,
  strutils, lazbbaboutdlg, settings1, lazbbinifiles, LazUTF8, Clipbrd,
  UniqueInstance, lazbbchknewver, lazbbautostart, lazbbOsVersion,
  opensslsockets;

const
  // Message post at the end of activation procedure, processed once the form is shown
  WM_FORMSHOWN = WM_USER + 1;

type

  TSaveMode = (None, Setting, All);
  { TFContactManager }

  TFContactManager = class(TForm)
    OsVersion: TbbOsVersion;
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
    UpdateAlertBox: string;
    sNoLongerChkUpdates: string;
    LieuditCaption, BPCaption: string;
    CPCaption, TownCaption: string;
    CommentCaption, ImageFileCaption: string;
    LieuditWkCaption, BPWkCaption: string;
    CPWkCaption, TownWkCaption: string;
    settings: TConfig;
    CurLangStr: string;
    SettingsChanged: boolean;
    ContactsChanged: boolean;
    LangFile: TBbIniFile;
    LangNums: TStringList;
    LangFound: boolean;
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
    OKBtn, YesBtn, NoBtn, CancelBtn: string;
    Use64bitcaption: string;
    HttpErrMsgNames: array [0..16] of string;
    sCannotGetNewVerList: string;
    ChkVerInterval: Int64;
    StartMini: Boolean;
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
    //procedure ModLangue;
    procedure Translate(LngFile: TBbInifile);
    procedure SetEditState(val: boolean);
    function ShowAlert(Title, AlertStr, StReplace, NoShow: string;
      var Alert: boolean): boolean;
    procedure EnableLocBtns;
    procedure EnableEdits(Enable: Boolean);
    procedure CheckUpdate(days: PtrInt);
    procedure OnFormShown(var Msg: TLMessage); message WM_FORMSHOWN;
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

// TFContactManager : This is the main form of the program

// Procedure to answer post message at the end of activation procedure
// so once form is shown

procedure TFContactManager.OnFormShown(var Msg: TLMessage);
begin
  if StartMini then Application.minimize;
  StartMini:= false;
end;

procedure TFContactManager.FormCreate(Sender: TObject);
var
  s: string;
begin
  First := True;
  CompileDateTime:= StringToTimeDate({$I %DATE%}+' '+{$I %TIME%}, 'yyyy/mm/dd hh:nn:ss');
  OS := 'Unk';
  UserPath := GetUserDir;
  UserAppsDataPath := UserPath;
  {$IFDEF Linux}
    OS := 'Linux';
    CRLF := #10;
    CurLangStr := GetEnvironmentVariable('LANG');
    x := pos('.', CurLangStr);
    CurLangStr := Copy(CurLangStr, 0, 2);
    wxbitsrun := 0;
    OSTarget:= '';
  {$ENDIF}
  {$IFDEF WINDOWS}
    OS := 'Windows ';
    CRLF := #13#10;
    // get user data folder
    s := ExtractFilePath(ExcludeTrailingPathDelimiter(GetAppConfigDir(False)));
    if Ord(WindowsVersion) < 7 then
      UserAppsDataPath := s                     // NT to XP
    else
    UserAppsDataPath := ExtractFilePath(ExcludeTrailingPathDelimiter(s)) + 'Roaming'; // Vista to W10
    LazGetShortLanguageID(CurLangStr);
    {$IFDEF CPU32}
       OSTarget := '32 bits';
    {$ENDIF}
    {$IFDEF CPU64}
       OSTarget := '64 bits';
    {$ENDIF}
  {$ENDIF}
  //GetSysInfo(OsInfo);
  ProgName := 'ContactMgr';
  // Loading default language file..
  LangFile:= TBbIniFile.Create(ExtractFilePath(Application.ExeName) + 'lang'+PathDelim+'fr.lng');
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
    if length(s) > 0 then s := s + ' ';
    s := s + ListeContacts.GetItem(MouseIndex).Name;
    if length(s) = 1 then s := 'Contact ' + IntToStr(MouseIndex);       // only the space
    s1 := ListeContacts.GetItem(MouseIndex).Street;
    if length(s1) > 0 then s := s + #10 + s1;
    s1 := ListeContacts.GetItem(MouseIndex).BP;
    if length(s1) > 0 then s1 := s1 + ' ';
    s1 := s1 + ListeContacts.GetItem(MouseIndex).Lieudit;
    if length(s1) > 1 then s := s + #10 + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Postcode;
    if length(s1) > 0 then s1 := s1 + ' ';
    s1 := s1 + ListeContacts.GetItem(MouseIndex).Town;
    if length(s1) > 1 then s := s + #10 + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Phone;
    if length(s1) > 0 then s := s + #10 + LPhone.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Box;
    if length(s1) > 0 then s := s + #10 + LBox.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Mobile;
    if length(s1) > 0 then s := s + #10 + LMobile.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Autre;
    if length(s1) > 0 then s := s + #10 + LAutre.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Email;
    if length(s1) > 0 then s := s + #10 + LEmail.Caption + ': ' + s1;
    s1 := ListeContacts.GetItem(MouseIndex).Web;
    if length(s1) > 0 then s := s + #10 + LWeb.Caption + ': ' + s1;
    LBContacts.Hint := s;
    Application.ActivateHint(Mouse.CursorPos);
    previndex := MouseIndex;
  end;
end;



procedure TFContactManager.FormActivate(Sender: TObject);
var
  i: integer;
begin
  inherited;

  // The following has to be executed only the first time
  if not First then exit;
  First:= false;
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
    end else SaveConfig(All);
  end;
  version := GetVersionInfo.ProductVersion;
  LoadCfgFile(ConfigFile);
   if length(Settings.LastVersion)=0 then Settings.LastVersion:= version;
  // AboutBox.UrlUpdate:= BaseUpdateURl+Version+'&language='+Settings.LangStr;    // In Modlang
  // AboutBox.LUpdate.Caption:= 'Recherche de mise à jour';      // in Modlangue
  // Aboutbox.Caption:= 'A propos du Gestionnaire de contacts';            // in ModLangue
  AboutBox.Version:= Version;
  AboutBox.ChkVerURL := 'https://github.com/bb84000/contactmanager/releases/latest';
  AboutBox.UrlWebsite:= 'https://www.sdtp.com';
  AboutBox.UrlSourceCode:= 'https://github.com/bb84000/contactmanager';
  ChkVerInterval:=  3;
  AboutBox.Width:= 340; // to have more place for the long product name
  AboutBox.Image1.Picture.Icon.LoadFromResourceName(HInstance, 'MAINICON');
  AboutBox.LProductName.Caption := GetVersionInfo.FileDescription;
  AboutBox.LCopyright.Caption :=
    GetVersionInfo.CompanyName + ' - ' + DateTimeToStr(CompileDateTime);
  AboutBox.LVersion.Caption := 'Version: ' + Version + ' (' + OS + OSTarget + ')';
  //AboutBox.LUpdate.Hint:= AboutBox.sLastUpdateSearch + ': ' + DateToStr(Settings.LastUpdChk);  // In Modlangue

  CurIndex := 0;
  if ListeContacts.Count > 0 then DisplayList
  else
  begin
    // Disable non pertinent controls when list is blank
    BtnFirst.Enabled := False;
    BtnPrev.Enabled := False;
    BtnNext.Enabled := False;
    BtnLast.Enabled := False;
    BtnCoord.Enabled := False;
    BtnLocate.Enabled := False;
    ESearch.Enabled := False;
    BtnSearch.Enabled := False;
    BtnEmail.Enabled := False;
    BtnWeb.Enabled := False;
    BtnEmailWk.Enabled := False;
    BtnWebWk.Enabled := False;
    PMnuChangeImg.Visible:= False;
    PMnuDeleteImg.Visible:= False;
    // Disable all edit
    EnableEdits(False);
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
  if (Pos('64', OSVersion.Architecture)>0) and (OsTarget='32 bits') then
    MsgDlg(Caption, use64bitcaption, mtInformation,  [mbOK], [OKBtn]);
  Application.ProcessMessages;
  if StartMini then PostMessage(Handle, WM_FORMSHOWN, 0, 0) ;
  Application.QueueAsyncCall(@CheckUpdate, ChkVerInterval);       // async call to let icons loading
 end;

//Dernière recherche il y a "days" jours ou plus ?

procedure TFContactManager.CheckUpdate(days: PtrInt);
var
  errmsg: string;
  sNewVer: string;
  CurVer, NewVer: int64;
  alertpos: TPosition;
  alertmsg: string;
begin
  //Dernière recherche il y a plus de days jours ?
  errmsg := '';
  alertmsg:= '';
  if not visible then alertpos:= poDesktopCenter
  else alertpos:= poMainFormCenter;
  AboutBox.LastUpdate:= Trunc(Settings.LastUpdChk);
  if (Trunc(Now)>Trunc(Settings.LastUpdChk)+days) and (not Settings.NoChkNewVer) then
  begin
     Settings.LastUpdChk := Trunc(Now);
     AboutBox.Checked:= true;
     AboutBox.ErrorMessage:='';
     sNewVer:= AboutBox.ChkNewVersion;
     errmsg:= AboutBox.ErrorMessage;
     if length(sNewVer)=0 then
     begin
       if length(errmsg)=0 then alertmsg:= sCannotGetNewVerList
       else alertmsg:= TranslateHttpErrorMsg(errmsg, HttpErrMsgNames);
       if AlertDlg(Caption,  alertmsg, [OKBtn, CancelBtn, sNoLongerChkUpdates],
                    true, mtError, alertpos)= mrYesToAll then Settings.NoChkNewVer:= true;
       exit;
     end;
     NewVer := VersionToInt(sNewVer);
     // Cannot get new version
     if NewVer < 0 then exit;
     //CurVer := VersionToInt('0.1.0.0');     //Test version check
     CurVer := VersionToInt(version);
     if NewVer > CurVer then
     begin
       Settings.LastVersion:= sNewVer;
       AboutBox.LUpdate.Caption := Format(AboutBox.sUpdateAvailable, [sNewVer]);
       AboutBox.NewVersion:= true;
       AboutBox.ShowModal;
     end else
     begin
       AboutBox.LUpdate.Caption:= AboutBox.sNoUpdateAvailable;
     end;
     Settings.LastUpdChk:= now;
   end else
   begin
    if VersionToInt(Settings.LastVersion)>VersionToInt(version) then
       AboutBox.LUpdate.Caption := Format(AboutBox.sUpdateAvailable, [Settings.LastVersion]) else
    begin
      AboutBox.LUpdate.Caption:= AboutBox.sNoUpdateAvailable;
      // Already checked the same day
      if Trunc(Settings.LastUpdChk) = Trunc(now) then AboutBox.checked:= true;
    end;
   end;
   //AboutBox.LUpdate.Hint:= AboutBox.sLastUpdateSearch + ': ' + DateToStr(Settings.LastUpdChk);
   AboutBox.Translate(LangFile);
end;

procedure TFContactManager.EnableEdits(Enable: Boolean);
var
  i: integer;
begin
  for i := 0 to PnlPerso.ControlCount - 1 do
  if (PnlPerso.Controls[i] is TEdit) then PnlPerso.Controls[i].Enabled:= Enable;
  for i := 0 to PnlWork.ControlCount - 1 do
  if (PnlWork.Controls[i] is TEdit) then Pnlwork.Controls[i].Enabled:= Enable;
  PMnuChooseImg.Visible:= Enable;
  BtnDelete.Enabled := Enable;
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
  if Settings.StartWin then SetAutostart(progname, Application.exename)
  else UnSetAutostart(progname);
  if ContactsChanged or (Settings.version='') then SaveConfig(All)
  else if SettingsChanged then SaveConfig(Setting) ;
end;

// Display alertbox for new version available

function TFContactManager.ShowAlert(Title, AlertStr, StReplace, NoShow: string;
  var Alert: boolean): boolean;
var
  NoNewVer: Boolean;
  AlRes: Integer;
begin
  Result := False;
  NoNewVer:= true  ;
  AlRes:= AlertDlg(Title, Format(UpdateAlertBox, [version + #10, streplace]) , ['OK', CancelBtn,  NoShow],
                  NoNewVer, mtError);
  Case AlRes of
    mrOK: begin
            Result:= true;
            Alert:= false;
          end;
    mrYesToAll: begin
                  Result:= true;
                  Alert:= true;
                end;
  end;
end;

// Load configuration and database from file

procedure TFContactManager.LoadCfgFile(filename: string);
var
  winstate: TWindowState;
  i: integer;
begin

  Settings.LoadXMLFile(filename);
  if Settings.SavSizePos then
    try
      WinState := TWindowState(StrToInt('$' + Copy(Settings.WState, 1, 4)));
      if Winstate = wsMinimized then
        //Application.Minimize
        StartMini:= true
      else
        WindowState := WinState;
      Top := StrToInt('$' + Copy(Settings.WState, 5, 4));
      Left := StrToInt('$' + Copy(Settings.WState, 9, 4));
      Height := StrToInt('$' + Copy(Settings.WState, 13, 4));
      Width := StrToInt('$' + Copy(Settings.WState, 17, 4));
    except
    end;
  if Settings.StartWin and settings.StartMini then StartMini:= true; //Application.Minimize;
  // Détermination de la langue (si pas dans settings, langue par défaut)
  if Settings.LangStr = '' then Settings.LangStr := CurLangStr;
  try
    FindAllFiles(LangNums, ExtractFilePath(Application.ExeName) + 'lang', '*.lng', true); //find all language files
    if LangNums.count > 0 then
    begin
      for i:= 0 to LangNums.count-1 do
      begin
        LangFile:= TBbInifile.Create(LangNums.Strings[i]);
        LangNums.Strings[i]:= TrimFileExt(ExtractFileName(LangNums.Strings[i]));
        FSettings.CBLangue.Items.Add(LangFile.ReadString('common', 'Language', 'Inconnu'));
        if LangNums.Strings[i] = Settings.LangStr then LangFound := True;
      end;
    end;
  except
    LangFound := false;
  end;
  // Si la langue n'est pas traduite, alors on passe en Anglais
  if not LangFound then
  begin
    Settings.LangStr := 'en';
  end;
  ListeContacts.Reset;
  ListeContacts.LoadXMLfile(filename);
  LangFile:= TBbIniFile.Create(ExtractFilePath(Application.ExeName) + 'lang'+PathDelim+Settings.LangStr+'.lng');
  Translate(LangFile);
  SettingsChanged := False;
end;

// Save configuration and database to file

function TFContactManager.SaveConfig(typ: TSaveMode): boolean;
var
  FilNamWoExt: string;
  i: integer;
begin
  Result := False;
    if (Typ= Setting) or (Typ = All) then
  begin
    Settings.DataFolder:= ContactMgrAppsData;
    Settings.WState:= '';
    if Top < 0 then Top:= 0;
    if Left < 0 then Left:= 0;
    Settings.WState:= IntToHex(ord(WindowState), 4)+IntToHex(Top, 4)+IntToHex(Left, 4)+IntToHex(Height, 4)+IntToHex(width, 4);
    Settings.Version:= version;
    if FileExists (ConfigFile) then
    begin
      if (Typ = All) then
      begin
        // On sauvegarde les versions précédentes parce que la base de données a changé
        FilNamWoExt:= TrimFileExt(ConfigFile);
        if FileExists (FilNamWoExt+'.bk5')                   // Efface la plus ancienne
        then  DeleteFile(FilNamWoExt+'.bk5');                // si elle existe
        For i:= 4 downto 0
        do if FileExists (FilNamWoExt+'.bk'+IntToStr(i))     // Renomme les précédentes si elles existent
           then  RenameFile(FilNamWoExt+'.bk'+IntToStr(i), FilNamWoExt+'.bk'+IntToStr(i+1));
        RenameFile(ConfigFile, FilNamWoExt+'.bk0');
        ListeContacts.SaveToXMLfile(ConfigFile);
      end;
      // la base n'a pas changé, on ne fait pas de backup
      settings.SaveToXMLfile(ConfigFile);
    end else
    begin
      ListeContacts.SaveToXMLfile(ConfigFile);
      settings.SaveToXMLfile(ConfigFile); ;
    end;
    result:= true;
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
  i, j: integer;
  MyEdit: TEdit;
begin
  SetContactChange(False);
  n := LBContacts.ItemIndex;
  if (n > LBContacts.Count - 1) then exit;
  for i := 0 to length(AFieldNames) - 1 do
  begin
    MyEdit := TEdit(FindComponent('E' + AFieldNames[i]));
    if ListeContacts.count>0 then
    begin
      if Assigned(MyEdit) then
          MyEdit.Text := ListeContacts.GetItemFieldString(n, AFieldNames[i]);
      // Replace with date locale format
      EDate.Text:= DateTimeToStr(ListeContacts.GetItem(n).Date);
      EDatemodif.text:= TimeDateToString(ListeContacts.GetItem(n).DateModif);
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
  SetContactChange(True);
end;

// Click on quit button

procedure TFContactManager.BtnQuitClick(Sender: TObject);
begin
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
      s := UpperCase(FloatToString(ListeContacts.GetItem(i).Longitude));
    if RBLatit.Checked then
      s := UpperCase(FloatToString(ListeContacts.GetItem(i).Latitude));
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
    Date := StringToTimeDate(EDate.Text);
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
    //BtnDelete.Enabled:= true;
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
      if (ListeContacts.Count=0) and (Fimpex.ImpexContacts.Count>0) then EnableEdits(true);
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
  //smap := 'https://www.google.fr/maps/search/';
  smap := 'https://www.google.fr/maps/place/';
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
begin
  // Enable all edit, they are disbled if listecontacts is blank
  if ListeContacts.count= 0 then EnableEdits(true);
  // prevent unwanted firing of the event during the process
  SetContactChange(False);
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
  LImageFile.Caption:= '';
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
var
  chked: Boolean;
  alertmsg: String;
begin
    // If main windows is hidden, place the about box at the center of desktop,
  // else at the center of main windows
  if (Sender.ClassName= 'TMenuItem') and not visible then AboutBox.Position:= poDesktopCenter
  else AboutBox.Position:= poMainFormCenter;
  AboutBox.LastUpdate:= Settings.LastUpdChk;
  chked:= AboutBox.Checked;
  AboutBox.ErrorMessage:='';
  AboutBox.ShowModal;
  // If we have checked update and got an error
  if length(AboutBox.ErrorMessage)>0 then
  begin
    alertmsg := TranslateHttpErrorMsg(AboutBox.ErrorMessage, HttpErrMsgNames);
    if AlertDlg(Caption,  alertmsg, [OKBtn, CancelBtn, sNoLongerChkUpdates],
                    true, mtError)= mrYesToAll then Settings.NoChkNewVer:= true;
  end;
  // Truncate date to avoid changes if there is the same day (hh:mm are in the decimal part of the date)
  if (not chked) and AboutBox.Checked then Settings.LastVersion:= AboutBox.LastVersion;
  if trunc(AboutBox.LastUpdate) > trunc(Settings.LastUpdChk) then
  begin
    Settings.LastUpdChk:= AboutBox.LastUpdate;
  end;
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
  FSettings.Edatafolder.Text := ContactMgrAppsData;
  FSettings.CBStartup.Checked := Settings.StartWin;
  FSettings.CBSavePos.Checked := Settings.SavSizePos;
  FSettings.CBMinimized.Checked := Settings.StartMini;
  FSettings.CBUpdate.Checked := Settings.NoChkNewVer;
  FSettings.CBLangue.ItemIndex := LangNums.IndexOf(Settings.LangStr);
  oldndx := FSettings.CBLangue.ItemIndex;
  FSettings.CBMinimized.Enabled := FSettings.CBStartup.Checked;
  if FSettings.ShowModal = mrOk then
  begin
    Settings.StartWin := FSettings.CBStartup.Checked;
    Settings.SavSizePos := FSettings.CBSavePos.Checked;
    Settings.StartMini := FSettings.CBMinimized.Checked;
    Settings.NoChkNewVer := FSettings.CBUpdate.Checked;
    Settings.LangStr := LangNums.Strings[FSettings.CBLangue.ItemIndex];
    if FSettings.CBLangue.ItemIndex <> oldndx then
    begin
      LangFile:= TBbIniFile.Create(ExtractFilePath(Application.ExeName) + 'lang'+PathDelim+Settings.LangStr+'.lng');
      Translate(LangFile);
    end;
    DisplayContact;                                // Needed to change language on hints
  end;
end;

// Replace lazarus upper tabs with coloured panels

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

procedure TFContactManager.Translate(LngFile: TBbInifile);
const
  dquot = '"';     // Double quote
  dquotv = '","';   // Double quote  plus comma plus double quote
var

  prgName: String;
begin
  if Assigned(LngFile) then
  with LngFile do
  begin
    prgName:= ReadString('Common', 'ProgName', 'Erreur');
    if prgName<>ProgName then
    ShowMessage('Fichier de langue erroné. Réinstallez le programme');
    OsVersion.Translate(LangFile);
    //Main Form
    Caption:=ReadString('Common','DefaultCaption','Gestionnaire de Contacts');
    // Components
    OKBtn:= ReadString('Common', 'OKBtn', 'OK');
    YesBtn:=ReadString('Common','YesBtn','Oui');
    NoBtn:=ReadString('Common','NoBtn','Non');
    CancelBtn:=ReadString('Common','CancelBtn','Annuler');


    // Main form
    PPerso.Caption:=ReadString('main','PPerso.Caption',PPerso.Caption);
    PWork.Caption:=ReadString('main','PWork.Caption',PWork.Caption);
    GBOrder.Caption:=ReadString('main','GBOrder.Caption',GBOrder.Caption);
    RBNone.Caption:=ReadString('main','RBNone.Caption',RBNone.Caption);
    RBTown.Caption:=ReadString('main','RBTown.Caption',RBTown.Caption);
    RBNameSurname.Caption:=ReadString('main','RBNameSurname.Caption',RBNameSurname.Caption);
    RBCountry.Caption:=ReadString('main','RBCountry.Caption',RBCountry.Caption);
    RBSurnameName.Caption:=ReadString('main','RBSurnameName.Caption',RBSurnameName.Caption);
    RBPostcode.Caption:=ReadString('main','RBPostcode.Caption',RBPostcode.Caption);
    RBlongit.Caption:=ReadString('main','RBlongit.Caption',RBlongit.Caption);
    RBLatit.Caption:=ReadString('main','RBLatit.Caption',RBLatit.Caption);
    BtnImport.Hint:=ReadString('main','BtnImport.Hint',BtnImport.Hint);
    BtnFirst.Hint:=ReadString('main','BtnFirst.Hint',BtnFirst.Hint);
    BtnPrev.Hint:=ReadString('main','BtnPrev.Hint',BtnPrev.Hint);
    BtnNext.Hint:=ReadString('main','BtnNext.Hint',BtnNext.Hint);
    BtnLast.Hint:=ReadString('main','BtnLast.Hint',BtnLast.Hint);
    BtnDelete.Hint:=ReadString('main','BtnDelete.Hint',BtnDelete.Hint);
    BtnAdd.Hint:=ReadString('main','BtnAdd.Hint',BtnAdd.Hint);
    BtnValid.Hint:=ReadString('main','BtnValid.Hint',BtnValid.Hint);
    BtnCancel.Hint:=ReadString('main','BtnCancel.Hint',BtnCancel.Hint);
    BtnCoord.Hint:=ReadString('main','BtnCoord.Hint',BtnCoord.Hint);
    BtnLocate.Hint:=ReadString('main','BtnLocate.Hint',BtnLocate.Hint);
    BtnPrefs.Hint:=ReadString('main','BtnPrefs.Hint',BtnPrefs.Hint);
    BtnAbout.Hint:=ReadString('main','BtnAbout.Hint',BtnAbout.Hint);
    BtnQuit.Hint:=ReadString('main','BtnQuit.Hint',BtnQuit.Hint);
    BtnSearch.Hint:=ReadString('main','BtnSearch.Hint',BtnSearch.Hint);
    LName.Caption:=ReadString('main','LName.Caption',LName.Caption);
    LSurname.Caption:=ReadString('main','LSurname.Caption',LSurname.Caption);
    LStreet.Caption:=ReadString('main','LStreet.Caption', LStreet.Caption);
    BPCaption:=ReadString('main','BPCaption','BP');
    LieuditCaption:=ReadString('main','LieuditCaption','Lieudit');
    LBP.Caption:=BPCaption+', '+LieuditCaption;
    CPCaption:=ReadString('main','CPCaption','CP');
    TownCaption:=ReadString('main','TownCaption','Ville');
    LCP.Caption:=CPCaption+', '+TownCaption;
    LCountry.Caption:=ReadString('main','LCountry.Caption',LCountry.Caption);
    LPhone.Caption:=ReadString('main','LPhone.Caption',LPhone.Caption);
    LBox.Caption:=ReadString('main','LBox.Caption',LBox.Caption);
    LMobile.Caption:=ReadString('main','LMobile.Caption',LMobile.Caption);
    LAutre.Caption:=ReadString('main','LAutre.Caption',LAutre.Caption);
    LEmail.Caption:=ReadString('main','LEmail.Caption',LEmail.Caption);
    LWeb.Caption:=ReadString('main','LWeb.Caption',LWeb.Caption);
    LLongitude.Caption:=ReadString('main','LLongitude.Caption',LLongitude.Caption);
    LLatitude.Caption:=ReadString('main','LLatitude.Caption',LLatitude.Caption);
    LDateCre.Caption:=ReadString('main','LDateCre.Caption',LDateCre.Caption);
    LDatemodif.Caption:=ReadString('main','LDatemodif.Caption',LDatemodif.Caption);
    CommentCaption:=ReadString('main','CommentCaption','Commentaire');
    ImageFileCaption:=ReadString('main','ImageFileCaption','Fichier image');
    LFonction.Caption:= ReadString('main','LFonction.Caption',LFonction.Caption);
    LCompany.Caption:=ReadString('main','LCompany.Caption',LCompany.Caption);
    LStreetWk.Caption:=ReadString('main','LStreetWk.Caption',LStreetWk.Caption);
    BPWkCaption:=ReadString('main','BPWkCaption','BP Pro');
    LieuditWkCaption := ReadString('main', 'LieuditWkCaption', 'Lieudit pro');
    LBPWk.Caption:=BPWkCaption+', '+LieuditWkCaption;
    CPWkCaption:=ReadString('main','CPWkCaption','CP pro');
    TownWkCaption:=ReadString('main','TownWkCaption','Ville pro');
    LCPWk.Caption:=CPWkCaption+', '+TownWkCaption;
    LCountryWk.Caption:=ReadString('main','LCountryWk.Caption',LCountryWk.Caption);
    LPhoneWk.Caption:=ReadString('main','LPhoneWk.Caption',LPhoneWk.Caption);
    LBoxWk.Caption:=ReadString('main','LBoxWk.Caption',LBoxWk.Caption);
    LMobileWk.Caption:=ReadString('main','LMobileWk.Caption',LMobileWk.Caption);
    LAutreWk.Caption:=ReadString('main','LAutreWk.Caption',LAutreWk.Caption);
    LEmailWk.Caption:=ReadString('main','LEmailWk.Caption',LEmailWk.Caption);
    LWebWk.Caption:=ReadString('main','LWebWk.Caption',LWebWk.Caption);
    LLongitudeWk.Caption:=ReadString('main','LLongitudeWk.Caption',LLongitudeWk.Caption);
    LLatitudeWk.Caption:=ReadString('main','LLatitudeWk.Caption',LLatitudeWk.Caption);
    ImgContactHintEmpty:=ReadString('main','ImgContactHintEmpty',
      'Cliquez avec le bouton droit de la souris pour ajouter une image');
    ImgContactHintFull:=ReadString('main','ImgContactHintFull',
      'Cliquez avec le bouton droit de la souris pour changer ou supprimer cette image%sFichier image: %s');
    OPictDialog.Title:=ReadString('main','OPictDialog.Title',OPictDialog.Title);
    ContactNotFound:=ReadString('main','ContactNotFound','Pas de contact trouvé');
    ContactNoOtherFound:=ReadString('main','ContactNoOtherFound','Pas d''autre contact trouvé');
    CntImportd:=ReadString('main','CntImportd','%d contact %s importé');
    CntExportd:=ReadString('main','CntExportd','%d contact %s exporté');
    CntImportds:=ReadString('main','CntImportds','%d contacts %s importés ');
    CntExportds:=ReadString('main','CntExportds','%d contacts %s exportés');
    MailSubject:=ReadString('main','MailSubject','Courrier du gestionnaire de contacts');
    ConfirmDeleteContact:=ReadString('main','ConfirmDeleteContact',
      'Voulez-vous vraiment supprimer le contact %s ?');
    CanCloseMsg:=ReadString('main', 'CanCloseMsg',
      'Une modification est en cours.%s' +
      'Pour la valider et quitter, cliquez sur le bouton "Oui".%s' +
      'Pour l''annuler et quitter, cliquer sur le bouton "Non".%s' +
      'Pour revenir au programme, cliquer sur le bouton "Annuler".');
    Use64bitcaption:=ReadString('main','Use64bitcaption','Utilisez la version 64 bits de ce programme');
    sNoLongerChkUpdates:=ReadString('main','NoLongerChkUpdates','Ne plus rechercher les mises à jour');
    UpdateAlertBox:=ReadString('main','UpdateAlertBox',
      'Version actuelle: %sUne nouvelle version %s est disponible');
    sCannotGetNewVerList:=ReadString('main','CannotGetNewVerList','Liste des nouvelles versions indisponible');

    // AboutBox
    AboutBox.Translate(LangFile);
    AboutBox.LVersion.Hint:= OSVersion.VerDetail;

    // Settings
    FSettings.Translate(LangFile);
    FSettings.LStatus.Caption := OsVersion.VerDetail;

    // Import/export
    FIMpex.Translate(LangFile);

    // popup menus
    MnuRetrieveGPSCaption:=ReadString('main','MnuRetrieveGPSCaption','Récupérer les données GPS de %s');
    MnuLocateCaption:=ReadString('main','MnuLocateCaption','Localiser %s sur une carte');
    MnuCopyCaption:=ReadString('main', 'MnuCopyCaption','Copier les données de %s');
    MnuDeleteCaption:=ReadString('main','MnuDeleteCaption','Supprimer le contact %s');
    MnuSendmailCaption:=ReadString('main','MnuSendmail','Envoyer un courriel personnel à %s');
    MnuVisitwebCaption:=ReadString('main','MnuVisitwebCaption','Visister le site Web personnel de %s');
    PMnuChooseImg.Caption:=ReadString('main','PMnuChoose.Caption',PMnuChooseImg.Caption);
    PMnuChangeImg.Caption:=ReadString('main','PMnuChange.Caption',PMnuChangeImg.Caption);
    PMnuDeleteImg.Caption:=ReadString('main','PMnuDelete.Caption',PMnuDeleteImg.Caption);

    // HTTP Error messages
    HttpErrMsgNames[0] := ReadString('HttpErr', 'SErrInvalidProtocol',
      'Protocole "%s" invalide');
    HttpErrMsgNames[1] := ReadString('HttpErr', 'SErrReadingSocket',
      'Erreur de lecture des données à partir du socket');
    HttpErrMsgNames[2] := ReadString('HttpErr', 'SErrInvalidProtocolVersion',
      'Version de protocole invalide en réponse: %s');
    HttpErrMsgNames[3] := ReadString('HttpErr', 'SErrInvalidStatusCode',
      'Code de statut de réponse invalide: %s');
    HttpErrMsgNames[4] := ReadString('HttpErr', 'SErrUnexpectedResponse',
      'Code de statut de réponse non prévu: %s');
    HttpErrMsgNames[5] := ReadString('HttpErr', 'SErrChunkTooBig',
      'Bloc trop grand');
    HttpErrMsgNames[6] := ReadString('HttpErr', 'SErrChunkLineEndMissing',
      'Fin de ligne du bloc manquante');
    HttpErrMsgNames[7] := ReadString('HttpErr', 'SErrMaxRedirectsReached',
      'Nombre maximum de redirections atteint: %s');
    // Socket error messages
    HttpErrMsgNames[8] := ReadString('HttpErr', 'strHostNotFound',
      'Résolution du nom d''hôte pour "%s" impossible.');
    HttpErrMsgNames[9] := ReadString('HttpErr', 'strSocketCreationFailed',
      'Echec de la création du socket: %s');
    HttpErrMsgNames[10] := ReadString('HttpErr', 'strSocketBindFailed',
      'Echec de liaison du socket: %s');
    HttpErrMsgNames[11] := ReadString('HttpErr', 'strSocketListenFailed',
      'Echec de l''écoute sur le port n° %s, erreur %s');
    HttpErrMsgNames[12]:=ReadString('HttpErr','strSocketConnectFailed',
      'Echec de la connexion à %s');
    HttpErrMsgNames[13]:=ReadString('HttpErr', 'strSocketAcceptFailed',
      'Connexion refusée d''un client sur le socket: %s, erreur %s');
    HttpErrMsgNames[14]:=ReadString('HttpErr','strSocketAcceptWouldBlock',
      'La connexion pourrait bloquer le socket: %s');
    HttpErrMsgNames[15]:=ReadString('HttpErr','strSocketIOTimeOut',
      'Impossible de fixer le timeout E/S à %s');
    HttpErrMsgNames[16]:=ReadString('HttpErr','strErrNoStream',
      'Flux du socket non assigné');
    // Translate default header of csv export
    csvheader := dquot+
                       LName.Caption+dquotv+
                       LSurname.Caption+dquotv+
                       LStreet.Caption +dquotv+
                       BPCaption+dquotv+
                       LieuditCaption+dquotv+
                       CPCaption+dquotv+
                       TownCaption+dquotv+
                       LCountry.Caption+dquotv+
                       LPhone.Caption+dquotv+
                       LBox.Caption+dquotv+
                       LMobile.Caption+dquotv+
                       LAutre.Caption+dquotv+
                       LEmail.Caption+dquotv+
                       LWeb.Caption+dquotv+
                       LLongitude.Caption+dquotv+
                       LLatitude.Caption+dquotv+
                       LDateCre.Caption+dquotv+
                       LDateModif.Caption+dquotv+
                       CommentCaption+dquotv+
                       'Index'+dquotv+
                       ImageFileCaption+dquotv+
                       LFonction.Caption+dquotv+
                       LService.Caption+dquotv+
                       LCompany.Caption+dquotv+
                       LStreetWk.Caption+dquotv+
                       BPWkCaption+dquotv+
                       LieuditWkCaption+dquotv+
                       CPWkCaption+dquotv+
                       TownWkCaption+dquotv+
                       LCountryWk.Caption+dquotv+
                       LPhoneWk.Caption+dquotv+
                       LBoxWk.Caption+dquotv+
                       LMobileWk.Caption+dquotv+
                       LAutreWk.Caption+dquotv+
                       LEmailWk.Caption+dquotv+
                       LWebWk.Caption+dquotv+
                       LLongitudeWk.Caption+dquotv+
                       LLatitudeWk.Caption+dquotv+
                       'Version'+dquotv+'Tag'+dquot;


  end;
end;

end.
