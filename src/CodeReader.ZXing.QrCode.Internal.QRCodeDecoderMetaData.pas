{
  * Copyright 2013 ZXing authors
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

  * Delphi Implementation by E. Spelt and K. Gossens
}


unit CodeReader.ZXing.QrCode.Internal.QRCodeDecoderMetaData;

interface

uses 
  CodeReader.ZXing.ResultPoint;

type
  /// <summary>
  /// Meta-data container for QR Code decoding. Instances of this class may be used to convey information back to the
  /// decoding caller. Callers are expected to process this.
  /// </summary>
  TQRCodeDecoderMetaData = class sealed
  private
    Fmirrored: Boolean;
  public
    /// <summary>
    /// Initializes a new instance of the <see cref="TQRCodeDecoderMetaData"/> class.
    /// </summary>
    /// <param name="mirrored">if set to <c>true</c> [mirrored].</param>
    constructor Create(const mirrored: Boolean);

    /// <summary>
    /// Apply the result points' order correction due to mirroring.
    /// </summary>
    /// <param name="points">Array of points to apply mirror correction to.</param>
    procedure applyMirroredCorrection(const points: TArray<IResultPoint>);

    /// <summary>
    /// true if the QR Code was mirrored.
    /// </summary>
    property IsMirrored: boolean read Fmirrored;
  end;

implementation

{ TQRCodeDecoderMetaData }

constructor TQRCodeDecoderMetaData.Create(const mirrored: Boolean);
begin
  Fmirrored := mirrored;
end;

procedure TQRCodeDecoderMetaData.applyMirroredCorrection(
  const points: TArray<IResultPoint>);
var
  bottomLeft: IResultPoint;
begin
  if ((FMirrored and (points <> nil)) and (Length(points) >= 3)) then
  begin
    bottomLeft := points[0];
    points[0] := points[2];
    points[2] := bottomLeft;
    // No need to 'fix' top-left and alignment pattern.
  end
end;

end.
