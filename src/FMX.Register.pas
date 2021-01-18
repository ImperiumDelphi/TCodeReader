unit FMX.Register;

interface

Uses
  System.Classes,
  System.Types,
  DesignIntF,
  FMX.Android.Permissions,
  FMX.CodeReader;


implementation

{$R FMX.Resources.res }

Procedure Register;
Begin
RegisterComponents('Imperium Delphi', [TAndroidPermissions, TCodeReader]);
End;

end.
