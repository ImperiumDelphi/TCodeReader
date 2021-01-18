unit DW.Camera.Android;

{*******************************************************}
{                                                       }
{                      Kastri                           }
{                                                       }
{         Delphi Worlds Cross-Platform Library          }
{                                                       }
{    Copyright 2020 Dave Nottage under MIT license      }
{  which is located in the root folder of this library  }
{                                                       }
{*******************************************************}

{$I DW.GlobalDefines.inc}
interface

uses
  // RTL
  System.Classes, System.Types,
  // Android
  Androidapi.JNIBridge, Androidapi.JNI.Util, Androidapi.Gles, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Os, Androidapi.JNI.Media,
  // FMX
  FMX.Controls, FMX.Graphics, FMX.Types,
  // DW
  DW.Camera, DW.Androidapi.JNI.Os, DW.Androidapi.JNI.Hardware.Camera2, DW.Androidapi.JNI.DWCameraHelpers, DW.Androidapi.JNI.View, DW.CameraPreview;

type
  TPlatformCamera = class;

  TCaptureMode = (None, Still, Faces);

  TCameraCaptureSession = class(TObject)
  private
    FCameraView: JDWCameraView;
    FCaptureRequest: TCaptureMode;
    FCaptureSessionCaptureCallback: JDWCameraCaptureSessionCaptureCallback;
    FCaptureSessionCaptureCallbackDelegate: JDWCameraCaptureSessionCaptureCallbackDelegate;
    FCaptureSessionStateCallback: JDWCameraCaptureSessionStateCallback;
    FCaptureSessionStateCallbackDelegate: JDWCameraCaptureSessionStateCallbackDelegate;
    FIsCapturing: Boolean;
    FIsStarting: Boolean;
    FHandler: JHandler;
    FPlatformCamera: TPlatformCamera;
    FPreview: TCameraPreview;
    FPreviewSurface: JSurface;
    FRequestedOrientation: Integer;
    FRequestHelper: JDWCaptureRequestBuilderHelper;
    FSession: JCameraCaptureSession;
    FStillImageAvailableListener: JImageReader_OnImageAvailableListener;
    FStillImageReader: JImageReader;
    FStillImageOrientation: Integer;
    FSurfaceTexture: JSurfaceTexture;
    FSurfaceTextureListener: JTextureView_SurfaceTextureListener;
    FThread: JHandlerThread;
    FFirst : Boolean;
    FPreviewSize : TSizeF;
    FMaxImageWidth: Integer;
    FCapturedWidth: Integer;
    FCapturedHeight: Integer;
    procedure AddLocation(const AStream: TMemoryStream);
    procedure CaptureCompleted(session: JCameraCaptureSession; request: JCaptureRequest; result: JTotalCaptureResult); virtual;
    procedure CaptureProgressed(session: JCameraCaptureSession; request: JCaptureRequest; partialResult: JCaptureResult); virtual;
    procedure CaptureSessionConfigured(session: JCameraCaptureSession); virtual;
    procedure CaptureSessionConfigureFailed(session: JCameraCaptureSession); virtual;
    procedure CheckFaces(const AHelper: JDWCaptureResultHelper);
    procedure CreatePreviewSurface;
    procedure CreateStillReader;
    function GetOrientation(const ARotation: Integer): Integer;
    function GetPreviewControl: TControl;
    procedure InternalStartSession;
    procedure OrientationChangeHandler(Sender: TObject);
    procedure SizeChangeHandler(Sender: TObject);
    procedure StartThread;
    procedure StopThread;
    procedure UpdateFlashMode;
    procedure UpdatePreview;
    procedure SetMaxImageWidth(const Value: Integer);
  protected
    procedure CaptureImage(const ACaptureRequest: TCaptureMode);
    procedure ImageAvailable(reader: JImageReader);
    procedure StartSession;
    procedure StopSession;
    procedure SurfaceTextureAvailable(surface: JSurfaceTexture; width: Integer; height: Integer);
    procedure SurfaceTextureDestroyed(surface: JSurfaceTexture);
    property IsCapturing: Boolean read FIsCapturing;
    property PreviewControl: TControl read GetPreviewControl;
    property Handler: JHandler read FHandler;
    property PlatformCamera: TPlatformCamera read FPlatformCamera;
    property Session: JCameraCaptureSession read FSession;
  public
    constructor Create(const APlatformCamera: TPlatformCamera);
    destructor Destroy; override;
    Property MaxImageWidth  : Integer Read FMaxImageWidth Write SetMaxImageWidth;
    Property CapturedWidth  : Integer Read FCapturedWidth;
    Property CapturedHeight : Integer Read FCapturedHeight;
  end;

  TPlatformCamera = class(TCustomPlatformCamera)
  private
    FAvailableViewSizes: TJavaObjectArray<Jutil_Size>;
    FCameraDevice: JCameraDevice;
    FCameraManager: JCameraManager;
    FCameraOrientation: Integer;
    FCaptureSession: TCameraCaptureSession;
    FDetectionDateTime: TDateTime;
    FFaces: TFaces;
    FFacesDetected: Boolean;
    FDeviceStateCallback: JDWCameraDeviceStateCallback;
    FDeviceStateCallbackDelegate: JDWCameraDeviceStateCallbackDelegate;
    FHandler: JHandler;
    FViewSize: Jutil_Size;
    FCaptureSize : TSize;
    FLensDistance : Integer;
    procedure DoOpenCamera;
    procedure UpdateViewSize;
    function GetIsSwapping: Boolean;
  protected
    procedure SetMaxImageWidth(const Value: Integer); Override;
    procedure CameraDisconnected(camera: JCameraDevice);
    procedure CameraError(camera: JCameraDevice; error: Integer);
    procedure CameraOpened(camera: JCameraDevice);
    procedure CapturedStillImage(const AImageStream: TStream; const ACaptureRequest: TCaptureMode);
    procedure CloseCamera; override;
    procedure DetectedFaces(const AFaces: TJavaObjectArray<JFace>);
    procedure DoCaptureImage; override;
    function GetHighestFaceDetectMode: TFaceDetectMode;
    function GetPreviewControl: TControl; override;
    function GetResolutionHeight: Integer; override;
    function GetResolutionWidth: Integer; override;
    function GetCapturedHeight: Integer; Override;
    function GetCapturedWidth: Integer; Override;
    function GetCameraOrientation: Integer; Override;
    procedure OpenCamera; override;
    procedure RequestPermission; override;
    procedure StartCapture; override;
    procedure StopCapture; override;
    procedure StillCaptureFailed;
    function SizeFitsInPreview(const ASize: Jutil_Size): Boolean;
    property CameraDevice: JCameraDevice read FCameraDevice;
    property CameraOrientation: Integer read FCameraOrientation;
    property IsSwapping: Boolean read GetIsSwapping;
    property ViewSize: Jutil_Size read FViewSize;
  public
    constructor Create(const ACamera: TCamera); override;
    destructor Destroy; override;
  end;

implementation

uses
  // RTL
  System.SysUtils, System.DateUtils, System.Math, System.Permissions, System.IOUtils, System.Sensors,
  // Android
  Androidapi.Helpers, Androidapi.JNI, Androidapi.JNI.App, Androidapi.JNI.JavaTypes,
  // FMX
  FMX.Forms, FMX.Media,
  // DW
  DW.CameraPreview.Android, DW.Android.Helpers, DW.Consts.Android, DW.UIHelper, DW.Types;

const
  cCaptureModeCaptions: array[TCaptureMode] of string = ('None', 'Still', 'Faces');

type
  TDWCameraDeviceStateCallbackDelegate = class(TJavaLocal, JDWCameraDeviceStateCallbackDelegate)
  private
    FPlatformCamera: TPlatformCamera;
  public
    { JDWCameraDeviceStateCallbackDelegate }
    procedure Disconnected(camera: JCameraDevice); cdecl;
    procedure Error(camera: JCameraDevice; error: Integer); cdecl;
    procedure Opened(camera: JCameraDevice); cdecl;
  public
    constructor Create(const APlatformCamera: TPlatformCamera);
  end;

  TDWCameraCaptureSessionCaptureCallbackDelegate = class(TJavaLocal, JDWCameraCaptureSessionCaptureCallbackDelegate)
  private
    FCaptureSession: TCameraCaptureSession;
  public
    { JDWCameraCaptureSessionCaptureCallbackDelegate }
    procedure CaptureProgressed(session: JCameraCaptureSession; request: JCaptureRequest; partialResult: JCaptureResult); cdecl;
    procedure CaptureCompleted(session: JCameraCaptureSession; request: JCaptureRequest; result: JTotalCaptureResult); cdecl;
  public
    constructor Create(const ACaptureSession: TCameraCaptureSession);
  end;

  TDWCameraCaptureSessionStateCallbackDelegate = class(TJavaLocal, JDWCameraCaptureSessionStateCallbackDelegate)
  private
    FCaptureSession: TCameraCaptureSession;
  public
    { JDWCameraCaptureSessionStateCallbackDelegate }
    procedure ConfigureFailed(session: JCameraCaptureSession); cdecl;
    procedure Configured(session: JCameraCaptureSession); cdecl;
  public
    constructor Create(const ACaptureSession: TCameraCaptureSession);
  end;

  TImageAvailableListener = class(TJavaLocal, JImageReader_OnImageAvailableListener)
  private
    FCaptureSession: TCameraCaptureSession;
    // FImageType: TImageType;
  public
    { JImageReader_OnImageAvailableListener }
    procedure onImageAvailable(reader: JImageReader); cdecl;
  public
    constructor Create(const ACaptureSession: TCameraCaptureSession);
  end;

  TSurfaceTextureListener = class(TJavaLocal, JTextureView_SurfaceTextureListener)
  private
    FCaptureSession: TCameraCaptureSession;
    // FImageType: TImageType;
  public
    { JTextureView_SurfaceTextureListener }
    procedure onSurfaceTextureAvailable(surface: JSurfaceTexture; width: Integer; height: Integer); cdecl;
    function onSurfaceTextureDestroyed(surface: JSurfaceTexture): Boolean; cdecl;
    procedure onSurfaceTextureUpdated(surface: JSurfaceTexture); cdecl;
    procedure onSurfaceTextureSizeChanged(surface: JSurfaceTexture; width: Integer; height: Integer); cdecl;
  public
    constructor Create(const ACaptureSession: TCameraCaptureSession);
  end;

function GetSizeArea(const ASize: Jutil_Size): Integer;
begin
  Result := ASize.getHeight * ASize.getWidth;
end;

function GetImageFormat(const AFormat: Integer): string;
begin
Result := 'Unknown';
if AFormat = TJImageFormat.JavaClass.JPEG then
   Result := 'JPEG'
else
   if AFormat = TJImageFormat.JavaClass.YUV_420_888 then
      Result := 'YUV_420_888';
end;

function ValueToDegrees(const AValue: Double): string;
var
  LValue: Double;
  LDegrees, LMinutes: Integer;
begin
  LValue := Abs(AValue);
  LDegrees := Trunc(LValue);
  LValue := (LValue - LDegrees) * 60;
  LMinutes := Trunc(LValue);
  LValue := (LValue - LMinutes) * 60;
  Result := Format('%d/1,%d/1,%d/1000', [LDegrees, LMinutes, Round(LValue)]);
end;

{ TDWCameraDeviceStateCallbackDelegate }

constructor TDWCameraDeviceStateCallbackDelegate.Create(const APlatformCamera: TPlatformCamera);
begin
  inherited Create;
  FPlatformCamera := APlatformCamera;
end;

procedure TDWCameraDeviceStateCallbackDelegate.Disconnected(camera: JCameraDevice);
begin
  FPlatformCamera.CameraDisconnected(camera);
end;

procedure TDWCameraDeviceStateCallbackDelegate.Error(camera: JCameraDevice; error: Integer);
begin
  FPlatformCamera.CameraError(camera, error);
end;

procedure TDWCameraDeviceStateCallbackDelegate.Opened(camera: JCameraDevice);
begin
  FPlatformCamera.CameraOpened(camera);
end;

{ TDWCameraCaptureSessionCaptureCallbackDelegate }

constructor TDWCameraCaptureSessionCaptureCallbackDelegate.Create(const ACaptureSession: TCameraCaptureSession);
begin
  inherited Create;
  FCaptureSession := ACaptureSession;
end;

procedure TDWCameraCaptureSessionCaptureCallbackDelegate.CaptureCompleted(session: JCameraCaptureSession; request: JCaptureRequest;
  result: JTotalCaptureResult);
begin
//Log.d('CaptureCompleted');

  FCaptureSession.CaptureCompleted(session, request, result);
end;

procedure TDWCameraCaptureSessionCaptureCallbackDelegate.CaptureProgressed(session: JCameraCaptureSession; request: JCaptureRequest;
  partialResult: JCaptureResult);
begin
//Log.d('CaptureProcessed');

  FCaptureSession.CaptureProgressed(session, request, partialResult);
end;

{ TDWCameraCaptureSessionStateCallbackDelegate }

constructor TDWCameraCaptureSessionStateCallbackDelegate.Create(const ACaptureSession: TCameraCaptureSession);
begin
  inherited Create;
  FCaptureSession := ACaptureSession;
end;

procedure TDWCameraCaptureSessionStateCallbackDelegate.Configured(session: JCameraCaptureSession);
begin
  FCaptureSession.CaptureSessionConfigured(session);
end;

procedure TDWCameraCaptureSessionStateCallbackDelegate.ConfigureFailed(session: JCameraCaptureSession);
begin
  FCaptureSession.CaptureSessionConfigureFailed(session);
end;

constructor TImageAvailableListener.Create(const ACaptureSession: TCameraCaptureSession);
begin
  inherited Create;
  FCaptureSession := ACaptureSession;
end;

procedure TImageAvailableListener.onImageAvailable(reader: JImageReader);
begin
  FCaptureSession.ImageAvailable(reader);
end;

{ TSurfaceTextureListener }

constructor TSurfaceTextureListener.Create(const ACaptureSession: TCameraCaptureSession);
begin
  inherited Create;
  FCaptureSession := ACaptureSession;
end;

procedure TSurfaceTextureListener.onSurfaceTextureAvailable(surface: JSurfaceTexture; width, height: Integer);
begin
//Log.d('OnSurfaceAvaliable');
  FCaptureSession.SurfaceTextureAvailable(surface, width, height);
end;

function TSurfaceTextureListener.onSurfaceTextureDestroyed(surface: JSurfaceTexture): Boolean;
begin
  FCaptureSession.SurfaceTextureDestroyed(surface);
  Result := True;
end;

procedure TSurfaceTextureListener.onSurfaceTextureSizeChanged(surface: JSurfaceTexture; width, height: Integer);
begin
  //
end;

procedure TSurfaceTextureListener.onSurfaceTextureUpdated(surface: JSurfaceTexture);
begin
//Log.d('OnSurfaceUpdated');
  //
end;

{ TCameraCaptureSession }

constructor TCameraCaptureSession.Create(const APlatformCamera: TPlatformCamera);
begin
inherited Create;
FMaxImageWidth  := 0;
FPlatformCamera := APlatformCamera;
FRequestHelper  := TJDWCaptureRequestBuilderHelper.JavaClass.init;
FCaptureSessionCaptureCallbackDelegate := TDWCameraCaptureSessionCaptureCallbackDelegate.Create(Self);
FCaptureSessionCaptureCallback         := TJDWCameraCaptureSessionCaptureCallback.JavaClass.init(FCaptureSessionCaptureCallbackDelegate);
FCaptureSessionStateCallbackDelegate   := TDWCameraCaptureSessionStateCallbackDelegate.Create(Self);
FCaptureSessionStateCallback           := TJDWCameraCaptureSessionStateCallback.JavaClass.init(FCaptureSessionStateCallbackDelegate);
FPreview                     := TCameraPreview.Create(nil);
FPreview.Align               := TAlignLayout.Center;
FPreview.OnOrientationChange := OrientationChangeHandler;
FPreview.OnSizeChange        := SizeChangeHandler;
FSurfaceTextureListener      := TSurfaceTextureListener.Create(Self);
FCameraView                  := TAndroidCameraPreview(FPreview.Presentation).View;
FCameraView.setSurfaceTextureListener(FSurfaceTextureListener);
StartThread;
end;

destructor TCameraCaptureSession.Destroy;
begin
  FPreview.Free;
  StopThread;
  inherited;
end;

function TCameraCaptureSession.GetOrientation(const ARotation: Integer): Integer;
var
  LRotation: Integer;
begin
if ARotation = TJSurface.JavaClass.ROTATION_90  then LRotation := 0   else
if ARotation = TJSurface.JavaClass.ROTATION_0   then LRotation := 90  else
if ARotation = TJSurface.JavaClass.ROTATION_270 then LRotation := 180 else
if ARotation = TJSurface.JavaClass.ROTATION_180 then LRotation := 270
else
   LRotation := 0;
Result := (LRotation + FPlatformCamera.CameraOrientation + 270) mod 360;
end;

function TCameraCaptureSession.GetPreviewControl: TControl;
begin
Result := FPreview;
end;

procedure TCameraCaptureSession.StartThread;
begin
  FThread := TJHandlerThread.JavaClass.init(StringToJString('CameraPreview'));
  FThread.start;
  FHandler := TJHandler.JavaClass.init(FThread.getLooper);
end;

procedure TCameraCaptureSession.StopThread;
begin
  FThread.quitSafely;
  FThread.join;
  FThread := nil;
  FHandler := nil;
end;

procedure TCameraCaptureSession.CreatePreviewSurface;
begin
FPreviewSurface := nil;
FSurfaceTexture.setDefaultBufferSize(PlatformCamera.ViewSize.getWidth, PlatformCamera.ViewSize.getHeight);
FPreviewSurface := TJSurface.JavaClass.init(FSurfaceTexture);
UpdatePreview;
if FIsStarting then
   InternalStartSession;
end;

procedure TCameraCaptureSession.SurfaceTextureAvailable(surface: JSurfaceTexture; width, height: Integer);
begin
FSurfaceTexture := surface;
CreatePreviewSurface;
end;

procedure TCameraCaptureSession.SurfaceTextureDestroyed(surface: JSurfaceTexture);
begin
FSurfaceTexture := nil;
end;

procedure TCameraCaptureSession.OrientationChangeHandler(Sender: TObject);
begin
  //
end;

procedure TCameraCaptureSession.SetMaxImageWidth(const Value: Integer);
begin
if MaxImageWidth <> Value then
   Begin
   FMaxImageWidth := Value;
   CreateStillReader;
   End;
end;

procedure TCameraCaptureSession.SizeChangeHandler(Sender: TObject);
begin
if FIsCapturing then
   UpdatePreview;
end;

procedure TCameraCaptureSession.UpdatePreview;
var
   LScale,
   LScreenScale : Single;
   LSize        : TSizeF;
   LViewSize,
   LPreviewSize : TSize;
   LIsPortrait  : Boolean;
begin
LIsPortrait := Screen.Height > Screen.Width;
if LIsPortrait then
   LViewSize := TSize.Create(PlatformCamera.ViewSize.getWidth, PlatformCamera.ViewSize.getHeight)
else
   LViewSize := TSize.Create(PlatformCamera.ViewSize.getHeight, PlatformCamera.ViewSize.getWidth);
if LIsPortrait then
   LSize := TSizeF.Create(FPreview.ParentControl.Height * (LViewSize.cy / LViewSize.cx), FPreview.ParentControl.Height)
else
   LSize := TSizeF.Create(FPreview.ParentControl.Width, FPreview.ParentControl.Width * (LViewSize.cx / LViewSize.cy));

// Parte 2 da gambiarra para funcionar no 10.3.3, o FPreview.size não pode ser alterado.

{$If Defined(VER330)}
if FFirst then FPreviewSize.Create(LSize);
{$ELSE}
FPreview.Size.Size := LSize;   // Aqui dá o problema no 10.3.3
{$ENDIF}

LScreenScale := TAndroidCameraPreview(FPreview.Presentation).ScreenScale;
LPreviewSize := TSize.Create(Round(FPreview.Size.Size.cx * LScreenScale), Round(FPreview.Size.Size.cy * LScreenScale));
FCameraView.setPreviewSize(TJutil_Size.JavaClass.init(LPreviewSize.cx, LPreviewSize.cy));
FFirst := False;
end;

procedure TCameraCaptureSession.CreateStillReader;
begin
if Platformcamera.ViewSize = Nil then Exit;
FStillImageAvailableListener := nil;
FStillImageAvailableListener := TImageAvailableListener.Create(Self);
FStillImageReader            := nil;
if FMaxImageWidth = 0 then
   FStillImageReader := TJImageReader.JavaClass.newInstance(PlatformCamera.ViewSize.getWidth,          PlatformCamera.ViewSize.getHeight,          TJImageFormat.JavaClass.YUV_420_888, 1)
//   FStillImageReader := TJImageReader.JavaClass.newInstance(PlatformCamera.ViewSize.getWidth,          PlatformCamera.ViewSize.getHeight,          TJImageFormat.JavaClass.JPEG, 1)
Else
//   FStillImageReader := TJImageReader.JavaClass.newInstance(Trunc(FPlatformcamera.FCaptureSize.Width), Trunc(FPlatformcamera.FCaptureSize.Height), TJImageFormat.JavaClass.JPEG, 1);
   FStillImageReader := TJImageReader.JavaClass.newInstance(Trunc(FPlatformcamera.FCaptureSize.Width), Trunc(FPlatformcamera.FCaptureSize.Height), TJImageFormat.JavaClass.YUV_420_888, 1);
FStillImageReader.setOnImageAvailableListener(FStillImageAvailableListener, Handler);
end;

procedure TCameraCaptureSession.InternalStartSession;
var
   LOutputs: JArrayList;
begin
FIsStarting := False;
LOutputs := TJArrayList.JavaClass.init(2);
LOutputs.add(FPreviewSurface);
LOutputs.add(FStillImageReader.getSurface);
FPlatformCamera.CameraDevice.createCaptureSession(TJList.Wrap(TAndroidHelper.JObjectToID(LOutputs)), FCaptureSessionStateCallback, FHandler);

// Aqui uma ganbiarra para funcionar no 10.3.3, não achei o erro ao alterar o FPreview.size.
// Então fiz a alteração aqui, a primeira passagem armazena o valor de size, e ele é alterado
// aqui antes da segunda execução

{$If Defined(VER330)}
if FPreviewSize <> FPreview.Size.Size then
   TThread.CreateAnonymousThread(
      Procedure
      Begin
      while FFirst do Sleep(50);
      Sleep(100);
      TThread.Queue(Nil,
         Procedure
         Begin
         StopSession;
         FPreview.Size.Size := FPreviewSize;
         FPreview.Visible   := True;
         CreateStillReader;
         if FSurfaceTexture <> nil then
           InternalStartSession
         else
           FIsStarting := True;
         End);
      End).Start;
{$ENDIF}
end;

procedure TCameraCaptureSession.StartSession;
begin
if FPreview.ParentControl <> nil then
   begin
   FFirst := True;
   FPreview.Visible := True;
   CreateStillReader;
   if FSurfaceTexture <> nil then
      InternalStartSession
   else
      FIsStarting := True;
   end;
end;

procedure TCameraCaptureSession.StopSession;
begin
  if FSession <> nil then
  begin
    FSession.close;
    FSession := nil;
  end;
  if not FPlatformCamera.IsSwapping then
    FPreview.Visible := False;
  FIsCapturing := False;
end;


procedure TCameraCaptureSession.CaptureImage(const ACaptureRequest: TCaptureMode);
var
  LBuilder : JCaptureRequest_Builder;
Begin
FCaptureRequest := ACaptureRequest;
LBuilder        := FPlatformCamera.CameraDevice.createCaptureRequest(TJCameraDevice.JavaClass.TEMPLATE_STILL_CAPTURE);
LBuilder.addTarget(FStillImageReader.getSurface);
FRequestHelper.setCaptureRequestBuilder(LBuilder);
//Aqui Rotação
//FRequestedOrientation := GetOrientation(TAndroidHelper.Activity.getWindowManager.getDefaultDisplay.getRotation);
//FRequestedOrientation := GetOrientation(0);
UpdateFlashMode;
FSession.capture(LBuilder.build, FCaptureSessionCaptureCallback, FHandler);
end;

procedure TCameraCaptureSession.UpdateFlashMode;
begin
FRequestHelper.setIntegerValue(TJCaptureRequest.JavaClass.CONTROL_SCENE_MODE, TJCameraMetadata.JavaClass.CONTROL_SCENE_MODE_BARCODE);
FRequestHelper.setIntegerValue(TJCaptureRequest.JavaClass.CONTROL_MODE,       TJCameraMetadata.JavaClass.CONTROL_MODE_USE_SCENE_MODE);

//FRequestHelper.setIntegerValue(TJCaptureRequest.JavaClass.CONTROL_AWB_MODE,   TJCameraMetadata.JavaClass.CONTROL_AWB_MODE_FLUORESCENT);
//FRequestHelper.setIntegerValue(TJCaptureRequest.JavaClass.CONTROL_AF_MODE,     TJCameraMetadata.JavaClass.CONTROL_AF_MODE_'OFF);

//FRequestHelper.setIntegerValue(TJCaptureRequest.JavaClass.CONTROL_MODE, TJCameraMetadata.JavaClass.CONTROL_MODE_AUTO);
case FPlatformCamera.FlashMode of
   TFlashMode.FlashOff  : FRequestHelper.setIntegerValue(TJCaptureRequest.JavaClass.FLASH_MODE, TJCaptureRequest.JavaClass.FLASH_MODE_OFF);
   TFlashMode.FlashOn   : FRequestHelper.setIntegerValue(TJCaptureRequest.JavaClass.CONTROL_AE_MODE, TJCameraMetadata.JavaClass.CONTROL_AE_MODE_ON_ALWAYS_FLASH);
   TFlashMode.AutoFlash : FRequestHelper.setIntegerValue(TJCaptureRequest.JavaClass.CONTROL_AE_MODE, TJCameraMetadata.JavaClass.CONTROL_AE_MODE_ON_AUTO_FLASH);
  end;
end;

procedure TCameraCaptureSession.AddLocation(const AStream: TMemoryStream);
const
  cRefLatitude: array[Boolean] of string = ('N', 'S');
  cRefLongitude: array[Boolean] of string = ('W', 'E');
var
  LFileName: string;
  LEXIF: JExifInterface;
  LLocation: TLocationCoord2D;
begin
  LLocation := PlatformCamera.Camera.Location;
  LFileName := TPath.GetTempFileName;
  AStream.SaveToFile(LFileName);
  LEXIF := TJExifInterface.JavaClass.init(StringToJString(LFileName));
  LEXIF.setAttribute(TJExifInterface.JavaClass.TAG_GPS_LATITUDE, StringToJString(ValueToDegrees(LLocation.Latitude)));
  LEXIF.setAttribute(TJExifInterface.JavaClass.TAG_GPS_LATITUDE_REF, StringToJString(cRefLatitude[LLocation.Latitude < 0]));
  LEXIF.setAttribute(TJExifInterface.JavaClass.TAG_GPS_LONGITUDE, StringToJString(ValueToDegrees(LLocation.Longitude)));
  LEXIF.setAttribute(TJExifInterface.JavaClass.TAG_GPS_LONGITUDE_REF, StringToJString(cRefLongitude[LLocation.Longitude < 0]));
  LEXIF.saveAttributes;
  AStream.LoadFromFile(LFileName);
  TFile.Delete(LFileName);
end;

procedure TCameraCaptureSession.ImageAvailable(reader: JImageReader);
begin
// From: http://stackoverflow.com/questions/41775968/how-to-convert-android-media-image-to-bitmap-object
if FCaptureRequest <> TCaptureMode.None then
   TThread.CreateAnonymousThread(
      Procedure
      var
         LImage      : JImage;
         LStream     : TStream;
         LRotation   : Integer;
         LYSize      : Integer;
         LYBuffer    : JByteBuffer;
         LBuffer     : TJavaArray<Byte>;

      Begin
      try
         LImage := reader.acquireNextImage;
         try

            LStream         := TMemoryStream.Create;
            LYBuffer        := LImage.getPlanes.Items[0].getBuffer;
            LYSize          := LYBuffer.remaining;
            FCapturedWidth  := LImage.getPlanes.Items[0].getRowStride;
            FCapturedHeight := Limage.getHeight;
            LBuffer         := TJavaArray<Byte>.Create(LYSize);
            LYBuffer.get(LBuffer, 0, LYSize);
            LStream.WriteBuffer(LBuffer.Data^, LBuffer.Length);

//            LRotation := 90;
//            if ((PlatformCamera.CameraOrientation mod 180) <> 0) and (PlatformCamera.ViewSize.getWidth <> LImage.getHeight) then
//               LRotation := FRequestedOrientation;
//            LStream := TJImageHelper.JImageToStream(LImage, LRotation); // Aqui transforma o YUV_422_888 em JPEG
//            FCapturedWidth  := LImage.getWidth;
//            FCapturedHeight := Limage.getHeight;

            try
               if PlatformCamera.Camera.IncludeLocation then AddLocation(TMemoryStream(LStream));
               PlatformCamera.CapturedStillImage(LStream, FCaptureRequest);
            finally
               LStream.Free;
               end;
         finally
            LImage.close;
            end;
      finally
         FCaptureRequest := TCaptureMode.None;
         end;
      End).Start;
end;

procedure TCameraCaptureSession.CheckFaces(const AHelper: JDWCaptureResultHelper);
var
   LFaces: TJavaObjectArray<JFace>;
begin
LFaces := AHelper.getFaces;
if (LFaces <> nil) and (LFaces.Length > 0) then
   PlatformCamera.DetectedFaces(LFaces);
end;

procedure TCameraCaptureSession.CaptureCompleted(session: JCameraCaptureSession; request: JCaptureRequest; result: JTotalCaptureResult);
var
   LHelper: JDWCaptureResultHelper;
begin
LHelper := TJDWCaptureResultHelper.JavaClass.init;
LHelper.setCaptureResult(result);
case FCaptureRequest of
   TCaptureMode.Faces: CheckFaces(LHelper);
   end;
end;

procedure TCameraCaptureSession.CaptureProgressed(session: JCameraCaptureSession; request: JCaptureRequest; partialResult: JCaptureResult);
begin
  //
end;

procedure TCameraCaptureSession.CaptureSessionConfigured(session: JCameraCaptureSession);
var
  LBuilder: JCaptureRequest_Builder;
begin
  FSession := session;
  LBuilder := FPlatformCamera.CameraDevice.createCaptureRequest(TJCameraDevice.JavaClass.TEMPLATE_PREVIEW);
  LBuilder.addTarget(FPreviewSurface);
  FRequestHelper.setCaptureRequestBuilder(LBuilder);
  FRequestHelper.setFaceDetectMode(Ord(FPlatformCamera.GetHighestFaceDetectMode));
  UpdateFlashMode;
  session.setRepeatingRequest(LBuilder.build, FCaptureSessionCaptureCallback, FHandler);
  FIsCapturing := True;
end;

procedure TCameraCaptureSession.CaptureSessionConfigureFailed(session: JCameraCaptureSession);
begin
  //
end;

{ TPlatformCamera }

constructor TPlatformCamera.Create(const ACamera: TCamera);
begin
  inherited;
  FCameraManager := TJCameraManager.Wrap(TAndroidHelper.Activity.getSystemService(TJContext.JavaClass.CAMERA_SERVICE));
  FDeviceStateCallbackDelegate := TDWCameraDeviceStateCallbackDelegate.Create(Self);
  FDeviceStateCallback := TJDWCameraDeviceStateCallback.JavaClass.init(FDeviceStateCallbackDelegate);
  FCaptureSession := TCameraCaptureSession.Create(Self);
  FHandler := TJHandler.JavaClass.init(TJLooper.JavaClass.getMainLooper);
end;

destructor TPlatformCamera.Destroy;
begin
  FDeviceStateCallbackDelegate := nil;
  FDeviceStateCallback := nil;
  FCaptureSession.Free;
  FHandler := nil;
  inherited;
end;

procedure TPlatformCamera.DetectedFaces(const AFaces: TJavaObjectArray<JFace>);
var
  I: Integer;
  LFace: JFace;
  LPoint: JPoint;
  LRect: JRect;
begin
  if not FFacesDetected and (MilliSecondsBetween(Now, FDetectionDateTime) > 1000) then
  begin
    FFacesDetected := True;
    FDetectionDateTime := Now;
    SetLength(FFaces, AFaces.Length);
    for I := 0 to AFaces.Length - 1 do
    begin
      LFace  := AFaces.Items[I];
      LRect  := LFace.getBounds;           if LRect  <> nil then FFaces[I].Bounds           := TRectF .Create(LRect.left, LRect.top, LRect.right, LRect.bottom);
      LPoint := LFace.getLeftEyePosition;  if LPoint <> nil then FFaces[I].LeftEyePosition  := TPointF.Create(LPoint.x, LPoint.y);
      LPoint := LFace.getRightEyePosition; if LPoint <> nil then FFaces[I].RightEyePosition := TPointF.Create(LPoint.x, LPoint.y);
      LPoint := LFace.getMouthPosition;    if LPoint <> nil then FFaces[I].MouthPosition    := TPointF.Create(LPoint.x, LPoint.y);
    end;
    FCaptureSession.CaptureImage(TCaptureMode.Faces);
  end;
end;

procedure TPlatformCamera.DoCaptureImage;
begin
  FCaptureSession.CaptureImage(TCaptureMode.Still);
end;

procedure TPlatformCamera.StillCaptureFailed;
begin
  FFacesDetected := False;
end;

function TPlatformCamera.GetCameraOrientation: Integer;
begin
Result := FCaptureSession.FRequestedOrientation;
end;

function TPlatformCamera.GetCapturedHeight: Integer;
begin
Result := FCaptureSession.CapturedHeight;
end;

function TPlatformCamera.GetCapturedWidth: Integer;
begin
Result := FCaptureSession.CapturedWidth;
end;

function TPlatformCamera.GetHighestFaceDetectMode: TFaceDetectMode;
var
  LMode: TFaceDetectMode;
begin
  Result := TFaceDetectMode.None;
  for LMode := High(TFaceDetectMode) downto Low(TFaceDetectMode) do
  begin
    // Set the highest available mode, or none if none selected
    if (LMode in FAvailableFaceDetectModes) and (FaceDetectMode >= LMode) then
    begin
      Result := LMode;
      Break;
    end;
  end;
end;

function TPlatformCamera.GetIsSwapping: Boolean;
begin
  Result := FIsSwapping;
end;

function TPlatformCamera.GetPreviewControl: TControl;
begin
  Result := FCaptureSession.PreviewControl;
end;

function TPlatformCamera.GetResolutionHeight: Integer;
begin
  if FViewSize <> nil then
    Result := FViewSize.getHeight
  else
    Result := 0;
end;

function TPlatformCamera.GetResolutionWidth: Integer;
begin
  if FViewSize <> nil then
    Result := FViewSize.getWidth
  else
    Result := 0;
end;

procedure TPlatformCamera.DoOpenCamera;
var
   LCameraIDList    : TJavaObjectArray<JString>;
   LItem            : JString;
   LCameraID        : JString;
   LLensFacing      : Integer;
   LCharacteristics : JCameraCharacteristics;
   LHelper          : JDWCameraCharacteristicsHelper;
   LMap             : JStreamConfigurationMap;
   LFaceDetectModes : TJavaArray<Integer>;
   I                : Integer;
begin
FCameraOrientation := 0;
LFaceDetectModes   := nil;
FViewSize          := nil;
FCaptureSize       := TSize.Create(0,0);
LCameraIDList      := FCameraManager.getCameraIdList;
LCameraID          := nil;
LMap               := nil;
LHelper            := TJDWCameraCharacteristicsHelper.JavaClass.init;
for I := 0 to LCameraIDList.Length - 1 do
   begin
   LItem            := LCameraIDList.Items[I];
   LCharacteristics := FCameraManager.getCameraCharacteristics(LItem);
   LHelper.setCameraCharacteristics(LCharacteristics);
   LFaceDetectModes := LHelper.getFaceDetectModes;
   LLensFacing      := LHelper.getLensFacing;
   case CameraPosition of
      TDevicePosition.Back  : if LLensFacing = TJCameraMetadata.JavaClass.LENS_FACING_BACK  then LCameraID := LItem;
      TDevicePosition.Front : if LLensFacing = TJCameraMetadata.JavaClass.LENS_FACING_FRONT then LCameraID := LItem;
      end;
   if LCameraID <> nil then
      begin
      FCameraOrientation := LHelper.getSensorOrientation;
      LMap := LHelper.getMap;
      Break;
      end;
   end;

if (LCameraID = nil) or (LMap = nil) then Exit; // <======

FCaptureSession.FFirst    := True;
FAvailableFaceDetectModes := [];
if LFaceDetectModes <> nil then
   for I := 0 to LFaceDetectModes.Length - 1 do Include(FAvailableFaceDetectModes, TFaceDetectMode(LFaceDetectModes.Items[I]));
// May need to rethink this - largest preview size may not be appropriate, except for stills

FAvailableViewSizes := LMap.getOutputSizes(TJImageFormat.JavaClass.YUV_420_888);
//FAvailableViewSizes := LMap.getOutputSizes(TJImageFormat.JavaClass.JPEG);
if FAvailableViewSizes = nil then
   FAvailableViewSizes := LMap.getOutputSizes(TJImageFormat.JavaClass.RAW_SENSOR);
if FAvailableViewSizes <> nil then
   begin
   UpdateViewSize;
   FCameraManager.openCamera(LCameraID, FDeviceStateCallback, FHandler);
   end;
end;

procedure TPlatformCamera.UpdateViewSize;
var
   I     : Integer;
   LSize : Jutil_Size;
begin
FViewSize    := nil;
FCAptureSize := tSize.Create(0,0);
for I := 0 to FAvailableViewSizes.Length - 1 do
   begin
   LSize := FAvailableViewSizes.Items[I];
   if (FViewSize          = nil) And (LSize.getWidth <= MaxPreviewWidth) then FViewSize := LSize;
   if (FCaptureSize.Width = 0)   And (LSize.getWidth <= MaxImageWidth)   then FCaptureSize := TSize.Create(LSize.getWidth, LSize.getHeight);
   end;
if (FViewSize <> nil) and ((FCameraOrientation mod 180) <> 0) then
   FViewSize := TJutil_Size.JavaClass.init(FViewSize.getWidth, FViewSize.getHeight);
end;

procedure TPlatformCamera.OpenCamera;
begin
DoOpenCamera;
end;

procedure TPlatformCamera.RequestPermission;
const
  cStatus: array[Boolean] of TAuthorizationStatus = (TAuthorizationStatus.Denied, TAuthorizationStatus.Authorized);
begin
PermissionsService.RequestPermissions([cPermissionCamera],
   procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
   begin
   QueueAuthorizationStatus(cStatus[AGrantResults[0] = TPermissionStatus.Granted]);
   end);
end;

procedure TPlatformCamera.CloseCamera;
begin
StopCapture;
if FCameraDevice <> nil then FCameraDevice.close;
FCameraDevice := nil;
FAvailableFaceDetectModes := [];
SetFaceDetectMode(TFaceDetectMode.None);
InternalSetActive(False);
end;

procedure TPlatformCamera.SetMaxImageWidth(const Value: Integer);
begin
inherited;
FCaptureSession.MaxImageWidth := Value;
end;

function TPlatformCamera.SizeFitsInPreview(const ASize: Jutil_Size): Boolean;
begin
  Result := True;
end;

procedure TPlatformCamera.StartCapture;
begin
  if FCaptureSession <> nil then
  begin
    FCaptureSession.StartSession;
    FIsCapturing := FCaptureSession.IsCapturing;
  end;
end;

procedure TPlatformCamera.StopCapture;
begin
  FCaptureSession.StopSession;
  FIsCapturing := False;
end;

procedure TPlatformCamera.CameraDisconnected(camera: JCameraDevice);
begin
  FCameraDevice := nil;
  FIsCapturing  := False;
  InternalSetActive(False);
end;

procedure TPlatformCamera.CameraError(camera: JCameraDevice; error: Integer);
begin
end;

procedure TPlatformCamera.CameraOpened(camera: JCameraDevice);
begin
  FCameraDevice := camera;
  InternalSetActive(True);
  StartCapture;
end;

procedure TPlatformCamera.CapturedStillImage(const AImageStream: TStream; const ACaptureRequest: TCaptureMode); 
Begin
TThread.Synchronize(nil,
   procedure
   begin
   case ACaptureRequest of
       TCaptureMode.Still: DoCapturedImage(AImageStream);
       TCaptureMode.Faces: DoDetectedFaces(AImageStream, FFaces);
       end;
   end);
FFacesDetected := False;
end;

end.
