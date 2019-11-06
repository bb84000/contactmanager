unit contacts1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, laz2_DOM , laz2_XMLRead, laz2_XMLWrite, Dialogs, lazbbutils, base64;

Type
  TChampsCompare = (cdcNone, cdcName, cdcSurname, cdcPostcode, cdcTown,  cdcCountry, cdcLongit, cdcLatit);
  TSortDirections = (ascend, descend);
  TSaveMode = (selection, all);


  PContact = ^TContact;
  TContact = Record
    Name: string;
    Surname:string;
    Street: string;
    BP: string;
    Lieudit:string;
    Postcode:string;
    Town:string;
    Country:string;
    Phone:string;
    Mobile:string;
    Box:string;
    Autre:string;
    Email:string;
    Web:string;
    Date:TDateTime;
    DateModif:TDateTime;
    Comment:string;
    Longitude:float;
    Latitude:float;
    Imagepath:string;
    Fonction:string;
    Service:string;
    Company:string;
    StreetWk:string;
    BPWk:string;
    LieuditWk:string;
    PostcodeWk:string;
    TownWk:string;
    CountryWk:string;
    PhoneWk:string;
    BoxWk:string;
    MobileWk:string;
    AutreWk:string;
    EmailWk:string;
    WebWk:string;
    LongitudeWk:float;
    LatitudeWk:float;
    Index1:int64;
    // partial save, tag is true
    Tag: Boolean;
    // For Vcards import
    Version: String;
  end;

  TContactsList = class(TList)
  private
    FOnChange: TNotifyEvent;
    FSortType: TChampsCompare;
    FSortDirection: TSortDirections;
    FCsvHeader: String;
    FCsvQuote: String;
    FCsvDelimiter: String;
    procedure SetSortDirection(Value: TSortDirections);
    procedure SetSortType (Value: TChampsCompare);
    procedure DoSort;
    procedure SetCsvHeader(value:string);
    function SaveItem(iNode: TDOMNode; sname, svalue: string): TDOMNode;
  public
    Duplicates : TDuplicates;
    procedure Delete (const i : Integer);
    procedure DeleteMulti (j, k : Integer);
    procedure Reset;
    procedure AddContact(Contact : TContact);
    procedure ModifyContact (const i: integer; Contact : TContact);
    procedure ModifyField (const i: integer; field: string; value: variant);
    function GetItem(const i: Integer): TContact;
    constructor Create;
    function GetFloat(s: String): Float;
    function GetInt(s: String): INt64;
    function GetDate(s: string): TDateTime;
    function GetBool(s: string): Boolean;
    function BoolToStr(b: boolean): string;
    function SaveToXMLnode(iNode: TDOMNode): Boolean;
    function SaveToXMLfile(filename: string): Boolean;
    function SaveToVCardfile(filename: string; mode: TSaveMode=all): Boolean;
    function SaveToCsvFile(filename: string; chrset: TCharset=UTF8;  mode: TSaveMode=all; header: boolean=true ): Boolean;
    function LoadXMLnode(iNode: TDOMNode): Boolean;
    function LoadXMLfile(filename: string): Boolean;
    function LoadVCardfile(filename: string): Boolean;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property SortDirection: TSortDirections read FSortDirection write SetSortDirection default ascend;
    Property SortType : TChampsCompare read FSortType write SetSortType default cdcNone;
    Property CsvHeader: string read FCsvHeader write FCsvHeader ;
    property CsvQuote: string read FCsvQuote write FCsvQuote;
    property CsvDelimiter: string read FCsvDelimiter write FCsvDelimiter;
  end;

  var
  ClesTri: array[0..10] of TChampsCompare;

  Const
    // default header
    defheader = '"Name","Surname","Street","BP","Lieudit","Postcode","Town","Country","Phone","Mobile","Box","Autre","Email",'+
        '"Web","Date","DateModif","Comment","Index1","Longitude","Latitude","Imagepath","Fonction","Service","Company",+' +
        '"StreetWk","BPWk","LieuditWk","PostcodeWk","TownWk","CountryWk","PhoneWk","BoxWk","MobileWk","AutreWk","EmailWk",'+
        '"WebWk","LongitudeWk","LatitudeWk","Version","Tag"';

implementation

function stringCompare(Item1, Item2: String): Integer;
begin
  result := Comparestr(UpperCase(Item1), UpperCase(Item2));
end;

function NumericCompare(Item1, Item2: float): Integer;
begin
  if Item1 > Item2 then result := 1
  else
  if Item1 = Item2 then result := 0
  else result := -1;
end;


function CompareMulti(Item1, Item2: Pointer): Integer;
var
  Entry1, Entry2: PContact;
  R, J: integer;
  ResComp: array[TChampsCompare] of integer;
begin
  Entry1:= PContact(Item1);
  Entry2:= PContact(Item2);
  ResComp[cdcNone]  := 0;
  ResComp[cdcName]  := StringCompare(Entry1^.Name+Entry1^.surname, Entry2^.Name+Entry2^.surname);
  ResComp[cdcSurName] := StringCompare(Entry1^.surname+Entry1^.Name , Entry2^.surname+Entry2^.Name);
  ResComp[cdcTown]  := StringCompare(Entry1^.Town, Entry2^.Town);
  ResComp[cdcCountry]:= StringCompare(Entry1^.country, Entry2^.country);
  Try
    ResComp[cdcPostCode]:= NumericCompare(StrToInt(Entry1^.PostCode), StrToInt(Entry2^.PostCode));
  Except
    ResComp[cdcPostCode]:= StringCompare(Entry1^.PostCode, Entry2^.PostCode);
  end;
  ResComp[cdcLongit]:= NumericCompare(Entry1^.Longitude, Entry2^.Longitude);
  ResComp[cdcLatit] := NumericCompare(Entry1^.Latitude, Entry2^.Latitude);

  R := 0;
  for J := 0 to 10 do
  begin
    if ResComp[ClesTri[J]] <> 0 then
     begin
       R := ResComp[ClesTri[J]];
       break;
     end;
  end;
  result :=  R;
end;

function CompareMultiDesc(Item1, Item2: Pointer): Integer;
begin
  result:=  -CompareMulti(Item1, Item2);
end;

procedure TContactsList.DoSort;
begin
  if FSortType <> cdcNone then
  begin
    ClesTri[1] := FSortType;
    //ClesTri[2] := cdcName;
    //ClesTri[3] := cdcDur;
    if FSortDirection = ascend then sort(@comparemulti) else sort(@comparemultidesc);
  end;
end;

constructor TContactsList.Create;
begin
  inherited Create;
  FCsvHeader:= defheader;
  FCsvQuote:= '"';
  FCsvDelimiter:=',';
end;


procedure TContactsList.SetSortDirection(Value: TSortDirections);
begin
  FSortDirection:= Value;
  if FSortDirection = ascend then sort(@comparemulti) else sort(@comparemultidesc);
end;

procedure TContactsList.SetSortType (Value: TChampsCompare);
begin
  FSortType:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
  DoSort;
end;

procedure TContactsList.Delete(const i: Integer);
begin
  inherited delete(i);
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TContactsList.DeleteMulti(j, k : Integer);
var
  i : Integer;
begin
  // On commence par le dernier, ajouter des sécurités
  For i:= k downto j do
  begin
     inherited delete(i);
  end;
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TContactsList.Reset;
var
 i: Integer;
begin
 for i := 0 to Count-1 do
  if Items[i] <> nil then Items[i]:= nil;
 Clear;
end;

procedure TContactsList.AddContact(Contact : TContact);
var
 K: PContact;
begin
  new(K);
  K^.Name := Contact.Name;
  K^.Surname := Contact.Surname;
  K^.Street:= Contact.Street;
  K^.BP:= Contact.BP;
  K^.Lieudit:= Contact.Lieudit;
  K^.Postcode:= Contact.Postcode;
  K^.Town:= Contact.Town;
  K^.Country:= Contact.Country;
  K^.Phone:= Contact.Phone;
  K^.Mobile:= Contact.Mobile;
  K^.Box:= Contact.Box;
  K^.Autre:= Contact.Autre;
  K^.Email:= Contact.Email;
  K^.Web:= Contact.Web;
  K^.Date:= Contact.Date;
  K^.DateModif:= Contact.DateModif;
  K^.Comment:= Contact.Comment ;
  K^.Index1:= Contact.Index1;
  K^.Longitude:= Contact.Longitude;
  K^.Latitude:= Contact.Latitude;
  K^.Imagepath:= Contact.Imagepath;
  K^.fonction:= Contact.fonction;
  K^.Service:= Contact.Service;
  K^.Company:= Contact.Company;
  K^.StreetWk:=Contact.StreetWk;
  K^.BPWk:= Contact.BPWk;
  K^.LieuditWk:= Contact.LieuditWk;
  K^.PostcodeWk:= Contact.PostcodeWk;
  K^.TownWk:= Contact.TownWk;
  K^.CountryWk:= Contact.CountryWk;
  K^.PhoneWk:= Contact.PhoneWk;
  K^.BoxWk:= Contact.BoxWk;
  K^.MobileWk:= Contact.MobileWk;
  K^.AutreWk:= Contact.AutreWk;
  K^.EmailWk:= Contact.EmailWk;
  K^.WebWk:= Contact.WebWk;
  K^.LongitudeWk:= Contact.LongitudeWk;
  K^.LatitudeWk:= Contact.LatitudeWk;
  K^.Version:= Contact.Version;
  K^.Tag:= Contact.Tag;
  add(K);
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;


procedure TContactsList.ModifyContact (const i: integer; Contact : TContact);
begin
  TContact(Items[i]^).Name:= Contact.Name;
  TContact(Items[i]^).Surname := Contact.Surname;
  TContact(Items[i]^).Street:= Contact.Street;
  TContact(Items[i]^).BP:= Contact.BP;
  TContact(Items[i]^).Lieudit:= Contact.Lieudit;
  TContact(Items[i]^).Postcode:= Contact.Postcode;
  TContact(Items[i]^).Town:= Contact.Town;
  TContact(Items[i]^).Country:= Contact.Country;
  TContact(Items[i]^).Phone:= Contact.Phone;
  TContact(Items[i]^).Mobile:= Contact.Mobile;
  TContact(Items[i]^).Box:= Contact.Box;
  TContact(Items[i]^).Autre:= Contact.Autre;
  TContact(Items[i]^).Email:= Contact.Email;
  TContact(Items[i]^).Web:= Contact.Web;
  TContact(Items[i]^).Date:= Contact.Date;
  TContact(Items[i]^).DateModif:= Contact.DateModif;
  TContact(Items[i]^).Comment:= Contact.Comment ;
  TContact(Items[i]^).Index1:= Contact.Index1;
  TContact(Items[i]^).Longitude:= Contact.Longitude;
  TContact(Items[i]^).Latitude:= Contact.Latitude;
  TContact(Items[i]^).Imagepath:= Contact.Imagepath;
  TContact(Items[i]^).fonction:= Contact.fonction;
  TContact(Items[i]^).Service:= Contact.Service;
  TContact(Items[i]^).Company:= Contact.Company;
  TContact(Items[i]^).StreetWk:= Contact.StreetWk;
  TContact(Items[i]^).BPWk:= Contact.BPWk;
  TContact(Items[i]^).LieuditWk:= Contact.LieuditWk;
  TContact(Items[i]^).PostcodeWk:= Contact.PostcodeWk;
  TContact(Items[i]^).TownWk:= Contact.TownWk;
  TContact(Items[i]^).CountryWk:= Contact.CountryWk;
  TContact(Items[i]^).PhoneWk:= Contact.PhoneWk;
  TContact(Items[i]^).BoxWk:= Contact.BoxWk;
  TContact(Items[i]^).MobileWk:= Contact.MobileWk;
  TContact(Items[i]^).AutreWk:= Contact.AutreWk;
  TContact(Items[i]^).EmailWk:= Contact.EmailWk;
  TContact(Items[i]^).WebWk:= Contact.WebWk;
  TContact(Items[i]^).LongitudeWk:= Contact.LongitudeWk;
  TContact(Items[i]^).LatitudeWk:= Contact.LatitudeWk;
  TContact(Items[i]^).Version:= Contact.Version ;
  TContact(Items[i]^).Tag:= Contact.Tag;
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TContactsList.ModifyField (const i: integer; field: string; value: variant);
begin
  if field='Name' then TContact(Items[i]^).Name:= value;
  if field='Surname' then TContact(Items[i]^).Surname := value;
  if field='Street' then TContact(Items[i]^).Street:= value;
  if field='BP' then TContact(Items[i]^).BP:= value;
  if field='Lieudit' then TContact(Items[i]^).Lieudit:= value;
  if field='Postcode' then TContact(Items[i]^).Postcode:= value;
  if field='Town' then TContact(Items[i]^).Town:= value;
  if field='Country' then TContact(Items[i]^).Country:= value;
  if field='Phone' then TContact(Items[i]^).Phone:= value;
  if field='Mobile' then TContact(Items[i]^).Mobile:= value;
  if field='Box' then TContact(Items[i]^).Box:= value;
  if field='Autre' then TContact(Items[i]^).Autre:= value;
  if field='Email' then TContact(Items[i]^).Email:= value;
  if field='Web' then TContact(Items[i]^).Web:= value;
  if field='Date' then TContact(Items[i]^).Date:= value;
  if field='DateModif' then TContact(Items[i]^).DateModif:= value;
  if field='Comment' then TContact(Items[i]^).Comment:= value ;
  if field='Index1' then TContact(Items[i]^).Index1:= value;
  if field='Longitude' then TContact(Items[i]^).Longitude:= value;
  if field='Latitude' then TContact(Items[i]^).Latitude:= value;
  if field='Imagepath' then TContact(Items[i]^).Imagepath:= value;
  if field='Fonction' then TContact(Items[i]^).fonction:= value;
  if field='Service' then TContact(Items[i]^).Service:= value;
  if field='Company' then TContact(Items[i]^).Company:= value;
  if field='StreetWk' then TContact(Items[i]^).StreetWk:= value;
  if field='BPWk' then TContact(Items[i]^).BPWk:= value;
  if field='LieuditWk' then TContact(Items[i]^).LieuditWk:= value;
  if field='PostcodeWk' then TContact(Items[i]^).PostcodeWk:= value;
  if field='TownWk' then TContact(Items[i]^).TownWk:= value;
  if field='CountryWk' then TContact(Items[i]^).CountryWk:= value;
  if field='PhoneWk' then TContact(Items[i]^).PhoneWk:= value;
  if field='BoxWk' then TContact(Items[i]^).BoxWk:= value;
  if field='MobileWk' then TContact(Items[i]^).MobileWk:= value;
  if field='AutreWk' then TContact(Items[i]^).AutreWk:= value;
  if field='EmailWk' then TContact(Items[i]^).EmailWk:= value;
  if field='WebWk' then TContact(Items[i]^).WebWk:= value;
  if field='LongitudeWk' then TContact(Items[i]^).LongitudeWk:= value;
  if field='LatitudeWk' then TContact(Items[i]^).LatitudeWk:= value;
  if field='Version' then TContact(Items[i]^).Version:= value;
  if field='Tag' then TContact(Items[i]^).Tag:= value;
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;


function TContactsList.GetItem(const i: Integer): TContact;
begin
 Result := TContact(Items[i]^);
end;

function TContactsList.GetInt(s: String): INt64;
begin
  try

    result:= StrToInt64(s);
  except
    result:= 0;
  end;
end;

function TContactsList.GetFloat(s: String): Float;
var
  DecSep: Char;
begin
  DecSep:= DefaultFormatSettings.DecimalSeparator;
  DefaultFormatSettings.DecimalSeparator:= '.';
  try
    result:= StrToFloat(s);
  except
    result:= 0;
  end;
  DefaultFormatSettings.DecimalSeparator:= DecSep;
end;

function TContactsList.GetDate(s: string): TDateTime;
begin
  try
    result:= StrToDateTime(s);
  except
    result:= now();
  end;
end;

function TContactsList.GetBool(s: string): Boolean;
begin
  result:= (uppercase(s)='TRUE');
end;

function TContactsList.BoolToStr(b: boolean): string;
begin
  if b then result:= 'true' else result:= 'false';
end;

function TContactsList.LoadXMLNode(iNode: TDOMNode): Boolean;
var
  chNode: TDOMNode;
  subNode: TDOMNode;
  k: PContact;
  s: string;
  upNodeName: string;
begin
 SortType:= TChampsCompare(GetInt(TDOMElement(iNode).GetAttribute('sort')));
 chNode := iNode.FirstChild;
 while (chNode <> nil) and (UpperCase(chnode.NodeName)='CONTACT')  do
  begin
    Try
      new(K);
      subNode:= chNode.FirstChild;
      while subNode <> nil do
      try
        upNodeName:= UpperCase(subNode.NodeName);
        s:= subNode.TextContent;
        if upNodeName = 'NAME' then K^.Name:= s;
        if upNodeName = 'SURNAME' then K^.Surname := s;
        if upNodeName = 'STREET' then K^.Street:= s;
        if upNodeName = 'BP' then K^.BP:= s;
        if upNodeName = 'LIEUDIT' then K^.Lieudit := s;
        if upNodeName = 'POSTCODE' then K^.Postcode:= s;
        if upNodeName = 'TOWN' then K^.Town:= s;
        if upNodeName = 'COUNTRY' then K^.Country := s;
        if upNodeName = 'PHONE' then K^.Phone:= s;
        if upNodeName = 'MOBILE' then K^.Mobile:= s;
        if upNodeName = 'BOX' then K^.Box := s;
        if upNodeName = 'AUTRE' then K^.Autre:= s;
        if upNodeName = 'EMAIL' then K^.Email := s;
        if upNodeName = 'WEB' then K^.Web:= s;
        if upNodeName = 'DATE' then K^.Date := GetDate(s);
        if upNodeName = 'DATEMODIF' then K^.DateModif:= GetDate(s);
        if upNodeName = 'COMMENT' then K^.Comment:= s;
        if upNodeName = 'INDEX1' then K^.Index1 := GetInt(s);
        if upNodeName = 'LONGITUDE' then K^.Longitude:= GetFloat(s);
        if upNodeName = 'LATITUDE' then K^.Latitude:= GetFloat(s);
        if upNodeName = 'IMAGEPATH' then K^.Imagepath:= s;
        if upNodeName = 'FUNCTION' then K^.fonction := s;
        if upNodeName = 'SERVICE' then K^.Service:= s;
        if upNodeName = 'COMPANY' then K^.Company:= s;
        if upNodeName = 'STREETWK' then K^.StreetWk:= s;
        if upNodeName = 'BPWK' then K^.BPWk:= s;
        if upNodeName = 'LIEUDITWK' then K^.LieuditWk := s;
        if upNodeName = 'POSTCODEWK' then K^.PostcodeWk:= s;
        if upNodeName = 'TOWNWK' then K^.TownWk:= s;
        if upNodeName = 'COUNTRYWK' then K^.CountryWk := s;
        if upNodeName = 'PHONEWK' then K^.PhoneWk:= s;
        if upNodeName = 'MOBILEWK' then K^.MobileWk:= s;
        if upNodeName = 'BOXWK' then K^.BoxWk := s;
        if upNodeName = 'AUTREWK' then K^.AutreWk:= s;
        if upNodeName = 'EMAILWK' then K^.EmailWk := s;
        if upNodeName = 'WEBWK' then K^.WebWk:= s;
        if upNodeName = 'LONGITUDEWK' then K^.LongitudeWk:= GetFloat(s);
        if upNodeName = 'LATITUDEWK' then K^.LatitudeWk:= GetFloat(s);
        if upNodeName = 'VERSION' then K^.Version:= s;
        if upNodeName = 'TAG' then K^.Tag:= GetBool(s);
      finally
        subnode:= subnode.NextSibling;
      end;
      add(K);
    finally
      chNode := chNode.NextSibling;
    end;
  end;
  result:= true;
end;

function TContactsList.LoadXMLFile(filename: string): Boolean;
var
  ContactsXML: TXMLDocument;
  RootNode,ContactsNode : TDOMNode;
begin
  result:= false;
  if not FileExists(filename) then exit;
  ReadXMLFile(ContactsXML, filename);
  RootNode := ContactsXML.DocumentElement;
  ContactsNode:= RootNode.FindNode('contacts');
  if ContactsNode= nil then exit;
  LoadXMLnode(ContactsNode);
  If assigned(ContactsNode) then ContactsNode.free;
  result:= true;
end;

function TContactsList.LoadVCardFile(filename: string): Boolean;
var
  vcsl : TStringList;
  s, s1, sup, sdata: string;
  A: TStringArray;
  i: integer;
  photo: boolean;
  imagetype: String;
  b64string: string;
  p: integer;
  fs: TFileStream;
  imgpath: string;
  MyCont: Tcontact;
begin
  result:= false;
  photo:= false;
  imagetype:= '';
  b64string:= '';
  if not FileExists(filename) then exit;
  result:= true;
  // Create a stringlist and copy the VCard file content to the stringlist
  vcsl := TStringList.Create;
  vcsl.LoadFromFile(filename);
  // Then parse eache line to find the parameter
  for i:= 0 to vcsl.count-1 do
  begin
    //Read current line and convert uppercase
    s:= vcsl.Strings[i];
    sup:= UpperCase(s);
    // We auto convert it to UTF8 if ansi detected, then data is after the last ':'
    sdata:= IsAnsi2Utf8(copy(s, LastDelimiter(':', s)+1, length(s)));
    // split the data in an array
    Setlength(A, 0);
    A := sdata.Split(';');
    // We have a new VCard
    if sup= 'BEGIN:VCARD' then
    begin
      MyCont:= Default(TContact );
      photo:= false;
      continue;
    end;
    // If it is a photo field, so append line to b64string
    if photo then
    begin
      if length(s) > 0 then b64string:= b64string+s+#10 else
      // blank line, end of b64 code
      begin
        photo:= false;
        imgpath:= GetTempDir(true)+InttoStr(i)+'.'+imagetype;
        if Length(b64string) > 0 then
        try
          fs:= TFileStream.Create(imgpath, fmCreate);
          s1:= DecodeStringBase64(b64string);
          fs.Position := 0;
          fs.Write(s1[1], length(s1));
        finally
          fs.free;
          MyCont.Imagepath:= imgpath;
        end;
       end;
      continue
    end;
    // End of the current VCard
    if s= 'END:VCARD' then
    begin
      AddContact(MyCont);
      continue;
    end;
    // Detect version
    if pos('VERSION:', sup)= 1 then
    begin
      MyCont.version:= copy(s, 9, 5) ;
      continue;
    end;
    // Name field  (skip charset) : LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX
    if (pos('N:', sup)= 1) or (pos('N;', sup)= 1) then
    begin
      MyCont.name:= A[0];
      MyCont.surname:= A[1];
      continue;
    end;
    // home address field : Post Office Box; Extended Address; Street; Locality; Region; Postal Code; Country
    // can also be coordinates : ADR;GEO="geo:12.3457,78.910";
    if (pos('ADR:', sup)= 1) or ((pos('ADR;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      MyCont.BP:= A[0];
      MyCont.Lieudit:= A[1];
      MyCont.street:= A[2];
      MyCont.town:= A[3];
      MyCont.postcode:= A[5];
      MyCont.country:= A[6];
      // check geo
      if pos('GEO', sup) > 0 then
      begin
        s1:= copy(s, pos('GEO', sup)+1, length(s));
        s1:= copy(s1, pos(':', s1)+1, pos(';', s1)-pos(':', s1)-1);
        A:= s1.Split(',"''');        // allow ignore quotes
        MyCont.Longitude:= GetFloat(A[0]);
        MyCont.Latitude:= GetFloat(A[1]);
      end;
      continue;
    end;
    // work address field : Post Office Box; Extended Address; Street; Locality; Region; Postal Code; Country
    if ((pos('ADR;', sup)= 1) and (pos('WORK', sup) > 0)) then
    begin
      MyCont.BPWk:= A[0];
      MyCont.LieuditWk:= A[1];
      MyCont.StreetWk:= A[2];
      MyCont.TownWk:= A[3];
      MyCont.PostcodeWk:= A[5];
      MyCont.CountryWk:= A[6];
      // check geo
      if pos('GEO', sup) > 0 then
      begin
        s1:= copy(s, pos('GEO', sup)+1, length(s));
        s1:= copy(s1, pos(':', s1)+1, pos(';', s1)-pos(':', s1)-1);
        A:= s1.Split(',"''');        // allow ignore quotes
        MyCont.LongitudeWk:= GetFloat(A[0]);
        MyCont.LatitudeWk:= GetFloat(A[1]);
      end;
      continue;
    end;
    // home phone field
    if (pos('TEL:', sup)= 1) then //or (pos('TEL;HOME', sup)= 1) or (pos('TEL;TYPE=HOME', sup)= 1)  then
    begin
      MyCont.phone:= s;
      continue;
    end;
   // can be fixed line or cell, home or work other cases nor relevant for this app
    if (pos('TEL;', sup)= 1) then
    begin
       if pos('CELL', sup) > 0 then       // Cell phone
       begin
         if pos('WORK', sup) > 0 then MyCont.MobileWk:= sdata    // work cell phone
         else MyCont.mobile:= sdata;                            // home or other cell phone
       end else                                                    // fixes line phone
       begin
         if pos('WORK', sup) > 0 then MyCont.PhoneWk:= sdata     // work phone line
         else MyCont.phone:= sdata;                             // home or other phone line
       end;
      continue;
    end;
    if (pos('EMAIL:', sup)= 1) or ((pos('EMAIL;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      MyCont.email:= sdata;
      continue;
    end;
    if (pos('EMAIL;', sup)= 1) and (pos('WORK', sup) > 0) then
    begin
      MyCont.EmailWk:= sdata;
      continue;
    end;
    if (pos('URL:', sup)= 1) or ((pos('URL;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      s1:= copy(s, pos(':', s)+1, length(s));       // Need first ':' there is another one after http...
      MyCont.web:= s1;
      continue;
    end;
    if (pos('URL;', sup)= 1) and (pos('WORK', sup) > 0) then
    begin
      s1:= copy(s, pos(':', s)+1, length(s));       // Need first ':' there is another one after http...
      MyCont.WebWk:= sdata;
      continue;
    end;
    // GEO:geo:37.386013,-122.082932  or GEO:37.386013;-122.082932
    if pos('GEO', sup)=1 then
    begin
      s1:= copy(s, pos('GEO', sup)+4, length(s));   // remove firest GEO
      s1:= copy(s1, pos(':', s1)+1, length(s));
      A:= s1.Split(',;"''');        // allow ignore quotes
      if pos('WORK', SUP) > 0 then
      begin
        MyCont.LatitudeWk:= GetFloat(A[0]);
        MyCont.LongitudeWk:= GetFloat(A[1]) ;
      end else
      begin
        MyCont.Latitude:= GetFloat(A[0]);
        MyCont.Longitude:= GetFloat(A[1]) ;
      end;
      continue;
    end;
    // Photo field, with base 64, JPG (or PNG : todo)
    if pos('PHOTO', sup)=1 then
    begin
      if pos('ENCODING=BASE64', sup) >0 then      // embedded image, search type
      begin
        p:= pos('TYPE=', sup);
        if p > 0 then
        begin
          imagetype:= uppercase(copy(s, p+5, 4));
          p:= pos(':', sup);
          b64string:= copy (s, p+1, length(s))+#10;
          photo:= true;
        end;
      end;
      continue;
    end;
    if pos('ORG', sup)=1 then
    begin
      MyCont.Company:= A[0];
      MyCont.Service:= A[1];
      continue;
    end;
    if pos('ROLE', sup)=1 then
    begin
      MyCont.fonction:= A[0];
    end;
    // Timestamp 19961022T140000
    if pos('REV', sup)=1 then
    try

      MyCont.Date:= EncodeDate(StrToInt(copy(A[0], 1, 4)), StrToInt(copy(A[0], 5, 2)), StrToInt(copy(A[0], 7, 2))  );
      MyCont.DateModif:= now();
      //ShowMessage(DateTimeToStr(MyCont.Date));
    Except
    end;
  end;
  vcsl.free;

end;


function TContactsList.SaveItem(iNode: TDOMNode; sname, svalue: string): TDOMNode;
begin
  result:= iNode.OwnerDocument.CreateElement(sname);
  result.TextContent:= svalue;
end;

function TContactsList.SaveToXMLnode(iNode: TDOMNode): Boolean;
var
  i: Integer;
  ContNode: TDOMNode;
  DecSep: Char;
begin
  Result:= True;
  If Count > 0 Then
   begin
     TDOMElement(iNode).SetAttribute('sort', IntToStr(Ord(SortType)));
     For i:= 0 to Count-1 do
     Try
       ContNode := iNode.OwnerDocument.CreateElement('contact');
       iNode.Appendchild(ContNode);
       DecSep:= DefaultFormatSettings.DecimalSeparator;
       DefaultFormatSettings.DecimalSeparator:= '.';
       ContNode.AppendChild(SaveItem(ContNode, 'name', TContact(Items[i]^).Name));
       ContNode.AppendChild(SaveItem(ContNode, 'surname', TContact(Items[i]^).Surname));
       ContNode.AppendChild(SaveItem(ContNode, 'street', TContact(Items[i]^).Street));
       ContNode.AppendChild(SaveItem(ContNode, 'bp', TContact(Items[i]^).BP));
       ContNode.AppendChild(SaveItem(ContNode, 'lieudit', TContact(Items[i]^).Lieudit));
       ContNode.AppendChild(SaveItem(ContNode, 'postcode', TContact(Items[i]^).Postcode));
       ContNode.AppendChild(SaveItem(ContNode, 'town', TContact(Items[i]^).Town));
       ContNode.AppendChild(SaveItem(ContNode, 'country', TContact(Items[i]^).Country));
       ContNode.AppendChild(SaveItem(ContNode, 'phone', TContact(Items[i]^).Phone));
       ContNode.AppendChild(SaveItem(ContNode, 'mobile', TContact(Items[i]^).Mobile));
       ContNode.AppendChild(SaveItem(ContNode, 'box', TContact(Items[i]^).Box));
       ContNode.AppendChild(SaveItem(ContNode, 'autre', TContact(Items[i]^).Autre));
       ContNode.AppendChild(SaveItem(ContNode, 'email', TContact(Items[i]^).Email));
       ContNode.AppendChild(SaveItem(ContNode, 'web', TContact(Items[i]^).Web));
       ContNode.AppendChild(SaveItem(ContNode, 'date', DateTimeToStr(TContact(Items[i]^).Date)));
       ContNode.AppendChild(SaveItem(ContNode, 'datemodif', DateTimeToStr(TContact(Items[i]^).Datemodif)));
       ContNode.AppendChild(SaveItem(ContNode, 'comment', TContact(Items[i]^).Comment));
       ContNode.AppendChild(SaveItem(ContNode, 'index1', IntToStr(i)));  //IntToStr(TContact(Items[i]^).Index1)));
       ContNode.AppendChild(SaveItem(ContNode, 'longitude', FloatToStr(TContact(Items[i]^).Longitude)));
       ContNode.AppendChild(SaveItem(ContNode, 'latitude', FloatToStr(TContact(Items[i]^).Latitude)));
       ContNode.AppendChild(SaveItem(ContNode, 'imagepath', TContact(Items[i]^).Imagepath));
       ContNode.AppendChild(SaveItem(ContNode, 'function', TContact(Items[i]^).fonction));
       ContNode.AppendChild(SaveItem(ContNode, 'service', TContact(Items[i]^).Service));
       ContNode.AppendChild(SaveItem(ContNode, 'company', TContact(Items[i]^).Company));
       ContNode.AppendChild(SaveItem(ContNode, 'bpwk', TContact(Items[i]^).BPWk));
       ContNode.AppendChild(SaveItem(ContNode, 'streetwk', TContact(Items[i]^).StreetWk));
       ContNode.AppendChild(SaveItem(ContNode, 'lieuditwk', TContact(Items[i]^).LieuditWk));
       ContNode.AppendChild(SaveItem(ContNode, 'postcodewk', TContact(Items[i]^).PostcodeWk));
       ContNode.AppendChild(SaveItem(ContNode, 'townwk', TContact(Items[i]^).TownWk));
       ContNode.AppendChild(SaveItem(ContNode, 'countrywk', TContact(Items[i]^).CountryWk));
       ContNode.AppendChild(SaveItem(ContNode, 'phonewk', TContact(Items[i]^).PhoneWk));
       ContNode.AppendChild(SaveItem(ContNode, 'boxwk', TContact(Items[i]^).BoxWk));
       ContNode.AppendChild(SaveItem(ContNode, 'mobilewk', TContact(Items[i]^).MobileWk));
       ContNode.AppendChild(SaveItem(ContNode, 'autrewk', TContact(Items[i]^).AutreWk));
       ContNode.AppendChild(SaveItem(ContNode, 'emailwk', TContact(Items[i]^).EmailWk));
       ContNode.AppendChild(SaveItem(ContNode, 'webwk', TContact(Items[i]^).WebWk));
       ContNode.AppendChild(SaveItem(ContNode, 'longitudewk', FloatToStr(TContact(Items[i]^).LongitudeWk)));
       ContNode.AppendChild(SaveItem(ContNode, 'latitudewk', FloatToStr(TContact(Items[i]^).LatitudeWk)));
       ContNode.AppendChild(SaveItem(ContNode, 'version', TContact(Items[i]^).Version));
       ContNode.AppendChild(SaveItem(ContNode, 'tag', BoolToStr(TContact(Items[i]^).tag)));
       DefaultFormatSettings.DecimalSeparator:= DecSep;
     except
       Result:= False;
     end;
   end;

end;


function TContactsList.SaveToXMLfile(filename: string): Boolean;
var
  ContactsXML: TXMLDocument;
  RootNode, ContactsNode :TDOMNode;
begin
  result:= false;
  if FileExists(filename)then
  begin
    ReadXMLFile(ContactsXML, filename);
    RootNode := ContactsXML.DocumentElement;
  end else
  begin
    ContactsXML := TXMLDocument.Create;
    RootNode := ContactsXML.CreateElement('config');
    ContactsXML.Appendchild(RootNode);
  end;
  ContactsNode:= RootNode.FindNode('contacts');
  if ContactsNode <> nil then RootNode.RemoveChild(ContactsNode);
  ContactsNode:= ContactsXML.CreateElement('contacts');
  if Count > 0 then
  begin
    SaveToXMLnode(ContactsNode);
    RootNode.Appendchild(ContactsNode);
    writeXMLFile(ContactsXML, filename);
    result:= true;
  end;
  if assigned(ContactsXML) then ContactsXML.free;;
end;

// mode : part only tagged contacts
//      : all
// default : all

function TContactsList.SaveToVCardfile(filename: string; mode:TSaveMode=all): Boolean;
var
  DecSep: Char;
  i, j: integer;
  vCard: TstringList;
  line: string;
  fs: TFileStream;
  fstring: string;
  b64string: string;
  photostr: string;
const
  vcbeg= 'BEGIN:VCARD';
  vcend=  'END:VCARD';
begin
  DecSep:= DefaultFormatSettings.DecimalSeparator;
  DefaultFormatSettings.DecimalSeparator:= '.';
  if Count > 0 then
  begin
    vcard:= TStringList.create;
    for i:= 0 to Count-1 do
    begin
      if mode = all then TContact(Items[i]^).Tag:= true;
      if TContact(Items[i]^).Tag=true then
       begin
          vcard.add(vcbeg);
          vcard.add('VERSION:2.1');
          vcard.add('VERSION:2.1');
          vcard.add('N;CHARSET=UTF-8:'+TContact(Items[i]^).Name+';'+TContact(Items[i]^).Surname+';;;');
          vcard.add('FN;CHARSET=UTF-8:'+TContact(Items[i]^).Surname+' '+TContact(Items[i]^).Name);
          vcard.add('ADR;HOME;CHARSET=UTF-8:'+TContact(Items[i]^).BP+';'+TContact(Items[i]^).Lieudit+';'+
                                            TContact(Items[i]^).Street+';'+TContact(Items[i]^).Town+';'+';'+   //region left blank
                                            TContact(Items[i]^).Postcode+';'+TContact(Items[i]^).Country);
          line:= TContact(Items[i]^).Phone;
          if length(line) > 0 then vcard.add('TEL;HOME:'+line);
          line:= TContact(Items[i]^).Mobile;
          if length(line) > 0 then vcard.add('TEL;CELL:'+line);
          line:= TContact(Items[i]^).Email;
          if length(line) > 0 then vcard.add('EMAIL;HOME:'+line);
          line:= TContact(Items[i]^).Web;
          if length(line) > 0 then vcard.add('URL;HOME:'+line);
          //GEO:geo:37.386013,-122.082932   (lat, lon);
          vcard.add('GEO:'+FloattoStr(TContact(Items[i]^).Latitude)+';'+FloattoStr(TContact(Items[i]^).Longitude));
          line:= TContact(Items[i]^).Company+';'+TContact(Items[i]^).Service;
          if length(line) > 1 then vcard.add('ORG:'+line+';;');
          line:= TContact(Items[i]^).fonction;
          if length(line) > 0 then vcard.add('ROLE:'+line);
          line:= TContact(Items[i]^).BPWk+';'+TContact(Items[i]^).LieuditWk+';'+TContact(Items[i]^).StreetWk +';'+
                      TContact(Items[i]^).TownWk+';'+';'+   //region left blank
                      TContact(Items[i]^).PostcodeWk +';'+TContact(Items[i]^).CountryWk;
          if length(line) > 6 then  vcard.add('ADR;WORK;CHARSET=UTF-8:'+line);
          line:= TContact(Items[i]^).PhoneWk;
          if length(line) > 0 then vcard.add('TEL;WORK:'+line);
          line:= TContact(Items[i]^).MobileWk;
          if length(line) > 0 then vcard.add('TEL;CELL;WORK:'+line);
          line:= TContact(Items[i]^).EmailWk;
          if length(line) > 0 then vcard.add('EMAIL;WORK:'+line);
          line:= TContact(Items[i]^).WebWk;
          if length(line) > 0 then vcard.add('URL;WORK:'+line);
          vcard.add('GEO;WORK:'+FloattoStr(TContact(Items[i]^).LatitudeWk)+';'+FloattoStr(TContact(Items[i]^).LongitudeWk));
          // REV (timestamp)
          vcard.add('REV:'+FormatDateTime('YYYYMMDD"T"hhnnss', TContact(Items[i]^).Date));

          // Add photo
          //EncodeStringBase64(const s:string):String;
          If Fileexists(TContact(Items[i]^).Imagepath) then
          try
            fs:= TFileStream.Create(TContact(Items[i]^).Imagepath, fmOpenRead);
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
          // Reset tag to false when processed
          TContact(Items[i]^).Tag:= false;
       end;
    end;
    vcard.SaveToFile(filename);
    vcard.free;
  end;
  DefaultFormatSettings.DecimalSeparator:= DecSep;
end;

procedure TContactsList.SetCsvHeader(value:string);
begin
end;

function TContactsList.SaveToCsvfile(filename: string; chrset: TCharset=UTF8;  mode: TSaveMode=all; header: boolean=true): Boolean;
var
  csv: TstringList;
  csvh : string;
  quote : string;      // quote
  quotdel: string;   // quote+delimiter
  decsep: Char;
  i: integer;
  line: string;
begin

  decsep:= DefaultFormatSettings.DecimalSeparator;
  DefaultFormatSettings.DecimalSeparator:= '.';
  if Count > 0 then
  begin
    quote:= FCsvQuote;
    quotdel:= quote+FCsvDelimiter;
    csv:= TStringList.create;
    // Header formatting
    if header then
    begin
      csvh:= StringReplace(FCsvHeader, ',', FCsvDelimiter ,[rfReplaceAll]);
      csvh:= StringReplace(csvh, '"',FCsvQuote ,[rfReplaceAll]);
      if chrset = UTF8 then csv.AddText(csvh)     // UTF8
      else  csv.Add(IsUtf82Ansi(csvh));         // ANSI
    end;
    for i:= 0 to Count-1 do
    begin
      if mode = all then TContact(Items[i]^).Tag:= true;
      if TContact(Items[i]^).Tag=true then
      begin
        line:= quote+TContact(Items[i]^).Name+quotdel+
               quote+TContact(Items[i]^).SurName+quotdel+
               quote+TContact(Items[i]^).Street+quotdel+
               quote+TContact(Items[i]^).BP+quotdel+
               quote+TContact(Items[i]^).Lieudit+quotdel+
               quote+ TContact(Items[i]^).Postcode+quotdel+
               quote+TContact(Items[i]^).Town+quotdel+
               quote+TContact(Items[i]^).Country+quotdel+
               quote+TContact(Items[i]^).Phone+quotdel+
               quote+TContact(Items[i]^).Box+quotdel+
               quote+TContact(Items[i]^).Mobile+quotdel+
               quote+TContact(Items[i]^).Autre+quotdel+
               quote+TContact(Items[i]^).Email+quotdel+
               quote+TContact(Items[i]^).Web+quotdel+
               quote+FloatToStr(TContact(Items[i]^).Longitude)+quotdel+
               quote+FloatToStr(TContact(Items[i]^).Latitude)+quotdel+
               quote+DateTimeToStr(TContact(Items[i]^).Date)+quotdel+
               quote+DateTimeToStr(TContact(Items[i]^).DateModif)+quotdel+
               quote+TContact(Items[i]^).Comment+quotdel+
               quote+TContact(Items[i]^).Imagepath+quotdel+
               quote+TContact(Items[i]^).fonction+quotdel+
               quote+TContact(Items[i]^).Service+quotdel+
               quote+TContact(Items[i]^).Company+quotdel+
               quote+TContact(Items[i]^).StreetWk+quotdel+
               quote+TContact(Items[i]^).BPWk+quotdel+
               quote+TContact(Items[i]^).LieuditWk+quotdel+
               quote+TContact(Items[i]^).PostcodeWk+quotdel+
               quote+TContact(Items[i]^).PostcodeWk+quotdel+
               quote+TContact(Items[i]^).TownWk+quotdel+
               quote+TContact(Items[i]^).CountryWk+quotdel+
               quote+TContact(Items[i]^).PhoneWk+quotdel+
               quote+TContact(Items[i]^).BoxWk+quotdel+
               quote+TContact(Items[i]^).MobileWk+quotdel+
               quote+TContact(Items[i]^).AutreWk+quotdel+
               quote+TContact(Items[i]^).EmailWk+quotdel+
               quote+TContact(Items[i]^).WebWk+quotdel+
               quote+FloatToStr(TContact(Items[i]^).LongitudeWk)+quotdel+
               quote+FloatToStr(TContact(Items[i]^).LatitudeWk)+quote;
        if chrset= UTF8 then csv.AddText(line)     // UTF8
        else  csv.Add(IsUtf82Ansi(line));          // ANSI
        TContact(Items[i]^).Tag:= false;
      end;
    end;
    csv.SaveToFile(filename);
    csv.Free;
  end;
  DefaultFormatSettings.DecimalSeparator:= decsep;
end;

end.

