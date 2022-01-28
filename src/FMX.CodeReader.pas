unit FMX.CodeReader;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Filter.Effects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,

  System.IOUtils,
  System.Messaging,
  FMX.Media,
  FMX.Surfaces,
  FMX.Platform,
  CodeReader.DW.Camera,
  CodeReader.DW.Types,
  CodeReader.DW.NativeImage,
  CodeReader.ZXing.ScanManager,
  CodeReader.ZXing.BarcodeFormat,
  CodeReader.ZXing.ReadResult;

Type

   TCodeType        = (Code1DVertical, Code1DHorizontal, Code2D);
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
         FOnStop          : TNotifyEvent;
         FOnStart         : TNotifyEvent;
         function GetIsActive   : Boolean;
         function GetBeepVolume : Single;
         procedure SetCodeType        (const Value: TCodeType);
         procedure SetIconColor       (const Value: TAlphaColor);
         procedure SetBeepVolume      (const Value: Single);
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
         PRocedure Paint; Override;
      Public
         Constructor Create(aOwner : TComponent); Override;
         Destructor Destroy; Override;
         Procedure Start;
         Procedure Stop;
         Property IsActive        : Boolean            Read GetIsActive;
      Published
         Property CodeType        : TCodeType          Read FCodeType         Write SetCodeType;
         Property ShowMask        : Boolean            Read FShowMask         Write FShowMask;
         Property ShowIconTypes   : Boolean            Read FShowIconTypes    Write FShowIconTypes;
         Property InProcess       : Boolean            Read FInProcess;
         Property PlaySound       : Boolean            Read FPlaySound        Write FPlaySound;
         Property BeepVolume      : Single             Read GetBeepVolume     Write SetBeepVolume;
         Property Text            : String             Read FText;
         Property IConColor       : TAlphaColor        Read FIconColor        Write SetIconColor;
         Property MaxImageWidth   : Integer            Read FMaxImageWidth    Write FmaxImageWidth;
         Property ValidSamples    : Integer            Read FValidSamples     Write FValidSamples;
         Property ImageWidth      : Integer            Read FImageWidth;
         Property ImageHeight     : Integer            Read FImageHeight;
         Property ImageStream     : TMemoryStream      Read FImageStream;
         Property OnCodeReady     : TCodeResult        Read FOnCodeReady      Write FOnCodeReady;
         Property OnImageCaptured : TNotifyEvent       Read FOnImageCaptured  Write FOnImageCaptured;
         Property OnStart         : TNotifyEvent       Read FOnStart          Write FOnStart;
         Property OnStop          : TNotifyEvent       Read FOnStop           Write FOnStop;
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

{$R ..\pkg\FMX.Resources.res }

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
   LAudioPath := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'Beep.wav');
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
ClipChildren     := True;
FPlaySound       := True;
FShowMask        := True;
FShowIconTypes   := True;
FMaxImageWidth   := 2100;
FValidSamples    := 2;
FValidCount      := 0;
IconColor        := TAlphacolors.White;
FImageStream     := TMemoryStream.Create;
FScan            := TScanManager .Create(TBarcodeFormat.Auto, Nil);
FCodeType        := TCodeType.Code1DVertical;
TMessageManager.DefaultManager.SubscribeToMessage(TApplicationEventMessage, AppEventMessage);
SetSize(100, 100);
end;

destructor TCodeReader.Destroy;
begin
If FCamera <> Nil Then
   Begin
   if FCamera.IsActive then
      Begin
      While FInProcess do Sleep(50);
      FCamera.IsActive := False;
      End;
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
var
  LSurf : TBitmapSurface;
{$ENDIF}
{$IFDEF ANDROID}
var
  T    : Cardinal;
  W, H : Integer;
  X, Y : Integer;
  Off  : Integer;
  Buf  : TArray<Byte>;
  Lums : TArray<Byte>;
{$ENDIF}
begin
if FInProcess then Exit;
FInProcess   := True;
FText        := '';
FTimerThread := TThread.GetTickCount;
FImageWidth  := FCamera.CapturedWidth;
FImageHeight := FCamera.CapturedHeight;

{$IFDEF ANDROID}
If FCamera.CameraOrientation = 90 Then
   Begin
   T := AImageStream.Size;
   H := FCamera.CapturedHeight;
   AImageStream.Position := 0;
   SetLength(Buf,  AImageStream.Size);
   AImageStream.Read(Buf, AImageStream.Size);
   case Self.CodeType of
      Code1DVertical:
         Begin
         W := Trunc(FCamera.CapturedWidth);
         H := Trunc(FCamera.CapturedHeight/4);
         SetLength(Lums, W*H);
         for Y := Trunc(H*1.5) to Trunc(H*1.5)+H-1 do System.Move(Buf[W*Y], Lums[W*(Y-Trunc(H*1.5))], W);
         End;
      Code1DHorizontal:
         Begin
         W   := Trunc(FCamera.CapturedWidth/4);
         Off := Trunc(W *1.5);
         SetLength(Lums, W*H);
         for Y := 0 to H-1 do System.Move(Buf[FCamera.CapturedWidth*Y+Off], Lums[W*Y], W);
         End;
      Code2D:
         Begin
         W   := Trunc(FCamera.CapturedWidth/2);
         Off := Trunc(FCamera.CapturedWidth/4);
         SetLength(Lums, W*H);
         for Y := 0 to H-1 do System.Move(Buf[FCamera.CapturedWidth*Y+Off], Lums[W*Y], W);
         End;
      end;
   FImageWidth  := W;
   FImageHeight := H;
   FImageStream.Clear;
   FImageStream.WriteData(Lums, W*H);
   End
Else
   Begin
   FImageStream.Clear;
   FImageStream.LoadFromStream(AImageStream);
   End;
{$ELSE}
FImageStream.Clear;
FImageStream.LoadFromStream(AImageStream);
{$ENDIF}
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
      LSurf.SetSize(FImageWidth, FImageHeight);
      TBitmapCodecManager.LoadFromStream(FImageStream, LSurf, 0);
      Code := FScan.Scan(LSurf);
      LSurf.DisposeOf;
      {$ELSE}
      Code := FScan.Scan(FImageStream, FImageWidth, FImageHeight);
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
   FTimer.Interval := 25;
   FTimer.Enabled  := True;
   End).Start;
end;

procedure TCodeReader.Click;
begin
inherited;
If FCamera.IsActive Then FCamera.DoFocus;
end;

procedure TCodeReader.TimerSampling(Sender: TObject);
begin
FTimer.Enabled      := False;
FScan .EnableQRCode := FCodeType = TCodeType.Code2D;
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
   LBitmap.Clear(Talphacolors.Null);
   LBitmap.Canvas.BeginScene;
   case FCodeType of
      Code1DVertical   : LRect := TRectF.Create(W/2 - (50*S), 10*S, W/2+(50*S), H-(10*S));
      Code1DHorizontal : LRect := TRectF.Create((10*S), H/2 - (50*S), W-(10*S), H/2+(50*S));
      Code2D           : LRect := TRectF.Create(W/2-(150*S), H/2-(150*S), W/2+(150*S), H/2+(150*S));
      end;
   LBitmap.Canvas.Fill.Color := TAlphacolors.Black;
   LBitmap.Canvas.FillRect(TRectF.Create(0, 0, W, H), 0, 0, [], 0.6);
   LBitmap.Canvas.Fill.Color := TAlphacolors.White;
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
   case FCodeType of
      Code1DVertical   : FIcon.LoadFromBitmap(FIcoBarCode90);
      Code1DHorizontal : FIcon.LoadFromBitmap(FIcoBarCode);
      Code2D           : FIcon.LoadFromBitmap(FIcoQRCode);
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
   0 : SetCodeType(TCodeType.Code1DHorizontal);
   1 : SetCodeType(TCodeType.Code1DVertical);
   2 : SetCodeType(TCodeType.Code2D);
   end;
FIcon.Tag := T;
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

function TCodeReader.GetBeepVolume: Single;
begin
Result := FAudio.Volume;
end;

procedure TCodeReader.Paint;
begin
inherited;
if (csDesigning in ComponentState) And Not Locked then DrawDesignBorder;
end;

procedure TCodeReader.SetBeepVolume(const Value: Single);
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
if Assigned(FOnStart) then FOnStart(Self);
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
   if Assigned(FOnStop) then FOnStop(Self);
   End;
end;

Initialization
RegisterFMXclasses([TCodeReader]);

end.

