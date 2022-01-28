unit FMX.Register;

interface

Uses
  System.classes,
  System.Types,
  DesignIntF,
  FMX.Android.Permissions,
  FMX.CodeReader;

Procedure Register;

implementation

Procedure Register;
Begin
RegisterComponents('Imperium Delphi', [TAndroidPermissions, TCodeReader]);
End;

end.
