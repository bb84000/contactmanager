unit contacts1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, laz2_DOM , laz2_XMLRead, laz2_XMLWrite, Dialogs, lazbbutils, base64;

Type
  TChampsCompare = (cdcNone, cdcName, cdcSurname, cdcPostcode, cdcTown,  cdcCountry, cdcLongit, cdcLatit);
  TSortDirections = (ascend, descend);

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
    Index1:int64;
    Longitude:float;
    Latitude:float;
    Imagepath:string;
    fonction:string;
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
    // For Vcards import
    Version: String;
  end;

  TContactsList = class(TList)
  private
    FOnChange: TNotifyEvent;
    FSortType: TChampsCompare;
    FSortDirection: TSortDirections;
    procedure SetSortDirection(Value: TSortDirections);
    procedure SetSortType (Value: TChampsCompare);
    procedure DoSort;
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
    function SaveToXMLnode(iNode: TDOMNode): Boolean;
    function SaveToXMLfile(filename: string): Boolean;
    function SaveToVCardfile(filename: string): Boolean;
    function LoadXMLnode(iNode: TDOMNode): Boolean;
    function LoadXMLfile(filename: string): Boolean;
    function LoadVCardfile(filename: string): Boolean;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property SortDirection: TSortDirections read FSortDirection write SetSortDirection default ascend;
    Property SortType : TChampsCompare read FSortType write SetSortType default cdcNone;
  end;

  var
  ClesTri: array[0..10] of TChampsCompare;

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
  if field='fonction' then TContact(Items[i]^).fonction:= value;
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
  k: PContact;
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
  vcsl := TStringList.Create;
  vcsl.LoadFromFile(filename);
  for i:= 0 to vcsl.count-1 do
  begin
    s:= vcsl.Strings[i];


    sup:= UpperCase(s);
    // We auto convert it to UTF8 if ansi detected
    sdata:= IsAnsi2Utf8(copy(s, LastDelimiter(':', s)+1, length(s)));
    Setlength(A, 0);
    A := sdata.Split(';');

    if sup= 'BEGIN:VCARD' then              // We have a new VCard
    begin
      new(K);
      MyCont.Longitude:= 0;
      MyCont.Latitude:= 0;
      MyCont.LongitudeWk:= 0;
      MyCont.LatitudeWk:= 0;
      photo:= false;
      continue;
    end;

        // If it is a phot0 field, so append line to b64string
    if photo then
    begin
      if length(s) > 0 then b64string:= b64string+s+#10 else
      // blank line, end of b64 code
      begin
        photo:= false;
        imgpath:= GetTempDir(true)+InttoStr(i)+'.jpg';
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


    if s= 'END:VCARD' then                  // End of the current VCard
    begin
      AddContact(MyCont);
      continue;
    end;

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
    // Photo field
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
  end;
  if assigned(ContactsXML) then ContactsXML.free;;
end;

function TContactsList.SaveToVCardfile(filename: string): Boolean;
begin

end;

end.

