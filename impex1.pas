unit impex1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, Grids, contacts1, laz2_DOM , laz2_XMLRead, csvdocument, lazbbutils, math, FileUtil, base64;

type

  { TFImpex }

  TFImpex = class(TForm)
    BtnCancel: TButton;
    BtnImpex: TButton;
    BtnUp: TButton;
    BtnEmpty: TButton;
    BtnDown: TButton;
    CBType: TComboBox;
    CBCode: TComboBox;
    CBFirstline: TCheckBox;
    EDelim: TEdit;
    EFilename: TEdit;
    ESepar: TEdit;
    LCode: TLabel;
    LDelim: TLabel;
    LFilename: TLabel;
    LBImpex: TListBox;
    LSepar: TLabel;
    OD1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    PnlTop: TPanel;
    RBExport: TRadioButton;
    RBImport: TRadioButton;
    SD1: TSaveDialog;
    SBFileOpen: TSpeedButton;
    SGImpex: TStringGrid;
    procedure BtnDownClick(Sender: TObject);
    procedure BtnEmptyClick(Sender: TObject);
    procedure BtnImpexClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure CBTypeChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure LBImpexClick(Sender: TObject);
    procedure RBImpexChange(Sender: TObject);
    procedure SBFileOpenClick(Sender: TObject);
    procedure SGImpexSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);

  private
    csvheaderdoc: TCSVDocument;
    csvsheadercount: Integer;
    ContactFldArray: Array of Integer;
    csvdoc: TCSVDocument;
    csvfldcount: Integer;
    Vcards: TContactsList;
    DecSep: Char;
    BtnImpexEnabled: boolean;
    function getcsvstring(doc: TCSVDocument; fld, ndx: integer) : string;
    function getcsvfloat(doc: TCSVDocument; fld, ndx: integer) : Float;
    function getcsvdate(doc: TCSVDocument; fld, ndx: integer) : TDateTime;
  public
    ImpexContacts: TContactsList;
    ImpexSelcount: integer;
  end;

var
  FImpex: TFImpex;

implementation

{$R *.lfm}

uses contactmgr1;

{ TFImpex }

procedure TFImpex.FormActivate(Sender: TObject);

begin
  DecSep:= DefaultFormatSettings.DecimalSeparator; ;
  LSepar.Enabled:= not Boolean(CBType.ItemIndex);
  ESepar.Enabled:= LSepar.Enabled;
  LDelim.Enabled:= LSepar.Enabled;
  EDelim.Enabled:= LSepar.Enabled;
  SBFileOpen.Glyph.LoadFromResourceName(HINSTANCE, 'fileopen');
  // Contact fields
  csvheaderdoc:= TCSVDocument.Create;
  csvheaderdoc.Delimiter:=',';
  with FContactManager do
  begin
    csvheaderdoc.CSVText:= csvheader;
    BtnImpex.Caption:= FImpex_ImportBtn_Caption;
  end;
  csvsheadercount:= csvheaderdoc.ColCount[0];
  csvdoc:= TCSVDocument.Create;
  // // mrOK : Import, mrYes : Export
  BtnImpex.ModalResult:= mrOK;
  BtnImpex.Enabled:= false;
  BtnUp.Enabled:= false;
  BtnEmpty.Enabled:= False;
  BtnDown.Enabled:= false;;
  EFilename.text:= '';
  LBIMpex.Clear;
  SGImpex.Clear;
  RBImpexChange(Sender);
end;

procedure TFImpex.FormDeactivate(Sender: TObject);
begin
  FreeAndNil(csvheaderdoc);
  FreeAndNil(csvdoc);
end;

procedure TFImpex.LBImpexClick(Sender: TObject);
var
  curline: integer;
  i: integer;
begin
  curline:= LBImpex.ItemIndex;
  if BtnImpexEnabled then BtnImpex.Enabled:= true;
  if RBImport.checked then
  begin
    DecSep:= DefaultFormatSettings.DecimalSeparator;
    DefaultFormatSettings.DecimalSeparator:= '.';
    Case CBType.ItemIndex of
      0: begin
           for i:= 1 to csvfldcount do
           begin
             sgImpex.Cells[1,i]:= IsAnsi2Utf8(csvdoc.Cells[ContactFldArray[i-1],curline]);
            end;

         end;
      2: begin
           sgImpex.Cells[1,1]:= Vcards.GetItem(curline).name;
           sgImpex.Cells[1,2]:= Vcards.GetItem(curline).surname;
           sgImpex.Cells[1,3]:= Vcards.GetItem(curline).street;
           sgImpex.Cells[1,4]:= Vcards.GetItem(curline).BP;
           sgImpex.Cells[1,5]:= Vcards.GetItem(curline).lieudit;
           sgImpex.Cells[1,6]:= Vcards.GetItem(curline).postcode;
           sgImpex.Cells[1,7]:= Vcards.GetItem(curline).town;
           sgImpex.Cells[1,8]:= Vcards.GetItem(curline).country;
           sgImpex.Cells[1,9]:= Vcards.GetItem(curline).phone;
           // 10:Box
           sgImpex.Cells[1,11]:= Vcards.GetItem(curline).mobile;
           // 12: Autre tél.
           sgImpex.Cells[1,13]:= Vcards.GetItem(curline).email;
           sgImpex.Cells[1,14]:= Vcards.GetItem(curline).web;
           sgImpex.Cells[1,15]:= FloatToStr(Vcards.GetItem(curline).Longitude);
           sgImpex.Cells[1,16]:= FloatToStr(Vcards.GetItem(curline).Latitude);
           sgImpex.Cells[1,17]:= DateToStr(Vcards.GetItem(curline).Date);
           sgImpex.Cells[1,18]:= DateToStr(Vcards.GetItem(curline).DateModif);

           sgImpex.Cells[1,24]:= Vcards.GetItem(curline).StreetWk;
           sgImpex.Cells[1,25]:= Vcards.GetItem(curline).BPWk;
           sgImpex.Cells[1,26]:= Vcards.GetItem(curline).LieuditWk;
           sgImpex.Cells[1,27]:= Vcards.GetItem(curline).PostcodeWk;
           sgImpex.Cells[1,28]:= Vcards.GetItem(curline).TownWk;
           sgImpex.Cells[1,29]:= Vcards.GetItem(curline).CountryWk;
           sgImpex.Cells[1,30]:= Vcards.GetItem(curline).PhoneWk;
           // 31: Box
           sgImpex.Cells[1,32]:= Vcards.GetItem(curline).MobileWk;
           // 33 : Autre tél
           sgImpex.Cells[1,34]:= Vcards.GetItem(curline).EmailWk;
           sgImpex.Cells[1,35]:= Vcards.GetItem(curline).WebWk;
           sgImpex.Cells[1,36]:= FloatToStr(Vcards.GetItem(curline).LongitudeWk);
           sgImpex.Cells[1,37]:= FloatToStr(Vcards.GetItem(curline).LatitudeWk);
         end;
    end;
    DefaultFormatSettings.DecimalSeparator:= decSep;
  end;
end;

procedure TFImpex.RBImpexChange(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  ESepar.Enabled:= RBExport.Checked;
  Edelim.Enabled:= RBExport.Checked;
  CBCode.Enabled:= RBExport.Checked;
  LBImpex.Clear;
  SGImpex.Clear;
  BtnImpexEnabled:= false;;
  if RBImport.Checked then
  begin
    SBFileOpen.Glyph.LoadFromResourceName(HINSTANCE, 'fileopen');
    BtnImpex.Caption:= FContactManager.FImpex_ImportBtn_Caption;
    BtnImpex.ModalResult:= mrOK;              // Import
    CBType.Items.Text:='CSV'+#10+'Contacts'+#10+'vCard';
    CBType.ItemIndex:=0;
    CBCode.ItemIndex:=0;
  end else
  begin
    SBFileOpen.Glyph.LoadFromResourceName(HINSTANCE, 'filesave')  ;
    BtnImpex.Caption:= FContactManager.FImpex_ExportBtn_Caption;
    BtnImpex.ModalResult:= mrYes;            // Export
    // populate list
    For i:= 0 to FContactManager.ListeContacts.Count-1 do
    begin
      s:= FContactManager.ListeContacts.GetItem(i).Surname;
      if length(s)>0 then s:= s+' ';
      s:= s+ FContactManager.ListeContacts.GetItem(i).Name;
      LBImpex.Items.Add(s);
     end;
    CBType.Items.Text:='CSV'+#10+'vCard';
    CBType.ItemIndex:=0;
    CBCode.ItemIndex:=0;
  end;
end;

procedure TFImpex.SBFileOpenClick(Sender: TObject);
var
  xmlContacts: TXMLDocument;
  RootNode: TDomNode;
  ContactsNode: TDOMNode;
  i: integer;
  MyContact: TContact;
  s: string;
  //csvstream: TStringStream;
  //csvtext: string;
  chrset: TCharSet;

begin
  if RBImport.Checked then
  begin
    SetLength(ContactFldArray, csvsheadercount);
        // Set filters in open file dialog
    Case CBType.ItemIndex of
        0: OD1.filter:= 'CSV|*.csv;*.txt';         // Import CSV file
        1: OD1.filter:= 'Contacts|*.xml';         // Import old contacts
        2: OD1.filter:= 'vCard|*.vcf';
    end;
    if not OD1.Execute then exit;  //avoid exception
    EFilename.text:= OD1.FileName;
    sgImpex.RowCount:= csvsheadercount+1;
    for i:= 1 to csvsheadercount do
      begin
        sgImpex.Cells[0,i]:= csvheaderdoc.Cells[i-1,0];
      end;
      Case CBType.ItemIndex of
        // Import CSV file
        0: begin
           // Display contact header
           {sgImpex.RowCount:= csvsheadercount+1;
           for i:= 1 to csvsheadercount do
           begin
             sgImpex.Cells[0,i]:= csvheaderdoc.Cells[i-1,0];
           end;   }
           // Display imported headers or first record
           //csvdoc:= TCSVDocument.Create;
           csvdoc.LoadFromFile(EFilename.text);
           CBCode.Items.Clear;
           for i:= 0 to length(CharSetArray)-1 do CBCode.Items[i]:= CharSetArray [i];
           Chrset:= Charset(csvdoc.CSVText);
           CBCode.ItemIndex:= Ord(Chrset);
           csvfldcount:= csvdoc.ColCount[0];
           SetLength(ContactFldArray, csvsheadercount);
           if csvfldcount > csvsheadercount then
           begin
             sgImpex.RowCount:= csvfldcount+1;
             SetLength(ContactFldArray, csvfldcount);
           end ;
           for i:= 1 to csvfldcount do
           begin
             sgImpex.Cells[1,i]:= IsAnsi2Utf8(csvdoc.Cells[i-1,0]);
             ContactFldArray[i-1]:= i-1;
           end;
           LBImpex.Clear;
           For i:= 0 to csvdoc.RowCount-1 do
           begin
             LBImpex.Items.Add(IsAnsi2Utf8(csvdoc.Cells[1, i]));
           end;
           BtnImpexEnabled:= true;
           if LBImpex.SelCount > 0 then BtnImpex.Enabled:= true;
           BtnUp.Enabled:= true;
           BtnEmpty.Enabled:= true;
           BtnDown.Enabled:= true;

         end ;            //CSV
        // Import Contact file (java or new version)
        1: if Assigned(ImpexContacts) then
         begin
           ReadXMLFile(xmlContacts, OD1.FileName);
           RootNode:= xmlContacts.DocumentElement;
           ContactsNode:= RootNode;
           if UpperCase(RootNode.NodeName) <> 'CONTACTS' then  // not jcontacts
           begin
             ContactsNode:= RootNode.FindNode('contacts');     // New contacts file
           end;
           ImpexContacts.LoadXMLNode(ContactsNode);
           LBImpex.Clear;
           if ImpexContacts.Count = 0 then exit;
           For i:= 0 to ImpexContacts.Count-1 do
           begin
             MyContact:= ImpexContacts.GetItem(i) ;
             With MyContact do
             begin
               if length(surname) > 0 then
               begin
                 if length (name) > 0 then s:= surname+' '+name else s:= surname;
               end else s:= name;
             end;
             LBImpex.Items.Add(s);
           end;
           BtnImpexEnabled:= true;
           if LBImpex.SelCount > 0 then BtnImpex.Enabled:= true;
           xmlContacts.Free;
         end;            // Old jcontacts and contacts
      2: begin           //
           Vcards:= TContactsList.Create;
           VCards.LoadVCardFile(EFilename.text);
           for i:=0 to VCards. Count-1 do
             begin
               LBImpex.Items.Add(VCards.GetItem(i).surname+' '+VCards.GetItem(i).name);
             end;
             LBImpexClick(self);
             BtnImpexEnabled:= true;
             if LBImpex.SelCount > 0 then BtnImpex.Enabled:= true;

         end

      else exit;
    end;
  end else
  begin
    // Set filters in open file dialog
    Case CBType.ItemIndex of
        0: SD1.filter:= 'CSV|*.csv;*.txt';         // export CSV file
        1: SD1.filter:= 'vCard|*.vcf';
    end;

    if SD1.Execute then EFileName.text:= SD1.FileName;
    BtnImpexEnabled:= true;
    if LBImpex.SelCount > 0 then BtnImpex.Enabled:= true;
  end;


end;

procedure TFImpex.SGImpexSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin


end;







procedure TFImpex.CBTypeChange(Sender: TObject);
begin
  LSepar.Enabled:= not Boolean(CBType.ItemIndex);
  ESepar.Enabled:= LSepar.Enabled;
  LDelim.Enabled:= LSepar.Enabled;
  EDelim.Enabled:= LSepar.Enabled;

end;

procedure TFImpex.BtnUpClick(Sender: TObject);
var
  curline, prevline: integer;
  prevndx: integer;
  prevval: string;
  cansel: boolean;
begin
  // Cur line
  Curline:= SGImpex.Row;
  if curline < 2 then exit;
  prevline:= Curline-1;
  prevndx:= ContactFldArray[prevline-1];
  prevval:= SGImpex.cells[1, prevline];
  SGImpex.cells[1, prevline]:= SGImpex.cells[1, curline];
  ContactFldArray[prevline-1]:= ContactFldArray[curline-1]; ;
  SGImpex.cells[1, curline]:= prevval;
  SGImpex.Row:= prevline;
  SGImpex.Col:=1;
  cansel:= true;
  SGImpexSelectCell(self,prevline,1,cansel);
  SGImpex.SetFocus;
  ContactFldArray[curline-1]:= prevndx;
end;


procedure TFImpex.BtnEmptyClick(Sender: TObject);
var
  curline: integer;
begin
  Curline:= SGImpex.Row;
  SGImpex.cells[1, curline]:= '';
  ContactFldArray[curline-1]:= -1;
end;

procedure TFImpex.BtnDownClick(Sender: TObject);
var
  curline, nextline: integer;
  nextndx: integer;
  nextval: string;
  cansel: boolean;
begin
  Curline:= SGImpex.Row;
  if curline > SGImpex.RowCount-2 then exit;
  nextline:= curline+1;
  nextndx:= ContactFldArray[nextline-1];
  nextval:= SGImpex.cells[1, nextline];
  SGImpex.cells[1, nextline]:= SGImpex.cells[1, curline];
  ContactFldArray[nextline-1]:= ContactFldArray[curline-1];
  SGImpex.cells[1, curline]:= nextval;
  SGImpex.Row:= nextline;
  SGImpex.Col:=1;
  cansel:= true;
  SGImpexSelectCell(self,nextline,1,cansel);
  SGImpex.SetFocus;
  ContactFldArray[curline-1]:= nextndx;
end;

function TFImpex.getcsvstring(doc: TCSVDocument; fld, ndx: integer) : string;
begin
  try
    result:= IsAnsi2Utf8(doc.Cells[ContactFldArray[fld],ndx]);
  except
    result:= '';
  end;
end;

function TFImpex.getcsvfloat(doc: TCSVDocument; fld, ndx: integer) : Float;
begin
  try
    result:= StrToFloat(doc.Cells[ContactFldArray[fld],ndx]);
  except
    result:= 0;
  end;
end;

function TFImpex.getcsvdate(doc: TCSVDocument; fld, ndx: integer) : TDateTime;
begin
  try
    result:= StrToDateTime(doc.Cells[ContactFldArray[fld],ndx]);
  except
    result:= now();
  end;
end;

procedure TFImpex.BtnImpexClick(Sender: TObject);
var
  MyContact: TContact;
  i, j: integer;
  csvh: string;
  csv, vcard: TStringList;
  delim, delsep: string;        // delimiter, delimiter+separator
  line: string;
  rInt: LongInt;
  nimgfile: string;
  Image1: TImage;
  fs: TFileStream;
  fstring: string;
  b64string: string;
  photostr: string;
const
  vcbeg= 'BEGIN:VCARD';
  vcend=  'END:VCARD';
begin
  ImpexSelcount:= LBImpex.SelCount;
  if RBImport.checked then
  begin
    Case CBType.ItemIndex of
      // csv has to be processed after all field changes are done
      0: begin
           ImpexContacts.Reset;
           for i:= 0 to LBImpex.Items.Count-1 do
             begin
               MyContact.Name:= getcsvstring(csvdoc, 0, i);
               MyContact.Surname:= getcsvstring(csvdoc, 1, i);
               MyContact.Street:= getcsvstring(csvdoc, 2, i);
               MyContact.BP:= getcsvstring(csvdoc, 3, i);
               MyContact.Lieudit:= getcsvstring(csvdoc, 4, i);
               MyContact.Postcode:= getcsvstring(csvdoc, 5, i);
               MyContact.Town:= getcsvstring(csvdoc, 6, i);
               MyContact.Country:= getcsvstring(csvdoc, 7, i);
               MyContact.Phone:= getcsvstring(csvdoc, 8, i);
               MyContact.Box:= getcsvstring(csvdoc, 9, i);
               MyContact.Mobile:= getcsvstring(csvdoc, 10, i);
               MyContact.Autre:= getcsvstring(csvdoc, 11, i);
               MyContact.Email:= getcsvstring(csvdoc, 12, i);
               MyContact.Web:= getcsvstring(csvdoc, 13, i);
               MyContact.Longitude:= getcsvfloat(csvdoc, 14, i);
               MyContact.Latitude:= getcsvfloat(csvdoc, 15, i);
               MyContact.Date:= getcsvdate(csvdoc, 16, i);
               MyContact.DateModif:= now();      //17
               MyContact.Comment:= getcsvstring(csvdoc, 18, i);
               MyContact.Imagepath:= '';    //19
               MyContact.fonction:= getcsvstring(csvdoc, 20, i);
               MyContact.Service:= getcsvstring(csvdoc, 21, i);
               MyContact.Company:= getcsvstring(csvdoc, 22, i);
               MyContact.StreetWk:= getcsvstring(csvdoc, 23, i);
               MyContact.BPWk:= getcsvstring(csvdoc, 24, i);
               MyContact.LieuditWk:= getcsvstring(csvdoc, 25, i);
               MyContact.PostcodeWk:= getcsvstring(csvdoc, 26, i);
               MyContact.TownWk:= getcsvstring(csvdoc, 27, i);
               MyContact.CountryWk:= getcsvstring(csvdoc, 28, i);
               MyContact.PhoneWk:= getcsvstring(csvdoc, 29, i);
               MyContact.BoxWk:= getcsvstring(csvdoc, 30, i);
               MyContact.MobileWk:= getcsvstring(csvdoc, 31, i);
               MyContact.AutreWk:= getcsvstring(csvdoc, 32, i);
               MyContact.EmailWk:= getcsvstring(csvdoc, 33, i);
               MyContact.WebWk:= getcsvstring(csvdoc, 34, i);
               MyContact.LongitudeWk:= getcsvfloat(csvdoc, 35, i);
               MyContact.LatitudeWk:= getcsvfloat(csvdoc, 36, i);
               ImpexContacts.AddContact(MyContact);
             end;
         end;
      // vCard
      2: begin
           ImpexContacts.Reset;
           for i:= 0 to LBImpex.Items.Count-1 do
           begin
             MyContact.Name:= Vcards.GetItem(i).name;
             MyContact.Surname:= VCards.GetItem(i).surname;
             MyContact.Street:= VCards.GetItem(i).street;
             MyContact.BP:= VCards.GetItem(i).BP;
             MyContact.Lieudit:= VCards.GetItem(i).lieudit;
             MyContact.Postcode:= VCards.GetItem(i).postcode;
             MyContact.Town:= VCards.GetItem(i).town;
             MyContact.Country:= VCards.GetItem(i).country;
             MyContact.Phone:= VCards.GetItem(i).phone;
             MyContact.Box:= '';
             MyContact.Mobile:= VCards.GetItem(i).mobile;
             MyContact.Autre:= '';
             MyContact.Email:= VCards.GetItem(i).email;
             MyContact.Web:= VCards.GetItem(i).web;
             MyContact.Longitude:= VCards.GetItem(i).Longitude;
             MyContact.Latitude:= VCards.GetItem(i).Latitude;
             MyContact.Date:= VCards.GetItem(i).Date;
             MyContact.DateModif:= VCards.GetItem(i).DateModif;      //17
             MyContact.Comment:= VCards.GetItem(i).Comment;
             // retrieve image
             if FileExists(VCards.GetItem(i).Imagepath) then
             begin
               Image1:= TImage.Create(self);
               Image1.Picture.LoadFromFile(VCards.GetItem(i).Imagepath);
               DeleteFile(VCards.GetItem(i).Imagepath);
               ImageFitToSize(Image1, FContactManager.ImgContact.Width, FContactManager.ImgContact.Height);
               Randomize;
               rInt:= random(10000);
               nimgfile:= LowerCase('VCIMP'+VCards.GetItem(i).Name+VCards.GetItem(i).Surname+Format('%d', [rInt])+'.jpg') ;
               Image1.Picture.SaveToFile( FContactManager.ContactMgrAppsData+'images\'+nimgfile);
               Image1.Free;
             end;
             MyContact.Imagepath:= nimgfile ;    //19
             MyContact.fonction:= VCards.GetItem(i).fonction;
             MyContact.Service:= VCards.GetItem(i).Service;
             MyContact.Company:= VCards.GetItem(i).Company;
             MyContact.StreetWk:= VCards.GetItem(i).StreetWk;
             MyContact.BPWk:= VCards.GetItem(i).BPWk;
             MyContact.LieuditWk:= VCards.GetItem(i).LieuditWk;
             MyContact.PostcodeWk:= VCards.GetItem(i).PostcodeWk;
             MyContact.TownWk:= VCards.GetItem(i).TownWk;
             MyContact.CountryWk:= VCards.GetItem(i).CountryWk;
             MyContact.PhoneWk:= VCards.GetItem(i).PhoneWk;
             MyContact.BoxWk:= '';
             MyContact.MobileWk:= VCards.GetItem(i).MobileWk;
             MyContact.AutreWk:= '';
             MyContact.EmailWk:= VCards.GetItem(i).EmailWk;
             MyContact.WebWk:= VCards.GetItem(i).WebWk;
             MyContact.LongitudeWk:= VCards.GetItem(i).LongitudeWk;
             MyContact.LatitudeWk:= VCards.GetItem(i).LatitudeWk;
             ImpexContacts.AddContact(MyContact);
           end;
         end;
    end;

  end else    // Export contacts
  begin

    Case CBType.ItemIndex of
      0: begin
           delim:= EDelim.Text;
           delsep:= EDelim.Text+ESepar.text;
           DefaultFormatSettings.DecimalSeparator:= '.';
           // Header formatting
           csvh:= StringReplace(FContactManager.csvheader, ',', ESepar.text, [rfReplaceAll]);
           csvh:= StringReplace(csvh, '"', EDelim.text, [rfReplaceAll]);
           csv:= TStringList.create;
           if CBCode.ItemIndex= 0 then csv.AddText(csvh)     // UTF8
               else  csv.Add(IsUtf82Ansi(csvh));         // ANSI
           // Now, write records
           for i:= 0 to LBImpex.Items.Count-1 do
           begin
             if Fimpex.LBImpex.Selected[i] then
             begin
               line:= delim+FContactManager.ListeContacts.GetItem(i).Name+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).SurName+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Street+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).BP+EDelim.Text+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Lieudit+EDelim.Text+delsep+
                   delim+ FContactManager.ListeContacts.GetItem(i).Postcode+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Town+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Country+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Phone+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Box+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Mobile+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Autre+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Email+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Web+delsep+
                   delim+FloatToStr(FContactManager.ListeContacts.GetItem(i).Longitude)+delsep+
                   delim+FloatToStr(FContactManager.ListeContacts.GetItem(i).Latitude)+delsep+
                   delim+DateTimeToStr(FContactManager.ListeContacts.GetItem(i).Date)+delsep+
                   delim+DateTimeToStr(FContactManager.ListeContacts.GetItem(i).DateModif)+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Comment+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Imagepath+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).fonction+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Service+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).Company+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).StreetWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).BPWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).LieuditWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).PostcodeWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).PostcodeWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).TownWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).CountryWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).PhoneWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).BoxWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).MobileWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).AutreWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).EmailWk+delsep+
                   delim+FContactManager.ListeContacts.GetItem(i).WebWk+delsep+
                   delim+FloatToStr(FContactManager.ListeContacts.GetItem(i).LongitudeWk)+delsep+
                   delim+FloatToStr(FContactManager.ListeContacts.GetItem(i).LatitudeWk)+delim;
               if CBCode.ItemIndex= 0 then csv.AddText(line)     // UTF8
               else  csv.Add(IsUtf82Ansi(line));             // ANSI

             end;
           end;
           csv.SaveToFile(EFileName.text);
           DefaultFormatSettings.DecimalSeparator:= DecSep;
           csv.free;
         end;
      1: begin
           DefaultFormatSettings.DecimalSeparator:= '.';
           vcard:= TStringList.create;
           for i:= 0 to LBImpex.Items.Count-1 do
           begin
             if Fimpex.LBImpex.Selected[i] then
             begin
               vcard.add(vcbeg);
               vcard.add('VERSION:2.1');
               vcard.add('N;CHARSET=UTF-8:'+FContactManager.ListeContacts.GetItem(i).Name+';'+
                                            FContactManager.ListeContacts.GetItem(i).Surname+';;;');
               vcard.add('FN;CHARSET=UTF-8:'+FContactManager.ListeContacts.GetItem(i).Surname+' '+
                                            FContactManager.ListeContacts.GetItem(i).Name);
               vcard.add('ADR;HOME;CHARSET=UTF-8:'+FContactManager.ListeContacts.GetItem(i).BP+';'+
                                            FContactManager.ListeContacts.GetItem(i).Lieudit+';'+
                                            FContactManager.ListeContacts.GetItem(i).Street+';'+
                                            FContactManager.ListeContacts.GetItem(i).Town+';'+';'+   //region left blank
                                            FContactManager.ListeContacts.GetItem(i).Postcode+';'+
                                            FContactManager.ListeContacts.GetItem(i).Country);
               line:= FContactManager.ListeContacts.GetItem(i).Phone;
               if length(line) > 0 then vcard.add('TEL;HOME:'+line);
               line:= FContactManager.ListeContacts.GetItem(i).Mobile;
               if length(line) > 0 then vcard.add('TEL;CELL:'+line);
               line:= FContactManager.ListeContacts.GetItem(i).Email;
               if length(line) > 0 then vcard.add('EMAIL;HOME:'+line);
               line:= FContactManager.ListeContacts.GetItem(i).Web;
               if length(line) > 0 then vcard.add('URL;HOME:'+line);
               //GEO:geo:37.386013,-122.082932   (lat, lon);
               vcard.add('GEO:'+FloattoStr(FContactManager.ListeContacts.GetItem(i).Latitude)+';'+
                                    FloattoStr(FContactManager.ListeContacts.GetItem(i).Longitude));
               line:= FContactManager.ListeContacts.GetItem(i).Company+';'+FContactManager.ListeContacts.GetItem(i).Service;
               if length(line) > 1 then vcard.add('ORG:'+line+';;');
               line:= FContactManager.ListeContacts.GetItem(i).fonction;
               if length(line) > 0 then vcard.add('ROLE:'+line);
               line:= FContactManager.ListeContacts.GetItem(i).BPWk+';'+
                      FContactManager.ListeContacts.GetItem(i).LieuditWk+';'+
                      FContactManager.ListeContacts.GetItem(i).StreetWk +';'+
                      FContactManager.ListeContacts.GetItem(i).TownWk+';'+';'+   //region left blank
                      FContactManager.ListeContacts.GetItem(i).PostcodeWk +';'+
                      FContactManager.ListeContacts.GetItem(i).CountryWk;
               if length(line) > 6 then  vcard.add('ADR;WORK;CHARSET=UTF-8:'+line);
               line:= FContactManager.ListeContacts.GetItem(i).PhoneWk;
               if length(line) > 0 then vcard.add('TEL;WORK:'+line);
               line:= FContactManager.ListeContacts.GetItem(i).MobileWk;
               if length(line) > 0 then vcard.add('TEL;CELL;WORK:'+line);
               line:= FContactManager.ListeContacts.GetItem(i).EmailWk;
               if length(line) > 0 then vcard.add('EMAIL;WORK:'+line);
               line:= FContactManager.ListeContacts.GetItem(i).WebWk;
               if length(line) > 0 then vcard.add('URL;WORK:'+line);
               //GEO:geo:37.386013,-122.082932   (lat, lon);
               vcard.add('GEO;WORK:'+FloattoStr(FContactManager.ListeContacts.GetItem(i).LatitudeWk)+';'+
                                    FloattoStr(FContactManager.ListeContacts.GetItem(i).LongitudeWk));

               // REV (timestamp)
               vcard.add('REV:'+FormatDateTime('YYYYMMDD"T"hhnnss', FContactManager.ListeContacts.GetItem(i).Date));

               // Add photo
               //EncodeStringBase64(const s:string):String;
               If Fileexists(FContactManager.ContactMgrAppsData+'images\'+FContactManager.ListeContacts.GetItem(i).Imagepath) then
               try
                 fs:= TFileStream.Create(FContactManager.ContactMgrAppsData+'images\'+
                                     FContactManager.ListeContacts.GetItem(i).Imagepath, fmOpenRead);
                 if fs.Size > 0 then
                 begin
                    fs.Position := 0;
                    SetLength(fstring, fs.Size div SizeOf(Char));
                    fs.ReadBuffer(Pointer(fstring)^, fs.Size div SizeOf(Char));
                    B64string := EncodeStringBase64(fString);
                    // insert line breaks every 76 chars
                    photostr:= 'PHOTO;ENCODING=BASE64;TYPE=JPEG:'+B64string;
                    for j:= 0 to (length(photostr) div 76)+1 do
                    begin
                      line:= copy(photostr, (j*76)+1, 76);
                      if length(line) > 0 then
                      begin
                        vcard.add(line);
                      end else
                      begin
                        vcard.add('');
                        break;
                      end;
                    end;
                 end;
               finally
                 fs.free;
               end;
               vcard.add(vcend);
               vcard.add('');
            end;
          end;
          DefaultFormatSettings.DecimalSeparator:= DecSep;
          vcard.SaveToFile(EFileName.text);
          vcard.free;
        end;

    end;
  end;

end;








end.

