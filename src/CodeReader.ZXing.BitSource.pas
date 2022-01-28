unit CodeReader.ZXing.BitSource;

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

uses 
  SysUtils, 
  CodeReader.ZXing.Common.Detector.MathUtils;

type

  TBitSource = class sealed
  private
    bytes: TArray<Byte>;
  public
    BitOffset: Integer;
    ByteOffset: Integer;
    constructor Create(bytes: TArray<Byte>);
    function available: Integer;
    function readBits(numBits: Integer): Integer;
  end;

implementation

{ TBitSource }

function TBitSource.available: Integer;
begin
  Result := 8 * (Length(self.bytes) - self.ByteOffset) - self.BitOffset;
end;

constructor TBitSource.Create(bytes: TArray<Byte>);
begin
  self.bytes := bytes;
end;

function TBitSource.readBits(numBits: Integer): Integer;
var
  bitsToNotRead, bitsLeft, toRead, mask: Integer;
begin
  if (((numBits < 1) or (numBits > $20)) or (numBits > available())) then
    raise EArgumentException.Create(numBits.ToString + 'numBits');

  Result := 0;
  if (BitOffset > 0) then
  begin

    bitsLeft := 8 - BitOffset;
    if (numBits < bitsLeft) then
      toRead := numBits
    else
      toRead := bitsLeft;

    bitsToNotRead := (bitsLeft - toRead);
    mask := TMathUtils.Asr($FF, ((8 - toRead) and $1F)) shl bitsToNotRead;
    Result := TMathUtils.Asr((self.bytes[self.ByteOffset] and mask),
      bitsToNotRead);

    dec(numBits, toRead);
    inc(BitOffset, toRead);

    if (BitOffset = 8) then
    begin
      BitOffset := 0;
      inc(ByteOffset)
    end
  end;

  if (numBits > 0) then
  begin

    while ((numBits >= 8)) do
    begin
      Result := ((Result shl 8) or (self.bytes[self.ByteOffset] and $FF));
      inc(self.ByteOffset);
      dec(numBits, 8)
    end;

    if (numBits > 0) then
    begin
      bitsToNotRead := 8 - numBits;
      mask := TMathUtils.Asr($FF, bitsToNotRead) shl bitsToNotRead;

      Result := (Result shl numBits) or
        TMathUtils.Asr((bytes[ByteOffset] and mask), bitsToNotRead);

      inc(BitOffset, numBits)
    end

  end;

end;

end.
