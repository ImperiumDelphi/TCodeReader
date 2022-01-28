unit CodeReader.DW.UIHelper;

{*******************************************************}
{                                                       }
{                      Kastri                           }
{                                                       }
{         Delphi Worlds Cross-Platform Library          }
{                                                       }
{    Copyright 2020 Dave Nottage under MIT LICENSE      }
{  which is located in the root folder of this library  }
{                                                       }
{*******************************************************}

{$I DW.GlobalDefines.inc}
interface

uses
  // RTL
  System.Types, System.UITypes, System.Messaging,
  System.classes,
  // FMX
  FMX.Types, FMX.Forms;

type
  TUserInterfaceStyle = (Light, Dark);
  TUserInterfaceStyleChangedMessage = TMessage<TUserInterfaceStyle>;

  /// <summary>
  ///   Helper functions specific to UI
  /// </summary>
  TUIHelper = record
  public
    class procedure CopyImageToClipboard(const AImage: TStream); static;
    class function GetStatusBarOffset: Single; static;
    /// <summary>
    ///   Special function for handling of "notch" based devices
    /// </summary>
    class function GetOffsetRect: TRectF; overload; static;
    class function GetOffsetRect(const AHandle: TWindowHandle): TRectF; overload; static;
    /// <summary>
    ///   Returns Black or White, depending on the background color supplied
    /// </summary>
    class function GetTextColor(const ABackgroundColor: TAlphaColor): TAlphaColor; static;
    class function GetScreenOrientation: TScreenOrientation; static;
    class function GetUserInterfaceStyle: TUserInterfaceStyle; static;
    class procedure OpenSettings; static;
    /// <summary>
    ///   Force a repaint of the form
    /// </summary>
    class procedure Render(const AForm: TForm); static;
  end;

implementation

{$IF Defined(ANDROID)}
uses
  CodeReader.DW.UIHelper.Android;
{$ELSEIF Defined(IOS)}
uses
  CodeReader.DW.UIHelper.iOS;
{$ENDIF}

{ TUIHelper }

class function TUIHelper.GetOffsetRect: TRectF;
begin
  {$IF Defined(IOS) or Defined(Android)}
  Result := TPlatformUIHelper.GetOffsetRect;
  {$ELSE}
  Result := RectF(0, 0, 0, 0);
  {$ENDIF}
end;

class procedure TUIHelper.CopyImageToClipboard(const AImage: TStream);
begin
  {$IF Defined(IOS)}
  TPlatformUIHelper.CopyImageToClipboard(AImage);
  {$ELSE}
  //
  {$ENDIF}
end;

class function TUIHelper.GetOffsetRect(const AHandle: TWindowHandle): TRectF;
begin
  {$IF Defined(IOS) or Defined(Android)}
  Result := TPlatformUIHelper.GetOffsetRect(AHandle);
  {$ELSE}
  Result := RectF(0, 0, 0, 0);
  {$ENDIF}
end;

class procedure TUIHelper.Render(const AForm: TForm);
begin
  // Should not be required in other OS's
  {$IF Defined(Android)}
  TPlatformUIHelper.Render(AForm);
  {$ENDIF}
end;

class function TUIHelper.GetTextColor(const ABackgroundColor: TAlphaColor): TAlphaColor;
var
  LRec: TAlphaColorRec;
begin
  LRec := TAlphaColorRec(ABackgroundColor);
  if ((LRec.R * 0.299) + (LRec.G * 0.587) + (LRec.B * 0.114)) > 127 then
    Result := TAlphaColorRec.Black
  else
    Result := TAlphaColorRec.White;
end;

class function TUIHelper.GetUserInterfaceStyle: TUserInterfaceStyle;
begin
  {$IF Defined(IOS) or Defined(Android)}
  Result := TPlatformUIHelper.GetUserInterfaceStyle;
  {$ELSE}
  Result := TUserInterfaceStyle.Light;
  {$ENDIF}
end;

class procedure TUIHelper.OpenSettings;
begin
  {$IF Defined(IOS)} // or Defined(Android)}
  TPlatformUIHelper.OpenSettings;
  {$ELSE}
  //
  {$ENDIF}
end;

class function TUIHelper.GetScreenOrientation: TScreenOrientation;
begin
  {$IF Defined(IOS) or Defined(Android)}
  Result := TPlatformUIHelper.GetScreenOrientation;
  {$ELSE}
  Result := TScreenOrientation.Portrait;
  {$ENDIF}
end;

class function TUIHelper.GetStatusBarOffset: Single;
begin
  {$IF Defined(IOS) or Defined(Android)}
  Result := TPlatformUIHelper.GetStatusBarOffset;
  {$ELSE}
  Result := 0;
  {$ENDIF}
end;

end.
