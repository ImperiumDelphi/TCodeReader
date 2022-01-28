unit CodeReader.ZXing.DecoderResult;

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

uses SysUtils,
     Generics.Collections,
     CodeReader.ZXIng.ByteSegments;

type
  TDecoderResult = class
  private
    function GetStructuredAppend: boolean;
  public
    ByteSegments: IByteSegments;
    ECLevel: string;
    Erasures: Integer;
    ErrorsCorrected: Integer;
    Other: TObject;
    RawBytes: TArray<Byte>;
    StructuredAppendParity: Integer;
    StructuredAppendSequenceNumber: Integer;
    Text: string;

    constructor Create(RawBytes: TArray<Byte>; const Text: string;
      ByteSegments: IByteSegments; ECLevel: string); overload;
    constructor Create(RawBytes: TArray<Byte>; const Text: string;
      ByteSegments: IByteSegments; ECLevel: string; saSequence: Integer;
      saParity: Integer); overload;
    destructor Destroy; override;

    property StructuredAppend: boolean read GetStructuredAppend;
  end;

implementation

{ TDecoderResult }

constructor TDecoderResult.Create(RawBytes: TArray<Byte>; const Text: String;
  ByteSegments: IByteSegments; ECLevel: String);
begin
  Self.Create(RawBytes, Text, ByteSegments, ECLevel, -1, -1);
end;

constructor TDecoderResult.Create(RawBytes: TArray<Byte>; const Text: string;
  ByteSegments: IByteSegments; ECLevel: string;
  saSequence, saParity: Integer);
begin
  if ((RawBytes = nil) and (Text = ''))
  then
     raise EArgumentException.Create('Text or rawbytes cannot be nil or empty');

  Self.RawBytes := RawBytes;
  Self.Text := Text;
  Self.ByteSegments := ByteSegments;
  Self.ECLevel := ECLevel;
  Self.StructuredAppendParity := saParity;
  Self.StructuredAppendSequenceNumber := saSequence
end;

destructor TDecoderResult.Destroy;
begin
  if Assigned(ByteSegments)
  then
     ByteSegments.Clear;

  RawBytes := nil;
  FreeAndNil(Other);

  inherited;
end;

function TDecoderResult.GetStructuredAppend: boolean;
begin
  result := (StructuredAppendParity >= 0) and
    (StructuredAppendSequenceNumber >= 0);
end;

end.
