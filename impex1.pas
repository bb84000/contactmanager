{*******************************************************************************}
{ Import/export unit : import csv, vcard and ContactsMgr xml files              }
{ bb - sdtp - november 2019                                                     }
{*******************************************************************************}
unit impex1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,

  Buttons, Grids, contacts1, laz2_DOM , laz2_XMLRead, csvdocument, lazbbutils, math, FileUtil;

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
//    Vcards: TContactsList;
    BtnImpexEnabled: boolean;
    function getcsvstring(doc: TCSVDocument; fld, ndx: integer) : string;
    function getcsvfloat(doc: TCSVDocument; fld, ndx: integer) : Float;
    function getcsvdate(doc: TCSVDocument; fld, ndx: integer) : TDateTime;
    procedure SGImpexPopulate(linecur: integer);
    procedure EnableCsvControls;
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

// Modal result is mrOK for import and mrYes for export, so main form knows
// it has to do at this moment

procedure TFImpex.FormActivate(Sender: TObject);
begin
  EnableCsvControls;
  ResPngToGlyph(HInstance,'FILEOPEN', SBFileOpen.Glyph);
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
  // mrOK : Import, mrYes : Export
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

// Right panel buttons only acivated in csv import
// First line check box only activatd in csv export, as only selected contacts
//   are imported, do not select first contact, which is the fields description
// Code combobox only activated in csv export, csv import is automagically
//   converted in UTF8 and vCards has is own coding system

procedure TFImpex.EnableCsvControls;
begin
  ESepar.Enabled:= (CBType.ItemIndex=0);
  Edelim.Enabled:= (CBType.ItemIndex=0);;
  LSepar.Enabled:= ESepar.Enabled;
  LDelim.Enabled:= LSepar.Enabled;
  CBCode.Enabled:= LSepar.Enabled and RBExport.Checked;
  LCode.Enabled:= CBCode.Enabled;
  CBFirstline.Enabled:= RBExport.Checked and (CBType.ItemIndex=0);
end;

// Populate stringgrid with list box last selected conntact values

procedure TFImpex.SGImpexPopulate(linecur: integer);
var
  i: integer;
begin
  if assigned(ImpexContacts) and (linecur < ImpexContacts.count) then
  begin

    for i:= 1 to length(AFieldNames) do
      sgImpex.Cells[1,i]:= ImpexContacts.GetItemFieldString(linecur, AFieldNames[i-1]) ;

  end;
end;

// Click on a contact in listbox

procedure TFImpex.LBImpexClick(Sender: TObject);
var
  curline: integer;
  i: integer;
begin
  curline:= LBImpex.ItemIndex;
  if BtnImpexEnabled then BtnImpex.Enabled:= true;
  if RBImport.checked then
  begin
    Case CBType.ItemIndex of
      0: begin
           for i:= 1 to csvfldcount do
           begin
             sgImpex.Cells[1,i]:= IsAnsi2Utf8(csvdoc.Cells[ContactFldArray[i-1],curline]);
            end;
         end;
      1: begin
           SGImpexPopulate(curline);
         end;
      2: begin
           SGImpexPopulate(curline);
         end;
    end;
  end else SGImpexPopulate(curline);
end;

// Change import to export or vice-versa


procedure TFImpex.RBImpexChange(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  EnableCsvControls;
  LBImpex.Clear;
  SGImpex.Clear;
  BtnImpexEnabled:= false;;
  if RBImport.Checked then
  begin
    // IMport PNG from resource
    ResPngToGlyph(HInstance,'FILEOPEN', SBFileOpen.Glyph);
    BtnImpex.Caption:= FContactManager.FImpex_ImportBtn_Caption;
    BtnImpex.ModalResult:= mrOK;              // Import
    CBType.Items.Text:='CSV'+#10+'vCard'+#10+'Contacts';
    CBType.ItemIndex:=0;
    CBCode.ItemIndex:=0;
  end else
  begin
    ResPngToGlyph(HInstance,'FILESAVE', SBFileOpen.Glyph);
    BtnImpex.Caption:= FContactManager.FImpex_ExportBtn_Caption;
    BtnImpex.ModalResult:= mrYes;            // Export
    sgImpex.RowCount:= csvsheadercount+1;
    for i:= 1 to csvsheadercount do
    begin
      sgImpex.Cells[0,i]:= csvheaderdoc.Cells[i-1,0];
    end;
    // populate list
    ImpexContacts.Reset;
    For i:= 0 to FContactManager.ListeContacts.Count-1 do
    begin
      ImpexContacts.AddContact(FContactManager.ListeContacts.GetItem(i));
      s:= ImpexContacts.GetItem(i).Surname;
      if length(s)>0 then s:= s+' ';
      s:= s+ ImpexContacts.GetItem(i).Name;
      LBImpex.Items.Add(s);
     end;
    CBType.Items.Text:='CSV'+#10+'vCard';
    CBType.ItemIndex:=0;
    CBCode.ItemIndex:=0;
  end;
end;

// Open file to import or define file to export
// We dont export xml files as it is the default format !
// xml Contacts and vCard import are done in contacts1 unit as they have known fields.
// csv import must be done here as whe have to match import fields with our fields

procedure TFImpex.SBFileOpenClick(Sender: TObject);
var
  xmlContacts: TXMLDocument;
  RootNode: TDomNode;
  ContactsNode: TDOMNode;
  i: integer;
  MyContact: TContact;
  s, imgpath: string;
  chrset: TCharSet;
  oldcont: boolean;
begin
  if RBImport.Checked then
  begin
    SetLength(ContactFldArray, csvsheadercount);
        // Set filters in open file dialog
    Case CBType.ItemIndex of
        0: OD1.filter:= 'CSV|*.csv;*.txt';         // Import CSV file
        1: OD1.filter:= 'vCard|*.vcf';
        2: OD1.filter:= 'Contacts|*.xml';          // Import old contacts
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
             csvDoc.Delimiter:= ESepar.Text[1];
             csvDoc.QuoteChar:= EDelim.Text[1];
             csvdoc.LoadFromFile(EFilename.text);
             // Don't change once csv is imported
             ESepar.Enabled:= false;
             EDelim.Enabled:= false;
             LSepar.Enabled:= false;
             LDelim.Enabled:= false;
             LCode.Enabled:= CBCode.Enabled;
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
        // VCard
         1: begin           //
           if Assigned(ImpexContacts) then  ImpexContacts.Reset;
           ImpexContacts.LoadVCardFile(EFilename.text);
            for i:=0 to ImpexContacts.Count-1 do
           begin
             LBImpex.Items.Add(ImpexContacts.GetItem(i).surname+' '+ImpexContacts.GetItem(i).name);
           end;
             LBImpexClick(self);
             BtnImpexEnabled:= true;
             if LBImpex.SelCount > 0 then BtnImpex.Enabled:= true;
        end;
         // Import Contact file (java or new version)
        2: if Assigned(ImpexContacts) then
         begin
           ReadXMLFile(xmlContacts, OD1.FileName);
           RootNode:= xmlContacts.DocumentElement;
           ContactsNode:= RootNode;
           if UpperCase(RootNode.NodeName) <> 'CONTACTS' then  // not jcontacts
           begin
             ContactsNode:= RootNode.FindNode('contacts');     // New contacts file
             oldcont:= false;
           end else
           begin
             oldcont:= true  ;
             imgpath:= ExtractFilePath(OD1.FileName)+'images'+PathDelim;

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
               // old contacts file dont have the complete imagepath
               if oldcont then
               begin
                 if length(MyContact.Imagepath) > 0 then
                 ImpexContacts.ModifyField(i, 'Imagepath', imgpath+MyContact.Imagepath) ;
               end;
             end;
             LBImpex.Items.Add(s);
           end;
           BtnImpexEnabled:= true;
           if LBImpex.SelCount > 0 then BtnImpex.Enabled:= true;
           xmlContacts.Free;
         end;
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

// Blank procedure needed to process select cell event

procedure TFImpex.SGImpexSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
// Do not remove
end;

// Change type of file

procedure TFImpex.CBTypeChange(Sender: TObject);
var
  i: integer;
begin
  if RBImport.Checked then
  begin
    LBImpex.Clear;
    for i:= 1 to SGImpex.RowCount-1 do  sgImpex.Cells[1,i]:= '';
    EFilename.text:= '';
    BtnImpexEnabled:= false;
    BtnImpex.Enabled:= false;
  end  ;
  EnableCsvControls;
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
    result:= StringToFloat(doc.Cells[ContactFldArray[fld],ndx]);
  except
    result:= 0;
  end;
end;

function TFImpex.getcsvdate(doc: TCSVDocument; fld, ndx: integer) : TDateTime;
begin
  try
    result:= StringToDateTime(doc.Cells[ContactFldArray[fld],ndx]);
  except
    result:= now();
  end;
end;

procedure TFImpex.BtnImpexClick(Sender: TObject);
var
  MyContact: TContact;
  i: integer;
  rInt: LongInt;
  nimgfile: string;
  Image1: TImage;
begin
  ImpexSelcount:= LBImpex.SelCount;
  if RBImport.checked then
  begin
    Case CBType.ItemIndex of
      // csv has to be processed after all field changes are done
      0: begin
           ImpexContacts.Reset;
           for i:= 0 to LBImpex.Items.Count-1 do     // Only selected items
            begin
               if LBImpex.Selected[i] then // Only selected items
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
         end;
      // vCard use directly contacts1 import, only change image
      1: begin
            for i:= ImpexContacts.count-1 downto 0 do
            begin
              if not LBImpex.Selected[i] then ImpexContacts.Delete(i) else
              begin
                if length(ImpexContacts.GetItem(i).Imagepath) > 0 then
                begin
                  // retrieve image
                  if FileExists(ImpexContacts.GetItem(i).Imagepath) then
                  begin
                    Image1:= TImage.Create(self);
                    Image1.Picture.LoadFromFile(ImpexContacts.GetItem(i).Imagepath);
                    DeleteFile(ImpexContacts.GetItem(i).Imagepath);
                    ImageFitToSize(Image1, FContactManager.ImgContact.Width, FContactManager.ImgContact.Height);
                    Randomize;
                    rInt:= random(10000);
                    nimgfile:= FContactManager.ContactMgrAppsData+'images'+PathDelim+LowerCase('VCIMP'+ImpexContacts.GetItem(i).Name+ImpexContacts.GetItem(i).Surname+Format('%d', [rInt])+'.jpg') ;
                    Image1.Picture.SaveToFile(nimgfile);
                    Image1.Free;
                    ImpexContacts.ModifyField(i, 'Imagepath', nimgfile);
                  end;
                end;
              end;
            end;
         end;
         2: begin
            for i:= ImpexContacts.count-1 downto 0 do
            begin
              if not LBImpex.Selected[i] then ImpexContacts.Delete(i) else
              begin
                if length(ImpexContacts.GetItem(i).Imagepath) > 0 then
                begin
                   nimgfile:= ExtractFileName(ImpexContacts.GetItem(i).Imagepath);
                   CopyFile(ImpexContacts.GetItem(i).Imagepath, FContactManager.ContactMgrAppsData+'images'+PathDelim+nimgfile);
                   ImpexContacts.ModifyField(i, 'Imagepath', FContactManager.ContactMgrAppsData+'images'+PathDelim+nimgfile);
                end;
              end;
            end;
         end;

    end;
  end else    // Export contacts
  begin
    Case CBType.ItemIndex of
      // Export csv, tag is set to true for selected items
      0: begin
           for i:= 0 to LBImpex.Items.Count-1 do
           begin
             if Fimpex.LBImpex.Selected[i] then ImpexContacts.ModifyField(i, 'Tag', True)
             else ImpexContacts.ModifyField(i, 'Tag', False);
          end;
           ImpexContacts.CsvHeader:= FContactManager.csvheader;
           ImpexContacts.CsvQuote:= EDelim.text;
           ImpexContacts.CsvDelimiter:= ESepar.Text;
           if CBCode.ItemIndex= 0 then ImpexContacts.SaveToCsvFile(EFileName.text, UTF8, selection, CBFirstline.checked)    // UTF8
           else ImpexContacts.SaveToCsvFile(EFileName.text, ANSI,  selection, CBFirstline.checked);         // ANSI
         end;
      // Export VCards, tag is set to true for selected items
      1: begin
           for i:= 0 to LBImpex.Items.Count-1 do
           begin
             if Fimpex.LBImpex.Selected[i] then ImpexContacts.ModifyField(i, 'Tag', True)
             else ImpexContacts.ModifyField(i, 'Tag', False);
          end;
          ImpexContacts.SaveToVCardfile(EFileName.text, selection)
        end;

    end;
  end;

end;








end.

