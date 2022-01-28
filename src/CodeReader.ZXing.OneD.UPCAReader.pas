unit CodeReader.ZXing.OneD.UPCAReader;
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

  * Original Authors: Sean Owen
  * Delphi Implementation by E. Spelt
}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Math,
  CodeReader.ZXing.OneD.OneDReader,
  CodeReader.ZXing.Common.BitArray,
  CodeReader.ZXing.BinaryBitmap,
  CodeReader.ZXing.ReadResult,
  CodeReader.ZXing.DecodeHintType,
  CodeReader.ZXing.ResultPoint,
  CodeReader.ZXing.BarcodeFormat,
  CodeReader.ZXing.Helpers,
  CodeReader.ZXing.OneD.EAN13Reader,
  CodeReader.ZXing.OneD.UPCEANReader;

type

  TUPCAReader = class(TUPCEANReader)
  private
    class var EAN13Reader: TUPCEANReader;
    class function maybeReturnResult(pResult: TReadResult): TReadResult; static;
    class procedure DoInitialize();
    class procedure DoFinalize();
  protected

  public
    class function DecodeMiddle(const row: IBitArray;
      const startRange: TArray<Integer>; const resultString: TStringBuilder)
      : Integer; override;

    function decode(const image: TBinaryBitmap;
      hints: TDictionary<TDecodeHintType, TObject>): TReadResult; override;

    function decodeRow(const rowNumber: Integer; const row: IBitArray;
      const hints: TDictionary<TDecodeHintType, TObject>): TReadResult;
      overload; override;

    function decodeRow(const rowNumber: Integer; const row: IBitArray;
      const startGuardRange: TArray<Integer>;
      const hints: TDictionary<TDecodeHintType, TObject>): TReadResult;
      reintroduce; overload;

    function BarcodeFormat: TBarcodeFormat; override;
  end;

implementation

{ TUPCAReader }

class procedure TUPCAReader.DoFinalize;
begin
  EAN13Reader.Free;
end;

class procedure TUPCAReader.DoInitialize;
begin
  EAN13Reader := TEAN13Reader.Create();
end;

function TUPCAReader.decode(const image: TBinaryBitmap;
  hints: TDictionary<TDecodeHintType, TObject>): TReadResult;
begin
  result := TUPCAReader.maybeReturnResult(self.EAN13Reader.decode(image, hints))
end;

class function TUPCAReader.DecodeMiddle(const row: IBitArray;
  const startRange: TArray<Integer>;
  const resultString: TStringBuilder): Integer;
begin
  result := self.EAN13Reader.DecodeMiddle(row, startRange, resultString)
end;

function TUPCAReader.decodeRow(const rowNumber: Integer; const row: IBitArray;
  const hints: TDictionary<TDecodeHintType, TObject>): TReadResult;
begin
  result := TUPCAReader.maybeReturnResult(self.EAN13Reader.decodeRow(rowNumber,
    row, hints))
end;

function TUPCAReader.decodeRow(const rowNumber: Integer; const row: IBitArray;
  const startGuardRange: TArray<Integer>;
  const hints: TDictionary<TDecodeHintType, TObject>): TReadResult;
begin
  result := TUPCAReader.maybeReturnResult
    (self.EAN13Reader.doDecodeRow(rowNumber, row, startGuardRange, hints))
end;

function TUPCAReader.BarcodeFormat: TBarcodeFormat;
begin
  result := TBarcodeFormat.UPC_A;
end;

class function TUPCAReader.maybeReturnResult(pResult: TReadResult): TReadResult;
begin
  if not Assigned(pResult) then
    Exit(nil);

{$ZEROBASEDstrings ON}
  if (copy(pResult.text, 0, 1) = '0') then
  begin
    pResult.text := copy(pResult.text, 2, length(pResult.text));
    pResult.BarcodeFormat := TBarcodeFormat.UPC_A;
  end;
{$ZEROBASEDstrings OFF}
  result := pResult;

end;

initialization

TUPCAReader.DoInitialize;

finalization

TUPCAReader.DoFinalize;


end.
