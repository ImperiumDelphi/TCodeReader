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

  * Delphi Implementation by K. Gossens
}

unit CodeReader.ZXing.OneD.UPCEANExtensionSupport;

interface

uses 
  System.SysUtils, 
  System.Generics.Collections,
  System.Math,
  CodeReader.ZXing.OneD.UPCEANExtension2Support,
  CodeReader.ZXing.OneD.UPCEANExtension5Support,
  CodeReader.ZXing.Reader,
  CodeReader.ZXing.BinaryBitmap,
  CodeReader.ZXing.ReadResult,
  CodeReader.ZXing.DecodeHintType,
  CodeReader.ZXing.ResultMetadataType,
  CodeReader.ZXing.ResultPoint,
  CodeReader.ZXing.Common.BitArray,
  CodeReader.ZXing.Common.Detector.MathUtils;

type
  TUPCEANExtensionSupport = class sealed
  private
    class var
      EXTENSION_START_PATTERN : TArray<Integer>;

      twoSupport : TUPCEANExtension2Support;
      fiveSupport : TUPCEANExtension5Support;

    class procedure InitializeClass; static;
    class procedure FinalizeClass; static;
  public
    function decodeRow(const rowNumber: Integer; const row: IBitArray;
      const rowOffset: Integer): TReadResult;
  end;

implementation

uses
  CodeReader.ZXing.OneD.UPCEANReader;

{ TUPCEANExtensionSupport }

class procedure TUPCEANExtensionSupport.InitializeClass();
begin
  EXTENSION_START_PATTERN := TArray<Integer>.Create(1, 1, 2);
  twoSupport := TUPCEANExtension2Support.Create();
  fiveSupport := TUPCEANExtension5Support.Create();
end;

class procedure TUPCEANExtensionSupport.FinalizeClass();
begin
  EXTENSION_START_PATTERN := nil;
  twoSupport.Free;
  fiveSupport.Free;
end;

function TUPCEANExtensionSupport.decodeRow(const rowNumber: Integer;
  const row: IBitArray; const rowOffset: Integer): TReadResult;
var
  extensionStartRange: TArray<Integer>;
  res : TReadResult;
begin
  Result := nil;

  extensionStartRange := TUPCEANReader.findGuardPattern(row, rowOffset,
    false, EXTENSION_START_PATTERN);
  if (extensionStartRange = nil)
  then
     exit;
  res := fiveSupport.decodeRow(rowNumber, row, extensionStartRange);
  if (res = nil)
  then
     res := twoSupport.decodeRow(rowNumber, row, extensionStartRange);
  Result := res;
end;

initialization
  TUPCEANExtensionSupport.InitializeClass;
finalization
  TUPCEANExtensionSupport.FinalizeClass;
end.
