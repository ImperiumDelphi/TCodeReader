unit FMX.Register;

interface

Uses
  System.classes,
  System.Types,
  DesignIntF,
  FMX.CodeReader;

Procedure Register;

implementation

Procedure Register;
Begin
RegisterComponents('Imperium Delphi', [TCodeReader]);
End;

end.
