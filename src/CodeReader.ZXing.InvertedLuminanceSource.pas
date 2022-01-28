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

  * Original Author: dswitkin@google.com (Daniel Switkin)
  * Delphi Implementation by K. Gossens
}

unit CodeReader.ZXing.InvertedLuminanceSource;

interface

uses
  System.SysUtils,
  CodeReader.ZXing.LuminanceSource;

type
  TInvertedLuminanceSource = class sealed(TLuminanceSource)
  private
    delegate: TLuminanceSource;
    invertedMatrix: TArray<Byte>;
  public
    constructor Create(delegate: TLuminanceSource); reintroduce;

    function crop(const left, top, width, height: Integer): TLuminanceSource; override;
    function getRow(const y: Integer; row: TArray<Byte>): TArray<Byte>; override;
    function rotateCounterClockwise(): TLuminanceSource; override;
    function rotateCounterClockwise45(): TLuminanceSource; override;

    function invert: TLuminanceSource; override;
    function Matrix: TArray<Byte>; override;
    function CropSupported: Boolean; override;
    function RotateSupported: Boolean; override;
  end;

implementation

{ TInvertedLuminanceSource }

/// <summary>
/// Initializes a new instance of the <see cref="InvertedLuminanceSource"/> class.
/// </summary>
/// <param name="delegate">The @delegate.</param>
constructor TInvertedLuminanceSource.Create(delegate: TLuminanceSource);
begin
  inherited Create(delegate.Width, delegate.Height);
  Self.delegate := delegate;
end;
  
/// <summary>
/// Fetches one row of luminance data from the underlying platform's bitmap. Values range from
/// 0 (black) to 255 (white). Because Java does not have an unsigned byte type, callers will have
/// to bitwise and with 0xff for each value. It is preferable for implementations of this method
/// to only fetch this row rather than the whole image, since no 2D Readers may be installed and
/// getMatrix() may never be called.
/// </summary>
/// <param name="y">The row to fetch, 0 &lt;= y &lt; Height.</param>
/// <param name="row">An optional preallocated array. If null or too small, it will be ignored.
/// Always use the returned object, and ignore the .length of the array.</param>
/// <returns>
/// An array containing the luminance data.
/// </returns>
function TInvertedLuminanceSource.getRow(const y: Integer; row: TArray<Byte>): TArray<Byte>;
var
  rowArray : TArray<Byte>;
  i, width : Integer;
begin
  rowArray := delegate.getRow(y, row);
  width := Self.Width;
  for i := 0 to Pred(width) do
    rowArray[i] := (255 - (row[i] and $FF));
  
  Result := rowArray;
end;

/// <summary>
/// Fetches luminance data for the underlying bitmap. Values should be fetched using:
/// int luminance = array[y * width + x] &amp; 0xff;
/// </summary>
/// <returns> A row-major 2D array of luminance values. Do not use result.length as it may be
/// larger than width * height bytes on some platforms. Do not modify the contents
/// of the result.
///   </returns>
function TInvertedLuminanceSource.Matrix: TArray<Byte>;
var
  matrixArray: TArray<Byte>;
  i, len: Integer;
begin
  if (invertedMatrix = nil) then
  begin
    matrixArray := delegate.Matrix;
    len := Self.Width * Self.Height;
    invertedMatrix := TArray<Byte>.Create();
    SetLength(invertedMatrix, len);
    for i := 0 to Pred(len) do
      invertedMatrix[i] := (255 - (matrixArray[i] and $FF));

    Result := invertedMatrix;
  end;
end;

/// <summary>
/// </summary>
/// <returns> Whether this subclass supports cropping.</returns>
function TInvertedLuminanceSource.CropSupported: Boolean;
begin
  Result := delegate.CropSupported;
end;

/// <summary>
/// Returns a new object with cropped image data. Implementations may keep a reference to the
/// original data rather than a copy. Only callable if CropSupported is true.
/// </summary>
/// <param name="left">The left coordinate, 0 &lt;= left &lt; Width.</param>
/// <param name="top">The top coordinate, 0 &lt;= top &lt;= Height.</param>
/// <param name="width">The width of the rectangle to crop.</param>
/// <param name="height">The height of the rectangle to crop.</param>
/// <returns>
/// A cropped version of this object.
/// </returns>
function TInvertedLuminanceSource.crop(const left, top,
  width, height: Integer): TLuminanceSource;
begin
  Result := TInvertedLuminanceSource.Create(Self.delegate.crop(left, top,
    width, height));
end;

function TInvertedLuminanceSource.invert: TLuminanceSource;
begin
  Result := self.delegate;
end;

function TInvertedLuminanceSource.rotateCounterClockwise(): TLuminanceSource;
begin
  Result := TInvertedLuminanceSource.Create(Self.delegate.rotateCounterClockwise);
end;

function TInvertedLuminanceSource.rotateCounterClockwise45(): TLuminanceSource;
begin
  Result := TInvertedLuminanceSource.Create(Self.delegate.rotateCounterClockwise45);
end;

function TInvertedLuminanceSource.RotateSupported: Boolean;
begin
  Result := delegate.RotateSupported;;
end;

end.
