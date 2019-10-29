unit vcarray;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, lazbbutils;

type
  TChampsCompare = (cdcNone, cdcName, cdcSurname, cdcPostcode, cdcTown,  cdcCountry, cdcLongit, cdcLatit);
  TSortDirections = (ascend, descend);

  TVCard2 = record
    version: string;
    name: string;    // Name field  (skip charset) : LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX)
    surname: string;
    fname: string;   // formated name
    pobox: string;
    lieudit: string;
    street: string;
    town: string;
    pocode: string;
    country: string;
    phone: string;
    mobile: string;
    email: string;
    web: string;
    Longitude: string;
    Latitude: string;
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
    Longitudew: string;
    Latitudew: string;
  end;

  TVCardsList = class(TList)
  private
    FOnChange: TNotifyEvent;
    FSortType: TChampsCompare;
    FSortDirection: TSortDirections;
    //procedure SetSortDirection(Value: TSortDirections);
    //procedure SetSortType (Value: TChampsCompare);
    //procedure DoSort;
  public
    Duplicates : TDuplicates;
    constructor Create(filename: string='');
    {procedure Delete (const i : Integer);
    procedure DeleteMulti (j, k : Integer);
    procedure Reset;
    procedure AddVCard(Contact : TContact);
    procedure ModifyVCard (const i: integer; Contact : TContact);
    procedure ModifyField (const i: integer; field: string; value: variant); }
    function GetItem(const i: Integer): TVCard2;
    {function GetFloat(s: String): Float;
    function GetInt(s: String): INt64;
    function GetDate(s: string): TDateTime;
    function SaveVCardFile(iNode: TDOMNode): Boolean; }
    function ReadVCardFile(filename: string): Boolean;
    {property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property SortDirection: TSortDirections read FSortDirection write SetSortDirection default ascend;
    Property SortType : TChampsCompare read FSortType write SetSortType default cdcNone; }




  end;

  Tvcardarr = array of TVCard2;

  function loadvcardarr(filename: string): Tvcardarr;
  function savevcardarray(cdarr: Tvcardarr; filename: string): boolean;



implementation

constructor TVCardsList.Create(filename: string='');
begin
  inherited Create;
  //ReadVCardFile(filename);
end;

function TVCardsList.ReadVCardFile(filename: string): Boolean;
var
  vcsl : TStringList;
  s, s1, sup, sdata: string;
  A: TStringArray;
  i: integer;
begin
end;

function TVCardsList.GetItem(const i: Integer): TVCard2;
begin
 Result := TVCard2(Items[i]^);
end;

function loadvcardarr(filename: string): Tvcardarr;
var
  vcsl : TStringList;
  vcarr: Tvcardarr;
  i, j: integer;
  s, s1: string;
  sup: string;
  sdata: string;
  A: TStringArray;
begin
  result:= vcarr;
  if not FileExists(filename) then exit;
  vcsl := TStringList.Create;
  vcsl.LoadFromFile(filename);
  j:= 0;
  for i:= 0 to vcsl.count-1 do
  begin
    s:= vcsl.Strings[i];
    sup:= UpperCase(s);
    sdata:= IsAnsi2Utf8(copy(s, LastDelimiter(':', s)+1, length(s)));
    Setlength(A, 0);
    A := sdata.Split(';');
    if sup= 'BEGIN:VCARD' then
    begin
       setlength(result, j+1);
    end;
    if pos('VERSION:', sup)= 1 then result[j].version:= copy(s, 9, 5) ;
    // Name field  (skip charset) : LASTNAME; FIRSTNAME; ADDITIONAL NAME; NAME PREFIX(Mr.,Mrs.); NAME SUFFIX
    // We auto convert it to UTF8 if ansi detected
    if (pos('N:', sup)= 1) or (pos('N;', sup)= 1) then
    begin
      result[j].name:= A[0];
      result[j].surname:= A[1];
    end;
    // home address field : Post Office Box; Extended Address; Street; Locality; Region; Postal Code; Country
    if (pos('ADR:', sup)= 1) or ((pos('ADR;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      result[j].pobox:= A[0];
      result[j].lieudit:= A[1];
      result[j].street:= A[2];
      result[j].town:= A[3];
      result[j].pocode:= A[5];
      result[j].country:= A[6];
    end;
    // work address field : Post Office Box; Extended Address; Street; Locality; Region; Postal Code; Country
    if ((pos('ADR;', sup)= 1) and (pos('WORK', sup) > 0)) then
    begin
      result[j].poboxw:= A[0];
      result[j].lieuditw:= A[1];
      result[j].streetw:= A[2];
      result[j].townw:= A[3];
      result[j].pocodew:= A[5];
      result[j].countryw:= A[6];
    end;
    // home phone field
    if (pos('TEL:', sup)= 1) then //or (pos('TEL;HOME', sup)= 1) or (pos('TEL;TYPE=HOME', sup)= 1)  then
    begin
       result[j].phone:= s;
    end;
    // can be fixed line or cell, home or work other cases nor relevant for this app
    if (pos('TEL;', sup)= 1) then
    begin
      if pos('CELL', sup) > 0 then       // Cell phone
      begin
        if pos('WORK', sup) > 0 then result[j].mobilew:= sdata    // work cell phone
        else result[j].mobile:= sdata;                            // home or other cell phone
      end else                                                    // fixes line phone
      begin
        if pos('WORK', sup) > 0 then result[j].phonew:= sdata     // work phone line
        else result[j].phone:= sdata;                             // home or other phone line
      end;
    end;
    if (pos('EMAIL:', sup)= 1) or ((pos('EMAIL;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      result[j].email:= sdata;
    end;
    if (pos('EMAIL;', sup)= 1) and (pos('WORK', sup) > 0) then
    begin
      result[j].Emailw:= sdata;
    end;
    if (pos('URL:', sup)= 1) or ((pos('URL;', sup)= 1) and (pos('WORK', sup) = 0)) then
    begin
      s1:= copy(s, pos(':', s)+1, length(s));       // Need first ':' there is another one after http...
      result[j].web:= s1;
    end;
    if (pos('URL;', sup)= 1) and (pos('WORK', sup) > 0) then
    begin
      s1:= copy(s, pos(':', s)+1, length(s));       // Need first ':' there is another one after http...
      result[j].Webw:= sdata;
    end;

    if s= 'END:VCARD' then
    begin
      inc (j);
    end;
  end;
  vcsl.free;
end;

function savevcardarray(cdarr: Tvcardarr; filename: string): boolean;
begin
  result:= true;
end;

end.

