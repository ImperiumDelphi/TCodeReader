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

  * Original Authors: dswitkin@google.com (Daniel Switkin), Sean Owen and
  *                   alasdair@google.com (Alasdair Mackintosh)
  *
  * Delphi Implementation by E. Spelt
}

unit CodeReader.ZXing.OneD.EAN8Reader;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Math,
  CodeReader.ZXing.OneD.OneDReader,
  CodeReader.ZXing.Common.BitArray,
  CodeReader.ZXing.OneD.UPCEANReader,
  CodeReader.ZXing.ReadResult,
  CodeReader.ZXing.DecodeHintType,
  CodeReader.ZXing.ResultPoint,
  CodeReader.ZXing.BarcodeFormat;

type
  /// <summary>
  /// <p>Implements decoding of the EAN-8 format.</p>
  /// </summary>
  TEAN8Reader = class(TUPCEANReader)

  private
    class var DecodeMiddleCounters: TArray<Integer>;

    class procedure DoInitialize();
    class procedure DoFinalize();
  public
    class function DecodeMiddle(const row: IBitArray;
      const startRange: TArray<Integer>; const resultString: TStringBuilder)
      : Integer; override;

    function BarcodeFormat: TBarcodeFormat; override;
  end;

implementation

function TEAN8Reader.BarcodeFormat: TBarcodeFormat;
begin
  result := TBarcodeFormat.EAN_8;
end;

class procedure TEAN8Reader.DoFinalize;
begin
  DecodeMiddleCounters := nil;
end;

class procedure TEAN8Reader.DoInitialize;
begin
  SetLength(DecodeMiddleCounters, 4);
end;

class function TEAN8Reader.DecodeMiddle(const row: IBitArray;
  const startRange: TArray<Integer>;
  const resultString: TStringBuilder): Integer;
var
  ending, rowOffset, x, bestMatch: Integer;
  counter: Integer;
  counters, middleRange: TArray<Integer>;
begin
  counters := self.DecodeMiddleCounters;
  counters[0] := 0;
  counters[1] := 0;
  counters[2] := 0;
  counters[3] := 0;
  ending := row.Size;
  rowOffset := startRange[1];
  x := 0;
  while (((x < 4) and (rowOffset < ending))) do
  begin
    if (not TUPCEANReader.decodeDigit(row, counters, rowOffset,
      TUPCEANReader.L_PATTERNS, bestMatch)) then
    begin
      result := -1;
      exit
    end;

    resultString.Append(IntToStr(bestMatch));

    for counter in counters do
    begin
      inc(rowOffset, counter)
    end;
    inc(x)
  end;

  middleRange := TUPCEANReader.findGuardPattern(row, rowOffset, true,
    TUPCEANReader.MIDDLE_PATTERN);
  if (middleRange = nil) then
  begin
    result := -1;
    exit
  end;

  rowOffset := middleRange[1];
  x := 0;
  while (((x < 4) and (rowOffset < ending))) do
  begin
    if (not TUPCEANReader.decodeDigit(row, counters, rowOffset,
      TUPCEANReader.L_PATTERNS, bestMatch)) then
    begin
      result := -1;
      exit
    end;

    resultString.Append(IntToStr(bestMatch));
    for counter in counters do
    begin
      inc(rowOffset, counter)
    end;

    inc(x)
  end;

  result := rowOffset;

end;

initialization

TEAN8Reader.DoInitialize;

finalization

TEAN8Reader.DoFinalize;

end.

