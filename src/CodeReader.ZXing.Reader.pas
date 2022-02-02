{
  * Copyright 2007 ZXing authors
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

  * Original Authors: Sean Owen and dswitkin@google.com (Daniel Switkin)
  * Delphi Implementation by E. Spelt and K. Gossens
}

unit CodeReader.ZXing.Reader;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  CodeReader.ZXing.BinaryBitmap,
  CodeReader.ZXing.ReadResult,
  CodeReader.ZXing.DecodeHintType;

type
  /// <summary>
  /// Implementations of this interface can decode an image of a barcode in some format into
  /// the String it encodes. For example, <see cref="CodeReader.ZXing.QrCode.QRCodeReader" /> can
  /// decode a QR code. The decoder may optionally receive hints from the caller which may help
  /// it decode more quickly or accurately.
  ///
  /// See <see cref="MultiFormatReader" />, which attempts to determine what barcode
  /// format is present within the image as well, and then decodes it accordingly.
  /// </summary>
  IReader = interface
    /// <summary>
    /// Locates and decodes a barcode in some format within an image.
    /// </summary>
    /// <param name="image">image of barcode to decode</param>
    /// <returns>String which the barcode encodes</returns>
    function decode(const image: TBinaryBitmap): TReadResult; overload;

    /// <summary> Locates and decodes a barcode in some format within an image. This method also accepts
    /// hints, each possibly associated to some data, which may help the implementation decode.
    /// </summary>
    /// <param name="image">image of barcode to decode</param>
    /// <param name="hints">passed as a <see cref="IDictionary{TKey, TValue}" /> from <see cref="DecodeHintType" />
    /// to arbitrary data. The
    /// meaning of the data depends upon the hint type. The implementation may or may not do
    /// anything with these hints.
    /// </param>
    /// <returns>String which the barcode encodes</returns>
    function decode(const image: TBinaryBitmap; hints: TDictionary<TDecodeHintType, TObject>): TReadResult; overload;

    /// <summary>
    /// Resets any internal state the implementation has after a decode, to prepare it
    /// for reuse.
    /// </summary>
    procedure Reset();
  end;

implementation

end.
