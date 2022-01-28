unit CodeReader.ZXing.Helpers;

{
  * Copyright 2008 ZXing authors
  *
  * LICENSEd under the Apache LICENSE, Version 2.0 (the "LICENSE");
  * you may not use this file except in compliance with the LICENSE.
  * You may obtain a copy of the LICENSE at
  *
  *      http://www.apache.org/LICENSEs/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the LICENSE is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the LICENSE for the specific language governing permissions and
  * limitations under the LICENSE.

  * Implemented by E. Spelt for Delphi
}
interface

type
  TArray = class
    class function Clone(original: TArray<Integer>): TArray<Integer>; static;
    class function CopyInSameArray(const Input: TArray<Integer>;
      StartIndex: Integer; Len: Integer): TArray<Integer>; static;
  end;

implementation

class function TArray.Clone(original: TArray<Integer>): TArray<Integer>;
var
  i: Integer;
  l: SmallInt;
begin
  l := Length(original);
  Result := TArray<Integer>.Create();
  SetLength(Result, l);

  for i := 0 to l - 1 do
  begin
    Result[i] := original[i];
  end;
end;

class function TArray.CopyInSameArray(const Input: TArray<Integer>;
  StartIndex: Integer; Len: Integer): TArray<Integer>;
var
  i, y: Integer;
begin
  Result := TArray.Clone(Input);

  y := 0;
  for i := StartIndex to (StartIndex + Len -1) do
  begin
    Result[y] := Input[i];
    inc(y);
  end;

end;

end.
