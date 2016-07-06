unit SortList;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

 uses SysUtils, Classes, RTLConsts;

 type

 TSortList = class(TList)
   FSorted: Boolean;
   FDuplicates: TDuplicates;
   procedure SetSorted(Value: Boolean);
  protected
   function CompareItems(const I1, I2: Pointer): Integer; virtual; abstract;
  public
   function Add(Item: Pointer): Integer; overload;
   function Find(const Item: Pointer; var Index: Integer): Boolean; virtual;
   procedure QuickSort(L, R: Integer);
   function IndexOf(Item: Pointer): Integer; overload;
   property Duplicates: TDuplicates read FDuplicates write FDuplicates;
   property Sorted: Boolean read FSorted write SetSorted;
 end;

implementation

{ TSortList }

function TSortList.Add(Item: Pointer): Integer;
begin
  if not Sorted then Result := inherited IndexOf(Item) else
  begin
    if Find(Item, Result) then
      case Duplicates of
        dupIgnore: Exit;
        dupError: Error(SDuplicateItem, Integer(Item));
      end;
    Insert(Result,Item)
  end;
end;

function TSortList.Find(const Item: Pointer; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareItems(Items[I], Item);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;



function TSortList.IndexOf(Item: Pointer): Integer;
begin
 if not Sorted then Result := inherited IndexOf(Item) else
   if not Find(Item, Result) then Result := -1;
end;

procedure TSortList.SetSorted(Value: Boolean);
begin
 if FSorted <> Value then
  begin
    if Value and (Count > 0) then QuickSort(0,Count-1);
    FSorted := Value;
  end;
end;

procedure TSortList.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
  T : Pointer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while CompareItems(Items[I], Items[P]) < 0 do Inc(I);
      while CompareItems(Items[J], Items[P]) > 0 do Dec(J);
      if I <= J then
      begin
        T := Items[I];
        Items[I] := Items[J];
        Items[J] := T;
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;


end.
