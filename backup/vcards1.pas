unit vcards1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, lazbbutils, math;

type
  TChampsCompare = (cdcNone, cdcName, cdcSurname, cdcPostcode, cdcTown,  cdcCountry, cdcLongit, cdcLatit);
  TSortDirections = (ascend, descend);

  PVCard = ^TVCard;
  TVCard = record
    version: string;
    name: string;    // Name field  (skip charset) : LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX)
    surname: string;
    fname: string;   // formated name
    pobox: string;
    lieudit: string;
    street: string;
    town: string;
    postcode: string;
    country: string;
    phone: string;
    mobile: string;
    email: string;
    web: string;
    Longitude: float;
    Latitude: float;
    Date: string;
    DateModif: string;
    Comment: string;
    fonction: string;
    Service: string;
    Company: string;
    poboxw: string;
    lieuditw: string;
    streetw: string;
    townw: string;
    pocodew: string;
    countryw: string;
    phonew: string;
    mobilew: string;
    Emailw:string;
    Webw:string;
    Longitudew: float;
    Latitudew: float;
  end;

  TVCardsList = class(TList)
  private
    FOnChange: TNotifyEvent;
    FSortType: TChampsCompare;
    FSortDirection: TSortDirections;
    //procedure SetSortDirection(Value: TSortDirections);
    //procedure SetSortType (Value: TChampsCompare);
    procedure DoSort;
  public
    Duplicates : TDuplicates;
    constructor Create;
    procedure Delete (const i : Integer);
    {procedure DeleteMulti (j, k : Integer); }
    procedure Reset;
    {procedure AddVCard(Contact : TContact);
    procedure ModifyVCard (const i: integer; Contact : TContact);
    procedure ModifyField (const i: integer; field: string; value: variant); }
    function GetItem(const i: Integer): TVCard;
    {function GetFloat(s: String): Float;
    function GetInt(s: String): INt64;
    function GetDate(s: string): TDateTime;
    function SaveVCardFile(iNode: TDOMNode): Boolean; }
    function ReadVCardFile(filename: string): Boolean;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    {property SortDirection: TSortDirections read FSortDirection write SetSortDirection default ascend;
    Property SortType : TChampsCompare read FSortType write SetSortType default cdcNone; }




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
  Entry1, Entry2: PVCard;
  R, J: integer;
  ResComp: array[TChampsCompare] of integer;
begin
  Entry1:= PVCard(Item1);
  Entry2:= PVCard(Item2);
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




constructor TVCardsList.Create;
begin
  inherited Create;
end;

procedure TVCardsList.Reset;
var
 i: Integer;
begin
 for i := 0 to Count-1 do
  if Items[i] <> nil then Items[i]:= nil;
 Clear;
end;

procedure TVCardsList.DoSort;
begin
  if FSortType <> cdcNone then
  begin
    ClesTri[1] := FSortType;
    //ClesTri[2] := cdcName;
    //ClesTri[3] := cdcDur;
    if FSortDirection = ascend then sort(@comparemulti) else sort(@comparemultidesc);
  end;
end;

procedure TVCardsList.Delete(const i: Integer);
begin
  inherited delete(i);
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TVCardsList.ReadVCardFile(filename: string): Boolean;
var
  vcsl : TStringList;
  s, s1, sup, sdata: string;
  A: TStringArray;
  i: integer;
  k: PVCard;
begin
  result:= false;
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
      continue;
    end;
  if s= 'END:VCARD' then                  // End of the current VCard
    begin
      add(K);
      continue;
    end;
    if pos('VERSION:', sup)= 1 then
    begin
      K^.version:= copy(s, 9, 5) ;
      continue;
    end;
    // Name field  (skip charset) : LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX
    if (pos('N:', sup)= 1) or (pos('N;', sup)= 1) then
    begin
      K^.name:= A[0];
      K^.surname:= A[1];
      continue;
    end;
    // home address field : Post Office Box; Extended Address; Street; Locality; Region; Postal Code; Country
    if (pos('ADR:', sup)= 1) or ((pos('ADR;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      K^.pobox:= A[0];
      K^.lieudit:= A[1];
      K^.street:= A[2];
      K^.town:= A[3];
      K^.pocode:= A[5];
      K^.country:= A[6];
      continue;
    end;
    // work address field : Post Office Box; Extended Address; Street; Locality; Region; Postal Code; Country
    if ((pos('ADR;', sup)= 1) and (pos('WORK', sup) > 0)) then
    begin
      K^.poboxw:= A[0];
      K^.lieuditw:= A[1];
      K^.streetw:= A[2];
      K^.townw:= A[3];
      K^.pocodew:= A[5];
      K^.countryw:= A[6];
      continue;
    end;
    // home phone field
    if (pos('TEL:', sup)= 1) then //or (pos('TEL;HOME', sup)= 1) or (pos('TEL;TYPE=HOME', sup)= 1)  then
    begin
      K^.phone:= s;
      continue;
    end;
   // can be fixed line or cell, home or work other cases nor relevant for this app
    if (pos('TEL;', sup)= 1) then
    begin
       if pos('CELL', sup) > 0 then       // Cell phone
       begin
         if pos('WORK', sup) > 0 then K^.mobilew:= sdata    // work cell phone
         else K^.mobile:= sdata;                            // home or other cell phone
       end else                                                    // fixes line phone
       begin
         if pos('WORK', sup) > 0 then K^.phonew:= sdata     // work phone line
         else K^.phone:= sdata;                             // home or other phone line
       end;
      continue;
    end;
    if (pos('EMAIL:', sup)= 1) or ((pos('EMAIL;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      K^.email:= sdata;
      continue;
    end;
    if (pos('EMAIL;', sup)= 1) and (pos('WORK', sup) > 0) then
    begin
      K^.Emailw:= sdata;
      continue;
    end;
    if (pos('URL:', sup)= 1) or ((pos('URL;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      s1:= copy(s, pos(':', s)+1, length(s));       // Need first ':' there is another one after http...
      K^.web:= s1;
      continue;
    end;
    if (pos('URL;', sup)= 1) and (pos('WORK', sup) > 0) then
    begin
      s1:= copy(s, pos(':', s)+1, length(s));       // Need first ':' there is another one after http...
      K^.Webw:= sdata;
    end;


  end;
  vcsl.free;

end;

function TVCardsList.GetItem(const i: Integer): TVCard;
begin
 Result := TVCard(Items[i]^);
end;


end.

