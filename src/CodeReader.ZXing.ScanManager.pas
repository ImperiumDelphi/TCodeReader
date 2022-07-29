unit CodeReader.ZXing.ScanManager;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.classes,
  FMX.Graphics,
  FMX.Surfaces,
  FMX.Types,
  CodeReader.ZXing.LuminanceSource,
  CodeReader.ZXing.RGBLuminanceSource,
  CodeReader.ZXing.InvertedLuminanceSource,
  CodeReader.ZXing.HybridBinarizer,
  CodeReader.ZXing.BinaryBitmap,
  CodeReader.ZXing.MultiFormatReader,
  CodeReader.ZXing.BarcodeFormat,
  CodeReader.ZXing.ResultPoint,
  CodeReader.ZXing.ReadResult,
  CodeReader.ZXing.DecodeHintType;

type
  TScanManager = class
  private
    FEnableInversion: Boolean;
    FHints: TDictionary<TDecodeHintType, TObject>;
    FResultPointEvent: TResultPointCallback;
    FMultiFormatReader: TMultiFormatReader;
    listFormats: TList<TBarcodeFormat>;
    FEnableQRDCode: Boolean;

    function GetMultiFormatReader(const format: TBarcodeFormat) : TMultiFormatReader;
    procedure SetResultPointEvent(const AValue: TResultPointCallback);
  public
    destructor Destroy; override;

    function Scan(const pBitmapForScan: TBitmap): TReadResult; Overload;
    function Scan(const pBitmapForScan: TBitmapSurface): TReadResult; Overload;
    function Scan(const aLuminance : TMemoryStream; aWidth, aHeight : Integer): TReadResult;  Overload;
    constructor Create(const format: TBarcodeFormat; Hints: TDictionary<TDecodeHintType, TObject>);

    property OnResultPoint: TResultPointCallback read FResultPointEvent write SetResultPointEvent;
    property EnableQRCode : Boolean              Read FEnableQRDCode    Write FEnableQRDCode;
  end;

implementation

constructor TScanManager.Create(const format: TBarcodeFormat;
  Hints: TDictionary<TDecodeHintType, TObject>);
begin
  inherited Create;
  FEnableQRDCode     := True;
  FEnableInversion   := False;
  FHints             := Hints;
  FMultiFormatReader := GetMultiFormatReader(format);
end;

destructor TScanManager.Destroy;
var
  hint: TPair<TDecodeHintType, TObject>;
  o: TObject;
begin
  if Assigned(FHints) then
  begin

    for hint in FHints do
    begin
      o := hint.Value;
      if Assigned(o) then
        o.Free;
    end;

    FHints.Clear();
    FreeAndNil(FHints);
  end;

  FreeAndNil(FMultiFormatReader);
  inherited;
end;

procedure TScanManager.SetResultPointEvent(const AValue: TResultPointCallback);
var
  ahKey: TDecodeHintType;
  ahValue: TObject;
begin
  FResultPointEvent := AValue;

  ahKey := TDecodeHintType.NEED_RESULT_POINT_CALLBACK;
  if Assigned(FResultPointEvent) then
  begin
    ahValue := TResultPointEventObject.Create(FResultPointEvent);
    FHints.AddOrSetValue(ahKey, ahValue);
  end
  else
  begin
    if Fhints.TryGetValue(ahKey, ahValue) then
    begin
      ahValue.Free;
      ahValue := nil;
      FHints.Remove(ahKey);
    end;
  end;
end;

function TScanManager.GetMultiFormatReader(const format: TBarcodeFormat)
  : TMultiFormatReader;
var
  o: TObject;

begin
  Result := TMultiFormatReader.Create;
  listFormats := nil;

  if FHints = nil then
    FHints := TDictionary<TDecodeHintType, TObject>.Create();

  if FHints.ContainsKey(CodeReader.ZXing.DecodeHintType.ENABLE_INVERSION) then
    FEnableInversion := true;

  if format <> TBarcodeFormat.Auto then
  begin
    if (FHints.TryGetValue(CodeReader.ZXing.DecodeHintType.POSSIBLE_FORMATS, o)) then
      listFormats := o as TList<TBarcodeFormat>
    else
    begin
      listFormats := TList<TBarcodeFormat>.Create();
      FHints.Add(CodeReader.ZXing.DecodeHintType.POSSIBLE_FORMATS, listFormats);
    end;

    if (listFormats.Count = 0) then
      listFormats.Add(format)
    else
      listFormats.Insert(0, format); // favor the format parameter

  end;

  Result.Hints := FHints;
end;

function TScanManager.Scan(const pBitmapForScan: TBitmap): TReadResult;
var
  LuminanceSource, InvLuminanceSource: TLuminanceSource;
  HybridBinarizer: THybridBinarizer;
  BinaryBitmap: TBinaryBitmap;
begin
  InvLuminanceSource := nil;
  LuminanceSource := nil;
  HybridBinarizer := nil;
  BinaryBitmap := nil;
  try

   FMultiformatReader.EnableQRCode := Self.EnableQRCode;
    LuminanceSource := TRGBLuminanceSource.CreateFromBitmap(pBitmapForScan, pBitmapForScan.Width, pBitmapForScan.Height);
    HybridBinarizer := THybridBinarizer.Create(LuminanceSource);
    BinaryBitmap := TBinaryBitmap.Create(HybridBinarizer);
    Result := FMultiFormatReader.Decode(BinaryBitmap, true);

    if (Result = nil) then
    begin
      if (FEnableInversion) then
      begin
        if (BinaryBitmap <> nil) then
          FreeAndNil(BinaryBitmap);

        if (HybridBinarizer <> nil) then
          FreeAndNil(HybridBinarizer);

        InvLuminanceSource := LuminanceSource.invert();
        HybridBinarizer := THybridBinarizer.Create(InvLuminanceSource);
        BinaryBitmap := TBinaryBitmap.Create(HybridBinarizer);
        Result := FMultiFormatReader.Decode(BinaryBitmap, true);

      end;
    end;
  finally
    BinaryBitmap.Free;
    HybridBinarizer.Free;
    InvLuminanceSource.Free;
    LuminanceSource.Free;
  end;
end;

function TScanManager.Scan(const pBitmapForScan: TBitmapSurface): TReadResult;
var
   LuminanceSource, InvLuminanceSource: TLuminanceSource;
   HybridBinarizer: THybridBinarizer;
   BinaryBitmap: TBinaryBitmap;
begin
InvLuminanceSource := nil;
LuminanceSource := nil;
HybridBinarizer := nil;
BinaryBitmap := nil;
try

   FMultiformatReader.EnableQRCode := Self.EnableQRCode;
   LuminanceSource := TRGBLuminanceSource.CreateFromBitmapSurface(pBitmapForScan, pBitmapForScan.Width, pBitmapForScan.Height);
   HybridBinarizer := THybridBinarizer.Create(LuminanceSource);
   BinaryBitmap := TBinaryBitmap.Create(HybridBinarizer);
   Result := FMultiFormatReader.Decode(BinaryBitmap, true);

   if (Result = nil) then
      begin
      if (FEnableInversion) then
         begin
         if (BinaryBitmap    <> nil) then FreeAndNil(BinaryBitmap);
         if (HybridBinarizer <> nil) then FreeAndNil(HybridBinarizer);
         InvLuminanceSource := LuminanceSource.invert();
         HybridBinarizer := THybridBinarizer.Create(InvLuminanceSource);
         BinaryBitmap := TBinaryBitmap.Create(HybridBinarizer);
         Result := FMultiFormatReader.Decode(BinaryBitmap, true);
         end;
      end;

   if (Result = nil) then
      begin
      if (BinaryBitmap    <> nil) then FreeAndNil(BinaryBitmap);
      if (HybridBinarizer <> nil) then FreeAndNil(HybridBinarizer);
      pBitmapForScan.Rotate90;
      LuminanceSource := TRGBLuminanceSource.CreateFromBitmapSurface(pBitmapForScan, pBitmapForScan.Width, pBitmapForScan.Height);
      HybridBinarizer := THybridBinarizer.Create(LuminanceSource);
      BinaryBitmap    := TBinaryBitmap.Create(HybridBinarizer);
      Result          := FMultiFormatReader.Decode(BinaryBitmap, true);
      end;

finally
   BinaryBitmap      .Free;
   HybridBinarizer   .Free;
   InvLuminanceSource.Free;
   LuminanceSource   .Free;
   end;
end;

function TScanManager.Scan(const aLuminance : TMemoryStream; aWidth, aHeight : Integer): TReadResult;
var
   LuminanceSource    : TLuminanceSource;
   InvLuminanceSource : TLuminanceSource;
   HybridBinarizer    : THybridBinarizer;
   BinaryBitmap       : TBinaryBitmap;
begin
LuminanceSource    := Nil;
InvLuminanceSource := Nil;
HybridBinarizer    := Nil;
BinaryBitmap       := Nil;
try
   FMultiformatReader.EnableQRCode := Self.EnableQRCode;
   LuminanceSource := TRGBLuminanceSource.CreateFromStream(aLuminance, aWidth, aHeight);
   HybridBinarizer := THybridBinarizer.Create(LuminanceSource);
   BinaryBitmap    := TBinaryBitmap.Create(HybridBinarizer);
   Result          := FMultiFormatReader.Decode(BinaryBitmap, true);
   if (Result = nil) then
      begin
      if (BinaryBitmap    <> nil) then FreeAndNil(BinaryBitmap);
      if (HybridBinarizer <> nil) then FreeAndNil(HybridBinarizer);
      LuminanceSource.RotateCounterClockwise();
      HybridBinarizer    := THybridBinarizer.Create(LuminanceSource);
      BinaryBitmap       := TBinaryBitmap.Create(HybridBinarizer);
      Result             := FMultiFormatReader.Decode(BinaryBitmap, true);
      end;
   {$IFNDEF ANDROID}
   if (Result = nil) then
      begin
      if (FEnableInversion) then
         begin
         if (BinaryBitmap    <> nil) then FreeAndNil(BinaryBitmap);
         if (HybridBinarizer <> nil) then FreeAndNil(HybridBinarizer);
         InvLuminanceSource := LuminanceSource.invert();
         HybridBinarizer    := THybridBinarizer.Create(InvLuminanceSource);
         BinaryBitmap       := TBinaryBitmap.Create(HybridBinarizer);
         Result             := FMultiFormatReader.Decode(BinaryBitmap, true);
         end;
      end;
   {$ENDIF}

finally
   BinaryBitmap      .Free;
   HybridBinarizer   .Free;
   InvLuminanceSource.Free;
   LuminanceSource   .Free;
   end;

end;

end.
