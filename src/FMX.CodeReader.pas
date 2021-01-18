unit FMX.CodeReader;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Filter.Effects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,

  System.IOUtils,
  System.Messaging,
  FMX.Media,
  FMX.Surfaces,
  FMX.Platform,
  DW.Camera,
  DW.Types,
  DW.NativeImage,
  ZXing.ScanManager,
  ZXing.BarcodeFormat,
  ZXing.ReadResult,

  FMX.Android.Permissions;

Type

   TCodeType        = (Codes1D, Codes2D, CodesAll);
   TCodeOrientation = (CodeVertical, CodeHorizontal);
   TCodeResult      = Procedure (aCode : String) Of Object;

   [ComponentPlatformsAttribute (pidAllPlatforms)]
   TCodeReader = Class(TControl)
      Private
         FCamera          : TCamera;
         FPreview         : TLayout;
         FMask            : TNativeImage;
         FIcon            : TNativeImage;
         FScan            : TScanManager;
         FTimer           : TTimer;
         FImageStream     : TMemoryStream;
         FCodeType        : TCodeType;
         FCodeOrientation : TCodeOrientation;
         FOnCodeReady     : TCodeResult;
         FAudio           : TMediaPlayer;
         FIconColor       : TAlphaColor;
         FIcoQRCode       : TBitmap;
         FIcoBarcode      : TBitmap;
         FicoBarCode90    : TBitmap;
         FInProcess       : Boolean;
         FPlaySound       : Boolean;
         FShowMask        : Boolean;
         FShowIconTypes   : Boolean;
         FText            : String;
         FTextCheck       : String;
         FMaxImageWidth   : Integer;
         FValidSamples    : Integer;
         FValidCount      : Integer;
         FImageHeight     : Integer;
         FImageWidth      : Integer;
         FTimerThread     : Cardinal;
         FOnImageCaptured : TNotifyEvent;
         function GetIsActive      : Boolean;
         function GetSoundVolume   : Single;
         procedure SetCodeOrientation (const Value: TCodeOrientation);
         procedure SetCodeType        (const Value: TCodeType);
         procedure SetIconColor       (const Value: TAlphaColor);
         procedure SetSoundVolume     (const Value: Single);
         procedure AppEventMessage    (const Sender: TObject; const M: TMessage);
         procedure CameraImageCaptured(Sender: TObject; const AImageStream: TStream);
         procedure TimerSampling      (Sender: TObject);
         procedure TypeSelect         (Sender: TObject);
         Procedure CreateMask;
         procedure CreateCamera;
         procedure ShowIcon;
      Protected
         Procedure Resize; Override;
         Procedure DoCodeReady; Virtual;
         Procedure Click; Override;
      Public
         Constructor Create(aOwner : TComponent); Override;
         Destructor Destroy; Override;
         Procedure Start;
         Procedure Stop;
         Property IsActive        : Boolean            Read GetIsActive;
      Published
         Property CodeType        : TCodeType          Read FCodeType         Write SetCodeType;
         Property CodeOrientation : TCodeOrientation   Read FCodeOrientation  Write SetCodeOrientation;
         Property ShowMask        : Boolean            Read FShowMask         Write FShowMask;
         Property ShowIconTypes   : Boolean            Read FShowIconTypes    Write FShowIconTypes;
         Property InProcess       : Boolean            Read FInProcess;
         Property PlaySound       : Boolean            Read FPlaySound        Write FPlaySound;
         Property SoundVolume     : Single             Read GetSoundVolume    Write SetSoundVolume;
         Property Text            : String             Read FText;
         Property IConColor       : TAlphaColor        Read FIconColor        Write SetIconColor;
         Property MaxImageWidth   : Integer            Read FMaxImageWidth    Write FmaxImageWidth;
         Property ValidSamples    : Integer            Read FValidSamples     Write FValidSamples;
         Property ImageWidth      : Integer            Read FImageWidth;
         Property ImageHeight     : Integer            Read FImageHeight;
         Property ImageStream     : TMemoryStream      Read FImageStream;
         Property OnCodeReady     : TCodeResult        Read FOnCodeReady      Write FOnCodeReady;
         Property OnImageCaptured : TNotifyEvent       Read FOnImageCaptured  Write FOnImageCaptured;
         Property HitTest;
         Property Width;
         Property Height;
         Property Size;
         Property Position;
         Property Align;
         Property Anchors;
         Property Padding;
         Property Margins;
         Property Enabled;
         Property Visible;
      End;

implementation

{ TCodeReader }

Procedure TCodeReader.CreateCamera;
Begin
FCamera                       := TCamera.Create;
FCamera.CameraPosition        := TDevicePosition.Back;
FCamera.OnImageCaptured       := CameraImageCaptured;
FCamera.OnAuthorizationStatus := Nil;
FCamera.OnStatusChange        := Nil;
FCamera.PreviewControl.Parent := FPreview;
FCamera.MaxImageWidth         := FMaxImageWidth;
FCamera.MaxPreviewWidth       := 720;
End;

constructor TCodeReader.Create(aOwner: TComponent);

   Procedure CreatePreview;
   Begin
   FPreview         := TLayout.Create(Self);
   FPreview.Stored  := False;
   FPreview.Align   := TAlignLayout.Contents;
   FPreview.Parent  := Self;
   FPreview.Visible := False;
   FPreview.HitTest := False;
   End;

   Procedure CreateMaskView;
   Begin
   FMask         := TNativeImage.Create(Self);
   FMask.Stored  := False;
   FMask.Align   := TAlignLayout.Client;
   FMask.Parent  := Self;
   FMask.Visible := False;
   FMask.HitTest := False;
   FMask.BringToFront;
   End;

   Procedure CreateTimer;
   Begin
   FTimer         := TTimer.Create(Self);
   FTimer.Stored  := False;
   FTimer.Enabled := False;
   FTimer.OnTimer := TimerSampling;
   End;

   Procedure CreateBeep;
   Var
      LRC        : TResourceStream;
      LAudioPath : String;
   Begin
   LAudioPath := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'beep.wav');
   If Not FileExists(LAudioPath) Then
      Begin
      LRC := TResourceStream.Create(HInstance, 'is_Beep', RT_RCDATA);
      LRC.SaveToFile(LAudioPath);
      LRC.DisposeOf;
      End;
   FAudio          := TMediaPlayer.Create(Self);
   FAudio.Stored   := False;
   FAudio.FileName := LAudioPath;
   End;

   Procedure CreateIcons;
   Var
      LRC     : TResourceStream;
   Begin
   FIcoQRCode    := TBitmap.Create;
   FIcoBarcode   := TBitmap.Create;
   FIcoBarCode90 := TBitmap.Create;
   FIcon         := TNativeImage.Create(Self);
   FIcon.Stored  := False;
   FIcon.Parent  := Self;
   FIcon.Tag     := 0;
   FIcon.OnClick := TypeSelect;
   FIcon.HitTest := True;
   FIcon.Visible := False;
   LRC := TResourceStream.Create(HInstance, 'is_QRCodeScan',  RT_RCDATA);
   FIcoQRCode.LoadFromStream(LRC);
   LRC.DisposeOf;
   LRC := TResourceStream.Create(HInstance, 'is_BarCodeScan', RT_RCDATA);
   FIcoBarCode  .LoadFromStream(LRC);
   FIcoBarCode90.LoadFromStream(LRC);
   LRC.DisposeOf;
   FIcoBarCode90.Rotate(90);
   End;

begin
inherited;
CreatePreview;
CreateMaskView;
CreateTimer;
CreateBeep;
CreateIcons;
FCamera          := Nil;
FPlaySound       := True;
FShowMask        := True;
FShowIconTypes   := True;
FMaxImageWidth   := 1000;
FValidSamples    := 2;
FValidCount      := 0;
IconColor        := TAlphaColors.White;
FImageStream     := TMemoryStream.Create;
FScan            := TScanManager .Create(TBarcodeFormat.Auto, Nil);
FCodeType        := TCodeType.Codes1D;
FCodeOrientation := TCodeOrientation.CodeVertical;
TMessageManager.DefaultManager.SubscribeToMessage(TApplicationEventMessage, AppEventMessage);
SetSize(100, 240);
end;

destructor TCodeReader.Destroy;
begin
If FCamera <> Nil Then
   Begin
   if FCamera.IsActive then FCamera.IsActive := False;
   FCamera.DisposeOf;
   End;
FPreview     .DisposeOf;
FMask        .DisposeOf;
FImageStream .DisposeOf;
FScan        .DisposeOf;
FIcoQRCode   .DisposeOf;
FIcoBarcode  .DisposeOf;
FIcoBarCode90.DisposeOf;
FIcon        .DisposeOf;
inherited;
end;

procedure TCodeReader.AppEventMessage(const Sender: TObject; const M: TMessage);
var
  LEvent: TApplicationEvent;
begin
LEvent := TApplicationEventMessage(M).Value.Event;
If LEvent = TApplicationEvent.EnteredBackground Then Stop;
end;

procedure TCodeReader.DoCodeReady;
begin
TTHread.Queue(Nil,
   Procedure
   Begin
   FTextCheck := '';
   FAudio.Play;
   OnCodeReady(FText);
   End);
end;

procedure TCodeReader.CameraImageCaptured(Sender: TObject; const AImageStream: TStream);
{$IFDEF IOS}
Var
   LSurf : TBitmapSurface;
{$ENDIF}
begin
if FInProcess then Exit;
FInProcess   := True;
FText        := '';
FTimerThread := TThread.GetTickCount;
FImageWidth  := FCamera.CapturedWidth;
FImageHeight := FCamera.CapturedHeight;
FImageStream.Clear;
FImageStream.LoadFromStream(AImageStream);
FImageStream.Position := 0;
if Assigned(FOnImageCaptured) then OnImageCaptured(Self);
TThread.CreateAnonymousThread(
   Procedure
   Var
      Code : TReadResult;
   Begin
   Try
      {$IFDEF IOS}
      LSurf := TBitmapSurface.Create;
      LSurf.SetSize(Trunc(FCamera.CapturedWidth), Trunc(FCamera.CapturedHeight));
      TBitmapCodecManager.LoadFromStream(FImageStream, LSurf, 0);
      Code := FScan.Scan(LSurf);
      LSurf.DisposeOf;
      {$ELSE}
      Code := FScan.Scan(FImageStream, FCamera.CapturedWidth, FCamera.CapturedHeight);
      {$ENDIF}
      if Code <> Nil then
         Begin
         if Code.Text <> FTextCheck     then FValidCount := 0;
         if FValidCount = 0             then FTextCheck  := Code.Text;
         if FTextCheck  = Code.text     then Inc(FValidCount);
         if FValidCount = FValidSamples then FText       := Code.text;
         Code.DisposeOf;
         End
      Else
         FValidCount := 0;
   Except
      End;
   FInProcess := False;
   if Not(FText.IsEmpty) And Assigned(OnCodeReady) then DoCodeReady;
   if TThread.GetTickCount - FTimerThread > 400 then
      FTimer.Interval := 25
   Else
      FTimer.Interval := 250;
   FTimer.Enabled := True;
   End).Start;
end;

procedure TCodeReader.Click;
begin
inherited;
//If FCamera.IsActive Then FCamera.DoFocus;
end;

procedure TCodeReader.TimerSampling(Sender: TObject);
begin
FTimer.Enabled      := False;
FScan .EnableQRCode := (FCodeType = TCodeType.Codes2D) or (FCodeType = TCodeType.CodesAll);
if Assigned(FCamera) And FCamera.IsActive Then
   If  Not(FInProcess) then
      Begin
      FCamera.CaptureImage;
      End
   Else
      Begin
      FTimer.Interval := 400;
      FTimer.Enabled  := FCamera.IsActive;
      End;
end;

procedure TCodeReader.CreateMask;
Var
   LBitmap : TBitmap;
   LStream : TMemoryStream;
   LRect   : TRectF;
   LEffect : TColorKeyAlphaEffect;
   W, H, S : Single;
   LScr    : IFMXScreenService;
begin
if FShowMask then
   Begin
   if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, LScr) then
      S := LScr.GetScreenScale
   Else
      S := 1;
   W       := Width  * S;
   H       := Height * S;
   LEffect := TColorKeyAlphaEffect.Create(Self);
   LStream := TMemoryStream.Create;
   LBitmap := TBitmap.Create;
   LBitmap.SetSize(Trunc(W), Trunc(H));
   LBitmap.Clear(TalphaColors.Null);
   LBitmap.Canvas.BeginScene;
   if FCodeType = TCodeType.Codes1d then
      Begin
      case FCodeOrientation of
         CodeVertical   : LRect := TRectF.Create(W/2 - (50*S), 10*S, W/2+(50*S), H-(10*S));
         CodeHorizontal : LRect := TRectF.Create((10*S), H/2 - (50*S), W-(10*S), H/2+(50*S));
         end;
      End
   Else
      Begin
      LRect := TRectF.Create(W/2-(150*S), H/2-(150*S), W/2+(150*S), H/2+(150*S));
      End;
   LBitmap.Canvas.Fill.Color := TAlphaColors.Black;
   LBitmap.Canvas.FillRect(TRectF.Create(0, 0, W, H), 0, 0, [], 0.6);
   LBitmap.Canvas.Fill.Color := TAlphaColors.White;
   LBitmap.Canvas.FillRect(LRect, 12*S, 12*S, AllCorners, 1);
   LBitmap.Canvas.EndScene;
   LEffect.ColorKey  := TAlphaColorRec.White;
   LEffect.Tolerance := 0.1;
   LEffect.ProcessEffect(LBitmap.Canvas, LBitmap, 0);
   LBitmap.SaveToStream(LStream);
   FMask.LoadFromStream(LStream);
   LStream.DisposeOf;
   LBitmap.DisposeOf;
   LEffect.DisposeOf;
   FMask.BringToFront;
   FIcon.BringToFront;
   End;
ShowIcon;
end;

procedure TCodeReader.Resize;
begin
inherited;
CreateMask;
end;

procedure TCodeReader.ShowIcon;
begin
if FShowIconTypes then
   Begin
   FIcon.Width      := 40;
   FIcon.Height     := 40;
   FIcon.Position.X := Width - 48;
   FIcon.Position.Y := 8;
   if FCodeType = TCodeType.Codes2D then
      FIcon.LoadFromBitmap(FIcoQRCode)
   Else
      case FCodeOrientation of
         CodeVertical   : FIcon.LoadFromBitmap(FIcoBarCode90);
         CodeHorizontal : FIcon.LoadFromBitmap(FIcoBarCode);
         end;
   FIcon.BringToFront;
   End;
end;

procedure TCodeReader.TypeSelect(Sender: TObject);
Var
   T : Integer;
begin
T := FIcon.Tag;
Inc(T);
if T > 2 then T := 0;
case T of
   0 : Begin
       SetCodeType(TCodeType.Codes1D);
       SetCodeOrientation(TCodeOrientation.CodeVertical);
       End;
   1 : Begin
       SetCodeType(TCodeType.Codes1D);
       SetCodeOrientation(TCodeOrientation.CodeHorizontal);
       End;
   2 : Begin
       SetCodeType(TCodeType.Codes2D);
       End;
   end;
FIcon.Tag := T;
end;

procedure TCodeReader.SetCodeOrientation(const Value: TCodeOrientation);
begin
If FCodeOrientation <> Value Then
   Begin
   FCodeOrientation := Value;
   CreateMask;
   End;
end;

procedure TCodeReader.SetCodeType(const Value: TCodeType);
begin
If FCodeType <> Value Then
   Begin
   FCodeType := Value;
   CreateMask;
   End;
end;

procedure TCodeReader.SetIconColor(const Value: TAlphaColor);
Var
   LEffect : TFillRGBEffect;
begin
FIconColor    := Value;
LEffect       := TFillRGBEffect.Create(Self);
LEffect.Color := FIconColor;
LEffect.ProcessEffect(FIcoQRCode   .Canvas, FIcoQRCode,    0);
LEffect.ProcessEffect(FIcoBarCode  .Canvas, FIcoBarCode,   0);
LEffect.ProcessEffect(FIcoBarCode90.Canvas, FIcoBarCode90, 0);
LEffect.DisposeOf;
ShowIcon;
end;

function TCodeReader.GetIsActive: Boolean;
begin
Result := (FCamera <> Nil) And FCamera.IsActive;
end;

function TCodeReader.GetSoundVolume: Single;
begin
Result := FAudio.Volume;
end;

procedure TCodeReader.SetSoundVolume(const Value: Single);
begin
FAudio.Volume := Value;
end;

procedure TCodeReader.Start;
begin
if FCamera = Nil then CreateCamera;
FPreview.Size     := Self.Size;
FPreview.Visible  := True;
FMask   .Visible  := FShowMask;
FIcon   .Visible  := FShowIconTypes;
FCamera .IsActive := True;
FTimer  .Interval := 800;
FTimer  .Enabled  := True;
FInProcess        := False;
end;

procedure TCodeReader.Stop;
begin
while FInProcess do Sleep(50);
if FCamera <> Nil then
   Begin
   FTimer  .Enabled  := False;
   FCamera .IsActive := False;
   FPreview.Visible  := False;
   FMask   .Visible  := False;
   FIcon   .Visible  := False;
   FInProcess        := False;
   End;
end;

Initialization
RegisterFMXClasses([TCodeReader]);

end.
