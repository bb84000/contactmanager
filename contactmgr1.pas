unit contactmgr1;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
     Win32Proc,
  {$ENDIF} Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, contacts1, laz2_DOM , laz2_XMLRead, laz2_XMLWrite, Types, lazbbosversion,
  lazbbutils, impex1, lclintf, Menus, ExtDlgs, fphttpclient, strutils, lazbbabout, prefs1, config1, lazbbinifiles,
  LazUTF8, Clipbrd, UniqueInstance;

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
    EDatecreation: TEdit;
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
    procedure LBContactsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LBContactsSelectionChange(Sender: TObject; User: boolean);
    procedure MnuCopyClick(Sender: TObject);
    procedure PnlButtonsClick(Sender: TObject);
    procedure PnlInfosClick(Sender: TObject);
    procedure PMnuChooseImgClick(Sender: TObject);
    procedure PMnuDeleteImgClick(Sender: TObject);
    procedure PMnuListPopup(Sender: TObject);
    procedure PPersoClick(Sender: TObject);
    procedure PWorkClick(Sender: TObject);
    procedure RBSortClick(Sender: TObject);
  private
    First: boolean;
    OS, OSTarget, CRLF : string;
    CompileDateTime: TDateTime;
    UserPath, UserAppsDataPath: string;
    ProgName: string;
    ConfigFile: string;
    SortType: TChampsCompare;
    CurIndex: integer;
    CurContChanged: boolean;
    ButtonStates: array [0..14] of Boolean;
    NewContact: boolean;
    version: string;
    BaseUpdateUrl: string;
    LieuditCaption, BPCaption:  string;
    CPCaption, TownCaption: string;
    CommentCaption, ImageFileCaption: string;
    LieuditWkCaption, BPWkCaption:  string;
    CPWkCaption, TownWkCaption: string;
    settings: TConfig;
    LangStr: string;
    SettingsChanged: Boolean;
    ContactsChanged: Boolean;
    LangFile: TBbIniFile;
    LangNums: TStringList;
    LangFound: Boolean;
    OsInfo: TOSInfo;
    Newsearch: boolean;
    previndex: integer;
    MnuRetrieveGPSCaption: string;
    MnuLocateCaption: string;
    MnuCopyCaption: string;
    MnuDeleteCaption: string;
    MnuSendmailCaption: string;
    MnuVisitwebCaption: string;
    MouseIndex: Integer;
    ContactNotFound, ContactNoOtherFound: String;
    CntImportd, CntExportd, CntImportds, CntExportds: string;
    ConfirmDeleteContact: string;
    MailSubject: string;
    ImgContactHintEmpty, ImgContactHintFull: string;
    canCloseMsg: string;
    YesBtn, NoBtn, CancelBtn: string;
    procedure LoadCfgFile(filename: string);
    procedure DisplayList;
    procedure DisplayContact;
    procedure SetContactChange(val: Boolean);
    procedure SaveButtonStates;
    procedure RestoreButtonStates;
    procedure DisableButtons;
    function SaveConfig(Typ: TSaveMode): boolean;
    procedure SettingsOnChange(sender: TObject);
    procedure SettingsOnStateChange(sender: TObject);
    procedure ContactsOnChange(sender: TObject);
    procedure ModLangue ;
    procedure SetEditState(val: boolean);
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
  First:= true;
  // Compilation date/time
  try
    CompileDateTime:= Str2Date({$I %DATE%}, 'YYYY/MM/DD')+StrToTime({$I %TIME%});
  except
    CompileDateTime:=  now();
  end;
  OS:= 'Unk';
  UserPath:= GetUserDir;
  UserAppsDataPath:= UserPath;
  {$IFDEF Linux}
     OS:= 'Linux';
     CRLF:= #10;
     LangStr:=GetEnvironmentVariable('LANG');
     x:= pos('.', LangStr);
     LangStr:= Copy(LangStr,0, 2);
     wxbitsrun:= 0;
  {$ENDIF}
  {$IFDEF WINDOWS}
     OS:= 'Windows ';
     CRLF:= #13#10;
     // get user data folder
     s:= ExtractFilePath(ExcludeTrailingPathDelimiter(GetAppConfigDir(False)));
     if  Ord(WindowsVersion) < 7 then UserAppsDataPath:= s                     // NT to XP
     else UserAppsDataPath:= ExtractFilePath(ExcludeTrailingPathDelimiter(s))+'Roaming';  // Vista to W10
     LazGetShortLanguageID(LangStr);

  {$ENDIF}
  GetSysInfo(OsInfo);
  ProgName:= 'ContactMgr';
  // Chargement des chaînes de langue...
  LangFile:= TBbIniFile.create(ExtractFilePath(Application.ExeName)+'contactmgr.lng');
  LangNums:= TStringList.Create;

  ContactMgrAppsData:= UserAppsDataPath+PathDelim+ProgName+PathDelim;
    if not DirectoryExists (ContactMgrAppsData) then
  begin
    CreateDir(ContactMgrAppsData);
  end;
  settings:= TConfig.Create;
  settings.OnChange:= @SettingsOnChange;
  settings.OnStateChange:= @SettingsOnStateChange;
  ListeContacts:= TContactsList.Create;
  ListeContacts.OnChange:= @ContactsOnChange;
  LImageFile.Caption:= '';
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





procedure TFContactManager.LBContactsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var

  s, s1: string;
  cname, cstreet, clieudit, ctown : string;
begin
  MouseIndex := LBContacts.ItemAtPos(Point(X,Y), false);
  if (MouseIndex >= 0) and (previndex <> MouseIndex) then
  begin
    s:= '';
    s1:= '';
    s:= ListeContacts.GetItem(MouseIndex).Surname;
    if length(s)>0 then s:= s+' ';
    cname:= ListeContacts.GetItem(MouseIndex).Name;
    if length(cname)>0 then s:= s+cname;
    if length(s)=0 then s:= 'Contact '+IntToStr(MouseIndex);
    cstreet:= ListeContacts.GetItem(MouseIndex).Street;
    if length(cstreet)>0 then s:= s+#10+cstreet;
    s1:= ListeContacts.GetItem(MouseIndex).BP;
    if length(s1)>0 then s1:= s1+' ';
    clieudit:= ListeContacts.GetItem(MouseIndex).Lieudit;
    if length(clieudit)>0 then s1:= s1+clieudit;
    if length(s1) > 0 then s:=s+#10+s1;
    s1:=ListeContacts.GetItem(MouseIndex).Postcode;
    if length(s1)>0 then s1:= s1+' ';
    ctown:= ListeContacts.GetItem(MouseIndex).Town;
    if length(ctown)>0 then s1:= s1+ctown;
    if length(s1) > 0 then s:=s+#10+s1;
    s1:= ListeContacts.GetItem(MouseIndex).Phone;
    if length(s1) > 0 then s:= s+#10+LPhone.Caption+': '+s1;
    s1:= ListeContacts.GetItem(MouseIndex).Box;
    if length(s1) > 0 then s:= s+#10+LBox.Caption+': '+s1;
    s1:= ListeContacts.GetItem(MouseIndex).Mobile;
    if length(s1) > 0 then s:= s+#10+LMobile.Caption+': '+s1;
    s1:= ListeContacts.GetItem(MouseIndex).Autre;
    if length(s1) > 0 then s:= s+#10+LAutre.Caption+': '+s1;
    s1:= ListeContacts.GetItem(MouseIndex).Email;
    if length(s1) > 0 then s:= s+#10+LEmail.Caption+': '+s1;
    s1:= ListeContacts.GetItem(MouseIndex).Web;
    if length(s1) > 0 then s:= s+#10+LWeb.Caption+': '+s1;
    LBContacts.Hint:= s;
    Application.ActivateHint(Mouse.CursorPos);
    previndex:= MouseIndex;
  end;
end;

procedure TFContactManager.FormActivate(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if not first then exit;
  {$IFDEF WIN32}
      OSTarget:= '32 bits';
  {$ENDIF}
  {$IFDEF WIN64}
      OSTarget:= '64 bits';
  {$ENDIF}
  ConfigFile:= ContactMgrAppsData+ProgName+'.xml';

  If not FileExists(ConfigFile) then
  begin
    If FileExists (ContactMgrAppsData+ProgName+'.bk0') then
    begin
      RenameFile(ContactMgrAppsData+ProgName+'.bk0', ConfigFile);
      For i:= 1 to 5
      do if FileExists (ContactMgrAppsData+ProgName+'.bk'+IntToStr(i))     // Renomme les précédentes si elles existent
       then  RenameFile(ContactMgrAppsData+ProgName+'.bk'+IntToStr(i), ContactMgrAppsData+ProgName+'.bk'+IntToStr(i-1));
    end else
    begin
      SaveConfig(All)
    end;
  end;
  BaseUpdateUrl:= 'http://www.sdtp.com/versions/version.php?program=contactmgr&version=%s&language=%s';
  version:= GetVersionInfo.ProductVersion;
  LoadCfgFile(ConfigFile);
  //Aboutbox.Caption:= 'A propos du Gestionnaire de contacts';            // in ModLangue
  AboutBox.Image1.Picture.Icon.LoadFromResourceName(HInstance, 'MAINICON');
  AboutBox.LProductName.Caption:= GetVersionInfo.FileDescription;
  AboutBox.LCopyright.Caption:= GetVersionInfo.CompanyName+' - '+DateTimeToStr(CompileDateTime);
  AboutBox.LVersion.Caption:= 'Version: '+Version+' ('+OS+OSTarget+')';
  //AboutBox.UrlUpdate:= BaseUpdateURl+Version+'&language='+Settings.LangStr;    // In Modlang
 // AboutBox.LUpdate.Caption:= 'Recherche de mise à jour';      // in Modlangue
  AboutBox.UrlWebsite:=GetVersionInfo.Comments;
  FPrefs.LStatus.Caption:= OsInfo.VerDetail;;
  CurIndex:= 0;
  DisplayList;
  Case ListeContacts.SortType of
    cdcName : RBNameSurname.Checked:= True;
    cdcSurname : RBSurnameName.Checked:= True;
    cdcPostcode : RBPostCode.Checked:= True;
    cdcTown : RBTown.Checked:= True;
    cdcCountry : RBCountry.Checked:= True;
    cdcLongit : RBLongit.Checked:= True;
    cdcLatit : RBLatit.Checked:= True;
  end;
  // Positionne les faux onglets et positionne sur l'onglet personnel
  PPerso.Left:= 2;
  PWork.left:= PPerso.Width+PPerso.Left;
  PPersoClick(Sender);
  NewContact:= False;
  ContactsChanged:= false;
  Application.ProcessMessages;
  Application.Title:= Caption;

end;

procedure TFContactManager.FormChangeBounds(Sender: TObject);
begin
  SettingsOnStateChange(Sender);
end;

procedure TFContactManager.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  // Don't close if changes pending
  CloseAction:= caFree;
  if not BtnQuit.Enabled then
  begin
   Case  MsgDlg(Caption, Format(canCloseMsg, [#10,#10,#10]), mtwarning,  [mbYes, mbNo, mbCancel] ,
                                             [YesBtn, NoBtn, CancelBtn])  of
     mrYes: BtnValidClick(Sender) ;
     mrNo: BtnCancelClick(Sender);
     else CloseAction:= caNone;
   end;
   end;
  if (SettingsChanged or ContactsChanged) then SaveConfig(All);
end;


procedure TFContactManager.LoadCfgFile(filename: string);
var
  CfgXML: TXMLDocument;
  RootNode, SettingsNode : TDOMNode;
  winstate: TWindowState;
  i: integer;
begin
  ReadXMLFile(CfgXml, filename);
  RootNode := CfgXML.DocumentElement;
  SettingsNode:= RootNode.FindNode('settings');
  settings.ReadXMLNode(SettingsNode);
  if assigned(CfgXML) then CfgXML.free;
  if Settings.SavSizePos then
  try
    WinState:= TWindowState(StrToInt('$'+Copy(Settings.WState,1,4)));
    if Winstate= wsMinimized then Application.Minimize else WindowState:= WinState;
    Top:= StrToInt('$'+Copy(Settings.WState,5,4));
    Left:= StrToInt('$'+Copy(Settings.WState,9,4));
    Height:= StrToInt('$'+Copy(Settings.WState,13,4));
    Width:= StrToInt('$'+Copy(Settings.WState,17,4)) ;
  except
  end;
  // Détermination de la langue
  LangFile.ReadSections(LangNums);
  if LangNums.Count > 1 then
    For i:= 0 to LangNums.Count-1 do
    begin
      FPrefs.CBLangue.Items.Add (LangFile.ReadString(LangNums.Strings[i],'Language', 'Aucune'));
      If LangNums.Strings[i] = Settings.LangStr then LangFound:= True;
    end;
  // Si la langue n'est pas traduite, alors on passe en Anglais
  If not LangFound then
  //If LangFound then
  begin
    Settings.LangStr:= 'en';
  end;

  Modlangue;
  //Caption:= 'Test';


  SettingsChanged:= false;
  ListeContacts.LoadXMLfile(filename);
end;


function TFContactManager.SaveConfig(typ: TSaveMode): boolean;
var
  CfgXML: TXMLDocument;
  RootNode, ContactsNode, SettingsNode :TDOMNode;
  FilNamWoExt: string;
  i: integer;
begin
  result:= false;
  if FileExists(ConfigFile)then
  begin
    ReadXMLFile(CfgXml, ConfigFile);
    RootNode := CfgXML.DocumentElement;
  end else
  begin
    CfgXML := TXMLDocument.Create;
    RootNode := CfgXML.CreateElement('config');
    CfgXML.Appendchild(RootNode);
  end;
  if (Typ = All) then
  begin
    ContactsNode:= RootNode.FindNode('contacts');
    if ContactsNode <> nil then RootNode.RemoveChild(ContactsNode);
    ContactsNode:= CfgXML.CreateElement('contacts');
    ListeContacts.SaveToXMLnode(ContactsNode);
    RootNode.Appendchild(ContactsNode);
  end;
  if (Typ= Setting) or (Typ = All) then
  begin
    SettingsNode:= RootNode.FindNode('settings');
    if SettingsNode <> nil then RootNode.RemoveChild(SettingsNode);
    SettingsNode:= CfgXML.CreateElement('settings');
    Settings.DataFolder:= ContactMgrAppsData;
    //Settings.LangStr:= LangStr;
    Settings.WState:= '';
    if Top < 0 then Top:= 0;
    if Left < 0 then Left:= 0;
    Settings.WState:= IntToHex(ord(WindowState), 4)+IntToHex(Top, 4)+IntToHex(Left, 4)+IntToHex(Height, 4)+IntToHex(width, 4);
    Settings.SaveXMLnode(SettingsNode);
    RootNode.Appendchild(SettingsNode);
    // On sauvegarde les versions précédentes
    FilNamWoExt:= TrimFileExt(ConfigFile);
    if FileExists (FilNamWoExt+'.bk5')                   // Efface la plus ancienne
    then  DeleteFile(FilNamWoExt+'.bk5');                // si elle existe
    For i:= 4 downto 0
    do if FileExists (FilNamWoExt+'.bk'+IntToStr(i))     // Renomme les précédentes si elles existent
       then  RenameFile(FilNamWoExt+'.bk'+IntToStr(i), FilNamWoExt+'.bk'+IntToStr(i+1));
    if FileExists (ConfigFile)
    then  RenameFile(ConfigFile, FilNamWoExt+'.bk0');
    // Et on sauvegarde la nouvelle config
    writeXMLFile(CfgXML, ConfigFile);
    result:= true;
  end;
end;



procedure TFContactManager.LBContactsSelectionChange(Sender: TObject;
  User: boolean);
begin
  CurIndex:= ListeContacts.GetItem(LBContacts.ItemIndex).Index1 ;
  BtnFirst.enabled:= boolean(LBContacts.ItemIndex);
  BtnPrev.enabled:= BtnFirst.enabled;
  BtnLast.Enabled:= boolean(LBContacts.Count-1-LBContacts.ItemIndex);
  BtnNext.Enabled:= BtnLast.Enabled;
  DisplayContact;
end;

procedure TFContactManager.MnuCopyClick(Sender: TObject);
begin
 Clipboard.AsText := LBContacts.Hint;
end;

procedure TFContactManager.PnlButtonsClick(Sender: TObject);
begin

end;

procedure TFContactManager.PnlInfosClick(Sender: TObject);
begin

end;






procedure TFContactManager.PMnuChooseImgClick(Sender: TObject);
var
  filename: string;
  Image1: TImage;
  rInt: LongInt;
  nimgfile: string;
begin
  if OPictDialog.Execute then
  begin
    filename:= OPictDialog.FileName;
    Image1:= TImage.Create(self);
    Image1.Picture.LoadFromFile(filename);
    ImageFitToSize(Image1, ImgContact.Width, ImgContact.Height);
    Randomize;
    rInt:= random(10000);
    nimgfile:= ContactMgrAppsData+'images'+PathDelim+LowerCase(ListeContacts.GetItem(LBContacts.ItemIndex).Name+Format('%d', [rInt])+'.jpg') ;
    Image1.Picture.SaveToFile( nimgfile);
    ImgContact.Picture.Assign(Image1.Picture.Bitmap);
    LIMageFile.Caption:= nimgfile;

    Image1.Free;
  end;
end;

procedure TFContactManager.PMnuDeleteImgClick(Sender: TObject);
begin
  LImageFile.Caption:= '';
  ImgContact.Picture.Assign(nil);
end;




procedure TFContactManager.PMnuListPopup(Sender: TObject);
var
  s, cname: string;
  i: Integer;
begin
  LBContacts.ItemIndex:= MouseIndex;
  i:= LBContacts.ItemIndex;
  s:= ListeContacts.GetItem(i).Surname;
  if length(s)>0 then s:= s+' ';
  cname:= ListeContacts.GetItem(i).Name;
  if length(cname)>0 then s:= s+cname;
  if length(s)=0 then s:= 'Contact '+IntToStr(i);
  MnuCoord.Caption:= Format(MnuRetrieveGPSCaption, [s]) ;
  MnuLocate.Caption:= Format(MnuLocateCaption, [s]);
  MnuCopy.Caption:= Format(MnuCopyCaption, [s]);
  MnuDelete.Caption:= Format(MnuDeleteCaption, [s]);
  MnuSendmail.Caption:= Format(MnuSendmailCaption, [s]);
  MnuVisitweb.Caption:= Format(MnuVisitwebCaption, [s]);
  MnuSendmail.Enabled:= not(length(ListeContacts.GetItem(i).Email)=0);
  MnuVisitweb.Enabled:= not(length(ListeContacts.GetItem(i).Web)=0);
  CropBitmap(BtnEmail.Glyph, MnuSendMail.Bitmap, BtnEmail.Enabled);
  CropBitmap(BtnWeb.Glyph, MnuVisitweb.Bitmap, BtnWeb.Enabled);
end;




procedure TFContactManager.DisplayList;
var
  i: integer;
  MyContact: TContact;
  s: string;
  ndx: integer;
begin

  ndx:= 0;
  if ListeContacts.Count > 0 then
  begin
    LBContacts.Clear;
    For i:= 0 to ListeContacts.Count-1 do
    begin
      MyContact:= ListeContacts.GetItem(i) ;
      With MyContact do
      begin
        if length(surname) > 0 then
        begin
          if length (name) > 0 then s:= surname+' '+name else s:= surname;
        end else s:= name;
        if index1 = curindex then ndx:= i;        // Repositionner après tri
      end;
      LBContacts.Items.Add(s);
    end;
    LBContacts.ItemIndex:= ndx;
    curindex:= ListeContacts.GetItem(ndx).Index1 ;
    DisplayContact;

  end;
end;

procedure TFContactManager.DisplayContact;
var
  n: integer;
  DecSep: Char;
begin
  SetContactChange(false);
  n:= LBContacts.ItemIndex;
  if (n < 0) and (n > LBContacts.count-1)  then exit;
  DecSep:= DefaultFormatSettings.DecimalSeparator;
  DefaultFormatSettings.DecimalSeparator:= '.';
  EName.text:= ListeContacts.GetItem(n).Name ;
  ESurname.text:= ListeContacts.GetItem(n).Surname;
  EStreet.text:= ListeContacts.GetItem(n).Street;
  EBP.text:= ListeContacts.GetItem(n).BP;
  ELieudit.text:= ListeContacts.GetItem(n).Lieudit;
  EPostcode.text:= ListeContacts.GetItem(n).Postcode ;
  ETown.text:= ListeContacts.GetItem(n).Town;
  ECountry.text:= ListeContacts.GetItem(n).Country;
  EPhone.text:= ListeContacts.GetItem(n).Phone;
  EBox.text:= ListeContacts.GetItem(n).Box;
  EMobile.text:= ListeContacts.GetItem(n).Mobile;
  EAutre.text:= ListeContacts.GetItem(n).Autre;
  EEmail.text:= ListeContacts.GetItem(n).Email;
  BtnEmail.enabled:= Boolean(length(EEMail.text));    // pas de bouton Email si pas d'email !
  EWeb.text:= ListeContacts.GetItem(n).Web;
  BtnWeb.Enabled:=  Boolean(length(EWeb.text));
  ELongitude.text:= FloatToStr(ListeContacts.GetItem(n).Longitude);
  ELatitude.text:= FloatToStr(ListeContacts.GetItem(n).Latitude);
  EDatecreation.text:= DateTimeToStr(ListeContacts.GetItem(n).Date);
  EDatemodif.text:= DateTimeToStr(ListeContacts.GetItem(n).DateModif);
  LIMageFile.Caption:= ListeContacts.GetItem(n).Imagepath;
  try
    ImgContact.Picture.LoadFromFile(ListeContacts.GetItem(n).Imagepath);
    PMnuChooseImg.Visible:= false;
    PMnuChangeImg.Visible:= true;
    PMnuDeleteImg.Visible:= true;
    ImgContact.Hint:= Format(ImgContactHintFull, [#10, ListeContacts.GetItem(n).Imagepath]);
  except
    ImgContact.Picture:= nil;
    PMnuChooseImg.Visible:= true;
    PMnuChangeImg.Visible:= false;
    PMnuDeleteImg.Visible:= false;
    ImgContact.Hint:=  ImgContactHintEmpty;
  end;
  EFonction.text:= ListeContacts.GetItem(n).fonction ;
  ECompany.text:= ListeContacts.GetItem(n).Company;
  EService.text:= ListeContacts.GetItem(n).Service;
  EStreetWk.text:= ListeContacts.GetItem(n).StreetWk;
  EBPWk.text:= ListeContacts.GetItem(n).BPWk;
  ELieuditWk.text:= ListeContacts.GetItem(n).LieuditWk;
  EPostcodeWk.text:= ListeContacts.GetItem(n).PostcodeWk ;
  ETownWk.text:= ListeContacts.GetItem(n).TownWk;
  ECountryWk.text:= ListeContacts.GetItem(n).CountryWk;
  EPhoneWk.text:= ListeContacts.GetItem(n).PhoneWk;
  EBoxWK.text:= ListeContacts.GetItem(n).BoxWk;
  EMobileWk.text:= ListeContacts.GetItem(n).MobileWk;
  EAutreWk.text:= ListeContacts.GetItem(n).AutreWk;
  EEmailWk.text:= ListeContacts.GetItem(n).EmailWk;
  BtnEmailWk.enabled:= Boolean(length(EEmailWk.text));
  EWebWK.text:= ListeContacts.GetItem(n).WebWk;
  BtnWebWk.Enabled:=  Boolean(length(EWebWk.text));
  ELongitudeWk.text:= FloatToStr(ListeContacts.GetItem(n).LongitudeWk);
  ELatitudeWk.text:= FloatToStr(ListeContacts.GetItem(n).LatitudeWk);
  DefaultFormatSettings.DecimalSeparator:= decSep;
  SetContactChange(true);
end;

procedure TFContactManager.BtnQuitClick(Sender: TObject);
begin

  Close;
end ;

procedure TFContactManager.BtnSearchClick(Sender: TObject);
var
  i, ns: Integer;
  fnd: boolean;
  s: string;
begin
  if newsearch then ns:= 0 else ns:= LBContacts.itemindex+1;
  if (ns > LBContacts.Count-1) or (Length(ESearch.Text)=0) then exit;
  For i:= ns to  LBContacts.Count-1 do
  begin
    fnd:= false;
    if rbNone.Checked or RBNameSurname.Checked or RBSurnameName.Checked then s:= UpperCase(ListeContacts.GetItem(i).Name+ListeContacts.GetItem(i).Surname);
    if RBPostcode.Checked or RBTown.Checked then  s:= UpperCase(ListeContacts.GetItem(i).PostCode+ListeContacts.GetItem(i).Town);
    if RBCountry.Checked then s:= UpperCase(ListeContacts.GetItem(i).Country);
    if RBlongit.Checked then s:= UpperCase(FloatToStr(ListeContacts.GetItem(i).Longitude));
    if RBLatit.Checked then s:= UpperCase(FloatToStr(ListeContacts.GetItem(i).Latitude));
    if pos(UpperCase(Esearch.Text), s) > 0 then
      begin
        LBContacts.ItemIndex:= i;
        newsearch:= false;
        fnd:= true;
        break;
    end;
  end;
  if newsearch then MsgDlg(Caption, ESearch.Text+': '+ContactNotFound, mtInformation,  [mbOK] , ['OK'])
  else if (ns>0) and (not(fnd)) then MsgDlg(Caption, ESearch.Text+': '+ContactNoOtherFound, mtInformation,  [mbOK] , ['OK']);
end;

procedure TFContactManager.BtnValidClick(Sender: TObject);
var
  tmpContact: TContact;
begin
  with tmpContact do
  begin
    Name:= EName.text;
    Surname:= ESurname.text;
    Street:= EStreet.text;
    BP:= EBP.text;
    Lieudit:= ELieudit.text;
    Postcode:= EPostcode.text;
    Town:= ETown.text;
    Country:= ECountry.text;
    Phone:= EPhone.text;
    Box:= EBox.text;
    Mobile:= EMobile.text;
    Autre:= EAutre.text;
    Email:= EEmail.text;
    Web:= EWeb.text;
    Longitude:= ListeContacts.GetFloat(ELongitude.text);
    Latitude:= ListeContacts.GetFloat(ELatitude.text);
    Date:=  ListeContacts.GetDate(EDatecreation.text);
    DateModif:= now();
    //image
    fonction:= EFonction.text;
    Company:= ECompany.text;
    Service:= EService.text;;
    StreetWk:= EStreetWk.text;
    BPWk:= EBPWk.text;
    LieuditWk:= ELieuditWk.text;
    PostcodeWk:= EPostcodeWk.text;
    TownWk:= ETownWk.text;
    CountryWk:= ECountryWk.text;
    PhoneWk:= EPhoneWk.text;
    BoxWk:= EBoxWK.text;
    MobileWk:= EMobileWk.text;
    AutreWk:= EAutreWk.text;
    EmailWk:= EEmailWk.text;
    WebWk:= EWebWK.text;
    LongitudeWk:=  ListeContacts.GetFloat(ELongitudeWk.text);
    LatitudeWk:=  ListeContacts.GetFloat(ELatitudeWk.text);
    Index1:= ListeContacts.GetItem(LBContacts.ItemIndex).Index1;
    Comment:= ListeContacts.GetItem(LBContacts.ItemIndex).Comment;
    if LIMageFile.Caption <> ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath then
      begin
       if FileExists(ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath)
       then deletefile(ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath);
    end;
    Imagepath:= LIMageFile.Caption;
  end;
  if NewContact then
  begin
    RestoreButtonStates;
    ListeContacts.AddContact(tmpContact)
  end else ListeContacts.ModifyContact(LBContacts.ItemIndex, tmpContact);
  Esearch.Enabled:= True;
  RBSortClick(Sender);
  DisplayList;
  SetEditState(false);
end;

procedure TFContactManager.BtnWebClick(Sender: TObject);
begin
  OpenURL(ListeContacts.GetItem(LBContacts.ItemIndex).Web);
end;

procedure TFContactManager.SetContactChange(val: Boolean);
var
  i: integer;
begin
  for i:= 0 to PnlPerso.ControlCount- 1 do
    if (PnlPerso.Controls[i] is TEdit) then
      if val then
      begin
        TEdit(PnlPerso.Controls[i]).OnChange:= @EContactChange;
      end else
      begin
        TEdit(PnlPerso.Controls[i]).OnChange:= nil;
        TEdit(PnlPerso.Controls[i]).Color:= clDefault;
      end;
  for i:= 0 to PnlWork.ControlCount- 1 do
    if (PnlWork.Controls[i] is TEdit) then
      if val then
      begin
        TEdit(PnlWork.Controls[i]).OnChange:= @EContactChange;
      end else
      begin
        TEdit(PnlWork.Controls[i]).OnChange:= nil;
        TEdit(PnlWork.Controls[i]).Color:= clDefault;
      end;
      if val then ImgContact.OnPictureChanged:= @EContactChange
      else ImgContact.OnPictureChanged:= nil;
end;

procedure TFContactManager.SaveButtonStates;
var
  i: integer;
  j: integer;
begin
  if CurContChanged then exit;
  j:= 0;
  for i:= 0 to PnlButtons.ControlCount- 1 do
    if (PnlButtons.Controls[i] is TSpeedButton) then
    begin
      ButtonStates[j]:= PnlButtons.Controls[i].Enabled;
      inc (j);
    end;
  CurContChanged:= true;
end;

procedure TFContactManager.RestoreButtonStates;
var
  i: integer;
  j: integer;
begin
  j:= 0;
  for i:= 0 to PnlButtons.ControlCount- 1 do
    if (PnlButtons.Controls[i] is TSpeedButton) then
    begin
      PnlButtons.Controls[i].Enabled:= ButtonStates[j];
      inc (j);
    end;
  CurContChanged:= False;
end;

procedure TFContactManager.DisableButtons;
var
  i: integer;
begin
   for i:= 0 to PnlButtons.ControlCount- 1 do
     if (PnlButtons.Controls[i] is TSpeedButton) then
     begin
       PnlButtons.Controls[i].Enabled:= false;
     end;
end;

procedure TFContactManager.EContactChange(Sender: TObject);
begin
  //PnlImageOld:= ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath;
  SaveButtonStates;
  DisableButtons;
  Esearch.Enabled:= False;
  BtnValid.enabled:= true;
  BtnCancel.Enabled:= true;
  LBContacts.Enabled:= false;
  GBOrder.Enabled:= False;
  TEdit(Sender).Color:= clGradientActiveCaption;
  NewContact:= False;
end;

procedure TFContactManager.ESearchChange(Sender: TObject);
begin
  Newsearch:= true;
end;




procedure TFContactManager.BtnImportClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  FImpex.ImpexContacts:= TContactsList.create;
  Case FImpex.ShowModal of
    // mrOK : Import,
    mrOK : begin
             for i:= 0 to Fimpex.LBImpex.Items.Count-1 do
             begin
               if Fimpex.LBImpex.Selected[i] then ListeContacts.AddContact(Fimpex.ImpexContacts.GetItem(i));
             end;
             if  Fimpex.ImpexSelcount > 1 then s:= CntImportds else s:= CntImportd;
             MsgDlg(Caption, Format(s, [Fimpex.ImpexSelcount, FImpex.CBType.Text]),
                       mtInformation,  [mbOK] , ['OK'], 0);
             ListeContacts.SortType:= SortType;
             DisplayList;
           end;
    // mrYes : Export
    mrYes : begin
              if  Fimpex.ImpexSelcount > 1 then s:= CntExportds else s:= CntEXportd;
              MsgDlg(Caption, Format(s, [Fimpex.ImpexSelcount, FImpex.CBType.Text]),
                       mtInformation,  [mbOK] , ['OK'], 0);
            end;
  end;
  FImpex.ImpexContacts.free;
end;




procedure TFContactManager.BtnLocateClick(Sender: TObject);
var
  smap, stmp: string;
  HTTPCli1: TFPHTTPClient;
  p: integer;
  sstreet, slieu, spost, stown, scountry: string;
begin
  smap:= 'https://www.google.fr/maps/search/';
  // check if perso or work
  if PCtrl1.ActivePage= TSPerso then
  begin
    sstreet:= EStreet.Text;
    slieu:= ELieudit.Text;
    spost:= EPostcode.Text;
    stown:= ETown.Text;
    scountry:= ECountry.Text;
  end else
  begin
    sstreet:= EStreetWk.text;
    slieu:= ELieuditWk.Text;
    spost:= EPostcodeWK.Text;
    stown:= ETownWk.Text;
    scountry:= ECountryWk.Text;
  end;
  if length(sstreet)>0 then smap:= smap+sstreet+'+' else
  begin
    if length(slieu)>0 then smap:= smap+slieu+'+';
  end;
  smap:= smap+',';
  if length(spost)>0 then smap:= smap+spost+'+';
  if length(stown)>0 then smap:= smap+stown;
  if length(scountry)>0 then smap:= smap+','+scountry;
  smap:= StringReplace(smap, ' ','+', [rfReplaceAll] );
  if (TSpeedButton(Sender)=BtnLocate) or (TMenuItem(Sender)=MnuLocate) then OpenURL(smap);
  if (TSpeedButton(Sender)= BtnCoord) or (TMenuItem(Sender)=MnuCoord) then
  begin
    HTTPCli1:= TFPHTTPClient.Create(nil);
    stmp:=HTTPCli1.get(smap);
    HTTPCli1.free;
    // p:= pos('https://www.google.fr/maps/preview/place', stmp);
    // Based on google analysed answer page; no warranty !
    p:= pos('/@', stmp);
    stmp:= copy(stmp, p+2, 30);
    if PCtrl1.ActivePage= TSPerso then
    begin
      ELatitude.Text:= ExtractDelimited(1, stmp, [',']);
      ELongitude.Text:= ExtractDelimited(2, stmp, [',']);
    end else
    begin
      ELatitudeWk.Text:= ExtractDelimited(1, stmp, [',']);
      ELongitudeWk.Text:= ExtractDelimited(2, stmp, [',']);
    end;
  end;
end;

procedure TFContactManager.BtnDeleteClick(Sender: TObject);
var
  imgfile: string;
begin
  If MsgDlg(Caption, Format(ConfirmDeleteContact,
            [ListeContacts.GetItem(LBContacts.ItemIndex).Name+' '+ListeContacts.GetItem(LBContacts.ItemIndex).Surname]),
             mtWarning, mbYesNo, [YesBtn, NoBtn],0) = mrYes then
  begin
    if (LBContacts.ItemIndex >= 0) and (LBContacts.ItemIndex < LBContacts.Count) then
    begin
      imgfile:= ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath;
      if Fileexists(imgfile) then DeleteFile(imgfile);
      ListeContacts.Delete(LBContacts.ItemIndex);

    end;
    DisplayList;
  end;
end;

procedure TFContactManager.BtnEmailClick(Sender: TObject);
begin
  OpenURL('mailto:'+ListeContacts.GetItem(LBContacts.ItemIndex).Email+'?subject='+MailSubject+'&body='+MailSubject);
end;


procedure TFContactManager.SetEditState(val: boolean);
begin
  SetContactChange(val);
  DisplayContact;
  SetContactChange(not val);
  RestoreButtonStates;
  LBContacts.Enabled:= not val;
  GBOrder.Enabled:= not val;
  Esearch.Enabled:= not val;
  NewContact:= val;

end;

procedure TFContactManager.BtnCancelClick(Sender: TObject);
begin
  if LIMageFile.Caption <> ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath then
  begin
    if fileexists(LImageFile.Caption) then deletefile(LImageFile.Caption);
    LIMageFile.Caption:= ListeContacts.GetItem(LBContacts.ItemIndex).Imagepath;
  end;
  SetEditState(false);
end;





procedure TFContactManager.BtnAddClick(Sender: TObject);
begin
  SetContactChange(false);
  EName.text:= '' ;
  ESurname.text:= '';
  EStreet.text:= '';
  EBP.text:= '';
  ELieudit.text:= '';
  EPostcode.text:= '' ;
  ETown.text:= '';
  ECountry.text:= '';
  EPhone.text:= '';
  EBox.text:= '';
  EMobile.text:= '';
  EAutre.text:= '';
  EEmail.text:= '';
  BtnEmail.enabled:= Boolean(length(EEMail.text));    // pas de bouton Email si pas d'email !
  EWeb.text:= '';
  BtnWeb.Enabled:=  Boolean(length(EWeb.text));
  ELongitude.text:= '';
  ELatitude.text:= '';
  EDatecreation.text:= DateTimeToStr(now);
  EDatemodif.text:= DateTimeToStr(now);
  ImgContact.Picture:= nil;
  EFonction.text:= '' ;
  ECompany.text:= '';
  EService.text:= '';
  EStreetWk.text:= '';
  EBPWk.text:= '';
  ELieuditWk.text:= '';
  EPostcodeWk.text:= '' ;
  ETownWk.text:= '';
  ECountryWk.text:= '';
  EPhoneWk.text:= '';
  EBoxWK.text:= '';
  EMobileWk.text:= '';
  EAutreWk.text:= '';
  EEmailWk.text:= '';
  BtnEmailWk.enabled:= Boolean(length(EEmailWk.text));
  EWebWK.text:= '';
  BtnWebWk.Enabled:=  Boolean(length(EWebWk.text));
  ELongitudeWk.text:= '';
  ELatitudeWk.text:= '';
  //SetContactChange(true);
  NewContact:= True;
  SaveButtonStates;
  DisableButtons;
  BtnValid.enabled:= true;
  BtnCancel.Enabled:= true;
  LBContacts.Enabled:= false;
  GBOrder.Enabled:= False;
  Esearch.Enabled:= False;
end;

procedure TFContactManager.BtnAboutClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TFContactManager.BtnNavClick(Sender: TObject);
begin
  if (TSpeedButton(sender) = BtnNext) and (LBContacts.ItemIndex < LBContacts.Count-1)
  then LBContacts.ItemIndex:= LBContacts.ItemIndex+1;
  if (TSpeedButton(sender) = BtnPrev) and (LBContacts.ItemIndex > 0)
  then LBContacts.ItemIndex:= LBContacts.ItemIndex-1;
  if (TSpeedButton(sender) = BtnFirst) and (LBContacts.ItemIndex > 0)
  then LBContacts.ItemIndex:= 0;
  if (TSpeedButton(sender) = BtnLast) and (LBContacts.ItemIndex  < LBContacts.Count-1)
  then LBContacts.ItemIndex:= LBContacts.Count-1;
end;

procedure TFContactManager.BtnPrefsClick(Sender: TObject);
var
  oldndx: integer;
begin
  Fprefs.Edatafolder.Text:= ContactMgrAppsData;
  Fprefs.CBStartup.Checked:= Settings.StartWin;
  Fprefs.CBSavePos.checked:= Settings.SavSizePos;
  Fprefs.CBMinimized.Checked:= Settings.StartMini;
  Fprefs.CBUpdate.checked:= Settings.NoChkNewVer;
  FPrefs.CBLangue.ItemIndex:= LangNums.IndexOf(Settings.LangStr);
  oldndx:=  FPrefs.CBLangue.ItemIndex;

  if FPrefs.ShowModal = mrOK then
  begin
    Settings.StartWin:= Fprefs.CBStartup.Checked ;
    Settings.SavSizePos:= Fprefs.CBSavePos.checked;
    Settings.StartMini:= Fprefs.CBMinimized.Checked;
    Settings.NoChkNewVer:= Fprefs.CBUpdate.checked;
    Settings.LangStr:= LangNums.Strings[FPrefs.CBLangue.ItemIndex];
    if FPrefs.CBLangue.ItemIndex <> oldndx then ModLangue;
    DisplayContact;                                // Needed to change language on hints
  end;
end;

// Remplace les onglets par des panels colorés
procedure TFContactManager.PPersoClick(Sender: TObject);
begin
  PCtrl1.ActivePage:= TSPerso;
  PWork.Color:= clDefault;
  PPerso.color:=  clGradientActiveCaption;
end;

procedure TFContactManager.PWorkClick(Sender: TObject);
begin
  PCtrl1.ActivePage:= TSWork;
  PPerso.color:= clDefault;
  PWork.color:= clGradientActiveCaption;

end;



procedure TFContactManager.RBSortClick(Sender: TObject);
begin
  if TRadioButton(Sender) = RBNameSurname then ListeContacts.SortType:= cdcName;
  if TRadioButton(Sender) = RBSurnameName then ListeContacts.SortType:= cdcSurname;
  if TRadioButton(Sender) = RBPostcode then ListeContacts.SortType:= cdcPostcode;
  if TRadioButton(Sender) = RBTown then ListeContacts.SortType:= cdcTown;
  if TRadioButton(Sender) = RBCountry then ListeContacts.SortType:= cdcCountry;
  if TRadioButton(Sender) = RBlongit then ListeContacts.SortType:= cdcLongit;
  if TRadioButton(Sender) = RBlatit then ListeContacts.SortType:= cdcLatit;
  DisplayList;
end;

procedure TFContactManager.SettingsOnChange(sender: TObject);
begin
  SettingsChanged:= true;
end;

procedure TFContactManager.SettingsOnStateChange(sender: TObject);
begin
  SettingsChanged:= true;
end;

procedure TFContactManager.ContactsOnChange(sender: TObject);
begin
  ContactsChanged:= true;
end;

// To be called in form activation routine
procedure TFContactManager.ModLangue ;
const
  dquot='"';     // Double quote
  dquotv='","';   // Double cote  plus comma plus double quote
begin
  With LangFile do
  begin
    //Main Form
    Caption:= ReadString(Settings.LangStr, 'Caption', 'Gestionnaire de Contacts');
    // Components
    YesBtn:= ReadString(Settings.LangStr, 'YesBtn', 'Oui');
    NoBtn:= ReadString(Settings.LangStr, 'NoBtn', 'Non');
    CancelBtn:=ReadString(Settings.LangStr, 'CancelBtn', 'Annuler');
    Aboutbox.Caption:= ReadString(Settings.LangStr, 'Aboutbox.Caption', 'A propos du Gestionnaire de Contacts');
    AboutBox.LUpdate.Caption:= ReadString(Settings.LangStr, 'AboutBox.LUpdate.Caption', 'Recherche de mise à jour');
    AboutBox.UrlUpdate:= Format(BaseUpdateURl, [Version, Settings.LangStr]);
    PPerso.Caption:= ReadString(Settings.LangStr, 'PPerso.Caption', PPerso.Caption);
    PWork.Caption:= ReadString(Settings.LangStr, 'PWork.Caption', PWork.Caption);
    GBOrder.Caption:= ReadString(Settings.LangStr, 'GBOrder.Caption', GBOrder.Caption);
    RBNone.Caption:= ReadString(Settings.LangStr, 'RBNone.Caption', RBNone.Caption);
    RBTown.Caption:= ReadString(Settings.LangStr, 'RBTown.Caption', RBTown.Caption);
    RBNameSurname.Caption:= ReadString(Settings.LangStr, 'RBNameSurname.Caption', RBNameSurname.Caption);
    RBCountry.Caption:= ReadString(Settings.LangStr, 'RBCountry.Caption', RBCountry.Caption);
    RBSurnameName.Caption:= ReadString(Settings.LangStr, 'RBSurnameName.Caption', RBSurnameName.Caption);
    RBPostcode.Caption:= ReadString(Settings.LangStr, 'RBPostcode.Caption', RBPostcode.Caption);
    RBlongit.Caption:= ReadString(Settings.LangStr, 'RBlongit.Caption', RBlongit.Caption);
    RBLatit.Caption:= ReadString(Settings.LangStr, 'RBLatit.Caption', RBLatit.Caption);
    BtnImport.Hint:= ReadString(Settings.LangStr, 'BtnImport.Hint', BtnImport.Hint);
    BtnFirst.Hint:= ReadString(Settings.LangStr, 'BtnFirst.Hint', BtnFirst.Hint);
    BtnPrev.Hint:= ReadString(Settings.LangStr, 'BtnPrev.Hint', BtnPrev.Hint);
    BtnNext.Hint:= ReadString(Settings.LangStr, 'BtnNext.Hint', BtnNext.Hint);
    BtnLast.Hint:= ReadString(Settings.LangStr, 'BtnLast.Hint', BtnLast.Hint);
    BtnDelete.Hint:= ReadString(Settings.LangStr, 'BtnDelete.Hint', BtnDelete.Hint);
    BtnAdd.Hint:= ReadString(Settings.LangStr, 'BtnAdd.Hint', BtnAdd.Hint);
    BtnValid.Hint:= ReadString(Settings.LangStr, 'BtnValid.Hint', BtnValid.Hint);
    BtnCancel.Hint:= ReadString(Settings.LangStr, 'BtnCancel.Hint', BtnCancel.Hint);
    BtnCoord.Hint:= ReadString(Settings.LangStr, 'BtnCoord.Hint', BtnCoord.Hint);
    BtnLocate.Hint:= ReadString(Settings.LangStr, 'BtnLocate.Hint', BtnLocate.Hint);
    BtnPrefs.Hint:= ReadString(Settings.LangStr, 'BtnPrefs.Hint', BtnPrefs.Hint);
    BtnAbout.Hint:= ReadString(Settings.LangStr, 'BtnAbout.Hint', BtnAbout.Hint);
    BtnQuit.Hint:= ReadString(Settings.LangStr, 'BtnQuit.Hint', BtnQuit.Hint);
    BtnSearch.Hint:= ReadString(Settings.LangStr, 'BtnSearch.Hint', BtnSearch.Hint);
    LName.Caption:= ReadString(Settings.LangStr, 'LName.Caption', LName.Caption);
    LSurname.Caption:= ReadString(Settings.LangStr, 'LSurname.Caption', LSurname.Caption);
    LStreet.Caption:= ReadString(Settings.LangStr, 'LStreet.Caption', LStreet.Caption);
    BPCaption:= ReadString(Settings.LangStr, 'BPCaption', 'BP');
    LieuditCaption:= ReadString(Settings.LangStr, 'LieuditCaption', 'Lieudit');
    LBP.Caption:= BPCaption+', '+LieuditCaption;
    CPCaption:= ReadString(Settings.LangStr, 'CPCaption', 'CP');
    TownCaption:= ReadString(Settings.LangStr, 'TownCaption', 'Ville');
    LCP.Caption:= CPCaption+', '+TownCaption;
    LCountry.Caption:= ReadString(Settings.LangStr, 'LCountry.Caption', LCountry.Caption);
    LPhone.Caption:= ReadString(Settings.LangStr, 'LPhone.Caption', LPhone.Caption);
    LBox.Caption:= ReadString(Settings.LangStr, 'LBox.Caption', LBox.Caption);
    LMobile.Caption:= ReadString(Settings.LangStr, 'LMobile.Caption', LMobile.Caption);
    LAutre.Caption:= ReadString(Settings.LangStr, 'LAutre.Caption', LAutre.Caption);
    LEmail.Caption:= ReadString(Settings.LangStr, 'LEmail.Caption', LEmail.Caption);
    LWeb.Caption:= ReadString(Settings.LangStr, 'LWeb.Caption', LWeb.Caption);
    LLongitude.Caption:= ReadString(Settings.LangStr, 'LLongitude.Caption', LLongitude.Caption);
    LLatitude.Caption:= ReadString(Settings.LangStr, 'LLatitude.Caption', LLatitude.Caption);
    LDateCre.Caption:= ReadString(Settings.LangStr, 'LDateCre.Caption', LDateCre.Caption);
    LDatemodif.Caption:= ReadString(Settings.LangStr, 'LDatemodif.Caption', LDatemodif.Caption);
    CommentCaption:= ReadString(Settings.LangStr, 'CommentCaption', 'Commentaire');
    ImageFileCaption:= ReadString(Settings.LangStr, 'ImageFileCaption', 'Fichier image');
    LFonction.Caption:= ReadString(Settings.LangStr, 'LFonction.Caption', LFonction.Caption);
    LCompany.Caption:= ReadString(Settings.LangStr, 'LCompany.Caption', LCompany.Caption);
    LStreetWk.Caption:= ReadString(Settings.LangStr, 'LStreetWk.Caption', LStreetWk.Caption);
    BPWkCaption:= ReadString(Settings.LangStr, 'BPWkCaption', 'BP Pro');
    LieuditWkCaption:= ReadString(Settings.LangStr, 'LieuditWkCaption', 'Lieudit pro');
    LBPWk.Caption:= BPWkCaption+', '+LieuditWkCaption;
    CPWkCaption:= ReadString(Settings.LangStr, 'CPWkCaption', 'CP pro');
    TownWkCaption:= ReadString(Settings.LangStr, 'TownWkCaption', 'Ville pro');
    LCP.Caption:= CPWkCaption+', '+TownWkCaption;
    LCountryWk.Caption:= ReadString(Settings.LangStr, 'LCountryWk.Caption', LCountryWk.Caption);
    LPhoneWk.Caption:= ReadString(Settings.LangStr, 'LPhoneWk.Caption', LPhoneWk.Caption);
    LBoxWk.Caption:= ReadString(Settings.LangStr, 'LBoxWk.Caption', LBoxWk.Caption);
    LMobileWk.Caption:= ReadString(Settings.LangStr, 'LMobileWk.Caption', LMobileWk.Caption);
    LAutreWk.Caption:= ReadString(Settings.LangStr, 'LAutreWk.Caption', LAutreWk.Caption);
    LEmailWk.Caption:= ReadString(Settings.LangStr, 'LEmailWk.Caption', LEmailWk.Caption);
    LWebWk.Caption:= ReadString(Settings.LangStr, 'LWebWk.Caption', LWebWk.Caption);
    LLongitudeWk.Caption:= ReadString(Settings.LangStr, 'LLongitudeWk.Caption', LLongitudeWk.Caption);
    LLatitudeWk.Caption:= ReadString(Settings.LangStr, 'LLatitudeWk.Caption', LLatitudeWk.Caption);
    ImgContactHintEmpty:= ReadString(Settings.LangStr, 'ImgContactHintEmpty', 'Cliquez avec le bouton droit de la souris pour ajouter une image');
    ImgContactHintFull:= ReadString(Settings.LangStr, 'ImgContactHintFull',
                                'Cliquez avec le bouton droit de la souris pour changer ou supprimer cette image%sFichier image: %s');
    OPictDialog.Title:= ReadString(Settings.LangStr, 'OPictDialog.Title', OPictDialog.Title);
    ContactNotFound:= ReadString(Settings.LangStr, 'ContactNotFound', 'Pas de contact trouvé');
    ContactNoOtherFound:= ReadString(Settings.LangStr, 'ContactNoOtherFound', 'Pas d''autre contact trouvé');
    CntImportd:= ReadString(Settings.LangStr, 'CntImportd', '%d contact %s importé ');
    CntExportd:= ReadString(Settings.LangStr, 'CntExportd', '%d contact %s exporté');
    CntImportds:= ReadString(Settings.LangStr, 'CntImportds', '%d contacts %s importés ');
    CntExportds:= ReadString(Settings.LangStr, 'CntExportds', '%d contacts %s exportés');
    MailSubject:= ReadString(Settings.LangStr, 'MailSubject', 'Courrier du gestionnaire de contacts');
    ConfirmDeleteContact:=ReadString(Settings.LangStr, 'ConfirmDeleteContact', 'Voulez-vous vraiment supprimer le contact %s ?');
    CanCloseMsg:= ReadString(Settings.LangStr, 'CanCloseMsg', 'Une modification est en cours.%s'+
                     'Pour la valider et quitter, cliquez sur le bouton "Oui".%s'+
                     'Pour l''annuler et quitter, cliquer sur le bouton "Non".%s'+
                     'Pour revenir au programme, cliquer sur le bouton "Annuler".');
    // Settings
    FPrefs.Caption:= ReadString(Settings.LangStr, 'FPrefs.Caption', FPrefs.Caption);
    FPrefs.GroupBox1.Caption:= ReadString(Settings.LangStr, 'FPrefs.GroupBox1.Caption', FPrefs.GroupBox1.Caption);
    FPrefs.LDataFolder.Caption:= ReadString(Settings.LangStr, 'FPrefs.LDataFolder.Caption', FPrefs.LDataFolder.Caption);
    FPrefs.CBStartup.Caption:= ReadString(Settings.LangStr, 'FPrefs.CBStartup.Caption', FPrefs.CBStartup.Caption);
    FPrefs.CBMinimized.Caption:= ReadString(Settings.LangStr, 'FPrefs.CBMinimized.Caption', FPrefs.CBMinimized.Caption);
    FPrefs.CBSavePos.Caption:= ReadString(Settings.LangStr, 'FPrefs.CBSavePos.Caption', FPrefs.CBSavePos.Caption);
    FPrefs.CBUpdate.Caption:= ReadString(Settings.LangStr, 'FPrefs.CBUpdate.Caption', FPrefs.CBUpdate.Caption);
    FPrefs.LLangue.Caption:= ReadString(Settings.LangStr, 'FPrefs.LLangue.Caption', FPrefs.LLangue.Caption);
    FPrefs.BtnCancel.Caption:= CancelBtn;
    // Import/export
    FImpex.Caption:= ReadString(Settings.LangStr, 'FImpex.Caption', FImpex.Caption);
    FImpex.RBImport.Caption:= ReadString(Settings.LangStr, 'FImpex.RBImport.Caption', FImpex.RBImport.Caption);
    Fimpex.RBExport.Caption:= ReadString(Settings.LangStr, 'Fimpex.RBExport.Caption', Fimpex.RBExport.Caption);
    FImpex.LSepar.Caption:= ReadString(Settings.LangStr, 'FImpex.LSepar.Caption', FImpex.LSepar.Caption);
    FImpex.LDelim.Caption:= ReadString(Settings.LangStr, 'FImpex.LDelim.Caption', FImpex.LDelim.Caption);
    FImpex.LFilename.Caption:= ReadString(Settings.LangStr, 'FImpex.LFilename.Caption', FImpex.LFilename.Caption);
    FImpex.LCode.Caption:= ReadString(Settings.LangStr, 'FImpex.LCode.Caption', FImpex.LCode.Caption);
    FImpex.SGImpex.Columns[0].Title.Caption:= ReadString(Settings.LangStr, 'FImpex.SGImpex.Col0.Title', FImpex.SGImpex.Columns[0].Title.Caption);
    FImpex.SGImpex.Columns[1].Title.Caption:= ReadString(Settings.LangStr, 'FImpex.SGImpex.Col1.Title', FImpex.SGImpex.Columns[1].Title.Caption);
    FImpex.OD1.Title:= ReadString(Settings.LangStr, 'FImpex.OD1.Title', FImpex.OD1.Title);
    FImpex.SD1.Title:= ReadString(Settings.LangStr, 'FImpex.SD1.Title', FImpex.SD1.Title);
    FImpex_ImportBtn_Caption:= ReadString(Settings.LangStr, 'FImpex.ImportBtn.Caption', 'Importation');
    FImpex_ExportBtn_Caption:= ReadString(Settings.LangStr, 'FImpex.ExportBtn.Caption', 'Exportation');
    FImpex.BtnCancel.Caption:= FPrefs.BtnCancel.Caption;
    // popup menus
    MnuRetrieveGPSCaption:= ReadString(Settings.LangStr, 'MnuRetrieveGPSCaption', 'Récupérer les données GPS de %s');
    MnuLocateCaption:= ReadString(Settings.LangStr, 'MnuLocateCaption', 'Localiser %s sur une carte');
    MnuCopyCaption:= ReadString(Settings.LangStr, 'MnuCopyCaption', 'Copier les données de %s');
    MnuDeleteCaption:= ReadString(Settings.LangStr, 'MnuDeleteCaption', 'Supprimer le contact %s');
    MnuSendmailCaption:= ReadString(Settings.LangStr, 'MnuSendmail', 'Envoyer un courriel personnel à %s');
    MnuVisitwebCaption:= ReadString(Settings.LangStr, 'MnuVisitwebCaption', 'Visister le site Web personnel de %s');
    PMnuChooseImg.Caption:= ReadString(Settings.LangStr, 'PMnuChoose.Caption', PMnuChooseImg.Caption);
    PMnuChangeImg.Caption:= ReadString(Settings.LangStr, 'PMnuChange.Caption', PMnuChangeImg.Caption);
    PMnuDeleteImg.Caption:= ReadString(Settings.LangStr, 'PMnuDelete.Caption', PMnuDeleteImg.Caption);

    // Translate header of csv export
    csvheader:= dquot+LName.Caption+dquotv+LSurname.Caption+dquotv+LStreet.Caption+dquotv+BPCaption+dquotv+
                LieuditCaption+dquotv+CPCaption+dquotv+TownCaption+dquotv+LCountry.Caption+dquotv+LPhone.Caption+dquotv+
                LBox.Caption+dquotv+LMobile.Caption+dquotv+LAutre.Caption+dquotv+LEmail.Caption+dquotv+
                LWeb.Caption+dquotv+LLongitude.Caption+dquotv+LLatitude.Caption+dquotv+LDateCre.Caption+dquotv+
                LDateModif.Caption+dquotv+CommentCaption+dquotv+ImageFileCaption+dquotv+LFonction.Caption+dquotv+
                LService.Caption+dquotv+LCompany.Caption+dquotv+LStreetWk.Caption+dquotv+BPWkCaption+dquotv+
                LieuditWkCaption+dquotv+CPWkCaption+dquotv+TownWkCaption+dquotv+LCountryWk.Caption+dquotv+
                LPhoneWk.Caption+dquotv+LBoxWk.Caption+dquotv+LMobileWk.Caption+dquotv+LAutreWk.Caption+dquotv+
                LEmailWk.Caption+dquotv+LWebWk.Caption+dquotv+LLongitudeWk.Caption+dquotv+LLatitudeWk.Caption+dquot;

  end;
end;

end.

